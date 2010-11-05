Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA5GZMdC209042 for <xfs@oss.sgi.com>; Fri, 5 Nov 2010 11:35:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17156AC012
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 09:36:47 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id BB0037006203
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 11:36:44 -0500 (CDT)
Message-Id: <20101105163644.563280731@sgi.com>
Date: Fri, 05 Nov 2010 11:35:08 -0500
From: wkendall@sgi.com
Subject: [PATCH v2 8/9] xfsrestore: remove nix_t
References: <20101105163500.747192954@sgi.com>
Content-Disposition: inline; filename=nuke_nix
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

The nix_t type is a 64-bit version of a (32-bit) nh_t, created "to
facilitate conversion to a 64-bit offset." At this point there's only
one case where an nh_t is converted to an off64_t, so just do an
explicit cast in that case and remove the nix_t.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 restore/node.c |  112 ++++++++++++++++++++++-----------------------------------
 1 file changed, 44 insertions(+), 68 deletions(-)

Index: xfsdump-kernel.org/restore/node.c
===================================================================
--- xfsdump-kernel.org.orig/restore/node.c
+++ xfsdump-kernel.org/restore/node.c
@@ -50,22 +50,21 @@ extern size_t pgmask;
 #define	HDLGENSHIFT		( NBBY * sizeof ( nh_t ) - HDLGENCNT )
 #define	HDLGENLOMASK		( ( 1 << HDLGENCNT ) - 1 )
 #define	HDLGENMASK		( HDLGENLOMASK << HDLGENSHIFT )
-#define HDLNIXCNT		HDLGENSHIFT
-#define HDLNIXMASK		( ( 1 << HDLNIXCNT ) - 1 )
+#define HDLMASK			( ( 1 << HDLGENSHIFT ) - 1 )
 #define HDLGETGEN( h )		( ( u_char_t )				\
 				  ( ( ( int )h >> HDLGENSHIFT )		\
 				    &					\
 				    HDLGENLOMASK ))
-#define HDLGETNIX( h )		( ( nix_t )( ( int )h & HDLNIXMASK ))
+#define HDLGETNHDL( h )		( ( nh_t )( ( int )h & HDLMASK ))
 #define HDLMKHDL( g, n )	( ( nh_t )( ( ( ( int )g << HDLGENSHIFT )\
 					      &				\
 					      HDLGENMASK )		\
 					  |				\
-					  ( ( int )n & HDLNIXMASK )))
-#define NIX_MAX			( ( off64_t )HDLNIXMASK )
+					  ( ( int )n & HDLMASK )))
+#define NH_MAX			( HDLMASK )
 
 /* the housekeeping byte of each node will hold two check fields:
- * a gen count, initialized to the node ix and incremented each time a node
+ * a gen count, initialized to 0 and incremented each time a node
  * is allocated, to catch re-use of stale handles; and unique pattern, to
  * differentiate a valid node from random memory. two unique patterns will
  * be used; one when the node is on the free list, another when it is
@@ -97,7 +96,7 @@ extern size_t pgmask;
 
 #else /* NODECHK */
 
-#define NIX_MAX			( NH_NULL - 1 )
+#define NH_MAX			( NH_NULL - 1 )
 
 #endif /* NODECHK */
 
@@ -106,16 +105,6 @@ extern size_t pgmask;
 #define NODESPERSEG_MIN	1048576
 #define WINMAP_MIN	4
 
-/* a node is identified internally by its index into the backing store.
- * this index is the offset of the node into the segmented portion of
- * backing store (follows the abstraction header page) divided by the
- * size of a node. a special index is reserved to represent the null
- * index. a type is defined for node index (nix_t). it is a 64 bit
- * unsigned to facilitate conversion from index to 64 bit offset.
- */
-typedef off64_t nix_t;
-#define NIX_NULL OFF64MAX
-
 /* reserve the firstpage for a header to save persistent context
  */
 #define NODE_HDRSZ	pgsz
@@ -142,15 +131,14 @@ struct node_hdr {
 	size_t nh_nodealignsz;
 		/* user's constraint on node alignment
 		 */
-	nix_t nh_freenix;
-		/* index into backing store of first node of singly-linked
-		 * list of free nodes
+	nh_t nh_freenh;
+		/* handle of first node of singly-linked list of free nodes
 		 */
 	off64_t nh_firstsegoff;
 		/* offset into backing store of the first segment
 		 */
-	nh_t nh_virgnix;
-		/* node handle of next virgin node
+	nh_t nh_virgnh;
+		/* handle of next virgin node
 		 */
 	intgen_t nh_segixshift;
 		/* bitshift used to extract the segment index from an nh_t
@@ -248,10 +236,10 @@ node_init( intgen_t fd,
 	 * dirs_nondirs_cnt may be less than the number of nodes/dirents).
 	 * Checking this here prevents potential overflow in the logic below.
 	 */
-	if ( dirs_nondirs_cnt > NIX_MAX ) {
+	if ( dirs_nondirs_cnt > NH_MAX ) {
 		mlog( MLOG_NORMAL | MLOG_ERROR, _(
-		  "dump contains %llu inodes, restore can only handle %llu\n"),
-		  dirs_nondirs_cnt, NIX_MAX );
+		  "dump contains %llu inodes, restore can only handle %u\n"),
+		  dirs_nondirs_cnt, NH_MAX );
 		return BOOL_FALSE;
 	}
 
@@ -265,7 +253,7 @@ node_init( intgen_t fd,
 		      segixshift++ );
 
 		/* rounding up to a power of 2 may have caused overflow */
-		if ( ( 1ULL << segixshift ) > NIX_MAX )
+		if ( ( 1ULL << segixshift ) > NH_MAX )
 			segixshift--;
 
 		nodesperseg = 1UL << segixshift;
@@ -308,9 +296,9 @@ node_init( intgen_t fd,
 	node_hdrp->nh_winmapmax = winmapmax;
 	node_hdrp->nh_nodesperseg = nodesperseg;
 	node_hdrp->nh_nodealignsz = nodealignsz;
-	node_hdrp->nh_freenix = NIX_NULL;
+	node_hdrp->nh_freenh = NH_NULL;
 	node_hdrp->nh_firstsegoff = off + ( off64_t )NODE_HDRSZ;
-	node_hdrp->nh_virgnix = 0;
+	node_hdrp->nh_virgnh = 0;
 	node_hdrp->nh_segixshift = segixshift;
 	node_hdrp->nh_relnixmask = relnixmask;
 
@@ -383,7 +371,6 @@ node_sync( intgen_t fd, off64_t off )
 nh_t
 node_alloc( void )
 {
-	nix_t nix;
 	u_char_t *p;
 	nh_t nh;
 #ifdef NODECHK
@@ -396,12 +383,12 @@ node_alloc( void )
 	 * otherwise get the next one from the current virgin segment,
 	 * or allocate a new virgin segment if the current one is depleted.
 	 */
-	if ( node_hdrp->nh_freenix != NIX_NULL ) {
-		nix_t *linkagep;
+	if ( node_hdrp->nh_freenh != NH_NULL ) {
+		nh_t *linkagep;
 
-		nix = node_hdrp->nh_freenix;
+		nh = node_hdrp->nh_freenh;
 
-		node_map_internal( nix, ( void ** )&p );
+		node_map_internal( nh, ( void ** )&p );
 		if (p == NULL)
 			return NH_NULL;
 #ifdef NODECHK
@@ -413,18 +400,18 @@ node_alloc( void )
 #endif /* NODECHK */
 
 		/* adjust the free list */
-		linkagep = ( nix_t * )p;
-		node_hdrp->nh_freenix = *linkagep;
+		linkagep = ( nh_t * )p;
+		node_hdrp->nh_freenh = *linkagep;
 
-		node_unmap_internal( nix, ( void ** )&p, BOOL_TRUE );
+		node_unmap_internal( nh, ( void ** )&p, BOOL_TRUE );
 
 	} else {
-		if ( nh2relnix( node_hdrp->nh_virgnix ) == 0 ) {
+		if ( nh2relnix( node_hdrp->nh_virgnh ) == 0 ) {
 			/* need to start a new virgin segment */
 			intgen_t rval;
 			off64_t new_seg_off =
 				node_hdrp->nh_firstsegoff +
-				( off64_t )nh2segix( node_hdrp->nh_virgnix ) *
+				( off64_t )nh2segix( node_hdrp->nh_virgnh ) *
 				( off64_t )node_hdrp->nh_segsz;
 
 			ASSERT( new_seg_off
@@ -443,34 +430,32 @@ node_alloc( void )
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 				      "unable to autogrow node segment %lu: "
 				      "%s (%d)\n"),
-				      nh2segix( node_hdrp->nh_virgnix ),
+				      nh2segix( node_hdrp->nh_virgnh ),
 				      strerror( errno ),
 				      errno );
 			}
 		}
 
-		nix = node_hdrp->nh_virgnix++;
+		nh = node_hdrp->nh_virgnh++;
 	}
 
 	/* build a handle for node
 	 */
-	if ( nix > NIX_MAX ) {
+	if ( nh > NH_MAX ) {
 		mlog( MLOG_NORMAL | MLOG_ERROR, _(
 		  "dump contains too many dirents, "
 		  "restore can only handle %llu\n"),
-		  NIX_MAX );
+		  NH_MAX );
 		return NH_NULL;
 	}
 #ifdef NODECHK
-	node_map_internal( nix , ( void ** )&p );
+	node_map_internal( nh , ( void ** )&p );
 	if (p == NULL)
 		abort();
 	hkpp = p + ( int )node_hdrp->nh_nodehkix;
-	nh = HDLMKHDL( gen, nix );
+	nh = HDLMKHDL( gen, nh );
 	*hkpp = HKPMKHKP( gen, NODEUNQALCD );
-	node_unmap_internal( nix, ( void ** )&p, BOOL_FALSE );
-#else /* NODECHK */
-	nh = ( nh_t )nix;
+	node_unmap_internal( nh, ( void ** )&p, BOOL_FALSE );
 #endif /* NODECHK */
 
 	return nh;
@@ -503,7 +488,6 @@ node_map_internal( nh_t nh, void **pp )
 void *
 node_map( nh_t nh )
 {
-	nix_t nix;
 	u_char_t *p;
 #ifdef NODECHK
 	register u_char_t hkp;
@@ -518,17 +502,15 @@ node_map( nh_t nh )
 	 */
 #ifdef NODECHK
 	hdlgen = HDLGETGEN( nh );
-	nix = HDLGETNIX( nh );
-#else /* NODECHK */
-	nix = ( nix_t )nh;
+	nh = HDLGETNHDL( nh );
 #endif /* NODECHK */
 
-	ASSERT( nix <= NIX_MAX );
+	ASSERT( nh <= NH_MAX );
 
 	/* map in
 	 */
 	p = 0; /* keep lint happy */
-	node_map_internal( nix, ( void ** )&p );
+	node_map_internal( nh, ( void ** )&p );
 	if (p == NULL)
 	    return NULL;
 
@@ -548,7 +530,6 @@ node_map( nh_t nh )
 static inline void
 node_unmap_internal( nh_t nh, void **pp, bool_t freepr )
 {
-	nix_t nix;
 #ifdef NODECHK
 	register u_char_t hkp;
 	register u_char_t hdlgen;
@@ -564,12 +545,10 @@ node_unmap_internal( nh_t nh, void **pp,
 	 */
 #ifdef NODECHK
 	hdlgen = HDLGETGEN( nh );
-	nix = HDLGETNIX( nh );
-#else /* NODECHK */
-	nix = ( nix_t )nh;
+	nh = HDLGETNHDL( nh );
 #endif /* NODECHK */
 
-	ASSERT( nix <= NIX_MAX );
+	ASSERT( nh <= NH_MAX );
 
 #ifdef NODECHK
 	hkp = *( *( u_char_t ** )pp + node_hdrp->nh_nodehkix );
@@ -587,7 +566,7 @@ node_unmap_internal( nh_t nh, void **pp,
 
 	/* unmap the window containing the node
 	 */
-	win_unmap( nh2segix( nix ), pp ); /* zeros *pp */
+	win_unmap( nh2segix( nh ), pp ); /* zeros *pp */
 }
 
 void
@@ -600,9 +579,8 @@ void
 node_free( nh_t *nhp )
 {
 	nh_t nh;
-	nix_t nix;
 	u_char_t *p;
-	register nix_t *linkagep;
+	register nh_t *linkagep;
 #ifdef NODECHK
 	register u_char_t *hkpp;
 	register u_char_t hdlgen;
@@ -618,12 +596,10 @@ node_free( nh_t *nhp )
 	 */
 #ifdef NODECHK
 	hdlgen = HDLGETGEN( nh );
-	nix = HDLGETNIX( nh );
-#else /* NODECHK */
-	nix = ( nix_t )nh;
+	nh = HDLGETNHDL( nh );
 #endif /* NODECHK */
 
-	ASSERT( nix <= NIX_MAX );
+	ASSERT( nh <= NH_MAX );
 
 	/* map in
 	 */
@@ -647,9 +623,9 @@ node_free( nh_t *nhp )
 
 	/* put node on free list
 	 */
-	linkagep = ( nix_t * )p;
-	*linkagep = node_hdrp->nh_freenix;
-	node_hdrp->nh_freenix = nix;
+	linkagep = ( nh_t * )p;
+	*linkagep = node_hdrp->nh_freenh;
+	node_hdrp->nh_freenh = nh;
 
 	/* map out
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
