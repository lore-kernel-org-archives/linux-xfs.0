Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G6oYX031609 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:06:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47FCF164F1B5
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:06:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4hTfaFm5u4hWYr9L for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:06:50 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xlx-0007Hp-Si
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:49 +0000
Message-Id: <20081202160649.790190000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 02/22] remove useless mnt_want_write call in xfs_write
Content-Disposition: inline; filename=xfs-remove-mnt_want_write
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


When mnt_want_write was introduced a call to it was added around
xfs_ichgtime, but there is no need for this because a file can't be open
read/write on a r/o mount, and a mount can't degrade r/o while we still
have files open for writing.  As the mnt_want_write changes were never
merged into the CVS tree this patch is for mainline only.


Signed-off-by: Christoph Hellwig <hch@lst.de>

--- linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2008-08-14 14:52:15.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-08-14 14:54:53.000000000 -0300
@@ -51,7 +51,6 @@
 #include "xfs_vnodeops.h"
 
 #include <linux/capability.h>
-#include <linux/mount.h>
 #include <linux/writeback.h>
 
 
@@ -668,15 +667,8 @@ start:
 	if (new_size > xip->i_size)
 		xip->i_new_size = new_size;
 
-	/*
-	 * We're not supposed to change timestamps in readonly-mounted
-	 * filesystems.  Throw it away if anyone asks us.
-	 */
-	if (likely(!(ioflags & IO_INVIS) &&
-		   !mnt_want_write(file->f_path.mnt))) {
+	if (likely(!(ioflags & IO_INVIS)))
 		xfs_ichgtime(xip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-		mnt_drop_write(file->f_path.mnt);
-	}
 
 	/*
 	 * If the offset is beyond the size of the file, we have a couple

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
