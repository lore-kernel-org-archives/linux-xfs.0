Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 15:38:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9DMc5L7016154
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 15:38:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE46213F0D71
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 15:39:46 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 6bYeu92samWdCvCU for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 15:39:46 -0700 (PDT)
Date: Tue, 14 Oct 2008 09:39:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: fw: [PATCH] fix instant oops with tracing enabled
Message-ID: <20081013223932.GE10716@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: hch@lst.de

SGI folks,

Looks like Christoph is having problems posting to the list;
the spam filter is dropping all his mail. In the mean time,
here's a fix for an oops in the tracing code as a result of
the last check ins. I didn't see this because the "combine
inodes" patches removes xfs_icount altogether. If that
series is going to be included in the current round of checkins
then this patch probably isn't needed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


From: Christoph Hellwig <hch@lst.de>

We can only read inode->i_count if the inode is actually there and not
a NULL pointer.  This was introduced in one of the recent sync patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-10-13 12:07:38.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2008-10-13 12:07:47.000000000 -0400
@@ -92,7 +92,7 @@ static inline int xfs_icount(struct xfs_
 {
 	struct inode *inode = VFS_I(ip);
 
-	if (!inode)
+	if (inode)
 		return atomic_read(&inode->i_count);
 	return -1;
 }
