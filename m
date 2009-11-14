Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGHfHq193824 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:17:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 934AB1D976F2
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8F4Pp2lBCAf4UNPg for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N9LK6-0004YH-99
	for xfs@oss.sgi.com; Sat, 14 Nov 2009 16:18:02 +0000
Message-Id: <20091114161802.164659630@bombadil.infradead.org>
Date: Sat, 14 Nov 2009 11:17:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: remove incorrect sparse annotation for
	xfs_iget_cache_miss
References: <20091114161717.233372584@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-sparse-fix
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

xfs_iget_cache_miss does not get called with the pag_ici_lock held, so
the __releases annotation is incorrect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
 
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-11-12 17:13:27.565003964 +0100
+++ xfs/fs/xfs/xfs_iget.c	2009-11-12 17:19:14.801254179 +0100
@@ -293,7 +293,7 @@ xfs_iget_cache_miss(
 	struct xfs_inode	**ipp,
 	xfs_daddr_t		bno,
 	int			flags,
-	int			lock_flags) __releases(pag->pag_ici_lock)
+	int			lock_flags)
 {
 	struct xfs_inode	*ip;
 	int			error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
