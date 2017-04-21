Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43665 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162276AbdDURHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 13:07:32 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d1aNQ-0005VE-4q
        for linux-xfs@vger.kernel.org; Fri, 21 Apr 2017 15:21:40 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] xfs: fix __user annotations for xfs_ioc_getfsmap
Date: Fri, 21 Apr 2017 17:21:21 +0200
Message-Id: <20170421152123.11316-5-hch@lst.de>
In-Reply-To: <20170421152123.11316-1-hch@lst.de>
References: <20170421152123.11316-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

By passing the whole fsmap_head structure and an index we can get the
user point annotations right for the embedded variable sized array
in struct fsmap_head.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0f8bed9a7e4c..b7db0b8f0657 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1614,7 +1614,8 @@ xfs_ioc_getbmapx(
 
 struct getfsmap_info {
 	struct xfs_mount	*mp;
-	struct fsmap __user	*data;
+	struct fsmap_head __user *data;
+	int			idx;
 	__u32			last_flags;
 };
 
@@ -1628,17 +1629,17 @@ xfs_getfsmap_format(struct xfs_fsmap *xfm, void *priv)
 
 	info->last_flags = xfm->fmr_flags;
 	xfs_fsmap_from_internal(&fm, xfm);
-	if (copy_to_user(info->data, &fm, sizeof(struct fsmap)))
+	if (copy_to_user(&info->data->fmh_recs[info->idx++], &fm,
+			sizeof(struct fsmap)))
 		return -EFAULT;
 
-	info->data++;
 	return 0;
 }
 
 STATIC int
 xfs_ioc_getfsmap(
 	struct xfs_inode	*ip,
-	void			__user *arg)
+	struct fsmap_head	__user *arg)
 {
 	struct getfsmap_info	info = { NULL };
 	struct xfs_fsmap_head	xhead = {0};
@@ -1664,7 +1665,7 @@ xfs_ioc_getfsmap(
 	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
 
 	info.mp = ip->i_mount;
-	info.data = ((__force struct fsmap_head *)arg)->fmh_recs;
+	info.data = arg;
 	error = xfs_getfsmap(ip->i_mount, &xhead, xfs_getfsmap_format, &info);
 	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
 		error = 0;
@@ -1674,10 +1675,9 @@ xfs_ioc_getfsmap(
 
 	/* If we didn't abort, set the "last" flag in the last fmx */
 	if (!aborted && xhead.fmh_entries) {
-		info.data--;
 		info.last_flags |= FMR_OF_LAST;
-		if (copy_to_user(&info.data->fmr_flags, &info.last_flags,
-				sizeof(info.last_flags)))
+		if (copy_to_user(&info.data->fmh_recs[info.idx - 1].fmr_flags,
+				&info.last_flags, sizeof(info.last_flags)))
 			return -EFAULT;
 	}
 
-- 
2.11.0

