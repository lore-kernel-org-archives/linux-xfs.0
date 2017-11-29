Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752838AbdK2XYL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:11 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 08/11] ext4: remove not needed freezing calls
Date: Wed, 29 Nov 2017 15:23:53 -0800
Message-Id: <20171129232356.28296-9-mcgrof@kernel.org>
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
 fs/ext4/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 57a8fa451d3e..8a510b1c2d92 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2980,8 +2980,6 @@ static int ext4_lazyinit_thread(void *arg)
 		}
 		mutex_unlock(&eli->li_list_mtx);
 
-		try_to_freeze();
-
 		cur = jiffies;
 		if ((time_after_eq(cur, next_wakeup)) ||
 		    (MAX_JIFFY_OFFSET == next_wakeup)) {
-- 
2.15.0

