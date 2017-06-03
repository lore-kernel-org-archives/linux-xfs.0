Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59921 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCNLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:11:14 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/23] xfs: fix over-copying of getbmap parameters from userspace
Date: Sat,  3 Jun 2017 15:10:42 +0200
Message-Id: <20170603131103.23712-3-hch@lst.de>
In-Reply-To: <20170603131103.23712-1-hch@lst.de>
References: <20170603131103.23712-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit be6324c00c4d1e0e665f03ed1fc18863a88da119 upstream.

In xfs_ioc_getbmap, we should only copy the fields of struct getbmap
from userspace, or else we end up copying random stack contents into the
kernel.  struct getbmap is a strict subset of getbmapx, so a partial
structure copy should work fine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2fd7fdf5438f..6d30b06e79bc 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1543,10 +1543,11 @@ xfs_ioc_getbmap(
 	unsigned int		cmd,
 	void			__user *arg)
 {
-	struct getbmapx		bmx;
+	struct getbmapx		bmx = { 0 };
 	int			error;
 
-	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
+	/* struct getbmap is a strict subset of struct getbmapx. */
+	if (copy_from_user(&bmx, arg, offsetof(struct getbmapx, bmv_iflags)))
 		return -EFAULT;
 
 	if (bmx.bmv_count < 2)
-- 
2.11.0

