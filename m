Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B9A338223
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:37:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D047304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:29 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2LaxOjQLynZurXAm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:27 -0700 (PDT)
Subject: [PATCH 062/145] xfs_repair: add fixed-location per-AG rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:37:15 -0700
Message-ID: <146612743563.16048.12801958251253451303.stgit@birch.djwong.org>
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

Add reverse-mappings for fixed-location per-AG metadata such as inode
chunks, superblocks, and the log to the raw rmap list, then merge the
raw rmap data (which also has the BMBT data) into the main rmap list.

v2: Support sparse inode chunks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |   41 +++++++++++++++++++++++++
 repair/rmap.c   |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h   |    2 +
 3 files changed, 135 insertions(+)


diff --git a/repair/phase4.c b/repair/phase4.c
index b4264df..8880c91 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -157,6 +157,40 @@ process_ags(
 	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
 }
 
+static void
+check_rmap_btrees(
+	work_queue_t	*wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
+{
+	int		error;
+
+	error = add_fixed_ag_rmap_data(wq->mp, agno);
+	if (error)
+		do_error(
+_("unable to add AG %u metadata reverse-mapping data.\n"), agno);
+
+	error = fold_raw_rmaps(wq->mp, agno);
+	if (error)
+		do_error(
+_("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
+}
+
+static void
+process_rmap_data(
+	struct xfs_mount	*mp)
+{
+	struct work_queue	wq;
+	xfs_agnumber_t		i;
+
+	if (!needs_rmap_work(mp))
+		return;
+
+	create_work_queue(&wq, mp, libxfs_nproc());
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		queue_work(&wq, check_rmap_btrees, i, NULL);
+	destroy_work_queue(&wq);
+}
 
 void
 phase4(xfs_mount_t *mp)
@@ -306,6 +340,13 @@ phase4(xfs_mount_t *mp)
 	 * already in phase 3.
 	 */
 	process_ags(mp);
+
+	/*
+	 * Process all the reverse-mapping data that we collected.  This
+	 * involves checking the rmap data against the btree.
+	 */
+	process_rmap_data(mp);
+
 	print_final_rpt();
 
 	/*
diff --git a/repair/rmap.c b/repair/rmap.c
index e30e99b..8f532fb 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -331,6 +331,98 @@ err:
 	return error;
 }
 
+static int
+find_first_zero_bit(
+	__uint64_t	mask)
+{
+	int		n;
+	int		b = 0;
+
+	for (n = 0; n < sizeof(mask) * NBBY && (mask & 1); n++, mask >>= 1)
+		b++;
+
+	return b;
+}
+
+static int
+popcnt(
+	__uint64_t	mask)
+{
+	int		n;
+	int		b = 0;
+
+	if (mask == 0)
+		return 0;
+
+	for (n = 0; n < sizeof(mask) * NBBY; n++, mask >>= 1)
+		if (mask & 1)
+			b++;
+
+	return b;
+}
+
+/*
+ * Add an allocation group's fixed metadata to the rmap list.  This includes
+ * sb/agi/agf/agfl headers, inode chunks, and the log.
+ */
+int
+add_fixed_ag_rmap_data(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	xfs_fsblock_t		fsbno;
+	xfs_agblock_t		agbno;
+	ino_tree_node_t		*ino_rec;
+	xfs_agino_t		agino;
+	int			error;
+	int			startidx;
+	int			nr;
+
+	if (!needs_rmap_work(mp))
+		return 0;
+
+	/* sb/agi/agf/agfl headers */
+	error = add_ag_rmap(mp, agno, 0, XFS_BNO_BLOCK(mp),
+			XFS_RMAP_OWN_FS);
+	if (error)
+		goto out;
+
+	/* inodes */
+	ino_rec = findfirst_inode_rec(agno);
+	for (; ino_rec != NULL; ino_rec = next_ino_rec(ino_rec)) {
+		if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
+			startidx = find_first_zero_bit(ino_rec->ir_sparse);
+			nr = XFS_INODES_PER_CHUNK - popcnt(ino_rec->ir_sparse);
+		} else {
+			startidx = 0;
+			nr = XFS_INODES_PER_CHUNK;
+		}
+		nr /= mp->m_sb.sb_inopblock;
+		if (nr == 0)
+			nr = 1;
+		agino = ino_rec->ino_startnum + startidx;
+		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+		if (XFS_AGINO_TO_OFFSET(mp, agino) == 0) {
+			error = add_ag_rmap(mp, agno, agbno, nr,
+					XFS_RMAP_OWN_INODES);
+			if (error)
+				goto out;
+		}
+	}
+
+	/* log */
+	fsbno = mp->m_sb.sb_logstart;
+	if (fsbno && XFS_FSB_TO_AGNO(mp, fsbno) == agno) {
+		agbno = XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart);
+		error = add_ag_rmap(mp, agno, agbno, mp->m_sb.sb_logblocks,
+				XFS_RMAP_OWN_LOG);
+		if (error)
+			goto out;
+	}
+out:
+	return error;
+}
+
 #ifdef RMAP_DEBUG
 static void
 dump_rmap(
diff --git a/repair/rmap.h b/repair/rmap.h
index 6a3a0a4..f948f25 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -34,4 +34,6 @@ extern int add_bmbt_rmap(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);
 extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern bool mergeable_rmaps(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
+extern int add_fixed_ag_rmap_data(struct xfs_mount *, xfs_agnumber_t);
+
 #endif /* RMAP_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
