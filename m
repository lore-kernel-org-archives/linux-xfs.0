Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B67FF29EB4
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:08:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F219AC006
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:08:25 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7FfbWLktCo1ZWAuH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:08:22 -0700 (PDT)
Subject: [PATCH 29/51] xfs_repair: collect reverse-mapping data for
	refcount/rmap tree rebuilding
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:08:19 -0700
Message-ID: <20151007050819.1504.30373.stgit@birch.djwong.org>
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

Collect reverse-mapping data for the entire filesystem so that we can
later check and rebuild the reference count tree and the reverse mapping
tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/Makefile     |    4 +
 repair/dinode.c     |    9 ++
 repair/phase4.c     |    5 +
 repair/rmap.c       |  195 +++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h       |   30 ++++++++
 repair/xfs_repair.c |    4 +
 6 files changed, 245 insertions(+), 2 deletions(-)
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
index e81c245..2c0a421 100644
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
@@ -779,6 +781,13 @@ _("illegal state %d in block map %" PRIu64 "\n"),
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
diff --git a/repair/phase4.c b/repair/phase4.c
index 1a7d7b5..bc43cd8 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -30,7 +30,10 @@
 #include "versions.h"
 #include "dir2.h"
 #include "progress.h"
+#include "slab.h"
+#include "rmap.h"
 
+bool collect_rmaps = false;
 
 /*
  * null out quota inode fields in sb if they point to non-existent inodes.
@@ -170,6 +173,8 @@ phase4(xfs_mount_t *mp)
 	int			ag_hdr_block;
 	int			bstate;
 
+	if (needs_rmap_work(mp))
+		collect_rmaps = true;
 	ag_hdr_block = howmany(ag_hdr_len, mp->m_sb.sb_blocksize);
 
 	do_log(_("Phase 4 - check for duplicate blocks...\n"));
diff --git a/repair/rmap.c b/repair/rmap.c
new file mode 100644
index 0000000..1a73dbb
--- /dev/null
+++ b/repair/rmap.c
@@ -0,0 +1,195 @@
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
+/* per-AG rmap object anchor */
+struct xfs_ag_rmap {
+	struct xfs_slab	*ar_rmaps;		/* rmap observations, p4 */
+};
+
+static struct xfs_ag_rmap *ag_rmaps;
+
+/*
+ * Compare rmap observations for array sorting.
+ */
+static int
+rmap_compare(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_rmap_irec	*pa;
+	const struct xfs_rmap_irec	*pb;
+
+	pa = a; pb = b;
+	if (pa->rm_startblock < pb->rm_startblock)
+		return -1;
+	else if (pa->rm_startblock > pb->rm_startblock)
+		return 1;
+	else if (pa->rm_owner < pb->rm_owner)
+		return -1;
+	else if (pa->rm_owner > pb->rm_owner)
+		return 1;
+	else if (pa->rm_offset < pb->rm_offset)
+		return -1;
+	else if (pa->rm_offset > pb->rm_offset)
+		return 1;
+	else
+		return 0;
+}
+
+/**
+ * needs_rmap_work() -- Return true if we must reconstruct either the
+ *                      reference count or reverse mapping trees.
+ *
+ * @mp: XFS mount object
+ */
+bool
+needs_rmap_work(
+	struct xfs_mount	*mp)
+{
+	return xfs_sb_version_hasrmapbt(&mp->m_sb);
+}
+
+/**
+ * init_rmaps() -- Initialize per-AG reverse map data.
+ *
+ * @mp: XFS mount object
+ */
+void
+init_rmaps(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		i;
+	int			error;
+
+	if (!needs_rmap_work(mp))
+		return;
+
+	ag_rmaps = calloc(mp->m_sb.sb_agcount, sizeof(struct xfs_ag_rmap));
+	if (!ag_rmaps)
+		do_error(_("couldn't allocate per-AG reverse map roots\n"));
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		error = init_slab(&ag_rmaps[i].ar_rmaps,
+				sizeof(struct xfs_rmap_irec));
+		if (error)
+			do_error(
+_("Insufficient memory while allocating reverse mapping slabs."));
+	}
+}
+
+/**
+ * free_rmaps() -- Free the per-AG reverse-mapping data.
+ *
+ * @mp: XFS mount object
+ */
+void
+free_rmaps(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		i;
+
+	if (!needs_rmap_work(mp))
+		return;
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		free_slab(&ag_rmaps[i].ar_rmaps);
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
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_slab		*rmaps;
+	struct xfs_rmap_irec	rmap;
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
+	rmap.rm_owner = ino;
+	rmap.rm_offset = irec->br_startoff;
+	if (whichfork == XFS_ATTR_FORK)
+		rmap.rm_offset |= XFS_RMAP_OFF_ATTR;
+	rmap.rm_startblock = agbno;
+	rmap.rm_blockcount = irec->br_blockcount;
+	if (irec->br_state == XFS_EXT_UNWRITTEN)
+		rmap.rm_blockcount |= XFS_RMAP_LEN_UNWRITTEN;
+	return slab_add(rmaps, &rmap);
+}
+
+#ifdef RMAP_DEBUG
+static void
+dump_rmap(
+	const char		*msg,
+	xfs_agnumber_t		agno,
+	struct xfs_rmap_irec	*rmap)
+{
+	printf("%s: %p agno=%u pblk=%llu ino=%llu lblk=%llu len=%u\n", msg,
+		rmap,
+		(unsigned)agno,
+		(unsigned long long)rmap->rm_startblock,
+		(unsigned long long)rmap->rm_owner,
+		(unsigned long long)rmap->rm_offset,
+		(unsigned)rmap->rm_blockcount);
+}
+#else
+# define dump_rmap(m, a, r)
+#endif
diff --git a/repair/rmap.h b/repair/rmap.h
new file mode 100644
index 0000000..be3d357
--- /dev/null
+++ b/repair/rmap.h
@@ -0,0 +1,30 @@
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
+extern bool needs_rmap_work(struct xfs_mount *);
+
+extern void init_rmaps(struct xfs_mount *);
+extern void free_rmaps(struct xfs_mount *);
+
+extern int add_rmap(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
+
+#endif /* RMAP_H_ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index a464cd3..f4289c0 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -31,6 +31,8 @@
 #include "threads.h"
 #include "progress.h"
 #include "dinode.h"
+#include "slab.h"
+#include "rmap.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 
@@ -790,6 +792,7 @@ main(int argc, char **argv)
 	init_bmaps(mp);
 	incore_ino_init(mp);
 	incore_ext_init(mp);
+	init_rmaps(mp);
 
 	/* initialize random globals now that we know the fs geometry */
 	inodes_per_block = mp->m_sb.sb_inopblock;
@@ -823,6 +826,7 @@ main(int argc, char **argv)
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
