Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6ZiI178953 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37AD114678DF
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vtG23vq5DoxDxHGG for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xx-000169-TJ
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:01 +0000
Message-Id: <20100531160901.792538953@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/17] xfs: kill the unused xlog_debug variable
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xlog_debug
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2010-05-29 18:44:56.012049463 +0200
+++ xfs/fs/xfs/xfs_log.h	2010-05-29 18:44:57.709003926 +0200
@@ -201,9 +201,4 @@ int	xfs_log_commit_cil(struct xfs_mount
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 #endif
-
-
-extern int xlog_debug;		/* set to 1 to enable real log */
-
-
 #endif	/* __XFS_LOG_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
