Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18600 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753383AbdDCRgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 13:36:47 -0400
Date: Mon, 3 Apr 2017 10:36:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix over-copying of getbmap parameters from userspace
Message-ID: <20170403173619.GM4864@birch.djwong.org>
References: <20170403173430.GL4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403173430.GL4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>

In xfs_ioc_getbmap, we should only copy the fields of struct getbmap
from userspace, or else we end up copying random stack contents into the
kernel.  struct getbmap is a strict subset of getbmapx, so a partial
structure copy should work fine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2fd7fdf..e44dde7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1543,10 +1543,14 @@ xfs_ioc_getbmap(
 	unsigned int		cmd,
 	void			__user *arg)
 {
-	struct getbmapx		bmx;
+	struct getbmapx		bmx = { 0 };
 	int			error;
 
-	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
+	/*
+	 * struct getbmap is a strict subset of struct getbmapx,
+	 * so using a straight memory copy should work fine.
+	 */
+	if (copy_from_user(&bmx, arg, offsetof(struct getbmapx, bmv_iflags)))
 		return -EFAULT;
 
 	if (bmx.bmv_count < 2)
