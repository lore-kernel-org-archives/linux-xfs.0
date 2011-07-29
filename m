Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TKf3sf066960 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 15:41:03 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 4/4] xfsdump: convert to the POSIX signal API
Date: Fri, 29 Jul 2011 15:40:11 -0500
Message-Id: <1311972011-1446-5-git-send-email-wkendall@sgi.com>
In-Reply-To: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
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
sigprocmask, sigset with sigaction, and sigpause with sigsuspend.

childmain() and cldmgr_entry() are thread entry points. By the time
they are spawned the main thread will have already set its signal
mask, so no need to setup signals in these threads as the mask is
inherited.

ring_slave_entry() is a thread entry point but is spawned before the
main thread has its signal mask setup. Setup the thread's mask to
block the same signals that the main thread will block.  The main
thread should be reworked to set its mask earlier, but that will
require a fair amount of refactoring that is beyond the scope of
this patch.

Also just use abort() to generate a core file rather than sending
SIGQUIT and then waiting for it to arrive.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/cldmgr.c |    5 ---
 common/dlog.c   |   84 +++++++++++++++++++---------------------------
 common/main.c   |  100 ++++++++++++++++++++++++++++---------------------------
 common/ring.c   |   14 +++++---
 dump/content.c  |   21 +++++-------
 5 files changed, 104 insertions(+), 120 deletions(-)

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
index 6a243ef..d37bf1c 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -30,9 +30,6 @@
 #include "dlog.h"
 #include "getopt.h"
 
-extern bool_t miniroot;
-extern pid_t parentpid;
-
 static int dlog_ttyfd = -1;
 static bool_t dlog_allowed_flag = BOOL_FALSE;
 static bool_t dlog_timeouts_flag = BOOL_FALSE;
@@ -374,13 +371,14 @@ promptinput( char *buf,
 {
 	va_list args;
 	u_intgen_t alarm_save = 0;
-	void (* sigalrm_save)(int) = NULL;
-	void (* sigint_save)(int) = NULL;
-	void (* sighup_save)(int) = NULL;
-	void (* sigterm_save)(int) = NULL;
-	void (* sigquit_save)(int) = NULL;
+	sigset_t dlog_set, orig_set;
+	struct sigaction sa;
+	struct sigaction sigalrm_save;
+	struct sigaction sigint_save;
+	struct sigaction sighup_save;
+	struct sigaction sigterm_save;
+	struct sigaction sigquit_save;
 	intgen_t nread;
-	pid_t pid = getpid( );
 
 	/* display the pre-prompt
 	 */
@@ -400,38 +398,39 @@ promptinput( char *buf,
 	mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, promptstr );
 
 	/* set up signal handling
+	 * the mlog lock is held for the life of the dialog and it's possible
+	 * the main thread, which normally does the signal handling, is now
+	 * waiting on the mlog lock trying to log a message. so we unblock
+	 * the relevant signals for this thread. note this means the current
+	 * thread or the main thread might handle one of these signals.
 	 */
+	sigemptyset( &dlog_set );
+	sa.sa_handler = sighandler;
+	sigfillset( &sa.sa_mask );
+	sa.sa_flags = 0;
 	dlog_signo_received = -1;
 	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGALRM );
-		}
-		sigalrm_save = sigset( SIGALRM, sighandler );
+		sigaddset( &dlog_set, SIGALRM );
+		sigaction( SIGALRM, &sa, &sigalrm_save );
 		alarm_save = alarm( ( u_intgen_t )timeout );
 	}
 	if ( sigintix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGINT );
-		}
-		sigint_save = sigset( SIGINT, sighandler );
+		sigaddset( &dlog_set, SIGINT );
+		sigaction( SIGINT, &sa, &sigint_save );
 	}
 	if ( sighupix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGHUP );
-		}
-		sighup_save = sigset( SIGHUP, sighandler );
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGTERM );
-		}
-		sigterm_save = sigset( SIGTERM, sighandler );
+		sigaddset( &dlog_set, SIGHUP );
+		sigaction( SIGHUP, &sa, &sighup_save );
+		sigaddset( &dlog_set, SIGTERM );
+		sigaction( SIGTERM, &sa, &sigterm_save );
 	}
 	if ( sigquitix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGQUIT );
-		}
-		sigquit_save = sigset( SIGQUIT, sighandler );
+		sigaddset( &dlog_set, SIGQUIT );
+		sigaction( SIGQUIT, &sa, &sigquit_save );
 	}
 
+	sigprocmask( SIG_UNBLOCK, &dlog_set, &orig_set );
+
 	/* wait for input, timeout, or interrupt
 	 */
 	ASSERT( dlog_ttyfd >= 0 );
@@ -439,34 +438,21 @@ promptinput( char *buf,
 
 	/* restore signal handling
 	 */
+	sigprocmask( SIG_SETMASK, &orig_set, NULL );
+
 	if ( sigquitix != IXMAX ) {
-		( void )sigset( SIGQUIT, sigquit_save );
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGQUIT );
-		}
+		sigaction( SIGQUIT, &sigquit_save, NULL );
 	}
 	if ( sighupix != IXMAX ) {
-		( void )sigset( SIGHUP, sighup_save );
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGHUP );
-		}
-		( void )sigset( SIGTERM, sigterm_save );
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGTERM );
-		}
+		sigaction( SIGHUP, &sighup_save, NULL );
+		sigaction( SIGTERM, &sigterm_save, NULL );
 	}
 	if ( sigintix != IXMAX ) {
-		( void )sigset( SIGINT, sigint_save );
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGINT );
-		}
+		sigaction( SIGINT, &sigint_save, NULL );
 	}
 	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
 		( void )alarm( alarm_save );
-		( void )sigset( SIGALRM, sigalrm_save );
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGALRM );
-		}
+		sigaction( SIGALRM, &sigalrm_save, NULL );
 	}
 	
 	/* check for timeout or interrupt
diff --git a/common/main.c b/common/main.c
index 73c63bd..8c2c66d 100644
--- a/common/main.c
+++ b/common/main.c
@@ -546,6 +546,9 @@ main( int argc, char *argv[] )
 	 * loop.
 	 */
 	if ( ! miniroot && ! pipeline ) {
+		struct sigaction sa;
+		sigset_t blocked_set;
+
 		stop_in_progress = BOOL_FALSE;
 		coredump_requested = BOOL_FALSE;
 		sighup_received = BOOL_FALSE;
@@ -554,22 +557,32 @@ main( int argc, char *argv[] )
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
+		sigfillset(&sa.sa_mask);
+		sa.sa_flags = 0;
+
+		sigaction( SIGINT, &sa, NULL );
+		sigaction( SIGHUP, &sa, NULL );
+		sigaction( SIGTERM, &sa, NULL );
+		sigaction( SIGQUIT, &sa, NULL );
+		sigaction( SIGALRM, &sa, NULL );
 
 		/* ignore SIGPIPE, instead handle EPIPE as part
 		 * of normal sys call error handling
 		 */
-		sigset( SIGPIPE, SIG_IGN );
+		sa.sa_handler = SIG_IGN;
+		sigaction( SIGPIPE, &sa, NULL );
 	}
 
 	/* do content initialization.
@@ -588,16 +601,22 @@ main( int argc, char *argv[] )
 	 * with just one stream.
 	 */
 	if ( miniroot || pipeline ) {
+		struct sigaction sa;
 		intgen_t exitcode;
 
-		sigset( SIGINT, sighandler );
-		sigset( SIGHUP, sighandler );
-		sigset( SIGTERM, sighandler );
+		sa.sa_handler = sighandler;
+		sigfillset(&sa.sa_mask);
+		sa.sa_flags = 0;
+
+		sigaction( SIGINT, &sa, NULL );
+		sigaction( SIGHUP, &sa, NULL );
+		sigaction( SIGTERM, &sa, NULL );
 
 		/* ignore SIGPIPE, instead handle EPIPE as part
 		 * of normal sys call error handling
 		 */
-		sigset( SIGPIPE, SIG_IGN );
+		sa.sa_handler = SIG_IGN;
+		sigaction( SIGPIPE, &sa, NULL );
 
 		ok = drive_init2( argc,
 				  argv,
@@ -689,6 +708,7 @@ main( int argc, char *argv[] )
 		time32_t now;
 		bool_t stop_requested = BOOL_FALSE;
 		intgen_t stop_timeout = -1;
+		sigset_t empty_set;
 
 		/* if there was an initialization error,
 		 * immediately stop all children.
@@ -877,16 +897,8 @@ main( int argc, char *argv[] )
 
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
 
@@ -894,14 +906,9 @@ main( int argc, char *argv[] )
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
@@ -1074,6 +1081,10 @@ bool_t
 preemptchk( int flg )
 {
 	bool_t preempt_requested;
+	int i;
+	int sigs[] = { SIGINT, SIGHUP, SIGTERM, SIGQUIT };
+	int num_sigs = sizeof(sigs) / sizeof(sigs[0]);
+	sigset_t pending_set, handle_set;
 
 	/* see if a progress report needed
 	 */
@@ -1110,15 +1121,14 @@ preemptchk( int flg )
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
 
@@ -1542,14 +1552,6 @@ childmain( void *arg1 )
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
