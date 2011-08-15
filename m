Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FDtc3Z085659 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 08:55:38 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v3 4/7] xfsdump: rework dialog timeout and EINTR reliance
Date: Mon, 15 Aug 2011 08:55:03 -0500
Message-Id: <1313416506-3666-5-git-send-email-wkendall@sgi.com>
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

The current dialog code uses alarm(2) to implement the dialog timeout.
This is suboptimal as the main loop already makes use of alarm.

Additionally the existing code relies on its blocking read(2) being
interrupted if a signal is received. This is not guaranteed to work
as a signal may be delivered to a different thread.

Both of these issues can be resolved by using select(2) rather than
a blocking read.

'dlog_allowed_flag' and 'dlog_signo_received' are now marked 'volatile'
to prevent them from being optimized out from being checked during
a loop.

This also changes dlog_desist() to not change 'dlog_ttyfd', as that
could impact a dialog already in progress. Clearing 'dlog_allowed_flag'
is sufficient to disable dialogs.

Finally add an assert to dlog_string_query() to check that dialogs
are allowed to make it consistent with other promptinput() callers.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 common/dlog.c |   65 ++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/common/dlog.c b/common/dlog.c
index c81edc6..79f2818 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -21,6 +21,7 @@
 
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <sys/select.h>
 #include <fcntl.h>
 #include <time.h>
 #include <errno.h>
@@ -35,7 +36,7 @@ extern bool_t miniroot;
 extern pid_t parentpid;
 
 static int dlog_ttyfd = -1;
-static bool_t dlog_allowed_flag = BOOL_FALSE;
+static volatile bool_t dlog_allowed_flag = BOOL_FALSE;
 static bool_t dlog_timeouts_flag = BOOL_FALSE;
 static char *promptstr = " -> ";
 
@@ -132,7 +133,6 @@ void
 dlog_desist( void )
 {
 	dlog_allowed_flag = BOOL_FALSE;
-	dlog_ttyfd = -1;
 }
 
 intgen_t
@@ -293,6 +293,10 @@ dlog_string_query( dlog_ucbp_t ucb, /* user's print func */
 	ix_t exceptionix;
 	bool_t ok;
 
+	/* sanity
+	 */
+	ASSERT( dlog_allowed_flag );
+
 	/* call the caller's callback with his context, print context, and
 	 * print operator
 	 */
@@ -336,7 +340,7 @@ dlog_string_ack( char *ackstr[ ], size_t ackcnt )
 
 /* ok that this is a static, since used under mutual exclusion lock
  */
-static int dlog_signo_received;
+static volatile int dlog_signo_received;
 
 static void
 sighandler( int signo )
@@ -370,13 +374,12 @@ promptinput( char *buf,
 	     ... )
 {
 	va_list args;
-	u_intgen_t alarm_save = 0;
-	void (* sigalrm_save)(int) = NULL;
 	void (* sigint_save)(int) = NULL;
 	void (* sighup_save)(int) = NULL;
 	void (* sigterm_save)(int) = NULL;
 	void (* sigquit_save)(int) = NULL;
-	intgen_t nread;
+	time32_t now = time( NULL );
+	intgen_t nread = -1;
 	pid_t pid = getpid( );
 
 	/* display the pre-prompt
@@ -396,16 +399,17 @@ promptinput( char *buf,
 #endif /* NOTYET */
 	mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, promptstr );
 
-	/* set up signal handling
+	/* set up timeout
 	 */
-	dlog_signo_received = -1;
 	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sigrelse( SIGALRM );
-		}
-		sigalrm_save = sigset( SIGALRM, sighandler );
-		alarm_save = alarm( ( u_intgen_t )timeout );
+		timeout += now;
+	} else {
+		timeout = TIMEMAX;
 	}
+
+	/* set up signal handling
+	 */
+	dlog_signo_received = -1;
 	if ( sigintix != IXMAX ) {
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sigrelse( SIGINT );
@@ -429,10 +433,27 @@ promptinput( char *buf,
 		sigquit_save = sigset( SIGQUIT, sighandler );
 	}
 
-	/* wait for input, timeout, or interrupt
+	/* wait for input, timeout, or interrupt.
+	 * note we come out of the select() frequently in order to
+	 * check for a signal. the signal may have been handled by the
+	 * the main thread, so we can't rely on the signal waking us
+	 * up from the select().
 	 */
-	ASSERT( dlog_ttyfd >= 0 );
-	nread = read( dlog_ttyfd, buf, bufsz - 1 );
+	while ( now < timeout && dlog_signo_received == -1 && dlog_allowed_flag ) {
+		int rc;
+		fd_set rfds;
+		struct timeval tv = { 0, 100000 }; // 100 ms
+
+		FD_ZERO( &rfds );
+		FD_SET( dlog_ttyfd, &rfds );
+
+		rc = select( dlog_ttyfd + 1, &rfds, NULL, NULL, &tv );
+		if ( rc > 0 && FD_ISSET( dlog_ttyfd, &rfds ) ) {
+			nread = read( dlog_ttyfd, buf, bufsz - 1 );
+			break;
+		}
+		now = time( NULL );
+	}
 
 	/* restore signal handling
 	 */
@@ -458,18 +479,11 @@ promptinput( char *buf,
 			( void )sighold( SIGINT );
 		}
 	}
-	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
-		( void )alarm( alarm_save );
-		( void )sigset( SIGALRM, sigalrm_save );
-		if ( pid == parentpid && ! miniroot ) {
-			( void )sighold( SIGALRM );
-		}
-	}
 	
 	/* check for timeout or interrupt
 	 */
 	if ( nread < 0 ) {
-		if ( dlog_signo_received == SIGALRM ) {
+		if ( now >= timeout ) {
 			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 			      _("timeout\n") );
 			*exceptionixp = timeoutix;
@@ -493,8 +507,7 @@ promptinput( char *buf,
 			*exceptionixp = sigquitix;
 		} else {
 			mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
-			      _("unknown signal during dialog: %d\n"),
-			      dlog_signo_received );
+			      _("abnormal dialog termination\n"));
 			*exceptionixp = sigquitix;
 		}
 		return BOOL_FALSE;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
