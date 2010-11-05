Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA5GZLqZ209005 for <xfs@oss.sgi.com>; Fri, 5 Nov 2010 11:35:21 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8E7C30408F
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 09:36:46 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 8E4B97006202
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 11:36:44 -0500 (CDT)
Message-Id: <20101105163644.371326494@sgi.com>
Date: Fri, 05 Nov 2010 11:35:07 -0500
From: wkendall@sgi.com
Subject: [PATCH v2 7/9] xfsrestore: make node lookup more efficient
References: <20101105163500.747192954@sgi.com>
Content-Disposition: inline; filename=window_lookup_performance
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

When converting an nh_t to a segment index and relative node index,
use shift and bitwise-and instead of division and modulo. Results show
this is about 50% faster than the current method.


Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 restore/node.c |  150 ++++++++++++++++++++++++++++-----------------------------
 restore/win.c  |   36 +++----------
 restore/win.h  |    6 +-
 3 files changed, 87 insertions(+), 105 deletions(-)

Index: xfsdump-kernel.org/restore/node.c
===================================================================
--- xfsdump-kernel.org.orig/restore/node.c
+++ xfsdump-kernel.org/restore/node.c
@@ -115,8 +115,6 @@ extern size_t pgmask;
  */
 typedef off64_t nix_t;
 #define NIX_NULL OFF64MAX
-#define NIX2OFF( nix )	( nix * ( nix_t )node_hdrp->nh_nodesz )
-#define OFF2NIX( noff )	( noff / ( nix_t )node_hdrp->nh_nodesz )
 
 /* reserve the firstpage for a header to save persistent context
  */
@@ -151,20 +149,15 @@ struct node_hdr {
 	off64_t nh_firstsegoff;
 		/* offset into backing store of the first segment
 		 */
-	off64_t nh_virgsegreloff;
-		/* offset (relative to beginning of first segment) into
-		 * backing store of segment containing one or
-		 * more virgin nodes. relative to beginning of segmented
-		 * portion of backing store. bumped only when all of the
-		 * nodes in the segment have been placed on the free list.
-		 * when bumped, nh_virginrelnix is simultaneously set back
-		 * to zero.
-		 */
-	nix_t nh_virgrelnix;
-		/* relative node index within the segment identified by
-		 * nh_virgsegreloff of the next node not yet placed on the
-		 * free list. never reaches nh_nodesperseg: instead set
-		 * to zero and bump nh_virgsegreloff by one segment.
+	nh_t nh_virgnix;
+		/* node handle of next virgin node
+		 */
+	intgen_t nh_segixshift;
+		/* bitshift used to extract the segment index from an nh_t
+		 */
+	nh_t nh_relnixmask;
+		/* bitmask used to extract the node index from an nh_t
+		 * (relative to the start of a segment)
 		 */
 };
 
@@ -173,6 +166,12 @@ typedef struct node_hdr node_hdr_t;
 static node_hdr_t *node_hdrp;
 static intgen_t node_fd;
 
+/* forward declarations of locally defined static functions ******************/
+static inline size_t nh2segix( nh_t nh );
+static inline nh_t nh2relnix( nh_t nh );
+static inline void node_map_internal( nh_t nh, void **pp );
+static inline void node_unmap_internal( nh_t nh, void **pp, bool_t freepr );
+
 /* ARGSUSED */
 bool_t
 node_init( intgen_t fd,
@@ -190,7 +189,7 @@ node_init( intgen_t fd,
 	size_t winmapmax;
 	size_t segcount;
 	intgen_t segixshift;
-	intgen_t rval;
+	nh_t relnixmask;
 
 	/* sanity checks
 	 */
@@ -281,6 +280,8 @@ node_init( intgen_t fd,
 		winmapmax = min( vmsz / segsz, max_segments );
 	}
 
+	relnixmask = nodesperseg - 1;
+
 	/* map the abstraction header
 	 */
 	ASSERT( ( NODE_HDRSZ & pgmask ) == 0 );
@@ -309,32 +310,14 @@ node_init( intgen_t fd,
 	node_hdrp->nh_nodealignsz = nodealignsz;
 	node_hdrp->nh_freenix = NIX_NULL;
 	node_hdrp->nh_firstsegoff = off + ( off64_t )NODE_HDRSZ;
-	node_hdrp->nh_virgsegreloff = 0;
-	node_hdrp->nh_virgrelnix = 0;
+	node_hdrp->nh_virgnix = 0;
+	node_hdrp->nh_segixshift = segixshift;
+	node_hdrp->nh_relnixmask = relnixmask;
 
 	/* save transient context
 	 */
 	node_fd = fd;
 
-	/* autogrow the first segment
-	 */
-	mlog( MLOG_DEBUG,
-	      "pre-growing new node array segment at %lld "
-	      "size %lld\n",
-	      node_hdrp->nh_firstsegoff,
-	      ( off64_t )node_hdrp->nh_segsz );
-	rval = ftruncate64( node_fd,
-			    node_hdrp->nh_firstsegoff
-			    +
-			    ( off64_t )node_hdrp->nh_segsz );
-	if ( rval ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
-		      "unable to autogrow first node segment: %s (%d)\n"),
-		      strerror( errno ),
-		      errno );
-		return BOOL_FALSE;
-	}
-
 	/* initialize the window abstraction
 	 */
 	win_init( fd,
@@ -415,12 +398,10 @@ node_alloc( void )
 	 */
 	if ( node_hdrp->nh_freenix != NIX_NULL ) {
 		nix_t *linkagep;
-		off64_t off;
 
 		nix = node_hdrp->nh_freenix;
 
-		off = NIX2OFF( nix );
-		win_map( off, ( void ** )&p );
+		node_map_internal( nix, ( void ** )&p );
 		if (p == NULL)
 			return NH_NULL;
 #ifdef NODECHK
@@ -435,66 +416,59 @@ node_alloc( void )
 		linkagep = ( nix_t * )p;
 		node_hdrp->nh_freenix = *linkagep;
 
-		win_unmap( off, ( void ** )&p );
+		node_unmap_internal( nix, ( void ** )&p, BOOL_TRUE );
 
 	} else {
-		if ( node_hdrp->nh_virgrelnix
-		     >=
-		     ( nix_t )node_hdrp->nh_nodesperseg ) {
+		if ( nh2relnix( node_hdrp->nh_virgnix ) == 0 ) {
+			/* need to start a new virgin segment */
 			intgen_t rval;
-			ASSERT( node_hdrp->nh_virgrelnix
-				==
-				( nix_t )node_hdrp->nh_nodesperseg );
-			ASSERT( node_hdrp->nh_virgsegreloff
+			off64_t new_seg_off =
+				node_hdrp->nh_firstsegoff +
+				( off64_t )nh2segix( node_hdrp->nh_virgnix ) *
+				( off64_t )node_hdrp->nh_segsz;
+
+			ASSERT( new_seg_off
 				<=
 				OFF64MAX - ( off64_t )node_hdrp->nh_segsz );
-#ifdef TREE_DEBUG
-			mlog(MLOG_DEBUG | MLOG_TREE,
-			    "node_alloc(): runout of nodes for freelist in "
-                            "this segment - nodes used = %lld\n", 
-                            node_hdrp->nh_virgrelnix);
-#endif
-			node_hdrp->nh_virgsegreloff +=
-					( off64_t )node_hdrp->nh_segsz;
-			node_hdrp->nh_virgrelnix = 0;
 			mlog( MLOG_DEBUG,
 			      "pre-growing new node array segment at %lld "
 			      "size %lld\n",
-			      node_hdrp->nh_firstsegoff +
-			      node_hdrp->nh_virgsegreloff,
+			      new_seg_off,
 			      ( off64_t )node_hdrp->nh_segsz );
 			rval = ftruncate64( node_fd,
-					    node_hdrp->nh_firstsegoff
-					    +
-					    node_hdrp->nh_virgsegreloff
+					    new_seg_off
 					    +
 					    ( off64_t )node_hdrp->nh_segsz );
 			if ( rval ) {
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
-				      "unable to autogrow node segment %llu: "
+				      "unable to autogrow node segment %lu: "
 				      "%s (%d)\n"),
-				      OFF2NIX(node_hdrp->nh_virgsegreloff),
+				      nh2segix( node_hdrp->nh_virgnix ),
 				      strerror( errno ),
 				      errno );
 			}
 		}
 
-		nix = OFF2NIX( node_hdrp->nh_virgsegreloff )
-			+
-			node_hdrp->nh_virgrelnix++;
+		nix = node_hdrp->nh_virgnix++;
 	}
 
 	/* build a handle for node
 	 */
-	ASSERT( nix <= NIX_MAX );
+	if ( nix > NIX_MAX ) {
+		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		  "dump contains too many dirents, "
+		  "restore can only handle %llu\n"),
+		  NIX_MAX );
+		return NH_NULL;
+	}
 #ifdef NODECHK
-	win_map( NIX2OFF( nix ), ( void ** )&p );
+	node_map_internal( nix , ( void ** )&p );
 	if (p == NULL)
 		abort();
 	hkpp = p + ( int )node_hdrp->nh_nodehkix;
 	nh = HDLMKHDL( gen, nix );
 	*hkpp = HKPMKHKP( gen, NODEUNQALCD );
-	win_unmap( NIX2OFF( nix ), ( void ** )&p );
+	node_unmap_internal( nix, ( void ** )&p, BOOL_FALSE );
 #else /* NODECHK */
 	nh = ( nh_t )nix;
 #endif /* NODECHK */
@@ -502,6 +476,30 @@ node_alloc( void )
 	return nh;
 }
 
+static inline size_t
+nh2segix( nh_t nh )
+{
+	return nh >> node_hdrp->nh_segixshift;
+}
+
+static inline nh_t
+nh2relnix( nh_t nh )
+{
+	return nh & node_hdrp->nh_relnixmask;
+}
+
+static inline void
+node_map_internal( nh_t nh, void **pp )
+{
+	win_map( nh2segix( nh ), pp );
+	if ( *pp != NULL ) {
+		nh_t relnix = nh2relnix( nh );
+		*pp = ( void * )( ( char * )( *pp ) +
+				( ( off64_t )relnix *
+				  node_hdrp->nh_nodesz ) );
+	}
+}
+
 void *
 node_map( nh_t nh )
 {
@@ -530,7 +528,7 @@ node_map( nh_t nh )
 	/* map in
 	 */
 	p = 0; /* keep lint happy */
-	win_map( NIX2OFF( nix ), ( void ** )&p );
+	node_map_internal( nix, ( void ** )&p );
 	if (p == NULL)
 	    return NULL;
 
@@ -547,8 +545,8 @@ node_map( nh_t nh )
 }
 
 /* ARGSUSED */
-static void
-node_unmap_internal( nh_t nh, void **pp, bool_t internalpr )
+static inline void
+node_unmap_internal( nh_t nh, void **pp, bool_t freepr )
 {
 	nix_t nix;
 #ifdef NODECHK
@@ -578,7 +576,7 @@ node_unmap_internal( nh_t nh, void **pp,
 	nodegen = HKPGETGEN( hkp );
 	ASSERT( nodegen == hdlgen );
 	nodeunq = HKPGETUNQ( hkp );
-	if ( ! internalpr ) {
+	if ( ! freepr ) {
 		ASSERT( nodeunq != NODEUNQFREE );
 		ASSERT( nodeunq == NODEUNQALCD );
 	} else {
@@ -589,7 +587,7 @@ node_unmap_internal( nh_t nh, void **pp,
 
 	/* unmap the window containing the node
 	 */
-	win_unmap( NIX2OFF( nix ), pp ); /* zeros *pp */
+	win_unmap( nh2segix( nix ), pp ); /* zeros *pp */
 }
 
 void
Index: xfsdump-kernel.org/restore/win.c
===================================================================
--- xfsdump-kernel.org.orig/restore/win.c
+++ xfsdump-kernel.org/restore/win.c
@@ -177,31 +177,16 @@ win_init( intgen_t fd,
 }
 
 void
-win_map( off64_t off, void **pp )
+win_map( size_t segix, void **pp )
 {
-	size_t offwithinseg;
-	size_t segix;
 	off64_t segoff;
 	win_t *winp;
 
 	CRITICAL_BEGIN();
 
-	/* calculate offset within segment
-	 */
-	offwithinseg = ( size_t )( off % ( off64_t )tranp->t_segsz );
-
-	/* calculate segment index
-	 */
-	segix = (size_t)( off / ( off64_t )tranp->t_segsz );
-
-	/* calculate offset of segment
-	 */
-	segoff = off - ( off64_t )offwithinseg;
-
 #ifdef TREE_DEBUG
 	mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
-	     "win_map(off=%lld,addr=%x): off within = %llu, segoff = %lld\n",
-	      off, pp, offwithinseg, segoff);
+	     "win_map(segix=%lu,addr=%p)\n", segix, pp);
 #endif
 	/* resize the array if necessary */
 	if ( segix >= tranp->t_segmaplen )
@@ -243,7 +228,7 @@ win_map( off64_t off, void **pp )
 			ASSERT( ! winp->w_nextp );
 		}
 		winp->w_refcnt++;
-		*pp = ( void * )( ( char * )( winp->w_p ) + offwithinseg );
+		*pp = winp->w_p;
 		CRITICAL_END();
 		return;
 	}
@@ -287,6 +272,10 @@ win_map( off64_t off, void **pp )
 		return;
 	}
 
+	/* calculate offset of segment
+	 */
+	segoff = segix * ( off64_t )tranp->t_segsz;
+
 	/* map the window
 	 */
 	ASSERT( tranp->t_segsz >= 1 );
@@ -320,7 +309,7 @@ win_map( off64_t off, void **pp )
 		if (error == ENOMEM && tranp->t_lruheadp) {
 			mlog( MLOG_NORMAL | MLOG_ERROR,
 		      		_("win_map(): try to select a different win_t\n"));
-			win_map(off, pp);
+			win_map(segix, pp);
 			return;
 		}
 		*pp = NULL;
@@ -331,23 +320,18 @@ win_map( off64_t off, void **pp )
 	winp->w_refcnt++;
 	tranp->t_segmap[winp->w_segix] = winp;
 
-	*pp = ( void * )( ( char * )( winp->w_p ) + offwithinseg );
+	*pp = winp->w_p;
 
 	CRITICAL_END();
 }
 
 void
-win_unmap( off64_t off, void **pp )
+win_unmap( size_t segix, void **pp )
 {
-	size_t segix;
 	win_t *winp;
 
 	CRITICAL_BEGIN();
 
-	/* calculate segment index
-	 */
-	segix = (size_t)( off / ( off64_t )tranp->t_segsz );
-
 	/* verify window mapped
 	 */
 	ASSERT( segix < tranp->t_segmaplen );
Index: xfsdump-kernel.org/restore/win.h
===================================================================
--- xfsdump-kernel.org.orig/restore/win.h
+++ xfsdump-kernel.org/restore/win.h
@@ -28,15 +28,15 @@ void win_init( intgen_t fd,
 	       size64_t winsz,		/* window size */
 	       size_t wincntmax );	/* max number of windows to manage */
 
-/* supply a pointer to the portion of the file identified by off.
+/* supply a pointer to the portion of the file identified by segix.
  */
-void win_map( off64_t off,		/* file offset relative to rngoff */
+void win_map( size_t segix,		/* segment index to be mapped */
 	      void **pp );		/* returns pointer by reference */
 
 /* invalidate the pointer previously supplied. SIDE-EFFECT: zeros
  * by reference the caller's pointer.
  */
-void win_unmap( off64_t off,		/* must match win_map param */
+void win_unmap( size_t segix,		/* must match win_map param */
 	        void **pp );		/* ptr generated by win_map: ZEROED */
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
