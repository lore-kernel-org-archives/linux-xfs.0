Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 859D47F6D
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:59:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F422BAC003
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:59:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dFQEhDRFb1jnf9Lm for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:59:39 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YaMYY-0002sY-1n
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YaMYY-000132-15
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: clean up inode locking for RENAME_WHITEOUT
Date: Tue, 24 Mar 2015 21:59:27 +1100
Message-Id: <1427194771-3105-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194771-3105-1-git-send-email-david@fromorbit.com>
References: <1427194771-3105-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When doing RENAME_WHITEOUT, we now have to lock 5 inodes into the
rename transaction. This means we need to update
xfs_sort_for_rename() and xfs_lock_inodes() to handle up to 5
inodes. Because of the vagaries of rename, this means we could have
anywhere between 3 and 5 inodes locked into the transaction....

While xfs_lock_inodes() does not need anything other than an assert
telling us we are passing more inodes that we ever thought we should
see, it could do with a logic rework to remove all the indenting.
This is not a functional change - it just makes the code a lot
easier to read.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 145 +++++++++++++++++++++++++----------------------------
 1 file changed, 67 insertions(+), 78 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5a44f1c..e38bc40 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -391,15 +391,14 @@ xfs_lock_inumorder(int lock_mode, int subclass)
 }
 
 /*
- * The following routine will lock n inodes in exclusive mode.
- * We assume the caller calls us with the inodes in i_ino order.
+ * The following routine will lock n inodes in exclusive mode.  We assume the
+ * caller calls us with the inodes in i_ino order.
  *
- * We need to detect deadlock where an inode that we lock
- * is in the AIL and we start waiting for another inode that is locked
- * by a thread in a long running transaction (such as truncate). This can
- * result in deadlock since the long running trans might need to wait
- * for the inode we just locked in order to push the tail and free space
- * in the log.
+ * We need to detect deadlock where an inode that we lock is in the AIL and we
+ * start waiting for another inode that is locked by a thread in a long running
+ * transaction (such as truncate). This can result in deadlock since the long
+ * running trans might need to wait for the inode we just locked in order to
+ * push the tail and free space in the log.
  */
 void
 xfs_lock_inodes(
@@ -410,30 +409,27 @@ xfs_lock_inodes(
 	int		attempts = 0, i, j, try_lock;
 	xfs_log_item_t	*lp;
 
-	ASSERT(ips && (inodes >= 2)); /* we need at least two */
+	/* currently supports between 2 and 5 inodes */
+	ASSERT(ips && inodes >= 2 && inodes <= 5);
 
 	try_lock = 0;
 	i = 0;
-
 again:
 	for (; i < inodes; i++) {
 		ASSERT(ips[i]);
 
-		if (i && (ips[i] == ips[i-1]))	/* Already locked */
+		if (i && (ips[i] == ips[i - 1]))	/* Already locked */
 			continue;
 
 		/*
-		 * If try_lock is not set yet, make sure all locked inodes
-		 * are not in the AIL.
-		 * If any are, set try_lock to be used later.
+		 * If try_lock is not set yet, make sure all locked inodes are
+		 * not in the AIL.  If any are, set try_lock to be used later.
 		 */
-
 		if (!try_lock) {
 			for (j = (i - 1); j >= 0 && !try_lock; j--) {
 				lp = (xfs_log_item_t *)ips[j]->i_itemp;
-				if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
+				if (lp && (lp->li_flags & XFS_LI_IN_AIL))
 					try_lock++;
-				}
 			}
 		}
 
@@ -443,51 +439,42 @@ again:
 		 * we can't get any, we must release all we have
 		 * and try again.
 		 */
+		if (!try_lock) {
+			xfs_ilock(ips[i], xfs_lock_inumorder(lock_mode, i));
+			continue;
+		}
+
+		/* try_lock means we have an inode locked that is in the AIL. */
+		ASSERT(i != 0);
+		if (xfs_ilock_nowait(ips[i], xfs_lock_inumorder(lock_mode, i)))
+			continue;
 
-		if (try_lock) {
-			/* try_lock must be 0 if i is 0. */
+		/*
+		 * Unlock all previous guys and try again.  xfs_iunlock will try
+		 * to push the tail if the inode is in the AIL.
+		 */
+		attempts++;
+		for (j = i - 1; j >= 0; j--) {
 			/*
-			 * try_lock means we have an inode locked
-			 * that is in the AIL.
+			 * Check to see if we've already unlocked this one.  Not
+			 * the first one going back, and the inode ptr is the
+			 * same.
 			 */
-			ASSERT(i != 0);
-			if (!xfs_ilock_nowait(ips[i], xfs_lock_inumorder(lock_mode, i))) {
-				attempts++;
-
-				/*
-				 * Unlock all previous guys and try again.
-				 * xfs_iunlock will try to push the tail
-				 * if the inode is in the AIL.
-				 */
-
-				for(j = i - 1; j >= 0; j--) {
-
-					/*
-					 * Check to see if we've already
-					 * unlocked this one.
-					 * Not the first one going back,
-					 * and the inode ptr is the same.
-					 */
-					if ((j != (i - 1)) && ips[j] ==
-								ips[j+1])
-						continue;
-
-					xfs_iunlock(ips[j], lock_mode);
-				}
+			if (j != (i - 1) && ips[j] == ips[j + 1])
+				continue;
+
+			xfs_iunlock(ips[j], lock_mode);
+		}
 
-				if ((attempts % 5) == 0) {
-					delay(1); /* Don't just spin the CPU */
+		if ((attempts % 5) == 0) {
+			delay(1); /* Don't just spin the CPU */
 #ifdef DEBUG
-					xfs_lock_delays++;
+			xfs_lock_delays++;
 #endif
-				}
-				i = 0;
-				try_lock = 0;
-				goto again;
-			}
-		} else {
-			xfs_ilock(ips[i], xfs_lock_inumorder(lock_mode, i));
 		}
+		i = 0;
+		try_lock = 0;
+		goto again;
 	}
 
 #ifdef DEBUG
@@ -2681,19 +2668,22 @@ xfs_remove(
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
+#define __XFS_SORT_INODES	5
 STATIC void
 xfs_sort_for_rename(
-	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
-	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
-	xfs_inode_t	*ip1,	/* in: inode of old entry */
-	xfs_inode_t	*ip2,	/* in: inode of new entry, if it
-				   already exists, NULL otherwise. */
-	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
-	int		*num_inodes)  /* out: number of inodes in array */
+	struct xfs_inode	*dp1,	/* in: old (source) directory inode */
+	struct xfs_inode	*dp2,	/* in: new (target) directory inode */
+	struct xfs_inode	*ip1,	/* in: inode of old entry */
+	struct xfs_inode	*ip2,	/* in: inode of new entry */
+	struct xfs_inode	*wino,	/* in: whiteout inode */
+	struct xfs_inode	**i_tab,/* out: sorted array of inodes */
+	int			*num_inodes)  /* in/out: inodes in array */
 {
-	xfs_inode_t		*temp;
 	int			i, j;
 
+	ASSERT(*num_inodes == __XFS_SORT_INODES);
+	memset(i_tab, 0, *num_inodes * sizeof(struct xfs_inode *));
+
 	/*
 	 * i_tab contains a list of pointers to inodes.  We initialize
 	 * the table here & we'll sort it.  We will then use it to
@@ -2701,25 +2691,24 @@ xfs_sort_for_rename(
 	 *
 	 * Note that the table may contain duplicates.  e.g., dp1 == dp2.
 	 */
-	i_tab[0] = dp1;
-	i_tab[1] = dp2;
-	i_tab[2] = ip1;
-	if (ip2) {
-		*num_inodes = 4;
-		i_tab[3] = ip2;
-	} else {
-		*num_inodes = 3;
-		i_tab[3] = NULL;
-	}
+	i = 0;
+	i_tab[i++] = dp1;
+	i_tab[i++] = dp2;
+	i_tab[i++] = ip1;
+	if (ip2)
+		i_tab[i++] = ip2;
+	if (wino)
+		i_tab[i++] = wino;
+	*num_inodes = i;
 
 	/*
 	 * Sort the elements via bubble sort.  (Remember, there are at
-	 * most 4 elements to sort, so this is adequate.)
+	 * most 5 elements to sort, so this is adequate.)
 	 */
 	for (i = 0; i < *num_inodes; i++) {
 		for (j = 1; j < *num_inodes; j++) {
 			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino) {
-				temp = i_tab[j];
+				struct xfs_inode *temp = i_tab[j];
 				i_tab[j] = i_tab[j-1];
 				i_tab[j-1] = temp;
 			}
@@ -2867,16 +2856,16 @@ xfs_rename(
 	xfs_fsblock_t   first_block;
 	int		cancel_flags;
 	int		committed;
-	xfs_inode_t	*inodes[4];
+	xfs_inode_t	*inodes[__XFS_SORT_INODES];
+	int		num_inodes = __XFS_SORT_INODES;
 	int		spaceres;
-	int		num_inodes;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
 	new_parent = (src_dp != target_dp);
 	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
 
-	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
+	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, NULL,
 				inodes, &num_inodes);
 
 	xfs_bmap_init(&free_list, &first_block);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
