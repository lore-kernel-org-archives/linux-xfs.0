Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A9DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiLaAb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiLaAb1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:31:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27F513F7A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 504C261C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D1BC433D2;
        Sat, 31 Dec 2022 00:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446684;
        bh=/yurlxQvca5VkMAHfMDWHA1r+pnabDaQ8+FDxjSmpfY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QQpmHYqh1kgL1+9yvJEXMmqJt4onqGFrZTVgXEUGFKlPz+H53GAR1B3hWgJLfEclK
         i4hJX/d/G07vUPbFo/1UB6icpeYcjvPbn3ZHYZDioX0VgrWAq0FIjQ27EKTPN//RRg
         td7Bu+ChxK0/yQ74IZQ6KR8so7KB3PRTq5JfIMpnJmvsaV6Sgn2bbIHySEQ0PpZLwe
         jX5c3jxS6IYBy7j4EpCeJD30s6UzLM7JkWZm/IEameg7M9QGDhRbpHVLGjCCfR8TtR
         RdyQIKgzZwh6XCEYYjFL198soZkqaGxf9dI3o35um8i+Db4czjJrRTglkQbxwNp4fN
         81t9sgtMIRBJQ==
Subject: [PATCH 2/4] xfs_scrub: improve thread scheduling repair items during
 phase 4
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870456.716640.1706451255732465904.stgit@magnolia>
In-Reply-To: <167243870430.716640.15368107413813691968.stgit@magnolia>
References: <167243870430.716640.15368107413813691968.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As it stands, xfs_scrub doesn't do a good job of scheduling repair items
during phase 4.  The repair lists are sharded by AG, and one repair
worker is started for each per-AG repair list.  Consequently, if one AG
requires considerably more work than the others (e.g. inodes are not
spread evenly among the AGs) then phase 4 can stall waiting for that one
worker thread when there's still plenty of CPU power available.

While our initial assumptions were that repairs would be vanishingly
scarce, the reality is that "repairs" can be triggered for optimizations
like gaps in the xattr structures, or clearing the inode reflink flag on
inodes that no longer share data.  In real world testing scenarios, the
lack of balance leads to complaints about excessive runtime of
xfs_scrub.

To fix these balance problems, we replace the per-AG repair item lists
in the scrub context with a single repair item list.  Phase 4 will be
redesigned as follows:

The repair worker will grab a repair item from the main list, try to
repair it, record whether the repair attempt made any progress, and
requeue the item if it was not fully fixed.  A separate repair scheduler
function starts the repair workers, and waits for them all to complete.
Requeued repairs are merged back into the main repair list.  If we made
any forward progress, we'll start another round of repairs with the
repair workers.  Phase 4 retains the behavior that if the pool stops
making forward progress, it will try all the repairs one last time,
serially.

To facilitate this new design, phase 2 will queue repairs of space
metadata items directly to the main list.  Phase 3's worker threads will
queue repair items to per-thread lists and splice those lists into the
main list at the end.

On a filesystem crafted to put all the inodes in a single AG, this
restores xfs_scrub's ability to parallelize repairs.  There seems to be
a slight performance hit for the evenly-spread case, but avoiding a
performance cliff due to an unbalanced fs is more important here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/list.h    |   14 +++
 scrub/phase1.c    |    8 +-
 scrub/phase2.c    |   23 +++++
 scrub/phase3.c    |  106 ++++++++++++++++---------
 scrub/phase4.c    |  226 ++++++++++++++++++++++++++++++++++++++---------------
 scrub/repair.c    |  135 +++++++++++++++++---------------
 scrub/repair.h    |   37 +++++++--
 scrub/xfs_scrub.h |    2 
 8 files changed, 377 insertions(+), 174 deletions(-)


diff --git a/include/list.h b/include/list.h
index dab4e23bd10..b1e2d49c8f3 100644
--- a/include/list.h
+++ b/include/list.h
@@ -152,6 +152,20 @@ static inline void list_splice_init(struct list_head *list,
 #define list_first_entry(ptr, type, member) \
 	list_entry((ptr)->next, type, member)
 
+/**
+ * list_first_entry_or_null - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_first_entry_or_null(ptr, type, member) ({ \
+	struct list_head *head__ = (ptr); \
+	struct list_head *pos__ = head__->next; \
+	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
+})
+
 #define container_of(ptr, type, member) ({			\
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 18b1d5e948e..6ad012042da 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -89,7 +89,8 @@ scrub_cleanup(
 	if (error)
 		return error;
 
-	action_lists_free(&ctx->action_lists);
+	action_list_free(&ctx->action_list);
+
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
 	if (ctx->rtdev)
@@ -185,10 +186,9 @@ _("Not an XFS filesystem."));
 		return error;
 	}
 
-	error = action_lists_alloc(ctx->mnt.fsgeom.agcount,
-			&ctx->action_lists);
+	error = action_list_alloc(&ctx->action_list);
 	if (error) {
-		str_liberror(ctx, error, _("allocating action lists"));
+		str_liberror(ctx, error, _("allocating repair list"));
 		return error;
 	}
 
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 7b580f4e4dd..e07f7a11be5 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -50,6 +50,25 @@ warn_repair_difficulties(
 	str_info(ctx, descr, _("Filesystem might not be repairable."));
 }
 
+/* Add a scrub item that needs more work to fs metadata repair list. */
+static int
+defer_fs_repair(
+	struct scrub_ctx	*ctx,
+	const struct scrub_item	*sri)
+{
+	struct action_item	*aitem = NULL;
+	int			error;
+
+	error = repair_item_to_action_item(ctx, sri, &aitem);
+	if (error || !aitem)
+		return error;
+
+	pthread_mutex_lock(&ctx->lock);
+	action_list_add(ctx->action_list, aitem);
+	pthread_mutex_unlock(&ctx->lock);
+	return 0;
+}
+
 /* Scrub each AG's metadata btrees. */
 static void
 scan_ag_metadata(
@@ -108,7 +127,7 @@ scan_ag_metadata(
 		goto err;
 
 	/* Everything else gets fixed during phase 4. */
-	ret = repair_item_defer(ctx, &sri);
+	ret = defer_fs_repair(ctx, &sri);
 	if (ret)
 		goto err;
 	return;
@@ -144,7 +163,7 @@ scan_metafile(
 	difficulty = repair_item_difficulty(&sri);
 	warn_repair_difficulties(ctx, difficulty, xfrog_scrubbers[type].descr);
 
-	ret = repair_item_defer(ctx, &sri);
+	ret = defer_fs_repair(ctx, &sri);
 	if (ret) {
 		sctl->aborted = true;
 		goto out;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 06a338480e7..e000d8fe4c5 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -10,6 +10,7 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/ptvar.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "counter.h"
@@ -26,8 +27,8 @@ struct scrub_inode_ctx {
 	/* Number of inodes scanned. */
 	struct ptcounter	*icount;
 
-	/* per-AG locks to protect the repair lists */
-	pthread_mutex_t		*locks;
+	/* Per-thread lists of file repair items. */
+	struct ptvar		*repair_ptlists;
 
 	/* Set to true to abort all threads. */
 	bool			aborted;
@@ -51,28 +52,28 @@ report_close_error(
 	str_errno(ctx, descr);
 }
 
-/*
- * Defer all the repairs until phase 4, being careful about locking since the
- * inode scrub threads are not per-AG.
- */
+/* Defer all the repairs until phase 4. */
 static int
 defer_inode_repair(
 	struct scrub_inode_ctx		*ictx,
-	const struct xfs_bulkstat	*bstat,
-	struct scrub_item		*sri)
+	const struct scrub_item		*sri)
 {
+	struct action_list		*alist;
 	struct action_item		*aitem = NULL;
-	xfs_agnumber_t			agno;
 	int				ret;
 
 	ret = repair_item_to_action_item(ictx->ctx, sri, &aitem);
 	if (ret || !aitem)
 		return ret;
 
-	agno = cvt_ino_to_agno(&ictx->ctx->mnt, bstat->bs_ino);
-	pthread_mutex_lock(&ictx->locks[agno]);
-	action_list_add(&ictx->ctx->action_lists[agno], aitem);
-	pthread_mutex_unlock(&ictx->locks[agno]);
+	alist = ptvar_get(ictx->repair_ptlists, &ret);
+	if (ret) {
+		str_liberror(ictx->ctx, ret,
+ _("getting per-thread inode repair list"));
+		return ret;
+	}
+
+	action_list_add(alist, aitem);
 	return 0;
 }
 
@@ -81,8 +82,7 @@ static int
 try_inode_repair(
 	struct scrub_inode_ctx		*ictx,
 	struct scrub_item		*sri,
-	int				fd,
-	const struct xfs_bulkstat	*bstat)
+	int				fd)
 {
 	/*
 	 * If at the start of phase 3 we already had ag/rt metadata repairs
@@ -149,7 +149,7 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	error = try_inode_repair(ictx, &sri, fd, bstat);
+	error = try_inode_repair(ictx, &sri, fd);
 	if (error)
 		goto out;
 
@@ -161,7 +161,7 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	error = try_inode_repair(ictx, &sri, fd, bstat);
+	error = try_inode_repair(ictx, &sri, fd);
 	if (error)
 		goto out;
 
@@ -178,7 +178,7 @@ scrub_inode(
 		goto out;
 
 	/* Try to repair the file while it's open. */
-	error = try_inode_repair(ictx, &sri, fd, bstat);
+	error = try_inode_repair(ictx, &sri, fd);
 	if (error)
 		goto out;
 
@@ -195,7 +195,7 @@ scrub_inode(
 	progress_add(1);
 
 	if (!error && !ictx->aborted)
-		error = defer_inode_repair(ictx, bstat, &sri);
+		error = defer_inode_repair(ictx, &sri);
 
 	if (fd >= 0) {
 		int	err2;
@@ -212,6 +212,33 @@ scrub_inode(
 	return error;
 }
 
+/*
+ * Collect all the inode repairs in the file repair list.  No need for locks
+ * here, since we're single-threaded.
+ */
+static int
+collect_repairs(
+	struct ptvar		*ptv,
+	void			*data,
+	void			*foreach_arg)
+{
+	struct scrub_ctx	*ctx = foreach_arg;
+	struct action_list	*alist = data;
+
+	action_list_merge(ctx->action_list, alist);
+	return 0;
+}
+
+/* Initialize this per-thread file repair item list. */
+static void
+action_ptlist_init(
+	void			*priv)
+{
+	struct action_list	*alist = priv;
+
+	action_list_init(alist);
+}
+
 /* Verify all the inodes in a filesystem. */
 int
 phase3_func(
@@ -222,17 +249,18 @@ phase3_func(
 	xfs_agnumber_t		agno;
 	int			err;
 
+	err = -ptvar_alloc(scrub_nproc(ctx), sizeof(struct action_list),
+			action_ptlist_init, &ictx.repair_ptlists);
+	if (err) {
+		str_liberror(ctx, err,
+	_("creating per-thread file repair item lists"));
+		return err;
+	}
+
 	err = ptcounter_alloc(scrub_nproc(ctx), &ictx.icount);
 	if (err) {
 		str_liberror(ctx, err, _("creating scanned inode counter"));
-		return err;
-	}
-
-	ictx.locks = calloc(ctx->mnt.fsgeom.agcount, sizeof(pthread_mutex_t));
-	if (!ictx.locks) {
-		str_errno(ctx, _("creating per-AG repair list locks"));
-		err = ENOMEM;
-		goto out_ptcounter;
+		goto out_ptvar;
 	}
 
 	/*
@@ -241,9 +269,7 @@ phase3_func(
 	 * to repair the space metadata.
 	 */
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		pthread_mutex_init(&ictx.locks[agno], NULL);
-
-		if (!action_list_empty(&ctx->action_lists[agno]))
+		if (!action_list_empty(ctx->action_list))
 			ictx.always_defer_repairs = true;
 	}
 
@@ -251,22 +277,30 @@ phase3_func(
 	if (!err && ictx.aborted)
 		err = ECANCELED;
 	if (err)
-		goto out_locks;
+		goto out_ptcounter;
+
+	/*
+	 * Combine all of the file repair items into the main repair list.
+	 * We don't need locks here since we're the only thread running now.
+	 */
+	err = -ptvar_foreach(ictx.repair_ptlists, collect_repairs, ctx);
+	if (err) {
+		str_liberror(ctx, err, _("collecting inode repair lists"));
+		goto out_ptcounter;
+	}
 
 	scrub_report_preen_triggers(ctx);
 	err = ptcounter_value(ictx.icount, &val);
 	if (err) {
 		str_liberror(ctx, err, _("summing scanned inode counter"));
-		goto out_locks;
+		goto out_ptcounter;
 	}
 
 	ctx->inodes_checked = val;
-out_locks:
-	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
-		pthread_mutex_destroy(&ictx.locks[agno]);
-	free(ictx.locks);
 out_ptcounter:
 	ptcounter_free(ictx.icount);
+out_ptvar:
+	ptvar_free(ictx.repair_ptlists);
 	return err;
 }
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index aa0b060fcc9..5563c4c5b0b 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -17,57 +17,166 @@
 #include "scrub.h"
 #include "repair.h"
 #include "vfs.h"
+#include "atomic.h"
 
 /* Phase 4: Repair filesystem. */
 
-/* Fix all the problems in our per-AG list. */
+struct repair_list_schedule {
+	struct action_list		*repair_list;
+
+	/* Action items that we could not resolve and want to try again. */
+	struct action_list		requeue_list;
+
+	pthread_mutex_t			lock;
+
+	/* Workers use this to signal the scheduler when all work is done. */
+	pthread_cond_t			done;
+
+	/* Number of workers that are still running. */
+	unsigned int			workers;
+
+	/* Or should we all abort? */
+	bool				aborted;
+
+	/* Did we make any progress this round? */
+	bool				made_progress;
+};
+
+/* Try to repair as many things on our list as we can. */
 static void
-repair_ag(
+repair_list_worker(
 	struct workqueue		*wq,
 	xfs_agnumber_t			agno,
 	void				*priv)
 {
+	struct repair_list_schedule	*rls = priv;
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*aborted = priv;
-	struct action_list		*alist;
-	unsigned long long		unfixed;
-	unsigned long long		new_unfixed;
-	unsigned int			flags = 0;
-	int				ret;
-
-	alist = &ctx->action_lists[agno];
-	unfixed = action_list_length(alist);
-
-	/* Repair anything broken until we fail to make progress. */
-	do {
-		ret = action_list_process(ctx, alist, flags);
+
+	pthread_mutex_lock(&rls->lock);
+	while (!rls->aborted) {
+		struct action_item	*aitem;
+		enum tryrepair_outcome	outcome;
+		int			ret;
+
+		aitem = action_list_pop(rls->repair_list);
+		if (!aitem)
+			break;
+
+		pthread_mutex_unlock(&rls->lock);
+		ret = action_item_try_repair(ctx, aitem, &outcome);
+		pthread_mutex_lock(&rls->lock);
+
 		if (ret) {
-			*aborted = true;
-			return;
+			rls->aborted = true;
+			free(aitem);
+			break;
 		}
-		new_unfixed = action_list_length(alist);
-		if (new_unfixed == unfixed)
+
+		switch (outcome) {
+		case TR_REQUEUE:
+			/*
+			 * Partial progress.  Make a note of that and requeue
+			 * this item for the next round.
+			 */
+			rls->made_progress = true;
+			action_list_add(&rls->requeue_list, aitem);
+			break;
+		case TR_NOPROGRESS:
+			/*
+			 * No progress.  Requeue this item for a later round,
+			 * which could happen if something else makes progress.
+			 */
+			action_list_add(&rls->requeue_list, aitem);
 			break;
-		unfixed = new_unfixed;
-		if (*aborted)
-			return;
-	} while (unfixed > 0);
-
-	/* Try once more, but this time complain if we can't fix things. */
-	flags |= XRM_FINAL_WARNING;
-	ret = action_list_process(ctx, alist, flags);
-	if (ret)
-		*aborted = true;
+		case TR_REPAIRED:
+			/* Item is clean.  Free it. */
+			free(aitem);
+			break;
+		}
+	}
+
+	rls->workers--;
+	if (rls->workers == 0)
+		pthread_cond_broadcast(&rls->done);
+	pthread_mutex_unlock(&rls->lock);
+}
+
+/*
+ * Schedule repair list workers.  Returns 1 if we made progress, 0 if we
+ * did not, or -1 if we need to abort everything.
+ */
+static int
+repair_list_schedule(
+	struct scrub_ctx		*ctx,
+	struct workqueue		*wq,
+	struct action_list		*repair_list)
+{
+	struct repair_list_schedule	rls = {
+		.lock			= PTHREAD_MUTEX_INITIALIZER,
+		.done			= PTHREAD_COND_INITIALIZER,
+		.repair_list		= repair_list,
+	};
+	unsigned int			i;
+	unsigned int			nr_workers = scrub_nproc(ctx);
+	bool				made_any_progress = false;
+	int				ret = 0;
+
+	if (action_list_empty(repair_list))
+		return 0;
+
+	action_list_init(&rls.requeue_list);
+
+	/*
+	 * Use the workers to run through the entire repair list once.  Requeue
+	 * anything that did not make progress, and keep trying as long as the
+	 * workers made any kind of progress.
+	 */
+	do {
+		rls.made_progress = false;
+
+		/* Start all the worker threads. */
+		for (i = 0; i < nr_workers; i++) {
+			pthread_mutex_lock(&rls.lock);
+			rls.workers++;
+			pthread_mutex_unlock(&rls.lock);
+
+			ret = -workqueue_add(wq, repair_list_worker, 0, &rls);
+			if (ret) {
+				str_liberror(ctx, ret,
+ _("queueing repair list worker"));
+				pthread_mutex_lock(&rls.lock);
+				rls.workers--;
+				pthread_mutex_unlock(&rls.lock);
+				break;
+			}
+		}
+
+		/* Wait for all worker functions to return. */
+		pthread_mutex_lock(&rls.lock);
+		if (rls.workers > 0)
+			pthread_cond_wait(&rls.done, &rls.lock);
+		pthread_mutex_unlock(&rls.lock);
+
+		action_list_merge(repair_list, &rls.requeue_list);
+
+		if (ret || rls.aborted)
+			return -1;
+		if (rls.made_progress)
+			made_any_progress = true;
+	} while (rls.made_progress && !action_list_empty(repair_list));
+
+	if (made_any_progress)
+	       return 1;
+	return 0;
 }
 
-/* Process all the action items. */
+/* Process both repair lists. */
 static int
 repair_everything(
 	struct scrub_ctx		*ctx)
 {
 	struct workqueue		wq;
-	xfs_agnumber_t			agno;
-	bool				aborted = false;
+	int				fixed_anything;
 	int				ret;
 
 	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
@@ -76,41 +185,32 @@ repair_everything(
 		str_liberror(ctx, ret, _("creating repair workqueue"));
 		return ret;
 	}
-	for (agno = 0; !aborted && agno < ctx->mnt.fsgeom.agcount; agno++) {
-		if (action_list_length(&ctx->action_lists[agno]) == 0)
-			continue;
 
-		ret = -workqueue_add(&wq, repair_ag, agno, &aborted);
-		if (ret) {
-			str_liberror(ctx, ret, _("queueing repair work"));
+	/*
+	 * Try to fix everything on the space metadata repair list and then the
+	 * file repair list until we stop making progress.  These repairs can
+	 * be threaded, if the user desires.
+	 */
+	do {
+		fixed_anything = 0;
+
+		ret = repair_list_schedule(ctx, &wq, ctx->action_list);
+		if (ret < 0)
 			break;
-		}
-	}
+		if (ret == 1)
+			fixed_anything++;
+	} while (fixed_anything > 0);
 
 	ret = -workqueue_terminate(&wq);
 	if (ret)
 		str_liberror(ctx, ret, _("finishing repair work"));
 	workqueue_destroy(&wq);
 
-	if (aborted)
-		return ECANCELED;
+	if (ret < 0)
+		return ret;
 
-	return 0;
-}
-
-/* Decide if we have any repair work to do. */
-static inline bool
-have_action_items(
-	struct scrub_ctx	*ctx)
-{
-	xfs_agnumber_t		agno;
-
-	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		if (action_list_length(&ctx->action_lists[agno]) > 0)
-			return true;
-	}
-
-	return false;
+	/* Repair everything serially.  Last chance to fix things. */
+	return action_list_process(ctx, ctx->action_list, XRM_FINAL_WARNING);
 }
 
 /* Trim the unused areas of the filesystem if the caller asked us to. */
@@ -132,7 +232,7 @@ phase4_func(
 	struct scrub_item	sri;
 	int			ret;
 
-	if (!have_action_items(ctx))
+	if (action_list_empty(ctx->action_list))
 		goto maybe_trim;
 
 	/*
@@ -190,12 +290,12 @@ phase4_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	xfs_agnumber_t		agno;
-	unsigned long long	need_fixing = 0;
+	unsigned long long	need_fixing;
 
-	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
-		need_fixing += action_list_length(&ctx->action_lists[agno]);
+	/* Everything on the repair list plus FSTRIM. */
+	need_fixing = action_list_length(ctx->action_list);
 	need_fixing++;
+
 	*items = need_fixing;
 	*nr_threads = scrub_nproc(ctx) + 1;
 	*rshift = 0;
diff --git a/scrub/repair.c b/scrub/repair.c
index d0434e3d6d1..dd608629f2a 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -387,58 +387,41 @@ repair_item_difficulty(
 	return ret;
 }
 
-/*
- * Allocate a certain number of repair lists for the scrub context.  Returns
- * zero or a positive error number.
- */
+/* Create a new repair action list. */
 int
-action_lists_alloc(
-	size_t				nr,
-	struct action_list		**listsp)
+action_list_alloc(
+	struct action_list		**listp)
 {
-	struct action_list		*lists;
-	xfs_agnumber_t			agno;
+	struct action_list		*alist;
 
-	lists = calloc(nr, sizeof(struct action_list));
-	if (!lists)
+	alist = malloc(sizeof(struct action_list));
+	if (!alist)
 		return errno;
 
-	for (agno = 0; agno < nr; agno++)
-		action_list_init(&lists[agno]);
-	*listsp = lists;
-
+	action_list_init(alist);
+	*listp = alist;
 	return 0;
 }
 
-/* Discard repair list contents. */
+/* Free the repair lists. */
 void
-action_list_discard(
-	struct action_list		*alist)
+action_list_free(
+	struct action_list		**listp)
 {
+	struct action_list		*alist = *listp;
 	struct action_item		*aitem;
 	struct action_item		*n;
 
+	if (!(*listp))
+		return;
+
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
 		list_del(&aitem->list);
 		free(aitem);
 	}
-}
 
-/* Free the repair lists. */
-void
-action_lists_free(
-	struct action_list		**listsp)
-{
-	free(*listsp);
-	*listsp = NULL;
-}
-
-/* Initialize repair list */
-void
-action_list_init(
-	struct action_list		*alist)
-{
-	INIT_LIST_HEAD(&alist->list);
+	free(alist);
+	*listp = NULL;
 }
 
 /* Number of pending repairs in this list. */
@@ -455,7 +438,23 @@ action_list_length(
 	return ret;
 }
 
-/* Add to the list of repairs. */
+/* Remove the first action item from the action list. */
+struct action_item *
+action_list_pop(
+	struct action_list		*alist)
+{
+	struct action_item		*aitem;
+
+	aitem = list_first_entry_or_null(&alist->list, struct action_item,
+			list);
+	if (!aitem)
+		return NULL;
+
+	list_del_init(&aitem->list);
+	return aitem;
+}
+
+/* Add an action item to the end of a list. */
 void
 action_list_add(
 	struct action_list		*alist,
@@ -464,6 +463,46 @@ action_list_add(
 	list_add_tail(&aitem->list, &alist->list);
 }
 
+/*
+ * Try to repair a filesystem object and let the caller know what it should do
+ * with the action item.  The caller must be able to requeue action items, so
+ * we don't complain if repairs are not totally successful.
+ */
+int
+action_item_try_repair(
+	struct scrub_ctx	*ctx,
+	struct action_item	*aitem,
+	enum tryrepair_outcome	*outcome)
+{
+	struct scrub_item	*sri = &aitem->sri;
+	unsigned int		before, after;
+	int			ret;
+
+	before = repair_item_count_needsrepair(sri);
+
+	ret = repair_item(ctx, sri, 0);
+	if (ret)
+		return ret;
+
+	after = repair_item_count_needsrepair(sri);
+	if (after > 0) {
+		/*
+		 * The kernel did not complete all of the repairs requested.
+		 * If it made some progress we'll requeue; otherwise, let the
+		 * caller know that nothing got fixed.
+		 */
+		if (before != after)
+			*outcome = TR_REQUEUE;
+		else
+			*outcome = TR_NOPROGRESS;
+		return 0;
+	}
+
+	/* Repairs complete. */
+	*outcome = TR_REPAIRED;
+	return 0;
+}
+
 /* Repair everything on this list. */
 int
 action_list_process(
@@ -667,29 +706,3 @@ repair_item_to_action_item(
 	*aitemp = aitem;
 	return 0;
 }
-
-/* Defer all the repairs until phase 4. */
-int
-repair_item_defer(
-	struct scrub_ctx	*ctx,
-	const struct scrub_item	*sri)
-{
-	struct action_item	*aitem = NULL;
-	unsigned int		agno;
-	int			error;
-
-	error = repair_item_to_action_item(ctx, sri, &aitem);
-	if (error || !aitem)
-		return error;
-
-	if (sri->sri_agno != -1U)
-		agno = sri->sri_agno;
-	else if (sri->sri_ino != -1ULL && sri->sri_gen != -1U)
-		agno = cvt_ino_to_agno(&ctx->mnt, sri->sri_ino);
-	else
-		agno = 0;
-	ASSERT(agno < ctx->mnt.fsgeom.agcount);
-
-	action_list_add(&ctx->action_lists[agno], aitem);
-	return 0;
-}
diff --git a/scrub/repair.h b/scrub/repair.h
index d76bb963cdd..639ab2370e0 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -12,19 +12,43 @@ struct action_list {
 
 struct action_item;
 
-int action_lists_alloc(size_t nr, struct action_list **listsp);
-void action_lists_free(struct action_list **listsp);
+int action_list_alloc(struct action_list **listp);
+void action_list_free(struct action_list **listp);
+static inline void action_list_init(struct action_list *alist)
+{
+	INIT_LIST_HEAD(&alist->list);
+}
 
-void action_list_init(struct action_list *alist);
+unsigned long long action_list_length(struct action_list *alist);
+
+/* Move all the items of @src to the tail of @dst, and reinitialize @src. */
+static inline void
+action_list_merge(
+	struct action_list	*dst,
+	struct action_list	*src)
+{
+	list_splice_tail_init(&src->list, &dst->list);
+}
+
+struct action_item *action_list_pop(struct action_list *alist);
+void action_list_add(struct action_list *alist, struct action_item *aitem);
 
 static inline bool action_list_empty(const struct action_list *alist)
 {
 	return list_empty(&alist->list);
 }
 
-unsigned long long action_list_length(struct action_list *alist);
-void action_list_add(struct action_list *dest, struct action_item *item);
-void action_list_discard(struct action_list *alist);
+enum tryrepair_outcome {
+	/* No progress was made on repairs at all. */
+	TR_NOPROGRESS = 0,
+	/* Some progress was made on repairs; try again soon. */
+	TR_REQUEUE,
+	/* Repairs completely successful. */
+	TR_REPAIRED,
+};
+
+int action_item_try_repair(struct scrub_ctx *ctx, struct action_item *aitem,
+		enum tryrepair_outcome *outcome);
 
 void repair_item_mustfix(struct scrub_item *sri, struct scrub_item *fix_now);
 
@@ -56,7 +80,6 @@ int repair_item(struct scrub_ctx *ctx, struct scrub_item *sri,
 		unsigned int repair_flags);
 int repair_item_to_action_item(struct scrub_ctx *ctx,
 		const struct scrub_item *sri, struct action_item **aitemp);
-int repair_item_defer(struct scrub_ctx *ctx, const struct scrub_item *sri);
 
 static inline unsigned int
 repair_item_count_needsrepair(
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 768f935084f..d5094147327 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -71,7 +71,7 @@ struct scrub_ctx {
 
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
-	struct action_list	*action_lists;
+	struct action_list	*action_list;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	corruptions_found;

