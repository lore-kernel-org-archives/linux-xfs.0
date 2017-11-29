Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753293AbdK2XYN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:13 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 10/11] nilfs2: remove not needed freezing calls
Date: Wed, 29 Nov 2017 15:23:55 -0800
Message-Id: <20171129232356.28296-11-mcgrof@kernel.org>
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
 fs/nilfs2/segment.c | 48 ++++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9f3ffba41533..407e12a60145 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2543,6 +2543,8 @@ static int nilfs_segctor_thread(void *arg)
 	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
+	DEFINE_WAIT(wait);
+	int should_sleep = 1;
 
 	sci->sc_timer_task = current;
 
@@ -2574,38 +2576,28 @@ static int nilfs_segctor_thread(void *arg)
 		timeout = 0;
 	}
 
+	prepare_to_wait(&sci->sc_wait_daemon, &wait,
+			TASK_INTERRUPTIBLE);
 
-	if (freezing(current)) {
+	if (sci->sc_seq_request != sci->sc_seq_done)
+		should_sleep = 0;
+	else if (sci->sc_flush_request)
+		should_sleep = 0;
+	else if (sci->sc_state & NILFS_SEGCTOR_COMMIT)
+		should_sleep = time_before(jiffies,
+				sci->sc_timer.expires);
+
+	if (should_sleep) {
 		spin_unlock(&sci->sc_state_lock);
-		try_to_freeze();
+		schedule();
 		spin_lock(&sci->sc_state_lock);
-	} else {
-		DEFINE_WAIT(wait);
-		int should_sleep = 1;
-
-		prepare_to_wait(&sci->sc_wait_daemon, &wait,
-				TASK_INTERRUPTIBLE);
-
-		if (sci->sc_seq_request != sci->sc_seq_done)
-			should_sleep = 0;
-		else if (sci->sc_flush_request)
-			should_sleep = 0;
-		else if (sci->sc_state & NILFS_SEGCTOR_COMMIT)
-			should_sleep = time_before(jiffies,
-					sci->sc_timer.expires);
-
-		if (should_sleep) {
-			spin_unlock(&sci->sc_state_lock);
-			schedule();
-			spin_lock(&sci->sc_state_lock);
-		}
-		finish_wait(&sci->sc_wait_daemon, &wait);
-		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
-			   time_after_eq(jiffies, sci->sc_timer.expires));
-
-		if (nilfs_sb_dirty(nilfs) && nilfs_sb_need_update(nilfs))
-			set_nilfs_discontinued(nilfs);
 	}
+	finish_wait(&sci->sc_wait_daemon, &wait);
+	timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
+		   time_after_eq(jiffies, sci->sc_timer.expires));
+
+	if (nilfs_sb_dirty(nilfs) && nilfs_sb_need_update(nilfs))
+		set_nilfs_discontinued(nilfs);
 	goto loop;
 
  end_thread:
-- 
2.15.0

