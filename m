Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD5FC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiLaARN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbiLaARL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:17:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C9BE0D8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:17:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76E0F61D04
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8E3C433D2;
        Sat, 31 Dec 2022 00:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445828;
        bh=EtUw+YoFm42sbe8L6vnQo59vLWNjd6xt34Gef27kgO4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pqpNrpXMsvEVSDnHfF1krk3jrrcbxv0lVqQ/I7bUZK8qQ/15dNdkpDYoc3nSrIeWB
         18h7s1dfhXkrqsfqE42Qf0rmaelZfsDpkAN/jYA5IbQT1orc3OWvhWQA0LNLhKJjmq
         0WAK0Vh46VnJY28cmyvydew6qbJ4KdW/A+m7l+jE5znH9k2E9f07GuMlOAQb1Oa+Th
         KiJCvg6lHb7H62tPNZ+XYIdmtYZRzqmx14P8cHtrDYyeO+Egm8/4/3omc+2/Mm10T4
         EZAJRgN3iQgJLzB8zkNL5mJk74xdbSjfW5l9UgHBx4ZQpGRaUr0CwLui8H/iFY5np8
         lnHxEw4biXTmQ==
Subject: [PATCH 3/5] xfs_repair: create refcount bag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:52 -0800
Message-ID: <167243867284.712955.10005379733633399092.stgit@magnolia>
In-Reply-To: <167243867247.712955.4006304832992035940.stgit@magnolia>
References: <167243867247.712955.4006304832992035940.stgit@magnolia>
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
 libxfs/libxfs_api_defs.h |    5 +
 repair/Makefile          |    2 
 repair/rcbag.c           |  404 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rcbag.h           |   33 ++++
 repair/rcbag_btree.c     |   59 +++++++
 repair/rcbag_btree.h     |    7 +
 6 files changed, 510 insertions(+)
 create mode 100644 repair/rcbag.c
 create mode 100644 repair/rcbag.h


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index df614182b7b..aa71914af97 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -58,14 +58,19 @@
 #define xfs_btree_calc_size		libxfs_btree_calc_size
 #define xfs_btree_decrement		libxfs_btree_decrement
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
+#define xfs_btree_delete		libxfs_btree_delete
 #define xfs_btree_get_block		libxfs_btree_get_block
+#define xfs_btree_get_rec		libxfs_btree_get_rec
 #define xfs_btree_goto_left_edge	libxfs_btree_goto_left_edge
 #define xfs_btree_has_more_records	libxfs_btree_has_more_records
 #define xfs_btree_increment		libxfs_btree_increment
 #define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_btree_insert		libxfs_btree_insert
+#define xfs_btree_lookup		libxfs_btree_lookup
 #define xfs_btree_mem_head_nlevels	libxfs_btree_mem_head_nlevels
 #define xfs_btree_mem_head_read_buf	libxfs_btree_mem_head_read_buf
 #define xfs_btree_rec_addr		libxfs_btree_rec_addr
+#define xfs_btree_update		libxfs_btree_update
 #define xfs_btree_space_to_height	libxfs_btree_space_to_height
 #define xfs_btree_visit_blocks		libxfs_btree_visit_blocks
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
diff --git a/repair/Makefile b/repair/Makefile
index 5ea8d9618e7..250c86cca2d 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -29,6 +29,7 @@ HFILES = \
 	protos.h \
 	quotacheck.h \
 	rcbag_btree.h \
+	rcbag.h \
 	rmap.h \
 	rt.h \
 	scan.h \
@@ -66,6 +67,7 @@ CFILES = \
 	progress.c \
 	quotacheck.c \
 	rcbag_btree.c \
+	rcbag.c \
 	rmap.c \
 	rt.c \
 	sb.c \
diff --git a/repair/rcbag.c b/repair/rcbag.c
new file mode 100644
index 00000000000..04958cba460
--- /dev/null
+++ b/repair/rcbag.c
@@ -0,0 +1,404 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "btree.h"
+#include "err_protos.h"
+#include "libxlog.h"
+#include "incore.h"
+#include "globals.h"
+#include "dinode.h"
+#include "slab.h"
+#include "libfrog/bitmap.h"
+#include "libxfs/xfile.h"
+#include "libxfs/xfbtree.h"
+#include "libxfs/xfs_btree_mem.h"
+#include "rcbag_btree.h"
+#include "rcbag.h"
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
+	uint64_t		max_rmaps,
+	struct rcbag		**bagp)
+{
+	struct xfile		*xfile;
+	struct xfs_buftarg	*target;
+	struct rcbag		*bag;
+	unsigned long long	maxbytes;
+	int			error;
+
+	bag = malloc(sizeof(struct rcbag));
+	if (!bag)
+		return ENOMEM;
+
+	bag->nr_items = 0;
+	bag->mp = mp;
+
+	/* Need to save space for the head block */
+	maxbytes = (1 + rcbagbt_calc_size(max_rmaps)) * getpagesize();
+	error = -xfile_create(mp, maxbytes, "refcount bag", &xfile);
+	if (error)
+		goto out_bag;
+
+	error = -libxfs_alloc_memory_buftarg(mp, xfile, &target);
+	if (error)
+		goto out_xfile;
+
+	error = rcbagbt_mem_create(mp, target, &bag->xfbtree);
+	if (error)
+		goto out_buftarg;
+
+	*bagp = bag;
+	return 0;
+
+out_buftarg:
+	libxfs_buftarg_free(target);
+out_xfile:
+	xfile_destroy(xfile);
+out_bag:
+	free(bag);
+	return error;
+}
+
+void
+rcbag_free(
+	struct rcbag		**bagp)
+{
+	struct rcbag		*bag = *bagp;
+	struct xfile		*xfile;
+	struct xfs_buftarg	*target;
+
+	target = bag->xfbtree->target;
+	xfile = target->bt_xfile;
+
+	xfbtree_destroy(bag->xfbtree);
+	libxfs_buftarg_free(target);
+	xfile_destroy(xfile);
+
+	free(bag);
+	*bagp = NULL;
+}
+
+/* Track an rmap in the refcount bag. */
+void
+rcbag_add(
+	struct rcbag			*bag,
+	const struct xfs_rmap_irec	*rmap)
+{
+	struct rcbag_rec		bagrec;
+	struct xfs_mount		*mp = bag->mp;
+	struct xfs_trans		*tp;
+	struct xfs_buf			*head_bp;
+	struct xfs_btree_cur		*cur;
+	int				has;
+	int				error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(_("allocating tx for refcount bag update\n"));
+
+	error = -xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
+	if (error)
+		do_error(_("reading refcount bag header\n"));
+
+	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	error = rcbagbt_lookup_eq(cur, rmap, &has);
+	if (error)
+		do_error(_("looking up refcount bag records\n"));
+
+	if (has) {
+		error = rcbagbt_get_rec(cur, &bagrec, &has);
+		if (error || !has)
+			do_error(_("reading refcount bag records\n"));
+
+		bagrec.rbg_refcount++;
+		error = rcbagbt_update(cur, &bagrec);
+		if (error)
+			do_error(_("updating refcount bag record\n"));
+	} else {
+		bagrec.rbg_startblock = rmap->rm_startblock;
+		bagrec.rbg_blockcount = rmap->rm_blockcount;
+		bagrec.rbg_ino = rmap->rm_owner;
+		bagrec.rbg_refcount = 1;
+
+		error = rcbagbt_insert(cur, &bagrec, &has);
+		if (error || !has)
+			do_error(_("adding refcount bag record, err %d\n"),
+					error);
+	}
+
+	libxfs_btree_del_cursor(cur, error);
+	libxfs_trans_brelse(tp, head_bp);
+
+	error = -xfbtree_trans_commit(bag->xfbtree, tp);
+	if (error)
+		do_error(_("committing refcount bag record\n"));
+
+	libxfs_trans_cancel(tp);
+	bag->nr_items++;
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
+void
+rcbag_next_edge(
+	struct rcbag			*bag,
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
+	error = -xfbtree_head_read_buf(bag->xfbtree, NULL, &head_bp);
+	if (error)
+		do_error(_("reading refcount bag header\n"));
+
+	cur = rcbagbt_mem_cursor(mp, NULL, head_bp, bag->xfbtree);
+	error = -libxfs_btree_goto_left_edge(cur);
+	if (error)
+		do_error(_("seeking refcount bag btree cursor\n"));
+
+	while (true) {
+		error = -libxfs_btree_increment(cur, 0, &has);
+		if (error)
+			do_error(_("incrementing refcount bag btree cursor\n"));
+		if (!has)
+			break;
+
+		error = rcbagbt_get_rec(cur, &bagrec, &has);
+		if (error)
+			do_error(_("reading refcount bag btree record\n"));
+		if (!has)
+			do_error(_("refcount bag btree record disappeared?\n"));
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
+	if (next_bno == NULLAGBLOCK)
+		do_error(_("next refcount bag edge not found?\n"));
+
+	*next_bnop = next_bno;
+
+	libxfs_btree_del_cursor(cur, error);
+	libxfs_trans_brelse(NULL, head_bp);
+}
+
+/* Pop all refcount bag records that end at next_bno */
+void
+rcbag_remove_ending_at(
+	struct rcbag		*bag,
+	uint32_t		next_bno)
+{
+	struct rcbag_rec	bagrec;
+	struct xfs_mount	*mp = bag->mp;
+	struct xfs_trans	*tp;
+	struct xfs_buf		*head_bp;
+	struct xfs_btree_cur	*cur;
+	int			has;
+	int			error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(_("allocating tx for refcount bag update\n"));
+
+	error = -xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
+	if (error)
+		do_error(_("reading refcount bag header\n"));
+
+	/* go to the right edge of the tree */
+	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	memset(&cur->bc_rec, 0xFF, sizeof(cur->bc_rec));
+	error = -libxfs_btree_lookup(cur, XFS_LOOKUP_GE, &has);
+	if (error)
+		do_error(_("seeking refcount bag btree cursor\n"));
+
+	while (true) {
+		error = -libxfs_btree_decrement(cur, 0, &has);
+		if (error)
+			do_error(_("decrementing refcount bag btree cursor\n"));
+		if (!has)
+			break;
+
+		error = rcbagbt_get_rec(cur, &bagrec, &has);
+		if (error)
+			do_error(_("reading refcount bag btree record\n"));
+		if (!has)
+			do_error(_("refcount bag btree record disappeared?\n"));
+
+		if (BAGREC_NEXT(&bagrec) != next_bno)
+			continue;
+
+		error = -libxfs_btree_delete(cur, &has);
+		if (error)
+			do_error(_("deleting refcount bag btree record, err %d\n"),
+					error);
+		if (!has)
+			do_error(_("couldn't delete refcount bag record?\n"));
+
+		bag->nr_items -= bagrec.rbg_refcount;
+	}
+
+	libxfs_btree_del_cursor(cur, error);
+	libxfs_trans_brelse(tp, head_bp);
+
+	error = -xfbtree_trans_commit(bag->xfbtree, tp);
+	if (error)
+		do_error(_("committing refcount bag deletions\n"));
+
+	libxfs_trans_cancel(tp);
+}
+
+/* Prepare to iterate the shared inodes tracked by the refcount bag. */
+void
+rcbag_ino_iter_start(
+	struct rcbag		*bag,
+	struct rcbag_iter	*iter)
+{
+	struct xfs_mount	*mp = bag->mp;
+	int			error;
+
+	memset(iter, 0, sizeof(struct rcbag_iter));
+
+	if (bag->nr_items < 2)
+		return;
+
+	error = -xfbtree_head_read_buf(bag->xfbtree, NULL, &iter->head_bp);
+	if (error)
+		do_error(_("reading refcount bag header\n"));
+
+	iter->cur = rcbagbt_mem_cursor(mp, NULL, iter->head_bp, bag->xfbtree);
+	error = -libxfs_btree_goto_left_edge(iter->cur);
+	if (error)
+		do_error(_("seeking refcount bag btree cursor\n"));
+}
+
+/* Tear down an iteration. */
+void
+rcbag_ino_iter_stop(
+	struct rcbag		*bag,
+	struct rcbag_iter	*iter)
+{
+	if (iter->cur)
+		libxfs_btree_del_cursor(iter->cur, XFS_BTREE_NOERROR);
+	if (iter->head_bp)
+		libxfs_trans_brelse(NULL, iter->head_bp);
+	iter->cur = NULL;
+	iter->head_bp = NULL;
+}
+
+/*
+ * Walk all the shared inodes tracked by the refcount bag.  Returns 1 when
+ * returning a valid iter.ino, and 0 if iteration has completed.  The iter
+ * should be initialized to zeroes before the first call.
+ */
+int
+rcbag_ino_iter(
+	struct rcbag		*bag,
+	struct rcbag_iter	*iter)
+{
+	struct rcbag_rec	bagrec;
+	int			has;
+	int			error;
+
+	if (bag->nr_items < 2)
+		return 0;
+
+	do {
+		error = -libxfs_btree_increment(iter->cur, 0, &has);
+		if (error)
+			do_error(_("incrementing refcount bag btree cursor\n"));
+		if (!has)
+			return 0;
+
+		error = rcbagbt_get_rec(iter->cur, &bagrec, &has);
+		if (error)
+			do_error(_("reading refcount bag btree record\n"));
+		if (!has)
+			do_error(_("refcount bag btree record disappeared?\n"));
+	} while (iter->ino == bagrec.rbg_ino);
+
+	iter->ino = bagrec.rbg_ino;
+	return 1;
+}
+
+/* Dump the rcbag. */
+void
+rcbag_dump(
+	struct rcbag			*bag)
+{
+	struct rcbag_rec		bagrec;
+	struct xfs_mount		*mp = bag->mp;
+	struct xfs_buf			*head_bp;
+	struct xfs_btree_cur		*cur;
+	unsigned long long		nr = 0;
+	int				has;
+	int				error;
+
+	error = -xfbtree_head_read_buf(bag->xfbtree, NULL, &head_bp);
+	if (error)
+		do_error(_("reading refcount bag header\n"));
+
+	cur = rcbagbt_mem_cursor(mp, NULL, head_bp, bag->xfbtree);
+	error = -libxfs_btree_goto_left_edge(cur);
+	if (error)
+		do_error(_("seeking refcount bag btree cursor\n"));
+
+	while (true) {
+		error = -libxfs_btree_increment(cur, 0, &has);
+		if (error)
+			do_error(_("incrementing refcount bag btree cursor\n"));
+		if (!has)
+			break;
+
+		error = rcbagbt_get_rec(cur, &bagrec, &has);
+		if (error)
+			do_error(_("reading refcount bag btree record\n"));
+		if (!has)
+			do_error(_("refcount bag btree record disappeared?\n"));
+
+		printf("[%llu]: bno 0x%x fsbcount 0x%x ino 0x%llx refcount 0x%llx\n",
+				nr++,
+				(unsigned int)bagrec.rbg_startblock,
+				(unsigned int)bagrec.rbg_blockcount,
+				(unsigned long long)bagrec.rbg_ino,
+				(unsigned long long)bagrec.rbg_refcount);
+	}
+
+	libxfs_btree_del_cursor(cur, error);
+	libxfs_trans_brelse(NULL, head_bp);
+}
diff --git a/repair/rcbag.h b/repair/rcbag.h
new file mode 100644
index 00000000000..04f9b5b403e
--- /dev/null
+++ b/repair/rcbag.h
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __RCBAG_H__
+#define __RCBAG_H__
+
+struct xfs_mount;
+struct rcbag;
+
+int rcbag_init(struct xfs_mount *mp, uint64_t max_rmaps, struct rcbag **bagp);
+void rcbag_free(struct rcbag **bagp);
+void rcbag_add(struct rcbag *bag, const struct xfs_rmap_irec *rmap);
+uint64_t rcbag_count(const struct rcbag *bag);
+
+void rcbag_next_edge(struct rcbag *bag, const struct xfs_rmap_irec *next_rmap,
+		bool next_valid, uint32_t *next_bnop);
+void rcbag_remove_ending_at(struct rcbag *bag, uint32_t next_bno);
+
+struct rcbag_iter {
+	struct xfs_buf		*head_bp;
+	struct xfs_btree_cur	*cur;
+	uint64_t		ino;
+};
+
+void rcbag_ino_iter_start(struct rcbag *bag, struct rcbag_iter *iter);
+void rcbag_ino_iter_stop(struct rcbag *bag, struct rcbag_iter *iter);
+int rcbag_ino_iter(struct rcbag *bag, struct rcbag_iter *iter);
+
+void rcbag_dump(struct rcbag *bag);
+
+#endif /* __RCBAG_H__ */
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
index c86189806c8..13676463f7c 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -333,3 +333,62 @@ rcbagbt_destroy_cur_cache(void)
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
+	rec->rbg_ino = rmap->rm_owner;
+
+	return -libxfs_btree_lookup(cur, XFS_LOOKUP_EQ, success);
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
+	error = -libxfs_btree_get_rec(cur, &btrec, has);
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
+	return -libxfs_btree_update(cur, &btrec);
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
+	return -libxfs_btree_insert(cur, success);
+}
diff --git a/repair/rcbag_btree.h b/repair/rcbag_btree.h
index 21329153baf..fcbc4171369 100644
--- a/repair/rcbag_btree.h
+++ b/repair/rcbag_btree.h
@@ -68,4 +68,11 @@ struct xfs_btree_cur *rcbagbt_mem_cursor(struct xfs_mount *mp,
 int rcbagbt_mem_create(struct xfs_mount *mp, struct xfs_buftarg *target,
 		struct xfbtree **xfbtreep);
 
+int rcbagbt_lookup_eq(struct xfs_btree_cur *cur,
+		const struct xfs_rmap_irec *rmap, int *success);
+int rcbagbt_get_rec(struct xfs_btree_cur *cur, struct rcbag_rec *rec, int *has);
+int rcbagbt_update(struct xfs_btree_cur *cur, const struct rcbag_rec *rec);
+int rcbagbt_insert(struct xfs_btree_cur *cur, const struct rcbag_rec *rec,
+		int *success);
+
 #endif /* __RCBAG_BTREE_H__ */

