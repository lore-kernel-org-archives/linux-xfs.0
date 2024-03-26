Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08C812838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 04:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425726; cv=none; b=h7/T+oVVs0wx0doTzrnLhCreZ0+k0l2j32dr3gORkQLWe1Z/M7dXBbDtDGtlCvlRky+t57dzozDukrd1yJV+PNsgZ/URRczo/OH4CloVgQYDQT9ypbZki194YgYLWJ7scAf05Bb4JDynXnaUgdH48BuVQogow6HIm1fFO5xAEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425726; c=relaxed/simple;
	bh=MRq+5pNgITHU5wFp+wRbiQls4e94NFM/kaGiPGKZ3i0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nnPHc/Cjyg6ZIaEhU6qcOwzvmMscDO9KuHxOO0dE3qIViVz/eNeIuHPIVFnjHG7YiDPYRdBf7OuddwwNaLA7fMSoC7SsmKFVr72Fuo2TKrlBTLwWg/1ivZm8OBnElXMKIobf0kux94ySQmcq21XffLkt/weT8GhoUETBOu0rUMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPZp9CgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPZp9CgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B51C433C7;
	Tue, 26 Mar 2024 04:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425726;
	bh=MRq+5pNgITHU5wFp+wRbiQls4e94NFM/kaGiPGKZ3i0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uPZp9CgHCPw0Mf6AxV63se7yLSCLnytfBLG5fQVWB9VHZXaYVo7B0z0ZXplHBuEhk
	 4SU4WN3ii9Yghm4e/ZSmchECRhRM3QX3whIovCwxc7R7wxl3OY72+AOPAQa5dfjwDW
	 gYRbG4zN5GvVQF+EWeYSgfTejIX9vJV4jsROLCpaQxwgYzpGfUoRuUGI/8BdTuwSz0
	 QlRLDAAN1udDSOc8hP7Gc8sfhpAydbDaS8U5/QfZhu/UrYW17Q5vKrAcSRCzCyDAq9
	 Q5Ld5xHExa6iIAeOmCjV9YhsTjsxxVAWORd4WynSwlg90i2UmGVW2TTiSmV9W9Sp3M
	 1X1WbNYtUSLfA==
Date: Mon, 25 Mar 2024 21:02:06 -0700
Subject: [PATCH 2/4] xfs_repair: create refcount bag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142135109.2220204.3997484486890202762.stgit@frogsfrogsfrogs>
In-Reply-To: <171142135076.2220204.9878243275175160383.stgit@frogsfrogsfrogs>
References: <171142135076.2220204.9878243275175160383.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a bag structure for refcount information that uses the refcount
bag btree defined in the previous patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    5 +
 repair/Makefile          |    2 
 repair/rcbag.c           |  370 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rcbag.h           |   32 ++++
 repair/rcbag_btree.c     |   59 +++++++
 repair/rcbag_btree.h     |    7 +
 6 files changed, 475 insertions(+)
 create mode 100644 repair/rcbag.c
 create mode 100644 repair/rcbag.h


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index cd2e6a8fb16f..2b1a2035c6a2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -66,15 +66,20 @@
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
 #define xfs_btree_memblock_verify	libxfs_btree_memblock_verify
 #define xfs_btree_rec_addr		libxfs_btree_rec_addr
+#define xfs_btree_update		libxfs_btree_update
 #define xfs_btree_space_to_height	libxfs_btree_space_to_height
 #define xfs_btree_stage_afakeroot	libxfs_btree_stage_afakeroot
 #define xfs_btree_stage_ifakeroot	libxfs_btree_stage_ifakeroot
diff --git a/repair/Makefile b/repair/Makefile
index 5ea8d9618e78..250c86cca2d3 100644
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
index 000000000000..2ae3f5d40a9d
--- /dev/null
+++ b/repair/rcbag.c
@@ -0,0 +1,370 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
+#include "libfrog/platform.h"
+#include "rcbag_btree.h"
+#include "rcbag.h"
+
+struct rcbag {
+	struct xfs_mount	*mp;
+
+	/* buffer target for in-memory btree */
+	struct xfs_buftarg	*btp;
+	/* root of in-memory refcount bag btree */
+	struct xfbtree		xfbtree;
+
+	/* number of records in the bag */
+	uint64_t		nr_items;
+};
+
+int
+rcbag_init(
+	struct xfs_mount	*mp,
+	uint64_t		max_rmaps,
+	struct rcbag		**bagp)
+{
+	struct rcbag		*bag;
+	char			*descr;
+	unsigned long long	maxbytes;
+	int			error;
+
+	bag = calloc(1, sizeof(struct rcbag));
+	if (!bag)
+		return ENOMEM;
+
+	bag->nr_items = 0;
+	bag->mp = mp;
+
+	/* Need to save space for the head block */
+	maxbytes = (1 + rcbagbt_calc_size(max_rmaps)) * getpagesize();
+	descr = kasprintf("xfs_repair (%s): refcount bag", mp->m_fsname);
+	error = -xmbuf_alloc(mp, descr, maxbytes, &bag->btp);
+	kfree(descr);
+	if (error)
+		goto out_bag;
+
+	error = rcbagbt_mem_init(mp, &bag->xfbtree, bag->btp);
+	if (error)
+		goto out_buftarg;
+
+	*bagp = bag;
+	return 0;
+
+out_buftarg:
+	xmbuf_free(bag->btp);
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
+
+	xfbtree_destroy(&bag->xfbtree);
+	xmbuf_free(bag->btp);
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
+	struct xfs_btree_cur		*cur;
+	int				has;
+	int				error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(_("allocating tx for refcount bag update\n"));
+
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
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
+
+	error = -xfbtree_trans_commit(&bag->xfbtree, tp);
+	if (error)
+		do_error(_("committing refcount bag record\n"));
+
+	libxfs_trans_cancel(tp);
+	bag->nr_items++;
+}
+
+/* Return the number of records in the bag. */
+uint64_t
+rcbag_count(
+	const struct rcbag	*rcbag)
+{
+	return rcbag->nr_items;
+}
+
+static inline uint32_t rcbag_rec_next_bno(const struct rcbag_rec *r)
+{
+	return r->rbg_startblock + r->rbg_blockcount;
+}
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
+	struct xfs_btree_cur		*cur;
+	uint32_t			next_bno = NULLAGBLOCK;
+	int				has;
+	int				error;
+
+	if (next_valid)
+		next_bno = next_rmap->rm_startblock;
+
+	cur = rcbagbt_mem_cursor(mp, NULL, &bag->xfbtree);
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
+		next_bno = min(next_bno, rcbag_rec_next_bno(&bagrec));
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
+	struct xfs_btree_cur	*cur;
+	int			has;
+	int			error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(_("allocating tx for refcount bag update\n"));
+
+	/* go to the right edge of the tree */
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
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
+		if (rcbag_rec_next_bno(&bagrec) != next_bno)
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
+
+	error = -xfbtree_trans_commit(&bag->xfbtree, tp);
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
+	iter->cur = rcbagbt_mem_cursor(mp, NULL, &bag->xfbtree);
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
+	iter->cur = NULL;
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
+	struct xfs_btree_cur		*cur;
+	unsigned long long		nr = 0;
+	int				has;
+	int				error;
+
+	cur = rcbagbt_mem_cursor(mp, NULL, &bag->xfbtree);
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
+}
diff --git a/repair/rcbag.h b/repair/rcbag.h
new file mode 100644
index 000000000000..92088e4e95fe
--- /dev/null
+++ b/repair/rcbag.h
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
index 11d69f9978c2..bed7c7a8f699 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -329,3 +329,62 @@ rcbagbt_destroy_cur_cache(void)
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
index acd7765c89c7..49191595f579 100644
--- a/repair/rcbag_btree.h
+++ b/repair/rcbag_btree.h
@@ -67,4 +67,11 @@ struct xfs_btree_cur *rcbagbt_mem_cursor(struct xfs_mount *mp,
 int rcbagbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
 		struct xfs_buftarg *btp);
 
+int rcbagbt_lookup_eq(struct xfs_btree_cur *cur,
+		const struct xfs_rmap_irec *rmap, int *success);
+int rcbagbt_get_rec(struct xfs_btree_cur *cur, struct rcbag_rec *rec, int *has);
+int rcbagbt_update(struct xfs_btree_cur *cur, const struct rcbag_rec *rec);
+int rcbagbt_insert(struct xfs_btree_cur *cur, const struct rcbag_rec *rec,
+		int *success);
+
 #endif /* __RCBAG_BTREE_H__ */

