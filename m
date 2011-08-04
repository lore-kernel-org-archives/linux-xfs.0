Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74MV7F4089295 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 17:31:07 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 3/7] xfsdump: remove SIGCHLD handling
Date: Thu,  4 Aug 2011 17:30:07 -0500
Message-Id: <1312497011-24840-4-git-send-email-wkendall@sgi.com>
In-Reply-To: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
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

The multi-stream version of xfsdump for IRIX used sprocs for
threading. When a "thread" exits with sprocs, a SIGCHLD is sent to
the main thread just as if a regular child process exited. A future
multi-stream version of xfsdump would use pthreads, so the SIGCHLD
code is no longer needed. So:

- No longer register for or handle SIGCHLD (SIGCLD).
- Remove signal handling code for child processes.
- Remove cldmgr_killall() as there are no children.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/cldmgr.c |   28 ----------
 common/cldmgr.h |    4 --
 common/main.c   |  155 ++++++++++---------------------------------------------
 common/ring.c   |    1 -
 4 files changed, 28 insertions(+), 160 deletions(-)

diff --git a/common/cldmgr.c b/common/cldmgr.c
index 97507f3..3520c6e 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -59,16 +59,10 @@ static pid_t cldmgr_parentpid;
 bool_t
 cldmgr_init( void )
 {
-	/* REFERENCED */
-	intgen_t rval;
-
 	( void )memset( ( void * )cld, 0, sizeof( cld ));
 	cldmgr_stopflag = BOOL_FALSE;
 	cldmgr_parentpid = getpid( );
 
-	rval = atexit( cldmgr_killall );
-	ASSERT( ! rval );
-
 	return BOOL_TRUE;
 }
 
@@ -125,27 +119,6 @@ cldmgr_stop( void )
 	cldmgr_stopflag = BOOL_TRUE;
 }
 
-/* cldmgr_killall()
- *
- */
-void
-cldmgr_killall( void )
-{
-	cld_t *p = cld;
-	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
-
-	signal( SIGCLD, SIG_IGN );
-	for ( ; p < ep ; p++ ) {
-		if ( p->c_busy ) {
-			mlog( MLOG_NITTY | MLOG_PROC,
-			      "sending SIGKILL to pid %d\n",
-			      p->c_pid );
-			kill( p->c_pid, SIGKILL );
-			cldmgr_died( p->c_pid );
-		}
-	}
-}
-
 void
 cldmgr_died( pid_t pid )
 {
@@ -247,7 +220,6 @@ cldmgr_entry( void *arg1 )
 	signal( SIGHUP, SIG_IGN );
 	signal( SIGINT, SIG_IGN );
 	signal( SIGQUIT, SIG_IGN );
-	signal( SIGCLD, SIG_DFL );
 	alarm( 0 );
 	cldp->c_pid = pid;
 	ok = qlock_thrdinit( );
diff --git a/common/cldmgr.h b/common/cldmgr.h
index d80fe8b..bb3f612 100644
--- a/common/cldmgr.h
+++ b/common/cldmgr.h
@@ -40,10 +40,6 @@ extern bool_t cldmgr_create( int ( * entry )( void *arg1 ),
  */
 extern void cldmgr_stop( void );
 
-/* cldmgr_killall - kills all children
- */
-extern void cldmgr_killall( void );
-
 /* cldmgr_died - tells the child manager that the child died
  */
 extern void cldmgr_died( pid_t pid );
diff --git a/common/main.c b/common/main.c
index d21b559..b6674f9 100644
--- a/common/main.c
+++ b/common/main.c
@@ -483,7 +483,6 @@ main( int argc, char *argv[] )
 	 */
 	ok = drive_init1( argc, argv, miniroot );
 	if ( ! ok ) {
-		cldmgr_killall( );
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
@@ -572,8 +571,6 @@ main( int argc, char *argv[] )
 		alarm( 0 );
 		sigset( SIGALRM, sighandler );
 		sighold( SIGALRM );
-		sigset( SIGCLD, sighandler );
-		sighold( SIGCLD );
 	}
 
 	/* do content initialization.
@@ -585,7 +582,6 @@ main( int argc, char *argv[] )
 	ok = content_init( argc, argv, vmsz / VMSZ_PER );
 #endif /* RESTORE */
 	if ( ! ok ) {
-		cldmgr_killall( );
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
@@ -881,9 +877,7 @@ main( int argc, char *argv[] )
 		sigrelse( SIGHUP );
 		sigrelse( SIGTERM );
 		sigrelse( SIGQUIT );
-		sigrelse( SIGALRM );
-		( void )sigpause( SIGCLD );
-		sighold( SIGCLD );
+		( void )sigpause( SIGALRM );
 		sighold( SIGALRM );
 		sighold( SIGQUIT );
 		sighold( SIGTERM );
@@ -896,10 +890,6 @@ main( int argc, char *argv[] )
 	 */
 	if ( coredump_requested ) {
 		mlog( MLOG_DEBUG | MLOG_PROC,
-		      "killing all remaining children\n" );
-		cldmgr_killall( );
-		sleep( 1 );
-		mlog( MLOG_DEBUG | MLOG_PROC,
 		      "parent sending SIGQUIT to self (pid %d)\n",
 		      parentpid );
 		sigrelse( SIGQUIT );
@@ -1492,11 +1482,6 @@ mrh_sighandler( int signo )
 static void
 sighandler( int signo )
 {
-	/* get the pid and stream index
-	 */
-	pid_t pid = getpid( );
-	intgen_t stix = stream_getix( pid );
-
 	/* if in miniroot, don't do anything risky. just quit.
 	 */
 	if ( miniroot || pipeline ) {
@@ -1516,117 +1501,34 @@ sighandler( int signo )
 		exit( rval );
 	}
 
-	/* if death of a child of a child, bury the child and return.
-	 * probably rmt.
-	 */
-	if ( pid != parentpid && signo == SIGCLD ) {
-		intgen_t stat;
-		( void )wait( &stat );
-		( void )sigset( signo, sighandler );
-		return;
-	}
-
-	/* if neither parent nor managed child nor slave, exit
-	 */
-	if ( pid != parentpid && stix == -1 ) {
-		exit( 0 );
-	}
-
-	/* parent signal handling
-	 */
-	if ( pid == parentpid ) {
-		pid_t cid;
-		intgen_t stat;
-		switch ( signo ) {
-		case SIGCLD:
-			/* bury the child and notify the child manager
-			 * abstraction of its death, and record death stats
-			 */
-			cid = wait( &stat );
-			stix = stream_getix( cid );
-			cldmgr_died( cid );
-			if ( WIFSIGNALED( stat ) || WEXITSTATUS( stat ) > 0 ) {
-				if ( prbcld_cnt == 0 ) {
-					if ( WIFSIGNALED( stat )) {
-						prbcld_pid = cid;
-						prbcld_xc = 0;
-						prbcld_signo = WTERMSIG( stat );
-					} else if ( WEXITSTATUS( stat ) > 0 ) {
-						prbcld_pid = cid;
-						prbcld_xc = WEXITSTATUS( stat );
-						prbcld_signo = 0;
-					}
-				}
-				prbcld_cnt++;
-			}
-			( void )sigset( signo, sighandler );
-			return;
-		case SIGHUP:
-			/* immediately disable further dialogs
-			 */
-			dlog_desist( );
-			sighup_received = BOOL_TRUE;
-			return;
-		case SIGTERM:
-			/* immediately disable further dialogs
-			 */
-			dlog_desist( );
-			sigterm_received = BOOL_TRUE;
-			return;
-		case SIGINT:
-			sigint_received = BOOL_TRUE;
-			return;
-		case SIGQUIT:
-			/* immediately disable further dialogs
-			 */
-			dlog_desist( );
-			sigquit_received = BOOL_TRUE;
-			return;
-		case SIGALRM:
-			return;
-		default:
-			sigstray_received = signo;
-			return;
-		}
-	}
-
-	/* managed child handling
-	 */
-	if ( stream_getix( pid ) != -1 ) {
-		switch ( signo ) {
-		case SIGHUP:
-			/* can get SIGHUP during dialog: just dismiss
-			 */
-			return;
-		case SIGTERM:
-			/* can get SIGTERM during dialog: just dismiss
-			 */
-			return;
-		case SIGINT:
-			/* can get SIGINT during dialog: just dismiss
-			 */
-			return;
-		case SIGQUIT:
-			/* can get SIGQUIT during dialog: just dismiss
-			 */
-			return;
-		case SIGALRM:
-			/* accept and do nothing about alarm signals
-			 */
-			return;
-		default:
-			/* should not be any other captured signals:
-			 * request a core dump
-			 */
-			mlog_exit( EXIT_FAULT, RV_NONE );
-			exit( EXIT_FAULT );
-			return;
-		}
+	switch ( signo ) {
+	case SIGHUP:
+		/* immediately disable further dialogs
+		*/
+		dlog_desist( );
+		sighup_received = BOOL_TRUE;
+		break;
+	case SIGTERM:
+		/* immediately disable further dialogs
+		*/
+		dlog_desist( );
+		sigterm_received = BOOL_TRUE;
+		break;
+	case SIGINT:
+		sigint_received = BOOL_TRUE;
+		break;
+	case SIGQUIT:
+		/* immediately disable further dialogs
+		 */
+		dlog_desist( );
+		sigquit_received = BOOL_TRUE;
+		break;
+	case SIGALRM:
+		break;
+	default:
+		sigstray_received = signo;
+		break;
 	}
-
-	/* if some other child, just exit
-	 */
-	exit( 0 );
 }
 
 static int
@@ -1643,7 +1545,6 @@ childmain( void *arg1 )
 	sigset( SIGINT, SIG_IGN );
 	sigset( SIGQUIT, SIG_IGN );
 	sigset( SIGALRM, SIG_IGN );
-	sigset( SIGCLD, SIG_IGN );
 
 	/* Determine which stream I am.
 	 */
diff --git a/common/ring.c b/common/ring.c
index b132ab9..237d884 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -413,7 +413,6 @@ ring_slave_entry( void *ringctxp )
 	sigset( SIGINT, SIG_IGN );
 	sigset( SIGQUIT, SIG_IGN );
 	sigset( SIGALRM, SIG_IGN );
-	sigset( SIGCLD, SIG_IGN );
 
 	/* record slave pid to be used to kill slave
 	 */
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
