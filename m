Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB9B88383
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:44:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25F5CAC004
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FJHoRAgGcPl91GzU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:19 -0700 (PDT)
Subject: [PATCH 128/145] xfs_repair: fix inode reflink flags
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:44:12 -0700
Message-ID: <146612785261.16048.12190820987789813213.stgit@birch.djwong.org>
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

While we're computing reference counts, record which inodes actually
share blocks with other files and fix the flags as necessary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |   20 ++++++++
 repair/rmap.c   |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h   |    1 
 3 files changed, 154 insertions(+)


diff --git a/repair/phase4.c b/repair/phase4.c
index 021d51d..59bb9fb 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -208,6 +208,21 @@ _("%s while computing reference count records.\n"),
 }
 
 static void
+process_inode_reflink_flags(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	int			error;
+
+	error = fix_inode_reflink_flags(wq->mp, agno);
+	if (error)
+		do_error(
+_("%s while fixing inode reflink flags.\n"),
+			 strerror(-error));
+}
+
+static void
 process_rmap_data(
 	struct xfs_mount	*mp)
 {
@@ -229,6 +244,11 @@ process_rmap_data(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, compute_ag_refcounts, i, NULL);
 	destroy_work_queue(&wq);
+
+	create_work_queue(&wq, mp, libxfs_nproc());
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		queue_work(&wq, process_inode_reflink_flags, i, NULL);
+	destroy_work_queue(&wq);
 }
 
 void
diff --git a/repair/rmap.c b/repair/rmap.c
index 6a62665..124173d 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -665,6 +665,39 @@ dump_rmap(
  */
 
 /*
+ * Mark all inodes in the reverse-mapping observation stack as requiring the
+ * reflink inode flag, if the stack depth is greater than 1.
+ */
+static void
+mark_inode_rl(
+	struct xfs_mount		*mp,
+	struct xfs_bag		*rmaps)
+{
+	xfs_agnumber_t		iagno;
+	struct xfs_rmap_irec	*rmap;
+	struct ino_tree_node	*irec;
+	int			off;
+	size_t			idx;
+	xfs_agino_t		ino;
+
+	if (bag_count(rmaps) < 2)
+		return;
+
+	/* Reflink flag accounting */
+	foreach_bag_ptr(rmaps, idx, rmap) {
+		ASSERT(!XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner));
+		iagno = XFS_INO_TO_AGNO(mp, rmap->rm_owner);
+		ino = XFS_INO_TO_AGINO(mp, rmap->rm_owner);
+		pthread_mutex_lock(&ag_locks[iagno].lock);
+		irec = find_inode_rec(mp, iagno, ino);
+		off = get_inode_offset(mp, rmap->rm_owner, irec);
+		/* lock here because we might go outside this ag */
+		set_inode_is_rl(irec, off);
+		pthread_mutex_unlock(&ag_locks[iagno].lock);
+	}
+}
+
+/*
  * Emit a refcount object for refcntbt reconstruction during phase 5.
  */
 #define REFCOUNT_CLAMP(nr)	((nr) > MAXREFCOUNT ? MAXREFCOUNT : (nr))
@@ -745,6 +778,7 @@ compute_refcounts(
 			if (error)
 				goto err;
 		}
+		mark_inode_rl(mp, stack_top);
 
 		/* Set nbno to the bno of the next refcount change */
 		if (n < slab_count(rmaps))
@@ -781,6 +815,7 @@ compute_refcounts(
 				if (error)
 					goto err;
 			}
+			mark_inode_rl(mp, stack_top);
 
 			/* Emit refcount if necessary */
 			ASSERT(nbno > cbno);
@@ -1099,6 +1134,104 @@ record_inode_reflink_flag(
 }
 
 /*
+ * Fix an inode's reflink flag.
+ */
+static int
+fix_inode_reflink_flag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	bool			set)
+{
+	struct xfs_dinode	*dino;
+	struct xfs_buf		*buf;
+
+	if (set)
+		do_warn(
+_("setting reflink flag on inode %"PRIu64"\n"),
+			XFS_AGINO_TO_INO(mp, agno, agino));
+	else if (!no_modify) /* && !set */
+		do_warn(
+_("clearing reflink flag on inode %"PRIu64"\n"),
+			XFS_AGINO_TO_INO(mp, agno, agino));
+	if (no_modify)
+		return 0;
+
+	buf = get_agino_buf(mp, agno, agino, &dino);
+	if (!buf)
+		return 1;
+	ASSERT(XFS_AGINO_TO_INO(mp, agno, agino) == be64_to_cpu(dino->di_ino));
+	if (set)
+		dino->di_flags2 |= cpu_to_be64(XFS_DIFLAG2_REFLINK);
+	else
+		dino->di_flags2 &= cpu_to_be64(~XFS_DIFLAG2_REFLINK);
+	libxfs_dinode_calc_crc(mp, dino);
+	libxfs_writebuf(buf, 0);
+
+	return 0;
+}
+
+/*
+ * Fix discrepancies between the state of the inode reflink flag and our
+ * observations as to whether or not the inode really needs it.
+ */
+int
+fix_inode_reflink_flags(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct ino_tree_node	*irec;
+	int			bit;
+	__uint64_t		was;
+	__uint64_t		is;
+	__uint64_t		diff;
+	__uint64_t		mask;
+	int			error = 0;
+	xfs_agino_t		agino;
+
+	/*
+	 * Update the reflink flag for any inode where there's a discrepancy
+	 * between the inode flag and whether or not we found any reflinked
+	 * extents.
+	 */
+	for (irec = findfirst_inode_rec(agno);
+	     irec != NULL;
+	     irec = next_ino_rec(irec)) {
+		ASSERT((irec->ino_was_rl & irec->ir_free) == 0);
+		ASSERT((irec->ino_is_rl & irec->ir_free) == 0);
+		was = irec->ino_was_rl;
+		is = irec->ino_is_rl;
+		if (was == is)
+			continue;
+		diff = was ^ is;
+		dbg_printf("mismatch ino=%llu was=0x%lx is=0x%lx dif=0x%lx\n",
+			(unsigned long long)XFS_AGINO_TO_INO(mp, agno,
+						irec->ino_startnum),
+			was, is, diff);
+
+		for (bit = 0, mask = 1; bit < 64; bit++, mask <<= 1) {
+			agino = bit + irec->ino_startnum;
+			if (!(diff & mask))
+				continue;
+			else if (was & mask)
+				error = fix_inode_reflink_flag(mp, agno, agino,
+						false);
+			else if (is & mask)
+				error = fix_inode_reflink_flag(mp, agno, agino,
+						true);
+			else
+				ASSERT(0);
+			if (error)
+				do_error(
+_("Unable to fix reflink flag on inode %"PRIu64".\n"),
+					XFS_AGINO_TO_INO(mp, agno, agino));
+		}
+	}
+
+	return error;
+}
+
+/*
  * Regenerate the AGFL so that we don't run out of it while rebuilding the
  * rmap btree.  If skip_rmapbt is true, don't update the rmapbt (most probably
  * because we're updating the rmapbt).
diff --git a/repair/rmap.h b/repair/rmap.h
index 47b2f3b..d6d360f 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -52,6 +52,7 @@ extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
 extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
 	xfs_agnumber_t, xfs_agino_t, xfs_ino_t);
+extern int fix_inode_reflink_flags(struct xfs_mount *, xfs_agnumber_t);
 
 extern void fix_freelist(struct xfs_mount *, xfs_agnumber_t, bool);
 extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
