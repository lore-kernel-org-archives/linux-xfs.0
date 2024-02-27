Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B4F9F0
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000640; cv=none; b=M+sS39xNgVpKU5Ov2Whrwn7jryafgUM7c28shXtZidZ3N0LDfF66qPA7PCvxga9K4cF4StDRWyl4Ox5QX2u5XBibQKbQ3wsNMsAFescUTkdM4gBu5pLj48iU2uoLMFV5MYMT9dveI+M8PRdI5s4VH7B4kLx+te9YUtZTk8kWtpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000640; c=relaxed/simple;
	bh=EvwNIoq95+2A67wlBJg0v3amwnZf/baOmXXOCPpm0E8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkzZAAy910E6FXytbigzDdVKvH2bc4N6hkCgQrg3WnOk5f2VBZrLC7ibplBQrpIsXpsinBdg0sXOyDMvtYuAXKOUfKkO012bw+pK+aB55WWl76QW2WQHJ6D/vb0boqvmTHL5qXP6GS4RiV/E4jjwA573yzUFSrWWVzCO4hfDkpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOzQMwU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOzQMwU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236BDC43390;
	Tue, 27 Feb 2024 02:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000640;
	bh=EvwNIoq95+2A67wlBJg0v3amwnZf/baOmXXOCPpm0E8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BOzQMwU/FKyTUH/4ojvNnNvhResztGo1fLmV1/P+v/V5YgKcJu5heydW54Yg8/X52
	 VmOa3TYakl5U1AxByaxNYr6MixXStcN/NQS4obK298D+MaH4781nfKrsSLgEbRV2df
	 TxnKTy1g/znYRlpekbaDSCfyjWhl2byNcpQdvlVn5HOQLtOBeXwYChNLsGKtkxonqA
	 mzT1hLaill1JCCwNhMwh4bbdvRRmZp8XOpFv0XaABUFRoEDOMzlxZmOBzXo5YJ6UnT
	 gKrb3KZO9KASFb46aiXI3Yf4KBfuIAGLBGCNUY6W8FYaDJ3/8yKUbpXnsi0qdIVqQy
	 jOCCD62sO5/LA==
Date: Mon, 26 Feb 2024 18:23:59 -0800
Subject: [PATCH 12/14] xfs: support non-power-of-two rtextsize with
 exchange-range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011839.938268.6567862146289505624.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
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

The generic exchange-range alignment checks use (fast) bitmasking
operations to perform block alignment checks on the exchange parameters.
Unfortunately, bitmasks require that the alignment size be a power of
two.  This isn't true for realtime devices with a non-power-of-two
extent size, so we have to copy-pasta the generic checks using long
division for this to work properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_exchrange.c |   89 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index a2b1c9d933385..ae74ff016ee1f 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -590,6 +590,75 @@ xfs_generic_exchrange_finish(
 	return file_remove_privs(fxr->file2);
 }
 
+/*
+ * Check the alignment of an exchange request when the allocation unit size
+ * isn't a power of two.  The generic file-level helpers use (fast)
+ * bitmask-based alignment checks, but here we have to use slow long division.
+ */
+static int
+xfs_exchrange_check_rtalign(
+	const struct xfs_exchrange	*fxr,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*ip2,
+	unsigned int			alloc_unit)
+{
+	uint64_t			length = fxr->length;
+	uint64_t			blen;
+	loff_t				size1, size2;
+
+	size1 = i_size_read(VFS_I(ip1));
+	size2 = i_size_read(VFS_I(ip2));
+
+	/* The start of both ranges must be aligned to a rt extent. */
+	if (!isaligned_64(fxr->file1_offset, alloc_unit) ||
+	    !isaligned_64(fxr->file2_offset, alloc_unit))
+		return -EINVAL;
+
+	if (fxr->flags & XFS_EXCHRANGE_TO_EOF)
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
+		blen = roundup_64(size1, alloc_unit) - fxr->file1_offset;
+	else if (fxr->file2_offset + length == size2)
+		blen = roundup_64(size2, alloc_unit) - fxr->file2_offset;
+	else if (!isaligned_64(length, alloc_unit))
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
+	if (isaligned_64(length, alloc_unit))
+		return 0;
+
+	blen = length;
+	if (fxr->file2_offset + length < size2)
+		blen = rounddown_64(blen, alloc_unit);
+
+	if (fxr->file1_offset + blen < size1)
+		blen = rounddown_64(blen, alloc_unit);
+
+	return blen == length ? 0 : -EINVAL;
+}
+
 /* Prepare two files to have their data exchanged. */
 STATIC int
 xfs_exchrange_prep(
@@ -597,6 +666,7 @@ xfs_exchrange_prep(
 	struct xfs_inode	*ip1,
 	struct xfs_inode	*ip2)
 {
+	struct xfs_mount	*mp = ip2->i_mount;
 	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(ip2);
 	int			error;
 
@@ -606,13 +676,18 @@ xfs_exchrange_prep(
 	if (XFS_IS_REALTIME_INODE(ip1) != XFS_IS_REALTIME_INODE(ip2))
 		return -EINVAL;
 
-	/*
-	 * The alignment checks in the generic helpers cannot deal with
-	 * allocation units that are not powers of 2.  This can happen with the
-	 * realtime volume if the extent size is set.
-	 */
-	if (!is_power_of_2(alloc_unit))
-		return -EOPNOTSUPP;
+	/* Check non-power of two alignment issues, if necessary. */
+	if (!is_power_of_2(alloc_unit)) {
+		error = xfs_exchrange_check_rtalign(fxr, ip1, ip2, alloc_unit);
+		if (error)
+			return error;
+
+		/*
+		 * Do the generic file-level checks with the regular block
+		 * alignment.
+		 */
+		alloc_unit = mp->m_sb.sb_blocksize;
+	}
 
 	error = xfs_generic_exchrange_prep(fxr, alloc_unit);
 	if (error || fxr->length == 0)

