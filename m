Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A8307F8E
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 89B168F8059
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vuqvm4NmTi0EQULC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:11 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2 RESEND] bdi: Avoid oops on device removal
Date: Fri, 10 Oct 2014 16:23:43 +0200
Message-Id: <1412951028-4085-39-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

After 839a8e8660b67 "writeback: replace custom worker pool
implementation with unbound workqueue" when device is removed while we
are writing to it we crash in bdi_writeback_workfn() ->
set_worker_desc() because bdi->dev is NULL.  This can happen because
even though bdi_unregister() cancels all pending flushing work, nothing
really prevents new ones from being queued from balance_dirty_pages() or
other places.

Fix the problem by clearing BDI_registered bit in bdi_unregister() and
checking it before scheduling of any flushing work.

Fixes: 839a8e8660b6777e7fe4e80af1a048aebe2b5977
CC: stable@vger.kernel.org
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c           | 23 ++++++++++++++++++-----
 include/linux/backing-dev.h |  2 +-
 mm/backing-dev.c            | 13 +++++++++----
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8277b76be983..c24e7b8b521b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -94,16 +94,29 @@ static inline struct inode *wb_inode(struct list_head *head)
 #define CREATE_TRACE_POINTS
 #include <trace/events/writeback.h>
 
+static void bdi_wakeup_thread(struct backing_dev_info *bdi)
+{
+	spin_lock_bh(&bdi->wb_lock);
+	if (test_bit(BDI_registered, &bdi->state))
+		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+	spin_unlock_bh(&bdi->wb_lock);
+}
+
 static void bdi_queue_work(struct backing_dev_info *bdi,
 			   struct wb_writeback_work *work)
 {
 	trace_writeback_queue(bdi, work);
 
 	spin_lock_bh(&bdi->wb_lock);
+	if (!test_bit(BDI_registered, &bdi->state)) {
+		if (work->done)
+			complete(work->done);
+		goto out_unlock;
+	}
 	list_add_tail(&work->list, &bdi->work_list);
-	spin_unlock_bh(&bdi->wb_lock);
-
 	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+out_unlock:
+	spin_unlock_bh(&bdi->wb_lock);
 }
 
 static void
@@ -119,7 +132,7 @@ __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work) {
 		trace_writeback_nowork(bdi);
-		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+		bdi_wakeup_thread(bdi);
 		return;
 	}
 
@@ -166,7 +179,7 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
 	 * writeback as soon as there is no other work to do.
 	 */
 	trace_writeback_wake_background(bdi);
-	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+	bdi_wakeup_thread(bdi);
 }
 
 /*
@@ -1025,7 +1038,7 @@ void bdi_writeback_workfn(struct work_struct *work)
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
-		   list_empty(&bdi->bdi_list))) {
+		   !test_bit(BDI_registered, &bdi->state))) {
 		/*
 		 * The normal path.  Keep writing back @bdi until its
 		 * work_list is empty.  Note that this path is also taken
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 24819001f5c8..e488e9459a93 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -95,7 +95,7 @@ struct backing_dev_info {
 	unsigned int max_ratio, max_prop_frac;
 
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
-	spinlock_t wb_lock;	  /* protects work_list */
+	spinlock_t wb_lock;	  /* protects work_list & wb.dwork scheduling */
 
 	struct list_head work_list;
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index fab8401fc54e..09d9591b7708 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -297,7 +297,10 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	spin_lock_bh(&bdi->wb_lock);
+	if (test_bit(BDI_registered, &bdi->state))
+		queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	spin_unlock_bh(&bdi->wb_lock);
 }
 
 /*
@@ -310,9 +313,6 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
 	spin_unlock_bh(&bdi_lock);
 
 	synchronize_rcu_expedited();
-
-	/* bdi_list is now unused, clear it to mark @bdi dying */
-	INIT_LIST_HEAD(&bdi->bdi_list);
 }
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
@@ -363,6 +363,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 */
 	bdi_remove_from_list(bdi);
 
+	/* Make sure nobody queues further work */
+	spin_lock_bh(&bdi->wb_lock);
+	clear_bit(BDI_registered, &bdi->state);
+	spin_unlock_bh(&bdi->wb_lock);
+
 	/*
 	 * Drain work list and shutdown the delayed_work.  At this point,
 	 * @bdi->bdi_list is empty telling bdi_Writeback_workfn() that @bdi
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
