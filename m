Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PISUeC216825 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 13:28:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51AF73F904F
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:29:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2ujEvCnFTsXHSIU1 for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:29:23 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Mg0ij-0001H6-WB
	for xfs@oss.sgi.com; Tue, 25 Aug 2009 18:26:14 +0000
Message-Id: <20090825182613.898529620@bombadil.infradead.org>
Date: Tue, 25 Aug 2009 14:21:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/9] xfs: switch to NOFS allocation under i_lock in
	xfs_attr_rmtval_get
References: <20090825182134.299870049@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-buf-4
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

xfs_attr_rmtval_get is always called with i_lock held, but i_lock is taken
in reclaim context so all allocations under it must avoid recursions into
the filesystem.  

Reported by the new reclaim context tracing in lockdep.


Index: linux-2.6/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_attr.c	2009-07-18 22:34:08.947532301 +0200
+++ linux-2.6/fs/xfs/xfs_attr.c	2009-07-18 22:35:44.786660003 +0200
@@ -2010,7 +2010,9 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_read_buf(mp, mp->m_ddev_targp, dblkno,
-					     blkcnt, XFS_BUF_LOCK, &bp);
+					     blkcnt,
+					     XFS_BUF_LOCK | XBF_DONT_BLOCK,
+					     &bp);
 			if (error)
 				return(error);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
