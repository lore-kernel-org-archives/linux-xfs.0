Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7868D7F3F
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08254AC008
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:05 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ipepvnoxMI0FuC5W (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2 RESEND] bdi: Fix hung task on sync
Date: Fri, 10 Oct 2014 16:23:06 +0200
Message-Id: <1412951028-4085-2-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, Derek Basehore <dbasehore@chromium.org>, reiserfs-devel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

From: Derek Basehore <dbasehore@chromium.org>

bdi_wakeup_thread_delayed() used the mod_delayed_work() function to
schedule work to writeback dirty inodes. The problem with this is that
it can delay work that is scheduled for immediate execution, such as the
work from sync_inodes_sb().  This can happen since mod_delayed_work()
can now steal work from a work_queue.  This fixes the problem by using
queue_delayed_work() instead. This is a regression caused by
839a8e8660b6 "writeback: replace custom worker pool implementation with
unbound workqueue".

The reason that this causes a problem is that laptop-mode will change
the delay, dirty_writeback_centisecs, to 60000 (10 minutes) by default.
In the case that bdi_wakeup_thread_delayed() races with
sync_inodes_sb(), sync will be stopped for 10 minutes and trigger a hung
task. Even if dirty_writeback_centisecs is not long enough to cause a
hung task, we still don't want to delay sync for that long.

We fix the problem by using queue_delayed_work() when we want to
schedule writeback sometime in future. This function doesn't change the
timer if it is already armed.

For the same reason, we also change bdi_writeback_workfn() to
immediately queue the work again in the case that the work_list is not
empty. The same problem can happen if the sync work is run on the rescue
worker.

Fixes: 839a8e8660b6777e7fe4e80af1a048aebe2b5977
CC: stable@vger.kernel.org
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 8 ++++----
 mm/backing-dev.c  | 5 ++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e0259a163f98..8277b76be983 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1047,10 +1047,10 @@ void bdi_writeback_workfn(struct work_struct *work)
 		trace_writeback_pages_written(pages_written);
 	}
 
-	if (!list_empty(&bdi->work_list) ||
-	    (wb_has_dirty_io(wb) && dirty_writeback_interval))
-		queue_delayed_work(bdi_wq, &wb->dwork,
-			msecs_to_jiffies(dirty_writeback_interval * 10));
+	if (!list_empty(&bdi->work_list))
+		mod_delayed_work(bdi_wq, &wb->dwork, 0);
+	else if (wb_has_dirty_io(wb) && dirty_writeback_interval)
+		bdi_wakeup_thread_delayed(bdi);
 
 	current->flags &= ~PF_SWAPWRITE;
 }
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ce682f7a4f29..fab8401fc54e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -288,13 +288,16 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi)
  * Note, we wouldn't bother setting up the timer, but this function is on the
  * fast-path (used by '__mark_inode_dirty()'), so we save few context switches
  * by delaying the wake-up.
+ *
+ * We have to be careful not to postpone flush work if it is scheduled for
+ * earlier. Thus we use queue_delayed_work().
  */
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 {
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
 }
 
 /*
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
