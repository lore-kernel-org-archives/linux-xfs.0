Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PIPfvm216627 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 13:25:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72A873F9017
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:26:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IDS3fCfSnjNJyHm3 for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:26:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Mg0ij-0001EW-61
	for xfs@oss.sgi.com; Tue, 25 Aug 2009 18:26:13 +0000
Message-Id: <20090825182613.083976866@bombadil.infradead.org>
Date: Tue, 25 Aug 2009 14:21:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/9] xfs: switch to NOFS allocation under i_lock in
	xfs_da_buf_make
References: <20090825182134.299870049@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-xfs_da_buf_make
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

i_lock is taken in the reclaim context so all allocations under it
must avoid recursions into the filesystem.

Reported by the new reclaim context tracing in lockdep.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_da_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_da_btree.c	2009-07-10 13:05:24.812364541 +0200
+++ linux-2.6/fs/xfs/xfs_da_btree.c	2009-07-10 13:16:00.834365485 +0200
@@ -2261,9 +2261,9 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bp
 	int		off;
 
 	if (nbuf == 1)
-		dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_SLEEP);
+		dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_NOFS);
 	else
-		dabuf = kmem_alloc(XFS_DA_BUF_SIZE(nbuf), KM_SLEEP);
+		dabuf = kmem_alloc(XFS_DA_BUF_SIZE(nbuf), KM_NOFS);
 	dabuf->dirty = 0;
 #ifdef XFS_DABUF_DEBUG
 	dabuf->ra = ra;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
