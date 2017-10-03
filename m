Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbdJCSxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 14:53:22 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 3/5] xfs: allow fs freeze on suspend/hibernation
Date: Tue,  3 Oct 2017 11:53:11 -0700
Message-Id: <20171003185313.1017-4-mcgrof@kernel.org>
In-Reply-To: <20171003185313.1017-1-mcgrof@kernel.org>
References: <20171003185313.1017-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

This also removes the freezer calls on the XFS kthread as they are
no longer needed.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/xfs/xfs_super.c     | 3 ++-
 fs/xfs/xfs_trans_ail.c | 7 ++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 64013b2db8e0..75c3415657eb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1775,7 +1775,8 @@ static struct file_system_type xfs_fs_type = {
 	.name			= "xfs",
 	.mount			= xfs_fs_mount,
 	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV |
+				  FS_FREEZE_ON_SUSPEND,
 };
 MODULE_ALIAS_FS("xfs");
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 354368a906e5..8cebda88e91a 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -512,7 +512,6 @@ xfsaild(
 	long		tout = 0;	/* milliseconds */
 
 	current->flags |= PF_MEMALLOC;
-	set_freezable();
 
 	while (!kthread_should_stop()) {
 		if (tout && tout <= 20)
@@ -535,19 +534,17 @@ xfsaild(
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
2.14.0

