Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A6C11719
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDxIVo/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D31C433C7;
	Sun, 31 Dec 2023 21:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059872;
	bh=JTrp0euvZhFwTlDQTknBtC435Kc/a8OpWqmBPFVOONI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KDxIVo/E+KTDgjgIb8hBrnaB/iKPoxQXMD47zrxLLga7CGJJqtIzMgkpCyJgd9NwI
	 pLl2UWxBr9xz2Tif663r/ZLtR4yBsVB1NXqxpLdEvpDj3kk7zhVFWZIwcsr93o8R6p
	 lKZ5DR5J4sn24teer/gmmGhF5NrEdEXm+1Ds1ILkJz+GOaYmnete9nAfhAO1Q7957c
	 6xcJGybLQoKizU75isttunlivjsAohZyQjkfXWPKCVV43Xtyu3tdnBLVr/cQmn1FKr
	 Xa8+vs+8PwpBCQzKWmNb9Ypm/BC+us8g6ucjbH21N3VeIX4lKFywcPg/oNEQGKDqGY
	 6HWcv7oJBGZwQ==
Date: Sun, 31 Dec 2023 13:57:52 -0800
Subject: [PATCH 7/9] xfs: allow reflink on the rt volume when extent size is
 larger than 1 rt block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852783.1767395.4576654556100736347.stgit@frogsfrogsfrogs>
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

Make the necessary tweaks to the reflink remapping code to support
remapping on the realtime volume when the rt extent size is larger than
a single rt block.  We need to check that the remap arguments from
userspace are aligned to a rt extent boundary, and that the length
is always aligned, even if the kernel tried to round it up to EOF for
us.  XFS can only map and remap full rt extents, so we have to be a
little more strict about the alignment there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_rtalloc.c |    2 +
 fs/xfs/xfs_super.c   |   19 +++++++++---
 fs/xfs/xfs_trace.h   |    3 ++
 4 files changed, 93 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5d68603506f27..d516f3a35df36 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1534,6 +1534,13 @@ xfs_reflink_remap_blocks(
 	len = min_t(xfs_filblks_t, XFS_B_TO_FSB(mp, remap_len),
 			XFS_MAX_FILEOFF);
 
+	/*
+	 * Make sure the end is aligned with an allocation unit, even if it's
+	 * past EOF.
+	 */
+	if (xfs_inode_has_bigallocunit(dest))
+		len = xfs_rtb_roundup_rtx(mp, len);
+
 	trace_xfs_reflink_remap_blocks(src, srcoff, len, dest, destoff);
 
 	while (len > 0) {
@@ -1607,6 +1614,57 @@ xfs_reflink_zero_posteof(
 	return xfs_zero_range(ip, isize, pos - isize, NULL);
 }
 
+#ifdef CONFIG_XFS_RT
+/*
+ * Adjust the length of the remap operation to end on an allocation unit (AU)
+ * boundary.
+ */
+STATIC int
+xfs_reflink_adjust_bigalloc_len(
+	struct xfs_inode	*src,
+	loff_t			pos_in,
+	struct xfs_inode	*dest,
+	loff_t			pos_out,
+	loff_t			*len,
+	unsigned int		remap_flags)
+{
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(src);
+	uint32_t		mod;
+
+	div_u64_rem(*len, alloc_unit, &mod);
+
+	/*
+	 * We previously checked the AU alignment of both offsets, so we now
+	 * have to check the AU alignment of the length.  The VFS remap prep
+	 * function can change the length on us, so we can only make length
+	 * adjustments after that.  If the length is aligned to an AU, we're
+	 * good to go.
+	 *
+	 * Otherwise, the length is not aligned to an AU.  If the source file's
+	 * range ends at EOF, the VFS ensured that the dest file's range also
+	 * ends at EOF.  The actual remap function will round the (byte) length
+	 * up to the nearest AU, so we're ok here too.
+	 */
+	if (mod == 0 || pos_in + *len == i_size_read(VFS_I(src)))
+		return 0;
+
+	/*
+	 * Otherwise, the only thing we can do is round the request length down
+	 * to an AU boundary.  If the caller doesn't allow that, we cannot move
+	 * forward.
+	 */
+	if (!(remap_flags & REMAP_FILE_CAN_SHORTEN))
+		return -EINVAL;
+
+	/* Back off by a single extent. */
+	(*len) -= mod;
+	trace_xfs_reflink_adjust_bigalloc_len(src, pos_in, *len, dest, pos_out);
+	return 0;
+}
+#else
+# define xfs_reflink_adjust_bigalloc_len(...)		(0)
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file will
@@ -1649,6 +1707,7 @@ xfs_reflink_remap_prep(
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
+	const struct iomap_ops	*dax_read_ops = NULL;
 	int			ret;
 
 	/* Lock both files against IO */
@@ -1666,15 +1725,25 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
-	if (!IS_DAX(inode_in))
-		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
-				pos_out, len, remap_flags);
-	else
-		ret = dax_remap_file_range_prep(file_in, pos_in, file_out,
-				pos_out, len, remap_flags, &xfs_read_iomap_ops);
+	ASSERT(is_power_of_2(xfs_inode_alloc_unitsize(dest)));
+
+	if (IS_DAX(inode_in))
+		dax_read_ops = &xfs_read_iomap_ops;
+
+	ret = __generic_remap_file_range_prep(file_in, pos_in, file_out,
+			pos_out, len, remap_flags, dax_read_ops,
+			xfs_inode_alloc_unitsize(dest));
 	if (ret || *len == 0)
 		goto out_unlock;
 
+	/* Adjust the end to align to an allocation unit. */
+	if (xfs_inode_has_bigallocunit(src)) {
+		ret = xfs_reflink_adjust_bigalloc_len(src, pos_in, dest,
+				pos_out, len, remap_flags);
+		if (ret || *len == 0)
+			goto out_unlock;
+	}
+
 	/* Attach dquots to dest inode before changing block map */
 	ret = xfs_qm_dqattach(dest);
 	if (ret)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 11b6645a5a534..c617c326125b3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1253,7 +1253,7 @@ xfs_growfs_rt(
 		return -EOPNOTSUPP;
 	if (xfs_has_quota(mp))
 		return -EOPNOTSUPP;
-	if (xfs_has_reflink(mp) && in->extsize != 1)
+	if (xfs_has_reflink(mp) && !is_power_of_2(mp->m_sb.sb_rextsize))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bf0c0ce9a54b9..c17e1d06820d1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1729,13 +1729,22 @@ xfs_fs_fill_super(
 
 	if (xfs_has_reflink(mp)) {
 		/*
-		 * Reflink doesn't support rt extent sizes larger than a single
-		 * block because we would have to perform unshare-around for
-		 * rtext-unaligned write requests.
+		 * Reflink doesn't support pagecache pages that span multiple
+		 * realtime extents because iomap doesn't track subpage dirty
+		 * state.  This means that we cannot dirty all the pages
+		 * backing an rt extent without dirtying the adjoining rt
+		 * extents.  If those rt extents are shared and extend into
+		 * other pages, this leads to crazy write amplification.  The
+		 * VFS remap_range checks assume power-of-two block sizes.
+		 *
+		 * Hence we only support rt extent sizes that are an integer
+		 * power of two because we know those will align with the page
+		 * size.
 		 */
-		if (xfs_has_realtime(mp) && mp->m_sb.sb_rextsize != 1) {
+		if (xfs_has_realtime(mp) &&
+		    !is_power_of_2(mp->m_sb.sb_rextsize)) {
 			xfs_alert(mp,
-	"reflink not compatible with realtime extent size %u!",
+	"reflink not compatible with non-power-of-2 realtime extent size %u!",
 					mp->m_sb.sb_rextsize);
 			error = -EINVAL;
 			goto out_filestream_unmount;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4767fc49c4641..906e35eef223d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3887,6 +3887,9 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
 		  __entry->dest_lblk)
 );
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
+#ifdef CONFIG_XFS_RT
+DEFINE_DOUBLE_IO_EVENT(xfs_reflink_adjust_bigalloc_len);
+#endif /* CONFIG_XFS_RT */
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);

