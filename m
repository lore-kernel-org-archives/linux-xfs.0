Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8R1lVqe150760 for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 20:47:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF031E7934D
	for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 19:01:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	kFDs5oUTZCgyg4vq for <xfs@oss.sgi.com>;
	Sun, 26 Sep 2010 19:01:20 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40635769-1927428
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:18:25 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1P02pM-0002t9-C4
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:24 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1P02p5-0003q8-Qq
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/18] xfs: split inode AG walking into separate code for
	reclaim
Date: Mon, 27 Sep 2010 11:47:47 +1000
Message-Id: <1285552073-14663-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1285552073-14663-1-git-send-email-david@fromorbit.com>
References: <1285552073-14663-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The reclaim walk requires different locking and has a slightly
different walk algorithm, so separate it out so that it can be
optimised separately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c    |  202 ++++++++++++++++++----------------------
 fs/xfs/linux-2.6/xfs_sync.h    |    2 +-
 fs/xfs/linux-2.6/xfs_trace.h   |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    3 +-
 fs/xfs/xfs_mount.c             |   26 +++++
 fs/xfs/xfs_mount.h             |    2 +
 6 files changed, 122 insertions(+), 115 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index ddeaff9..359422d 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -40,78 +40,46 @@
 #include <linux/freezer.h>
 
 
-STATIC xfs_inode_t *
-xfs_inode_ag_lookup(
-	struct xfs_mount	*mp,
-	struct xfs_perag	*pag,
-	uint32_t		*first_index,
-	int			tag)
-{
-	int			nr_found;
-	struct xfs_inode	*ip;
-
-	/*
-	 * use a gang lookup to find the next inode in the tree
-	 * as the tree is sparse and a gang lookup walks to find
-	 * the number of objects requested.
-	 */
-	if (tag == XFS_ICI_NO_TAG) {
-		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-				(void **)&ip, *first_index, 1);
-	} else {
-		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
-				(void **)&ip, *first_index, 1, tag);
-	}
-	if (!nr_found)
-		return NULL;
-
-	/*
-	 * Update the index for the next lookup. Catch overflows
-	 * into the next AG range which can occur if we have inodes
-	 * in the last block of the AG and we are currently
-	 * pointing to the last inode.
-	 */
-	*first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-	if (*first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-		return NULL;
-	return ip;
-}
-
 STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
-	int			flags,
-	int			tag,
-	int			exclusive,
-	int			*nr_to_scan)
+	int			flags)
 {
 	uint32_t		first_index;
 	int			last_error = 0;
 	int			skipped;
+	int			done;
 
 restart:
+	done = 0;
 	skipped = 0;
 	first_index = 0;
 	do {
 		int		error = 0;
+		int		nr_found;
 		xfs_inode_t	*ip;
 
-		if (exclusive)
-			write_lock(&pag->pag_ici_lock);
-		else
-			read_lock(&pag->pag_ici_lock);
-		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
-		if (!ip) {
-			if (exclusive)
-				write_unlock(&pag->pag_ici_lock);
-			else
-				read_unlock(&pag->pag_ici_lock);
+		read_lock(&pag->pag_ici_lock);
+		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+				(void **)&ip, first_index, 1);
+		if (!nr_found) {
+			read_unlock(&pag->pag_ici_lock);
 			break;
 		}
 
+		/*
+		 * Update the index for the next lookup. Catch overflows
+		 * into the next AG range which can occur if we have inodes
+		 * in the last block of the AG and we are currently
+		 * pointing to the last inode.
+		 */
+		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+			done = 1;
+
 		/* execute releases pag->pag_ici_lock */
 		error = execute(ip, pag, flags);
 		if (error == EAGAIN) {
@@ -125,7 +93,7 @@ restart:
 		if (error == EFSCORRUPTED)
 			break;
 
-	} while ((*nr_to_scan)--);
+	} while (!done);
 
 	if (skipped) {
 		delay(1);
@@ -134,73 +102,29 @@ restart:
 	return last_error;
 }
 
-/*
- * Select the next per-ag structure to iterate during the walk. The reclaim
- * walk is optimised only to walk AGs with reclaimable inodes in them.
- */
-static struct xfs_perag *
-xfs_inode_ag_iter_next_pag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		*first,
-	int			tag)
-{
-	struct xfs_perag	*pag = NULL;
-
-	if (tag == XFS_ICI_RECLAIM_TAG) {
-		int found;
-		int ref;
-
-		rcu_read_lock();
-		found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
-				(void **)&pag, *first, 1, tag);
-		if (found <= 0) {
-			rcu_read_unlock();
-			return NULL;
-		}
-		*first = pag->pag_agno + 1;
-		/* open coded pag reference increment */
-		ref = atomic_inc_return(&pag->pag_ref);
-		rcu_read_unlock();
-		trace_xfs_perag_get_reclaim(mp, pag->pag_agno, ref, _RET_IP_);
-	} else {
-		pag = xfs_perag_get(mp, *first);
-		(*first)++;
-	}
-	return pag;
-}
-
 int
 xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
-	int			flags,
-	int			tag,
-	int			exclusive,
-	int			*nr_to_scan)
+	int			flags)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
 	int			last_error = 0;
 	xfs_agnumber_t		ag;
-	int			nr;
 
-	nr = nr_to_scan ? *nr_to_scan : INT_MAX;
 	ag = 0;
-	while ((pag = xfs_inode_ag_iter_next_pag(mp, &ag, tag))) {
-		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag,
-						exclusive, &nr);
+	while ((pag = xfs_perag_get(mp, ag))) {
+		ag = pag->pag_agno + 1;
+		error = xfs_inode_ag_walk(mp, pag, execute, flags);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
 			if (error == EFSCORRUPTED)
 				break;
 		}
-		if (nr <= 0)
-			break;
 	}
-	if (nr_to_scan)
-		*nr_to_scan = nr;
 	return XFS_ERROR(last_error);
 }
 
@@ -318,8 +242,7 @@ xfs_sync_data(
 
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
-	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags,
-				      XFS_ICI_NO_TAG, 0, NULL);
+	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -337,8 +260,7 @@ xfs_sync_attr(
 {
 	ASSERT((flags & ~SYNC_WAIT) == 0);
 
-	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags,
-				     XFS_ICI_NO_TAG, 0, NULL);
+	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags);
 }
 
 STATIC int
@@ -859,13 +781,72 @@ reclaim:
 
 }
 
+/*
+ * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
+ * corrupted, we still want to try to reclaim all the inodes. If we don't,
+ * then a shut down during filesystem unmount reclaim walk leak all the
+ * unreclaimed inodes.
+ */
+int
+xfs_reclaim_inodes_ag(
+	struct xfs_mount	*mp,
+	int			flags,
+	int			*nr_to_scan)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		ag;
+
+	ag = 0;
+	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
+		unsigned long	first_index = 0;
+		int		done = 0;
+
+		ag = pag->pag_agno + 1;
+
+		do {
+			struct xfs_inode *ip;
+			int	nr_found;
+
+			write_lock(&pag->pag_ici_lock);
+			nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+					(void **)&ip, first_index, 1,
+					XFS_ICI_RECLAIM_TAG);
+			if (!nr_found) {
+				write_unlock(&pag->pag_ici_lock);
+				break;
+			}
+
+			/*
+			 * Update the index for the next lookup. Catch overflows
+			 * into the next AG range which can occur if we have inodes
+			 * in the last block of the AG and we are currently
+			 * pointing to the last inode.
+			 */
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+				done = 1;
+
+			error = xfs_reclaim_inode(ip, pag, flags);
+			if (error && last_error != EFSCORRUPTED)
+				last_error = error;
+
+		} while (!done && (*nr_to_scan)--);
+
+		xfs_perag_put(pag);
+	}
+	return XFS_ERROR(last_error);
+}
+
 int
 xfs_reclaim_inodes(
 	xfs_mount_t	*mp,
 	int		mode)
 {
-	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode, mode,
-					XFS_ICI_RECLAIM_TAG, 1, NULL);
+	int		nr_to_scan = INT_MAX;
+
+	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
 }
 
 /*
@@ -887,17 +868,16 @@ xfs_reclaim_inode_shrink(
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
 
-		xfs_inode_ag_iterator(mp, xfs_reclaim_inode, 0,
-					XFS_ICI_RECLAIM_TAG, 1, &nr_to_scan);
-		/* if we don't exhaust the scan, don't bother coming back */
+		xfs_reclaim_inodes_ag(mp, 0, &nr_to_scan);
+		/* terminate if we don't exhaust the scan */
 		if (nr_to_scan > 0)
 			return -1;
        }
 
 	reclaimable = 0;
 	ag = 0;
-	while ((pag = xfs_inode_ag_iter_next_pag(mp, &ag,
-					XFS_ICI_RECLAIM_TAG))) {
+	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
+		ag = pag->pag_agno + 1;
 		reclaimable += pag->pag_ici_reclaimable;
 		xfs_perag_put(pag);
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index fe78726..e8a3528 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -50,7 +50,7 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags, int tag, int write_lock, int *nr_to_scan);
+	int flags);
 
 void xfs_inode_shrinker_register(struct xfs_mount *mp);
 void xfs_inode_shrinker_unregister(struct xfs_mount *mp);
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 2a1d4fb..286dc20 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -124,7 +124,7 @@ DEFINE_EVENT(xfs_perag_class, name,	\
 		 unsigned long caller_ip),					\
 	TP_ARGS(mp, agno, refcount, caller_ip))
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
-DEFINE_PERAG_REF_EVENT(xfs_perag_get_reclaim);
+DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 7a71336..ac11fbe 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -918,8 +918,7 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags,
-				XFS_ICI_NO_TAG, 0, NULL);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags);
 }
 
 /*------------------------------------------------------------------------*/
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 912101d..d66e87c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -219,6 +219,32 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 	return pag;
 }
 
+/*
+ * search from @first to find the next perag with the given tag set.
+ */
+struct xfs_perag *
+xfs_perag_get_tag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			found;
+	int			ref;
+
+	rcu_read_lock();
+	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
+					(void **)&pag, first, 1, tag);
+	if (found <= 0) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	ref = atomic_inc_return(&pag->pag_ref);
+	rcu_read_unlock();
+	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
+	return pag;
+}
+
 void
 xfs_perag_put(struct xfs_perag *pag)
 {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 622da21..7ab2409 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -327,6 +327,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
  * perag get/put wrappers for ref counting
  */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
+struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
+					int tag);
 void	xfs_perag_put(struct xfs_perag *pag);
 
 /*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
