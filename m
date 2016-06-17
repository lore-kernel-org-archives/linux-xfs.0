Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B5398249
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:37:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 254B1AC003
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:54 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Lp70H8SKcbj18Xj4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:52 -0700 (PDT)
Subject: [PATCH 066/145] xfs_repair: merge data & attr fork reverse mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:37:45 -0700
Message-ID: <146612746543.16048.15290406733335696865.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Merge data and attribute fork reverse mappings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |   10 ++++++++++
 repair/rmap.c   |   32 +++++++++++++++++++++++++++++---
 repair/rmap.h   |    2 ++
 3 files changed, 41 insertions(+), 3 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index e234d92..3be3786 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -154,7 +154,17 @@ static void
 process_ags(
 	xfs_mount_t		*mp)
 {
+	xfs_agnumber_t		i;
+	int			error;
+
 	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		error = finish_collecting_fork_rmaps(mp, i);
+		if (error)
+			do_error(
+_("unable to finish adding attr/data fork reverse-mapping data for AG %u.\n"),
+				i);
+	}
 }
 
 static void
diff --git a/repair/rmap.c b/repair/rmap.c
index 9c17ee8..e39df5a 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -41,6 +41,7 @@ struct xfs_ag_rmap {
 	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
 	int		ar_flcount;		/* agfl entries from leftover */
 						/* agbt allocations */
+	struct xfs_rmap_irec	ar_last_rmap;	/* last rmap seen */
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
@@ -118,6 +119,7 @@ _("Insufficient memory while allocating reverse mapping slabs."));
 		if (error)
 			do_error(
 _("Insufficient memory while allocating raw metadata reverse mapping slabs."));
+		ag_rmaps[i].ar_last_rmap.rm_owner = XFS_RMAP_OWN_UNKNOWN;
 	}
 }
 
@@ -177,10 +179,11 @@ add_rmap(
 	int			whichfork,
 	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_slab		*rmaps;
 	struct xfs_rmap_irec	rmap;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
+	struct xfs_rmap_irec	*last_rmap;
+	int			error = 0;
 
 	if (!needs_rmap_work(mp))
 		return 0;
@@ -193,7 +196,6 @@ add_rmap(
 	ASSERT(ino != NULLFSINO);
 	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
 
-	rmaps = ag_rmaps[agno].ar_rmaps;
 	rmap.rm_owner = ino;
 	rmap.rm_offset = irec->br_startoff;
 	rmap.rm_flags = 0;
@@ -203,7 +205,31 @@ add_rmap(
 	rmap.rm_blockcount = irec->br_blockcount;
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
-	return slab_add(rmaps, &rmap);
+	last_rmap = &ag_rmaps[agno].ar_last_rmap;
+	if (last_rmap->rm_owner == XFS_RMAP_OWN_UNKNOWN)
+		*last_rmap = rmap;
+	else if (mergeable_rmaps(last_rmap, &rmap))
+		last_rmap->rm_blockcount += rmap.rm_blockcount;
+	else {
+		error = slab_add(ag_rmaps[agno].ar_rmaps, last_rmap);
+		if (error)
+			return error;
+		*last_rmap = rmap;
+	}
+
+	return error;
+}
+
+/* Finish collecting inode data/attr fork rmaps. */
+int
+finish_collecting_fork_rmaps(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	if (!needs_rmap_work(mp) ||
+	    ag_rmaps[agno].ar_last_rmap.rm_owner == XFS_RMAP_OWN_UNKNOWN)
+		return 0;
+	return slab_add(ag_rmaps[agno].ar_rmaps, &ag_rmaps[agno].ar_last_rmap);
 }
 
 /* add a raw rmap; these will be merged later */
diff --git a/repair/rmap.h b/repair/rmap.h
index 4722266..69215e8 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -28,6 +28,8 @@ extern void init_rmaps(struct xfs_mount *);
 extern void free_rmaps(struct xfs_mount *);
 
 extern int add_rmap(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
+extern int finish_collecting_fork_rmaps(struct xfs_mount *mp,
+		xfs_agnumber_t agno);
 extern int add_ag_rmap(struct xfs_mount *, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
 extern int add_bmbt_rmap(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
