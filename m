Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8775BCA9EAF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 02:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55A2021D7B
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 02:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l7ZkBriQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbfJYCS6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 22:18:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389816AbfJYCS5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 22:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=N6dTWRDS8i8pNymS4DIBj8MMJO7h2CIn6cYn5ZtjaH0=; b=l7ZkBriQNrkpJlBIGqy0fTxsh
        XWADD08GxphKlgWkuv8yN2RX2PqHh0RR9GlC8s4RBCshJ7AFaFPs3AY4u95oK46cBTKBXeXZ4+Tcj
        JdZYfZHmVEv8s8hJzuhFB+iOP3I0/TiQFDhMED/+wzJRLGgh6z2PWPEd3WI4wNpXmnhsOVKMIuXDe
        Bc0INQf97jNZjxoKG8YgxjepW+CNkWSbrIB5vX/Nja1Arvs12D5+iG3bbrDdAce6dvy2ygszLgUCT
        /HwyN16QdOuLwgcdsYTyby0U6fh5XDoUlXwTKxcQajUBZ4CIjZ3rDZbdUJ3W0O1WYf0rvGcZ/W0ta
        BAVamipqQ==;
Received: from p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp ([153.156.43.6] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNpBo-0005Uf-Vb
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 02:18:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: add a xfs_inode_buftarg helper
Date:   Fri, 25 Oct 2019 11:18:50 +0900
Message-Id: <20191025021852.20172-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025021852.20172-1-hch@lst.de>
References: <20191025021852.20172-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a new xfs_inode_buftarg helper that gets the data I/O buftarg for a
given inode.  Replace the existing xfs_find_bdev_for_inode and
xfs_find_daxdev_for_inode helpers with this new general one and cleanup
some of the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c      | 34 +++++-----------------------------
 fs/xfs/xfs_aops.h      |  3 ---
 fs/xfs/xfs_bmap_util.c | 15 ++++++++-------
 fs/xfs/xfs_file.c      | 14 +++++++-------
 fs/xfs/xfs_inode.h     |  7 +++++++
 fs/xfs/xfs_ioctl.c     |  7 +++----
 fs/xfs/xfs_iomap.c     | 11 +++++++----
 fs/xfs/xfs_iops.c      |  2 +-
 8 files changed, 38 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5d3503f6412a..3a688eb5c5ae 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -30,32 +30,6 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
 	return container_of(ctx, struct xfs_writepage_ctx, ctx);
 }
 
-struct block_device *
-xfs_find_bdev_for_inode(
-	struct inode		*inode)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-
-	if (XFS_IS_REALTIME_INODE(ip))
-		return mp->m_rtdev_targp->bt_bdev;
-	else
-		return mp->m_ddev_targp->bt_bdev;
-}
-
-struct dax_device *
-xfs_find_daxdev_for_inode(
-	struct inode		*inode)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-
-	if (XFS_IS_REALTIME_INODE(ip))
-		return mp->m_rtdev_targp->bt_daxdev;
-	else
-		return mp->m_ddev_targp->bt_daxdev;
-}
-
 /*
  * Fast and loose check if this write could update the on-disk inode size.
  */
@@ -609,9 +583,11 @@ xfs_dax_writepages(
 	struct address_space	*mapping,
 	struct writeback_control *wbc)
 {
-	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	struct xfs_inode	*ip = XFS_I(mapping->host);
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return dax_writeback_mapping_range(mapping,
-			xfs_find_bdev_for_inode(mapping->host), wbc);
+			xfs_inode_buftarg(ip)->bt_bdev, wbc);
 }
 
 STATIC sector_t
@@ -661,7 +637,7 @@ xfs_iomap_swapfile_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_find_bdev_for_inode(file_inode(swap_file));
+	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
 	return iomap_swapfile_activate(sis, swap_file, span,
 			&xfs_read_iomap_ops);
 }
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 687b11f34fa2..e0bd68419764 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -11,7 +11,4 @@ extern const struct address_space_operations xfs_dax_aops;
 
 int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 
-extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
-extern struct dax_device *xfs_find_daxdev_for_inode(struct inode *);
-
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5d8632b7f549..9b0572a7b03a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -53,15 +53,16 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
  */
 int
 xfs_zero_extent(
-	struct xfs_inode *ip,
-	xfs_fsblock_t	start_fsb,
-	xfs_off_t	count_fsb)
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		start_fsb,
+	xfs_off_t		count_fsb)
 {
-	struct xfs_mount *mp = ip->i_mount;
-	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
-	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
+	xfs_daddr_t		sector = xfs_fsb_to_db(ip, start_fsb);
+	sector_t		block = XFS_BB_TO_FSBT(mp, sector);
 
-	return blkdev_issue_zeroout(xfs_find_bdev_for_inode(VFS_I(ip)),
+	return blkdev_issue_zeroout(target->bt_bdev,
 		block << (mp->m_super->s_blocksize_bits - 9),
 		count_fsb << (mp->m_super->s_blocksize_bits - 9),
 		GFP_NOFS, 0);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 24659667d5cb..ee4ebb7904f6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1229,22 +1229,22 @@ static const struct vm_operations_struct xfs_file_vm_ops = {
 
 STATIC int
 xfs_file_mmap(
-	struct file	*filp,
-	struct vm_area_struct *vma)
+	struct file		*file,
+	struct vm_area_struct	*vma)
 {
-	struct dax_device 	*dax_dev;
+	struct inode		*inode = file_inode(file);
+	struct xfs_buftarg	*target = xfs_inode_buftarg(XFS_I(inode));
 
-	dax_dev = xfs_find_daxdev_for_inode(file_inode(filp));
 	/*
 	 * We don't support synchronous mappings for non-DAX files and
 	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!daxdev_mapping_supported(vma, dax_dev))
+	if (!daxdev_mapping_supported(vma, target->bt_daxdev))
 		return -EOPNOTSUPP;
 
-	file_accessed(filp);
+	file_accessed(file);
 	vma->vm_ops = &xfs_file_vm_ops;
-	if (IS_DAX(file_inode(filp)))
+	if (IS_DAX(inode))
 		vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 558173f95a03..bcfb35a9c5ca 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -219,6 +219,13 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
 	return ip->i_cowfp && ip->i_cowfp->if_bytes;
 }
 
+/*
+ * Return the buftarg used for data allocations on a given inode.
+ */
+#define xfs_inode_buftarg(ip) \
+	(XFS_IS_REALTIME_INODE(ip) ? \
+		(ip)->i_mount->m_rtdev_targp : (ip)->i_mount->m_ddev_targp)
+
 /*
  * In-core inode flags.
  */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d58f0d6a699e..b7b5c17131cd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1311,10 +1311,9 @@ xfs_ioctl_setattr_dax_invalidate(
 	 * have to check the device for dax support or flush pagecache.
 	 */
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
-		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
-			return -EINVAL;
-		if (!bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
-				sb->s_blocksize))
+		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
+
+		if (!bdev_dax_supported(target->bt_bdev, sb->s_blocksize))
 			return -EINVAL;
 	}
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bf0c7756ac90..c1063507e5fd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -57,6 +57,7 @@ xfs_bmbt_to_iomap(
 	u16			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
 
 	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
 		return xfs_alert_fsblock_zero(ip, imap);
@@ -77,8 +78,8 @@ xfs_bmbt_to_iomap(
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
-	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
-	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
+	iomap->bdev = target->bt_bdev;
+	iomap->dax_dev = target->bt_daxdev;
 	iomap->flags = flags;
 
 	if (xfs_ipincount(ip) &&
@@ -94,12 +95,14 @@ xfs_hole_to_iomap(
 	xfs_fileoff_t		offset_fsb,
 	xfs_fileoff_t		end_fsb)
 {
+	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
+
 	iomap->addr = IOMAP_NULL_ADDR;
 	iomap->type = IOMAP_HOLE;
 	iomap->offset = XFS_FSB_TO_B(ip->i_mount, offset_fsb);
 	iomap->length = XFS_FSB_TO_B(ip->i_mount, end_fsb - offset_fsb);
-	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
-	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
+	iomap->bdev = target->bt_bdev;
+	iomap->dax_dev = target->bt_daxdev;
 }
 
 static inline xfs_fileoff_t
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 329a34af8e79..404f2dd58698 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1227,7 +1227,7 @@ xfs_inode_supports_dax(
 		return false;
 
 	/* Device has to support DAX too. */
-	return xfs_find_daxdev_for_inode(VFS_I(ip)) != NULL;
+	return xfs_inode_buftarg(ip)->bt_daxdev != NULL;
 }
 
 STATIC void
-- 
2.20.1

