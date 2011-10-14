Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EIr4uC043303 for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 13:53:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47AB5562014
	for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 11:53:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	C929Qm3iRlx1z7e8 for <xfs@oss.sgi.com>;
	Fri, 14 Oct 2011 11:53:02 -0700 (PDT)
Message-Id: <20111014185301.346470238@bombadil.infradead.org>
Date: Fri, 14 Oct 2011 14:50:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: do not update xa_last_pushed_lsn for locked items
References: <20111014185048.893798829@bombadil.infradead.org>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

commit bc6e588a8971aa74c02e42db4d6e0248679f3738 upstream

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
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-14 14:42:03.004395373 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-14 14:42:22.687898198 +0200
@@ -491,7 +491,6 @@ xfs_ail_worker(
 
 		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
-			ailp->xa_last_pushed_lsn = lsn;
 			stuck++;
 			break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
