Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05A6B7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:12:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E843730404E
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 11:11:57 -0700 (PDT)
Received: from mail-yk0-f178.google.com (mail-yk0-f178.google.com
	[209.85.160.178]) by cuda.sgi.com with ESMTP id
	0arlPr9I7NODKek8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 11:11:55 -0700 (PDT)
Received: by ykfw73 with SMTP id w73so164390065ykf.3
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 11:11:55 -0700 (PDT)
Date: Tue, 25 Aug 2015 14:11:52 -0400
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 block/for-linus] writeback: sync_inodes_sb() must write
	out I_DIRTY_TIME inodes and always call wait_sb_inodes()
Message-ID: <20150825181152.GA26785@mtj.duckdns.org>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150813224415.GG4496@mtj.duckdns.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
updated writeback path to avoid kicking writeback work items if there
are no inodes to be written out; unfortunately, the avoidance logic
was too aggressive and broke sync_inodes_sb().

* sync_inodes_sb() must write out I_DIRTY_TIME inodes but I_DIRTY_TIME
  inodes dont't contribute to bdi/wb_has_dirty_io() tests and were
  being skipped over.

* inodes are taken off wb->b_dirty/io/more_io lists after writeback
  starts on them.  sync_inodes_sb() skipping wait_sb_inodes() when
  bdi_has_dirty_io() breaks it by making it return while writebacks
  are in-flight.

This patch fixes the breakages by

* Removing bdi_has_dirty_io() shortcut from bdi_split_work_to_wbs().
  The callers are already testing the condition.

* Removing bdi_has_dirty_io() shortcut from sync_inodes_sb() so that
  it always calls into bdi_split_work_to_wbs() and wait_sb_inodes().

* Making bdi_split_work_to_wbs() consider the b_dirty_time list for
  WB_SYNC_ALL writebacks.

Kudos to Eryu, Dave and Jan for tracking down the issue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
Link: http://lkml.kernel.org/g/20150812101204.GE17933@dhcp-13-216.nay.redhat.com
Reported-and-bisected-by: Eryu Guan <eguan@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.com>
Cc: Ted Ts'o <tytso@google.com>
---
 fs/fs-writeback.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -844,14 +844,15 @@ static void bdi_split_work_to_wbs(struct
 	struct wb_iter iter;
 
 	might_sleep();
-
-	if (!bdi_has_dirty_io(bdi))
-		return;
 restart:
 	rcu_read_lock();
 	bdi_for_each_wb(wb, bdi, &iter, next_blkcg_id) {
-		if (!wb_has_dirty_io(wb) ||
-		    (skip_if_busy && writeback_in_progress(wb)))
+		/* SYNC_ALL writes out I_DIRTY_TIME too */
+		if (!wb_has_dirty_io(wb) &&
+		    (base_work->sync_mode == WB_SYNC_NONE ||
+		     list_empty(&wb->b_dirty_time)))
+			continue;
+		if (skip_if_busy && writeback_in_progress(wb))
 			continue;
 
 		base_work->nr_pages = wb_split_bdi_pages(wb, nr_pages);
@@ -899,8 +900,7 @@ static void bdi_split_work_to_wbs(struct
 {
 	might_sleep();
 
-	if (bdi_has_dirty_io(bdi) &&
-	    (!skip_if_busy || !writeback_in_progress(&bdi->wb))) {
+	if (!skip_if_busy || !writeback_in_progress(&bdi->wb)) {
 		base_work->auto_free = 0;
 		base_work->single_wait = 0;
 		base_work->single_done = 0;
@@ -2275,8 +2275,12 @@ void sync_inodes_sb(struct super_block *
 	};
 	struct backing_dev_info *bdi = sb->s_bdi;
 
-	/* Nothing to do? */
-	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
+	/*
+	 * Can't skip on !bdi_has_dirty() because we should wait for !dirty
+	 * inodes under writeback and I_DIRTY_TIME inodes ignored by
+	 * bdi_has_dirty() need to be written out too.
+	 */
+	if (bdi == &noop_backing_dev_info)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
