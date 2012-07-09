Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q69Ig8Z0000778 for <xfs@oss.sgi.com>; Mon, 9 Jul 2012 13:42:08 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id nOo44waSeWRVf0b1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Jul 2012 11:42:07 -0700 (PDT)
Received: by yhp26 with SMTP id 26so14141288yhp.26
	for <xfs@oss.sgi.com>; Mon, 09 Jul 2012 11:42:07 -0700 (PDT)
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] workqueue: don't use WQ_HIGHPRI for unbound workqueues
Date: Mon,  9 Jul 2012 11:41:50 -0700
Message-Id: <1341859315-17759-2-git-send-email-tj@kernel.org>
In-Reply-To: <1341859315-17759-1-git-send-email-tj@kernel.org>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
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
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, Tejun Heo <tj@kernel.org>, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Unbound wqs aren't concurrency-managed and try to execute work items
as soon as possible.  This is currently achieved by implicitly setting
%WQ_HIGHPRI on all unbound workqueues; however, WQ_HIGHPRI
implementation is about to be restructured and this usage won't be
valid anymore.

Add an explicit chain-wakeup path for unbound workqueues in
process_one_work() instead of piggy backing on %WQ_HIGHPRI.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9a3128d..27637c2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -580,6 +580,10 @@ static bool __need_more_worker(struct global_cwq *gcwq)
 /*
  * Need to wake up a worker?  Called from anything but currently
  * running workers.
+ *
+ * Note that, because unbound workers never contribute to nr_running, this
+ * function will always return %true for unbound gcwq as long as the
+ * worklist isn't empty.
  */
 static bool need_more_worker(struct global_cwq *gcwq)
 {
@@ -1867,6 +1871,13 @@ __acquires(&gcwq->lock)
 	if (unlikely(cpu_intensive))
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
+	/*
+	 * Unbound gcwq isn't concurrency managed and work items should be
+	 * executed ASAP.  Wake up another worker if necessary.
+	 */
+	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(gcwq))
+		wake_up_worker(gcwq);
+
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
@@ -2984,13 +2995,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (flags & WQ_MEM_RECLAIM)
 		flags |= WQ_RESCUER;
 
-	/*
-	 * Unbound workqueues aren't concurrency managed and should be
-	 * dispatched to workers immediately.
-	 */
-	if (flags & WQ_UNBOUND)
-		flags |= WQ_HIGHPRI;
-
 	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 
-- 
1.7.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
