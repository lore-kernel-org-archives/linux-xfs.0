Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47083 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbcJYXGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:06:53 -0400
Subject: [PATCH 30/39] xfs_repair: record reflink inode state
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:06:48 -0700
Message-ID: <147743680894.11035.12324719494742257672.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Record the state of the per-inode reflink flag, so that we can
compare against the rmap data and update the flags accordingly.
Clear the (reflink) state if we clear the inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dino_chunks.c |    1 +
 repair/dinode.c      |    6 ++++++
 repair/incore.h      |   38 ++++++++++++++++++++++++++++++++++++++
 repair/incore_ino.c  |    2 ++
 repair/rmap.c        |   26 ++++++++++++++++++++++++++
 repair/rmap.h        |    2 ++
 6 files changed, 75 insertions(+)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 7dbaca6..4db9512 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -931,6 +931,7 @@ process_inode_chunk(
 				do_warn(_("would have cleared inode %" PRIu64 "\n"),
 					ino);
 			}
+			clear_inode_was_rl(ino_rec, irec_offset);
 		}
 
 process_next:
diff --git a/repair/dinode.c b/repair/dinode.c
index 98afdc9..64fc983 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2636,6 +2636,12 @@ _("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
 		goto clear_bad_out;
 
 	/*
+	 * record the state of the reflink flag
+	 */
+	if (collect_rmaps)
+		record_inode_reflink_flag(mp, dino, agno, ino, lino);
+
+	/*
 	 * check data fork -- if it's bad, clear the inode
 	 */
 	if (process_inode_data_fork(mp, agno, ino, dino, type, dirty,
diff --git a/repair/incore.h b/repair/incore.h
index b6c4b4f..bcd2f4b 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -283,6 +283,8 @@ typedef struct ino_tree_node  {
 	__uint64_t		ir_sparse;	/* sparse inode bitmask */
 	__uint64_t		ino_confirmed;	/* confirmed bitmask */
 	__uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
+	__uint64_t		ino_was_rl;	/* bit == 1 if reflink flag set */
+	__uint64_t		ino_is_rl;	/* bit == 1 if reflink flag should be set */
 	__uint8_t		nlink_size;
 	union ino_nlink		disk_nlinks;	/* on-disk nlinks, set in P3 */
 	union  {
@@ -494,6 +496,42 @@ static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
 }
 
 /*
+ * set/clear/test was inode marked as reflinked
+ */
+static inline void set_inode_was_rl(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_was_rl |= IREC_MASK(offset);
+}
+
+static inline void clear_inode_was_rl(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_was_rl &= ~IREC_MASK(offset);
+}
+
+static inline int inode_was_rl(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ino_was_rl & IREC_MASK(offset)) != 0;
+}
+
+/*
+ * set/clear/test should inode be marked as reflinked
+ */
+static inline void set_inode_is_rl(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_is_rl |= IREC_MASK(offset);
+}
+
+static inline void clear_inode_is_rl(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_is_rl &= ~IREC_MASK(offset);
+}
+
+static inline int inode_is_rl(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ino_is_rl & IREC_MASK(offset)) != 0;
+}
+
+/*
  * add_inode_reached() is set on inode I only if I has been reached
  * by an inode P claiming to be the parent and if I is a directory,
  * the .. link in the I says that P is I's parent.
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 1898257..2ec1765 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -257,6 +257,8 @@ alloc_ino_node(
 	irec->ino_startnum = starting_ino;
 	irec->ino_confirmed = 0;
 	irec->ino_isa_dir = 0;
+	irec->ino_was_rl = 0;
+	irec->ino_is_rl = 0;
 	irec->ir_free = (xfs_inofree_t) - 1;
 	irec->ir_sparse = 0;
 	irec->ino_un.ex_data = NULL;
diff --git a/repair/rmap.c b/repair/rmap.c
index e95f6c8..5de4d32 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1083,6 +1083,32 @@ rmap_high_key_from_rec(
 }
 
 /*
+ * Record that an inode had the reflink flag set when repair started.  The
+ * inode reflink flag will be adjusted as necessary.
+ */
+void
+record_inode_reflink_flag(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dino,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		ino,
+	xfs_ino_t		lino)
+{
+	struct ino_tree_node	*irec;
+	int			off;
+
+	ASSERT(XFS_AGINO_TO_INO(mp, agno, ino) == be64_to_cpu(dino->di_ino));
+	if (!(be64_to_cpu(dino->di_flags2) & XFS_DIFLAG2_REFLINK))
+		return;
+	irec = find_inode_rec(mp, agno, ino);
+	off = get_inode_offset(mp, lino, irec);
+	ASSERT(!inode_was_rl(irec, off));
+	set_inode_was_rl(irec, off);
+	dbg_printf("set was_rl lino=%llu was=0x%llx\n",
+		(unsigned long long)lino, (unsigned long long)irec->ino_was_rl);
+}
+
+/*
  * Regenerate the AGFL so that we don't run out of it while rebuilding the
  * rmap btree.  If skip_rmapbt is true, don't update the rmapbt (most probably
  * because we're updating the rmapbt).
diff --git a/repair/rmap.h b/repair/rmap.h
index 01dec9f..ab6f434 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -50,6 +50,8 @@ extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 		struct xfs_rmap_irec *key);
 
 extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
+extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
+	xfs_agnumber_t, xfs_agino_t, xfs_ino_t);
 
 extern void fix_freelist(struct xfs_mount *, xfs_agnumber_t, bool);
 extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);

