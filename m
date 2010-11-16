Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGF5WbC069883 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 09:05:32 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6080F8F80BA
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 07:07:05 -0800 (PST)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 3A3E370017CC
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 09:07:05 -0600 (CST)
Message-Id: <20101116150705.030079100@sgi.com>
Date: Tue, 16 Nov 2010 09:05:09 -0600
From: wkendall@sgi.com
Subject: [PATCH v3 7/9] xfsrestore: make node lookup more efficient
References: <20101116150502.179825893@sgi.com>
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
 restore/node.c |  229 +++++++++++++++++++++++++++------------------------------
 restore/win.c  |   43 +++-------
 restore/win.h  |    8 +
 3 files changed, 130 insertions(+), 150 deletions(-)

Index: xfsdump-kernel.org/restore/node.c
===================================================================
--- xfsdump-kernel.org.orig/restore/node.c
+++ xfsdump-kernel.org/restore/node.c
@@ -115,13 +115,13 @@ extern size_t pgmask;
  */
 typedef off64_t nix_t;
 #define NIX_NULL OFF64MAX
-#define NIX2OFF( nix )	( nix * ( nix_t )node_hdrp->nh_nodesz )
-#define OFF2NIX( noff )	( noff / ( nix_t )node_hdrp->nh_nodesz )
 
 /* reserve the firstpage for a header to save persistent context
  */
 #define NODE_HDRSZ	pgsz
 
+typedef intgen_t relnix_t;
+
 struct node_hdr {
 	size_t nh_nodesz;
 		/* internal node size - user may see something smaller
@@ -151,20 +151,15 @@ struct node_hdr {
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
+	relnix_t nh_relnixmask;
+		/* bitmask used to extract the node index from an nh_t
+		 * (relative to the start of a segment)
 		 */
 };
 
@@ -173,6 +168,76 @@ typedef struct node_hdr node_hdr_t;
 static node_hdr_t *node_hdrp;
 static intgen_t node_fd;
 
+static inline segix_t
+nh2segix( nh_t nh )
+{
+	return nh >> node_hdrp->nh_segixshift;
+}
+
+static inline relnix_t
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
+		relnix_t relnix = nh2relnix( nh );
+		*pp = ( void * )( ( char * )( *pp ) +
+				( ( off64_t )relnix *
+				  node_hdrp->nh_nodesz ) );
+	}
+}
+
+/* ARGSUSED */
+static inline void
+node_unmap_internal( nh_t nh, void **pp, bool_t freepr )
+{
+	nix_t nix;
+#ifdef NODECHK
+	register u_char_t hkp;
+	register u_char_t hdlgen;
+	register u_char_t nodegen;
+	register u_char_t nodeunq;
+#endif /* NODECHK */
+
+	ASSERT( pp );
+	ASSERT( *pp );
+	ASSERT( nh != NH_NULL );
+
+	/* convert the handle into an index
+	 */
+#ifdef NODECHK
+	hdlgen = HDLGETGEN( nh );
+	nix = HDLGETNIX( nh );
+#else /* NODECHK */
+	nix = ( nix_t )nh;
+#endif /* NODECHK */
+
+	ASSERT( nix <= NIX_MAX );
+
+#ifdef NODECHK
+	hkp = *( *( u_char_t ** )pp + node_hdrp->nh_nodehkix );
+	nodegen = HKPGETGEN( hkp );
+	ASSERT( nodegen == hdlgen );
+	nodeunq = HKPGETUNQ( hkp );
+	if ( ! freepr ) {
+		ASSERT( nodeunq != NODEUNQFREE );
+		ASSERT( nodeunq == NODEUNQALCD );
+	} else {
+		ASSERT( nodeunq != NODEUNQALCD );
+		ASSERT( nodeunq == NODEUNQFREE );
+	}
+#endif /* NODECHK */
+
+	/* unmap the window containing the node
+	 */
+	win_unmap( nh2segix( nix ), pp ); /* zeros *pp */
+}
+
 /* ARGSUSED */
 bool_t
 node_init( intgen_t fd,
@@ -190,12 +255,13 @@ node_init( intgen_t fd,
 	size_t winmapmax;
 	size_t segcount;
 	intgen_t segixshift;
-	intgen_t rval;
 
 	/* sanity checks
 	 */
 	ASSERT( sizeof( node_hdr_t ) <= NODE_HDRSZ );
 	ASSERT( sizeof( nh_t ) < sizeof( off64_t ));
+	ASSERT( sizeof( nh_t ) <= sizeof( segix_t ));
+	ASSERT( sizeof( nh_t ) <= sizeof( relnix_t ));
 	ASSERT( nodehkix < usrnodesz );
 	ASSERT( usrnodesz >= sizeof( char * ) + 1 );
 		/* so node is at least big enough to hold
@@ -309,32 +375,14 @@ node_init( intgen_t fd,
 	node_hdrp->nh_nodealignsz = nodealignsz;
 	node_hdrp->nh_freenix = NIX_NULL;
 	node_hdrp->nh_firstsegoff = off + ( off64_t )NODE_HDRSZ;
-	node_hdrp->nh_virgsegreloff = 0;
-	node_hdrp->nh_virgrelnix = 0;
+	node_hdrp->nh_virgnix = 0;
+	node_hdrp->nh_segixshift = segixshift;
+	node_hdrp->nh_relnixmask = nodesperseg - 1;
 
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
@@ -415,12 +463,10 @@ node_alloc( void )
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
@@ -435,66 +481,59 @@ node_alloc( void )
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
+				      "unable to autogrow node segment %u: "
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
@@ -530,7 +569,7 @@ node_map( nh_t nh )
 	/* map in
 	 */
 	p = 0; /* keep lint happy */
-	win_map( NIX2OFF( nix ), ( void ** )&p );
+	node_map_internal( nix, ( void ** )&p );
 	if (p == NULL)
 	    return NULL;
 
@@ -546,52 +585,6 @@ node_map( nh_t nh )
 	return ( void * )p;
 }
 
-/* ARGSUSED */
-static void
-node_unmap_internal( nh_t nh, void **pp, bool_t internalpr )
-{
-	nix_t nix;
-#ifdef NODECHK
-	register u_char_t hkp;
-	register u_char_t hdlgen;
-	register u_char_t nodegen;
-	register u_char_t nodeunq;
-#endif /* NODECHK */
-
-	ASSERT( pp );
-	ASSERT( *pp );
-	ASSERT( nh != NH_NULL );
-
-	/* convert the handle into an index
-	 */
-#ifdef NODECHK
-	hdlgen = HDLGETGEN( nh );
-	nix = HDLGETNIX( nh );
-#else /* NODECHK */
-	nix = ( nix_t )nh;
-#endif /* NODECHK */
-
-	ASSERT( nix <= NIX_MAX );
-
-#ifdef NODECHK
-	hkp = *( *( u_char_t ** )pp + node_hdrp->nh_nodehkix );
-	nodegen = HKPGETGEN( hkp );
-	ASSERT( nodegen == hdlgen );
-	nodeunq = HKPGETUNQ( hkp );
-	if ( ! internalpr ) {
-		ASSERT( nodeunq != NODEUNQFREE );
-		ASSERT( nodeunq == NODEUNQALCD );
-	} else {
-		ASSERT( nodeunq != NODEUNQALCD );
-		ASSERT( nodeunq == NODEUNQFREE );
-	}
-#endif /* NODECHK */
-
-	/* unmap the window containing the node
-	 */
-	win_unmap( NIX2OFF( nix ), pp ); /* zeros *pp */
-}
-
 void
 node_unmap( nh_t nh, void **pp )
 {
Index: xfsdump-kernel.org/restore/win.c
===================================================================
--- xfsdump-kernel.org.orig/restore/win.c
+++ xfsdump-kernel.org/restore/win.c
@@ -30,6 +30,7 @@
 #include "mlog.h"
 #include "qlock.h"
 #include "mmap.h"
+#include "win.h"
 
 extern size_t pgsz;
 extern size_t pgmask;
@@ -48,7 +49,7 @@ extern size_t pgmask;
 /* window descriptor
  */
 struct win {
-	size_t w_segix;
+	segix_t w_segix;
 		/* index of segment mapped by this window
 		 */
 	void *w_p;
@@ -69,7 +70,7 @@ typedef struct win win_t;
 
 /* forward declarations
  */
-static void win_segmap_resize( size_t segix );
+static void win_segmap_resize( segix_t segix );
 
 /* transient state
  */
@@ -177,31 +178,16 @@ win_init( intgen_t fd,
 }
 
 void
-win_map( off64_t off, void **pp )
+win_map( segix_t segix, void **pp )
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
+	     "win_map(segix=%u,addr=%p)\n", segix, pp);
 #endif
 	/* resize the array if necessary */
 	if ( segix >= tranp->t_segmaplen )
@@ -243,7 +229,7 @@ win_map( off64_t off, void **pp )
 			ASSERT( ! winp->w_nextp );
 		}
 		winp->w_refcnt++;
-		*pp = ( void * )( ( char * )( winp->w_p ) + offwithinseg );
+		*pp = winp->w_p;
 		CRITICAL_END();
 		return;
 	}
@@ -287,6 +273,10 @@ win_map( off64_t off, void **pp )
 		return;
 	}
 
+	/* calculate offset of segment
+	 */
+	segoff = segix * ( off64_t )tranp->t_segsz;
+
 	/* map the window
 	 */
 	ASSERT( tranp->t_segsz >= 1 );
@@ -320,7 +310,7 @@ win_map( off64_t off, void **pp )
 		if (error == ENOMEM && tranp->t_lruheadp) {
 			mlog( MLOG_NORMAL | MLOG_ERROR,
 		      		_("win_map(): try to select a different win_t\n"));
-			win_map(off, pp);
+			win_map(segix, pp);
 			return;
 		}
 		*pp = NULL;
@@ -331,23 +321,18 @@ win_map( off64_t off, void **pp )
 	winp->w_refcnt++;
 	tranp->t_segmap[winp->w_segix] = winp;
 
-	*pp = ( void * )( ( char * )( winp->w_p ) + offwithinseg );
+	*pp = winp->w_p;
 
 	CRITICAL_END();
 }
 
 void
-win_unmap( off64_t off, void **pp )
+win_unmap( segix_t segix, void **pp )
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
@@ -390,7 +375,7 @@ win_unmap( off64_t off, void **pp )
 }
 
 static void
-win_segmap_resize(size_t segix)
+win_segmap_resize(segix_t segix)
 {
 	size_t oldlen;
 	win_t **new_part;
Index: xfsdump-kernel.org/restore/win.h
===================================================================
--- xfsdump-kernel.org.orig/restore/win.h
+++ xfsdump-kernel.org/restore/win.h
@@ -21,6 +21,8 @@
 /* win.[ch] - windows into a very large file
  */
 
+typedef intgen_t segix_t;
+
 /* initialize the window abstraction
  */
 void win_init( intgen_t fd,
@@ -28,15 +30,15 @@ void win_init( intgen_t fd,
 	       size64_t winsz,		/* window size */
 	       size_t wincntmax );	/* max number of windows to manage */
 
-/* supply a pointer to the portion of the file identified by off.
+/* supply a pointer to the portion of the file identified by segix.
  */
-void win_map( off64_t off,		/* file offset relative to rngoff */
+void win_map( segix_t segix,		/* segment index to be mapped */
 	      void **pp );		/* returns pointer by reference */
 
 /* invalidate the pointer previously supplied. SIDE-EFFECT: zeros
  * by reference the caller's pointer.
  */
-void win_unmap( off64_t off,		/* must match win_map param */
+void win_unmap( segix_t segix,		/* must match win_map param */
 	        void **pp );		/* ptr generated by win_map: ZEROED */
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
