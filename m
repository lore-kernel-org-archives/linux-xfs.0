Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A78DF9C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3kyNVKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7E5C433C8;
	Sun, 31 Dec 2023 20:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054630;
	bh=XzNpNiUpTpamA8ocwG/kAfVkPkHVEnNTg1sghrNr3mc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P3kyNVKqPb3lKIQXdxj1BLvKLZ7crTZZqFjo2/MQjyMhyD6WywBRHzqOTzRMRgDyH
	 VvDlmi5MDpb111nr95dJKiQ63prcEFFWczNrnAsU/7fFu49cY+AA5+iEmtfR8TadXm
	 aYe0frL9aOCGTwnbJDeRjOLGjcmmYjsfksEFzFOe5ZNyqWxuv+8PRLRF4fG3QWt27h
	 1Ew14As0VebI4JgCJTjsrXRNjAoNpSVpjR3qQ3u+tiW+9QC/YNOg+nTJ7f405YGofK
	 MbExOK1bTWxZQfAhkIyT77jykPS1NyW9I5UUOhPA4XqdHbgHAou+LtDyxZtZDyLFOe
	 9EyiecK81xolA==
Date: Sun, 31 Dec 2023 12:30:30 -0800
Subject: [PATCH 24/25] xfs: support non-power-of-two rtextsize with
 exchange-range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833527.1750288.3711610032358809724.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The VFS exchange-range alignment checks use (fast) bitmasks to perform
block alignment checks on the exchange parameters.  Unfortunately,
bitmasks require that the alignment size be a power of two.  This isn't
true for realtime devices, so we have to copy-pasta the VFS checks using
long division for this to work properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_xchgrange.c |  102 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 91 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_xchgrange.c b/fs/xfs/xfs_xchgrange.c
index fd09a2dfca9b9..d805678e946c1 100644
--- a/fs/xfs/xfs_xchgrange.c
+++ b/fs/xfs/xfs_xchgrange.c
@@ -808,6 +808,86 @@ xfs_xchg_range_need_convert_bigalloc(
 	       xfs_inode_has_bigallocunit(ip);
 }
 
+/*
+ * Check the alignment of an exchange request when the allocation unit size
+ * isn't a power of two.  The VFS helpers use (fast) bitmask-based alignment
+ * checks, but here we have to use slow long division.
+ */
+static int
+xfs_xchg_range_check_rtalign(
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*ip2,
+	const struct xfs_exch_range	*fxr)
+{
+	struct xfs_mount		*mp = ip1->i_mount;
+	uint32_t			rextbytes;
+	uint64_t			length = fxr->length;
+	uint64_t			blen;
+	loff_t				size1, size2;
+
+	rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+	size1 = i_size_read(VFS_I(ip1));
+	size2 = i_size_read(VFS_I(ip2));
+
+	/* The start of both ranges must be aligned to a rt extent. */
+	if (!isaligned_64(fxr->file1_offset, rextbytes) ||
+	    !isaligned_64(fxr->file2_offset, rextbytes))
+		return -EINVAL;
+
+	/*
+	 * If the caller asked for full files, check that the offset/length
+	 * values cover all of both files.
+	 */
+	if ((fxr->flags & XFS_EXCH_RANGE_FULL_FILES) &&
+	    (fxr->file1_offset != 0 || fxr->file2_offset != 0 ||
+	     fxr->length != size1 || fxr->length != size2))
+		return -EDOM;
+
+	if (fxr->flags & XFS_EXCH_RANGE_TO_EOF)
+		length = max_t(int64_t, size1 - fxr->file1_offset,
+					size2 - fxr->file2_offset);
+
+	/*
+	 * If the user wanted us to exchange up to the infile's EOF, round up
+	 * to the next rt extent boundary for this check.  Do the same for the
+	 * outfile.
+	 *
+	 * Otherwise, reject the range length if it's not rt extent aligned.
+	 * We already confirmed the starting offsets' rt extent block
+	 * alignment.
+	 */
+	if (fxr->file1_offset + length == size1)
+		blen = roundup_64(size1, rextbytes) - fxr->file1_offset;
+	else if (fxr->file2_offset + length == size2)
+		blen = roundup_64(size2, rextbytes) - fxr->file2_offset;
+	else if (!isaligned_64(length, rextbytes))
+		return -EINVAL;
+	else
+		blen = length;
+
+	/* Don't allow overlapped exchanges within the same file. */
+	if (ip1 == ip2 &&
+	    fxr->file2_offset + blen > fxr->file1_offset &&
+	    fxr->file1_offset + blen > fxr->file2_offset)
+		return -EINVAL;
+
+	/*
+	 * Ensure that we don't exchange a partial EOF rt extent into the
+	 * middle of another file.
+	 */
+	if (isaligned_64(length, rextbytes))
+		return 0;
+
+	blen = length;
+	if (fxr->file2_offset + length < size2)
+		blen = rounddown_64(blen, rextbytes);
+
+	if (fxr->file1_offset + blen < size1)
+		blen = rounddown_64(blen, rextbytes);
+
+	return blen == length ? 0 : -EINVAL;
+}
+
 /* Prepare two files to have their data exchanged. */
 int
 xfs_xchg_range_prep(
@@ -818,6 +898,7 @@ xfs_xchg_range_prep(
 {
 	struct xfs_inode	*ip1 = XFS_I(file_inode(file1));
 	struct xfs_inode	*ip2 = XFS_I(file_inode(file2));
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(ip2);
 	int			error;
 
 	trace_xfs_xchg_range_prep(ip1, fxr, ip2, 0);
@@ -826,18 +907,17 @@ xfs_xchg_range_prep(
 	if (XFS_IS_REALTIME_INODE(ip1) != XFS_IS_REALTIME_INODE(ip2))
 		return -EINVAL;
 
-	/*
-	 * The alignment checks in the VFS helpers cannot deal with allocation
-	 * units that are not powers of 2.  This can happen with the realtime
-	 * volume if the extent size is set.  Note that alignment checks are
-	 * skipped if FULL_FILES is set.
-	 */
-	if (!(fxr->flags & XFS_EXCH_RANGE_FULL_FILES) &&
-	    !is_power_of_2(xfs_inode_alloc_unitsize(ip2)))
-		return -EOPNOTSUPP;
+	/* Check non-power of two alignment issues, if necessary. */
+	if (XFS_IS_REALTIME_INODE(ip2) && !is_power_of_2(alloc_unit)) {
+		error = xfs_xchg_range_check_rtalign(ip1, ip2, fxr);
+		if (error)
+			return error;
 
-	error = xfs_exch_range_prep(file1, file2, fxr,
-			xfs_inode_alloc_unitsize(ip2));
+		/* Do the VFS checks with the regular block alignment. */
+		alloc_unit = ip1->i_mount->m_sb.sb_blocksize;
+	}
+
+	error = xfs_exch_range_prep(file1, file2, fxr, alloc_unit);
 	if (error || fxr->length == 0)
 		return error;
 

