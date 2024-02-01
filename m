Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D007112FB2C
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 20:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817631; cv=none; b=QL9LgkgQSEFT8w4EiTlYcNsr+g5gfP1HXc8nshCPvbZA3OjFSPewdKb54wYlY2sqNe01VRkX9Ln87qpovqAvIDyKHcyq6zYSb3BaXhsjMlktgNbLX6prKgYFad1Rp0vxZvRS4IqtHYkIxWMwXVYJYytppcPtLUIG3V1sFo9iakk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817631; c=relaxed/simple;
	bh=DWcNDheF69KRYsX5YHh4l+/VxjV5B7vlJVr6NlS0nTs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcd3OeI0ocWD58MXKYfjZtCj9R1HnZ0hO72YqcEpdKEwgEVcInUSi6tyGgrjUf3V5W2Vl/bFfDveYkolvCsFM5Fwzx5ah4THxMfQpX07wg2OpJuMwdecW+2r88Dn+A7SFGhJxbunWpHCoeo9/w1YQU1AdeGt9kzeMpYBZgksKTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvPbf1ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvPbf1ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDA2C433F1;
	Thu,  1 Feb 2024 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817631;
	bh=DWcNDheF69KRYsX5YHh4l+/VxjV5B7vlJVr6NlS0nTs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HvPbf1tsTbCEBz/o7ChcbIS763BmgeKA32VlUbLYKw/98phu+muMV1RbS63U4JBOJ
	 uzeDa0YUD1aFgXANk7qvEIpH7+n+9fREK8bXwsKtszRkCt7A8ee24xSizewvs7o9uE
	 WZC2/33Af9r6JR1ZL2cmQtCgrVtrZLSbr0Tkm/yYu0v5uSRi3X+IVBw55kXEUOA3Bp
	 NJkXB/ed7gSRzYml58nZy7mtBbI5C0d9rupzDWGXZUMvKnsytanvSARhI0KpmM8UkC
	 Mnn7E0Yw8SndyhB814xHeNPvcpdJfOIKux4ymfQsqn5XdLPxquhupp7YhVgF+FU7ox
	 OzW6KQ7gv9dmQ==
Date: Thu, 01 Feb 2024 12:00:30 -0800
Subject: [PATCH 2/3] xfs: create refcount bag structure for btree repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337904.1608752.3526552383569668536.stgit@frogsfrogsfrogs>
In-Reply-To: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
References: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile            |    1 
 fs/xfs/scrub/rcbag.c       |  307 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag.h       |   28 ++++
 fs/xfs/scrub/rcbag_btree.c |   58 ++++++++
 fs/xfs/scrub/rcbag_btree.h |    7 +
 5 files changed, 401 insertions(+)
 create mode 100644 fs/xfs/scrub/rcbag.c
 create mode 100644 fs/xfs/scrub/rcbag.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b9066cf851c3a..20f0bbe4b7102 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -200,6 +200,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   newbt.o \
 				   nlinks_repair.o \
 				   rcbag_btree.o \
+				   rcbag.o \
 				   reap.o \
 				   refcount_repair.o \
 				   repair.o \
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
new file mode 100644
index 0000000000000..e1e52bc20713f
--- /dev/null
+++ b/fs/xfs/scrub/rcbag.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
+#include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
+#include "xfs_error.h"
+#include "scrub/scrub.h"
+#include "scrub/rcbag_btree.h"
+#include "scrub/rcbag.h"
+#include "scrub/trace.h"
+
+struct rcbag {
+	struct xfs_mount	*mp;
+	struct xfbtree		xfbtree;
+	uint64_t		nr_items;
+};
+
+int
+rcbag_init(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*btp,
+	struct rcbag		**bagp)
+{
+	struct rcbag		*bag;
+	int			error;
+
+	bag = kzalloc(sizeof(struct rcbag), XCHK_GFP_FLAGS);
+	if (!bag)
+		return -ENOMEM;
+
+	bag->nr_items = 0;
+	bag->mp = mp;
+
+	error = rcbagbt_mem_init(mp, &bag->xfbtree, btp);
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
+	xfbtree_destroy(&bag->xfbtree);
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
+	struct xfs_btree_cur		*cur;
+	int				has;
+	int				error;
+
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
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
+
+	error = xfbtree_trans_commit(&bag->xfbtree, tp);
+	if (error)
+		return error;
+
+	bag->nr_items++;
+	return 0;
+
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	xfbtree_trans_cancel(&bag->xfbtree, tp);
+	return error;
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
+	struct xfs_btree_cur		*cur;
+	uint32_t			next_bno = NULLAGBLOCK;
+	int				has;
+	int				error;
+
+	if (next_valid)
+		next_bno = next_rmap->rm_startblock;
+
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
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
+		next_bno = min(next_bno, rcbag_rec_next_bno(&bagrec));
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
+
+	*next_bnop = next_bno;
+	return 0;
+
+out_cur:
+	xfs_btree_del_cursor(cur, error);
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
+	struct xfs_btree_cur	*cur;
+	int			has;
+	int			error;
+
+	/* go to the right edge of the tree */
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
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
+		if (rcbag_rec_next_bno(&bagrec) != next_bno)
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
+	return xfbtree_trans_commit(&bag->xfbtree, tp);
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	xfbtree_trans_cancel(&bag->xfbtree, tp);
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
+	struct xfs_btree_cur		*cur;
+	unsigned long long		nr = 0;
+	int				has;
+	int				error;
+
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
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
+}
diff --git a/fs/xfs/scrub/rcbag.h b/fs/xfs/scrub/rcbag.h
new file mode 100644
index 0000000000000..e29ef788ba72b
--- /dev/null
+++ b/fs/xfs/scrub/rcbag.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_RCBAG_H__
+#define __XFS_SCRUB_RCBAG_H__
+
+struct xfs_mount;
+struct rcbag;
+struct xfs_buftarg;
+
+int rcbag_init(struct xfs_mount *mp, struct xfs_buftarg *btp,
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
index 762960e012a05..709356dc62568 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -310,3 +310,61 @@ rcbagbt_destroy_cur_cache(void)
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
index 9202f7199b686..03cadb0325522 100644
--- a/fs/xfs/scrub/rcbag_btree.h
+++ b/fs/xfs/scrub/rcbag_btree.h
@@ -66,6 +66,13 @@ struct xfs_btree_cur *rcbagbt_mem_cursor(struct xfs_mount *mp,
 int rcbagbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
 		struct xfs_buftarg *btp);
 
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

