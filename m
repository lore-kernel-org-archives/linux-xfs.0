Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PISTBf216824 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 13:28:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21CB0150E013
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:29:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Wdfy2sr3fch0jEaI for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:29:22 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Mg0ii-0001DU-QA
	for xfs@oss.sgi.com; Tue, 25 Aug 2009 18:26:12 +0000
Message-Id: <20090825182612.645320741@bombadil.infradead.org>
Date: Tue, 25 Aug 2009 14:21:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/9] xfs: switch to NOFS allocation under i_lock in xfs_getbmap
References: <20090825182134.299870049@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-getbmap
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

xfs_getbmap allocates memory with i_lock held, but i_lock is taken in
reclaim context so all allocations under it must avoid recursions into
the filesystem.

Reported by the new reclaim context tracing in lockdep.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.c	2009-07-10 13:05:24.808364312 +0200
+++ linux-2.6/fs/xfs/xfs_bmap.c	2009-07-10 13:16:00.830363579 +0200
@@ -6009,7 +6009,7 @@ xfs_getbmap(
 	 */
 	error = ENOMEM;
 	subnex = 16;
-	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL);
+	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL | KM_NOFS);
 	if (!map)
 		goto out_unlock_ilock;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
