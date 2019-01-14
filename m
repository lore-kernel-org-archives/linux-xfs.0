Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfANR0K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:10 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5FA8D9E63F
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:08 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 08/13] xfsdump: (8/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:23 +0100
Message-Id: <20190114172528.65250-9-jtulak@redhat.com>
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
 dump/getopt.h         |   2 +-
 dump/inomap.c         | 768 +++++++++++++++++++++---------------------
 dump/inomap.h         |  32 +-
 dump/var.c            |  96 +++---
 dump/var.h            |   4 +-
 include/swab.h        |  24 +-
 include/swap.h        |  10 +-
 inventory/getopt.h    |   2 +-
 inventory/inv_api.c   | 414 +++++++++++------------
 inventory/inv_core.c  | 106 +++---
 inventory/inv_files.c |  10 +-
 inventory/inv_fstab.c | 152 ++++-----
 inventory/inv_idx.c   | 274 +++++++--------
 inventory/inv_mgr.c   | 332 +++++++++---------
 inventory/inv_oref.c  |  46 +--
 inventory/inv_oref.h  |   2 +-
 inventory/inv_priv.h  | 244 +++++++-------
 17 files changed, 1259 insertions(+), 1259 deletions(-)

diff --git a/dump/getopt.h b/dump/getopt.h
index 3bab87a..dd798d8 100644
--- a/dump/getopt.h
+++ b/dump/getopt.h
@@ -50,7 +50,7 @@
 #define	GETOPT_SUBTREE		's'	/* subtree dump (content_inode.c) */
 #define GETOPT_DUMPTIME		't'	/* use mtime of file as dump time */
 /*				'u' */
-#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4 ) */
+#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
 /*				'w' */
 /*				'x'	   used in irix for xvm snapshot */
 /*				'y' */
diff --git a/dump/inomap.c b/dump/inomap.c
index 238fcaf..4c8d490 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -57,7 +57,7 @@
 
 /* declarations of externally defined global symbols *************************/
 
-extern bool_t preemptchk( int );
+extern bool_t preemptchk(int);
 extern size_t pgsz;
 extern hsm_fs_ctxt_t *hsm_fs_ctxtp;
 extern uint64_t maxdumpfilesize;
@@ -67,7 +67,7 @@ extern bool_t allowexcludefiles_pr;
 
 /* inomap construction callbacks
  */
-static int cb_context( bool_t last,
+static int cb_context(bool_t last,
 			    time32_t,
 			    bool_t,
 			    time32_t,
@@ -78,50 +78,50 @@ static int cb_context( bool_t last,
 			    int,
 			    bool_t,
 			    bool_t *);
-static void cb_context_free( void );
-static int cb_count_inogrp( void *, int, xfs_inogrp_t *);
-static int cb_add_inogrp( void *, int, xfs_inogrp_t * );
-static int cb_add( void *, jdm_fshandle_t *, int, xfs_bstat_t * );
-static bool_t cb_inoinresumerange( xfs_ino_t );
-static bool_t cb_inoresumed( xfs_ino_t );
-static void cb_accuminit_sz( void );
-static void cb_spinit( void );
-static int cb_startpt( void *,
+static void cb_context_free(void);
+static int cb_count_inogrp(void *, int, xfs_inogrp_t *);
+static int cb_add_inogrp(void *, int, xfs_inogrp_t *);
+static int cb_add(void *, jdm_fshandle_t *, int, xfs_bstat_t *);
+static bool_t cb_inoinresumerange(xfs_ino_t);
+static bool_t cb_inoresumed(xfs_ino_t);
+static void cb_accuminit_sz(void);
+static void cb_spinit(void);
+static int cb_startpt(void *,
 			    jdm_fshandle_t *,
 			    int,
-			    xfs_bstat_t * );
-static int supprt_prune( void *,
+			    xfs_bstat_t *);
+static int supprt_prune(void *,
 			      jdm_fshandle_t *,
 			      int,
 			      xfs_bstat_t *,
-			      char * );
-static off64_t quantity2offset( jdm_fshandle_t *, xfs_bstat_t *, off64_t );
-static off64_t estimate_dump_space( xfs_bstat_t * );
+			      char *);
+static off64_t quantity2offset(jdm_fshandle_t *, xfs_bstat_t *, off64_t);
+static off64_t estimate_dump_space(xfs_bstat_t *);
 
 /* inomap primitives
  */
-static int inomap_init( int igrpcnt );
-static void inomap_add( void *, xfs_ino_t ino, gen_t gen, int );
-static int inomap_set_state( void *, xfs_ino_t ino, int );
-static void inomap_set_gen(void *, xfs_ino_t, gen_t );
+static int inomap_init(int igrpcnt);
+static void inomap_add(void *, xfs_ino_t ino, gen_t gen, int);
+static int inomap_set_state(void *, xfs_ino_t ino, int);
+static void inomap_set_gen(void *, xfs_ino_t, gen_t);
 
 /* subtree abstraction
  */
-static int subtree_descend_cb( void *,
+static int subtree_descend_cb(void *,
 				    jdm_fshandle_t *,
 				    int fsfd,
 				    xfs_bstat_t *,
-				    char * );
-static int subtreelist_parse_cb( void *,
+				    char *);
+static int subtreelist_parse_cb(void *,
 				      jdm_fshandle_t *,
 				      int fsfd,
 				      xfs_bstat_t *,
-				      char * );
-static int subtreelist_parse( jdm_fshandle_t *,
+				      char *);
+static int subtreelist_parse(jdm_fshandle_t *,
 				   int,
 				   xfs_bstat_t *,
 				   char *[],
-				   ix_t );
+				   ix_t);
 
 /* definition of locally defined global variables ****************************/
 
@@ -142,7 +142,7 @@ static uint64_t inomap_exclude_skipattr = 0;
  */
 /* ARGSUSED */
 bool_t
-inomap_build( jdm_fshandle_t *fshandlep,
+inomap_build(jdm_fshandle_t *fshandlep,
 	      int fsfd,
 	      xfs_bstat_t *rootstatp,
 	      bool_t last,
@@ -159,7 +159,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	      ix_t *statphasep,
 	      ix_t *statpassp,
 	      size64_t statcnt,
-	      size64_t *statdonep )
+	      size64_t *statdonep)
 {
 	xfs_bstat_t *bstatbufp;
 	size_t bstatbuflen;
@@ -185,24 +185,24 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	/* allocate a bulkstat buf
 	 */
 	bstatbuflen = BSTATBUFLEN;
-	bstatbufp = ( xfs_bstat_t * )memalign( pgsz,
+	bstatbufp = (xfs_bstat_t *)memalign(pgsz,
 					       bstatbuflen
 					       *
-					       sizeof( xfs_bstat_t ));
-	assert( bstatbufp );
+					       sizeof(xfs_bstat_t));
+	assert(bstatbufp);
 
 	/* count the number of inode groups, which will serve as a
 	 * starting point for the size of the inomap.
 	 */
-	rval = inogrp_iter( fsfd, cb_count_inogrp, (void *)&igrpcnt, &stat );
-	if ( rval || stat ) {
-		free( ( void * )bstatbufp );
+	rval = inogrp_iter(fsfd, cb_count_inogrp, (void *)&igrpcnt, &stat);
+	if (rval || stat) {
+		free((void *)bstatbufp);
 		return BOOL_FALSE;
 	}
 
 	/* initialize the callback context
 	 */
-	rval = cb_context( last,
+	rval = cb_context(last,
 			   lasttime,
 			   resume,
 			   resumetime,
@@ -212,9 +212,9 @@ inomap_build( jdm_fshandle_t *fshandlep,
 			   startptcnt,
 			   igrpcnt,
 			   skip_unchanged_dirs,
-			   &pruneneeded );
- 	if ( rval ) {
- 		free( ( void * )bstatbufp );
+			   &pruneneeded);
+ 	if (rval) {
+ 		free((void *)bstatbufp);
  		return BOOL_FALSE;
  	}
 
@@ -225,10 +225,10 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	 * in this filesystem. each inode will be marked unused until its
 	 * correct state is set in cb_add.
 	 */
-	rval = inogrp_iter( fsfd, cb_add_inogrp, NULL, &stat );
- 	if ( rval || stat ) {
+	rval = inogrp_iter(fsfd, cb_add_inogrp, NULL, &stat);
+ 	if (rval || stat) {
 		cb_context_free();
- 		free( ( void * )bstatbufp );
+ 		free((void *)bstatbufp);
  		return BOOL_FALSE;
  	}
 
@@ -244,26 +244,26 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	 * set a flag if any ino not put in a dump state. This will be used
 	 * to decide if any pruning can be done.
 	 */
-	mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+	mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 	      "ino map phase 1: "
-	      "constructing initial dump list\n") );
+	      "constructing initial dump list\n"));
 
 	*inomap_statdonep = 0;
 	*inomap_statphasep = 1;
 	stat = 0;
-	cb_accuminit_sz( );
+	cb_accuminit_sz();
 
-	if ( subtreecnt ) {
-		rval = subtreelist_parse( fshandlep,
+	if (subtreecnt) {
+		rval = subtreelist_parse(fshandlep,
 					  fsfd,
 					  rootstatp,
 					  subtreebuf,
-					  subtreecnt );
+					  subtreecnt);
 	} else {
-		rval = bigstat_iter( fshandlep,
+		rval = bigstat_iter(fshandlep,
 				     fsfd,
 				     BIGSTAT_ITER_ALL,
-				     ( xfs_ino_t )0,
+				     (xfs_ino_t)0,
 				     cb_add,
 				     NULL,
 				     NULL,
@@ -271,80 +271,80 @@ inomap_build( jdm_fshandle_t *fshandlep,
 				     &stat,
 				     preemptchk,
 				     bstatbufp,
-				     bstatbuflen );
+				     bstatbuflen);
 	}
 	*inomap_statphasep = 0;
-	if ( rval || preemptchk( PREEMPT_FULL )) {
+	if (rval || preemptchk(PREEMPT_FULL)) {
 		cb_context_free();
-		free( ( void * )bstatbufp );
+		free((void *)bstatbufp);
 		return BOOL_FALSE;
 	}
 
-	if ( inomap_exclude_filesize > 0 ) {
-		mlog( MLOG_NOTE | MLOG_VERBOSE, _(
+	if (inomap_exclude_filesize > 0) {
+		mlog(MLOG_NOTE | MLOG_VERBOSE, _(
 		      "pruned %llu files: maximum size exceeded\n"),
-		      inomap_exclude_filesize );
+		      inomap_exclude_filesize);
 	}
-	if ( inomap_exclude_skipattr > 0 ) {
-		mlog( MLOG_NOTE | MLOG_VERBOSE, _(
+	if (inomap_exclude_skipattr > 0) {
+		mlog(MLOG_NOTE | MLOG_VERBOSE, _(
 		      "pruned %llu files: skip attribute set\n"),
-		      inomap_exclude_skipattr );
+		      inomap_exclude_skipattr);
 	}
 
 	/* prune directories unchanged since the last dump and containing
 	 * no children needing dumping.
 	 */
-	if ( pruneneeded ) {
+	if (pruneneeded) {
 		bool_t	rootdump = BOOL_FALSE;
 
-		mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 		      "ino map phase 2: "
-		      "pruning unneeded subtrees\n") );
+		      "pruning unneeded subtrees\n"));
 		*inomap_statdonep = 0;
 		*inomap_statpassp = 0;
 		*inomap_statphasep = 2;
 
-		(void) supprt_prune( &rootdump,
+		(void) supprt_prune(&rootdump,
 				     fshandlep,
 				     fsfd,
 				     rootstatp,
-				     NULL );
+				     NULL);
 		*inomap_statphasep = 0;
 
-		if ( preemptchk( PREEMPT_FULL )) {
+		if (preemptchk(PREEMPT_FULL)) {
 			cb_context_free();
-			free( ( void * )bstatbufp );
+			free((void *)bstatbufp);
 			return BOOL_FALSE;
 		}
 
 	} else {
-		mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 		      "ino map phase 2: "
-		      "skipping (no pruning necessary)\n") );
+		      "skipping (no pruning necessary)\n"));
 	}
 
 	/* initialize the callback context for startpoint calculation
 	 */
-	cb_spinit( );
+	cb_spinit();
 
 	/* identify dump stream startpoints
 	 */
-	if ( startptcnt > 1 ) {
-		mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+	if (startptcnt > 1) {
+		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 		      "ino map phase 3: "
-		      "identifying stream starting points\n") );
+		      "identifying stream starting points\n"));
 	} else {
-		mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 		      "ino map phase 3: "
-		      "skipping (only one dump stream)\n") );
+		      "skipping (only one dump stream)\n"));
 	}
 	stat = 0;
 	*inomap_statdonep = 0;
 	*inomap_statphasep = 3;
-	rval = bigstat_iter( fshandlep,
+	rval = bigstat_iter(fshandlep,
 			     fsfd,
 			     BIGSTAT_ITER_NONDIR,
-			     ( xfs_ino_t )0,
+			     (xfs_ino_t)0,
 			     cb_startpt,
 			     NULL,
 			     inomap_next_nondir,
@@ -352,66 +352,66 @@ inomap_build( jdm_fshandle_t *fshandlep,
 			     &stat,
 			     preemptchk,
 			     bstatbufp,
-			     bstatbuflen );
+			     bstatbuflen);
 	*inomap_statphasep = 0;
 
-	if ( rval ) {
+	if (rval) {
 		cb_context_free();
-		free( ( void * )bstatbufp );
+		free((void *)bstatbufp);
 		return BOOL_FALSE;
 	}
 
-	if ( startptcnt > 1 ) {
+	if (startptcnt > 1) {
 		ix_t startptix;
-		for ( startptix = 0 ; startptix < startptcnt ; startptix++ ) {
+		for (startptix = 0 ; startptix < startptcnt ; startptix++) {
 			startpt_t *p;
 			startpt_t *ep;
 
-			p = &startptp[ startptix ];
-			if ( startptix == startptcnt - 1 ) {
+			p = &startptp[startptix];
+			if (startptix == startptcnt - 1) {
 				ep = 0;
 			} else {
-				ep = &startptp[ startptix + 1 ];
+				ep = &startptp[startptix + 1];
 			}
-			assert( ! p->sp_flags );
-			mlog( MLOG_VERBOSE | MLOG_INOMAP,
+			assert(! p->sp_flags);
+			mlog(MLOG_VERBOSE | MLOG_INOMAP,
 			      _("stream %u: ino %llu offset %lld to "),
 			      startptix,
 			      p->sp_ino,
-			      p->sp_offset );
-			if ( ! ep ) {
-				mlog( MLOG_VERBOSE | MLOG_BARE | MLOG_INOMAP,
-				      _("end\n") );
+			      p->sp_offset);
+			if (! ep) {
+				mlog(MLOG_VERBOSE | MLOG_BARE | MLOG_INOMAP,
+				      _("end\n"));
 			} else {
-				mlog( MLOG_VERBOSE |  MLOG_BARE | MLOG_INOMAP,
+				mlog(MLOG_VERBOSE |  MLOG_BARE | MLOG_INOMAP,
 				      _("ino %llu offset %lld\n"),
 				      ep->sp_ino,
-				      ep->sp_offset );
+				      ep->sp_offset);
 			}
 		}
 	}
 
 	cb_context_free();
-	free( ( void * )bstatbufp );
-	mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
-	      "ino map construction complete\n") );
+	free((void *)bstatbufp);
+	mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
+	      "ino map construction complete\n"));
 	return BOOL_TRUE;
 }
 
 void
-inomap_skip( xfs_ino_t ino )
+inomap_skip(xfs_ino_t ino)
 {
 	int oldstate;
 
-	oldstate = inomap_get_state( NULL, ino );
-	if ( oldstate == MAP_NDR_CHANGE) {
-		inomap_set_state( NULL, ino, MAP_NDR_NOCHNG );
+	oldstate = inomap_get_state(NULL, ino);
+	if (oldstate == MAP_NDR_CHANGE) {
+		inomap_set_state(NULL, ino, MAP_NDR_NOCHNG);
 	}
 
-	if ( oldstate == MAP_DIR_CHANGE
+	if (oldstate == MAP_DIR_CHANGE
 	     ||
-	     oldstate == MAP_DIR_SUPPRT ) {
-		inomap_set_state( NULL, ino, MAP_DIR_NOCHNG );
+	     oldstate == MAP_DIR_SUPPRT) {
+		inomap_set_state(NULL, ino, MAP_DIR_NOCHNG);
 	}
 }
 
@@ -445,7 +445,7 @@ static bool_t cb_skip_unchanged_dirs;	/* set by cb_context() */
  * phases of inomap_build().
  */
 static int
-cb_context( bool_t last,
+cb_context(bool_t last,
 	    time32_t lasttime,
 	    bool_t resume,
 	    time32_t resumetime,
@@ -455,7 +455,7 @@ cb_context( bool_t last,
 	    size_t startptcnt,
 	    int igrpcnt,
 	    bool_t skip_unchanged_dirs,
-	    bool_t *pruneneededp )
+	    bool_t *pruneneededp)
 {
 	cb_last = last;
 	cb_lasttime = lasttime;
@@ -471,7 +471,7 @@ cb_context( bool_t last,
 	cb_pruneneededp = pruneneededp;
 	cb_skip_unchanged_dirs = skip_unchanged_dirs;
 
-	if (inomap_init( igrpcnt ))
+	if (inomap_init(igrpcnt))
 		return -1;
 
 	cb_inomap_contextp = inomap_alloc_context();
@@ -482,13 +482,13 @@ cb_context( bool_t last,
 }
 
 static void
-cb_context_free( void )
+cb_context_free(void)
 {
-	inomap_free_context( cb_inomap_contextp );
+	inomap_free_context(cb_inomap_contextp);
 }
 
 static int
-cb_count_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
+cb_count_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
 {
 	int *count = (int *)arg1;
 	(*count)++;
@@ -502,25 +502,25 @@ cb_count_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
  */
 /* ARGSUSED */
 static int
-cb_add( void *arg1,
+cb_add(void *arg1,
 	jdm_fshandle_t *fshandlep,
 	int fsfd,
-	xfs_bstat_t *statp )
+	xfs_bstat_t *statp)
 {
 	register time32_t mtime = statp->bs_mtime.tv_sec;
 	register time32_t ctime = statp->bs_ctime.tv_sec;
-	register time32_t ltime = max( mtime, ctime );
+	register time32_t ltime = max(mtime, ctime);
 	register mode_t mode = statp->bs_mode & S_IFMT;
 	xfs_off_t estimated_size = 0;
 	xfs_ino_t ino = statp->bs_ino;
 	bool_t changed;
 	bool_t resumed;
 
-	( *inomap_statdonep )++;
+	(*inomap_statdonep)++;
 
 	/* skip if no links
 	 */
-	if ( statp->bs_nlink == 0 ) {
+	if (statp->bs_nlink == 0) {
 		return 0;
 	}
 
@@ -533,14 +533,14 @@ cb_add( void *arg1,
 	 * increment was based, dump it if it has changed since that
 	 * original base dump.
 	 */
-	if ( cb_resume && ! cb_inoinresumerange( ino )) {
-		if ( ltime >= cb_resumetime ) {
+	if (cb_resume && ! cb_inoinresumerange(ino)) {
+		if (ltime >= cb_resumetime) {
 			changed = BOOL_TRUE;
 		} else {
 			changed = BOOL_FALSE;
 		}
-	} else if ( cb_last ) {
-		if ( ltime >= cb_lasttime ) {
+	} else if (cb_last) {
+		if (ltime >= cb_lasttime) {
 			changed = BOOL_TRUE;
 		} else {
 			changed = BOOL_FALSE;
@@ -552,86 +552,86 @@ cb_add( void *arg1,
 	/* this is redundant: make sure any ino partially dumped
 	 * is completed.
 	 */
-	if ( cb_resume && cb_inoresumed( ino )) {
+	if (cb_resume && cb_inoresumed(ino)) {
 		resumed = BOOL_TRUE;
 	} else {
 		resumed = BOOL_FALSE;
 	}
 
-	if ( changed ) {
-		if ( mode == S_IFDIR ) {
-			inomap_add( cb_inomap_contextp,
+	if (changed) {
+		if (mode == S_IFDIR) {
+			inomap_add(cb_inomap_contextp,
 				    ino,
 				    (gen_t)statp->bs_gen,
-				    MAP_DIR_CHANGE );
+				    MAP_DIR_CHANGE);
 			cb_dircnt++;
 		} else {
-			estimated_size = estimate_dump_space( statp );
+			estimated_size = estimate_dump_space(statp);
 
 			/* skip if size is greater than prune size. quota
 			 * files are exempt from the check.
 			 */
-			if ( maxdumpfilesize > 0 &&
+			if (maxdumpfilesize > 0 &&
 			     estimated_size > maxdumpfilesize &&
-			     !is_quota_file(statp->bs_ino) ) {
-				mlog( MLOG_DEBUG | MLOG_EXCLFILES,
+			     !is_quota_file(statp->bs_ino)) {
+				mlog(MLOG_DEBUG | MLOG_EXCLFILES,
 				      "pruned ino %llu, owner %u, estimated size %llu: maximum size exceeded\n",
 				      statp->bs_ino,
 				      statp->bs_uid,
-				      estimated_size );
-				inomap_add( cb_inomap_contextp,
+				      estimated_size);
+				inomap_add(cb_inomap_contextp,
 					    ino,
 					    (gen_t)statp->bs_gen,
-					    MAP_NDR_NOCHNG );
+					    MAP_NDR_NOCHNG);
 				inomap_exclude_filesize++;
 				return 0;
 			}
 
 			if (allowexcludefiles_pr && statp->bs_xflags & XFS_XFLAG_NODUMP) {
-				mlog( MLOG_DEBUG | MLOG_EXCLFILES,
+				mlog(MLOG_DEBUG | MLOG_EXCLFILES,
 				      "pruned ino %llu, owner %u, estimated size %llu: skip flag set\n",
 				      statp->bs_ino,
 				      statp->bs_uid,
-				      estimated_size );
-				inomap_add( cb_inomap_contextp,
+				      estimated_size);
+				inomap_add(cb_inomap_contextp,
 					    ino,
 					    (gen_t)statp->bs_gen,
-					    MAP_NDR_NOCHNG );
+					    MAP_NDR_NOCHNG);
 				inomap_exclude_skipattr++;
 				return 0;
 			}
 
-			inomap_add( cb_inomap_contextp,
+			inomap_add(cb_inomap_contextp,
 				    ino,
 				    (gen_t)statp->bs_gen,
-				    MAP_NDR_CHANGE );
+				    MAP_NDR_CHANGE);
 			cb_nondircnt++;
 			cb_datasz += estimated_size;
-			cb_hdrsz += ( EXTENTHDR_SZ * (statp->bs_extents + 1) );
+			cb_hdrsz += (EXTENTHDR_SZ * (statp->bs_extents + 1));
 		}
-	} else if ( resumed ) {
-		assert( mode != S_IFDIR );
-		assert( changed );
+	} else if (resumed) {
+		assert(mode != S_IFDIR);
+		assert(changed);
 	} else {
-		if ( mode == S_IFDIR ) {
-			if ( cb_skip_unchanged_dirs ) {
-				inomap_add( cb_inomap_contextp,
+		if (mode == S_IFDIR) {
+			if (cb_skip_unchanged_dirs) {
+				inomap_add(cb_inomap_contextp,
 					    ino,
 					    (gen_t)statp->bs_gen,
-					    MAP_DIR_NOCHNG );
+					    MAP_DIR_NOCHNG);
 			} else {
 				*cb_pruneneededp = BOOL_TRUE;
-				inomap_add( cb_inomap_contextp,
+				inomap_add(cb_inomap_contextp,
 					    ino,
 					    (gen_t)statp->bs_gen,
-					    MAP_DIR_SUPPRT );
+					    MAP_DIR_SUPPRT);
 				cb_dircnt++;
 			}
 		} else {
-			inomap_add( cb_inomap_contextp,
+			inomap_add(cb_inomap_contextp,
 				    ino,
 				    (gen_t)statp->bs_gen,
-				    MAP_NDR_NOCHNG );
+				    MAP_NDR_NOCHNG);
 		}
 	}
 
@@ -639,23 +639,23 @@ cb_add( void *arg1,
 }
 
 static bool_t
-cb_inoinresumerange( xfs_ino_t ino )
+cb_inoinresumerange(xfs_ino_t ino)
 {
 	register size_t streamix;
 
-	for ( streamix = 0 ; streamix < cb_resumerangecnt ; streamix++ ) {
-		register drange_t *rp = &cb_resumerangep[ streamix ];
-		if ( ! ( rp->dr_begin.sp_flags & STARTPT_FLAGS_END )
+	for (streamix = 0 ; streamix < cb_resumerangecnt ; streamix++) {
+		register drange_t *rp = &cb_resumerangep[streamix];
+		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
 		     &&
 		     ino >= rp->dr_begin.sp_ino
 		     &&
-		     ( ( rp->dr_end.sp_flags & STARTPT_FLAGS_END )
+		     ((rp->dr_end.sp_flags & STARTPT_FLAGS_END)
 		       ||
 		       ino < rp->dr_end.sp_ino
 		       ||
-		       ( ino == rp->dr_end.sp_ino
+		       (ino == rp->dr_end.sp_ino
 			 &&
-			 rp->dr_end.sp_offset != 0 ))) {
+			 rp->dr_end.sp_offset != 0))) {
 			return BOOL_TRUE;
 		}
 	}
@@ -664,17 +664,17 @@ cb_inoinresumerange( xfs_ino_t ino )
 }
 
 static bool_t
-cb_inoresumed( xfs_ino_t ino )
+cb_inoresumed(xfs_ino_t ino)
 {
 	size_t streamix;
 
-	for ( streamix = 0 ; streamix < cb_resumerangecnt ; streamix++ ) {
-		drange_t *rp = &cb_resumerangep[ streamix ];
-		if ( ! ( rp->dr_begin.sp_flags & STARTPT_FLAGS_END )
+	for (streamix = 0 ; streamix < cb_resumerangecnt ; streamix++) {
+		drange_t *rp = &cb_resumerangep[streamix];
+		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
 		     &&
 		     ino == rp->dr_begin.sp_ino
 		     &&
-		     rp->dr_begin.sp_offset != 0 ) {
+		     rp->dr_begin.sp_offset != 0) {
 			return BOOL_TRUE;
 		}
 	}
@@ -688,20 +688,20 @@ cb_inoresumed( xfs_ino_t ino )
  */
 /* ARGSUSED */
 static bool_t			/* false, used as diriter callback */
-supprt_prune( void *arg1,	/* ancestors marked as changed? */
+supprt_prune(void *arg1,	/* ancestors marked as changed? */
 	      jdm_fshandle_t *fshandlep,
 	      int fsfd,
 	      xfs_bstat_t *statp,
-	      char *name )
+	      char *name)
 {
 	static bool_t cbrval = BOOL_FALSE;
 	int state;
 
-	if ( ( statp->bs_mode & S_IFMT ) == S_IFDIR ) {
+	if ((statp->bs_mode & S_IFMT) == S_IFDIR) {
 		bool_t changed_below = BOOL_FALSE;
 
-		state = inomap_get_state( cb_inomap_contextp, statp->bs_ino );
-		if ( state != MAP_DIR_CHANGE &&
+		state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
+		if (state != MAP_DIR_CHANGE &&
                      state != MAP_DIR_NOCHNG &&
 		     state != MAP_DIR_SUPPRT) {
 			/*
@@ -709,67 +709,67 @@ supprt_prune( void *arg1,	/* ancestors marked as changed? */
 			 * certainly changed.
 			 */
 			state = MAP_DIR_CHANGE;
-			inomap_set_state( cb_inomap_contextp,
+			inomap_set_state(cb_inomap_contextp,
 					  statp->bs_ino,
-					  state );
+					  state);
 		}
 
-		( void )diriter( fshandlep,
+		(void)diriter(fshandlep,
 				 fsfd,
 				 statp,
 				 supprt_prune,
 				 (void *)&changed_below,
 				 &cbrval,
 				 NULL,
-				 0 );
+				 0);
 
-		if ( state == MAP_DIR_SUPPRT ) {
-			if ( changed_below == BOOL_FALSE ) {
-				inomap_set_state( cb_inomap_contextp,
+		if (state == MAP_DIR_SUPPRT) {
+			if (changed_below == BOOL_FALSE) {
+				inomap_set_state(cb_inomap_contextp,
 						  statp->bs_ino,
-						  MAP_DIR_NOCHNG );
+						  MAP_DIR_NOCHNG);
 				cb_dircnt--;	/* dump size just changed! */
 			}
 			else {
 				/* Directory entries back up the hierarchy */
 				/* to be dumped - as either MAP_DIR_SUPPRT */
 				/* or as MAP_DIR_CHANGE in inode state map */
-				*( bool_t * )arg1 = BOOL_TRUE;
+				*(bool_t *)arg1 = BOOL_TRUE;
 			}
 		}
-		else if ( state == MAP_DIR_CHANGE ) {
+		else if (state == MAP_DIR_CHANGE) {
 			/* Directory entries back up the hierarchy must get */
 			/* dumped - as either MAP_DIR_SUPPRT/MAP_DIR_CHANGE */
-			*( bool_t * )arg1 = BOOL_TRUE;
+			*(bool_t *)arg1 = BOOL_TRUE;
 		}
 		return cbrval;
 	}
 
-	if ( *(bool_t *)arg1 == BOOL_TRUE ) {	/* shortcut, sibling changed */
+	if (*(bool_t *)arg1 == BOOL_TRUE) {	/* shortcut, sibling changed */
 		return cbrval;
 	}
 
-	state = inomap_get_state( cb_inomap_contextp, statp->bs_ino );
-	if ( state != MAP_NDR_CHANGE &&
-	     state != MAP_NDR_NOCHNG ) {
+	state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
+	if (state != MAP_NDR_CHANGE &&
+	     state != MAP_NDR_NOCHNG) {
 		/*
 		 * if dir is now a file then it has
 		 * certainly changed.
 		 */
 		state = MAP_NDR_CHANGE;
-		inomap_set_state( cb_inomap_contextp, statp->bs_ino, state );
+		inomap_set_state(cb_inomap_contextp, statp->bs_ino, state);
 	}
-	if ( state == MAP_NDR_CHANGE ) {
+	if (state == MAP_NDR_CHANGE) {
 		/* Directory entries back up the hierarchy must get */
 		/* dumped - as either MAP_DIR_SUPPRT/MAP_DIR_CHANGE */
-		*( bool_t * )arg1 = BOOL_TRUE;
+		*(bool_t *)arg1 = BOOL_TRUE;
 	}
 	return cbrval;
 }
 
 
 static void
-cb_accuminit_sz( void )
+cb_accuminit_sz(void)
 {
 	cb_datasz = 0;
 	cb_hdrsz = 0;
@@ -782,10 +782,10 @@ cb_accuminit_sz( void )
  * cb_accum accumulates the dump space.
  */
 static void
-cb_spinit( void )
+cb_spinit(void)
 {
 	cb_startptix = 0;
-	cb_incr = (cb_datasz + cb_hdrsz) / ( off64_t )cb_startptcnt;
+	cb_incr = (cb_datasz + cb_hdrsz) / (off64_t)cb_startptcnt;
 	cb_target = 0; /* so first ino will push us over the edge */
 	cb_accum = 0;
 }
@@ -809,10 +809,10 @@ typedef enum {
 
 /* ARGSUSED */
 static int
-cb_startpt( void *arg1,
+cb_startpt(void *arg1,
 	    jdm_fshandle_t *fshandlep,
 	    int fsfd,
-	    xfs_bstat_t *statp )
+	    xfs_bstat_t *statp)
 {
 	register int state;
 
@@ -821,31 +821,31 @@ cb_startpt( void *arg1,
 	off64_t qty;	/* amount of a SPLIT file to skip */
 	action_t action;
 
-	( *inomap_statdonep )++;
+	(*inomap_statdonep)++;
 
 	/* skip if no links
 	 */
-	if ( statp->bs_nlink == 0 ) {
+	if (statp->bs_nlink == 0) {
 		return 0;
 	}
 
 	/* skip if not in inomap or not a non-dir
 	 */
-	state = inomap_get_state( cb_inomap_contextp, statp->bs_ino );
-	if ( state != MAP_NDR_CHANGE ) {
+	state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
+	if (state != MAP_NDR_CHANGE) {
 		return 0;
 	}
 
-	assert( cb_startptix < cb_startptcnt );
+	assert(cb_startptix < cb_startptcnt);
 
-	estimate = estimate_dump_space( statp );
-	cb_accum += estimate + ( EXTENTHDR_SZ * (statp->bs_extents + 1) );
+	estimate = estimate_dump_space(statp);
+	cb_accum += estimate + (EXTENTHDR_SZ * (statp->bs_extents + 1));
 
 	/* loop until no new start points found. loop is necessary
 	 * to handle the pathological case of a huge file so big it
 	 * spans several streams.
 	 */
-	action = ( action_t )HOLD; /* irrelevant, but demanded by lint */
+	action = (action_t)HOLD; /* irrelevant, but demanded by lint */
 	do {
 		/* decide what to do: hold, bump, or split. there are
 		 * 8 valid cases to consider:
@@ -874,69 +874,69 @@ cb_startpt( void *arg1,
 		 *    accum incl. this file is would be way beyond the
 		 *    target: HOLD.
 		 */
-		if ( cb_target - old_accum >= TOO_SHY ) {
-			if ( cb_target - cb_accum >= TOO_SHY ) {
-				action = ( action_t )HOLD;
-			} else if ( cb_accum <= cb_target ) {
-				action = ( action_t )HOLD;
-			} else if ( cb_accum - cb_target < TOO_BOLD ) {
-				action = ( action_t )HOLD;
+		if (cb_target - old_accum >= TOO_SHY) {
+			if (cb_target - cb_accum >= TOO_SHY) {
+				action = (action_t)HOLD;
+			} else if (cb_accum <= cb_target) {
+				action = (action_t)HOLD;
+			} else if (cb_accum - cb_target < TOO_BOLD) {
+				action = (action_t)HOLD;
 			} else {
-				action = ( action_t )SPLIT;
+				action = (action_t)SPLIT;
 			}
 		} else {
-			if ( cb_target - cb_accum >= TOO_SHY ) {
-				action = ( action_t )YELL;
-			} else if ( cb_accum < cb_target ) {
-				action = ( action_t )HOLD;
-			} else if ( cb_accum - cb_target < TOO_BOLD ) {
-				if ( cb_accum - cb_target >=
-						      cb_target - old_accum ) {
-					action = ( action_t )BUMP;
+			if (cb_target - cb_accum >= TOO_SHY) {
+				action = (action_t)YELL;
+			} else if (cb_accum < cb_target) {
+				action = (action_t)HOLD;
+			} else if (cb_accum - cb_target < TOO_BOLD) {
+				if (cb_accum - cb_target >=
+						      cb_target - old_accum) {
+					action = (action_t)BUMP;
 				} else {
-					action = ( action_t )HOLD;
+					action = (action_t)HOLD;
 				}
 			} else {
-				action = ( action_t )BUMP;
+				action = (action_t)BUMP;
 			}
 		}
 
 		/* perform the action selected above
 		 */
-		switch ( action ) {
-		case ( action_t )HOLD:
+		switch (action) {
+		case (action_t)HOLD:
 			break;
-		case ( action_t )BUMP:
+		case (action_t)BUMP:
 			cb_startptp->sp_ino = statp->bs_ino;
 			cb_startptp->sp_offset = 0;
 			cb_startptix++;
 			cb_startptp++;
 			cb_target += cb_incr;
-			if ( cb_startptix == cb_startptcnt ) {
+			if (cb_startptix == cb_startptcnt) {
 				return 1; /* done; abort the iteration */
 			}
 			break;
-		case ( action_t )SPLIT:
+		case (action_t)SPLIT:
 			cb_startptp->sp_ino = statp->bs_ino;
-			qty = ( cb_target - old_accum )
+			qty = (cb_target - old_accum)
 			      &
-			      ~( off64_t )( BBSIZE - 1 );
+			      ~(off64_t)(BBSIZE - 1);
 			cb_startptp->sp_offset =
-					quantity2offset( fshandlep,
+					quantity2offset(fshandlep,
 							 statp,
-							 qty );
+							 qty);
 			cb_startptix++;
 			cb_startptp++;
 			cb_target += cb_incr;
-			if ( cb_startptix == cb_startptcnt ) {
+			if (cb_startptix == cb_startptcnt) {
 				return 1; /* done; abort the iteration */
 			}
 			break;
 		default:
-			assert( 0 );
+			assert(0);
 			return 1;
 		}
-	} while ( action == ( action_t )BUMP || action == ( action_t )SPLIT );
+	} while (action == (action_t)BUMP || action == (action_t)SPLIT);
 
 	return 0;
 }
@@ -948,7 +948,7 @@ cb_startpt( void *arg1,
  */
 struct i2gseg {
 	uint64_t s_valid;
-	gen_t s_gen[ INOPERSEG ];
+	gen_t s_gen[INOPERSEG];
 };
 typedef struct i2gseg i2gseg_t;
 
@@ -966,15 +966,15 @@ static struct inomap {
 } inomap;
 
 static inline void
-SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
+SEG_SET_BITS(seg_t *segp, xfs_ino_t ino, int state)
 {
 	register xfs_ino_t relino;
 	register uint64_t mask;
 	register uint64_t clrmask;
 	relino = ino - segp->base;
-	mask = ( uint64_t )1 << relino;
+	mask = (uint64_t)1 << relino;
 	clrmask = ~mask;
-	switch( state ) {
+	switch(state) {
 	case 0:
 		segp->lobits &= clrmask;
 		segp->mebits &= clrmask;
@@ -1019,22 +1019,22 @@ SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
 }
 
 static inline int
-SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
+SEG_GET_BITS(seg_t *segp, xfs_ino_t ino)
 {
 	int state;
 	register xfs_ino_t relino;
 	register uint64_t mask;
 	relino = ino - segp->base;
-	mask = ( uint64_t )1 << relino;
-	if ( segp->lobits & mask ) {
+	mask = (uint64_t)1 << relino;
+	if (segp->lobits & mask) {
 		state = 1;
 	} else {
 		state = 0;
 	}
-	if ( segp->mebits & mask ) {
+	if (segp->mebits & mask) {
 		state |= 2;
 	}
-	if ( segp->hibits & mask ) {
+	if (segp->hibits & mask) {
 		state |= 4;
 	}
 
@@ -1044,9 +1044,9 @@ SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
 /* context for inomap construction - initialized by map_init
  */
 static int
-inomap_init( int igrpcnt )
+inomap_init(int igrpcnt)
 {
-	assert( sizeof( hnk_t ) == HNKSZ );
+	assert(sizeof(hnk_t) == HNKSZ);
 
 	/* lastseg must be initialized with -1 offsets since
 	 * no segments have been added yet */
@@ -1055,58 +1055,58 @@ inomap_init( int igrpcnt )
 	inomap.hnkmaplen = (igrpcnt + SEGPERHNK - 1) / SEGPERHNK;
 	inomap.hnkmap = (hnk_t *)malloc(inomap.hnkmaplen * HNKSZ);
 	inomap.i2gmap = (i2gseg_t *)
-		calloc( inomap.hnkmaplen * SEGPERHNK, sizeof(i2gseg_t) );
+		calloc(inomap.hnkmaplen * SEGPERHNK, sizeof(i2gseg_t));
 	if (!inomap.hnkmap || !inomap.i2gmap)
 		return -1;
 	return 0;
 }
 
 uint64_t
-inomap_getsz( void )
+inomap_getsz(void)
 {
 	return (inomap.lastseg.hnkoff + 1) * HNKSZ;
 }
 
 static inline bool_t
-inomap_validaddr( seg_addr_t *addrp )
+inomap_validaddr(seg_addr_t *addrp)
 {
 	int maxseg;
 
-	if ( addrp->hnkoff < 0 || addrp->hnkoff > inomap.lastseg.hnkoff )
+	if (addrp->hnkoff < 0 || addrp->hnkoff > inomap.lastseg.hnkoff)
 		return BOOL_FALSE;
 
-	maxseg = ( addrp->hnkoff == inomap.lastseg.hnkoff ) ?
+	maxseg = (addrp->hnkoff == inomap.lastseg.hnkoff) ?
 			inomap.lastseg.segoff : SEGPERHNK - 1;
 
-	if ( addrp->segoff < 0 || addrp->segoff > maxseg )
+	if (addrp->segoff < 0 || addrp->segoff > maxseg)
 		return BOOL_FALSE;
 
 	return BOOL_TRUE;
 }
 
 static inline hnk_t *
-inomap_addr2hnk( seg_addr_t *addrp )
+inomap_addr2hnk(seg_addr_t *addrp)
 {
 	return &inomap.hnkmap[addrp->hnkoff];
 }
 
 static inline seg_t *
-inomap_addr2seg( seg_addr_t *addrp )
+inomap_addr2seg(seg_addr_t *addrp)
 {
-	hnk_t *hunkp = inomap_addr2hnk( addrp );
+	hnk_t *hunkp = inomap_addr2hnk(addrp);
 	return &hunkp->seg[addrp->segoff];
 }
 
 static inline int
-inomap_addr2segix( seg_addr_t *addrp )
+inomap_addr2segix(seg_addr_t *addrp)
 {
-	return ( addrp->hnkoff * SEGPERHNK ) + addrp->segoff;
+	return (addrp->hnkoff * SEGPERHNK) + addrp->segoff;
 }
 
 static inline int
-inomap_lastseg( int hnkoff )
+inomap_lastseg(int hnkoff)
 {
-	if ( hnkoff == inomap.lastseg.hnkoff )
+	if (hnkoff == inomap.lastseg.hnkoff)
 		return inomap.lastseg.segoff;
 	else
 		return SEGPERHNK - 1;
@@ -1116,7 +1116,7 @@ inomap_lastseg( int hnkoff )
  * order. adds a new segment to the inomap and ino-to-gen map.
  */
 static int
-cb_add_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
+cb_add_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
 {
 	hnk_t *hunk;
 	seg_t *segp;
@@ -1149,13 +1149,13 @@ cb_add_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
 			       SEGPERHNK * sizeof(i2gseg_t));
 		}
 
-		memset(inomap_addr2hnk( lastsegp ), 0, HNKSZ);
+		memset(inomap_addr2hnk(lastsegp), 0, HNKSZ);
 	}
 
-	hunk = inomap_addr2hnk( lastsegp );
+	hunk = inomap_addr2hnk(lastsegp);
 	hunk->maxino = inogrp->xi_startino + INOPERSEG - 1;
 
-	segp = inomap_addr2seg( lastsegp );
+	segp = inomap_addr2seg(lastsegp);
 	segp->base = inogrp->xi_startino;
 
 	return 0;
@@ -1164,41 +1164,41 @@ cb_add_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
 /* called for every ino to be added to the map.
  */
 static void
-inomap_add( void *contextp, xfs_ino_t ino, gen_t gen, int state )
+inomap_add(void *contextp, xfs_ino_t ino, gen_t gen, int state)
 {
-	inomap_set_state( contextp, ino, state );
-	inomap_set_gen( contextp, ino, gen );
+	inomap_set_state(contextp, ino, state);
+	inomap_set_gen(contextp, ino, gen);
 }
 
 void *
-inomap_alloc_context( void )
+inomap_alloc_context(void)
 {
-	void *addr = calloc( 1, sizeof(seg_addr_t) );
+	void *addr = calloc(1, sizeof(seg_addr_t));
 	if (!addr) {
-		mlog( MLOG_NORMAL | MLOG_ERROR,
+		mlog(MLOG_NORMAL | MLOG_ERROR,
 		      _("failed to allocate inomap context: %s\n"),
-		      strerror(errno) );
+		      strerror(errno));
 	}
 	return addr;
 }
 
 void
-inomap_reset_context( void *p )
+inomap_reset_context(void *p)
 {
-	memset( p, 0, sizeof(seg_addr_t) );
+	memset(p, 0, sizeof(seg_addr_t));
 }
 
 void
-inomap_free_context( void *p )
+inomap_free_context(void *p)
 {
-	free( p );
+	free(p);
 }
 
 /* use binary search to find the hunk containing the given inode.
  * use the supplied addr as the starting point for the search.
  */
 static bool_t
-inomap_find_hnk( seg_addr_t *addrp, xfs_ino_t ino )
+inomap_find_hnk(seg_addr_t *addrp, xfs_ino_t ino)
 {
 	hnk_t *hunkp;
 	int lower;
@@ -1206,12 +1206,12 @@ inomap_find_hnk( seg_addr_t *addrp, xfs_ino_t ino )
 
 	lower = 0;
 	upper = inomap.lastseg.hnkoff;
-	while ( upper >= lower ) {
-		hunkp = inomap_addr2hnk( addrp );
+	while (upper >= lower) {
+		hunkp = inomap_addr2hnk(addrp);
 
-		if ( hunkp->seg[0].base > ino ) {
+		if (hunkp->seg[0].base > ino) {
 			upper = addrp->hnkoff - 1;
-		} else if ( hunkp->maxino < ino ) {
+		} else if (hunkp->maxino < ino) {
 			lower = addrp->hnkoff + 1;
 		} else {
 			return BOOL_TRUE;
@@ -1230,29 +1230,29 @@ inomap_find_hnk( seg_addr_t *addrp, xfs_ino_t ino )
  * point for the search.
  */
 static bool_t
-inomap_find_seg( seg_addr_t *addrp, xfs_ino_t ino )
+inomap_find_seg(seg_addr_t *addrp, xfs_ino_t ino)
 {
 	seg_t *segp;
 	int lower;
 	int upper;
 
-	if ( !inomap_validaddr( addrp ) ) {
-		inomap_reset_context( addrp );
+	if (!inomap_validaddr(addrp)) {
+		inomap_reset_context(addrp);
 	}
 
-	if ( !inomap_find_hnk( addrp, ino ) )
+	if (!inomap_find_hnk(addrp, ino))
 		return BOOL_FALSE;
 
 	/* find the correct segment */
 	lower = 0;
 	upper = inomap_lastseg(addrp->hnkoff);
 
-	while ( upper >= lower ) {
-		segp = inomap_addr2seg( addrp );
+	while (upper >= lower) {
+		segp = inomap_addr2seg(addrp);
 
-		if ( segp->base > ino ) {
+		if (segp->base > ino) {
 			upper = addrp->segoff - 1;
-		} else if ( segp->base + INOPERSEG <= ino ) {
+		} else if (segp->base + INOPERSEG <= ino) {
 			lower = addrp->segoff + 1;
 		} else {
 			return BOOL_TRUE;
@@ -1265,28 +1265,28 @@ inomap_find_seg( seg_addr_t *addrp, xfs_ino_t ino )
 }
 
 static xfs_ino_t
-inomap_iter( void *contextp, int statemask )
+inomap_iter(void *contextp, int statemask)
 {
 	xfs_ino_t ino, endino;
 	seg_t *segp;
 	seg_addr_t *addrp = (seg_addr_t *)contextp;
 
-	for ( ;
+	for (;
 	      addrp->hnkoff <= inomap.lastseg.hnkoff;
-	      addrp->hnkoff++, addrp->segoff = 0, addrp->inooff = 0 ) {
+	      addrp->hnkoff++, addrp->segoff = 0, addrp->inooff = 0) {
 
-		for ( ;
+		for (;
 		      addrp->segoff <= inomap_lastseg(addrp->hnkoff);
-		      addrp->segoff++, addrp->inooff = 0 ) {
+		      addrp->segoff++, addrp->inooff = 0) {
 
-			segp = inomap_addr2seg( addrp );
+			segp = inomap_addr2seg(addrp);
 
 			ino = segp->base + addrp->inooff;
 			endino = segp->base + INOPERSEG;
-			for ( ; ino < endino ; ino++, addrp->inooff++ ) {
+			for (; ino < endino ; ino++, addrp->inooff++) {
 				int st;
-				st = SEG_GET_BITS( segp, ino );
-				if ( statemask & ( 1 << st )) {
+				st = SEG_GET_BITS(segp, ino);
+				if (statemask & (1 << st)) {
 					addrp->inooff++; /* for next call */
 					return ino;
 				}
@@ -1324,7 +1324,7 @@ inomap_next_dir(void *contextp, xfs_ino_t lastino)
 }
 
 static int
-inomap_set_state( void *contextp, xfs_ino_t ino, int state )
+inomap_set_state(void *contextp, xfs_ino_t ino, int state)
 {
 	int oldstate;
 	seg_addr_t *addrp;
@@ -1332,31 +1332,31 @@ inomap_set_state( void *contextp, xfs_ino_t ino, int state )
 	seg_t *segp;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if ( !inomap_find_seg( addrp, ino ) )
+	if (!inomap_find_seg(addrp, ino))
 		return MAP_INO_UNUSED;
 
-	segp = inomap_addr2seg( addrp );
+	segp = inomap_addr2seg(addrp);
 
-	oldstate = SEG_GET_BITS( segp, ino );
-	SEG_SET_BITS( segp, ino, state );
+	oldstate = SEG_GET_BITS(segp, ino);
+	SEG_SET_BITS(segp, ino, state);
 
 	return oldstate;
 }
 
 int
-inomap_get_state( void *contextp, xfs_ino_t ino )
+inomap_get_state(void *contextp, xfs_ino_t ino)
 {
 	seg_addr_t *addrp;
 	seg_addr_t addr;
 	seg_t *segp;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if ( !inomap_find_seg( addrp, ino ) )
+	if (!inomap_find_seg(addrp, ino))
 		return MAP_INO_UNUSED;
 
-	segp = inomap_addr2seg( addrp );
+	segp = inomap_addr2seg(addrp);
 
-	return SEG_GET_BITS( segp, ino );
+	return SEG_GET_BITS(segp, ino);
 }
 
 static void
@@ -1369,11 +1369,11 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 	xfs_ino_t relino;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if ( !inomap_find_seg( addrp, ino ) )
+	if (!inomap_find_seg(addrp, ino))
 		return;
 
-	segp = inomap_addr2seg( addrp );
-	i2gsegp = &inomap.i2gmap[inomap_addr2segix( addrp )];
+	segp = inomap_addr2seg(addrp);
+	i2gsegp = &inomap.i2gmap[inomap_addr2segix(addrp)];
 
 	relino = ino - segp->base;
 	i2gsegp->s_valid |= (uint64_t)1 << relino;
@@ -1381,7 +1381,7 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 }
 
 int
-inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
+inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen)
 {
 	seg_addr_t *addrp;
 	seg_addr_t addr;
@@ -1390,14 +1390,14 @@ inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
 	xfs_ino_t relino;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if ( !inomap_find_seg( addrp, ino ) )
+	if (!inomap_find_seg(addrp, ino))
 		return 1;
 
-	segp = inomap_addr2seg( addrp );
-	i2gsegp = &inomap.i2gmap[inomap_addr2segix( addrp )];
+	segp = inomap_addr2seg(addrp);
+	i2gsegp = &inomap.i2gmap[inomap_addr2segix(addrp)];
 
 	relino = ino - segp->base;
-	if ( ! (i2gsegp->s_valid & ((uint64_t)1 << relino)) )
+	if (! (i2gsegp->s_valid & ((uint64_t)1 << relino)))
 		return 1;
 
 	*gen = i2gsegp->s_gen[relino];
@@ -1405,21 +1405,21 @@ inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
 }
 
 void
-inomap_writehdr( content_inode_hdr_t *scwhdrp )
+inomap_writehdr(content_inode_hdr_t *scwhdrp)
 {
 	/* update the inomap info in the content header
 	 */
 	scwhdrp->cih_inomap_hnkcnt = inomap.lastseg.hnkoff + 1;
-	scwhdrp->cih_inomap_segcnt = inomap_addr2segix( &inomap.lastseg ) + 1;
-	scwhdrp->cih_inomap_dircnt = ( uint64_t )cb_dircnt;
-	scwhdrp->cih_inomap_nondircnt = ( uint64_t )cb_nondircnt;
-	scwhdrp->cih_inomap_firstino = inomap.hnkmap[0].seg[ 0 ].base;
+	scwhdrp->cih_inomap_segcnt = inomap_addr2segix(&inomap.lastseg) + 1;
+	scwhdrp->cih_inomap_dircnt = (uint64_t)cb_dircnt;
+	scwhdrp->cih_inomap_nondircnt = (uint64_t)cb_nondircnt;
+	scwhdrp->cih_inomap_firstino = inomap.hnkmap[0].seg[0].base;
 	scwhdrp->cih_inomap_lastino = inomap.hnkmap[inomap.lastseg.hnkoff].maxino;
-	scwhdrp->cih_inomap_datasz = ( uint64_t )cb_datasz;
+	scwhdrp->cih_inomap_datasz = (uint64_t)cb_datasz;
 }
 
 rv_t
-inomap_dump( drive_t *drivep )
+inomap_dump(drive_t *drivep)
 {
 	seg_addr_t addr;
 	hnk_t *hnkp;
@@ -1427,22 +1427,22 @@ inomap_dump( drive_t *drivep )
 
 	/* use write_buf to dump the hunks
 	 */
-	for ( addr.hnkoff = 0 ;
+	for (addr.hnkoff = 0 ;
 	      addr.hnkoff <= inomap.lastseg.hnkoff ;
-	      addr.hnkoff++ ) {
+	      addr.hnkoff++) {
 		int rval;
 		rv_t rv;
 		drive_ops_t *dop = drivep->d_opsp;
 
-		hnkp = inomap_addr2hnk( &addr );
+		hnkp = inomap_addr2hnk(&addr);
 
 		xlate_hnk(hnkp, &tmphnkp, 1);
-		rval = write_buf( ( char * )&tmphnkp,
-				  sizeof( tmphnkp ),
-				  ( void * )drivep,
-				  ( gwbfp_t )dop->do_get_write_buf,
-				  ( wfp_t )dop->do_write );
-		switch ( rval ) {
+		rval = write_buf((char *)&tmphnkp,
+				  sizeof(tmphnkp),
+				  (void *)drivep,
+				  (gwbfp_t)dop->do_get_write_buf,
+				  (wfp_t)dop->do_write);
+		switch (rval) {
 		case 0:
 			rv = RV_OK;
 			break;
@@ -1461,7 +1461,7 @@ inomap_dump( drive_t *drivep )
 			rv = RV_CORE;
 			break;
 		}
-		if ( rv != RV_OK ) {
+		if (rv != RV_OK) {
 			return rv;
 		}
 	}
@@ -1470,38 +1470,38 @@ inomap_dump( drive_t *drivep )
 }
 
 static int
-subtreelist_parse( jdm_fshandle_t *fshandlep,
+subtreelist_parse(jdm_fshandle_t *fshandlep,
 		   int fsfd,
 		   xfs_bstat_t *rootstatp,
 		   char *subtreebuf[],
-		   ix_t subtreecnt )
+		   ix_t subtreecnt)
 {
 	ix_t subtreeix;
 
 	/* add the root ino to the dump
 	 */
-	cb_add( NULL, fshandlep, fsfd, rootstatp );
+	cb_add(NULL, fshandlep, fsfd, rootstatp);
 
 	/* do a recursive descent for each subtree specified
 	 */
-	for ( subtreeix = 0 ; subtreeix < subtreecnt ; subtreeix++ ) {
+	for (subtreeix = 0 ; subtreeix < subtreecnt ; subtreeix++) {
 		int cbrval = 0;
-		char *currentpath = subtreebuf[ subtreeix ];
-		assert( *currentpath != '/' );
-		( void )diriter( fshandlep,
+		char *currentpath = subtreebuf[subtreeix];
+		assert(*currentpath != '/');
+		(void)diriter(fshandlep,
 				 fsfd,
 				 rootstatp,
 				 subtreelist_parse_cb,
-				 ( void * )currentpath,
+				 (void *)currentpath,
 				 &cbrval,
 				 NULL,
-				 0 );
-		if ( cbrval != 1 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_INOMAP,
+				 0);
+		if (cbrval != 1) {
+			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_INOMAP,
 			      "%s: %s\n",
 			      cbrval == 0 ? _("subtree not present")
 					  : _("invalid subtree specified"),
-			      currentpath );
+			      currentpath);
 			return -1;
 		}
 	}
@@ -1510,30 +1510,30 @@ subtreelist_parse( jdm_fshandle_t *fshandlep,
 }
 
 static int
-subtreelist_parse_cb( void *arg1,
+subtreelist_parse_cb(void *arg1,
 		      jdm_fshandle_t *fshandlep,
 		      int fsfd,
 		      xfs_bstat_t *statp,
-		      char *name  )
+		      char *name)
 {
 	int cbrval = 0;
 
 	/* arg1 is used to carry the tail of the subtree path
 	 */
-	char *subpath = ( char * )arg1;
+	char *subpath = (char *)arg1;
 
 	/* temporarily terminate the subpath at the next slash
 	 */
-	char *nextslash = strchr( subpath, '/' );
-	if ( nextslash ) {
+	char *nextslash = strchr(subpath, '/');
+	if (nextslash) {
 		*nextslash = 0;
 	}
 
 	/* if the first element of the subpath doesn't match this
 	 * directory entry, try the next entry.
 	 */
-	if ( strcmp( subpath, name )) {
-		if ( nextslash ) {
+	if (strcmp(subpath, name)) {
+		if (nextslash) {
 			*nextslash = '/';
 		}
 		return 0;
@@ -1541,15 +1541,15 @@ subtreelist_parse_cb( void *arg1,
 
 	/* it matches, so add ino to list and continue down the path
 	 */
-	cb_add( NULL, fshandlep, fsfd, statp );
+	cb_add(NULL, fshandlep, fsfd, statp);
 
-	if ( nextslash ) {
+	if (nextslash) {
 
 		/* if we're not at the end of the path, yet the current
 		 * path element is not a directory, complain and abort the
 		 * iteration in a way which terminates the application
 		 */
-		if ( ( statp->bs_mode & S_IFMT ) != S_IFDIR ) {
+		if ((statp->bs_mode & S_IFMT) != S_IFDIR) {
 			*nextslash = '/';
 			return 2;
 		}
@@ -1560,14 +1560,14 @@ subtreelist_parse_cb( void *arg1,
 
 		/* peel the first element of the subpath and recurse
 		*/
-		( void )diriter( fshandlep,
+		(void)diriter(fshandlep,
 				 fsfd,
 				 statp,
 				 subtreelist_parse_cb,
-				 ( void * )( nextslash + 1 ),
+				 (void *)(nextslash + 1),
 				 &cbrval,
 				 NULL,
-				 0 );
+				 0);
 		return cbrval;
 
 	} else {
@@ -1576,43 +1576,43 @@ subtreelist_parse_cb( void *arg1,
 		 * to the inomap.
 		 */
 
-		if ( ( statp->bs_mode & S_IFMT ) != S_IFDIR ) {
+		if ((statp->bs_mode & S_IFMT) != S_IFDIR) {
 			return 1;
 		}
 
-		( void )diriter( fshandlep,
+		(void)diriter(fshandlep,
 				 fsfd,
 				 statp,
 				 subtree_descend_cb,
 				 NULL,
 				 &cbrval,
 				 0,
-				 0 );
+				 0);
 		return 1;
 	}
 }
 
 static int
-subtree_descend_cb( void *arg1,
+subtree_descend_cb(void *arg1,
 		    jdm_fshandle_t *fshandlep,
 		    int fsfd,
 		    xfs_bstat_t *statp,
-		    char *name  )
+		    char *name)
 {
 	int cbrval = 0;
 
-	cb_add( NULL, fshandlep, fsfd, statp );
+	cb_add(NULL, fshandlep, fsfd, statp);
 
-	if ( ( statp->bs_mode & S_IFMT ) == S_IFDIR ) {
+	if ((statp->bs_mode & S_IFMT) == S_IFDIR) {
 
-		( void )diriter( fshandlep,
+		(void)diriter(fshandlep,
 				 fsfd,
 				 statp,
 				 subtree_descend_cb,
 				 NULL,
 				 &cbrval,
 				 NULL,
-				 0 );
+				 0);
 	}
 
 	return cbrval;
@@ -1624,10 +1624,10 @@ subtree_descend_cb( void *arg1,
 #define BMAP_LEN	512
 
 static off64_t
-quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
+quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
 {
 	int fd;
-	getbmapx_t bmap[ BMAP_LEN ];
+	getbmapx_t bmap[BMAP_LEN];
 	off64_t offset;
 	off64_t offset_next;
 	off64_t qty_accum;
@@ -1644,51 +1644,51 @@ quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
 	offset = 0;
 	offset_next = 0;
 	qty_accum = 0;
-	bmap[ 0 ].bmv_offset = 0;
-	bmap[ 0 ].bmv_length = -1;
-	bmap[ 0 ].bmv_count = BMAP_LEN;
-	bmap[ 0 ].bmv_iflags = BMV_IF_NO_DMAPI_READ;
-	bmap[ 0 ].bmv_entries = -1;
-	fd = jdm_open( fshandlep, statp, O_RDONLY );
-	if ( fd < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
+	bmap[0].bmv_offset = 0;
+	bmap[0].bmv_length = -1;
+	bmap[0].bmv_count = BMAP_LEN;
+	bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;
+	bmap[0].bmv_entries = -1;
+	fd = jdm_open(fshandlep, statp, O_RDONLY);
+	if (fd < 0) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
 		      "could not open ino %llu to read extent map: %s\n"),
 		      statp->bs_ino,
-		      strerror( errno ));
+		      strerror(errno));
 		return 0;
 	}
 
-	for ( ; ; ) {
+	for (; ;) {
 		int eix;
 		int rval;
 
-		rval = ioctl( fd, XFS_IOC_GETBMAPX, bmap );
-		if ( rval ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
+		rval = ioctl(fd, XFS_IOC_GETBMAPX, bmap);
+		if (rval) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
 			      "could not read extent map for ino %llu: %s\n"),
 			      statp->bs_ino,
-			      strerror( errno ));
-			( void )close( fd );
+			      strerror(errno));
+			(void)close(fd);
 			return 0;
 		}
 
-		if ( bmap[ 0 ].bmv_entries <= 0 ) {
-			assert( bmap[ 0 ].bmv_entries == 0 );
-			( void )close( fd );
+		if (bmap[0].bmv_entries <= 0) {
+			assert(bmap[0].bmv_entries == 0);
+			(void)close(fd);
 			return offset_next;
 		}
 
-		for ( eix = 1 ; eix <= bmap[ 0 ].bmv_entries ; eix++ ) {
-			getbmapx_t *bmapp = &bmap[ eix ];
+		for (eix = 1 ; eix <= bmap[0].bmv_entries ; eix++) {
+			getbmapx_t *bmapp = &bmap[eix];
 			off64_t qty_new;
-			if ( bmapp->bmv_block == -1 ) {
+			if (bmapp->bmv_block == -1) {
 				continue; /* hole */
 			}
 			offset = bmapp->bmv_offset * BBSIZE;
 			qty_new = qty_accum + bmapp->bmv_length * BBSIZE;
-			if ( qty_new >= qty ) {
-				( void )close( fd );
-				return offset + ( qty - qty_accum );
+			if (qty_new >= qty) {
+				(void)close(fd);
+				return offset + (qty - qty_accum);
 			}
 			offset_next = offset + bmapp->bmv_length * BBSIZE;
 			qty_accum = qty_new;
@@ -1699,9 +1699,9 @@ quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
 
 
 static off64_t
-estimate_dump_space( xfs_bstat_t *statp )
+estimate_dump_space(xfs_bstat_t *statp)
 {
-	switch ( statp->bs_mode & S_IFMT ) {
+	switch (statp->bs_mode & S_IFMT) {
 	case S_IFREG:
 		/* very rough: must improve this.  If GETOPT_DUMPASOFFLINE was
 		 * specified and the HSM provided an estimate, then use it.
@@ -1719,7 +1719,7 @@ estimate_dump_space( xfs_bstat_t *statp )
 			if (HsmEstimateFileSpace(hsm_fs_ctxtp, NULL, statp, &bytes, accurate))
 				return bytes;
 		}
-		return statp->bs_blocks * ( off64_t )statp->bs_blksize;
+		return statp->bs_blocks * (off64_t)statp->bs_blksize;
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFDIR:
@@ -1734,11 +1734,11 @@ estimate_dump_space( xfs_bstat_t *statp )
 	*/
 		return 0;
 	default:
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
 		      "unknown inode type: ino=%llu, mode=0x%04x 0%06o\n"),
 		      statp->bs_ino,
 		      statp->bs_mode,
-		      statp->bs_mode );
+		      statp->bs_mode);
 		return 0;
 	}
 }
diff --git a/dump/inomap.h b/dump/inomap.h
index fb9bbf7..64b769a 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -47,7 +47,7 @@ struct xfs_bstat;
  * fall at file boundaries. returns BOOL_FALSE if error encountered (should
  * abort the dump; else returns BOOL_TRUE.
  */
-extern bool_t inomap_build( void *fshandlep,
+extern bool_t inomap_build(void *fshandlep,
 			    int fsfd,
 			    struct xfs_bstat *rootstatp,
 			    bool_t last,
@@ -64,26 +64,26 @@ extern bool_t inomap_build( void *fshandlep,
 			    ix_t *statphasep,
 			    ix_t *statpassp,
 			    size64_t statcnt,
-			    size64_t *statdonep );
+			    size64_t *statdonep);
 
-extern uint64_t inomap_getsz( void );
+extern uint64_t inomap_getsz(void);
 
 /* inomap_skip - tell inomap about inodes to skip in the dump
  */
-extern void inomap_skip( xfs_ino_t ino );
+extern void inomap_skip(xfs_ino_t ino);
 
 
 /* inomap_writehdr - updates the write header with inomap-private info
  * to be communicated to the restore side
  */
-extern void inomap_writehdr( content_inode_hdr_t *scwhdrp );
+extern void inomap_writehdr(content_inode_hdr_t *scwhdrp);
 
 
 /* inomap_dump - dumps the map to media - content-abstraction-knowledgable
  *
  * returns error from media write op
  */
-extern rv_t inomap_dump( drive_t *drivep );
+extern rv_t inomap_dump(drive_t *drivep);
 
 
 /* map state values
@@ -111,16 +111,16 @@ struct seg {
 
 typedef struct seg seg_t;
 
-#define INOPERSEG	( sizeof( (( seg_t * )0 )->lobits ) * NBBY )
+#define INOPERSEG	(sizeof(((seg_t *)0)->lobits) * NBBY)
 
-#define HNKSZ		( 4 * PGSZ )
-#define SEGPERHNK	( ( HNKSZ / sizeof( seg_t )) - 1 )
+#define HNKSZ		(4 * PGSZ)
+#define SEGPERHNK	((HNKSZ / sizeof(seg_t)) - 1)
 
 struct hnk {
-	seg_t seg[ SEGPERHNK ];
+	seg_t seg[SEGPERHNK];
 	xfs_ino_t maxino;
 	struct hnk *nextp;		/* no longer used, kept for binary compat */
-	char pad[sizeof( seg_t ) - sizeof( xfs_ino_t ) - sizeof( struct hnk * )];
+	char pad[sizeof(seg_t) - sizeof(xfs_ino_t) - sizeof(struct hnk *)];
 };
 
 typedef struct hnk hnk_t;
@@ -129,11 +129,11 @@ typedef struct hnk hnk_t;
  * requires a pointer to a context block, obtained from
  * inomap_alloc_context(), and released by inomap_free_context().
  */
-extern void *inomap_alloc_context( void );
-extern void inomap_reset_context( void *contextp );
-extern void inomap_free_context( void *contextp );
-extern int inomap_get_state( void *contextp, xfs_ino_t ino );
-extern int inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen );
+extern void *inomap_alloc_context(void);
+extern void inomap_reset_context(void *contextp);
+extern void inomap_free_context(void *contextp);
+extern int inomap_get_state(void *contextp, xfs_ino_t ino);
+extern int inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen);
 
 
 /* generators returning the next dir or non-dir ino selected in this dump.
diff --git a/dump/var.c b/dump/var.c
index 6e3ead0..440e42d 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -34,137 +34,137 @@
 #include "global.h"
 #include "inventory.h"
 
-static void var_skip_recurse( char *, void ( * )( xfs_ino_t ));
-static int  var_create_component( char * );
+static void var_skip_recurse(char *, void (*)(xfs_ino_t));
+static int  var_create_component(char *);
 
 void
-var_create( void )
+var_create(void)
 {
 	char path[PATH_MAX];
 	char *p;
 
-	p = strcpy( path, XFSDUMP_DIRPATH );
-	mlog( MLOG_DEBUG, "creating directory %s\n", path );
+	p = strcpy(path, XFSDUMP_DIRPATH);
+	mlog(MLOG_DEBUG, "creating directory %s\n", path);
 
 	do {
 		p++;
-		if ( *p == '/' ) {
+		if (*p == '/') {
 			*p = '\0';
-			if ( ! var_create_component( path ) )
+			if (! var_create_component(path))
 				return;
 			*p = '/';
 		}
-	} while ( *p );
+	} while (*p);
 
-	( void ) var_create_component( path );
+	(void) var_create_component(path);
 }
 
 static int
-var_create_component( char *path )
+var_create_component(char *path)
 {
-	int rval = mkdir( path, 0755 );
+	int rval = mkdir(path, 0755);
 
-	if ( rval && errno != EEXIST ) {
-		mlog( MLOG_NORMAL, _("unable to create %s: %s\n"),
-		      path, strerror( errno ));
+	if (rval && errno != EEXIST) {
+		mlog(MLOG_NORMAL, _("unable to create %s: %s\n"),
+		      path, strerror(errno));
 		return 0;
 	}
-	if ( rval == 0 ) {
-		rval = chown( path, 0, 0 );
-		if ( rval ) {
-			mlog( MLOG_NORMAL, _("unable to chown %s: %s\n"),
-			      path, strerror( errno ));
+	if (rval == 0) {
+		rval = chown(path, 0, 0);
+		if (rval) {
+			mlog(MLOG_NORMAL, _("unable to chown %s: %s\n"),
+			      path, strerror(errno));
 		}
 	}
 	return 1;
 }
 
 void
-var_skip( uuid_t *dumped_fsidp, void ( *cb )( xfs_ino_t ino ))
+var_skip(uuid_t *dumped_fsidp, void (*cb)(xfs_ino_t ino))
 {
 	uuid_t fsid;
 	int rval;
 
 	/* see if the fs uuid's match
 	 */
-	rval = fs_getid( XFSDUMP_DIRPATH, &fsid );
-	if ( rval ) {
+	rval = fs_getid(XFSDUMP_DIRPATH, &fsid);
+	if (rval) {
 #ifdef HIDDEN
                 /* NOTE: this will happen for non-XFS file systems */
                 /*       and is expected, so no msg */
-		mlog( MLOG_NORMAL, _(
+		mlog(MLOG_NORMAL, _(
 		      "unable to determine uuid of fs containing %s: "
 		      "%s\n"),
 		      XFSDUMP_DIRPATH,
-		      strerror( errno ));
+		      strerror(errno));
 #endif
 		return;
 	}
 
-	if ( uuid_compare( *dumped_fsidp, fsid ) != 0) {
+	if (uuid_compare(*dumped_fsidp, fsid) != 0) {
 		return;
 	}
 
 	/* traverse the xfsdump directory, getting inode numbers of it
 	 * and all of its children, and reporting those to the callback.
 	 */
-	var_skip_recurse( XFSDUMP_DIRPATH, cb );
+	var_skip_recurse(XFSDUMP_DIRPATH, cb);
 }
 
 static void
-var_skip_recurse( char *base, void ( *cb )( xfs_ino_t ino ))
+var_skip_recurse(char *base, void (*cb)(xfs_ino_t ino))
 {
 	struct stat64 statbuf;
 	DIR *dirp;
 	struct dirent *direntp;
 	int rval;
 
-	rval = lstat64( base, &statbuf );
-	if ( rval ) {
-		mlog( MLOG_NORMAL, _(
+	rval = lstat64(base, &statbuf);
+	if (rval) {
+		mlog(MLOG_NORMAL, _(
 		      "unable to get status of %s: %s\n"),
 		      base,
-		      strerror( errno ));
+		      strerror(errno));
 		return;
 	}
 
-	mlog( MLOG_DEBUG,
+	mlog(MLOG_DEBUG,
 	      "excluding %s from dump\n",
-	      base );
+	      base);
 
-	( * cb )( statbuf.st_ino );
+	(* cb)(statbuf.st_ino);
 
-	if ( ( statbuf.st_mode & S_IFMT ) != S_IFDIR ) {
+	if ((statbuf.st_mode & S_IFMT) != S_IFDIR) {
 		return;
 	}
 
-	dirp = opendir( base );
-	if ( ! dirp ) {
-		mlog( MLOG_NORMAL, _(
+	dirp = opendir(base);
+	if (! dirp) {
+		mlog(MLOG_NORMAL, _(
 		      "unable to open directory %s\n"),
-		      base );
+		      base);
 		return;
 	}
 
-	while ( ( direntp = readdir( dirp )) != NULL ) {
+	while ((direntp = readdir(dirp)) != NULL) {
 		char *path;
 
 		/* skip "." and ".."
 		 */
-		if ( *( direntp->d_name + 0 ) == '.'
+		if (*(direntp->d_name + 0) == '.'
 		     &&
-		     ( *( direntp->d_name + 1 ) == 0
+		     (*(direntp->d_name + 1) == 0
 		       ||
-		       ( *( direntp->d_name + 1 ) == '.'
+		       (*(direntp->d_name + 1) == '.'
 			 &&
-			 *( direntp->d_name + 2 ) == 0 ))) {
+			 *(direntp->d_name + 2) == 0))) {
 			continue;
 		}
 
-		path = open_pathalloc( base, direntp->d_name, 0 );
-		var_skip_recurse( path, cb );
-		free( ( void * )path );
+		path = open_pathalloc(base, direntp->d_name, 0);
+		var_skip_recurse(path, cb);
+		free((void *)path);
 	}
 
-	closedir( dirp );
+	closedir(dirp);
 }
diff --git a/dump/var.h b/dump/var.h
index 889a389..0a8f13d 100644
--- a/dump/var.h
+++ b/dump/var.h
@@ -21,8 +21,8 @@
 /* var.[ch] - abstraction dealing with /var/[lib/]xfsdump/
  */
 
-extern void var_create( void );
+extern void var_create(void);
 
-extern void var_skip( uuid_t *dumped_fsidp, void ( *cb )( xfs_ino_t ino ));
+extern void var_skip(uuid_t *dumped_fsidp, void (*cb)(xfs_ino_t ino));
 
 #endif /* VAR_H */
diff --git a/include/swab.h b/include/swab.h
index 2684aa7..abfeeb6 100644
--- a/include/swab.h
+++ b/include/swab.h
@@ -7,25 +7,25 @@
 #define ___swab16(x) \
 ({ \
 	__u16 __x = (x); \
-	((__u16)( \
+	((__u16)(\
 		(((__u16)(__x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(__x) & (__u16)0xff00U) >> 8) )); \
+		(((__u16)(__x) & (__u16)0xff00U) >> 8))); \
 })
 
 #define ___swab32(x) \
 ({ \
 	__u32 __x = (x); \
-	((__u32)( \
+	((__u32)(\
 		(((__u32)(__x) & (__u32)0x000000ffUL) << 24) | \
 		(((__u32)(__x) & (__u32)0x0000ff00UL) <<  8) | \
 		(((__u32)(__x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(__x) & (__u32)0xff000000UL) >> 24) )); \
+		(((__u32)(__x) & (__u32)0xff000000UL) >> 24))); \
 })
 
 #define ___swab64(x) \
 ({ \
 	__u64 __x = (x); \
-	((__u64)( \
+	((__u64)(\
 		(__u64)(((__u64)(__x) & (__u64)0x00000000000000ffULL) << 56) | \
 		(__u64)(((__u64)(__x) & (__u64)0x000000000000ff00ULL) << 40) | \
 		(__u64)(((__u64)(__x) & (__u64)0x0000000000ff0000ULL) << 24) | \
@@ -33,21 +33,21 @@
 		(__u64)(((__u64)(__x) & (__u64)0x000000ff00000000ULL) >>  8) | \
 		(__u64)(((__u64)(__x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
 		(__u64)(((__u64)(__x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56) )); \
+		(__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56))); \
 })
 
 #define ___constant_swab16(x) \
-	((__u16)( \
+	((__u16)(\
 		(((__u16)(x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(x) & (__u16)0xff00U) >> 8) ))
+		(((__u16)(x) & (__u16)0xff00U) >> 8)))
 #define ___constant_swab32(x) \
-	((__u32)( \
+	((__u32)(\
 		(((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
 		(((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
 		(((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(x) & (__u32)0xff000000UL) >> 24) ))
+		(((__u32)(x) & (__u32)0xff000000UL) >> 24)))
 #define ___constant_swab64(x) \
-	((__u64)( \
+	((__u64)(\
 		(__u64)(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) | \
 		(__u64)(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) | \
 		(__u64)(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) | \
@@ -55,7 +55,7 @@
 		(__u64)(((__u64)(x) & (__u64)0x000000ff00000000ULL) >>  8) | \
 		(__u64)(((__u64)(x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
 		(__u64)(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56) ))
+		(__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56)))
 
 /*
  * provide defaults when no architecture-specific optimization is detected
diff --git a/include/swap.h b/include/swap.h
index fa6aec6..d74453f 100644
--- a/include/swap.h
+++ b/include/swap.h
@@ -51,11 +51,11 @@
 
 #define INT_SET(ref,arch,valueref) \
 	(__builtin_constant_p(valueref) ? \
-	(void)( (ref) = ( ((arch) != ARCH_NOCONVERT) ? \
-	  		   (INT_SWAP((ref),(valueref))) : (valueref)) ) : \
-	(void)( ((ref) = (valueref)), \
-			( ((arch) != ARCH_NOCONVERT) ? \
-			   (ref) = INT_SWAP((ref),(ref)) : 0 ) ))
+	(void)((ref) = (((arch) != ARCH_NOCONVERT) ? \
+	  		   (INT_SWAP((ref),(valueref))) : (valueref))) : \
+	(void)(((ref) = (valueref)), \
+			(((arch) != ARCH_NOCONVERT) ? \
+			   (ref) = INT_SWAP((ref),(ref)) : 0)))
 
 #define INT_XLATE(buf,p,dir,arch) \
 	((dir > 0) ? ((p) = INT_GET((buf),(arch))) : INT_SET((buf),(arch),(p)))
diff --git a/inventory/getopt.h b/inventory/getopt.h
index 7bebc6d..4ae23e4 100644
--- a/inventory/getopt.h
+++ b/inventory/getopt.h
@@ -32,7 +32,7 @@
 #define	GETOPT_DUMPDEST		'f'	/* dump dest. file (drive.c) */
 #define	GETOPT_LEVEL		'l'	/* dump level (content_inode.c) */
 #define	GETOPT_SUBTREE		's'	/* subtree dump (content_inode.c) */
-#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4 ) */
+#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
 #define	GETOPT_DUMPLABEL	'L'	/* dump session label (global.c) */
 #define	GETOPT_MEDIALABEL	'M'	/* media object label (content.c) */
 #define	GETOPT_RESUME		'R'	/* resume intr dump (content_inode.c) */
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index eee128e..a5cb4df 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -47,7 +47,7 @@
 /*----------------------------------------------------------------------*/
 
 inv_idbtoken_t
-inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
+inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 {
 	int fd, stobjfd, num, retval;
 	inv_idbtoken_t tok = INV_TOKEN_NULL;
@@ -55,17 +55,17 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 
 	int index = 0;
 
-	assert ( pred );
-	fd = retval = init_idb ( pred, bywhat, forwhat, &tok );
+	assert (pred);
+	fd = retval = init_idb (pred, bywhat, forwhat, &tok);
 
-	if ( retval == I_DONE )
+	if (retval == I_DONE)
 		return tok;
 
 	/* if we just want to search the db, all we need is the invidx.
 	   at this point, we know that a tok wasnt created in init_idb() */
-	if ( forwhat == INV_SEARCH_ONLY ) {
+	if (forwhat == INV_SEARCH_ONLY) {
 		/* fd == I_EMPTYINV or fd == valid fd */
-		tok = get_token( fd, -1);
+		tok = get_token(fd, -1);
 		tok->d_oflag = forwhat;
 		return tok;
 	}
@@ -73,51 +73,51 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 	/* XXX also, see if it is too full. if so, make another and leave a
 	   reference to the new file in the old one */
 
-	stobjfd = idx_get_stobj( fd, forwhat, &index );
-	if ( stobjfd < 0 ) {
-		close( fd );
+	stobjfd = idx_get_stobj(fd, forwhat, &index);
+	if (stobjfd < 0) {
+		close(fd);
 		return INV_TOKEN_NULL;
 	}
 
-	assert ( index > 0 );
+	assert (index > 0);
 
 	/* Now we need to make sure that this has enough space */
-	INVLOCK( stobjfd, LOCK_SH );
+	INVLOCK(stobjfd, LOCK_SH);
 
-	num = GET_SESCOUNTERS( stobjfd, &sescnt );
-	if ( num < 0 ) {
-		close( fd );
-		INVLOCK( stobjfd, LOCK_UN );
-		close( stobjfd );
+	num = GET_SESCOUNTERS(stobjfd, &sescnt);
+	if (num < 0) {
+		close(fd);
+		INVLOCK(stobjfd, LOCK_UN);
+		close(stobjfd);
 		return INV_TOKEN_NULL;
 	}
 
-	/* create another storage object ( and, an inv_index entry for it
-	   too ) if we've filled this one up */
+	/* create another storage object (and, an inv_index entry for it
+	   too) if we've filled this one up */
 
-	if ( (uint) num >= sescnt->ic_maxnum ) {
-		mlog( MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
-		      "index entry. \n" );
-		INVLOCK( stobjfd, LOCK_UN );
+	if ((uint) num >= sescnt->ic_maxnum) {
+		mlog(MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
+		      "index entry. \n");
+		INVLOCK(stobjfd, LOCK_UN);
 		close (stobjfd);
 
-		INVLOCK( fd, LOCK_EX );
-		stobjfd = idx_create_entry( &tok, fd, BOOL_FALSE );
-		INVLOCK( fd, LOCK_UN );
+		INVLOCK(fd, LOCK_EX);
+		stobjfd = idx_create_entry(&tok, fd, BOOL_FALSE);
+		INVLOCK(fd, LOCK_UN);
 
-		free ( sescnt );
-		if ( stobjfd < 0 ) {
-			close( fd );
+		free (sescnt);
+		if (stobjfd < 0) {
+			close(fd);
 			return INV_TOKEN_NULL;
 		}
 		return tok;
 	}
 
-	INVLOCK( stobjfd, LOCK_UN );
+	INVLOCK(stobjfd, LOCK_UN);
 
-	free ( sescnt );
-	tok = get_token( fd, stobjfd );
-	tok->d_invindex_off = IDX_HDR_OFFSET( index - 1 );
+	free (sescnt);
+	tok = get_token(fd, stobjfd);
+	tok->d_invindex_off = IDX_HDR_OFFSET(index - 1);
 	tok->d_oflag = forwhat;
 	return tok;
 
@@ -134,12 +134,12 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 
 
 bool_t
-inv_close( inv_idbtoken_t tok )
+inv_close(inv_idbtoken_t tok)
 {
-	close ( tok->d_invindex_fd );
-	if ( tok->d_stobj_fd >= 0 )
-		close ( tok->d_stobj_fd );
-	destroy_token( tok );
+	close (tok->d_invindex_fd);
+	if (tok->d_stobj_fd >= 0)
+		close (tok->d_stobj_fd);
+	destroy_token(tok);
 	return BOOL_TRUE;
 }
 
@@ -167,7 +167,7 @@ inv_writesession_open(
 	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
-	char		*devpath )
+	char		*devpath)
 {
 	invt_session_t  ses;
 	int		fd;
@@ -177,17 +177,17 @@ inv_writesession_open(
 	inv_sestoken_t	sestok;
 	inv_oflag_t     forwhat;
 
-	assert ( tok != INV_TOKEN_NULL );
-	assert ( sesid && fsid && mntpt && devpath );
+	assert (tok != INV_TOKEN_NULL);
+	assert (sesid && fsid && mntpt && devpath);
 	forwhat = tok->d_oflag;
 	fd = tok->d_stobj_fd;
-	assert ( forwhat != INV_SEARCH_ONLY );
-	assert ( fd > 0 );
+	assert (forwhat != INV_SEARCH_ONLY);
+	assert (fd > 0);
 
-	if ( ! ( tok->d_update_flag & FSTAB_UPDATED ) ) {
-		if ( fstab_put_entry( fsid, mntpt, devpath, forwhat ) < 0 ) {
-		       mlog( MLOG_NORMAL | MLOG_INV, _(
-				"INV: put_fstab_entry failed.\n") );
+	if (! (tok->d_update_flag & FSTAB_UPDATED)) {
+		if (fstab_put_entry(fsid, mntpt, devpath, forwhat) < 0) {
+		       mlog(MLOG_NORMAL | MLOG_INV, _(
+				"INV: put_fstab_entry failed.\n"));
 		       return INV_TOKEN_NULL;
 		}
 		tok->d_update_flag |= FSTAB_UPDATED;
@@ -195,12 +195,12 @@ inv_writesession_open(
 
 
 	/* copy the session information to store */
-	memset( (void *)&ses, 0, sizeof( ses ) );	/* paranoia */
-	memcpy( &ses.s_sesid, sesid, sizeof( uuid_t ) );
-	memcpy( &ses.s_fsid, fsid, sizeof( uuid_t ) );
-	strcpy( ses.s_label, label );
-	strcpy( ses.s_mountpt, mntpt );
-	strcpy( ses.s_devpath, devpath );
+	memset((void *)&ses, 0, sizeof(ses));	/* paranoia */
+	memcpy(&ses.s_sesid, sesid, sizeof(uuid_t));
+	memcpy(&ses.s_fsid, fsid, sizeof(uuid_t));
+	strcpy(ses.s_label, label);
+	strcpy(ses.s_mountpt, mntpt);
+	strcpy(ses.s_devpath, devpath);
 	ses.s_max_nstreams = nstreams;
 
         hdr.sh_pruned = 0; /* session is not pruned by invutil */
@@ -210,41 +210,41 @@ inv_writesession_open(
 	hdr.sh_flag |= (isresumed) ? INVT_RESUMED : 0;
 	/* sh_streams_off and sh_sess_off will be set in create_session() */
 
-	sestok = get_sesstoken( tok );
+	sestok = get_sesstoken(tok);
 
 	/* we need to put the new session in the appropriate place in
 	   storage object. So first find out howmany sessions are there */
 
-	INVLOCK( fd, LOCK_EX );
-	if ( GET_SESCOUNTERS( fd, &sescnt) < 0 ) {
-		free ( sestok );
-		INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_EX);
+	if (GET_SESCOUNTERS(fd, &sescnt) < 0) {
+		free (sestok);
+		INVLOCK(fd, LOCK_UN);
 		return INV_TOKEN_NULL;
 	}
 
 	/* create the writesession, and get ready for the streams to come
 	   afterwards */
-	rval = stobj_create_session( sestok, fd, sescnt, &ses, &hdr );
+	rval = stobj_create_session(sestok, fd, sescnt, &ses, &hdr);
 	assert (rval > 0);
 
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
 	sestok->sd_sesstime = time;
 
-	if ( tok->d_update_flag & NEW_INVINDEX ) {
-		if ( idx_put_sesstime( sestok, INVT_STARTTIME ) < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
-				"INV: put_starttime failed.\n") );
+	if (tok->d_update_flag & NEW_INVINDEX) {
+		if (idx_put_sesstime(sestok, INVT_STARTTIME) < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
+				"INV: put_starttime failed.\n"));
 			return INV_TOKEN_NULL;
 		}
 		tok->d_update_flag &= ~(NEW_INVINDEX);
 	}
 
-	free ( sescnt );
+	free (sescnt);
 
 
-	return ( rval < 0 )? INV_TOKEN_NULL: sestok;
+	return (rval < 0)? INV_TOKEN_NULL: sestok;
 }
 
 
@@ -259,19 +259,19 @@ inv_writesession_open(
 
 
 bool_t
-inv_writesession_close( inv_sestoken_t tok )
+inv_writesession_close(inv_sestoken_t tok)
 {
 	int		rval;
 
-	assert ( tok != INV_TOKEN_NULL );
+	assert (tok != INV_TOKEN_NULL);
 
 	/* now update end_time in the inv index header */
-	rval = idx_put_sesstime( tok, INVT_ENDTIME );
+	rval = idx_put_sesstime(tok, INVT_ENDTIME);
 
-	memset( tok, 0, sizeof( invt_sesdesc_entry_t ) );
-	free ( tok );
+	memset(tok, 0, sizeof(invt_sesdesc_entry_t));
+	free (tok);
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
@@ -285,7 +285,7 @@ inv_writesession_close( inv_sestoken_t tok )
 inv_stmtoken_t
 inv_stream_open(
 	inv_sestoken_t tok,
-	char		*cmdarg )
+	char		*cmdarg)
 {
 	inv_stmtoken_t stok;
 	invt_stream_t  stream;
@@ -294,21 +294,21 @@ inv_stream_open(
 	int fd;
 	bool_t err = BOOL_FALSE;
 
-	assert ( tok != INV_TOKEN_NULL );
+	assert (tok != INV_TOKEN_NULL);
 
 	/* this memset is needed as a dump interrupted/crashed very soon
 	 * after starting results in an inventory with exteremely large
 	 * starting/ending inodes or offsets. This can be misleading.
 	 * See bug #463702 for an example.
 	 */
-	memset( (void *)&stream, 0 , sizeof(invt_stream_t) );
+	memset((void *)&stream, 0 , sizeof(invt_stream_t));
 
 	stream.st_nmediafiles = 0;
 	stream.st_interrupted = BOOL_TRUE; /* fix for 353197 */
-	strcpy( stream.st_cmdarg, cmdarg );
+	strcpy(stream.st_cmdarg, cmdarg);
 
 	/* XXX yukk... make the token descriptors not pointers */
-	stok = ( inv_stmtoken_t ) malloc( sizeof( invt_strdesc_entry_t ) );
+	stok = (inv_stmtoken_t) malloc(sizeof(invt_strdesc_entry_t));
 
 	stok->md_sesstok = tok;
 	stok->md_lastmfile = 0;
@@ -316,46 +316,46 @@ inv_stream_open(
 	/* get the session to find out where the stream is going to go */
 	fd = tok->sd_invtok->d_stobj_fd;
 
-	INVLOCK( fd, LOCK_EX );
+	INVLOCK(fd, LOCK_EX);
 
 	/* get the session header and the session */
-	if ( stobj_get_sessinfo( tok, &seshdr, &ses ) <= 0 )
+	if (stobj_get_sessinfo(tok, &seshdr, &ses) <= 0)
 		err = BOOL_TRUE;
 
-	if ( ( ! err )  && ses.s_cur_nstreams < ses.s_max_nstreams ) {
+	if ((! err)  && ses.s_cur_nstreams < ses.s_max_nstreams) {
 		/* this is where this stream header will be written to */
-		stok->md_stream_off = (off64_t) (sizeof( invt_stream_t ) *
-					         ses.s_cur_nstreams )
+		stok->md_stream_off = (off64_t) (sizeof(invt_stream_t) *
+					         ses.s_cur_nstreams)
 			                         + seshdr.sh_streams_off;
 		ses.s_cur_nstreams++;
 
 		/* write it back. */
-		if ( PUT_REC_NOLOCK( fd, &ses, sizeof( ses ),
-				     tok->sd_session_off ) < 0 )
+		if (PUT_REC_NOLOCK(fd, &ses, sizeof(ses),
+				     tok->sd_session_off) < 0)
 			err = BOOL_TRUE;
-	} else if ( ! err ) {
-		mlog ( MLOG_NORMAL, _(
+	} else if (! err) {
+		mlog (MLOG_NORMAL, _(
 		       "INV: cant create more than %d streams."
-		       " Max'd out..\n"), ses.s_cur_nstreams );
+		       " Max'd out..\n"), ses.s_cur_nstreams);
 		err = BOOL_TRUE;
 	}
 
-	if ( ! err ) {
+	if (! err) {
 		stream.st_firstmfile = stream.st_lastmfile =
 			               stok->md_stream_off;
 
 		/* now write the stream header on to the disk */
-		if ( PUT_REC_NOLOCK( fd, &stream, sizeof( invt_stream_t ),
-				    stok->md_stream_off ) > 0 ) {
+		if (PUT_REC_NOLOCK(fd, &stream, sizeof(invt_stream_t),
+				    stok->md_stream_off) > 0) {
 			/* we're all set */
-			INVLOCK( fd, LOCK_UN );
+			INVLOCK(fd, LOCK_UN);
 			return stok;
 		}
 	}
 
 	/* error occured somewhere */
-	free ( stok );
-	INVLOCK( fd, LOCK_UN );
+	free (stok);
+	INVLOCK(fd, LOCK_UN);
 	return INV_TOKEN_NULL;
 
 }
@@ -372,36 +372,36 @@ inv_stream_open(
 bool_t
 inv_stream_close(
 		inv_stmtoken_t	tok,
-		bool_t wasinterrupted )
+		bool_t wasinterrupted)
 {
 	invt_stream_t strm;
 	int fd = tok->md_sesstok->sd_invtok->d_stobj_fd;
 	int rval;
 	bool_t dowrite = BOOL_FALSE;
 
-	rval = idx_put_sesstime( tok->md_sesstok, INVT_ENDTIME );
+	rval = idx_put_sesstime(tok->md_sesstok, INVT_ENDTIME);
 	if (rval < 0)
-		mlog( MLOG_NORMAL | MLOG_INV, _(
+		mlog(MLOG_NORMAL | MLOG_INV, _(
 		      "INV: idx_put_sesstime failed in "
-		      "inv_stream_close() \n") );
-	INVLOCK( fd, LOCK_EX );
-	if ((rval = GET_REC_NOLOCK( fd, &strm, sizeof( invt_stream_t ),
-			       tok->md_stream_off )) > 0 ) {
+		      "inv_stream_close() \n"));
+	INVLOCK(fd, LOCK_EX);
+	if ((rval = GET_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
+			       tok->md_stream_off)) > 0) {
 
-		if ( strm.st_interrupted != wasinterrupted ) {
+		if (strm.st_interrupted != wasinterrupted) {
 			strm.st_interrupted = wasinterrupted;
 			dowrite = BOOL_TRUE;
 		}
 
 		/* get the last media file to figure out what our last
 		   ino was. we have a pointer to that in the stream token */
-		if ( tok->md_lastmfile ){
-			if ( strm.st_endino.ino !=
+		if (tok->md_lastmfile){
+			if (strm.st_endino.ino !=
 			      tok->md_lastmfile->mf_endino.ino ||
 			     strm.st_endino.offset !=
 			      tok->md_lastmfile->mf_endino.offset) {
 
-			      mlog( MLOG_DEBUG | MLOG_INV, "INV: stream_close() "
+			      mlog(MLOG_DEBUG | MLOG_INV, "INV: stream_close() "
 				    " - endinos dont match ! \n");
 			      dowrite = BOOL_TRUE;
 			      strm.st_endino = tok->md_lastmfile->mf_endino;
@@ -414,15 +414,15 @@ inv_stream_close(
 		}
 	}
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
-	if ( tok->md_lastmfile ) {
-		free ( tok->md_lastmfile );
+	if (tok->md_lastmfile) {
+		free (tok->md_lastmfile);
 	}
-	memset( tok, 0, sizeof( invt_strdesc_entry_t ) );
-	free ( tok );
+	memset(tok, 0, sizeof(invt_strdesc_entry_t));
+	free (tok);
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 }
 
 
@@ -452,15 +452,15 @@ inv_put_mediafile(
 	int 		 rval;
 
 
-	assert ( tok != INV_TOKEN_NULL );
-	assert ( tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED );
-	assert ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );
+	assert (tok != INV_TOKEN_NULL);
+	assert (tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED);
+	assert (tok->md_sesstok->sd_invtok->d_stobj_fd >= 0);
 
-	mf = (invt_mediafile_t *) calloc( 1, sizeof( invt_mediafile_t ) );
+	mf = (invt_mediafile_t *) calloc(1, sizeof(invt_mediafile_t));
 
 	/* copy the media file information */
-	memcpy( &mf->mf_moid, moid, sizeof( uuid_t ) );
-	strcpy( mf->mf_label, label );
+	memcpy(&mf->mf_moid, moid, sizeof(uuid_t));
+	strcpy(mf->mf_label, label);
 	mf->mf_mfileidx = mfileindex;
 	mf->mf_startino.ino = startino;
 	mf->mf_startino.offset = startino_offset;
@@ -468,25 +468,25 @@ inv_put_mediafile(
 	mf->mf_endino.offset = endino_offset;
 	mf->mf_size = size;
 	mf->mf_flag = 0;
-	if ( isgood )
+	if (isgood)
 		mf->mf_flag |= INVT_MFILE_GOOD;
 
 	/* This flag is used to indicate the media file that contains the
 	   dump of the sessioninfo structure that contains all but this
 	   media file */
-	if ( isinvdump )
+	if (isinvdump)
 		mf->mf_flag |= INVT_MFILE_INVDUMP;
 
-	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_EX );
-	rval = stobj_put_mediafile( tok, mf );
-	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN );
+	INVLOCK(tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_EX);
+	rval = stobj_put_mediafile(tok, mf);
+	INVLOCK(tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN);
 
 	/* we dont free the mfile here. we always keep the last mfile
 	   around, inside the inv_stmtoken, and when we add a new mfile,
 	   we free the previous one. The last one is freed in stream_close()
 	   */
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
@@ -510,7 +510,7 @@ bool_t
 inv_get_sessioninfo(
 	inv_sestoken_t		tok,
 	void		      **bufpp,	/* buf to fill */
-	size_t		       *bufszp )/* size of that buffer */
+	size_t		       *bufszp)/* size of that buffer */
 {
 	invt_session_t 	ses;
 	invt_seshdr_t	hdr;
@@ -518,23 +518,23 @@ inv_get_sessioninfo(
 	int		fd;
 
 
-	assert( tok != INV_TOKEN_NULL );
-	assert( tok->sd_invtok );
+	assert(tok != INV_TOKEN_NULL);
+	assert(tok->sd_invtok);
 	*bufpp = NULL;
 	*bufszp = 0;
 	fd = tok->sd_invtok->d_stobj_fd;
 
-	INVLOCK( fd, LOCK_SH );
+	INVLOCK(fd, LOCK_SH);
 
 	/* Next we get the session header, and the session information. Then
 	   we can figure out how much space to allocate */
-	if ( stobj_get_sessinfo( tok, &hdr, &ses ) <= 0 ) {
-		INVLOCK( fd, LOCK_UN );
+	if (stobj_get_sessinfo(tok, &hdr, &ses) <= 0) {
+		INVLOCK(fd, LOCK_UN);
 		return BOOL_FALSE;
 	}
 
-	rval = stobj_pack_sessinfo( fd, &ses, &hdr, bufpp, bufszp );
-	INVLOCK( fd, LOCK_UN );
+	rval = stobj_pack_sessinfo(fd, &ses, &hdr, bufpp, bufszp);
+	INVLOCK(fd, LOCK_UN);
 
 
 	return rval;
@@ -555,18 +555,18 @@ inv_get_sessioninfo(
 /*----------------------------------------------------------------------*/
 
 bool_t
-inv_put_sessioninfo( invt_sessinfo_t *s )
+inv_put_sessioninfo(invt_sessinfo_t *s)
 {
 	static bool_t invdir_ok = BOOL_FALSE;
 
-	if ( !invdir_ok ) {
-		if ( make_invdirectory( INV_SEARCH_N_MOD ) < 0 )
+	if (!invdir_ok) {
+		if (make_invdirectory(INV_SEARCH_N_MOD) < 0)
 			return BOOL_FALSE;
 		else
 			invdir_ok = BOOL_TRUE;
 	}
 
-      	return insert_session( s );
+      	return insert_session(s);
 
 }
 
@@ -588,7 +588,7 @@ inv_free_session(
 	assert(ses);
 	assert(*ses);
 
-	for ( i = 0; i < (*ses)->s_nstreams; i++ ) {
+	for (i = 0; i < (*ses)->s_nstreams; i++) {
 		/* the array of mediafiles is contiguous */
 		free ((*ses)->s_streams[i].st_mediafiles);
 	}
@@ -619,12 +619,12 @@ inv_lasttime_level_lessthan(
 	time32_t	**tm)
 {
 	int 	rval;
-	if ( tok != INV_TOKEN_NULL ) {
+	if (tok != INV_TOKEN_NULL) {
 		rval =  search_invt(fsidp, tok->d_invindex_fd, &level,
 				    (void **)tm,
 				    (search_callback_t)tm_level_lessthan);
 
-		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+		return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 	}
 
 	return invmgr_query_all_sessions(fsidp,		 /* fs uuid ptr */
@@ -652,12 +652,12 @@ inv_lastsession_level_lessthan(
 	inv_session_t	**ses)
 {
 	int 	rval;
-	if ( tok != INV_TOKEN_NULL ) {
+	if (tok != INV_TOKEN_NULL) {
 		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
 				   (void **)ses,
 				   (search_callback_t)lastsess_level_lessthan);
 
-		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+		return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 	}
 
 	return invmgr_query_all_sessions(fsidp,		 /* fs uuid */
@@ -684,15 +684,15 @@ inv_lastsession_level_equalto(
 	uuid_t		*fsidp,
 	inv_idbtoken_t	tok,
 	u_char		level,
-	inv_session_t	**ses )
+	inv_session_t	**ses)
 {
 	int 	rval;
-	if ( tok != INV_TOKEN_NULL ) {
+	if (tok != INV_TOKEN_NULL) {
 		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
 				   (void **)ses,
 				   (search_callback_t)lastsess_level_equalto);
 
-		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+		return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 	}
 
 	return invmgr_query_all_sessions(fsidp,		 /* fs uuid */
@@ -758,7 +758,7 @@ inv_get_session_bylabel(
 /*----------------------------------------------------------------------*/
 
 bool_t
-inv_delete_mediaobj( uuid_t *moid )
+inv_delete_mediaobj(uuid_t *moid)
 {
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
 
@@ -771,8 +771,8 @@ inv_delete_mediaobj( uuid_t *moid )
 		         forall mediafiles (m) in strm {
 			     if (m.mediaobj == moid) {
 			     // delete m
-			     if ( --strm.nmediafiles == 0 )
-			        if ( --s.nstreams == 0 )
+			     if (--strm.nmediafiles == 0)
+			        if (--s.nstreams == 0)
 			            delete-session (s)
 			     }
 			 }
@@ -786,40 +786,40 @@ inv_delete_mediaobj( uuid_t *moid )
 	int numfs, i, fd, invfd;
 	char fname[INV_STRLEN];
 
-	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-	if ( fd < 0 || numfs <= 0 ) {
-		mlog( MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n") );
+	fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+	if (fd < 0 || numfs <= 0) {
+		mlog(MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n"));
 		return BOOL_FALSE;
 	}
 
-	close( fd );
+	close(fd);
 
-	for ( i = 0; i < numfs; i++) {
-		if ( fstab_get_fname( &arr[i].ft_uuid,
+	for (i = 0; i < numfs; i++) {
+		if (fstab_get_fname(&arr[i].ft_uuid,
 				      fname,
 				      (inv_predicate_t)INV_BY_UUID,
 				      forwhat
 				     )
-		     < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
-			      "INV: Cant get inv-name for uuid\n") );
+		     < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
+			      "INV: Cant get inv-name for uuid\n"));
 			return BOOL_FALSE;
 		}
-		strcat( fname, INV_INVINDEX_PREFIX );
-		invfd = open( fname, INV_OFLAG(forwhat));
-		if ( invfd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+		strcat(fname, INV_INVINDEX_PREFIX);
+		invfd = open(fname, INV_OFLAG(forwhat));
+		if (invfd < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: Open failed on %s\n"),
-			     fname );
+			     fname);
 			return BOOL_FALSE;
 		}
 
 		if (search_invt(&arr[i].ft_uuid, invfd, NULL, (void **)&moid,
 				(search_callback_t)stobj_delete_mobj)
-		    < 0 )
+		    < 0)
 			return BOOL_FALSE;
 		/* we have to delete the session, etc */
-		close( invfd );
+		close(invfd);
 	}
 
 	return BOOL_TRUE;
@@ -899,8 +899,8 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		rptr = wptr + 1;
 		while (*wptr != '\0')
 			*wptr++ = *rptr++;
-		while ( ( c = getopt( argc, argv, invoptstring)) != EOF ) {
-			switch ( c ) {
+		while ((c = getopt(argc, argv, invoptstring)) != EOF) {
+			switch (c) {
 			case GETOPT_INVPRINT:
 				prctx->depth = 0;
 				rval |= I_IFOUND ;
@@ -912,8 +912,8 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		optarg = NULL;
 	}
 
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_INVPRINT:
 			rval |= I_IFOUND ;
 			if ((options = optarg) == NULL)
@@ -924,7 +924,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 				if (value == NULL && d != OPT_FSTAB &&
 				     d != OPT_INVIDX && d != OPT_INVCHECK)
 					continue;
-				switch( d ) {
+				switch(d) {
 					/* process mntpt option */
 				      case OPT_MNT:
 					bywhat = (inv_predicate_t) INV_BY_MOUNTPT;
@@ -950,14 +950,14 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 				      case OPT_DEPTH:
 					prctx->depth = atoi(value);
 					if (prctx->depth < 0 ||
-					    prctx->depth > 4 )
+					    prctx->depth > 4)
 						prctx->depth = 0;
 					break;
 
 				      case OPT_MOBJID:
 					{
 					uuid_t *u;
-					u = malloc ( sizeof( uuid_t ) );
+					u = malloc (sizeof(uuid_t));
 					uuid_parse(value, *u);
 					prctx->mobj.type = INVT_MOID;
 					prctx->mobj.value = (void *)u;
@@ -988,13 +988,13 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 					break;
 
 				      default:
-					if ( strlen(value) == 1 &&
-					     atoi(value) < PR_MAXDEPTH )
+					if (strlen(value) == 1 &&
+					     atoi(value) < PR_MAXDEPTH)
 						prctx->depth = atoi(value);
 					else {
-						mlog( MLOG_NORMAL | MLOG_INV, _(
+						mlog(MLOG_NORMAL | MLOG_INV, _(
 					       "INV: invalid sub-option %s"
-					       " for -I option\n"), value );
+					       " for -I option\n"), value);
 						rval |= I_IERR;
 					}
 					break;
@@ -1006,18 +1006,18 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 	}
 
 	if (npreds > 1) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
+		mlog(MLOG_NORMAL | MLOG_INV, _(
 		     "INV: Only one of mnt=,dev= and fsid=value can be used.\n")
 		     );
 		rval |= I_IERR;
 	}
 	else if (npreds2 > 1) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
+		mlog(MLOG_NORMAL | MLOG_INV, _(
 		     "INV: Only one of mobjid= and mobjlabel= can be used.\n")
 		     );
 		rval |= I_IERR;
 	}
-	else if ( (rval & I_IFOUND) && !(rval & I_IERR) && fs
+	else if ((rval & I_IFOUND) && !(rval & I_IERR) && fs
 		 && ! prctx->fstab && ! prctx->invcheck) {
 		inv_idbtoken_t tok;
 
@@ -1032,33 +1032,33 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 			invt_counter_t *cnt = NULL;
 			inv_oflag_t forwhat = INV_SEARCH_ONLY;
 
-			fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-			free( cnt );
+			fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+			free(cnt);
 
 			rval |= I_IERR; /* Cleared if successful */
 
-			if ( fd >= 0 ) {
-				for ( i = 0; i < numfs; i++ ) {
+			if (fd >= 0) {
+				for (i = 0; i < numfs; i++) {
 					tok = inv_open(
-						(inv_predicate_t )INV_BY_UUID,
+						(inv_predicate_t)INV_BY_UUID,
 						INV_SEARCH_ONLY,
-						&arr[i].ft_uuid );
-					if ( tok == INV_TOKEN_NULL )
+						&arr[i].ft_uuid);
+					if (tok == INV_TOKEN_NULL)
 						break;
-					if ( STREQL( arr[i].ft_mountpt, fs) ) {
+					if (STREQL(arr[i].ft_mountpt, fs)) {
 						prctx->index = i;
 						invmgr_inv_print(
 						          tok->d_invindex_fd,
-							  prctx );
+							  prctx);
 						rval &= ~(I_IERR);
 					}
-					inv_close( tok );
+					inv_close(tok);
 				}
-				free ( arr );
+				free (arr);
 				rval |= I_IDONE;
 			}
-			if ( (rval&I_IERR) ) {
-				mlog( MLOG_NORMAL | MLOG_INV, _(
+			if ((rval&I_IERR)) {
+				mlog(MLOG_NORMAL | MLOG_INV, _(
 				    "INV: open failed on mount point \"%s\"\n"),
 				     fs);
 			}
@@ -1066,14 +1066,14 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		}
 
 		/* We have to print only one file system to print by UUID */
-		tok = inv_open( bywhat, INV_SEARCH_ONLY, fs);
-		if ( tok != INV_TOKEN_NULL ) {
+		tok = inv_open(bywhat, INV_SEARCH_ONLY, fs);
+		if (tok != INV_TOKEN_NULL) {
 			prctx->index = 0;
 			invmgr_inv_print(tok->d_invindex_fd, prctx);
-			inv_close( tok );
+			inv_close(tok);
 			rval |= I_IDONE;
 		} else {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: open failed on file system id \"%s\"\n"),
 			     fs);
 			rval |= I_IERR;
@@ -1085,7 +1085,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 
 /* This prints out all the sessions of a filesystem that are in the inventory */
 bool_t
-inv_DEBUG_print( int argc, char **argv )
+inv_DEBUG_print(int argc, char **argv)
 {
 	invt_counter_t *cnt = NULL;
 	invt_fstab_t *arr = NULL;
@@ -1099,37 +1099,37 @@ inv_DEBUG_print( int argc, char **argv )
 	prctx.level = PR_MAXLEVEL;
 
 	/* If user didnt indicate -i option, we can't do anything */
-	rval = inv_getopt( argc, argv, &prctx );
+	rval = inv_getopt(argc, argv, &prctx);
 
 	if (!prctx.invcheck && ! prctx.fstab) {
 		if (! (rval & I_IFOUND)) {
 			return BOOL_TRUE;
-		} else if ( rval & I_IERR || rval & I_IDONE ) {
+		} else if (rval & I_IERR || rval & I_IDONE) {
 			return BOOL_FALSE;
 		}
 	}
 
-	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-	free( cnt );
+	fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+	free(cnt);
 
-	if ( fd >= 0 ) {
+	if (fd >= 0) {
 		 if (prctx.fstab) {
-			 fstab_DEBUG_print( arr, numfs );
+			 fstab_DEBUG_print(arr, numfs);
 			 if (! prctx.invidx)
 				 return BOOL_FALSE;
 		 }
 
-		for ( i = 0; i < numfs; i++ ) {
-			tok = inv_open( ( inv_predicate_t )INV_BY_UUID,
+		for (i = 0; i < numfs; i++) {
+			tok = inv_open((inv_predicate_t)INV_BY_UUID,
 					forwhat,
-				        &arr[i].ft_uuid );
-			if ( tok == INV_TOKEN_NULL ) {
-				free ( arr );
+				        &arr[i].ft_uuid);
+			if (tok == INV_TOKEN_NULL) {
+				free (arr);
 				return BOOL_FALSE;
 			}
 
 			if (prctx.invcheck) {
-				mlog( MLOG_VERBOSE | MLOG_INV, _(
+				mlog(MLOG_VERBOSE | MLOG_INV, _(
 				     "INV: checking fs \"%s\"\n"),
 				     &arr[i].ft_mountpt
 				     );
@@ -1137,10 +1137,10 @@ inv_DEBUG_print( int argc, char **argv )
 			}
 			else {
 				prctx.index = i;
-				invmgr_inv_print( tok->d_invindex_fd,
-						 &prctx );
+				invmgr_inv_print(tok->d_invindex_fd,
+						 &prctx);
 			}
-			inv_close( tok );
+			inv_close(tok);
 		}
 	}
 
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index f9866a5..d95d0c5 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -46,30 +46,30 @@
 /*----------------------------------------------------------------------*/
 
 int
-get_counters( int fd, void **cntpp, size_t cntsz )
+get_counters(int fd, void **cntpp, size_t cntsz)
 {
 	/* object must be locked at least SHARED by caller */
 	uint num;
-	assert( cntsz >= sizeof( invt_counter_t ) );
+	assert(cntsz >= sizeof(invt_counter_t));
 
-	*cntpp =  calloc( 1, cntsz);
+	*cntpp =  calloc(1, cntsz);
 
 	/* find the number of sessions and the max possible */
-	if ( GET_REC_NOLOCK( fd, (void *) *cntpp, cntsz, (off64_t) 0 ) < 0 ) {
-		free( *cntpp );
+	if (GET_REC_NOLOCK(fd, (void *) *cntpp, cntsz, (off64_t) 0) < 0) {
+		free(*cntpp);
 		*cntpp = NULL;
 		return -1;
 	}
 
 	num = ((invt_counter_t *)(*cntpp))->ic_curnum;
 
-	if ( ( (invt_counter_t *)(*cntpp))->ic_vernum != INV_VERSION ) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
+	if (((invt_counter_t *)(*cntpp))->ic_vernum != INV_VERSION) {
+		mlog(MLOG_NORMAL | MLOG_INV, _(
 		      "INV : Unknown version %d - Expected version %d\n"),
-		      (int) ( (invt_counter_t *)(*cntpp))->ic_vernum,
-		      (int) INV_VERSION );
-		assert ( ((invt_counter_t *)(*cntpp))->ic_vernum ==
-			INV_VERSION );
+		      (int) ((invt_counter_t *)(*cntpp))->ic_vernum,
+		      (int) INV_VERSION);
+		assert (((invt_counter_t *)(*cntpp))->ic_vernum ==
+			INV_VERSION);
 	}
 
 	return (int) num;
@@ -84,19 +84,19 @@ get_counters( int fd, void **cntpp, size_t cntsz )
 /*----------------------------------------------------------------------*/
 
 int
-get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
+get_headers(int fd, void **hdrs, size_t bufsz, size_t off)
 {
 
-	*hdrs = malloc( bufsz );
-	if ( *hdrs == NULL ) {
-		INV_PERROR( _("get_headers() - malloc(seshdrs)\n") );
+	*hdrs = malloc(bufsz);
+	if (*hdrs == NULL) {
+		INV_PERROR(_("get_headers() - malloc(seshdrs)\n"));
 		return -1;
 	}
 	/* file must be locked at least SHARED by caller */
 
 	/* get the array of hdrs */
-	if ( GET_REC_NOLOCK( fd, (void *) *hdrs, bufsz, (off64_t)off ) < 0 ) {
-		free ( *hdrs );
+	if (GET_REC_NOLOCK(fd, (void *) *hdrs, bufsz, (off64_t)off) < 0) {
+		free (*hdrs);
 		*hdrs = NULL;
 		return -1;
 	}
@@ -111,26 +111,26 @@ get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
 /*----------------------------------------------------------------------*/
 
 int
-get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
-		bool_t dolock )
+get_invtrecord(int fd, void *buf, size_t bufsz, off64_t off,
+		bool_t dolock)
 {
 	int  nread;
 
-	assert ( fd >= 0 );
+	assert (fd >= 0);
 
-	if ( dolock )
-		INVLOCK( fd, LOCK_SH );
+	if (dolock)
+		INVLOCK(fd, LOCK_SH);
 
 	nread = pread(fd, buf, bufsz, (off_t)off);
-	if (  nread != (int) bufsz ) {
-		INV_PERROR( _("Error in reading inventory record :") );
-		if ( dolock )
-			INVLOCK( fd, LOCK_UN );
+	if (nread != (int) bufsz) {
+		INV_PERROR(_("Error in reading inventory record :"));
+		if (dolock)
+			INVLOCK(fd, LOCK_UN);
 		return -1;
 	}
 
-	if ( dolock )
-		INVLOCK( fd, LOCK_UN );
+	if (dolock)
+		INVLOCK(fd, LOCK_UN);
 
 	return nread;
 }
@@ -145,23 +145,23 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
 /*----------------------------------------------------------------------*/
 
 int
-put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock )
+put_invtrecord(int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock)
 {
 	int nwritten;
 
-	if ( dolock )
-		INVLOCK( fd, LOCK_EX );
+	if (dolock)
+		INVLOCK(fd, LOCK_EX);
 
 	nwritten = pwrite(fd, buf, bufsz, (off_t)off);
-	if (nwritten != (int) bufsz ) {
-		INV_PERROR( _("Error in writing inventory record :") );
-		if ( dolock )
-			INVLOCK( fd, LOCK_UN );
+	if (nwritten != (int) bufsz) {
+		INV_PERROR(_("Error in writing inventory record :"));
+		if (dolock)
+			INVLOCK(fd, LOCK_UN);
 		return -1;
 	}
 
-	if ( dolock )
-		INVLOCK( fd, LOCK_UN );
+	if (dolock)
+		INVLOCK(fd, LOCK_UN);
 	return nwritten;
 }
 
@@ -177,25 +177,25 @@ put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock )
 
 
 int
-get_headerinfo( int fd, void **hdrs, void **cnt,
-	        size_t hdrsz, size_t cntsz, bool_t dolock )
+get_headerinfo(int fd, void **hdrs, void **cnt,
+	        size_t hdrsz, size_t cntsz, bool_t dolock)
 {
 	int num;
 
 	/* get a lock on the table for reading */
-	if ( dolock ) INVLOCK( fd, LOCK_SH );
+	if (dolock) INVLOCK(fd, LOCK_SH);
 
-	num = get_counters( fd, cnt, cntsz );
+	num = get_counters(fd, cnt, cntsz);
 
 	/* If there are no sessions recorded yet, we're done too */
-	if ( num > 0 ) {
-		if ( get_headers( fd, hdrs, hdrsz * (size_t)num, cntsz ) < 0 ) {
-			free ( *cnt );
+	if (num > 0) {
+		if (get_headers(fd, hdrs, hdrsz * (size_t)num, cntsz) < 0) {
+			free (*cnt);
 			num = -1;
 		}
 	}
 
-	if ( dolock ) INVLOCK( fd, LOCK_UN );
+	if (dolock) INVLOCK(fd, LOCK_UN);
 	return num;
 }
 
@@ -206,25 +206,25 @@ get_headerinfo( int fd, void **hdrs, void **cnt,
 /*----------------------------------------------------------------------*/
 
 int
-get_lastheader( int fd, void **ent, size_t hdrsz, size_t cntsz )
+get_lastheader(int fd, void **ent, size_t hdrsz, size_t cntsz)
 {
 	int	     	 nindices;
 	void	 	 *arr = NULL;
 	invt_counter_t	 *cnt = NULL;
 	char 		 *pos;
 	/* get the entries in the inv_index */
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( fd, &arr, (void **)&cnt,
-					 hdrsz, cntsz )) <= 0 ) {
+	if ((nindices = GET_ALLHDRS_N_CNTS(fd, &arr, (void **)&cnt,
+					 hdrsz, cntsz)) <= 0) {
 		return -1;
 	}
 
 	/* if there's space anywhere at all, then it must be in the last
 	   entry */
-	*ent = malloc( hdrsz );
-	pos = (char *) arr + ( (uint)nindices - 1 ) * hdrsz;
-	memcpy( *ent, pos, hdrsz );
-	free ( arr );
-	free ( cnt );
+	*ent = malloc(hdrsz);
+	pos = (char *) arr + ((uint)nindices - 1) * hdrsz;
+	memcpy(*ent, pos, hdrsz);
+	free (arr);
+	free (cnt);
 
 	return nindices;
 }
diff --git a/inventory/inv_files.c b/inventory/inv_files.c
index 46f6b8f..ae4642d 100644
--- a/inventory/inv_files.c
+++ b/inventory/inv_files.c
@@ -49,35 +49,35 @@ static char inv_dirpathp[MGR_PATH_MAX];
 static char inv_lockfilep[MGR_PATH_MAX];
 
 char *
-inv_dirpath( void )
+inv_dirpath(void)
 {
 	assert(inv_base);
 	return inv_dirpathp;
 }
 
 char *
-inv_fstab( void )
+inv_fstab(void)
 {
 	assert(inv_base);
 	return inv_fstabp;
 }
 
 char *
-inv_lockfile( void )
+inv_lockfile(void)
 {
 	assert(inv_base);
 	return inv_lockfilep;
 }
 
 char *
-inv_basepath( void )
+inv_basepath(void)
 {
 	assert(inv_base);
 	return inv_base;
 }
 
 int
-inv_setup_base( void )
+inv_setup_base(void)
 {
 	struct stat64 new_sbuf, old_sbuf;
 	int new_exists, old_exists;
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 5f7e734..bc56f30 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -49,28 +49,28 @@
 
 
 int
-fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
-	      inv_oflag_t forwhat )
+fstab_getall(invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
+	      inv_oflag_t forwhat)
 {
 	int fd;
 
-	fd = open ( INV_FSTAB, INV_OFLAG(forwhat) );
+	fd = open (INV_FSTAB, INV_OFLAG(forwhat));
 
-	if ( fd < 0 )
+	if (fd < 0)
 		return -1; /* if ENOENT, fstab_put_entry will CREAT */
 
-	INVLOCK( fd, LOCK_EX );
-	if (( *numfs = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void**) arr,
+	INVLOCK(fd, LOCK_EX);
+	if ((*numfs = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void**) arr,
 						 (void **)cnt,
-						 sizeof( invt_fstab_t ),
-						 sizeof( invt_counter_t ) )
-	     ) < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_INV, _(
-			"INV: couldn't get fstab headers\n") );
+						 sizeof(invt_fstab_t),
+						 sizeof(invt_counter_t))
+	     ) < 0) {
+		mlog(MLOG_NORMAL | MLOG_INV, _(
+			"INV: couldn't get fstab headers\n"));
 	}
 #ifdef INVT_DEBUG
-	mlog( MLOG_NITTY | MLOG_INV, "INV: number of filesystems in fstab %d\n",
-	      *numfs );
+	mlog(MLOG_NITTY | MLOG_INV, "INV: number of filesystems in fstab %d\n",
+	      *numfs);
 #endif
 	/* fstab is left locked EX on exit. The caller takes does
 	   the unlocking */
@@ -88,53 +88,53 @@ fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 
 
 int
-fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
+fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 {
 	int numfs, i, fd;
 	invt_counter_t *cnt;
 	invt_fstab_t *arr;
 	int rval = 1;
 
-	assert( forwhat != INV_SEARCH_ONLY );
+	assert(forwhat != INV_SEARCH_ONLY);
 
 	/* fd is locked on succesful return */
-	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-	if ( fd < 0 ) {
-		if ( errno != ENOENT ) {
+	fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+	if (fd < 0) {
+		if (errno != ENOENT) {
 			return -1;
 		}
-		if ((fd = open( INV_FSTAB, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR ))
-		    < 0 ) {
-			INV_PERROR ( INV_FSTAB );
+		if ((fd = open(INV_FSTAB, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR))
+		    < 0) {
+			INV_PERROR (INV_FSTAB);
 			return -1;
 		}
 
-		INVLOCK( fd, LOCK_EX );
-		fchmod( fd, INV_PERMS );
+		INVLOCK(fd, LOCK_EX);
+		fchmod(fd, INV_PERMS);
 
-		cnt = (invt_counter_t *) malloc( sizeof ( invt_counter_t ) );
+		cnt = (invt_counter_t *) malloc(sizeof (invt_counter_t));
 
 		cnt->ic_maxnum = -1;
 		cnt->ic_curnum = 0;
 		cnt->ic_vernum = INV_VERSION;
 
-	} else if ( numfs > 0 ) {
+	} else if (numfs > 0) {
 
 		for (i = 0; i < numfs; i++) {
-		    if ( uuid_compare( *fsidp, arr[ i ].ft_uuid ) == 0 ) {
+		    if (uuid_compare(*fsidp, arr[i].ft_uuid) == 0) {
 
-/*			if ( ( STREQL( arr[i].ft_mountpt, mntpt ) ) &&
-			    ( STREQL( arr[i].ft_devpath, dev ) ) )
+/*			if ((STREQL(arr[i].ft_mountpt, mntpt)) &&
+			    (STREQL(arr[i].ft_devpath, dev)))
 */
-				free ( arr );
-				free ( cnt );
-				close( fd );
+				free (arr);
+				free (cnt);
+				close(fd);
 				return 1;
 
 		}
 	    }
 	    /* entry not found. just follow thru to create a new one */
-	    free ( arr );
+	    free (arr);
 	}
 
 	/* make a new fstab entry and insert it at the end. the table
@@ -143,29 +143,29 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 		invt_fstab_t ent;
 		off64_t hoff;
 
-		memcpy( &ent.ft_uuid, fsidp, sizeof( uuid_t ) );
-		strcpy( ent.ft_mountpt, mntpt );
-		strcpy( ent.ft_devpath, dev );
+		memcpy(&ent.ft_uuid, fsidp, sizeof(uuid_t));
+		strcpy(ent.ft_mountpt, mntpt);
+		strcpy(ent.ft_devpath, dev);
 
 		/* increase the number of entries first */
 #ifdef INVT_DEBUG
-		mlog( MLOG_NITTY | MLOG_INV,"INV: putting new fstab entry for %s ....\n",
+		mlog(MLOG_NITTY | MLOG_INV,"INV: putting new fstab entry for %s ....\n",
 		      mntpt);
 #endif
 		cnt->ic_curnum++;
-		hoff = (off64_t) ( sizeof( invt_counter_t ) +
-				 (size_t)( cnt->ic_curnum - 1 ) *
-				           sizeof( invt_fstab_t ) );
+		hoff = (off64_t) (sizeof(invt_counter_t) +
+				 (size_t)(cnt->ic_curnum - 1) *
+				           sizeof(invt_fstab_t));
 
-		rval = PUT_COUNTERS( fd, cnt );
-		if ( rval > 0 ) {
-		      rval = PUT_REC_NOLOCK( fd, &ent, sizeof( ent ), hoff );
+		rval = PUT_COUNTERS(fd, cnt);
+		if (rval > 0) {
+		      rval = PUT_REC_NOLOCK(fd, &ent, sizeof(ent), hoff);
 		}
 
 	}
-	INVLOCK( fd, LOCK_UN );
-	free ( cnt );
-	close ( fd );
+	INVLOCK(fd, LOCK_UN);
+	free (cnt);
+	close (fd);
 	return rval;
 }
 
@@ -174,7 +174,7 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 
 
 int
-fstab_get_fname( void *pred,
+fstab_get_fname(void *pred,
 		 char *fname,
 		 inv_predicate_t bywhat,
 		 inv_oflag_t forwhat)
@@ -189,34 +189,34 @@ fstab_get_fname( void *pred,
 		invt_counter_t *cnt;
 
 		/* on sucessful return fd is locked */
-		fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
-		if ( fd < 0 )
+		fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
+		if (fd < 0)
 			return -1;
-		if ( numfs <= 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+		if (numfs <= 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			      "INV: No recorded filesystems in"
-			      " inventory's fstab.\n") );
+			      " inventory's fstab.\n"));
 			return -1;
 		}
-		INVLOCK( fd, LOCK_UN );
-		close ( fd );
-		free ( cnt ); /* we dont need it */
+		INVLOCK(fd, LOCK_UN);
+		close (fd);
+		free (cnt); /* we dont need it */
 
 		/* first get hold of the uuid for this mount point/device */
 
 		for (i = 0; i < numfs; i++) {
-			if ( ( bywhat == INV_BY_MOUNTPT &&
-			     ( STREQL( arr[i].ft_mountpt, pred ) )) ||
-			     ( bywhat == INV_BY_DEVPATH &&
-			     ( STREQL( arr[i].ft_devpath, pred ) )) ) {
+			if ((bywhat == INV_BY_MOUNTPT &&
+			     (STREQL(arr[i].ft_mountpt, pred))) ||
+			     (bywhat == INV_BY_DEVPATH &&
+			     (STREQL(arr[i].ft_devpath, pred)))) {
 
 				uuidp = &arr[i].ft_uuid;
 				break;
 			}
 		}
 #ifdef INVT_DEBUG
-		if (! uuidp )
-			mlog( MLOG_DEBUG | MLOG_INV,"INV: get_fname: unable to find %s"
+		if (! uuidp)
+			mlog(MLOG_DEBUG | MLOG_INV,"INV: get_fname: unable to find %s"
 			      " in the inventory\n", (char *)pred);
 #endif
 
@@ -224,35 +224,35 @@ fstab_get_fname( void *pred,
 		uuidp = (uuid_t *)pred;
 	}
 
-	if (! uuidp )
+	if (! uuidp)
 		return -1;
 
-	uuid_unparse( *uuidp, uuidstr );
+	uuid_unparse(*uuidp, uuidstr);
 
-	strncpy ( fname, INV_DIRPATH, INV_STRLEN );
-	strcat ( fname, "/" );
-	strcat ( fname, uuidstr);
+	strncpy (fname, INV_DIRPATH, INV_STRLEN);
+	strcat (fname, "/");
+	strcat (fname, uuidstr);
 
-	if ( bywhat != INV_BY_UUID )
-		free ( arr );
+	if (bywhat != INV_BY_UUID)
+		free (arr);
 
-	assert( (int) strlen( fname ) < INV_STRLEN );
+	assert((int) strlen(fname) < INV_STRLEN);
 	return 1;
 }
 
 
 void
-fstab_DEBUG_print( invt_fstab_t *arr, int num )
+fstab_DEBUG_print(invt_fstab_t *arr, int num)
 {
 	int i;
 	char str[UUID_STR_LEN + 1];
 
-	mlog( MLOG_NORMAL | MLOG_INV, _("\n\n--------- fstab ------------\n") );
-	for ( i = 0; i < num; i++ ) {
-		printf( _("Mount\t%s\n"), arr[i].ft_mountpt );
-		printf( _("Dev\t%s\n"), arr[i].ft_devpath );
-		uuid_unparse( arr[i].ft_uuid, str );
-		printf( _("FSid\t%s\n\n"), str );
+	mlog(MLOG_NORMAL | MLOG_INV, _("\n\n--------- fstab ------------\n"));
+	for (i = 0; i < num; i++) {
+		printf(_("Mount\t%s\n"), arr[i].ft_mountpt);
+		printf(_("Dev\t%s\n"), arr[i].ft_devpath);
+		uuid_unparse(arr[i].ft_uuid, str);
+		printf(_("FSid\t%s\n\n"), str);
 	}
-	mlog( MLOG_NORMAL | MLOG_INV, "\n---------========------------\n" );
+	mlog(MLOG_NORMAL | MLOG_INV, "\n---------========------------\n");
 }
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index b33983d..7f50a2b 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -44,10 +44,10 @@
 /* into.                                                                */
 /*----------------------------------------------------------------------*/
 uint
-idx_insert_newentry( int fd, /* kept locked EX by caller */
+idx_insert_newentry(int fd, /* kept locked EX by caller */
 		     int *stobjfd, /* OUT */
 		     invt_entry_t *iarr, invt_counter_t *icnt,
-		     time32_t tm )
+		     time32_t tm)
 {
 	uint i;
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
@@ -56,42 +56,42 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 
 	/* If time period of the new entry is before our first invindex,
 	   we have to insert a new invindex in the first slot */
-	if ( iarr[0].ie_timeperiod.tp_start > tm ) {
-		/* *stobjfd = idx_put_newentry( fd, 0, iarr, icnt, &ient );*/
-		*stobjfd = open( iarr[0].ie_filename, INV_OFLAG(forwhat) );
+	if (iarr[0].ie_timeperiod.tp_start > tm) {
+		/* *stobjfd = idx_put_newentry(fd, 0, iarr, icnt, &ient);*/
+		*stobjfd = open(iarr[0].ie_filename, INV_OFLAG(forwhat));
 		return 0;
 	}
 
-	for ( i = 0; i < icnt->ic_curnum; i++ ) {
+	for (i = 0; i < icnt->ic_curnum; i++) {
 		/* if our time is nicely within an existing entry's time
 		   period, hellalujah */
-		if ( IS_WITHIN( &iarr[i].ie_timeperiod, tm ) ) {
+		if (IS_WITHIN(&iarr[i].ie_timeperiod, tm)) {
 #ifdef INVT_DEBUG
-			mlog( MLOG_DEBUG | MLOG_INV, "INV: is_within %d\n",i );
+			mlog(MLOG_DEBUG | MLOG_INV, "INV: is_within %d\n",i);
 #endif
-			*stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
+			*stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			return i;
 		}
-		if ( iarr[i].ie_timeperiod.tp_end == 0  &&
-		     iarr[i].ie_timeperiod.tp_start  == 0 ) {
+		if (iarr[i].ie_timeperiod.tp_end == 0  &&
+		     iarr[i].ie_timeperiod.tp_start  == 0) {
 #ifdef INVT_DEBUG
-			mlog( MLOG_DEBUG | MLOG_INV, "INV: end = start \n" );
-			mlog( MLOG_DEBUG | MLOG_INV,"BEF: st %ld end %ld\n",
+			mlog(MLOG_DEBUG | MLOG_INV, "INV: end = start \n");
+			mlog(MLOG_DEBUG | MLOG_INV,"BEF: st %ld end %ld\n",
 			     iarr[i].ie_timeperiod.tp_start,
-			     iarr[i].ie_timeperiod.tp_end );
+			     iarr[i].ie_timeperiod.tp_end);
 #endif
 
 			iarr[i].ie_timeperiod.tp_start =
 				iarr[i].ie_timeperiod.tp_end = tm;
-			PUT_REC_NOLOCK( fd, iarr,
+			PUT_REC_NOLOCK(fd, iarr,
 				       icnt->ic_curnum * sizeof(invt_entry_t),
-				       (off64_t) sizeof( invt_counter_t ) );
+				       (off64_t) sizeof(invt_counter_t));
 #ifdef INVT_DEBUG
-			mlog( MLOG_DEBUG | MLOG_INV,"AFT: st %ld end %ld\n",
+			mlog(MLOG_DEBUG | MLOG_INV,"AFT: st %ld end %ld\n",
 			     iarr[i].ie_timeperiod.tp_start,
-			     iarr[i].ie_timeperiod.tp_end );
+			     iarr[i].ie_timeperiod.tp_end);
 #endif
-			*stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
+			*stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			return i;
 		}
 
@@ -99,9 +99,9 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 
 		/* if it is beyond the end of this timeperiod, see if we
 		   belong to a timeperiod that doesn't have an entry */
-		if ( iarr[i].ie_timeperiod.tp_end < tm ) {
+		if (iarr[i].ie_timeperiod.tp_end < tm) {
 			/* see if we're the last entry here */
-			if ( i == icnt->ic_curnum - 1 ) {
+			if (i == icnt->ic_curnum - 1) {
 				/* our slot is (i+1)th entry. Make the
 				   timeperiod's the same as it was. As far
 				   as I can see there is no way that
@@ -109,13 +109,13 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 
 				   insert the new entry and write back
 				   icnt and invindex entry */
-				/* *stobjfd = idx_put_newentry( fd, i+1, iarr,
-							     icnt, &ient );*/
-			      *stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
+				/* *stobjfd = idx_put_newentry(fd, i+1, iarr,
+							     icnt, &ient);*/
+			      *stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			      return i;
 			}
 			/* see if the next entry starts later than us */
-			if ( iarr[i+1].ie_timeperiod.tp_start > tm ) {
+			if (iarr[i+1].ie_timeperiod.tp_start > tm) {
 
 
 				/* We have the option of pushing entries
@@ -125,22 +125,22 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 				   We choose the former. */
 
 				/* the timeperiods had better not overlap */
-				assert(( tm > iarr[i].ie_timeperiod.tp_end ) &&
-				       ( tm < iarr[i+1].ie_timeperiod.tp_start ));
+				assert((tm > iarr[i].ie_timeperiod.tp_end) &&
+				       (tm < iarr[i+1].ie_timeperiod.tp_start));
 
 				/* shift everything from (i+1) onwards by
 				   one. Then insert the new entry and write
 				   back icnt and invindex entries */
-				/* *stobjfd = idx_put_newentry( fd, i+1, iarr,
-							     icnt, &ient );*/
-			      *stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
+				/* *stobjfd = idx_put_newentry(fd, i+1, iarr,
+							     icnt, &ient);*/
+			      *stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 				return i;
 			}
 		}
 	}
 
 	/* We couldnt find anything that fits */
-	assert( 0 );	/* We can't get here ! */
+	assert(0);	/* We can't get here ! */
 	return -1;
 
 
@@ -156,7 +156,7 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 int
 idx_put_newentry(
 	invt_idxinfo_t *idx,
-	invt_entry_t *ient )
+	invt_entry_t *ient)
 {
 	invt_entry_t	*idxarr;
 	int stobjfd;
@@ -166,37 +166,37 @@ idx_put_newentry(
 	invt_entry_t *iarr = idx->iarr;
 	invt_counter_t *icnt = idx->icnt;
 
-	stobj_makefname( ient->ie_filename );
-	if ( ( stobjfd = stobj_create( ient->ie_filename ) ) < 0 )
+	stobj_makefname(ient->ie_filename);
+	if ((stobjfd = stobj_create(ient->ie_filename)) < 0)
 		return -1;
 
 	icnt->ic_curnum++; /* there is no maximum */
 
-	idxarr = ( invt_entry_t * ) calloc ( icnt->ic_curnum,
-					     sizeof( invt_entry_t ) );
-	memcpy( idxarr, iarr, ( size_t ) ( sizeof( invt_entry_t ) * index ) );
+	idxarr = (invt_entry_t *) calloc (icnt->ic_curnum,
+					     sizeof(invt_entry_t));
+	memcpy(idxarr, iarr, (size_t) (sizeof(invt_entry_t) * index));
 
 	/* shift everything from (i+1) onwards by one */
-	if ( index <  icnt->ic_curnum - 1 )
-		memcpy( &idxarr[ index + 1 ], &iarr[ index ],
-		       ( size_t ) ( ( icnt->ic_curnum - index - 1 ) *
-				    sizeof( invt_entry_t ) ) );
+	if (index <  icnt->ic_curnum - 1)
+		memcpy(&idxarr[index + 1], &iarr[index],
+		       (size_t) ((icnt->ic_curnum - index - 1) *
+				    sizeof(invt_entry_t)));
 	/* insert the new entry */
-	memcpy( &idxarr[ index ], ient, sizeof( invt_entry_t ) );
+	memcpy(&idxarr[index], ient, sizeof(invt_entry_t));
 
 
-	if ( ( PUT_COUNTERS( fd, icnt ) < 0 ) ||
-		( PUT_REC_NOLOCK( fd, idxarr,
-				  icnt->ic_curnum * sizeof( invt_entry_t ),
-				  sizeof( invt_counter_t ) ) < 0 ) ) {
+	if ((PUT_COUNTERS(fd, icnt) < 0) ||
+		(PUT_REC_NOLOCK(fd, idxarr,
+				  icnt->ic_curnum * sizeof(invt_entry_t),
+				  sizeof(invt_counter_t)) < 0)) {
 			/* XXX delete the stobj that we just created */
 
-			memset( ient->ie_filename, 0 , INV_STRLEN );
-			free( idxarr );
+			memset(ient->ie_filename, 0 , INV_STRLEN);
+			free(idxarr);
 			return -1;
 		}
 
-	free( iarr );
+	free(iarr);
 	idx->iarr = idxarr;
 	return stobjfd;
 
@@ -213,8 +213,8 @@ idx_put_newentry(
 
 
 int
-idx_find_stobj( invt_idxinfo_t *idx,
-	        time32_t tm )
+idx_find_stobj(invt_idxinfo_t *idx,
+	        time32_t tm)
 {
 
 	int 		stobjfd;
@@ -222,22 +222,22 @@ idx_find_stobj( invt_idxinfo_t *idx,
 	/* since sessions can be inserted in random order, the invindex
 	   table can contain time-periods that don't have corresponding
 	   entries for */
-	if ( GET_ALLHDRS_N_CNTS_NOLOCK( idx->invfd, (void **)&idx->iarr,
+	if (GET_ALLHDRS_N_CNTS_NOLOCK(idx->invfd, (void **)&idx->iarr,
 						     (void **)&idx->icnt,
-						     sizeof( invt_entry_t ),
-				sizeof( invt_counter_t ) ) < 0 ) {
+						     sizeof(invt_entry_t),
+				sizeof(invt_counter_t)) < 0) {
 		return -1;
 	}
 
 #ifdef INVT_DEBUG
-	printf( "idx_find_stobj Time: %ld\n", tm );
-	idx_DEBUG_printinvindices( idx->iarr, idx->icnt->ic_curnum );
+	printf("idx_find_stobj Time: %ld\n", tm);
+	idx_DEBUG_printinvindices(idx->iarr, idx->icnt->ic_curnum);
 #endif
 
 	/* Now figure out where we are going to insert this stobj among the
 	   invindices and put it there */
-	idx->index = idx_insert_newentry( idx->invfd, &stobjfd, idx->iarr,
-						 idx->icnt, tm );
+	idx->index = idx_insert_newentry(idx->invfd, &stobjfd, idx->iarr,
+						 idx->icnt, tm);
 
 	return stobjfd;
 }
@@ -254,33 +254,33 @@ idx_find_stobj( invt_idxinfo_t *idx,
 /*----------------------------------------------------------------------*/
 
 inv_idbtoken_t
-idx_create( char *fname, inv_oflag_t forwhat )
+idx_create(char *fname, inv_oflag_t forwhat)
 {
 	int stobjfd, fd;
 	inv_idbtoken_t tok;
 
 	/* This is not to be called when the user wants to open
 	   the db for SEARCH_ONLY. */
-	assert( forwhat != INV_SEARCH_ONLY );
+	assert(forwhat != INV_SEARCH_ONLY);
 
-	if ((fd = open ( fname , INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR ) ) < 0 ) {
-		INV_PERROR ( fname );
+	if ((fd = open (fname , INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+		INV_PERROR (fname);
 		return INV_TOKEN_NULL;
 	}
 
-	INVLOCK( fd, LOCK_EX );
-	fchmod( fd, INV_PERMS );
+	INVLOCK(fd, LOCK_EX);
+	fchmod(fd, INV_PERMS);
 
 #ifdef INVT_DEBUG
-	mlog( MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
+	mlog(MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
 #endif
 
 	/* create the first entry in the new inv_index */
-	stobjfd = idx_create_entry( &tok, fd, BOOL_TRUE );
+	stobjfd = idx_create_entry(&tok, fd, BOOL_TRUE);
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
-	if ( stobjfd < 0 )
+	if (stobjfd < 0)
 		return INV_TOKEN_NULL;
 	return tok;
 }
@@ -292,18 +292,18 @@ idx_create( char *fname, inv_oflag_t forwhat )
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 int
-idx_recons_time( time32_t tm, invt_idxinfo_t *idx )
+idx_recons_time(time32_t tm, invt_idxinfo_t *idx)
 {
 	invt_timeperiod_t *tp = &idx->iarr[idx->index].ie_timeperiod;
-	if ( tp->tp_start && IS_WITHIN( tp, tm ) )
+	if (tp->tp_start && IS_WITHIN(tp, tm))
 		return 1;
 
-	if ( tm > tp->tp_end || tp->tp_end == 0 )
+	if (tm > tp->tp_end || tp->tp_end == 0)
 		tp->tp_end =  tm;
-	if ( tm < tp->tp_start || tp->tp_start == 0 )
+	if (tm < tp->tp_start || tp->tp_start == 0)
 		tp->tp_start = tm;
-	PUT_REC_NOLOCK( idx->invfd,  &idx->iarr[idx->index],
-		        sizeof( invt_entry_t ), IDX_HDR_OFFSET(idx->index) );
+	PUT_REC_NOLOCK(idx->invfd,  &idx->iarr[idx->index],
+		        sizeof(invt_entry_t), IDX_HDR_OFFSET(idx->index));
 	return 1;
 }
 
@@ -317,29 +317,29 @@ idx_recons_time( time32_t tm, invt_idxinfo_t *idx )
 /*----------------------------------------------------------------------*/
 
 int
-idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
+idx_put_sesstime(inv_sestoken_t tok, bool_t whichtime)
 {
 	int rval;
 	invt_entry_t ent;
 	int fd = tok->sd_invtok->d_invindex_fd;
 
-	INVLOCK( fd, LOCK_EX );
+	INVLOCK(fd, LOCK_EX);
 
-	rval = GET_REC_NOLOCK( fd, &ent, sizeof( invt_entry_t ),
+	rval = GET_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
 			        tok->sd_invtok->d_invindex_off);
-	if ( rval < 0 ) {
-		INVLOCK( fd, LOCK_UN );
+	if (rval < 0) {
+		INVLOCK(fd, LOCK_UN);
 		return -1;
 	}
 	ent.ie_timeperiod.tp_end = tok->sd_sesstime;
 
-	if ( whichtime == INVT_STARTTIME || ent.ie_timeperiod.tp_start == 0 ) {
+	if (whichtime == INVT_STARTTIME || ent.ie_timeperiod.tp_start == 0) {
 		ent.ie_timeperiod.tp_start = tok->sd_sesstime;
 	}
 #ifdef INVT_DEBUG
-	mlog( MLOG_DEBUG | MLOG_INV,"Putsestime: st %ld end %ld\n",
+	mlog(MLOG_DEBUG | MLOG_INV,"Putsestime: st %ld end %ld\n",
 			      ent.ie_timeperiod.tp_start,
-			      ent.ie_timeperiod.tp_end );
+			      ent.ie_timeperiod.tp_end);
 #endif
 	rval = PUT_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
 			      tok->sd_invtok->d_invindex_off);
@@ -349,20 +349,20 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 		int nindices;
 		invt_entry_t *iarr = NULL;
 		invt_counter_t *icnt = NULL;
-		if ( ( nindices = GET_ALLHDRS_N_CNTS_NOLOCK( fd,
+		if ((nindices = GET_ALLHDRS_N_CNTS_NOLOCK(fd,
 						     (void **)&iarr,
 						     (void **)&icnt,
-						sizeof( invt_entry_t ),
-				sizeof( invt_counter_t ))) < 0 ) {
+						sizeof(invt_entry_t),
+				sizeof(invt_counter_t))) < 0) {
 			return -1;
 		}
-		idx_DEBUG_printinvindices( iarr, (uint) nindices );
-		free( iarr );
-		free( icnt );
+		idx_DEBUG_printinvindices(iarr, (uint) nindices);
+		free(iarr);
+		free(icnt);
 	}
 #endif
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 	return rval;
 }
 
@@ -384,42 +384,42 @@ int
 idx_create_entry(
 	inv_idbtoken_t *tok,
 	int invfd, 	/* kept locked EX  by caller */
-	bool_t firstentry )
+	bool_t firstentry)
 {
 	invt_entry_t   	ent;
 	int	      	fd;
 	off64_t 	hoff;
 
 
-	memset ( &ent, 0, sizeof( ent ) );
+	memset (&ent, 0, sizeof(ent));
 
 	/* initialize the start and end times to be the same */
 	ent.ie_timeperiod.tp_start = ent.ie_timeperiod.tp_end = (time32_t)0;
-	stobj_makefname( ent.ie_filename );
+	stobj_makefname(ent.ie_filename);
 
-	if ( firstentry ) {
+	if (firstentry) {
 		invt_counter_t cnt;
 
 		cnt.ic_maxnum = INVT_MAX_INVINDICES;
 		cnt.ic_curnum = 1;
 		cnt.ic_vernum = INV_VERSION;
 
-		fd = stobj_create( ent.ie_filename );
-		if ( fd < 0 ) {
+		fd = stobj_create(ent.ie_filename);
+		if (fd < 0) {
 			return -1;
 		}
 
-		if ( PUT_REC_NOLOCK( invfd, &cnt, sizeof(cnt), (off64_t)0 ) < 0 )
+		if (PUT_REC_NOLOCK(invfd, &cnt, sizeof(cnt), (off64_t)0) < 0)
 			return -1;
 
-		hoff = sizeof( invt_counter_t );
+		hoff = sizeof(invt_counter_t);
 
-		if ( PUT_REC_NOLOCK( invfd, &ent, sizeof( ent ), hoff ) < 0)
+		if (PUT_REC_NOLOCK(invfd, &ent, sizeof(ent), hoff) < 0)
 			return -1;
 	} else {
 		invt_counter_t *cnt = NULL;
 
-		if ( GET_COUNTERS( invfd, &cnt )  < 0 ) {
+		if (GET_COUNTERS(invfd, &cnt)  < 0) {
 			return -1;
 		}
 
@@ -427,29 +427,29 @@ idx_create_entry(
 		   another and leave a pointer to that in here */
 
 		/* create the new storage object */
-		fd = stobj_create( ent.ie_filename );
-		if ( fd < 0 ) {
+		fd = stobj_create(ent.ie_filename);
+		if (fd < 0) {
 			return -1;
 		}
 		++(cnt->ic_curnum);
-		if ( PUT_COUNTERS( invfd, cnt ) < 0 ) {
+		if (PUT_COUNTERS(invfd, cnt) < 0) {
 			return -1;
 		}
 
 		/* add the new index entry to the array, at the end */
 
-		hoff = IDX_HDR_OFFSET( cnt->ic_curnum - 1 );
+		hoff = IDX_HDR_OFFSET(cnt->ic_curnum - 1);
 		free (cnt);
 #ifdef INVT_DEBUG
-		mlog( MLOG_NITTY | MLOG_INV, "new stobj name %s @ offset %d\n",
-		      ent.ie_filename,(int)hoff );
+		mlog(MLOG_NITTY | MLOG_INV, "new stobj name %s @ offset %d\n",
+		      ent.ie_filename,(int)hoff);
 #endif
-		if (PUT_REC_NOLOCK( invfd, &ent, sizeof( ent ), hoff) < 0 )
+		if (PUT_REC_NOLOCK(invfd, &ent, sizeof(ent), hoff) < 0)
 			return -1;
 
 	}
 
-	*tok = get_token( invfd, fd );
+	*tok = get_token(invfd, fd);
 	(*tok)->d_invindex_off = hoff;
 	(*tok)->d_update_flag |= NEW_INVINDEX;
 	(*tok)->d_oflag = INV_SEARCH_N_MOD;
@@ -469,7 +469,7 @@ idx_create_entry(
 /*----------------------------------------------------------------------*/
 
 int
-idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index )
+idx_get_stobj(int invfd, inv_oflag_t forwhat, int *index)
 {
 	invt_entry_t 	*ent = 0;
 	int	     	 fd;
@@ -477,65 +477,65 @@ idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index )
 	/* if there's space anywhere at all, then it must be in the last
 	   entry. get_lastheader() does the locking */
 
-	if ((*index = get_lastheader( invfd, (void **)&ent,
+	if ((*index = get_lastheader(invfd, (void **)&ent,
 				       sizeof(invt_entry_t),
-				       sizeof(invt_counter_t) ) ) < 0 )
+				       sizeof(invt_counter_t))) < 0)
 		return -1;
 	/* at this point we know that there should be at least one invindex
 	   entry present */
-	assert ( ent != NULL );
-	assert ( ent->ie_filename );
+	assert (ent != NULL);
+	assert (ent->ie_filename);
 
-	fd = open( ent->ie_filename, INV_OFLAG(forwhat) );
-	if ( fd < 0 )
-		INV_PERROR( ent->ie_filename );
-	free ( ent );
+	fd = open(ent->ie_filename, INV_OFLAG(forwhat));
+	if (fd < 0)
+		INV_PERROR(ent->ie_filename);
+	free (ent);
 
 	return fd;
 }
 
 
 int
-idx_DEBUG_printinvindices( invt_entry_t *iarr, uint num )
+idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num)
 {
 	uint i;
 	uint k;
 
 	char s[9];
-	printf( "\n ==================================\n"
-	        " InvIndex\n # StObjs\t%d\n", num );
+	printf("\n ==================================\n"
+	        " InvIndex\n # StObjs\t%d\n", num);
 #define INV_UUID_STR_LEN	36 /* not exported via uuid.h */
-	for ( i = 0; i < num; i++ ) {
-		k = strlen( iarr[i].ie_filename );
-		strncpy( s, (char *) iarr[i].ie_filename + k -
-			( INV_UUID_STR_LEN + strlen(INV_STOBJ_PREFIX)), 8 );
+	for (i = 0; i < num; i++) {
+		k = strlen(iarr[i].ie_filename);
+		strncpy(s, (char *) iarr[i].ie_filename + k -
+			(INV_UUID_STR_LEN + strlen(INV_STOBJ_PREFIX)), 8);
 		s[8]= 0;
 		printf("%d. %s \t( %d - %d )\n", i, s,
 		       iarr[i].ie_timeperiod.tp_start,
-		       iarr[i].ie_timeperiod.tp_end );
+		       iarr[i].ie_timeperiod.tp_end);
 	}
 #undef INV_UUID_STR_LEN
-	printf( "\n ==================================\n");
+	printf("\n ==================================\n");
 	return 1;
 
 }
 
 int
-idx_DEBUG_print ( int fd )
+idx_DEBUG_print (int fd)
 {
 	int nindices;
 	invt_entry_t *iarr = NULL;
 	invt_counter_t *icnt = NULL;
-	if ( ( nindices = GET_ALLHDRS_N_CNTS_NOLOCK( fd,
+	if ((nindices = GET_ALLHDRS_N_CNTS_NOLOCK(fd,
 						    (void **)&iarr,
 						    (void **)&icnt,
-						    sizeof( invt_entry_t ),
-				         sizeof( invt_counter_t ))) < 0 ) {
+						    sizeof(invt_entry_t),
+				         sizeof(invt_counter_t))) < 0) {
 		return -1;
 	}
-	idx_DEBUG_printinvindices( iarr, (uint) nindices );
-	free( iarr );
-	free( icnt );
+	idx_DEBUG_printinvindices(iarr, (uint) nindices);
+	free(iarr);
+	free(icnt);
 
 	return 1;
 }
@@ -543,16 +543,16 @@ idx_DEBUG_print ( int fd )
 
 
 int
-DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
+DEBUG_displayallsessions(int fd, invt_seshdr_t *hdr, uint ref,
 			  invt_pr_ctx_t *prctx)
 {
 	inv_session_t *ses;
-	if ( stobj_make_invsess( fd, &ses, hdr ) < 1 )
+	if (stobj_make_invsess(fd, &ses, hdr) < 1)
 		return -1;
 
-	DEBUG_sessionprint( ses, ref, prctx);
-	free( ses->s_streams );
-	free( ses );
+	DEBUG_sessionprint(ses, ref, prctx);
+	free(ses->s_streams);
+	free(ses);
 
 	return 0;
 }
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index f175c02..c78e64e 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -45,33 +45,33 @@
 /*----------------------------------------------------------------------*/
 
 int
-init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
-	  inv_idbtoken_t *tok )
+init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
+	  inv_idbtoken_t *tok)
 {
-	char fname[ INV_STRLEN ];
-	char uuname[ INV_STRLEN ];
+	char fname[INV_STRLEN];
+	char uuname[INV_STRLEN];
 	int fd;
 
 	*tok = INV_TOKEN_NULL;
 	/* make sure INV_DIRPATH exists, and is writable */
-	if ( make_invdirectory( forwhat ) < 0 )
+	if (make_invdirectory(forwhat) < 0)
 		return I_DONE;
 
 	/* come up with the unique file suffix that refers to this
 	   filesystem */
-	if ( fstab_get_fname( pred, uuname, bywhat, forwhat ) < 0 ) {
+	if (fstab_get_fname(pred, uuname, bywhat, forwhat) < 0) {
 		return I_DONE;
 	}
 
-	( void )strcpy( fname, uuname );
-	strcat ( fname, INV_INVINDEX_PREFIX );
+	(void)strcpy(fname, uuname);
+	strcat (fname, INV_INVINDEX_PREFIX);
 
 	/* first check if the inv_index file exists: if not create it */
-	if ( ( fd = open( fname, INV_OFLAG(forwhat) ) ) == -1 ) {
+	if ((fd = open(fname, INV_OFLAG(forwhat))) == -1) {
 		if (errno != ENOENT) {
-			INV_PERROR ( fname );
+			INV_PERROR (fname);
 		} else if (forwhat == INV_SEARCH_N_MOD) {
-			*tok = idx_create( fname, forwhat );
+			*tok = idx_create(fname, forwhat);
 		} else {
 			/* this happens when the inv is empty and the user
 			   wants to do a search. this is legal - not an error */
@@ -89,12 +89,12 @@ init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 
 
 inv_idbtoken_t
-get_token( int invfd, int stobjfd  )
+get_token(int invfd, int stobjfd)
 {
 	invt_desc_entry_t *desc;
 
 	desc = (invt_desc_entry_t *) malloc
-		( sizeof( invt_desc_entry_t ) );
+		(sizeof(invt_desc_entry_t));
 
 	desc->d_invindex_fd = invfd;
 	desc->d_stobj_fd  = stobjfd;
@@ -110,19 +110,19 @@ get_token( int invfd, int stobjfd  )
 
 
 void
-destroy_token( inv_idbtoken_t tok )
+destroy_token(inv_idbtoken_t tok)
 {
-	free ( (invt_desc_entry_t *) tok );
+	free ((invt_desc_entry_t *) tok);
 }
 
 
 
 inv_sestoken_t
-get_sesstoken( inv_idbtoken_t tok )
+get_sesstoken(inv_idbtoken_t tok)
 {
 	inv_sestoken_t stok;
 
-	stok = (inv_sestoken_t) malloc( sizeof( invt_sesdesc_entry_t ) );
+	stok = (inv_sestoken_t) malloc(sizeof(invt_sesdesc_entry_t));
 	stok->sd_invtok = tok;
 	stok->sd_session_off = stok->sd_sesshdr_off = -1;
 	stok->sd_sesstime = (time32_t) 0;
@@ -159,31 +159,31 @@ invmgr_query_all_sessions (
 	*outarg = NULL;
 	assert(inarg);
 
-	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
+	fd = fstab_getall(&arr, &cnt, &numfs, forwhat);
 	/* special case missing file: ok, outarg says zero */
-	if ( fd < 0 && errno == ENOENT ) {
+	if (fd < 0 && errno == ENOENT) {
 		return BOOL_TRUE;
 	}
-	if ( fd < 0 || numfs <= 0 ) {
-		mlog( MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n") );
+	if (fd < 0 || numfs <= 0) {
+		mlog(MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n"));
 		return ret;
 	}
 
-	close( fd );
+	close(fd);
 
-	for ( i = 0; i < numfs; i++) {
-		if ( fstab_get_fname( &arr[i].ft_uuid, fname,
+	for (i = 0; i < numfs; i++) {
+		if (fstab_get_fname(&arr[i].ft_uuid, fname,
 				     (inv_predicate_t)INV_BY_UUID,
-				     forwhat) < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+				     forwhat) < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: Cant get inv-name for uuid\n")
 			     );
 			continue;
 		}
-		strcat( fname, INV_INVINDEX_PREFIX );
-		invfd = open( fname, INV_OFLAG(forwhat) );
-		if ( invfd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_INV, _(
+		strcat(fname, INV_INVINDEX_PREFIX);
+		invfd = open(fname, INV_OFLAG(forwhat));
+		if (invfd < 0) {
+			mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: Open failed on %s\n"),
 			     fname
 			     );
@@ -216,7 +216,7 @@ invmgr_query_all_sessions (
 /*----------------------------------------------------------------------*/
 /* search_invt                                                          */
 /*                                                                      */
-/* Used by the toplevel (inv layer ) to do common searches on the inven-*/
+/* Used by the toplevel (inv layer) to do common searches on the inven-*/
 /* tory. Caller supplies a callback routine that performs the real      */
 /* comparison/check.                                                    */
 /*----------------------------------------------------------------------*/
@@ -243,17 +243,17 @@ search_invt(
 	 * if no session found, the caller will expect to see
 	 * NULL.
 	 */
-	*( char ** )buf = NULL;
+	*(char **)buf = NULL;
 
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+	if ((nindices = GET_ALLHDRS_N_CNTS(invfd, (void **)&iarr,
 					      (void **)&icnt,
-					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
-	      ) <= 0 ) {
+					      sizeof(invt_entry_t),
+					      sizeof(invt_counter_t))
+	      ) <= 0) {
 		return -1;
 	}
 
-	free( icnt );
+	free(icnt);
 
 	/* we need to get all the invindex headers and seshdrs in reverse
 	   order */
@@ -263,25 +263,25 @@ search_invt(
 		invt_seshdr_t		*harr = NULL;
 		bool_t                  found;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY );
+		fd = open (iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
-			INV_PERROR( iarr[i].ie_filename );
+			INV_PERROR(iarr[i].ie_filename);
 			continue;
 		}
-		INVLOCK( fd, LOCK_SH );
+		INVLOCK(fd, LOCK_SH);
 
 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+		if ((nsess = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void **)&harr,
 						  (void **)&scnt,
-						  sizeof( invt_seshdr_t ),
-						 sizeof( invt_sescounter_t ))
-		     ) < 0 ) {
-			INV_PERROR( iarr[i].ie_filename );
-			INVLOCK( fd, LOCK_UN );
-			close( fd );
+						  sizeof(invt_seshdr_t),
+						 sizeof(invt_sescounter_t))
+		     ) < 0) {
+			INV_PERROR(iarr[i].ie_filename);
+			INVLOCK(fd, LOCK_UN);
+			close(fd);
 			continue;
 		}
-		free ( scnt );
+		free (scnt);
 
 		for (j = nsess - 1; j >= 0; j--) {
 			invt_session_t ses;
@@ -311,18 +311,18 @@ search_invt(
 			}
 
 			found = (* do_chkcriteria)(fd, &harr[j], arg, buf);
-			if (! found ) continue;
+			if (! found) continue;
 
 			/* we found what we need; just return */
-			INVLOCK( fd, LOCK_UN );
-			close( fd );
-			free( harr );
+			INVLOCK(fd, LOCK_UN);
+			close(fd);
+			free(harr);
 
 			return found; /* == -1 or 1 */
 		}
 
-		INVLOCK( fd, LOCK_UN );
-		close( fd );
+		INVLOCK(fd, LOCK_UN);
+		close(fd);
 	}
 
 	return 0;
@@ -353,66 +353,66 @@ invmgr_inv_print(
 		return 0;
 
 
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+	if ((nindices = GET_ALLHDRS_N_CNTS(invfd, (void **)&iarr,
 					      (void **)&icnt,
-					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
-	      ) <= 0 ) {
+					      sizeof(invt_entry_t),
+					      sizeof(invt_counter_t))
+	      ) <= 0) {
 		return -1;
 	}
 
-	free( icnt );
+	free(icnt);
 
 	if (prctx->invidx) {
-		idx_DEBUG_printinvindices( iarr, (uint) nindices );
+		idx_DEBUG_printinvindices(iarr, (uint) nindices);
 		free(iarr);
 		return (0);
 	}
 
 
 
-	for ( i = 0; i < nindices; i++ ) {
+	for (i = 0; i < nindices; i++) {
 		int 			nsess;
 		invt_sescounter_t 	*scnt = NULL;
 		invt_seshdr_t		*harr = NULL;
 		int                     s;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY );
+		fd = open (iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
-			INV_PERROR( iarr[i].ie_filename );
+			INV_PERROR(iarr[i].ie_filename);
 			continue;
 		}
-		INVLOCK( fd, LOCK_SH );
+		INVLOCK(fd, LOCK_SH);
 
 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+		if ((nsess = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void **)&harr,
 						  (void **)&scnt,
-						  sizeof( invt_seshdr_t ),
-						 sizeof( invt_sescounter_t ))
-		     ) < 0 ) {
-			INV_PERROR( iarr[i].ie_filename );
-			INVLOCK( fd, LOCK_UN );
-			close( fd );
+						  sizeof(invt_seshdr_t),
+						 sizeof(invt_sescounter_t))
+		     ) < 0) {
+			INV_PERROR(iarr[i].ie_filename);
+			INVLOCK(fd, LOCK_UN);
+			close(fd);
 			continue;
 		}
-		free ( scnt );
-		for( s = 0; s < nsess; s++ ) {
+		free (scnt);
+		for(s = 0; s < nsess; s++) {
 			/* fd is kept locked until we return from the
 			   callback routine */
 
 			/* Check to see if this session has been pruned
 			 * by xfsinvutil before returning it.
 			 */
-			if ( harr[s].sh_pruned ) {
+			if (harr[s].sh_pruned) {
 				continue;
 			}
 
-			(void)DEBUG_displayallsessions( fd, &harr[ s ],
+			(void)DEBUG_displayallsessions(fd, &harr[s],
 						        ref++, prctx);
 		}
 
-		INVLOCK( fd, LOCK_UN );
-		close( fd );
+		INVLOCK(fd, LOCK_UN);
+		close(fd);
 	}
 
 	free (iarr);
@@ -441,42 +441,42 @@ invmgr_inv_check(
 	if (invfd == I_EMPTYINV)
 		return 0;
 
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+	if ((nindices = GET_ALLHDRS_N_CNTS(invfd, (void **)&iarr,
 					      (void **)&icnt,
-					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
-	      ) <= 0 ) {
+					      sizeof(invt_entry_t),
+					      sizeof(invt_counter_t))
+	      ) <= 0) {
 		return -1;
 	}
 
-	free( icnt );
+	free(icnt);
 
 
-	for ( i = 0; i < nindices; i++ ) {
+	for (i = 0; i < nindices; i++) {
 		int 			nsess;
 		invt_sescounter_t 	*scnt = NULL;
 		invt_seshdr_t		*harr = NULL;
 		int                     s;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY );
+		fd = open (iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
-			INV_PERROR( iarr[i].ie_filename );
+			INV_PERROR(iarr[i].ie_filename);
 			continue;
 		}
-		INVLOCK( fd, LOCK_SH );
+		INVLOCK(fd, LOCK_SH);
 
 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+		if ((nsess = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void **)&harr,
 						  (void **)&scnt,
-						  sizeof( invt_seshdr_t ),
-						 sizeof( invt_sescounter_t ))
-		     ) < 0 ) {
-			INV_PERROR( iarr[i].ie_filename );
-			INVLOCK( fd, LOCK_UN );
-			close( fd );
+						  sizeof(invt_seshdr_t),
+						 sizeof(invt_sescounter_t))
+		     ) < 0) {
+			INV_PERROR(iarr[i].ie_filename);
+			INVLOCK(fd, LOCK_UN);
+			close(fd);
 			continue;
 		}
-		free ( scnt );
+		free (scnt);
 
 		if ((iarr[i].ie_timeperiod.tp_start != harr[0].sh_time) ||
 		    (iarr[i].ie_timeperiod.tp_end != harr[nsess-1].sh_time)) {
@@ -485,7 +485,7 @@ invmgr_inv_check(
 			       i+1,
 			       iarr[i].ie_timeperiod.tp_start,
 			       iarr[i].ie_timeperiod.tp_end);
-			for( s = 0; s < nsess; s++ ) {
+			for(s = 0; s < nsess; s++) {
 				printf(_("tm (%d)\t%d\n"), s, harr[s].sh_time);
 			}
 		}
@@ -493,8 +493,8 @@ invmgr_inv_check(
 			printf(_("INV: Check %d out of %d succeeded\n"),
 			       i+1, nindices);
 		}
-		INVLOCK( fd, LOCK_UN );
-		close( fd );
+		INVLOCK(fd, LOCK_UN);
+		close(fd);
 	}
 
 	return 0;
@@ -509,20 +509,20 @@ invmgr_inv_check(
 
 /* ARGSUSED */
 bool_t
-tm_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
-		   void **tm )
+tm_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
+		   void **tm)
 {
 	u_char level = *(u_char *)arg;
 	*tm = NULL;
-	if ( IS_PARTIAL_SESSION( hdr ) )
+	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
-	if (hdr->sh_level < level ) {
+	if (hdr->sh_level < level) {
 #ifdef INVT_DEBUG
-		mlog( MLOG_DEBUG | MLOG_INV, "$ found level %d < %d\n", hdr->sh_level,
-		     level );
+		mlog(MLOG_DEBUG | MLOG_INV, "$ found level %d < %d\n", hdr->sh_level,
+		     level);
 #endif
-		*tm = calloc( 1, sizeof( time32_t ) );
-		memcpy( *tm, &hdr->sh_time, sizeof( time32_t ) );
+		*tm = calloc(1, sizeof(time32_t));
+		memcpy(*tm, &hdr->sh_time, sizeof(time32_t));
 		return 1;
 	}
 	return 0;
@@ -538,19 +538,19 @@ tm_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
 /*----------------------------------------------------------------------*/
 
 bool_t
-lastsess_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
-			 void **buf )
+lastsess_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
+			 void **buf)
 {
 	u_char level = *(u_char *)arg;
 	*buf = NULL;
-	if ( IS_PARTIAL_SESSION( hdr ) )
+	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
-	if (hdr->sh_level < level ) {
+	if (hdr->sh_level < level) {
 #ifdef INVT_DEBUG
-		mlog( MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d < %d \n",
-		     hdr->sh_level, level );
+		mlog(MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d < %d \n",
+		     hdr->sh_level, level);
 #endif
-		return stobj_make_invsess( fd, (inv_session_t **) buf, hdr );
+		return stobj_make_invsess(fd, (inv_session_t **) buf, hdr);
 	}
 	return 0;
 
@@ -565,19 +565,19 @@ lastsess_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
 /*----------------------------------------------------------------------*/
 
 bool_t
-lastsess_level_equalto( int fd, invt_seshdr_t *hdr,
-		       void *arg, void **buf )
+lastsess_level_equalto(int fd, invt_seshdr_t *hdr,
+		       void *arg, void **buf)
 {
 	u_char level = *(u_char *)arg;
 	*buf = NULL;
-	if ( IS_PARTIAL_SESSION( hdr ) )
+	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
-	if (hdr->sh_level == level ) {
+	if (hdr->sh_level == level) {
 #ifdef INVT_DEBUG
-	mlog( MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d == %d \n", hdr->sh_level,
-	     level );
+	mlog(MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d == %d \n", hdr->sh_level,
+	     level);
 #endif
-		return stobj_make_invsess( fd, (inv_session_t **) buf, hdr );
+		return stobj_make_invsess(fd, (inv_session_t **) buf, hdr);
 	}
 	return 0;
 
@@ -596,7 +596,7 @@ lastsess_level_equalto( int fd, invt_seshdr_t *hdr,
 /* this is used in reconstructing the database.                         */
 /*----------------------------------------------------------------------*/
 bool_t
-insert_session( invt_sessinfo_t *s)
+insert_session(invt_sessinfo_t *s)
 {
 	inv_idbtoken_t tok = INV_TOKEN_NULL;
 	int invfd, stobjfd = -1;
@@ -605,21 +605,21 @@ insert_session( invt_sessinfo_t *s)
 	inv_oflag_t       forwhat = INV_SEARCH_N_MOD;
 
 	/* initialize the inventory */
-	if ( ( invfd = init_idb ( (void *) s->ses->s_fsid,
+	if ((invfd = init_idb ((void *) s->ses->s_fsid,
 				  (inv_predicate_t) INV_BY_UUID,
  				  forwhat,
-				  &tok ) ) < 0 ) {
-		if ( tok == INV_TOKEN_NULL ) {
+				  &tok)) < 0) {
+		if (tok == INV_TOKEN_NULL) {
 #ifdef INVT_DEBUG
-			mlog( MLOG_DEBUG | MLOG_INV, "INV: insert_session: init_db "
-			      "failed\n" );
+			mlog(MLOG_DEBUG | MLOG_INV, "INV: insert_session: init_db "
+			      "failed\n");
 #endif
 			return BOOL_FALSE;
 		}
 
 		invfd = tok->d_invindex_fd;
-		close( tok->d_stobj_fd );
-		destroy_token( tok );
+		close(tok->d_stobj_fd);
+		destroy_token(tok);
 	}
 
 	/* at this point we know that invindex has at least one entry
@@ -629,33 +629,33 @@ insert_session( invt_sessinfo_t *s)
 	   contain this session, it suffices to sequentially search the
 	   inventory indices of this filesystem for the particular invt-entry
 	 */
-	INVLOCK( invfd, LOCK_EX );
+	INVLOCK(invfd, LOCK_EX);
 	idx.invfd = invfd;
-	stobjfd = idx_find_stobj( &idx, s->seshdr->sh_time );
+	stobjfd = idx_find_stobj(&idx, s->seshdr->sh_time);
 	if (stobjfd < 0) {
-		INVLOCK( invfd, LOCK_UN );
-		free( idx.icnt );
-		free( idx.iarr );
+		INVLOCK(invfd, LOCK_UN);
+		free(idx.icnt);
+		free(idx.iarr);
 		return BOOL_FALSE;
 	}
 
 	/* Now put the session in the storage-object */
-	INVLOCK( stobjfd, LOCK_EX );
-	if ( ( stobj_insert_session( &idx, stobjfd, s ) < 0 ) ||
-		( idx_recons_time ( s->seshdr->sh_time, &idx ) < 0 ) )
+	INVLOCK(stobjfd, LOCK_EX);
+	if ((stobj_insert_session(&idx, stobjfd, s) < 0) ||
+		(idx_recons_time (s->seshdr->sh_time, &idx) < 0))
 			ret = BOOL_TRUE;
 
-	INVLOCK( stobjfd, LOCK_UN );
-	INVLOCK( invfd, LOCK_UN );
+	INVLOCK(stobjfd, LOCK_UN);
+	INVLOCK(invfd, LOCK_UN);
 
-	free( idx.icnt );
-	free( idx.iarr );
+	free(idx.icnt);
+	free(idx.iarr);
 
 	if (ret) return BOOL_FALSE;
 
 	/* make sure the fstab is uptodate too */
-	if ( fstab_put_entry( &s->ses->s_fsid, s->ses->s_mountpt, s->ses->s_devpath,
-			      forwhat ) < 0 )
+	if (fstab_put_entry(&s->ses->s_fsid, s->ses->s_mountpt, s->ses->s_devpath,
+			      forwhat) < 0)
 		return BOOL_FALSE;
 
 	/* and we are done */
@@ -672,82 +672,82 @@ insert_session( invt_sessinfo_t *s)
 /*----------------------------------------------------------------------*/
 
 int
-make_invdirectory( inv_oflag_t forwhat )
+make_invdirectory(inv_oflag_t forwhat)
 {
 	struct stat64 st;
 	char path[PATH_MAX];
 	char *p;
 
-	p = strcpy( path, INV_DIRPATH );
+	p = strcpy(path, INV_DIRPATH);
 
-	if ( stat64( path, &st ) == 0 )
+	if (stat64(path, &st) == 0)
 		return 1;
 
-	if ( forwhat == INV_SEARCH_ONLY || errno != ENOENT )
+	if (forwhat == INV_SEARCH_ONLY || errno != ENOENT)
 		return -1;
 
 	do {
 		p++;
-		if ( *p == '/' ) {
+		if (*p == '/') {
 			*p = '\0';
-			if ( mkdir( path, (mode_t)0755 ) < 0 ) {
-				if ( errno != EEXIST ) {
-					INV_PERROR( path );
+			if (mkdir(path, (mode_t)0755) < 0) {
+				if (errno != EEXIST) {
+					INV_PERROR(path);
 					return -1;
 				}
 			}
 			*p = '/';
 		}
-	} while ( *p );
+	} while (*p);
 
-	if ( mkdir( path, (mode_t)0755 ) < 0 ) {
-		if ( errno != EEXIST ) {
-			INV_PERROR( path );
+	if (mkdir(path, (mode_t)0755) < 0) {
+		if (errno != EEXIST) {
+			INV_PERROR(path);
 			return -1;
 		}
 	}
 
-	mlog( MLOG_VERBOSE | MLOG_INV, _("%s created\n"), path );
+	mlog(MLOG_VERBOSE | MLOG_INV, _("%s created\n"), path);
 	return 1;
 }
 
 #ifdef NOTDEF
 
 bool_t
-invmgr_lockinit( void )
+invmgr_lockinit(void)
 {
-	if ( invlock_fd == -1 ) {
-		if (( invlock_fd = open( INV_LOCKFILE,
-					O_RDONLY | O_CREAT, S_IRUSR|S_IWUSR )) < 0 ) {
-			INV_PERROR( INV_LOCKFILE );
+	if (invlock_fd == -1) {
+		if ((invlock_fd = open(INV_LOCKFILE,
+					O_RDONLY | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+			INV_PERROR(INV_LOCKFILE);
 			return BOOL_FALSE;
 		}
-		fchmod ( invlock_fd, INV_PERMS );
+		fchmod (invlock_fd, INV_PERMS);
 	}
 	return BOOL_TRUE;
 }
 
 
 bool_t
-invmgr_trylock( invt_mode_t mode )
+invmgr_trylock(invt_mode_t mode)
 {
 	int md;
-	assert( invlock_fd >= 0 );
+	assert(invlock_fd >= 0);
 
 	md = (mode == INVT_RECONSTRUCT) ? LOCK_EX: LOCK_SH;
 
-	if (INVLOCK( invlock_fd, md | LOCK_NB ) < 0)
+	if (INVLOCK(invlock_fd, md | LOCK_NB) < 0)
 		return BOOL_FALSE;
 
 	return BOOL_TRUE;
 }
 
 void
-invmgr_unlock( void )
+invmgr_unlock(void)
 {
-	assert( invlock_fd >= 0 );
+	assert(invlock_fd >= 0);
 
-	INVLOCK( invlock_fd, LOCK_UN );
+	INVLOCK(invlock_fd, LOCK_UN);
 
 }
 
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index 56ac5e5..a2e08d6 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -269,7 +269,7 @@ _oref_free(
 	 */
 	OREF_UNLOCK(obj);
 
-	if (OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ) ){
+	if (OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ)){
 		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
 			free((oref)->cu_sescnt);
 		if (OREF_ISRESOLVED(obj, INVT_RES_HDRS))
@@ -311,8 +311,8 @@ oref_resolve(
 	inv_predicate_t bywhat,
 	void 		*pred)
 {
-	char 		fname[ INV_STRLEN ];
-	char 		uuname[ INV_STRLEN ];
+	char 		fname[INV_STRLEN];
+	char 		uuname[INV_STRLEN];
 	int 		fd;
 	invt_oref_t	*stobj;
 	int		index;
@@ -358,13 +358,13 @@ oref_resolve(
 		return INV_ERR;
 	}
 
-	/* create another storage object ( and, an inv_index entry for it
-	   too ) if we've filled this one up */
+	/* create another storage object (and, an inv_index entry for it
+	   too) if we've filled this one up */
 	if (OREF_CNT_CURNUM(stobj) >= OREF_CNT_MAXNUM(stobj)) {
 		int 	rval;
 #ifdef INVT_DEBUG
-		mlog( MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
-		      "index entry. \n" );
+		mlog(MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
+		      "index entry. \n");
 #endif
 		/* Close(), Destroy() and mark unresolved */
 		OREF_UNRESOLVE_CHILD(invidx);
@@ -405,12 +405,12 @@ oref_resolve_child(
 
 	/* at this point we know that there should be at least one invindex
 	   entry present */
-	assert ( ent != NULL );
-	assert ( ent->ie_filename );
+	assert (ent != NULL);
+	assert (ent->ie_filename);
 
-	fd = open( ent->ie_filename, O_RDWR );
-	if ( fd < 0 ) {
-		INV_PERROR( ent->ie_filename );
+	fd = open(ent->ie_filename, O_RDWR);
+	if (fd < 0) {
+		INV_PERROR(ent->ie_filename);
 		return INV_ERR;
 	}
 
@@ -432,8 +432,8 @@ oref_resolve_new_invidx(
 	int stobjfd, fd;
 	inv_idbtoken_t tok;
 
-	if ((fd = open ( fname , O_RDWR | O_CREAT, S_IRUSR|S_IWUSR ) ) < 0 ) {
-		INV_PERROR ( fname );
+	if ((fd = open (fname , O_RDWR | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+		INV_PERROR (fname);
 		return INV_ERR;
 	}
 	invidx->fd = fd;
@@ -441,7 +441,7 @@ oref_resolve_new_invidx(
 	fchmod(fd, INV_PERMS);
 
 #ifdef INVT_DEBUG
-	mlog( MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
+	mlog(MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
 #endif
 	/* create the new stobj as its first entry */
 	rval = oref_resolve_new_stobj(invidx, IS_EMPTY);
@@ -467,15 +467,15 @@ oref_resolve_new_stobj(
 
 	assert(OREF_ISLOCKED(invidx));
 
-	memset ( &ent, 0, sizeof( ent ) );
+	memset (&ent, 0, sizeof(ent));
 	stobj = calloc(1, sizeof(invt_oref_t));
 	OREF_SET_CHILD(invidx, stobj);
 
 	/* initialize the start and end times to be the same */
 	ent.ie_timeperiod.tp_start = ent.ie_timeperiod.tp_end = (time32_t)0;
-	stobj_makefname( ent.ie_filename );
+	stobj_makefname(ent.ie_filename);
 
-	if ( firstentry ) {
+	if (firstentry) {
 		invt_counter_t *cnt;
 		cnt = malloc(sizeof(invt_counter_t));
 
@@ -483,8 +483,8 @@ oref_resolve_new_stobj(
 		cnt->ic_curnum = 1;
 		cnt->ic_vernum = INV_VERSION;
 
-		fd = stobj_create( ent.ie_filename );
-		if ( fd < 0 ) {
+		fd = stobj_create(ent.ie_filename);
+		if (fd < 0) {
 			free(cnt);
 			return INV_ERR;
 		}
@@ -501,8 +501,8 @@ oref_resolve_new_stobj(
 			return INV_ERR;
 
 		/* create the new storage object */
-		fd = stobj_create( ent.ie_filename );
-		if ( fd < 0 ) {
+		fd = stobj_create(ent.ie_filename);
+		if (fd < 0) {
 			return -1;
 		}
 
@@ -516,7 +516,7 @@ oref_resolve_new_stobj(
 			return INV_ERR;
 
 	}
-	tok = get_token( invfd, fd );
+	tok = get_token(invfd, fd);
 	tok->d_invindex_off = IDX_HDR_OFFSET(OREF_CNT_CURNUM(invidx) - 1);
 	tok->d_update_flag |= NEW_INVINDEX;
 
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index 0061722..836ce82 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -120,7 +120,7 @@ typedef struct invt_oref {
  * For locking/unlocking orefs - mode { LOCK_SH, LOCK_EX, LOCK_UN }
  */
 
-#define OREF_LOCKMODE_EQL(oref, mode) ((oref)->lockflag == mode )
+#define OREF_LOCKMODE_EQL(oref, mode) ((oref)->lockflag == mode)
 #define OREF_ISLOCKED(oref)	      ((oref)->lockflag == 0 ||
 				       (oref)->lockflag == LOCK_UN)
 
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index ed50782..2310dc1 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -47,11 +47,11 @@
 #define FSTAB_UPDATED		1
 #define NEW_INVINDEX		2
 
-/* session flags ( seshdr.sh_flag ) */
+/* session flags (seshdr.sh_flag) */
 #define INVT_PARTIAL		(uint)0x0001
 #define INVT_RESUMED            (uint)0x0002
 
-/* media file flags ( mfile.mf_flag ) */
+/* media file flags (mfile.mf_flag) */
 #define INVT_MFILE_GOOD         (u_char)0x01
 #define INVT_MFILE_INVDUMP      (u_char)0x02
 
@@ -60,7 +60,7 @@
 #define INVT_DOLOCK		BOOL_TRUE
 #define INVT_DONTLOCK		BOOL_FALSE
 
-#define INVLOCK( fd, m )	flock( fd, m )
+#define INVLOCK(fd, m)	flock(fd, m)
 
 /* return values */
 #define INV_OK			(int) 1
@@ -75,27 +75,27 @@
 
 #define INV_PERMS               S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
 
-#define IS_WITHIN(ttpe, tm)	( tm >= (ttpe)->tp_start && \
-				  tm <= (ttpe)->tp_end )
-#define IDX_HDR_OFFSET(n) 	(off64_t) ( sizeof( invt_entry_t ) * \
+#define IS_WITHIN(ttpe, tm)	(tm >= (ttpe)->tp_start && \
+				  tm <= (ttpe)->tp_end)
+#define IDX_HDR_OFFSET(n) 	(off64_t) (sizeof(invt_entry_t) * \
 					   (size_t) (n)\
-					   + sizeof( invt_counter_t ) )
-#define STOBJ_OFFSET( nhdrs, nsess ) (off64_t) ( \
-			       sizeof( invt_sescounter_t ) + \
-			       (size_t) nhdrs * sizeof( invt_seshdr_t ) + \
-			       (size_t) nsess * sizeof( invt_session_t ) )
-
-#define STREQL( n,m )		( strcmp((n),(m)) == 0 )
-#define UUID_EQL( n,m,t )	( uuid_compare( n, m, t ) == 0 )
-#define IS_PARTIAL_SESSION( h ) ( (h)->sh_flag & INVT_PARTIAL )
-#define IS_RESUMED_SESSION( h ) ( (h)->sh_flag & INVT_RESUMED )
-#define SC_EOF_INITIAL_POS	(off64_t) (sizeof( invt_sescounter_t ) + \
+					   + sizeof(invt_counter_t))
+#define STOBJ_OFFSET(nhdrs, nsess) (off64_t) (\
+			       sizeof(invt_sescounter_t) + \
+			       (size_t) nhdrs * sizeof(invt_seshdr_t) + \
+			       (size_t) nsess * sizeof(invt_session_t))
+
+#define STREQL(n,m)		(strcmp((n),(m)) == 0)
+#define UUID_EQL(n,m,t)	(uuid_compare(n, m, t) == 0)
+#define IS_PARTIAL_SESSION(h) ((h)->sh_flag & INVT_PARTIAL)
+#define IS_RESUMED_SESSION(h) ((h)->sh_flag & INVT_RESUMED)
+#define SC_EOF_INITIAL_POS	(off64_t) (sizeof(invt_sescounter_t) + \
 					 INVT_STOBJ_MAXSESSIONS * \
-					 ( sizeof( invt_seshdr_t ) + \
-					   sizeof( invt_session_t ) ) )
+					 (sizeof(invt_seshdr_t) + \
+					   sizeof(invt_session_t)))
 
-#define INV_PERROR(s)  	mlog( MLOG_NORMAL,"INV: %s %s\n", s,strerror(errno) )
-#define INV_OFLAG(f)    ( f == INV_SEARCH_ONLY ) ? O_RDONLY: O_RDWR
+#define INV_PERROR(s)  	mlog(MLOG_NORMAL,"INV: %s %s\n", s,strerror(errno))
+#define INV_OFLAG(f)    (f == INV_SEARCH_ONLY) ? O_RDONLY: O_RDWR
 
 /*----------------------------------------------------------------------*/
 /* On Disk Data Structures                                              */
@@ -200,8 +200,8 @@ typedef struct invt_sescounter {
 	INVT_COUNTER_FIELDS
 	off64_t	       ic_eof;   /* current end of the file, where the next
 				 media file or stream will be written to */
-	char 	       ic_padding[0x20 - ( INVT_COUNTER_FIELDS_SIZE +
-					   sizeof( off64_t) )];
+	char 	       ic_padding[0x20 - (INVT_COUNTER_FIELDS_SIZE +
+					   sizeof(off64_t))];
 } invt_sescounter_t;
 
 
@@ -297,41 +297,41 @@ typedef struct invt_pr_ctx {
 typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 
 
-#define GET_REC( fd, buf, sz, off )  \
-                 get_invtrecord( fd, buf, sz, off, INVT_DOLOCK )
+#define GET_REC(fd, buf, sz, off)  \
+                 get_invtrecord(fd, buf, sz, off, INVT_DOLOCK)
 
-#define GET_REC_NOLOCK( fd, buf, sz, off )  \
-                 get_invtrecord( fd, buf, sz, off, INVT_DONTLOCK )
+#define GET_REC_NOLOCK(fd, buf, sz, off)  \
+                 get_invtrecord(fd, buf, sz, off, INVT_DONTLOCK)
 
-#define GET_ALLHDRS_N_CNTS( fd, h, c, hsz, csz ) \
-                 get_headerinfo( fd, h, c, hsz, csz, INVT_DOLOCK )
+#define GET_ALLHDRS_N_CNTS(fd, h, c, hsz, csz) \
+                 get_headerinfo(fd, h, c, hsz, csz, INVT_DOLOCK)
 
-#define GET_ALLHDRS_N_CNTS_NOLOCK( fd, h, c, hsz, csz ) \
-                 get_headerinfo( fd, h, c, hsz, csz, INVT_DONTLOCK )
+#define GET_ALLHDRS_N_CNTS_NOLOCK(fd, h, c, hsz, csz) \
+                 get_headerinfo(fd, h, c, hsz, csz, INVT_DONTLOCK)
 
-#define PUT_REC( fd, buf, sz, off )  \
-                 put_invtrecord( fd, buf, sz, off, INVT_DOLOCK )
+#define PUT_REC(fd, buf, sz, off)  \
+                 put_invtrecord(fd, buf, sz, off, INVT_DOLOCK)
 
-#define PUT_REC_NOLOCK( fd, buf, sz, off )  \
-                 put_invtrecord( fd, buf, sz, off, INVT_DONTLOCK )
+#define PUT_REC_NOLOCK(fd, buf, sz, off)  \
+                 put_invtrecord(fd, buf, sz, off, INVT_DONTLOCK)
 
 
-#define GET_COUNTERS( fd, cnt ) get_counters( fd, (void **)(cnt), \
-					      sizeof(invt_counter_t) )
-#define GET_SESCOUNTERS( fd, cnt ) get_counters( fd, (void **)(cnt), \
-						sizeof(invt_sescounter_t) )
+#define GET_COUNTERS(fd, cnt) get_counters(fd, (void **)(cnt), \
+					      sizeof(invt_counter_t))
+#define GET_SESCOUNTERS(fd, cnt) get_counters(fd, (void **)(cnt), \
+						sizeof(invt_sescounter_t))
 
-#define PUT_COUNTERS( fd, cnt ) PUT_REC_NOLOCK( fd, (void *)(cnt), \
-					     sizeof( invt_counter_t ), \
-					     (off64_t) 0 )
+#define PUT_COUNTERS(fd, cnt) PUT_REC_NOLOCK(fd, (void *)(cnt), \
+					     sizeof(invt_counter_t), \
+					     (off64_t) 0)
 
-#define PUT_SESCOUNTERS( fd, cnt )  PUT_REC_NOLOCK( fd, (void *)(cnt), \
-					     sizeof( invt_sescounter_t ), \
-					     (off64_t) 0 )
+#define PUT_SESCOUNTERS(fd, cnt)  PUT_REC_NOLOCK(fd, (void *)(cnt), \
+					     sizeof(invt_sescounter_t), \
+					     (off64_t) 0)
 
-#define GET_SESHEADERS( fd, hdrs, n ) get_headers( fd, (void**)(hdrs), \
-				   (size_t) ( n * sizeof(invt_seshdr_t ) ),\
-				          sizeof( invt_sescounter_t )  )
+#define GET_SESHEADERS(fd, hdrs, n) get_headers(fd, (void**)(hdrs), \
+				   (size_t) (n * sizeof(invt_seshdr_t)),\
+				          sizeof(invt_sescounter_t))
 
 #define GET_ENTRIES(fd, hdrs, n, sz) get_headers(fd, (void**)(hdrs), \
 				   (size_t) (n * sz), sizeof(invt_counter_t))
@@ -345,48 +345,48 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 
 /*----------------------------------------------------------------------*/
 inv_idbtoken_t
-idx_create( char *fname, inv_oflag_t forwhat );
+idx_create(char *fname, inv_oflag_t forwhat);
 
 int
-idx_create_entry( inv_idbtoken_t *tok, int invfd, bool_t firstentry );
+idx_create_entry(inv_idbtoken_t *tok, int invfd, bool_t firstentry);
 
 int
-idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime);
+idx_put_sesstime(inv_sestoken_t tok, bool_t whichtime);
 
 
 int
-idx_find_stobj( invt_idxinfo_t *idx, time32_t tm );
+idx_find_stobj(invt_idxinfo_t *idx, time32_t tm);
 
 uint
-idx_insert_newentry( int fd, int *stobjfd, invt_entry_t *iarr,
+idx_insert_newentry(int fd, int *stobjfd, invt_entry_t *iarr,
 		     invt_counter_t *icnt,
-		     time32_t tm );
+		     time32_t tm);
 int
-idx_put_newentry( invt_idxinfo_t *idx, invt_entry_t *ient );
+idx_put_newentry(invt_idxinfo_t *idx, invt_entry_t *ient);
 
 int
-idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index );
+idx_get_stobj(int invfd, inv_oflag_t forwhat, int *index);
 
 int
-idx_recons_time( time32_t tm, invt_idxinfo_t *idx );
+idx_recons_time(time32_t tm, invt_idxinfo_t *idx);
 
 int
-idx_DEBUG_printinvindices( invt_entry_t *iarr, uint num );
+idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num);
 
 int
-idx_DEBUG_print ( int fd );
+idx_DEBUG_print (int fd);
 
 /*----------------------------------------------------------------------*/
 
 int
-stobj_create( char *fname );
+stobj_create(char *fname);
 
 int
-stobj_create_session( inv_sestoken_t tok, int fd, invt_sescounter_t *sescnt,
-		      invt_session_t *ses, invt_seshdr_t *hdr );
+stobj_create_session(inv_sestoken_t tok, int fd, invt_sescounter_t *sescnt,
+		      invt_session_t *ses, invt_seshdr_t *hdr);
 
 int
-stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf );
+stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf);
 
 off64_t
 stobj_put_session(
@@ -395,73 +395,73 @@ stobj_put_session(
 	invt_session_t *ses,
 	invt_seshdr_t *hdr,
 	invt_stream_t *strms,
-	invt_mediafile_t *mfiles );
+	invt_mediafile_t *mfiles);
 
 int
-stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
-		   invt_mediafile_t *mfiles );
+		   invt_mediafile_t *mfiles);
 
 int
-stobj_hdrcmp( const void *h1, const void *h2 );
+stobj_hdrcmp(const void *h1, const void *h2);
 
 int
-stobj_sortheaders( int fd, uint num );
+stobj_sortheaders(int fd, uint num);
 
 uint
-stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm );
+stobj_find_splitpoint(int fd, invt_seshdr_t *harr, uint ns, time32_t tm);
 
 int
-stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
-	     invt_sessinfo_t *newsess );
+stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
+	     invt_sessinfo_t *newsess);
 bool_t
-stobj_replace_session( int fd, invt_sescounter_t *sescnt, invt_session_t *ses,
-		       invt_seshdr_t *hdr, invt_sessinfo_t *newsess );
+stobj_replace_session(int fd, invt_sescounter_t *sescnt, invt_session_t *ses,
+		       invt_seshdr_t *hdr, invt_sessinfo_t *newsess);
 
 int
-stobj_delete_mfile( int fd, inv_stream_t *strm, invt_mediafile_t *mf,
-		    off64_t  mfileoff );
+stobj_delete_mfile(int fd, inv_stream_t *strm, invt_mediafile_t *mf,
+		    off64_t  mfileoff);
 
 bool_t
-stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
-		     void  **bufpp, size_t *bufszp );
+stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
+		     void  **bufpp, size_t *bufszp);
 
 bool_t
 stobj_unpack_sessinfo(
         void              *bufp,
         size_t             bufsz,
-	invt_sessinfo_t   *s );
+	invt_sessinfo_t   *s);
 
 bool_t
-stobj_delete_sessinfo( int fd, invt_sescounter_t *sescnt,
-		       invt_session_t *ses, invt_seshdr_t *hdr );
+stobj_delete_sessinfo(int fd, invt_sescounter_t *sescnt,
+		       invt_session_t *ses, invt_seshdr_t *hdr);
 
 bool_t
-stobj_delete_mobj( int fd, invt_seshdr_t *hdr, void *arg,
-		   void **buf );
+stobj_delete_mobj(int fd, invt_seshdr_t *hdr, void *arg,
+		   void **buf);
 
 int
-stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr, invt_session_t *ses );
+stobj_get_sessinfo (inv_sestoken_t tok, invt_seshdr_t *hdr, invt_session_t *ses);
 
 void
-stobj_makefname( char *fname );
+stobj_makefname(char *fname);
 
 int
-stobj_insert_session( invt_idxinfo_t *idx, int fd,
-		      invt_sessinfo_t *s );
+stobj_insert_session(invt_idxinfo_t *idx, int fd,
+		      invt_sessinfo_t *s);
 
 int
-stobj_make_invsess( int fd, inv_session_t **buf, invt_seshdr_t *hdr );
+stobj_make_invsess(int fd, inv_session_t **buf, invt_seshdr_t *hdr);
 
 int
-stobj_copy_invsess( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_copy_invsess(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		    inv_session_t **buf);
 
 void
-DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx);
+DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx);
 
 void
-DEBUG_sessprint( invt_session_t *ses );
+DEBUG_sessprint(invt_session_t *ses);
 
 bool_t
 stobj_getsession_byuuid(int fd, invt_seshdr_t *hdr, void *sesid, void **buf);
@@ -486,57 +486,57 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo);
 /*----------------------------------------------------------------------*/
 
 int
-fstab_get_fname( void *pred, char *fname, inv_predicate_t bywhat,
-		 inv_oflag_t forwhat );
+fstab_get_fname(void *pred, char *fname, inv_predicate_t bywhat,
+		 inv_oflag_t forwhat);
 
 int
-fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat );
+fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat);
 
 int
-fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
-	      inv_oflag_t forwhat );
+fstab_getall(invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
+	      inv_oflag_t forwhat);
 
 void
-fstab_DEBUG_print( invt_fstab_t *arr, int num );
+fstab_DEBUG_print(invt_fstab_t *arr, int num);
 
 
 /*----------------------------------------------------------------------*/
 
 int
-get_invtentry( char *fname, time32_t tm, invt_entry_t *buf, size_t bufsz );
+get_invtentry(char *fname, time32_t tm, invt_entry_t *buf, size_t bufsz);
 
 int
-get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock );
+get_invtrecord(int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock);
 
 int
-put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock );
+put_invtrecord(int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock);
 
 inv_idbtoken_t
-get_token( int fd, int objfd );
+get_token(int fd, int objfd);
 
 void
-destroy_token( inv_idbtoken_t tok );
+destroy_token(inv_idbtoken_t tok);
 
 
 int
-get_headers( int fd, void **hdrs, size_t bufsz, size_t cntsz );
+get_headers(int fd, void **hdrs, size_t bufsz, size_t cntsz);
 
 int
-get_counters( int fd, void **cntpp, size_t sz );
+get_counters(int fd, void **cntpp, size_t sz);
 
 int
-get_sescounters( int fd, invt_sescounter_t **cntpp );
+get_sescounters(int fd, invt_sescounter_t **cntpp);
 
 int
-get_lastheader( int fd, void **ent, size_t hdrsz,  size_t cntsz );
+get_lastheader(int fd, void **ent, size_t hdrsz,  size_t cntsz);
 
 
 inv_sestoken_t
-get_sesstoken( inv_idbtoken_t tok );
+get_sesstoken(inv_idbtoken_t tok);
 
 int
-get_headerinfo( int fd, void **hdrs, void **cnt,
-	        size_t hdrsz, size_t cntsz, bool_t doblock );
+get_headerinfo(int fd, void **hdrs, void **cnt,
+	        size_t hdrsz, size_t cntsz, bool_t doblock);
 
 bool_t
 invmgr_query_all_sessions(uuid_t *fsidp, void *inarg, void **outarg,
@@ -546,42 +546,42 @@ int
 search_invt(uuid_t *fsidp, int invfd, void *arg, void **buf,
 	    search_callback_t do_chkcriteria);
 int
-invmgr_inv_print( int invfd, invt_pr_ctx_t *prctx);
+invmgr_inv_print(int invfd, invt_pr_ctx_t *prctx);
 
 int
-invmgr_inv_check( int invfd );
+invmgr_inv_check(int invfd);
 
 bool_t
-tm_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
-		   void **tm );
+tm_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
+		   void **tm);
 
 bool_t
-lastsess_level_lessthan( int fd, invt_seshdr_t *hdr,  void *arg,
-			 void **buf );
+lastsess_level_lessthan(int fd, invt_seshdr_t *hdr,  void *arg,
+			 void **buf);
 
 bool_t
-lastsess_level_equalto( int fd, invt_seshdr_t *hdr,  void *arg, void **buf );
+lastsess_level_equalto(int fd, invt_seshdr_t *hdr,  void *arg, void **buf);
 
 int
-DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
+DEBUG_displayallsessions(int fd, invt_seshdr_t *hdr, uint ref,
 			  invt_pr_ctx_t *prctx);
 
 int
-make_invdirectory( inv_oflag_t forwhat );
+make_invdirectory(inv_oflag_t forwhat);
 
 bool_t
-init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
-	 inv_idbtoken_t *tok );
+init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
+	 inv_idbtoken_t *tok);
 
 int
-inv_getopt( int argc, char **argv, invt_pr_ctx_t *prctx);
+inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx);
 
 bool_t
-insert_session( invt_sessinfo_t *s);
+insert_session(invt_sessinfo_t *s);
 
 /* To reconstruct a complete inventory from dumped inventories */
 extern bool_t
-inv_put_sessioninfo( invt_sessinfo_t *s );
+inv_put_sessioninfo(invt_sessinfo_t *s);
 
 
 #endif
-- 
2.19.1
