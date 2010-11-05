Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA5GZM40209045 for <xfs@oss.sgi.com>; Fri, 5 Nov 2010 11:35:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4184EAC016
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 09:36:44 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id C4DDD7003735
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 11:36:43 -0500 (CDT)
Message-Id: <20101105163643.571496225@sgi.com>
Date: Fri, 05 Nov 2010 11:35:03 -0500
From: wkendall@sgi.com
Subject: [PATCH v2 3/9] xfsrestore: cache path lookups
References: <20101105163500.747192954@sgi.com>
Content-Disposition: inline; filename=node2path_caching
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

In order to resolve a pathname, xfsrestore must work from an inode
number (from the dump) and recurse up the directory entry tree that it
has constructed. Each level of recursion requires a seek and read to
get the name of the dirent, and possibly a mmap of a section of the
directory entry tree if it is not already mapped (and in that case,
possibly a munmap of another section). It's quite common to resolve
pathnames in the same directory consecutively, so simply caching the
parent directory pathname from the previous lookup saves quite a bit
of overhead.

Signed-off-by: Bill Kendall <wkendall@sgi.com>


---
 restore/tree.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

Index: xfsdump-kernel.org/restore/tree.c
===================================================================
--- xfsdump-kernel.org.orig/restore/tree.c
+++ xfsdump-kernel.org/restore/tree.c
@@ -236,6 +236,14 @@ struct link_iter_context {
 };
 typedef struct link_iter_context link_iter_context_t;
 
+/* used for caching parent pathname from previous Node2path result
+ */
+struct path_cache {
+	nh_t nh;
+	intgen_t len;
+	char buf[MAXPATHLEN];
+};
+typedef struct path_cache path_cache_t;
 
 /* declarations of externally defined global symbols *************************/
 
@@ -254,7 +262,8 @@ static nh_t Node_alloc( xfs_ino_t ino,
 static void Node_free( nh_t *nhp );
 static node_t * Node_map( nh_t nh );
 static void Node_unmap( nh_t nh, node_t **npp );
-static intgen_t Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz );
+static intgen_t Node2path_recurse( nh_t nh, char *buf,
+				   intgen_t bufsz, intgen_t level );
 static void adopt( nh_t parh, nh_t cldh, nrh_t nrh );
 static nrh_t disown( nh_t cldh );
 static void selsubtree( nh_t nh, bool_t sensepr );
@@ -3435,7 +3444,7 @@ Node2path( nh_t nh, char *path, char *er
 {
 	intgen_t remainingcnt;
 	path[ 0 ] = 0; /* in case root node passed in */
-	remainingcnt = Node2path_recurse( nh, path, MAXPATHLEN );
+	remainingcnt = Node2path_recurse( nh, path, MAXPATHLEN, 0 );
 	if ( remainingcnt <= 0 ) {
 		node_t *np = Node_map( nh );
 		xfs_ino_t ino = np->n_ino;
@@ -3459,13 +3468,15 @@ Node2path( nh_t nh, char *path, char *er
  * works because the buffer size is secretly 2 * MAXPATHLEN.
  */
 static intgen_t
-Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz )
+Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz, intgen_t level )
 {
+	static path_cache_t cache = { NH_NULL, 0, "" };
 	node_t *np;
 	nh_t parh;
 	xfs_ino_t ino;
 	gen_t gen;
 	nrh_t nrh;
+	char *oldbuf;
 	intgen_t oldbufsz;
 	intgen_t namelen;
 
@@ -3475,6 +3486,13 @@ Node2path_recurse( nh_t nh, char *buf, i
 		return bufsz;
 	}
 
+	/* if we have a cache hit, no need to recurse any further
+	 */
+	if ( nh == cache.nh && bufsz > cache.len ) {
+		strcpy( buf, cache.buf );
+		return bufsz - cache.len;
+	}
+
 	/* extract useful node members
 	 */
 	np = Node_map( nh );
@@ -3486,8 +3504,9 @@ Node2path_recurse( nh_t nh, char *buf, i
 
 	/* build path to parent
 	 */
+	oldbuf = buf;
 	oldbufsz = bufsz;
-	bufsz = Node2path_recurse( parh, buf, bufsz ); /* RECURSION */
+	bufsz = Node2path_recurse( parh, buf, bufsz, level+1 ); /* RECURSION */
 	if ( bufsz <= 0 ) {
 		return bufsz;
 	}
@@ -3517,10 +3536,22 @@ Node2path_recurse( nh_t nh, char *buf, i
 		ASSERT( namelen > 0 );
 	}
 
-	/* return remaining buffer size
+	/* update remaining buffer size
 	 */
 	bufsz -= namelen;
 	ASSERT( bufsz + MAXPATHLEN > 0 );
+
+	/* update the cache if we're the target's parent
+	 * (and the pathname is not too long)
+	 */
+	if ( level == 1 && bufsz > 0 ) {
+		cache.nh = nh;
+		strcpy( cache.buf, oldbuf );
+		cache.len = oldbufsz - bufsz;
+	}
+
+	/* return remaining buffer size
+	 */
 	return bufsz;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
