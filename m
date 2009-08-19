Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JIiOTZ221129 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 13:44:39 -0500
Message-Id: <20090819184512.452411477@bombadil.infradead.org>
Date: Wed, 19 Aug 2009 14:43:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: fix spin_is_locked assert on uni-processor builds
References: <20090819184258.542698202@bombadil.infradead.org>
Content-Disposition: inline; filename=fix-spin_is_locked-assert
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

xfs: fix spin_is_locked assert on uni-processor builds
   
Without SMP or preemption spin_is_locked always returns false,
so we can't do an assert with it.  Instead use assert_spin_locked,
which does the right thing on all builds.


upstream commit a8914f3a6d72c97328597a556a99daaf5cc288ae
    
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reported-by: Johannes Engel <jcnengel@googlemail.com>
Tested-by: Johannes Engel <jcnengel@googlemail.com>
Signed-off-by: Felix Blyakher <felixb@sgi.com>

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3750f04..9dbdff3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
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
