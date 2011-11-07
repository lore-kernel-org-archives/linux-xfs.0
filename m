Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7Kxfni076029 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:59:41 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 8/8] xfsdump: enable multiple streams
Date: Mon,  7 Nov 2011 14:58:31 -0600
Message-Id: <1320699511-12281-9-git-send-email-wkendall@sgi.com>
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

IRIX contained an environment referred to as "miniroot" where
sproc threads were either not available, or at least not used
in xfsdump. Throughout xfsdump there's a "miniroot" variable
which indicates whether or not thread support is enabled. On
Linux this variable has always been false in order to disable
support for multiple streams.

Now that the threading infracstructure has been converted over
to pthreads, this patch removes the "miniroot" variable and
enables the option of using multiple streams.

Note that another feature in xfsdump, using a ring buffer for
I/O to tapes, also depends on thread support. I'm leaving that
disabled for now until more testing has been done.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/drive.c          |   20 +------
 common/drive.h          |    8 +--
 common/drive_minrmt.c   |   15 +++---
 common/drive_scsitape.c |   15 +++---
 common/drive_simple.c   |    8 ++--
 common/main.c           |  124 +++++-----------------------------------------
 dump/content.c          |   35 ++++++-------
 dump/getopt.h           |    4 +-
 man/man8/xfsdump.8      |    8 +--
 man/man8/xfsrestore.8   |    4 +-
 restore/content.c       |   23 ++++-----
 restore/getopt.h        |    4 +-
 12 files changed, 74 insertions(+), 194 deletions(-)

diff --git a/common/drive.c b/common/drive.c
index 227fecd..32a7191 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -81,7 +81,7 @@ static drive_strategy_t *strategypp[] = {
  * specified on the command line.
  */
 bool_t
-drive_init1( int argc, char *argv[ ], bool_t singlethreaded )
+drive_init1( int argc, char *argv[ ] )
 {
 	intgen_t c;
 	ix_t driveix;
@@ -103,18 +103,6 @@ drive_init1( int argc, char *argv[ ], bool_t singlethreaded )
 		}
 	}
 
-	/* validate drive count
-	 */
-	if ( singlethreaded && drivecnt > 1 ) {
-		mlog( MLOG_NORMAL, _(
-		      "too many -%c arguments: "
-		      "maximum is %d when running in miniroot\n"),
-		      GETOPT_DUMPDEST,
-		      1 );
-		usage( );
-		return BOOL_FALSE;
-	}
-
 	/* allocate an array to hold ptrs to drive descriptors
 	 */
 	if (drivecnt > 0) {
@@ -221,8 +209,7 @@ drive_init1( int argc, char *argv[ ], bool_t singlethreaded )
 			intgen_t score;
 			score = ( * sp->ds_match )( argc,
 						    argv,
-						    drivep,
-						    singlethreaded );
+						    drivep );
 			if ( ! bestsp || score > bestscore ) {
 				bestsp = sp;
 				bestscore = score;
@@ -237,8 +224,7 @@ drive_init1( int argc, char *argv[ ], bool_t singlethreaded )
 		      bestsp->ds_description );
 		ok = ( * bestsp->ds_instantiate )( argc,
 						   argv,
-						   drivep,
-						   singlethreaded );
+						   drivep );
 		if ( ! ok ) {
 			return BOOL_FALSE;
 		}
diff --git a/common/drive.h b/common/drive.h
index 4dc4270..f693976 100644
--- a/common/drive.h
+++ b/common/drive.h
@@ -140,15 +140,13 @@ struct drive_strategy {
 		     */
 	intgen_t ( * ds_match )( intgen_t argc,
 				 char *argv[ ],
-				 struct drive *drivep,
-				 bool_t singlethreaded );
+				 struct drive *drivep );
 		    /* returns degree of match. drivep has been pre-allocated
 		     * and initialized with generic info.
 		     */
 	bool_t ( * ds_instantiate )( intgen_t argc,
 				     char *argv[ ],
-				     struct drive *drivep,
-				     bool_t singlethreaded );
+				     struct drive *drivep );
 		    /* creates a drive manager instance, by filling in the
 		     * blanks of the pre-allocated drive descriptor
 		     * returns FALSE on failure.
@@ -648,7 +646,7 @@ extern size_t partialmax;
  *
  * Returns FALSE if utility should be aborted.
  */
-extern bool_t drive_init1( int argc, char *argv[], bool_t singlethreaded );
+extern bool_t drive_init1( int argc, char *argv[] );
 
 
 /* drive_init2 - allocate and initialize read and write hdr buffers,
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 3ff4d0f..5f5f96c 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -257,8 +257,8 @@ extern int rmtwrite( int, const void *, uint);
 
 /* strategy functions
  */
-static intgen_t ds_match( int, char *[], drive_t *, bool_t );
-static intgen_t ds_instantiate( int, char *[], drive_t *, bool_t );
+static intgen_t ds_match( int, char *[], drive_t * );
+static intgen_t ds_instantiate( int, char *[], drive_t * );
 
 /* manager operations
  */
@@ -404,7 +404,7 @@ static u_int32_t cmdlineblksize = 0;
  */
 /* ARGSUSED */
 static intgen_t
-ds_match( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
+ds_match( int argc, char *argv[], drive_t *drivep )
 {
 	intgen_t fd;
 	intgen_t c;
@@ -464,7 +464,7 @@ ds_match( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
  */
 /*ARGSUSED*/
 static bool_t
-ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
+ds_instantiate( int argc, char *argv[], drive_t *drivep )
 {
 	drive_context_t *contextp;
 	intgen_t c;
@@ -487,9 +487,10 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 	ASSERT( contextp );
 	memset( ( void * )contextp, 0, sizeof( *contextp ));
 
-	/* transfer indication of singlethreadedness to context
+	/* do not enable a separate I/O thread,
+	 * more testing to be done first...
 	 */
-	contextp->dc_singlethreadedpr = singlethreaded;
+	contextp->dc_singlethreadedpr = BOOL_TRUE;
 
 	/* scan the command line for the I/O buffer ring length
 	 * and record checksum request
@@ -580,7 +581,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 	/* if threads not allowed, allocate a record buffer. otherwise
 	 * create a ring, from which buffers will be taken.
 	 */
-	if ( singlethreaded ) {
+	if ( contextp->dc_singlethreadedpr ) {
 		contextp->dc_bufp = ( char * )memalign( PGSZ, STAPE_MAX_RECSZ );
 		ASSERT( contextp->dc_bufp );
 	} else {
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index f24d604..71b809f 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -299,8 +299,8 @@ extern int rmtwrite( int, const void *, uint);
 
 /* strategy functions
  */
-static intgen_t ds_match( int, char *[], drive_t *, bool_t );
-static intgen_t ds_instantiate( int, char *[], drive_t *, bool_t );
+static intgen_t ds_match( int, char *[], drive_t * );
+static intgen_t ds_instantiate( int, char *[], drive_t * );
 
 /* manager operations
  */
@@ -506,7 +506,7 @@ is_scsi_driver(char *pathname)
  */
 /* ARGSUSED */
 static intgen_t
-ds_match( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
+ds_match( int argc, char *argv[], drive_t *drivep )
 {
 	struct mtget mt_stat;
 	intgen_t fd;
@@ -544,7 +544,7 @@ ds_match( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
  */
 /*ARGSUSED*/
 static bool_t
-ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
+ds_instantiate( int argc, char *argv[], drive_t *drivep )
 {
 	drive_context_t *contextp;
 	intgen_t c;
@@ -567,9 +567,10 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 	ASSERT( contextp );
 	memset( ( void * )contextp, 0, sizeof( *contextp ));
 
-	/* transfer indication of singlethreadedness to context
+	/* do not enable a separate I/O thread,
+	 * more testing to be done first...
 	 */
-	contextp->dc_singlethreadedpr = singlethreaded;
+	contextp->dc_singlethreadedpr = BOOL_TRUE;
 
 	/* scan the command line for the I/O buffer ring length
 	 * and record checksum request
@@ -670,7 +671,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 	/* if threads not allowed, allocate a record buffer. otherwise
 	 * create a ring, from which buffers will be taken.
 	 */
-	if ( singlethreaded ) {
+	if ( contextp->dc_singlethreadedpr ) {
 		contextp->dc_bufp = ( char * )memalign( PGSZ, STAPE_MAX_RECSZ );
 		ASSERT( contextp->dc_bufp );
 	} else {
diff --git a/common/drive_simple.c b/common/drive_simple.c
index cb88aa8..086d162 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -98,8 +98,8 @@ extern size_t pgsz;
 
 /* strategy functions
  */
-static intgen_t ds_match( int, char *[], drive_t *, bool_t );
-static intgen_t ds_instantiate( int, char *[], drive_t *, bool_t );
+static intgen_t ds_match( int, char *[], drive_t * );
+static intgen_t ds_instantiate( int, char *[], drive_t * );
 
 /* declare manager operators
  */
@@ -178,7 +178,7 @@ static drive_ops_t drive_ops = {
  */
 /* ARGSUSED */
 static intgen_t
-ds_match( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
+ds_match( int argc, char *argv[], drive_t *drivep )
 {
 	bool_t isrmtpr;
 	struct stat64 statbuf;
@@ -221,7 +221,7 @@ ds_match( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
  */
 /*ARGSUSED*/
 static bool_t
-ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
+ds_instantiate( int argc, char *argv[], drive_t *drivep )
 {
 	drive_context_t *contextp;
 
diff --git a/common/main.c b/common/main.c
index 38b3889..5880723 100644
--- a/common/main.c
+++ b/common/main.c
@@ -87,10 +87,6 @@ bool_t preemptchk( int );
 static bool_t loadoptfile( int *argcp, char ***argvp );
 static char * stripquotes( char *p );
 static void shiftleftby1( char *p, char *endp );
-static bool_t in_miniroot_heuristic( void );
-#ifdef HIDDEN
-static void mrh_sighandler( int );
-#endif
 static void sighandler( int );
 static int childmain( void * );
 static bool_t sigint_dialog( void );
@@ -111,11 +107,6 @@ intgen_t version = 3;
 intgen_t subversion = 0;
 char *progname = 0;			/* used in all error output */
 char *homedir = 0;			/* directory invoked from */
-#ifdef HIDDEN
-bool_t miniroot = BOOL_FALSE;
-#else
-bool_t miniroot = BOOL_TRUE;
-#endif /* HIDDEN */
 bool_t pipeline = BOOL_FALSE;
 bool_t stdoutpiped = BOOL_FALSE;
 pthread_t parenttid;
@@ -215,16 +206,11 @@ main( int argc, char *argv[] )
 	if ( ! ok ) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
-	/* scan the command line for the miniroot, info, progress
+	/* scan the command line for the info, progress
 	 * report options, and stacksz.
 	 */
 	minstacksz = MINSTACKSZ;
 	maxstacksz = MAXSTACKSZ;
-#ifdef HIDDEN
-	miniroot = BOOL_FALSE;
-#else
-	miniroot = BOOL_TRUE;
-#endif /* HIDDEN */
 	infoonly = BOOL_FALSE;
 	progrpt_enabledpr = BOOL_FALSE;
 	optind = 1;
@@ -275,9 +261,6 @@ main( int argc, char *argv[] )
 			}
 			maxstacksz = tmpstacksz;
 			break;
-                case GETOPT_MINIROOT:
-                        miniroot = BOOL_TRUE;
-                        break;
 		case GETOPT_HELP:
 			infoonly = BOOL_TRUE;
 			mlog_exit_hint(RV_USAGE);
@@ -349,13 +332,6 @@ main( int argc, char *argv[] )
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
-	/* perform an experiment to determine if we are in the miniroot.
-	 * various features will be disallowed if in miniroot.
-	 */
-	if ( ! miniroot && in_miniroot_heuristic( )) {
-		miniroot = BOOL_TRUE;
-	}
-
 	/* initialize message logging (stage 2) - allocate the message lock
 	 */
 	ok = mlog_init2( );
@@ -473,7 +449,7 @@ main( int argc, char *argv[] )
 	 * terribly time-consuming here. A second initialization pass
 	 * will be done shortly.
 	 */
-	ok = drive_init1( argc, argv, miniroot );
+	ok = drive_init1( argc, argv );
 	if ( ! ok ) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
@@ -503,11 +479,7 @@ main( int argc, char *argv[] )
 	      VERSION,
 	      version,
 	      subversion );
-	if ( miniroot ) {
-		mlog( MLOG_VERBOSE | MLOG_BARE, _(
-		      " - "
-		      "Running single-threaded\n") );
-	} else if ( ! pipeline && ! stdoutpiped && sistr && dlog_allowed( )) {
+	if ( ! pipeline && ! stdoutpiped && sistr && dlog_allowed( )) {
 		mlog( MLOG_VERBOSE | MLOG_BARE, _(
 		      " - "
 		      "type %s for status and control\n"),
@@ -531,11 +503,10 @@ main( int argc, char *argv[] )
 	 */
 	mlog_tell_streamcnt( drivecnt );
 
-	/* initialize the state of signal processing. if miniroot or
-	 * pipeline, just want to exit when a signal is received. otherwise,
-	 * hold signals so they don't interfere with sys calls; they will
-	 * be released at pre-emption points and upon pausing in the main
-	 * loop.
+	/* initialize the state of signal processing. if in a pipeline, just
+	 * want to exit when a signal is received. otherwise, hold signals so
+	 * they don't interfere with sys calls; they will be released at
+	 * pre-emption points and upon pausing in the main loop.
 	 */
 
 	sigfillset(&sa.sa_mask);
@@ -551,7 +522,7 @@ main( int argc, char *argv[] )
 	sigaction( SIGPIPE, &sa, NULL );
 	sigaction( SIGCHLD, &sa, NULL );
 
-	if ( ! miniroot && ! pipeline ) {
+	if ( ! pipeline ) {
 		sigset_t blocked_set;
 
 		stop_in_progress = BOOL_FALSE;
@@ -594,10 +565,9 @@ main( int argc, char *argv[] )
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
-	/* if miniroot or a pipeline, go single-threaded
-	 * with just one stream.
+	/* if in a pipeline, go single-threaded with just one stream.
 	 */
-	if ( miniroot || pipeline ) {
+	if ( pipeline ) {
 		intgen_t exitcode;
 
 		sa.sa_handler = sighandler;
@@ -977,9 +947,6 @@ usage( void )
 	ULO(_("(show verbosity in messages)"),		GETOPT_SHOWLOGLEVEL );
 #endif /* REVEAL */
 	ULO(_("<I/O buffer ring length>"),		GETOPT_RINGLEN );
-#ifdef REVEAL
-	ULO(_("(miniroot restrictions)"),		GETOPT_MINIROOT );
-#endif /* REVEAL */
 	ULN(_("- (stdout)") );
 	ULN(_("<source (mntpnt|device)>") );
 #endif /* DUMP */
@@ -1030,9 +997,6 @@ usage( void )
 #endif /* REVEAL */
 	ULO(_("<excluded subtree> ..."),		GETOPT_NOSUBTREE );
 	ULO(_("<I/O buffer ring length>"),		GETOPT_RINGLEN );
-#ifdef REVEAL
-	ULO(_("(miniroot restrictions)"),		GETOPT_MINIROOT );
-#endif /* REVEAL */
 	ULN(_("- (stdin)") );
 	ULN(_("<destination>") );
 #endif /* RESTORE */
@@ -1081,9 +1045,9 @@ preemptchk( int flg )
 		return BOOL_FALSE;
 	}
 
-	/* signals not caught in these cases
+	/* signals not caught if in a pipeline
 	 */
-	if ( miniroot || pipeline ) {
+	if ( pipeline ) {
 		return BOOL_FALSE;
 	}
 
@@ -1400,66 +1364,6 @@ loadoptfile( intgen_t *argcp, char ***argvp )
 	return BOOL_TRUE;
 }
 
-#ifdef HIDDEN
-static pid_t mrh_cid;
-#endif
-
-static bool_t
-in_miniroot_heuristic( void )
-{
-	return BOOL_TRUE;
-
-#ifdef HIDDEN
-	SIG_PF prev_handler_hup;
-	SIG_PF prev_handler_term;
-	SIG_PF prev_handler_int;
-	SIG_PF prev_handler_quit;
-	SIG_PF prev_handler_cld;
-	bool_t in_miniroot;
-
-	/* attempt to call sproc.
-	 */
-	prev_handler_hup = sigset( SIGHUP, SIG_IGN );
-	prev_handler_term = sigset( SIGTERM, SIG_IGN );
-	prev_handler_int = sigset( SIGINT, SIG_IGN );
-	prev_handler_quit = sigset( SIGQUIT, SIG_IGN );
-	prev_handler_cld = sigset( SIGCLD, mrh_sighandler );
-	( void )sighold( SIGCLD );
-	mrh_cid = ( pid_t )sproc( ( void ( * )( void * ))exit, PR_SALL, 0 );
-	if ( mrh_cid < 0 ) {
-		in_miniroot = BOOL_TRUE;
-	} else {
-		while ( mrh_cid >= 0 ) {
-			( void )sigpause( SIGCLD );
-		}
-		in_miniroot = BOOL_FALSE;
-	}
-	( void )sigset( SIGHUP, prev_handler_hup );
-	( void )sigset( SIGTERM, prev_handler_term );
-	( void )sigset( SIGINT, prev_handler_int );
-	( void )sigset( SIGQUIT, prev_handler_quit );
-	( void )sigset( SIGCLD, prev_handler_cld );
-
-	return in_miniroot;
-#endif /* HIDDEN */
-}
-
-#ifdef HIDDEN
-static void
-mrh_sighandler( int signo )
-{
-	if ( signo == SIGCLD ) {
-		pid_t cid;
-		intgen_t stat;
-
-		cid = wait( &stat );
-		if ( cid == mrh_cid ) {
-			mrh_cid = -1;
-		}
-	}
-}
-#endif
-
 /* parent and children share this handler. 
  */
 static void
@@ -1470,9 +1374,9 @@ sighandler( int signo )
 	if ( dlog_sighandler( signo ) )
 		return;
 
-	/* if in miniroot, don't do anything risky. just quit.
+	/* if in pipeline, don't do anything risky. just quit.
 	 */
-	if ( miniroot || pipeline ) {
+	if ( pipeline ) {
 		intgen_t rval;
 
 		mlog( MLOG_TRACE | MLOG_NOTE | MLOG_NOLOCK | MLOG_PROC,
diff --git a/dump/content.c b/dump/content.c
index 33f1166..3a7f508 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -244,7 +244,6 @@ typedef struct pds pds_t;
 extern void usage( void );
 extern bool_t preemptchk( int );
 extern char *homedir;
-extern bool_t miniroot;
 extern bool_t pipeline;
 extern bool_t stdoutpiped;
 extern char *sistr;
@@ -2352,7 +2351,7 @@ content_stream_dump( ix_t strmix )
 					     inomap_next_nondir,
 					     inomap_contextp,
 					     ( intgen_t * )&rv,
-					     ( miniroot || pipeline ) ?
+					     pipeline ?
 					       (bool_t (*)(int))preemptchk : 0,
 					     bstatbufp,
 					     bstatbuflen );
@@ -2586,24 +2585,22 @@ decision_more:
 	 * from all streams have been registered.
 	 */
 	if ( drivep->d_capabilities & DRIVE_CAP_FILES ) {
-		if ( ! miniroot ) {
-			if ( stream_cnt( ) > 1 ) {
-				mlog( MLOG_VERBOSE, _(
-				      "waiting for synchronized "
-				      "session inventory dump\n") );
-				sc_stat_pds[ strmix ].pds_phase = PDS_INVSYNC;
-			}
+		if ( stream_cnt( ) > 1 ) {
+			mlog( MLOG_VERBOSE, _(
+			      "waiting for synchronized "
+			      "session inventory dump\n") );
+			sc_stat_pds[ strmix ].pds_phase = PDS_INVSYNC;
+		}
 
-			/* first be sure all threads have begun
-			 */
-			while ( sc_thrdsarrivedcnt < drivecnt ) {
-				sleep( 1 );
-			}
-			/* now wait for survivors to checkin
-			 */
-			while ( sc_thrdsdonecnt < stream_cnt( )) {
-				sleep( 1 );
-			}
+		/* first be sure all threads have begun
+		*/
+		while ( sc_thrdsarrivedcnt < drivecnt ) {
+			sleep( 1 );
+		}
+		/* now wait for survivors to checkin
+		*/
+		while ( sc_thrdsdonecnt < stream_cnt( )) {
+			sleep( 1 );
 		}
 		/* proceeed
 		 */
diff --git a/dump/getopt.h b/dump/getopt.h
index 8a55631..ba26c93 100644
--- a/dump/getopt.h
+++ b/dump/getopt.h
@@ -27,7 +27,7 @@
  * facilitating easy changes.
  */
 
-#define GETOPT_CMDSTRING	"ab:c:d:ef:hl:mop:qs:t:v:z:AB:CDEFG:H:I:JL:M:NO:PRSTUVWY:Z"
+#define GETOPT_CMDSTRING	"ab:c:d:ef:hl:mop:qs:t:v:z:AB:CDEFG:H:I:JL:M:NO:PRSTUVWY:"
 
 #define GETOPT_DUMPASOFFLINE	'a'	/* dump DMF dualstate files as offline */
 #define	GETOPT_BLOCKSIZE	'b'	/* blocksize for rmt */
@@ -80,6 +80,6 @@
 #define	GETOPT_SHOWLOGLEVEL	'W'	/* show level of log messages */
 /*				'X'	*/
 #define	GETOPT_RINGLEN		'Y'	/* specify I/O buffer ring length */
-#define	GETOPT_MINIROOT		'Z'	/* apply miniroot restrictions */
+/*				'Z'	   used on irix for miniroot */
 
 #endif /* GETOPT_H */
diff --git a/man/man8/xfsdump.8 b/man/man8/xfsdump.8
index 46e6bd5..5360378 100644
--- a/man/man8/xfsdump.8
+++ b/man/man8/xfsdump.8
@@ -66,10 +66,6 @@ option. Other techniques, such as making a second copy of the dump
 image, provide more protection against media failures than multiple
 media files will.
 .P
-However, the current implementation in Linux only supports one destination
-and running single threaded. Therefore, the above comments
-regarding multiple streams describe the possible future capabilities.
-.P
 .I xfsdump
 maintains an online dump inventory in \f2/var/lib/xfsdump/inventory\f1.
 The
@@ -391,8 +387,8 @@ Specify I/O buffer ring length.
 uses a ring of output buffers to achieve maximum throughput
 when dumping to tape drives.
 The default ring length is 3.
-However, this is only supported when running multi-threaded
-which has not been done for Linux yet - making this option benign.
+However, this is not currently enabled on
+Linux yet, making this option benign.
 .TP 5
 .B \-
 A lone
diff --git a/man/man8/xfsrestore.8 b/man/man8/xfsrestore.8
index 8e33ee9..aad97fa 100644
--- a/man/man8/xfsrestore.8
+++ b/man/man8/xfsrestore.8
@@ -426,8 +426,8 @@ Specify I/O buffer ring length.
 uses a ring of input buffers to achieve maximum throughput
 when restoring from tape drives.
 The default ring length is 3.
-However, this is only supported when running multi-threaded
-which has not been done for Linux yet - making this option benign.
+However, this is not currently enabled on
+Linux yet, making this option benign.
 .TP 5
 .B \-
 A lone
diff --git a/restore/content.c b/restore/content.c
index 0108a40..a9e0b20 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -660,7 +660,6 @@ typedef struct tran tran_t;
 extern void usage( void );
 extern bool_t preemptchk( void );
 extern char *homedir;
-extern bool_t miniroot;
 extern bool_t pipeline;
 extern bool_t stdoutpiped;
 extern char *sistr;
@@ -2544,14 +2543,12 @@ content_stream_restore( ix_t thrdix )
 	}
 	tranp->t_sync5 = SYNC_BUSY;
 	unlock( );
-	if ( ! miniroot ) {
-		if ( drivecnt > 1 ) {
-			mlog( MLOG_TRACE,
-			      "waiting for other streams to exit\n" );
-		}
-		while ( cldmgr_otherstreamsremain( thrdix )) {
-			sleep( 1 );
-		}
+	if ( drivecnt > 1 ) {
+		mlog( MLOG_TRACE,
+		      "waiting for other streams to exit\n" );
+	}
+	while ( cldmgr_otherstreamsremain( thrdix )) {
+		sleep( 1 );
 	}
 
 	mlog( MLOG_DEBUG,
@@ -3006,10 +3003,10 @@ applydirdump( drive_t *drivep,
 				return RV_INTR;
 			}
 
-			/* if miniroot or pipeline , call preemptchk( ) to
+			/* if in a pipeline , call preemptchk( ) to
 			 * print status reports
 			 */
-			if ( miniroot || pipeline )
+			if ( pipeline )
 			{
 				mlog( MLOG_DEBUG ,
 					"preemptchk( )\n");
@@ -3543,10 +3540,10 @@ applynondirdump( drive_t *drivep,
 				       fhdrp->fh_offset );
 		}
 
-		/* if miniroot or pipeline , call preemptchk( ) to
+		/* if in a pipeline , call preemptchk( ) to
 		 * print status reports
 		 */
-		if ( miniroot || pipeline )
+		if ( pipeline )
 		{
 			mlog( MLOG_DEBUG ,
 				"preemptchk( )\n");
diff --git a/restore/getopt.h b/restore/getopt.h
index 4ee865d..63568de 100644
--- a/restore/getopt.h
+++ b/restore/getopt.h
@@ -26,7 +26,7 @@
  * purpose is to contain that command string.
  */
 
-#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wABCDEFG:H:I:JL:M:NO:PQRS:TUVWX:Y:Z"
+#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wABCDEFG:H:I:JL:M:NO:PQRS:TUVWX:Y:"
 
 #define GETOPT_WORKSPACE	'a'	/* workspace dir (content.c) */
 #define GETOPT_BLOCKSIZE        'b'     /* blocksize for rmt */
@@ -79,6 +79,6 @@
 #define	GETOPT_SHOWLOGLEVEL	'W'	/* show level of log messages */
 #define	GETOPT_NOSUBTREE	'X'	/* subtree to exclude */
 #define	GETOPT_RINGLEN		'Y'	/* specify I/O buffer ring length */
-#define	GETOPT_MINIROOT		'Z'	/* apply miniroot restrictions */
+/*				'Z'	   used on irix for miniroot */
 
 #endif /* GETOPT_H */
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
