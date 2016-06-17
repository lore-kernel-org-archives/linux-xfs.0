Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DA2281C7
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:37:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D55C304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:13 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5egZY8jLDAwZBB5D (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:10 -0700 (PDT)
Subject: [PATCH 060/145] xfs_repair: record and merge raw rmap data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:37:03 -0700
Message-ID: <146612742343.16048.8981147515226574112.stgit@birch.djwong.org>
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

Since we still allow merging of BMBT block, AG metadata, and AG btree
block rmaps, provide a facility to collect these raw observations and
merge them (with maximal length) into the main rmap list.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/rmap.c |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h |    4 ++
 2 files changed, 140 insertions(+), 1 deletion(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index e78115e..1851742 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -38,6 +38,7 @@
 /* per-AG rmap object anchor */
 struct xfs_ag_rmap {
 	struct xfs_slab	*ar_rmaps;		/* rmap observations, p4 */
+	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
@@ -109,6 +110,11 @@ init_rmaps(
 		if (error)
 			do_error(
 _("Insufficient memory while allocating reverse mapping slabs."));
+		error = init_slab(&ag_rmaps[i].ar_raw_rmaps,
+				  sizeof(struct xfs_rmap_irec));
+		if (error)
+			do_error(
+_("Insufficient memory while allocating raw metadata reverse mapping slabs."));
 	}
 }
 
@@ -124,13 +130,40 @@ free_rmaps(
 	if (!needs_rmap_work(mp))
 		return;
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		free_slab(&ag_rmaps[i].ar_rmaps);
+		free_slab(&ag_rmaps[i].ar_raw_rmaps);
+	}
 	free(ag_rmaps);
 	ag_rmaps = NULL;
 }
 
 /*
+ * Decide if two reverse-mapping records can be merged.
+ */
+bool
+mergeable_rmaps(
+	struct xfs_rmap_irec	*r1,
+	struct xfs_rmap_irec	*r2)
+{
+	if (r1->rm_owner != r2->rm_owner)
+		return false;
+	if (r1->rm_startblock + r1->rm_blockcount != r2->rm_startblock)
+		return false;
+	if ((unsigned long long)r1->rm_blockcount + r2->rm_blockcount >
+	    XFS_RMAP_LEN_MAX)
+		return false;
+	if (XFS_RMAP_NON_INODE_OWNER(r2->rm_owner))
+		return true;
+	/* must be an inode owner below here */
+	if (r1->rm_flags != r2->rm_flags)
+		return false;
+	if (r1->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		return true;
+	return r1->rm_offset + r1->rm_blockcount == r2->rm_offset;
+}
+
+/*
  * Add an observation about a block mapping in an inode's data or attribute
  * fork for later btree reconstruction.
  */
@@ -170,6 +203,108 @@ add_rmap(
 	return slab_add(rmaps, &rmap);
 }
 
+/* add a raw rmap; these will be merged later */
+static int
+__add_raw_rmap(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	bool			is_attr,
+	bool			is_bmbt)
+{
+	struct xfs_rmap_irec	rmap;
+
+	ASSERT(len != 0);
+	rmap.rm_owner = owner;
+	rmap.rm_offset = 0;
+	rmap.rm_flags = 0;
+	if (is_attr)
+		rmap.rm_flags |= XFS_RMAP_ATTR_FORK;
+	if (is_bmbt)
+		rmap.rm_flags |= XFS_RMAP_BMBT_BLOCK;
+	rmap.rm_startblock = agbno;
+	rmap.rm_blockcount = len;
+	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
+}
+
+/*
+ * Add a reverse mapping for a per-AG fixed metadata extent.
+ */
+int
+add_ag_rmap(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner)
+{
+	if (!needs_rmap_work(mp))
+		return 0;
+
+	ASSERT(agno != NULLAGNUMBER);
+	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
+
+	return __add_raw_rmap(mp, agno, agbno, len, owner, false, false);
+}
+
+/*
+ * Merge adjacent raw rmaps and add them to the main rmap list.
+ */
+int
+fold_raw_rmaps(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_slab_cursor	*cur = NULL;
+	struct xfs_rmap_irec	*prev, *rec;
+	size_t			old_sz;
+	int			error;
+
+	old_sz = slab_count(ag_rmaps[agno].ar_rmaps);
+	if (slab_count(ag_rmaps[agno].ar_raw_rmaps) == 0)
+		goto no_raw;
+	qsort_slab(ag_rmaps[agno].ar_raw_rmaps, rmap_compare);
+	error = init_slab_cursor(ag_rmaps[agno].ar_raw_rmaps, rmap_compare,
+			&cur);
+	if (error)
+		goto err;
+
+	prev = pop_slab_cursor(cur);
+	rec = pop_slab_cursor(cur);
+	while (rec) {
+		if (mergeable_rmaps(prev, rec)) {
+			prev->rm_blockcount += rec->rm_blockcount;
+			rec = pop_slab_cursor(cur);
+			continue;
+		}
+		error = slab_add(ag_rmaps[agno].ar_rmaps, prev);
+		if (error)
+			goto err;
+		prev = rec;
+		rec = pop_slab_cursor(cur);
+	}
+	if (prev) {
+		error = slab_add(ag_rmaps[agno].ar_rmaps, prev);
+		if (error)
+			goto err;
+	}
+	free_slab(&ag_rmaps[agno].ar_raw_rmaps);
+	error = init_slab(&ag_rmaps[agno].ar_raw_rmaps,
+			sizeof(struct xfs_rmap_irec));
+	if (error)
+		do_error(
+_("Insufficient memory while allocating raw metadata reverse mapping slabs."));
+no_raw:
+	if (old_sz)
+		qsort_slab(ag_rmaps[agno].ar_rmaps, rmap_compare);
+err:
+	free_slab_cursor(&cur);
+	return error;
+}
+
 #ifdef RMAP_DEBUG
 static void
 dump_rmap(
diff --git a/repair/rmap.h b/repair/rmap.h
index 0832790..ca92623 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -28,5 +28,9 @@ extern void init_rmaps(struct xfs_mount *);
 extern void free_rmaps(struct xfs_mount *);
 
 extern int add_rmap(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
+extern int add_ag_rmap(struct xfs_mount *, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
+extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
+extern bool mergeable_rmaps(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
 #endif /* RMAP_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
