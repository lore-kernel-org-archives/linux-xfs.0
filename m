Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1690BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbiLaBIV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbiLaBIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:08:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE621573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:08:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9235BB81DCA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1EDC433D2;
        Sat, 31 Dec 2022 01:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448895;
        bh=1EeOU69l/0KeeDxkYP9TsNZrPzyh6HN+E/gVubojDOg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TYLOvo8xtFoBGWQdx/LSY5Mhf+D2qDnv/z6RjhXxM89SX6MbN7k3YGIYxZ6ut8nai
         3T+piL7/y/dG7fzcuaNkTmRKk1XLP5TaKVCf8NK/MFnQQWUEIJTY5YEfd+3S3kYdn7
         tZ/1Zsu8NYn4vNbPO4+viMHWuOv/GYr3smxYppksYnDtY0CuJkEAZ142DJ810j84+H
         WSex3I6z9Xp5CgdarcaPBvbAzaMGaYrueYgWIaqanYsa4lwbB0Yp8fD+ylFJeVv3ur
         rEd1zGMj94BZGhlTAaxL86Oy73Hc4Mu+ioS5cFGbKLOfs8mC415Kxdndcu22J2XaMf
         ZvmlsyTlmlAMw==
Subject: [PATCH 12/20] xfs: hoist xfs_iunlink to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:20 -0800
Message-ID: <167243864001.707335.15849086365597867277.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_inode_util.c |  276 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    4 +
 fs/xfs/xfs_inode.c             |  275 ----------------------------------------
 fs/xfs/xfs_inode.h             |    1 
 4 files changed, 280 insertions(+), 276 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 5c9954dd20b3..0c3ac4b07cc5 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -18,6 +18,10 @@
 #include "xfs_ialloc.h"
 #include "xfs_health.h"
 #include "xfs_bmap.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_ag.h"
+#include "xfs_iunlink_item.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -334,3 +338,275 @@ xfs_inode_init(
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
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index a73ccaea5582..e15cf94e0943 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -56,6 +56,10 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
+
 /* The libxfs client must provide this group of helper functions. */
 
 /* Handle legacy Irix sgid inheritance quirks. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index db1f521ac6d0..f69423504216 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -43,9 +43,6 @@
 
 struct kmem_cache *xfs_inode_cache;
 
-STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
-	struct xfs_inode *);
-
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
@@ -1729,39 +1726,6 @@ xfs_inactive(
 	xfs_qm_dqdetach(ip);
 }
 
-/*
- * In-Core Unlinked List Lookups
- * =============================
- *
- * Every inode is supposed to be reachable from some other piece of metadata
- * with the exception of the root directory.  Inodes with a connection to a
- * file descriptor but not linked from anywhere in the on-disk directory tree
- * are collectively known as unlinked inodes, though the filesystem itself
- * maintains links to these inodes so that on-disk metadata are consistent.
- *
- * XFS implements a per-AG on-disk hash table of unlinked inodes.  The AGI
- * header contains a number of buckets that point to an inode, and each inode
- * record has a pointer to the next inode in the hash chain.  This
- * singly-linked list causes scaling problems in the iunlink remove function
- * because we must walk that list to find the inode that points to the inode
- * being removed from the unlinked hash bucket list.
- *
- * Hence we keep an in-memory double linked list to link each inode on an
- * unlinked list. Because there are 64 unlinked lists per AGI, keeping pointer
- * based lists would require having 64 list heads in the perag, one for each
- * list. This is expensive in terms of memory (think millions of AGs) and cache
- * misses on lookups. Instead, use the fact that inodes on the unlinked list
- * must be referenced at the VFS level to keep them on the list and hence we
- * have an existence guarantee for inodes on the unlinked list.
- *
- * Given we have an existence guarantee, we can use lockless inode cache lookups
- * to resolve aginos to xfs inodes. This means we only need 8 bytes per inode
- * for the double linked unlinked list, and we don't need any extra locking to
- * keep the list safe as all manipulations are done under the AGI buffer lock.
- * Keeping the list up to date does not require memory allocation, just finding
- * the XFS inode and updating the next/prev unlinked list aginos.
- */
-
 /*
  * Find an inode on the unlinked list. This does not take references to the
  * inode as we have existence guarantees by holding the AGI buffer lock and that
@@ -1791,245 +1755,6 @@ xfs_iunlink_lookup(
 	return ip;
 }
 
-/* Update the prev pointer of the next agino. */
-static int
-xfs_iunlink_update_backref(
-	struct xfs_perag	*pag,
-	xfs_agino_t		prev_agino,
-	xfs_agino_t		next_agino)
-{
-	struct xfs_inode	*ip;
-
-	/* No update necessary if we are at the end of the list. */
-	if (next_agino == NULLAGINO)
-		return 0;
-
-	ip = xfs_iunlink_lookup(pag, next_agino);
-	if (!ip) {
-		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	ip->i_prev_unlinked = prev_agino;
-	return 0;
-}
-
-/*
- * Point the AGI unlinked bucket at an inode and log the results.  The caller
- * is responsible for validating the old value.
- */
-STATIC int
-xfs_iunlink_update_bucket(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_buf		*agibp,
-	unsigned int		bucket_index,
-	xfs_agino_t		new_agino)
-{
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		old_value;
-	int			offset;
-
-	ASSERT(xfs_verify_agino_or_null(pag, new_agino));
-
-	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
-			old_value, new_agino);
-
-	/*
-	 * We should never find the head of the list already set to the value
-	 * passed in because either we're adding or removing ourselves from the
-	 * head of the list.
-	 */
-	if (old_value == new_agino) {
-		xfs_buf_mark_corrupt(agibp);
-		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
-	offset = offsetof(struct xfs_agi, agi_unlinked) +
-			(sizeof(xfs_agino_t) * bucket_index);
-	xfs_trans_log_buf(tp, agibp, offset, offset + sizeof(xfs_agino_t) - 1);
-	return 0;
-}
-
-static int
-xfs_iunlink_insert_inode(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_buf		*agibp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		next_agino;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	int			error;
-
-	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the pointer isn't garbage and that this inode
-	 * isn't already on the list.
-	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(pag, next_agino)) {
-		xfs_buf_mark_corrupt(agibp);
-		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Update the prev pointer in the next inode to point back to this
-	 * inode.
-	 */
-	error = xfs_iunlink_update_backref(pag, agino, next_agino);
-	if (error)
-		return error;
-
-	if (next_agino != NULLAGINO) {
-		/*
-		 * There is already another inode in the bucket, so point this
-		 * inode to the current head of the list.
-		 */
-		error = xfs_iunlink_log_inode(tp, ip, pag, next_agino);
-		if (error)
-			return error;
-		ip->i_next_unlinked = next_agino;
-	}
-
-	/* Point the head of the list to point to this inode. */
-	ip->i_prev_unlinked = NULLAGINO;
-	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
-}
-
-/*
- * This is called when the inode's link count has gone to 0 or we are creating
- * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
- *
- * We place the on-disk inode on a list in the AGI.  It will be pulled from this
- * list when the inode is freed.
- */
-int
-xfs_iunlink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
-	struct xfs_buf		*agibp;
-	int			error;
-
-	ASSERT(VFS_I(ip)->i_nlink == 0);
-	ASSERT(VFS_I(ip)->i_mode != 0);
-	trace_xfs_iunlink(ip);
-
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(pag, tp, &agibp);
-	if (error)
-		goto out;
-
-	error = xfs_iunlink_insert_inode(tp, pag, agibp, ip);
-out:
-	xfs_perag_put(pag);
-	return error;
-}
-
-static int
-xfs_iunlink_remove_inode(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_buf		*agibp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	xfs_agino_t		head_agino;
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	int			error;
-
-	trace_xfs_iunlink_remove(ip);
-
-	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the head pointer isn't garbage.
-	 */
-	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (!xfs_verify_agino(pag, head_agino)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				agi, sizeof(*agi));
-		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Set our inode's next_unlinked pointer to NULL and then return
-	 * the old pointer value so that we can update whatever was previous
-	 * to us in the list to point to whatever was next in the list.
-	 */
-	error = xfs_iunlink_log_inode(tp, ip, pag, NULLAGINO);
-	if (error)
-		return error;
-
-	/*
-	 * Update the prev pointer in the next inode to point back to previous
-	 * inode in the chain.
-	 */
-	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
-			ip->i_next_unlinked);
-	if (error)
-		return error;
-
-	if (head_agino != agino) {
-		struct xfs_inode	*prev_ip;
-
-		prev_ip = xfs_iunlink_lookup(pag, ip->i_prev_unlinked);
-		if (!prev_ip) {
-			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
-			return -EFSCORRUPTED;
-		}
-
-		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
-				ip->i_next_unlinked);
-		prev_ip->i_next_unlinked = ip->i_next_unlinked;
-	} else {
-		/* Point the head of the list to the next unlinked inode. */
-		error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
-				ip->i_next_unlinked);
-	}
-
-	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = 0;
-	return error;
-}
-
-/*
- * Pull the on-disk inode from the AGI unlinked list.
- */
-STATIC int
-xfs_iunlink_remove(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_inode	*ip)
-{
-	struct xfs_buf		*agibp;
-	int			error;
-
-	trace_xfs_iunlink_remove(ip);
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(pag, tp, &agibp);
-	if (error)
-		return error;
-
-	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
-}
-
 /*
  * Look up the inode number specified and if it is not already marked XFS_ISTALE
  * mark it stale. We should only find clean inodes in this lookup that aren't
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b99c62f14919..d07763312a27 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,7 +574,6 @@ extern struct kmem_cache	*xfs_inode_cache;
 
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
-int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 struct xfs_inode *xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino);
 
 void xfs_end_io(struct work_struct *work);

