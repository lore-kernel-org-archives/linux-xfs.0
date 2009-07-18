Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IMGtpn176618 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:16:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C604F137E09D
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id f0QHEiIpxlKRqmQT for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:34 -0700 (PDT)
Message-Id: <20090718221734.293462000@bombadil.infradead.org>
Date: Sat, 18 Jul 2009 18:15:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/9] xfs: switch to NOFS allocation under i_lock in
	xfs_attr_rmtval_get
References: <20090718221452.594956000@bombadil.infradead.org>
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
Cc: sage@newdream.net

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
