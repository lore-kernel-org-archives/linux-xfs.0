Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D9FC87F6F
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 17:44:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C75188F8039
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 15:44:22 -0700 (PDT)
Received: from mail-yk0-f181.google.com (mail-yk0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	IbCtLLP9EXpvOqGe (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 15:44:18 -0700 (PDT)
Received: by ykaz130 with SMTP id z130so54740176yka.0
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 15:44:17 -0700 (PDT)
Date: Thu, 13 Aug 2015 18:44:15 -0400
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME inodes
Message-ID: <20150813224415.GG4496@mtj.duckdns.org>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150813004435.GN3902@dastard>
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
was too aggressive and made sync_inodes_sb() skip I_DIRTY_TIME inodes.
This patch fixes the breakage by

* Removing bdi_has_dirty_io() shortcut from bdi_split_work_to_wbs().
  The callers are already testing the condition.

* Removing bdi_has_dirty_io() shortcut from sync_inodes_sb() so that
  it always calls into bdi_split_work_to_wbs().

* Making bdi_split_work_to_wbs() consider the b_dirty_time list for
  WB_SYNC_ALL writebacks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
Cc: Ted Ts'o <tytso@google.com>
Cc: Jan Kara <jack@suse.com>
---
Hello,

So, this fixes I_DIRTY_TIME syncing problem for ext4 but AFAICS xfs
doesn't even use the generic inode metadata writeback path, so this
most likely won't do anything for the originally reported problem.
I'll post another patch for debugging.

Thanks.

 fs/fs-writeback.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

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
@@ -2275,8 +2275,8 @@ void sync_inodes_sb(struct super_block *
 	};
 	struct backing_dev_info *bdi = sb->s_bdi;
 
-	/* Nothing to do? */
-	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
+	/* bdi_has_dirty() ignores I_DIRTY_TIME but we can't, always kick wbs */
+	if (bdi == &noop_backing_dev_info)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
