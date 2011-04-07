Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p376GpIC080947 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 01:16:51 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 732BA1E0653A
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 23:20:07 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eEtEnae947EvAnGL for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 23:20:07 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] bdi: mark the bdi flusher busy when being forked
Date: Thu,  7 Apr 2011 16:19:55 +1000
Message-Id: <1302157196-1988-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1302157196-1988-1-git-send-email-david@fromorbit.com>
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Recetn attempts to use writeback_inode_sb_nr_if_idle() in XFs from
memory reclaim context have caused deadlocks because memory reclaim
call be called from a failed allocation during forking a flusher
thread. The shrinker then attempts to trigger writeback and the bdi
is considered idle because writeback is not in progress yet and then
deadlocks because bdi_queue_work() blocks waiting for the
BDI_Pending bit to clear which will never happen because it needs
the fork to complete.

To avoid this deadlock, consider writeback to be in progress if the
flusher thread is being created. This prevents reclaim from blocking
waiting for it be forked and hence avoids the deadlock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b5ed541..64e2aba 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -62,11 +62,14 @@ int nr_pdflush_threads;
  * @bdi: the device's backing_dev_info structure.
  *
  * Determine whether there is writeback waiting to be handled against a
- * backing device.
+ * backing device. If the flusher thread is being created, then writeback is in
+ * the process of being started, so indicate that it writeback is not idle at
+ * this point in time.
  */
 int writeback_in_progress(struct backing_dev_info *bdi)
 {
-	return test_bit(BDI_writeback_running, &bdi->state);
+	return test_bit(BDI_writeback_running, &bdi->state) ||
+		test_bit(BDI_pending, &bdi->state);
 }
 
 static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
