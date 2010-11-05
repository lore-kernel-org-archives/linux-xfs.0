Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA5GZLbf209040 for <xfs@oss.sgi.com>; Fri, 5 Nov 2010 11:35:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 171FAAC014
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 09:36:47 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 5F5EB7006201
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 11:36:44 -0500 (CDT)
Message-Id: <20101105163644.182690256@sgi.com>
Date: Fri, 05 Nov 2010 11:35:06 -0500
From: wkendall@sgi.com
Subject: [PATCH v2 6/9] xfsrestore: fix node table setup
References: <20101105163500.747192954@sgi.com>
Content-Disposition: inline; filename=winmap_max_fix
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The node table setup code unintentionally limits the amount of virtual
memory that will be used for the node table. Rather than setting a
limit based on the remaining virtual memory, the node table is limited
to the amount of memory it thinks it will need based on the dump's
inode count. But the node table stores directory entries, not inodes,
and so dumps with lots of hard links end up thrashing mapping and
unmapping segments of the node table to stay within the self-imposed
virtual memory limit.

This patch also changes the node table to ensure that there are a
power of two nodes per segment. Profiling revealed that while building
the node table, 50% of the restore cpu time was spent doing division
and modulo to convert a node index into its segment index and offset
within the segment. This change prepares the node table for another
patch which will change the lookup mechanism to use shift and
bitwise-and.

Also don't bother passing the estimated segment table size to the
window abstraction. It has to deal with resizing the table anyway and
can choose a reasonable starting size.


Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 restore/node.c |  125 ++++++++++++++++++++++++++++++++++-----------------------
 restore/win.c  |    7 +--
 restore/win.h  |    3 -
 3 files changed, 80 insertions(+), 55 deletions(-)

Index: xfsdump-kernel.org/restore/node.c
===================================================================
--- xfsdump-kernel.org.orig/restore/node.c
+++ xfsdump-kernel.org/restore/node.c
@@ -97,19 +97,14 @@ extern size_t pgmask;
 
 #else /* NODECHK */
 
-#define NIX_MAX			( ( ( off64_t )1			\
-				    <<					\
-				    ( ( off64_t )NBBY			\
-				      *					\
-				      ( off64_t )sizeof( nh_t )))	\
-				  -					\
-				  ( off64_t )2 ) /* 2 to avoid NH_NULL */
+#define NIX_MAX			( NH_NULL - 1 )
 
 #endif /* NODECHK */
 
 /* window constraints
  */
-#define NODESPERSEGMIN	1000000
+#define NODESPERSEG_MIN	1048576
+#define WINMAP_MIN	4
 
 /* a node is identified internally by its index into the backing store.
  * this index is the offset of the node into the segmented portion of
@@ -135,17 +130,14 @@ struct node_hdr {
 		/* index of byte in each node the user has reserved
 		 * for use by me
 		 */
-	size_t nh_nodesperseg;
+	nh_t nh_nodesperseg;
 		/* an integral number of internal nodes must fit into a
 		 * segment
 		 */
-	size_t nh_segsz;
+	size64_t nh_segsz;
 		/* the backing store is partitoned into segment, which
 		 * can be mapped into VM windows  by the win abstraction
 		 */
-	size64_t nh_segtblsz;
-		/* the estimated size of the entire segment table.
-		 */
 	size_t nh_winmapmax;
 		/* maximum number of windows which can be mapped
 		 */
@@ -191,13 +183,13 @@ node_init( intgen_t fd,
 	   size64_t vmsz,
 	   size64_t dirs_nondirs_cnt )
 {
-	size64_t nodesz;
-	size64_t winmap_mem;
+	size_t nodesz;
 	size64_t segsz;
-	size64_t segtablesz;
-	size64_t nodesperseg;
-	size64_t minsegsz;
-	size64_t winmapmax;
+	nh_t nodesperseg;
+	size_t max_segments;
+	size_t winmapmax;
+	size_t segcount;
+	intgen_t segixshift;
 	intgen_t rval;
 
 	/* sanity checks
@@ -218,36 +210,76 @@ node_init( intgen_t fd,
 	*/
 	nodesz = ( usrnodesz + nodealignsz - 1 ) & ~( nodealignsz - 1 );
 
-#define	WINMAP_MAX	20	/* maximum number of windows to use */
-#define	WINMAP_MIN	4	/* minimum number of windows to use */
-#define	HARDLINK_FUDGE	1.2	/* approx 1.2 hard links per file */
-
-	/* Calculate the expected size of the segment table using the number
-	 * of dirs and non-dirs.  Since we don't know how many hard-links
-	 * there will be, scale the size upward using HARDLINK_FUDGE.
+	/* Calculate the node table params based on the number of inodes in the
+	 * dump, since that's all we know. Ideally we'd base this on the number
+	 * of dirents in the dump instead as there's a node per dirent.
+	 *
+	 * Due to virtual memory constraints and the fact that we don't know
+	 * the final node table size, we can't guarantee that the entire node
+	 * table can be mapped at once. Instead segments will be mapped using a
+	 * window abstraction. Some operations require WINMAP_MIN nodes to be
+	 * referenced at a time, therefore we must ensure that this many
+	 * segments fit in virtual memory.
+	 *
+	 * nodesperseg must be a power of two. Earlier versions did not enforce
+	 * this, and profiling showed that nearly 50% of cpu time during the
+	 * node table construction was consumed doing division and modulo to
+	 * convert an nh_t to a segment index and node offset.  By making
+	 * nodesperseg a power of two we can use shift and bitwise-and instead.
+	 *
+	 * Each segment must hold an integral number of nodes and be an integral
+	 * number of pages. #1 ensures this except when nodesperseg is small, so
+	 * the smallest allowed segsz is pgsz * nodesz (i.e., nodesperseg ==
+	 * pgsz). However this is of no consequence as we enforce a larger
+	 * minimum nodesperseg (NODESPERSEG_MIN) anyway in order to place a
+	 * reasonable cap on the max number of segments.
 	 */
 
-	segtablesz = ( (size64_t)(HARDLINK_FUDGE * (double)dirs_nondirs_cnt) * nodesz);
+	ASSERT( NODESPERSEG_MIN >= pgsz );
+
+	if ( vmsz < WINMAP_MIN * NODESPERSEG_MIN * nodesz ) {
+		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		  "not enough virtual memory for node abstraction: "
+		  "remaining-vsmz=%llu need=%llu\n"),
+		  vmsz, WINMAP_MIN * NODESPERSEG_MIN * nodesz );
+		return BOOL_FALSE;
+	}
 
-	/* Figure out how much memory is available for use by winmaps, and
-	 * use that to pick an appropriate winmapmax, segsz, and nodesperseg,
-	 * the goal being that if at all possible we want the entire segment
-	 * table to be mapped so that we aren't constantly mapping and
-	 * unmapping winmaps.  There must be at least WINMAP_MIN winmaps
-	 * because references can be held on more than one winmap at the
-	 * same time.  More winmaps are generally better to reduce the
-	 * number of nodes that are unmapped if unmapping does occur.
+	/* This is checked as nodes are allocated as well (remember that
+	 * dirs_nondirs_cnt may be less than the number of nodes/dirents).
+	 * Checking this here prevents potential overflow in the logic below.
 	 */
+	if ( dirs_nondirs_cnt > NIX_MAX ) {
+		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		  "dump contains %llu inodes, restore can only handle %llu\n"),
+		  dirs_nondirs_cnt, NIX_MAX );
+		return BOOL_FALSE;
+	}
+
+	for ( winmapmax = 0, segcount = 1; winmapmax < WINMAP_MIN; segcount <<= 1 ) {
+
+		nodesperseg = max( dirs_nondirs_cnt / segcount, NODESPERSEG_MIN );
+
+		/* nodesperseg must be a power of 2 */
+		for ( segixshift = 0;
+		      ( 1ULL << segixshift ) < nodesperseg;
+		      segixshift++ );
 
-	minsegsz = pgsz * nodesz;	/* must be pgsz and nodesz multiple */
-	winmap_mem = min(vmsz, segtablesz);
-	segsz = (((winmap_mem / WINMAP_MAX) + minsegsz - 1) / minsegsz) * minsegsz;
-	segsz = max(segsz, minsegsz);
+		/* rounding up to a power of 2 may have caused overflow */
+		if ( ( 1ULL << segixshift ) > NIX_MAX )
+			segixshift--;
 
-	nodesperseg = segsz / nodesz;
+		nodesperseg = 1UL << segixshift;
 
-	winmapmax = min(WINMAP_MAX, vmsz / segsz);
-	winmapmax = max(winmapmax, WINMAP_MIN);
+		max_segments = 1UL << ( NBBY * sizeof(nh_t) - segixshift );
+
+		segsz = nodesperseg * nodesz;
+
+		/* max number of segments that will fit in virtual memory,
+		 * capped at the max possible number of segments
+		 */
+		winmapmax = min( vmsz / segsz, max_segments );
+	}
 
 	/* map the abstraction header
 	 */
@@ -272,7 +304,6 @@ node_init( intgen_t fd,
 	node_hdrp->nh_nodesz = nodesz;
 	node_hdrp->nh_nodehkix = nodehkix;
 	node_hdrp->nh_segsz = segsz;
-	node_hdrp->nh_segtblsz = segtablesz;
 	node_hdrp->nh_winmapmax = winmapmax;
 	node_hdrp->nh_nodesperseg = nodesperseg;
 	node_hdrp->nh_nodealignsz = nodealignsz;
@@ -309,7 +340,6 @@ node_init( intgen_t fd,
 	win_init( fd,
 		  node_hdrp->nh_firstsegoff,
 		  segsz,
-		  segtablesz,
 		  winmapmax );
 	
 	/* announce the results
@@ -317,14 +347,12 @@ node_init( intgen_t fd,
 	mlog( MLOG_DEBUG | MLOG_TREE,
 	      "node_init:"
 	      " vmsz = %llu (0x%llx)"
-	      " segsz = %u (0x%x)"
-	      " segtblsz = %llu (0x%llx)"
+	      " segsz = %llu (0x%llx)"
 	      " nodesperseg = %u (0x%x)"
-	      " winmapmax = %llu (0x%llx)"
+	      " winmapmax = %lu (0x%lx)"
 	      "\n",
 	      vmsz, vmsz,
 	      segsz, segsz,
-	      segtablesz, segtablesz,
 	      nodesperseg, nodesperseg,
 	      winmapmax, winmapmax );
 
@@ -364,7 +392,6 @@ node_sync( intgen_t fd, off64_t off )
 	win_init( fd,
 		  node_hdrp->nh_firstsegoff,
 		  node_hdrp->nh_segsz,
-		  node_hdrp->nh_segtblsz,
 		  node_hdrp->nh_winmapmax );
 
 	return BOOL_TRUE;
Index: xfsdump-kernel.org/restore/win.c
===================================================================
--- xfsdump-kernel.org.orig/restore/win.c
+++ xfsdump-kernel.org/restore/win.c
@@ -80,7 +80,7 @@ struct tran {
 	off64_t t_firstoff;
 		/* offset of first seg within backing store (for mmap( ))
 		 */
-	size_t t_segsz;
+	size64_t t_segsz;
 		/* backing store segment / window size
 		 */
 	size_t t_winmax;
@@ -147,8 +147,7 @@ win_getnum_mmaps(void)
 void
 win_init( intgen_t fd,
 	  off64_t firstoff,
-	  size_t segsz,
-	  size64_t segtablesz,
+	  size64_t segsz,
 	  size_t winmax )
 {
 	/* validate parameters
@@ -167,7 +166,7 @@ win_init( intgen_t fd,
 	tranp->t_segsz = segsz;
 	tranp->t_winmax = winmax;
 
-	tranp->t_segmaplen = (size_t)(segtablesz / segsz) + 1;
+	tranp->t_segmaplen = SEGMAP_INCR;
 	tranp->t_segmap = (win_t **)
 	calloc( tranp->t_segmaplen, sizeof(win_t *) );
 	ASSERT( tranp->t_segmap );
Index: xfsdump-kernel.org/restore/win.h
===================================================================
--- xfsdump-kernel.org.orig/restore/win.h
+++ xfsdump-kernel.org/restore/win.h
@@ -25,8 +25,7 @@
  */
 void win_init( intgen_t fd,
 	       off64_t rngoff,		/* offset into file of windowing */
-	       size_t winsz,		/* window size */
-	       size64_t segtablesz,     /* estimate of segment table size */
+	       size64_t winsz,		/* window size */
 	       size_t wincntmax );	/* max number of windows to manage */
 
 /* supply a pointer to the portion of the file identified by off.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
