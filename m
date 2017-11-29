Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753255AbdK2XYM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:12 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 09/11] f2fs: remove not needed freezing calls
Date: Wed, 29 Nov 2017 15:23:54 -0800
Message-Id: <20171129232356.28296-10-mcgrof@kernel.org>
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
 fs/f2fs/gc.c      | 5 +----
 fs/f2fs/segment.c | 6 +-----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index d844dcb80570..1032d6aa1756 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -32,10 +32,9 @@ static int gc_thread_func(void *data)
 
 	wait_ms = gc_th->min_sleep_time;
 
-	set_freezable();
 	do {
 		wait_event_interruptible_timeout(*wq,
-				kthread_should_stop() || freezing(current) ||
+				kthread_should_stop() ||
 				gc_th->gc_wake,
 				msecs_to_jiffies(wait_ms));
 
@@ -43,8 +42,6 @@ static int gc_thread_func(void *data)
 		if (gc_th->gc_wake)
 			gc_th->gc_wake = 0;
 
-		if (try_to_freeze())
-			continue;
 		if (kthread_should_stop())
 			break;
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c117e0913f2a..a55e456e67ee 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1382,18 +1382,14 @@ static int issue_discard_thread(void *data)
 	unsigned int wait_ms = DEF_MIN_DISCARD_ISSUE_TIME;
 	int issued;
 
-	set_freezable();
-
 	do {
 		init_discard_policy(&dpolicy, DPOLICY_BG,
 					dcc->discard_granularity);
 
 		wait_event_interruptible_timeout(*q,
-				kthread_should_stop() || freezing(current) ||
+				kthread_should_stop() ||
 				dcc->discard_wake,
 				msecs_to_jiffies(wait_ms));
-		if (try_to_freeze())
-			continue;
 		if (kthread_should_stop())
 			return 0;
 
-- 
2.15.0

