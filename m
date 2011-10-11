Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BFEhEs008408 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 10:14:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A45C145FA44
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 08:21:58 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gBaUDKc9AOUHkBES for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 08:21:58 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDe2T-0005ow-E0
	for xfs@oss.sgi.com; Tue, 11 Oct 2011 15:14:41 +0000
Message-Id: <20111011151441.383119482@bombadil.infradead.org>
Date: Tue, 11 Oct 2011 11:14:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: do not update xa_last_pushed_lsn for locked items
References: <20111011151407.382514375@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-ail-retry-locked-items
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

If an item was locked we should not update xa_last_pushed_lsn and thus skip
it when restarting the AIL scan as we need to be able to lock and write it
out as soon as possible.  Otherwise heavy lock contention might starve AIL
pushing too easily, especially given the larger backoff once we moved
xa_last_pushed_lsn all the way to the target lsn.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Tested-by: Stefan Priebe <s.priebe@profihost.ag>

Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-11 15:48:49.302003241 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-11 15:49:10.307505812 +0200
@@ -440,7 +440,6 @@ xfs_ail_worker(
 
 		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
-			ailp->xa_last_pushed_lsn = lsn;
 			stuck++;
 			break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
