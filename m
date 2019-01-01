Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACRb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012FDL6174239
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:30 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pp1jqx414-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:17:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012HTYj002135
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:29 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012HSRv000721
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:29 GMT
Subject: [PATCH 06/12] xfs: refactor walking of per-AG RECLAIM inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:27 -0800
Message-ID: <154630904767.16693.13857289605746264694.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that walks reclaim-tagged inodes so that we can reuse
the same loop in a subsequent patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |  170 +++++++++++++++++++++++++++++----------------------
 1 file changed, 97 insertions(+), 73 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 36d986087abb..7e031eb6f048 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1004,9 +1004,9 @@ xfs_inode_ag_iterator_tag(
 
 /*
  * Grab the inode for reclaim exclusively.
- * Return 0 if we grabbed it, non-zero otherwise.
+ * Return true if we grabbed it, false otherwise.
  */
-STATIC int
+STATIC bool
 xfs_reclaim_inode_grab(
 	struct xfs_inode	*ip,
 	int			flags)
@@ -1015,7 +1015,7 @@ xfs_reclaim_inode_grab(
 
 	/* quick check for stale RCU freed inode */
 	if (!ip->i_ino)
-		return 1;
+		return false;
 
 	/*
 	 * If we are asked for non-blocking operation, do unlocked checks to
@@ -1024,7 +1024,7 @@ xfs_reclaim_inode_grab(
 	 */
 	if ((flags & SYNC_TRYLOCK) &&
 	    __xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
-		return 1;
+		return false;
 
 	/*
 	 * The radix tree lock here protects a thread in xfs_iget from racing
@@ -1041,11 +1041,11 @@ xfs_reclaim_inode_grab(
 	    __xfs_iflags_test(ip, XFS_IRECLAIM)) {
 		/* not a reclaim candidate. */
 		spin_unlock(&ip->i_flags_lock);
-		return 1;
+		return false;
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
-	return 0;
+	return true;
 }
 
 /*
@@ -1223,6 +1223,90 @@ xfs_reclaim_inode(
 	return 0;
 }
 
+/*
+ * Walk the RECLAIM tagged inodes in this AG looking for inodes to inactivate.
+ */
+STATIC int
+xfs_walk_ag_reclaim_inos(
+	struct xfs_perag	*pag,
+	int			sync_flags,
+	bool			(*grab_fn)(struct xfs_inode *ip,
+					   int sync_flags),
+	int			(*execute_fn)(struct xfs_inode *ip,
+					      struct xfs_perag *pag,
+					      int sync_flags),
+	int			*nr_to_scan,
+	bool			*done)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	unsigned long		first_index = 0;
+	int			nr_found = 0;
+	int			last_error = 0;
+	int			error;
+
+	do {
+		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+		int	i;
+
+		rcu_read_lock();
+		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+				(void **)batch, first_index, XFS_LOOKUP_BATCH,
+				XFS_ICI_RECLAIM_TAG);
+		if (!nr_found) {
+			*done = true;
+			rcu_read_unlock();
+			break;
+		}
+
+		/*
+		 * Grab the inodes before we drop the lock. if we found
+		 * nothing, nr == 0 and the loop will be skipped.
+		 */
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_inode *ip = batch[i];
+
+			if (*done || !grab_fn(ip, sync_flags))
+				batch[i] = NULL;
+
+			/*
+			 * Update the index for the next lookup. Catch
+			 * overflows into the next AG range which can occur if
+			 * we have inodes in the last block of the AG and we
+			 * are currently pointing to the last inode.
+			 *
+			 * Because we may see inodes that are from the wrong AG
+			 * due to RCU freeing and reallocation, only update the
+			 * index if it lies in this AG. It was a race that lead
+			 * us to see this inode, so another lookup from the
+			 * same index will not find it again.
+			 */
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+				continue;
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+				*done = true;
+		}
+
+		/* unlock now we've grabbed the inodes. */
+		rcu_read_unlock();
+
+		for (i = 0; i < nr_found; i++) {
+			if (!batch[i])
+				continue;
+			error = execute_fn(batch[i], pag, sync_flags);
+			if (error && last_error != -EFSCORRUPTED)
+				last_error = error;
+		}
+
+		*nr_to_scan -= XFS_LOOKUP_BATCH;
+
+		cond_resched();
+
+	} while (nr_found && !*done && *nr_to_scan > 0);
+
+	return last_error;
+}
+
 /*
  * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
  * corrupted, we still want to try to reclaim all the inodes. If we don't,
@@ -1236,8 +1320,8 @@ xfs_reclaim_inodes_ag(
 	int			*nr_to_scan)
 {
 	struct xfs_perag	*pag;
-	int			error = 0;
 	int			last_error = 0;
+	int			error;
 	xfs_agnumber_t		ag;
 	int			trylock = flags & SYNC_TRYLOCK;
 	int			skipped;
@@ -1247,8 +1331,7 @@ xfs_reclaim_inodes_ag(
 	skipped = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		unsigned long	first_index = 0;
-		int		done = 0;
-		int		nr_found = 0;
+		bool		done = false;
 
 		ag = pag->pag_agno + 1;
 
@@ -1262,70 +1345,11 @@ xfs_reclaim_inodes_ag(
 		} else
 			mutex_lock(&pag->pag_ici_reclaim_lock);
 
-		do {
-			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
-			int	i;
-
-			rcu_read_lock();
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH,
-					XFS_ICI_RECLAIM_TAG);
-			if (!nr_found) {
-				done = 1;
-				rcu_read_unlock();
-				break;
-			}
-
-			/*
-			 * Grab the inodes before we drop the lock. if we found
-			 * nothing, nr == 0 and the loop will be skipped.
-			 */
-			for (i = 0; i < nr_found; i++) {
-				struct xfs_inode *ip = batch[i];
-
-				if (done || xfs_reclaim_inode_grab(ip, flags))
-					batch[i] = NULL;
-
-				/*
-				 * Update the index for the next lookup. Catch
-				 * overflows into the next AG range which can
-				 * occur if we have inodes in the last block of
-				 * the AG and we are currently pointing to the
-				 * last inode.
-				 *
-				 * Because we may see inodes that are from the
-				 * wrong AG due to RCU freeing and
-				 * reallocation, only update the index if it
-				 * lies in this AG. It was a race that lead us
-				 * to see this inode, so another lookup from
-				 * the same index will not find it again.
-				 */
-				if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=
-								pag->pag_agno)
-					continue;
-				first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-				if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-					done = 1;
-			}
-
-			/* unlock now we've grabbed the inodes. */
-			rcu_read_unlock();
-
-			for (i = 0; i < nr_found; i++) {
-				if (!batch[i])
-					continue;
-				error = xfs_reclaim_inode(batch[i], pag, flags);
-				if (error && last_error != -EFSCORRUPTED)
-					last_error = error;
-			}
-
-			*nr_to_scan -= XFS_LOOKUP_BATCH;
-
-			cond_resched();
-
-		} while (nr_found && !done && *nr_to_scan > 0);
+		error = xfs_walk_ag_reclaim_inos(pag, flags,
+				xfs_reclaim_inode_grab, xfs_reclaim_inode,
+				nr_to_scan, &done);
+		if (error && last_error != -EFSCORRUPTED)
+			last_error = error;
 
 		if (trylock && !done)
 			pag->pag_ici_reclaim_cursor = first_index;
