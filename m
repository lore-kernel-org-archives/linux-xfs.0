Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A5B029EF5
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:10:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 39A668F8037
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:10:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id rD6TKikS2KzTUdg8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:10:20 -0700 (PDT)
Subject: [PATCH 46/51] xfs_repair: record reflink inode state
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:10:13 -0700
Message-ID: <20151007051013.1504.65933.stgit@birch.djwong.org>
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

Record the state of the per-inode reflink flag, so that we can
compare against the rmap data and update the flags accordingly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c     |    6 ++++++
 repair/incore.h     |   38 ++++++++++++++++++++++++++++++++++++++
 repair/incore_ino.c |    2 ++
 repair/rmap.c       |   32 ++++++++++++++++++++++++++++++++
 repair/rmap.h       |    3 +++
 5 files changed, 81 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 5b7c31f..89adb4f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2606,6 +2606,12 @@ _("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
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
index 32d7678..674bedb 100644
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
index 8818913..2e79577 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -961,6 +961,38 @@ err:
 	return 0;
 }
 
+/*
+ * record_inode_reflink_flag() -- Record that an inode had the reflink flag
+ *                                set when repair started.  The inode reflink
+ *                                flag will be adjusted as necessary.
+ * @mp: XFS mount object.
+ * @dino: On-disk inode.
+ * @agno: AG number of the inode.
+ * @ino: AG inode number.
+ * @lino: Full inode number.
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
 /**
  * fix_freelist() - Regenerate the AGFL, so that we don't run out of it while
  *		    rebuilding the rmapbt.
diff --git a/repair/rmap.h b/repair/rmap.h
index 13df5d6..b404c59 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -41,6 +41,9 @@ extern int check_rmaps(struct xfs_mount *, xfs_agnumber_t);
 
 extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
 
+extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
+	xfs_agnumber_t, xfs_agino_t, xfs_ino_t);
+
 extern void fix_freelist(struct xfs_mount *, xfs_agnumber_t, bool);
 extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
