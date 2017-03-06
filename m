Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34537 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbdCFNqH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 08:46:07 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 7/7] jbd2: make the whole kjournald2 kthread NOFS safe
Date: Mon,  6 Mar 2017 14:14:08 +0100
Message-Id: <20170306131408.9828-8-mhocko@kernel.org>
In-Reply-To: <20170306131408.9828-1-mhocko@kernel.org>
References: <20170306131408.9828-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

From: Michal Hocko <mhocko@suse.com>

kjournald2 is central to the transaction commit processing. As such any
potential allocation from this kernel thread has to be GFP_NOFS. Make
sure to mark the whole kernel thread GFP_NOFS by the memalloc_nofs_save.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/jbd2/journal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index a1a359bfcc9c..78433ce1db40 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -43,6 +43,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bitops.h>
 #include <linux/ratelimit.h>
+#include <linux/sched/mm.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/jbd2.h>
@@ -206,6 +207,13 @@ static int kjournald2(void *arg)
 	wake_up(&journal->j_wait_done_commit);
 
 	/*
+	 * Make sure that no allocations from this kernel thread will ever recurse
+	 * to the fs layer because we are responsible for the transaction commit
+	 * and any fs involvement might get stuck waiting for the trasn. commit.
+	 */
+	memalloc_nofs_save();
+
+	/*
 	 * And now, wait forever for commit wakeup events.
 	 */
 	write_lock(&journal->j_state_lock);
-- 
2.11.0

