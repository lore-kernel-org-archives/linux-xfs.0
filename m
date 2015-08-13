Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2FB0B29DF6
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 18:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A2D8AC002
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 16:24:05 -0700 (PDT)
Received: from mail-yk0-f177.google.com (mail-yk0-f177.google.com
	[209.85.160.177]) by cuda.sgi.com with ESMTP id
	YxmjD7iJ13FAsZy1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 16:24:03 -0700 (PDT)
Received: by ykaz130 with SMTP id z130so55405410yka.0
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 16:24:02 -0700 (PDT)
Date: Thu, 13 Aug 2015 19:24:00 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: generic/04[89] fail on XFS due to change in writeback code
	[4.2-rc1 regression]
Message-ID: <20150813232400.GH4496@mtj.duckdns.org>
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
To: Eryu Guan <eguan@redhat.com>
Cc: axboe@fb.com, jack@suse.cz, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hello, Eryu.

Can you please do the followings?

1. See if the "writeback: fix syncing of I_DIRTY_TIME inodes" patch
   changes anything.

2. If not, apply this patch.  This patch *should* make the failures go
   away and might print out some error messages along with stack
   trace.  Can you please verify that the failures go away with this
   patch and report the kernel messages if any trigger?

Thanks a lot.

Index: work/fs/fs-writeback.c
===================================================================
--- work.orig/fs/fs-writeback.c
+++ work/fs/fs-writeback.c
@@ -103,7 +103,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(wbc_writepa
 
 static bool wb_io_lists_populated(struct bdi_writeback *wb)
 {
-	if (wb_has_dirty_io(wb)) {
+	if (test_bit(WB_has_dirty_io, &wb->state)) {
 		return false;
 	} else {
 		set_bit(WB_has_dirty_io, &wb->state);
@@ -844,14 +844,13 @@ static void bdi_split_work_to_wbs(struct
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
+		if (!wb_has_dirty_io(wb) && base_work->sync_mode == WB_SYNC_NONE)
+			continue;
+		if (skip_if_busy && writeback_in_progress(wb))
 			continue;
 
 		base_work->nr_pages = wb_split_bdi_pages(wb, nr_pages);
@@ -899,8 +898,7 @@ static void bdi_split_work_to_wbs(struct
 {
 	might_sleep();
 
-	if (bdi_has_dirty_io(bdi) &&
-	    (!skip_if_busy || !writeback_in_progress(&bdi->wb))) {
+	if (!skip_if_busy || !writeback_in_progress(&bdi->wb)) {
 		base_work->auto_free = 0;
 		base_work->single_wait = 0;
 		base_work->single_done = 0;
@@ -2275,8 +2273,8 @@ void sync_inodes_sb(struct super_block *
 	};
 	struct backing_dev_info *bdi = sb->s_bdi;
 
-	/* Nothing to do? */
-	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
+	/* bdi_has_dirty() ignores I_DIRTY_TIME but we can't, always kick wbs */
+	if (bdi == &noop_backing_dev_info)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
Index: work/include/linux/backing-dev.h
===================================================================
--- work.orig/include/linux/backing-dev.h
+++ work/include/linux/backing-dev.h
@@ -38,7 +38,17 @@ extern struct workqueue_struct *bdi_wq;
 
 static inline bool wb_has_dirty_io(struct bdi_writeback *wb)
 {
-	return test_bit(WB_has_dirty_io, &wb->state);
+	bool ret = test_bit(WB_has_dirty_io, &wb->state);
+
+	if (!ret && (!list_empty(&wb->b_dirty) || !list_empty(&wb->b_io) ||
+		     !list_empty(&wb->b_more_io))) {
+		const char *name = wb->bdi->dev ? dev_name(wb->bdi->dev) : "UNK";
+
+		pr_err("wb_has_dirty_io: ERR %s has_dirty=%d b_dirty=%d b_io=%d b_more_io=%d\n",
+		       name, ret, !list_empty(&wb->b_dirty), !list_empty(&wb->b_io), !list_empty(&wb->b_more_io));
+		WARN_ON(1);
+	}
+	return ret;
 }
 
 static inline bool bdi_has_dirty_io(struct backing_dev_info *bdi)
@@ -47,7 +57,18 @@ static inline bool bdi_has_dirty_io(stru
 	 * @bdi->tot_write_bandwidth is guaranteed to be > 0 if there are
 	 * any dirty wbs.  See wb_update_write_bandwidth().
 	 */
-	return atomic_long_read(&bdi->tot_write_bandwidth);
+	bool ret = atomic_long_read(&bdi->tot_write_bandwidth);
+
+	if (ret != wb_has_dirty_io(&bdi->wb)) {
+		const char *name = bdi->dev ? dev_name(bdi->dev) : "UNK";
+
+		pr_err("bdi_has_dirty_io: ERR %s tot_write_bw=%ld b_dirty=%d b_io=%d b_more_io=%d\n",
+		       name, atomic_long_read(&bdi->tot_write_bandwidth),
+		       !list_empty(&bdi->wb.b_dirty), !list_empty(&bdi->wb.b_io), !list_empty(&bdi->wb.b_more_io));
+		WARN_ON(1);
+	}
+
+	return ret;
 }
 
 static inline void __add_wb_stat(struct bdi_writeback *wb,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
