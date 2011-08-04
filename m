Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74MV8P7089306 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 17:31:08 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 6/7] xfsdump: convert to the POSIX signal API
Date: Thu,  4 Aug 2011 17:30:10 -0500
Message-Id: <1312497011-24840-7-git-send-email-wkendall@sgi.com>
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

Convert from using the System V signal API to the POSIX API. For
xfsdump, this mostly means replacing sigrelse/sighold with
sigprocmask, sigset with sigaction and sigpause with sigsuspend.

Note that sigprocmask calls will be replaced with pthread_sigmask
when pthread support is added to xfsdump.

childmain() and cldmgr_entry() are thread entry points. By the time
they are spawned the main thread will have already set its signal
mask, so no need to setup signals in the thread as the mask is
inherited.

ring_slave_entry() is a thread entry point but is spawned before the
main thread has its signal mask setup. Setup the thread's mask to
block the same signals that the main thread will block.  The main
thread should be reworked to set its mask earlier, but that will
require a fair amount of refactoring that is beyond the scope of
this patch.

Also simplify code to generate a core file to just use abort()
rather than sending SIGQUIT and then waiting for it to arrive.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/cldmgr.c |    5 ---
 common/dlog.c   |   44 ++++++-------------------
 common/main.c   |   95 ++++++++++++++++++++++++++----------------------------
 common/ring.c   |   14 +++++---
 dump/content.c  |   21 +++++-------
 5 files changed, 74 insertions(+), 105 deletions(-)

diff --git a/common/cldmgr.c b/common/cldmgr.c
index 3520c6e..7784a15 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -23,7 +23,6 @@
 #include <sys/ipc.h>
 #include <sys/sem.h>
 #include <sys/prctl.h>
-#include <signal.h>
 #include <errno.h>
 
 #include "types.h"
@@ -217,10 +216,6 @@ cldmgr_entry( void *arg1 )
 	/* REFERENCED */
 	bool_t ok;
 
-	signal( SIGHUP, SIG_IGN );
-	signal( SIGINT, SIG_IGN );
-	signal( SIGQUIT, SIG_IGN );
-	alarm( 0 );
 	cldp->c_pid = pid;
 	ok = qlock_thrdinit( );
 	ASSERT( ok );
diff --git a/common/dlog.c b/common/dlog.c
index 749de1b..59a56bd 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -31,9 +31,6 @@
 #include "dlog.h"
 #include "getopt.h"
 
-extern bool_t miniroot;
-extern pid_t parentpid;
-
 static int dlog_ttyfd = -1;
 static bool_t dlog_allowed_flag = BOOL_FALSE;
 static bool_t dlog_timeouts_flag = BOOL_FALSE;
@@ -383,7 +380,7 @@ promptinput( char *buf,
 	va_list args;
 	time32_t now = time( NULL );
 	intgen_t nread = -1;
-	pid_t pid = getpid( );
+	sigset_t orig_set;
 
 	/* display the pre-prompt
 	 */
@@ -411,32 +408,28 @@ promptinput( char *buf,
 	}
 
 	/* set up signal handling
+	 * the mlog lock is held for the life of the dialog (see dlog_begin)
+	 * and it's possible the main thread, which normally does the signal
+	 * handling, is now waiting on the mlog lock trying to log a message.
+	 * so unblock the relevant signals for this thread. note this means
+	 * the current thread or the main thread might handle one of these
+	 * signals.
 	 */
 	dlog_signo_received = -1;
 	sigemptyset( &dlog_registered_sigs );
 	if ( sigintix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGINT );
-		}
 		sigaddset( &dlog_registered_sigs, SIGINT );
 	}
 	if ( sighupix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGHUP );
-		}
 		sigaddset( &dlog_registered_sigs, SIGHUP );
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGTERM );
-		}
 		sigaddset( &dlog_registered_sigs, SIGTERM );
 	}
 	if ( sigquitix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGQUIT );
-		}
 		sigaddset( &dlog_registered_sigs, SIGQUIT );
 	}
 
+	sigprocmask( SIG_UNBLOCK, &dlog_registered_sigs, &orig_set );
+
 	/* wait for input, timeout, or interrupt.
 	 * note we come out of the select() frequently in order to
 	 * check for a signal. the signal may have been handled by the
@@ -461,25 +454,8 @@ promptinput( char *buf,
 
 	/* restore signal handling
 	 */
+	sigprocmask( SIG_SETMASK, &orig_set, NULL );
 	sigemptyset( &dlog_registered_sigs );
-	if ( sigquitix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGQUIT );
-		}
-	}
-	if ( sighupix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGHUP );
-		}
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGTERM );
-		}
-	}
-	if ( sigintix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGINT );
-		}
-	}
 	
 	/* check for timeout or interrupt
 	 */
diff --git a/common/main.c b/common/main.c
index 825c894..d3b6662 100644
--- a/common/main.c
+++ b/common/main.c
@@ -545,13 +545,20 @@ main( int argc, char *argv[] )
 	 * be released at pre-emption points and upon pausing in the main
 	 * loop.
 	 */
+	
+	struct sigaction sa;
+	sigfillset(&sa.sa_mask);
+	sa.sa_flags = 0;
 
 	/* always ignore SIGPIPE, instead handle EPIPE as part
 	 * of normal sys call error handling
 	 */
-	sigset( SIGPIPE, SIG_IGN );
+	sa.sa_handler = SIG_IGN;
+	sigaction( SIGPIPE, &sa, NULL );
 
 	if ( ! miniroot && ! pipeline ) {
+		sigset_t blocked_set;
+
 		stop_in_progress = BOOL_FALSE;
 		coredump_requested = BOOL_FALSE;
 		sighup_received = BOOL_FALSE;
@@ -560,17 +567,23 @@ main( int argc, char *argv[] )
 		sigquit_received = BOOL_FALSE;
 		sigstray_received = BOOL_FALSE;
 		prbcld_cnt = 0;
-		sigset( SIGINT, sighandler );
-		sighold( SIGINT );
-		sigset( SIGHUP, sighandler );
-		sighold( SIGHUP );
-		sigset( SIGTERM, sighandler );
-		sighold( SIGTERM );
-		sigset( SIGQUIT, sighandler );
-		sighold( SIGQUIT );
+
 		alarm( 0 );
-		sigset( SIGALRM, sighandler );
-		sighold( SIGALRM );
+
+		sigemptyset( &blocked_set );
+		sigaddset( &blocked_set, SIGINT );
+		sigaddset( &blocked_set, SIGHUP );
+		sigaddset( &blocked_set, SIGTERM );
+		sigaddset( &blocked_set, SIGQUIT );
+		sigaddset( &blocked_set, SIGALRM );
+		sigprocmask( SIG_SETMASK, &blocked_set, NULL );
+
+		sa.sa_handler = sighandler;
+		sigaction( SIGINT, &sa, NULL );
+		sigaction( SIGHUP, &sa, NULL );
+		sigaction( SIGTERM, &sa, NULL );
+		sigaction( SIGQUIT, &sa, NULL );
+		sigaction( SIGALRM, &sa, NULL );
 	}
 
 	/* do content initialization.
@@ -591,10 +604,11 @@ main( int argc, char *argv[] )
 	if ( miniroot || pipeline ) {
 		intgen_t exitcode;
 
-		sigset( SIGINT, sighandler );
-		sigset( SIGHUP, sighandler );
-		sigset( SIGTERM, sighandler );
-		sigset( SIGQUIT, sighandler );
+		sa.sa_handler = sighandler;
+		sigaction( SIGINT, &sa, NULL );
+		sigaction( SIGHUP, &sa, NULL );
+		sigaction( SIGTERM, &sa, NULL );
+		sigaction( SIGQUIT, &sa, NULL );
 
 		ok = drive_init2( argc,
 				  argv,
@@ -686,6 +700,7 @@ main( int argc, char *argv[] )
 		time32_t now;
 		bool_t stop_requested = BOOL_FALSE;
 		intgen_t stop_timeout = -1;
+		sigset_t empty_set;
 
 		/* if there was an initialization error,
 		 * immediately stop all children.
@@ -874,16 +889,8 @@ main( int argc, char *argv[] )
 
 		/* sleep until next signal
 		 */
-		sigrelse( SIGINT );
-		sigrelse( SIGHUP );
-		sigrelse( SIGTERM );
-		sigrelse( SIGQUIT );
-		( void )sigpause( SIGALRM );
-		sighold( SIGALRM );
-		sighold( SIGQUIT );
-		sighold( SIGTERM );
-		sighold( SIGHUP );
-		sighold( SIGINT );
+		sigemptyset( &empty_set );
+		sigsuspend( &empty_set );
 		( void )alarm( 0 );
 	}
 
@@ -891,14 +898,9 @@ main( int argc, char *argv[] )
 	 */
 	if ( coredump_requested ) {
 		mlog( MLOG_DEBUG | MLOG_PROC,
-		      "parent sending SIGQUIT to self (pid %d)\n",
+		      "core dump requested, aborting (pid %d)\n",
 		      parentpid );
-		sigrelse( SIGQUIT );
-		sigset( SIGQUIT, SIG_DFL );
-		kill( parentpid, SIGQUIT );
-		for ( ; ; ) {
-			sleep( 1 );
-		}
+		abort();
 	}
 
 	/* determine if dump or restore was interrupted
@@ -1071,6 +1073,10 @@ bool_t
 preemptchk( int flg )
 {
 	bool_t preempt_requested;
+	int i;
+	int sigs[] = { SIGINT, SIGHUP, SIGTERM, SIGQUIT };
+	int num_sigs = sizeof(sigs) / sizeof(sigs[0]);
+	sigset_t pending_set, handle_set;
 
 	/* see if a progress report needed
 	 */
@@ -1107,15 +1113,14 @@ preemptchk( int flg )
 	/* release signals momentarily to let any pending ones
 	 * invoke signal handler and set flags
 	 */
-	sigrelse( SIGINT );
-	sigrelse( SIGHUP );
-	sigrelse( SIGTERM );
-	sigrelse( SIGQUIT );
-
-	sighold( SIGQUIT );
-	sighold( SIGTERM );
-	sighold( SIGHUP );
-	sighold( SIGINT );
+	sigpending( &pending_set );
+	for ( i = 0; i < num_sigs; i++ ) {
+		if ( sigismember( &pending_set, sigs[i] ) == 1 ) {
+			sigfillset( &handle_set );
+			sigdelset( &handle_set, sigs[i] );
+			sigsuspend( &handle_set );
+		}
+	}
 
 	preempt_requested = BOOL_FALSE;
 
@@ -1544,14 +1549,6 @@ childmain( void *arg1 )
 	intgen_t exitcode;
 	drive_t *drivep;
 
-	/* ignore signals
-	 */
-	sigset( SIGHUP, SIG_IGN );
-	sigset( SIGTERM, SIG_IGN );
-	sigset( SIGINT, SIG_IGN );
-	sigset( SIGQUIT, SIG_IGN );
-	sigset( SIGALRM, SIG_IGN );
-
 	/* Determine which stream I am.
 	 */
 	stix = ( ix_t )arg1;
diff --git a/common/ring.c b/common/ring.c
index 237d884..f6e95e8 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -404,15 +404,19 @@ ring_slave_put( ring_t *ringp, ring_msg_t *msgp )
 static int
 ring_slave_entry( void *ringctxp )
 {
+	sigset_t blocked_set;
 	ring_t *ringp = ( ring_t * )ringctxp;
 	enum { LOOPMODE_NORMAL, LOOPMODE_IGNORE, LOOPMODE_DIE } loopmode;
 
-	/* ignore signals
+	/* block signals, let the main thread handle them
 	 */
-	sigset( SIGHUP, SIG_IGN );
-	sigset( SIGINT, SIG_IGN );
-	sigset( SIGQUIT, SIG_IGN );
-	sigset( SIGALRM, SIG_IGN );
+	sigemptyset( &blocked_set );
+	sigaddset( &blocked_set, SIGINT );
+	sigaddset( &blocked_set, SIGHUP );
+	sigaddset( &blocked_set, SIGTERM );
+	sigaddset( &blocked_set, SIGQUIT );
+	sigaddset( &blocked_set, SIGALRM );
+	sigprocmask( SIG_SETMASK, &blocked_set, NULL );
 
 	/* record slave pid to be used to kill slave
 	 */
diff --git a/dump/content.c b/dump/content.c
index c6840e5..fcc952e 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -1701,6 +1701,7 @@ baseuuidbypass:
 	if ( sc_inv_updatepr ) {
 		char *qmntpnt;
 		char *qfsdevice;
+		sigset_t tty_set, orig_set;
 
 		rval = atexit( inv_cleanup );
 		ASSERT( ! rval );
@@ -1738,9 +1739,11 @@ baseuuidbypass:
 
 		/* hold tty signals while creating a new inventory session
 		 */
-		( void )sighold( SIGINT );
-		( void )sighold( SIGQUIT );
-		( void )sighold( SIGHUP );
+		sigemptyset( &tty_set );
+		sigaddset( &tty_set, SIGINT );
+		sigaddset( &tty_set, SIGQUIT );
+		sigaddset( &tty_set, SIGHUP );
+		sigprocmask( SIG_BLOCK, &tty_set, &orig_set );
 
 		sc_inv_sestoken = inv_writesession_open( sc_inv_idbtoken,
 						&fsid,
@@ -1755,9 +1758,7 @@ baseuuidbypass:
 						qmntpnt,
 						qfsdevice );
 		if( sc_inv_sestoken == INV_TOKEN_NULL ) {
-			( void )sigrelse( SIGINT );
-			( void )sigrelse( SIGQUIT );
-			( void )sigrelse( SIGHUP );
+			sigprocmask( SIG_SETMASK, &orig_set, NULL );
 			return BOOL_FALSE;
 		}
 
@@ -1782,16 +1783,12 @@ baseuuidbypass:
 				free( ( void * )drvpath );
 			}
 			if ( sc_inv_stmtokenp[ strmix ] == INV_TOKEN_NULL ) {
-				( void )sigrelse( SIGINT );
-				( void )sigrelse( SIGQUIT );
-				( void )sigrelse( SIGHUP );
+				sigprocmask( SIG_SETMASK, &orig_set, NULL );
 				return BOOL_FALSE;
 			}
 		}
 
-		( void )sigrelse( SIGINT );
-		( void )sigrelse( SIGQUIT );
-		( void )sigrelse( SIGHUP );
+		sigprocmask( SIG_SETMASK, &orig_set, NULL );
 	}
 
 	/* set media change flags to FALSE;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
