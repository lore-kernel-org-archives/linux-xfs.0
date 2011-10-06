Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96IZqE6195429 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 13:35:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A94AF14513A2
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 11:42:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JAdmlam6fyGcGQYH for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 11:42:40 -0700 (PDT)
Message-Id: <20111006183549.399127499@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 14:32:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: do not update xa_last_pushed_lsn for locked items
References: <20111006183257.036884724@bombadil.infradead.org>
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
Cc: Stefan Priebe <s.priebe@profihost.ag>

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
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-06 10:31:29.855243550 -0400
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-06 10:31:55.832744112 -0400
@@ -452,7 +452,6 @@ xfs_ail_worker(
 
 		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
-			ailp->xa_last_pushed_lsn = lsn;
 			stuck++;
 			break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
