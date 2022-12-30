Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CBFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiLaCHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:07:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A7513F97
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9B1F61CC1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8E2C433D2;
        Sat, 31 Dec 2022 02:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452433;
        bh=am35Sg+RprmpKPpuBQUNVLKputXg7NPJ2gHfdcpeLTc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IP2l7QLOAg3nNYXzPbU+9HuUIP9uYxqvRfTqXo6y7zEo1hSFaWPRh3ar8SF4i0cVL
         9mVaxg769t3EY9KgvpzkS1TiqiZGVfmgh8bZM4i4dkJB5pZdLi6y9njmynGnKddWuI
         kRs6sM9/BX/od6+cko+ym/1dajUEVKZovRecY/8CrqEQ82CNclcWV7zA3nADPSQ6z0
         7FHQvVPXLg29DMnjzwS2TGVhQbeE7H9Z/tVrZxNFyaHy0aJRjDyciY1EwL6l7U5eb9
         MrZa4RyTkuEB/PQXiolgjsVk6Q5bpBLqTagzQnVK5hoSt1oyyUUx25K+zyhibym0I2
         AORrYsBAZWPpQ==
Subject: [PATCH 16/26] xfs: hoist xfs_iunlink to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875512.723621.5748794528457709093.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move xfs_iunlink and xfs_iunlink_remove to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h     |    1 
 include/xfs_trace.h     |    6 +
 libxfs/Makefile         |    2 
 libxfs/inode.c          |    2 
 libxfs/iunlink.c        |  126 ++++++++++++++++++++++
 libxfs/iunlink.h        |   22 ++++
 libxfs/libxfs_priv.h    |   28 +++++
 libxfs/xfs_inode_util.c |  275 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |    4 +
 9 files changed, 466 insertions(+)
 create mode 100644 libxfs/iunlink.c
 create mode 100644 libxfs/iunlink.h


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 5c806b3a58c..234f8d3affa 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -135,6 +135,7 @@ typedef struct xfs_inode {
 
 	/* unlinked list pointers */
 	xfs_agino_t		i_next_unlinked;
+	xfs_agino_t		i_prev_unlinked;
 
 	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
 	unsigned int		i_cformat;	/* format of cow fork */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a6ba6fc93bf..d94d8d29bed 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -349,4 +349,10 @@
 #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)		((c) = (c))
 
+#define trace_xfs_iunlink_update_bucket(...)	((void) 0)
+#define trace_xfs_iunlink_update_dinode(...)	((void) 0)
+#define trace_xfs_iunlink(...)			((void) 0)
+#define trace_xfs_iunlink_remove(...)		((void) 0)
+#define trace_xfs_iunlink_map_prev_fallback(...)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index f9bc82cc9e8..94f5968e862 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -23,6 +23,7 @@ HFILES = \
 	libxfs_io.h \
 	libxfs_api_defs.h \
 	init.h \
+	iunlink.h \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
@@ -65,6 +66,7 @@ CFILES = cache.c \
 	defer_item.c \
 	init.c \
 	inode.c \
+	iunlink.c \
 	kmem.c \
 	logitem.c \
 	rdwr.c \
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 8ef2b654769..1a27016a763 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -169,6 +169,8 @@ libxfs_iget(
 	ip->i_mount = mp;
 	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_next_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = NULLAGINO;
 	spin_lock_init(&VFS_I(ip)->i_lock);
 
 	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, 0);
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
new file mode 100644
index 00000000000..2123dfdcbbf
--- /dev/null
+++ b/libxfs/iunlink.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020-2022, Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "libxfs_io.h"
+#include "init.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_ag.h"
+#include "iunlink.h"
+#include "xfs_trace.h"
+
+/* in memory log item structure */
+struct xfs_iunlink_item {
+	struct xfs_inode	*ip;
+	struct xfs_perag	*pag;
+	xfs_agino_t		next_agino;
+	xfs_agino_t		old_agino;
+};
+
+/*
+ * Look up the inode cluster buffer and log the on-disk unlinked inode change
+ * we need to make.
+ */
+static int
+xfs_iunlink_log_dinode(
+	struct xfs_trans	*tp,
+	struct xfs_iunlink_item	*iup)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip = iup->ip;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*ibp;
+	int			offset;
+	int			error;
+
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
+	if (error)
+		return error;
+	/*
+	 * Don't log the unlinked field on stale buffers as this may be the
+	 * transaction that frees the inode cluster and relogging the buffer
+	 * here will incorrectly remove the stale state.
+	 */
+	if (ibp->b_flags & LIBXFS_B_STALE)
+		goto out;
+
+	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
+
+	/* Make sure the old pointer isn't garbage. */
+	if (be32_to_cpu(dip->di_next_unlinked) != iup->old_agino) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	trace_xfs_iunlink_update_dinode(mp, iup->pag->pag_agno,
+			XFS_INO_TO_AGINO(mp, ip->i_ino),
+			be32_to_cpu(dip->di_next_unlinked), iup->next_agino);
+
+	dip->di_next_unlinked = cpu_to_be32(iup->next_agino);
+	offset = ip->i_imap.im_boffset +
+			offsetof(struct xfs_dinode, di_next_unlinked);
+
+	xfs_dinode_calc_crc(mp, dip);
+	xfs_trans_inode_buf(tp, ibp);
+	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
+	return 0;
+out:
+	xfs_trans_brelse(tp, ibp);
+	return error;
+}
+
+/*
+ * Initialize the inode log item for a newly allocated (in-core) inode.
+ *
+ * Inode extents can only reside within an AG. Hence specify the starting
+ * block for the inode chunk by offset within an AG as well as the
+ * length of the allocated extent.
+ *
+ * This joins the item to the transaction and marks it dirty so
+ * that we don't need a separate call to do this, nor does the
+ * caller need to know anything about the iunlink item.
+ */
+int
+xfs_iunlink_log_inode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_iunlink_item	iup = {
+		.ip		= ip,
+		.pag		= pag,
+		.next_agino	= next_agino,
+		.old_agino	= ip->i_next_unlinked,
+	};
+
+	ASSERT(xfs_verify_agino_or_null(pag, next_agino));
+	ASSERT(xfs_verify_agino_or_null(pag, ip->i_next_unlinked));
+
+	/*
+	 * Since we're updating a linked list, we should never find that the
+	 * current pointer is the same as the new value, unless we're
+	 * terminating the list.
+	 */
+	if (ip->i_next_unlinked == next_agino) {
+		if (next_agino != NULLAGINO)
+			return -EFSCORRUPTED;
+		return 0;
+	}
+
+	return xfs_iunlink_log_dinode(tp, &iup);
+}
+
diff --git a/libxfs/iunlink.h b/libxfs/iunlink.h
new file mode 100644
index 00000000000..fec6a515181
--- /dev/null
+++ b/libxfs/iunlink.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020-2022, Red Hat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef XFS_IUNLINK_ITEM_H
+#define XFS_IUNLINK_ITEM_H	1
+
+struct xfs_trans;
+struct xfs_inode;
+struct xfs_perag;
+
+static inline struct xfs_inode *
+xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino)
+{
+	return NULL;
+}
+
+int xfs_iunlink_log_inode(struct xfs_trans *tp, struct xfs_inode *ip,
+			struct xfs_perag *pag, xfs_agino_t next_agino);
+
+#endif	/* XFS_IUNLINK_ITEM_H */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index acad5ccd228..90335331cde 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -518,6 +518,8 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_filestream_lookup_ag(ip)		(0)
 #define xfs_filestream_new_ag(ip,ag)		(0)
 
+#define xfs_trans_inode_buf(tp, bp)		((void) 0)
+
 /* quota bits */
 #define xfs_trans_mod_dquot_byino(t,i,f,d)		((void) 0)
 #define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
@@ -690,6 +692,32 @@ static inline void xfs_buf_hash_destroy(struct xfs_perag *pag) { }
 static inline int xfs_iunlink_init(struct xfs_perag *pag) { return 0; }
 static inline void xfs_iunlink_destroy(struct xfs_perag *pag) { }
 
+static inline xfs_agino_t
+xfs_iunlink_lookup_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino)
+{
+	return NULLAGINO;
+}
+
+static inline int
+xfs_iunlink_add_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		this_agino)
+{
+	return 0;
+}
+
+static inline int
+xfs_iunlink_change_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	xfs_agino_t		next_unlinked)
+{
+	return 0;
+}
+
 xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *mp,
 		xfs_agnumber_t agcount);
 
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 21196a899da..4b19edd9ab1 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -17,6 +17,9 @@
 #include "xfs_ialloc.h"
 #include "xfs_health.h"
 #include "xfs_bmap.h"
+#include "xfs_trace.h"
+#include "xfs_ag.h"
+#include "iunlink.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -333,3 +336,275 @@ xfs_inode_init(
 	/* now that we have an i_mode we can setup the inode structure */
 	xfs_setup_inode(ip);
 }
+
+/*
+ * In-Core Unlinked List Lookups
+ * =============================
+ *
+ * Every inode is supposed to be reachable from some other piece of metadata
+ * with the exception of the root directory.  Inodes with a connection to a
+ * file descriptor but not linked from anywhere in the on-disk directory tree
+ * are collectively known as unlinked inodes, though the filesystem itself
+ * maintains links to these inodes so that on-disk metadata are consistent.
+ *
+ * XFS implements a per-AG on-disk hash table of unlinked inodes.  The AGI
+ * header contains a number of buckets that point to an inode, and each inode
+ * record has a pointer to the next inode in the hash chain.  This
+ * singly-linked list causes scaling problems in the iunlink remove function
+ * because we must walk that list to find the inode that points to the inode
+ * being removed from the unlinked hash bucket list.
+ *
+ * Hence we keep an in-memory double linked list to link each inode on an
+ * unlinked list. Because there are 64 unlinked lists per AGI, keeping pointer
+ * based lists would require having 64 list heads in the perag, one for each
+ * list. This is expensive in terms of memory (think millions of AGs) and cache
+ * misses on lookups. Instead, use the fact that inodes on the unlinked list
+ * must be referenced at the VFS level to keep them on the list and hence we
+ * have an existence guarantee for inodes on the unlinked list.
+ *
+ * Given we have an existence guarantee, we can use lockless inode cache lookups
+ * to resolve aginos to xfs inodes. This means we only need 8 bytes per inode
+ * for the double linked unlinked list, and we don't need any extra locking to
+ * keep the list safe as all manipulations are done under the AGI buffer lock.
+ * Keeping the list up to date does not require memory allocation, just finding
+ * the XFS inode and updating the next/prev unlinked list aginos.
+ */
+
+/* Update the prev pointer of the next agino. */
+static int
+xfs_iunlink_update_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_inode	*ip;
+
+	/* No update necessary if we are at the end of the list. */
+	if (next_agino == NULLAGINO)
+		return 0;
+
+	ip = xfs_iunlink_lookup(pag, next_agino);
+	if (!ip) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	ip->i_prev_unlinked = prev_agino;
+	return 0;
+}
+
+/*
+ * Point the AGI unlinked bucket at an inode and log the results.  The caller
+ * is responsible for validating the old value.
+ */
+STATIC int
+xfs_iunlink_update_bucket(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	unsigned int		bucket_index,
+	xfs_agino_t		new_agino)
+{
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		old_value;
+	int			offset;
+
+	ASSERT(xfs_verify_agino_or_null(pag, new_agino));
+
+	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
+			old_value, new_agino);
+
+	/*
+	 * We should never find the head of the list already set to the value
+	 * passed in because either we're adding or removing ourselves from the
+	 * head of the list.
+	 */
+	if (old_value == new_agino) {
+		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
+	offset = offsetof(struct xfs_agi, agi_unlinked) +
+			(sizeof(xfs_agino_t) * bucket_index);
+	xfs_trans_log_buf(tp, agibp, offset, offset + sizeof(xfs_agino_t) - 1);
+	return 0;
+}
+
+static int
+xfs_iunlink_insert_inode(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		next_agino;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			error;
+
+	/*
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the pointer isn't garbage and that this inode
+	 * isn't already on the list.
+	 */
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (next_agino == agino ||
+	    !xfs_verify_agino_or_null(pag, next_agino)) {
+		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Update the prev pointer in the next inode to point back to this
+	 * inode.
+	 */
+	error = xfs_iunlink_update_backref(pag, agino, next_agino);
+	if (error)
+		return error;
+
+	if (next_agino != NULLAGINO) {
+		/*
+		 * There is already another inode in the bucket, so point this
+		 * inode to the current head of the list.
+		 */
+		error = xfs_iunlink_log_inode(tp, ip, pag, next_agino);
+		if (error)
+			return error;
+		ip->i_next_unlinked = next_agino;
+	}
+
+	/* Point the head of the list to point to this inode. */
+	ip->i_prev_unlinked = NULLAGINO;
+	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
+}
+
+/*
+ * This is called when the inode's link count has gone to 0 or we are creating
+ * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
+ *
+ * We place the on-disk inode on a list in the AGI.  It will be pulled from this
+ * list when the inode is freed.
+ */
+int
+xfs_iunlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*agibp;
+	int			error;
+
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(VFS_I(ip)->i_mode != 0);
+	trace_xfs_iunlink(ip);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(pag, tp, &agibp);
+	if (error)
+		goto out;
+
+	error = xfs_iunlink_insert_inode(tp, pag, agibp, ip);
+out:
+	xfs_perag_put(pag);
+	return error;
+}
+
+static int
+xfs_iunlink_remove_inode(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		head_agino;
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/*
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the head pointer isn't garbage.
+	 */
+	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (!xfs_verify_agino(pag, head_agino)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				agi, sizeof(*agi));
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Set our inode's next_unlinked pointer to NULL and then return
+	 * the old pointer value so that we can update whatever was previous
+	 * to us in the list to point to whatever was next in the list.
+	 */
+	error = xfs_iunlink_log_inode(tp, ip, pag, NULLAGINO);
+	if (error)
+		return error;
+
+	/*
+	 * Update the prev pointer in the next inode to point back to previous
+	 * inode in the chain.
+	 */
+	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
+			ip->i_next_unlinked);
+	if (error)
+		return error;
+
+	if (head_agino != agino) {
+		struct xfs_inode	*prev_ip;
+
+		prev_ip = xfs_iunlink_lookup(pag, ip->i_prev_unlinked);
+		if (!prev_ip) {
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
+			return -EFSCORRUPTED;
+		}
+
+		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
+				ip->i_next_unlinked);
+		prev_ip->i_next_unlinked = ip->i_next_unlinked;
+	} else {
+		/* Point the head of the list to the next unlinked inode. */
+		error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
+				ip->i_next_unlinked);
+	}
+
+	ip->i_next_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
+	return error;
+}
+
+/*
+ * Pull the on-disk inode from the AGI unlinked list.
+ */
+int
+xfs_iunlink_remove(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_buf		*agibp;
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(pag, tp, &agibp);
+	if (error)
+		return error;
+
+	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index a73ccaea558..e15cf94e094 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -56,6 +56,10 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
+
 /* The libxfs client must provide this group of helper functions. */
 
 /* Handle legacy Irix sgid inheritance quirks. */

