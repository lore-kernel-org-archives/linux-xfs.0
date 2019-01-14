Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfANRZ5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:25:57 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D923B7F6CB
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:25:56 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 01/13] xfsdump: (1/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:16 +0100
Message-Id: <20190114172528.65250-2-jtulak@redhat.com>
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
 common/arch_xlate.c     |   8 +-
 common/cldmgr.c         | 134 +++++++++----------
 common/cldmgr.h         |  16 +--
 common/cleanup.c        |  66 +++++-----
 common/cleanup.h        |  16 +--
 common/content.h        |  42 +++---
 common/content_common.c |  94 ++++++-------
 common/content_common.h |   2 +-
 common/content_inode.h  |  88 ++++++-------
 common/dlog.c           | 284 ++++++++++++++++++++--------------------
 common/dlog.h           |  32 ++---
 common/drive.c          | 170 ++++++++++++------------
 common/drive.h          | 126 +++++++++---------
 13 files changed, 539 insertions(+), 539 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index 4043a9d..99b1d00 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -464,7 +464,7 @@ xlate_direnthdr(direnthdr_t *dh1, direnthdr_t *dh2, int dir)
 	     ptr1->dh_gen,
 	     ptr1->dh_checksum,
 	     ptr1->dh_sz,
-	     ptr1->dh_name );
+	     ptr1->dh_name);
 
 	mlog(MLOG_NITTY, "xlate_direnthdr: post-xlate\n"
 	     "\tdh_ino %llu\n"
@@ -476,7 +476,7 @@ xlate_direnthdr(direnthdr_t *dh1, direnthdr_t *dh2, int dir)
 	     ptr2->dh_gen,
 	     ptr2->dh_checksum,
 	     ptr2->dh_sz,
-	     ptr2->dh_name );
+	     ptr2->dh_name);
 }
 
 /*
@@ -510,7 +510,7 @@ xlate_direnthdr_v1(direnthdr_v1_t *dh1, direnthdr_v1_t *dh2, int dir)
 	     ptr1->dh_gen,
 	     ptr1->dh_sz,
 	     ptr1->dh_checksum,
-	     ptr1->dh_name );
+	     ptr1->dh_name);
 
 	mlog(MLOG_NITTY, "xlate_direnthdr_v1: post-xlate\n"
 	     "\tdh_ino %llu\n"
@@ -522,7 +522,7 @@ xlate_direnthdr_v1(direnthdr_v1_t *dh1, direnthdr_v1_t *dh2, int dir)
 	     ptr2->dh_gen,
 	     ptr2->dh_sz,
 	     ptr2->dh_checksum,
-	     ptr2->dh_name );
+	     ptr2->dh_name);
 }
 
 /*
diff --git a/common/cldmgr.c b/common/cldmgr.c
index 2890092..ecd31f8 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -38,7 +38,7 @@
 
 extern size_t pgsz;
 
-#define CLD_MAX	( STREAM_SIMMAX * 2 )
+#define CLD_MAX	(STREAM_SIMMAX * 2)
 
 typedef enum { C_AVAIL, C_ALIVE, C_EXITED } state_t;
 
@@ -47,50 +47,50 @@ struct cld {
 	int c_exit_code;
 	pthread_t c_tid;
 	ix_t c_streamix;
-	int ( * c_entry )( void *arg1 );
+	int (* c_entry)(void *arg1);
 	void * c_arg1;
 };
 
 typedef struct cld cld_t;
 
-static cld_t cld[ CLD_MAX ];
+static cld_t cld[CLD_MAX];
 static bool_t cldmgr_stopflag;
 
-static cld_t *cldmgr_getcld( void );
-static void *cldmgr_entry( void * );
-static void cldmgr_cleanup( void * );
+static cld_t *cldmgr_getcld(void);
+static void *cldmgr_entry(void *);
+static void cldmgr_cleanup(void *);
 /* REFERENCED */
 static pthread_t cldmgr_parenttid;
 
 bool_t
-cldmgr_init( void )
+cldmgr_init(void)
 {
-	( void )memset( ( void * )cld, 0, sizeof( cld ));
+	(void)memset((void *)cld, 0, sizeof(cld));
 	cldmgr_stopflag = BOOL_FALSE;
-	cldmgr_parenttid = pthread_self( );
+	cldmgr_parenttid = pthread_self();
 
 	return BOOL_TRUE;
 }
 
 bool_t
-cldmgr_create( int ( * entry )( void *arg1 ),
+cldmgr_create(int (* entry)(void *arg1),
 	       ix_t streamix,
 	       char *descstr,
-	       void *arg1 )
+	       void *arg1)
 {
 	cld_t *cldp;
 	int rval;
 
-	assert( pthread_equal( pthread_self( ), cldmgr_parenttid ) );
+	assert(pthread_equal(pthread_self(), cldmgr_parenttid));
 
-	cldp = cldmgr_getcld( );
-	if ( ! cldp ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_PROC, _(
+	cldp = cldmgr_getcld();
+	if (! cldp) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_PROC, _(
 		      "cannot create %s thread for stream %u: "
 		      "too many child threads (max allowed is %d)\n"),
 		      descstr,
 		      streamix,
-		      CLD_MAX );
+		      CLD_MAX);
 		return BOOL_FALSE;
 	}
 
@@ -98,26 +98,26 @@ cldmgr_create( int ( * entry )( void *arg1 ),
 	cldp->c_streamix = streamix;
 	cldp->c_entry = entry;
 	cldp->c_arg1 = arg1;
-	rval = pthread_create( &cldp->c_tid, NULL, cldmgr_entry, cldp );
-	if ( rval ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_PROC, _(
+	rval = pthread_create(&cldp->c_tid, NULL, cldmgr_entry, cldp);
+	if (rval) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_PROC, _(
 		      "failed creating %s thread for stream %u: %s\n"),
 		      descstr,
 		      streamix,
-		      strerror( rval ));
+		      strerror(rval));
 	} else {
-		mlog( MLOG_NITTY | MLOG_PROC,
+		mlog(MLOG_NITTY | MLOG_PROC,
 		      "%s thread created for stream %u: tid %lu\n",
 		      descstr,
 		      streamix,
-		      cldp->c_tid );
+		      cldp->c_tid);
 	}
 
 	return rval ? BOOL_FALSE : BOOL_TRUE;
 }
 
 void
-cldmgr_stop( void )
+cldmgr_stop(void)
 {
 	/* must NOT mlog here!
 	 * locked up by main loop dialog
@@ -126,31 +126,31 @@ cldmgr_stop( void )
 }
 
 int
-cldmgr_join( void )
+cldmgr_join(void)
 {
 	cld_t *p = cld;
-	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
+	cld_t *ep = cld + sizeof(cld) / sizeof(cld[0]);
 	int xc = EXIT_NORMAL;
 
 	lock();
-	for ( ; p < ep ; p++ ) {
-		if ( p->c_state == C_EXITED ) {
-			if ( ( int )( p->c_streamix ) >= 0 ) {
-				stream_dead( p->c_tid );
+	for (; p < ep ; p++) {
+		if (p->c_state == C_EXITED) {
+			if ((int)(p->c_streamix) >= 0) {
+				stream_dead(p->c_tid);
 			}
-			pthread_join( p->c_tid, NULL );
-			if ( p->c_exit_code != EXIT_NORMAL && xc != EXIT_FAULT )
+			pthread_join(p->c_tid, NULL);
+			if (p->c_exit_code != EXIT_NORMAL && xc != EXIT_FAULT)
 				xc = p->c_exit_code;
-			if ( p->c_exit_code != EXIT_NORMAL ) {
-				mlog( MLOG_DEBUG | MLOG_PROC | MLOG_NOLOCK,
+			if (p->c_exit_code != EXIT_NORMAL) {
+				mlog(MLOG_DEBUG | MLOG_PROC | MLOG_NOLOCK,
 					"child (thread %lu) requested stop: "
 					"exit code %d (%s)\n",
 					p->c_tid, p->c_exit_code,
-					exit_codestring( p->c_exit_code ));
+					exit_codestring(p->c_exit_code));
 			}
 
 			// reinit this child for reuse
-			memset( ( void * )p, 0, sizeof( cld_t ));
+			memset((void *)p, 0, sizeof(cld_t));
 		}
 	}
 	unlock();
@@ -159,96 +159,96 @@ cldmgr_join( void )
 }
 
 bool_t
-cldmgr_stop_requested( void )
+cldmgr_stop_requested(void)
 {
 	return cldmgr_stopflag;
 }
 
 size_t
-cldmgr_remainingcnt( void )
+cldmgr_remainingcnt(void)
 {
 	cld_t *p = cld;
-	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
+	cld_t *ep = cld + sizeof(cld) / sizeof(cld[0]);
 	size_t cnt;
 
 	cnt = 0;
-	lock( );
-	for ( ; p < ep ; p++ ) {
-		if ( p->c_state == C_ALIVE ) {
+	lock();
+	for (; p < ep ; p++) {
+		if (p->c_state == C_ALIVE) {
 			cnt++;
 		}
 	}
-	unlock( );
+	unlock();
 
 	return cnt;
 }
 
 bool_t
-cldmgr_otherstreamsremain( ix_t streamix )
+cldmgr_otherstreamsremain(ix_t streamix)
 {
 	cld_t *p = cld;
-	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
+	cld_t *ep = cld + sizeof(cld) / sizeof(cld[0]);
 
-	lock( );
-	for ( ; p < ep ; p++ ) {
-		if ( p->c_state == C_ALIVE && p->c_streamix != streamix ) {
-			unlock( );
+	lock();
+	for (; p < ep ; p++) {
+		if (p->c_state == C_ALIVE && p->c_streamix != streamix) {
+			unlock();
 			return BOOL_TRUE;
 		}
 	}
-	unlock( );
+	unlock();
 
 	return BOOL_FALSE;
 }
 
 static cld_t *
-cldmgr_getcld( void )
+cldmgr_getcld(void)
 {
 	cld_t *p = cld;
-	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
+	cld_t *ep = cld + sizeof(cld) / sizeof(cld[0]);
 
 	lock();
-	for ( ; p < ep ; p++ ) {
-		if ( p->c_state == C_AVAIL ) {
+	for (; p < ep ; p++) {
+		if (p->c_state == C_AVAIL) {
 			p->c_state = C_ALIVE;
 			break;
 		}
 	}
 	unlock();
 
-	return ( p < ep ) ? p : 0;
+	return (p < ep) ? p : 0;
 }
 
 static void *
-cldmgr_entry( void *arg1 )
+cldmgr_entry(void *arg1)
 {
-	cld_t *cldp = ( cld_t * )arg1;
-	pthread_t tid = pthread_self( );
+	cld_t *cldp = (cld_t *)arg1;
+	pthread_t tid = pthread_self();
 
-	pthread_cleanup_push( cldmgr_cleanup, arg1 );
+	pthread_cleanup_push(cldmgr_cleanup, arg1);
 
-	if ( ( int )( cldp->c_streamix ) >= 0 ) {
-		stream_register( tid, ( int )cldp->c_streamix );
+	if ((int)(cldp->c_streamix) >= 0) {
+		stream_register(tid, (int)cldp->c_streamix);
 	}
-	mlog( MLOG_DEBUG | MLOG_PROC,
+	mlog(MLOG_DEBUG | MLOG_PROC,
 	      "thread %lu created for stream %d\n",
 	      tid,
-	      cldp->c_streamix );
-	cldp->c_exit_code = ( * cldp->c_entry )( cldp->c_arg1 );
+	      cldp->c_streamix);
+	cldp->c_exit_code = (* cldp->c_entry)(cldp->c_arg1);
 
-	pthread_cleanup_pop( 1 );
+	pthread_cleanup_pop(1);
 
 	return NULL;
 }
 
 static void
-cldmgr_cleanup( void *arg1 )
+cldmgr_cleanup(void *arg1)
 {
-	cld_t *cldp = ( cld_t * )arg1;
+	cld_t *cldp = (cld_t *)arg1;
 
 	lock();
 	cldp->c_state = C_EXITED;
 	// signal the main thread to look for exited threads
-	kill( getpid( ), SIGUSR1 );
+	kill(getpid(), SIGUSR1);
 	unlock();
 }
diff --git a/common/cldmgr.h b/common/cldmgr.h
index c3384fa..ce3a382 100644
--- a/common/cldmgr.h
+++ b/common/cldmgr.h
@@ -24,39 +24,39 @@
 /* cldmgr_init - initializes child management
  * returns FALSE if trouble encountered.
  */
-extern bool_t cldmgr_init( void );
+extern bool_t cldmgr_init(void);
 
 /* cldmgr_create - creates a child thread. returns FALSE if trouble
  * encountered
  */
-extern bool_t cldmgr_create( int ( * entry )( void *arg1 ),
+extern bool_t cldmgr_create(int (* entry)(void *arg1),
 			     ix_t streamix,
 			     char *descstr,
-			     void *arg1 );
+			     void *arg1);
 
 /* cldmgr_stop - asks all children to gracefully terminate, at the next
  * convenient point in their normal processing loop.
  */
-extern void cldmgr_stop( void );
+extern void cldmgr_stop(void);
 
 /* cldmgr_join - join child threads that have exited.
  * returns EXIT_NORMAL if all exited normally (or no threads have exited),
  * EXIT_FAULT if any threads requested a core dump, or another EXIT_*
  * value if any threads exited abnormally.
  */
-extern int cldmgr_join( void );
+extern int cldmgr_join(void);
 
 /* cldmgr_stop_requested - returns TRUE if the child should gracefully
  * terminate.
  */
-extern bool_t cldmgr_stop_requested( void );
+extern bool_t cldmgr_stop_requested(void);
 
 /* cldmgr_remainingcnt - returns number of children remaining
  */
-extern size_t cldmgr_remainingcnt( void );
+extern size_t cldmgr_remainingcnt(void);
 
 /* checks if any children serving any other streams are still alive
  */
-extern bool_t cldmgr_otherstreamsremain( ix_t streamix );
+extern bool_t cldmgr_otherstreamsremain(ix_t streamix);
 
 #endif /* CLDMGR_H */
diff --git a/common/cleanup.c b/common/cleanup.c
index 45339c6..5248f3c 100644
--- a/common/cleanup.c
+++ b/common/cleanup.c
@@ -22,7 +22,7 @@
 #include "cleanup.h"
 
 struct cu {
-	void ( * cu_funcp )( void *arg1, void *arg2 );
+	void (* cu_funcp)(void *arg1, void *arg2);
 	void *cu_arg1;
 	void *cu_arg2;
 	int  cu_flags;
@@ -39,20 +39,20 @@ typedef struct cu cu_t;
 static cu_t *cu_rootp;
 
 void
-cleanup_init( void )
+cleanup_init(void)
 {
 	cu_rootp = 0;
 }
 
 static cleanup_t *
-cleanup_register_base( void ( * funcp )( void *arg1, void *arg2 ),
+cleanup_register_base(void (* funcp)(void *arg1, void *arg2),
 		  void *arg1,
-		  void *arg2 )
+		  void *arg2)
 {
 	cu_t *p;
 
-	p = ( cu_t * )calloc( 1, sizeof( cu_t ));
-	assert( p );
+	p = (cu_t *)calloc(1, sizeof(cu_t));
+	assert(p);
 	p->cu_funcp = funcp;
 	p->cu_arg1 = arg1;
 	p->cu_arg2 = arg2;
@@ -60,85 +60,85 @@ cleanup_register_base( void ( * funcp )( void *arg1, void *arg2 ),
 	p->cu_nextp = cu_rootp;
 	cu_rootp = p;
 
-	return ( cleanup_t *)p;
+	return (cleanup_t *)p;
 }
 
 cleanup_t *
-cleanup_register( void ( * funcp )( void *arg1, void *arg2 ),
+cleanup_register(void (* funcp)(void *arg1, void *arg2),
 		  void *arg1,
-		  void *arg2 )
+		  void *arg2)
 {
 	cu_t *p;
 
-	p = cleanup_register_base( funcp, arg1, arg2 );
+	p = cleanup_register_base(funcp, arg1, arg2);
 
-	return ( cleanup_t *)p;
+	return (cleanup_t *)p;
 }
 
 cleanup_t *
-cleanup_register_early( void ( * funcp )( void *arg1, void *arg2 ),
+cleanup_register_early(void (* funcp)(void *arg1, void *arg2),
 		  void *arg1,
-		  void *arg2 )
+		  void *arg2)
 {
 	cu_t *p;
 
-	p = cleanup_register_base( funcp, arg1, arg2 );
+	p = cleanup_register_base(funcp, arg1, arg2);
 	p->cu_flags = CU_EARLY;
 
-	return ( cleanup_t *)p;
+	return (cleanup_t *)p;
 }
 
 void
-cleanup_cancel( cleanup_t *cleanupp )
+cleanup_cancel(cleanup_t *cleanupp)
 {
-	cu_t *p = ( cu_t *)cleanupp;
+	cu_t *p = (cu_t *)cleanupp;
 	cu_t *nextp;
 	cu_t *prevp;
 
-	assert( cu_rootp );
+	assert(cu_rootp);
 
-	for ( prevp = 0, nextp = cu_rootp
+	for (prevp = 0, nextp = cu_rootp
 	      ;
 	      nextp && nextp != p
 	      ;
-	      prevp = nextp, nextp = nextp->cu_nextp )
+	      prevp = nextp, nextp = nextp->cu_nextp)
 	;
 
-	assert( nextp );
-	if ( prevp ) {
+	assert(nextp);
+	if (prevp) {
 		prevp->cu_nextp = p->cu_nextp;
 	} else {
 		cu_rootp = p->cu_nextp;
 	}
-	free( ( void * )p );
+	free((void *)p);
 }
 
 void
-cleanup( void )
+cleanup(void)
 {
-	while ( cu_rootp ) {
+	while (cu_rootp) {
 		cu_t *p = cu_rootp;
-		( * p->cu_funcp )( p->cu_arg1, p->cu_arg2 );
+		(* p->cu_funcp)(p->cu_arg1, p->cu_arg2);
 		cu_rootp = p->cu_nextp;
-		free( ( void * )p );
+		free((void *)p);
 	}
 }
 
 void
-cleanup_early( void )
+cleanup_early(void)
 {
 	cu_t *cuptr, *cuprevp;
 
 	cuptr = cu_rootp;
 	cuprevp = NULL;
 
-	while ( cuptr ) {
+	while (cuptr) {
 		cu_t *cunextp = cuptr->cu_nextp;
 
-		if ( cuptr->cu_flags & CU_EARLY) {
-			( * cuptr->cu_funcp )( cuptr->cu_arg1, cuptr->cu_arg2 );
-			free( ( void * )cuptr );
-			if ( cuprevp )  {
+		if (cuptr->cu_flags & CU_EARLY) {
+			(* cuptr->cu_funcp)(cuptr->cu_arg1, cuptr->cu_arg2);
+			free((void *)cuptr);
+			if (cuprevp)  {
 				cuprevp->cu_nextp = cunextp;
 			} else {
 				cu_rootp = cunextp;
diff --git a/common/cleanup.h b/common/cleanup.h
index a54f9db..1cf55d9 100644
--- a/common/cleanup.h
+++ b/common/cleanup.h
@@ -24,20 +24,20 @@
 
 typedef void cleanup_t;
 
-extern void cleanup_init( void );
+extern void cleanup_init(void);
 
-extern cleanup_t *cleanup_register( void ( *funcp )( void *arg1, void *arg2 ),
+extern cleanup_t *cleanup_register(void (*funcp)(void *arg1, void *arg2),
 				    void *arg1,
-				    void *arg2 );
+				    void *arg2);
 
 extern cleanup_t *cleanup_register_early(
-				    void ( *funcp )( void *arg1, void *arg2 ),
+				    void (*funcp)(void *arg1, void *arg2),
 				    void *arg1,
-				    void *arg2 );
+				    void *arg2);
 
-extern void cleanup_cancel( cleanup_t *cleanupp );
+extern void cleanup_cancel(cleanup_t *cleanupp);
 
-extern void cleanup( void );
-extern void cleanup_early( void );
+extern void cleanup(void);
+extern void cleanup_early(void);
 
 #endif /* CLEANUP_H */
diff --git a/common/content.h b/common/content.h
index c947474..dd858e0 100644
--- a/common/content.h
+++ b/common/content.h
@@ -32,30 +32,30 @@
  * argument of the co_begin_write() operator will be stuffed into the
  * upper layer info, and extracted for the upper layer by co_begin_read().
  */
-#define CONTENT_HDR_SZ		sizeofmember( media_hdr_t, mh_upper )
+#define CONTENT_HDR_SZ		sizeofmember(media_hdr_t, mh_upper)
 #define CONTENT_HDR_FSTYPE_SZ	16
 #define CONTENT_STATSZ		160 /* must match dlog.h DLOG_MULTI_STATSZ */
 
 struct content_hdr {
-	char ch_mntpnt[ GLOBAL_HDR_STRING_SZ ];		/* 100  100 */
+	char ch_mntpnt[GLOBAL_HDR_STRING_SZ];		/* 100  100 */
 		/* full pathname of fs mount point */
-	char ch_fsdevice[ GLOBAL_HDR_STRING_SZ ];	/* 100  200 */
+	char ch_fsdevice[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
 		/* full pathname of char device containing fs */
 	char  ch_pad1[GLOBAL_HDR_STRING_SZ];		/* 100  300 */
 		/* in case another label is needed */
-	char ch_fstype[ CONTENT_HDR_FSTYPE_SZ ];	/*  10  310 */
+	char ch_fstype[CONTENT_HDR_FSTYPE_SZ];	/*  10  310 */
 		/* from fsid.h */
 	uuid_t ch_fsid;					/*  10  320 */
 		/* file system uuid */
-	char  ch_pad2[ GLOBAL_HDR_UUID_SZ ];		/*  10  330 */
+	char  ch_pad2[GLOBAL_HDR_UUID_SZ];		/*  10  330 */
 		/* in case another id is needed */
-	char ch_pad3[ 8 ];				/*   8  338 */
+	char ch_pad3[8];				/*   8  338 */
 		/* padding */
 	int32_t ch_strategyid;				/*   4  33c */
 		/* ID of the content strategy used to produce this dump */
-	char ch_pad4[ 4 ];				/*   4  340 */
+	char ch_pad4[4];				/*   4  340 */
 		/* alignment */
-	char ch_specific[ 0xc0 ];			/*  c0  400 */
+	char ch_specific[0xc0];			/*  c0  400 */
 		/* content strategy-specific info */
 };
 
@@ -84,13 +84,13 @@ extern bool_t is_quota_file(ino_t ino);
 #endif /* DUMP */
 
 #ifdef DUMP
-extern bool_t content_init( int argc,
-			    char *argv[ ],
-			    global_hdr_t *gwhdrtemplatep );
+extern bool_t content_init(int argc,
+			    char *argv[],
+			    global_hdr_t *gwhdrtemplatep);
 	/* prepares for multi-stream dump
 	 */
 
-extern int content_stream_dump( ix_t strmix );
+extern int content_stream_dump(ix_t strmix);
 	/* does stream dump
 	 */
 
@@ -98,37 +98,37 @@ extern int content_stream_dump( ix_t strmix );
 #ifdef RESTORE
 extern size_t perssz;
 
-extern bool_t content_init( int argc, char *argv[ ], size64_t vmsz );
+extern bool_t content_init(int argc, char *argv[], size64_t vmsz);
 	/* prepares for multi-thread restore
 	 */
 
-extern int content_stream_restore( ix_t thrdix );
+extern int content_stream_restore(ix_t thrdix);
 	/* does thread restore
 	 */
 
-extern bool_t content_overwrite_ok( char *path,
+extern bool_t content_overwrite_ok(char *path,
 				    int32_t ctime,
 				    int32_t mtime,
 				    char **reasonstrp,
-				    bool_t *exists );
+				    bool_t *exists);
 	/* called by tree to ask if ok to overwrite file
 	 */
 
-extern void content_showinv( void );
+extern void content_showinv(void);
 	/* displays inventory of dump session being restored,
 	 * in the context of a second-level dialog
 	 */
 
-extern void content_showremainingobjects( void );
+extern void content_showremainingobjects(void);
 	/* displays info on media objects remaining to be restored.
 	 */
 #endif /* RESTORE */
 
-extern bool_t content_complete( void );
+extern bool_t content_complete(void);
 	/* cleanup: called from main thread. returns TRUE if complete
 	 */
 
-extern size_t content_statline( char **lines[ ] );
+extern size_t content_statline(char **lines[]);
 	/* supplies status line for main keyboard intr dialog
 	 * returns by ref an array of character strings, and the length
 	 * of the array is returned by value.
@@ -138,7 +138,7 @@ extern bool_t content_media_change_needed;
 	/* queried by main thread to decide if interupt dialog needed
 	 * for media change confirmation.
 	 */
-extern char *content_mediachange_query( void );
+extern char *content_mediachange_query(void);
 	/* invoked by main thread sigint dialog to allow operator to
 	 * confirm media changes and ask what media objects remain
 	 */
diff --git a/common/content_common.c b/common/content_common.c
index 8f84e56..78d14ed 100644
--- a/common/content_common.c
+++ b/common/content_common.c
@@ -44,19 +44,19 @@
 #define DLOG_TIMEOUT	3600
 
 bool_t
-Media_prompt_change( drive_t *drivep )
+Media_prompt_change(drive_t *drivep)
 {
 	fold_t fold;
-	char question[ 100 ];
-	char *preamblestr[ PREAMBLEMAX ];
+	char question[100];
+	char *preamblestr[PREAMBLEMAX];
 	size_t preamblecnt;
-	char *querystr[ QUERYMAX ];
+	char *querystr[QUERYMAX];
 	size_t querycnt;
-	char *choicestr[ CHOICEMAX ];
+	char *choicestr[CHOICEMAX];
 	size_t choicecnt;
-	char *ackstr[ ACKMAX ];
+	char *ackstr[ACKMAX];
 	size_t ackcnt;
-	char *postamblestr[ POSTAMBLEMAX ];
+	char *postamblestr[POSTAMBLEMAX];
 	size_t postamblecnt;
 	ix_t doix;
 	ix_t dontix;
@@ -65,31 +65,31 @@ Media_prompt_change( drive_t *drivep )
 
 retry:
 	preamblecnt = 0;
-	fold_init( fold, _("change media dialog"), '=' );
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
+	fold_init(fold, _("change media dialog"), '=');
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
 
 	/* query: ask if media changed or declined
 	 */
-	sprintf( question, _(
+	sprintf(question, _(
 		 "please change media in "
 		 "drive %u\n"),
-		 (unsigned int)drivep->d_index );
+		 (unsigned int)drivep->d_index);
 	querycnt = 0;
-	querystr[ querycnt++ ] = question;
-	assert( querycnt <= QUERYMAX );
+	querystr[querycnt++] = question;
+	assert(querycnt <= QUERYMAX);
 	choicecnt = 0;
 	dontix = choicecnt;
-	choicestr[ choicecnt++ ] = _("media change declined");
+	choicestr[choicecnt++ ] = _("media change declined");
 	doix = choicecnt;
-	choicestr[ choicecnt++ ] = _("media changed");
-	assert( choicecnt <= CHOICEMAX );
+	choicestr[choicecnt++ ] = _("media changed");
+	assert(choicecnt <= CHOICEMAX);
 	sigintix = IXMAX - 1;
 
-	responseix = dlog_multi_query( querystr,
+	responseix = dlog_multi_query(querystr,
 				       querycnt,
 				       choicestr,
 				       choicecnt,
@@ -101,43 +101,43 @@ retry:
 				       dontix,		/* timeout ix */
 				       sigintix,	/* sigint ix */
 				       dontix,		/* sighup ix */
-				       dontix );	/* sigquit ix */
+				       dontix);	/* sigquit ix */
 	ackcnt = 0;
-	if ( responseix == doix ) {
-		ackstr[ ackcnt++ ] = _("examining new media\n");
-	} else if ( responseix == dontix ) {
-		ackstr[ ackcnt++ ] = _("media change aborted\n");
+	if (responseix == doix) {
+		ackstr[ackcnt++ ] = _("examining new media\n");
+	} else if (responseix == dontix) {
+		ackstr[ackcnt++ ] = _("media change aborted\n");
 	} else {
-		assert( responseix == sigintix );
-		ackstr[ ackcnt++ ] = _("keyboard interrupt\n");
+		assert(responseix == sigintix);
+		ackstr[ackcnt++ ] = _("keyboard interrupt\n");
 	}
 
-	assert( ackcnt <= ACKMAX );
-	dlog_multi_ack( ackstr,
-			ackcnt );
+	assert(ackcnt <= ACKMAX);
+	dlog_multi_ack(ackstr,
+			ackcnt);
 
 	postamblecnt = 0;
-	fold_init( fold, _("end dialog"), '-' );
-	postamblestr[ postamblecnt++ ] = "\n";
-	postamblestr[ postamblecnt++ ] = fold;
-	postamblestr[ postamblecnt++ ] = "\n\n";
-	assert( postamblecnt <= POSTAMBLEMAX );
-	dlog_end( postamblestr,
-		  postamblecnt );
+	fold_init(fold, _("end dialog"), '-');
+	postamblestr[postamblecnt++ ] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++ ] = "\n\n";
+	assert(postamblecnt <= POSTAMBLEMAX);
+	dlog_end(postamblestr,
+		  postamblecnt);
 
-	if ( responseix == sigintix ) {
-		if ( cldmgr_stop_requested( )) {
+	if (responseix == sigintix) {
+		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
-		sleep( 1 ); /* to allow main thread to begin dialog */
-		mlog( MLOG_NORMAL | MLOG_BARE,
-		      "" ); /* to block until main thread dialog complete */
-		sleep( 1 ); /* to allow main thread to request children die */
-		if ( cldmgr_stop_requested( )) {
+		sleep(1); /* to allow main thread to begin dialog */
+		mlog(MLOG_NORMAL | MLOG_BARE,
+		      ""); /* to block until main thread dialog complete */
+		sleep(1); /* to allow main thread to request children die */
+		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
-		mlog( MLOG_DEBUG,
-		      "retrying media change dialog\n" );
+		mlog(MLOG_DEBUG,
+		      "retrying media change dialog\n");
 		goto retry;
 	}
 
diff --git a/common/content_common.h b/common/content_common.h
index 368ac0f..3e5d98b 100644
--- a/common/content_common.h
+++ b/common/content_common.h
@@ -18,6 +18,6 @@
 #ifndef CONTENT_COMMON_H
 #define CONTENT_COMMON_H
 
-extern bool_t Media_prompt_change( drive_t *drivep );
+extern bool_t Media_prompt_change(drive_t *drivep);
 
 #endif /* CONTENT_COMMON_H */
diff --git a/common/content_inode.h b/common/content_inode.h
index 38ba2a3..e1885fd 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -34,7 +34,7 @@ struct startpt {
 
 typedef struct startpt startpt_t;
 
-#define STARTPT_FLAGS_END		( 1 << 0 )
+#define STARTPT_FLAGS_END		(1 << 0)
 		/* this startpt indicates that all extents of all files in
 		 * the stream were completely dumped. the other fields
 		 * are meaningless. this will appear only once per dump
@@ -43,7 +43,7 @@ typedef struct startpt startpt_t;
 		 * also used in the strategy-specific portion of the
 		 * content header to qualify the ending point.
 		 */
-#define STARTPT_FLAGS_NULL		( 1 << 1 )
+#define STARTPT_FLAGS_NULL		(1 << 1)
 		/* used to detect if the null file header makes it onto
 		 * media. only necessary after the last file in the stream,
 		 * to allow the end-of-stream flag in the null header to
@@ -63,7 +63,7 @@ typedef struct drange drange_t;
 
 /* inode-style specific media file header section
  */
-#define CONTENT_INODE_HDR_SZ  sizeofmember( content_hdr_t, ch_specific )
+#define CONTENT_INODE_HDR_SZ  sizeofmember(content_hdr_t, ch_specific)
 
 struct content_inode_hdr {
 	int32_t cih_mediafiletype;			/*   4   4 */
@@ -72,7 +72,7 @@ struct content_inode_hdr {
 		/* dump attributes: see #defines below */
 	int32_t cih_level;				/*   4   c */
 		/* dump level */
-	char pad1[ 4 ];					/*   4  10 */
+	char pad1[4];					/*   4  10 */
 		/* alignment */
 	time32_t cih_last_time;				/*   4  14 */
 		/* if an incremental,time of previous dump at a lesser level */
@@ -102,7 +102,7 @@ struct content_inode_hdr {
 
 	uint64_t cih_inomap_datasz;			/*   8  a8 */
 		/* bytes of non-metadata dumped */
-	char cih_pad2[ CONTENT_INODE_HDR_SZ - 0xa8 ];	/*  18  c0 */
+	char cih_pad2[CONTENT_INODE_HDR_SZ - 0xa8];	/*  18  c0 */
 		/* padding */
 };
 
@@ -116,21 +116,21 @@ typedef struct content_inode_hdr content_inode_hdr_t;
 
 /* dump attributes
  */
-#define	CIH_DUMPATTR_SUBTREE			( 1 <<  0 )
-#define	CIH_DUMPATTR_INDEX			( 1 <<  1 )
-#define CIH_DUMPATTR_INVENTORY			( 1 <<  2 )
-#define CIH_DUMPATTR_INCREMENTAL		( 1 <<  3 )
-#define CIH_DUMPATTR_RETRY			( 1 <<  4 )
-#define CIH_DUMPATTR_RESUME			( 1 <<  5 )
-#define CIH_DUMPATTR_INOMAP			( 1 <<  6 )
-#define CIH_DUMPATTR_DIRDUMP			( 1 <<  7 )
-#define CIH_DUMPATTR_FILEHDR_CHECKSUM		( 1 <<  8 )
-#define CIH_DUMPATTR_EXTENTHDR_CHECKSUM		( 1 <<  9 )
-#define CIH_DUMPATTR_DIRENTHDR_CHECKSUM		( 1 << 10 )
-#define CIH_DUMPATTR_DIRENTHDR_GEN		( 1 << 11 )
-#define CIH_DUMPATTR_EXTATTR			( 1 << 12 )
-#define CIH_DUMPATTR_EXTATTRHDR_CHECKSUM	( 1 << 13 )
-#define CIH_DUMPATTR_NOTSELFCONTAINED		( 1 << 14 )
+#define	CIH_DUMPATTR_SUBTREE			(1 <<  0)
+#define	CIH_DUMPATTR_INDEX			(1 <<  1)
+#define CIH_DUMPATTR_INVENTORY			(1 <<  2)
+#define CIH_DUMPATTR_INCREMENTAL		(1 <<  3)
+#define CIH_DUMPATTR_RETRY			(1 <<  4)
+#define CIH_DUMPATTR_RESUME			(1 <<  5)
+#define CIH_DUMPATTR_INOMAP			(1 <<  6)
+#define CIH_DUMPATTR_DIRDUMP			(1 <<  7)
+#define CIH_DUMPATTR_FILEHDR_CHECKSUM		(1 <<  8)
+#define CIH_DUMPATTR_EXTENTHDR_CHECKSUM		(1 <<  9)
+#define CIH_DUMPATTR_DIRENTHDR_CHECKSUM		(1 << 10)
+#define CIH_DUMPATTR_DIRENTHDR_GEN		(1 << 11)
+#define CIH_DUMPATTR_EXTATTR			(1 << 12)
+#define CIH_DUMPATTR_EXTATTRHDR_CHECKSUM	(1 << 13)
+#define CIH_DUMPATTR_NOTSELFCONTAINED		(1 << 14)
 
 
 /* timestruct_t - time structure
@@ -176,10 +176,10 @@ struct bstat {				/*		     bytes accum */
 	uint16_t	bs_projid_lo;	/* low 16 of project id	 2    5a */
 	uint16_t	bs_forkoff;	/* inode fork offset	 2    5c */
 	uint16_t	bs_projid_hi;	/* hi 16 of project id	 2    5e */
-	char		bs_pad[ 10 ];	/* for expansion	 e    68 */
+	char		bs_pad[10];	/* for expansion	 e    68 */
 	uint32_t	bs_dmevmask;	/* DMI event mask        4    6c */
 	uint16_t	bs_dmstate;	/* DMI state info        2    6e */
-	char		bs_pad1[ 18 ];	/* for expansion        12    80 */
+	char		bs_pad1[18];	/* for expansion        12    80 */
 					/* NOTE: old dumps didn't always
 					 * zero first 2 bytes of bs_pad1 */
 };
@@ -201,9 +201,9 @@ bstat_projid(struct bstat *bs)
 /* extended inode flags that can only be set after all data
  * has been restored to a file.
  */
-#define	POST_DATA_XFLAGS	( XFS_XFLAG_IMMUTABLE |		\
+#define	POST_DATA_XFLAGS	(XFS_XFLAG_IMMUTABLE |		\
 				  XFS_XFLAG_APPEND |		\
-				  XFS_XFLAG_SYNC )
+				  XFS_XFLAG_SYNC)
 
 /* filehdr_t - header placed at the beginning of every dumped file.
  *
@@ -218,28 +218,28 @@ struct filehdr {
 	int32_t fh_flags;
 	uint32_t fh_checksum;
 	bstat_t fh_stat;
-	char fh_pad2[ FILEHDR_SZ
-		      - sizeof( int64_t )
-		      - sizeof( int32_t )
-		      - sizeof( uint32_t )
-		      - sizeof( bstat_t ) ];
+	char fh_pad2[FILEHDR_SZ
+		      - sizeof(int64_t)
+		      - sizeof(int32_t)
+		      - sizeof(uint32_t)
+		      - sizeof(bstat_t)];
 };
 
 typedef struct filehdr filehdr_t;
 
-#define FILEHDR_FLAGS_NULL	( 1 << 0 )
+#define FILEHDR_FLAGS_NULL	(1 << 0)
 		/* identifies a dummy file header. every media file
 		 * is terminated with a dummy file header, unless
 		 * terminated by end of media.
 		 */
-#define FILEHDR_FLAGS_CHECKSUM	( 1 << 1 )
+#define FILEHDR_FLAGS_CHECKSUM	(1 << 1)
 		/* indicates the header checksum is valid
 		 */
-#define FILEHDR_FLAGS_END	( 1 << 2 )
+#define FILEHDR_FLAGS_END	(1 << 2)
 		/* the last media file in the stream is always terminated by
 		 * a dummy file header, with this flag set.
 		 */
-#define FILEHDR_FLAGS_EXTATTR	( 1 << 3 )
+#define FILEHDR_FLAGS_EXTATTR	(1 << 3)
 		/* special file header followed by one file's (dir or nondir)
 		 * extended attributes.
 		 */
@@ -261,7 +261,7 @@ struct extenthdr {
 	int32_t eh_type;
 	int32_t eh_flags;
 	uint32_t eh_checksum;
-	char eh_pad[ 4 ];
+	char eh_pad[4];
 };
 
 typedef struct extenthdr extenthdr_t;
@@ -285,7 +285,7 @@ typedef struct extenthdr extenthdr_t;
 		 * hole extent length.
 		 */
 
-#define EXTENTHDR_FLAGS_CHECKSUM	( 1 << 0 )
+#define EXTENTHDR_FLAGS_CHECKSUM	(1 << 0)
 
 
 /* direnthdr_t - placed at the beginning of every dumped directory entry.
@@ -309,7 +309,7 @@ struct direnthdr {
 	gen_t dh_gen;
 	uint32_t dh_checksum;
 	uint16_t dh_sz; /* overall size of record */
-	char dh_name[ 6 ];
+	char dh_name[6];
 };
 
 typedef struct direnthdr direnthdr_t;
@@ -323,7 +323,7 @@ struct direnthdr_v1 {
 	uint16_t dh_gen; /* generation count & DENTGENMASK of ref'ed inode */
 	uint16_t dh_sz; /* overall size of record */
 	uint32_t dh_checksum;
-	char dh_name[ 8 ];
+	char dh_name[8];
 };
 
 typedef struct direnthdr_v1 direnthdr_v1_t;
@@ -331,8 +331,8 @@ typedef struct direnthdr_v1 direnthdr_v1_t;
 /* truncated generation count
  */
 #define DENTGENSZ		12	/* leave 4 bits for future flags */
-#define DENTGENMASK		(( 1 << DENTGENSZ ) - 1 )
-#define BIGGEN2GEN( bg )	( ( gen_t )( bg & DENTGENMASK ))
+#define DENTGENMASK		((1 << DENTGENSZ) - 1)
+#define BIGGEN2GEN(bg)	((gen_t)(bg & DENTGENMASK))
 
 
 
@@ -362,21 +362,21 @@ struct extattrhdr {
 
 typedef struct extattrhdr extattrhdr_t;
 
-#define EXTATTRHDR_FLAGS_ROOT		( 1 << 0 )
+#define EXTATTRHDR_FLAGS_ROOT		(1 << 0)
 	/* a "root" mode attribute
 	 */
-#define EXTATTRHDR_FLAGS_NULL		( 1 << 1 )
+#define EXTATTRHDR_FLAGS_NULL		(1 << 1)
 	/* marks the end of the attributes associated with the leading filehdr_t
 	 */
-#define EXTATTRHDR_FLAGS_OLD_CHECKSUM	( 1 << 2 )
+#define EXTATTRHDR_FLAGS_OLD_CHECKSUM	(1 << 2)
 	/* old xfsdumps used this flag to indicate a checksum is present,
 	 * but the checksum was not calculated properly. the presence of
 	 * this flag now indicates a checksum that cannot be verified.
 	 */
-#define EXTATTRHDR_FLAGS_SECURE		( 1 << 3 )
+#define EXTATTRHDR_FLAGS_SECURE		(1 << 3)
 	/* a linux "secure" mode attribute
 	 */
-#define EXTATTRHDR_FLAGS_CHECKSUM	( 1 << 4 )
+#define EXTATTRHDR_FLAGS_CHECKSUM	(1 << 4)
 	/* checksum is present.
 	 */
 
diff --git a/common/dlog.c b/common/dlog.c
index 77364a3..3626568 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -42,7 +42,7 @@ static char *promptstr = " -> ";
 
 static sigset_t dlog_registered_sigs;
 
-static bool_t promptinput( char *buf,
+static bool_t promptinput(char *buf,
 			   size_t bufsz,
 			   ix_t *exceptionixp,
 			   time32_t timeout,
@@ -50,17 +50,17 @@ static bool_t promptinput( char *buf,
 			   ix_t sigintix,
 			   ix_t sighupix,
 			   ix_t sigquitix,
-			   char *fmt, ... );
-static void dlog_string_query_print( void *ctxp, char *fmt, ... );
+			   char *fmt, ...);
+static void dlog_string_query_print(void *ctxp, char *fmt, ...);
 
 bool_t
-dlog_init( int argc, char *argv[ ] )
+dlog_init(int argc, char *argv[])
 {
 	int c;
 
 	/* can only call once
 	 */
-	assert( dlog_ttyfd == -1 );
+	assert(dlog_ttyfd == -1);
 
 	/* initially allow dialog, use stdin fd
 	 */
@@ -68,15 +68,15 @@ dlog_init( int argc, char *argv[ ] )
 	dlog_allowed_flag = BOOL_TRUE;
 	dlog_timeouts_flag = BOOL_TRUE;
 
-	sigemptyset( &dlog_registered_sigs );
+	sigemptyset(&dlog_registered_sigs);
 
 	/* look for command line option claiming the operator knows
 	 * what's up.
 	 */
 	optind = 1;
 	opterr = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_FORCE:
 			dlog_ttyfd = -1;
 			dlog_allowed_flag = BOOL_FALSE;
@@ -90,9 +90,9 @@ dlog_init( int argc, char *argv[ ] )
 	/* look to see if restore source coming in on
 	 * stdin. If so , try to open /dev/tty for dialogs.
 	 */
-	if ( optind < argc && ! strcmp( argv[ optind ], "-" )) {
-		dlog_ttyfd = open( "/dev/tty", O_RDWR );
-		if ( dlog_ttyfd < 0 ) {
+	if (optind < argc && ! strcmp(argv[optind ], "-")) {
+		dlog_ttyfd = open("/dev/tty", O_RDWR);
+		if (dlog_ttyfd < 0) {
 			perror("/dev/tty");
 			dlog_ttyfd = -1;
 			dlog_allowed_flag = BOOL_FALSE;
@@ -103,22 +103,22 @@ dlog_init( int argc, char *argv[ ] )
 #ifdef CHKSTDIN
 	/* if stdin is not a tty, don't allow dialogs
 	 */
-	if ( dlog_allowed_flag ) {
+	if (dlog_allowed_flag) {
 		struct stat statbuf;
 		int rval;
 
-		assert( dlog_ttyfd >= 0 );
-		rval = fstat( dlog_ttyfd, &statbuf );
-		if ( rval ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING,
+		assert(dlog_ttyfd >= 0);
+		rval = fstat(dlog_ttyfd, &statbuf);
+		if (rval) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING,
 			      _("could not fstat stdin (fd %d): %s (%d)\n"),
 			      dlog_ttyfd,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 		} else {
-			mlog( MLOG_DEBUG,
+			mlog(MLOG_DEBUG,
 			      "stdin mode 0x%x\n",
-			      statbuf.st_mode );
+			      statbuf.st_mode);
 		}
 	}
 #endif /* CHKSTDIN */
@@ -127,51 +127,51 @@ dlog_init( int argc, char *argv[ ] )
 }
 
 bool_t
-dlog_allowed( void )
+dlog_allowed(void)
 {
 	return dlog_allowed_flag;
 }
 
 void
-dlog_desist( void )
+dlog_desist(void)
 {
 	dlog_allowed_flag = BOOL_FALSE;
 }
 
 int
-dlog_fd( void )
+dlog_fd(void)
 {
 	return dlog_ttyfd;
 }
 
 void
-dlog_begin( char *preamblestr[ ], size_t preamblecnt )
+dlog_begin(char *preamblestr[], size_t preamblecnt)
 {
 	size_t ix;
 
-	mlog_lock( );
-	for ( ix = 0 ; ix < preamblecnt ; ix++ ) {
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-		      preamblestr[ ix ] );
+	mlog_lock();
+	for (ix = 0 ; ix < preamblecnt ; ix++) {
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		      preamblestr[ix]);
 	}
 }
 
 void
-dlog_end( char *postamblestr[ ], size_t postamblecnt )
+dlog_end(char *postamblestr[], size_t postamblecnt)
 {
 	size_t ix;
 
-	for ( ix = 0 ; ix < postamblecnt ; ix++ ) {
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-		      postamblestr[ ix ] );
+	for (ix = 0 ; ix < postamblecnt ; ix++) {
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		      postamblestr[ix]);
 	}
-	mlog_unlock( );
+	mlog_unlock();
 }
 
 ix_t
-dlog_multi_query( char *querystr[ ],
+dlog_multi_query(char *querystr[],
 		  size_t querycnt,
-		  char *choicestr[ ],
+		  char *choicestr[],
 		  size_t choicecnt,
 		  char *hilitestr,
 		  size_t hiliteix,
@@ -181,64 +181,64 @@ dlog_multi_query( char *querystr[ ],
 		  ix_t timeoutix,
 		  ix_t sigintix,
 		  ix_t sighupix,
-		  ix_t sigquitix )
+		  ix_t sigquitix)
 {
 	size_t ix;
-	char buf[ 100 ];
+	char buf[100];
 	char *prepromptstr;
 
 	/* sanity
 	 */
-	assert( dlog_allowed_flag );
+	assert(dlog_allowed_flag);
 
 	/* display query description strings
 	 */
-	for ( ix = 0 ; ix < querycnt ; ix++ ) {
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-		      querystr[ ix ] );
+	for (ix = 0 ; ix < querycnt ; ix++) {
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		      querystr[ix]);
 	}
 
 	/* display the choices: NOTE: display is 1-based, code intfs 0-based!
 	 */
-	for ( ix = 0 ; ix < choicecnt ; ix++ ) {
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+	for (ix = 0 ; ix < choicecnt ; ix++) {
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 		      "%u: %s",
 		      ix + 1,
-		      choicestr[ ix ] );
-		if ( ix == hiliteix ) {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		      choicestr[ix]);
+		if (ix == hiliteix) {
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 			      "%s",
-			      hilitestr ?  hilitestr : " *" );
+			      hilitestr ?  hilitestr : " *");
 		}
-		if ( ix == defaultix ) {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		if (ix == defaultix) {
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 			      "%s",
-			      defaultstr ?  defaultstr : _(" (default)") );
+			      defaultstr ?  defaultstr : _(" (default)"));
 		}
-		if ( dlog_timeouts_flag
+		if (dlog_timeouts_flag
 		     &&
 		     timeoutix != IXMAX
 		     &&
-		     ix == timeoutix ) {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		     ix == timeoutix) {
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 			      _(" (timeout in %u sec)"),
-			      timeout );
+			      timeout);
 		}
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-		      "\n" );
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		      "\n");
 	}
 
 	/* read the tty until we get a proper answer or are interrupted
 	 */
 	prepromptstr = "";
-	for ( ; ; ) {
+	for (; ;) {
 		ix_t exceptionix;
 		bool_t ok;
 
 		/* prompt and accept input
 		 */
-		ok = promptinput( buf,
-				  sizeof( buf ),
+		ok = promptinput(buf,
+				  sizeof(buf),
 				  &exceptionix,
 				  timeout,
 				  timeoutix,
@@ -246,17 +246,17 @@ dlog_multi_query( char *querystr[ ],
 				  sighupix,
 				  sigquitix,
 				  prepromptstr,
-				  choicecnt );
-		if ( ok ) {
+				  choicecnt);
+		if (ok) {
 			long int val;
 			char *end = buf;
 
-			if ( ! strlen( buf )) {
+			if (! strlen(buf)) {
 				return defaultix;
 			}
 
-			val = strtol( buf, &end, 10 );
-			if ( *end != '\0' || val < 1 || val > choicecnt ) {
+			val = strtol(buf, &end, 10);
+			if (*end != '\0' || val < 1 || val > choicecnt) {
 				prepromptstr = _(
 				      "please enter a value "
 				      "between 1 and %d inclusive ");
@@ -271,18 +271,18 @@ dlog_multi_query( char *querystr[ ],
 }
 
 void
-dlog_multi_ack( char *ackstr[ ], size_t ackcnt )
+dlog_multi_ack(char *ackstr[], size_t ackcnt)
 {
 	size_t ix;
 
-	for ( ix = 0 ; ix < ackcnt ; ix++ ) {
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-		      ackstr[ ix ] );
+	for (ix = 0 ; ix < ackcnt ; ix++) {
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		      ackstr[ix]);
 	}
 }
 
 ix_t
-dlog_string_query( dlog_ucbp_t ucb, /* user's print func */
+dlog_string_query(dlog_ucbp_t ucb, /* user's print func */
 		   void *uctxp,	  /* user's context for above */
 		   char *bufp,	  /* typed string returned in */
 		   size_t bufsz,	  /* buffer size */
@@ -291,35 +291,35 @@ dlog_string_query( dlog_ucbp_t ucb, /* user's print func */
 		   ix_t sigintix,
 		   ix_t sighupix,
 		   ix_t sigquitix,
-		   ix_t okix )
+		   ix_t okix)
 {
 	ix_t exceptionix;
 	bool_t ok;
 
 	/* sanity
 	 */
-	assert( dlog_allowed_flag );
+	assert(dlog_allowed_flag);
 
 	/* call the caller's callback with his context, print context, and
 	 * print operator
 	 */
-	( * ucb )( uctxp, dlog_string_query_print, 0 );
+	(* ucb)(uctxp, dlog_string_query_print, 0);
 
 	/* if called for, print the timeout and a newline.
 	 * if not, print just a newline
 	 */
-	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+	if (dlog_timeouts_flag && timeoutix != IXMAX) {
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 		      _(" (timeout in %u sec)\n"),
-		      timeout );
+		      timeout);
 	} else {
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-		      "\n" );
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+		      "\n");
 	}
 
 	/* prompt and accept input
 	 */
-	ok = promptinput( bufp,
+	ok = promptinput(bufp,
 			  bufsz,
 			  &exceptionix,
 			  timeout,
@@ -327,8 +327,8 @@ dlog_string_query( dlog_ucbp_t ucb, /* user's print func */
 			  sigintix,
 			  sighupix,
 			  sigquitix,
-			  "" );
-	if ( ok ) {
+			  "");
+	if (ok) {
 		return okix;
 	} else {
 		return exceptionix;
@@ -336,9 +336,9 @@ dlog_string_query( dlog_ucbp_t ucb, /* user's print func */
 }
 
 void
-dlog_string_ack( char *ackstr[ ], size_t ackcnt )
+dlog_string_ack(char *ackstr[], size_t ackcnt)
 {
-	dlog_multi_ack( ackstr, ackcnt );
+	dlog_multi_ack(ackstr, ackcnt);
 }
 
 /* ok that this is a static, since used under mutual exclusion lock
@@ -346,31 +346,31 @@ dlog_string_ack( char *ackstr[ ], size_t ackcnt )
 static volatile int dlog_signo_received;
 
 bool_t
-dlog_sighandler( int signo )
+dlog_sighandler(int signo)
 {
-	if ( sigismember( &dlog_registered_sigs, signo ) < 1 )
+	if (sigismember(&dlog_registered_sigs, signo) < 1)
 		return BOOL_FALSE;
 	// only process the first signal
-	sigemptyset( &dlog_registered_sigs );
+	sigemptyset(&dlog_registered_sigs);
 	dlog_signo_received = signo;
 	return BOOL_TRUE;
 }
 
 /* ARGSUSED */
 static void
-dlog_string_query_print( void *ctxp, char *fmt, ... )
+dlog_string_query_print(void *ctxp, char *fmt, ...)
 {
 	va_list args;
 
-	assert( ! ctxp );
+	assert(! ctxp);
 
-	va_start( args, fmt );
-	mlog_va( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, fmt, args );
-	va_end( args );
+	va_start(args, fmt);
+	mlog_va(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, fmt, args);
+	va_end(args);
 }
 
 static bool_t
-promptinput( char *buf,
+promptinput(char *buf,
 	     size_t bufsz,
 	     ix_t *exceptionixp,
 	     time32_t timeout,
@@ -379,34 +379,34 @@ promptinput( char *buf,
 	     ix_t sighupix,
 	     ix_t sigquitix,
 	     char *fmt,
-	     ... )
+	     ...)
 {
 	va_list args;
-	time32_t now = time( NULL );
+	time32_t now = time(NULL);
 	int nread = -1;
 	sigset_t orig_set;
 	char *bufp = buf;
 
 	/* display the pre-prompt
 	 */
-	va_start( args, fmt );
-	mlog_va( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, fmt, args );
-	va_end( args );
+	va_start(args, fmt);
+	mlog_va(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, fmt, args);
+	va_end(args);
 
 	/* display standard prompt
 	 */
 #ifdef NOTYET
-	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
-		mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+	if (dlog_timeouts_flag && timeoutix != IXMAX) {
+		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 		      _("(timeout in %d sec)"),
-		      timeout );
+		      timeout);
 	}
 #endif /* NOTYET */
-	mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, promptstr );
+	mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, promptstr);
 
 	/* set up timeout
 	 */
-	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
+	if (dlog_timeouts_flag && timeoutix != IXMAX) {
 		timeout += now;
 	} else {
 		timeout = TIMEMAX;
@@ -421,19 +421,19 @@ promptinput( char *buf,
 	 * signals.
 	 */
 	dlog_signo_received = -1;
-	sigemptyset( &dlog_registered_sigs );
-	if ( sigintix != IXMAX ) {
-		sigaddset( &dlog_registered_sigs, SIGINT );
+	sigemptyset(&dlog_registered_sigs);
+	if (sigintix != IXMAX) {
+		sigaddset(&dlog_registered_sigs, SIGINT);
 	}
-	if ( sighupix != IXMAX ) {
-		sigaddset( &dlog_registered_sigs, SIGHUP );
-		sigaddset( &dlog_registered_sigs, SIGTERM );
+	if (sighupix != IXMAX) {
+		sigaddset(&dlog_registered_sigs, SIGHUP);
+		sigaddset(&dlog_registered_sigs, SIGTERM);
 	}
-	if ( sigquitix != IXMAX ) {
-		sigaddset( &dlog_registered_sigs, SIGQUIT );
+	if (sigquitix != IXMAX) {
+		sigaddset(&dlog_registered_sigs, SIGQUIT);
 	}
 
-	pthread_sigmask( SIG_UNBLOCK, &dlog_registered_sigs, &orig_set );
+	pthread_sigmask(SIG_UNBLOCK, &dlog_registered_sigs, &orig_set);
 
 	/* wait for input, timeout, or interrupt.
 	 * note we come out of the select() frequently in order to
@@ -441,28 +441,28 @@ promptinput( char *buf,
 	 * the main thread, so we can't rely on the signal waking us
 	 * up from the select().
 	 */
-	while ( now < timeout && dlog_signo_received == -1 && dlog_allowed_flag ) {
+	while (now < timeout && dlog_signo_received == -1 && dlog_allowed_flag) {
 		int rc;
 		fd_set rfds;
 		struct timeval tv = { 0, 100000 }; // 100 ms
 
-		FD_ZERO( &rfds );
-		FD_SET( dlog_ttyfd, &rfds );
+		FD_ZERO(&rfds);
+		FD_SET(dlog_ttyfd, &rfds);
 
-		rc = select( dlog_ttyfd + 1, &rfds, NULL, NULL, &tv );
-		if ( rc > 0 && FD_ISSET( dlog_ttyfd, &rfds ) ) {
-			nread = read( dlog_ttyfd, bufp, bufsz );
-			if ( nread < 0 ) {
+		rc = select(dlog_ttyfd + 1, &rfds, NULL, NULL, &tv);
+		if (rc > 0 && FD_ISSET(dlog_ttyfd, &rfds)) {
+			nread = read(dlog_ttyfd, bufp, bufsz);
+			if (nread < 0) {
 				break; // error handled below
-			} else if ( nread == 0 && buf == bufp ) {
-				mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, "\n" );
+			} else if (nread == 0 && buf == bufp) {
+				mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, "\n");
 				*bufp = 0;
 				break; // no input, return an empty string
-			} else if ( nread > 0 && bufp[nread-1] == '\n' ) {
+			} else if (nread > 0 && bufp[nread-1] == '\n') {
 				// received a full line, chomp the newline
 				bufp[nread-1] = 0;
 				break;
-			} else if ( nread == bufsz ) {
+			} else if (nread == bufsz) {
 				// no more room, truncate and return
 				bufp[nread-1] = 0;
 				break;
@@ -473,47 +473,47 @@ promptinput( char *buf,
 			bufsz -= nread;
 			nread = -1;
 		}
-		now = time( NULL );
+		now = time(NULL);
 	}
 
 	/* restore signal handling
 	 */
-	pthread_sigmask( SIG_SETMASK, &orig_set, NULL );
-	sigemptyset( &dlog_registered_sigs );
+	pthread_sigmask(SIG_SETMASK, &orig_set, NULL);
+	sigemptyset(&dlog_registered_sigs);
 
 	/* check for timeout or interrupt
 	 */
-	if ( nread < 0 ) {
-		if ( now >= timeout ) {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-			      _("timeout\n") );
+	if (nread < 0) {
+		if (now >= timeout) {
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+			      _("timeout\n"));
 			*exceptionixp = timeoutix;
-		} else if ( dlog_signo_received == SIGINT ) {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-			      _("keyboard interrupt\n") );
+		} else if (dlog_signo_received == SIGINT) {
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+			      _("keyboard interrupt\n"));
 			mlog_exit_hint(RV_KBD_INTR);
 			*exceptionixp = sigintix;
-		} else if ( dlog_signo_received == SIGHUP ) {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-			      _("hangup\n") );
+		} else if (dlog_signo_received == SIGHUP) {
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+			      _("hangup\n"));
 			*exceptionixp = sighupix;
-		} else if ( dlog_signo_received == SIGTERM ) {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-			      _("terminate\n") );
+		} else if (dlog_signo_received == SIGTERM) {
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+			      _("terminate\n"));
 			*exceptionixp = sighupix;
-		} else if ( dlog_signo_received == SIGQUIT ) {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-			      _("keyboard quit\n") );
+		} else if (dlog_signo_received == SIGQUIT) {
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+			      _("keyboard quit\n"));
 			mlog_exit_hint(RV_KBD_INTR);
 			*exceptionixp = sigquitix;
 		} else {
-			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
+			mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 			      _("abnormal dialog termination\n"));
 			*exceptionixp = sigquitix;
 		}
 		return BOOL_FALSE;
 	} else {
-		assert( dlog_signo_received == -1 );
+		assert(dlog_signo_received == -1);
 		*exceptionixp = 0;
 		return BOOL_TRUE;
 	}
diff --git a/common/dlog.h b/common/dlog.h
index 31ed9c2..7f0e41d 100644
--- a/common/dlog.h
+++ b/common/dlog.h
@@ -23,41 +23,41 @@
  * abstracts dialogs with the operator
  */
 
-extern bool_t dlog_init( int argc, char *argv[ ] );
+extern bool_t dlog_init(int argc, char *argv[]);
 
 
 /* tells if dialogs are allowed;
  * will be false if invoked to right of unnamed pipe,
  * or if pipe to left breaks.
  */
-extern bool_t dlog_allowed( void );
+extern bool_t dlog_allowed(void);
 
 
 /* allows signal handler to notify dlog of broken write pipe
  */
-extern void dlog_desist( void );
+extern void dlog_desist(void);
 
 /* returns the dialog tty file descriptor. returns -1 if none
  */
-extern int dlog_fd( void );
+extern int dlog_fd(void);
 
 /* returns BOOL_TRUE if a dialog consumed the given signal
  */
-extern bool_t dlog_sighandler( int signo );
+extern bool_t dlog_sighandler(int signo);
 
 /* bracket a dialog session
  */
-extern void dlog_begin( char *preamblestr[ ], size_t preamblecnt );
-extern void dlog_end( char *postamblestr[ ], size_t postamblecnt );
+extern void dlog_begin(char *preamblestr[], size_t preamblecnt);
+extern void dlog_end(char *postamblestr[], size_t postamblecnt);
 
 
 /* multiple choice question abstraction. if any exception event index
  * set to IXMAX, that event will be ignored. returns index of selected
  * choice, or exception index if exception occured.
  */
-extern ix_t dlog_multi_query( char *querystr[ ],	/* pre-choices output */
+extern ix_t dlog_multi_query(char *querystr[],	/* pre-choices output */
 			      size_t querycnt,		/* length of above */
-			      char *choicestr[ ],	/* choices */
+			      char *choicestr[],	/* choices */
 			      size_t choicecnt,		/* length of above */
 			      char *hilitestr,		/* to distinguish */
 			      ix_t hiliteix,		/* highlighted choice */
@@ -67,8 +67,8 @@ extern ix_t dlog_multi_query( char *querystr[ ],	/* pre-choices output */
 			      ix_t timeoutix,		/* return if timeout */
 			      ix_t sigintix,		/* return if SIGINT */
 			      ix_t sighupix,		/* return if SIGHUP */
-			      ix_t sigquitix );		/* return if SIGQUIT */
-extern void dlog_multi_ack( char *ackstr[ ], size_t ackcnt );
+			      ix_t sigquitix);		/* return if SIGQUIT */
+extern void dlog_multi_ack(char *ackstr[], size_t ackcnt);
 
 /* call the caller's callback to display whatever, using provided print
  * function, then prompt for and return an arbitrary string. two types
@@ -78,9 +78,9 @@ extern void dlog_multi_ack( char *ackstr[ ], size_t ackcnt );
  * received, sigquitix if SIGQUIT received. if any of the exception indices
  * are set to IXMAX by the caller, those events will be ignored.
  */
-typedef void ( * dlog_pcbp_t )( void *pctxp, char *s, ... );
-typedef void ( * dlog_ucbp_t )( void *uctxp, dlog_pcbp_t pcb, void *pctxp );
-extern ix_t dlog_string_query( dlog_ucbp_t ucb, /* user's print func */
+typedef void (* dlog_pcbp_t)(void *pctxp, char *s, ...);
+typedef void (* dlog_ucbp_t)(void *uctxp, dlog_pcbp_t pcb, void *pctxp);
+extern ix_t dlog_string_query(dlog_ucbp_t ucb, /* user's print func */
 			       void *uctxp,	/* user's context for above */
 			       char *bufp,	/* typed string returned in */
 			       size_t bufsz,	/* buffer size */
@@ -89,7 +89,7 @@ extern ix_t dlog_string_query( dlog_ucbp_t ucb, /* user's print func */
 			       ix_t sigintix,	/* return if SIGINT */
 			       ix_t sighupix,	/* return if SIGHUP */
 			       ix_t sigquitix,  /* return if SIGQUIT */
-			       ix_t okix );     /* return if successful */
-extern void dlog_string_ack( char *ackstr[ ], size_t ackcnt );
+			       ix_t okix);     /* return if successful */
+extern void dlog_string_ack(char *ackstr[], size_t ackcnt);
 
 #endif /* DLOG_H */
diff --git a/common/drive.c b/common/drive.c
index edb63c0..b01b916 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -44,7 +44,7 @@
 
 /* declarations of externally defined global symbols *************************/
 
-extern void usage( void );
+extern void usage(void);
 extern char *homedir;
 
 /* declare all drive strategies here
@@ -56,10 +56,10 @@ extern drive_strategy_t drive_strategy_rmt;
 
 /* forward declarations of locally defined static functions ******************/
 
-static drive_t *drive_alloc( char *, size_t );
-static void drive_allochdrs( drive_t *drivep,
+static drive_t *drive_alloc(char *, size_t);
+static void drive_allochdrs(drive_t *drivep,
 			     global_hdr_t *gwhdrtemplatep,
-			     ix_t driveix );
+			     ix_t driveix);
 
 
 /* definition of locally defined global variables ****************************/
@@ -85,22 +85,22 @@ static drive_strategy_t *strategypp[] = {
  * specified on the command line.
  */
 bool_t
-drive_init1( int argc, char *argv[ ] )
+drive_init1(int argc, char *argv[])
 {
 	int c;
 	ix_t driveix;
 
 	/* sanity check asserts
 	 */
-	assert( sizeof( drive_hdr_t ) == DRIVE_HDR_SZ );
+	assert(sizeof(drive_hdr_t) == DRIVE_HDR_SZ);
 
 	/* count drive arguments
 	 */
 	optind = 1;
 	opterr = 0;
 	drivecnt = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_DUMPDEST:
 			drivecnt++;
 			break;
@@ -110,8 +110,8 @@ drive_init1( int argc, char *argv[ ] )
 	/* allocate an array to hold ptrs to drive descriptors
 	 */
 	if (drivecnt > 0) {
-		drivepp = ( drive_t ** )calloc( drivecnt, sizeof( drive_t * ));
-		assert( drivepp );
+		drivepp = (drive_t **)calloc(drivecnt, sizeof(drive_t *));
+		assert(drivepp);
 	}
 
 	/* initialize the partialmax value.  Each drive can be completing a file
@@ -128,33 +128,33 @@ drive_init1( int argc, char *argv[ ] )
 	optind = 1;
 	opterr = 0;
 	driveix = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_DUMPDEST:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL,
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL,
 				      _("-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 
 			/* allocate a drive descriptor
 			 */
-			drivepp[ driveix ] = drive_alloc( optarg, driveix );
+			drivepp[driveix] = drive_alloc(optarg, driveix);
 			driveix++;
 			break;
 		}
 	}
-	assert( driveix == drivecnt );
+	assert(driveix == drivecnt);
 
 	/* the user may specify stdin as the source, by
 	 * a single dash ('-') with no option letter. This must appear
 	 * between all lettered arguments and the file system pathname.
 	 */
-	if ( optind < argc && ! strcmp( argv[ optind ], "-" )) {
-		if ( driveix > 0 ) {
-			mlog( MLOG_NORMAL,
+	if (optind < argc && ! strcmp(argv[optind ], "-")) {
+		if (driveix > 0) {
+			mlog(MLOG_NORMAL,
 #ifdef DUMP
 			_("cannot specify source files and stdout together\n")
 #endif /* DUMP */
@@ -162,7 +162,7 @@ drive_init1( int argc, char *argv[ ] )
 			_("cannot specify source files and stdin together\n")
 #endif /* RESTORE */
 			      );
-			usage( );
+			usage();
 			return BOOL_FALSE;
 		}
 
@@ -172,20 +172,20 @@ drive_init1( int argc, char *argv[ ] )
 		 * Bug #393618 - prasadb 04/16/97
 		 * allocate an array to hold ptrs to drive descriptors
 		 */
-		drivepp = ( drive_t ** )calloc( drivecnt, sizeof( drive_t * ));
-		assert( drivepp );
+		drivepp = (drive_t **)calloc(drivecnt, sizeof(drive_t *));
+		assert(drivepp);
 
-		drivepp[ 0 ] = drive_alloc( "stdio", 0 );
+		drivepp[0 ] = drive_alloc("stdio", 0);
 
 #ifdef DUMP   /* ifdef added around dlog_desist() by prasadb to fix 435626 */
-		dlog_desist( );
+		dlog_desist();
 #endif
 	}
 
 	/* verify that some dump destination(s) / restore source(s) specified
 	 */
-	if ( drivecnt == 0 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR,
+	if (drivecnt == 0) {
+		mlog(MLOG_NORMAL | MLOG_ERROR,
 #ifdef DUMP
 			_("no destination file(s) specified\n")
 #endif /* DUMP */
@@ -193,43 +193,43 @@ drive_init1( int argc, char *argv[ ] )
 			_("no source file(s) specified\n")
 #endif /* RESTORE */
 			);
-		usage( );
+		usage();
 		return BOOL_FALSE;
 	}
 
 	/* run each drive past each strategy, pick the best match
 	 * and instantiate a drive manager.
 	 */
-	for ( driveix = 0 ; driveix < drivecnt ; driveix++ ) {
-		drive_t *drivep = drivepp[ driveix ];
+	for (driveix = 0 ; driveix < drivecnt ; driveix++) {
+		drive_t *drivep = drivepp[driveix];
 		int bestscore = 0 - INTGENMAX;
 		ix_t six;
-		ix_t scnt = sizeof( strategypp ) / sizeof( strategypp[ 0 ] );
+		ix_t scnt = sizeof(strategypp) / sizeof(strategypp[0]);
 		drive_strategy_t *bestsp = 0;
 		bool_t ok;
 
-		for ( six = 0 ; six < scnt ; six++ ) {
-			drive_strategy_t *sp = strategypp[ six ];
+		for (six = 0 ; six < scnt ; six++) {
+			drive_strategy_t *sp = strategypp[six];
 			int score;
-			score = ( * sp->ds_match )( argc,
+			score = (* sp->ds_match)(argc,
 						    argv,
-						    drivep );
-			if ( ! bestsp || score > bestscore ) {
+						    drivep);
+			if (! bestsp || score > bestscore) {
 				bestsp = sp;
 				bestscore = score;
 			}
 		}
-		assert( bestsp );
+		assert(bestsp);
 		drivep->d_strategyp = bestsp;
 		drivep->d_recmarksep = bestsp->ds_recmarksep;
 		drivep->d_recmfilesz = bestsp->ds_recmfilesz;
-		mlog( MLOG_VERBOSE,
+		mlog(MLOG_VERBOSE,
 		      _("using %s strategy\n"),
-		      bestsp->ds_description );
-		ok = ( * bestsp->ds_instantiate )( argc,
+		      bestsp->ds_description);
+		ok = (* bestsp->ds_instantiate)(argc,
 						   argv,
-						   drivep );
-		if ( ! ok ) {
+						   drivep);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 	}
@@ -245,19 +245,19 @@ drive_init1( int argc, char *argv[ ] )
  */
 /* ARGSUSED */
 bool_t
-drive_init2( int argc,
-	     char *argv[ ],
-	     global_hdr_t *gwhdrtemplatep )
+drive_init2(int argc,
+	     char *argv[],
+	     global_hdr_t *gwhdrtemplatep)
 {
 	ix_t driveix;
 
-	for ( driveix = 0 ; driveix < drivecnt ; driveix++ ) {
-		drive_t *drivep = drivepp[ driveix ];
+	for (driveix = 0 ; driveix < drivecnt ; driveix++) {
+		drive_t *drivep = drivepp[driveix];
 		bool_t ok;
 
-		drive_allochdrs( drivep, gwhdrtemplatep, driveix );
-		ok = ( * drivep->d_opsp->do_init )( drivep );
-		if ( ! ok ) {
+		drive_allochdrs(drivep, gwhdrtemplatep, driveix);
+		ok = (* drivep->d_opsp->do_init)(drivep);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 	}
@@ -270,16 +270,16 @@ drive_init2( int argc,
  * synchronizes with async operations begun by drive_init2.
  */
 bool_t
-drive_init3( void )
+drive_init3(void)
 {
 	ix_t driveix;
 
-	for ( driveix = 0 ; driveix < drivecnt ; driveix++ ) {
-		drive_t *drivep = drivepp[ driveix ];
+	for (driveix = 0 ; driveix < drivecnt ; driveix++) {
+		drive_t *drivep = drivepp[driveix];
 		bool_t ok;
 
-		ok = ( * drivep->d_opsp->do_sync )( drivep );
-		if ( ! ok ) {
+		ok = (* drivep->d_opsp->do_sync)(drivep);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 	}
@@ -294,17 +294,17 @@ drive_init3( void )
  * utility function for use by drive-specific strategies.
  */
 void
-drive_mark_commit( drive_t *drivep, off64_t ncommitted )
+drive_mark_commit(drive_t *drivep, off64_t ncommitted)
 {
 	drive_markrec_t *dmp;
 
-	for ( dmp = drivep->d_markrecheadp
+	for (dmp = drivep->d_markrecheadp
 	;
-	dmp && dmp->dm_log <= ( drive_mark_t )ncommitted
+	dmp && dmp->dm_log <= (drive_mark_t)ncommitted
 	;
 	) {
 		drivep->d_markrecheadp = dmp->dm_nextp;
-		( * dmp->dm_cbfuncp )( dmp->dm_cbcontextp, dmp, BOOL_TRUE );
+		(* dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_TRUE);
 		dmp = drivep->d_markrecheadp;
 	}
 }
@@ -314,17 +314,17 @@ drive_mark_commit( drive_t *drivep, off64_t ncommitted )
  * utility function for use by drive-specific strategies.
  */
 void
-drive_mark_discard( drive_t *drivep )
+drive_mark_discard(drive_t *drivep)
 {
 	drive_markrec_t *dmp;
 
-	for ( dmp = drivep->d_markrecheadp
+	for (dmp = drivep->d_markrecheadp
 	;
 	dmp
 	;
-	drivep->d_markrecheadp = dmp->dm_nextp, dmp = dmp->dm_nextp ) {
+	drivep->d_markrecheadp = dmp->dm_nextp, dmp = dmp->dm_nextp) {
 
-		( * dmp->dm_cbfuncp )( dmp->dm_cbcontextp, dmp, BOOL_FALSE );
+		(* dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_FALSE);
 	}
 }
 
@@ -332,15 +332,15 @@ drive_mark_discard( drive_t *drivep )
  * to print drive throughput and streaming metrics.
  */
 void
-drive_display_metrics( void )
+drive_display_metrics(void)
 {
 	ix_t driveix;
 
-	for ( driveix = 0 ; driveix < drivecnt ; driveix++ ) {
-		drive_t *drivep = drivepp[ driveix ];
+	for (driveix = 0 ; driveix < drivecnt ; driveix++) {
+		drive_t *drivep = drivepp[driveix];
 		drive_ops_t *dop = drivep->d_opsp;
-		if ( dop->do_display_metrics ) {
-			( * dop->do_display_metrics )( drivep );
+		if (dop->do_display_metrics) {
+			(* dop->do_display_metrics)(drivep);
 		}
 	}
 }
@@ -352,30 +352,30 @@ drive_display_metrics( void )
  * descriptor. do NOT allocate hdr buffers.
  */
 static drive_t *
-drive_alloc( char *pathname, ix_t driveix )
+drive_alloc(char *pathname, ix_t driveix)
 {
 	drive_t *drivep;
 	struct stat64 statbuf;
 
 	/* allocate the descriptor
 	 */
-	drivep = ( drive_t * )calloc( 1, sizeof( drive_t ));
-	assert( drivep );
+	drivep = (drive_t *)calloc(1, sizeof(drive_t));
+	assert(drivep);
 
 	/* convert the pathname to an absolute pathname
 	 * NOTE: string "stdio" is reserved to mean send to standard out
 	 */
-	if ( strcmp( pathname, "stdio" )) {
-		pathname = path_reltoabs( pathname, homedir );
+	if (strcmp(pathname, "stdio")) {
+		pathname = path_reltoabs(pathname, homedir);
 	}
 
 	/* set pipe flags
 	 */
-	if ( ! strcmp( pathname, "stdio" )) {
+	if (! strcmp(pathname, "stdio")) {
 		drivep->d_isunnamedpipepr = BOOL_TRUE;
-	} else if ( ! stat64( pathname, &statbuf )
+	} else if (! stat64(pathname, &statbuf)
 		    &&
-		    ( statbuf.st_mode & S_IFMT ) == S_IFIFO ) {
+		    (statbuf.st_mode & S_IFMT) == S_IFIFO) {
 		drivep->d_isnamedpipepr = BOOL_TRUE;
 	}
 
@@ -391,7 +391,7 @@ drive_alloc( char *pathname, ix_t driveix )
  * hdrs, and ptrs into the hdrs.
  */
 static void
-drive_allochdrs( drive_t *drivep, global_hdr_t *gwhdrtemplatep, ix_t driveix )
+drive_allochdrs(drive_t *drivep, global_hdr_t *gwhdrtemplatep, ix_t driveix)
 {
 	global_hdr_t *grhdrp;
 	drive_hdr_t *drhdrp;
@@ -400,22 +400,22 @@ drive_allochdrs( drive_t *drivep, global_hdr_t *gwhdrtemplatep, ix_t driveix )
 
 	/* allocate the read header
 	 */
-	grhdrp = ( global_hdr_t * )calloc( 1, sizeof( global_hdr_t ));
-	assert( grhdrp );
+	grhdrp = (global_hdr_t *)calloc(1, sizeof(global_hdr_t));
+	assert(grhdrp);
 	gwhdrp = NULL;
 	dwhdrp = NULL;
 
 	/* calculate pointer to the drive portion of the read header
 	 */
-	drhdrp = ( drive_hdr_t * )grhdrp->gh_upper;
+	drhdrp = (drive_hdr_t *)grhdrp->gh_upper;
 
 	/* global write hdr used only for dumps. will be NULL for restore
 	 */
-	if ( gwhdrtemplatep ) {
+	if (gwhdrtemplatep) {
 		/* allocate the write header
 		 */
-		gwhdrp = ( global_hdr_t * )calloc( 1, sizeof( global_hdr_t ));
-		assert( gwhdrp );
+		gwhdrp = (global_hdr_t *)calloc(1, sizeof(global_hdr_t));
+		assert(gwhdrp);
 
 		/* copy the template
 		 */
@@ -423,7 +423,7 @@ drive_allochdrs( drive_t *drivep, global_hdr_t *gwhdrtemplatep, ix_t driveix )
 
 		/* calculate pointer to the drive portion of the read header
 		 */
-		dwhdrp = ( drive_hdr_t * )gwhdrp->gh_upper;
+		dwhdrp = (drive_hdr_t *)gwhdrp->gh_upper;
 
 		/* fill in generic drive fields of write hdr
 		 */
diff --git a/common/drive.h b/common/drive.h
index 37258e0..4b4fcf8 100644
--- a/common/drive.h
+++ b/common/drive.h
@@ -99,7 +99,7 @@
  * CAUTION! the various components of the media file header are carefully
  * crafted to fit in DRIVE_HDR_SZ bytes.
  */
-#define DRIVE_HDR_SZ		sizeofmember( global_hdr_t, gh_upper )
+#define DRIVE_HDR_SZ		sizeofmember(global_hdr_t, gh_upper)
 
 struct drive_hdr {
 	uint32_t dh_drivecnt;				/*   4    4 */
@@ -108,11 +108,11 @@ struct drive_hdr {
 		/* 0-based index of the drive used to dump this stream */
 	int32_t dh_strategyid;				/*   4    c */
 		/* ID of the drive strategy used to produce this dump */
-	char dh_pad1[ 0x1f4 ];				/* 1f4  200 */
+	char dh_pad1[0x1f4];				/* 1f4  200 */
 		/* padding */
-	char dh_specific[ 0x200 ];			/* 200  400 */
+	char dh_specific[0x200];			/* 200  400 */
 		/* drive strategy-specific info */
-	char dh_upper[ DRIVE_HDR_SZ - 0x400 ];		/* 800  c00 */
+	char dh_upper[DRIVE_HDR_SZ - 0x400];		/* 800  c00 */
 		/* header info private to upper software layers */
 };
 
@@ -138,15 +138,15 @@ struct drive_strategy {
 	char *ds_description;
 		    /* a short char string describing strategy
 		     */
-	int ( * ds_match )( int argc,
-				 char *argv[ ],
-				 struct drive *drivep );
+	int (* ds_match)(int argc,
+				 char *argv[],
+				 struct drive *drivep);
 		    /* returns degree of match. drivep has been pre-allocated
 		     * and initialized with generic info.
 		     */
-	bool_t ( * ds_instantiate )( int argc,
-				     char *argv[ ],
-				     struct drive *drivep );
+	bool_t (* ds_instantiate)(int argc,
+				     char *argv[],
+				     struct drive *drivep);
 		    /* creates a drive manager instance, by filling in the
 		     * blanks of the pre-allocated drive descriptor
 		     * returns FALSE on failure.
@@ -186,9 +186,9 @@ typedef off64_t drive_mark_t;
  * was NOT committed.
  */
 struct drive_markrec; /* forward decl */
-typedef void ( * drive_mcbfp_t )( void *context_t,
+typedef void (* drive_mcbfp_t)(void *context_t,
 				  struct drive_markrec *markrecp,
-				  bool_t committed );
+				  bool_t committed);
 
 /* drive_markrec_t - context for set mark callback function
  *
@@ -257,17 +257,17 @@ struct drive {
 typedef struct drive drive_t;
 
 struct drive_ops {
-	bool_t ( * do_init )( drive_t *drivep );
+	bool_t (* do_init)(drive_t *drivep);
 				/* initializes drive, and begins async
 				 * determination of media object presence
 				 * returns FALSE if session should be aborted.
 				 */
-	bool_t ( * do_sync )( drive_t *drivep );
+	bool_t (* do_sync)(drive_t *drivep);
 				/* synchronizes with the activity kicked off
 				 * by do_init. returns FALSE if session should
 				 * be aborted.
 				 */
-	int ( * do_begin_read )( drive_t *drivep );
+	int (* do_begin_read)(drive_t *drivep);
 				/* prepares the drive manager for reading.
 				 * if the media is positioned at BOM or just
 				 * after a file mark, current media file is
@@ -306,10 +306,10 @@ struct drive_ops {
 				 * begin_read. if successful, caller MUST call
 				 * end_read prior to next begin_read.
 				 */
-	char * ( * do_read )( drive_t *drivep,
+	char * (* do_read)(drive_t *drivep,
 			      size_t wanted_bufsz,
 			      size_t *actual_bufszp,
-			      int *statp );
+			      int *statp);
 				/* asks the drive manager for a buffered filled
 				 * with the next read stream data.
 				 * the actual buffer size supplied may
@@ -341,23 +341,23 @@ struct drive_ops {
 				 * valid data (although the buffer size may
 				 * be zero!).
 				 */
-	void ( * do_return_read_buf )( drive_t *drivep,
+	void (* do_return_read_buf)(drive_t *drivep,
 				       char *bufp,
-				       size_t bufsz );
+				       size_t bufsz);
 				/* returns the buffer obtained
 				 * from the previous do_read() call.
 				 * the entire buffer must be returned
 				 * in one shot.
 				 */
-	void ( * do_get_mark )( drive_t *drivep,
-				drive_mark_t *drivemarkp );
+	void (* do_get_mark)(drive_t *drivep,
+				drive_mark_t *drivemarkp);
 				/* returns (by reference) a mark corresponding
 				 * to the next byte which will be read by a
 				 * call to do_read(). will be used in a later
 				 * session to seek to that position.
 				 */
-	int ( * do_seek_mark )( drive_t *drivep,
-				     drive_mark_t *drivemarkp );
+	int (* do_seek_mark)(drive_t *drivep,
+				     drive_mark_t *drivemarkp);
 				/* searches for the specified mark within the
 				 * current file. returns zero if the mark
 				 * was found, or an error explaining why not:
@@ -367,7 +367,7 @@ struct drive_ops {
 				 *	CORRUPTION - encountered corrupt data;
 				 *	DEVICE - device error;
 				 */
-	int ( * do_next_mark )( drive_t *drivep );
+	int (* do_next_mark)(drive_t *drivep);
 				/* if d_capabilities has DRIVE_CAP_NEXTMARK set,
 				 * drive has the capability to
 				 * seek forward to the next mark. returns
@@ -378,14 +378,14 @@ struct drive_ops {
 				 *	DEVICE - device error;
 				 * if currently at a mark, will go to the next.
 				 */
-	void ( *do_end_read )( drive_t *drivep );
+	void (*do_end_read)(drive_t *drivep);
 				/* ends the file read. must be called prior
 				 * to beginning another read or write session.
 				 * ensures that the next call to begin_read
 				 * will position the media at the next media
 				 * file.
 				 */
-	int ( * do_begin_write )( drive_t *drivep );
+	int (* do_begin_write)(drive_t *drivep);
 				/* begins a write media file for writing.
 				 * asserts the media is positioned at BOM or
 				 * just after a file mark. write header will
@@ -396,10 +396,10 @@ struct drive_ops {
 				 *	DEVICE - device error;
 				 *	CORE  - driver error
 				 */
-	void ( * do_set_mark )( drive_t *drivep,
+	void (* do_set_mark)(drive_t *drivep,
 				drive_mcbfp_t cbfuncp,
 				void *cbcontextp,
-				drive_markrec_t *markrecp );
+				drive_markrec_t *markrecp);
 				/* marks the position in the write stream
 				 * where the next write will occur.
 				 * At the time the data written
@@ -426,9 +426,9 @@ struct drive_ops {
 				 * last committed marked point in the write
 				 * stream.
 				 */
-	char * ( * do_get_write_buf )( drive_t *drivep,
+	char * (* do_get_write_buf)(drive_t *drivep,
 				       size_t wanted_bufsz,
-				       size_t *actual_bufszp );
+				       size_t *actual_bufszp);
 				/* asks the drive manager for a buffer.
 				 * returns a pointer to a buffer, and its
 				 * size. must call do_write() before
@@ -443,9 +443,9 @@ struct drive_ops {
 				 * be larger or smaller than the wanted bufsz,
 				 * but will be at least 1 byte in length.
 				 */
-	int ( * do_write )( drive_t *drivep,
+	int (* do_write)(drive_t *drivep,
 				 char *bufp,
-				 size_t bufsz );
+				 size_t bufsz);
 				/* asks the drive manager to write bufsz
 				 * bytes from the buffer, which was acquired
 				 * from a previous call to do_get_write_buf().
@@ -473,7 +473,7 @@ struct drive_ops {
 				 * instead, the caller must get another buffer
 				 * using do_get_write_buf().
 				 */
-	size_t ( * do_get_align_cnt )( drive_t *drivep );
+	size_t (* do_get_align_cnt)(drive_t *drivep);
 				/* used during writing. returns the number
 				 * of bytes which should be written to
 				 * page-align the next do_get_write_buf()
@@ -481,7 +481,7 @@ struct drive_ops {
 				 * alignment will be maintained after the
 				 * initial alignment done using this info.
 				 */
-	int ( * do_end_write )( drive_t *drivep, off64_t *ncommittedp );
+	int (* do_end_write)(drive_t *drivep, off64_t *ncommittedp);
 				/* terminates a media file write sequence.
 				 * flushes any buffered data not yet committed
 				 * to media, and calls callbacks for all marks
@@ -502,9 +502,9 @@ struct drive_ops {
 				 * an error, do_end_write will not do any
 				 * I/O, and will return 0.
 				 */
-	int ( * do_fsf )( drive_t *drivep,
+	int (* do_fsf)(drive_t *drivep,
 			      int count,
-			      int *statp );
+			      int *statp);
 				/* if d_capabilities has DRIVE_CAP_FSF set,
 				 * drive has the capability to
 				 * forward space count files. returns the
@@ -528,9 +528,9 @@ struct drive_ops {
 				 * behaves as if position is at most recent
 				 * file mark or BOT.
 				 */
-	int ( * do_bsf )( drive_t *drivep,
+	int (* do_bsf)(drive_t *drivep,
 			       int count,
-			       int *statp );
+			       int *statp);
 				/* if d_capabilities has DRIVE_CAP_BSF set,
 				 * drive has the capability to backward space
 				 * count files. returns the number of actual
@@ -554,35 +554,35 @@ struct drive_ops {
 				 *	BOM - hit beginning of recorded data;
 				 *	DEVICE - device error;
 				 */
-	int ( * do_rewind )( drive_t *drivep );
+	int (* do_rewind)(drive_t *drivep);
 				/* if d_capabilities has DRIVE_CAP_REWIND set,
 				 * drive has the capability to
 				 * position at beginning of recorded data
 				 *	DEVICE - device error;
 				 */
-	int ( * do_erase )( drive_t *drivep );
+	int (* do_erase)(drive_t *drivep);
 				/* if d_capabilities has DRIVE_CAP_ERASE set,
 				 * drive has the capability to
 				 * erase: all content of media object is
 				 * eradicated.
 				 *	DEVICE - device error;
 				 */
-	int ( * do_eject_media )( drive_t *drivep );
+	int (* do_eject_media)(drive_t *drivep);
 				/* if d_capabilities has DRIVE_CAP_EJECT set,
 				 * drive has capability
 				 * to eject media, and will do so when called.
 				 *	DEVICE - device error;
 				 */
-	int ( * do_get_device_class )( drive_t *drivep );
+	int (* do_get_device_class)(drive_t *drivep);
 				/* returns the media class of the device
 				 * (see below).
 				 */
-	void ( * do_display_metrics )( drive_t *drivep );
+	void (* do_display_metrics)(drive_t *drivep);
 				/* use BARE mlog to print useful throughput
 				 * and performance info. set to NULL if
 				 * nothing to say.
 				 */
-	void ( * do_quit )( drive_t * drivep );
+	void (* do_quit)(drive_t * drivep);
 				/* tells the drive manager to de-allocate
 				 * resources, INCLUDING the slave process.
 				 */
@@ -600,18 +600,18 @@ extern size_t partialmax;
 /* drive capabilities - bit positions in the capabilities mask
  * DO NOT CHANGE: used in dh_capabilities field of scsi drive hdr.
  */
-#define DRIVE_CAP_BSF		( 1 << 0 ) /* can backspace files */
-#define DRIVE_CAP_FSF		( 1 << 1 ) /* can forwardspace files */
-#define DRIVE_CAP_REWIND	( 1 << 2 ) /* can rewind */
-#define DRIVE_CAP_FILES		( 1 << 4 ) /* supports multiple files */
-#define DRIVE_CAP_APPEND	( 1 << 5 ) /* can append to end of rec. data */
-#define DRIVE_CAP_OVERWRITE	( 1 << 6 ) /* can overwrite recorded data */
-#define DRIVE_CAP_ERASE		( 1 << 6 ) /* can erase media */
-#define DRIVE_CAP_NEXTMARK	( 1 << 8 ) /* can seek to a next good mark */
-#define DRIVE_CAP_EJECT		( 1 << 12 ) /* can eject media */
-#define DRIVE_CAP_AUTOREWIND	( 1 << 13 ) /* rewinds on media insertion */
-#define DRIVE_CAP_READ		( 1 << 14 ) /* can read media */
-#define DRIVE_CAP_REMOVABLE	( 1 << 15 ) /* can change media */
+#define DRIVE_CAP_BSF		(1 << 0) /* can backspace files */
+#define DRIVE_CAP_FSF		(1 << 1) /* can forwardspace files */
+#define DRIVE_CAP_REWIND	(1 << 2) /* can rewind */
+#define DRIVE_CAP_FILES		(1 << 4) /* supports multiple files */
+#define DRIVE_CAP_APPEND	(1 << 5) /* can append to end of rec. data */
+#define DRIVE_CAP_OVERWRITE	(1 << 6) /* can overwrite recorded data */
+#define DRIVE_CAP_ERASE		(1 << 6) /* can erase media */
+#define DRIVE_CAP_NEXTMARK	(1 << 8) /* can seek to a next good mark */
+#define DRIVE_CAP_EJECT		(1 << 12) /* can eject media */
+#define DRIVE_CAP_AUTOREWIND	(1 << 13) /* rewinds on media insertion */
+#define DRIVE_CAP_READ		(1 << 14) /* can read media */
+#define DRIVE_CAP_REMOVABLE	(1 << 15) /* can change media */
 
 /* drive manager error codes - interpretation specific to and described
  * in context of use.
@@ -646,7 +646,7 @@ extern size_t partialmax;
  *
  * Returns FALSE if utility should be aborted.
  */
-extern bool_t drive_init1( int argc, char *argv[] );
+extern bool_t drive_init1(int argc, char *argv[]);
 
 
 /* drive_init2 - allocate and initialize read and write hdr buffers,
@@ -655,35 +655,35 @@ extern bool_t drive_init1( int argc, char *argv[] );
  *
  * Returns FALSE if the session should be aborted.
  */
-extern bool_t drive_init2( int argc,
+extern bool_t drive_init2(int argc,
 			   char *argv[],
-			   global_hdr_t *gwhdrtemplatep );
+			   global_hdr_t *gwhdrtemplatep);
 
 
 /* drive_init3 - synchronize with async activity kicked off by drive_init3.
  *
  * Returns FALSE if the session should be aborted.
  */
-extern bool_t drive_init3( void );
+extern bool_t drive_init3(void);
 
 /* drive_mark_commit - invokes callback for all drive marks committed
  * to media. ncommitted is the number of bytes actually committed to
  * media so far. mark records with a mark offset less than or equal to
  * ncommitted will have their callbacks invoked.
  */
-extern void drive_mark_commit( drive_t *drivep, off64_t ncommitted );
+extern void drive_mark_commit(drive_t *drivep, off64_t ncommitted);
 
 
 /* drive_mark_discard - invokes callback of all uncommitted marks,
  * indicating the commit did not occur.
  */
-extern void drive_mark_discard( drive_t *drivep );
+extern void drive_mark_discard(drive_t *drivep);
 
 
 /* drive_display_metrics - display drive throughput and streaming metrics
  * for all drives
  */
-extern void drive_display_metrics( void );
+extern void drive_display_metrics(void);
 
 
 /* device classes
-- 
2.19.1
