Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DM56Op194002 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:05:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DD951C4CFDC
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:06:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id klOCfGOmdVu3JfIm for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:06:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NVBLm-0004Ty-QR
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 22:06:02 +0000
Message-Id: <20100113220602.632551077@bombadil.infradead.org>
Date: Wed, 13 Jan 2010 17:05:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: kill XFS_QMOPT_ASYNC
References: <20100113220547.846700560@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_QMOPT_ASYNC
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

The option is unused and one of the few remaining users of xfs_bawrite,
so let's get rid of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/quota/xfs_dquot.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_dquot.c	2010-01-08 15:10:07.694006652 +0100
+++ linux-2.6/fs/xfs/quota/xfs_dquot.c	2010-01-08 15:10:26.227006460 +0100
@@ -1253,8 +1253,6 @@ xfs_qm_dqflush(
 
 	if (flags & XFS_QMOPT_DELWRI) {
 		xfs_bdwrite(mp, bp);
-	} else if (flags & XFS_QMOPT_ASYNC) {
-		error = xfs_bawrite(mp, bp);
 	} else {
 		error = xfs_bwrite(mp, bp);
 	}
Index: linux-2.6/fs/xfs/xfs_quota.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_quota.h	2010-01-08 15:10:07.729006360 +0100
+++ linux-2.6/fs/xfs/xfs_quota.h	2010-01-08 15:10:12.062005658 +0100
@@ -226,7 +226,6 @@ typedef struct xfs_qoff_logformat {
  * flags for dqflush and dqflush_all.
  */
 #define XFS_QMOPT_SYNC		0x1000000
-#define XFS_QMOPT_ASYNC		0x2000000
 #define XFS_QMOPT_DELWRI	0x4000000
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
