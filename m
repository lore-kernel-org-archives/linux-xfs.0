Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36008 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbdBFOHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 09:07:37 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 6/6] jbd2: make the whole kjournald2 kthread NOFS safe
Date: Mon,  6 Feb 2017 15:07:18 +0100
Message-Id: <20170206140718.16222-7-mhocko@kernel.org>
In-Reply-To: <20170206140718.16222-1-mhocko@kernel.org>
References: <20170206140718.16222-1-mhocko@kernel.org>
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
 fs/jbd2/journal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 704139625fbe..662531a70ce1 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -206,6 +206,13 @@ static int kjournald2(void *arg)
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

