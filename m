Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbfAaXSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 18:18:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VNDwXE084160
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:42 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2q8eyuumud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:42 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0VNIfrx030647
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:41 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0VNIfWd002138
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:41 GMT
Subject: [PATCH 8/8] xfs: cache unlinked pointers in an rhashtable
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Jan 2019 15:18:40 -0800
Message-ID: <154897672012.26065.1375987197453969157.stgit@magnolia>
In-Reply-To: <154897667054.26065.13164381203002725289.stgit@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use a rhashtable to cache the unlinked list incore.  This should speed
up unlinked processing considerably when there are a lot of inodes on
the unlinked list because iunlink_remove no longer has to traverse an
entire bucket list to find which inode points to the one being removed.

The incore list structure records "X.next_unlinked = Y" relations, with
the rhashtable using Y to index the records.  This makes finding the
inode X that points to a inode Y very quick.  If our cache fails to find
anything we can always fall back on the old method.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c       |  216 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h       |   10 ++
 fs/xfs/xfs_log_recover.c |   12 ++-
 fs/xfs/xfs_mount.c       |    7 +
 fs/xfs/xfs_mount.h       |    1 
 5 files changed, 245 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 56349497d75b..eec3c6109fc6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1880,6 +1880,189 @@ xfs_inactive(
 	xfs_qm_dqdetach(ip);
 }
 
+/*
+ * Faster In-Core Unlinked List Lookups
+ * ====================================
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
+ * What if we modelled the unlinked list as a collection of records capturing
+ * "X.next_unlinked = Y" relations?  If we indexed those records on Y, we'd
+ * have a fast way to look up unlinked list predecessors, which avoids the
+ * slow list walk.  That's exactly what we do here (in-core) with a per-AG
+ * rhashtable.
+ */
+
+/* Capture a "X.next_unlinked = Y" relationship. */
+struct xfs_iunlink {
+	struct rhash_head	iu_rhash_head;
+	xfs_agino_t		iu_agino;
+	xfs_agino_t		iu_next_unlinked;
+};
+
+struct xfs_iunlink_key {
+	xfs_agino_t		iu_next_unlinked;
+};
+
+/* Unlinked list predecessor lookup hashtable construction */
+static int
+_xfs_iunlink_obj_cmp(
+	struct rhashtable_compare_arg	*arg,
+	const void			*obj)
+{
+	const struct xfs_iunlink_key	*key = arg->key;
+	const struct xfs_iunlink	*iu = obj;
+
+	if (iu->iu_next_unlinked != key->iu_next_unlinked)
+		return 1;
+	return 0;
+}
+
+static const struct rhashtable_params xfs_iunlink_hash_params = {
+	.min_size		= XFS_AGI_UNLINKED_BUCKETS,
+	.nelem_hint		= 512,
+	.key_len		= sizeof(xfs_agino_t),
+	.key_offset		= offsetof(struct xfs_iunlink, iu_next_unlinked),
+	.head_offset		= offsetof(struct xfs_iunlink, iu_rhash_head),
+	.automatic_shrinking	= true,
+	.obj_cmpfn		= _xfs_iunlink_obj_cmp,
+};
+
+/*
+ * Return X (in @prev_agino), where X.next_unlinked == @agino.  Returns -ENOENT
+ * if no such relation is found.
+ */
+int
+xfs_iunlink_lookup_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	xfs_agino_t		*prev_agino)
+{
+	struct xfs_iunlink_key	key = { .iu_next_unlinked = agino };
+	struct xfs_iunlink	*iu;
+
+	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &key,
+			xfs_iunlink_hash_params);
+	if (!iu)
+		return -ENOENT;
+	*prev_agino = iu->iu_agino;
+	return 0;
+}
+
+/* Remember that @prev_agino.next_unlinked = @this_agino. */
+int
+xfs_iunlink_add_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		this_agino)
+{
+	struct xfs_iunlink	*iu;
+
+	iu = kmem_zalloc(sizeof(*iu), KM_SLEEP | KM_NOFS);
+	iu->iu_agino = prev_agino;
+	iu->iu_next_unlinked = this_agino;
+
+	return rhashtable_insert_fast(&pag->pagi_unlinked_hash,
+			&iu->iu_rhash_head, xfs_iunlink_hash_params);
+}
+
+/* Forget that X.next_unlinked = @agino. */
+int
+xfs_iunlink_forget_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino)
+{
+	struct xfs_iunlink_key	key = { .iu_next_unlinked = agino };
+	struct xfs_iunlink	*iu;
+	int			error;
+
+	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &key,
+			xfs_iunlink_hash_params);
+	if (!iu)
+		return -ENOENT;
+
+	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
+			&iu->iu_rhash_head, xfs_iunlink_hash_params);
+	if (error)
+		return error;
+
+	kmem_free(iu);
+	return 0;
+}
+
+
+/* Replace X.next_unlinked = @agino with X.next_unlinked = @next_unlinked. */
+int
+xfs_iunlink_change_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	xfs_agino_t		next_unlinked)
+{
+	struct xfs_iunlink_key	key = { .iu_next_unlinked = agino };
+	struct xfs_iunlink	*iu;
+	int			error;
+
+	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &key,
+			xfs_iunlink_hash_params);
+	if (!iu)
+		return -ENOENT;
+
+	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
+			&iu->iu_rhash_head, xfs_iunlink_hash_params);
+	if (error)
+		return error;
+
+	iu->iu_next_unlinked = next_unlinked;
+
+	return rhashtable_insert_fast(&pag->pagi_unlinked_hash,
+			&iu->iu_rhash_head, xfs_iunlink_hash_params);
+}
+
+/* Set up the in-core predecessor structures. */
+int
+xfs_iunlink_init(
+	struct xfs_perag	*pag)
+{
+	return rhashtable_init(&pag->pagi_unlinked_hash,
+			&xfs_iunlink_hash_params);
+}
+
+/* Free the in-core predecessor structures. */
+static void
+xfs_iunlink_free_item(
+	void			*ptr,
+	void			*arg)
+{
+	struct xfs_iunlink	*iu = ptr;
+	bool			*freed_anything = arg;
+
+	*freed_anything = true;
+	kmem_free(iu);
+}
+
+void
+xfs_iunlink_destroy(
+	struct xfs_perag	*pag)
+{
+	bool			freed_anything = false;
+
+	rhashtable_free_and_destroy(&pag->pagi_unlinked_hash,
+			xfs_iunlink_free_item, &freed_anything);
+
+	ASSERT(freed_anything == false || XFS_FORCED_SHUTDOWN(pag->pag_mount));
+}
+
 /*
  * Point the AGI unlinked bucket at an inode and log the results.  The caller
  * is responsible for validating the old value.
@@ -2072,6 +2255,9 @@ xfs_iunlink(
 		if (error)
 			goto out_unlock;
 		ASSERT(old_agino == NULLAGINO);
+		error = xfs_iunlink_add_backref(pag, agino, next_agino);
+		if (error)
+			goto out_unlock;
 	}
 
 	/* Point the head of the list to point to this inode. */
@@ -2144,6 +2330,17 @@ xfs_iunlink_map_prev(
 
 	ASSERT(head_agino != target_agino);
 
+	/* See if our backref cache can find it faster. */
+	error = xfs_iunlink_lookup_backref(pag, target_agino, &next_agino);
+	if (error == 0) {
+		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
+		error = xfs_iunlink_map_ino(tp, next_ino, &last_imap,
+				&last_dip, &last_ibp);
+		if (error)
+			return error;
+		goto out;
+	}
+
 	next_agino = head_agino;
 	while (next_agino != target_agino) {
 		xfs_agino_t	unlinked_agino;
@@ -2169,6 +2366,7 @@ xfs_iunlink_map_prev(
 		next_agino = unlinked_agino;
 	}
 
+out:
 	/* Should never happen, but don't return garbage. */
 	if (next_ino == NULLFSINO)
 		return -EFSCORRUPTED;
@@ -2243,6 +2441,12 @@ xfs_iunlink_remove(
 		if (error)
 			goto out_unlock;
 
+		if (next_agino != NULLAGINO) {
+			error = xfs_iunlink_forget_backref(pag, next_agino);
+			if (error)
+				goto out_unlock;
+		}
+
 		/* Point the head of the list to the next unlinked inode. */
 		error = xfs_iunlink_update_bucket(tp, agibp, bucket_index,
 				next_agino);
@@ -2265,10 +2469,22 @@ xfs_iunlink_remove(
 				&next_agino);
 		if (error)
 			goto out_unlock;
+		if (next_agino != NULLAGINO) {
+			error = xfs_iunlink_forget_backref(pag, next_agino);
+			if (error)
+				goto out_unlock;
+		}
 
 		/* Point the previous inode on the list to the next inode. */
 		xfs_iunlink_update_dinode(tp, last_ibp, last_dip, &imap,
 				next_ino, next_agino);
+		if (next_agino == NULLAGINO)
+			error = xfs_iunlink_forget_backref(pag, agino);
+		else
+			error = xfs_iunlink_change_backref(pag, agino,
+					next_agino);
+		if (error)
+			goto out_unlock;
 	}
 	pag->pagi_unlinked_count--;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index be2014520155..9690f0d32e33 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -500,4 +500,14 @@ extern struct kmem_zone	*xfs_inode_zone;
 
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
 
+int xfs_iunlink_init(struct xfs_perag *pag);
+void xfs_iunlink_destroy(struct xfs_perag *pag);
+int xfs_iunlink_lookup_backref(struct xfs_perag *pag, xfs_agino_t agino,
+		xfs_agino_t *prev_agino);
+int xfs_iunlink_add_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
+		xfs_agino_t this_agino);
+int xfs_iunlink_forget_backref(struct xfs_perag *pag, xfs_agino_t agino);
+int xfs_iunlink_change_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
+		xfs_agino_t this_agino);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c920b8aeba01..909b70550aa8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5078,12 +5078,22 @@ xlog_recover_process_one_iunlink(
 	agino = be32_to_cpu(dip->di_next_unlinked);
 	xfs_buf_relse(ibp);
 
-	/* Make sure the in-core data knows about this unlinked inode. */
+	/*
+	 * Make sure the in-core data knows about this unlinked inode.  Since
+	 * our iunlinks recovery basically just deletes the head of a bucket
+	 * list until the bucket is empty, we need only to add the backref from
+	 * the current list item to the next one, if this isn't the list tail.
+	 */
 	pag = xfs_perag_get(mp, agno);
 	mutex_lock(&pag->pagi_unlinked_lock);
 	pag->pagi_unlinked_count++;
+	if (agino != NULLAGINO)
+		error = xfs_iunlink_add_backref(pag, XFS_INO_TO_AGINO(mp, ino),
+				agino);
 	mutex_unlock(&pag->pagi_unlinked_lock);
 	xfs_perag_put(pag);
+	if (error)
+		goto fail_iput;
 
 	/*
 	 * Prevent any DMAPI event from being sent when the reference on
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6bfc985669e0..4eb97ddc915e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -151,6 +151,7 @@ xfs_free_perag(
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		ASSERT(pag->pagi_unlinked_count == 0 ||
 		       XFS_FORCED_SHUTDOWN(mp));
+		xfs_iunlink_destroy(pag);
 		mutex_destroy(&pag->pagi_unlinked_lock);
 		xfs_buf_hash_destroy(pag);
 		mutex_destroy(&pag->pag_ici_reclaim_lock);
@@ -231,6 +232,9 @@ xfs_initialize_perag(
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
 		mutex_init(&pag->pagi_unlinked_lock);
+		error = xfs_iunlink_init(pag);
+		if (error)
+			goto out_iunlink_mutex;
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
@@ -241,6 +245,8 @@ xfs_initialize_perag(
 	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
 	return 0;
 
+out_iunlink_mutex:
+	mutex_destroy(&pag->pagi_unlinked_lock);
 out_hash_destroy:
 	xfs_buf_hash_destroy(pag);
 out_free_pag:
@@ -253,6 +259,7 @@ xfs_initialize_perag(
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
+		xfs_iunlink_destroy(pag);
 		mutex_destroy(&pag->pagi_unlinked_lock);
 		mutex_destroy(&pag->pag_ici_reclaim_lock);
 		kmem_free(pag);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0fcc6b6a4f67..27a433e93d32 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -392,6 +392,7 @@ typedef struct xfs_perag {
 	/* unlinked inodes */
 	struct mutex		pagi_unlinked_lock;
 	uint32_t		pagi_unlinked_count;
+	struct rhashtable	pagi_unlinked_hash;
 } xfs_perag_t;
 
 static inline struct xfs_ag_resv *
