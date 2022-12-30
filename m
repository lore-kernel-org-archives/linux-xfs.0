Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CB4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiLaCBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCBT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:01:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B9C2AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F2F1B81DED
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D02C433D2;
        Sat, 31 Dec 2022 02:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452075;
        bh=6pqZwELMJP34cAJ4OwI73I/8KEUNmgqjziWNYXfCq3s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HFQZ+jL0JZ45CCwLHFLY/DzqNeoNTNIh4G78VwOrla45FO4PK3Q9ENqtywN1JB9x9
         H+ADVHZCpC2ay0yZZc0j43fDvrsUBtljWm3Wqtu/Obq3acQsqNqs+hujCNPVvW7Zm1
         FCqzgoLz1hsgodRUf8iUsYmw6C3fTLLtKvskcmLZVPbW8qm4Qf47n1HYTP0ahLUJ0S
         G4kzrJeTI86N+nzAKOduEAuOwxRdew6NRyQGaTme0fbRCC58UdZFFDwNzvHDCbx24q
         V7G8CAPa1+BRjtxlz2S2ydRkwMthA/Q12mX2RzqLhamQevg5f+URkTPoMMD2OmzPAe
         ZwB3hufmvJmRg==
Subject: [PATCH 9/9] xfs: support realtime reflink with an extent size that
 isn't a power of 2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:39 -0800
Message-ID: <167243871932.718512.16891050272429194261.stgit@magnolia>
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
index 28fe946ecd08..1ec00204b33f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1658,6 +1658,83 @@ xfs_reflink_remap_adjust_rtlen(
 # define xfs_reflink_remap_adjust_rtlen(...)		(0)
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
@@ -1701,6 +1778,7 @@ xfs_reflink_remap_prep(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	const struct iomap_ops	*dax_read_ops = NULL;
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(dest);
 	int			ret;
 
 	/* Lock both files against IO */
@@ -1718,14 +1796,22 @@ xfs_reflink_remap_prep(
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
index 7c1edd5c2554..5e27cb7fce36 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1312,7 +1312,8 @@ xfs_growfs_rt(
 		return -EOPNOTSUPP;
 	if (xfs_has_quota(mp))
 		return -EOPNOTSUPP;
-	if (xfs_has_reflink(mp) && !is_power_of_2(mp->m_sb.sb_rextsize))
+	if (xfs_has_reflink(mp) && !is_power_of_2(mp->m_sb.sb_rextsize) &&
+	    (XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) & ~PAGE_MASK))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 31c1690ed847..627fa40bbc5b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1662,17 +1662,17 @@ xfs_fs_fill_super(
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

