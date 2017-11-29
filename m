Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753320AbdK2XYP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:15 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 11/11] jfs: remove not needed freezing calls
Date: Wed, 29 Nov 2017 15:23:56 -0800
Message-Id: <20171129232356.28296-12-mcgrof@kernel.org>
In-Reply-To: <20171129232356.28296-1-mcgrof@kernel.org>
References: <20171129232356.28296-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

This removes superflous freezer calls as they are no longer needed
as the VFS now performs filesystem freezing/thaw if the filesystem has
support for it.

The following Coccinelle rule was used as follows:

spatch --sp-file fs-freeze-cleanup.cocci --in-place fs/$FS/

@ has_freeze_fs @
identifier super_ops;
expression freeze_op;
@@

struct super_operations super_ops = {
	.freeze_fs = freeze_op,
};

@ remove_set_freezable depends on has_freeze_fs @
expression time;
statement S, S2, S3;
expression task;
@@

(
-	set_freezable();
|
-	if (try_to_freeze())
-		continue;
|
-	try_to_freeze();
|
-	freezable_schedule();
+	schedule();
|
-	freezable_schedule_timeout(time);
+	schedule_timeout(time);
|
-	if (freezing(task)) { S }
|
-	if (freezing(task)) { S }
-	else
	{ S2 }
|
-	freezing(current)
)

Generated-by: Coccinelle SmPL
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/jfs/jfs_logmgr.c | 11 +++--------
 fs/jfs/jfs_txnmgr.c | 31 +++++++++----------------------
 2 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 0e5d412c0b01..fa5a95d8fba8 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2344,14 +2344,9 @@ int jfsIOWait(void *arg)
 			spin_lock_irq(&log_redrive_lock);
 		}
 
-		if (freezing(current)) {
-			spin_unlock_irq(&log_redrive_lock);
-			try_to_freeze();
-		} else {
-			set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock_irq(&log_redrive_lock);
-			schedule();
-		}
+		set_current_state(TASK_INTERRUPTIBLE);
+		spin_unlock_irq(&log_redrive_lock);
+		schedule();
 	} while (!kthread_should_stop());
 
 	jfs_info("jfsIOWait being killed!");
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 4d973524c887..a313300c4651 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2747,6 +2747,7 @@ int jfs_lazycommit(void *arg)
 	struct tblock *tblk;
 	unsigned long flags;
 	struct jfs_sb_info *sbi;
+	DECLARE_WAITQUEUE(wq, current);
 
 	do {
 		LAZY_LOCK(flags);
@@ -2793,19 +2794,11 @@ int jfs_lazycommit(void *arg)
 		}
 		/* In case a wakeup came while all threads were active */
 		jfs_commit_thread_waking = 0;
-
-		if (freezing(current)) {
-			LAZY_UNLOCK(flags);
-			try_to_freeze();
-		} else {
-			DECLARE_WAITQUEUE(wq, current);
-
-			add_wait_queue(&jfs_commit_thread_wait, &wq);
-			set_current_state(TASK_INTERRUPTIBLE);
-			LAZY_UNLOCK(flags);
-			schedule();
-			remove_wait_queue(&jfs_commit_thread_wait, &wq);
-		}
+		add_wait_queue(&jfs_commit_thread_wait, &wq);
+		set_current_state(TASK_INTERRUPTIBLE);
+		LAZY_UNLOCK(flags);
+		schedule();
+		remove_wait_queue(&jfs_commit_thread_wait, &wq);
 	} while (!kthread_should_stop());
 
 	if (!list_empty(&TxAnchor.unlock_queue))
@@ -2982,15 +2975,9 @@ int jfs_sync(void *arg)
 		}
 		/* Add anon_list2 back to anon_list */
 		list_splice_init(&TxAnchor.anon_list2, &TxAnchor.anon_list);
-
-		if (freezing(current)) {
-			TXN_UNLOCK();
-			try_to_freeze();
-		} else {
-			set_current_state(TASK_INTERRUPTIBLE);
-			TXN_UNLOCK();
-			schedule();
-		}
+		set_current_state(TASK_INTERRUPTIBLE);
+		TXN_UNLOCK();
+		schedule();
 	} while (!kthread_should_stop());
 
 	jfs_info("jfs_sync being killed");
-- 
2.15.0

