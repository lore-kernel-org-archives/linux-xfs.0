Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FDtdqa085672 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 08:55:40 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v3 5/7] xfsdump: rework dialog to use main signal handler
Date: Mon, 15 Aug 2011 08:55:04 -0500
Message-Id: <1313416506-3666-6-git-send-email-wkendall@sgi.com>
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

xfsdump currently swaps in a different signal handler for the duration
of a dialog. This patch changes the code to have a global signal
handler which will first give the dialog a chance to process the
signal. If a dialog is not active or if it is not interested in the
signal, the signal will be processed as usual.

There is one side effect to this change. SIGQUIT is now caught in the
miniroot/pipeline case as the handler needs to be setup in case a
dialog needs it. The signal handler will exit in this case just as
if SIGQUIT was not caught, the only real difference being that a
core file will not be generated.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 common/dlog.c |   32 +++++++++++++++++---------------
 common/dlog.h |    3 +++
 common/main.c |    6 ++++++
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/common/dlog.c b/common/dlog.c
index 79f2818..a49aab5 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -40,6 +40,8 @@ static volatile bool_t dlog_allowed_flag = BOOL_FALSE;
 static bool_t dlog_timeouts_flag = BOOL_FALSE;
 static char *promptstr = " -> ";
 
+static sigset_t dlog_registered_sigs;
+
 static bool_t promptinput( char *buf,
 			   size_t bufsz,
 			   ix_t *exceptionixp,
@@ -50,7 +52,6 @@ static bool_t promptinput( char *buf,
 			   ix_t sigquitix,
 			   char *fmt, ... );
 static void dlog_string_query_print( void *ctxp, char *fmt, ... );
-static void sighandler( int );
 
 bool_t
 dlog_init( int argc, char *argv[ ] )
@@ -67,6 +68,8 @@ dlog_init( int argc, char *argv[ ] )
 	dlog_allowed_flag = BOOL_TRUE;
 	dlog_timeouts_flag = BOOL_TRUE;
 
+	sigemptyset( &dlog_registered_sigs );
+
 	/* look for command line option claiming the operator knows
 	 * what's up.
 	 */
@@ -342,10 +345,15 @@ dlog_string_ack( char *ackstr[ ], size_t ackcnt )
  */
 static volatile int dlog_signo_received;
 
-static void
-sighandler( int signo )
+bool_t
+dlog_sighandler( int signo )
 {
+	if ( sigismember( &dlog_registered_sigs, signo ) < 1 )
+		return BOOL_FALSE;
+	// only process the first signal
+	sigemptyset( &dlog_registered_sigs );
 	dlog_signo_received = signo;
+	return BOOL_TRUE;
 }
 
 /* ARGSUSED */
@@ -374,10 +382,6 @@ promptinput( char *buf,
 	     ... )
 {
 	va_list args;
-	void (* sigint_save)(int) = NULL;
-	void (* sighup_save)(int) = NULL;
-	void (* sigterm_save)(int) = NULL;
-	void (* sigquit_save)(int) = NULL;
 	time32_t now = time( NULL );
 	intgen_t nread = -1;
 	pid_t pid = getpid( );
@@ -410,27 +414,28 @@ promptinput( char *buf,
 	/* set up signal handling
 	 */
 	dlog_signo_received = -1;
+	sigemptyset( &dlog_registered_sigs );
 	if ( sigintix != IXMAX ) {
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sigrelse( SIGINT );
 		}
-		sigint_save = sigset( SIGINT, sighandler );
+		sigaddset( &dlog_registered_sigs, SIGINT );
 	}
 	if ( sighupix != IXMAX ) {
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sigrelse( SIGHUP );
 		}
-		sighup_save = sigset( SIGHUP, sighandler );
+		sigaddset( &dlog_registered_sigs, SIGHUP );
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sigrelse( SIGTERM );
 		}
-		sigterm_save = sigset( SIGTERM, sighandler );
+		sigaddset( &dlog_registered_sigs, SIGTERM );
 	}
 	if ( sigquitix != IXMAX ) {
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sigrelse( SIGQUIT );
 		}
-		sigquit_save = sigset( SIGQUIT, sighandler );
+		sigaddset( &dlog_registered_sigs, SIGQUIT );
 	}
 
 	/* wait for input, timeout, or interrupt.
@@ -457,24 +462,21 @@ promptinput( char *buf,
 
 	/* restore signal handling
 	 */
+	sigemptyset( &dlog_registered_sigs );
 	if ( sigquitix != IXMAX ) {
-		( void )sigset( SIGQUIT, sigquit_save );
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sighold( SIGQUIT );
 		}
 	}
 	if ( sighupix != IXMAX ) {
-		( void )sigset( SIGHUP, sighup_save );
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sighold( SIGHUP );
 		}
-		( void )sigset( SIGTERM, sigterm_save );
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sighold( SIGTERM );
 		}
 	}
 	if ( sigintix != IXMAX ) {
-		( void )sigset( SIGINT, sigint_save );
 		if ( pid == parentpid && ! miniroot ) {
 			( void )sighold( SIGINT );
 		}
diff --git a/common/dlog.h b/common/dlog.h
index 0ee6331..bc17c41 100644
--- a/common/dlog.h
+++ b/common/dlog.h
@@ -41,6 +41,9 @@ extern void dlog_desist( void );
  */
 extern intgen_t dlog_fd( void );
 
+/* returns BOOL_TRUE if a dialog consumed the given signal
+ */
+extern bool_t dlog_sighandler( int signo );
 
 /* bracket a dialog session
  */
diff --git a/common/main.c b/common/main.c
index 6db8e9d..41df975 100644
--- a/common/main.c
+++ b/common/main.c
@@ -599,6 +599,7 @@ main( int argc, char *argv[] )
 		sigset( SIGINT, sighandler );
 		sigset( SIGHUP, sighandler );
 		sigset( SIGTERM, sighandler );
+		sigset( SIGQUIT, sighandler );
 
 		ok = drive_init2( argc,
 				  argv,
@@ -1487,6 +1488,11 @@ mrh_sighandler( int signo )
 static void
 sighandler( int signo )
 {
+	/* dialog gets first crack at the signal
+	 */
+	if ( dlog_sighandler( signo ) )
+		return;
+
 	/* if in miniroot, don't do anything risky. just quit.
 	 */
 	if ( miniroot || pipeline ) {
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
