Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF22629DFC
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:27:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85A37AC004
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:27:01 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id kBLyEkFjpDcAKuKX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:26:59 -0700 (PDT)
Subject: [PATCH 12/15] xfs_repair: collect reverse-mapping data for
	refcount/rmap tree rebuilding
From: "Darrick J. Wong" <djwong@birch.djwong.org>
Date: Mon, 29 Jun 2015 20:26:56 -0700
Message-ID: <20150630032656.572.40741.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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

Collect reverse-mapping data for the entire filesystem so that we can
later check and rebuild the reference count tree and the reverse mapping
tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/Makefile     |    4 -
 repair/dinode.c     |   42 ++++++++++
 repair/incore.h     |   38 +++++++++
 repair/incore_ino.c |    2 
 repair/phase4.c     |    2 
 repair/rmap.c       |  206 +++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h       |   34 ++++++++
 repair/xfs_repair.c |    4 +
 8 files changed, 330 insertions(+), 2 deletions(-)
 create mode 100644 repair/rmap.c
 create mode 100644 repair/rmap.h


diff --git a/repair/Makefile b/repair/Makefile
index 82cba8e..7239a9e 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -11,14 +11,14 @@ LTCOMMAND = xfs_repair
 
 HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h btree.h \
 	dinode.h dir2.h err_protos.h globals.h incore.h protos.h rt.h \
-	progress.h scan.h versions.h prefetch.h threads.h slab.h
+	progress.h scan.h versions.h prefetch.h threads.h slab.h rmap.h
 
 CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
 	dino_chunks.c dinode.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
 	progress.c prefetch.c rt.c sb.c scan.c threads.c \
-	versions.c xfs_repair.c slab.c
+	versions.c xfs_repair.c slab.c rmap.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
diff --git a/repair/dinode.c b/repair/dinode.c
index fc8bc12..e706998 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -30,6 +30,8 @@
 #include "attr_repair.h"
 #include "bmap.h"
 #include "threads.h"
+#include "slab.h"
+#include "rmap.h"
 
 /*
  * gettext lookups for translations of strings use mutexes internally to
@@ -720,6 +722,9 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 			 * checking each entry without setting the
 			 * block bitmap
 			 */
+			if (type == XR_INO_DATA &&
+			    xfs_sb_version_hasreflink(&mp->m_sb))
+				goto skip_dup;
 			if (search_dup_extent(agno, agbno, ebno)) {
 				do_warn(
 _("%s fork in ino %" PRIu64 " claims dup extent, "
@@ -729,6 +734,7 @@ _("%s fork in ino %" PRIu64 " claims dup extent, "
 					irec.br_blockcount);
 				goto done;
 			}
+skip_dup:
 			*tot += irec.br_blockcount;
 			continue;
 		}
@@ -768,6 +774,9 @@ _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 			case XR_E_INUSE:
 			case XR_E_MULT:
 				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
+				if (type == XR_INO_DATA &&
+				    xfs_sb_version_hasreflink(&mp->m_sb))
+					break;
 				do_warn(
 _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
 					forkname, ftype, ino, b);
@@ -779,6 +788,13 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 					state, b);
 			}
 		}
+		if (collect_rmaps) { /* && !check_dups */
+			error = add_rmap(mp, ino, whichfork, &irec);
+			if (error)
+				do_error(
+_("couldn't add reverse mapping\n")
+					);
+		}
 		*tot += irec.br_blockcount;
 	}
 	error = 0;
@@ -2387,6 +2403,26 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			flags &= XFS_DIFLAG_ANY;
 		}
 
+		if ((flags & XFS_DIFLAG_REFLINK) &&
+		    !xfs_sb_version_hasreflink(&mp->m_sb)) {
+			if (!uncertain) {
+				do_warn(
+	_("inode %" PRIu64 " is marked reflinked but file system does not support reflink\n"),
+					lino);
+			}
+			goto clear_bad_out;
+		}
+
+		if ((flags & XFS_DIFLAG_REFLINK) &&
+		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+			if (!uncertain) {
+				do_warn(
+	_("Cannot have a reflinked realtime inode %" PRIu64 "\n"),
+					lino);
+			}
+			goto clear_bad_out;
+		}
+
 		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) {
 			/* need an rt-dev! */
 			if (!rt_name) {
@@ -2544,6 +2580,12 @@ _("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
 		goto clear_bad_out;
 
 	/*
+	 * record the state of the reflink flag
+	 */
+	if (collect_rmaps)
+		reflink_record_inode_flag(mp, dino, agno, ino, lino);
+
+	/*
 	 * check data fork -- if it's bad, clear the inode
 	 */
 	if (process_inode_data_fork(mp, agno, ino, dino, type, dirty,
diff --git a/repair/incore.h b/repair/incore.h
index ad19daa..e6c5310 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -282,6 +282,8 @@ typedef struct ino_tree_node  {
 	__uint64_t		ir_sparse;	/* sparse inode bitmask */
 	__uint64_t		ino_confirmed;	/* confirmed bitmask */
 	__uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
+	__uint64_t		ino_was_rl;	/* bit == 1 if reflink flag set */
+	__uint64_t		ino_is_rl;	/* bit == 1 if reflink flag should be set */
 	__uint8_t		nlink_size;
 	union ino_nlink		disk_nlinks;	/* on-disk nlinks, set in P3 */
 	union  {
@@ -493,6 +495,42 @@ static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
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
index cda6c2b..dd426aa 100644
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
diff --git a/repair/phase4.c b/repair/phase4.c
index aa79ae0..2c2cccb 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -31,6 +31,7 @@
 #include "dir2.h"
 #include "progress.h"
 
+bool collect_rmaps = false;
 
 /*
  * null out quota inode fields in sb if they point to non-existent inodes.
@@ -169,6 +170,7 @@ phase4(xfs_mount_t *mp)
 	int			ag_hdr_block;
 	int			bstate;
 
+	collect_rmaps = true;
 	ag_hdr_block = howmany(ag_hdr_len, mp->m_sb.sb_blocksize);
 
 	do_log(_("Phase 4 - check for duplicate blocks...\n"));
diff --git a/repair/rmap.c b/repair/rmap.c
new file mode 100644
index 0000000..2e1829c
--- /dev/null
+++ b/repair/rmap.c
@@ -0,0 +1,206 @@
+/*
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <libxfs.h>
+#include "btree.h"
+#include "err_protos.h"
+#include "libxlog.h"
+#include "incore.h"
+#include "globals.h"
+#include "dinode.h"
+#include "slab.h"
+#include "rmap.h"
+
+#undef RMAP_DEBUG
+
+#ifdef RMAP_DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
+/* Reverse mapping observation */
+typedef struct xfs_rmap {
+	xfs_ino_t	rm_ino;		/* inode number */
+	xfs_fileoff_t	rm_startoff;	/* starting file offset */
+	xfs_agblock_t	rm_startblock;	/* starting AG block number */
+	xfs_extlen_t	rm_blockcount;	/* number of AG blocks */
+	struct xfs_rmap	*rm_next;	/* next item in stack */
+} xfs_rmap_t;
+
+/* per-AG rmap object anchor */
+typedef struct xfs_ag_rmap {
+	xfs_slab_t	*ar_rmaps;		/* rmap observations, p4 */
+	xfs_slab_t	*ar_reflink_items;	/* reflink items, p4-5 */
+} xfs_ag_rmap_t;
+
+static xfs_ag_rmap_t *ag_rmaps;
+
+/**
+ * needs_rmap_work() -- Return true if we must reconstruct either the
+ *                      reference count or reverse mapping trees.
+ */
+bool
+needs_rmap_work(
+	xfs_mount_t	*mp)
+{
+	return xfs_sb_version_hasreflink(&mp->m_sb) ||
+	       xfs_sb_version_hasrmapbt(&mp->m_sb);
+}
+
+/**
+ * init_rmaps() -- Initialize per-AG reverse map data.
+ */
+void
+init_rmaps(
+	xfs_mount_t	*mp)
+{
+	xfs_agnumber_t	i;
+	int		error;
+
+	if (!needs_rmap_work(mp))
+		return;
+
+	ag_rmaps = calloc(mp->m_sb.sb_agcount, sizeof(xfs_ag_rmap_t));
+	if (!ag_rmaps)
+		do_error(_("couldn't allocate per-AG reverse map roots\n"));
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		error = init_slab(&ag_rmaps[i].ar_rmaps, sizeof(xfs_rmap_t));
+		if (error)
+			do_error(
+_("Insufficient memory while allocating reverse mapping slabs."));
+		error = init_slab(&ag_rmaps[i].ar_reflink_items,
+				  sizeof(xfs_reflink_rec_incore_t));
+		if (error)
+			do_error(
+_("Insufficient memory while allocating reflink item slabs."));
+	}
+}
+
+/**
+ * free_rmaps() -- Free the per-AG reverse-mapping data.
+ */
+void
+free_rmaps(
+	xfs_mount_t	*mp)
+{
+	xfs_agnumber_t	i;
+
+	if (!needs_rmap_work(mp))
+		return;
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		free_slab(&ag_rmaps[i].ar_rmaps);
+		free_slab(&ag_rmaps[i].ar_reflink_items);
+	}
+	free(ag_rmaps);
+	ag_rmaps = NULL;
+}
+
+/**
+ * add_rmap() -- Add an observation about a physical block mapping for later
+ *               btree reconstruction.
+ *
+ * @mp:	XFS mount object.
+ * @ino: The inode number associated with the extent mapping.
+ * @whichfork: Data or attribute fork?
+ * @irec: The extent mapping to record.
+ */
+int
+add_rmap(
+	xfs_mount_t		*mp,
+	xfs_ino_t		ino,
+	int			whichfork,
+	xfs_bmbt_irec_t		*irec)
+{
+	xfs_slab_t		*rmaps;
+	xfs_rmap_t		rmap;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+
+	if (!needs_rmap_work(mp))
+		return 0;
+
+	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+	ASSERT(agno != NULLAGNUMBER);
+	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(agbno + irec->br_blockcount <= mp->m_sb.sb_agblocks);
+	ASSERT(ino != NULLFSINO);
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	rmaps = ag_rmaps[agno].ar_rmaps;
+	rmap.rm_ino = ino;
+	rmap.rm_startoff = irec->br_startoff;
+	rmap.rm_startblock = agbno;
+	rmap.rm_blockcount = irec->br_blockcount;
+	rmap.rm_next = NULL;
+	return slab_add(rmaps, &rmap);
+}
+
+#ifdef RMAP_DEBUG
+static void
+dump_rmap(
+	const char		*msg,
+	xfs_agnumber_t		agno,
+	xfs_rmap_t		*rmap)
+{
+	printf("%s: %p agno=%u pblk=%llu ino=%llu lblk=%llu len=%u\n", msg,
+		rmap,
+		(unsigned)agno,
+		(unsigned long long)rmap->rm_startblock,
+		(unsigned long long)rmap->rm_ino,
+		(unsigned long long)rmap->rm_startoff,
+		(unsigned)rmap->rm_blockcount);
+}
+#else
+# define dump_rmap(m, a, r)
+#endif
+
+/**
+ * reflink_record_inode_flag() -- Record that an inode had the reflink flag
+ *                                set when repair started.  The inode reflink
+ *                                flag will be adjusted as necessary.
+ * @mp: XFS mount object.
+ * @dino: On-disk inode.
+ * @agno: AG number of the inode.
+ * @ino: AG inode number.
+ * @lino: Full inode number.
+ */
+void
+reflink_record_inode_flag(
+	xfs_mount_t	*mp,
+	xfs_dinode_t	*dino,
+	xfs_agnumber_t	agno,
+	xfs_agino_t	ino,
+	xfs_ino_t	lino)
+{
+	ino_tree_node_t	*irec;
+	int		off;
+
+	ASSERT(XFS_AGINO_TO_INO(mp, agno, ino) == be64_to_cpu(dino->di_ino));
+	if (!(be16_to_cpu(dino->di_flags) & XFS_DIFLAG_REFLINK))
+		return;
+	irec = find_inode_rec(mp, agno, ino);
+	off = get_inode_offset(mp, lino, irec);
+	ASSERT(!inode_was_rl(irec, off));
+	set_inode_was_rl(irec, off);
+	dbg_printf("set was_rl lino=%llu was=0x%llx\n",
+		(unsigned long long)lino, (unsigned long long)irec->ino_was_rl);
+}
diff --git a/repair/rmap.h b/repair/rmap.h
new file mode 100644
index 0000000..16ad157
--- /dev/null
+++ b/repair/rmap.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef RMAP_H_
+#define RMAP_H_
+
+extern bool collect_rmaps;
+
+extern void init_rmaps(xfs_mount_t *mp);
+extern void free_rmaps(xfs_mount_t *mp);
+
+extern int add_rmap(xfs_mount_t *mp, xfs_ino_t ino, int whichfork,
+	xfs_bmbt_irec_t *irec);
+
+extern void reflink_record_inode_flag(xfs_mount_t *mp, xfs_dinode_t *dino,
+	xfs_agnumber_t agno, xfs_agino_t ino, xfs_ino_t lino);
+
+extern bool needs_rmap_work(xfs_mount_t *mp);
+
+#endif /* RMAP_H_ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 07ddd00..3cd288a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -31,6 +31,8 @@
 #include "threads.h"
 #include "progress.h"
 #include "dinode.h"
+#include "slab.h"
+#include "rmap.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 
@@ -771,6 +773,7 @@ main(int argc, char **argv)
 	init_bmaps(mp);
 	incore_ino_init(mp);
 	incore_ext_init(mp);
+	init_rmaps(mp);
 
 	/* initialize random globals now that we know the fs geometry */
 	inodes_per_block = mp->m_sb.sb_inopblock;
@@ -804,6 +807,7 @@ main(int argc, char **argv)
 	/*
 	 * Done with the block usage maps, toss them...
 	 */
+	free_rmaps(mp);
 	free_bmaps(mp);
 
 	if (!bad_ino_btree)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
