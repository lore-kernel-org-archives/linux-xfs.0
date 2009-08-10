Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7ADxD2e061652 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 08:59:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2C5B1D5617A
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:00:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GduiaMsDrJYTIRqP for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:00:07 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MaVPy-00065i-Ct
	for xfs@oss.sgi.com; Mon, 10 Aug 2009 14:00:06 +0000
Date: Mon, 10 Aug 2009 10:00:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix spin_is_locked assert on uni-processor builds
Message-ID: <20090810140006.GA21521@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Without SMP or preemption spin_is_locked always returns false,
so we can't do an assert with it.  Instead use assert_spin_locked,
which does the right thing on all builds.

This fixes kernel.org BZ #13621.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Johannes Engel <jcnengel@googlemail.com>
Tested-by: Johannes Engel <jcnengel@googlemail.com>

Index: linux-2.6/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log.c	2009-08-09 23:27:07.889729629 -0300
+++ linux-2.6/fs/xfs/xfs_log.c	2009-08-09 23:27:24.092725926 -0300
@@ -3180,7 +3180,7 @@ try_again:
 STATIC void
 xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
 {
-	ASSERT(spin_is_locked(&log->l_icloglock));
+	assert_spin_locked(&log->l_icloglock);
 
 	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		xlog_state_switch_iclogs(log, iclog, 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
