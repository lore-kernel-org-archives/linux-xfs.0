Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55826 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbfBDSAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 13:00:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x14HnWJS039408
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 18:00:13 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qd97eppny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Feb 2019 18:00:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x14I06WR004527
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 18:00:07 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x14I06Pr027146
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 18:00:06 GMT
Subject: [PATCH 10/10] xfs: cache unlinked pointers in an rhashtable
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Feb 2019 10:00:05 -0800
Message-ID: <154930320519.31814.7868551876308474527.stgit@magnolia>
In-Reply-To: <154930313674.31814.17994684613232167921.stgit@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
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

FWIW this drastically reduces the amount of time it takes to remove
inodes from the unlinked list.  I wrote a program to open a lot of
O_TMPFILE files and then close them in the same order, which takes
a very long time if we have to traverse the unlinked lists.  With the
ptach, I see:

+ /d/t/tmpfile/tmpfile
Opened 193531 files in 6.33s.
Closed 193531 files in 5.86s

real    0m12.192s
user    0m0.064s
sys     0m11.619s
+ cd /
+ umount /mnt

real    0m0.050s
user    0m0.004s
sys     0m0.030s

And without the patch:

+ /d/t/tmpfile/tmpfile
Opened 193588 files in 6.35s.
Closed 193588 files in 751.61s

real    12m38.853s
user    0m0.084s
sys     12m34.470s
+ cd /
+ umount /mnt

real    0m0.086s
user    0m0.000s
sys     0m0.060s

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c       |  207 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h       |    9 ++
 fs/xfs/xfs_log_recover.c |   12 ++-
 fs/xfs/xfs_mount.c       |    5 +
 fs/xfs/xfs_mount.h       |    1 
 5 files changed, 233 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b9696d762c8f..baee8c894447 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1880,6 +1880,167 @@ xfs_inactive(
 	xfs_qm_dqdetach(ip);
 }
 
+/*
+ * In-Core Unlinked List Lookups
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
+/* Unlinked list predecessor lookup hashtable construction */
+static int
+xfs_iunlink_obj_cmpfn(
+	struct rhashtable_compare_arg	*arg,
+	const void			*obj)
+{
+	const xfs_agino_t		*key = arg->key;
+	const struct xfs_iunlink	*iu = obj;
+
+	if (iu->iu_next_unlinked != *key)
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
+	.obj_cmpfn		= xfs_iunlink_obj_cmpfn,
+};
+
+/*
+ * Return X, where X.next_unlinked == @agino.  Returns NULLAGINO if no such
+ * relation is found.
+ */
+xfs_agino_t
+xfs_iunlink_lookup_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino)
+{
+	struct xfs_iunlink	*iu;
+
+	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
+			xfs_iunlink_hash_params);
+	return iu ? iu->iu_agino : NULLAGINO;
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
+/*
+ * Replace X.next_unlinked = @agino with X.next_unlinked = @next_unlinked.
+ * If @next_unlinked is NULLAGINO, we drop the backref and exit.
+ */
+int
+xfs_iunlink_change_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	xfs_agino_t		next_unlinked)
+{
+	struct xfs_iunlink	*iu;
+	int			error;
+
+	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
+			xfs_iunlink_hash_params);
+	if (!iu)
+		return -ENOENT;
+
+	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
+			&iu->iu_rhash_head, xfs_iunlink_hash_params);
+	if (error)
+		return error;
+
+	/*
+	 * If there is no new next entry just free our item and return.
+	 */
+	if (next_unlinked == NULLAGINO) {
+		kmem_free(iu);
+		return 0;
+	}
+
+	/*
+	 * Else update the hash table to the new entry.
+	 */
+	iu->iu_next_unlinked = next_unlinked;
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
@@ -2055,6 +2216,14 @@ xfs_iunlink(
 		if (error)
 			goto out;
 		ASSERT(old_agino == NULLAGINO);
+
+		/*
+		 * agino has been unlinked, add a backref from the next inode
+		 * back to agino.
+		 */
+		error = xfs_iunlink_add_backref(pag, agino, next_agino);
+		if (error)
+			goto out;
 	}
 
 	/* Point the head of the list to point to this inode. */
@@ -2127,6 +2296,17 @@ xfs_iunlink_map_prev(
 
 	ASSERT(head_agino != target_agino);
 
+	/* See if our backref cache can find it faster. */
+	next_agino = xfs_iunlink_lookup_backref(pag, target_agino);
+	if (next_agino != NULLAGINO) {
+		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
+		error = xfs_iunlink_map_ino(tp, next_ino, imap, &last_dip,
+				&last_ibp);
+		if (error)
+			return error;
+		goto out;
+	}
+
 	next_agino = head_agino;
 	while (next_agino != target_agino) {
 		xfs_agino_t	unlinked_agino;
@@ -2156,6 +2336,7 @@ xfs_iunlink_map_prev(
 		next_agino = unlinked_agino;
 	}
 
+out:
 	/* Should never happen, but don't return garbage. */
 	if (next_ino == NULLFSINO)
 		return -EFSCORRUPTED;
@@ -2218,6 +2399,20 @@ xfs_iunlink_remove(
 	if (error)
 		goto out;
 
+	/*
+	 * If there was a backref pointing from the next inode back to this
+	 * one, remove it because we've removed this inode from the list.
+	 *
+	 * Later, if this inode was in the middle of the list we'll update
+	 * this inode's backref to point from the next inode.
+	 */
+	if (next_agino != NULLAGINO) {
+		error = xfs_iunlink_change_backref(pag, next_agino,
+				NULLAGINO);
+		if (error)
+			goto out;
+	}
+
 	if (head_agino == agino) {
 		/* Point the head of the list to the next unlinked inode. */
 		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
@@ -2236,6 +2431,18 @@ xfs_iunlink_remove(
 		/* Point the previous inode on the list to the next inode. */
 		xfs_iunlink_update_dinode(tp, agno, last_ibp, last_dip, &imap,
 				prev_ino, next_agino);
+
+		/*
+		 * Now we deal with the backref for this inode.  If this inode
+		 * pointed at a real inode, change the backref that pointed to
+		 * us to point to our old next.  If this inode was the end of
+		 * the list, delete the backref that pointed to us.  Note that
+		 * change_backref takes care of deleting the backref if
+		 * next_agino is NULLAGINO.
+		 */
+		error = xfs_iunlink_change_backref(pag, agino, next_agino);
+		if (error)
+			goto out;
 	}
 	pag->pagi_unlinked_count--;
 out:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index be2014520155..0a83bfacfd33 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -500,4 +500,13 @@ extern struct kmem_zone	*xfs_inode_zone;
 
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
 
+int xfs_iunlink_init(struct xfs_perag *pag);
+void xfs_iunlink_destroy(struct xfs_perag *pag);
+xfs_agino_t xfs_iunlink_lookup_backref(struct xfs_perag *pag,
+		xfs_agino_t agino);
+int xfs_iunlink_add_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
+		xfs_agino_t this_agino);
+int xfs_iunlink_change_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
+		xfs_agino_t this_agino);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c634fbfea4a8..f5fb8885662f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5078,10 +5078,20 @@ xlog_recover_process_one_iunlink(
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
 	pag->pagi_unlinked_count++;
+	if (agino != NULLAGINO)
+		error = xfs_iunlink_add_backref(pag, XFS_INO_TO_AGINO(mp, ino),
+				agino);
 	xfs_perag_put(pag);
+	if (error)
+		goto fail_iput;
 
 	/*
 	 * Prevent any DMAPI event from being sent when the reference on
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6ca92a71c233..9a181f7ca1d5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -151,6 +151,7 @@ xfs_free_perag(
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		ASSERT(pag->pagi_unlinked_count == 0 ||
 		       XFS_FORCED_SHUTDOWN(mp));
+		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		mutex_destroy(&pag->pag_ici_reclaim_lock);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
@@ -229,6 +230,9 @@ xfs_initialize_perag(
 		/* first new pag is fully initialized */
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
+		error = xfs_iunlink_init(pag);
+		if (error)
+			goto out_hash_destroy;
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
@@ -251,6 +255,7 @@ xfs_initialize_perag(
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
+		xfs_iunlink_destroy(pag);
 		mutex_destroy(&pag->pag_ici_reclaim_lock);
 		kmem_free(pag);
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 169069a01f3c..dcc45b441dd6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -391,6 +391,7 @@ typedef struct xfs_perag {
 
 	/* unlinked inode info; lock AGI to access */
 	unsigned int		pagi_unlinked_count;
+	struct rhashtable	pagi_unlinked_hash;
 } xfs_perag_t;
 
 static inline struct xfs_ag_resv *
