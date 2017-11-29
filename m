Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753252AbdK2XYJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:09 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 07/11] xfs: remove not needed freezing calls
Date: Wed, 29 Nov 2017 15:23:52 -0800
Message-Id: <20171129232356.28296-8-mcgrof@kernel.org>
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
 fs/xfs/xfs_trans_ail.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index cef89f7127d3..1f3dd10a9d00 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -513,7 +513,6 @@ xfsaild(
 	long		tout = 0;	/* milliseconds */
 
 	current->flags |= PF_MEMALLOC;
-	set_freezable();
 
 	while (1) {
 		if (tout && tout <= 20)
@@ -551,19 +550,17 @@ xfsaild(
 		if (!xfs_ail_min(ailp) &&
 		    ailp->xa_target == ailp->xa_target_prev) {
 			spin_unlock(&ailp->xa_lock);
-			freezable_schedule();
+			schedule();
 			tout = 0;
 			continue;
 		}
 		spin_unlock(&ailp->xa_lock);
 
 		if (tout)
-			freezable_schedule_timeout(msecs_to_jiffies(tout));
+			schedule_timeout(msecs_to_jiffies(tout));
 
 		__set_current_state(TASK_RUNNING);
 
-		try_to_freeze();
-
 		tout = xfsaild_push(ailp);
 	}
 
-- 
2.15.0

