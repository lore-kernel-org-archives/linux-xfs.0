Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2GCL11032653 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:12:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41C00164F2E4
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:12:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IYdlbNA02eAyuLHO for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:12:21 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xly-0007In-0h
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:50 +0000
Message-Id: <20081202160649.932903000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 03/22] remove unused behvavior cruft in xfs_super.h
Content-Disposition: inline; filename=xfs-remove-dmapi-cruft
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


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_super.h	2008-12-02 11:21:33.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_super.h	2008-12-02 11:21:49.000000000 +0100
@@ -20,24 +20,12 @@
 
 #include <linux/exportfs.h>
 
-#ifdef CONFIG_XFS_DMAPI
-# define vfs_insertdmapi(vfs)	vfs_insertops(vfsp, &xfs_dmops)
-# define vfs_initdmapi()	dmapi_init()
-# define vfs_exitdmapi()	dmapi_uninit()
-#else
-# define vfs_insertdmapi(vfs)	do { } while (0)
-# define vfs_initdmapi()	do { } while (0)
-# define vfs_exitdmapi()	do { } while (0)
-#endif
-
 #ifdef CONFIG_XFS_QUOTA
-# define vfs_insertquota(vfs)	vfs_insertops(vfsp, &xfs_qmops)
 extern void xfs_qm_init(void);
 extern void xfs_qm_exit(void);
 # define vfs_initquota()	xfs_qm_init()
 # define vfs_exitquota()	xfs_qm_exit()
 #else
-# define vfs_insertquota(vfs)	do { } while (0)
 # define vfs_initquota()	do { } while (0)
 # define vfs_exitquota()	do { } while (0)
 #endif

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
