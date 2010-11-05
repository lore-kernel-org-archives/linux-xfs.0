Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA5GZLrE209003 for <xfs@oss.sgi.com>; Fri, 5 Nov 2010 11:35:21 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCA0330408D
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 09:36:46 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 308FF7003738
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 11:36:44 -0500 (CDT)
Message-Id: <20101105163643.987306372@sgi.com>
Date: Fri, 05 Nov 2010 11:35:05 -0500
From: wkendall@sgi.com
Subject: [PATCH v2 5/9] xfsrestore: cleanup node allocation
References: <20101105163500.747192954@sgi.com>
Content-Disposition: inline; filename=node_alloc_cleanup
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

Simplify the node allocation code. The current code takes some
number of nodes from a new segment and links them into the
freelist whenever the freelist is depleted. There's no reason
to put the new nodes on the freelist, we can just allocate the
next available new node as needed. This also saves a trip through
win_map/win_unmap if there are no nodes on the freelist (the
common case).

Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 restore/node.c |  144 +++++++++++++++------------------------------------------
 1 file changed, 39 insertions(+), 105 deletions(-)

Index: xfsdump-kernel.org/restore/node.c
===================================================================
--- xfsdump-kernel.org.orig/restore/node.c
+++ xfsdump-kernel.org/restore/node.c
@@ -111,10 +111,6 @@ extern size_t pgmask;
  */
 #define NODESPERSEGMIN	1000000
 
-/* how many nodes to place on free list at a time
- */
-#define VIRGSACRMAX	8192 /* fudged: 8192 48 byte nodes (24 or 96 pages) */
-
 /* a node is identified internally by its index into the backing store.
  * this index is the offset of the node into the segmented portion of
  * backing store (follows the abstraction header page) divided by the
@@ -380,72 +376,41 @@ node_alloc( void )
 	nix_t nix;
 	u_char_t *p;
 	nh_t nh;
-	register nix_t *linkagep;
 #ifdef NODECHK
-	register u_char_t *hkpp;
-	register u_char_t gen;
-	register u_char_t unq;
+	u_char_t *hkpp;
+	u_char_t gen = 0;
+	u_char_t unq;
 #endif /* NODECHK */
 
-	/* if free list is depleted, map in a new window at the
-	 * end of backing store. put all nodes on free list.
-	 * initialize the gen count to the node index, and the unique
-	 * pattern to the free pattern.
-	 */
-	if ( node_hdrp->nh_freenix == NIX_NULL ) {
-		nix_t virgbegnix; /* abs. nix of first node in virg seg */
-		nix_t virgendnix; /* abs. nix of next node after last */
-		nix_t sacrcnt; /* how many virgins to put on free list */
-		nix_t sacrnix; 
-
-		ASSERT( node_hdrp->nh_virgrelnix
-			<
-			( nix_t )node_hdrp->nh_nodesperseg );
-		virgbegnix = OFF2NIX( node_hdrp->nh_virgsegreloff )
-			     +
-			     node_hdrp->nh_virgrelnix;
-		virgendnix =
-		      OFF2NIX( ( node_hdrp->nh_virgsegreloff
-			       +
-			       ( off64_t )node_hdrp->nh_segsz ) );
-#ifdef TREE_DEBUG
-		mlog(MLOG_DEBUG | MLOG_TREE,
-		   "node_alloc(): create freelist - "
-		   "virg_begin=%lld virg_end=%lld\n",
-		   virgbegnix, virgendnix); 
-#endif
-		ASSERT( virgendnix > virgbegnix );
-		sacrcnt = min( VIRGSACRMAX, virgendnix - virgbegnix );
-		ASSERT( sacrcnt >= 1 );
-		p = 0; /* keep lint happy */
-		win_map( NIX2OFF( virgbegnix ), ( void ** )&p );
+	/* if there's a node available on the free list, use it.
+	 * otherwise get the next one from the current virgin segment,
+	 * or allocate a new virgin segment if the current one is depleted.
+	 */
+	if ( node_hdrp->nh_freenix != NIX_NULL ) {
+		nix_t *linkagep;
+		off64_t off;
+
+		nix = node_hdrp->nh_freenix;
+
+		off = NIX2OFF( nix );
+		win_map( off, ( void ** )&p );
 		if (p == NULL)
-		    return NH_NULL;
-		node_hdrp->nh_freenix = virgbegnix;
-		for ( sacrnix = virgbegnix
-		      ;
-		      sacrnix < virgbegnix + sacrcnt - 1
-		      ;
-		      p += node_hdrp->nh_nodesz, sacrnix++ ) {
-			linkagep = ( nix_t * )p;
-			*linkagep = sacrnix + 1;
-#ifdef NODECHK
-			hkpp = p + node_hdrp->nh_nodehkix;
-			gen = ( u_char_t )sacrnix;
-			*hkpp = ( u_char_t )HKPMKHKP( ( size_t )gen,
-						      NODEUNQFREE );
-#endif /* NODECHK */
-		}
-		linkagep = ( nix_t * )p;
-		*linkagep = NIX_NULL;
+			return NH_NULL;
 #ifdef NODECHK
 		hkpp = p + node_hdrp->nh_nodehkix;
-		gen = ( u_char_t )sacrnix;
-		*hkpp = HKPMKHKP( gen, NODEUNQFREE );
+		gen = ( u_char_t )( HKPGETGEN( *p ) + ( u_char_t )1 );
+		unq = HKPGETUNQ( *hkpp );
+		ASSERT( unq != NODEUNQALCD );
+		ASSERT( unq == NODEUNQFREE );
 #endif /* NODECHK */
-		node_hdrp->nh_virgrelnix += sacrcnt;
-		win_unmap( node_hdrp->nh_virgsegreloff, ( void ** )&p );
 
+		/* adjust the free list */
+		linkagep = ( nix_t * )p;
+		node_hdrp->nh_freenix = *linkagep;
+
+		win_unmap( off, ( void ** )&p );
+
+	} else {
 		if ( node_hdrp->nh_virgrelnix
 		     >=
 		     ( nix_t )node_hdrp->nh_nodesperseg ) {
@@ -468,14 +433,11 @@ node_alloc( void )
 			mlog( MLOG_DEBUG,
 			      "pre-growing new node array segment at %lld "
 			      "size %lld\n",
-			      node_hdrp->nh_firstsegoff 
-			      +
-			      node_hdrp->nh_virgsegreloff
-			      +
-			      ( off64_t )node_hdrp->nh_segsz,
+			      node_hdrp->nh_firstsegoff +
+			      node_hdrp->nh_virgsegreloff,
 			      ( off64_t )node_hdrp->nh_segsz );
 			rval = ftruncate64( node_fd,
-					    node_hdrp->nh_firstsegoff 
+					    node_hdrp->nh_firstsegoff
 					    +
 					    node_hdrp->nh_virgsegreloff
 					    +
@@ -484,60 +446,32 @@ node_alloc( void )
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 				      "unable to autogrow node segment %llu: "
 				      "%s (%d)\n"),
-				      node_hdrp->nh_virgsegreloff
-				      /
-				      ( off64_t )node_hdrp->nh_segsz,
+				      OFF2NIX(node_hdrp->nh_virgsegreloff),
 				      strerror( errno ),
 				      errno );
 			}
 		}
-	}
 
-	/* map in window containing node at top of free list,
-	 * and adjust free list.
-	 */
-	nix = node_hdrp->nh_freenix;
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE,
-	   "node_alloc(): win_map(%llu) and get head from node freelist\n",
-           NIX2OFF(nix));
-#endif
-	win_map( NIX2OFF( nix ), ( void ** )&p );
-	if (p == NULL)
-	    return NH_NULL;
-#ifdef NODECHK
-	hkpp = p + node_hdrp->nh_nodehkix;
-	unq = HKPGETUNQ( *hkpp );
-	ASSERT( unq != NODEUNQALCD );
-	ASSERT( unq == NODEUNQFREE );
-#endif /* NODECHK */
-	linkagep = ( nix_t * )p;
-	node_hdrp->nh_freenix = *linkagep;
-
-	/* clean the node
-	 */
-	memset( ( void * )p, 0, node_hdrp->nh_nodesz );
+		nix = OFF2NIX( node_hdrp->nh_virgsegreloff )
+			+
+			node_hdrp->nh_virgrelnix++;
+	}
 
 	/* build a handle for node
 	 */
 	ASSERT( nix <= NIX_MAX );
 #ifdef NODECHK
+	win_map( NIX2OFF( nix ), ( void ** )&p );
+	if (p == NULL)
+		abort();
 	hkpp = p + ( int )node_hdrp->nh_nodehkix;
-	gen = ( u_char_t )( HKPGETGEN( *p ) + ( u_char_t )1 );
 	nh = HDLMKHDL( gen, nix );
 	*hkpp = HKPMKHKP( gen, NODEUNQALCD );
+	win_unmap( NIX2OFF( nix ), ( void ** )&p );
 #else /* NODECHK */
 	nh = ( nh_t )nix;
 #endif /* NODECHK */
 
-	/* unmap window
-	 */
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE,
-	   "node_alloc(): win_unmap(%llu)\n", NIX2OFF(nix));
-#endif
-	win_unmap( NIX2OFF( nix ), ( void ** )&p );
-
 	return nh;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
