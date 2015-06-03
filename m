Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73D327F95
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 01:05:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3383AC004
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 23:05:07 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gzgyFmV3ksXV1P8L for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 23:05:05 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Z01nQ-0001D8-HY
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Z01nQ-0002um-Gr
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/20] xfs: factor out free space extent length check
Date: Wed,  3 Jun 2015 16:04:39 +1000
Message-Id: <1433311497-10245-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1433311497-10245-1-git-send-email-david@fromorbit.com>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
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

The longest extent length checks in xfs_alloc_fix_freelist() are now
essentially identical. Factor them out into a helper function, so we
know they are checking exactly the same thing before and after we
lock the AGF.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 71 +++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 08b45f8..2471cb5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1871,6 +1871,39 @@ xfs_alloc_longest_free_extent(
 }
 
 /*
+ * Check if the operation we are fixing up the freelist for should go ahead or
+ * not. If we are freeing blocks, we always allow it, otherwise the allocation
+ * is dependent on whether the size and shape of free space available will
+ * permit the requested allocation to take place.
+ */
+static bool
+xfs_alloc_space_available(
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		min_free,
+	int			flags)
+{
+	struct xfs_perag	*pag = args->pag;
+	xfs_extlen_t		longest;
+	int			available;
+
+	if (flags & XFS_ALLOC_FLAG_FREEING)
+		return true;
+
+	/* do we have enough contiguous free space for the allocation? */
+	longest = xfs_alloc_longest_free_extent(args->mp, pag, min_free);
+	if ((args->minlen + args->alignment + args->minalignslop - 1) > longest)
+		return false;
+
+	/* do have enough free space remaining for the allocation? */
+	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
+			  min_free - args->total);
+	if (available < (int)args->minleft)
+		return false;
+
+	return true;
+}
+
+/*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
  */
@@ -1883,7 +1916,6 @@ xfs_alloc_fix_freelist(
 	xfs_buf_t	*agflbp;/* agfl buffer pointer */
 	xfs_agblock_t	bno;	/* freelist block */
 	int		error;	/* error result code */
-	xfs_extlen_t	longest;/* longest extent in allocation group */
 	xfs_mount_t	*mp;	/* file system mount point structure */
 	xfs_extlen_t	need;	/* total blocks needed in freelist */
 	xfs_perag_t	*pag;	/* per-ag information structure */
@@ -1919,22 +1951,12 @@ xfs_alloc_fix_freelist(
 		return 0;
 	}
 
-	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
-		/*
-		 * If it looks like there isn't a long enough extent, or enough
-		 * total blocks, reject it.
-		 */
-		need = XFS_MIN_FREELIST_PAG(pag, mp);
-		longest = xfs_alloc_longest_free_extent(mp, pag, need);
-		if ((args->minlen + args->alignment + args->minalignslop - 1) >
-				longest ||
-		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
-			   need - args->total) < (int)args->minleft)) {
-			if (agbp)
-				xfs_trans_brelse(tp, agbp);
-			args->agbp = NULL;
-			return 0;
-		}
+	need = XFS_MIN_FREELIST_PAG(pag, mp);
+	if (!xfs_alloc_space_available(args, need, flags)) {
+		if (agbp)
+			xfs_trans_brelse(tp, agbp);
+		args->agbp = NULL;
+		return 0;
 	}
 
 	/*
@@ -1956,17 +1978,12 @@ xfs_alloc_fix_freelist(
 
 	/* If there isn't enough total space or single-extent, reject it. */
 	need = XFS_MIN_FREELIST_PAG(pag, mp);
-	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
-		longest = xfs_alloc_longest_free_extent(mp, pag, need);
-		if ((args->minlen + args->alignment + args->minalignslop - 1) >
-				longest ||
-		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
-			   need - args->total) < (int)args->minleft)) {
-			xfs_trans_brelse(tp, agbp);
-			args->agbp = NULL;
-			return 0;
-		}
+	if (!xfs_alloc_space_available(args, need, flags)) {
+		xfs_trans_brelse(tp, agbp);
+		args->agbp = NULL;
+		return 0;
 	}
+
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
