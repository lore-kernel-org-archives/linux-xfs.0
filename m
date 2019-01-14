Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfANR0R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1E68889AC9
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:15 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 13/13] xfsdump: (13/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:28 +0100
Message-Id: <20190114172528.65250-14-jtulak@redhat.com>
In-Reply-To: <20190114172528.65250-1-jtulak@redhat.com>
References: <20190114172528.65250-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Transform "( x, y )" to "(x, y)", and the same for [].

Created by this script:
*****
#!/usr/bin/env bash
# transform 'foo( x, y )' -> 'foo(x, y)'
set -euo pipefail

# regexps in order:
# - remove spaces after opening parentheses (
# - remove spaces after opening brackets [
# - remove spaces before closing parentheses )
# - remove spaces before closing brackets ]
#
# Run multiple iterations to get all overlapping matches.

for i in {1..8}; do
    echo "iteration $i"
    find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
        $0 = gensub(/^([^"]*)\(\s+/, "\\1(", "g")
        $0 = gensub(/^([^"]*)\[\s+/, "\\1[", "g")
        $0 = gensub(/(\S)\s+\)([^"]*)$/, "\\1)\\2", "g")
        $0 = gensub(/(\S)\s+\]([^"]*)$/, "\\1]\\2", "g")
    }; {print }' {} \;
done


# Revert changes in defines that would cause redefinition error
sed -i \
    -e 's/^#define sizeofmember.*$/#define sizeofmember( t, m )\tsizeof( ( ( t * )0 )->m )/' \
    -e 's/^#define offsetofmember.*$/#define offsetofmember( t, m )\t( ( size_t )( char * )\&( ( ( t * )0 )->m ) )/' \
    common/types.h

*****

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 restore/tree.c | 2874 ++++++++++++++++++++++++------------------------
 restore/tree.h |   48 +-
 restore/win.c  |  138 +--
 restore/win.h  |   12 +-
 4 files changed, 1536 insertions(+), 1536 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index bc948fc..3f3084e 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -127,9 +127,9 @@ typedef struct treePersStorage treepers_t;
 #define INTER_ARGMAX	10	/* max number of args to interactive cmds */
 struct inter {
 	size_t i_argc;
-	char *i_argv[ INTER_ARGMAX ];
+	char *i_argv[INTER_ARGMAX];
 	nh_t i_cwdh;
-	char i_name[ NAME_MAX + 1 ];
+	char i_name[NAME_MAX + 1];
 };
 
 typedef struct inter inter_t;
@@ -163,7 +163,7 @@ struct tran {
 	nh_t *t_hashp;
 		/* pointer to mapped hash array (private to hash abstraction)
 		 */
-	char t_namebuf[ NAME_MAX + 1 ];
+	char t_namebuf[NAME_MAX + 1];
 		/* to hold names temporarily retrieved from name registry
 		 */
 	inter_t t_inter;
@@ -196,14 +196,14 @@ struct node {
 
 typedef struct node node_t;
 
-#define NF_REAL		( 1 << 0 )
+#define NF_REAL		(1 << 0)
 	/* set when the corresponding file/dir has been created in
 	 * the restore destination.
 	 */
-#define NF_SUBTREE	( 1 << 1 )
+#define NF_SUBTREE	(1 << 1)
 	/* marks nodes in the selected subtrees.
 	 */
-#define NF_REFED	( 1 << 2 )
+#define NF_REFED	(1 << 2)
 	/* indicates node is still referenced according to incremental/resumed
 	 * dump. used to detect dirents no longer used. prior to restoring
 	 * a dump session, this flag is cleared in all nodes. during the dirent
@@ -211,15 +211,15 @@ typedef struct node node_t;
 	 * for referenced but undumped directories. NOTE: nodes in the
 	 * orphanage NEVER have this flag set.
 	 */
-#define NF_WRITTEN	( 1 << 3 )
+#define NF_WRITTEN	(1 << 3)
 	/* set as soon as a non-dir node restore is begun. allows
 	 * overwrite inhibit options to work with segmented files
 	 */
-#define NF_ISDIR	( 1 << 4 )
+#define NF_ISDIR	(1 << 4)
 	/* indicates this node is a directory. set when a directory is taken
 	 * from the dirdump.
 	 */
-#define NF_DUMPEDDIR	( 1 << 5 )
+#define NF_DUMPEDDIR	(1 << 5)
 	/* indicates this node is a directory present in the current dirdump.
 	 * at beginning of session, this flag is cleared in all nodes.
 	 * then as each directory dump is read from media, the flag
@@ -229,7 +229,7 @@ typedef struct node node_t;
 	 * it exists, in which case if it is not dumped then all of its entries
 	 * are referenced as well.
 	 */
-#define NF_NEWORPH	( 1 << 6 )
+#define NF_NEWORPH	(1 << 6)
 	/* cleared from all nodes in the orphanage before a dump is applied.
 	 * set if a dir is seen in the dirdump but no node exists for it.
 	 * cleared if that dir is adopted subsequently during the dirdump.
@@ -261,64 +261,64 @@ typedef struct path_cache path_cache_t;
 
 /* declarations of externally defined global symbols *************************/
 
-extern void usage( void );
+extern void usage(void);
 extern size_t pgsz;
 extern size_t pgmask;
 extern bool_t restore_rootdir_permissions;
 
 /* forward declarations of locally defined static functions ******************/
 
-static nh_t Node_alloc( xfs_ino_t ino,
+static nh_t Node_alloc(xfs_ino_t ino,
 			gen_t gen,
 			nrh_t nrh,
 			dah_t dah,
-			size_t flags );
-static void Node_free( nh_t *nhp );
-static node_t * Node_map( nh_t nh );
-static void Node_unmap( nh_t nh, node_t **npp );
-static int Node2path_recurse( nh_t nh, char *buf,
-				   int bufsz, int level );
-static void adopt( nh_t parh, nh_t cldh, nrh_t nrh );
-static nrh_t disown( nh_t cldh );
-static void selsubtree( nh_t nh, bool_t sensepr );
-static void selsubtree_recurse_down( nh_t nh, bool_t sensepr );
-static nh_t link_hardh( xfs_ino_t ino, gen_t gen );
-static nh_t link_nexth( nh_t nh );
-static nh_t link_matchh( nh_t hardh, nh_t parh, char *name );
-static void link_in( nh_t nh );
-static void link_out( nh_t nh );
-static void link_headiter( bool_t ( * cbfp )( void *contextp, nh_t hardh ),
-			   void *contextp );
-static void link_iter_init( link_iter_context_t *link_iter_contextp,
-			    nh_t hardheadh );
-static nh_t link_iter_next( link_iter_context_t *link_iter_contextp );
-void link_iter_unlink( link_iter_context_t *link_iter_contextp, nh_t nh );
-static bool_t hash_init( size64_t vmsz,
+			size_t flags);
+static void Node_free(nh_t *nhp);
+static node_t * Node_map(nh_t nh);
+static void Node_unmap(nh_t nh, node_t **npp);
+static int Node2path_recurse(nh_t nh, char *buf,
+				   int bufsz, int level);
+static void adopt(nh_t parh, nh_t cldh, nrh_t nrh);
+static nrh_t disown(nh_t cldh);
+static void selsubtree(nh_t nh, bool_t sensepr);
+static void selsubtree_recurse_down(nh_t nh, bool_t sensepr);
+static nh_t link_hardh(xfs_ino_t ino, gen_t gen);
+static nh_t link_nexth(nh_t nh);
+static nh_t link_matchh(nh_t hardh, nh_t parh, char *name);
+static void link_in(nh_t nh);
+static void link_out(nh_t nh);
+static void link_headiter(bool_t (* cbfp)(void *contextp, nh_t hardh),
+			   void *contextp);
+static void link_iter_init(link_iter_context_t *link_iter_contextp,
+			    nh_t hardheadh);
+static nh_t link_iter_next(link_iter_context_t *link_iter_contextp);
+void link_iter_unlink(link_iter_context_t *link_iter_contextp, nh_t nh);
+static bool_t hash_init(size64_t vmsz,
 			 size64_t dircnt,
 			 size64_t nondircnt,
-			 char *perspath );
-static bool_t hash_sync( char *perspath );
+			 char *perspath);
+static bool_t hash_sync(char *perspath);
 static inline size_t hash_val(xfs_ino_t ino, size_t hashmask);
-static void hash_in( nh_t nh );
-static void hash_out( nh_t nh );
-static nh_t hash_find( xfs_ino_t ino, gen_t gen );
-static void hash_iter( bool_t ( * cbfp )( void *contextp, nh_t hashh ),
-		       void *contextp );
-static void setdirattr( dah_t dah, char *path );
-static bool_t tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
+static void hash_in(nh_t nh);
+static void hash_out(nh_t nh);
+static nh_t hash_find(xfs_ino_t ino, gen_t gen);
+static void hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh),
+		       void *contextp);
+static void setdirattr(dah_t dah, char *path);
+static bool_t tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			    dlog_pcbp_t pcb, void *pctxp,
 			    nh_t *namedhp, nh_t *parhp, nh_t *cldhp,
-			    xfs_ino_t *inop, bool_t *isdirprp, bool_t *isselpr );
-static bool_t Node2path( nh_t nh, char *path, char *errmsg );
-static bool_t tree_setattr_recurse( nh_t parh, char *path );
-static void tsi_cmd_pwd_recurse( void *ctxp,
+			    xfs_ino_t *inop, bool_t *isdirprp, bool_t *isselpr);
+static bool_t Node2path(nh_t nh, char *path, char *errmsg);
+static bool_t tree_setattr_recurse(nh_t parh, char *path);
+static void tsi_cmd_pwd_recurse(void *ctxp,
 				 dlog_pcbp_t pcb,
 				 void *pctxp,
-				 nh_t nh );
+				 nh_t nh);
 static int mkdir_r(char *path);
 #ifdef TREE_CHK
-static bool_t Node_chk( nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp );
-static bool_t tree_chk2( void );
+static bool_t Node_chk(nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp);
+static bool_t tree_chk2(void);
 #endif /* TREE_CHK */
 
 /* definition of locally defined global variables ****************************/
@@ -337,7 +337,7 @@ static xfs_ino_t orphino = ORPH_INO;
 
 /* ARGSUSED */
 bool_t
-tree_init( char *hkdir,
+tree_init(char *hkdir,
 	   char *dstdir,
 	   bool_t toconlypr,
 	   bool_t ownerpr,
@@ -351,7 +351,7 @@ tree_init( char *hkdir,
 	   bool_t restoredmpr,
 	   bool_t dstdirisxfspr,
 	   uint32_t dumpformat,
-	   bool_t truncategenpr )
+	   bool_t truncategenpr)
 {
 	off64_t nodeoff;
 	char *perspath;
@@ -360,16 +360,16 @@ tree_init( char *hkdir,
 
 	/* sanity checks
 	 */
-	assert( ! ( PERSSZ % pgsz ));
-	assert( sizeof( persp ) <= PERSSZ );
-	assert( sizeof( node_t ) <= NODESZ );
-	assert( ! persp );
-	assert( ! tranp );
+	assert(! (PERSSZ % pgsz));
+	assert(sizeof(persp) <= PERSSZ);
+	assert(sizeof(node_t) <= NODESZ);
+	assert(! persp);
+	assert(! tranp);
 
 	/* allocate transient state
 	 */
-	tranp = ( tran_t * )calloc( 1, sizeof( tran_t ));
-	assert( tranp );
+	tranp = (tran_t *)calloc(1, sizeof(tran_t));
+	assert(tranp);
 
 	tranp->t_toconlypr = toconlypr;
 	tranp->t_hkdir = hkdir;
@@ -379,16 +379,16 @@ tree_init( char *hkdir,
 	/* allocate a char string buffer to hold the abs. pathname
 	 * of the orphanage directory file. load it with the pathname.
 	 */
-	tranp->t_orphdir = open_pathalloc( tranp->t_dstdir,
+	tranp->t_orphdir = open_pathalloc(tranp->t_dstdir,
 					   orphname,
-					   0 );
+					   0);
 
 	/* determine if housekeeping dir is within the destination.
 	 * generate a relative path containing the difference,
 	 * else null. will not restore into there.
 	 */
-	if ( strcmp( dstdir, "." )) {
-		tranp->t_hksubtree = path_diff( hkdir, dstdir );
+	if (strcmp(dstdir, ".")) {
+		tranp->t_hksubtree = path_diff(hkdir, dstdir);
 	} else {
 		tranp->t_hksubtree = 0;
 	}
@@ -396,19 +396,19 @@ tree_init( char *hkdir,
 	/* create an orphanage, if it already exists, complain.
 	 * not needed if just a table-of-contents restore.
 	 */
-	if ( ! tranp->t_toconlypr ) {
-		rval = mkdir( tranp->t_orphdir, S_IRWXU );
-		if ( rval ) {
-			if ( errno == EEXIST ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+	if (! tranp->t_toconlypr) {
+		rval = mkdir(tranp->t_orphdir, S_IRWXU);
+		if (rval) {
+			if (errno == EEXIST) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 				      "%s already exists: "
 				      "rm -rf prior to initating restore\n"),
-				      tranp->t_orphdir );
+				      tranp->t_orphdir);
 			} else {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 				      "unable to create %s: %s\n"),
 				      tranp->t_orphdir,
-				      strerror( errno ));
+				      strerror(errno));
 			}
 			return BOOL_FALSE;
 		}
@@ -416,42 +416,42 @@ tree_init( char *hkdir,
 
 	/* build a full pathname to pers. state file
 	 */
-	perspath = open_pathalloc( tranp->t_hkdir, persname, 0 );
+	perspath = open_pathalloc(tranp->t_hkdir, persname, 0);
 
 	/* create the persistent state file
 	 */
-	( void )unlink( perspath );
-	tranp->t_persfd = open( perspath,
+	(void)unlink(perspath);
+	tranp->t_persfd = open(perspath,
 				O_RDWR | O_CREAT,
-				S_IRUSR | S_IWUSR );
-	if ( tranp->t_persfd < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+				S_IRUSR | S_IWUSR);
+	if (tranp->t_persfd < 0) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 		      "could not open %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* mmap the persistent state
 	 */
-	assert( ! ( PERSSZ % pgsz ));
-	persp = ( treepers_t * ) mmap_autogrow(
+	assert(! (PERSSZ % pgsz));
+	persp = (treepers_t *) mmap_autogrow(
 				     PERSSZ,
 				     tranp->t_persfd,
-				     ( off64_t )0 );
-	if ( persp == ( treepers_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+				     (off64_t)0);
+	if (persp == (treepers_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 		      "unable to map %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* create the hash abstraction. it will map more of the
 	 * persistent state file.
 	 */
-	ok = hash_init( vmsz / HASHSZ_PERVM, dircnt, nondircnt, perspath );
-	if ( ! ok ) {
+	ok = hash_init(vmsz / HASHSZ_PERVM, dircnt, nondircnt, perspath);
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
@@ -459,17 +459,17 @@ tree_init( char *hkdir,
 	 * begin immediately after the hash abstraction. give it the remainder
 	 * of vm.
 	 */
-	assert( persp->p_hashsz <= ( size64_t )( OFF64MAX - ( off64_t )PERSSZ));
-	nodeoff = ( off64_t )PERSSZ + ( off64_t )persp->p_hashsz;
-	assert( vmsz > ( size64_t )nodeoff );
-	ok = node_init( tranp->t_persfd,
+	assert(persp->p_hashsz <= (size64_t)(OFF64MAX - (off64_t)PERSSZ));
+	nodeoff = (off64_t)PERSSZ + (off64_t)persp->p_hashsz;
+	assert(vmsz > (size64_t)nodeoff);
+	ok = node_init(tranp->t_persfd,
 		        nodeoff,
 		        NODESZ,
-			 ( ix_t )offsetofmember( node_t, n_nodehkbyte ),
-		        sizeof( size64_t ), /* node alignment */
-		        vmsz - ( size64_t )nodeoff,
-			dircnt + nondircnt );
-	if ( ! ok ) {
+			 (ix_t)offsetofmember(node_t, n_nodehkbyte),
+		        sizeof(size64_t), /* node alignment */
+		        vmsz - (size64_t)nodeoff,
+			dircnt + nondircnt);
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
@@ -482,23 +482,23 @@ tree_init( char *hkdir,
 	 * has a generation count of zero - which is true.
 	 */
 	persp->p_rootino = rootino;
-	persp->p_rooth = Node_alloc( rootino,
+	persp->p_rooth = Node_alloc(rootino,
 				     0, /* gen cnt */
 				     NRH_NULL,
 				     DAH_NULL,
-				     NF_ISDIR | NF_REAL );
+				     NF_ISDIR | NF_REAL);
 	if (persp->p_rooth == NH_NULL)
 		return BOOL_FALSE;
-	link_in( persp->p_rooth );
-	persp->p_orphh = Node_alloc( orphino,
+	link_in(persp->p_rooth);
+	persp->p_orphh = Node_alloc(orphino,
 				     0, /* gen cnt */
-				     namreg_add( orphname, strlen( orphname )),
+				     namreg_add(orphname, strlen(orphname)),
 				     DAH_NULL,
-				     NF_ISDIR | NF_REAL );
+				     NF_ISDIR | NF_REAL);
 	if (persp->p_orphh == NH_NULL)
 		return BOOL_FALSE;
-	link_in( persp->p_orphh );
-	adopt( persp->p_rooth, persp->p_orphh, NRH_NULL );
+	link_in(persp->p_orphh);
+	adopt(persp->p_rooth, persp->p_orphh, NRH_NULL);
 
 	/* record if we should attempt to restore original owner/group
 	 */
@@ -514,14 +514,14 @@ tree_init( char *hkdir,
 
 	/* record if truncated generation numbers are required
 	 */
-	if ( dumpformat < GLOBAL_HDR_VERSION_3 ) {
+	if (dumpformat < GLOBAL_HDR_VERSION_3) {
 		persp->p_truncategenpr = BOOL_TRUE;
-		mlog( MLOG_NORMAL | MLOG_DEBUG | MLOG_TREE, _(
+		mlog(MLOG_NORMAL | MLOG_DEBUG | MLOG_TREE, _(
 		      "dump format version %u used truncated inode generation numbers\n"),
-			dumpformat );
-	} else if ( truncategenpr ) {
+			dumpformat);
+	} else if (truncategenpr) {
 		persp->p_truncategenpr = BOOL_TRUE;
-		mlog( MLOG_NORMAL | MLOG_DEBUG | MLOG_TREE, _(
+		mlog(MLOG_NORMAL | MLOG_DEBUG | MLOG_TREE, _(
 		      "forcing use of truncated inode generation numbers\n"));
 	} else {
 		persp->p_truncategenpr = BOOL_FALSE;
@@ -531,33 +531,33 @@ tree_init( char *hkdir,
 }
 
 bool_t
-tree_sync( char *hkdir,
+tree_sync(char *hkdir,
 	   char *dstdir,
 	   bool_t toconlypr,
 	   bool_t fullpr,
-	   bool_t dstdirisxfspr )
+	   bool_t dstdirisxfspr)
 {
 	off64_t nodeoff;
 	char *perspath;
 	bool_t ok;
 	int rval;
 
-	if ( persp ) {
+	if (persp) {
 		return BOOL_TRUE;
 	}
 
 	/* sanity checks
 	 */
-	assert( ! ( PERSSZ % pgsz ));
-	assert( sizeof( persp ) <= PERSSZ );
-	assert( sizeof( node_t ) <= NODESZ );
-	assert( ! persp );
-	assert( ! tranp );
+	assert(! (PERSSZ % pgsz));
+	assert(sizeof(persp) <= PERSSZ);
+	assert(sizeof(node_t) <= NODESZ);
+	assert(! persp);
+	assert(! tranp);
 
 	/* allocate transient state
 	 */
-	tranp = ( tran_t * )calloc( 1, sizeof( tran_t ));
-	assert( tranp );
+	tranp = (tran_t *)calloc(1, sizeof(tran_t));
+	assert(tranp);
 
 	tranp->t_toconlypr = toconlypr;
 	tranp->t_hkdir = hkdir;
@@ -567,58 +567,58 @@ tree_sync( char *hkdir,
 	/* allocate a char string buffer to hold the abs. pathname
 	 * of the orphanage directory file. load it with the pathname.
 	 */
-	tranp->t_orphdir = open_pathalloc( tranp->t_dstdir,
+	tranp->t_orphdir = open_pathalloc(tranp->t_dstdir,
 					   orphname,
-					   0 );
+					   0);
 
 	/* determine if housekeeping dir is within the destination.
 	 * generate a relative path containing the difference,
 	 * else null. will not restore into there.
 	 */
-	if ( strcmp( dstdir, "." )) {
-		tranp->t_hksubtree = path_diff( hkdir, dstdir );
+	if (strcmp(dstdir, ".")) {
+		tranp->t_hksubtree = path_diff(hkdir, dstdir);
 	} else {
 		tranp->t_hksubtree = 0;
 	}
 
 	/* re-create the orphanage (in case someone rmdir'ed it)
 	 */
-	rval = mkdir( tranp->t_orphdir, S_IRWXU );
-	if ( rval && errno != EEXIST ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+	rval = mkdir(tranp->t_orphdir, S_IRWXU);
+	if (rval && errno != EEXIST) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 		      "unable to recreate %s: %s\n"),
 		      tranp->t_orphdir,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* build a full pathname to pers. state file
 	 */
-	perspath = open_pathalloc( tranp->t_hkdir, persname, 0 );
+	perspath = open_pathalloc(tranp->t_hkdir, persname, 0);
 
 	/* re-open the persistent state file
 	 */
-	tranp->t_persfd = open( perspath, O_RDWR );
-	if ( tranp->t_persfd < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+	tranp->t_persfd = open(perspath, O_RDWR);
+	if (tranp->t_persfd < 0) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 		      "could not open %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* mmap the persistent state
 	 */
-	assert( ! ( PERSSZ % pgsz ));
-	persp = ( treepers_t * ) mmap_autogrow(
+	assert(! (PERSSZ % pgsz));
+	persp = (treepers_t *) mmap_autogrow(
 				     PERSSZ,
 				     tranp->t_persfd,
-				     ( off64_t )0 );
-	if ( persp == ( treepers_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+				     (off64_t)0);
+	if (persp == (treepers_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 		      "unable to map %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
@@ -630,26 +630,26 @@ tree_sync( char *hkdir,
 	/* regardless of the format of this dump, if the previously applied
 	 * dump used truncated generation numbers, then we need to as well.
 	 */
-	if ( persp->p_truncategenpr ) {
-		mlog( MLOG_NORMAL | MLOG_DEBUG | MLOG_TREE, _(
+	if (persp->p_truncategenpr) {
+		mlog(MLOG_NORMAL | MLOG_DEBUG | MLOG_TREE, _(
 		      "using truncated inode generation numbers for "
-		      "compatibility with previously applied restore\n") );
+		      "compatibility with previously applied restore\n"));
 	}
 
 	/* rsynchronize with the hash abstraction. it will map more of the
 	 * persistent state file.
 	 */
-	ok = hash_sync( perspath );
-	if ( ! ok ) {
+	ok = hash_sync(perspath);
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
 	/* synchronize with the node abstraction.
 	 */
-	assert( persp->p_hashsz <= ( size64_t )( OFF64MAX - ( off64_t )PERSSZ));
-	nodeoff = ( off64_t )PERSSZ + ( off64_t )persp->p_hashsz;
-	ok = node_sync( tranp->t_persfd, nodeoff );
-	if ( ! ok ) {
+	assert(persp->p_hashsz <= (size64_t)(OFF64MAX - (off64_t)PERSSZ));
+	nodeoff = (off64_t)PERSSZ + (off64_t)persp->p_hashsz;
+	ok = node_sync(tranp->t_persfd, nodeoff);
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
@@ -662,17 +662,17 @@ tree_sync( char *hkdir,
 }
 
 bool_t
-tree_check_dump_format( uint32_t dumpformat )
+tree_check_dump_format(uint32_t dumpformat)
 {
-	if ( dumpformat < GLOBAL_HDR_VERSION_3 && !persp->p_truncategenpr ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+	if (dumpformat < GLOBAL_HDR_VERSION_3 && !persp->p_truncategenpr) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 		      "encountered dump format %d after a "
 		      "restore of format %d or newer\n"),
-			dumpformat, GLOBAL_HDR_VERSION_3 );
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+			dumpformat, GLOBAL_HDR_VERSION_3);
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 		      "to restore this series of dumps, use the -%c "
 		      "option on the first restore\n"),
-			GETOPT_FMT2COMPAT );
+			GETOPT_FMT2COMPAT);
 		return BOOL_FALSE;
 	}
 
@@ -685,142 +685,142 @@ tree_check_dump_format( uint32_t dumpformat )
  * referenced during ref adj. also null dirattr handles, since they are
  * not retained across dump session restores.
  */
-static void tree_marknoref_recurse( nh_t parh );
+static void tree_marknoref_recurse(nh_t parh);
 
 void
-tree_marknoref( void )
+tree_marknoref(void)
 {
-	tree_marknoref_recurse( persp->p_rooth );
+	tree_marknoref_recurse(persp->p_rooth);
 
 	{
 		node_t *orphp;
-		orphp = Node_map( persp->p_orphh );
-		orphp->n_flags |= ( NF_REFED | NF_DUMPEDDIR );
-		assert( orphp->n_dah == DAH_NULL );
-		Node_unmap( persp->p_orphh, &orphp );
+		orphp = Node_map(persp->p_orphh);
+		orphp->n_flags |= (NF_REFED | NF_DUMPEDDIR);
+		assert(orphp->n_dah == DAH_NULL);
+		Node_unmap(persp->p_orphh, &orphp);
 	}
 }
 
 static void
-tree_marknoref_recurse( nh_t parh )
+tree_marknoref_recurse(nh_t parh)
 {
 	nh_t cldh;
 
 	{
 		node_t *parp;
-		parp = Node_map( parh );
-		parp->n_flags &= ~( NF_REFED | NF_DUMPEDDIR | NF_NEWORPH );
+		parp = Node_map(parh);
+		parp->n_flags &= ~(NF_REFED | NF_DUMPEDDIR | NF_NEWORPH);
 
 		parp->n_dah = DAH_NULL;
 		cldh = parp->n_cldh;
-		Node_unmap( parh, &parp  );
+		Node_unmap(parh, &parp);
 	}
-	while ( cldh != NH_NULL ) {
+	while (cldh != NH_NULL) {
 		node_t *cldp;
 		nh_t nextcldh;
-		tree_marknoref_recurse( cldh ); /* RECURSION */
-		cldp = Node_map( cldh );
+		tree_marknoref_recurse(cldh); /* RECURSION */
+		cldp = Node_map(cldh);
 		nextcldh = cldp->n_sibh;
-		Node_unmap( cldh, &cldp  );
+		Node_unmap(cldh, &cldp);
 		cldh = nextcldh;
 	}
 }
 
 void
-tree_markallsubtree( bool_t sensepr )
+tree_markallsubtree(bool_t sensepr)
 {
-	if ( ! sensepr ) {
+	if (! sensepr) {
 		persp->p_ignoreorphpr = BOOL_TRUE;
 	}
-	selsubtree( persp->p_rooth, sensepr );
+	selsubtree(persp->p_rooth, sensepr);
 }
 
 nh_t
-tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
+tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 {
 	nh_t hardh;
 	xfs_ino_t ino = fhdrp->fh_stat.bs_ino;
 	gen_t gen = fhdrp->fh_stat.bs_gen;
 	dah_t dah;
 
-	if ( persp->p_truncategenpr ) {
-		gen = BIGGEN2GEN( gen );
+	if (persp->p_truncategenpr) {
+		gen = BIGGEN2GEN(gen);
 	}
 
 	/* sanity check - orphino is supposed to be an unused ino!
 	 */
-	assert( ino != orphino );
+	assert(ino != orphino);
 
 	/* lookup head of hardlink list
 	 */
-	hardh = link_hardh( ino, gen );
-	assert( ino != persp->p_rootino || hardh == persp->p_rooth );
+	hardh = link_hardh(ino, gen);
+	assert(ino != persp->p_rootino || hardh == persp->p_rooth);
 
 	/* already present
 	 */
-	if ( hardh != NH_NULL ) {
+	if (hardh != NH_NULL) {
 		node_t *hardp;
-		hardp = Node_map( hardh );
-		if ( ! ( hardp->n_flags & NF_ISDIR )) {
+		hardp = Node_map(hardh);
+		if (! (hardp->n_flags & NF_ISDIR)) {
 			/* case 1: previously seen as dirent, now know is dir
 			 */
-			mlog( MLOG_TRACE | MLOG_TREE,
+			mlog(MLOG_TRACE | MLOG_TREE,
 			      "directory %llu %u (%u): "
 			      "upgrading to dir\n",
 			      ino,
 			      gen,
-			      fhdrp->fh_stat.bs_gen );
-			if ( ! tranp->t_toconlypr ) {
-				assert( hardp->n_dah == DAH_NULL );
-				hardp->n_dah = dirattr_add( fhdrp );
+			      fhdrp->fh_stat.bs_gen);
+			if (! tranp->t_toconlypr) {
+				assert(hardp->n_dah == DAH_NULL);
+				hardp->n_dah = dirattr_add(fhdrp);
 			}
-		} else if ( ! tranp->t_toconlypr && hardp->n_dah == DAH_NULL ) {
+		} else if (! tranp->t_toconlypr && hardp->n_dah == DAH_NULL) {
 			/* case 2: node is a dir, but had thrown away dirattr
 			 */
-			mlog( MLOG_TRACE | MLOG_TREE,
+			mlog(MLOG_TRACE | MLOG_TREE,
 			      "directory %llu %u (%u): "
 			      "updating\n",
 			      ino,
 			      gen,
-			      fhdrp->fh_stat.bs_gen );
-			hardp->n_dah = dirattr_add( fhdrp );
+			      fhdrp->fh_stat.bs_gen);
+			hardp->n_dah = dirattr_add(fhdrp);
 		} else {
 			/* case 3: already has dirattr; must be restart
 			 */
-			mlog( MLOG_TRACE | MLOG_TREE,
+			mlog(MLOG_TRACE | MLOG_TREE,
 			      "directory %llu %u (%u): "
 			      "retaining\n",
 			      ino,
 			      gen,
-			      fhdrp->fh_stat.bs_gen );
+			      fhdrp->fh_stat.bs_gen);
 		}
 		hardp->n_flags |= NF_ISDIR;
 		hardp->n_flags |= NF_DUMPEDDIR;
 		*dahp = hardp->n_dah;
-		Node_unmap( hardh, &hardp );
+		Node_unmap(hardh, &hardp);
 	} else {
 		/* case 4: first time seen
 		 */
-		mlog( MLOG_TRACE | MLOG_TREE,
+		mlog(MLOG_TRACE | MLOG_TREE,
 		      "directory %llu %u (%u): "
 		      "new\n",
 		      ino,
 		      gen,
-		      fhdrp->fh_stat.bs_gen );
-		if ( ! tranp->t_toconlypr ) {
-			dah = dirattr_add( fhdrp );
+		      fhdrp->fh_stat.bs_gen);
+		if (! tranp->t_toconlypr) {
+			dah = dirattr_add(fhdrp);
 		} else {
 			dah = DAH_NULL;
 		}
-		hardh = Node_alloc( ino,
+		hardh = Node_alloc(ino,
 				    gen,
 				    NRH_NULL,
 				    dah,
-				    NF_ISDIR | NF_NEWORPH );
+				    NF_ISDIR | NF_NEWORPH);
 		if (hardh == NH_NULL)
 			return NH_NULL;
-		link_in( hardh );
-		adopt( persp->p_orphh, hardh, NRH_NULL );
+		link_in(hardh);
+		adopt(persp->p_orphh, hardh, NRH_NULL);
 		*dahp = dah;
 	}
 
@@ -828,103 +828,103 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
 }
 
 rv_t
-tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
+tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 {
 	nh_t hardh;
 
-	if ( persp->p_truncategenpr ) {
-		gen = BIGGEN2GEN( gen );
+	if (persp->p_truncategenpr) {
+		gen = BIGGEN2GEN(gen);
 	}
 
 	/* sanity check - orphino is supposed to be an unused ino!
 	 */
-	assert( ino != orphino );
+	assert(ino != orphino);
 
 	/* don't allow entries named "orphanage" under root to be added
 	 */
-	if ( parh == persp->p_rooth && !strcmp( name, orphname )) {
-		mlog( MLOG_DEBUG | MLOG_TREE,
+	if (parh == persp->p_rooth && !strcmp(name, orphname)) {
+		mlog(MLOG_DEBUG | MLOG_TREE,
 		      "dirent %s %llu %u: "
 		      "skipping (reserved)\n",
 		      name,
 		      ino,
-		      gen );
+		      gen);
 		return RV_OK;
 	}
 
 	/* if the parent is null, just ignore
 	 */
-	if ( parh == NH_NULL ) {
-		mlog( MLOG_DEBUG | MLOG_TREE,
+	if (parh == NH_NULL) {
+		mlog(MLOG_DEBUG | MLOG_TREE,
 		      "dirent %s %llu %u: "
 		      "skipping (null parent)\n",
 		      name,
 		      ino,
-		      gen );
+		      gen);
 		return RV_OK;
 	}
 
 	/* see if one or more links to this ino already exist.
 	 */
-	hardh = link_hardh( ino, gen );
+	hardh = link_hardh(ino, gen);
 
-	if ( hardh != NH_NULL ) {
+	if (hardh != NH_NULL) {
 		node_t *hardp;
-		hardp = Node_map( hardh );
-		if ( hardp->n_flags & NF_ISDIR ) {
+		hardp = Node_map(hardh);
+		if (hardp->n_flags & NF_ISDIR) {
 			nh_t renameh;
 			node_t *renamep;
 			/* REFERENCED */
 			int namebuflen;
 
 			hardp->n_flags |= NF_REFED;
-			if ( hardp->n_parh == persp->p_orphh ) {
+			if (hardp->n_parh == persp->p_orphh) {
 				/* dir now seen as entry
 				 * if in orph but REAL, must be pending rename
 				 */
-				if ( ( hardp->n_flags & NF_REAL )
+				if ((hardp->n_flags & NF_REAL)
 				     &&
-				     hardp->n_lnkh == NH_NULL ) {
-					hardp->n_lnkh = Node_alloc( ino,
+				     hardp->n_lnkh == NH_NULL) {
+					hardp->n_lnkh = Node_alloc(ino,
 								    gen,
 								    NRH_NULL,
 								    DAH_NULL,
-								    0 );
+								    0);
 					if (hardp->n_lnkh == NH_NULL)
 						return RV_ERROR;
 				}
-				if ( hardp->n_lnkh != NH_NULL ) {
-					assert( hardp->n_flags & NF_REAL );
+				if (hardp->n_lnkh != NH_NULL) {
+					assert(hardp->n_flags & NF_REAL);
 					renameh = hardp->n_lnkh;
-					renamep = Node_map( renameh );
-					if ( renamep->n_parh == NH_NULL ) {
-						mlog( MLOG_DEBUG | MLOG_TREE,
+					renamep = Node_map(renameh);
+					if (renamep->n_parh == NH_NULL) {
+						mlog(MLOG_DEBUG | MLOG_TREE,
 						      "dirent %s %llu %u: "
 						      "adopting (dir par)\n",
 						      name,
 						      ino,
-						      gen );
+						      gen);
 						renamep->n_parh = parh;
 					}
-					if ( renamep->n_parh != parh ) {
-						mlog( MLOG_DEBUG | MLOG_TREE,
+					if (renamep->n_parh != parh) {
+						mlog(MLOG_DEBUG | MLOG_TREE,
 						      "dirent %s %llu %u: "
 						      "re-adopting (dir par)\n",
 						      name,
 						      ino,
-						      gen );
+						      gen);
 						renamep->n_parh = parh;
 					}
-					if ( renamep->n_nrh != NRH_NULL ) {
+					if (renamep->n_nrh != NRH_NULL) {
 						namebuflen
 						=
-						namreg_get( renamep->n_nrh,
+						namreg_get(renamep->n_nrh,
 							    tranp->t_namebuf,
-						    sizeof( tranp->t_namebuf ));
-						assert( namebuflen > 0 );
-						if ( strcmp( name,
-							   tranp->t_namebuf )) {
-							mlog( MLOG_DEBUG
+						    sizeof(tranp->t_namebuf));
+						assert(namebuflen > 0);
+						if (strcmp(name,
+							   tranp->t_namebuf)) {
+							mlog(MLOG_DEBUG
 							      |
 							      MLOG_TREE,
 							      "dirent %s "
@@ -935,200 +935,200 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
 							      name,
 							      ino,
 							      gen,
-							     tranp->t_namebuf );
+							     tranp->t_namebuf);
 							namreg_del(
-							       renamep->n_nrh );
+							       renamep->n_nrh);
 							renamep->n_nrh =
 								       NRH_NULL;
 						}
 					}
-					if ( renamep->n_nrh == NRH_NULL ) {
+					if (renamep->n_nrh == NRH_NULL) {
 						renamep->n_nrh
 						=
-						namreg_add( name, namelen );
+						namreg_add(name, namelen);
 						renamep->n_parh = parh;
 					}
-					Node_unmap( renameh, &renamep );
+					Node_unmap(renameh, &renamep);
 				} else {
 					nrh_t nrh;
 
 					hardp->n_flags &= ~NF_NEWORPH;
-					assert( hardp->n_nrh == NRH_NULL );
-					assert( hardp->n_parh != NH_NULL );
-					nrh = disown( hardh );
-					assert( nrh == NRH_NULL );
-					nrh = namreg_add( name, namelen );
-					adopt( parh, hardh, nrh );
-					mlog( MLOG_DEBUG | MLOG_TREE,
+					assert(hardp->n_nrh == NRH_NULL);
+					assert(hardp->n_parh != NH_NULL);
+					nrh = disown(hardh);
+					assert(nrh == NRH_NULL);
+					nrh = namreg_add(name, namelen);
+					adopt(parh, hardh, nrh);
+					mlog(MLOG_DEBUG | MLOG_TREE,
 					      "dirent %s %llu %u: "
 					      "updating (dir)\n",
 					      name,
 					      ino,
-					      gen );
+					      gen);
 				}
 			} else {
-				assert( hardp->n_nrh != NRH_NULL );
+				assert(hardp->n_nrh != NRH_NULL);
 				namebuflen
 				=
-				namreg_get( hardp->n_nrh,
+				namreg_get(hardp->n_nrh,
 					    tranp->t_namebuf,
-					    sizeof( tranp->t_namebuf ));
-				assert( namebuflen > 0 );
-				if ( hardp->n_parh == parh
+					    sizeof(tranp->t_namebuf));
+				assert(namebuflen > 0);
+				if (hardp->n_parh == parh
 				     &&
-				     ! strcmp( tranp->t_namebuf, name )) {
+				     ! strcmp(tranp->t_namebuf, name)) {
 					/* dir seen as entry again
 					 */
-					if ( hardp->n_lnkh != NH_NULL ) {
+					if (hardp->n_lnkh != NH_NULL) {
 						/* rescind rename
 						 */
-						mlog( MLOG_DEBUG | MLOG_TREE,
+						mlog(MLOG_DEBUG | MLOG_TREE,
 						      "dirent %s %llu %u: "
 						      "rescind rename (dir)\n",
 						      name,
 						      ino,
-						      gen );
-						Node_free( &hardp->n_lnkh );
+						      gen);
+						Node_free(&hardp->n_lnkh);
 					} else {
-						mlog( MLOG_DEBUG | MLOG_TREE,
+						mlog(MLOG_DEBUG | MLOG_TREE,
 						      "dirent %s %llu %u: "
 						      "retaining (dir)\n",
 						      name,
 						      ino,
-						      gen );
+						      gen);
 					}
 				} else {
 					/* dir rename
 					 */
 					nh_t renameh;
 					node_t *renamep;
-					if ( hardp->n_lnkh == NH_NULL ) {
-						renameh = Node_alloc( ino,
+					if (hardp->n_lnkh == NH_NULL) {
+						renameh = Node_alloc(ino,
 								      gen,
 								      NRH_NULL,
 								      DAH_NULL,
-								      0 );
+								      0);
 						if (renameh == NH_NULL)
 							return RV_ERROR;
 						hardp->n_lnkh = renameh;
 					} else {
-						mlog( MLOG_DEBUG | MLOG_TREE,
+						mlog(MLOG_DEBUG | MLOG_TREE,
 						      "dirent %s %llu %u: "
 						      "re-renaming\n",
 						      name,
 						      ino,
-						      gen );
+						      gen);
 						renameh = hardp->n_lnkh;
-						renamep = Node_map( renameh );
+						renamep = Node_map(renameh);
 						renamep->n_parh = NH_NULL;
-						if ( renamep->n_nrh
+						if (renamep->n_nrh
 						     !=
-						     NRH_NULL ) {
-						   namreg_del( renamep->n_nrh );
+						     NRH_NULL) {
+						   namreg_del(renamep->n_nrh);
 						}
 						renamep->n_nrh = NRH_NULL;
-						Node_unmap( renameh, &renamep );
+						Node_unmap(renameh, &renamep);
 					}
-					renamep = Node_map( renameh );
-					assert( hardp->n_parh != NH_NULL );
-					if ( hardp->n_parh != parh ) {
+					renamep = Node_map(renameh);
+					assert(hardp->n_parh != NH_NULL);
+					if (hardp->n_parh != parh) {
 						/* different parent
 						 */
 						renamep->n_parh = parh;
-						mlog( MLOG_DEBUG | MLOG_TREE,
+						mlog(MLOG_DEBUG | MLOG_TREE,
 						      "dirent %s %llu %u: "
 						      "renaming (parent)\n",
 						      name,
 						      ino,
-						      gen );
+						      gen);
 					}
-					if ( strcmp( tranp->t_namebuf, name )) {
+					if (strcmp(tranp->t_namebuf, name)) {
 						/* different name
 						 */
 						renamep->n_nrh =
-						    namreg_add( name, namelen );
-						mlog( MLOG_DEBUG | MLOG_TREE,
+						    namreg_add(name, namelen);
+						mlog(MLOG_DEBUG | MLOG_TREE,
 						      "dirent %s %llu %u: "
 						      "renaming (name)\n",
 						      name,
 						      ino,
-						      gen );
+						      gen);
 					}
-					Node_unmap( renameh, &renamep );
+					Node_unmap(renameh, &renamep);
 				}
 			}
 		} else {
 			nh_t matchh;
-			matchh = link_matchh( hardh, parh, name );
-			if ( matchh != NH_NULL ) {
+			matchh = link_matchh(hardh, parh, name);
+			if (matchh != NH_NULL) {
 				/* entry already exists
 				 */
 				node_t *matchp;
-				matchp = Node_map( matchh );
+				matchp = Node_map(matchh);
 				matchp->n_flags |= NF_REFED;
-				Node_unmap( matchh, &matchp );
-				mlog( MLOG_DEBUG | MLOG_TREE,
+				Node_unmap(matchh, &matchp);
+				mlog(MLOG_DEBUG | MLOG_TREE,
 				      "dirent %s %llu %u: "
 				      "retaining (nondir)\n",
 				      name,
 				      ino,
-				      gen );
+				      gen);
 			} else {
 				/* case 5: new hard link
 				 */
 				nrh_t nrh;
 				nh_t linkh;
-				nrh = namreg_add( name, namelen );
-				linkh = Node_alloc( ino,
+				nrh = namreg_add(name, namelen);
+				linkh = Node_alloc(ino,
 						    gen,
 						    NRH_NULL,
 						    DAH_NULL,
-						    NF_REFED );
+						    NF_REFED);
 				if (linkh == NH_NULL)
 					return RV_ERROR;
-				link_in( linkh );
-				adopt( parh, linkh, nrh );
-				mlog( MLOG_DEBUG | MLOG_TREE,
+				link_in(linkh);
+				adopt(parh, linkh, nrh);
+				mlog(MLOG_DEBUG | MLOG_TREE,
 				      "dirent %s %llu %u: "
 				      "adding (link)\n",
 				      name,
 				      ino,
-				      gen );
+				      gen);
 			}
 		}
-		Node_unmap( hardh, &hardp );
+		Node_unmap(hardh, &hardp);
 	} else {
 		/* case 6: new entry
 		 */
 		nrh_t nrh;
-		nrh = namreg_add( name, namelen );
-		hardh = Node_alloc( ino,
+		nrh = namreg_add(name, namelen);
+		hardh = Node_alloc(ino,
 				    gen,
 				    NRH_NULL,
 				    DAH_NULL,
-				    NF_REFED );
+				    NF_REFED);
 		if (hardh == NH_NULL)
 			return RV_ERROR;
-		link_in( hardh );
-		adopt( parh, hardh, nrh );
-		mlog( MLOG_DEBUG | MLOG_TREE,
+		link_in(hardh);
+		adopt(parh, hardh, nrh);
+		mlog(MLOG_DEBUG | MLOG_TREE,
 		      "dirent %s %llu %u: "
 		      "adding (new)\n",
 		      name,
 		      ino,
-		      gen );
+		      gen);
 	}
 	return RV_OK;
 }
 
 /* ARGSUSED */
 void
-tree_enddir( nh_t dirh )
+tree_enddir(nh_t dirh)
 {
 }
 
 bool_t
-tree_subtree_parse( bool_t sensepr, char *path )
+tree_subtree_parse(bool_t sensepr, char *path)
 {
 	nh_t namedh;
 	nh_t parh;
@@ -1140,7 +1140,7 @@ tree_subtree_parse( bool_t sensepr, char *path )
 
 	/* walk the tree down this relative pathname from the root.
 	 */
-	ok = tsi_walkpath( path,
+	ok = tsi_walkpath(path,
 			   NH_NULL,
 			   persp->p_rooth,
 			   0,
@@ -1150,15 +1150,15 @@ tree_subtree_parse( bool_t sensepr, char *path )
 			   &cldh,
 			   &ino,
 			   &isdirpr,
-			   &isselpr );
-	if ( ! ok ) {
+			   &isselpr);
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
 	/* set or clear flag in this node and all of its children,
 	 * and ajust parentage flags.
 	 */
-	selsubtree( namedh, sensepr );
+	selsubtree(namedh, sensepr);
 
 	return BOOL_TRUE;
 }
@@ -1173,25 +1173,25 @@ tree_subtree_parse( bool_t sensepr, char *path )
  * somewhere else in the tree. next, make new directories. then rename
  * directories. finally, create hardlinks from orphanage.
  */
-static bool_t noref_elim_recurse( nh_t parh,
+static bool_t noref_elim_recurse(nh_t parh,
 				  nh_t cldh,
 				  bool_t parrefpr,
 				  char *path1,
-				  char *path2 );
+				  char *path2);
 
-static bool_t mkdirs_recurse( nh_t parh,
+static bool_t mkdirs_recurse(nh_t parh,
 			      nh_t cldh,
-			      char *path );
+			      char *path);
 
-static bool_t rename_dirs( nh_t cldh,
+static bool_t rename_dirs(nh_t cldh,
 			   char *path1,
-			   char *path2 );
+			   char *path2);
 
-static bool_t proc_hardlinks( char *path1,
-			      char *path2 );
+static bool_t proc_hardlinks(char *path1,
+			      char *path2);
 
 bool_t
-tree_post( char *path1, char *path2 )
+tree_post(char *path1, char *path2)
 {
 	node_t *rootp;
 	node_t *orphp;
@@ -1200,63 +1200,63 @@ tree_post( char *path1, char *path2 )
 
 	/* eliminate unreferenced dirents
 	 */
-	if ( ! persp->p_fullpr ) {
-		mlog( MLOG_DEBUG | MLOG_TREE,
-		      "eliminating unreferenced directory entries\n" );
-		rootp = Node_map( persp->p_rooth );
+	if (! persp->p_fullpr) {
+		mlog(MLOG_DEBUG | MLOG_TREE,
+		      "eliminating unreferenced directory entries\n");
+		rootp = Node_map(persp->p_rooth);
 		cldh = rootp->n_cldh;
-		Node_unmap( persp->p_rooth, &rootp );
-		ok = noref_elim_recurse( persp->p_rooth,
+		Node_unmap(persp->p_rooth, &rootp);
+		ok = noref_elim_recurse(persp->p_rooth,
 					 cldh,
 					 BOOL_TRUE,
 					 path1,
-					 path2 );
-		if ( ! ok ) {
+					 path2);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 	}
 
 	/* make new directories
 	 */
-	mlog( MLOG_DEBUG | MLOG_TREE,
-	      "making new directories\n" );
-	rootp = Node_map( persp->p_rooth );
+	mlog(MLOG_DEBUG | MLOG_TREE,
+	      "making new directories\n");
+	rootp = Node_map(persp->p_rooth);
 	cldh = rootp->n_cldh;
-	Node_unmap( persp->p_rooth, &rootp );
-	ok = mkdirs_recurse( persp->p_rooth, cldh, path1 );
-	if ( ! ok ) {
+	Node_unmap(persp->p_rooth, &rootp);
+	ok = mkdirs_recurse(persp->p_rooth, cldh, path1);
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
 #ifdef TREE_CHK
-	assert( tree_chk( ));
+	assert(tree_chk());
 #endif /* TREE_CHK */
 
 	/* rename directories
 	 */
-	if ( ! persp->p_fullpr ) {
-		mlog( MLOG_DEBUG | MLOG_TREE,
-		      "performing directory renames\n" );
-		orphp = Node_map( persp->p_orphh );
+	if (! persp->p_fullpr) {
+		mlog(MLOG_DEBUG | MLOG_TREE,
+		      "performing directory renames\n");
+		orphp = Node_map(persp->p_orphh);
 		cldh = orphp->n_cldh;
-		Node_unmap( persp->p_orphh, &orphp );
-		ok = rename_dirs( cldh, path1, path2 );
-		if ( ! ok ) {
+		Node_unmap(persp->p_orphh, &orphp);
+		ok = rename_dirs(cldh, path1, path2);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 	}
 
 #ifdef TREE_CHK
-	assert( tree_chk( ));
+	assert(tree_chk());
 #endif /* TREE_CHK */
 
 	/* process hard links
 	 */
-	if ( ! persp->p_fullpr ) {
-		mlog( MLOG_DEBUG | MLOG_TREE,
-		      "processing hard links\n" );
-		ok = proc_hardlinks( path1, path2 );
-		if ( ! ok ) {
+	if (! persp->p_fullpr) {
+		mlog(MLOG_DEBUG | MLOG_TREE,
+		      "processing hard links\n");
+		ok = proc_hardlinks(path1, path2);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 	}
@@ -1266,13 +1266,13 @@ tree_post( char *path1, char *path2 )
 
 /* ARGSUSED */
 static bool_t
-noref_elim_recurse( nh_t parh,
+noref_elim_recurse(nh_t parh,
 		    nh_t cldh,
 		    bool_t parrefpr,
 		    char *path1,
-		    char *path2 )
+		    char *path2)
 {
-	while ( cldh != NH_NULL ) {
+	while (cldh != NH_NULL) {
 		node_t *cldp;
 		xfs_ino_t ino;
 		gen_t gen;
@@ -1287,141 +1287,141 @@ noref_elim_recurse( nh_t parh,
 		int rval;
 		bool_t ok;
 
-		cldp = Node_map( cldh );
+		cldp = Node_map(cldh);
 		ino = cldp->n_ino;
 		gen = cldp->n_gen;
 		inorphanagepr = cldp->n_parh == persp->p_orphh;
-		isdirpr = ( cldp->n_flags & NF_ISDIR );
-		isrealpr = ( cldp->n_flags & NF_REAL );
-		isrefpr = ( cldp->n_flags & NF_REFED );
-		isrenamepr = ( isdirpr && cldp->n_lnkh != NH_NULL );
+		isdirpr = (cldp->n_flags & NF_ISDIR);
+		isrealpr = (cldp->n_flags & NF_REAL);
+		isrefpr = (cldp->n_flags & NF_REFED);
+		isrenamepr = (isdirpr && cldp->n_lnkh != NH_NULL);
 		renameh = cldp->n_lnkh;
 		grandcldh = cldp->n_cldh;
 		nextcldh = cldp->n_sibh;
 
 #ifdef TREE_DEBUG
-		ok = Node2path( cldh, path1, _("noref debug") );
-		mlog( MLOG_TRACE | MLOG_TREE,
+		ok = Node2path(cldh, path1, _("noref debug"));
+		mlog(MLOG_TRACE | MLOG_TREE,
 		      "noref: %s: isdir = %d, isreal = %d, isref = %d, "
 		      "isrenamedir = %d\n",
-		      path1, isdirpr, isrealpr, isrefpr, isrenamepr );
+		      path1, isdirpr, isrealpr, isrefpr, isrenamepr);
 #endif
 
-		Node_unmap( cldh, &cldp );
+		Node_unmap(cldh, &cldp);
 
-		if ( isdirpr ) {
+		if (isdirpr) {
 			bool_t ok;
 
-			ok = noref_elim_recurse( cldh,
+			ok = noref_elim_recurse(cldh,
 						 grandcldh,
 						 isrefpr,
 						 path1,
-						 path2 );
+						 path2);
 						/* RECURSION */
-			if ( ! ok ) {
+			if (! ok) {
 				return BOOL_FALSE;
 			}
 
-			if ( inorphanagepr ) {
+			if (inorphanagepr) {
 				cldh = nextcldh;
 				continue;
 			}
 
-			if ( ! isrefpr ) {
+			if (! isrefpr) {
 				nrh_t nrh;
 
-				assert( ! isrenamepr );
-				if ( isrealpr ) {
-					ok = Node2path( cldh, path1, _("rmdir") );
-					if ( ! ok ) {
+				assert(! isrenamepr);
+				if (isrealpr) {
+					ok = Node2path(cldh, path1, _("rmdir"));
+					if (! ok) {
 						cldh = nextcldh;
 						continue;
 					}
-					mlog( MLOG_TRACE | MLOG_TREE,
+					mlog(MLOG_TRACE | MLOG_TREE,
 					      "rmdir %s\n",
-					      path1 );
-					rval = rmdir( path1 );
-					if ( rval ) {
-						mlog( MLOG_NORMAL
+					      path1);
+					rval = rmdir(path1);
+					if (rval) {
+						mlog(MLOG_NORMAL
 						      |
 						      MLOG_WARNING
 						      |
 						      MLOG_TREE, _(
 						    "unable to rmdir %s: %s\n"),
 						     path1,
-						     strerror( errno ));
+						     strerror(errno));
 						cldh = nextcldh;
 						continue;
 					}
 				}
-				nrh = disown( cldh );
-				assert( nrh != NRH_NULL );
-				namreg_del( nrh );
-				link_out( cldh );
-				Node_free( &cldh );
+				nrh = disown(cldh);
+				assert(nrh != NRH_NULL);
+				namreg_del(nrh);
+				link_out(cldh);
+				Node_free(&cldh);
 			}
 
-			if ( isrenamepr ) {
+			if (isrenamepr) {
 				nrh_t nrh;
 				node_t *renamep;
 
-				assert( isrefpr );
-				assert( isrealpr );
-				ok = Node2path( cldh,
+				assert(isrefpr);
+				assert(isrealpr);
+				ok = Node2path(cldh,
 						path1,
-						_("tmp dir rename src") );
-				if ( ! ok ) {
+						_("tmp dir rename src"));
+				if (! ok) {
 					cldh = nextcldh;
 					continue;
 				}
-				nrh = disown( cldh );
-				assert( nrh != NRH_NULL );
-				adopt( persp->p_orphh, cldh, NRH_NULL );
-				ok = Node2path( cldh,
+				nrh = disown(cldh);
+				assert(nrh != NRH_NULL);
+				adopt(persp->p_orphh, cldh, NRH_NULL);
+				ok = Node2path(cldh,
 						path2,
-						_("tmp dir rename dst") );
-				if ( ! ok ) {
+						_("tmp dir rename dst"));
+				if (! ok) {
 					/* REFERENCED */
 					nrh_t dummynrh;
-					dummynrh = disown( cldh );
-					assert( dummynrh == NRH_NULL );
-					adopt( parh, cldh, nrh );
+					dummynrh = disown(cldh);
+					assert(dummynrh == NRH_NULL);
+					adopt(parh, cldh, nrh);
 					cldh = nextcldh;
 					continue;
 				}
-				mlog( MLOG_TRACE | MLOG_TREE,
+				mlog(MLOG_TRACE | MLOG_TREE,
 				      "rename dir %s to %s\n",
 				      path1,
-				      path2 );
-				rval = rename( path1, path2 );
-				if ( rval ) {
+				      path2);
+				rval = rename(path1, path2);
+				if (rval) {
 					/* REFERENCED */
 					nrh_t dummynrh;
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "unable to rename dir %s "
 					      "to dir %s: %s\n"),
 					      path1,
 					      path2,
-					      strerror( errno ));
-					dummynrh = disown( cldh );
-					assert( dummynrh == NRH_NULL );
-					adopt( parh, cldh, nrh );
+					      strerror(errno));
+					dummynrh = disown(cldh);
+					assert(dummynrh == NRH_NULL);
+					adopt(parh, cldh, nrh);
 					cldh = nextcldh;
 					continue;
 				}
-				cldp = Node_map( cldh );
-				renamep = Node_map( renameh );
-				if ( renamep->n_nrh == NRH_NULL ) {
+				cldp = Node_map(cldh);
+				renamep = Node_map(renameh);
+				if (renamep->n_nrh == NRH_NULL) {
 					renamep->n_nrh = nrh;
 				} else {
-					namreg_del( nrh );
+					namreg_del(nrh);
 				}
-				if ( renamep->n_parh == NH_NULL ) {
+				if (renamep->n_parh == NH_NULL) {
 					renamep->n_parh = parh;
 				}
 				cldp->n_flags |= NF_NEWORPH;
-				Node_unmap( renameh, &renamep );
-				Node_unmap( cldh, &cldp );
+				Node_unmap(renameh, &renamep);
+				Node_unmap(cldh, &cldp);
 			}
 		} else  {
 			/* determine if we can unlink this node.
@@ -1434,18 +1434,18 @@ noref_elim_recurse( nh_t parh,
 			bool_t mustorphpr;
 			bool_t canunlinkpr;
 
-			if ( inorphanagepr ) {
+			if (inorphanagepr) {
 				cldh = nextcldh;
 				continue;
 			}
 
 			mustorphpr = BOOL_FALSE;
 			canunlinkpr = ! isrefpr && ! isrealpr;
-			if ( ! isrefpr && isrealpr ) {
+			if (! isrefpr && isrealpr) {
 				nh_t hardh;
 				bool_t neededpr;
-				hardh = link_hardh( ino, gen );
-				assert( hardh != NH_NULL );
+				hardh = link_hardh(ino, gen);
+				assert(hardh != NH_NULL);
 				canunlinkpr = BOOL_FALSE;
 				neededpr = BOOL_FALSE;
 				/* tes@sgi.com:
@@ -1454,26 +1454,26 @@ noref_elim_recurse( nh_t parh,
 				 * so that we will break out first
 				 * if we find a REAL file.
 				 */
-				while ( hardh != NH_NULL ) {
+				while (hardh != NH_NULL) {
 					node_t *hardp;
 					bool_t hardisrefpr;
 					bool_t hardisrealpr;
 					nh_t nexthardh;
 
-					hardp = Node_map( hardh );
+					hardp = Node_map(hardh);
 					hardisrefpr = hardp->n_flags & NF_REFED;
 					hardisrealpr = hardp->n_flags & NF_REAL;
 					nexthardh = hardp->n_lnkh;
-					Node_unmap( hardh, &hardp );
-					if ( hardh != cldh && hardisrealpr ) {
+					Node_unmap(hardh, &hardp);
+					if (hardh != cldh && hardisrealpr) {
 						break;
 					}
-					if ( hardisrefpr && ! hardisrealpr ) {
+					if (hardisrefpr && ! hardisrealpr) {
 						neededpr = BOOL_TRUE;
 					}
 					hardh = nexthardh;
 				}
-				if ( neededpr ) {
+				if (neededpr) {
 					mustorphpr = BOOL_TRUE;
 				}
 				else {
@@ -1481,74 +1481,74 @@ noref_elim_recurse( nh_t parh,
 				}
 			}
 
-			if ( mustorphpr ) {
+			if (mustorphpr) {
 				/* rename file to orphanage */
 				nrh_t nrh;
-				assert( ! canunlinkpr );
-				ok = Node2path( cldh,
+				assert(! canunlinkpr);
+				ok = Node2path(cldh,
 						path1,
-						_("tmp nondir rename src") );
-				if ( ! ok ) {
+						_("tmp nondir rename src"));
+				if (! ok) {
 					cldh = nextcldh;
 					continue;
 				}
-				nrh = disown( cldh );
-				assert( nrh != NRH_NULL );
-				adopt( persp->p_orphh, cldh, NRH_NULL );
-				ok = Node2path( cldh,
+				nrh = disown(cldh);
+				assert(nrh != NRH_NULL);
+				adopt(persp->p_orphh, cldh, NRH_NULL);
+				ok = Node2path(cldh,
 						path2,
-						_("tmp nondir rename dst") );
-				if ( ! ok ) {
+						_("tmp nondir rename dst"));
+				if (! ok) {
 					/* REFERENCED */
 					nrh_t dummynrh;
-					dummynrh = disown( cldh );
-					assert( dummynrh == NRH_NULL );
-					adopt( parh, cldh, nrh );
+					dummynrh = disown(cldh);
+					assert(dummynrh == NRH_NULL);
+					adopt(parh, cldh, nrh);
 					cldh = nextcldh;
 					continue;
 				}
-				mlog( MLOG_TRACE | MLOG_TREE,
+				mlog(MLOG_TRACE | MLOG_TREE,
 				      "rename nondir %s to %s\n",
 				      path1,
-				      path2 );
-				rval = rename( path1, path2 );
-				if ( rval ) {
+				      path2);
+				rval = rename(path1, path2);
+				if (rval) {
 					/* REFERENCED */
 					nrh_t dummynrh;
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "unable to rename nondir %s "
 					      "to nondir %s: %s\n"),
 					      path1,
 					      path2,
-					      strerror( errno ));
-					dummynrh = disown( cldh );
-					assert( dummynrh == NRH_NULL );
-					adopt( parh, cldh, nrh );
+					      strerror(errno));
+					dummynrh = disown(cldh);
+					assert(dummynrh == NRH_NULL);
+					adopt(parh, cldh, nrh);
 					cldh = nextcldh;
 					continue;
 				}
-				namreg_del( nrh );
-				cldp = Node_map( cldh );
+				namreg_del(nrh);
+				cldp = Node_map(cldh);
 				cldp->n_flags |= NF_NEWORPH;
-				Node_unmap( cldh, &cldp );
+				Node_unmap(cldh, &cldp);
 			}
-			if ( canunlinkpr ) {
+			if (canunlinkpr) {
 				/* REFERENCED */
 				nrh_t nrh;
 
-				assert( ! mustorphpr );
-				if ( isrealpr ) {
-					ok = Node2path( cldh, path1, _("rmdir") );
-					if ( ! ok ) {
+				assert(! mustorphpr);
+				if (isrealpr) {
+					ok = Node2path(cldh, path1, _("rmdir"));
+					if (! ok) {
 						cldh = nextcldh;
 						continue;
 					}
-					mlog( MLOG_TRACE | MLOG_TREE,
+					mlog(MLOG_TRACE | MLOG_TREE,
 					      "unlink %s\n",
-					      path1 );
-					rval = unlink( path1 );
-					if ( rval ) {
-						mlog( MLOG_NORMAL
+					      path1);
+					rval = unlink(path1);
+					if (rval) {
+						mlog(MLOG_NORMAL
 						      |
 						      MLOG_WARNING
 						      |
@@ -1556,15 +1556,15 @@ noref_elim_recurse( nh_t parh,
 						     "unable to unlink nondir "
 						     "%s: %s\n"),
 						     path1,
-						     strerror( errno ));
+						     strerror(errno));
 						cldh = nextcldh;
 						continue;
 					}
 				}
-				nrh = disown( cldh );
-				assert( nrh != NRH_NULL );
-				link_out( cldh );
-				Node_free( &cldh );
+				nrh = disown(cldh);
+				assert(nrh != NRH_NULL);
+				link_out(cldh);
+				Node_free(&cldh);
 			}
 		}
 
@@ -1578,9 +1578,9 @@ noref_elim_recurse( nh_t parh,
 
 /* ARGSUSED */
 static bool_t
-mkdirs_recurse( nh_t parh, nh_t cldh, char *path )
+mkdirs_recurse(nh_t parh, nh_t cldh, char *path)
 {
-	while ( cldh != NH_NULL ) {
+	while (cldh != NH_NULL) {
 		node_t *cldp;
 		bool_t isdirpr;
 		bool_t isselpr;
@@ -1589,53 +1589,53 @@ mkdirs_recurse( nh_t parh, nh_t cldh, char *path )
 		nh_t grandcldh;
 		nh_t nextcldh;
 
-		cldp = Node_map( cldh );
-		isdirpr = ( cldp->n_flags & NF_ISDIR );
-		isrealpr = ( cldp->n_flags & NF_REAL );
-		isrefpr = ( cldp->n_flags & NF_REFED );
-		isselpr = ( cldp->n_flags & NF_SUBTREE );
+		cldp = Node_map(cldh);
+		isdirpr = (cldp->n_flags & NF_ISDIR);
+		isrealpr = (cldp->n_flags & NF_REAL);
+		isrefpr = (cldp->n_flags & NF_REFED);
+		isselpr = (cldp->n_flags & NF_SUBTREE);
 		grandcldh = cldp->n_cldh;
 		nextcldh = cldp->n_sibh;
-		Node_unmap( cldh, &cldp );
+		Node_unmap(cldh, &cldp);
 
 		/* if needed, create a directory and update real flag
 		 */
-		if ( isdirpr && ! isrealpr && isrefpr && isselpr ) {
+		if (isdirpr && ! isrealpr && isrefpr && isselpr) {
 			int rval;
 
-			if ( ! Node2path( cldh, path, _("makedir") )) {
+			if (! Node2path(cldh, path, _("makedir"))) {
 				cldh = nextcldh;
 				continue;
 			}
-			if ( tranp->t_toconlypr ) {
+			if (tranp->t_toconlypr) {
 				rval = 0;
 			} else {
-				mlog( MLOG_TRACE | MLOG_TREE,
+				mlog(MLOG_TRACE | MLOG_TREE,
 				      "mkdir %s\n",
-				      path );
-				rval = mkdir( path, S_IRWXU );
+				      path);
+				rval = mkdir(path, S_IRWXU);
 			}
-			if ( rval && errno != EEXIST ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+			if (rval && errno != EEXIST) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 				      "mkdir %s failed: %s\n"),
 				      path,
-				      strerror( errno ));
+				      strerror(errno));
 
 			} else {
-				cldp = Node_map( cldh );
+				cldp = Node_map(cldh);
 				cldp->n_flags |= NF_REAL;
-				Node_unmap( cldh, &cldp );
+				Node_unmap(cldh, &cldp);
 				isrealpr = BOOL_TRUE;
 			}
 		}
 
 		/* if a real selected directory, recurse
 		 */
-		if ( isdirpr && isrealpr && isselpr ) {
+		if (isdirpr && isrealpr && isselpr) {
 			bool_t ok;
-			ok = mkdirs_recurse( cldh, grandcldh, path );
+			ok = mkdirs_recurse(cldh, grandcldh, path);
 							/* RECURSION */
-			if ( ! ok ) {
+			if (! ok) {
 				return BOOL_FALSE;
 			}
 		}
@@ -1649,11 +1649,11 @@ mkdirs_recurse( nh_t parh, nh_t cldh, char *path )
 }
 
 static bool_t
-rename_dirs( nh_t cldh,
+rename_dirs(nh_t cldh,
 	     char *path1,
-	     char *path2 )
+	     char *path2)
 {
-	while ( cldh != NH_NULL ) {
+	while (cldh != NH_NULL) {
 		node_t *cldp;
 		/* REFERENCED */
 		nh_t parh;
@@ -1664,68 +1664,68 @@ rename_dirs( nh_t cldh,
 		nh_t newparh;
 		nh_t newnrh;
 
-		cldp = Node_map( cldh );
+		cldp = Node_map(cldh);
 		parh = cldp->n_parh;
 		isdirpr = cldp->n_flags & NF_ISDIR;
 		renameh = cldp->n_lnkh;
 		isrenamepr = isdirpr && renameh != NH_NULL;
 		nextcldh = cldp->n_sibh;
-		Node_unmap( cldh, &cldp );
-		assert( parh == persp->p_orphh );
+		Node_unmap(cldh, &cldp);
+		assert(parh == persp->p_orphh);
 
-		if ( isrenamepr ) {
+		if (isrenamepr) {
 			node_t *renamep;
 			int rval;
 			/* REFERENCED */
 			nrh_t dummynrh;
 			bool_t ok;
 
-			renamep = Node_map( renameh );
+			renamep = Node_map(renameh);
 			newparh = renamep->n_parh;
 			newnrh = renamep->n_nrh;
-			Node_unmap( renameh, &renamep );
-			ok = Node2path( cldh, path1, _("rename dir") );
-			if ( ! ok ) {
+			Node_unmap(renameh, &renamep);
+			ok = Node2path(cldh, path1, _("rename dir"));
+			if (! ok) {
 				cldh = nextcldh;
 				continue;
 			}
-			dummynrh = disown( cldh );
-			assert( dummynrh == NRH_NULL );
-			adopt( newparh, cldh, newnrh );
-			ok = Node2path( cldh, path2, _("rename dir") );
-			if ( ! ok ) {
-				dummynrh = disown( cldh );
-				assert( dummynrh == newnrh );
-				adopt( persp->p_orphh, cldh, NRH_NULL );
-				cldp = Node_map( cldh );
+			dummynrh = disown(cldh);
+			assert(dummynrh == NRH_NULL);
+			adopt(newparh, cldh, newnrh);
+			ok = Node2path(cldh, path2, _("rename dir"));
+			if (! ok) {
+				dummynrh = disown(cldh);
+				assert(dummynrh == newnrh);
+				adopt(persp->p_orphh, cldh, NRH_NULL);
+				cldp = Node_map(cldh);
 				cldp->n_nrh = NRH_NULL;
-				Node_unmap( cldh, &cldp );
+				Node_unmap(cldh, &cldp);
 				cldh = nextcldh;
 				continue;
 			}
-			mlog( MLOG_TRACE | MLOG_TREE,
+			mlog(MLOG_TRACE | MLOG_TREE,
 			      "rename dir %s to %s\n",
 			      path1,
-			      path2 );
-			rval = rename( path1, path2 );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			      path2);
+			rval = rename(path1, path2);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "unable to rename dir %s "
 				      "to dir %s: %s\n"),
 				      path1,
 				      path2,
-				      strerror( errno ));
-				dummynrh = disown( cldh );
-				assert( dummynrh == newnrh );
-				adopt( persp->p_orphh, cldh, NRH_NULL );
+				      strerror(errno));
+				dummynrh = disown(cldh);
+				assert(dummynrh == newnrh);
+				adopt(persp->p_orphh, cldh, NRH_NULL);
 				cldh = nextcldh;
 				continue;
 			}
-			cldp = Node_map( cldh );
+			cldp = Node_map(cldh);
 			cldp->n_flags &= ~NF_NEWORPH;
 			cldp->n_lnkh = NH_NULL;
-			Node_unmap( cldh, &cldp );
-			Node_free( &renameh );
+			Node_unmap(cldh, &cldp);
+			Node_free(&renameh);
 		}
 
 		/* next!
@@ -1740,17 +1740,17 @@ rename_dirs( nh_t cldh,
  * ever returns FALSE;
  */
 rv_t
-tree_cb_links( xfs_ino_t ino,
+tree_cb_links(xfs_ino_t ino,
 	       gen_t gen,
 	       int32_t ctime,
 	       int32_t mtime,
-	       bool_t ( * funcp )( void *contextp,
+	       bool_t (* funcp)(void *contextp,
 				   bool_t linkpr,
 				   char *path1,
-				   char *path2 ),
+				   char *path2),
 	       void *contextp,
 	       char *path1,
-	       char *path2 )
+	       char *path2)
 {
 	nh_t hardh;
 	nh_t nh;
@@ -1758,57 +1758,57 @@ tree_cb_links( xfs_ino_t ino,
 	bool_t ok;
 	int  rval;
 
-	if ( persp->p_truncategenpr ) {
-		gen = BIGGEN2GEN( gen );
+	if (persp->p_truncategenpr) {
+		gen = BIGGEN2GEN(gen);
 	}
 
 	/* find the hardhead
 	 */
-	hardh = link_hardh( ino, gen );
+	hardh = link_hardh(ino, gen);
 
 	/* loop through all hard links, attempting to restore/link
 	 */
 	path = path1;
-	for ( nh = hardh ; nh != NH_NULL ; nh = link_nexth( nh )) {
+	for (nh = hardh ; nh != NH_NULL ; nh = link_nexth(nh)) {
 		node_t *np;
 		u_char_t flags;
 		char *reasonstr;
 
 		/* get the node flags
 		 */
-		np = Node_map( nh );
+		np = Node_map(nh);
 		flags = np->n_flags;
-		Node_unmap( nh, &np );
+		Node_unmap(nh, &np);
 
 		/* build a pathname
 		 */
-		ok = Node2path( nh, path, _("restore") );
-		if ( ! ok ) {
+		ok = Node2path(nh, path, _("restore"));
+		if (! ok) {
 			continue;
 		}
 
 		/* skip if not in selected subtree
 		 */
-		if ( ! ( flags & NF_SUBTREE )) {
-			mlog( (MLOG_NITTY + 1) | MLOG_TREE,
+		if (! (flags & NF_SUBTREE)) {
+			mlog((MLOG_NITTY + 1) | MLOG_TREE,
 			      "skipping %s (ino %llu gen %u): %s\n",
 			      path,
 			      ino,
 			      gen,
-			      "not in selected subtree" );
+			      "not in selected subtree");
 			continue;
 		}
 
 		/* don't restore into the housekeeping directory
 		 */
-		if ( path_beginswith( path, tranp->t_hkdir )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+		if (path_beginswith(path, tranp->t_hkdir)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 			      "cannot restore %s (ino %llu gen %u): "
 			      "pathname contains %s\n"),
 			      path,
 			      ino,
 			      gen,
-			      tranp->t_hkdir );
+			      tranp->t_hkdir);
 			continue;
 		}
 
@@ -1817,24 +1817,24 @@ tree_cb_links( xfs_ino_t ino,
 		 * so we won't check again. in fact, can't check again
 		 * since restore changes the answer.
 		 */
-		if ( ! ( flags & NF_WRITTEN )) {
+		if (! (flags & NF_WRITTEN)) {
 			bool_t exists;
-			if ( ! content_overwrite_ok( path,
+			if (! content_overwrite_ok(path,
 						     ctime,
 						     mtime,
 						     &reasonstr,
-						     &exists )) {
-				mlog( MLOG_TRACE | MLOG_TREE,
+						     &exists)) {
+				mlog(MLOG_TRACE | MLOG_TREE,
 				      "skipping %s (ino %llu gen %u): %s\n",
 				      path,
 				      ino,
 				      gen,
-				      reasonstr );
+				      reasonstr);
 				continue;
 			} else {
-				np = Node_map( nh );
+				np = Node_map(nh);
 				np->n_flags |= NF_WRITTEN;
-				Node_unmap( nh, &np );
+				Node_unmap(nh, &np);
 
 				/*
 				 * We're the first stream to restore this file.
@@ -1842,17 +1842,17 @@ tree_cb_links( xfs_ino_t ino,
 				 * that may have been set since the dump was
 				 * taken.
 				 */
-				if ( ! tranp->t_toconlypr && exists ) {
-					rval = unlink( path );
-					if ( rval && errno != ENOENT ) {
-						mlog( MLOG_NORMAL |
+				if (! tranp->t_toconlypr && exists) {
+					rval = unlink(path);
+					if (rval && errno != ENOENT) {
+						mlog(MLOG_NORMAL |
 						      MLOG_WARNING, _(
 						      "unable to unlink "
 						      "current file prior to "
 						      "restore: "
 						      "%s: %s: discarding\n"),
 						      path,
-						      strerror( errno ));
+						      strerror(errno));
 						continue;
 					}
 				}
@@ -1862,30 +1862,30 @@ tree_cb_links( xfs_ino_t ino,
 		/* call callback to restore file / create hard link.
 		 * returns !ok if should abort.
 		 */
-		if ( path == path2 ) {
-			mlog( MLOG_TRACE | MLOG_TREE,
+		if (path == path2) {
+			mlog(MLOG_TRACE | MLOG_TREE,
 			      "link %s to %s (%llu %u)\n",
 			      path1,
 			      path2,
 			      ino,
-			      gen );
+			      gen);
 		} else {
-			mlog( MLOG_TRACE | MLOG_TREE,
+			mlog(MLOG_TRACE | MLOG_TREE,
 			      "restoring %s (%llu %u)\n",
 			      path1,
 			      ino,
-			      gen );
+			      gen);
 		}
-		ok = ( * funcp )( contextp, path == path2, path1, path2 );
-		if ( ! ok ) {
+		ok = (* funcp)(contextp, path == path2, path1, path2);
+		if (! ok) {
 			return RV_NOTOK;
 		}
 
 		/* set flag, indicating node is now real
 		 */
-		np = Node_map( nh );
+		np = Node_map(nh);
 		np->n_flags |= NF_REAL;
-		Node_unmap( nh, &np );
+		Node_unmap(nh, &np);
 
 		/* switch to second path buffer, for link paths
 		 */
@@ -1896,8 +1896,8 @@ tree_cb_links( xfs_ino_t ino,
 	/* if not yet peeled from tape, do so: place in orphanage if
 	 * no references found (i.e., hard link list empty).
 	 */
-	if ( path == path1 ) {
-		if ( hardh != NH_NULL || persp->p_ignoreorphpr ) {
+	if (path == path1) {
+		if (hardh != NH_NULL || persp->p_ignoreorphpr) {
 			/*
 			 * The file is referenced so the path is
 			 * valid.  This means that if path begins
@@ -1923,19 +1923,19 @@ tree_cb_links( xfs_ino_t ino,
 			 * make the whole tree of data
 			 * unreachable.  pv698761
 			 */
-			if ( persp->p_ignoreorphpr || (strncmp(ORPH_NAME, path,
+			if (persp->p_ignoreorphpr || (strncmp(ORPH_NAME, path,
 					    strlen(ORPH_NAME)) != 0)) {
-				mlog( MLOG_DEBUG | MLOG_TREE,
+				mlog(MLOG_DEBUG | MLOG_TREE,
 				      "discarding %llu %u\n",
 				      ino,
-				      gen );
-				ok = ( * funcp )( contextp, BOOL_FALSE, 0, 0 );
-				if ( ! ok ) {
+				      gen);
+				ok = (* funcp)(contextp, BOOL_FALSE, 0, 0);
+				if (! ok) {
 					return RV_NOTOK;
 				}
 			} else {
 
-				if ( ! tranp->t_toconlypr ) {
+				if (! tranp->t_toconlypr) {
 					char *dir;
 					char tmp[PATH_MAX];
 
@@ -1947,40 +1947,40 @@ tree_cb_links( xfs_ino_t ino,
 				mlog (MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
 				      "ino %llu salvaging file,"
 				      " placing in %s\n"), ino, path1);
-				ok = ( * funcp )( contextp, path == path2,
-					path1, path2 );
-				if ( ! ok ) {
+				ok = (* funcp)(contextp, path == path2,
+					path1, path2);
+				if (! ok) {
 					return RV_NOTOK;
 				}
 			}
 		} else {
-			mlog( MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
+			mlog(MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
 			      "ino %llu gen %u not referenced: "
 			      "placing in orphanage\n"),
 			      ino,
-			      gen );
-			nh = Node_alloc( ino,
+			      gen);
+			nh = Node_alloc(ino,
 					 gen,
 					 NRH_NULL,
 					 DAH_NULL,
-					 NF_REAL | NF_NEWORPH );
+					 NF_REAL | NF_NEWORPH);
 			if (nh == NH_NULL) {
-				mlog( MLOG_ERROR | MLOG_TREE, _(
+				mlog(MLOG_ERROR | MLOG_TREE, _(
 				"node allocation failed when placing ino %llu"
 				" in orphanage\n"), ino);
 				return RV_ERROR; /* allocation failed */
 			}
-			link_in( nh );
-			adopt( persp->p_orphh, nh, NRH_NULL );
-			ok = Node2path( nh, path1, _("orphan") );
-			assert( ok );
-			( void )( * funcp )( contextp, BOOL_FALSE, path1,path2);
+			link_in(nh);
+			adopt(persp->p_orphh, nh, NRH_NULL);
+			ok = Node2path(nh, path1, _("orphan"));
+			assert(ok);
+			(void)(* funcp)(contextp, BOOL_FALSE, path1,path2);
 		}
 	}
 	return RV_OK;
 }
 
-/* uses flags cleared during directory restore (NF_DUMPEDDIR and NF_REFED )
+/* uses flags cleared during directory restore (NF_DUMPEDDIR and NF_REFED)
  * to determine what directory entries are no longer needed. this can
  * be done because whenever a directory chenges, it and all of its current
  * entries are dumped. so if an entry is dumped which is a dir, but that
@@ -1991,74 +1991,74 @@ tree_cb_links( xfs_ino_t ino,
  * clear the REFED flags.
  */
 
-static void tree_adjref_recurse( nh_t cldh,
+static void tree_adjref_recurse(nh_t cldh,
 				 bool_t pardumpedpr,
-				 bool_t parrefedpr );
+				 bool_t parrefedpr);
 
 bool_t
-tree_adjref( void )
+tree_adjref(void)
 {
-	tree_adjref_recurse( persp->p_rooth, BOOL_FALSE, BOOL_TRUE );
+	tree_adjref_recurse(persp->p_rooth, BOOL_FALSE, BOOL_TRUE);
 	return BOOL_TRUE;
 }
 
 static void
-tree_adjref_recurse( nh_t cldh,
+tree_adjref_recurse(nh_t cldh,
 		       bool_t pardumpedpr,
-		       bool_t parrefedpr )
+		       bool_t parrefedpr)
 {
 	nh_t grandcldh;
 	bool_t clddumpedpr;
 	bool_t cldrefedpr;
 	{
 		node_t *cldp;
-		cldp = Node_map( cldh );
-		if ( ! pardumpedpr && parrefedpr ) {
+		cldp = Node_map(cldh);
+		if (! pardumpedpr && parrefedpr) {
 			cldp->n_flags |= NF_REFED;
 		}
-		clddumpedpr = ( int )cldp->n_flags & NF_DUMPEDDIR;
-		cldrefedpr = ( int )cldp->n_flags & NF_REFED;
+		clddumpedpr = (int)cldp->n_flags & NF_DUMPEDDIR;
+		cldrefedpr = (int)cldp->n_flags & NF_REFED;
 		grandcldh = cldp->n_cldh;
-		Node_unmap( cldh, &cldp  );
+		Node_unmap(cldh, &cldp);
 	}
-	while ( grandcldh != NH_NULL ) {
+	while (grandcldh != NH_NULL) {
 		node_t *grandcldp;
 		nh_t nextgrandcldh;
-		tree_adjref_recurse( grandcldh, clddumpedpr, cldrefedpr );
+		tree_adjref_recurse(grandcldh, clddumpedpr, cldrefedpr);
 								/* RECURSION */
-		grandcldp = Node_map( grandcldh );
+		grandcldp = Node_map(grandcldh);
 		nextgrandcldh = grandcldp->n_sibh;
-		Node_unmap( grandcldh, &grandcldp  );
+		Node_unmap(grandcldh, &grandcldp);
 		grandcldh = nextgrandcldh;
 	}
 }
 
-static bool_t tree_extattr_recurse( nh_t parh,
+static bool_t tree_extattr_recurse(nh_t parh,
 				    nh_t cldh,
-				    bool_t ( * cbfunc )( char *path,
-							 dah_t dah ),
-				    char *path );
+				    bool_t (* cbfunc)(char *path,
+							 dah_t dah),
+				    char *path);
 
 bool_t
-tree_extattr( bool_t ( * cbfunc )( char *path, dah_t dah ), char *path )
+tree_extattr(bool_t (* cbfunc)(char *path, dah_t dah), char *path)
 {
 	node_t *rootp;
 	nh_t cldh;
 	bool_t ok;
 
-	rootp = Node_map( persp->p_rooth );
+	rootp = Node_map(persp->p_rooth);
 	cldh = rootp->n_cldh;
-	Node_unmap( persp->p_rooth, &rootp );
-	ok = tree_extattr_recurse( persp->p_rooth, cldh, cbfunc, path );
+	Node_unmap(persp->p_rooth, &rootp);
+	ok = tree_extattr_recurse(persp->p_rooth, cldh, cbfunc, path);
 
 	return ok;
 }
 
 static bool_t
-tree_extattr_recurse( nh_t parh,
+tree_extattr_recurse(nh_t parh,
 		      nh_t cldh,
-		      bool_t ( * cbfunc )( char *path, dah_t dah ),
-		      char *path )
+		      bool_t (* cbfunc)(char *path, dah_t dah),
+		      char *path)
 {
 	node_t *parp;
 	dah_t dah;
@@ -2066,7 +2066,7 @@ tree_extattr_recurse( nh_t parh,
 
 	/* first update all children
 	 */
-	while ( cldh != NH_NULL ) {
+	while (cldh != NH_NULL) {
 		node_t *cldp;
 		bool_t isdirpr;
 		bool_t isselpr;
@@ -2074,24 +2074,24 @@ tree_extattr_recurse( nh_t parh,
 		nh_t grandcldh;
 		nh_t nextcldh;
 
-		cldp = Node_map( cldh );
-		isdirpr = ( cldp->n_flags & NF_ISDIR );
-		isrealpr = ( cldp->n_flags & NF_REAL );
-		isselpr = ( cldp->n_flags & NF_SUBTREE );
+		cldp = Node_map(cldh);
+		isdirpr = (cldp->n_flags & NF_ISDIR);
+		isrealpr = (cldp->n_flags & NF_REAL);
+		isselpr = (cldp->n_flags & NF_SUBTREE);
 		grandcldh = cldp->n_cldh;
 		nextcldh = cldp->n_sibh;
-		Node_unmap( cldh, &cldp );
+		Node_unmap(cldh, &cldp);
 
 		/* if a real selected directory, recurse
 		 */
-		if ( isdirpr && isrealpr && isselpr ) {
+		if (isdirpr && isrealpr && isselpr) {
 			bool_t ok;
-			ok = tree_extattr_recurse( cldh,
+			ok = tree_extattr_recurse(cldh,
 						   grandcldh,
 						   cbfunc,
-						   path );
+						   path);
 							/* RECURSION */
-			if ( ! ok ) {
+			if (! ok) {
 				return BOOL_FALSE;
 			}
 		}
@@ -2103,17 +2103,17 @@ tree_extattr_recurse( nh_t parh,
 
 	/* now update self
 	 */
-	parp = Node_map( parh );
+	parp = Node_map(parh);
 	dah = parp->n_dah;
-	Node_unmap( parh, &parp );
-	if ( ! Node2path( parh, path, _("set dir extattr") )) {
+	Node_unmap(parh, &parp);
+	if (! Node2path(parh, path, _("set dir extattr"))) {
 		mlog (MLOG_NORMAL | MLOG_WARNING | MLOG_TREE,  _(
 		      "tree_extattr_recurse: Could not convert node to "
 		      "path for %s\n"), path);
 		return BOOL_TRUE;
 	}
-	if ( dah != DAH_NULL ) {
-		ok = ( * cbfunc )( path, dah );
+	if (dah != DAH_NULL) {
+		ok = (* cbfunc)(path, dah);
 	} else {
 		ok = BOOL_TRUE;
 	}
@@ -2129,10 +2129,10 @@ struct phcb {
 
 typedef struct phcb phcb_t;
 
-static bool_t proc_hardlinks_cb( void *contextp, nh_t hardheadh );
+static bool_t proc_hardlinks_cb(void *contextp, nh_t hardheadh);
 
 static bool_t
-proc_hardlinks( char *path1, char *path2 )
+proc_hardlinks(char *path1, char *path2)
 {
 	phcb_t phcb;
 
@@ -2141,7 +2141,7 @@ proc_hardlinks( char *path1, char *path2 )
 	phcb.path1 = path1;
 	phcb.path2 = path2;
 	phcb.ok = BOOL_TRUE;
-	link_headiter( proc_hardlinks_cb, ( void * )&phcb );
+	link_headiter(proc_hardlinks_cb, (void *)&phcb);
 	return phcb.ok;
 }
 
@@ -2165,9 +2165,9 @@ proc_hardlinks( char *path1, char *path2 )
  * Thus, steps 2 and 3 are handled in noref_elim_recurse().
  */
 static bool_t
-proc_hardlinks_cb( void *contextp, nh_t hardheadh )
+proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 {
-	phcb_t *phcbp = ( phcb_t * )contextp;
+	phcb_t *phcbp = (phcb_t *)contextp;
 	node_t *hardheadp;
 	xfs_ino_t ino;
 	gen_t gen;
@@ -2182,19 +2182,19 @@ proc_hardlinks_cb( void *contextp, nh_t hardheadh )
 
 	/* skip directories
 	 */
-	hardheadp = Node_map( hardheadh );
+	hardheadp = Node_map(hardheadh);
 	ino = hardheadp->n_ino;
 	gen = hardheadp->n_gen;
 	isdirpr = hardheadp->n_flags & NF_ISDIR;
-	Node_unmap( hardheadh, &hardheadp );
-	if ( isdirpr ) {
+	Node_unmap(hardheadh, &hardheadp);
+	if (isdirpr) {
 		return BOOL_TRUE;
 	}
 
-	mlog( MLOG_DEBUG | MLOG_TREE,
+	mlog(MLOG_DEBUG | MLOG_TREE,
 	      "processing hardlinks to %llu %u\n",
 	      ino,
-	      gen );
+	      gen);
 
 	/* first pass through hard link list: for each node, leave on
 	 * list, unlink and place on rename src list, unlink and place on
@@ -2204,61 +2204,61 @@ proc_hardlinks_cb( void *contextp, nh_t hardheadh )
 	rnsrcheadh = NH_NULL;
 	rndstheadh = NH_NULL;
 	lnsrch = NH_NULL;
-	link_iter_init( &link_iter_context, hardheadh );
-	while ( ( nh = link_iter_next( &link_iter_context )) != NH_NULL ) {
+	link_iter_init(&link_iter_context, hardheadh);
+	while ((nh = link_iter_next(&link_iter_context)) != NH_NULL) {
 
-		node_t *np = Node_map( nh );
+		node_t *np = Node_map(nh);
 		bool_t isrealpr = np->n_flags & NF_REAL;
 		bool_t isrefpr = np->n_flags & NF_REFED;
 		bool_t isselpr = np->n_flags & NF_SUBTREE;
 
 		/* if unrefed, unreal, free node etc. (sel doesn't matter)
 		 */
-		if ( ! isrealpr && ! isrefpr ) {
-			mlog( MLOG_NITTY | MLOG_TREE,
+		if (! isrealpr && ! isrefpr) {
+			mlog(MLOG_NITTY | MLOG_TREE,
 			      "freeing node %x: not real, not referenced\n",
-			      nh );
-			link_iter_unlink( &link_iter_context, nh );
-			Node_unmap( nh, &np );
-			( void )disown( nh );
-			Node_free( &nh );
+			      nh);
+			link_iter_unlink(&link_iter_context, nh);
+			Node_unmap(nh, &np);
+			(void)disown(nh);
+			Node_free(&nh);
 			continue;
 		}
 
 		/* not real, refed, but not selected, can't help
 		 */
-		if ( ! isrealpr &&   isrefpr && ! isselpr ) {
-			mlog( MLOG_NITTY | MLOG_TREE,
+		if (! isrealpr &&   isrefpr && ! isselpr) {
+			mlog(MLOG_NITTY | MLOG_TREE,
 			      "skipping node %x: not selected\n",
-			      nh );
-			Node_unmap( nh, &np );
+			      nh);
+			Node_unmap(nh, &np);
 			continue;
 		}
 
 		/* if unreal, refed, sel, add to dst list,
 		 */
-		if ( ! isrealpr &&   isrefpr &&   isselpr ) {
-			mlog( MLOG_NITTY | MLOG_TREE,
+		if (! isrealpr &&   isrefpr &&   isselpr) {
+			mlog(MLOG_NITTY | MLOG_TREE,
 			      "making node %x dst: "
 			      "not real, refed, sel\n",
-			      nh );
-			link_iter_unlink( &link_iter_context, nh );
+			      nh);
+			link_iter_unlink(&link_iter_context, nh);
 			np->n_lnkh = rndstheadh;
 			rndstheadh = nh;
-			Node_unmap( nh, &np );
+			Node_unmap(nh, &np);
 			continue;
 		}
 
 		/* if real, unrefed, sel, add to src list
 		 */
-		if (   isrealpr && ! isrefpr &&   isselpr ) {
-			mlog( MLOG_NITTY | MLOG_TREE,
+		if (isrealpr && ! isrefpr &&   isselpr) {
+			mlog(MLOG_NITTY | MLOG_TREE,
 			      "making node %x src: real, not refed, sel\n",
-			      nh );
-			link_iter_unlink( &link_iter_context, nh );
+			      nh);
+			link_iter_unlink(&link_iter_context, nh);
 			np->n_lnkh = rnsrcheadh;
 			rnsrcheadh = nh;
-			Node_unmap( nh, &np );
+			Node_unmap(nh, &np);
 			continue;
 		}
 
@@ -2266,187 +2266,187 @@ proc_hardlinks_cb( void *contextp, nh_t hardheadh )
 		 * real and referenced, leave alone (sel doesn't matter).
 		 * consider as a lnk src, since real and not going away.
 		 */
-		if (   isrealpr && ( isrefpr || !isselpr ) ) {
-			mlog( MLOG_NITTY | MLOG_TREE,
+		if (isrealpr && (isrefpr || !isselpr)) {
+			mlog(MLOG_NITTY | MLOG_TREE,
 			      "skipping node %x: %s\n",
 			      nh,
-			      isselpr ? "real and ref" : "real and not sel" );
-			Node_unmap( nh, &np );
-			if ( lnsrch == NH_NULL ) {
-				mlog( MLOG_NITTY | MLOG_TREE,
+			      isselpr ? "real and ref" : "real and not sel");
+			Node_unmap(nh, &np);
+			if (lnsrch == NH_NULL) {
+				mlog(MLOG_NITTY | MLOG_TREE,
 				      "node %x will be link src\n",
-				      nh );
+				      nh);
 				lnsrch = nh;
 			}
 			continue;
 		}
-		assert( 0 );
+		assert(0);
 	}
 
 	/* now pass through dst list, doing renames if src list not empty,
 	 * otherwise links if a lnk src available, otherwise put back in link
 	 * list
 	 */
-	while ( rndstheadh != NH_NULL ) {
+	while (rndstheadh != NH_NULL) {
 		nh_t dsth;
 		node_t *dstp;
 		bool_t successpr;
 
 		dsth = rndstheadh;
-		dstp = Node_map( dsth );
+		dstp = Node_map(dsth);
 		rndstheadh = dstp->n_lnkh;
 		dstp->n_lnkh = NH_NULL;
-		Node_unmap( dsth, &dstp );
+		Node_unmap(dsth, &dstp);
 
 		/* build pathname to dst
 		 */
-		ok = Node2path( dsth, phcbp->path2, _("rename to") );
-		if ( ! ok ) {
-			link_in( dsth );
+		ok = Node2path(dsth, phcbp->path2, _("rename to"));
+		if (! ok) {
+			link_in(dsth);
 			continue;
 		}
 
 		successpr = BOOL_FALSE;
-		while ( ! successpr && rnsrcheadh != NH_NULL ) {
+		while (! successpr && rnsrcheadh != NH_NULL) {
 			nh_t srch;
 			nrh_t nrh;
 			node_t *srcp;
 
 			srch = rnsrcheadh;
-			srcp = Node_map( srch );
+			srcp = Node_map(srch);
 			rnsrcheadh = srcp->n_lnkh;
 			srcp->n_lnkh = NH_NULL;
-			Node_unmap( srch, &srcp );
+			Node_unmap(srch, &srcp);
 
 			/* build a path to src
 			 */
-			ok = Node2path( srch, phcbp->path1, _("rename from") );
-			if ( ! ok ) {
-				link_in( srch );
+			ok = Node2path(srch, phcbp->path1, _("rename from"));
+			if (! ok) {
+				link_in(srch);
 				continue;
 			}
 
-			if ( tranp->t_toconlypr ) {
+			if (tranp->t_toconlypr) {
 				rval = 0;
 			} else {
-				mlog( MLOG_TRACE | MLOG_TREE,
+				mlog(MLOG_TRACE | MLOG_TREE,
 				      "rename nondir %s to %s\n",
 				      phcbp->path1,
-				      phcbp->path2 );
-				rval = rename( phcbp->path1,
-					       phcbp->path2 );
+				      phcbp->path2);
+				rval = rename(phcbp->path1,
+					       phcbp->path2);
 			}
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 				      "unable to rename nondir "
 				      "%s to %s: %s\n"),
 				      phcbp->path1,
 				      phcbp->path2,
-				      strerror( errno ));
-				link_in( srch );
+				      strerror(errno));
+				link_in(srch);
 				continue;
 			}
 
-			nrh = disown( srch );
-			if ( nrh != NRH_NULL ) {
-				namreg_del( nrh );
+			nrh = disown(srch);
+			if (nrh != NRH_NULL) {
+				namreg_del(nrh);
 			}
-			Node_free( &srch );
+			Node_free(&srch);
 
 			successpr = BOOL_TRUE;
 		}
 
 		/* tes@sgi.com: note: loop of one iteration only
 		 */
-		while ( ! successpr && lnsrch != NH_NULL ) {
-			ok = Node2path( lnsrch, phcbp->path1, _("link") );
+		while (! successpr && lnsrch != NH_NULL) {
+			ok = Node2path(lnsrch, phcbp->path1, _("link"));
 
-			if ( ! ok ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+			if (! ok) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 				      "unable to use %s "
 				      "as a hard link source\n"),
-				      phcbp->path1 );
+				      phcbp->path1);
 				lnsrch = NH_NULL;
 				continue;
 			}
 
-			if ( tranp->t_toconlypr ) {
+			if (tranp->t_toconlypr) {
 				rval = 0;
 			} else {
-				mlog( MLOG_TRACE | MLOG_TREE,
+				mlog(MLOG_TRACE | MLOG_TREE,
 				      "link nondir %s to %s\n",
 				      phcbp->path1,
-				      phcbp->path2 );
-				rval = link( phcbp->path1,
-					     phcbp->path2 );
+				      phcbp->path2);
+				rval = link(phcbp->path1,
+					     phcbp->path2);
 			}
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE,
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE,
 				      "unable to link nondir "
 				      "%s to %s: %s\n",
 				      phcbp->path1,
 				      phcbp->path2,
-				      strerror( errno ));
+				      strerror(errno));
 				break;
 			}
 			successpr = BOOL_TRUE;
 		}
 
-		if ( ! successpr ) {
-			mlog( MLOG_NITTY | MLOG_TREE,
+		if (! successpr) {
+			mlog(MLOG_NITTY | MLOG_TREE,
 			      "no link src for node %x\n",
-			      dsth );
+			      dsth);
 		} else {
-			dstp = Node_map( dsth );
+			dstp = Node_map(dsth);
 			dstp->n_flags |= NF_REAL;
-			Node_unmap( dsth, &dstp );
+			Node_unmap(dsth, &dstp);
 		}
 
-		link_in( dsth );
+		link_in(dsth);
 	}
 
 	/* finally, pass through remaining src list, unlinking/disowning.
 	 * tes@sgi.com: don't believe this will happen as this step
 	 * should now be done in noref_elim_recurse().
 	 */
-	while ( rnsrcheadh != NH_NULL ) {
+	while (rnsrcheadh != NH_NULL) {
 		nh_t srch;
 		node_t *srcp;
 		bool_t ok;
 
 		srch = rnsrcheadh;
-		srcp = Node_map( srch );
+		srcp = Node_map(srch);
 		rnsrcheadh = srcp->n_lnkh;
 		srcp->n_lnkh = NH_NULL;
-		Node_unmap( srch, &srcp );
+		Node_unmap(srch, &srcp);
 
-		ok = Node2path( srch, phcbp->path1, _("unlink") );
-		if ( ! ok ) {
-			link_in( srch );
+		ok = Node2path(srch, phcbp->path1, _("unlink"));
+		if (! ok) {
+			link_in(srch);
 			continue;
 		}
 
-		if ( tranp->t_toconlypr ) {
+		if (tranp->t_toconlypr) {
 			rval = 0;
 		} else {
-			mlog( MLOG_TRACE | MLOG_TREE,
+			mlog(MLOG_TRACE | MLOG_TREE,
 			      "unlink nondir %s\n",
-			      phcbp->path1 );
-			rval = unlink( phcbp->path1 );
+			      phcbp->path1);
+			rval = unlink(phcbp->path1);
 		}
-		if ( rval ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+		if (rval) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 			      "unable to unlink %s: %s\n"),
 			      phcbp->path1,
-			      strerror( errno ));
-			link_in( srch );
+			      strerror(errno));
+			link_in(srch);
 		} else {
 			nrh_t nrh;
-			nrh = disown( srch );
-			if ( nrh != NRH_NULL ) {
-				namreg_del( nrh );
+			nrh = disown(srch);
+			if (nrh != NRH_NULL) {
+				namreg_del(nrh);
 			}
-			Node_free( &srch );
+			Node_free(&srch);
 		}
 	}
 
@@ -2457,59 +2457,59 @@ proc_hardlinks_cb( void *contextp, nh_t hardheadh )
  * if non-empty, move children to orphanage
  */
 bool_t
-tree_setattr( char *path )
+tree_setattr(char *path)
 {
 	bool_t ok;
 	node_t *rootp;
 
-	ok = tree_setattr_recurse( persp->p_rooth, path );
+	ok = tree_setattr_recurse(persp->p_rooth, path);
 
-	if ( restore_rootdir_permissions && ok ) {
-		rootp = Node_map( persp->p_rooth );
+	if (restore_rootdir_permissions && ok) {
+		rootp = Node_map(persp->p_rooth);
 		/* "." is cwd which is the destination dir */
-		setdirattr( rootp->n_dah, "." );
-		Node_unmap( persp->p_rooth, &rootp );
+		setdirattr(rootp->n_dah, ".");
+		Node_unmap(persp->p_rooth, &rootp);
 	}
 
 	return ok;
 }
 
 static bool_t
-tree_setattr_recurse( nh_t parh, char *path )
+tree_setattr_recurse(nh_t parh, char *path)
 {
-	node_t *parp = Node_map( parh );
+	node_t *parp = Node_map(parh);
 	nh_t cldh = parp->n_cldh;
-	Node_unmap( parh, &parp );
-	while ( cldh != NH_NULL ) {
+	Node_unmap(parh, &parp);
+	while (cldh != NH_NULL) {
 		nh_t nextcldh;
 
 		/* get the node attributes
 		 */
-		node_t *cldp = Node_map( cldh );
-		bool_t isdirpr = ( cldp->n_flags & NF_ISDIR );
-		bool_t isselpr = ( cldp->n_flags & NF_SUBTREE );
-		bool_t isrealpr = ( cldp->n_flags & NF_REAL );
+		node_t *cldp = Node_map(cldh);
+		bool_t isdirpr = (cldp->n_flags & NF_ISDIR);
+		bool_t isselpr = (cldp->n_flags & NF_SUBTREE);
+		bool_t isrealpr = (cldp->n_flags & NF_REAL);
 		dah_t dah = cldp->n_dah;
 
 		/* get next cld
 		 */
 		nextcldh = cldp->n_sibh;
-		Node_unmap( cldh, &cldp );
+		Node_unmap(cldh, &cldp);
 
 		/* if is a real selected dir, go ahead.
 		 */
-		if ( isdirpr && isselpr && isrealpr ) {
+		if (isdirpr && isselpr && isrealpr) {
 			bool_t ok;
-			ok = tree_setattr_recurse( cldh, path ); /* RECURSION */
-			if ( ! ok ) {
-				Node_unmap( cldh, &cldp );
+			ok = tree_setattr_recurse(cldh, path); /* RECURSION */
+			if (! ok) {
+				Node_unmap(cldh, &cldp);
 				return BOOL_FALSE;
 			}
-			if ( dah != DAH_NULL ) {
+			if (dah != DAH_NULL) {
 				bool_t ok;
-				ok = Node2path( cldh, path, _("set dirattr") );
-				if ( ok ) {
-					setdirattr( dah, path );
+				ok = Node2path(cldh, path, _("set dirattr"));
+				if (ok) {
+					setdirattr(dah, path);
 				}
 			}
 		}
@@ -2521,7 +2521,7 @@ tree_setattr_recurse( nh_t parh, char *path )
 }
 
 static void
-setdirattr( dah_t dah, char *path )
+setdirattr(dah_t dah, char *path)
 {
 	mode_t mode;
 	struct utimbuf utimbuf;
@@ -2531,96 +2531,96 @@ setdirattr( dah_t dah, char *path )
 	void	*hanp;
 	int fd = -1;
 
-	if ( dah == DAH_NULL )
+	if (dah == DAH_NULL)
 		return;
 
-	if ( tranp->t_dstdirisxfspr ) {
+	if (tranp->t_dstdirisxfspr) {
 		if (path_to_handle(path, &hanp, &hlen)) {
-			mlog( MLOG_NORMAL | MLOG_WARNING,
+			mlog(MLOG_NORMAL | MLOG_WARNING,
 				_("path_to_handle of %s failed:%s\n"),
-				path, strerror( errno ));
+				path, strerror(errno));
 		} else {
 			fd = open_by_handle(hanp, hlen, O_RDONLY);
 			if (fd < 0) {
-				mlog( MLOG_NORMAL | MLOG_WARNING,
+				mlog(MLOG_NORMAL | MLOG_WARNING,
 					_("open_by_handle of %s failed:%s\n"),
-					path, strerror( errno ));
+					path, strerror(errno));
 			}
 			free_handle(hanp, hlen);
 		}
 	}
 
-	if ( tranp->t_dstdirisxfspr && persp->p_restoredmpr ) {
+	if (tranp->t_dstdirisxfspr && persp->p_restoredmpr) {
 		fsdmidata_t fssetdm;
 
-		fssetdm.fsd_dmevmask = dirattr_get_dmevmask( dah );
+		fssetdm.fsd_dmevmask = dirattr_get_dmevmask(dah);
 		fssetdm.fsd_padding = 0;	/* not used */
-		fssetdm.fsd_dmstate = ( uint16_t )dirattr_get_dmstate( dah );
+		fssetdm.fsd_dmstate = (uint16_t)dirattr_get_dmstate(dah);
 
 		/* restore DMAPI event settings etc.
 		 */
-		rval = ioctl( fd,
+		rval = ioctl(fd,
 			      XFS_IOC_FSSETDM,
-			      ( void * )&fssetdm );
-		if ( rval ) {
-			mlog( errno == EINVAL
+			      (void *)&fssetdm);
+		if (rval) {
+			mlog(errno == EINVAL
 			      ?
-			      ( MLOG_NITTY + 1 ) | MLOG_TREE
+			      (MLOG_NITTY + 1) | MLOG_TREE
 			      :
 			      MLOG_NITTY | MLOG_TREE,
 			      "set DMI attributes"
 			      " of %s failed: %s\n",
 			      path,
-			      strerror( errno ));
+			      strerror(errno));
 		}
 	}
 
-	utimbuf.actime = dirattr_get_atime( dah );
-	utimbuf.modtime = dirattr_get_mtime( dah );
-	rval = utime( path, &utimbuf );
-	if ( rval ) {
-		mlog( MLOG_VERBOSE | MLOG_TREE, _(
+	utimbuf.actime = dirattr_get_atime(dah);
+	utimbuf.modtime = dirattr_get_mtime(dah);
+	rval = utime(path, &utimbuf);
+	if (rval) {
+		mlog(MLOG_VERBOSE | MLOG_TREE, _(
 		      "could not set access and modification times"
 		      " of %s: %s\n"),
 		      path,
-		      strerror( errno ));
-	}
-	mode = dirattr_get_mode( dah );
-	if ( persp->p_ownerpr  ) {
-		rval = chown( path,
-			      dirattr_get_uid( dah ),
-			      dirattr_get_gid( dah ));
-		if ( rval ) {
-			mlog( MLOG_NORMAL | MLOG_TREE, _(
+		      strerror(errno));
+	}
+	mode = dirattr_get_mode(dah);
+	if (persp->p_ownerpr) {
+		rval = chown(path,
+			      dirattr_get_uid(dah),
+			      dirattr_get_gid(dah));
+		if (rval) {
+			mlog(MLOG_NORMAL | MLOG_TREE, _(
 			      "chown (uid=%d, gid=%d) %s failed: %s\n"),
-			      dirattr_get_uid( dah ),
-			      dirattr_get_gid( dah ),
+			      dirattr_get_uid(dah),
+			      dirattr_get_gid(dah),
 			      path,
-			      strerror( errno ));
+			      strerror(errno));
 		}
 	}
-	rval = chmod( path, mode );
-	if ( rval ) {
-		mlog( MLOG_NORMAL | MLOG_TREE, _(
+	rval = chmod(path, mode);
+	if (rval) {
+		mlog(MLOG_NORMAL | MLOG_TREE, _(
 		      "chmod %s failed: %s\n"),
 		      path,
-		      strerror( errno ));
+		      strerror(errno));
 	}
 
 	/* set the extended inode flags
 	 */
-	if ( !tranp->t_dstdirisxfspr )
+	if (!tranp->t_dstdirisxfspr)
 		return;
 
-	memset((void *)&fsxattr, 0, sizeof( fsxattr ));
-	fsxattr.fsx_xflags = dirattr_get_xflags( dah );
-	fsxattr.fsx_extsize = dirattr_get_extsize( dah );
-	fsxattr.fsx_projid = dirattr_get_projid( dah );
+	memset((void *)&fsxattr, 0, sizeof(fsxattr));
+	fsxattr.fsx_xflags = dirattr_get_xflags(dah);
+	fsxattr.fsx_extsize = dirattr_get_extsize(dah);
+	fsxattr.fsx_projid = dirattr_get_projid(dah);
 
-	rval = ioctl( fd,
+	rval = ioctl(fd,
 		      XFS_IOC_FSSETXATTR,
 		      (void *)&fsxattr);
-	if ( rval < 0 ) {
+	if (rval < 0) {
 		mlog(MLOG_NORMAL | MLOG_WARNING,
 		     _("attempt to set "
 		       "extended attributes "
@@ -2635,27 +2635,27 @@ setdirattr( dah_t dah, char *path )
 		     path,
 		     strerror(errno));
 	}
-	( void )close( fd );
+	(void)close(fd);
 }
 
 /* deletes orphanage if empty, else warns
  */
 bool_t
-tree_delorph( void )
+tree_delorph(void)
 {
 	int rval;
 
-	rval = rmdir( tranp->t_orphdir );
-	if ( rval ) {
-		if ( errno == EEXIST ) {
+	rval = rmdir(tranp->t_orphdir);
+	if (rval) {
+		if (errno == EEXIST) {
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 			     "unable to rmdir %s: not empty\n"),
-			     tranp->t_orphdir );
+			     tranp->t_orphdir);
 		} else {
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 			     "unable to rmdir %s: %s\n"),
 			     tranp->t_orphdir,
-			     strerror( errno ));
+			     strerror(errno));
 		}
 	}
 
@@ -2668,31 +2668,31 @@ tree_delorph( void )
 
 /* interactive subtree abstraction *******************************************/
 
-static void tsi_cmd_inst( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_pwd( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_ls( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_cd( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_add( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_delete( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_extract( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_quit( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_help( void *, dlog_pcbp_t, void * );
-static void tsi_cmd_parse( char * );
-static dlog_ucbp_t tsi_cmd_match( void );
+static void tsi_cmd_inst(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_pwd(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_ls(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_cd(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_add(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_delete(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_extract(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_quit(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_help(void *, dlog_pcbp_t, void *);
+static void tsi_cmd_parse(char *);
+static dlog_ucbp_t tsi_cmd_match(void);
 
 #define PREAMBLEMAX	3
 #define ACKMAX		3
 #define POSTAMBLEMAX	3
 
 bool_t
-tree_subtree_inter( void )
+tree_subtree_inter(void)
 {
 	fold_t fold;
-	char *preamblestr[ PREAMBLEMAX ];
+	char *preamblestr[PREAMBLEMAX];
 	size_t preamblecnt;
-	char *ackstr[ ACKMAX ];
+	char *ackstr[ACKMAX];
 	size_t ackcnt;
-	char *postamblestr[ POSTAMBLEMAX ];
+	char *postamblestr[POSTAMBLEMAX];
 	size_t postamblecnt;
 
 	dlog_ucbp_t cmdp;
@@ -2705,12 +2705,12 @@ restart:
 	/* begin the dialog
 	 */
 	preamblecnt = 0;
-	fold_init( fold, _("subtree selection dialog"), '=' );
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
+	fold_init(fold, _("subtree selection dialog"), '=');
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
 
 	/* execute commands until time to extract or quit. always begin with
 	 * an implicit instructions command. if see SIGINT, give main thread
@@ -2718,7 +2718,7 @@ restart:
 	 */
 	cmdp = tsi_cmd_inst;
 	do {
-		char buf[ MAXPATHLEN ];
+		char buf[MAXPATHLEN];
 		const ix_t abortix = 1;
 		const ix_t sigintix = 2;
 		const ix_t okix = 3;
@@ -2726,128 +2726,128 @@ restart:
 
 		/* execute command and get response
 		 */
-		responseix = dlog_string_query( cmdp,
+		responseix = dlog_string_query(cmdp,
 					        0,
 					        buf,
-					        sizeof( buf ),
+					        sizeof(buf),
 					        0,
 					        IXMAX,    /* timeout ix */
 					        sigintix, /* sigint ix */
 					        abortix,  /* sighup ix */
 						abortix,  /* sigquit ix */
-						okix );   /* ok ix */
+						okix);   /* ok ix */
 
 		/* ack the response
 		 */
 		ackcnt = 0;
-		if ( responseix == sigintix ) {
-			ackstr[ ackcnt++ ] = _("keyboard interrupt\n");
-		} else if ( responseix == abortix ) {
-			ackstr[ ackcnt++ ] = _("abort\n");
+		if (responseix == sigintix) {
+			ackstr[ackcnt++ ] = _("keyboard interrupt\n");
+		} else if (responseix == abortix) {
+			ackstr[ackcnt++ ] = _("abort\n");
 		} else {
-			assert( responseix == okix );
+			assert(responseix == okix);
 		}
-		assert( ackcnt <= ACKMAX );
-		dlog_string_ack( ackstr,
-				 ackcnt );
+		assert(ackcnt <= ACKMAX);
+		dlog_string_ack(ackstr,
+				 ackcnt);
 
 		/* exception handling
 		 */
-		if ( responseix != okix ) {
+		if (responseix != okix) {
 			/* if exception, end the dialog. may restart
 			 * if operator decidesd not to intr.
 			 */
 			postamblecnt = 0;
-			fold_init( fold, _("end dialog"), '-' );
-			postamblestr[ postamblecnt++ ] = "\n";
-			postamblestr[ postamblecnt++ ] = fold;
-			postamblestr[ postamblecnt++ ] = "\n\n";
-			assert( postamblecnt <= POSTAMBLEMAX );
-			dlog_end( postamblestr, postamblecnt );
+			fold_init(fold, _("end dialog"), '-');
+			postamblestr[postamblecnt++ ] = "\n";
+			postamblestr[postamblecnt++] = fold;
+			postamblestr[postamblecnt++ ] = "\n\n";
+			assert(postamblecnt <= POSTAMBLEMAX);
+			dlog_end(postamblestr, postamblecnt);
 
 			/* if sighup or sigquit, immediately quit
 			 */
-			if ( responseix == abortix ) {
+			if (responseix == abortix) {
 				return BOOL_FALSE;
 			}
 
 			/* if sigint, allow main thread to decide if
 			 * operator really wants to quit
 			 */
-			assert( responseix == sigintix );
-			if ( cldmgr_stop_requested( )) {
+			assert(responseix == sigintix);
+			if (cldmgr_stop_requested()) {
 				return BOOL_FALSE;
 			}
-			sleep( 1 ); /* to allow main thread to begin dialog */
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_TREE,
-			      "" ); /* block until main thread dialog done */
-			sleep( 1 ); /* let main thread ask children to die */
-			if ( cldmgr_stop_requested( )) {
+			sleep(1); /* to allow main thread to begin dialog */
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_TREE,
+			      ""); /* block until main thread dialog done */
+			sleep(1); /* let main thread ask children to die */
+			if (cldmgr_stop_requested()) {
 				return BOOL_FALSE;
 			}
-			mlog( MLOG_DEBUG | MLOG_TREE,
-			      "retrying interactive subtree selection dialog\n" );
+			mlog(MLOG_DEBUG | MLOG_TREE,
+			      "retrying interactive subtree selection dialog\n");
 			goto restart;
 		}
 
 
-		tsi_cmd_parse( buf );
-		cmdp = tsi_cmd_match( );
-		if ( ! cmdp ) {
+		tsi_cmd_parse(buf);
+		cmdp = tsi_cmd_match();
+		if (! cmdp) {
 			cmdp = tsi_cmd_help;
 		}
-	} while ( cmdp != tsi_cmd_quit && cmdp != tsi_cmd_extract );
+	} while (cmdp != tsi_cmd_quit && cmdp != tsi_cmd_extract);
 
 	postamblecnt = 0;
-	fold_init( fold, _("end dialog"), '-' );
-	postamblestr[ postamblecnt++ ] = "\n";
-	postamblestr[ postamblecnt++ ] = fold;
-	postamblestr[ postamblecnt++ ] = "\n\n";
-	assert( postamblecnt <= POSTAMBLEMAX );
-	dlog_end( postamblestr, postamblecnt );
+	fold_init(fold, _("end dialog"), '-');
+	postamblestr[postamblecnt++ ] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++ ] = "\n\n";
+	assert(postamblecnt <= POSTAMBLEMAX);
+	dlog_end(postamblestr, postamblecnt);
 
 	/* pv 773569 - quit is not a reason to consider session
          * to be interrupted (we haven't started yet) so just unmark
          * any selected directories and return */
-	if ( cmdp == tsi_cmd_quit ) {
-		mlog( MLOG_NORMAL, _("Unmark and quit\n") );
-		selsubtree( persp->p_rooth , BOOL_FALSE );
+	if (cmdp == tsi_cmd_quit) {
+		mlog(MLOG_NORMAL, _("Unmark and quit\n"));
+		selsubtree(persp->p_rooth , BOOL_FALSE);
 	}
 
 	return BOOL_TRUE;
 }
 
 static void
-tsi_cmd_inst( void *ctxp,
+tsi_cmd_inst(void *ctxp,
 	      dlog_pcbp_t pcb,
-	      void *pctxp )
+	      void *pctxp)
 {
-	tsi_cmd_help( ctxp, pcb, pctxp );
+	tsi_cmd_help(ctxp, pcb, pctxp);
 }
 
 static void
-tsi_cmd_pwd( void *ctxp,
+tsi_cmd_pwd(void *ctxp,
 	     dlog_pcbp_t pcb,
-	     void *pctxp )
+	     void *pctxp)
 {
 	/* special case root
 	 */
-	if ( tranp->t_inter.i_cwdh == persp->p_rooth ) {
-		( * pcb )( pctxp, "cwd is fs root\n" );
+	if (tranp->t_inter.i_cwdh == persp->p_rooth) {
+		(* pcb )(pctxp, "cwd is fs root\n");
 		return;
 	}
 
 	/* ascend tree recursively, print path on way back
 	 */
-	tsi_cmd_pwd_recurse( ctxp, pcb, pctxp, tranp->t_inter.i_cwdh );
-	( * pcb )( pctxp, "\n" );
+	tsi_cmd_pwd_recurse(ctxp, pcb, pctxp, tranp->t_inter.i_cwdh);
+	(* pcb )(pctxp, "\n");
 }
 
 static void
-tsi_cmd_pwd_recurse( void *ctxp,
+tsi_cmd_pwd_recurse(void *ctxp,
 		     dlog_pcbp_t pcb,
 		     void *pctxp,
-		     nh_t nh )
+		     nh_t nh)
 {
 	node_t *np;
 	register nh_t parh;
@@ -2855,33 +2855,33 @@ tsi_cmd_pwd_recurse( void *ctxp,
 	register int namelen;
 	nrh_t nrh;
 
-	assert( nh != NH_NULL );
+	assert(nh != NH_NULL);
 
-	np = Node_map( nh );
+	np = Node_map(nh);
 	nrh = np->n_nrh;
 	parh = np->n_parh;
-	Node_unmap( nh, &np );
-	if ( parh != persp->p_rooth ) {
-		tsi_cmd_pwd_recurse( ctxp, pcb, pctxp, parh );
+	Node_unmap(nh, &np);
+	if (parh != persp->p_rooth) {
+		tsi_cmd_pwd_recurse(ctxp, pcb, pctxp, parh);
 			/* RECURSION */
-		( * pcb )( pctxp, "/" );
+		(* pcb )(pctxp, "/");
 	}
-	assert( nrh != NRH_NULL );
-	namelen = namreg_get( nrh,
+	assert(nrh != NRH_NULL);
+	namelen = namreg_get(nrh,
 			      tranp->t_inter.i_name,
-			      sizeof( tranp->t_inter.i_name ));
-	assert( namelen > 0 );
-	( * pcb )( pctxp, tranp->t_inter.i_name );
+			      sizeof(tranp->t_inter.i_name));
+	assert(namelen > 0);
+	(* pcb)(pctxp, tranp->t_inter.i_name);
 }
 
 /* ARGSUSED */
 static void
-tsi_cmd_ls( void *ctxp,
+tsi_cmd_ls(void *ctxp,
 	    dlog_pcbp_t pcb,
-	    void *pctxp )
+	    void *pctxp)
 {
 	size_t argc = tranp->t_inter.i_argc;
-	char *arg = ( argc > 1 ) ? tranp->t_inter.i_argv[ 1 ] : 0;
+	char *arg = (argc > 1) ? tranp->t_inter.i_argv[1] : 0;
 	bool_t ok;
 
 	nh_t cldh;
@@ -2894,7 +2894,7 @@ tsi_cmd_ls( void *ctxp,
 	/* walk the tree according to the path argument, to get
 	 * the named node.
 	 */
-	ok = tsi_walkpath( arg,
+	ok = tsi_walkpath(arg,
 			   persp->p_rooth,
 			   tranp->t_inter.i_cwdh,
 			   pcb,
@@ -2904,20 +2904,20 @@ tsi_cmd_ls( void *ctxp,
 			   &cldh,
 			   &ino,
 			   &isdirpr,
-			   &isselpr );
-	if ( ! ok ) {
+			   &isselpr);
+	if (! ok) {
 		return;
 	}
 
 	/* if named is not a dir, just display named
 	 */
-	if ( ! isdirpr ) {
-		( * pcb )( pctxp,
+	if (! isdirpr) {
+		(* pcb)(pctxp,
 			   "    %s %10llu %s%s\n",
 			   isselpr ? "*" : " ",
 			   ino,
 			   tranp->t_inter.i_name,
-			   isdirpr ? "/" : " " );
+			   isdirpr ? "/" : " ");
 
 		return;
 	}
@@ -2925,30 +2925,30 @@ tsi_cmd_ls( void *ctxp,
 	/* iterate through the directory, printing all matching entries.
 	 * hide the orphanage.
 	 */
-	while ( cldh != NH_NULL ) {
+	while (cldh != NH_NULL) {
 		node_t *cldp;
 		nrh_t nrh;
 		nh_t nextcldh;
-		cldp = Node_map( cldh );
+		cldp = Node_map(cldh);
 		nrh = cldp->n_nrh;
 		nextcldh = cldp->n_sibh;
-		isdirpr = ( cldp->n_flags & NF_ISDIR );
-		isselpr = ( cldp->n_flags & NF_SUBTREE );
+		isdirpr = (cldp->n_flags & NF_ISDIR);
+		isselpr = (cldp->n_flags & NF_SUBTREE);
 		ino = cldp->n_ino;
-		Node_unmap( cldh, &cldp );
-		if ( cldh != persp->p_orphh ) {
+		Node_unmap(cldh, &cldp);
+		if (cldh != persp->p_orphh) {
 			/* REFERENCED */
 			int namelen;
-			namelen = namreg_get( nrh,
+			namelen = namreg_get(nrh,
 					      tranp->t_inter.i_name,
-					      sizeof( tranp->t_inter.i_name ));
-			assert( namelen > 0 );
-			( * pcb )( pctxp,
+					      sizeof(tranp->t_inter.i_name));
+			assert(namelen > 0);
+			(* pcb)(pctxp,
 				   "    %s %10llu %s%s\n",
 				   isselpr ? "*" : " ",
 				   ino,
 				   tranp->t_inter.i_name,
-				   isdirpr ? "/" : " " );
+				   isdirpr ? "/" : " ");
 		}
 		cldh = nextcldh;
 	}
@@ -2956,12 +2956,12 @@ tsi_cmd_ls( void *ctxp,
 
 /* ARGSUSED */
 static void
-tsi_cmd_cd( void *ctxp,
+tsi_cmd_cd(void *ctxp,
 	    dlog_pcbp_t pcb,
-	    void *pctxp )
+	    void *pctxp)
 {
 	size_t argc = tranp->t_inter.i_argc;
-	char *arg = ( argc > 1 ) ? tranp->t_inter.i_argv[ 1 ] : 0;
+	char *arg = (argc > 1) ? tranp->t_inter.i_argv[1] : 0;
 
 	nh_t cldh;
 	nh_t parh;
@@ -2974,7 +2974,7 @@ tsi_cmd_cd( void *ctxp,
 	/* walk the tree according to the path argument, to get
 	 * the named node.
 	 */
-	ok = tsi_walkpath( arg,
+	ok = tsi_walkpath(arg,
 			   persp->p_rooth,
 			   tranp->t_inter.i_cwdh,
 			   pcb,
@@ -2984,18 +2984,18 @@ tsi_cmd_cd( void *ctxp,
 			   &cldh,
 			   &ino,
 			   &isdirpr,
-			   &isselpr );
-	if ( ! ok ) {
+			   &isselpr);
+	if (! ok) {
 		return;
 	}
 
 	/* if named is not a dir, complain
 	 */
-	if ( ! isdirpr ) {
-		assert( arg );
-		( * pcb )( pctxp,
+	if (! isdirpr) {
+		assert(arg);
+		(* pcb)(pctxp,
 			   _("%s is not a directory\n"),
-			   arg );
+			   arg);
 
 		return;
 	}
@@ -3007,12 +3007,12 @@ tsi_cmd_cd( void *ctxp,
 
 /* ARGSUSED */
 static void
-tsi_cmd_add( void *ctxp,
+tsi_cmd_add(void *ctxp,
 	     dlog_pcbp_t pcb,
-	     void *pctxp )
+	     void *pctxp)
 {
 	size_t argc = tranp->t_inter.i_argc;
-	char *arg = ( argc > 1 ) ? tranp->t_inter.i_argv[ 1 ] : 0;
+	char *arg = (argc > 1) ? tranp->t_inter.i_argv[1] : 0;
 
 	nh_t cldh;
 	nh_t parh;
@@ -3025,7 +3025,7 @@ tsi_cmd_add( void *ctxp,
 	/* walk the tree according to the path argument, to get
 	 * the named node.
 	 */
-	ok = tsi_walkpath( arg,
+	ok = tsi_walkpath(arg,
 			   persp->p_rooth,
 			   tranp->t_inter.i_cwdh,
 			   pcb,
@@ -3035,22 +3035,22 @@ tsi_cmd_add( void *ctxp,
 			   &cldh,
 			   &ino,
 			   &isdirpr,
-			   &isselpr );
-	if ( ! ok ) {
+			   &isselpr);
+	if (! ok) {
 		return;
 	}
 
-	selsubtree( namedh, BOOL_TRUE );
+	selsubtree(namedh, BOOL_TRUE);
 }
 
 /* ARGSUSED */
 static void
-tsi_cmd_delete( void *ctxp,
+tsi_cmd_delete(void *ctxp,
 		dlog_pcbp_t pcb,
-		void *pctxp )
+		void *pctxp)
 {
 	size_t argc = tranp->t_inter.i_argc;
-	char *arg = ( argc > 1 ) ? tranp->t_inter.i_argv[ 1 ] : 0;
+	char *arg = (argc > 1) ? tranp->t_inter.i_argv[1] : 0;
 
 	nh_t cldh;
 	nh_t parh;
@@ -3063,7 +3063,7 @@ tsi_cmd_delete( void *ctxp,
 	/* walk the tree according to the path argument, to get
 	 * the named node.
 	 */
-	ok = tsi_walkpath( arg,
+	ok = tsi_walkpath(arg,
 			   persp->p_rooth,
 			   tranp->t_inter.i_cwdh,
 			   pcb,
@@ -3073,45 +3073,45 @@ tsi_cmd_delete( void *ctxp,
 			   &cldh,
 			   &ino,
 			   &isdirpr,
-			   &isselpr );
-	if ( ! ok ) {
+			   &isselpr);
+	if (! ok) {
 		return;
 	}
 
-	selsubtree( namedh, BOOL_FALSE );
+	selsubtree(namedh, BOOL_FALSE);
 }
 
 /* ARGSUSED */
 static void
-tsi_cmd_extract( void *ctxp,
+tsi_cmd_extract(void *ctxp,
 		 dlog_pcbp_t pcb,
-		 void *pctxp )
+		 void *pctxp)
 {
 }
 
 /* ARGSUSED */
 static void
-tsi_cmd_quit( void *ctxp,
+tsi_cmd_quit(void *ctxp,
 	      dlog_pcbp_t pcb,
-	      void *pctxp )
+	      void *pctxp)
 {
 }
 
-static int parse( int slotcnt, char **slotbuf, char *string );
+static int parse(int slotcnt, char **slotbuf, char *string);
 
 static void
-tsi_cmd_parse( char *buf )
+tsi_cmd_parse(char *buf)
 {
 	int wordcnt;
 
-	if ( ! buf ) {
+	if (! buf) {
 		tranp->t_inter.i_argc = 0;
 		return;
 	}
 
-	wordcnt = parse( INTER_ARGMAX, tranp->t_inter.i_argv, buf );
+	wordcnt = parse(INTER_ARGMAX, tranp->t_inter.i_argv, buf);
 
-	tranp->t_inter.i_argc = ( size_t )min( max( 0, wordcnt ), INTER_ARGMAX );
+	tranp->t_inter.i_argc = (size_t)min(max(0, wordcnt), INTER_ARGMAX);
 }
 
 struct tsi_cmd_tbl {
@@ -3136,37 +3136,37 @@ static tsi_cmd_tbl_t tsi_cmd_tbl[] = {
 };
 
 static dlog_ucbp_t
-tsi_cmd_match( void )
+tsi_cmd_match(void)
 {
 	tsi_cmd_tbl_t *tblp = tsi_cmd_tbl;
 	tsi_cmd_tbl_t *tblendp = tsi_cmd_tbl
 				 +
-				 sizeof( tsi_cmd_tbl )
+				 sizeof(tsi_cmd_tbl)
 				 /
-				 sizeof( tsi_cmd_tbl[ 0 ] );
+				 sizeof(tsi_cmd_tbl[0]);
 
-	if ( tranp->t_inter.i_argc == 0 ) {
+	if (tranp->t_inter.i_argc == 0) {
 		return 0;
 	}
 
-	for ( ; tblp < tblendp ; tblp++ ) {
-		if ( ! strncmp( tranp->t_inter.i_argv[ 0 ],
+	for (; tblp < tblendp ; tblp++) {
+		if (! strncmp(tranp->t_inter.i_argv[0],
 				tblp->tct_pattern,
-				strlen( tranp->t_inter.i_argv[ 0 ] ))) {
+				strlen(tranp->t_inter.i_argv[0]))) {
 			break;
 		}
 	}
 
-	if ( tblp == tblendp ) {
+	if (tblp == tblendp) {
 		return 0;
 	}
 
-	assert( tblp->tct_argcmin != 0 );
-	if ( tranp->t_inter.i_argc < tblp->tct_argcmin ) {
+	assert(tblp->tct_argcmin != 0);
+	if (tranp->t_inter.i_argc < tblp->tct_argcmin) {
 		return 0;
 	}
 
-	if ( tranp->t_inter.i_argc > tblp->tct_argcmax ) {
+	if (tranp->t_inter.i_argc > tblp->tct_argcmax) {
 		return 0;
 	}
 
@@ -3175,23 +3175,23 @@ tsi_cmd_match( void )
 
 /* ARGSUSED */
 static void
-tsi_cmd_help( void *ctxp,
+tsi_cmd_help(void *ctxp,
 	      dlog_pcbp_t pcb,
-	      void *pctxp )
+	      void *pctxp)
 {
 	tsi_cmd_tbl_t *tblp = tsi_cmd_tbl;
 	tsi_cmd_tbl_t *tblendp = tsi_cmd_tbl
 				 +
-				 sizeof( tsi_cmd_tbl )
+				 sizeof(tsi_cmd_tbl)
 				 /
-				 sizeof( tsi_cmd_tbl[ 0 ] );
+				 sizeof(tsi_cmd_tbl[0]);
 
-	( * pcb )( pctxp, _("the following commands are available:\n") );
-	for ( ; tblp < tblendp ; tblp++ ) {
-		( * pcb )( pctxp,
+	(* pcb )(pctxp, _("the following commands are available:\n"));
+	for (; tblp < tblendp ; tblp++) {
+		(* pcb)(pctxp,
 			   "\t%s %s\n",
 			   tblp->tct_pattern,
-			   tblp->tct_help );
+			   tblp->tct_help);
 	}
 }
 
@@ -3203,17 +3203,17 @@ tsi_cmd_help( void *ctxp,
  * optionally given a dlog print func and context, to be used for diag output.
  */
 static bool_t
-tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
+tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 	      dlog_pcbp_t pcb, void *pctxp,
 	      nh_t *namedhp, nh_t *parhp, nh_t *cldhp,
-	      xfs_ino_t *inop, bool_t *isdirprp, bool_t *isselprp )
+	      xfs_ino_t *inop, bool_t *isdirprp, bool_t *isselprp)
 {
 	nh_t namedh;
 	nh_t parh;
 	nh_t cldh;
 	node_t *namedp;
 	char *path;
-	char nbuf[ NAME_MAX + 1 ];
+	char nbuf[NAME_MAX + 1];
 	xfs_ino_t ino;
 	bool_t isdirpr;
 	bool_t isselpr;
@@ -3221,8 +3221,8 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 
 	/* correct arg if ends with slash (if arg is "/", ok)
 	 */
-	if ( arg && strlen( arg ) > 1 && arg[ strlen( arg ) - 1 ] == '/' ) {
-		arg[ strlen( arg ) - 1 ] = 0;
+	if (arg && strlen(arg) > 1 && arg[strlen(arg) - 1] == '/') {
+		arg[strlen(arg) - 1] = 0;
 	}
 
 	/* use path to walk down the path argument
@@ -3232,24 +3232,24 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 	/* walk the tree beginning either at the root node
 	 * or at the current working directory
 	 */
-	if ( path && *path == '/' ) {
-		assert( rooth != NH_NULL );
+	if (path && *path == '/') {
+		assert(rooth != NH_NULL);
 		namedh = rooth;
 		path++;
 	} else {
-		assert( cwdh != NH_NULL );
+		assert(cwdh != NH_NULL);
 		namedh = cwdh;
 	}
 
 	/* get the parent of the starting point, and its cld list
 	 */
-	namedp = Node_map( namedh );
+	namedp = Node_map(namedh);
 	parh = namedp->n_parh;
 	cldh = namedp->n_cldh;
 	ino = namedp->n_ino;
-	isselpr = ( namedp->n_flags & NF_SUBTREE );
-	assert( namedp->n_flags & NF_ISDIR );
-	Node_unmap( namedh, &namedp );
+	isselpr = (namedp->n_flags & NF_SUBTREE);
+	assert(namedp->n_flags & NF_ISDIR);
+	Node_unmap(namedh, &namedp);
 	isdirpr = BOOL_TRUE;
 
 	/* walk the tree from the starting point following the path arg.
@@ -3259,40 +3259,40 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 	 *	isdirpr - TRUE if named node is a directory;
 	 *	cldh - the first child in the named node's cld list.
 	 */
-	for ( ; ; ) {
+	for (; ;) {
 		size_t namelen;
 		char *strpatchp;
 		nh_t sibh;
 
 		/* if no path arg, break
 		 */
-		if ( ! path ) {
+		if (! path) {
 			break;
 		}
 
 		/* clean out leading slashes. these can occur if the
 		 * path arg is ".../////..." or "////..."
 		 */
-		while ( *path == '/' ) {
+		while (*path == '/') {
 			path++;
 		}
 
 		/* if empty path arg, break
 		 */
-		if ( ! strlen( path )) {
+		if (! strlen(path)) {
 			break;
 		}
 
 		/* copy the first name from the path, and advance
 		 * the path pointer.
 		 */
-		namelen = strcspn( path, "/" );
-		assert( namelen < sizeof( nbuf ));
-		strncpy( nbuf, path, namelen );
-		nbuf[ namelen ] = 0;
+		namelen = strcspn(path, "/");
+		assert(namelen < sizeof(nbuf));
+		strncpy(nbuf, path, namelen);
+		nbuf[namelen] = 0;
 		path += namelen;
-		if ( *path ) {
-			assert( *path == '/' );
+		if (*path) {
+			assert(*path == '/');
 			strpatchp = path;
 			*strpatchp = 0;
 			path++;
@@ -3302,19 +3302,19 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 
 		/* be sure the named node is a dir
 		 */
-		if ( ! isdirpr ) {
-			if ( pcb ) {
-				( * pcb )( pctxp, _(
+		if (! isdirpr) {
+			if (pcb) {
+				(* pcb)(pctxp, _(
 					   "parent of %s is not a directory\n"),
-					   arg );
+					   arg);
 			}
 			return BOOL_FALSE;
 		}
 
 		/* special case "."
 		 */
-		if ( ! strcmp( nbuf, "." )) {
-			if ( strpatchp ) {
+		if (! strcmp(nbuf, ".")) {
+			if (strpatchp) {
 				*strpatchp = '/';
 			}
 			continue;
@@ -3322,23 +3322,23 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 
 		/* special case ".."
 		 */
-		if ( ! strcmp( nbuf, ".." )) {
-			if ( parh == NH_NULL ) {
-				if ( pcb ) {
-					( * pcb )( pctxp, _(
+		if (! strcmp(nbuf, "..")) {
+			if (parh == NH_NULL) {
+				if (pcb) {
+					(* pcb)(pctxp, _(
 						   "%s above root\n"),
-						   arg );
+						   arg);
 				}
 				return BOOL_FALSE;
 			}
 			namedh = parh;
-			namedp = Node_map( namedh );
+			namedp = Node_map(namedh);
 			parh = namedp->n_parh;
 			cldh = namedp->n_cldh;
 			ino = namedp->n_ino;
-			isselpr = ( namedp->n_flags & NF_SUBTREE );
-			Node_unmap( namedh, &namedp );
-			if ( strpatchp ) {
+			isselpr = (namedp->n_flags & NF_SUBTREE);
+			Node_unmap(namedh, &namedp);
+			if (strpatchp) {
 				*strpatchp = '/';
 			}
 			continue;
@@ -3347,28 +3347,28 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 		/* look for child with right name
 		 */
 		sibh = cldh;
-		while ( sibh != NH_NULL ) {
+		while (sibh != NH_NULL) {
 			node_t *sibp;
 			nh_t nextsibh;
 			nrh_t nrh;
 			/* REFERENCED */
 			int siblen;
 
-			sibp = Node_map( sibh );
+			sibp = Node_map(sibh);
 			nrh = sibp->n_nrh;
 			nextsibh = sibp->n_sibh;
 			cldh = sibp->n_cldh;
 			ino = sibp->n_ino;
-			isselpr = ( sibp->n_flags & NF_SUBTREE );
-			isdirpr = ( sibp->n_flags & NF_ISDIR );
-			Node_unmap( sibh, &sibp );
-			assert( nrh != NRH_NULL || sibh == persp->p_orphh );
-			if ( nrh != NRH_NULL ) {
-				siblen = namreg_get( nrh,
+			isselpr = (sibp->n_flags & NF_SUBTREE);
+			isdirpr = (sibp->n_flags & NF_ISDIR);
+			Node_unmap(sibh, &sibp);
+			assert(nrh != NRH_NULL || sibh == persp->p_orphh);
+			if (nrh != NRH_NULL) {
+				siblen = namreg_get(nrh,
 						     tranp->t_inter.i_name,
-					       sizeof( tranp->t_inter.i_name ));
-				assert( siblen > 0 );
-				if ( ! strcmp( nbuf, tranp->t_inter.i_name )) {
+					       sizeof(tranp->t_inter.i_name));
+				assert(siblen > 0);
+				if (! strcmp(nbuf, tranp->t_inter.i_name)) {
 					break;
 				}
 			}
@@ -3377,11 +3377,11 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 
 		/* if no match, complain
 		 */
-		if ( sibh == NH_NULL ) {
-			if ( pcb ) {
-				( * pcb )( pctxp, _(
+		if (sibh == NH_NULL) {
+			if (pcb) {
+				(* pcb)(pctxp, _(
 					   "%s not found\n"),
-					   arg );
+					   arg);
 			}
 			return BOOL_FALSE;
 		}
@@ -3391,7 +3391,7 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 		 */
 		parh = namedh;
 		namedh = sibh;
-		if ( strpatchp ) {
+		if (strpatchp) {
 			*strpatchp = '/';
 		}
 	}
@@ -3408,15 +3408,15 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 /* Node abstraction *********************************************************/
 
 static nh_t
-Node_alloc( xfs_ino_t ino, gen_t gen, nrh_t nrh, dah_t dah, size_t flags )
+Node_alloc(xfs_ino_t ino, gen_t gen, nrh_t nrh, dah_t dah, size_t flags)
 {
 	nh_t nh;
 	node_t *np;
 
-	nh = node_alloc( );
+	nh = node_alloc();
 	if (nh == NH_NULL)
 	    return NH_NULL;
-	np = Node_map( nh );
+	np = Node_map(nh);
 	np->n_ino = ino;
 	np->n_nrh = nrh;
 	np->n_dah = dah;
@@ -3427,25 +3427,25 @@ Node_alloc( xfs_ino_t ino, gen_t gen, nrh_t nrh, dah_t dah, size_t flags )
 	np->n_cldh = NH_NULL;
 	np->n_lnkh = NH_NULL;
 	np->n_gen = gen;
-	np->n_flags = ( u_char_t )flags;
+	np->n_flags = (u_char_t)flags;
 	memset(np->n_pad, 0, sizeof(np->n_pad));
-	Node_unmap( nh, &np  );
+	Node_unmap(nh, &np);
 	return nh;
 }
 
 static void
-Node_free( nh_t *nhp )
+Node_free(nh_t *nhp)
 {
 	node_t *np;
-	np = Node_map( *nhp );
+	np = Node_map(*nhp);
 	np->n_ino = 0;
 	np->n_gen = 0;
-	if ( np->n_nrh != NRH_NULL ) {
-		namreg_del( np->n_nrh );
+	if (np->n_nrh != NRH_NULL) {
+		namreg_del(np->n_nrh);
 		np->n_nrh = NRH_NULL;
 	}
-	if ( np->n_dah != DAH_NULL ) {
-		dirattr_del( np->n_dah );
+	if (np->n_dah != DAH_NULL) {
+		dirattr_del(np->n_dah);
 		np->n_dah = DAH_NULL;
 	}
 	np->n_flags = 0;
@@ -3454,19 +3454,19 @@ Node_free( nh_t *nhp )
 	np->n_sibprevh = NH_NULL;
 	np->n_cldh = NH_NULL;
 	np->n_lnkh = NH_NULL;
-	Node_unmap( *nhp, &np  );
-	node_free( nhp );
+	Node_unmap(*nhp, &np);
+	node_free(nhp);
 }
 
 /*
  * NOTE: Does error handling here and exits.
  */
 static node_t *
-Node_map( nh_t nh )
+Node_map(nh_t nh)
 {
-	node_t *n = ( node_t * )node_map( nh );
-	if ( n == NULL ) {
-		mlog( MLOG_ERROR | MLOG_TREE, _(
+	node_t *n = (node_t *)node_map(nh);
+	if (n == NULL) {
+		mlog(MLOG_ERROR | MLOG_TREE, _(
 			"failed to map in node (node handle: %u)\n"), nh);
 		exit(EXIT_ERROR);
 	}
@@ -3474,32 +3474,32 @@ Node_map( nh_t nh )
 }
 
 static void
-Node_unmap( nh_t nh, node_t **npp )
+Node_unmap(nh_t nh, node_t **npp)
 {
-	node_unmap( nh, ( void ** )npp );
+	node_unmap(nh, (void **)npp);
 }
 
 /* builds a pathname for the specified node, relative to root
  * returns FALSE if pathname too long
  */
 static bool_t
-Node2path( nh_t nh, char *path, char *errmsg )
+Node2path(nh_t nh, char *path, char *errmsg)
 {
 	int remainingcnt;
 	strcpy(path, "."); /* in case root node passed in */
-	remainingcnt = Node2path_recurse( nh, path, MAXPATHLEN, 0 );
-	if ( remainingcnt <= 0 ) {
-		node_t *np = Node_map( nh );
+	remainingcnt = Node2path_recurse(nh, path, MAXPATHLEN, 0);
+	if (remainingcnt <= 0) {
+		node_t *np = Node_map(nh);
 		xfs_ino_t ino = np->n_ino;
 		gen_t gen = np->n_gen;
-		Node_unmap( nh, &np );
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+		Node_unmap(nh, &np);
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 		      "unable %s ino %llu gen %u: "
 		      "relative pathname too long (partial %s)\n"),
 		      errmsg,
 		      ino,
 		      gen,
-		      path );
+		      path);
 		return BOOL_FALSE;
 	} else {
 		return BOOL_TRUE;
@@ -3511,7 +3511,7 @@ Node2path( nh_t nh, char *path, char *errmsg )
  * works because the buffer size is secretly 2 * MAXPATHLEN.
  */
 static int
-Node2path_recurse( nh_t nh, char *buf, int bufsz, int level )
+Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 {
 	static __thread path_cache_t cache = { NH_NULL, 0, "" };
 	node_t *np;
@@ -3525,72 +3525,72 @@ Node2path_recurse( nh_t nh, char *buf, int bufsz, int level )
 
 	/* recursion termination
 	 */
-	if ( nh == persp->p_rooth ) {
+	if (nh == persp->p_rooth) {
 		return bufsz;
 	}
 
 	/* if we have a cache hit, no need to recurse any further
 	 */
-	if ( nh == cache.nh ) {
-		assert( bufsz > cache.len );
-		strcpy( buf, cache.buf );
+	if (nh == cache.nh) {
+		assert(bufsz > cache.len);
+		strcpy(buf, cache.buf);
 		return bufsz - cache.len;
 	}
 
 	/* extract useful node members
 	 */
-	np = Node_map( nh );
+	np = Node_map(nh);
 	parh = np->n_parh;
 	ino = np->n_ino;
 	gen = np->n_gen;
 	nrh = np->n_nrh;
-	Node_unmap( nh, &np );
+	Node_unmap(nh, &np);
 
 	/* build path to parent
 	 */
 	oldbuf = buf;
 	oldbufsz = bufsz;
-	bufsz = Node2path_recurse( parh, buf, bufsz, level+1 ); /* RECURSION */
-	if ( bufsz <= 0 ) {
+	bufsz = Node2path_recurse(parh, buf, bufsz, level+1); /* RECURSION */
+	if (bufsz <= 0) {
 		return bufsz;
 	}
 	buf += oldbufsz - bufsz;
 
 	/* insert slash if parent not root
 	 */
-	if ( parh != persp->p_rooth ) {
-		assert( bufsz + MAXPATHLEN >= 2 );
+	if (parh != persp->p_rooth) {
+		assert(bufsz + MAXPATHLEN >= 2);
 		*buf++ = '/';
-		*( buf + 1 ) = 0;
+		*(buf + 1) = 0;
 		bufsz--;
-		if ( bufsz <= 0 ) {
+		if (bufsz <= 0) {
 			return bufsz;
 		}
 	}
 
 	/* append entry name: special case if in orphanage
 	 */
-	if ( parh == persp->p_orphh ) {
-		namelen = sprintf( buf, "%llu.%u", (unsigned long long)ino, gen );
-	} else if ( nh == persp->p_orphh ) {
-		namelen = sprintf( buf, "%s", orphname );
+	if (parh == persp->p_orphh) {
+		namelen = sprintf(buf, "%llu.%u", (unsigned long long)ino, gen);
+	} else if (nh == persp->p_orphh) {
+		namelen = sprintf(buf, "%s", orphname);
 	} else {
-		assert( nrh != NRH_NULL );
-		namelen = namreg_get( nrh, buf, ( size_t )bufsz + MAXPATHLEN );
-		assert( namelen > 0 );
+		assert(nrh != NRH_NULL);
+		namelen = namreg_get(nrh, buf, (size_t)bufsz + MAXPATHLEN);
+		assert(namelen > 0);
 	}
 
 	/* update remaining buffer size
 	 */
 	bufsz -= namelen;
-	assert( bufsz + MAXPATHLEN > 0 );
+	assert(bufsz + MAXPATHLEN > 0);
 
 	/* update the cache if we're the target's parent
 	 * (and the pathname is not too long)
 	 */
-	if ( level == 1 && bufsz > 0 ) {
+	if (level == 1 && bufsz > 0) {
 		cache.nh = nh;
-		strcpy( cache.buf, oldbuf );
+		strcpy(cache.buf, oldbuf);
 		cache.len = oldbufsz - bufsz;
 	}
 
@@ -3602,7 +3602,7 @@ Node2path_recurse( nh_t nh, char *buf, int bufsz, int level )
 /* family abstraction *********************************************************/
 
 static void
-adopt( nh_t parh, nh_t cldh, nrh_t nrh )
+adopt(nh_t parh, nh_t cldh, nrh_t nrh)
 {
 	node_t *parp;
 	node_t *cldp;
@@ -3615,61 +3615,61 @@ adopt( nh_t parh, nh_t cldh, nrh_t nrh )
 #endif
 
 	/* fix up our child - put at front of child list */
-	cldp = Node_map( cldh );
+	cldp = Node_map(cldh);
 	cldp->n_parh = parh;
 	cldp->n_nrh = nrh;
-	parp = Node_map( parh );
+	parp = Node_map(parh);
 	cldp->n_sibh = parp->n_cldh;
 	cldp->n_sibprevh = NH_NULL;
-	Node_unmap( cldh, &cldp  );
+	Node_unmap(cldh, &cldp);
 
 	/* fix up old first child i.e. child's new sibling */
-	if ( parp->n_cldh != NH_NULL ) { /* if parent has a child */
-	    sibp = Node_map( parp->n_cldh );
+	if (parp->n_cldh != NH_NULL) { /* if parent has a child */
+	    sibp = Node_map(parp->n_cldh);
 	    sibp->n_sibprevh = cldh;
-	    Node_unmap( parp->n_cldh, &sibp );
+	    Node_unmap(parp->n_cldh, &sibp);
 	}
 
         /* fix up parent */
 	parp->n_cldh = cldh;
-	Node_unmap( parh, &parp  );
+	Node_unmap(parh, &parp);
 }
 
 static nrh_t
-disown( nh_t cldh )
+disown(nh_t cldh)
 {
 	node_t *cldp;
 	nrh_t nrh;
 	nh_t parh;
 	node_t *parp;
 
-	cldp = Node_map( cldh );
+	cldp = Node_map(cldh);
 
 	nrh = cldp->n_nrh;
 
 	parh = cldp->n_parh;
-	assert( parh != NH_NULL );
-	if ( parh == NH_NULL ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+	assert(parh != NH_NULL);
+	if (parh == NH_NULL) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 		      "attempt to disown child "
-		      "which has no parent!\n") );
+		      "which has no parent!\n"));
 		return nrh;
 	}
-	parp = Node_map( parh );
-	assert( parp->n_cldh != NH_NULL );
-	if ( parp->n_cldh == NH_NULL ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+	parp = Node_map(parh);
+	assert(parp->n_cldh != NH_NULL);
+	if (parp->n_cldh == NH_NULL) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 		      "attempt to disown child "
-		      "when parent has no children!\n") );
+		      "when parent has no children!\n"));
 		return nrh;
 	}
-	if ( parp->n_cldh == cldh ) {
+	if (parp->n_cldh == cldh) {
 		/* child is the first one in the child list */
 		parp->n_cldh = cldp->n_sibh;
-		if ( cldp->n_sibh != NH_NULL ) {
-			node_t *sibp = Node_map( cldp->n_sibh );
+		if (cldp->n_sibh != NH_NULL) {
+			node_t *sibp = Node_map(cldp->n_sibh);
 			sibp->n_sibprevh = NH_NULL;
-			Node_unmap( cldp->n_sibh, &sibp );
+			Node_unmap(cldp->n_sibh, &sibp);
 		}
 	} else {
 		/* child is further down the child list */
@@ -3678,24 +3678,24 @@ disown( nh_t cldh )
 		node_t *prevcldp;
 
 		assert(prevcldh != NH_NULL); /* must be a previous */
-		prevcldp = Node_map( prevcldh );
+		prevcldp = Node_map(prevcldh);
 
 		/* fix up previous */
 		prevcldp->n_sibh = cldp->n_sibh;
-		Node_unmap( prevcldh, &prevcldp  );
+		Node_unmap(prevcldh, &prevcldp);
 
 		/* fix up next */
-		if ( cldp->n_sibh != NH_NULL ) {
-			node_t *sibp = Node_map( cldp->n_sibh );
+		if (cldp->n_sibh != NH_NULL) {
+			node_t *sibp = Node_map(cldp->n_sibh);
 			sibp->n_sibprevh = prevcldh;
-			Node_unmap( cldp->n_sibh, &sibp );
+			Node_unmap(cldp->n_sibh, &sibp);
 		}
 	}
-	Node_unmap( parh, &parp  );
+	Node_unmap(parh, &parp);
 	cldp->n_parh = NH_NULL;
 	cldp->n_sibh = NH_NULL;
 	cldp->n_sibprevh = NH_NULL;
-	Node_unmap( cldh, &cldp  );
+	Node_unmap(cldh, &cldp);
 
 	return nrh;
 }
@@ -3706,65 +3706,65 @@ disown( nh_t cldh )
  * any nondirs which might need to be restored.
  */
 static void
-selsubtree( nh_t nh, bool_t sensepr )
+selsubtree(nh_t nh, bool_t sensepr)
 {
 	node_t *np;
 	nh_t parh;
 
 	/* first mark the subtree
 	 */
-	selsubtree_recurse_down( nh, sensepr );
+	selsubtree_recurse_down(nh, sensepr);
 
 	/* get parent
 	 */
-	np = Node_map( nh );
+	np = Node_map(nh);
 	parh = np->n_parh;
-	Node_unmap( nh, &np );
+	Node_unmap(nh, &np);
 
 	/* next adjust ancestory
 	 */
-	while ( parh != NH_NULL ) {
+	while (parh != NH_NULL) {
 		node_t *parp;
 		nh_t newparh;
 
-		parp = Node_map( parh );
-		if ( sensepr ) {
+		parp = Node_map(parh);
+		if (sensepr) {
 			parp->n_flags |= NF_SUBTREE;
 		} else {
 			bool_t atleastonechildselpr = BOOL_FALSE;
 			nh_t cldh = parp->n_cldh;
-			while ( cldh != NH_NULL ) {
+			while (cldh != NH_NULL) {
 				node_t *cldp;
 				nh_t nextcldh;
 				bool_t cldsensepr;
-				cldp = Node_map( cldh );
-				cldsensepr = ( cldp->n_flags & NF_SUBTREE )
+				cldp = Node_map(cldh);
+				cldsensepr = (cldp->n_flags & NF_SUBTREE)
 					     ?
 					     BOOL_TRUE
 					     :
 					     BOOL_FALSE;
 				nextcldh = cldp->n_sibh;
-				Node_unmap( cldh, &cldp );
-				if ( cldsensepr ) {
+				Node_unmap(cldh, &cldp);
+				if (cldsensepr) {
 					atleastonechildselpr = BOOL_TRUE;
 					break;
 				}
 				cldh = nextcldh;
 			}
-			if ( ! atleastonechildselpr ) {
+			if (! atleastonechildselpr) {
 				parp->n_flags &= ~NF_SUBTREE;
 				/* DBG could break out here (remember to unmap!)
 				 */
 			}
 		}
 		newparh = parp->n_parh;
-		Node_unmap( parh, &parp );
+		Node_unmap(parh, &parp);
 		parh = newparh;
 	}
 }
 
 static void
-selsubtree_recurse_down( nh_t nh, bool_t sensepr )
+selsubtree_recurse_down(nh_t nh, bool_t sensepr)
 {
 	nh_t cldh;
 
@@ -3776,8 +3776,8 @@ selsubtree_recurse_down( nh_t nh, bool_t sensepr )
 		xfs_ino_t ino;
 		gen_t gen;
 
-		np = Node_map( nh );
-		if ( sensepr ) {
+		np = Node_map(nh);
+		if (sensepr) {
 			np->n_flags |= NF_SUBTREE;
 		} else {
 			np->n_flags &= ~NF_SUBTREE;
@@ -3785,33 +3785,33 @@ selsubtree_recurse_down( nh_t nh, bool_t sensepr )
 		cldh = np->n_cldh;
 		ino = np->n_ino;
 		gen = np->n_gen;
-		isdirpr = ( np->n_flags & NF_ISDIR );
-		Node_unmap( nh, &np  );
-		if ( ! isdirpr ) {
-			if ( sensepr ) {
-				inomap_rst_add( ino );
+		isdirpr = (np->n_flags & NF_ISDIR);
+		Node_unmap(nh, &np);
+		if (! isdirpr) {
+			if (sensepr) {
+				inomap_rst_add(ino);
 			} else {
 				/* check hardlist: don't del unless none needed
 				 */
 				nh_t nh;
 				bool_t neededpr = BOOL_FALSE;
-				for ( nh = link_hardh( ino, gen )
+				for (nh = link_hardh(ino, gen)
 				      ;
 				      nh != NH_NULL
 				      ;
-				      nh = link_nexth( nh )) {
+				      nh = link_nexth(nh)) {
 					node_t *np;
 					u_char_t flags;
-					np = Node_map( nh );
+					np = Node_map(nh);
 					flags = np->n_flags;
-					Node_unmap( nh, &np  );
-					if ( flags & NF_SUBTREE ) {
+					Node_unmap(nh, &np);
+					if (flags & NF_SUBTREE) {
 						neededpr = BOOL_TRUE;
 						break;
 					}
 				}
-				if ( ! neededpr ) {
-					inomap_rst_del( ino );
+				if (! neededpr) {
+					inomap_rst_del(ino);
 				}
 			}
 		}
@@ -3819,16 +3819,16 @@ selsubtree_recurse_down( nh_t nh, bool_t sensepr )
 
 	/* then mark all of its children. be sure to skip the orphanage!!!
 	 */
-	while ( cldh != NH_NULL ) {
+	while (cldh != NH_NULL) {
 		node_t *cldp;
 		nh_t nextcldh;
 
-		if ( cldh != persp->p_orphh ) {
-			selsubtree_recurse_down( cldh, sensepr );
+		if (cldh != persp->p_orphh) {
+			selsubtree_recurse_down(cldh, sensepr);
 		}
-		cldp = Node_map( cldh );
+		cldp = Node_map(cldh);
 		nextcldh = cldp->n_sibh;
-		Node_unmap( cldh, &cldp  );
+		Node_unmap(cldh, &cldp);
 		cldh = nextcldh;
 	}
 }
@@ -3839,22 +3839,22 @@ selsubtree_recurse_down( nh_t nh, bool_t sensepr )
 /* returns handle to head of hard link list
  */
 static nh_t
-link_hardh( xfs_ino_t ino, gen_t gen )
+link_hardh(xfs_ino_t ino, gen_t gen)
 {
-	return hash_find( ino, gen );
+	return hash_find(ino, gen);
 }
 
 /* returns following node in hard link list
  */
 static nh_t
-link_nexth( nh_t nh )
+link_nexth(nh_t nh)
 {
 	node_t *np;
 	nh_t nexth;
 
-	np = Node_map( nh );
+	np = Node_map(nh);
 	nexth = np->n_lnkh;
-	Node_unmap( nh, &np );
+	Node_unmap(nh, &np);
 	return nexth;
 }
 
@@ -3862,33 +3862,33 @@ link_nexth( nh_t nh )
  * returns hard link list head
  */
 static nh_t
-link_matchh( nh_t hardh, nh_t parh, char *name )
+link_matchh(nh_t hardh, nh_t parh, char *name)
 {
-	while ( hardh != NH_NULL ) {
+	while (hardh != NH_NULL) {
 		node_t *np;
 		nh_t nexth;
-		np = Node_map( hardh );
-		if ( np->n_parh == parh ) {
+		np = Node_map(hardh);
+		if (np->n_parh == parh) {
 			/* REFERENCED */
 			int namelen;
-			namelen = namreg_get( np->n_nrh,
+			namelen = namreg_get(np->n_nrh,
 					      tranp->t_namebuf,
-					      sizeof( tranp->t_namebuf ));
-			assert( namelen > 0 );
-			if ( ! strcmp( name, tranp->t_namebuf )) {
-				Node_unmap( hardh, &np );
+					      sizeof(tranp->t_namebuf));
+			assert(namelen > 0);
+			if (! strcmp(name, tranp->t_namebuf)) {
+				Node_unmap(hardh, &np);
 				break;
 			}
 		}
 		nexth = np->n_lnkh;
-		Node_unmap( hardh, &np );
+		Node_unmap(hardh, &np);
 		hardh = nexth;
 	}
 	return hardh;
 }
 
 static void
-link_in( nh_t nh )
+link_in(nh_t nh)
 {
 	node_t *np;
 	xfs_ino_t ino;
@@ -3902,45 +3902,45 @@ link_in( nh_t nh )
 
 	/* map in the node to read ino and gen
 	 */
-	np = Node_map( nh );
+	np = Node_map(nh);
 	ino = np->n_ino;
 	gen = np->n_gen;
 
 	/* see if one or more links already hashed.
 	 */
-	hardh = hash_find( ino, gen );
+	hardh = hash_find(ino, gen);
 
 	/* if not hashed, just hash it. otherwise put at end
 	 * of hard link (lnk) list.
 	 */
-	if ( hardh == NH_NULL ) {
+	if (hardh == NH_NULL) {
 #ifdef TREE_DEBUG
 		mlog(MLOG_DEBUG | MLOG_TREE,
 		    "link_in(): hash node in for ino %llu\n", ino);
 #endif
-		hash_in( nh );
+		hash_in(nh);
 	} else {
 		nh_t prevh = hardh;
-		node_t *prevp = Node_map( prevh );
+		node_t *prevp = Node_map(prevh);
 #ifdef TREE_DEBUG
 		mlog(MLOG_DEBUG | MLOG_TREE,
 		    "link_in(): put at end of hash list\n");
 #endif
-		while ( prevp->n_lnkh != NH_NULL ) {
+		while (prevp->n_lnkh != NH_NULL) {
 			nh_t nexth = prevp->n_lnkh;
-			Node_unmap( prevh, &prevp  );
+			Node_unmap(prevh, &prevp);
 			prevh = nexth;
-			prevp = Node_map( prevh );
+			prevp = Node_map(prevh);
 		}
 		prevp->n_lnkh = nh;
-		Node_unmap( prevh, &prevp  );
+		Node_unmap(prevh, &prevp);
 	}
 
 	/* since always put at end of hard link list, make node's
 	 * lnk member terminate list.
 	 */
 	np->n_lnkh = NH_NULL;
-	Node_unmap( nh, &np  );
+	Node_unmap(nh, &np);
 #ifdef TREE_DEBUG
 	mlog(MLOG_DEBUG | MLOG_TREE,
 	    "link_in(%llu): UNmap in node\n", nh);
@@ -3948,7 +3948,7 @@ link_in( nh_t nh )
 }
 
 static void
-link_out( nh_t nh )
+link_out(nh_t nh)
 {
 	node_t *np;
 	xfs_ino_t ino;
@@ -3957,58 +3957,58 @@ link_out( nh_t nh )
 
 	/* map in the node to read ino and gen
 	 */
-	np = Node_map( nh );
+	np = Node_map(nh);
 	ino = np->n_ino;
 	gen = np->n_gen;
 
 	/* get head of hard link list
 	 */
-	hardh = hash_find( ino, gen );
-	assert( hardh != NH_NULL );
+	hardh = hash_find(ino, gen);
+	assert(hardh != NH_NULL);
 
 	/* if node is at head of hard link list, hash it out and
 	 * hash in the following node in link list, if there is one.
 	 * otherwise, unlink from hardlink list.
 	 */
-	if ( nh == hardh ) {
-		hash_out( nh );
-		if ( np->n_lnkh != NH_NULL ) {
-			hash_in( np->n_lnkh );
+	if (nh == hardh) {
+		hash_out(nh);
+		if (np->n_lnkh != NH_NULL) {
+			hash_in(np->n_lnkh);
 		}
 	} else {
 		nh_t prevh = hardh;
-		node_t *prevp = Node_map( prevh );
-		while ( prevp->n_lnkh != nh ) {
+		node_t *prevp = Node_map(prevh);
+		while (prevp->n_lnkh != nh) {
 			nh_t nexth = prevp->n_lnkh;
-			Node_unmap( prevh, &prevp  );
+			Node_unmap(prevh, &prevp);
 			prevh = nexth;
-			assert( prevh != NH_NULL );
-			prevp = Node_map( prevh );
+			assert(prevh != NH_NULL);
+			prevp = Node_map(prevh);
 		}
 		prevp->n_lnkh = np->n_lnkh;
-		Node_unmap( prevh, &prevp  );
+		Node_unmap(prevh, &prevp);
 	}
 	np->n_lnkh = NH_NULL;
 
 	/* release the mapping
 	 */
-	Node_unmap( nh, &np  );
+	Node_unmap(nh, &np);
 }
 
 /* invokes callback for all hardheads
  * iteration aborted if callback returns FALSE
  */
 static void
-link_headiter( bool_t ( * cbfp )( void *contextp, nh_t hardh ), void *contextp )
+link_headiter(bool_t (* cbfp)(void *contextp, nh_t hardh), void *contextp)
 {
-	hash_iter( cbfp, contextp );
+	hash_iter(cbfp, contextp);
 }
 
 /* iterator for a hard link list. allows deletion of the last node
  * returned.
  */
 static void
-link_iter_init( link_iter_context_t *link_iter_contextp, nh_t hardheadh )
+link_iter_init(link_iter_context_t *link_iter_contextp, nh_t hardheadh)
 {
 	link_iter_contextp->li_headh = hardheadh;
 	link_iter_contextp->li_prevh = NH_NULL;
@@ -4017,20 +4017,20 @@ link_iter_init( link_iter_context_t *link_iter_contextp, nh_t hardheadh )
 }
 
 static nh_t
-link_iter_next( link_iter_context_t *link_iter_contextp )
+link_iter_next(link_iter_context_t *link_iter_contextp)
 {
 	node_t *lastp;
 	nh_t tmplasth;
 
 	/* if already done, return
 	 */
-	if ( link_iter_contextp->li_donepr == BOOL_TRUE ) {
+	if (link_iter_contextp->li_donepr == BOOL_TRUE) {
 		return NH_NULL;
 	}
 
 	/* if no hardhead, done
 	 */
-	if ( link_iter_contextp->li_headh == NH_NULL ) {
+	if (link_iter_contextp->li_headh == NH_NULL) {
 		link_iter_contextp->li_donepr = BOOL_TRUE;
 		return NH_NULL;
 	}
@@ -4041,8 +4041,8 @@ link_iter_next( link_iter_context_t *link_iter_contextp )
 
 	/* if no last, must be first call
 	 */
-	if ( tmplasth == NH_NULL ) {
-		assert( link_iter_contextp->li_prevh == NH_NULL );
+	if (tmplasth == NH_NULL) {
+		assert(link_iter_contextp->li_prevh == NH_NULL);
 		link_iter_contextp->li_lasth = link_iter_contextp->li_headh;
 		return link_iter_contextp->li_lasth;
 	}
@@ -4050,13 +4050,13 @@ link_iter_next( link_iter_context_t *link_iter_contextp )
 	/* slide last into prev
 	 */
 	link_iter_contextp->li_prevh = tmplasth;
-	lastp = Node_map( tmplasth );
+	lastp = Node_map(tmplasth);
 	link_iter_contextp->li_lasth = lastp->n_lnkh;
-	Node_unmap( tmplasth, &lastp );
+	Node_unmap(tmplasth, &lastp);
 
 	/* if NULL, flag done
 	 */
-	if ( link_iter_contextp->li_lasth == NH_NULL ) {
+	if (link_iter_contextp->li_lasth == NH_NULL) {
 		link_iter_contextp->li_donepr = BOOL_TRUE;
 	}
 
@@ -4067,36 +4067,36 @@ link_iter_next( link_iter_context_t *link_iter_contextp )
 
 /* ARGSUSED */
 void
-link_iter_unlink( link_iter_context_t *link_iter_contextp, nh_t nh )
+link_iter_unlink(link_iter_context_t *link_iter_contextp, nh_t nh)
 {
 	node_t *lastp;
 	nh_t nexth;
 
 	/* sanity checks
 	 */
-	assert( link_iter_contextp->li_lasth != NH_NULL );
-	assert( nh == link_iter_contextp->li_lasth );
+	assert(link_iter_contextp->li_lasth != NH_NULL);
+	assert(nh == link_iter_contextp->li_lasth);
 
 	/* get the next node in list
 	 */
-	lastp = Node_map( link_iter_contextp->li_lasth );
+	lastp = Node_map(link_iter_contextp->li_lasth);
 	nexth = lastp->n_lnkh;
 	lastp->n_lnkh = NH_NULL;
-	Node_unmap( link_iter_contextp->li_lasth, &lastp );
+	Node_unmap(link_iter_contextp->li_lasth, &lastp);
 
-	if ( link_iter_contextp->li_lasth == link_iter_contextp->li_headh ) {
-		assert( link_iter_contextp->li_prevh == NH_NULL );
-		hash_out( link_iter_contextp->li_headh );
+	if (link_iter_contextp->li_lasth == link_iter_contextp->li_headh) {
+		assert(link_iter_contextp->li_prevh == NH_NULL);
+		hash_out(link_iter_contextp->li_headh);
 		link_iter_contextp->li_headh = nexth;
-		if ( nexth != NH_NULL ) {
-			hash_in( nexth );
+		if (nexth != NH_NULL) {
+			hash_in(nexth);
 		}
 	} else {
 		node_t *prevp;
-		assert( link_iter_contextp->li_prevh != NH_NULL );
-		prevp = Node_map( link_iter_contextp->li_prevh );
+		assert(link_iter_contextp->li_prevh != NH_NULL);
+		prevp = Node_map(link_iter_contextp->li_prevh);
 		prevp->n_lnkh = nexth;
-		Node_unmap( link_iter_contextp->li_prevh, &prevp );
+		Node_unmap(link_iter_contextp->li_prevh, &prevp);
 	}
 	link_iter_contextp->li_lasth = link_iter_contextp->li_prevh;
 	link_iter_contextp->li_prevh = NH_NULL;
@@ -4105,13 +4105,13 @@ link_iter_unlink( link_iter_context_t *link_iter_contextp, nh_t nh )
 
 /* hash abstraction *********************************************************/
 
-#define HASHLEN_MIN	( pgsz / sizeof( nh_t ))
+#define HASHLEN_MIN	(pgsz / sizeof(nh_t))
 
 static bool_t
-hash_init( size64_t vmsz,
+hash_init(size64_t vmsz,
 	   size64_t dircnt,
 	   size64_t nondircnt,
-	   char *perspath )
+	   char *perspath)
 {
 	size64_t hashlen;
 	size64_t loghashlen;
@@ -4121,94 +4121,94 @@ hash_init( size64_t vmsz,
 
 	/* sanity checks
 	 */
-	assert( pgsz % sizeof( nh_t ) == 0 );
+	assert(pgsz % sizeof(nh_t) == 0);
 
 	/* calculate the size of the hash array. must be a power of two,
 	 * and a multiple of the page size. don't use more than the available
 	 * vm. but enforce a minimum.
 	 */
-	vmlen = vmsz / sizeof( nh_t );
-	hashlenmax = min( vmlen, SIZEMAX );
-	hashlen = ( dircnt + nondircnt );
-	hashlen = max( hashlen, ( size64_t )HASHLEN_MIN );
-	hashlen = min( hashlen, hashlenmax );
+	vmlen = vmsz / sizeof(nh_t);
+	hashlenmax = min(vmlen, SIZEMAX);
+	hashlen = (dircnt + nondircnt);
+	hashlen = max(hashlen, (size64_t)HASHLEN_MIN);
+	hashlen = min(hashlen, hashlenmax);
 
-	for ( loghashlen = 0
+	for (loghashlen = 0
 	      ;
-	      ( ( size64_t )1 << loghashlen ) <= hashlen
+	      ((size64_t)1 << loghashlen) <= hashlen
 	      ;
-	      loghashlen++ )
+	      loghashlen++)
 		;
-	assert( loghashlen > 0 );
-	hashlen = ( size64_t )1 << loghashlen;
+	assert(loghashlen > 0);
+	hashlen = (size64_t)1 << loghashlen;
 	if (hashlen > hashlenmax)
 		hashlen >>= 1;
-	assert( hashlen <= hashlenmax );
+	assert(hashlen <= hashlenmax);
 
 	/* record hash size in persistent state
 	 */
-	persp->p_hashsz = hashlen * sizeof( nh_t );
+	persp->p_hashsz = hashlen * sizeof(nh_t);
 
 	/* map the hash array just after the persistent state header
 	 */
-	assert( persp->p_hashsz <= SIZEMAX );
-	assert( ! ( persp->p_hashsz % ( size64_t )pgsz ));
-	assert( ! ( PERSSZ % pgsz ));
-	tranp->t_hashp = ( nh_t * ) mmap_autogrow(
-					    ( size_t )persp->p_hashsz,
+	assert(persp->p_hashsz <= SIZEMAX);
+	assert(! (persp->p_hashsz % (size64_t)pgsz));
+	assert(! (PERSSZ % pgsz));
+	tranp->t_hashp = (nh_t *) mmap_autogrow(
+					    (size_t)persp->p_hashsz,
 					    tranp->t_persfd,
-					    ( off64_t )PERSSZ );
-	if ( tranp->t_hashp == ( nh_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_TREE, _(
+					    (off64_t)PERSSZ);
+	if (tranp->t_hashp == (nh_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_TREE, _(
 		      "unable to mmap hash array into %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* initialize the hash array to all NULL node handles
 	 */
-	for ( hix = 0 ; hix < ( ix_t )hashlen ; hix++ ) {
-		tranp->t_hashp[ hix ] = NH_NULL;
+	for (hix = 0 ; hix < (ix_t)hashlen ; hix++) {
+		tranp->t_hashp[hix] = NH_NULL;
 	}
 
 	/* build a hash mask. this works because hashlen is a power of two.
 	 * record in persistent state.
 	 */
-	assert( hashlen - 1 <= SIZEMAX );
-	persp->p_hashmask = ( size_t )( hashlen - 1 );
+	assert(hashlen - 1 <= SIZEMAX);
+	persp->p_hashmask = (size_t)(hashlen - 1);
 
 	return BOOL_TRUE;
 }
 
 static bool_t
-hash_sync( char *perspath )
+hash_sync(char *perspath)
 {
 	size64_t hashsz;
 
 	/* sanity checks
 	 */
-	assert( pgsz % sizeof( nh_t ) == 0 );
+	assert(pgsz % sizeof(nh_t) == 0);
 
 	/* retrieve the hash size from the persistent state
 	 */
 	hashsz = persp->p_hashsz;
-	assert( ! ( hashsz % sizeof( nh_t )));
+	assert(! (hashsz % sizeof(nh_t)));
 
 	/* map the hash array just after the persistent state header
 	 */
-	assert( hashsz <= SIZEMAX );
-	assert( ! ( hashsz % ( size64_t )pgsz ));
-	assert( ! ( PERSSZ % pgsz ));
-	tranp->t_hashp = ( nh_t * ) mmap_autogrow(
-					    ( size_t )hashsz,
+	assert(hashsz <= SIZEMAX);
+	assert(! (hashsz % (size64_t)pgsz));
+	assert(! (PERSSZ % pgsz));
+	tranp->t_hashp = (nh_t *) mmap_autogrow(
+					    (size_t)hashsz,
 					    tranp->t_persfd,
-					    ( off64_t )PERSSZ );
-	if ( tranp->t_hashp == ( nh_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_TREE, _(
+					    (off64_t)PERSSZ);
+	if (tranp->t_hashp == (nh_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_TREE, _(
 		      "unable to mmap hash array into %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
@@ -4228,7 +4228,7 @@ hash_val(xfs_ino_t ino, size_t hashmask)
 }
 
 static void
-hash_in( nh_t nh )
+hash_in(nh_t nh)
 {
 	node_t *np;
 	xfs_ino_t ino;
@@ -4237,7 +4237,7 @@ hash_in( nh_t nh )
 
 	/* get a mapping to the node
 	 */
-	np = Node_map( nh );
+	np = Node_map(nh);
 
 	/* get ino from node
 	 */
@@ -4245,7 +4245,7 @@ hash_in( nh_t nh )
 
 	/* assert not already in
 	 */
-	assert( hash_find( np->n_ino, np->n_gen ) == NH_NULL );
+	assert(hash_find(np->n_ino, np->n_gen) == NH_NULL);
 
 	/* calculate the hash index
 	 */
@@ -4253,21 +4253,21 @@ hash_in( nh_t nh )
 
 	/* get a pointer to the indexed hash array entry
 	 */
-	entryp = &tranp->t_hashp[ hix ];
+	entryp = &tranp->t_hashp[hix];
 
 	/* insert into the list, at the head
 	 */
-	assert( np->n_hashh == NH_NULL );
+	assert(np->n_hashh == NH_NULL);
 	np->n_hashh = *entryp;
 	*entryp = nh;
 
 	/* release the mapping
 	 */
-	Node_unmap( nh, &np  );
+	Node_unmap(nh, &np);
 }
 
 static void
-hash_out( nh_t nh )
+hash_out(nh_t nh)
 {
 	node_t *np;
 	xfs_ino_t ino;
@@ -4277,7 +4277,7 @@ hash_out( nh_t nh )
 
 	/* get a mapping to the node
 	 */
-	np = Node_map( nh );
+	np = Node_map(nh);
 
 	/* get the ino
 	 */
@@ -4286,40 +4286,40 @@ hash_out( nh_t nh )
 	/* get a pointer to the hash array entry
 	 */
 	hix = hash_val(ino, persp->p_hashmask);
-	entryp = &tranp->t_hashp[ hix ];
+	entryp = &tranp->t_hashp[hix];
 
 	/* get the handle of the first node in the appropriate hash array
 	 */
 	hashheadh = *entryp;
-	assert( hashheadh != NH_NULL );
+	assert(hashheadh != NH_NULL);
 
 	/* if node is first in list, replace entry with following node.
 	 * otherwise, walk the list until found.
 	 */
-	if ( hashheadh == nh ) {
+	if (hashheadh == nh) {
 		*entryp = np->n_hashh;
 	} else {
 		nh_t prevh = hashheadh;
-		node_t *prevp = Node_map( prevh );
-		while ( prevp->n_hashh != nh ) {
+		node_t *prevp = Node_map(prevh);
+		while (prevp->n_hashh != nh) {
 			nh_t nexth = prevp->n_hashh;
-			Node_unmap( prevh, &prevp  );
+			Node_unmap(prevh, &prevp);
 			prevh = nexth;
-			assert( prevh != NH_NULL );
-			prevp = Node_map( prevh );
+			assert(prevh != NH_NULL);
+			prevp = Node_map(prevh);
 		}
 		prevp->n_hashh = np->n_hashh;
-		Node_unmap( prevh, &prevp  );
+		Node_unmap(prevh, &prevp);
 	}
 	np->n_hashh = NH_NULL;
 
 	/* release the mapping
 	 */
-	Node_unmap( nh, &np  );
+	Node_unmap(nh, &np);
 }
 
 static nh_t
-hash_find( xfs_ino_t ino, gen_t gen )
+hash_find(xfs_ino_t ino, gen_t gen)
 {
 	nh_t nh;
 	node_t *np;
@@ -4328,11 +4328,11 @@ hash_find( xfs_ino_t ino, gen_t gen )
 	/* get handle to first node in appropriate hash array
 	 */
 	hix = hash_val(ino, persp->p_hashmask);
-	nh = tranp->t_hashp[ hix ];
+	nh = tranp->t_hashp[hix];
 
 	/* if list empty, return null handle
 	 */
-	if ( nh == NH_NULL ) {
+	if (nh == NH_NULL) {
 		return NH_NULL;
 	}
 
@@ -4344,17 +4344,17 @@ hash_find( xfs_ino_t ino, gen_t gen )
 
 	/* walk the list until found.
 	 */
-	np = Node_map( nh );
-	while ( np->n_ino != ino || np->n_gen != gen ) {
+	np = Node_map(nh);
+	while (np->n_ino != ino || np->n_gen != gen) {
 		nh_t nextnh = np->n_hashh;
-		Node_unmap( nh, &np  );
+		Node_unmap(nh, &np);
 		nh = nextnh;
-		if ( nh == NH_NULL ) {
+		if (nh == NH_NULL) {
 			return NH_NULL;
 		}
-		np = Node_map( nh );
+		np = Node_map(nh);
 	}
-	Node_unmap( nh, &np  );
+	Node_unmap(nh, &np);
 
 #ifdef TREE_DEBUG
 	mlog(MLOG_DEBUG | MLOG_TREE,
@@ -4369,25 +4369,25 @@ hash_find( xfs_ino_t ino, gen_t gen )
  * must figure next node prior to calling callback.
  */
 static void
-hash_iter( bool_t ( * cbfp )( void *contextp, nh_t hashh ), void *contextp )
+hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh), void *contextp)
 {
 	ix_t hix;
-	size64_t hashlen = persp->p_hashsz / sizeof( nh_t );
+	size64_t hashlen = persp->p_hashsz / sizeof(nh_t);
 
-	for ( hix = 0 ; hix < ( ix_t )hashlen ; hix++ ) {
-		nh_t nh = tranp->t_hashp[ hix ];
+	for (hix = 0 ; hix < (ix_t)hashlen ; hix++) {
+		nh_t nh = tranp->t_hashp[hix];
 
-		while ( nh != NH_NULL ) {
+		while (nh != NH_NULL) {
 			node_t *np;
 			nh_t nexth;
 			bool_t ok;
 
-			np = Node_map( nh );
+			np = Node_map(nh);
 			nexth = np->n_hashh;
-			Node_unmap( nh, &np );
+			Node_unmap(nh, &np);
 
-			ok = ( * cbfp )( contextp, nh );
-			if ( ! ok ) {
+			ok = (* cbfp)(contextp, nh);
+			if (! ok) {
 				return;
 			}
 
@@ -4404,75 +4404,75 @@ hash_iter( bool_t ( * cbfp )( void *contextp, nh_t hashh ), void *contextp )
  * and sibling handles.
  */
 static bool_t
-Node_chk( nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp )
+Node_chk(nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp)
 {
 	node_t *np;
 	node_t n;
-	char nambuf[ NAME_MAX + 1 ];
+	char nambuf[NAME_MAX + 1];
 	bool_t okaccum;
 
-	mlog( MLOG_NITTY + 1 | MLOG_TREE,
+	mlog(MLOG_NITTY + 1 | MLOG_TREE,
 	      "checking node nh == 0x%x\n",
-	      nh );
+	      nh);
 
 	okaccum = BOOL_TRUE;
 
-	if ( nexthashhp ) {
+	if (nexthashhp) {
 		*nexthashhp = NH_NULL;
 	}
 
-	assert( nextlnkhp );
+	assert(nextlnkhp);
 	*nextlnkhp = NH_NULL;
 
-	np = Node_map( nh );
-	assert( np );
+	np = Node_map(nh);
+	assert(np);
 	n = *np;
-	Node_unmap( nh, &np );
+	Node_unmap(nh, &np);
 
-	if ( ! nexthashhp && n.n_hashh != NH_NULL ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
+	if (! nexthashhp && n.n_hashh != NH_NULL) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
 		      "nh 0x%x np 0x%x hash link not null\n"),
 		      nh,
-		      np );
+		      np);
 		okaccum = BOOL_FALSE;
 	}
 
-	if ( n.n_hashh != NH_NULL ) {
-		np = Node_map( n.n_hashh );
-		Node_unmap( n.n_hashh, &np );
+	if (n.n_hashh != NH_NULL) {
+		np = Node_map(n.n_hashh);
+		Node_unmap(n.n_hashh, &np);
 	}
 
-	if ( n.n_lnkh != NH_NULL ) {
-		np = Node_map( n.n_lnkh );
-		Node_unmap( n.n_lnkh, &np );
+	if (n.n_lnkh != NH_NULL) {
+		np = Node_map(n.n_lnkh);
+		Node_unmap(n.n_lnkh, &np);
 	}
 
-	if ( n.n_parh != NH_NULL ) {
-		np = Node_map( n.n_parh );
-		Node_unmap( n.n_parh, &np );
+	if (n.n_parh != NH_NULL) {
+		np = Node_map(n.n_parh);
+		Node_unmap(n.n_parh, &np);
 	}
 
-	if ( n.n_cldh != NH_NULL ) {
-		np = Node_map( n.n_cldh );
-		Node_unmap( n.n_cldh, &np );
+	if (n.n_cldh != NH_NULL) {
+		np = Node_map(n.n_cldh);
+		Node_unmap(n.n_cldh, &np);
 	}
 
-	if ( n.n_sibh != NH_NULL ) {
-		np = Node_map( n.n_sibh );
-		Node_unmap( n.n_sibh, &np );
+	if (n.n_sibh != NH_NULL) {
+		np = Node_map(n.n_sibh);
+		Node_unmap(n.n_sibh, &np);
 	}
 
-	if ( n.n_nrh != NRH_NULL ) {
+	if (n.n_nrh != NRH_NULL) {
 		int rval;
-		rval = namreg_get( n.n_nrh, nambuf, sizeof( nambuf ));
-		assert( rval >= 0 );
+		rval = namreg_get(n.n_nrh, nambuf, sizeof(nambuf));
+		assert(rval >= 0);
 	}
 
-	if ( n.n_dah != DAH_NULL ) {
-		( void )dirattr_get_mode( n.n_dah );
+	if (n.n_dah != DAH_NULL) {
+		(void)dirattr_get_mode(n.n_dah);
 	}
 
-	if ( nexthashhp ) {
+	if (nexthashhp) {
 		*nexthashhp = n.n_hashh;
 	}
 
@@ -4482,75 +4482,75 @@ Node_chk( nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp )
 }
 
 bool_t
-tree_chk( void )
+tree_chk(void)
 {
 	ix_t hix;
-	size64_t hashlen = persp->p_hashsz / sizeof( nh_t );
+	size64_t hashlen = persp->p_hashsz / sizeof(nh_t);
 	bool_t ok;
 	bool_t okaccum;
 
 	okaccum = BOOL_TRUE;
 
-	for ( hix = 0 ; hix < ( ix_t )hashlen ; hix++ ) {
-		nh_t hashh = tranp->t_hashp[ hix ];
+	for (hix = 0 ; hix < (ix_t)hashlen ; hix++) {
+		nh_t hashh = tranp->t_hashp[hix];
 
-		mlog( MLOG_NITTY + 1 | MLOG_TREE,
+		mlog(MLOG_NITTY + 1 | MLOG_TREE,
 		      "checking hix %u\n",
-		      hix );
-		while ( hashh != NH_NULL ) {
+		      hix);
+		while (hashh != NH_NULL) {
 			nh_t lnkh;
 
-			ok = Node_chk( hashh, &hashh, &lnkh );
-			if ( ! ok ) {
+			ok = Node_chk(hashh, &hashh, &lnkh);
+			if (! ok) {
 				okaccum = BOOL_FALSE;
 			}
 
-			while ( lnkh != NH_NULL ) {
-				ok = Node_chk( lnkh, 0, &lnkh );
-				if ( ! ok ) {
+			while (lnkh != NH_NULL) {
+				ok = Node_chk(lnkh, 0, &lnkh);
+				if (! ok) {
 					okaccum = BOOL_FALSE;
 				}
 			}
 		}
 	}
 
-	ok = tree_chk2( );
-	if ( ! ok ) {
+	ok = tree_chk2();
+	if (! ok) {
 		okaccum = BOOL_FALSE;
 	}
 
 	return okaccum;
 }
 
-static bool_t tree_chk2_recurse( nh_t cldh, nh_t parh );
+static bool_t tree_chk2_recurse(nh_t cldh, nh_t parh);
 
 static bool_t
-tree_chk2( void )
+tree_chk2(void)
 {
 	node_t *rootp;
 	nh_t cldh;
 	bool_t ok;
 
-	mlog( MLOG_DEBUG | MLOG_TREE,
-	      "tree hierarchy check\n" );
+	mlog(MLOG_DEBUG | MLOG_TREE,
+	      "tree hierarchy check\n");
 
-	rootp = Node_map( persp->p_rooth );
+	rootp = Node_map(persp->p_rooth);
 	cldh = rootp->n_cldh;
-	Node_unmap( persp->p_rooth, &rootp );
+	Node_unmap(persp->p_rooth, &rootp);
 
-	ok = tree_chk2_recurse( cldh, persp->p_rooth );
+	ok = tree_chk2_recurse(cldh, persp->p_rooth);
 
 	return ok;
 }
 
 static bool_t
-tree_chk2_recurse( nh_t cldh, nh_t parh )
+tree_chk2_recurse(nh_t cldh, nh_t parh)
 {
 	bool_t okaccum = BOOL_TRUE;
 
-	assert( parh != NH_NULL );
+	assert(parh != NH_NULL);
 
-	while ( cldh != NH_NULL ) {
+	while (cldh != NH_NULL) {
 		node_t *cldp;
 		xfs_ino_t ino;
 		gen_t gen;
@@ -4560,37 +4560,37 @@ tree_chk2_recurse( nh_t cldh, nh_t parh )
 		nh_t nextcldh;
 		bool_t ok;
 
-		cldp = Node_map( cldh );
+		cldp = Node_map(cldh);
 		ino = cldp->n_ino;
 		gen = cldp->n_gen;
 		nodeparh = cldp->n_parh;
 		nrh = cldp->n_nrh;
 		grandcldh = cldp->n_cldh;
 		nextcldh = cldp->n_sibh;
-		Node_unmap( cldh, &cldp );
+		Node_unmap(cldh, &cldp);
 
-		if ( parh == persp->p_orphh ) {
-			sprintf( tranp->t_namebuf, "%llu.%u", ino, gen );
-		} else if ( cldh == persp->p_orphh ) {
-			sprintf( tranp->t_namebuf, "%llu.%u", ino, gen );
+		if (parh == persp->p_orphh) {
+			sprintf(tranp->t_namebuf, "%llu.%u", ino, gen);
+		} else if (cldh == persp->p_orphh) {
+			sprintf(tranp->t_namebuf, "%llu.%u", ino, gen);
 		} else {
 			int namelen;
-			namelen = namreg_get( nrh,
+			namelen = namreg_get(nrh,
 					      tranp->t_namebuf,
-					      sizeof( tranp->t_namebuf ));
-			assert( namelen >= 0 );
+					      sizeof(tranp->t_namebuf));
+			assert(namelen >= 0);
 		}
 
-		if ( nodeparh == NH_NULL ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+		if (nodeparh == NH_NULL) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 			      "node %x %s %llu %u parent NULL\n"),
 			      cldh,
 			      tranp->t_namebuf,
 			      ino,
-			      gen );
+			      gen);
 			return BOOL_FALSE;
-		} else if ( nodeparh != parh ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+		} else if (nodeparh != parh) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 			      "node %x %s %llu %u parent mismatch: "
 			      "nodepar %x par %x\n"),
 			      cldh,
@@ -4598,19 +4598,19 @@ tree_chk2_recurse( nh_t cldh, nh_t parh )
 			      ino,
 			      gen,
 			      nodeparh,
-			      parh );
+			      parh);
 			return BOOL_FALSE;
 		} else {
-			mlog( MLOG_DEBUG | MLOG_TREE,
+			mlog(MLOG_DEBUG | MLOG_TREE,
 			      "node %x %s %llu %u  parent %x\n",
 			      cldh,
 			      tranp->t_namebuf,
 			      ino,
 			      gen,
-			      parh );
+			      parh);
 		}
-		ok = tree_chk2_recurse( grandcldh, cldh );
-		if ( ! ok ) {
+		ok = tree_chk2_recurse(grandcldh, cldh);
+		if (! ok) {
 			okaccum = BOOL_FALSE;
 		}
 
@@ -4624,14 +4624,14 @@ tree_chk2_recurse( nh_t cldh, nh_t parh )
 
 static char *whites = " \t\r\n\v\f";
 
-static int is_white( char c );
-static void fix_escape( char *string, char *liter );
-static void fix_quoted_span( char *string, char *liter );
-static void collapse_white( char *string, char *liter );
-static size_t distance_to_space( char *s, char *l );
+static int is_white(char c);
+static void fix_escape(char *string, char *liter);
+static void fix_quoted_span(char *string, char *liter);
+static void collapse_white(char *string, char *liter);
+static size_t distance_to_space(char *s, char *l);
 
 static int
-parse( int slotcnt, char **slotbuf, char *string )
+parse(int slotcnt, char **slotbuf, char *string)
 {
 	char *liter;
 	char *s;
@@ -4640,39 +4640,39 @@ parse( int slotcnt, char **slotbuf, char *string )
 
 	/* sanity checkcs
 	 */
-	assert( slotcnt >= 0 );
+	assert(slotcnt >= 0);
 
 	/* allocate a companion to the input string for identifying
 	 * characters which are to be interpreted literally.
 	 */
-	liter = ( char * )calloc( 1, strlen( string ) + 1 );
-	if ( ! liter ) {
+	liter = (char *)calloc(1, strlen(string) + 1);
+	if (! liter) {
 		return -1;
 	}
 
 	/* pass 1: collapse escape sequences, identifying characters which
 	 * are to be interpreted literally
 	 */
-	for ( s = string, l = liter ; *s ; s++, l++ ) {
-		if ( *s == '\\' && ! *l ) {
-			fix_escape( s, l );
+	for (s = string, l = liter ; *s ; s++, l++) {
+		if (*s == '\\' && ! *l) {
+			fix_escape(s, l);
 		}
 	}
 
 	/* pass 2: collapse quoted spans, identifying characters which
 	 * are to be interpreted literally
 	 */
-	for ( s = string, l = liter ; *s ; s++, l++ ) {
-		if ( *s == '\"' && ! *l ) {
-			fix_quoted_span( s, l );
+	for (s = string, l = liter ; *s ; s++, l++) {
+		if (*s == '\"' && ! *l) {
+			fix_quoted_span(s, l);
 		}
 	}
 
 	/* pass 3: collapse white space spans into a single space
 	 */
-	for ( s = string, l = liter ; *s ; s++, l++ ) {
-		if ( is_white( *s ) && ! *l ) {
-			collapse_white( s, l );
+	for (s = string, l = liter ; *s ; s++, l++) {
+		if (is_white(*s) && ! *l) {
+			collapse_white(s, l);
 		}
 	}
 
@@ -4681,24 +4681,24 @@ parse( int slotcnt, char **slotbuf, char *string )
 	wordcnt = 0;
 	s = string;
 	l = liter;
-	while ( *s ) {
+	while (*s) {
 		size_t d;
-		if ( wordcnt < ( size_t )slotcnt ) {
-			slotbuf[ wordcnt ] = s;
+		if (wordcnt < (size_t)slotcnt) {
+			slotbuf[wordcnt] = s;
 		}
 		wordcnt++;
-		d = distance_to_space( s, l );
+		d = distance_to_space(s, l);
 		s += d;
 		l += d;
-		if ( *s ) {
+		if (*s) {
 			*s = 0;
 			s++;
 			l++;
 		}
 	}
 
-	free( ( void * )liter );
-	return ( int )wordcnt;
+	free((void *)liter);
+	return (int)wordcnt;
 }
 
 struct escape_table {
@@ -4707,7 +4707,7 @@ struct escape_table {
 };
 typedef struct escape_table escape_table_t;
 
-static escape_table_t escape_table[ ] = {
+static escape_table_t escape_table[] = {
  {	'n',	'\n' },
  {	't',	'\t' },
  {	'v',	'\v' },
@@ -4719,14 +4719,14 @@ static escape_table_t escape_table[ ] = {
  {	'\\',	'\\' }
 };
 
-static void shrink( char *s, size_t cnt );
-static int is_hex( char c );
-static size_t hex_to_size( char c );
-static int is_octal( char c );
-static size_t octal_to_size( char c );
+static void shrink(char *s, size_t cnt);
+static int is_hex(char c);
+static size_t hex_to_size(char c);
+static int is_octal(char c);
+static size_t octal_to_size(char c);
 
 static void
-fix_escape( char *string, char *liter )
+fix_escape(char *string, char *liter)
 {
 	escape_table_t *ep;
 	escape_table_t *endep;
@@ -4734,129 +4734,129 @@ fix_escape( char *string, char *liter )
 	/* first look for special escapes described in table
 	 */
 	ep = escape_table;
-	endep = escape_table + ( sizeof( escape_table )
+	endep = escape_table + (sizeof(escape_table)
 			         /
-			         sizeof( escape_table[ 0 ] ));
-	for ( ; ep < endep ; ep++ ) {
-		if ( string[ 1 ] == ep->sequence ) {
-			string[ 0 ] = ep->substitute;
-			liter[ 0 ] = ( char )1;
-			shrink( &string[ 1 ], 1 );
-			shrink( &liter[ 1 ], 1 );
+			         sizeof(escape_table[0]));
+	for (; ep < endep ; ep++) {
+		if (string[1] == ep->sequence) {
+			string[0] = ep->substitute;
+			liter[0] = (char)1;
+			shrink(&string[1], 1);
+			shrink(&liter[1], 1);
 			return;
 		}
 	}
 
 	/* detect white space escapes
 	 */
-	if ( is_white( string[ 1 ] )) {
-		liter[ 0 ] = ( char )1;
-		shrink( &string[ 0 ], 1 );
-		shrink( &liter[ 1 ], 1 );
+	if (is_white(string[1])) {
+		liter[0] = (char)1;
+		shrink(&string[0], 1);
+		shrink(&liter[1], 1);
 		return;
 	}
 
 	/* detect hex escapes (don't allow null)
 	 */
-	if ( string[ 1 ] == 'x' ) {
+	if (string[1] == 'x') {
 		size_t hexlen;
 		size_t accum;
 		accum = 0;
-		for ( hexlen = 0
+		for (hexlen = 0
 		      ;
-		      hexlen < 2 && is_hex( string[ 2 + hexlen ] )
+		      hexlen < 2 && is_hex(string[2 + hexlen])
 		      ;
-		      hexlen++ ) {
+		      hexlen++) {
 			accum *= 16;
-			accum += hex_to_size( string[ 2 + hexlen ] );
+			accum += hex_to_size(string[2 + hexlen]);
 		}
-		if ( hexlen && accum ) {
-			string[ 0 ] = ( char )accum;
-			liter[ 0 ] = ( char )1;
-			shrink( &string[ 1 ], 1 + hexlen );
-			shrink( &liter[ 1 ], 1 + hexlen );
+		if (hexlen && accum) {
+			string[0] = (char)accum;
+			liter[0] = (char)1;
+			shrink(&string[1], 1 + hexlen);
+			shrink(&liter[1], 1 + hexlen);
 			return;
 		}
 	}
 
 	/* detect octal escapes (don't allow null)
 	 */
-	if ( is_octal( string[ 1 ] )) {
+	if (is_octal(string[1])) {
 		size_t octallen;
 		size_t accum;
-		accum = octal_to_size( string[ 1 ] );
-		for ( octallen = 1
+		accum = octal_to_size(string[1]);
+		for (octallen = 1
 		      ;
-		      octallen < 3 && is_octal( string[ 1 + octallen ] )
+		      octallen < 3 && is_octal(string[1 + octallen])
 		      ;
-		      octallen++ ) {
+		      octallen++) {
 			accum *= 8;
-			accum += octal_to_size( string[ 1 + octallen ] );
+			accum += octal_to_size(string[1 + octallen]);
 		}
-		if ( accum ) {
-			string[ 0 ] = ( char )accum;
-			liter[ 0 ] = ( char )1;
-			shrink( &string[ 1 ], octallen );
-			shrink( &liter[ 1 ], octallen );
+		if (accum) {
+			string[0] = (char)accum;
+			liter[0] = (char)1;
+			shrink(&string[1], octallen);
+			shrink(&liter[1], octallen);
 			return;
 		}
 	}
 
 	/* didn't match any escape sequences, so assume literal
 	 */
-	liter[ 0 ] = ( char )1;
+	liter[0] = (char)1;
 }
 
 static void
-fix_quoted_span( char *string, char *liter )
+fix_quoted_span(char *string, char *liter)
 {
 	char *s;
 	char *l;
 
 	/* first cover the leading quote
 	 */
-	shrink( string, 1 );
-	shrink( liter, 1 );
+	shrink(string, 1);
+	shrink(liter, 1);
 
 	/* scan for the next non-literal quote, marking all
 	 * characters in between as literal
 	 */
-	for ( s = string, l = liter ; *s && ( *s != '\"' || *l ) ; s++, l++ ) {
-		*l = ( char )1;
+	for (s = string, l = liter ; *s && (*s != '\"' || *l) ; s++, l++) {
+		*l = (char)1;
 	}
 
-	if ( *s ) {
-		shrink( s, 1 );
-		shrink( l, 1 );
+	if (*s) {
+		shrink(s, 1);
+		shrink(l, 1);
 	}
 }
 
 static void
-collapse_white( char *string, char *liter )
+collapse_white(char *string, char *liter)
 {
 	char *s;
 	char *l;
 	size_t cnt;
 
 	cnt = 0;
-	for ( s = string, l = liter ; is_white( *s ) && ! *l ; s++, l++ ) {
+	for (s = string, l = liter ; is_white(*s) && ! *l ; s++, l++) {
 		cnt++;
 	}
 
-	string[ 0 ] = ' ';
+	string[0] = ' ';
 
-	if ( cnt > 1 ) {
-		shrink( &string[ 1 ], cnt - 1 );
-		shrink( &liter[ 1 ], cnt - 1 );
+	if (cnt > 1) {
+		shrink(&string[1], cnt - 1);
+		shrink(&liter[1], cnt - 1);
 	}
 }
 
 static size_t
-distance_to_space( char *s, char *l )
+distance_to_space(char *s, char *l)
 {
 	size_t cnt;
 
-	for ( cnt = 0 ; *s && ( ! is_white( *s ) || *l ) ; s++, l++ ) {
+	for (cnt = 0 ; *s && (! is_white(*s) || *l) ; s++, l++) {
 		cnt++;
 	}
 
@@ -4864,15 +4864,15 @@ distance_to_space( char *s, char *l )
 }
 
 static void
-shrink( char *s, size_t cnt )
+shrink(char *s, size_t cnt)
 {
-	strcpy( s, s + cnt );
+	strcpy(s, s + cnt);
 }
 
 static int
-is_white( char c )
+is_white(char c)
 {
-	if ( c && strchr( whites, ( int )c )) {
+	if (c && strchr(whites, (int)c)) {
 		return 1;
 	} else {
 		return 0;
@@ -4880,17 +4880,17 @@ is_white( char c )
 }
 
 static int
-is_hex( char c )
+is_hex(char c)
 {
-	if ( c >= '0' && c <= '9' ) {
+	if (c >= '0' && c <= '9') {
 		return 1;
 	}
 
-	if ( c >= 'a' && c <= 'f' ) {
+	if (c >= 'a' && c <= 'f') {
 		return 1;
 	}
 
-	if ( c >= 'A' && c <= 'F' ) {
+	if (c >= 'A' && c <= 'F') {
 		return 1;
 	}
 
@@ -4898,27 +4898,27 @@ is_hex( char c )
 }
 
 static size_t
-hex_to_size( char c )
+hex_to_size(char c)
 {
-	if ( c >= '0' && c <= '9' ) {
-		return ( size_t )( c - '0' );
+	if (c >= '0' && c <= '9') {
+		return (size_t)(c - '0');
 	}
 
-	if ( c >= 'a' && c <= 'f' ) {
-		return ( size_t )( c - 'a' ) + ( size_t )0xa;
+	if (c >= 'a' && c <= 'f') {
+		return (size_t)(c - 'a') + (size_t)0xa;
 	}
 
-	if ( c >= 'A' && c <= 'F' ) {
-		return ( size_t )( c - 'A' ) + ( size_t )0xa;
+	if (c >= 'A' && c <= 'F') {
+		return (size_t)(c - 'A') + (size_t)0xa;
 	}
 
 	return 0;
 }
 
 static int
-is_octal( char c )
+is_octal(char c)
 {
-	if ( c >= '0' && c <= '7' ) {
+	if (c >= '0' && c <= '7') {
 		return 1;
 	}
 
@@ -4926,10 +4926,10 @@ is_octal( char c )
 }
 
 static size_t
-octal_to_size( char c )
+octal_to_size(char c)
 {
-	if ( c >= '0' && c <= '7' ) {
-		return ( size_t )( c - '0' );
+	if (c >= '0' && c <= '7') {
+		return (size_t)(c - '0');
 	}
 
 	return 0;
@@ -4946,7 +4946,7 @@ mkdir_r(char *path)
 		return mkdir(path, 0755);
 	}
 	else if ((sbuf.st_mode & S_IFDIR) == 0) {
-		mlog( MLOG_TRACE | MLOG_ERROR | MLOG_TREE, _(
+		mlog(MLOG_TRACE | MLOG_ERROR | MLOG_TREE, _(
 			"%s is not a directory\n"),
 			path);
 		mlog_exit(EXIT_ERROR, RV_EXISTS);
diff --git a/restore/tree.h b/restore/tree.h
index 47911c4..6c9551b 100644
--- a/restore/tree.h
+++ b/restore/tree.h
@@ -20,7 +20,7 @@
 
 /* tree_init - creates a new tree abstraction.
  */
-extern bool_t tree_init( char *hkdir,
+extern bool_t tree_init(char *hkdir,
 			 char *dstdir,
 			 bool_t toconlypr,
 			 bool_t ownerpr,
@@ -34,15 +34,15 @@ extern bool_t tree_init( char *hkdir,
 			 bool_t restoredmpr,
 			 bool_t dstdirisxfspr,
 			 uint32_t dumpformat,
-			 bool_t truncategenpr );
+			 bool_t truncategenpr);
 
 /* tree_sync - synchronizes with an existing tree abstraction
  */
-extern bool_t tree_sync( char *hkdir,
+extern bool_t tree_sync(char *hkdir,
 			 char *dstdir,
 			 bool_t toconlypr,
 			 bool_t fullpr,
-			 bool_t dstdirisxfspr );
+			 bool_t dstdirisxfspr);
 
 /* tree_check_dump_format - detect the rare case where a
  * cumulative restore begins with a format 3 (or newer)
@@ -50,32 +50,32 @@ extern bool_t tree_sync( char *hkdir,
  * a format 2 dump. the restore will fail unless the
  * original restore was told to use format 2 gen numbers.
  */
-extern bool_t tree_check_dump_format( uint32_t dumpformat );
+extern bool_t tree_check_dump_format(uint32_t dumpformat);
 
 
 /* tree_begindir - begins application of dumped directory to tree.
  * returns handle to dir node. returns by reference the dirattr
  * handle if new. caller must pre-zero (DAH_NULL).
  */
-extern nh_t tree_begindir( filehdr_t *fhdrp, dah_t *dahp );
+extern nh_t tree_begindir(filehdr_t *fhdrp, dah_t *dahp);
 
 /* tree_addent - adds a directory entry; takes dirh from above call
  */
-extern rv_t tree_addent( nh_t dirh,
+extern rv_t tree_addent(nh_t dirh,
 			 xfs_ino_t ino,
 			 gen_t gen,
 			 char *name,
-			 size_t namelen );
+			 size_t namelen);
 
 /* ends application of dir
  */
-extern void tree_enddir( nh_t dirh );
+extern void tree_enddir(nh_t dirh);
 
 #ifdef TREE_CHK
 /* tree_chk - do a sanity check of the tree prior to post-processing and
  * non-dir restoral. returns FALSE if corruption detected.
  */
-extern bool_t tree_chk( void );
+extern bool_t tree_chk(void);
 #endif /* TREE_CHK */
 
 /* tree_marknoref - mark all nodes as no reference, not dumped dirs, and
@@ -83,40 +83,40 @@ extern bool_t tree_chk( void );
  * of the restoral of a dump session, in order to detect directory entries
  * no longer needed.
  */
-extern void tree_marknoref( void );
+extern void tree_marknoref(void);
 
 /* mark all nodes in tree as either selected or unselected, depending on sense
  */
-extern void tree_markallsubtree( bool_t sensepr );
+extern void tree_markallsubtree(bool_t sensepr);
 
-extern bool_t tree_subtree_parse( bool_t sensepr, char *path );
+extern bool_t tree_subtree_parse(bool_t sensepr, char *path);
 
-extern bool_t tree_post( char *path1, char *path2 );
+extern bool_t tree_post(char *path1, char *path2);
 
-extern rv_t tree_cb_links( xfs_ino_t ino,
+extern rv_t tree_cb_links(xfs_ino_t ino,
 			   gen_t gen,
 			   int32_t ctime,
 			   int32_t mtime,
-			   bool_t ( * funcp )( void *contextp,
+			   bool_t (* funcp)(void *contextp,
 					       bool_t linkpr,
 					       char *path1,
-					       char *path2 ),
+					       char *path2),
 			   void *contextp,
 			   char *path1,
-			   char *path2 );
+			   char *path2);
 
 /* called after all dirs have been restored. adjusts the ref flags,
  * by noting that dirents not refed because their parents were not dumped
  * are virtually reffed if their parents are refed.
  */
-extern bool_t tree_adjref( void );
+extern bool_t tree_adjref(void);
 
-extern bool_t tree_setattr( char *path );
-extern bool_t tree_delorph( void );
-extern bool_t tree_subtree_inter( void );
+extern bool_t tree_setattr(char *path);
+extern bool_t tree_delorph(void);
+extern bool_t tree_subtree_inter(void);
 
-extern bool_t tree_extattr( bool_t ( * cbfunc )( char *path, dah_t dah ),
-			    char *path );
+extern bool_t tree_extattr(bool_t (* cbfunc)(char *path, dah_t dah),
+			    char *path);
 	/* does a depthwise bottom-up traversal of the tree, calling
 	 * the supplied callback for all directories with a non-NULL dirattr
 	 * handle. The callback will get called with the directory's pathname
diff --git a/restore/win.c b/restore/win.c
index e5bf708..53ca9b8 100644
--- a/restore/win.c
+++ b/restore/win.c
@@ -43,8 +43,8 @@ extern size_t pgmask;
 /*
  * critical region
  */
-#define CRITICAL_BEGIN()  if (!locksoffpr) qlock_lock( tranp->t_qlockh )
-#define CRITICAL_END()    if (!locksoffpr) qlock_unlock( tranp->t_qlockh )
+#define CRITICAL_BEGIN()  if (!locksoffpr) qlock_lock(tranp->t_qlockh)
+#define CRITICAL_END()    if (!locksoffpr) qlock_unlock(tranp->t_qlockh)
 
 /* window descriptor
  */
@@ -70,7 +70,7 @@ typedef struct win win_t;
 
 /* forward declarations
  */
-static void win_segmap_resize( segix_t segix );
+static void win_segmap_resize(segix_t segix);
 
 /* transient state
  */
@@ -79,7 +79,7 @@ struct tran {
 		/* file descriptor of backing store to be windowed
 		 */
 	off64_t t_firstoff;
-		/* offset of first seg within backing store (for mmap( ))
+		/* offset of first seg within backing store (for mmap())
 		 */
 	size64_t t_segsz;
 		/* backing store segment / window size
@@ -146,21 +146,21 @@ win_getnum_mmaps(void)
 }
 
 void
-win_init( int fd,
+win_init(int fd,
 	  off64_t firstoff,
 	  size64_t segsz,
-	  size_t winmax )
+	  size_t winmax)
 {
 	/* validate parameters
 	 */
-	assert( ( firstoff & ( off64_t )pgmask ) == 0 );
-	assert( ( segsz & pgmask ) == 0 );
+	assert((firstoff & (off64_t)pgmask) == 0);
+	assert((segsz & pgmask) == 0);
 
 	/* allocate and initialize transient state
 	 */
-	assert( tranp == 0 );
-	tranp = ( tran_t * )calloc( 1, sizeof( tran_t ));
-	assert( tranp );
+	assert(tranp == 0);
+	tranp = (tran_t *)calloc(1, sizeof(tran_t));
+	assert(tranp);
 
 	tranp->t_fd = fd;
 	tranp->t_firstoff = firstoff;
@@ -169,16 +169,16 @@ win_init( int fd,
 
 	tranp->t_segmaplen = SEGMAP_INCR;
 	tranp->t_segmap = (win_t **)
-	calloc( tranp->t_segmaplen, sizeof(win_t *) );
-	assert( tranp->t_segmap );
+	calloc(tranp->t_segmaplen, sizeof(win_t *));
+	assert(tranp->t_segmap);
 
 	/* initialize critical region enforcer
 	 */
-	tranp->t_qlockh = qlock_alloc( QLOCK_ORD_WIN );
+	tranp->t_qlockh = qlock_alloc(QLOCK_ORD_WIN);
 }
 
 void
-win_map( segix_t segix, void **pp )
+win_map(segix_t segix, void **pp)
 {
 	off64_t segoff;
 	win_t *winp;
@@ -190,23 +190,23 @@ win_map( segix_t segix, void **pp )
 	     "win_map(segix=%u,addr=%p)\n", segix, pp);
 #endif
 	/* resize the array if necessary */
-	if ( segix >= tranp->t_segmaplen )
-		win_segmap_resize( segix );
+	if (segix >= tranp->t_segmaplen)
+		win_segmap_resize(segix);
 
 	/* see if segment already mapped. if ref cnt zero,
 	 * remove from LRU list.
 	 */
 	winp = tranp->t_segmap[segix];
-	if ( winp ) {
+	if (winp) {
 #ifdef TREE_DEBUG
 		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
 		     "win_map(): requested segment already mapped\n");
 #endif
-		if ( winp->w_refcnt == 0 ) {
-			assert( tranp->t_lruheadp );
-			assert( tranp->t_lrutailp );
-			if ( tranp->t_lruheadp == winp ) {
-				if ( tranp->t_lrutailp == winp ) {
+		if (winp->w_refcnt == 0) {
+			assert(tranp->t_lruheadp);
+			assert(tranp->t_lrutailp);
+			if (tranp->t_lruheadp == winp) {
+				if (tranp->t_lrutailp == winp) {
 					tranp->t_lruheadp = 0;
 					tranp->t_lrutailp = 0;
 				} else {
@@ -214,7 +214,7 @@ win_map( segix_t segix, void **pp )
 					tranp->t_lruheadp->w_prevp = 0;
 				}
 			} else {
-				if ( tranp->t_lrutailp == winp ) {
+				if (tranp->t_lrutailp == winp) {
 					tranp->t_lrutailp = winp->w_prevp;
 					tranp->t_lrutailp->w_nextp = 0;
 				} else {
@@ -225,8 +225,8 @@ win_map( segix_t segix, void **pp )
 			winp->w_prevp = 0;
 			winp->w_nextp = 0;
 		} else {
-			assert( ! winp->w_prevp );
-			assert( ! winp->w_nextp );
+			assert(! winp->w_prevp);
+			assert(! winp->w_nextp);
 		}
 		winp->w_refcnt++;
 		*pp = winp->w_p;
@@ -237,70 +237,70 @@ win_map( segix_t segix, void **pp )
 	/* Allocate a new descriptor if we haven't yet hit the maximum,
 	 * otherwise reuse any descriptor on the LRU list.
 	 */
-	if ( tranp->t_wincnt < tranp->t_winmax ) {
+	if (tranp->t_wincnt < tranp->t_winmax) {
 #ifdef TREE_DEBUG
 		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
 		     "win_map(): create a new window\n");
 #endif
-		winp = ( win_t * )calloc( 1, sizeof( win_t ));
-		assert( winp );
+		winp = (win_t *)calloc(1, sizeof(win_t));
+		assert(winp);
 		tranp->t_wincnt++;
-	} else if ( tranp->t_lruheadp ) {
+	} else if (tranp->t_lruheadp) {
 		/* REFERENCED */
 		int rval;
 #ifdef TREE_DEBUG
 		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
 		     "win_map(): get head from lru freelist & unmap\n");
 #endif
-		assert( tranp->t_lrutailp );
+		assert(tranp->t_lrutailp);
 		winp = tranp->t_lruheadp;
 		tranp->t_lruheadp = winp->w_nextp;
-		if ( tranp->t_lruheadp ) {
+		if (tranp->t_lruheadp) {
 			tranp->t_lruheadp->w_prevp = 0;
 		} else {
 			tranp->t_lrutailp = 0;
 		}
 		tranp->t_segmap[winp->w_segix] = NULL;
-		rval = munmap( winp->w_p, tranp->t_segsz );
-		assert( ! rval );
-		memset( ( void * )winp, 0, sizeof( win_t ));
+		rval = munmap(winp->w_p, tranp->t_segsz);
+		assert(! rval);
+		memset((void *)winp, 0, sizeof(win_t));
 	} else {
-		assert( tranp->t_wincnt == tranp->t_winmax );
+		assert(tranp->t_wincnt == tranp->t_winmax);
 		*pp = NULL;
 		CRITICAL_END();
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "all map windows in use. Check virtual memory limits\n"));
 		return;
 	}
 
 	/* calculate offset of segment
 	 */
-	segoff = segix * ( off64_t )tranp->t_segsz;
+	segoff = segix * (off64_t)tranp->t_segsz;
 
 	/* map the window
 	 */
-	assert( tranp->t_segsz >= 1 );
-	assert( tranp->t_firstoff
+	assert(tranp->t_segsz >= 1);
+	assert(tranp->t_firstoff
 		<=
-		OFF64MAX - segoff - ( off64_t )tranp->t_segsz + 1ll );
-	assert( ! ( tranp->t_segsz % pgsz ));
-	assert( ! ( ( tranp->t_firstoff + segoff ) % ( off64_t )pgsz ));
+		OFF64MAX - segoff - (off64_t)tranp->t_segsz + 1ll);
+	assert(! (tranp->t_segsz % pgsz));
+	assert(! ((tranp->t_firstoff + segoff) % (off64_t)pgsz));
 #ifdef TREE_DEBUG
 	mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
 	     "win_map(): mmap segment at %lld, size = %llu\n",
-	    ( off64_t )( tranp->t_firstoff + segoff ), tranp->t_segsz);
+	    (off64_t)(tranp->t_firstoff + segoff), tranp->t_segsz);
 #endif
 	tranp->t_winmmaps++;
 	winp->w_p = mmap_autogrow(
 			    tranp->t_segsz,
 			    tranp->t_fd,
-			    ( off64_t )( tranp->t_firstoff + segoff ));
-	if ( winp->w_p == (void *)-1 ) {
+			    (off64_t)(tranp->t_firstoff + segoff));
+	if (winp->w_p == (void *)-1) {
 		int	error = errno;
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "win_map(): unable to map a node segment of size %d at %d: %s\n"),
 		      tranp->t_segsz, tranp->t_firstoff + segoff,
-		      strerror( error ));
+		      strerror(error));
 
 		tranp->t_wincnt--;
 		tranp->t_winmax--;
@@ -308,7 +308,7 @@ win_map( segix_t segix, void **pp )
 		free(winp);
 
 		if (error == ENOMEM && tranp->t_lruheadp) {
-			mlog( MLOG_NORMAL | MLOG_ERROR,
+			mlog(MLOG_NORMAL | MLOG_ERROR,
 		      		_("win_map(): try to select a different win_t\n"));
 			win_map(segix, pp);
 			return;
@@ -317,7 +317,7 @@ win_map( segix_t segix, void **pp )
 		return;
 	}
 	winp->w_segix  = segix;
-	assert( winp->w_refcnt == 0 );
+	assert(winp->w_refcnt == 0);
 	winp->w_refcnt++;
 	tranp->t_segmap[winp->w_segix] = winp;
 
@@ -327,7 +327,7 @@ win_map( segix_t segix, void **pp )
 }
 
 void
-win_unmap( segix_t segix, void **pp )
+win_unmap(segix_t segix, void **pp)
 {
 	win_t *winp;
 
@@ -335,36 +335,36 @@ win_unmap( segix_t segix, void **pp )
 
 	/* verify window mapped
 	 */
-	assert( segix < tranp->t_segmaplen );
+	assert(segix < tranp->t_segmaplen);
 	winp = tranp->t_segmap[segix];
-	assert( winp );
+	assert(winp);
 
 	/* validate p
 	 */
-	assert( pp );
-	assert( *pp );
-	assert( *pp >= winp->w_p );
-	assert( *pp < ( void * )( ( char * )( winp->w_p ) + tranp->t_segsz ));
+	assert(pp);
+	assert(*pp);
+	assert(*pp >= winp->w_p);
+	assert(*pp < (void *)((char *)(winp->w_p) + tranp->t_segsz));
 
 	/* decrement the reference count. if zero, place at tail of LRU list.
 	 */
-	assert( winp->w_refcnt > 0 );
+	assert(winp->w_refcnt > 0);
 	winp->w_refcnt--;
-	assert( ! winp->w_prevp );
-	assert( ! winp->w_nextp );
-	if ( winp->w_refcnt == 0 ) {
-		if ( tranp->t_lrutailp ) {
-			assert( tranp->t_lruheadp );
+	assert(! winp->w_prevp);
+	assert(! winp->w_nextp);
+	if (winp->w_refcnt == 0) {
+		if (tranp->t_lrutailp) {
+			assert(tranp->t_lruheadp);
 			winp->w_prevp = tranp->t_lrutailp;
 			tranp->t_lrutailp->w_nextp = winp;
 			tranp->t_lrutailp = winp;
 		} else {
-			assert( ! tranp->t_lruheadp );
-			assert( ! winp->w_prevp );
+			assert(! tranp->t_lruheadp);
+			assert(! winp->w_prevp);
 			tranp->t_lruheadp = winp;
 			tranp->t_lrutailp = winp;
 		}
-		assert( ! winp->w_nextp );
+		assert(! winp->w_nextp);
 	}
 
 	/* zero the caller's pointer
@@ -384,10 +384,10 @@ win_segmap_resize(segix_t segix)
 
 	tranp->t_segmaplen = segix + SEGMAP_INCR;
 	tranp->t_segmap = (win_t **)
-		realloc( tranp->t_segmap, tranp->t_segmaplen * sizeof(win_t *) );
-	assert( tranp->t_segmap );
+		realloc(tranp->t_segmap, tranp->t_segmaplen * sizeof(win_t *));
+	assert(tranp->t_segmap);
 
 	/* clear the new portion of the array */
 	new_part = tranp->t_segmap + oldlen;
-	memset( new_part, 0, (tranp->t_segmaplen - oldlen) * sizeof(win_t *) );
+	memset(new_part, 0, (tranp->t_segmaplen - oldlen) * sizeof(win_t *));
 }
diff --git a/restore/win.h b/restore/win.h
index a6bd002..2d52b56 100644
--- a/restore/win.h
+++ b/restore/win.h
@@ -25,21 +25,21 @@ typedef int segix_t;
 
 /* initialize the window abstraction
  */
-void win_init( int fd,
+void win_init(int fd,
 	       off64_t rngoff,		/* offset into file of windowing */
 	       size64_t winsz,		/* window size */
-	       size_t wincntmax );	/* max number of windows to manage */
+	       size_t wincntmax);	/* max number of windows to manage */
 
 /* supply a pointer to the portion of the file identified by segix.
  */
-void win_map( segix_t segix,		/* segment index to be mapped */
-	      void **pp );		/* returns pointer by reference */
+void win_map(segix_t segix,		/* segment index to be mapped */
+	      void **pp);		/* returns pointer by reference */
 
 /* invalidate the pointer previously supplied. SIDE-EFFECT: zeros
  * by reference the caller's pointer.
  */
-void win_unmap( segix_t segix,		/* must match win_map param */
-	        void **pp );		/* ptr generated by win_map: ZEROED */
+void win_unmap(segix_t segix,		/* must match win_map param */
+	        void **pp);		/* ptr generated by win_map: ZEROED */
 
 /*
  * Functions used to disable the window locking from happening.
-- 
2.19.1
