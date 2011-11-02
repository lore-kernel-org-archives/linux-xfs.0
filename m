Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2LBC4Z200881 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 16:11:12 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 5/8] xfsdump: convert IRIX sproc threads to pthreads
Date: Wed,  2 Nov 2011 16:10:51 -0500
Message-Id: <1320268254-20583-6-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
References: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
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

The existing (disabled) threading code in xfsdump is based on IRIX
sprocs. This patch converts the code to use pthreads. The threading code
remains disabled at this point.

Changes:
   - pid_t to pthread_t
   - getpid() to pthread_self()
   - "pid1 == pid2" to pthread_equal(tid1, tid2)
   - sigprocmask() to pthread_sigmask()
   - sproc() to pthread_create()

Also the following are not referenced and have been removed:
   - cldmgr_pid2streamix()
   - PROCMAX
   - r_slavepid
   - sproc.c and sproc.h

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/Makefile         |    2 +-
 common/cldmgr.c         |   56 ++++++++++++++--------------
 common/cldmgr.h         |    8 +---
 common/dlog.c           |    4 +-
 common/drive_minrmt.c   |    2 +-
 common/drive_scsitape.c |    2 +-
 common/main.c           |   20 +++++-----
 common/mlog.c           |   44 +++++++++++-----------
 common/ring.c           |    9 +---
 common/ring.h           |    1 -
 common/sproc.c          |   42 ---------------------
 common/sproc.h          |   23 -----------
 common/stream.c         |   94 +++++++++++++++++++++--------------------------
 common/stream.h         |   22 +++++-----
 dump/Makefile           |    4 +-
 dump/content.c          |    4 +-
 restore/Makefile        |    2 -
 restore/content.c       |    5 +-
 18 files changed, 127 insertions(+), 217 deletions(-)
 delete mode 100644 common/sproc.c
 delete mode 100644 common/sproc.h

diff --git a/common/Makefile b/common/Makefile
index 8d9d868..ad3d61a 100644
--- a/common/Makefile
+++ b/common/Makefile
@@ -13,7 +13,7 @@ LSRCFILES = arch_xlate.c arch_xlate.h \
 	hsmapi.c hsmapi.h inventory.c inventory.h lock.c lock.h \
 	main.c media.c media.h media_rmvtape.h mlog.c mlog.h \
 	openutil.c openutil.h path.c path.h qlock.c qlock.h \
-	rec_hdr.h ring.c ring.h sproc.c sproc.h stream.c \
+	rec_hdr.h ring.c ring.h stream.c \
 	stream.h timeutil.c timeutil.h ts_mtio.h types.h util.c util.h
 
 default install install-dev :
diff --git a/common/cldmgr.c b/common/cldmgr.c
index d327bab..4574834 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -24,6 +24,7 @@
 #include <sys/sem.h>
 #include <sys/prctl.h>
 #include <errno.h>
+#include <pthread.h>
 
 #include "types.h"
 #include "lock.h"
@@ -31,14 +32,13 @@
 #include "stream.h"
 #include "mlog.h"
 #include "cldmgr.h"
-#include "sproc.h"
 
 extern size_t pgsz;
 
 #define CLD_MAX	( STREAM_SIMMAX * 2 )
 struct cld {
 	bool_t c_busy;
-	pid_t c_pid;
+	pthread_t c_tid;
 	ix_t c_streamix;
 	int ( * c_entry )( void *arg1 );
 	void * c_arg1;
@@ -50,32 +50,31 @@ static cld_t cld[ CLD_MAX ];
 static bool_t cldmgr_stopflag;
 
 static cld_t *cldmgr_getcld( void );
-static cld_t * cldmgr_findbypid( pid_t );
-static int cldmgr_entry( void * );
+static cld_t * cldmgr_findbytid( pthread_t );
+static void *cldmgr_entry( void * );
 /* REFERENCED */
-static pid_t cldmgr_parentpid;
+static pthread_t cldmgr_parenttid;
 
 bool_t
 cldmgr_init( void )
 {
 	( void )memset( ( void * )cld, 0, sizeof( cld ));
 	cldmgr_stopflag = BOOL_FALSE;
-	cldmgr_parentpid = getpid( );
+	cldmgr_parenttid = pthread_self( );
 
 	return BOOL_TRUE;
 }
 
 bool_t
 cldmgr_create( int ( * entry )( void *arg1 ),
-	       u_intgen_t inh,
 	       ix_t streamix,
 	       char *descstr,
 	       void *arg1 )
 {
 	cld_t *cldp;
-	pid_t cldpid;
+	intgen_t rval;
 
-	ASSERT( getpid( ) == cldmgr_parentpid );
+	ASSERT( pthread_equal( pthread_self( ), cldmgr_parenttid ) );
 
 	cldp = cldmgr_getcld( );
 	if ( ! cldp ) {
@@ -91,22 +90,22 @@ cldmgr_create( int ( * entry )( void *arg1 ),
 	cldp->c_streamix = streamix;
 	cldp->c_entry = entry;
 	cldp->c_arg1 = arg1;
-	cldpid = ( pid_t )sproc( cldmgr_entry, inh, ( void * )cldp );
-	if ( cldpid < 0 ) {
+	rval = pthread_create( &cldp->c_tid, NULL, cldmgr_entry, cldp );
+	if ( rval ) {
 		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_PROC, _(
-		      "sproc failed creating %s thread for stream %u: %s\n"),
+		      "failed creating %s thread for stream %u: %s\n"),
 		      descstr,
 		      streamix,
-		      strerror( errno ));
+		      strerror( rval ));
 	} else {
 		mlog( MLOG_NITTY | MLOG_PROC,
-		      "%s thread created for stream %u: pid %d\n",
+		      "%s thread created for stream %u: tid %lu\n",
 		      descstr,
 		      streamix,
-		      cldpid );
+		      cldp->c_tid );
 	}
 
-	return cldpid < 0 ? BOOL_FALSE : BOOL_TRUE;
+	return rval ? BOOL_FALSE : BOOL_TRUE;
 }
 
 void
@@ -119,16 +118,16 @@ cldmgr_stop( void )
 }
 
 void
-cldmgr_died( pid_t pid )
+cldmgr_died( pthread_t tid )
 {
-	cld_t *cldp = cldmgr_findbypid( pid );
+	cld_t *cldp = cldmgr_findbytid( tid );
 
 	if ( ! cldp ) {
 		return;
 	}
 	cldp->c_busy = BOOL_FALSE;
 	if ( ( intgen_t )( cldp->c_streamix ) >= 0 ) {
-		stream_dead( pid );
+		stream_dead( tid );
 	}
 }
 
@@ -194,13 +193,13 @@ cldmgr_getcld( void )
 }
 
 static cld_t *
-cldmgr_findbypid( pid_t pid )
+cldmgr_findbytid( pthread_t tid )
 {
 	cld_t *p = cld;
 	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
 
 	for ( ; p < ep ; p++ ) {
-		if ( p->c_busy && p->c_pid == pid ) {
+		if ( p->c_busy && pthread_equal( p->c_tid, tid )) {
 			break;
 		}
 	}
@@ -208,19 +207,20 @@ cldmgr_findbypid( pid_t pid )
 	return ( p < ep ) ? p : 0;
 }
 
-static int
+static void *
 cldmgr_entry( void *arg1 )
 {
 	cld_t *cldp = ( cld_t * )arg1;
-	pid_t pid = getpid( );
+	pthread_t tid = pthread_self( );
 
-	cldp->c_pid = pid;
 	if ( ( intgen_t )( cldp->c_streamix ) >= 0 ) {
-		stream_register( pid, ( intgen_t )cldp->c_streamix );
+		stream_register( tid, ( intgen_t )cldp->c_streamix );
 	}
 	mlog( MLOG_DEBUG | MLOG_PROC,
-	      "child %d created for stream %d\n",
-	      pid,
+	      "thread %lu created for stream %d\n",
+	      tid,
 	      cldp->c_streamix );
-	return ( * cldp->c_entry )( cldp->c_arg1 );
+
+	( * cldp->c_entry )( cldp->c_arg1 );
+	return NULL;
 }
diff --git a/common/cldmgr.h b/common/cldmgr.h
index bb3f612..e393b82 100644
--- a/common/cldmgr.h
+++ b/common/cldmgr.h
@@ -30,7 +30,6 @@ extern bool_t cldmgr_init( void );
  * encountered
  */
 extern bool_t cldmgr_create( int ( * entry )( void *arg1 ),
-			     u_intgen_t inh,
 			     ix_t streamix,
 			     char *descstr,
 			     void *arg1 );
@@ -42,18 +41,13 @@ extern void cldmgr_stop( void );
 
 /* cldmgr_died - tells the child manager that the child died
  */
-extern void cldmgr_died( pid_t pid );
+extern void cldmgr_died( pthread_t tid );
 
 /* cldmgr_stop_requested - returns TRUE if the child should gracefully
  * terminate.
  */
 extern bool_t cldmgr_stop_requested( void );
 
-/* cldmgr_pid2streamix - retrieves the stream index. returns -1 if
- * not associated with any stream.
- */
-extern intgen_t cldmgr_pid2streamix( pid_t pid );
-
 /* cldmgr_remainingcnt - returns number of children remaining
  */
 extern size_t cldmgr_remainingcnt( void );
diff --git a/common/dlog.c b/common/dlog.c
index 8cf9a65..51666cf 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -429,7 +429,7 @@ promptinput( char *buf,
 		sigaddset( &dlog_registered_sigs, SIGQUIT );
 	}
 
-	sigprocmask( SIG_UNBLOCK, &dlog_registered_sigs, &orig_set );
+	pthread_sigmask( SIG_UNBLOCK, &dlog_registered_sigs, &orig_set );
 
 	/* wait for input, timeout, or interrupt.
 	 * note we come out of the select() frequently in order to
@@ -455,7 +455,7 @@ promptinput( char *buf,
 
 	/* restore signal handling
 	 */
-	sigprocmask( SIG_SETMASK, &orig_set, NULL );
+	pthread_sigmask( SIG_SETMASK, &orig_set, NULL );
 	sigemptyset( &dlog_registered_sigs );
 	
 	/* check for timeout or interrupt
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 836b663..3ff4d0f 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -577,7 +577,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 	drivep->d_cap_est  = -1;
 	drivep->d_rate_est = -1;
 
-	/* if sproc not allowed, allocate a record buffer. otherwise
+	/* if threads not allowed, allocate a record buffer. otherwise
 	 * create a ring, from which buffers will be taken.
 	 */
 	if ( singlethreaded ) {
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 8c1bd49..f24d604 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -667,7 +667,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 	drivep->d_cap_est  = -1;
 	drivep->d_rate_est = -1;
 
-	/* if sproc not allowed, allocate a record buffer. otherwise
+	/* if threads not allowed, allocate a record buffer. otherwise
 	 * create a ring, from which buffers will be taken.
 	 */
 	if ( singlethreaded ) {
diff --git a/common/main.c b/common/main.c
index 25c0838..d4dbe28 100644
--- a/common/main.c
+++ b/common/main.c
@@ -32,6 +32,7 @@
 #include <getopt.h>
 #include <stdint.h>
 #include <sched.h>
+#include <pthread.h>
 
 #include "exit.h"
 #include "types.h"
@@ -117,7 +118,7 @@ bool_t miniroot = BOOL_TRUE;
 #endif /* HIDDEN */
 bool_t pipeline = BOOL_FALSE;
 bool_t stdoutpiped = BOOL_FALSE;
-pid_t parentpid;
+pthread_t parenttid;
 char *sistr;
 size_t pgsz;
 size_t pgmask;
@@ -195,10 +196,10 @@ main( int argc, char *argv[] )
 	*/
 	mlog_init0();
 
-	/* Get the parent's pid. will be used in signal handling
+	/* Get the parent's pthread id. will be used
 	 * to differentiate parent from children.
 	 */
-	parentpid = getpid( );
+	parenttid = pthread_self( );
 	rval = atexit(mlog_exit_flush);
 	assert(rval == 0);
 
@@ -395,11 +396,11 @@ main( int argc, char *argv[] )
 	ASSERT( ( intgen_t )pgsz > 0 );
 	pgmask = pgsz - 1;
 
-	/* report parent pid
+	/* report parent tid
          */
 	mlog( MLOG_DEBUG | MLOG_PROC,
-	      "parent pid is %d\n",
-	      parentpid );
+	      "parent tid is %lu\n",
+	      parenttid );
 
 	/* get the current working directory: this is where we will dump
 	 * core, if necessary. some tmp files may be placed here as well.
@@ -572,7 +573,7 @@ main( int argc, char *argv[] )
 		sigaddset( &blocked_set, SIGTERM );
 		sigaddset( &blocked_set, SIGQUIT );
 		sigaddset( &blocked_set, SIGALRM );
-		sigprocmask( SIG_SETMASK, &blocked_set, NULL );
+		pthread_sigmask( SIG_SETMASK, &blocked_set, NULL );
 
 		sa.sa_handler = sighandler;
 		sigaction( SIGINT, &sa, NULL );
@@ -676,7 +677,6 @@ main( int argc, char *argv[] )
 	if ( ! init_error ) {
 		for ( stix = 0 ; stix < drivecnt ; stix++ ) {
 			ok = cldmgr_create( childmain,
-					    CLONE_VM,
 					    stix,
 					    "child",
 					    ( void * )stix );
@@ -895,7 +895,7 @@ main( int argc, char *argv[] )
 	if ( coredump_requested ) {
 		mlog( MLOG_DEBUG | MLOG_PROC,
 		      "core dump requested, aborting (pid %d)\n",
-		      parentpid );
+		      getpid() );
 		abort();
 	}
 
@@ -1560,7 +1560,7 @@ childmain( void *arg1 )
 	drivep = drivepp[ stix ];
 	( * drivep->d_opsp->do_quit )( drivep );
 
-	exit( exitcode );
+	return exitcode;
 }
 
 
diff --git a/common/mlog.c b/common/mlog.c
index 2265895..b0135b9 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -26,6 +26,7 @@
 #include <unistd.h>
 #include <time.h>
 #include <getopt.h>
+#include <pthread.h>
 
 #include "types.h"
 #include "qlock.h"
@@ -40,7 +41,7 @@
 
 extern char *progname;
 extern void usage( void );
-extern pid_t parentpid;
+extern pthread_t parenttid;
 
 #ifdef DUMP
 static FILE *mlog_fp = NULL; /* stderr */;
@@ -385,7 +386,7 @@ mlog_va( intgen_t levelarg, char *fmt, va_list args )
 
 	if ( ! ( levelarg & MLOG_BARE )) {
 		intgen_t streamix;
-		streamix = stream_getix( getpid() );
+		streamix = stream_getix( pthread_self( ) );
 
 		if ( mlog_showss ) {
 			sprintf( mlog_ssstr, ":%s", mlog_ss_names[ ss ] );
@@ -568,10 +569,10 @@ rv_getdesc(rv_t rv)
 int
 _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 {
-	pid_t pid;
+	pthread_t tid;
 	const struct rv_map *rvp;
 
-	pid = getpid();
+	tid = pthread_self();
 	rvp = rv_getdesc(rv);
 
 
@@ -595,7 +596,7 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 	 * most accurate information about the termination condition.
 	 */
 
-	if (pid == parentpid) {
+	if ( pthread_equal( tid, parenttid ) ) {
 		if (mlog_main_exit_code == -1) {
 			mlog_main_exit_code = exit_code;
 			mlog_main_exit_return = rv;
@@ -608,7 +609,7 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 		int exit_code;
 		rv_t exit_return, exit_hint;
 
-		if (stream_get_exit_status(pid,
+		if (stream_get_exit_status(tid,
 					   states,
 					   N(states),
 					   &state,
@@ -618,8 +619,8 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 					   &exit_hint))
 		{
 			if (exit_code == -1) {
-				stream_set_code(pid, exit_code);
-				stream_set_return(pid, rv);
+				stream_set_code(tid, exit_code);
+				stream_set_return(tid, rv);
 			}
 		}
 	}
@@ -630,10 +631,10 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 void
 _mlog_exit_hint( const char *file, int line, rv_t rv )
 {
-	pid_t pid;
+	pthread_t tid;
 	const struct rv_map *rvp;
 
-	pid = getpid();
+	tid = pthread_self();
 	rvp = rv_getdesc(rv);
 	
 	mlog( MLOG_DEBUG | MLOG_NOLOCK,
@@ -655,10 +656,10 @@ _mlog_exit_hint( const char *file, int line, rv_t rv )
 	 * information about the termination condition.
 	 */
 
-	if (pid == parentpid)
+	if ( pthread_equal( tid, parenttid ) )
 		mlog_main_exit_hint = rv;
 	else 
-		stream_set_hint( pid, rv );
+		stream_set_hint( tid, rv );
 
 }
 
@@ -670,10 +671,10 @@ mlog_get_hint( void )
 	bool_t ok;
 	rv_t hint;
 
-	if (getpid() == parentpid)
+	if ( pthread_equal( pthread_self(), parenttid ) )
 		return mlog_main_exit_hint;
 
-	ok = stream_get_exit_status(getpid(), states, N(states),
+	ok = stream_get_exit_status(pthread_self(), states, N(states),
 				    NULL, NULL, NULL, NULL, &hint);
 	ASSERT(ok);
 	return hint;
@@ -697,8 +698,8 @@ mlog_get_hint( void )
 void
 mlog_exit_flush(void)
 {
-	pid_t pids[STREAM_SIMMAX];
-	int i, npids;
+	pthread_t tids[STREAM_SIMMAX];
+	int i, ntids;
 	const struct rv_map *rvp;
 	stream_state_t states[] = { S_RUNNING, S_ZOMBIE };
 	bool_t incomplete = BOOL_FALSE;
@@ -713,13 +714,13 @@ mlog_exit_flush(void)
 	if (mlog_main_exit_hint == RV_USAGE)
 		return;
 
-	npids = stream_find_all(states, N(states), pids, STREAM_SIMMAX);
-	if (npids > 0) {
+	ntids = stream_find_all(states, N(states), tids, STREAM_SIMMAX);
+	if (ntids > 0) {
 
 		/* print the state of all the streams */
 		fprintf(mlog_fp, _("%s: %s Summary:\n"), progname, PROGSTR_CAPS );
 
-		for (i = 0; i < npids; i++) {
+		for (i = 0; i < ntids; i++) {
 			stream_state_t state;
 			intgen_t streamix;
 			int exit_code;
@@ -727,7 +728,7 @@ mlog_exit_flush(void)
 			/* REFERENCED */
 			bool_t ok;
 
-			ok = stream_get_exit_status(pids[i],
+			ok = stream_get_exit_status(tids[i],
 						    states,
 						    N(states),
 						    &state,
@@ -743,11 +744,10 @@ mlog_exit_flush(void)
 			/* print status of this stream */
 			rvp = rv_getdesc(rv);
 			fprintf(mlog_fp,
-				_("%s:   stream %d (pid %d) %s "
+				_("%s:   stream %d %s "
 				"%s (%s)\n"),
 				progname,
 				streamix,
-				pids[i],
 				drivepp[streamix]->d_pathname,
 				rvp->rv_string,
 				rvp->rv_desc);
diff --git a/common/ring.c b/common/ring.c
index e1dddba..42bd7d7 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -123,7 +123,6 @@ ring_create( size_t ringlen,
 	/* kick off the slave thread
 	 */
 	ok = cldmgr_create( ring_slave_entry,
-			    CLONE_VM,
 			    drive_index,
 			    _("slave"),
 			    ringp );
@@ -421,11 +420,7 @@ ring_slave_entry( void *ringctxp )
 	sigaddset( &blocked_set, SIGTERM );
 	sigaddset( &blocked_set, SIGQUIT );
 	sigaddset( &blocked_set, SIGALRM );
-	sigprocmask( SIG_SETMASK, &blocked_set, NULL );
-
-	/* record slave pid to be used to kill slave
-	 */
-	ringp->r_slavepid = getpid( );
+	pthread_sigmask( SIG_SETMASK, &blocked_set, NULL );
 
 	/* loop reading and precessing messages until told to die
 	 */
@@ -498,5 +493,5 @@ ring_slave_entry( void *ringctxp )
 		ring_slave_put( ringp, msgp );
 	}
 
-	exit( 0 );
+	return 0;
 }
diff --git a/common/ring.h b/common/ring.h
index 56e3924..caa505c 100644
--- a/common/ring.h
+++ b/common/ring.h
@@ -134,7 +134,6 @@ struct ring {
 	time32_t r_first_io_time;
 	off64_t r_all_io_cnt;
 /* ALL BELOW PRIVATE!!! */
-	pid_t r_slavepid;
 	size_t r_len;
 	ring_msg_t *r_msgp;
 	size_t r_ready_in_ix;
diff --git a/common/sproc.c b/common/sproc.c
deleted file mode 100644
index 3b1425a..0000000
--- a/common/sproc.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (c) 2000-2001 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <stdlib.h>
-#include <signal.h>
-#include <sched.h>
-
-#define STACKSIZE 65536
-
-int
-sproc (int (*entry) (void *), int flags, void *arg)
-{
-    int retval = -1;
-#ifdef HIDDEN
-    void *newstack;
-
-    if ( (newstack = calloc (1, STACKSIZE)) != NULL ) {
-        void ** stackp = ((void **)newstack)+(STACKSIZE -1)/sizeof(void*);
-
-        flags |= SIGCHLD;
-
-        retval = clone (entry, stackp, flags, arg);
-    }
-#endif
-
-    return retval;
-}
diff --git a/common/sproc.h b/common/sproc.h
deleted file mode 100644
index 46111ff..0000000
--- a/common/sproc.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (c) 2000-2001 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef SPROC_H
-#define SPROC_H
-
-int sproc (int (*) (void *), int, void *);
-
-#endif /* SPROC_H */
diff --git a/common/stream.c b/common/stream.c
index adaf7c0..48e25ee 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -19,18 +19,19 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <pthread.h>
+
 #include "types.h"
 #include "exit.h"
 #include "stream.h"
 #include "lock.h"
 #include "mlog.h"
 
-#define PROCMAX	( STREAM_SIMMAX * 2 + 1 )
 #define N(a) (sizeof((a)) / sizeof((a)[0]))
 
 struct spm {
 	stream_state_t	s_state;
-	pid_t		s_pid;
+	pthread_t	s_tid;
 	intgen_t	s_ix;
 	int		s_exit_code;
 	rv_t		s_exit_return;
@@ -38,37 +39,28 @@ struct spm {
 };
 
 typedef struct spm spm_t;
-extern pid_t parentpid;
 static spm_t spm[ STREAM_SIMMAX * 3 ];
 static bool_t initialized = BOOL_FALSE;
 
 void
 stream_init( void )
 {
-#ifdef HIDDEN
-	/* REFERENCED */
-	intgen_t rval;
-
-	rval = ( intgen_t )usconfig( CONF_INITUSERS, PROCMAX );
-	ASSERT( rval >= 0 );
-#endif /* HIDDEN */
-
 	( void )memset( ( void * )spm, 0, sizeof( spm ));
 	initialized = BOOL_TRUE;
 }
 
 /*
  * Note that the stream list structure (updated via the stream_* functions)
- * is indexed by pid. Multiple processes can be registered against the same
- * stream index, typically: the primary content process that does the work;
- * and the drive slave process, which just processes stuff off the ring buffer.
- * In general having multiple pids registered per stream is not an issue for
- * termination status reporting, as the mlog_exit* logging functions only
+ * is indexed by pthread_t (tid). Multiple processes can be registered against
+ * the same stream index, typically: the primary content process that does the
+ * work; and the drive slave process, which just processes stuff off the ring
+ * buffer. In general having multiple tids registered per stream is not an issue
+ * for termination status reporting, as the mlog_exit* logging functions only
  * ever get called out of the primary content process.
  */
 
 void
-stream_register( pid_t pid, intgen_t streamix )
+stream_register( pthread_t tid, intgen_t streamix )
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
@@ -87,7 +79,7 @@ stream_register( pid_t pid, intgen_t streamix )
 
 	if ( p >= ep ) return;
 
-	p->s_pid = pid;
+	p->s_tid = tid;
 	p->s_ix = streamix;
 	p->s_exit_code = -1;
 	p->s_exit_return = RV_NONE;
@@ -95,14 +87,14 @@ stream_register( pid_t pid, intgen_t streamix )
 }
 
 void
-stream_dead( pid_t pid )
+stream_dead( pthread_t tid )
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
 
 	lock();
 	for ( ; p < ep ; p++ )
-		if ( p->s_pid == pid ) {
+		if ( pthread_equal( p->s_tid, tid ) ) {
 			p->s_state = S_ZOMBIE;
 			break;
 		}
@@ -111,14 +103,14 @@ stream_dead( pid_t pid )
 }
 
 void
-stream_free( pid_t pid )
+stream_free( pthread_t tid )
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
 
 	lock();
 	for ( ; p < ep ; p++ ) {
-		if ( p->s_pid == pid ) {
+		if ( pthread_equal( p->s_tid, tid ) ) {
 			(void) memset( (void *) p, 0, sizeof(spm_t) );
 			p->s_state = S_FREE;
 			break;
@@ -130,22 +122,22 @@ stream_free( pid_t pid )
 
 int
 stream_find_all( stream_state_t states[], int nstates,
-		 pid_t pids[], int npids )
+		 pthread_t tids[], int ntids )
 {
 	int i, count = 0;
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
-	ASSERT(nstates > 0 && npids > 0);
+	ASSERT(nstates > 0 && ntids > 0);
 
 	if (!initialized)
 		return 0;
 
 	/* lock - make sure we get a consistent snapshot of the stream status */
 	lock();
-	for ( ; p < ep && count < npids; p++ )
+	for ( ; p < ep && count < ntids; p++ )
 		for (i = 0; i < nstates; i++)
 			if (p->s_state == states[i]) {
-				pids[count++] = p->s_pid;
+				tids[count++] = p->s_tid;
 				break;
 			}
 	unlock();
@@ -153,7 +145,7 @@ stream_find_all( stream_state_t states[], int nstates,
 }
 
 static spm_t *
-stream_find( pid_t pid, stream_state_t s[], int nstates )
+stream_find( pthread_t tid, stream_state_t s[], int nstates )
 {
 	int i;
 	spm_t *p = spm;
@@ -163,7 +155,7 @@ stream_find( pid_t pid, stream_state_t s[], int nstates )
 
 	/* note we don't lock the stream array in this function */
 	for ( ; p < ep ; p++ )
-		if ( p->s_pid == pid ) {
+		if ( pthread_equal( p->s_tid, tid ) ) {
 			/* check state */
 			for (i = 0; i < nstates; i++)
 				if (p->s_state == s[i])
@@ -174,8 +166,8 @@ stream_find( pid_t pid, stream_state_t s[], int nstates )
 	{
 		static const char *state_strings[] = { "S_FREE", "S_RUNNING", "S_ZOMBIE" };
 		mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK | MLOG_BARE,
-		      "stream_find(): no stream with pid: %d and state%s:",
-		      pid, nstates == 1 ? "" : "s" );
+		      "stream_find(): no stream with tid: %lu and state%s:",
+		      tid, nstates == 1 ? "" : "s" );
 		for (i = 0; i < nstates; i++)
 			mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK | MLOG_BARE,
 			      " %s", state_strings[s[i]]);
@@ -187,20 +179,18 @@ stream_find( pid_t pid, stream_state_t s[], int nstates )
 }
 
 /*
- * Note, the following function is called from two places:
- * main.c:sighandler(), and mlog.c:mlog_va() in the first case we
- * aren't allowed to take locks, and in the second locking may be
- * disabled and we are already protected by another lock. So no
- * locking is done in this function.
+ * Note, the following function is called from mlog.c:mlog_va(),
+ * where locking may be disabled and we are already protected by
+ * another lock. So no locking is done in this function.
  */
 
 intgen_t
-stream_getix( pid_t pid )
+stream_getix( pthread_t tid )
 {
 	stream_state_t states[] = { S_RUNNING };
 	spm_t *p;
 	intgen_t ix;
-	p = stream_find( pid, states, N(states) );
+	p = stream_find( tid, states, N(states) );
 	ix = p ? p->s_ix : -1;
 	return ix;
 }
@@ -213,43 +203,43 @@ stream_getix( pid_t pid )
  * streams.
  */
 
-#define stream_set(field_name, pid, value)				\
+#define stream_set(field_name, tid, value)				\
 	stream_state_t states[] = { S_RUNNING };			\
 	spm_t *p;							\
-	pid_t mypid = getpid();						\
+	pthread_t mytid = pthread_self();				\
 									\
-	if (mypid != (pid)) {						\
+	if ( !pthread_equal(mytid, (tid))) {				\
 		mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK,		\
 		      "stream_set_" #field_name "(): "			\
-		      "foreign stream (pid %d) "			\
-		      "not permitted to update this stream (pid %d)\n",	\
-		      mypid, (pid));					\
+		      "foreign stream (tid %lu) "			\
+		      "not permitted to update this stream (tid %lu)\n",\
+		      mytid, (tid));					\
 		return;							\
 	}								\
 									\
 	lock();								\
-	p = stream_find( (pid), states, N(states) );			\
+	p = stream_find( (tid), states, N(states) );			\
 	if (p) p->s_exit_ ## field_name = (value);			\
 	unlock();
 
-void stream_set_code( pid_t pid, int exit_code )
+void stream_set_code( pthread_t tid, int exit_code )
 {
-	stream_set( code, pid, exit_code );
+	stream_set( code, tid, exit_code );
 }
 
-void stream_set_return( pid_t pid, rv_t rv )
+void stream_set_return( pthread_t tid, rv_t rv )
 {
-	stream_set( return, pid, rv );
+	stream_set( return, tid, rv );
 }
 
-void stream_set_hint( pid_t pid, rv_t rv )
+void stream_set_hint( pthread_t tid, rv_t rv )
 {
-	stream_set( hint, pid, rv );
+	stream_set( hint, tid, rv );
 }
 
 
 bool_t
-stream_get_exit_status( pid_t pid,
+stream_get_exit_status( pthread_t tid,
 			stream_state_t states[],
 			int nstates,
 			stream_state_t *state,
@@ -262,7 +252,7 @@ stream_get_exit_status( pid_t pid,
 	spm_t *p;
 
 	lock();
-	p = stream_find( pid, states, nstates );
+	p = stream_find( tid, states, nstates );
 	if (! p) goto unlock;
 
 	if (state) *state = p->s_state;
diff --git a/common/stream.h b/common/stream.h
index 984634c..292792e 100644
--- a/common/stream.h
+++ b/common/stream.h
@@ -42,19 +42,19 @@
 typedef enum { S_FREE, S_RUNNING, S_ZOMBIE } stream_state_t;
 
 extern void stream_init( void );
-extern void stream_register( pid_t pid, intgen_t streamix );
-extern void stream_dead( pid_t pid );
-extern void stream_free( pid_t pid );
+extern void stream_register( pthread_t tid, intgen_t streamix );
+extern void stream_dead( pthread_t tid );
+extern void stream_free( pthread_t tid );
 extern int stream_find_all( stream_state_t states[],
 			    int nstates,
-			    pid_t pids[],
-			    int npids );
-extern intgen_t stream_getix( pid_t pid );
-extern void stream_set_code( pid_t pid, int code );
-extern void stream_set_return( pid_t pid, rv_t rv );
-extern void stream_set_hint( pid_t pid, rv_t rv );
-extern bool_t stream_exists( pid_t pid );
-extern bool_t stream_get_exit_status( pid_t pid,
+			    pthread_t tids[],
+			    int ntids );
+extern intgen_t stream_getix( pthread_t tid );
+extern void stream_set_code( pthread_t tid, int code );
+extern void stream_set_return( pthread_t tid, rv_t rv );
+extern void stream_set_hint( pthread_t tid, rv_t rv );
+extern bool_t stream_exists( pthread_t tid );
+extern bool_t stream_get_exit_status( pthread_t tid,
 				      stream_state_t states[],
 				      int nstates,
 				      stream_state_t *state,
diff --git a/dump/Makefile b/dump/Makefile
index d193f68..97879fa 100644
--- a/dump/Makefile
+++ b/dump/Makefile
@@ -30,7 +30,6 @@ COMMINCL = \
 	ts_mtio.h \
 	types.h \
 	util.h \
-	sproc.h \
 	rec_hdr.h
 
 INVINCL = \
@@ -68,8 +67,7 @@ COMMON = \
 	ring.c \
 	stream.c \
 	timeutil.c \
-	util.c \
-	sproc.c
+	util.c
 
 LOCALS = \
 	content.c \
diff --git a/dump/content.c b/dump/content.c
index 64bfe54..33f1166 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -1666,12 +1666,12 @@ baseuuidbypass:
 		sigaddset( &tty_set, SIGINT );
 		sigaddset( &tty_set, SIGQUIT );
 		sigaddset( &tty_set, SIGHUP );
-		sigprocmask( SIG_BLOCK, &tty_set, &orig_set );
+		pthread_sigmask( SIG_BLOCK, &tty_set, &orig_set );
 
 		result = create_inv_session( gwhdrtemplatep, &fsid, mntpnt,
 					     fsdevice, subtreecnt, strmix );
 
-		sigprocmask( SIG_SETMASK, &orig_set, NULL );
+		pthread_sigmask( SIG_SETMASK, &orig_set, NULL );
 
 		if ( !result ) {
 			return BOOL_FALSE;
diff --git a/restore/Makefile b/restore/Makefile
index ce3d6b4..c6f3f25 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -25,7 +25,6 @@ COMMINCL = \
 	qlock.h \
 	rec_hdr.h \
 	ring.h \
-	sproc.h \
 	stream.h \
 	timeutil.h \
 	ts_mtio.h \
@@ -64,7 +63,6 @@ COMMON = \
 	path.c \
 	qlock.c \
 	ring.c \
-	sproc.c \
 	stream.c \
 	timeutil.c \
 	util.c
diff --git a/restore/content.c b/restore/content.c
index 8dfa456..0108a40 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -33,6 +33,7 @@
 #include <dirent.h>
 #include <utime.h>
 #include <malloc.h>
+#include <pthread.h>
 
 #include "types.h"
 #include "timeutil.h"
@@ -2227,7 +2228,7 @@ content_stream_restore( ix_t thrdix )
 #if DEBUG_DUMPSTREAMS
 			{
 			    static int count[STREAM_MAX] = {0};
-			    intgen_t streamix = stream_getix( getpid() );
+			    intgen_t streamix = stream_getix( pthread_self() );
 			    if (++(count[streamix]) == 30) {
 				mlog( MLOG_TRACE,
 					"still waiting for dirs to be restored\n");
@@ -2390,7 +2391,7 @@ content_stream_restore( ix_t thrdix )
 #if DEBUG_DUMPSTREAMS
 			{
 			static int count[STREAM_MAX] = {0};
-			intgen_t streamix = stream_getix( getpid() );
+			intgen_t streamix = stream_getix( pthread_self() );
 			    if (++(count[streamix]) == 30) {
 				mlog( MLOG_NORMAL,
 				      "still waiting for dirs post-processing\n");
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
