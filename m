Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7AAC229EB7
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:08:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA105AC005
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:08:29 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uZx6OHCgcqI13sOa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:08:28 -0700 (PDT)
Subject: [PATCH 30/51] xfs_repair: record and merge raw rmap data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:08:26 -0700
Message-ID: <20151007050826.1504.14574.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
 repair/rmap.h |    3 +
 2 files changed, 140 insertions(+)


diff --git a/repair/rmap.c b/repair/rmap.c
index 1a73dbb..f3363f7 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -37,6 +37,7 @@
 /* per-AG rmap object anchor */
 struct xfs_ag_rmap {
 	struct xfs_slab	*ar_rmaps;		/* rmap observations, p4 */
+	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
@@ -107,6 +108,11 @@ init_rmaps(
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
 
@@ -126,6 +132,7 @@ free_rmaps(
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		free_slab(&ag_rmaps[i].ar_rmaps);
+		free_slab(&ag_rmaps[i].ar_raw_rmaps);
 	}
 	free(ag_rmaps);
 	ag_rmaps = NULL;
@@ -175,6 +182,136 @@ add_rmap(
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
+	rmap.rm_owner = owner;
+	rmap.rm_offset = 0;
+	if (is_attr)
+		rmap.rm_offset |= XFS_RMAP_OFF_ATTR;
+	if (is_bmbt)
+		rmap.rm_offset |= XFS_RMAP_OFF_BMBT;
+	rmap.rm_startblock = agbno;
+	rmap.rm_blockcount = len;
+	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
+}
+
+/**
+ * add_ag_rmap() -- Add an reverse mapping for a per-AG fixed metadata object.
+ *
+ * @mp:	XFS mount object.
+ * @agno: The AG number.
+ * @agbno: The block within the AG.
+ * @len: The length of the extent.
+ * @owner: The owner of the block.
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
+static bool
+mergeable_rmaps(
+	struct xfs_rmap_irec	*r1,
+	struct xfs_rmap_irec	*r2)
+{
+	if (r1->rm_startblock + r1->rm_blockcount != r2->rm_startblock)
+		return false;
+	if (r1->rm_owner != r2->rm_owner)
+		return false;
+	if (XFS_RMAP_NON_INODE_OWNER(r2->rm_owner))
+		return true;
+	/* must be an inode owner */
+	if (XFS_RMAP_IS_ATTR_FORK(r1->rm_offset) ^
+	    XFS_RMAP_IS_ATTR_FORK(r2->rm_offset))
+		return false;
+	if (XFS_RMAP_IS_BMBT(r1->rm_offset) || XFS_RMAP_IS_BMBT(r2->rm_offset))
+		return XFS_RMAP_IS_BMBT(r1->rm_offset) &&
+		       XFS_RMAP_IS_BMBT(r2->rm_offset);
+	return r1->rm_offset + r1->rm_blockcount == r2->rm_offset;
+}
+
+/**
+ * fold_raw_rmaps() - Merge adjacent raw rmaps and add them to the main
+ *		      rmap list.
+ * @mp: XFS mount.
+ * @agno: AG number.
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
index be3d357..51e916b 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -26,5 +26,8 @@ extern void init_rmaps(struct xfs_mount *);
 extern void free_rmaps(struct xfs_mount *);
 
 extern int add_rmap(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
+extern int add_ag_rmap(struct xfs_mount *, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
+extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 #endif /* RMAP_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
