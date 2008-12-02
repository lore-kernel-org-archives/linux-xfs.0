Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G7Lox031738 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:07:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F10A3164F1E0
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:07:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MgcLIBZ1B2LVMaLy for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:07:20 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xly-0007Jd-4q
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:50 +0000
Message-Id: <20081202160650.066779000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 04/22] remove unused prototypes for xfs_ihash_init /
	xfs_ihash_free
Content-Disposition: inline; filename=xfs-kill-xfs_ihash_init-exit
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

Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-11-19 20:07:01.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-11-19 20:07:05.000000000 +0100
@@ -493,8 +493,6 @@ static inline void xfs_ifunlock(xfs_inod
 /*
  * xfs_iget.c prototypes.
  */
-void		xfs_ihash_init(struct xfs_mount *);
-void		xfs_ihash_free(struct xfs_mount *);
 xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
 				  struct xfs_trans *);
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
