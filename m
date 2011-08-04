Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74MVAwQ089323 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 17:31:10 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 5/7] xfsdump: rework dialog to use main signal handler
Date: Thu,  4 Aug 2011 17:30:09 -0500
Message-Id: <1312497011-24840-6-git-send-email-wkendall@sgi.com>
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
---
 common/dlog.c |   32 +++++++++++++++++---------------
 common/dlog.h |    3 +++
 common/main.c |    6 ++++++
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/common/dlog.c b/common/dlog.c
index cbaa5cb..749de1b 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -39,6 +39,8 @@ static bool_t dlog_allowed_flag = BOOL_FALSE;
 static bool_t dlog_timeouts_flag = BOOL_FALSE;
 static char *promptstr = " -> ";
 
+static sigset_t dlog_registered_sigs;
+
 static bool_t promptinput( char *buf,
 			   size_t bufsz,
 			   ix_t *exceptionixp,
@@ -49,7 +51,6 @@ static bool_t promptinput( char *buf,
 			   ix_t sigquitix,
 			   char *fmt, ... );
 static void dlog_string_query_print( void *ctxp, char *fmt, ... );
-static void sighandler( int );
 
 bool_t
 dlog_init( int argc, char *argv[ ] )
@@ -66,6 +67,8 @@ dlog_init( int argc, char *argv[ ] )
 	dlog_allowed_flag = BOOL_TRUE;
 	dlog_timeouts_flag = BOOL_TRUE;
 
+	sigemptyset( &dlog_registered_sigs );
+
 	/* look for command line option claiming the operator knows
 	 * what's up.
 	 */
@@ -341,10 +344,15 @@ dlog_string_ack( char *ackstr[ ], size_t ackcnt )
  */
 static int dlog_signo_received;
 
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
@@ -373,10 +381,6 @@ promptinput( char *buf,
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
@@ -409,27 +413,28 @@ promptinput( char *buf,
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
@@ -456,24 +461,21 @@ promptinput( char *buf,
 
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
index b6674f9..825c894 100644
--- a/common/main.c
+++ b/common/main.c
@@ -594,6 +594,7 @@ main( int argc, char *argv[] )
 		sigset( SIGINT, sighandler );
 		sigset( SIGHUP, sighandler );
 		sigset( SIGTERM, sighandler );
+		sigset( SIGQUIT, sighandler );
 
 		ok = drive_init2( argc,
 				  argv,
@@ -1482,6 +1483,11 @@ mrh_sighandler( int signo )
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
