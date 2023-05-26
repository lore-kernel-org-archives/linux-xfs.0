Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B15C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbjEZBLL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbjEZBLK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:11:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDAC19A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:11:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A29964C14
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2F1C4339B;
        Fri, 26 May 2023 01:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063465;
        bh=RctLFLEejduFb1o/p2lxd+3QT0NG2MIdBJJMLM35PS0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=r0cSW/QOsNiOa47mj87ykw+eYu4AIL4OlowC6TouXZBM9JmkB04qm6MFxb/jmB5Hh
         zr/243ROCp7j4FPuC+pLboVKhN6BoXH4Uq49VhsoXIImbo/rJzVq0tbGSVBqbR8q2a
         uDPaWqomFfD8CWCiRPW2hhe4w6NVM4iZYo3TDAn/cYl5LaaLIoESpUSySLzcw8YjYM
         4lbFmBW2+ADBwvNf1Uy0qHmNICYw6Xx9xGnZ4FXkLWdnR3mtVlxkbWBecP6/NQEv51
         Z8pQF8oNUrErn7ry7k248o12xEm7zwjfNGkI6Mj4nGwrV0ZFCbnHRiwvdZNCkFEGpf
         zmqTJiqkAkccA==
Date:   Thu, 25 May 2023 18:11:05 -0700
Subject: [PATCH 3/4] xfs: create refcount bag structure for btree repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063164.3733778.3029751952312615325.stgit@frogsfrogsfrogs>
In-Reply-To: <168506063115.3733778.10696213835208138453.stgit@frogsfrogsfrogs>
References: <168506063115.3733778.10696213835208138453.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a bag structure for refcount information that uses the refcount
bag btree defined in the previous patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/scrub/rcbag.c       |  331 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag.h       |   28 ++++
 fs/xfs/scrub/rcbag_btree.c |   58 ++++++++
 fs/xfs/scrub/rcbag_btree.h |    7 +
 5 files changed, 425 insertions(+)
 create mode 100644 fs/xfs/scrub/rcbag.c
 create mode 100644 fs/xfs/scrub/rcbag.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index cca9cc33183a..56861c8f78cc 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -195,6 +195,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   newbt.o \
 				   nlinks_repair.o \
 				   rcbag_btree.o \
+				   rcbag.o \
 				   reap.o \
 				   refcount_repair.o \
 				   repair.o \
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
new file mode 100644
index 000000000000..37d1ec6d5538
--- /dev/null
+++ b/fs/xfs/scrub/rcbag.c
@@ -0,0 +1,331 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_btree_mem.h"
+#include "xfs_error.h"
+#include "scrub/scrub.h"
+#include "scrub/xfile.h"
+#include "scrub/xfbtree.h"
+#include "scrub/rcbag_btree.h"
+#include "scrub/rcbag.h"
+#include "scrub/trace.h"
+
+struct rcbag {
+	struct xfs_mount	*mp;
+	struct xfbtree		*xfbtree;
+	uint64_t		nr_items;
+};
+
+int
+rcbag_init(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*target,
+	struct rcbag		**bagp)
+{
+	struct rcbag		*bag;
+	int			error;
+
+	bag = kmalloc(sizeof(struct rcbag), XCHK_GFP_FLAGS);
+	if (!bag)
+		return -ENOMEM;
+
+	bag->nr_items = 0;
+	bag->mp = mp;
+
+	error = rcbagbt_mem_create(mp, target, &bag->xfbtree);
+	if (error)
+		goto out_bag;
+
+	*bagp = bag;
+	return 0;
+
+out_bag:
+	kfree(bag);
+	return error;
+}
+
+void
+rcbag_free(
+	struct rcbag		**bagp)
+{
+	struct rcbag		*bag = *bagp;
+
+	xfbtree_destroy(bag->xfbtree);
+	kfree(bag);
+	*bagp = NULL;
+}
+
+/* Track an rmap in the refcount bag. */
+int
+rcbag_add(
+	struct rcbag			*bag,
+	struct xfs_trans		*tp,
+	const struct xfs_rmap_irec	*rmap)
+{
+	struct rcbag_rec		bagrec;
+	struct xfs_mount		*mp = bag->mp;
+	struct xfs_buf			*head_bp;
+	struct xfs_btree_cur		*cur;
+	int				has;
+	int				error;
+
+	error = xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
+	if (error)
+		return error;
+
+	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	error = rcbagbt_lookup_eq(cur, rmap, &has);
+	if (error)
+		goto out_cur;
+
+	if (has) {
+		error = rcbagbt_get_rec(cur, &bagrec, &has);
+		if (error)
+			goto out_cur;
+		if (!has) {
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+
+		bagrec.rbg_refcount++;
+		error = rcbagbt_update(cur, &bagrec);
+		if (error)
+			goto out_cur;
+	} else {
+		bagrec.rbg_startblock = rmap->rm_startblock;
+		bagrec.rbg_blockcount = rmap->rm_blockcount;
+		bagrec.rbg_refcount = 1;
+
+		error = rcbagbt_insert(cur, &bagrec, &has);
+		if (error)
+			goto out_cur;
+		if (!has) {
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+	}
+
+	xfs_btree_del_cursor(cur, 0);
+	xfs_trans_brelse(tp, head_bp);
+
+	error = xfbtree_trans_commit(bag->xfbtree, tp);
+	if (error)
+		return error;
+
+	bag->nr_items++;
+	return 0;
+
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	xfs_trans_brelse(tp, head_bp);
+	xfbtree_trans_cancel(bag->xfbtree, tp);
+	return error;
+}
+
+uint64_t
+rcbag_count(
+	const struct rcbag	*rcbag)
+{
+	return rcbag->nr_items;
+}
+
+#define BAGREC_NEXT(r)	((r)->rbg_startblock + (r)->rbg_blockcount)
+
+/*
+ * Find the next block where the refcount changes, given the next rmap we
+ * looked at and the ones we're already tracking.
+ */
+int
+rcbag_next_edge(
+	struct rcbag			*bag,
+	struct xfs_trans		*tp,
+	const struct xfs_rmap_irec	*next_rmap,
+	bool				next_valid,
+	uint32_t			*next_bnop)
+{
+	struct rcbag_rec		bagrec;
+	struct xfs_mount		*mp = bag->mp;
+	struct xfs_buf			*head_bp;
+	struct xfs_btree_cur		*cur;
+	uint32_t			next_bno = NULLAGBLOCK;
+	int				has;
+	int				error;
+
+	if (next_valid)
+		next_bno = next_rmap->rm_startblock;
+
+	error = xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
+	if (error)
+		return error;
+
+	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	error = xfs_btree_goto_left_edge(cur);
+	if (error)
+		goto out_cur;
+
+	while (true) {
+		error = xfs_btree_increment(cur, 0, &has);
+		if (error)
+			goto out_cur;
+		if (!has)
+			break;
+
+		error = rcbagbt_get_rec(cur, &bagrec, &has);
+		if (error)
+			goto out_cur;
+		if (!has) {
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+
+		next_bno = min(next_bno, BAGREC_NEXT(&bagrec));
+	}
+
+	/*
+	 * We should have found /something/ because either next_rrm is the next
+	 * interesting rmap to look at after emitting this refcount extent, or
+	 * there are other rmaps in rmap_bag contributing to the current
+	 * sharing count.  But if something is seriously wrong, bail out.
+	 */
+	if (next_bno == NULLAGBLOCK) {
+		error = -EFSCORRUPTED;
+		goto out_cur;
+	}
+
+	xfs_btree_del_cursor(cur, 0);
+	xfs_trans_brelse(tp, head_bp);
+
+	*next_bnop = next_bno;
+	return 0;
+
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	xfs_trans_brelse(tp, head_bp);
+	return error;
+}
+
+/* Pop all refcount bag records that end at next_bno */
+int
+rcbag_remove_ending_at(
+	struct rcbag		*bag,
+	struct xfs_trans	*tp,
+	uint32_t		next_bno)
+{
+	struct rcbag_rec	bagrec;
+	struct xfs_mount	*mp = bag->mp;
+	struct xfs_buf		*head_bp;
+	struct xfs_btree_cur	*cur;
+	int			has;
+	int			error;
+
+	error = xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
+	if (error)
+		return error;
+
+	/* go to the right edge of the tree */
+	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	memset(&cur->bc_rec, 0xFF, sizeof(cur->bc_rec));
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, &has);
+	if (error)
+		goto out_cur;
+
+	while (true) {
+		error = xfs_btree_decrement(cur, 0, &has);
+		if (error)
+			goto out_cur;
+		if (!has)
+			break;
+
+		error = rcbagbt_get_rec(cur, &bagrec, &has);
+		if (error)
+			goto out_cur;
+		if (!has) {
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+
+		if (BAGREC_NEXT(&bagrec) != next_bno)
+			continue;
+
+		error = xfs_btree_delete(cur, &has);
+		if (error)
+			goto out_cur;
+		if (!has) {
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+
+		bag->nr_items -= bagrec.rbg_refcount;
+	}
+
+	xfs_btree_del_cursor(cur, 0);
+	xfs_trans_brelse(tp, head_bp);
+	return xfbtree_trans_commit(bag->xfbtree, tp);
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	xfs_trans_brelse(tp, head_bp);
+	xfbtree_trans_cancel(bag->xfbtree, tp);
+	return error;
+}
+
+/* Dump the rcbag. */
+void
+rcbag_dump(
+	struct rcbag			*bag,
+	struct xfs_trans		*tp)
+{
+	struct rcbag_rec		bagrec;
+	struct xfs_mount		*mp = bag->mp;
+	struct xfs_buf			*head_bp;
+	struct xfs_btree_cur		*cur;
+	unsigned long long		nr = 0;
+	int				has;
+	int				error;
+
+	error = xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
+	if (error)
+		return;
+
+	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	error = xfs_btree_goto_left_edge(cur);
+	if (error)
+		goto out_cur;
+
+	while (true) {
+		error = xfs_btree_increment(cur, 0, &has);
+		if (error)
+			goto out_cur;
+		if (!has)
+			break;
+
+		error = rcbagbt_get_rec(cur, &bagrec, &has);
+		if (error)
+			goto out_cur;
+		if (!has) {
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+
+		xfs_err(bag->mp, "[%llu]: bno 0x%x fsbcount 0x%x refcount 0x%llx\n",
+				nr++,
+				(unsigned int)bagrec.rbg_startblock,
+				(unsigned int)bagrec.rbg_blockcount,
+				(unsigned long long)bagrec.rbg_refcount);
+	}
+
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	xfs_trans_brelse(tp, head_bp);
+}
diff --git a/fs/xfs/scrub/rcbag.h b/fs/xfs/scrub/rcbag.h
new file mode 100644
index 000000000000..81ad3f1fb2f6
--- /dev/null
+++ b/fs/xfs/scrub/rcbag.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_RCBAG_H__
+#define __XFS_SCRUB_RCBAG_H__
+
+struct xfs_mount;
+struct rcbag;
+struct xfs_buftarg;
+
+int rcbag_init(struct xfs_mount *mp, struct xfs_buftarg *target,
+		struct rcbag **bagp);
+void rcbag_free(struct rcbag **bagp);
+int rcbag_add(struct rcbag *bag, struct xfs_trans *tp,
+		const struct xfs_rmap_irec *rmap);
+uint64_t rcbag_count(const struct rcbag *bag);
+
+int rcbag_next_edge(struct rcbag *bag, struct xfs_trans *tp,
+		const struct xfs_rmap_irec *next_rmap, bool next_valid,
+		uint32_t *next_bnop);
+int rcbag_remove_ending_at(struct rcbag *bag, struct xfs_trans *tp,
+		uint32_t next_bno);
+
+void rcbag_dump(struct rcbag *bag, struct xfs_trans *tp);
+
+#endif /* __XFS_SCRUB_RCBAG_H__ */
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 4c98f619551b..ac4cc6ae24c7 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -312,3 +312,61 @@ rcbagbt_destroy_cur_cache(void)
 	kmem_cache_destroy(rcbagbt_cur_cache);
 	rcbagbt_cur_cache = NULL;
 }
+
+/* Look up the refcount bag record corresponding to this reverse mapping. */
+int
+rcbagbt_lookup_eq(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rmap,
+	int				*success)
+{
+	struct rcbag_rec		*rec = (struct rcbag_rec *)&cur->bc_rec;
+
+	rec->rbg_startblock = rmap->rm_startblock;
+	rec->rbg_blockcount = rmap->rm_blockcount;
+
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, success);
+}
+
+/* Get the data from the pointed-to record. */
+int
+rcbagbt_get_rec(
+	struct xfs_btree_cur	*cur,
+	struct rcbag_rec	*rec,
+	int			*has)
+{
+	union xfs_btree_rec	*btrec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &btrec, has);
+	if (error || !(*has))
+		return error;
+
+	memcpy(rec, btrec, sizeof(struct rcbag_rec));
+	return 0;
+}
+
+/* Update the record referred to by cur to the value given. */
+int
+rcbagbt_update(
+	struct xfs_btree_cur	*cur,
+	const struct rcbag_rec	*rec)
+{
+	union xfs_btree_rec	btrec;
+
+	memcpy(&btrec, rec, sizeof(struct rcbag_rec));
+	return xfs_btree_update(cur, &btrec);
+}
+
+/* Update the record referred to by cur to the value given. */
+int
+rcbagbt_insert(
+	struct xfs_btree_cur	*cur,
+	const struct rcbag_rec	*rec,
+	int			*success)
+{
+	struct rcbag_rec	*btrec = (struct rcbag_rec *)&cur->bc_rec;
+
+	memcpy(btrec, rec, sizeof(struct rcbag_rec));
+	return xfs_btree_insert(cur, success);
+}
diff --git a/fs/xfs/scrub/rcbag_btree.h b/fs/xfs/scrub/rcbag_btree.h
index 9dcf5886fa85..c5c813cc5acb 100644
--- a/fs/xfs/scrub/rcbag_btree.h
+++ b/fs/xfs/scrub/rcbag_btree.h
@@ -68,6 +68,13 @@ struct xfs_btree_cur *rcbagbt_mem_cursor(struct xfs_mount *mp,
 int rcbagbt_mem_create(struct xfs_mount *mp, struct xfs_buftarg *target,
 		struct xfbtree **xfbtreep);
 
+int rcbagbt_lookup_eq(struct xfs_btree_cur *cur,
+		const struct xfs_rmap_irec *rmap, int *success);
+int rcbagbt_get_rec(struct xfs_btree_cur *cur, struct rcbag_rec *rec, int *has);
+int rcbagbt_update(struct xfs_btree_cur *cur, const struct rcbag_rec *rec);
+int rcbagbt_insert(struct xfs_btree_cur *cur, const struct rcbag_rec *rec,
+		int *success);
+
 #else
 # define rcbagbt_init_cur_cache()		0
 # define rcbagbt_destroy_cur_cache()		((void)0)

