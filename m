Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74MV6WS089284 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 17:31:06 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 4/7] xfsdump: rework dialog timeout and EINTR reliance
Date: Thu,  4 Aug 2011 17:30:08 -0500
Message-Id: <1312497011-24840-5-git-send-email-wkendall@sgi.com>
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

The current dialog code uses alarm(2) to implement the dialog timeout.
This is suboptimal as the main loop already makes use of alarm.

Additionally the existing code relies on its blocking read(2) being
interrupted if a signal is received. This is not guaranteed to work
as a signal may be delivered to a different thread.

Both of these issues can be resolved by using select(2) rather than
a blocking read.

This also changes dlog_desist() to not change 'dlog_ttyfd', as that
could impact a dialog already in progress. Clearing 'dlog_allowed_flag'
is sufficient to disable dialogs.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/dlog.c |   57 +++++++++++++++++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/common/dlog.c b/common/dlog.c
index 6a243ef..cbaa5cb 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -20,6 +20,7 @@
 #include <xfs/jdm.h>
 
 #include <sys/stat.h>
+#include <sys/select.h>
 #include <fcntl.h>
 #include <time.h>
 #include <errno.h>
@@ -131,7 +132,6 @@ void
 dlog_desist( void )
 {
 	dlog_allowed_flag = BOOL_FALSE;
-	dlog_ttyfd = -1;
 }
 
 intgen_t
@@ -373,13 +373,12 @@ promptinput( char *buf,
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
@@ -399,16 +398,17 @@ promptinput( char *buf,
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
@@ -432,10 +432,27 @@ promptinput( char *buf,
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
@@ -461,18 +478,11 @@ promptinput( char *buf,
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
@@ -496,8 +506,7 @@ promptinput( char *buf,
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
