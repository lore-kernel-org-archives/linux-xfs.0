Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2VBQeft137791 for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 06:26:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD50614B2F19
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ibyk1AKUG1odNG7P for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:52 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q5G4W-0006PE-5q
	for xfs@oss.sgi.com; Thu, 31 Mar 2011 11:29:52 +0000
Message-Id: <20110331112952.144090797@bombadil.infradead.org>
Date: Thu, 31 Mar 2011 07:28:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] block: do not try to merge discard requests
References: <20110331112850.980290062@bombadil.infradead.org>
Content-Disposition: inline; filename=blk-fix-discard-2
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

Hack to not make the kernel crash when submitting multiple discard
requests that the blocl layer otherwise tries to merge.

Index: xfs/block/blk-core.c
===================================================================
--- xfs.orig/block/blk-core.c	2011-03-30 16:04:45.700659775 +0200
+++ xfs/block/blk-core.c	2011-03-30 16:04:59.775160021 +0200
@@ -1247,7 +1247,7 @@ static int __make_request(struct request
 	 */
 	blk_queue_bounce(q, &bio);
 
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA | REQ_DISCARD)) {
 		spin_lock_irq(q->queue_lock);
 		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
