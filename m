Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55723 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdHaNRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 09:17:23 -0400
Date: Thu, 31 Aug 2017 06:17:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: don't set v3 xflags for v2 inodes
Message-ID: <20170831131723.GD19544@infradead.org>
References: <20170830155517.GI4757@magnolia>
 <20170830163825.GQ4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830163825.GQ4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>

Hmm.  I thought of something like that patch below:

---
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 31 Aug 2017 15:14:36 +0200
Subject: xfs: don't set v3 xflags for v2 inodes

Reject attempts to set XFLAGS that correspond to di_flags2 inode flags
if the inode isn't a v3 inode, because di_flags2 only exists on v3.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9c0c7a920304..9fea768e9f70 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -931,7 +931,7 @@ xfs_ioc_fsgetxattr(
 	return 0;
 }
 
-STATIC void
+STATIC int
 xfs_set_diflags(
 	struct xfs_inode	*ip,
 	unsigned int		xflags)
@@ -974,7 +974,7 @@ xfs_set_diflags(
 
 	/* diflags2 only valid for v3 inodes. */
 	if (ip->i_d.di_version < 3)
-		return;
+		return -EINVAL;
 
 	di_flags2 = (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
 	if (xflags & FS_XFLAG_DAX)
@@ -983,6 +983,7 @@ xfs_set_diflags(
 		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 
 	ip->i_d.di_flags2 = di_flags2;
+	return 0;
 }
 
 STATIC void
@@ -1022,6 +1023,7 @@ xfs_ioctl_setattr_xflags(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
@@ -1052,7 +1054,10 @@ xfs_ioctl_setattr_xflags(
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
-	xfs_set_diflags(ip, fa->fsx_xflags);
+	error = xfs_set_diflags(ip, fa->fsx_xflags);
+	if (error)
+		return error;
+
 	xfs_diflags_to_linux(ip);
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-- 
2.11.0

