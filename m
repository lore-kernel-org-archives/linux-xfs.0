Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A93CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiLaCAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCAt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:00:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B360C49
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:00:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05BC4B81DF8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EDCC433D2;
        Sat, 31 Dec 2022 02:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452044;
        bh=HperrF5r7kGhMFDFJvPHR+nQrrhOglDa9T98tYWj+4k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DnxG4ZXa+gHUAmY4YTt2oFrlRT7baFIMn+7SWEPUr6LrEZ86w+pps7rDcNuu5G9tm
         1pGMvYHmRimocEEqo45FcT6xElFv1gxfEulYrlSaiDgihZLs1P/yezbZFHsmQbGIKO
         sfup6BQhk7Tti9BrF25HKJJWgkGGJeWjd2lohEZ8uxylV3y2a7rPqOK4K5bEKud6yu
         17pLU8MiTSBs7+vvQ3GyBPap7n+Xx2mOYuZAoZia4i1LxJQCcmT6/4atqjxM/mTcpI
         FvM3up4UNOTJ7+HGSWH1CTH9l5U3566SCIu2BBzjZdbDTvR70vojm7Oh6O3+NDbj25
         TaNz8W6kLwdjQ==
Subject: [PATCH 7/9] xfs: allow reflink on the rt volume when extent size is
 larger than 1 rt block
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:39 -0800
Message-ID: <167243871903.718512.17290898717615584521.stgit@magnolia>
In-Reply-To: <167243871792.718512.13170681692847163098.stgit@magnolia>
References: <167243871792.718512.13170681692847163098.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
 fs/xfs/xfs_reflink.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_rtalloc.c |    2 +
 fs/xfs/xfs_super.c   |   19 +++++++++---
 fs/xfs/xfs_trace.h   |    3 ++
 4 files changed, 90 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b9f47bdbe383..28fe946ecd08 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1530,6 +1530,13 @@ xfs_reflink_remap_blocks(
 	len = min_t(xfs_filblks_t, XFS_B_TO_FSB(mp, remap_len),
 			XFS_MAX_FILEOFF);
 
+	/*
+	 * Make sure the end is aligned with a rt extent (if desired), since
+	 * the end of the range could be EOF.
+	 */
+	if (xfs_inode_has_bigrtextents(dest))
+		len = xfs_rtb_roundup_rtx(mp, len);
+
 	trace_xfs_reflink_remap_blocks(src, srcoff, len, dest, destoff);
 
 	while (len > 0) {
@@ -1603,6 +1610,54 @@ xfs_reflink_zero_posteof(
 	return xfs_zero_range(ip, isize, pos - isize, NULL);
 }
 
+#ifdef CONFIG_XFS_RT
+/* Adjust the length of the remap operation to end on a rt extent boundary. */
+STATIC int
+xfs_reflink_remap_adjust_rtlen(
+	struct xfs_inode	*src,
+	loff_t			pos_in,
+	struct xfs_inode	*dest,
+	loff_t			pos_out,
+	loff_t			*len,
+	unsigned int		remap_flags)
+{
+	struct xfs_mount	*mp = src->i_mount;
+	uint32_t		mod;
+
+	div_u64_rem(*len, XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize), &mod);
+
+	/*
+	 * We previously checked the rtextent alignment of both offsets, so we
+	 * now have to check the alignment of the length.  The VFS remap prep
+	 * function can change the length on us, so we can only make length
+	 * adjustments after that.  If the length is aligned to an rtextent,
+	 * we're trivially good to go.
+	 *
+	 * Otherwise, the length is not aligned to an rt extent.  If the source
+	 * file's range ends at EOF, the VFS ensured that the dest file's range
+	 * also ends at EOF.  The actual remap function will round the (byte)
+	 * length up to the nearest rtextent unit, so we're ok here too.
+	 */
+	if (mod == 0 || pos_in + *len == i_size_read(VFS_I(src)))
+		return 0;
+
+	/*
+	 * Otherwise, the only thing we can do is round the request length down
+	 * to an rt extent boundary.  If the caller doesn't allow that, we are
+	 * finished.
+	 */
+	if (!(remap_flags & REMAP_FILE_CAN_SHORTEN))
+		return -EINVAL;
+
+	/* Back off by a single extent. */
+	(*len) -= mod;
+	trace_xfs_reflink_remap_adjust_rtlen(src, pos_in, *len, dest, pos_out);
+	return 0;
+}
+#else
+# define xfs_reflink_remap_adjust_rtlen(...)		(0)
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file will
@@ -1645,6 +1700,7 @@ xfs_reflink_remap_prep(
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
+	const struct iomap_ops	*dax_read_ops = NULL;
 	int			ret;
 
 	/* Lock both files against IO */
@@ -1662,15 +1718,25 @@ xfs_reflink_remap_prep(
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
 
+	/* Make sure the end is aligned with a rt extent. */
+	if (xfs_inode_has_bigrtextents(src)) {
+		ret = xfs_reflink_remap_adjust_rtlen(src, pos_in, dest,
+				pos_out, len, remap_flags);
+		if (ret || *len == 0)
+			goto out_unlock;
+	}
+
 	/* Attach dquots to dest inode before changing block map */
 	ret = xfs_qm_dqattach(dest);
 	if (ret)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 75d39c3274df..7c1edd5c2554 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1312,7 +1312,7 @@ xfs_growfs_rt(
 		return -EOPNOTSUPP;
 	if (xfs_has_quota(mp))
 		return -EOPNOTSUPP;
-	if (xfs_has_reflink(mp) && in->extsize != 1)
+	if (xfs_has_reflink(mp) && !is_power_of_2(mp->m_sb.sb_rextsize))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a3a0011272e5..31c1690ed847 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1657,13 +1657,22 @@ xfs_fs_fill_super(
 
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
index d5b0dc3c5a0d..00716f112f4e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3848,6 +3848,9 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
 		  __entry->dest_lblk)
 );
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
+#ifdef CONFIG_XFS_RT
+DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_adjust_rtlen);
+#endif /* CONFIG_XFS_RT */
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);

