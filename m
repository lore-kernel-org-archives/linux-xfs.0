Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06N8VED120046 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 17:08:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBEF91C35D07
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 15:09:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	DtOyGSPqbPBtCJoT for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2010 15:09:22 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11267354-1927428
	for <xfs@oss.sgi.com>; Thu, 07 Jan 2010 09:39:20 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NSf0B-0000jS-9v
	for xfs@oss.sgi.com; Thu, 07 Jan 2010 10:09:19 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NSewS-00073s-U8
	for xfs@oss.sgi.com; Thu, 07 Jan 2010 10:05:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: reclaim inodes under a write lock
Date: Thu,  7 Jan 2010 10:05:24 +1100
Message-Id: <1262819125-27083-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1262819125-27083-1-git-send-email-david@fromorbit.com>
References: <1262819125-27083-1-git-send-email-david@fromorbit.com>
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

Make the inode tree reclaim walk exclusive to avoid races with
concurrent sync walkers and lookups. This is a version of
a patch posted by Christoph Hellwig that avoids all the code
duplication.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c    |   90 +++++++++++++++++++--------------------
 fs/xfs/linux-2.6/xfs_sync.h    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 3 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index f974d1a..6d1cd6e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -55,7 +55,8 @@ xfs_inode_ag_lookup(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	uint32_t		*first_index,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	int			nr_found;
 	struct xfs_inode	*ip;
@@ -65,7 +66,10 @@ xfs_inode_ag_lookup(
 	 * as the tree is sparse and a gang lookup walks to find
 	 * the number of objects requested.
 	 */
-	read_lock(&pag->pag_ici_lock);
+	if (write_lock)
+		write_lock(&pag->pag_ici_lock);
+	else
+		read_lock(&pag->pag_ici_lock);
 	if (tag == XFS_ICI_NO_TAG) {
 		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 				(void **)&ip, *first_index, 1);
@@ -89,7 +93,10 @@ xfs_inode_ag_lookup(
 	return ip;
 
 unlock:
-	read_unlock(&pag->pag_ici_lock);
+	if (write_lock)
+		write_unlock(&pag->pag_ici_lock);
+	else
+		read_unlock(&pag->pag_ici_lock);
 	return NULL;
 }
 
@@ -100,7 +107,8 @@ xfs_inode_ag_walk(
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	uint32_t		first_index;
 	int			last_error = 0;
@@ -113,7 +121,8 @@ restart:
 		int		error = 0;
 		xfs_inode_t	*ip;
 
-		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
+		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag,
+						write_lock);
 		if (!ip)
 			break;
 
@@ -145,7 +154,8 @@ xfs_inode_ag_iterator(
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
-	int			tag)
+	int			tag,
+	int			write_lock)
 {
 	int			error = 0;
 	int			last_error = 0;
@@ -159,7 +169,8 @@ xfs_inode_ag_iterator(
 			xfs_perag_put(pag);
 			continue;
 		}
-		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag);
+		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag,
+						write_lock);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -184,18 +195,20 @@ xfs_sync_inode_valid(
 		return EFSCORRUPTED;
 	}
 
-	/*
-	 * If we can't get a reference on the inode, it must be in reclaim.
-	 * Leave it for the reclaim code to flush. Also avoid inodes that
-	 * haven't been fully initialised.
-	 */
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM)) {
+		read_unlock(&pag->pag_ici_lock);
+		return ENOENT;
+	}
+
+	/* If we can't get a reference on the inode, it must be in reclaim. */
 	if (!igrab(inode)) {
 		read_unlock(&pag->pag_ici_lock);
 		return ENOENT;
 	}
 	read_unlock(&pag->pag_ici_lock);
 
-	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+	if (is_bad_inode(inode)) {
 		IRELE(ip);
 		return ENOENT;
 	}
@@ -285,7 +298,7 @@ xfs_sync_data(
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
 	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags,
-				      XFS_ICI_NO_TAG);
+				      XFS_ICI_NO_TAG, 0);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -307,7 +320,7 @@ xfs_sync_attr(
 	ASSERT((flags & ~SYNC_WAIT) == 0);
 
 	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags,
-				     XFS_ICI_NO_TAG);
+				     XFS_ICI_NO_TAG, 0);
 }
 
 STATIC int
@@ -669,33 +682,8 @@ xfs_reclaim_inode(
 	xfs_inode_t	*ip,
 	int		sync_mode)
 {
-	struct xfs_mount *mp = ip->i_mount;
-	struct xfs_perag *pag;
-
-
 	/*
-	 * The radix tree lock here protects a thread in xfs_iget_core from
-	 * racing with us on linking the inode back with a vnode.
-	 * Once we have the XFS_IRECLAIM flag set it will not touch
-	 * us.
-	 */
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	write_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
-	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
-		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
-		xfs_perag_put(pag);
-		return EAGAIN;
-	}
-	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
-	xfs_perag_put(pag);
-
-	/*
-	 * The inode is flushed delayed write. That means the flush lock
+	 * Inodes are flushed delayed write. That means the flush lock
 	 * may be held here and we will block for some time on it. Further,
 	 * if we hold the inode lock, we prevent the AIL from locking and
 	 * therefore being able to push the buffer. This means that we'll end
@@ -791,12 +779,22 @@ xfs_reclaim_inode_now(
 	struct xfs_perag	*pag,
 	int			flags)
 {
-	/* ignore if already under reclaim */
-	if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-		read_unlock(&pag->pag_ici_lock);
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget from racing
+	 * with us starting reclaim on the inode.  Once we have the
+	 * XFS_IRECLAIM flag set it will not touch us.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
+		/* ignore as it is already under reclaim */
+		spin_unlock(&ip->i_flags_lock);
+		write_unlock(&pag->pag_ici_lock);
 		return 0;
 	}
-	read_unlock(&pag->pag_ici_lock);
+	__xfs_iflags_set(ip, XFS_IRECLAIM);
+	spin_unlock(&ip->i_flags_lock);
+	write_unlock(&pag->pag_ici_lock);
 
 	return xfs_reclaim_inode(ip, flags);
 }
@@ -807,5 +805,5 @@ xfs_reclaim_inodes(
 	int		mode)
 {
 	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode_now, mode,
-					XFS_ICI_RECLAIM_TAG);
+					XFS_ICI_RECLAIM_TAG, 1);
 }
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index a500b4d..ea932b4 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -54,6 +54,6 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags, int tag);
+	int flags, int tag, int write_lock);
 
 #endif
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 71af76f..873e07e 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -891,7 +891,7 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG, 0);
 }
 
 /*------------------------------------------------------------------------*/
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
