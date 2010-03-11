Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2B9EEMD139454 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 03:14:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DE6A141C21B
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 01:15:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	aNm1En7HAyg0MFB9 for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 01:15:44 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16655433-1927428
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 19:45:43 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NpeUX-0005On-Qf
	for xfs@oss.sgi.com; Thu, 11 Mar 2010 20:15:41 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NpeUM-0005QA-Po
	for xfs@oss.sgi.com; Thu, 11 Mar 2010 20:15:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsprogs: duplicate extent btrees in xfs_repair need locking
Date: Thu, 11 Mar 2010 20:15:30 +1100
Message-Id: <1268298930-20809-1-git-send-email-david@fromorbit.com>
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

The per-ag duplicate extent btrees can be search concurrently from multiple
threads. This occurs when inode extent lists are being processed and inodes
with extents in the same AG are checked concurrently. The btrees have an
internal traversal cursor, so doing concurrent searches can result in the
cursor being corrupted for both searches.

Add an external lock for each duplicate extent tree and use it for searches,
inserts and deletes to ensure that we don't trash the state of any operation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/incore_ext.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index a362e5a..60dd4c4 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -74,6 +74,7 @@ static rt_ext_flist_t rt_ext_flist;
 static avl64tree_desc_t	*rt_ext_tree_ptr;	/* dup extent tree for rt */
 
 static struct btree_root **dup_extent_trees;	/* per ag dup extent trees */
+static pthread_mutex_t *dup_extent_tree_locks;
 
 static avltree_desc_t	**extent_bno_ptrs;	/*
 						 * array of extent tree ptrs
@@ -108,7 +109,9 @@ void
 release_dup_extent_tree(
 	xfs_agnumber_t		agno)
 {
+	pthread_mutex_lock(&dup_extent_tree_locks[agno]);
 	btree_clear(dup_extent_trees[agno]);
+	pthread_mutex_unlock(&dup_extent_tree_locks[agno]);
 }
 
 int
@@ -117,12 +120,16 @@ add_dup_extent(
 	xfs_agblock_t		startblock,
 	xfs_extlen_t		blockcount)
 {
+	int	ret;
 #ifdef XR_DUP_TRACE
 	fprintf(stderr, "Adding dup extent - %d/%d %d\n", agno, startblock,
 		blockcount);
 #endif
-	return btree_insert(dup_extent_trees[agno], startblock,
+	pthread_mutex_lock(&dup_extent_tree_locks[agno]);
+	ret = btree_insert(dup_extent_trees[agno], startblock,
 				(void *)(uintptr_t)(startblock + blockcount));
+	pthread_mutex_unlock(&dup_extent_tree_locks[agno]);
+	return ret;
 }
 
 int
@@ -132,13 +139,22 @@ search_dup_extent(
 	xfs_agblock_t		end_agbno)
 {
 	unsigned long	bno;
+	int		ret;
 
-	if (!btree_find(dup_extent_trees[agno], start_agbno, &bno))
-		return 0;	/* this really shouldn't happen */
-	if (bno < end_agbno)
-		return 1;
-	return (uintptr_t)btree_peek_prev(dup_extent_trees[agno], NULL) >
+	pthread_mutex_lock(&dup_extent_tree_locks[agno]);
+	if (!btree_find(dup_extent_trees[agno], start_agbno, &bno)) {
+		ret = 0;
+		goto out;	/* this really shouldn't happen */
+	}
+	if (bno < end_agbno) {
+		ret = 1;
+		goto out;
+	}
+	ret = (uintptr_t)btree_peek_prev(dup_extent_trees[agno], NULL) >
 								start_agbno;
+out:
+	pthread_mutex_unlock(&dup_extent_tree_locks[agno]);
+	return ret;
 }
 
 
@@ -856,6 +872,10 @@ incore_ext_init(xfs_mount_t *mp)
 	if (!dup_extent_trees)
 		do_error(_("couldn't malloc dup extent tree descriptor table\n"));
 
+	dup_extent_tree_locks = calloc(agcount, sizeof(pthread_mutex_t));
+	if (!dup_extent_tree_locks)
+		do_error(_("couldn't malloc dup extent tree descriptor table\n"));
+
 	if ((extent_bno_ptrs = malloc(agcount *
 					sizeof(avltree_desc_t *))) == NULL)
 		do_error(
@@ -879,6 +899,7 @@ incore_ext_init(xfs_mount_t *mp)
 
 	for (i = 0; i < agcount; i++)  {
 		btree_init(&dup_extent_trees[i]);
+		pthread_mutex_init(&dup_extent_tree_locks[i], NULL);
 		avl_init_tree(extent_bno_ptrs[i], &avl_extent_tree_ops);
 		avl_init_tree(extent_bcnt_ptrs[i], &avl_extent_bcnt_tree_ops);
 	}
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
