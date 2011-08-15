Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FDtdHR085670 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 08:55:39 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v3 2/7] xfsdump: process EPIPE instead of catching SIGPIPE
Date: Mon, 15 Aug 2011 08:55:01 -0500
Message-Id: <1313416506-3666-3-git-send-email-wkendall@sgi.com>
In-Reply-To: <1313416506-3666-1-git-send-email-wkendall@sgi.com>
References: <1313416506-3666-1-git-send-email-wkendall@sgi.com>
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

Looking forward towards a multi-threaded xfsdump, it's simpler to
handle pipe failures as a system call failure (EPIPE) rather than
through a signal handler which may run in a separate thread. The
existing error handling code handles EPIPE just fine, so the only
required change is to ignore SIGPIPE. Some sections of code already
temporarily ignore SIGPIPE -- they no longer need to do so since it
will already be ignored.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 common/main.c       |   49 ++++++-------------------------------------------
 common/ring.c       |    1 -
 librmt/rmtcommand.c |    7 +------
 librmt/rmtwrite.c   |    5 -----
 4 files changed, 7 insertions(+), 55 deletions(-)

diff --git a/common/main.c b/common/main.c
index c4d6878..d21b559 100644
--- a/common/main.c
+++ b/common/main.c
@@ -135,7 +135,6 @@ static time32_t stop_deadline;
 static bool_t stop_in_progress;
 static bool_t sighup_received;
 static bool_t sigterm_received;
-static bool_t sigpipe_received;
 static bool_t sigquit_received;
 static bool_t sigint_received;
 static size_t prbcld_cnt;
@@ -547,13 +546,18 @@ main( int argc, char *argv[] )
 	 * be released at pre-emption points and upon pausing in the main
 	 * loop.
 	 */
+
+	/* always ignore SIGPIPE, instead handle EPIPE as part
+	 * of normal sys call error handling
+	 */
+	sigset( SIGPIPE, SIG_IGN );
+
 	if ( ! miniroot && ! pipeline ) {
 		stop_in_progress = BOOL_FALSE;
 		coredump_requested = BOOL_FALSE;
 		sighup_received = BOOL_FALSE;
 		sigterm_received = BOOL_FALSE;
 		sigint_received = BOOL_FALSE;
-		sigpipe_received = BOOL_FALSE;
 		sigquit_received = BOOL_FALSE;
 		sigstray_received = BOOL_FALSE;
 		prbcld_cnt = 0;
@@ -563,8 +567,6 @@ main( int argc, char *argv[] )
 		sighold( SIGHUP );
 		sigset( SIGTERM, sighandler );
 		sighold( SIGTERM );
-		sigset( SIGPIPE, sighandler );
-		sighold( SIGPIPE );
 		sigset( SIGQUIT, sighandler );
 		sighold( SIGQUIT );
 		alarm( 0 );
@@ -596,7 +598,6 @@ main( int argc, char *argv[] )
 		sigset( SIGINT, sighandler );
 		sigset( SIGHUP, sighandler );
 		sigset( SIGTERM, sighandler );
-		sigset( SIGPIPE, sighandler );
 
 		ok = drive_init2( argc,
 				  argv,
@@ -804,16 +805,6 @@ main( int argc, char *argv[] )
 			sigterm_received = BOOL_FALSE;
 		}
 
-		/* request a stop on loss of write pipe
-		 */
-		if ( sigpipe_received ) {
-			mlog( MLOG_DEBUG | MLOG_PROC,
-			      "SIGPIPE received\n" );
-			stop_requested = BOOL_TRUE;
-			stop_timeout = STOP_TIMEOUT;
-			sigpipe_received = BOOL_FALSE;
-		}
-		
 		/* operator send SIGQUIT. treat like an interrupt,
 		 * but force a core dump
 		 */
@@ -889,14 +880,12 @@ main( int argc, char *argv[] )
 		sigrelse( SIGINT );
 		sigrelse( SIGHUP );
 		sigrelse( SIGTERM );
-		sigrelse( SIGPIPE );
 		sigrelse( SIGQUIT );
 		sigrelse( SIGALRM );
 		( void )sigpause( SIGCLD );
 		sighold( SIGCLD );
 		sighold( SIGALRM );
 		sighold( SIGQUIT );
-		sighold( SIGPIPE );
 		sighold( SIGTERM );
 		sighold( SIGHUP );
 		sighold( SIGINT );
@@ -1130,11 +1119,9 @@ preemptchk( int flg )
 	sigrelse( SIGINT );
 	sigrelse( SIGHUP );
 	sigrelse( SIGTERM );
-	sigrelse( SIGPIPE );
 	sigrelse( SIGQUIT );
 
 	sighold( SIGQUIT );
-	sighold( SIGPIPE );
 	sighold( SIGTERM );
 	sighold( SIGHUP );
 	sighold( SIGINT );
@@ -1170,13 +1157,6 @@ preemptchk( int flg )
 		sigterm_received = BOOL_FALSE;
 	}
 
-	if ( sigpipe_received ) {
-		mlog( MLOG_DEBUG | MLOG_PROC,
-		      "SIGPIPE received\n" );
-		preempt_requested = BOOL_TRUE;
-		sigpipe_received = BOOL_FALSE;
-	}
-	
 	if ( sigquit_received ) {
 		mlog( MLOG_DEBUG | MLOG_PROC,
 		      "SIGQUIT received (preempt)\n" );
@@ -1602,14 +1582,6 @@ sighandler( int signo )
 			dlog_desist( );
 			sigquit_received = BOOL_TRUE;
 			return;
-		case SIGPIPE:
-			/* immediately disable further dialogs,
-			 * and ignore subsequent signals
-			 */
-			dlog_desist( );
-			sigpipe_received = BOOL_TRUE;
-			( void )sigset( signo, SIG_IGN );
-			return;
 		case SIGALRM:
 			return;
 		default:
@@ -1638,14 +1610,6 @@ sighandler( int signo )
 			/* can get SIGQUIT during dialog: just dismiss
 			 */
 			return;
-		case SIGPIPE:
-			/* forward write pipe failures to parent,
-			 * and ignore subsequent failures
-			 */
-			dlog_desist( );
-			kill( parentpid, SIGPIPE );
-			( void )sigset( signo, SIG_IGN );
-			return;
 		case SIGALRM:
 			/* accept and do nothing about alarm signals
 			 */
@@ -1678,7 +1642,6 @@ childmain( void *arg1 )
 	sigset( SIGTERM, SIG_IGN );
 	sigset( SIGINT, SIG_IGN );
 	sigset( SIGQUIT, SIG_IGN );
-	sigset( SIGPIPE, SIG_IGN );
 	sigset( SIGALRM, SIG_IGN );
 	sigset( SIGCLD, SIG_IGN );
 
diff --git a/common/ring.c b/common/ring.c
index f6fc64d..b132ab9 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -412,7 +412,6 @@ ring_slave_entry( void *ringctxp )
 	sigset( SIGHUP, SIG_IGN );
 	sigset( SIGINT, SIG_IGN );
 	sigset( SIGQUIT, SIG_IGN );
-	sigset( SIGPIPE, SIG_IGN );
 	sigset( SIGALRM, SIG_IGN );
 	sigset( SIGCLD, SIG_IGN );
 
diff --git a/librmt/rmtcommand.c b/librmt/rmtcommand.c
index 42587e4..fbd7a6a 100644
--- a/librmt/rmtcommand.c
+++ b/librmt/rmtcommand.c
@@ -21,7 +21,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <signal.h>
 #include <errno.h>
 
 #include "rmtlib.h"
@@ -36,19 +35,16 @@ int fildes;
 char *buf;
 {
 	register int blen;
-	void (*pstat)();
 
 	_rmt_msg(RMTDBG, "rmtcommand: fd = %d, buf = %s\n", fildes, buf);
 
 /*
- *	save current pipe status and try to make the request
+ *	try to make the request
  */
 
 	blen = strlen(buf);
-	pstat = signal(SIGPIPE, SIG_IGN);
 	if (write(WRITE(fildes), buf, blen) == blen)
 	{
-		signal(SIGPIPE, pstat);
 		return(0);
 	}
 
@@ -56,7 +52,6 @@ char *buf;
  *	something went wrong. close down and go home
  */
 
-	signal(SIGPIPE, pstat);
 	_rmt_abort(fildes);
 
 	setoserror( EIO );
diff --git a/librmt/rmtwrite.c b/librmt/rmtwrite.c
index 7f373ee..c42b1ab 100644
--- a/librmt/rmtwrite.c
+++ b/librmt/rmtwrite.c
@@ -21,7 +21,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <signal.h>
 #include <errno.h>
 
 #include "rmtlib.h"
@@ -55,20 +54,16 @@ unsigned int nbyte;
 static int _rmt_write(int fildes, char *buf, unsigned int nbyte)
 {
 	char buffer[BUFMAGIC];
-	void (*pstat)();
 
 	sprintf(buffer, "W%d\n", nbyte);
 	if (_rmt_command(fildes, buffer) == -1)
 		return(-1);
 
-	pstat = signal(SIGPIPE, SIG_IGN);
 	if (write(WRITE(fildes), buf, nbyte) == nbyte)
 	{
-		signal (SIGPIPE, pstat);
 		return(_rmt_status(fildes));
 	}
 
-	signal (SIGPIPE, pstat);
 	_rmt_abort(fildes);
 	setoserror( EIO );
 	return(-1);
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
