Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7KxiXO076060 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:59:44 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 6/8] xfsdump: process thread exit status
Date: Mon,  7 Nov 2011 14:58:29 -0600
Message-Id: <1320699511-12281-7-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
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

When IRIX sprocs were in use, the main thread was notified of a thread
exit just as if a child process exited -- it received SIGCHLD. The main
thread would grab the pid and exit status, then call cldmgr_died() to
inform it that the child was gone so the slot in the child array could
be freed up for reuse.

This patch implements a similar mechanism for pthreads. The "c_busy"
field in struct cld has been replaced with a "c_state" field that
indicates whether the array slot is free (C_AVAIL), in use (C_ALIVE), or
is waiting to be joined (C_EXITED). Additionally a "c_exit_code" field
has been added to store the thread's exit value. Normally this is set
when the thread entry function returns, but it is initialized to
EXIT_INTERRUPT in case the thread is cancelled or calls pthread_exit()
rather than returning (neither of which happens in the code today).

When the child thread starts, it registers a pthread cleanup handler
which takes care of marking the child as C_EXITED and notifies the main
thread that a child is gone. Doing this in a cleanup handler ensures
that it's done regardless of how the thread exits. The main thread's
loop is based around sigsuspsend(), so the notification is done by
sending SIGUSR1. The main thread will then call cldmgr_join() to join
all exited threads and obtain their exit status.

Additional changes:
* cldmgr_findbypid() has been removed, it's no longer referenced.
* stream_dead() no longer grabs the lock(), because it's called
  only from cldmgr_join() which already holds the lock().

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/cldmgr.c |   88 +++++++++++++++++++++++++++++++++++-------------------
 common/cldmgr.h |    7 +++-
 common/main.c   |   33 +++++---------------
 common/stream.c |    3 +-
 common/stream.h |    1 +
 5 files changed, 73 insertions(+), 59 deletions(-)

diff --git a/common/cldmgr.c b/common/cldmgr.c
index 4574834..be7de34 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -26,6 +26,7 @@
 #include <errno.h>
 #include <pthread.h>
 
+#include "exit.h"
 #include "types.h"
 #include "lock.h"
 #include "qlock.h"
@@ -36,8 +37,12 @@
 extern size_t pgsz;
 
 #define CLD_MAX	( STREAM_SIMMAX * 2 )
+
+typedef enum { C_AVAIL, C_ALIVE, C_EXITED } state_t;
+
 struct cld {
-	bool_t c_busy;
+	state_t c_state;
+	intgen_t c_exit_code;
 	pthread_t c_tid;
 	ix_t c_streamix;
 	int ( * c_entry )( void *arg1 );
@@ -50,8 +55,8 @@ static cld_t cld[ CLD_MAX ];
 static bool_t cldmgr_stopflag;
 
 static cld_t *cldmgr_getcld( void );
-static cld_t * cldmgr_findbytid( pthread_t );
 static void *cldmgr_entry( void * );
+static void cldmgr_cleanup( void * );
 /* REFERENCED */
 static pthread_t cldmgr_parenttid;
 
@@ -87,6 +92,7 @@ cldmgr_create( int ( * entry )( void *arg1 ),
 		return BOOL_FALSE;
 	}
 
+	cldp->c_exit_code = EXIT_INTERRUPT;
 	cldp->c_streamix = streamix;
 	cldp->c_entry = entry;
 	cldp->c_arg1 = arg1;
@@ -117,18 +123,37 @@ cldmgr_stop( void )
 	cldmgr_stopflag = BOOL_TRUE;
 }
 
-void
-cldmgr_died( pthread_t tid )
+intgen_t
+cldmgr_join( void )
 {
-	cld_t *cldp = cldmgr_findbytid( tid );
+	cld_t *p = cld;
+	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
+	intgen_t xc = EXIT_NORMAL;
 
-	if ( ! cldp ) {
-		return;
-	}
-	cldp->c_busy = BOOL_FALSE;
-	if ( ( intgen_t )( cldp->c_streamix ) >= 0 ) {
-		stream_dead( tid );
+	lock();
+	for ( ; p < ep ; p++ ) {
+		if ( p->c_state == C_EXITED ) {
+			if ( ( intgen_t )( p->c_streamix ) >= 0 ) {
+				stream_dead( p->c_tid );
+			}
+			pthread_join( p->c_tid, NULL );
+			if ( p->c_exit_code != EXIT_NORMAL && xc != EXIT_FAULT )
+				xc = p->c_exit_code;
+			if ( p->c_exit_code != EXIT_NORMAL ) {
+				mlog( MLOG_DEBUG | MLOG_PROC | MLOG_NOLOCK,
+					"child (thread %lu) requested stop: "
+					"exit code %d (%s)\n",
+					p->c_tid, p->c_exit_code,
+					exit_codestring( p->c_exit_code ));
+			}
+
+			// reinit this child for reuse
+			memset( ( void * )p, 0, sizeof( cld_t ));
+		}
 	}
+	unlock();
+
+	return xc;
 }
 
 bool_t
@@ -147,7 +172,7 @@ cldmgr_remainingcnt( void )
 	cnt = 0;
 	lock( );
 	for ( ; p < ep ; p++ ) {
-		if ( p->c_busy ) {
+		if ( p->c_state == C_ALIVE ) {
 			cnt++;
 		}
 	}
@@ -164,7 +189,7 @@ cldmgr_otherstreamsremain( ix_t streamix )
 
 	lock( );
 	for ( ; p < ep ; p++ ) {
-		if ( p->c_busy && p->c_streamix != streamix ) {
+		if ( p->c_state == C_ALIVE && p->c_streamix != streamix ) {
 			unlock( );
 			return BOOL_TRUE;
 		}
@@ -182,8 +207,8 @@ cldmgr_getcld( void )
 
 	lock();
 	for ( ; p < ep ; p++ ) {
-		if ( ! p->c_busy ) {
-			p->c_busy = BOOL_TRUE;
+		if ( p->c_state == C_AVAIL ) {
+			p->c_state = C_ALIVE;
 			break;
 		}
 	}
@@ -192,27 +217,14 @@ cldmgr_getcld( void )
 	return ( p < ep ) ? p : 0;
 }
 
-static cld_t *
-cldmgr_findbytid( pthread_t tid )
-{
-	cld_t *p = cld;
-	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
-
-	for ( ; p < ep ; p++ ) {
-		if ( p->c_busy && pthread_equal( p->c_tid, tid )) {
-			break;
-		}
-	}
-
-	return ( p < ep ) ? p : 0;
-}
-
 static void *
 cldmgr_entry( void *arg1 )
 {
 	cld_t *cldp = ( cld_t * )arg1;
 	pthread_t tid = pthread_self( );
 
+	pthread_cleanup_push( cldmgr_cleanup, arg1 );
+
 	if ( ( intgen_t )( cldp->c_streamix ) >= 0 ) {
 		stream_register( tid, ( intgen_t )cldp->c_streamix );
 	}
@@ -220,7 +232,21 @@ cldmgr_entry( void *arg1 )
 	      "thread %lu created for stream %d\n",
 	      tid,
 	      cldp->c_streamix );
+	cldp->c_exit_code = ( * cldp->c_entry )( cldp->c_arg1 );
+
+	pthread_cleanup_pop( 1 );
 
-	( * cldp->c_entry )( cldp->c_arg1 );
 	return NULL;
 }
+
+static void
+cldmgr_cleanup( void *arg1 )
+{
+	cld_t *cldp = ( cld_t * )arg1;
+
+	lock();
+	cldp->c_state = C_EXITED;
+	// signal the main thread to look for exited threads
+	kill( getpid( ), SIGUSR1 );
+	unlock();
+}
diff --git a/common/cldmgr.h b/common/cldmgr.h
index e393b82..1df0c0c 100644
--- a/common/cldmgr.h
+++ b/common/cldmgr.h
@@ -39,9 +39,12 @@ extern bool_t cldmgr_create( int ( * entry )( void *arg1 ),
  */
 extern void cldmgr_stop( void );
 
-/* cldmgr_died - tells the child manager that the child died
+/* cldmgr_join - join child threads that have exited.
+ * returns EXIT_NORMAL if all exited normally (or no threads have exited),
+ * EXIT_FAULT if any threads requested a core dump, or another EXIT_*
+ * value if any threads exited abnormally.
  */
-extern void cldmgr_died( pthread_t tid );
+extern intgen_t cldmgr_join( void );
 
 /* cldmgr_stop_requested - returns TRUE if the child should gracefully
  * terminate.
diff --git a/common/main.c b/common/main.c
index d4dbe28..38b3889 100644
--- a/common/main.c
+++ b/common/main.c
@@ -137,10 +137,6 @@ static bool_t sighup_received;
 static bool_t sigterm_received;
 static bool_t sigquit_received;
 static bool_t sigint_received;
-static size_t prbcld_cnt;
-static pid_t prbcld_pid;
-static intgen_t prbcld_xc;
-static intgen_t prbcld_signo;
 /* REFERENCED */
 static intgen_t sigstray_received;
 static bool_t progrpt_enabledpr;
@@ -168,6 +164,8 @@ main( int argc, char *argv[] )
 	intgen_t exitcode;
 	rlim64_t tmpstacksz;
 	struct sigaction sa;
+	intgen_t prbcld_xc = EXIT_NORMAL;
+	intgen_t xc;
 	bool_t ok;
 	/* REFERENCED */
 	int rval;
@@ -563,7 +561,6 @@ main( int argc, char *argv[] )
 		sigint_received = BOOL_FALSE;
 		sigquit_received = BOOL_FALSE;
 		sigstray_received = BOOL_FALSE;
-		prbcld_cnt = 0;
 
 		alarm( 0 );
 
@@ -573,6 +570,7 @@ main( int argc, char *argv[] )
 		sigaddset( &blocked_set, SIGTERM );
 		sigaddset( &blocked_set, SIGQUIT );
 		sigaddset( &blocked_set, SIGALRM );
+		sigaddset( &blocked_set, SIGUSR1 );
 		pthread_sigmask( SIG_SETMASK, &blocked_set, NULL );
 
 		sa.sa_handler = sighandler;
@@ -581,6 +579,7 @@ main( int argc, char *argv[] )
 		sigaction( SIGTERM, &sa, NULL );
 		sigaction( SIGQUIT, &sa, NULL );
 		sigaction( SIGALRM, &sa, NULL );
+		sigaction( SIGUSR1, &sa, NULL );
 	}
 
 	/* do content initialization.
@@ -710,31 +709,16 @@ main( int argc, char *argv[] )
 		 * stop. furthermore, note that core should be dumped if
 		 * the child explicitly exited with EXIT_FAULT.
 		 */
-		if ( prbcld_cnt ) {
-			if ( prbcld_xc == EXIT_FAULT || prbcld_signo != 0 ) {
+		xc = cldmgr_join( );
+		if ( xc ) {
+			if ( xc == EXIT_FAULT ) {
 				coredump_requested = BOOL_TRUE;
 				stop_timeout = ABORT_TIMEOUT;
 			} else {
 				stop_timeout = STOP_TIMEOUT;
 			}
+			prbcld_xc = xc;
 			stop_requested = BOOL_TRUE;
-			if ( prbcld_xc != EXIT_NORMAL ) {
-				mlog( MLOG_DEBUG | MLOG_PROC,
-				      "child (pid %d) requested stop: "
-				      "exit code %d (%s)\n",
-				      prbcld_pid,
-				      prbcld_xc,
-				      exit_codestring( prbcld_xc ));
-			} else if ( prbcld_signo ) {
-				ASSERT( prbcld_signo );
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_PROC,
-				      _("child (pid %d) faulted: "
-				      "signal number %d (%s)\n"),
-				      prbcld_pid,
-				      prbcld_signo,
-				      sig_numstring( prbcld_signo ));
-			}
-			prbcld_cnt = 0;
 		}
 			
 		/* all children died normally. break out.
@@ -1528,6 +1512,7 @@ sighandler( int signo )
 		sigquit_received = BOOL_TRUE;
 		break;
 	case SIGALRM:
+	case SIGUSR1:
 		break;
 	default:
 		sigstray_received = signo;
diff --git a/common/stream.c b/common/stream.c
index 48e25ee..6704661 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -86,19 +86,18 @@ stream_register( pthread_t tid, intgen_t streamix )
 	p->s_exit_hint = RV_NONE;
 }
 
+/* NOTE: lock() must be held when calling stream_dead() */
 void
 stream_dead( pthread_t tid )
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
 
-	lock();
 	for ( ; p < ep ; p++ )
 		if ( pthread_equal( p->s_tid, tid ) ) {
 			p->s_state = S_ZOMBIE;
 			break;
 		}
-	unlock();
 	ASSERT( p < ep );
 }
 
diff --git a/common/stream.h b/common/stream.h
index 292792e..4b3799f 100644
--- a/common/stream.h
+++ b/common/stream.h
@@ -43,6 +43,7 @@ typedef enum { S_FREE, S_RUNNING, S_ZOMBIE } stream_state_t;
 
 extern void stream_init( void );
 extern void stream_register( pthread_t tid, intgen_t streamix );
+/* NOTE: lock() must be held when calling stream_dead */
 extern void stream_dead( pthread_t tid );
 extern void stream_free( pthread_t tid );
 extern int stream_find_all( stream_state_t states[],
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
