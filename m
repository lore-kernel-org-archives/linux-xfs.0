Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19359BA43
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OM/+kaHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E006EC433C7;
	Sun, 31 Dec 2023 21:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059903;
	bh=I/yVVacjB0X38rOipjRkfFkp0EjKgmJTpfQfV4GkDgg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OM/+kaHsUaNjkODcQsOwwIoBB3XBBCIehtCYKLIP/Aux/0JiaXcsltHx5xyK4Xvom
	 3Kx3bsEi1+wdgzvKiTeoyVEzIuas9TQ2Be9Ql2Y4a4KxLIigWU0M09bYumdkXhQsqE
	 7XsMKzosGplhahQaUueL5HkMbmr1tZWE3cKkH4OEin1cxfYGdHMhqNJUYt5pUnGWqX
	 XD8fZHICZiZmbfRYblZEkMxOjEnzZLcCYGHN6GA78ikMAdxy2G380hr3TC5sw+uMs7
	 1Beim+XwMvBkc++jEFlFQeXTW39Pz1VNmPNyzDtqibylvI88nPiYMAFOTyiUUsC0uV
	 Qte6DHy/czu/Q==
Date: Sun, 31 Dec 2023 13:58:23 -0800
Subject: [PATCH 9/9] xfs: support realtime reflink with an extent size that
 isn't a power of 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852815.1767395.842469542235107122.stgit@frogsfrogsfrogs>
In-Reply-To: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
References: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
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

Add the necessary alignment checking code to the reflink remap code to
ensure that remap requests are aligned to rt extent boundaries if the
realtime extent size isn't a power of two.  The VFS helpers assume that
they can use the usual (blocksize - 1) masking to avoid slow 64-bit
division, but since XFS is special we won't make everyone pay that cost
for our weird edge case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_rtalloc.c |    3 +-
 fs/xfs/xfs_super.c   |   12 +++----
 3 files changed, 97 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d516f3a35df36..0c54522404963 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1665,6 +1665,83 @@ xfs_reflink_adjust_bigalloc_len(
 # define xfs_reflink_adjust_bigalloc_len(...)		(0)
 #endif /* CONFIG_XFS_RT */
 
+/*
+ * Check the alignment of a remap request when the allocation unit size isn't a
+ * power of two.  The VFS helpers use (fast) bitmask-based alignment checks,
+ * but here we have to use slow long division.
+ */
+static int
+xfs_reflink_remap_check_rtalign(
+	struct xfs_inode		*ip_in,
+	loff_t				pos_in,
+	struct xfs_inode		*ip_out,
+	loff_t				pos_out,
+	loff_t				*req_len,
+	unsigned int			remap_flags)
+{
+	struct xfs_mount		*mp = ip_in->i_mount;
+	uint32_t			rextbytes;
+	loff_t				in_size, out_size;
+	loff_t				new_length, length = *req_len;
+	loff_t				blen;
+
+	rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+	in_size = i_size_read(VFS_I(ip_in));
+	out_size = i_size_read(VFS_I(ip_out));
+
+	/* The start of both ranges must be aligned to a rt extent. */
+	if (!isaligned_64(pos_in, rextbytes) ||
+	    !isaligned_64(pos_out, rextbytes))
+		return -EINVAL;
+
+	if (length == 0)
+		length = in_size - pos_in;
+
+	/*
+	 * If the user wanted us to exchange up to the infile's EOF, round up
+	 * to the next block boundary for this check.
+	 *
+	 * Otherwise, reject the range length if it's not extent aligned.  We
+	 * already confirmed the starting offsets' extent alignment.
+	 */
+	if (pos_in + length == in_size)
+		blen = roundup_64(in_size, rextbytes) - pos_in;
+	else
+		blen = rounddown_64(length, rextbytes);
+
+	/* Don't allow overlapped remappings within the same file. */
+	if (ip_in == ip_out &&
+	    pos_out + blen > pos_in &&
+	    pos_in + blen > pos_out)
+		return -EINVAL;
+
+	/*
+	 * Ensure that we don't exchange a partial EOF extent into the middle
+	 * of another file.
+	 */
+	if (isaligned_64(length, rextbytes))
+		return 0;
+
+	new_length = length;
+	if (pos_out + length < out_size)
+		new_length = rounddown_64(new_length, rextbytes);
+
+	if (new_length == length)
+		return 0;
+
+	/*
+	 * Return the shortened request if the caller permits it.  If the
+	 * request was shortened to zero rt extents, we know that the original
+	 * arguments weren't valid in the first place.
+	 */
+	if ((remap_flags & REMAP_FILE_CAN_SHORTEN) && new_length > 0) {
+		*req_len = new_length;
+		return 0;
+	}
+
+	return (remap_flags & REMAP_FILE_DEDUP) ? -EBADE : -EINVAL;
+}
+
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file will
@@ -1708,6 +1785,7 @@ xfs_reflink_remap_prep(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	const struct iomap_ops	*dax_read_ops = NULL;
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(dest);
 	int			ret;
 
 	/* Lock both files against IO */
@@ -1725,14 +1803,22 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
-	ASSERT(is_power_of_2(xfs_inode_alloc_unitsize(dest)));
+	/* Check non-power of two alignment issues, if necessary. */
+	if (XFS_IS_REALTIME_INODE(dest) && !is_power_of_2(alloc_unit)) {
+		ret = xfs_reflink_remap_check_rtalign(src, pos_in, dest,
+				pos_out, len, remap_flags);
+		if (ret)
+			goto out_unlock;
+
+		/* Do the VFS checks with the regular block alignment. */
+		alloc_unit = src->i_mount->m_sb.sb_blocksize;
+	}
 
 	if (IS_DAX(inode_in))
 		dax_read_ops = &xfs_read_iomap_ops;
 
 	ret = __generic_remap_file_range_prep(file_in, pos_in, file_out,
-			pos_out, len, remap_flags, dax_read_ops,
-			xfs_inode_alloc_unitsize(dest));
+			pos_out, len, remap_flags, dax_read_ops, alloc_unit);
 	if (ret || *len == 0)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index c617c326125b3..7917eaef911f6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1253,7 +1253,8 @@ xfs_growfs_rt(
 		return -EOPNOTSUPP;
 	if (xfs_has_quota(mp))
 		return -EOPNOTSUPP;
-	if (xfs_has_reflink(mp) && !is_power_of_2(mp->m_sb.sb_rextsize))
+	if (xfs_has_reflink(mp) && !is_power_of_2(mp->m_sb.sb_rextsize) &&
+	    (XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) & ~PAGE_MASK))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c17e1d06820d1..b5291b0ea21d9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1734,17 +1734,17 @@ xfs_fs_fill_super(
 		 * state.  This means that we cannot dirty all the pages
 		 * backing an rt extent without dirtying the adjoining rt
 		 * extents.  If those rt extents are shared and extend into
-		 * other pages, this leads to crazy write amplification.  The
-		 * VFS remap_range checks assume power-of-two block sizes.
+		 * other pages, this leads to crazy write amplification.
 		 *
 		 * Hence we only support rt extent sizes that are an integer
-		 * power of two because we know those will align with the page
-		 * size.
+		 * power of two or an integer multiple of the page size because
+		 * we know those will align with the page size.
 		 */
 		if (xfs_has_realtime(mp) &&
-		    !is_power_of_2(mp->m_sb.sb_rextsize)) {
+		    !is_power_of_2(mp->m_sb.sb_rextsize) &&
+		    (XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) & ~PAGE_MASK)) {
 			xfs_alert(mp,
-	"reflink not compatible with non-power-of-2 realtime extent size %u!",
+	"reflink not compatible with realtime extent size %u!",
 					mp->m_sb.sb_rextsize);
 			error = -EINVAL;
 			goto out_filestream_unmount;

