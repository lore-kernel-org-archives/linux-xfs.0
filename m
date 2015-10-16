Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D0DA7F51
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 20:45:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74730AC002
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:45:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lhTZAehNnEIdzRsC for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 18:45:25 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zmu4u-00019s-T3
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zmu4u-000060-S5
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] cleanup: kill intgen_t
Date: Fri, 16 Oct 2015 12:44:56 +1100
Message-Id: <1444959901-31319-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1444959901-31319-1-git-send-email-david@fromorbit.com>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

intgen_t is for jdm (libhandle) interfaces, not as a random
substitute for "int". Do a global s/intgen_t/int across the codebase
with sed to remove this stupidity so that we don't have to include
xfs/jdm.h across almost the entire code base.

After a manual pass back over the callers of the jdm API, there are
no places where the return value needs to be an intgen_t. Indeed,
jdm_open passes back a file descriptor, so intgen_t by definition
cannot be anything other than an int.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/cldmgr.c         |  14 +--
 common/cldmgr.h         |   2 +-
 common/content.h        |   8 +-
 common/dlog.c           |   6 +-
 common/dlog.h           |   2 +-
 common/drive.c          |   6 +-
 common/drive.h          |  44 +++++-----
 common/drive_minrmt.c   | 222 +++++++++++++++++++++++------------------------
 common/drive_scsitape.c | 226 ++++++++++++++++++++++++------------------------
 common/drive_simple.c   |  84 +++++++++---------
 common/exit.h           |   2 +-
 common/fs.c             |  12 +--
 common/fs.h             |   8 +-
 common/global.c         |   4 +-
 common/global.h         |   2 +-
 common/inventory.c      |   4 +-
 common/inventory.h      |   2 +-
 common/main.c           |  76 ++++++++--------
 common/media.c          |   2 +-
 common/mlog.c           |  38 ++++----
 common/mlog.h           |  16 ++--
 common/openutil.c       |  28 +++---
 common/openutil.h       |  14 +--
 common/qlock.c          |  16 ++--
 common/ring.c           |   4 +-
 common/ring.h           |   4 +-
 common/stream.c         |  10 +--
 common/stream.h         |   6 +-
 common/types.h          |   6 +-
 common/util.c           |  66 +++++++-------
 common/util.h           |  42 ++++-----
 dump/content.c          | 106 +++++++++++------------
 dump/inomap.c           | 156 ++++++++++++++++-----------------
 dump/inomap.h           |   6 +-
 dump/var.c              |   4 +-
 inventory/inv_api.c     |   6 +-
 inventory/inv_core.c    |  14 +--
 inventory/inv_fstab.c   |   6 +-
 inventory/inv_idx.c     |  14 +--
 inventory/inv_mgr.c     |   8 +-
 inventory/inv_oref.c    |  30 +++----
 inventory/inv_oref.h    |  10 +--
 inventory/inv_priv.h    |  70 +++++++--------
 inventory/inv_stobj.c   |  20 ++---
 inventory/inventory.h   |   2 +-
 inventory/testmain.c    |   8 +-
 invutil/invidx.c        |   2 +-
 restore/content.c       | 132 ++++++++++++++--------------
 restore/dirattr.c       |  30 +++----
 restore/inomap.c        |  48 +++++-----
 restore/inomap.h        |   2 +-
 restore/namreg.c        |  10 +--
 restore/namreg.h        |   2 +-
 restore/node.c          |  14 +--
 restore/node.h          |   4 +-
 restore/tree.c          |  54 ++++++------
 restore/win.c           |   6 +-
 restore/win.h           |   4 +-
 58 files changed, 872 insertions(+), 872 deletions(-)

diff --git a/common/cldmgr.c b/common/cldmgr.c
index 88fd7fd..624da62 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -47,7 +47,7 @@ typedef enum { C_AVAIL, C_ALIVE, C_EXITED } state_t;
 
 struct cld {
 	state_t c_state;
-	intgen_t c_exit_code;
+	int c_exit_code;
 	pthread_t c_tid;
 	ix_t c_streamix;
 	int ( * c_entry )( void *arg1 );
@@ -82,7 +82,7 @@ cldmgr_create( int ( * entry )( void *arg1 ),
 	       void *arg1 )
 {
 	cld_t *cldp;
-	intgen_t rval;
+	int rval;
 
 	assert( pthread_equal( pthread_self( ), cldmgr_parenttid ) );
 
@@ -128,17 +128,17 @@ cldmgr_stop( void )
 	cldmgr_stopflag = BOOL_TRUE;
 }
 
-intgen_t
+int
 cldmgr_join( void )
 {
 	cld_t *p = cld;
 	cld_t *ep = cld + sizeof( cld ) / sizeof( cld[ 0 ] );
-	intgen_t xc = EXIT_NORMAL;
+	int xc = EXIT_NORMAL;
 
 	lock();
 	for ( ; p < ep ; p++ ) {
 		if ( p->c_state == C_EXITED ) {
-			if ( ( intgen_t )( p->c_streamix ) >= 0 ) {
+			if ( ( int )( p->c_streamix ) >= 0 ) {
 				stream_dead( p->c_tid );
 			}
 			pthread_join( p->c_tid, NULL );
@@ -230,8 +230,8 @@ cldmgr_entry( void *arg1 )
 
 	pthread_cleanup_push( cldmgr_cleanup, arg1 );
 
-	if ( ( intgen_t )( cldp->c_streamix ) >= 0 ) {
-		stream_register( tid, ( intgen_t )cldp->c_streamix );
+	if ( ( int )( cldp->c_streamix ) >= 0 ) {
+		stream_register( tid, ( int )cldp->c_streamix );
 	}
 	mlog( MLOG_DEBUG | MLOG_PROC,
 	      "thread %lu created for stream %d\n",
diff --git a/common/cldmgr.h b/common/cldmgr.h
index 1df0c0c..c3384fa 100644
--- a/common/cldmgr.h
+++ b/common/cldmgr.h
@@ -44,7 +44,7 @@ extern void cldmgr_stop( void );
  * EXIT_FAULT if any threads requested a core dump, or another EXIT_*
  * value if any threads exited abnormally.
  */
-extern intgen_t cldmgr_join( void );
+extern int cldmgr_join( void );
 
 /* cldmgr_stop_requested - returns TRUE if the child should gracefully
  * terminate.
diff --git a/common/content.h b/common/content.h
index 03b72f0..763c09f 100644
--- a/common/content.h
+++ b/common/content.h
@@ -84,13 +84,13 @@ extern bool_t is_quota_file(ino_t ino);
 #endif /* DUMP */
 
 #ifdef DUMP
-extern bool_t content_init( intgen_t argc,
+extern bool_t content_init( int argc,
 			    char *argv[ ],
 			    global_hdr_t *gwhdrtemplatep );
 	/* prepares for multi-stream dump
 	 */
 
-extern intgen_t content_stream_dump( ix_t strmix );
+extern int content_stream_dump( ix_t strmix );
 	/* does stream dump
 	 */
 
@@ -98,11 +98,11 @@ extern intgen_t content_stream_dump( ix_t strmix );
 #ifdef RESTORE
 extern size_t perssz;
 
-extern bool_t content_init( intgen_t argc, char *argv[ ], size64_t vmsz );
+extern bool_t content_init( int argc, char *argv[ ], size64_t vmsz );
 	/* prepares for multi-thread restore
 	 */
 
-extern intgen_t content_stream_restore( ix_t thrdix );
+extern int content_stream_restore( ix_t thrdix );
 	/* does thread restore
 	 */
 
diff --git a/common/dlog.c b/common/dlog.c
index dac4e64..cb5c11a 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -58,7 +58,7 @@ static void dlog_string_query_print( void *ctxp, char *fmt, ... );
 bool_t
 dlog_init( int argc, char *argv[ ] )
 {
-	intgen_t c;
+	int c;
 
 	/* can only call once
 	 */
@@ -140,7 +140,7 @@ dlog_desist( void )
 	dlog_allowed_flag = BOOL_FALSE;
 }
 
-intgen_t
+int
 dlog_fd( void )
 {
 	return dlog_ttyfd;
@@ -385,7 +385,7 @@ promptinput( char *buf,
 {
 	va_list args;
 	time32_t now = time( NULL );
-	intgen_t nread = -1;
+	int nread = -1;
 	sigset_t orig_set;
 	char *bufp = buf;
 
diff --git a/common/dlog.h b/common/dlog.h
index bc17c41..31ed9c2 100644
--- a/common/dlog.h
+++ b/common/dlog.h
@@ -39,7 +39,7 @@ extern void dlog_desist( void );
 
 /* returns the dialog tty file descriptor. returns -1 if none
  */
-extern intgen_t dlog_fd( void );
+extern int dlog_fd( void );
 
 /* returns BOOL_TRUE if a dialog consumed the given signal
  */
diff --git a/common/drive.c b/common/drive.c
index afef147..9fb0bb7 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -87,7 +87,7 @@ static drive_strategy_t *strategypp[] = {
 bool_t
 drive_init1( int argc, char *argv[ ] )
 {
-	intgen_t c;
+	int c;
 	ix_t driveix;
 
 	/* sanity check asserts
@@ -202,7 +202,7 @@ drive_init1( int argc, char *argv[ ] )
 	 */
 	for ( driveix = 0 ; driveix < drivecnt ; driveix++ ) {
 		drive_t *drivep = drivepp[ driveix ];
-		intgen_t bestscore = 0 - INTGENMAX;
+		int bestscore = 0 - INTGENMAX;
 		ix_t six;
 		ix_t scnt = sizeof( strategypp ) / sizeof( strategypp[ 0 ] );
 		drive_strategy_t *bestsp = 0;
@@ -210,7 +210,7 @@ drive_init1( int argc, char *argv[ ] )
 
 		for ( six = 0 ; six < scnt ; six++ ) {
 			drive_strategy_t *sp = strategypp[ six ];
-			intgen_t score;
+			int score;
 			score = ( * sp->ds_match )( argc,
 						    argv,
 						    drivep );
diff --git a/common/drive.h b/common/drive.h
index f693976..b0efa4c 100644
--- a/common/drive.h
+++ b/common/drive.h
@@ -132,19 +132,19 @@ typedef struct drive_hdr drive_hdr_t;
 struct drive;			/* forward declaration */
 
 struct drive_strategy {
-	intgen_t ds_id;
+	int ds_id;
 		    /* strategy ID
 		     */
 	char *ds_description;
 		    /* a short char string describing strategy
 		     */
-	intgen_t ( * ds_match )( intgen_t argc,
+	int ( * ds_match )( int argc,
 				 char *argv[ ],
 				 struct drive *drivep );
 		    /* returns degree of match. drivep has been pre-allocated
 		     * and initialized with generic info.
 		     */
-	bool_t ( * ds_instantiate )( intgen_t argc,
+	bool_t ( * ds_instantiate )( int argc,
 				     char *argv[ ],
 				     struct drive *drivep );
 		    /* creates a drive manager instance, by filling in the
@@ -245,9 +245,9 @@ struct drive {
 	ix_t d_index;		/* e.g., 0, 1, 2, ... */
 	bool_t d_isnamedpipepr;	/* is a named pipe */
 	bool_t d_isunnamedpipepr;/* is an unnamed pipe */
-	intgen_t d_capabilities;/* see DRIVE_CAP_xxx below */
+	int d_capabilities;/* see DRIVE_CAP_xxx below */
 	off64_t d_cap_est;	/* capacity estimate in bytes; -1 if unknown */
-	intgen_t d_rate_est;	/* bytes per second; -1 if unknown */
+	int d_rate_est;	/* bytes per second; -1 if unknown */
 	drive_markrec_t *d_markrecheadp; /* linked list of mark records */
 	drive_markrec_t *d_markrectailp; /* yet to be committed */
 	off64_t d_recmarksep;	/* transfered from strategy on instantiation */
@@ -267,7 +267,7 @@ struct drive_ops {
 				 * by do_init. returns FALSE if session should
 				 * be aborted.
 				 */
-	intgen_t ( * do_begin_read )( drive_t *drivep );
+	int ( * do_begin_read )( drive_t *drivep );
 				/* prepares the drive manager for reading.
 				 * if the media is positioned at BOM or just
 				 * after a file mark, current media file is
@@ -309,7 +309,7 @@ struct drive_ops {
 	char * ( * do_read )( drive_t *drivep,
 			      size_t wanted_bufsz,
 			      size_t *actual_bufszp,
-			      intgen_t *statp );
+			      int *statp );
 				/* asks the drive manager for a buffered filled
 				 * with the next read stream data.
 				 * the actual buffer size supplied may
@@ -356,7 +356,7 @@ struct drive_ops {
 				 * call to do_read(). will be used in a later
 				 * session to seek to that position.
 				 */
-	intgen_t ( * do_seek_mark )( drive_t *drivep,
+	int ( * do_seek_mark )( drive_t *drivep,
 				     drive_mark_t *drivemarkp );
 				/* searches for the specified mark within the
 				 * current file. returns zero if the mark
@@ -367,7 +367,7 @@ struct drive_ops {
 				 *	CORRUPTION - encountered corrupt data;
 				 *	DEVICE - device error;
 				 */
-	intgen_t ( * do_next_mark )( drive_t *drivep );
+	int ( * do_next_mark )( drive_t *drivep );
 				/* if d_capabilities has DRIVE_CAP_NEXTMARK set,
 				 * drive has the capability to
 				 * seek forward to the next mark. returns
@@ -385,7 +385,7 @@ struct drive_ops {
 				 * will position the media at the next media
 				 * file.
 				 */
-	intgen_t ( * do_begin_write )( drive_t *drivep );
+	int ( * do_begin_write )( drive_t *drivep );
 				/* begins a write media file for writing.
 				 * asserts the media is positioned at BOM or
 				 * just after a file mark. write header will
@@ -443,7 +443,7 @@ struct drive_ops {
 				 * be larger or smaller than the wanted bufsz,
 				 * but will be at least 1 byte in length.
 				 */
-	intgen_t ( * do_write )( drive_t *drivep,
+	int ( * do_write )( drive_t *drivep,
 				 char *bufp,
 				 size_t bufsz );
 				/* asks the drive manager to write bufsz
@@ -481,7 +481,7 @@ struct drive_ops {
 				 * alignment will be maintained after the
 				 * initial alignment done using this info.
 				 */
-	intgen_t ( * do_end_write )( drive_t *drivep, off64_t *ncommittedp );
+	int ( * do_end_write )( drive_t *drivep, off64_t *ncommittedp );
 				/* terminates a media file write sequence.
 				 * flushes any buffered data not yet committed
 				 * to media, and calls callbacks for all marks
@@ -502,9 +502,9 @@ struct drive_ops {
 				 * an error, do_end_write will not do any
 				 * I/O, and will return 0.
 				 */
-	intgen_t ( * do_fsf )( drive_t *drivep,
-			      intgen_t count,
-			      intgen_t *statp );
+	int ( * do_fsf )( drive_t *drivep,
+			      int count,
+			      int *statp );
 				/* if d_capabilities has DRIVE_CAP_FSF set,
 				 * drive has the capability to
 				 * forward space count files. returns the
@@ -528,9 +528,9 @@ struct drive_ops {
 				 * behaves as if position is at most recent
 				 * file mark or BOT.
 				 */
-	intgen_t ( * do_bsf )( drive_t *drivep,
-			       intgen_t count,
-			       intgen_t *statp );
+	int ( * do_bsf )( drive_t *drivep,
+			       int count,
+			       int *statp );
 				/* if d_capabilities has DRIVE_CAP_BSF set,
 				 * drive has the capability to backward space
 				 * count files. returns the number of actual
@@ -554,26 +554,26 @@ struct drive_ops {
 				 *	BOM - hit beginning of recorded data;
 				 *	DEVICE - device error;
 				 */
-	intgen_t ( * do_rewind )( drive_t *drivep );
+	int ( * do_rewind )( drive_t *drivep );
 				/* if d_capabilities has DRIVE_CAP_REWIND set,
 				 * drive has the capability to
 				 * position at beginning of recorded data
 				 *	DEVICE - device error;
 				 */
-	intgen_t ( * do_erase )( drive_t *drivep );
+	int ( * do_erase )( drive_t *drivep );
 				/* if d_capabilities has DRIVE_CAP_ERASE set,
 				 * drive has the capability to
 				 * erase: all content of media object is
 				 * eradicated.
 				 *	DEVICE - device error;
 				 */
-	intgen_t ( * do_eject_media )( drive_t *drivep );
+	int ( * do_eject_media )( drive_t *drivep );
 				/* if d_capabilities has DRIVE_CAP_EJECT set,
 				 * drive has capability
 				 * to eject media, and will do so when called.
 				 *	DEVICE - device error;
 				 */
-	intgen_t ( * do_get_device_class )( drive_t *drivep );
+	int ( * do_get_device_class )( drive_t *drivep );
 				/* returns the media class of the device
 				 * (see below).
 				 */
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 51685dc..21eb09e 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -263,71 +263,71 @@ extern int rmtwrite( int, const void *, uint);
 
 /* strategy functions
  */
-static intgen_t ds_match( int, char *[], drive_t * );
-static intgen_t ds_instantiate( int, char *[], drive_t * );
+static int ds_match( int, char *[], drive_t * );
+static int ds_instantiate( int, char *[], drive_t * );
 
 /* manager operations
  */
 static bool_t do_init( drive_t * );
 static bool_t do_sync( drive_t * );
-static intgen_t do_begin_read( drive_t * );
-static char *do_read( drive_t *, size_t , size_t *, intgen_t * );
+static int do_begin_read( drive_t * );
+static char *do_read( drive_t *, size_t , size_t *, int * );
 static void do_return_read_buf( drive_t *, char *, size_t );
 static void do_get_mark( drive_t *, drive_mark_t * );
-static intgen_t do_seek_mark( drive_t *, drive_mark_t * );
-static intgen_t do_next_mark( drive_t * );
+static int do_seek_mark( drive_t *, drive_mark_t * );
+static int do_next_mark( drive_t * );
 static void do_get_mark( drive_t *, drive_mark_t * );
 static void do_end_read( drive_t * );
-static intgen_t do_begin_write( drive_t * );
+static int do_begin_write( drive_t * );
 static void do_set_mark( drive_t *, drive_mcbfp_t, void *, drive_markrec_t * );
 static char * do_get_write_buf( drive_t *, size_t , size_t * );
-static intgen_t do_write( drive_t *, char *, size_t );
+static int do_write( drive_t *, char *, size_t );
 static size_t do_get_align_cnt( drive_t * );
-static intgen_t do_end_write( drive_t *, off64_t * );
-static intgen_t do_fsf( drive_t *, intgen_t , intgen_t *);
-static intgen_t do_bsf( drive_t *, intgen_t , intgen_t *);
-static intgen_t do_rewind( drive_t * );
-static intgen_t do_erase( drive_t * );
-static intgen_t do_eject_media( drive_t * );
-static intgen_t do_get_device_class( drive_t * );
+static int do_end_write( drive_t *, off64_t * );
+static int do_fsf( drive_t *, int , int *);
+static int do_bsf( drive_t *, int , int *);
+static int do_rewind( drive_t * );
+static int do_erase( drive_t * );
+static int do_eject_media( drive_t * );
+static int do_get_device_class( drive_t * );
 static void do_display_metrics( drive_t *drivep );
 static void do_quit( drive_t * );
 
 /* misc. local utility funcs
  */
-static intgen_t	mt_op(intgen_t , intgen_t , intgen_t );
-static intgen_t determine_write_error( int, int );
-static intgen_t read_label( drive_t *);
+static int	mt_op(int , int , int );
+static int determine_write_error( int, int );
+static int read_label( drive_t *);
 static bool_t tape_rec_checksum_check( drive_context_t *, char * );
 static void set_recommended_sizes( drive_t * );
 static void display_access_failed_message( drive_t *);
 static bool_t get_tpcaps( drive_t * );
-static intgen_t prepare_drive( drive_t *drivep );
+static int prepare_drive( drive_t *drivep );
 static bool_t Open( drive_t *drivep );
 static void Close( drive_t *drivep );
-static intgen_t Read( drive_t *drivep,
+static int Read( drive_t *drivep,
 		      char *bufp,
 		      size_t cnt,
-		      intgen_t *errnop );
-static intgen_t Write( drive_t *drivep,
+		      int *errnop );
+static int Write( drive_t *drivep,
 		       char *bufp,
 		       size_t cnt,
-		       intgen_t *saved_errnop );
-static intgen_t record_hdr_validate( drive_t *drivep,
+		       int *saved_errnop );
+static int record_hdr_validate( drive_t *drivep,
 				     char *bufp,
 				     bool_t chkoffpr );
 static int ring_read( void *clientctxp, char *bufp );
 static int ring_write( void *clientctxp, char *bufp );
 static double percent64( off64_t num, off64_t denom );
-static intgen_t getrec( drive_t *drivep );
-static intgen_t write_record( drive_t *drivep, char *bufp, bool_t chksumpr,
+static int getrec( drive_t *drivep );
+static int write_record( drive_t *drivep, char *bufp, bool_t chksumpr,
                               bool_t xlatepr );
 static ring_msg_t * Ring_get( ring_t *ringp );
 static void Ring_reset(  ring_t *ringp, ring_msg_t *msgp );
 static void Ring_put(  ring_t *ringp, ring_msg_t *msgp );
-static intgen_t validate_media_file_hdr( drive_t *drivep );
+static int validate_media_file_hdr( drive_t *drivep );
 static void calc_max_lost( drive_t *drivep );
-static void display_ring_metrics( drive_t *drivep, intgen_t mlog_flags );
+static void display_ring_metrics( drive_t *drivep, int mlog_flags );
 #ifdef CLRMTAUD
 static u_int32_t rewind_and_verify( drive_t *drivep );
 static u_int32_t erase_and_verify( drive_t *drivep ); 
@@ -409,11 +409,11 @@ static u_int32_t cmdlineblksize = 0;
 /* strategy match - determines if this is the right strategy
  */
 /* ARGSUSED */
-static intgen_t
+static int
 ds_match( int argc, char *argv[], drive_t *drivep )
 {
-	intgen_t fd;
-	intgen_t c;
+	int fd;
+	int c;
 	bool_t minrmt = BOOL_FALSE;
 
 	/* heuristics to determine if this is a drive.
@@ -473,7 +473,7 @@ static bool_t
 ds_instantiate( int argc, char *argv[], drive_t *drivep )
 {
 	drive_context_t *contextp;
-	intgen_t c;
+	int c;
 
 	/* opportunity for sanity checking
 	 */
@@ -591,7 +591,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 		contextp->dc_bufp = ( char * )memalign( PGSZ, STAPE_MAX_RECSZ );
 		assert( contextp->dc_bufp );
 	} else {
-		intgen_t rval;
+		int rval;
 		mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
 		      "ring op: create: ringlen == %u\n",
 		      contextp->dc_ringlen );
@@ -712,11 +712,11 @@ do_sync( drive_t *drivep )
  *	DRIVE_ERROR_* on failure
  *
  */
-static intgen_t
+static int
 do_begin_read( drive_t *drivep )
 {
         drive_context_t *contextp;
-        intgen_t rval;
+        int rval;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "rmt drive op: begin read\n" );
@@ -812,12 +812,12 @@ static char *
 do_read( drive_t *drivep,
 	 size_t wantedcnt,
 	 size_t *actualcntp,
-	 intgen_t *rvalp )
+	 int *rvalp )
 {
 	drive_context_t *contextp;
 	size_t availcnt;
 	size_t actualcnt;
-	intgen_t rval;
+	int rval;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "rmt drive op: read: wanted %u (0x%x)\n",
@@ -970,7 +970,7 @@ typedef enum { SEEKMODE_BUF, SEEKMODE_RAW } seekmode_t;
  *	DRIVE_ERROR_* on failure
  *
  */
-static intgen_t
+static int
 do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 {
 	drive_context_t	*contextp;
@@ -1036,7 +1036,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 			size_t wantedcnt;
 			char *dummybufp;
 			size_t actualcnt;
-			intgen_t rval;
+			int rval;
 
 			/* if this is the last record, the wanted offset
 			 * must be just after it.
@@ -1147,15 +1147,15 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 			recskipcnt64 = wantedreccnt - contextp->dc_reccnt;
 			recskipcnt64remaining = recskipcnt64;
 			while ( recskipcnt64remaining ) {
-				intgen_t recskipcnt;
-				intgen_t saved_errno;
-				intgen_t rval;
+				int recskipcnt;
+				int saved_errno;
+				int rval;
 
 				assert( recskipcnt64remaining > 0 );
 				if ( recskipcnt64remaining > INTGENMAX ) {
 					recskipcnt = INTGENMAX;
 				} else {
-					recskipcnt = ( intgen_t )
+					recskipcnt = ( int )
 						     recskipcnt64remaining;
 				}
 				assert( recskipcnt > 0 );
@@ -1194,7 +1194,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		size_t wantedcnt;
 		char *dummybufp;
 		size_t actualcnt;
-		intgen_t rval;
+		int rval;
 
 		assert( ! contextp->dc_recp );
 
@@ -1253,7 +1253,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		/* eat that much tape
 		 */
 		if ( wantedcnt > 0 ) {
-		    intgen_t rval;
+		    int rval;
 		    rval = 0;
 		    dummybufp = do_read( drivep, wantedcnt, &actualcnt, &rval );
 		    if ( rval ) {
@@ -1300,7 +1300,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
  *	0 on success
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 do_next_mark( drive_t *drivep )
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
@@ -1308,11 +1308,11 @@ do_next_mark( drive_t *drivep )
 	char *p;
 	ix_t trycnt;
 	const ix_t maxtrycnt = 5;
-	intgen_t nread;
+	int nread;
 	off64_t markoff;
-	intgen_t saved_errno;
+	int saved_errno;
 	size_t tailsz;
-	intgen_t rval;
+	int rval;
 
 	/* assert protocol being followed.
 	 */
@@ -1418,7 +1418,7 @@ readrecord:
 	goto validateread;
 
 validateread:
-	if ( nread == ( intgen_t )tape_recsz ) {
+	if ( nread == ( int )tape_recsz ) {
 		goto validatehdr;
 	}
 
@@ -1585,7 +1585,7 @@ do_end_read( drive_t *drivep )
  *	0 on success
  * 	DRIVE_ERROR_... on failure
  */
-static intgen_t
+static int
 do_begin_write( drive_t *drivep )
 {
 	drive_context_t		*contextp;
@@ -1593,7 +1593,7 @@ do_begin_write( drive_t *drivep )
 	global_hdr_t		*gwhdrp;
 	rec_hdr_t		*tpwhdrp;
 	rec_hdr_t		*rechdrp;
-	intgen_t		rval;
+	int		rval;
 	media_hdr_t		*mwhdrp;
 	content_hdr_t		*ch;
 	content_inode_hdr_t	*cih;
@@ -1842,7 +1842,7 @@ do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
  *	non 0 on error
  */
 /* ARGSUSED */
-static intgen_t
+static int
 do_write( drive_t *drivep, char *bufp, size_t retcnt )
 {
 	drive_context_t *contextp;
@@ -1850,7 +1850,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 	global_hdr_t *gwhdrp;
 	size_t heldcnt;
 	off64_t last_rec_wrtn_wo_err; /* zero-based index */
-	intgen_t rval;
+	int rval;
 
 	/* get drive context and pointer to global write hdr
 	 */
@@ -2015,7 +2015,7 @@ do_get_align_cnt( drive_t * drivep )
  *	 0 on success
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 do_end_write( drive_t *drivep, off64_t *ncommittedp )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
@@ -2024,7 +2024,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	off64_t recs_guaranteed;
 	off64_t bytes_committed;
 
-	intgen_t rval;
+	int rval;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "rmt drive op: end write\n" );
@@ -2160,7 +2160,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	 * exposing any write errors.
 	 */
 	if ( ! rval ) {
-		intgen_t weofrval;
+		int weofrval;
 
 		weofrval = mt_op( contextp->dc_fd, MTWEOF, 1 );
 		if ( weofrval ) {
@@ -2211,8 +2211,8 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
  *	number of media files skipped
  *	*statp set to zero or DRIVE_ERROR_...
  */
-static intgen_t
-do_fsf( drive_t *drivep, intgen_t count, intgen_t *statp )
+static int
+do_fsf( drive_t *drivep, int count, int *statp )
 {
 	int 		i, done, op_failed, opcount;
 	drive_context_t *contextp;
@@ -2287,14 +2287,14 @@ do_fsf( drive_t *drivep, intgen_t count, intgen_t *statp )
  *	number of media files skipped
  *	*statp set to zero or DRIVE_ERROR_...
  */
-static intgen_t
-do_bsf( drive_t *drivep, intgen_t count, intgen_t *statp )
+static int
+do_bsf( drive_t *drivep, int count, int *statp )
 {
 #ifdef DEBUG
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 #endif
-	intgen_t skipped;
-	intgen_t rval;
+	int skipped;
+	int rval;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "rmt drive op: bsf: count %d\n",
@@ -2375,7 +2375,7 @@ do_bsf( drive_t *drivep, intgen_t count, intgen_t *statp )
  *	0 on sucess
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 do_rewind( drive_t *drivep )
 {
 #ifdef DEBUG
@@ -2401,7 +2401,7 @@ do_rewind( drive_t *drivep )
  *	0 on sucess
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 do_erase( drive_t *drivep )
 {
 #ifdef DEBUG
@@ -2439,7 +2439,7 @@ do_erase( drive_t *drivep )
  *	0 on sucess
  *	DRIVE_ERROR_DEVICE on failure
  */
-static intgen_t
+static int
 do_eject_media( drive_t *drivep )
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
@@ -2472,7 +2472,7 @@ do_eject_media( drive_t *drivep )
  *	always returns DEVICE_TAPE_REMOVABLE
  */
 /* ARGSUSED */
-static intgen_t
+static int
 do_get_device_class( drive_t *drivep)
 {
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
@@ -2547,13 +2547,13 @@ percent64( off64_t num, off64_t denom )
  *	0 on success
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 read_label( drive_t *drivep )
 {
 	drive_context_t *contextp;
-	intgen_t nread;
-	intgen_t saved_errno;
-	intgen_t rval;
+	int nread;
+	int saved_errno;
+	int rval;
 
 	/* initialize context ptr
 	 */
@@ -2568,8 +2568,8 @@ read_label( drive_t *drivep )
 
 	/* if a read error, get status
 	 */
-	if ( nread != ( intgen_t )tape_recsz ) {
-		assert( nread < ( intgen_t )tape_recsz );
+	if ( nread != ( int )tape_recsz ) {
+		assert( nread < ( int )tape_recsz );
 	} 
 
 	/* check for an unexpected errno
@@ -2613,7 +2613,7 @@ read_label( drive_t *drivep )
 	return rval;
 }
 
-static intgen_t
+static int
 validate_media_file_hdr( drive_t *drivep )
 {
 	global_hdr_t		*grhdrp = drivep->d_greadhdrp;
@@ -2792,12 +2792,12 @@ set_recommended_sizes( drive_t *drivep )
  *	0 on sucess
  *	-1 on failure
  */
-static intgen_t
-mt_op(intgen_t fd, intgen_t sub_op, intgen_t param )
+static int
+mt_op(int fd, int sub_op, int param )
 {
 	struct mtop 	mop;
 	char *printstr;
-	intgen_t rval;
+	int rval;
 
 	mop.mt_op   	= (short )sub_op;
 	mop.mt_count	= param;
@@ -2874,10 +2874,10 @@ mt_op(intgen_t fd, intgen_t sub_op, intgen_t param )
  * RETURNS:
  *      DRIVE_ERROR_*
  */
-static intgen_t
+static int
 determine_write_error( int nwritten, int saved_errno )
 {
-	intgen_t        ret = 0;
+	int        ret = 0;
 
 	if ( saved_errno == EACCES ) {
 		mlog(MLOG_NORMAL,
@@ -3059,7 +3059,7 @@ display_access_failed_message( drive_t *drivep )
  * determines other drive attributes. determines if any previous
  * xfsdumps on media.
  */
-static intgen_t
+static int
 prepare_drive( drive_t *drivep )
 {
 	drive_context_t	*contextp;
@@ -3067,7 +3067,7 @@ prepare_drive( drive_t *drivep )
 	ix_t try;
 	ix_t maxtries;
 	bool_t changedblkszpr;
-	intgen_t rval;
+	int rval;
 
 	/* get pointer to drive context
 	 */
@@ -3159,8 +3159,8 @@ prepare_drive( drive_t *drivep )
 	changedblkszpr = BOOL_FALSE;
 
 	for ( try = 1 ; ; try++ ) {
-		intgen_t nread;
-		intgen_t saved_errno;
+		int nread;
+		int saved_errno;
 
 		if ( cldmgr_stop_requested( )) {
 			return DRIVE_ERROR_STOP;
@@ -3264,7 +3264,7 @@ prepare_drive( drive_t *drivep )
 #endif
 		}
 
-		if ( nread == ( intgen_t )tape_recsz ) {
+		if ( nread == ( int )tape_recsz ) {
 			mlog( MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == selected blocksize "
 			  "indicates correct blocksize found\n" );
@@ -3272,7 +3272,7 @@ prepare_drive( drive_t *drivep )
 		}
 
 		/* short read */
-		if (( saved_errno == 0 ) && ( nread < (intgen_t)tape_recsz)) {
+		if (( saved_errno == 0 ) && ( nread < (int)tape_recsz)) {
 			mlog( MLOG_DEBUG | MLOG_DRIVE,
 			  "nread < selected blocksize "
 			  "indicates incorrect blocksize found "
@@ -3404,7 +3404,7 @@ static bool_t
 Open( drive_t *drivep )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t oflags;
+	int oflags;
 
 #ifdef DUMP
 	oflags = O_RDWR;
@@ -3443,11 +3443,11 @@ Close( drive_t *drivep )
 	contextp->dc_fd = -1;
 }
 
-static intgen_t
-Read( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
+static int
+Read( drive_t *drivep, char *bufp, size_t cnt, int *errnop )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nread;
+	int nread;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "tape op: reading %u bytes\n",
@@ -3465,7 +3465,7 @@ Read( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
 		      cnt,
 		      errno,
 		      strerror( errno ));
-	} else if ( nread != ( intgen_t )cnt ) {
+	} else if ( nread != ( int )cnt ) {
 		mlog( MLOG_NITTY | MLOG_DRIVE,
 		      "tape op read of %u bytes short: nread == %d\n",
 		      cnt,
@@ -3479,11 +3479,11 @@ Read( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
 	return nread;
 }
 
-static intgen_t
-Write( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
+static int
+Write( drive_t *drivep, char *bufp, size_t cnt, int *errnop )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nwritten;
+	int nwritten;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "tape op: writing %u bytes\n",
@@ -3501,7 +3501,7 @@ Write( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
 		      cnt,
 		      errno,
 		      strerror( errno ));
-	} else if ( nwritten != ( intgen_t )cnt ) {
+	} else if ( nwritten != ( int )cnt ) {
 		mlog( MLOG_NITTY | MLOG_DRIVE,
 		      "tape op write of %u bytes short: nwritten == %d\n",
 		      cnt,
@@ -3518,7 +3518,7 @@ Write( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
 /* validate a record header, log any anomolies, and return appropriate
  * indication.
  */
-static intgen_t
+static int
 record_hdr_validate( drive_t *drivep, char *bufp, bool_t chkoffpr )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
@@ -3617,17 +3617,17 @@ record_hdr_validate( drive_t *drivep, char *bufp, bool_t chkoffpr )
 /* do a read, determine DRIVE_ERROR_... if failure, and return failure code.
  * return 0 on success.
  */
-static intgen_t
+static int
 read_record(  drive_t *drivep, char *bufp )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nread;
-	intgen_t saved_errno;
-	intgen_t rval;
+	int nread;
+	int saved_errno;
+	int rval;
 
 	nread = Read( drivep, bufp, tape_recsz, &saved_errno );
 
-	if ( nread == ( intgen_t )tape_recsz ) {
+	if ( nread == ( int )tape_recsz ) {
 		contextp->dc_iocnt++;
 		rval = record_hdr_validate( drivep, bufp, BOOL_TRUE );
 		return rval;
@@ -3670,7 +3670,7 @@ read_record(  drive_t *drivep, char *bufp )
 	/* short read
 	 */
 	if ( nread >= 0 ) {
-		assert( nread <= ( intgen_t )tape_recsz );
+		assert( nread <= ( int )tape_recsz );
 		mlog( MLOG_DEBUG | MLOG_DRIVE,
 		      "short read record %lld (nread == %d)\n",
 		      contextp->dc_iocnt,
@@ -3698,7 +3698,7 @@ ring_read( void *clientctxp, char *bufp )
 
 /* gets another record IF dc_recp is NULL
  */
-static intgen_t
+static int
 getrec( drive_t *drivep )
 {
 	drive_context_t *contextp;
@@ -3707,7 +3707,7 @@ getrec( drive_t *drivep )
 	while ( ! contextp->dc_recp ) {
 		rec_hdr_t *rechdrp;
 		if ( contextp->dc_singlethreadedpr ) {
-			intgen_t rval;
+			int rval;
 			contextp->dc_recp = contextp->dc_bufp;
 			rval = read_record( drivep, contextp->dc_recp );
 			if ( rval ) {
@@ -3755,13 +3755,13 @@ getrec( drive_t *drivep )
  * return 0 on success.
  */
 /*ARGSUSED*/
-static intgen_t
+static int
 write_record(  drive_t *drivep, char *bufp, bool_t chksumpr, bool_t xlatepr )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nwritten;
-	intgen_t saved_errno;
-	intgen_t rval;
+	int nwritten;
+	int saved_errno;
+	int rval;
 
         if ( xlatepr ) {
 		rec_hdr_t rechdr;
@@ -3775,7 +3775,7 @@ write_record(  drive_t *drivep, char *bufp, bool_t chksumpr, bool_t xlatepr )
 
 	nwritten = Write( drivep, bufp, tape_recsz, &saved_errno );
 
-	if ( nwritten == ( intgen_t )tape_recsz ) {
+	if ( nwritten == ( int )tape_recsz ) {
 		contextp->dc_iocnt++;
 		return 0;
 	}
@@ -3843,7 +3843,7 @@ calc_max_lost( drive_t *drivep )
 }
 
 static void
-display_ring_metrics( drive_t *drivep, intgen_t mlog_flags )
+display_ring_metrics( drive_t *drivep, int mlog_flags )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 	ring_t *ringp = contextp->dc_ringp;
@@ -3894,7 +3894,7 @@ rewind_and_verify( drive_t *drivep )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 	ix_t try;
-	intgen_t rval;
+	int rval;
 
 	rval = mt_op( contextp->dc_fd, MTREW, 0 );
 	for ( try = 1 ; ; try++ ) {
@@ -3920,7 +3920,7 @@ static short
 erase_and_verify( drive_t *drivep ) 
 {
 	char *tempbufp;
-	intgen_t saved_errno;
+	int saved_errno;
 
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index eade6ac..605675f 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -305,79 +305,79 @@ extern int rmtwrite( int, const void *, uint);
 
 /* strategy functions
  */
-static intgen_t ds_match( int, char *[], drive_t * );
-static intgen_t ds_instantiate( int, char *[], drive_t * );
+static int ds_match( int, char *[], drive_t * );
+static int ds_instantiate( int, char *[], drive_t * );
 
 /* manager operations
  */
 static bool_t do_init( drive_t * );
 static bool_t do_sync( drive_t * );
-static intgen_t do_begin_read( drive_t * );
-static char *do_read( drive_t *, size_t , size_t *, intgen_t * );
+static int do_begin_read( drive_t * );
+static char *do_read( drive_t *, size_t , size_t *, int * );
 static void do_return_read_buf( drive_t *, char *, size_t );
 static void do_get_mark( drive_t *, drive_mark_t * );
-static intgen_t do_seek_mark( drive_t *, drive_mark_t * );
-static intgen_t do_next_mark( drive_t * );
+static int do_seek_mark( drive_t *, drive_mark_t * );
+static int do_next_mark( drive_t * );
 static void do_get_mark( drive_t *, drive_mark_t * );
 static void do_end_read( drive_t * );
-static intgen_t do_begin_write( drive_t * );
+static int do_begin_write( drive_t * );
 static void do_set_mark( drive_t *, drive_mcbfp_t, void *, drive_markrec_t * );
 static char * do_get_write_buf( drive_t *, size_t , size_t * );
-static intgen_t do_write( drive_t *, char *, size_t );
+static int do_write( drive_t *, char *, size_t );
 static size_t do_get_align_cnt( drive_t * );
-static intgen_t do_end_write( drive_t *, off64_t * );
-static intgen_t do_fsf( drive_t *, intgen_t , intgen_t *);
-static intgen_t do_bsf( drive_t *, intgen_t , intgen_t *);
-static intgen_t do_rewind( drive_t * );
-static intgen_t do_erase( drive_t * );
-static intgen_t do_eject_media( drive_t * );
-static intgen_t do_get_device_class( drive_t * );
+static int do_end_write( drive_t *, off64_t * );
+static int do_fsf( drive_t *, int , int *);
+static int do_bsf( drive_t *, int , int *);
+static int do_rewind( drive_t * );
+static int do_erase( drive_t * );
+static int do_eject_media( drive_t * );
+static int do_get_device_class( drive_t * );
 static void do_display_metrics( drive_t *drivep );
 static void do_quit( drive_t * );
 
 /* misc. local utility funcs
  */
-static intgen_t	mt_op(intgen_t , intgen_t , intgen_t );
-static intgen_t mt_blkinfo(intgen_t , struct mtblkinfo * );
+static int	mt_op(int , int , int );
+static int mt_blkinfo(int , struct mtblkinfo * );
 static bool_t mt_get_fileno( drive_t *, long *);
 static bool_t mt_get_status( drive_t *, mtstat_t *);
-static intgen_t determine_write_error( drive_t *, int, int );
-static intgen_t read_label( drive_t *);
+static int determine_write_error( drive_t *, int, int );
+static int read_label( drive_t *);
 static bool_t tape_rec_checksum_check( drive_context_t *, char * );
 static void set_recommended_sizes( drive_t * );
 static void display_access_failed_message( drive_t *);
 static void status_failed_message( drive_t *);
 static bool_t get_tpcaps( drive_t * );
 static bool_t set_fixed_blksz( drive_t *, size_t );
-static intgen_t prepare_drive( drive_t *drivep );
+static int prepare_drive( drive_t *drivep );
 static bool_t Open( drive_t *drivep );
 static void Close( drive_t *drivep );
-static intgen_t Read( drive_t *drivep,
+static int Read( drive_t *drivep,
 		      char *bufp,
 		      size_t cnt,
-		      intgen_t *errnop );
-static intgen_t Write( drive_t *drivep,
+		      int *errnop );
+static int Write( drive_t *drivep,
 		       char *bufp,
 		       size_t cnt,
-		       intgen_t *saved_errnop );
-static intgen_t quick_backup( drive_t *drivep,
+		       int *saved_errnop );
+static int quick_backup( drive_t *drivep,
 			      drive_context_t *contextp,
 			      ix_t skipcnt );
-static intgen_t record_hdr_validate( drive_t *drivep,
+static int record_hdr_validate( drive_t *drivep,
 				     char *bufp,
 				     bool_t chkoffpr );
 static int ring_read( void *clientctxp, char *bufp );
 static int ring_write( void *clientctxp, char *bufp );
 static double percent64( off64_t num, off64_t denom );
-static intgen_t getrec( drive_t *drivep );
-static intgen_t write_record( drive_t *drivep, char *bufp, bool_t chksumpr,
+static int getrec( drive_t *drivep );
+static int write_record( drive_t *drivep, char *bufp, bool_t chksumpr,
                               bool_t xlatepr );
 static ring_msg_t * Ring_get( ring_t *ringp );
 static void Ring_reset(  ring_t *ringp, ring_msg_t *msgp );
 static void Ring_put(  ring_t *ringp, ring_msg_t *msgp );
-static intgen_t validate_media_file_hdr( drive_t *drivep );
+static int validate_media_file_hdr( drive_t *drivep );
 static void calc_max_lost( drive_t *drivep );
-static void display_ring_metrics( drive_t *drivep, intgen_t mlog_flags );
+static void display_ring_metrics( drive_t *drivep, int mlog_flags );
 static mtstat_t rewind_and_verify( drive_t *drivep );
 static mtstat_t erase_and_verify( drive_t *drivep );
 static mtstat_t bsf_and_verify( drive_t *drivep );
@@ -511,11 +511,11 @@ is_scsi_driver(char *pathname)
 /* strategy match - determines if this is the right strategy
  */
 /* ARGSUSED */
-static intgen_t
+static int
 ds_match( int argc, char *argv[], drive_t *drivep )
 {
 	struct mtget mt_stat;
-	intgen_t fd;
+	int fd;
 
 	/* heuristics to determine if this is a drive.
 	 */
@@ -553,7 +553,7 @@ static bool_t
 ds_instantiate( int argc, char *argv[], drive_t *drivep )
 {
 	drive_context_t *contextp;
-	intgen_t c;
+	int c;
 
 	/* opportunity for sanity checking
 	 */
@@ -681,7 +681,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 		contextp->dc_bufp = ( char * )memalign( PGSZ, STAPE_MAX_RECSZ );
 		assert( contextp->dc_bufp );
 	} else {
-		intgen_t rval;
+		int rval;
 		mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
 		      "ring op: create: ringlen == %u\n",
 		      contextp->dc_ringlen );
@@ -825,11 +825,11 @@ do_sync( drive_t *drivep )
  *	DRIVE_ERROR_* on failure
  *
  */
-static intgen_t
+static int
 do_begin_read( drive_t *drivep )
 {
         drive_context_t *contextp;
-        intgen_t rval;
+        int rval;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: begin read\n" );
@@ -925,12 +925,12 @@ static char *
 do_read( drive_t *drivep,
 	 size_t wantedcnt,
 	 size_t *actualcntp,
-	 intgen_t *rvalp )
+	 int *rvalp )
 {
 	drive_context_t *contextp;
 	size_t availcnt;
 	size_t actualcnt;
-	intgen_t rval;
+	int rval;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: read: wanted %u (0x%x)\n",
@@ -1083,7 +1083,7 @@ typedef enum { SEEKMODE_BUF, SEEKMODE_RAW } seekmode_t;
  *	DRIVE_ERROR_* on failure
  *
  */
-static intgen_t
+static int
 do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 {
 	drive_context_t	*contextp;
@@ -1149,7 +1149,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 			size_t wantedcnt;
 			char *dummybufp;
 			size_t actualcnt;
-			intgen_t rval;
+			int rval;
 
 			/* if this is the last record, the wanted offset
 			 * must be just after it.
@@ -1260,15 +1260,15 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 			recskipcnt64 = wantedreccnt - contextp->dc_reccnt;
 			recskipcnt64remaining = recskipcnt64;
 			while ( recskipcnt64remaining ) {
-				intgen_t recskipcnt;
-				intgen_t saved_errno;
-				intgen_t rval;
+				int recskipcnt;
+				int saved_errno;
+				int rval;
 
 				assert( recskipcnt64remaining > 0 );
 				if ( recskipcnt64remaining > INTGENMAX ) {
 					recskipcnt = INTGENMAX;
 				} else {
-					recskipcnt = ( intgen_t )
+					recskipcnt = ( int )
 						     recskipcnt64remaining;
 				}
 				assert( recskipcnt > 0 );
@@ -1307,7 +1307,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		size_t wantedcnt;
 		char *dummybufp;
 		size_t actualcnt;
-		intgen_t rval;
+		int rval;
 
 		assert( ! contextp->dc_recp );
 
@@ -1366,7 +1366,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		/* eat that much tape
 		 */
 		if ( wantedcnt > 0 ) {
-		    intgen_t rval;
+		    int rval;
 		    rval = 0;
 		    dummybufp = do_read( drivep, wantedcnt, &actualcnt, &rval );
 		    if ( rval ) {
@@ -1413,7 +1413,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
  *	0 on success
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 do_next_mark( drive_t *drivep )
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
@@ -1421,12 +1421,12 @@ do_next_mark( drive_t *drivep )
 	char *p;
 	ix_t trycnt;
 	const ix_t maxtrycnt = 5;
-	intgen_t nread;
+	int nread;
 	off64_t markoff;
-	intgen_t saved_errno;
+	int saved_errno;
 	mtstat_t mtstat;
 	size_t tailsz;
-	intgen_t rval;
+	int rval;
 	bool_t ok;
 
 	/* assert protocol being followed.
@@ -1533,7 +1533,7 @@ readrecord:
 	goto validateread;
 
 validateread:
-	if ( nread == ( intgen_t )tape_recsz ) {
+	if ( nread == ( int )tape_recsz ) {
 		goto validatehdr;
 	}
 	ok = mt_get_status( drivep, &mtstat );
@@ -1721,7 +1721,7 @@ do_end_read( drive_t *drivep )
  *	0 on success
  * 	DRIVE_ERROR_... on failure
  */
-static intgen_t
+static int
 do_begin_write( drive_t *drivep )
 {
 	drive_context_t		*contextp;
@@ -1730,7 +1730,7 @@ do_begin_write( drive_t *drivep )
 	rec_hdr_t		*tpwhdrp;
 	rec_hdr_t		*rechdrp;
 	mtstat_t		mtstat;
-	intgen_t		rval;
+	int		rval;
 	media_hdr_t		*mwhdrp;
 	content_hdr_t		*ch;
 	content_inode_hdr_t	*cih;
@@ -1992,7 +1992,7 @@ do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
  *	non 0 on error
  */
 /* ARGSUSED */
-static intgen_t
+static int
 do_write( drive_t *drivep, char *bufp, size_t retcnt )
 {
 	drive_context_t *contextp;
@@ -2000,7 +2000,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 	global_hdr_t *gwhdrp;
 	size_t heldcnt;
 	off64_t last_rec_wrtn_wo_err; /* zero-based index */
-	intgen_t rval;
+	int rval;
 
 	/* get drive context and pointer to global write hdr
 	 */
@@ -2165,7 +2165,7 @@ do_get_align_cnt( drive_t * drivep )
  *	 0 on success
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 do_end_write( drive_t *drivep, off64_t *ncommittedp )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
@@ -2174,7 +2174,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	off64_t recs_guaranteed;
 	off64_t bytes_committed;
 
-	intgen_t rval;
+	int rval;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: end write\n" );
@@ -2310,7 +2310,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	 * exposing any write errors.
 	 */
 	if ( ! rval ) {
-		intgen_t weofrval;
+		int weofrval;
 		mtstat_t mtstat;
 		bool_t ok;
 
@@ -2375,8 +2375,8 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
  *	number of media files skipped
  *	*statp set to zero or DRIVE_ERROR_...
  */
-static intgen_t
-do_fsf( drive_t *drivep, intgen_t count, intgen_t *statp )
+static int
+do_fsf( drive_t *drivep, int count, int *statp )
 {
 	int 		i, done, op_failed, opcount;
 	mtstat_t mtstat;
@@ -2475,13 +2475,13 @@ do_fsf( drive_t *drivep, intgen_t count, intgen_t *statp )
  *	number of media files skipped
  *	*statp set to zero or DRIVE_ERROR_...
  */
-static intgen_t
-do_bsf( drive_t *drivep, intgen_t count, intgen_t *statp )
+static int
+do_bsf( drive_t *drivep, int count, int *statp )
 {
 #ifdef DEBUG
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 #endif
-	intgen_t skipped;
+	int skipped;
 	mtstat_t mtstat;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
@@ -2601,7 +2601,7 @@ do_bsf( drive_t *drivep, intgen_t count, intgen_t *statp )
  *	0 on success
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 do_rewind( drive_t *drivep )
 {
 #ifdef DEBUG
@@ -2632,7 +2632,7 @@ do_rewind( drive_t *drivep )
  *	0 on success
  *	DRIVE_ERROR_* on failure
  */
-static intgen_t
+static int
 do_erase( drive_t *drivep )
 {
 #ifdef DEBUG
@@ -2677,7 +2677,7 @@ do_erase( drive_t *drivep )
  *	0 on success
  *	DRIVE_ERROR_DEVICE on failure
  */
-static intgen_t
+static int
 do_eject_media( drive_t *drivep )
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
@@ -2710,7 +2710,7 @@ do_eject_media( drive_t *drivep )
  *	always returns DEVICE_TAPE_REMOVABLE
  */
 /* ARGSUSED */
-static intgen_t
+static int
 do_get_device_class( drive_t *drivep)
 {
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
@@ -2832,15 +2832,15 @@ percent64( off64_t num, off64_t denom )
  */  
 
 
-static intgen_t
+static int
 read_label( drive_t *drivep )
 {
 	drive_context_t *contextp;
-	intgen_t nread;
-	intgen_t saved_errno;
+	int nread;
+	int saved_errno;
 	mtstat_t mtstat;
 	bool_t wasatbotpr;
-	intgen_t rval;
+	int rval;
 	bool_t ok;
 
 	/* initialize context ptr
@@ -2918,8 +2918,8 @@ read_label( drive_t *drivep )
 
 	/* if a read error, get status
 	 */
-	if ( nread != ( intgen_t )tape_recsz ) {
-		assert( nread < ( intgen_t )tape_recsz );
+	if ( nread != ( int )tape_recsz ) {
+		assert( nread < ( int )tape_recsz );
 		ok = mt_get_status( drivep, &mtstat );
 		if ( ! ok ) {
 			status_failed_message( drivep );
@@ -3008,7 +3008,7 @@ read_label( drive_t *drivep )
 	return rval;
 }
 
-static intgen_t
+static int
 validate_media_file_hdr( drive_t *drivep )
 {
 	global_hdr_t		*grhdrp = drivep->d_greadhdrp;
@@ -3169,7 +3169,7 @@ set_fixed_blksz( drive_t *drivep, size_t blksz )
                  */
                 if ( mt_op( contextp->dc_fd,
                             MTSETBLK,  
-                            ( intgen_t )blksz ) ) {
+                            ( int )blksz ) ) {
 			mlog( MLOG_DEBUG | MLOG_DRIVE,
 			      "MTSETBLK %u failed: %s (%d)\n",
 			      blksz,
@@ -3328,7 +3328,7 @@ set_recommended_sizes( drive_t *drivep )
  *	FALSE on failure
  */
 static bool_t
-mt_blkinfo( intgen_t fd, struct mtblkinfo *minfo )
+mt_blkinfo( int fd, struct mtblkinfo *minfo )
 {
 	struct mtget 	mt_stat;
 
@@ -3382,12 +3382,12 @@ mt_blkinfo( intgen_t fd, struct mtblkinfo *minfo )
  *	0 on success
  *	-1 on failure
  */
-static intgen_t
-mt_op(intgen_t fd, intgen_t sub_op, intgen_t param )
+static int
+mt_op(int fd, int sub_op, int param )
 {
 	struct mtop 	mop;
 	char *printstr;
-	intgen_t rval;
+	int rval;
 
 	mop.mt_op   	= (short )sub_op;
 	mop.mt_count	= param;
@@ -3554,11 +3554,11 @@ mt_get_status( drive_t *drivep, long *status)
  * RETURNS:
  *	DRIVE_ERROR_*
  */
-static intgen_t
+static int
 determine_write_error( drive_t *drivep, int nwritten, int saved_errno )
 {
 	mtstat_t	mtstat;
-	intgen_t 	ret;
+	int 	ret;
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 
 	/* get tape device status
@@ -3847,7 +3847,7 @@ is_variable( drive_t *drivep, bool_t *varblk )
  * determines other drive attributes. determines if any previous
  * xfsdumps on media.
  */
-static intgen_t
+static int
 prepare_drive( drive_t *drivep )
 {
 	drive_context_t	*contextp;
@@ -3856,7 +3856,7 @@ prepare_drive( drive_t *drivep )
 	ix_t try;
 	ix_t maxtries;
 	bool_t changedblkszpr;
-	intgen_t rval;
+	int rval;
 	int varblk;
 
 	/* get pointer to drive context
@@ -4055,8 +4055,8 @@ retry:
 	changedblkszpr = BOOL_FALSE;
 	for ( try = 1 ; ; try++ ) {
 		bool_t wasatbotpr;
-		intgen_t nread;
-		intgen_t saved_errno;
+		int nread;
+		int saved_errno;
 
 		if ( cldmgr_stop_requested( )) {
 			return DRIVE_ERROR_STOP;
@@ -4426,7 +4426,7 @@ retry:
 			goto checkhdr;
 		}
 
-		if ( nread < ( intgen_t )tape_recsz
+		if ( nread < ( int )tape_recsz
 		     &&
 		     ! contextp->dc_isvarpr ) {
 			mlog( MLOG_DEBUG | MLOG_DRIVE,
@@ -4436,7 +4436,7 @@ retry:
 			goto newsize;
 		}
 		
-		if ( nread == ( intgen_t )tape_recsz
+		if ( nread == ( int )tape_recsz
 		     &&
 		     ! contextp->dc_isvarpr ) {
 			mlog( MLOG_DEBUG | MLOG_DRIVE,
@@ -4651,7 +4651,7 @@ static bool_t
 Open( drive_t *drivep )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t oflags;
+	int oflags;
 
 #ifdef DUMP
 	oflags = O_RDWR;
@@ -4691,11 +4691,11 @@ Close( drive_t *drivep )
 	contextp->dc_fd = -1;
 }
 
-static intgen_t
-Read( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
+static int
+Read( drive_t *drivep, char *bufp, size_t cnt, int *errnop )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nread;
+	int nread;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "tape op: reading %u bytes\n",
@@ -4713,7 +4713,7 @@ Read( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
 		      cnt,
 		      errno,
 		      strerror( errno ));
-	} else if ( nread != ( intgen_t )cnt ) {
+	} else if ( nread != ( int )cnt ) {
 		mlog( MLOG_NITTY | MLOG_DRIVE,
 		      "tape op read of %u bytes short: nread == %d\n",
 		      cnt,
@@ -4727,11 +4727,11 @@ Read( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
 	return nread;
 }
 
-static intgen_t
-Write( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
+static int
+Write( drive_t *drivep, char *bufp, size_t cnt, int *errnop )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nwritten;
+	int nwritten;
 
 	mlog( MLOG_DEBUG | MLOG_DRIVE,
 	      "tape op: writing %u bytes\n",
@@ -4749,7 +4749,7 @@ Write( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
 		      cnt,
 		      errno,
 		      strerror( errno ));
-	} else if ( nwritten != ( intgen_t )cnt ) {
+	} else if ( nwritten != ( int )cnt ) {
 		mlog( MLOG_NITTY | MLOG_DRIVE,
 		      "tape op write of %u bytes short: nwritten == %d\n",
 		      cnt,
@@ -4768,7 +4768,7 @@ Write( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
  * skips skipcnt media files.
  */
 /* ARGSUSED */
-static intgen_t
+static int
 quick_backup( drive_t *drivep, drive_context_t *contextp, ix_t skipcnt )
 {
 	if ( drivep->d_capabilities & DRIVE_CAP_BSF ) {
@@ -4798,7 +4798,7 @@ quick_backup( drive_t *drivep, drive_context_t *contextp, ix_t skipcnt )
 /* validate a record header, log any anomolies, and return appropriate
  * indication.
  */
-static intgen_t
+static int
 record_hdr_validate( drive_t *drivep, char *bufp, bool_t chkoffpr )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
@@ -4886,18 +4886,18 @@ record_hdr_validate( drive_t *drivep, char *bufp, bool_t chkoffpr )
 /* do a read, determine DRIVE_ERROR_... if failure, and return failure code.
  * return 0 on success.
  */
-static intgen_t
+static int
 read_record(  drive_t *drivep, char *bufp )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nread;
-	intgen_t saved_errno;
+	int nread;
+	int saved_errno;
 	mtstat_t mtstat;
-	intgen_t rval;
+	int rval;
 	bool_t ok;
 
 	nread = Read( drivep, bufp, tape_recsz, &saved_errno );
-	if ( nread == ( intgen_t )tape_recsz ) {
+	if ( nread == ( int )tape_recsz ) {
 		contextp->dc_iocnt++;
 		rval = record_hdr_validate( drivep, bufp, BOOL_TRUE );
 		return rval;
@@ -4950,7 +4950,7 @@ read_record(  drive_t *drivep, char *bufp )
 	/* short read
 	 */
 	if ( nread >= 0 ) {
-		assert( nread <= ( intgen_t )tape_recsz );
+		assert( nread <= ( int )tape_recsz );
 		mlog( MLOG_DEBUG | MLOG_DRIVE,
 		      "short read record %lld (nread == %d)\n",
 		      contextp->dc_iocnt,
@@ -4978,7 +4978,7 @@ ring_read( void *clientctxp, char *bufp )
 
 /* gets another record IF dc_recp is NULL
  */
-static intgen_t
+static int
 getrec( drive_t *drivep )
 {
 	drive_context_t *contextp;
@@ -4987,7 +4987,7 @@ getrec( drive_t *drivep )
 	while ( ! contextp->dc_recp ) {
 		rec_hdr_t *rechdrp;
 		if ( contextp->dc_singlethreadedpr ) {
-			intgen_t rval;
+			int rval;
 			contextp->dc_recp = contextp->dc_bufp;
 			rval = read_record( drivep, contextp->dc_recp );
 			if ( rval ) {
@@ -5035,13 +5035,13 @@ getrec( drive_t *drivep )
  * return 0 on success.
  */
 /*ARGSUSED*/
-static intgen_t
+static int
 write_record(  drive_t *drivep, char *bufp, bool_t chksumpr, bool_t xlatepr )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nwritten;
-	intgen_t saved_errno;
-	intgen_t rval;
+	int nwritten;
+	int saved_errno;
+	int rval;
 
         if ( xlatepr ) {
 		rec_hdr_t rechdr;
@@ -5055,7 +5055,7 @@ write_record(  drive_t *drivep, char *bufp, bool_t chksumpr, bool_t xlatepr )
 
 	nwritten = Write( drivep, bufp, tape_recsz, &saved_errno );
 
-	if ( nwritten == ( intgen_t )tape_recsz ) {
+	if ( nwritten == ( int )tape_recsz ) {
 		contextp->dc_iocnt++;
 		return 0;
 	}
@@ -5123,7 +5123,7 @@ calc_max_lost( drive_t *drivep )
 }
 
 static void
-display_ring_metrics( drive_t *drivep, intgen_t mlog_flags )
+display_ring_metrics( drive_t *drivep, int mlog_flags )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 	ring_t *ringp = contextp->dc_ringp;
@@ -5174,7 +5174,7 @@ rewind_and_verify( drive_t *drivep )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 	ix_t try;
-	intgen_t rval;
+	int rval;
 
 	rval = mt_op( contextp->dc_fd, MTREW, 0 );
 	for ( try = 1 ; ; try++ ) {
diff --git a/common/drive_simple.c b/common/drive_simple.c
index 69fce4b..45bc28c 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -84,7 +84,7 @@ struct drive_context {
 	char *dc_nextp;		/* next byte avail. to read/write */
 	char *dc_emptyp;	/* first empty slot in buffer */
 	off64_t dc_bufstroff;	/* offset in stream of top of buf */
-	intgen_t dc_fd;		/* input/output file descriptor */
+	int dc_fd;		/* input/output file descriptor */
 	drive_mark_t dc_firstmark;/* first mark's offset within mfile (dump) */
 	ix_t dc_markcnt;	/* count of marks set (dump) */
 	bool_t dc_rampr;	/* can randomly access file (not a pipe) */
@@ -104,30 +104,30 @@ extern size_t pgsz;
 
 /* strategy functions
  */
-static intgen_t ds_match( int, char *[], drive_t * );
-static intgen_t ds_instantiate( int, char *[], drive_t * );
+static int ds_match( int, char *[], drive_t * );
+static int ds_instantiate( int, char *[], drive_t * );
 
 /* declare manager operators
  */
 static bool_t do_init( drive_t * );
 static bool_t do_sync( drive_t * );
-static intgen_t do_begin_read( drive_t * );
-static char *do_read( drive_t *, size_t , size_t *, intgen_t * );
+static int do_begin_read( drive_t * );
+static char *do_read( drive_t *, size_t , size_t *, int * );
 static void do_return_read_buf( drive_t *, char *, size_t );
 static void do_get_mark( drive_t *, drive_mark_t * );
-static intgen_t do_seek_mark( drive_t *, drive_mark_t * );
-static intgen_t do_next_mark( drive_t * );
+static int do_seek_mark( drive_t *, drive_mark_t * );
+static int do_next_mark( drive_t * );
 static void do_get_mark( drive_t *, drive_mark_t * );
 static void do_end_read( drive_t * );
-static intgen_t do_begin_write( drive_t * );
+static int do_begin_write( drive_t * );
 static void do_set_mark( drive_t *, drive_mcbfp_t, void *, drive_markrec_t * );
 static char * do_get_write_buf( drive_t *, size_t , size_t * );
-static intgen_t do_write( drive_t *, char *, size_t );
+static int do_write( drive_t *, char *, size_t );
 static size_t do_get_align_cnt( drive_t * );
-static intgen_t do_end_write( drive_t *, off64_t * );
-static intgen_t do_rewind( drive_t * );
-static intgen_t do_erase( drive_t * );
-static intgen_t do_get_device_class( drive_t * );
+static int do_end_write( drive_t *, off64_t * );
+static int do_rewind( drive_t * );
+static int do_erase( drive_t * );
+static int do_get_device_class( drive_t * );
 static void do_quit( drive_t * );
 
 
@@ -183,7 +183,7 @@ static drive_ops_t drive_ops = {
 /* strategy match - determines if this is the right strategy
  */
 /* ARGSUSED */
-static intgen_t
+static int
 ds_match( int argc, char *argv[], drive_t *drivep )
 {
 	bool_t isrmtpr;
@@ -265,7 +265,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 		contextp->dc_fd = 0;
 #endif /* RESTORE */
 	} else if ( contextp->dc_isrmtpr ) {
-		intgen_t oflags;
+		int oflags;
 #ifdef DUMP
 		oflags = O_WRONLY | O_CREAT | O_TRUNC;
 #endif /* DUMP */
@@ -285,9 +285,9 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 			return BOOL_FALSE;
 		}
 	} else {
-		intgen_t oflags = 0;
+		int oflags = 0;
 		struct stat statbuf;
-		intgen_t rval;
+		int rval;
 		rval = stat( drivep->d_pathname, &statbuf );
 #ifdef DUMP
 		if ( rval ) {
@@ -419,17 +419,17 @@ do_sync( drive_t *drivep )
 /* drive op begin_read - prepare file for reading - main job is to
  * read the media hdr
  */
-static intgen_t
+static int
 do_begin_read( drive_t *drivep )
 {
 #ifdef DEBUG
-	intgen_t dcaps = drivep->d_capabilities;
+	int dcaps = drivep->d_capabilities;
 #endif
 	global_hdr_t *grhdrp = drivep->d_greadhdrp;
 	drive_hdr_t *drhdrp = drivep->d_readhdrp;
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 	global_hdr_t		*tmphdr = (global_hdr_t	*)malloc(GLOBAL_HDR_SZ);
 	drive_hdr_t		*tmpdh = (drive_hdr_t *)tmphdr->gh_upper;
 	media_hdr_t		*tmpmh = (media_hdr_t *)tmpdh->dh_upper;
@@ -579,7 +579,7 @@ static char *
 do_read( drive_t *drivep,
          size_t wantedcnt,
          size_t *actualcntp,
-         intgen_t *rvalp )
+         int *rvalp )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 	size_t remainingcnt;
@@ -734,7 +734,7 @@ do_get_mark( drive_t *drivep, drive_mark_t *markp )
 /* seek forward to the specified mark. the caller must not have already read
  * past that point.
  */
-static intgen_t
+static int
 do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
@@ -742,10 +742,10 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	off64_t nextoff;
 	off64_t strmoff;
 	/* REFERENCED */
-	intgen_t nread;
+	int nread;
 	off64_t nreadneeded64;
-	intgen_t nreadneeded;
-	intgen_t rval;
+	int nreadneeded;
+	int rval;
 
 	mlog( MLOG_NITTY | MLOG_DRIVE,
 	      "drive_simple seek_mark( )\n" );
@@ -775,7 +775,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		if ( nreadneeded64 > INTGENMAX )
 			nreadneeded = INTGENMAX;
 		else
-			nreadneeded = ( intgen_t )nreadneeded64;
+			nreadneeded = ( int )nreadneeded64;
 		nread = read_buf( 0, nreadneeded, drivep,
 				  ( rfp_t )drivep->d_opsp->do_read,
 				( rrbfp_t )drivep->d_opsp->do_return_read_buf,
@@ -799,15 +799,15 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
  * mark in the media file (recorded in the header). if the caller
  * has already read past that mark, blow up.
  */
-static intgen_t
+static int
 do_next_mark( drive_t *drivep )
 {
 #ifdef DEBUG
-	intgen_t dcaps = drivep->d_capabilities;
+	int dcaps = drivep->d_capabilities;
 #endif
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 	drive_mark_t mark = contextp->dc_firstmark;
-	intgen_t rval;
+	int rval;
 
 	mlog( MLOG_NITTY | MLOG_DRIVE,
 	      "drive_simple next_mark( )\n" );
@@ -854,10 +854,10 @@ do_end_read( drive_t *drivep )
 
 /* begin_write - prepare file for writing
  */
-static intgen_t
+static int
 do_begin_write( drive_t *drivep )
 {
-	intgen_t dcaps = drivep->d_capabilities;
+	int dcaps = drivep->d_capabilities;
 	global_hdr_t *gwhdrp = drivep->d_gwritehdrp;
 	drive_hdr_t *dwhdrp = drivep->d_writehdrp;
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
@@ -1055,7 +1055,7 @@ do_set_mark( drive_t *drivep,
 			drive_hdr_t		*dwhdrp = drivep->d_writehdrp;
 			off64_t			newoff;
 			/* REFERENCED */
-			intgen_t		nwritten;
+			int		nwritten;
 
 			/* assert the header has been flushed
 			 */
@@ -1219,7 +1219,7 @@ do_get_write_buf( drive_t *drivep, size_t wanted_bufsz, size_t *actual_bufszp )
  * caller.
  */
 /*ARGSUSED*/
-static intgen_t
+static int
 do_write( drive_t *drivep, char *bufp, size_t writesz )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
@@ -1265,7 +1265,7 @@ do_write( drive_t *drivep, char *bufp, size_t writesz )
 	/* if buffer is full, flush it
 	 */
 	if ( contextp->dc_nextp == contextp->dc_emptyp ) {
-		intgen_t nwritten;
+		int nwritten;
 
 		mlog( MLOG_DEBUG | MLOG_DRIVE,
 		      "flushing write buf addr 0x%x size 0x%x\n",
@@ -1333,7 +1333,7 @@ do_get_align_cnt( drive_t *drivep )
 /* end_write - flush any buffered data, and return by reference how many
  * bytes were committed.
  */
-static intgen_t
+static int
 do_end_write( drive_t *drivep, off64_t *ncommittedp )
 {
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
@@ -1402,11 +1402,11 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 
 /* rewind - return the current file offset to the beginning
  */
-intgen_t
+int
 do_rewind( drive_t *drivep )
 {
 #ifdef DEBUG
-	intgen_t dcaps = drivep->d_capabilities;
+	int dcaps = drivep->d_capabilities;
 #endif
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 	off64_t newoff;
@@ -1437,15 +1437,15 @@ do_rewind( drive_t *drivep )
 
 /* erase - truncate to zero length
  */
-intgen_t
+int
 do_erase( drive_t *drivep )
 {
 #ifdef DEBUG
-	intgen_t dcaps = drivep->d_capabilities;
+	int dcaps = drivep->d_capabilities;
 #endif
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
 	off64_t newoff;
-	intgen_t rval;
+	int rval;
 
 	mlog( MLOG_NITTY | MLOG_DRIVE,
 	      "drive_simple erase( )\n" );
@@ -1487,7 +1487,7 @@ do_erase( drive_t *drivep )
 /* get_media_class()
  */
 /* ARGSUSED */
-static intgen_t 
+static int 
 do_get_device_class( drive_t *drivep )
 {
 	mlog( MLOG_NITTY | MLOG_DRIVE,
diff --git a/common/exit.h b/common/exit.h
index f7e4878..403946d 100644
--- a/common/exit.h
+++ b/common/exit.h
@@ -26,7 +26,7 @@
 #define EXIT_FAULT	4	/* code fault */
 
 static inline const char *
-exit_codestring( intgen_t code )
+exit_codestring( int code )
 {
 	switch ( code ) {
 	case EXIT_NORMAL:    return "SUCCESS";
diff --git a/common/fs.c b/common/fs.c
index 2cd2f72..184f08d 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -109,12 +109,12 @@ static fs_tab_ent_t *fs_tab_lookup_mnt( char * );
 /* ARGSUSED */
 bool_t
 fs_info( char *typb,		/* out */
-	 intgen_t typbz,
+	 int typbz,
 	 char *typd,
 	 char *blkb,		/* out */
-	 intgen_t blkbz,
+	 int blkbz,
 	 char *mntb,		/* out */
-	 intgen_t mntbz,
+	 int mntbz,
 	 uuid_t *idb,		/* out */
 	 char *usrs )		/* in */
 {
@@ -169,7 +169,7 @@ fs_info( char *typb,		/* out */
 	assert( ok != BOOL_UNKNOWN );
 
 	if ( ok == BOOL_TRUE ) {
-		intgen_t rval = fs_getid( mntb, idb );
+		int rval = fs_getid( mntb, idb );
 		if ( rval ) {
 			mlog( MLOG_NORMAL,
 			      _("unable to determine uuid of fs mounted at %s: "
@@ -201,7 +201,7 @@ fs_mounted( char *typs, char *chrs, char *mnts, uuid_t *idp )
 	return strlen( mnts ) > 0 ? BOOL_TRUE : BOOL_FALSE;
 }
 
-intgen_t
+int
 fs_getid( char *mnts, uuid_t *idb )
 {
 	xfs_fsop_geom_v1_t geo;
@@ -227,7 +227,7 @@ size_t
 fs_getinocnt( char *mnts )
 {
 	struct statvfs vfsstat;
-	intgen_t rval;
+	int rval;
 
 	rval = statvfs( mnts, &vfsstat );
 	if ( rval ) {
diff --git a/common/fs.h b/common/fs.h
index 9ad1636..4a9d9d1 100644
--- a/common/fs.h
+++ b/common/fs.h
@@ -32,12 +32,12 @@
  * returns BOOL_FALSE if srcname does not describe a file system.
  */
 extern bool_t fs_info( char *fstype,		/* out: fs type (fsid.h) */
-		       intgen_t fstypesz,	/* in: buffer size */
+		       int fstypesz,	/* in: buffer size */
 		       char *fstypedef,		/* in: default fs type */
 		       char *fsdevice,		/* out: blk spec. dev. file */
-		       intgen_t fsdevicesz,	/* in: buffer size */
+		       int fsdevicesz,	/* in: buffer size */
 		       char *mntpt,		/* out: where fs mounted */
-		       intgen_t mntptsz,	/* in: buffer size */
+		       int mntptsz,	/* in: buffer size */
 		       uuid_t *fsid,		/* out: fs uuid */
 		       char *srcname );		/* in: how user named the fs */
 
@@ -51,7 +51,7 @@ extern bool_t fs_mounted( char *fstype,
 /* fs_getid - retrieves the uuid of the file system containing the named
  * file. returns -1 with errno set on error.
  */
-extern intgen_t fs_getid( char *fullpathname, uuid_t *fsidp );
+extern int fs_getid( char *fullpathname, uuid_t *fsidp );
 
 /* tells how many inos in use
  */
diff --git a/common/global.c b/common/global.c
index 319d4df..2129941 100644
--- a/common/global.c
+++ b/common/global.c
@@ -58,7 +58,7 @@ static char * prompt_label( char *bufp, size_t bufsz );
 /* definition of locally defined global functions ****************************/
 
 global_hdr_t *
-global_hdr_alloc( intgen_t argc, char *argv[ ] )
+global_hdr_alloc( int argc, char *argv[ ] )
 {
 	global_hdr_t *ghdrp;
 	int c;
@@ -68,7 +68,7 @@ global_hdr_alloc( intgen_t argc, char *argv[ ] )
 	struct stat64 statb;
 #endif /* DUMP */
 
-	intgen_t rval;
+	int rval;
 
 	/* sanity checks
 	 */
diff --git a/common/global.h b/common/global.h
index 6556a68..537be0c 100644
--- a/common/global.h
+++ b/common/global.h
@@ -73,7 +73,7 @@ typedef struct global_hdr global_hdr_t;
 /* used by main( ) to allocate and populate a global header template.
  * drive managers will copy this into the write header.
  */
-extern global_hdr_t * global_hdr_alloc( intgen_t argc, char *argv[ ] );
+extern global_hdr_t * global_hdr_alloc( int argc, char *argv[ ] );
 
 
 /* used by main( ) to free the global header template after drive ini.
diff --git a/common/inventory.c b/common/inventory.c
index 681d28f..d1c067b 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -232,7 +232,7 @@ inv_writesession_open(
 {
 	invt_session_t *ses;
 	int		fd;
-	intgen_t	rval;
+	int	rval;
 	invt_sescounter_t *sescnt = NULL;
 	invt_seshdr_t  	hdr;
 	inv_sestoken_t	sestok;
@@ -547,7 +547,7 @@ inv_put_mediafile(
 /*          get                                                         */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 inv_get_inolist(
 	inv_inolist_t 	**inolist )
 {
diff --git a/common/inventory.h b/common/inventory.h
index ee5a977..351f6e0 100644
--- a/common/inventory.h
+++ b/common/inventory.h
@@ -237,7 +237,7 @@ inv_DEBUG_printallsessions(
 
 #endif /* ifdef DEBUG */
 
-extern intgen_t
+extern int
 inv_setup_base( void );
 
 extern char *
diff --git a/common/main.c b/common/main.c
index 3b82a76..08bf574 100644
--- a/common/main.c
+++ b/common/main.c
@@ -103,7 +103,7 @@ static bool_t set_rlimits( void );
 #ifdef RESTORE
 static bool_t set_rlimits( size64_t * );
 #endif /* RESTORE */
-static char *sig_numstring( intgen_t num );
+static char *sig_numstring( int num );
 static char *strpbrkquotes( char *p, const char *sep );
 
 
@@ -133,7 +133,7 @@ static bool_t sigterm_received;
 static bool_t sigquit_received;
 static bool_t sigint_received;
 /* REFERENCED */
-static intgen_t sigstray_received;
+static int sigstray_received;
 static bool_t progrpt_enabledpr;
 static time32_t progrpt_interval;
 static time32_t progrpt_deadline;
@@ -156,11 +156,11 @@ main( int argc, char *argv[] )
 #endif /* DUMP */
 	bool_t init_error;
 	bool_t coredump_requested = BOOL_FALSE;
-	intgen_t exitcode;
+	int exitcode;
 	rlim64_t tmpstacksz;
 	struct sigaction sa;
-	intgen_t prbcld_xc = EXIT_NORMAL;
-	intgen_t xc;
+	int prbcld_xc = EXIT_NORMAL;
+	int xc;
 	bool_t ok;
 	/* REFERENCED */
 	int rval;
@@ -371,7 +371,7 @@ main( int argc, char *argv[] )
 	mlog( MLOG_DEBUG | MLOG_PROC,
 	      "getpagesize( ) returns %u\n",
 	      pgsz );
-	assert( ( intgen_t )pgsz > 0 );
+	assert( ( int )pgsz > 0 );
 	pgmask = pgsz - 1;
 
 	/* report parent tid
@@ -571,7 +571,7 @@ main( int argc, char *argv[] )
 	/* if in a pipeline, go single-threaded with just one stream.
 	 */
 	if ( pipeline ) {
-		intgen_t exitcode;
+		int exitcode;
 
 		sa.sa_handler = sighandler;
 		sigaction( SIGINT, &sa, NULL );
@@ -662,12 +662,12 @@ main( int argc, char *argv[] )
 	 * signals.
 	 */
 	if ( progrpt_enabledpr ) {
-		( void )alarm( ( u_intgen_t )progrpt_interval );
+		( void )alarm( ( u_int )progrpt_interval );
 	}
 	for ( ; ; ) {
 		time32_t now;
 		bool_t stop_requested = BOOL_FALSE;
-		intgen_t stop_timeout = -1;
+		int stop_timeout = -1;
 		sigset_t empty_set;
 
 		/* if there was an initialization error,
@@ -805,7 +805,7 @@ main( int argc, char *argv[] )
 		/* set alarm if needed (note time stands still during dialog)
 		 */
 		if ( stop_in_progress ) {
-			intgen_t timeout = ( intgen_t )( stop_deadline - now );
+			int timeout = ( int )( stop_deadline - now );
 			if ( timeout < 0 ) {
 				timeout = 0;
 			}
@@ -813,7 +813,7 @@ main( int argc, char *argv[] )
 			      "setting alarm for %d second%s\n",
 			      timeout,
 			      timeout == 1 ? "" : "s" );
-			( void )alarm( ( u_intgen_t )timeout );
+			( void )alarm( ( u_int )timeout );
 			if ( timeout == 0 ) {
 				continue;
 			}
@@ -835,7 +835,7 @@ main( int argc, char *argv[] )
 					      statline[ i ] );
 				}
 			}
-			( void )alarm( ( u_intgen_t )( progrpt_deadline
+			( void )alarm( ( u_int )( progrpt_deadline
 						       -
 						       now ));
 		}
@@ -1112,22 +1112,22 @@ preemptchk( int flg )
 /* definition of locally defined static functions ****************************/
 
 static bool_t
-loadoptfile( intgen_t *argcp, char ***argvp )
+loadoptfile( int *argcp, char ***argvp )
 {
 	char *optfilename;
 	ix_t optfileix = 0;
-	intgen_t fd;
+	int fd;
 	size_t sz;
-	intgen_t i;
+	int i;
 	struct stat64 stat;
 	char *argbuf;
 	char *p;
 	size_t tokencnt;
-	intgen_t nread;
+	int nread;
 	const char *sep = " \t\n\r";
 	char **newargv;
-	intgen_t c;
-	intgen_t rval;
+	int c;
+	int rval;
 
 	/* see if option specified
 	 */
@@ -1202,7 +1202,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
 	 */
 	sz = 0;
 	for ( i =  0 ; i < *argcp ; i++ ) {
-		if ( i == ( intgen_t )optfileix ) {
+		if ( i == ( int )optfileix ) {
 			i++; /* to skip option argument */
 			continue;
 		}
@@ -1246,7 +1246,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
 	/* copy the remaining command line args into the buffer
 	 */
 	for ( ; i < *argcp ; i++ ) {
-		if ( i == ( intgen_t )optfileix ) {
+		if ( i == ( int )optfileix ) {
 			i++; /* to skip option argument */
 			continue;
 		}
@@ -1262,7 +1262,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
 	/* change newlines and carriage returns into spaces
 	 */
 	for ( p = argbuf ; *p ; p++ ) {
-		if ( strchr( "\n\r", ( intgen_t )( *p ))) {
+		if ( strchr( "\n\r", ( int )( *p ))) {
 			*p = ' ';
 		}
 	}
@@ -1274,7 +1274,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
 	for ( ; ; ) {
 		/* start at the first non-separator character
 		 */
-		while ( *p && strchr( sep, ( intgen_t )( *p ))) {
+		while ( *p && strchr( sep, ( int )( *p ))) {
 			p++;
 		}
 
@@ -1320,7 +1320,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
 
 		/* start at the first non-separator character
 		 */
-		while ( *p && strchr( sep, ( intgen_t )*p )) {
+		while ( *p && strchr( sep, ( int )*p )) {
 			p++;
 		}
 
@@ -1332,7 +1332,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
 
 		/* better not disagree with counting scan!
 		 */
-		assert( i < ( intgen_t )tokencnt );
+		assert( i < ( int )tokencnt );
 
 		/* find the end of the first token
 		 */
@@ -1364,7 +1364,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
 	/* return new argc anr argv
 	 */
 	close( fd );
-	*argcp = ( intgen_t )tokencnt;
+	*argcp = ( int )tokencnt;
 	*argvp = newargv;
 	return BOOL_TRUE;
 }
@@ -1382,7 +1382,7 @@ sighandler( int signo )
 	/* if in pipeline, don't do anything risky. just quit.
 	 */
 	if ( pipeline ) {
-		intgen_t rval;
+		int rval;
 
 		mlog( MLOG_TRACE | MLOG_NOTE | MLOG_NOLOCK | MLOG_PROC,
 		      _("received signal %d (%s): cleanup and exit\n"),
@@ -1433,7 +1433,7 @@ static int
 childmain( void *arg1 )
 {
 	ix_t stix;
-	intgen_t exitcode;
+	int exitcode;
 	drive_t *drivep;
 
 	/* Determine which stream I am.
@@ -1519,7 +1519,7 @@ sigint_dialog( void )
 	size_t allix;
 	size_t nochangeix;
 	size_t responseix;
-	intgen_t ssselected = 0;
+	int ssselected = 0;
 	bool_t stop_requested = BOOL_FALSE;
 
 	/* preamble: the content status line, indicate if interrupt happening
@@ -1661,7 +1661,7 @@ sigint_dialog( void )
 			ssselected = -1;
 			ackstr[ ackcnt++ ] = _("all subsystems selected\n\n");
 		} else {
-			ssselected = ( intgen_t )responseix;
+			ssselected = ( int )responseix;
 			ackstr[ ackcnt++ ] = "\n";
 		}
 		dlog_multi_ack( ackstr,
@@ -1721,11 +1721,11 @@ sigint_dialog( void )
 					      ;
 					      ssix++ ) {
 						mlog_level_ss[ ssix ] =
-							( intgen_t )responseix;
+							( int )responseix;
 					}
 				} else {
 					mlog_level_ss[ ssselected ] =
-							( intgen_t )responseix;
+							( int )responseix;
 				}
 				ackstr[ ackcnt++ ] = _("level changed\n");
 			}
@@ -1888,7 +1888,7 @@ sigint_dialog( void )
 							ncix,  /* sigquit ix */
 							okix );
 			if ( responseix == okix ) {
-				intgen_t newinterval;
+				int newinterval;
 				newinterval = atoi( buf );
 				if ( ! strlen( buf )) {
 					ackstr[ ackcnt++ ] = _("no change\n");
@@ -1982,11 +1982,11 @@ sigint_dialog( void )
 static char *
 sigintstr( void )
 {
-	intgen_t ttyfd;
+	int ttyfd;
 	static char buf[ 20 ];
 	struct termios termios;
 	cc_t intchr;
-	intgen_t rval;
+	int rval;
 
 	ttyfd = dlog_fd( );
 	if ( ttyfd == -1 ) {
@@ -2034,7 +2034,7 @@ set_rlimits( size64_t *vmszp )
 	size64_t vmsz;
 #endif /* RESTORE */
 	/* REFERENCED */
-	intgen_t rval;
+	int rval;
 
 	assert( minstacksz <= maxstacksz );
 
@@ -2203,7 +2203,7 @@ set_rlimits( size64_t *vmszp )
 }
 
 struct sig_printmap {
-	intgen_t num;
+	int num;
 	char *string;
 };
 
@@ -2240,7 +2240,7 @@ static sig_printmap_t sig_printmap[ ] = {
 };
 
 static char *
-sig_numstring( intgen_t num )
+sig_numstring( int num )
 {
 	sig_printmap_t *p = sig_printmap;
 	sig_printmap_t *endp = sig_printmap
@@ -2291,7 +2291,7 @@ strpbrkquotes( char *p, const char *sep )
 		}
 
 		if ( ! inquotes ) {
-			if ( strchr( sep, ( intgen_t )( *p ))) {
+			if ( strchr( sep, ( int )( *p ))) {
 				return p;
 			}
 		}
diff --git a/common/media.c b/common/media.c
index 7d17405..fceb78d 100644
--- a/common/media.c
+++ b/common/media.c
@@ -89,7 +89,7 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 					     /
 					     sizeof( strategyp[ 0 ] );
 	media_strategy_t *chosen_sp;
-	intgen_t id;
+	int id;
 	bool_t ok;
 
 	/* sanity check asserts
diff --git a/common/mlog.c b/common/mlog.c
index 1fef185..fd21c18 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -54,15 +54,15 @@ static FILE *mlog_fp = NULL; /* stderr */;
 static FILE *mlog_fp = NULL; /* stdout */;
 #endif /* RESTORE */
 
-intgen_t mlog_level_ss[ MLOG_SS_CNT ];
+int mlog_level_ss[ MLOG_SS_CNT ];
 
-intgen_t mlog_showlevel = BOOL_FALSE;
+int mlog_showlevel = BOOL_FALSE;
 
-intgen_t mlog_showss = BOOL_FALSE;
+int mlog_showss = BOOL_FALSE;
 
-intgen_t mlog_timestamp = BOOL_FALSE;
+int mlog_timestamp = BOOL_FALSE;
 
-static intgen_t mlog_sym_lookup( char * );
+static int mlog_sym_lookup( char * );
 
 static size_t mlog_streamcnt;
 
@@ -84,7 +84,7 @@ static char mlog_tsstr[ 10 ];
 
 struct mlog_sym {
 	char *sym;
-	intgen_t level;
+	int level;
 };
 
 typedef struct mlog_sym mlog_sym_t;
@@ -146,13 +146,13 @@ mlog_init0( void )
 }
 
 bool_t
-mlog_init1( intgen_t argc, char *argv[ ] )
+mlog_init1( int argc, char *argv[ ] )
 {
 	char **suboptstrs;
 	ix_t ssix;
 	ix_t soix;
 	size_t vsymcnt;
-	intgen_t c;
+	int c;
 
 	/* prepare an array of suboption token strings. this will be the
 	 * concatenation of the subsystem names with the verbosity symbols.
@@ -200,7 +200,7 @@ mlog_init1( intgen_t argc, char *argv[ ] )
 			}
 			options = optarg;
 			while ( *options ) {
-				intgen_t suboptix;
+				int suboptix;
 				char *valstr;
 
 				suboptix = getsubopt( &options, 
@@ -343,9 +343,9 @@ mlog_unlock( void )
  * too much output.
  */
 void
-mlog_override_level( intgen_t levelarg )
+mlog_override_level( int levelarg )
 {
-	intgen_t level;
+	int level;
 	ix_t ss; /* SubSystem */
 
 	level = levelarg & MLOG_LEVELMASK;
@@ -362,7 +362,7 @@ mlog_override_level( intgen_t levelarg )
 }
 
 void
-mlog( intgen_t levelarg, char *fmt, ... )
+mlog( int levelarg, char *fmt, ... )
 {
 	va_list args;
 	va_start( args, fmt );
@@ -371,9 +371,9 @@ mlog( intgen_t levelarg, char *fmt, ... )
 }
 
 void
-mlog_va( intgen_t levelarg, char *fmt, va_list args )
+mlog_va( int levelarg, char *fmt, va_list args )
 {
-	intgen_t level;
+	int level;
 	ix_t ss;
 
 	level = levelarg & MLOG_LEVELMASK;
@@ -389,7 +389,7 @@ mlog_va( intgen_t levelarg, char *fmt, va_list args )
 	}
 
 	if ( ! ( levelarg & MLOG_BARE )) {
-		intgen_t streamix;
+		int streamix;
 		streamix = stream_getix( pthread_self( ) );
 
 		if ( mlog_showss ) {
@@ -419,7 +419,7 @@ mlog_va( intgen_t levelarg, char *fmt, va_list args )
 				mlog_levelstr[ 1 ] = ( char )
 						     ( level
 						       +
-						       ( intgen_t )'0' );
+						       ( int )'0' );
 			}
 		} else {
 			mlog_levelstr[ 0 ] = 0;
@@ -609,7 +609,7 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 	else {
 		stream_state_t states[] = { S_RUNNING };
 		stream_state_t state;
-		intgen_t streamix;
+		int streamix;
 		int exit_code;
 		rv_t exit_return, exit_hint;
 
@@ -726,7 +726,7 @@ mlog_exit_flush(void)
 
 		for (i = 0; i < ntids; i++) {
 			stream_state_t state;
-			intgen_t streamix;
+			int streamix;
 			int exit_code;
 			rv_t exit_return, exit_hint;
 			/* REFERENCED */
@@ -786,7 +786,7 @@ mlog_exit_flush(void)
 	fflush(mlog_fp);
 }
 
-static intgen_t
+static int
 mlog_sym_lookup( char *sym )
 {
 	mlog_sym_t *p = mlog_sym;
diff --git a/common/mlog.h b/common/mlog.h
index ce143bd..d7bbfce 100644
--- a/common/mlog.h
+++ b/common/mlog.h
@@ -80,13 +80,13 @@
 /* mlog_level - set during initialization, exported to facilitate
  * message logging decisions. one per subsystem (see above)
  */
-extern intgen_t mlog_level_ss[ MLOG_SS_CNT ];
+extern int mlog_level_ss[ MLOG_SS_CNT ];
 
 /* made external so main.c sigint dialog can change
  */
-extern intgen_t mlog_showlevel;
-extern intgen_t mlog_showss;
-extern intgen_t mlog_timestamp;
+extern int mlog_showlevel;
+extern int mlog_showss;
+extern int mlog_timestamp;
 
 /* mlog_ss_name - so main.c sigint dialog can allow changes
  */
@@ -96,7 +96,7 @@ extern char *mlog_ss_names[ MLOG_SS_CNT ];
  * unravel some initialization sequencing problems.
  */
 extern void mlog_init0( void );
-extern bool_t mlog_init1( intgen_t argc, char *argv[ ] );
+extern bool_t mlog_init1( int argc, char *argv[ ] );
 extern bool_t mlog_init2( void );
 
 /* post-initialization, to tell mlog how many streams
@@ -105,12 +105,12 @@ extern void mlog_tell_streamcnt( size_t streamcnt );
 
 /* override the -v option
  */
-void mlog_override_level( intgen_t levelarg );
+void mlog_override_level( int levelarg );
 
 /* vprintf-based message format
  */
-extern void mlog( intgen_t level, char *fmt, ... );
-extern void mlog_va( intgen_t levelarg, char *fmt, va_list args );
+extern void mlog( int level, char *fmt, ... );
+extern void mlog_va( int levelarg, char *fmt, va_list args );
 #define mlog_exit( e, r ) _mlog_exit( __FILE__, __LINE__, (e), (r) )
 extern int  _mlog_exit( const char *file, int line, int exit_code, rv_t return_code );
 #define mlog_exit_hint( r ) _mlog_exit_hint( __FILE__, __LINE__, (r) )
diff --git a/common/openutil.c b/common/openutil.c
index 9df42ae..6cc0efa 100644
--- a/common/openutil.c
+++ b/common/openutil.c
@@ -73,10 +73,10 @@ open_pathalloc( char *dirname, char *basename, pid_t pid )
   	return namebuf;
 }
 
-intgen_t
+int
 open_trwp( char *pathname )
 {
-	intgen_t fd;
+	int fd;
 
 	fd = open( pathname, O_CREAT | O_TRUNC | O_RDWR, S_IRUSR | S_IWUSR );
 	if ( fd < 0 ) {
@@ -89,10 +89,10 @@ open_trwp( char *pathname )
 	return fd;
 }
 
-intgen_t
+int
 open_erwp( char *pathname )
 {
-	intgen_t fd;
+	int fd;
 
 	fd = open( pathname, O_EXCL | O_CREAT | O_RDWR, S_IRUSR | S_IWUSR );
 	if ( fd < 0 ) {
@@ -105,31 +105,31 @@ open_erwp( char *pathname )
 	return fd;
 }
 
-intgen_t
+int
 open_rwp( char *pathname )
 {
-	intgen_t fd;
+	int fd;
 
 	fd = open( pathname, O_RDWR );
 
 	return fd;
 }
 
-intgen_t
+int
 mkdir_tp( char *pathname )
 {
-	intgen_t rval;
+	int rval;
 
 	rval = mkdir( pathname, S_IRWXU );
 
 	return rval;
 }
 
-intgen_t
+int
 open_trwdb( char *dirname, char *basename, pid_t pid )
 {
 	char *pathname;
-	intgen_t fd;
+	int fd;
 
 	pathname = open_pathalloc( dirname, basename, pid );
 	fd = open_trwp( pathname );
@@ -138,11 +138,11 @@ open_trwdb( char *dirname, char *basename, pid_t pid )
 	return fd;
 }
 
-intgen_t
+int
 open_erwdb( char *dirname, char *basename, pid_t pid )
 {
 	char *pathname;
-	intgen_t fd;
+	int fd;
 
 	pathname = open_pathalloc( dirname, basename, pid );
 	fd = open_erwp( pathname );
@@ -151,11 +151,11 @@ open_erwdb( char *dirname, char *basename, pid_t pid )
 	return fd;
 }
 
-intgen_t
+int
 open_rwdb( char *dirname, char *basename, pid_t pid )
 {
 	char *pathname;
-	intgen_t fd;
+	int fd;
 
 	pathname = open_pathalloc( dirname, basename, pid );
 	fd = open_rwp( pathname );
diff --git a/common/openutil.h b/common/openutil.h
index c00233d..587462c 100644
--- a/common/openutil.h
+++ b/common/openutil.h
@@ -35,28 +35,28 @@ extern char *open_pathalloc( char *dirname, char *basename, pid_t pid );
  * return the file descriptor, or -1 with errno set. uses mlog( MLOG_NORMAL...
  * if the creation fails.
  */
-extern intgen_t open_trwdb( char *dirname, char *basename, pid_t pid );
-extern intgen_t open_trwp( char *pathname );
+extern int open_trwdb( char *dirname, char *basename, pid_t pid );
+extern int open_trwp( char *pathname );
 
 
 /* open the specified file, with read and write permissions, given a
  * directory and base.* return the file descriptor, or -1 with errno set.
  * uses mlog( MLOG_NORMAL... if the open fails.
  */
-extern intgen_t open_rwdb( char *dirname, char *basename, pid_t pid );
-extern intgen_t open_rwp( char *pathname );
+extern int open_rwdb( char *dirname, char *basename, pid_t pid );
+extern int open_rwp( char *pathname );
 
 
 /* create and open the specified file, failing if already exists
  */
-extern intgen_t open_erwp( char *pathname );
-extern intgen_t open_erwdb( char *dirname, char *basename, pid_t pid );
+extern int open_erwp( char *pathname );
+extern int open_erwdb( char *dirname, char *basename, pid_t pid );
 
 
 /* create the specified directory, guaranteed to be initially empty. returns
  * 0 on success, -1 if trouble. uses mlog( MLOG_NORMAL... if the creation fails.
  */
-extern intgen_t mkdir_tp( char *pathname );
+extern int mkdir_tp( char *pathname );
 
 
 #endif /* UTIL_H */
diff --git a/common/qlock.c b/common/qlock.c
index 1b466d6..0583a63 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -106,7 +106,7 @@ qlock_lock( qlockh_t qlockh )
 	qlock_t *qlockp = ( qlock_t * )qlockh;
 	pthread_t tid;
 	/* REFERENCED */
-	intgen_t rval;
+	int rval;
 	
 	/* get the caller's tid
 	 */
@@ -149,7 +149,7 @@ qlock_unlock( qlockh_t qlockh )
 {
 	qlock_t *qlockp = ( qlock_t * )qlockh;
 	/* REFERENCED */
-	intgen_t rval;
+	int rval;
 	
 	/* verify lock is held by this thread
 	 */
@@ -169,7 +169,7 @@ qsemh_t
 qsem_alloc( ix_t cnt )
 {
 	sem_t *semp;
-	intgen_t rval;
+	int rval;
 
 	/* allocate a semaphore
 	 */
@@ -188,7 +188,7 @@ void
 qsem_free( qsemh_t qsemh )
 {
 	sem_t *semp = ( sem_t * )qsemh;
-	intgen_t rval;
+	int rval;
 
 	/* destroy the mutex and condition
 	 */
@@ -204,7 +204,7 @@ void
 qsemP( qsemh_t qsemh )
 {
 	sem_t *semp = ( sem_t * )qsemh;
-	intgen_t rval;
+	int rval;
 	
 	/* "P" the semaphore
 	 */
@@ -216,7 +216,7 @@ void
 qsemV( qsemh_t qsemh )
 {
 	sem_t *semp = ( sem_t * )qsemh;
-	intgen_t rval;
+	int rval;
 	
 	/* "V" the semaphore
 	 */
@@ -229,7 +229,7 @@ qsemPwouldblock( qsemh_t qsemh )
 {
 	sem_t *semp = ( sem_t * )qsemh;
 	int count;
-	intgen_t rval;
+	int rval;
 
 	rval = sem_getvalue( semp, &count );
 	assert( !rval );
@@ -242,7 +242,7 @@ qsemPavail( qsemh_t qsemh )
 {
 	sem_t *semp = ( sem_t * )qsemh;
 	int count;
-	intgen_t rval;
+	int rval;
 
 	rval = sem_getvalue( semp, &count );
 	assert( !rval );
diff --git a/common/ring.c b/common/ring.c
index 37a2d1d..bb90901 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -46,7 +46,7 @@ ring_create( size_t ringlen,
 	     int ( *readfunc )( void *clientctxp, char *bufp ),
 	     int ( *writefunc )( void *clientctxp, char *bufp ),
 	     void *clientctxp,
-	     intgen_t *rvalp )
+	     int *rvalp )
 {
 	bool_t ok;
 	ring_t *ringp;
@@ -107,7 +107,7 @@ ring_create( size_t ringlen,
 			return 0;
 		}
 		if ( pinpr ) {
-			intgen_t rval;
+			int rval;
 			rval = mlock( ( void * )msgp->rm_bufp, bufsz );
 			if ( rval ) {
 				if ( errno == ENOMEM ) {
diff --git a/common/ring.h b/common/ring.h
index caa505c..4a1cc54 100644
--- a/common/ring.h
+++ b/common/ring.h
@@ -113,7 +113,7 @@ typedef enum ring_loc ring_loc_t;
 struct ring_msg {
 	ring_op_t rm_op;
 	ring_stat_t rm_stat;
-	intgen_t rm_rval;
+	int rm_rval;
 	off64_t rm_user;
 	char *rm_bufp;
 /* ALL BELOW PRIVATE!!! */
@@ -171,7 +171,7 @@ extern ring_t *ring_create( size_t ringlen,
 			    int ( * readfunc )( void *clientctxp, char *bufp ),
 			    int ( * writefunc )( void *clientctxp, char *bufp ),
 			    void *clientctxp,
-			    intgen_t *rvalp );
+			    int *rvalp );
 
 
 /* ring_get - get a message off the ready queue
diff --git a/common/stream.c b/common/stream.c
index 90d315a..549bf59 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -36,7 +36,7 @@
 struct spm {
 	stream_state_t	s_state;
 	pthread_t	s_tid;
-	intgen_t	s_ix;
+	int	s_ix;
 	int		s_exit_code;
 	rv_t		s_exit_return;
 	rv_t		s_exit_hint;
@@ -64,7 +64,7 @@ stream_init( void )
  */
 
 void
-stream_register( pthread_t tid, intgen_t streamix )
+stream_register( pthread_t tid, int streamix )
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
@@ -187,12 +187,12 @@ stream_find( pthread_t tid, stream_state_t s[], int nstates )
  * another lock. So no locking is done in this function.
  */
 
-intgen_t
+int
 stream_getix( pthread_t tid )
 {
 	stream_state_t states[] = { S_RUNNING };
 	spm_t *p;
-	intgen_t ix;
+	int ix;
 	p = stream_find( tid, states, N(states) );
 	ix = p ? p->s_ix : -1;
 	return ix;
@@ -246,7 +246,7 @@ stream_get_exit_status( pthread_t tid,
 			stream_state_t states[],
 			int nstates,
 			stream_state_t *state,
-			intgen_t *ix,
+			int *ix,
 			int *exit_code,
 			rv_t *exit_return,
 			rv_t *exit_hint)
diff --git a/common/stream.h b/common/stream.h
index 4b3799f..a83a5a5 100644
--- a/common/stream.h
+++ b/common/stream.h
@@ -42,7 +42,7 @@
 typedef enum { S_FREE, S_RUNNING, S_ZOMBIE } stream_state_t;
 
 extern void stream_init( void );
-extern void stream_register( pthread_t tid, intgen_t streamix );
+extern void stream_register( pthread_t tid, int streamix );
 /* NOTE: lock() must be held when calling stream_dead */
 extern void stream_dead( pthread_t tid );
 extern void stream_free( pthread_t tid );
@@ -50,7 +50,7 @@ extern int stream_find_all( stream_state_t states[],
 			    int nstates,
 			    pthread_t tids[],
 			    int ntids );
-extern intgen_t stream_getix( pthread_t tid );
+extern int stream_getix( pthread_t tid );
 extern void stream_set_code( pthread_t tid, int code );
 extern void stream_set_return( pthread_t tid, rv_t rv );
 extern void stream_set_hint( pthread_t tid, rv_t rv );
@@ -59,7 +59,7 @@ extern bool_t stream_get_exit_status( pthread_t tid,
 				      stream_state_t states[],
 				      int nstates,
 				      stream_state_t *state,
-				      intgen_t *ix,
+				      int *ix,
 				      int *exit_code,
 				      rv_t *exit_return,
 				      rv_t *exit_hint);
diff --git a/common/types.h b/common/types.h
index 9d3606a..9afb3a7 100644
--- a/common/types.h
+++ b/common/types.h
@@ -38,7 +38,7 @@ typedef u_int32_t size32_t;
 typedef u_int64_t size64_t;
 typedef char char_t;
 typedef unsigned char u_char_t;
-typedef unsigned int u_intgen_t;
+typedef unsigned int u_int;
 typedef long long_t;
 typedef unsigned long u_long_t;
 typedef size_t ix_t;
@@ -70,8 +70,8 @@ typedef int32_t time32_t;
 #define SIZE64MAX	MKUMAX( size64_t )
 #define INO64MAX	MKUMAX( xfs_ino_t )
 #define OFF64MAX	MKSMAX( off64_t )
-#define INTGENMAX	MKSMAX( intgen_t )
-#define UINTGENMAX	MKUMAX( u_intgen_t )
+#define INTGENMAX	MKSMAX( int )
+#define UINTGENMAX	MKUMAX( u_int )
 #define OFFMAX		MKSMAX( off_t )
 #define SIZEMAX		MKUMAX( size_t )
 #define IXMAX		MKUMAX( size_t )
diff --git a/common/util.c b/common/util.c
index af48162..93dd9c8 100644
--- a/common/util.c
+++ b/common/util.c
@@ -39,7 +39,7 @@
 
 extern size_t pgsz;
 
-intgen_t
+int
 write_buf( char *bufp,
 	   size_t bufsz,
 	   void *contextp,
@@ -73,17 +73,17 @@ write_buf( char *bufp,
 	return 0;
 }
 
-intgen_t
+int
 read_buf( char *bufp,
 	  size_t bufsz, 
 	  void *contextp,
 	  rfp_t read_funcp,
 	  rrbfp_t return_read_buf_funcp,
-	  intgen_t *statp )
+	  int *statp )
 {
 	char *mbufp;		/* manager's buffer pointer */
 	size_t mbufsz;	/* size of manager's buffer */
-	intgen_t nread;
+	int nread;
 
 	nread = 0;
 	*statp = 0;
@@ -98,7 +98,7 @@ read_buf( char *bufp,
 			bufp += mbufsz;
 		}
 		bufsz -= mbufsz;
-		nread += ( intgen_t )mbufsz;
+		nread += ( int )mbufsz;
 		( * return_read_buf_funcp )( contextp, mbufp, mbufsz );
 	}
 
@@ -116,24 +116,24 @@ char
 	return rval;
 }
 
-intgen_t
+int
 bigstat_iter( jdm_fshandle_t *fshandlep,
-	      intgen_t fsfd,
-	      intgen_t selector,
+	      int fsfd,
+	      int selector,
 	      xfs_ino_t start_ino,
 	      bstat_cbfp_t fp,
 	      void * cb_arg1,
 	      bstat_seekfp_t seekfp,
 	      void * seek_arg1,
-	      intgen_t *statp,
+	      int *statp,
 	      bool_t ( pfp )( int ),
 	      xfs_bstat_t *buf,
 	      size_t buflenin )
 {
 	__s32 buflenout;
 	xfs_ino_t lastino;
-	intgen_t saved_errno;
-	intgen_t bulkstatcnt;
+	int saved_errno;
+	int bulkstatcnt;
         xfs_fsop_bulkreq_t bulkreq;
 
 	/* stat set with return from callback func
@@ -178,7 +178,7 @@ bigstat_iter( jdm_fshandle_t *fshandlep,
 		      buflenout,
 		      buf->bs_ino );
 		for ( p = buf, endp = buf + buflenout ; p < endp ; p++ ) {
-			intgen_t rval;
+			int rval;
 
 			if ( p->bs_ino == 0 )
 				continue;
@@ -253,13 +253,13 @@ bigstat_iter( jdm_fshandle_t *fshandlep,
 }
 
 /* ARGSUSED */
-intgen_t
-bigstat_one( intgen_t fsfd,
+int
+bigstat_one( int fsfd,
 	     xfs_ino_t ino,
 	     xfs_bstat_t *statp )
 {
         xfs_fsop_bulkreq_t bulkreq;
-	intgen_t count = 0;
+	int count = 0;
 
 	assert( ino > 0 );
         bulkreq.lastip = (__u64 *)&ino;
@@ -272,16 +272,16 @@ bigstat_one( intgen_t fsfd,
 /* call the given callback for each inode group in the filesystem.
  */
 #define INOGRPLEN	256
-intgen_t
-inogrp_iter( intgen_t fsfd,
-	     intgen_t ( * fp )( void *arg1,
-				intgen_t fsfd,
+int
+inogrp_iter( int fsfd,
+	     int ( * fp )( void *arg1,
+				int fsfd,
 				xfs_inogrp_t *inogrp ),
 	     void * arg1,
-	     intgen_t *statp )
+	     int *statp )
 {
 	xfs_ino_t lastino;
-	intgen_t inogrpcnt;
+	int inogrpcnt;
 	xfs_inogrp_t *igrp;
         xfs_fsop_bulkreq_t bulkreq;
 
@@ -311,7 +311,7 @@ inogrp_iter( intgen_t fsfd,
 			return 0;
 		}
 		for ( p = igrp, endp = igrp + inogrpcnt ; p < endp ; p++ ) {
-			intgen_t rval;
+			int rval;
 
 			rval = ( * fp )( arg1, fsfd, p );
 			if ( rval ) {
@@ -338,26 +338,26 @@ inogrp_iter( intgen_t fsfd,
  *
  * caller may supply a dirent buffer. if not, will malloc one
  */
-intgen_t
+int
 diriter( jdm_fshandle_t *fshandlep,
-	 intgen_t fsfd,
+	 int fsfd,
 	 xfs_bstat_t *statp,
-	 intgen_t ( *cbfp )( void *arg1,
+	 int ( *cbfp )( void *arg1,
 			     jdm_fshandle_t *fshandlep,
-			     intgen_t fsfd,
+			     int fsfd,
 			     xfs_bstat_t *statp,
 			     char *namep ),
 	 void *arg1,
-	 intgen_t *cbrvalp,
+	 int *cbrvalp,
 	 char *usrgdp,
 	 size_t usrgdsz )
 {
 	size_t gdsz;
 	struct dirent *gdp;
-	intgen_t fd;
-	intgen_t gdcnt;
-	intgen_t scrval;
-	intgen_t cbrval;
+	int fd;
+	int gdcnt;
+	int scrval;
+	int cbrval;
 
 	if ( usrgdp ) {
 		assert( usrgdsz >= sizeof( struct dirent ) );
@@ -392,7 +392,7 @@ diriter( jdm_fshandle_t *fshandlep,
 	cbrval = 0;
 	for ( gdcnt = 1 ; ; gdcnt++ ) {
 		struct dirent *p;
-		intgen_t nread;
+		int nread;
 		register size_t reclen;
 
 		assert( scrval == 0 );
@@ -426,7 +426,7 @@ diriter( jdm_fshandle_t *fshandlep,
 		      ;
 		      nread > 0
 		      ;
-		      nread -= ( intgen_t )reclen,
+		      nread -= ( int )reclen,
 		      assert( nread >= 0 ),
 		      p = ( struct dirent * )( ( char * )p + reclen ),
 		      reclen = ( size_t )p->d_reclen ) {
diff --git a/common/util.h b/common/util.h
index 8ac1831..5284811 100644
--- a/common/util.h
+++ b/common/util.h
@@ -33,9 +33,9 @@
  * if bufp is null, writes bufsz zeros.
  */
 typedef char * ( * gwbfp_t )( void *contextp, size_t wantedsz, size_t *szp);
-typedef intgen_t ( * wfp_t )( void *contextp, char *bufp, size_t bufsz );
+typedef int ( * wfp_t )( void *contextp, char *bufp, size_t bufsz );
 
-extern intgen_t write_buf( char *bufp,
+extern int write_buf( char *bufp,
 			   size_t bufsz,
 			   void *contextp,
 			   gwbfp_t get_write_buf_funcp,
@@ -56,15 +56,15 @@ extern intgen_t write_buf( char *bufp,
  * status of the first failure of the read funcp. if no read failures occur,
  * *statp will be zero.
  */
-typedef char * ( *rfp_t )( void *contextp, size_t wantedsz, size_t *szp, intgen_t *statp );
+typedef char * ( *rfp_t )( void *contextp, size_t wantedsz, size_t *szp, int *statp );
 typedef void ( * rrbfp_t )( void *contextp, char *bufp, size_t bufsz );
 
-extern intgen_t read_buf( char *bufp,
+extern int read_buf( char *bufp,
 			  size_t bufsz, 
 			  void *contextp,
 			  rfp_t read_funcp,
 			  rrbfp_t return_read_buf_funcp,
-			  intgen_t *statp );
+			  int *statp );
 
 
 
@@ -84,37 +84,37 @@ extern char *strncpyterm( char *s1, char *s2, size_t n );
 #define BIGSTAT_ITER_NONDIR	( 1 << 1 )
 #define BIGSTAT_ITER_ALL	( ~0 )
 
-typedef intgen_t (*bstat_cbfp_t)(void *arg1,
+typedef int (*bstat_cbfp_t)(void *arg1,
 				 jdm_fshandle_t *fshandlep,
-				 intgen_t fsfd,
+				 int fsfd,
 				 xfs_bstat_t *statp );
 
 typedef xfs_ino_t (*bstat_seekfp_t)(void *arg1,
 				    xfs_ino_t lastino);
 
-extern intgen_t bigstat_iter( jdm_fshandle_t *fshandlep,
-			      intgen_t fsfd,
-			      intgen_t selector,
+extern int bigstat_iter( jdm_fshandle_t *fshandlep,
+			      int fsfd,
+			      int selector,
 			      xfs_ino_t start_ino,
 			      bstat_cbfp_t fp,
 			      void * cb_arg1,
 			      bstat_seekfp_t seekfp,
 			      void * seek_arg1,
-			      intgen_t *statp,
+			      int *statp,
 			      bool_t ( pfp )( int ), /* preemption chk func */
 			      xfs_bstat_t *buf,
 			      size_t buflen );
 
-extern intgen_t bigstat_one( intgen_t fsfd,
+extern int bigstat_one( int fsfd,
 			     xfs_ino_t ino,
 			     xfs_bstat_t *statp );
 
-extern intgen_t inogrp_iter( intgen_t fsfd,
-			     intgen_t ( * fp )( void *arg1,
-				     		intgen_t fsfd,
+extern int inogrp_iter( int fsfd,
+			     int ( * fp )( void *arg1,
+				     		int fsfd,
 						xfs_inogrp_t *inogrp ),
 			     void * arg1,
-			     intgen_t *statp );
+			     int *statp );
 
 /* calls the callback for every entry in the directory specified
  * by the stat buffer. supplies the callback with a file system
@@ -129,16 +129,16 @@ extern intgen_t inogrp_iter( intgen_t fsfd,
  * callback's return value. if syscall fails, returns -1 with errno set.
  * otherwise returns 0.
  */
-extern intgen_t diriter( jdm_fshandle_t *fshandlep,
-			 intgen_t fsfd,
+extern int diriter( jdm_fshandle_t *fshandlep,
+			 int fsfd,
 			 xfs_bstat_t *statp,
-			 intgen_t ( *cbfp )( void *arg1,
+			 int ( *cbfp )( void *arg1,
 					     jdm_fshandle_t *fshandlep,
-					     intgen_t fsfd,
+					     int fsfd,
 					     xfs_bstat_t *statp,
 					     char *namep ),
 			 void *arg1,
-			 intgen_t *cbrvalp,
+			 int *cbrvalp,
 			 char *usrgdp,
 			 size_t usrgdsz );
 
diff --git a/dump/content.c b/dump/content.c
index 5d630bb..00a7bad 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -199,9 +199,9 @@ struct extent_group_context {
 	getbmapx_t eg_bmap[ BMAP_LEN ];
 	getbmapx_t *eg_nextbmapp;	/* ptr to the next extent to dump */
 	getbmapx_t *eg_endbmapp;		/* to detect extent exhaustion */
-	intgen_t eg_fd;			/* file desc. */
-	intgen_t eg_bmapix;		/* debug info only, not used */
-	intgen_t eg_gbmcnt;		/* debug, counts getbmapx calls for ino*/
+	int eg_fd;			/* file desc. */
+	int eg_bmapix;		/* debug info only, not used */
+	int eg_gbmcnt;		/* debug, counts getbmapx calls for ino*/
 };
 
 typedef struct extent_group_context extent_group_context_t;
@@ -266,11 +266,11 @@ static rv_t dump_dirs( ix_t strmix,
 		       void *inomap_contextp );
 static rv_t dump_dir( ix_t strmix,
 		      jdm_fshandle_t *,
-		      intgen_t,
+		      int,
 		      xfs_bstat_t * );
 static rv_t dump_file( void *,
 		       jdm_fshandle_t *,
-		       intgen_t,
+		       int,
 		       xfs_bstat_t * );
 static rv_t dump_file_reg( drive_t *drivep,
 			   context_t *contextp,
@@ -286,7 +286,7 @@ static rv_t dump_filehdr( drive_t *drivep,
 			  context_t *contextp,
 			  xfs_bstat_t *,
 			  off64_t,
-			  intgen_t );
+			  int );
 static rv_t dump_extenthdr( drive_t *drivep,
 			    context_t *contextp,
 			    int32_t,
@@ -336,7 +336,7 @@ static rv_t Media_mfile_end( drive_t *drivep,
 			     bool_t hit_eom );
 static bool_t Media_prompt_overwrite( drive_t *drivep );
 static rv_t Media_erasechk( drive_t *drivep,
-			    intgen_t dcaps,
+			    int dcaps,
 			    bool_t intr_allowed,
 			    bool_t prevmediapresentpr );
 static bool_t Media_prompt_erase( drive_t *drivep );
@@ -511,7 +511,7 @@ static bool_t create_inv_session(
 		size_t strmix);
 
 bool_t
-content_init( intgen_t argc,
+content_init( int argc,
 	      char *argv[ ],
 	      global_hdr_t *gwhdrtemplatep )
 {
@@ -544,10 +544,10 @@ content_init( intgen_t argc,
 	bool_t samepartialpr = BOOL_FALSE;
 	bool_t sameinterruptedpr = BOOL_FALSE;
 	size_t strmix;
-	intgen_t c;
-	intgen_t i;
-	intgen_t qstat;
-	intgen_t rval;
+	int c;
+	int i;
+	int qstat;
+	int rval;
 	bool_t ok;
 	extern char *optarg;
 	extern int optind, opterr, optopt;
@@ -1905,7 +1905,7 @@ create_inv_session(
 		ix_t subtreecnt,
 		size_t strmix)
 {
-	intgen_t rval;
+	int rval;
 	char *qmntpnt;
 	char *qfsdevice;
 
@@ -2086,7 +2086,7 @@ mark_callback( void *p, drive_markrec_t *dmp, bool_t committed )
 
 /* begin - called by stream process to invoke the dump stream
  */
-intgen_t
+int
 content_stream_dump( ix_t strmix )
 {
 	context_t *contextp = &sc_contextp[ strmix ];
@@ -2103,7 +2103,7 @@ content_stream_dump( ix_t strmix )
 	inv_stmtoken_t inv_stmt;
 	xfs_bstat_t *bstatbufp;
 	const size_t bstatbuflen = BSTATBUFLEN;
-	intgen_t rval;
+	int rval;
 	rv_t rv;
 
 	/* sanity checks
@@ -2368,7 +2368,7 @@ content_stream_dump( ix_t strmix )
 					     ( void * )strmix,
 					     inomap_next_nondir,
 					     inomap_contextp,
-					     ( intgen_t * )&rv,
+					     ( int * )&rv,
 					     pipeline ?
 					       (bool_t (*)(int))preemptchk : 0,
 					     bstatbufp,
@@ -2563,7 +2563,7 @@ decision_more:
 			ok = inv_put_mediafile( inv_stmt,
 						&mwhdrp->mh_mediaid,
 						mwhdrp->mh_medialabel,
-					( u_intgen_t )mwhdrp->mh_mediafileix,
+					( u_int )mwhdrp->mh_mediafileix,
 						startino,
 						startoffset,
 						scwhdrp->cih_startpt.sp_ino,
@@ -2652,7 +2652,7 @@ content_complete( void )
 {
 	time_t elapsed;
 	bool_t completepr;
-	intgen_t i;
+	int i;
 
 	completepr = check_complete_flags( );
 
@@ -2769,7 +2769,7 @@ content_mediachange_query( void )
 static void
 update_cc_Media_useterminatorpr( drive_t *drivep, context_t *contextp )
 {
-	intgen_t dcaps = drivep->d_capabilities;
+	int dcaps = drivep->d_capabilities;
 
 	contextp->cc_Media_useterminatorpr = BOOL_TRUE;
 	if ( ! ( dcaps & DRIVE_CAP_FILES )) {
@@ -2805,7 +2805,7 @@ dump_dirs( ix_t strmix,
 		xfs_bstat_t *p;
 		xfs_bstat_t *endp;
 		__s32 buflenout;
-		intgen_t rval;
+		int rval;
 
 		if ( bulkstatcallcnt == 0 ) {
 			mlog( MLOG_VERBOSE, _(
@@ -2909,17 +2909,17 @@ dump_dirs( ix_t strmix,
 static rv_t
 dump_dir( ix_t strmix,
 	  jdm_fshandle_t *fshandlep,
-	  intgen_t fsfd,
+	  int fsfd,
 	  xfs_bstat_t *statp )
 {
 	context_t *contextp = &sc_contextp[ strmix ];
 	drive_t *drivep = drivepp[ strmix ];
 	void *inomap_contextp = contextp->cc_inomap_contextp;
-	intgen_t state;
-	intgen_t fd;
+	int state;
+	int fd;
 	struct dirent *gdp = ( struct dirent *)contextp->cc_getdentsbufp;
 	size_t gdsz = contextp->cc_getdentsbufsz;
-	intgen_t gdcnt;
+	int gdcnt;
 	gen_t gen;
 	rv_t rv;
 
@@ -3008,7 +3008,7 @@ dump_dir( ix_t strmix,
 	 */
 	for ( gdcnt = 1, rv = RV_OK ; rv == RV_OK ; gdcnt++ ) {
 		struct dirent *p;
-		intgen_t nread;
+		int nread;
 		register size_t reclen;
 
 		nread = getdents_wrap( fd, (char *)gdp, gdsz );
@@ -3046,7 +3046,7 @@ dump_dir( ix_t strmix,
 		      ;
 		      nread > 0
 		      ;
-		      nread -= ( intgen_t )reclen,
+		      nread -= ( int )reclen,
 		      assert( nread >= 0 ),
 		      p = ( struct dirent * )( ( char * )p + reclen ),
 		      reclen = ( size_t )p->d_reclen ) {
@@ -3093,7 +3093,7 @@ dump_dir( ix_t strmix,
 			 */
 			if ( inomap_get_gen( NULL, p->d_ino, &gen) ) {
 				xfs_bstat_t statbuf;
-				intgen_t scrval;
+				int scrval;
 				
 				scrval = bigstat_one( fsfd,
 						      p->d_ino,
@@ -3261,7 +3261,7 @@ dump_extattr_list( drive_t *drivep,
 	char *dumpbufp;
 	char *endp;
 	size_t bufsz;
-	intgen_t rval = 0;
+	int rval = 0;
 	rv_t rv;
 	char *dumpbufendp = contextp->cc_extattrdumpbufp
 			    +
@@ -3645,7 +3645,7 @@ dump_extattrhdr( drive_t *drivep,
 {
 	extattrhdr_t ahdr;
 	extattrhdr_t tmpahdr;
-	intgen_t rval;
+	int rval;
 	rv_t rv;
 
 	memset( ( void * )&ahdr, 0, sizeof( ahdr ));
@@ -3693,7 +3693,7 @@ dump_extattrhdr( drive_t *drivep,
 static rv_t
 dump_file( void *arg1,
 	   jdm_fshandle_t *fshandlep,
-	   intgen_t fsfd,
+	   int fsfd,
 	   xfs_bstat_t *statp )
 {
 	ix_t strmix = ( ix_t )arg1;
@@ -3708,7 +3708,7 @@ dump_file( void *arg1,
 	startpt_t *startptp = &scwhdrp->cih_startpt;
 	startpt_t *endptp = &scwhdrp->cih_endpt;
 	bool_t file_skipped = BOOL_FALSE;
-	intgen_t state;
+	int state;
 	rv_t rv;
 
 	/* skip if no links
@@ -4147,7 +4147,7 @@ dump_file_spec( drive_t *drivep,
 		jdm_fshandle_t *fshandlep,
 		xfs_bstat_t *statp )
 {
-	intgen_t rval;
+	int rval;
 	rv_t rv;
 
 	mlog( MLOG_TRACE,
@@ -4178,7 +4178,7 @@ dump_file_spec( drive_t *drivep,
 	 * the symlink pathname char string will always  be NULL-terminated.
 	 */
 	if ( ( statp->bs_mode & S_IFMT ) == S_IFLNK ) {
-		intgen_t nread;
+		int nread;
 		size_t extentsz;
 
 		/* read the link path. if error, dump a zero-length
@@ -4263,7 +4263,7 @@ init_extent_group_context( jdm_fshandle_t *fshandlep,
 			   extent_group_context_t *gcp )
 {
 	bool_t isrealtime;
-	intgen_t oflags;
+	int oflags;
 	struct flock fl;
 
 	isrealtime = ( bool_t )(statp->bs_xflags & XFS_XFLAG_REALTIME );
@@ -4338,7 +4338,7 @@ dump_extent_group( drive_t *drivep,
 					XFS_XFLAG_REALTIME );
 	off64_t nextoffset;
 	off64_t bytecnt;	/* accumulates total bytes sent to media */
-	intgen_t rval;
+	int rval;
 	rv_t rv;
 
 	/*
@@ -4402,7 +4402,7 @@ dump_extent_group( drive_t *drivep,
 		 * get one.
 		 */
 		if ( gcp->eg_nextbmapp >= gcp->eg_endbmapp ) {
-			intgen_t entrycnt; /* entries in new bmap */
+			int entrycnt; /* entries in new bmap */
 
 			assert( gcp->eg_nextbmapp == gcp->eg_endbmapp );
 
@@ -4779,7 +4779,7 @@ dump_extent_group( drive_t *drivep,
 		 */
 		while ( extsz ) {
 			off64_t new_off;
-			intgen_t nread;
+			int nread;
 			size_t reqsz;
 			size_t actualsz;
 			char *bufp;
@@ -4947,12 +4947,12 @@ dump_filehdr( drive_t *drivep,
 	      context_t *contextp,
 	      xfs_bstat_t *statp,
 	      off64_t offset,
-	      intgen_t flags )
+	      int flags )
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	register filehdr_t *fhdrp = contextp->cc_filehdrp;
 	filehdr_t tmpfhdrp;
-	intgen_t rval;
+	int rval;
 	rv_t rv;
 
 	( void )memset( ( void * )fhdrp, 0, sizeof( *fhdrp ));
@@ -5004,7 +5004,7 @@ dump_extenthdr( drive_t *drivep,
 	drive_ops_t *dop = drivep->d_opsp;
 	register extenthdr_t *ehdrp = contextp->cc_extenthdrp;
 	extenthdr_t tmpehdrp;
-	intgen_t rval;
+	int rval;
 	rv_t rv;
 	char typestr[20];
 
@@ -5079,7 +5079,7 @@ dump_dirent( drive_t *drivep,
 	size_t direntbufsz = contextp->cc_mdirentbufsz;
 	size_t sz;
 	size_t name_offset;
-	intgen_t rval;
+	int rval;
 	rv_t rv;
 
 	if ( sc_use_old_direntpr ) {
@@ -5226,8 +5226,8 @@ dump_session_inv( drive_t *drivep,
 		uuid_t mediaid;
 		char medialabel[ GLOBAL_HDR_STRING_SZ ];
 		bool_t partial;
-		intgen_t mediafileix;
-		intgen_t rval;
+		int mediafileix;
+		int rval;
 		rv_t rv;
 
 		mlog( MLOG_VERBOSE, _(
@@ -5265,7 +5265,7 @@ dump_session_inv( drive_t *drivep,
 
 		uuid_copy(mediaid, mwhdrp->mh_mediaid);
 		strcpy( medialabel, mwhdrp->mh_medialabel );
-		mediafileix = ( intgen_t )mwhdrp->mh_mediafileix;
+		mediafileix = ( int )mwhdrp->mh_mediafileix;
 
 		rval = write_buf( inv_sbufp,
 				  inv_sbufsz,
@@ -5327,7 +5327,7 @@ dump_session_inv( drive_t *drivep,
 			ok = inv_put_mediafile( inv_stmt,
 						&mediaid,
 						medialabel,
-						( u_intgen_t )mediafileix,
+						( u_int )mediafileix,
 						(xfs_ino_t )0,
 						( off64_t )0,
 						(xfs_ino_t )0,
@@ -5444,7 +5444,7 @@ static rv_t
 write_pad( drive_t *drivep, size_t sz )
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	intgen_t rval;
+	int rval;
 	rv_t rv;
 
 	rval = write_buf( 0,
@@ -5531,7 +5531,7 @@ static rv_t
 Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	intgen_t dcaps = drivep->d_capabilities;
+	int dcaps = drivep->d_capabilities;
 	global_hdr_t *gwhdrp = drivep->d_gwritehdrp;
 	drive_hdr_t *dwhdrp = drivep->d_writehdrp;
 	media_hdr_t *mwhdrp = ( media_hdr_t * )dwhdrp->dh_upper;
@@ -5543,7 +5543,7 @@ Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
 	bool_t prevmediapresentpr;
 	bool_t mediawrittentopr;
 	global_hdr_t saved_gwhdr;
-	intgen_t rval;
+	int rval;
 	bool_t ok;
 
 	/* sanity checks
@@ -5688,7 +5688,7 @@ position:
 				goto changemedia;
 			}
 			if ( MEDIA_TERMINATOR_CHK( mrhdrp )) {
-				intgen_t status;
+				int status;
 				mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
 				      "stream terminator found\n") );
 				assert( contextp->cc_Media_useterminatorpr );
@@ -5745,7 +5745,7 @@ position:
 				      "unable to overwrite\n") );
 				goto changemedia;
 			} else {
-				intgen_t status;
+				int status;
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 				      "repositioning to overwrite\n") );
 				assert( dcaps & DRIVE_CAP_BSF );
@@ -5879,7 +5879,7 @@ position:
 				mlog_exit_hint(RV_CORRUPT);
 				goto changemedia;
 			} else {
-				intgen_t status;
+				int status;
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
 				      "encountered corrupt or foreign data: "
 				      "repositioning to overwrite\n") );
@@ -6140,7 +6140,7 @@ Media_mfile_end( drive_t *drivep,
 		 bool_t hit_eom )
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	intgen_t rval;
+	int rval;
 
 	mlog( MLOG_DEBUG | MLOG_MEDIA,
 	      "Media op: end media file\n" );
@@ -6280,7 +6280,7 @@ retry:
 
 static rv_t
 Media_erasechk( drive_t *drivep,
-		intgen_t dcaps,
+		int dcaps,
 		bool_t intr_allowed,
 		bool_t prevmediapresentpr )
 {
diff --git a/dump/inomap.c b/dump/inomap.c
index dacf954..06f3869 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -69,7 +69,7 @@ extern bool_t allowexcludefiles_pr;
 
 /* inomap construction callbacks
  */
-static intgen_t cb_context( bool_t last,
+static int cb_context( bool_t last,
 			    time32_t,
 			    bool_t,
 			    time32_t,
@@ -77,24 +77,24 @@ static intgen_t cb_context( bool_t last,
 			    drange_t *,
 			    startpt_t *,
 			    size_t,
-			    intgen_t,
+			    int,
 			    bool_t,
 			    bool_t *);
 static void cb_context_free( void );
-static intgen_t cb_count_inogrp( void *, intgen_t, xfs_inogrp_t *);
-static intgen_t cb_add_inogrp( void *, intgen_t, xfs_inogrp_t * );
-static intgen_t cb_add( void *, jdm_fshandle_t *, intgen_t, xfs_bstat_t * );
+static int cb_count_inogrp( void *, int, xfs_inogrp_t *);
+static int cb_add_inogrp( void *, int, xfs_inogrp_t * );
+static int cb_add( void *, jdm_fshandle_t *, int, xfs_bstat_t * );
 static bool_t cb_inoinresumerange( xfs_ino_t );
 static bool_t cb_inoresumed( xfs_ino_t );
 static void cb_accuminit_sz( void );
 static void cb_spinit( void );
-static intgen_t cb_startpt( void *,
+static int cb_startpt( void *,
 			    jdm_fshandle_t *,
-			    intgen_t,
+			    int,
 			    xfs_bstat_t * );
-static intgen_t supprt_prune( void *,
+static int supprt_prune( void *,
 			      jdm_fshandle_t *,
-			      intgen_t,
+			      int,
 			      xfs_bstat_t *,
 			      char * );
 static off64_t quantity2offset( jdm_fshandle_t *, xfs_bstat_t *, off64_t );
@@ -102,25 +102,25 @@ static off64_t estimate_dump_space( xfs_bstat_t * );
 
 /* inomap primitives
  */
-static intgen_t inomap_init( intgen_t igrpcnt );
-static void inomap_add( void *, xfs_ino_t ino, gen_t gen, intgen_t );
-static intgen_t inomap_set_state( void *, xfs_ino_t ino, intgen_t );
+static int inomap_init( int igrpcnt );
+static void inomap_add( void *, xfs_ino_t ino, gen_t gen, int );
+static int inomap_set_state( void *, xfs_ino_t ino, int );
 static void inomap_set_gen(void *, xfs_ino_t, gen_t );
 
 /* subtree abstraction
  */
-static intgen_t subtree_descend_cb( void *,
+static int subtree_descend_cb( void *,
 				    jdm_fshandle_t *,
-				    intgen_t fsfd,
+				    int fsfd,
 				    xfs_bstat_t *,
 				    char * );
-static intgen_t subtreelist_parse_cb( void *,
+static int subtreelist_parse_cb( void *,
 				      jdm_fshandle_t *,
-				      intgen_t fsfd,
+				      int fsfd,
 				      xfs_bstat_t *,
 				      char * );
-static intgen_t subtreelist_parse( jdm_fshandle_t *,
-				   intgen_t,
+static int subtreelist_parse( jdm_fshandle_t *,
+				   int,
 				   xfs_bstat_t *,
 				   char *[],
 				   ix_t );
@@ -145,7 +145,7 @@ static u_int64_t inomap_exclude_skipattr = 0;
 /* ARGSUSED */
 bool_t
 inomap_build( jdm_fshandle_t *fshandlep,
-	      intgen_t fsfd,
+	      int fsfd,
 	      xfs_bstat_t *rootstatp,
 	      bool_t last,
 	      time32_t lasttime,
@@ -166,9 +166,9 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	xfs_bstat_t *bstatbufp;
 	size_t bstatbuflen;
 	bool_t pruneneeded = BOOL_FALSE;
-	intgen_t igrpcnt = 0;
-	intgen_t stat;
-	intgen_t rval;
+	int igrpcnt = 0;
+	int stat;
+	int rval;
 
         /* do a sync so that bulkstat will pick up inode changes
          * that are currently in the inode cache. this is necessary
@@ -403,7 +403,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
 void
 inomap_skip( xfs_ino_t ino )
 {
-	intgen_t oldstate;
+	int oldstate;
 
 	oldstate = inomap_get_state( NULL, ino );
 	if ( oldstate == MAP_NDR_CHANGE) {
@@ -446,7 +446,7 @@ static bool_t cb_skip_unchanged_dirs;	/* set by cb_context() */
 /* cb_context - initializes the call back context for the add and prune
  * phases of inomap_build().
  */
-static intgen_t
+static int
 cb_context( bool_t last,
 	    time32_t lasttime,
 	    bool_t resume,
@@ -455,7 +455,7 @@ cb_context( bool_t last,
 	    drange_t *resumerangep,
 	    startpt_t *startptp,
 	    size_t startptcnt,
-	    intgen_t igrpcnt,
+	    int igrpcnt,
 	    bool_t skip_unchanged_dirs,
 	    bool_t *pruneneededp )
 {
@@ -489,10 +489,10 @@ cb_context_free( void )
 	inomap_free_context( cb_inomap_contextp );
 }
 
-static intgen_t
-cb_count_inogrp( void *arg1, intgen_t fsfd, xfs_inogrp_t *inogrp )
+static int
+cb_count_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
 {
-	intgen_t *count = (intgen_t *)arg1;
+	int *count = (int *)arg1;
 	(*count)++;
 	return 0;
 }
@@ -503,10 +503,10 @@ cb_count_inogrp( void *arg1, intgen_t fsfd, xfs_inogrp_t *inogrp )
  * files or directories have not been modified.
  */
 /* ARGSUSED */
-static intgen_t
+static int
 cb_add( void *arg1,
 	jdm_fshandle_t *fshandlep,
-	intgen_t fsfd,
+	int fsfd,
 	xfs_bstat_t *statp )
 {
 	register time32_t mtime = statp->bs_mtime.tv_sec;
@@ -692,12 +692,12 @@ cb_inoresumed( xfs_ino_t ino )
 static bool_t			/* false, used as diriter callback */
 supprt_prune( void *arg1,	/* ancestors marked as changed? */
 	      jdm_fshandle_t *fshandlep,
-	      intgen_t fsfd,
+	      int fsfd,
 	      xfs_bstat_t *statp,
 	      char *name )
 {
 	static bool_t cbrval = BOOL_FALSE;
-	intgen_t state;
+	int state;
 
 	if ( ( statp->bs_mode & S_IFMT ) == S_IFDIR ) {
 		bool_t changed_below = BOOL_FALSE;
@@ -810,13 +810,13 @@ typedef enum {
 } action_t;
 
 /* ARGSUSED */
-static intgen_t
+static int
 cb_startpt( void *arg1,
 	    jdm_fshandle_t *fshandlep,
-	    intgen_t fsfd,
+	    int fsfd,
 	    xfs_bstat_t *statp )
 {
-	register intgen_t state;
+	register int state;
 
 	off64_t estimate;
 	off64_t old_accum = cb_accum;
@@ -955,20 +955,20 @@ struct i2gseg {
 typedef struct i2gseg i2gseg_t;
 
 typedef struct seg_addr {
-	intgen_t hnkoff;
-	intgen_t segoff;
-	intgen_t inooff;
+	int hnkoff;
+	int segoff;
+	int inooff;
 } seg_addr_t;
 
 static struct inomap {
 	hnk_t *hnkmap;
-	intgen_t hnkmaplen;
+	int hnkmaplen;
 	i2gseg_t *i2gmap;
 	seg_addr_t lastseg;
 } inomap;
 
 static inline void
-SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, intgen_t state )
+SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
 {
 	register xfs_ino_t relino;
 	register u_int64_t mask;
@@ -1020,10 +1020,10 @@ SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, intgen_t state )
 	}
 }
 
-static inline intgen_t
+static inline int
 SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
 {
-	intgen_t state;
+	int state;
 	register xfs_ino_t relino;
 	register u_int64_t mask;
 	relino = ino - segp->base;
@@ -1045,8 +1045,8 @@ SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
 
 /* context for inomap construction - initialized by map_init
  */
-static intgen_t
-inomap_init( intgen_t igrpcnt )
+static int
+inomap_init( int igrpcnt )
 {
 	assert( sizeof( hnk_t ) == HNKSZ );
 
@@ -1072,7 +1072,7 @@ inomap_getsz( void )
 static inline bool_t
 inomap_validaddr( seg_addr_t *addrp )
 {
-	intgen_t maxseg;
+	int maxseg;
 
 	if ( addrp->hnkoff < 0 || addrp->hnkoff > inomap.lastseg.hnkoff )
 		return BOOL_FALSE;
@@ -1099,14 +1099,14 @@ inomap_addr2seg( seg_addr_t *addrp )
 	return &hunkp->seg[addrp->segoff];
 }
 
-static inline intgen_t
+static inline int
 inomap_addr2segix( seg_addr_t *addrp )
 {
 	return ( addrp->hnkoff * SEGPERHNK ) + addrp->segoff;
 }
 
-static inline intgen_t
-inomap_lastseg( intgen_t hnkoff )
+static inline int
+inomap_lastseg( int hnkoff )
 {
 	if ( hnkoff == inomap.lastseg.hnkoff )
 		return inomap.lastseg.segoff;
@@ -1117,8 +1117,8 @@ inomap_lastseg( intgen_t hnkoff )
 /* called for every inode group in the filesystem in increasing inode
  * order. adds a new segment to the inomap and ino-to-gen map.
  */
-static intgen_t
-cb_add_inogrp( void *arg1, intgen_t fsfd, xfs_inogrp_t *inogrp )
+static int
+cb_add_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
 {
 	hnk_t *hunk;
 	seg_t *segp;
@@ -1131,7 +1131,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd, xfs_inogrp_t *inogrp )
 		lastsegp->segoff = 0;
 
 		if (lastsegp->hnkoff == inomap.hnkmaplen) {
-			intgen_t numsegs;
+			int numsegs;
 
 			inomap.hnkmaplen++;
 			inomap.hnkmap = (hnk_t *)
@@ -1166,7 +1166,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd, xfs_inogrp_t *inogrp )
 /* called for every ino to be added to the map.
  */
 static void
-inomap_add( void *contextp, xfs_ino_t ino, gen_t gen, intgen_t state )
+inomap_add( void *contextp, xfs_ino_t ino, gen_t gen, int state )
 {
 	inomap_set_state( contextp, ino, state );
 	inomap_set_gen( contextp, ino, gen );
@@ -1203,8 +1203,8 @@ static bool_t
 inomap_find_hnk( seg_addr_t *addrp, xfs_ino_t ino )
 {
 	hnk_t *hunkp;
-	intgen_t lower;
-	intgen_t upper;
+	int lower;
+	int upper;
 
 	lower = 0;
 	upper = inomap.lastseg.hnkoff;
@@ -1235,8 +1235,8 @@ static bool_t
 inomap_find_seg( seg_addr_t *addrp, xfs_ino_t ino )
 {
 	seg_t *segp;
-	intgen_t lower;
-	intgen_t upper;
+	int lower;
+	int upper;
 
 	if ( !inomap_validaddr( addrp ) ) {
 		inomap_reset_context( addrp );
@@ -1267,7 +1267,7 @@ inomap_find_seg( seg_addr_t *addrp, xfs_ino_t ino )
 }
 
 static xfs_ino_t
-inomap_iter( void *contextp, intgen_t statemask )
+inomap_iter( void *contextp, int statemask )
 {
 	xfs_ino_t ino, endino;
 	seg_t *segp;
@@ -1286,7 +1286,7 @@ inomap_iter( void *contextp, intgen_t statemask )
 			ino = segp->base + addrp->inooff;
 			endino = segp->base + INOPERSEG;
 			for ( ; ino < endino ; ino++, addrp->inooff++ ) {
-				intgen_t st;
+				int st;
 				st = SEG_GET_BITS( segp, ino );
 				if ( statemask & ( 1 << st )) {
 					addrp->inooff++; /* for next call */
@@ -1302,7 +1302,7 @@ inomap_iter( void *contextp, intgen_t statemask )
 xfs_ino_t
 inomap_next_nondir(void *contextp, xfs_ino_t lastino)
 {
-	intgen_t state = 1 << MAP_NDR_CHANGE;
+	int state = 1 << MAP_NDR_CHANGE;
 	xfs_ino_t nextino;
 
 	do {
@@ -1315,7 +1315,7 @@ inomap_next_nondir(void *contextp, xfs_ino_t lastino)
 xfs_ino_t
 inomap_next_dir(void *contextp, xfs_ino_t lastino)
 {
-	intgen_t state = (1 << MAP_DIR_CHANGE) | (1 << MAP_DIR_SUPPRT);
+	int state = (1 << MAP_DIR_CHANGE) | (1 << MAP_DIR_SUPPRT);
 	xfs_ino_t nextino;
 
 	do {
@@ -1325,10 +1325,10 @@ inomap_next_dir(void *contextp, xfs_ino_t lastino)
 	return nextino;
 }
 
-static intgen_t
-inomap_set_state( void *contextp, xfs_ino_t ino, intgen_t state )
+static int
+inomap_set_state( void *contextp, xfs_ino_t ino, int state )
 {
-	intgen_t oldstate;
+	int oldstate;
 	seg_addr_t *addrp;
 	seg_addr_t addr;
 	seg_t *segp;
@@ -1345,7 +1345,7 @@ inomap_set_state( void *contextp, xfs_ino_t ino, intgen_t state )
 	return oldstate;
 }
 
-intgen_t
+int
 inomap_get_state( void *contextp, xfs_ino_t ino )
 {
 	seg_addr_t *addrp;
@@ -1382,7 +1382,7 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 	i2gsegp->s_gen[relino] = gen;
 }
 
-intgen_t
+int
 inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
 {
 	seg_addr_t *addrp;
@@ -1432,7 +1432,7 @@ inomap_dump( drive_t *drivep )
 	for ( addr.hnkoff = 0 ;
 	      addr.hnkoff <= inomap.lastseg.hnkoff ;
 	      addr.hnkoff++ ) {
-		intgen_t rval;
+		int rval;
 		rv_t rv;
 		drive_ops_t *dop = drivep->d_opsp;
 
@@ -1471,9 +1471,9 @@ inomap_dump( drive_t *drivep )
 	return RV_OK;
 }
 
-static intgen_t
+static int
 subtreelist_parse( jdm_fshandle_t *fshandlep,
-		   intgen_t fsfd,
+		   int fsfd,
 		   xfs_bstat_t *rootstatp,
 		   char *subtreebuf[],
 		   ix_t subtreecnt )
@@ -1487,7 +1487,7 @@ subtreelist_parse( jdm_fshandle_t *fshandlep,
 	/* do a recursive descent for each subtree specified
 	 */
 	for ( subtreeix = 0 ; subtreeix < subtreecnt ; subtreeix++ ) {
-		intgen_t cbrval = 0;
+		int cbrval = 0;
 		char *currentpath = subtreebuf[ subtreeix ];
 		assert( *currentpath != '/' );
 		( void )diriter( fshandlep,
@@ -1511,14 +1511,14 @@ subtreelist_parse( jdm_fshandle_t *fshandlep,
 	return 0;
 }
 
-static intgen_t
+static int
 subtreelist_parse_cb( void *arg1,
 		      jdm_fshandle_t *fshandlep,
-		      intgen_t fsfd,
+		      int fsfd,
 		      xfs_bstat_t *statp,
 		      char *name  )
 {
-	intgen_t cbrval = 0;
+	int cbrval = 0;
 
 	/* arg1 is used to carry the tail of the subtree path
 	 */
@@ -1594,14 +1594,14 @@ subtreelist_parse_cb( void *arg1,
 	}
 }
 
-static intgen_t
+static int
 subtree_descend_cb( void *arg1,
 		    jdm_fshandle_t *fshandlep,
-		    intgen_t fsfd,
+		    int fsfd,
 		    xfs_bstat_t *statp,
 		    char *name  )
 {
-	intgen_t cbrval = 0;
+	int cbrval = 0;
 
 	cb_add( NULL, fshandlep, fsfd, statp );
 
@@ -1628,7 +1628,7 @@ subtree_descend_cb( void *arg1,
 static off64_t
 quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
 {
-	intgen_t fd;
+	int fd;
 	getbmapx_t bmap[ BMAP_LEN ];
 	off64_t offset;
 	off64_t offset_next;
@@ -1661,8 +1661,8 @@ quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
 	}
 
 	for ( ; ; ) {
-		intgen_t eix;
-		intgen_t rval;
+		int eix;
+		int rval;
 
 		rval = ioctl( fd, XFS_IOC_GETBMAPX, bmap );
 		if ( rval ) {
diff --git a/dump/inomap.h b/dump/inomap.h
index 7d1db1f..663b434 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -47,7 +47,7 @@
  * abort the dump; else returns BOOL_TRUE.
  */
 extern bool_t inomap_build( jdm_fshandle_t *fshandlep,
-			    intgen_t fsfd,
+			    int fsfd,
 			    xfs_bstat_t *rootstatp,
 			    bool_t last,
 	      		    time32_t lasttime,
@@ -131,8 +131,8 @@ typedef struct hnk hnk_t;
 extern void *inomap_alloc_context( void );
 extern void inomap_reset_context( void *contextp );
 extern void inomap_free_context( void *contextp );
-extern intgen_t inomap_get_state( void *contextp, xfs_ino_t ino );
-extern intgen_t inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen );
+extern int inomap_get_state( void *contextp, xfs_ino_t ino );
+extern int inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen );
 
 
 /* generators returning the next dir or non-dir ino selected in this dump.
diff --git a/dump/var.c b/dump/var.c
index ceb7e3a..d3fa3be 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -84,7 +84,7 @@ void
 var_skip( uuid_t *dumped_fsidp, void ( *cb )( xfs_ino_t ino ))
 {
 	uuid_t fsid;
-	intgen_t rval;
+	int rval;
 
 	/* see if the fs uuid's match
 	 */
@@ -118,7 +118,7 @@ var_skip_recurse( char *base, void ( *cb )( xfs_ino_t ino ))
 	struct stat64 statbuf;
 	DIR *dirp;
 	struct dirent *direntp;
-	intgen_t rval;
+	int rval;
 
 	rval = lstat64( base, &statbuf );
 	if ( rval ) {
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index b564d2f..4c1855b 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -170,7 +170,7 @@ inv_writesession_open(
 {
 	invt_session_t  ses;
 	int		fd;
-	intgen_t	rval;
+	int	rval;
 	invt_sescounter_t *sescnt = NULL;
 	invt_seshdr_t  	hdr;
 	inv_sestoken_t	sestok;
@@ -867,10 +867,10 @@ static const char *myopts[] = {
 };
 
 
-intgen_t
+int
 inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx) 
 {
-	intgen_t rval = 0;
+	int rval = 0;
 	void *fs = 0;
 	char *options, *value;
 	extern char *optarg;
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index 7020f7f..419f575 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -45,7 +45,7 @@
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 get_counters( int fd, void **cntpp, size_t cntsz )
 {
 	/* object must be locked at least SHARED by caller */
@@ -72,7 +72,7 @@ get_counters( int fd, void **cntpp, size_t cntsz )
 			INV_VERSION );
 	} 
 
-	return (intgen_t) num;
+	return (int) num;
 }
 
 
@@ -83,7 +83,7 @@ get_counters( int fd, void **cntpp, size_t cntsz )
 /* get_headers                                                          */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
 {
 
@@ -110,7 +110,7 @@ get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
 /* get_invtrecord                                                       */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, 
 	        int whence, bool_t dolock )
 {
@@ -153,7 +153,7 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
 /* put_invtrecord                                                       */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, 
 	        int whence, bool_t dolock )
 {
@@ -193,7 +193,7 @@ put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
 /*----------------------------------------------------------------------*/
 
 
-intgen_t
+int
 get_headerinfo( int fd, void **hdrs, void **cnt,
 	        size_t hdrsz, size_t cntsz, bool_t dolock )
 {	
@@ -222,7 +222,7 @@ get_headerinfo( int fd, void **hdrs, void **cnt,
 /* get_lastheader                                                       */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 get_lastheader( int fd, void **ent, size_t hdrsz, size_t cntsz )
 {	
 	int	     	 nindices;
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 8263852..1c2bf3d 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -47,7 +47,7 @@
 /*----------------------------------------------------------------------*/
 
 
-intgen_t
+int
 fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 	      inv_oflag_t forwhat )
 {
@@ -86,7 +86,7 @@ fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 /*----------------------------------------------------------------------*/
 
 
-intgen_t
+int
 fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 {
 	int numfs, i, fd;
@@ -172,7 +172,7 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 
 
 
-intgen_t
+int
 fstab_get_fname( void *pred, 
 		 char *fname, 
 		 inv_predicate_t bywhat,
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index 0378c5a..13b64db 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -153,7 +153,7 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 idx_put_newentry( 
 	invt_idxinfo_t *idx, 
 	invt_entry_t *ient )
@@ -291,7 +291,7 @@ idx_create( char *fname, inv_oflag_t forwhat )
 /*                                                                      */
 /*                                                                      */
 /*----------------------------------------------------------------------*/
-intgen_t
+int
 idx_recons_time( time32_t tm, invt_idxinfo_t *idx )
 {
 	invt_timeperiod_t *tp = &idx->iarr[idx->index].ie_timeperiod;
@@ -316,7 +316,7 @@ idx_recons_time( time32_t tm, invt_idxinfo_t *idx )
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 {
 	int rval;
@@ -380,7 +380,7 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 idx_create_entry(  
 	inv_idbtoken_t *tok, 
 	int invfd, 	/* kept locked EX  by caller */
@@ -495,7 +495,7 @@ idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index )
 }
 
 
-intgen_t
+int
 idx_DEBUG_printinvindices( invt_entry_t *iarr, u_int num )
 {
 	u_int i;
@@ -520,7 +520,7 @@ idx_DEBUG_printinvindices( invt_entry_t *iarr, u_int num )
 	
 }
 
-intgen_t
+int
 idx_DEBUG_print ( int fd )
 {
 	int nindices;
@@ -542,7 +542,7 @@ idx_DEBUG_print ( int fd )
 
 
 
-intgen_t
+int
 DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, u_int ref,
 			  invt_pr_ctx_t *prctx)
 {
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index f1341b9..1b99d5c 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -220,7 +220,7 @@ invmgr_query_all_sessions (
 /* comparison/check.                                                    */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 search_invt( 
 	uuid_t			*fsidp,
 	int			invfd,
@@ -336,7 +336,7 @@ search_invt(
 /*---------------------------------------------------------------------------*/
 
 
-intgen_t
+int
 invmgr_inv_print(
 	int 		invfd, 
 	invt_pr_ctx_t 	*prctx)
@@ -427,7 +427,7 @@ invmgr_inv_print(
 /*---------------------------------------------------------------------------*/
 
 
-intgen_t
+int
 invmgr_inv_check(
 	int invfd)
 {
@@ -670,7 +670,7 @@ insert_session( invt_sessinfo_t *s)
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 make_invdirectory( inv_oflag_t forwhat )
 {
 	struct stat64 st;
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index ebcae95..66a03f4 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -29,12 +29,12 @@
 /*
  * Resolve a stobj, invidx or fstab
  */
-intgen_t
+int
 oref_resolve_(
 	invt_oref_t 	*obj,
 	invt_objtype_t	type)
 {
-	intgen_t rval;
+	int rval;
 
 	type &= INVT_OTYPE_MASK;
 	assert(type);
@@ -69,12 +69,12 @@ oref_resolve_(
  * Resolve an object reference upto a specified point 
  */
 
-intgen_t
+int
 oref_resolve_upto(
 	invt_oref_t 	*obj, 
 	invt_objtype_t	type)
 {
-	intgen_t rval = INV_OK;
+	int rval = INV_OK;
 
 	assert (OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
 	assert (OREF_ISLOCKED(obj));
@@ -107,7 +107,7 @@ oref_resolve_upto(
 
 
 
-intgen_t
+int
 oref_resolve_entries(
 	invt_oref_t 	*obj)
 {
@@ -146,7 +146,7 @@ oref_resolve_entries(
 
 
 
-intgen_t
+int
 oref_resolve_counters(
 	invt_oref_t 	*obj)
 {
@@ -179,12 +179,12 @@ oref_resolve_counters(
 
 
 
-intgen_t
+int
 oref_sync(
 	invt_oref_t 	*obj, 
 	invt_objtype_t	type)
 {
-	intgen_t rval;
+	int rval;
 
 	type &= INVT_RES_MASK;
 	assert(type);
@@ -219,14 +219,14 @@ oref_sync(
 	return rval;
 }
 
-intgen_t
+int
 oref_sync_append(
 	invt_oref_t 	*obj, 
 	invt_objtype_t	type,
 	void		*entry,
 	size_t		entsz)
 {
-	intgen_t rval;
+	int rval;
 
 	type &= INVT_RES_MASK;
 	assert(type);
@@ -305,7 +305,7 @@ _oref_free(
  * Also resolves an idb_token as a side effect.
  */
 
-intgen_t
+int
 oref_resolve(
 	invt_oref_t	*invidx,
 	inv_predicate_t bywhat,
@@ -361,7 +361,7 @@ oref_resolve(
 	/* create another storage object ( and, an inv_index entry for it 
 	   too ) if we've filled this one up */
 	if (OREF_CNT_CURNUM(stobj) >= OREF_CNT_MAXNUM(stobj)) {
-		intgen_t 	rval;
+		int 	rval;
 #ifdef INVT_DEBUG
 		mlog( MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
 		      "index entry. \n" );
@@ -390,7 +390,7 @@ oref_resolve(
  * Resolve the invidx entirely, and open the StObj.
  * Invidx is kept locked by caller
  */
-intgen_t
+int
 oref_resolve_child(
 	invt_oref_t 	*invidx,
 	int		*index)
@@ -424,7 +424,7 @@ oref_resolve_child(
 
 
 /* used to be idx_create */
-intgen_t
+int
 oref_resolve_new_invidx(
 	invt_oref_t 	*invidx,
 	char		*fname)
@@ -454,7 +454,7 @@ oref_resolve_new_invidx(
 
 
 /* formerly idx_create_entry() */
-intgen_t
+int
 oref_resolve_new_stobj(
 	invt_oref_t	*invidx,
 	bool_t		firstentry)
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index 2562500..e16684d 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -78,7 +78,7 @@ typedef struct invt_oref {
 
 	/* indicates level of depth this has been resolved to */
 	invt_objtype_t			 type;
-	intgen_t			 lockflag;
+	int			 lockflag;
 	void				 *token;
 } invt_oref_t;
 
@@ -231,22 +231,22 @@ typedef struct invt_oref {
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 oref_resolve(
 	invt_oref_t	*invidx,
 	inv_predicate_t bywhat,
 	void 		*pred);
 
-intgen_t
+int
 oref_resolve_upto(
 	invt_oref_t 	*obj, 
 	invt_objtype_t	type);
 
-intgen_t
+int
 oref_resolve_entries(
 	invt_oref_t 	*obj);
 
-intgen_t
+int
 oref_resolve_counters(
 	invt_oref_t 	*obj);
 
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index 8817b5e..598c366 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -63,8 +63,8 @@
 #define INVLOCK( fd, m )	flock( fd, m ) 
 
 /* return values */
-#define INV_OK			(intgen_t) 1
-#define INV_ERR			(intgen_t) -1
+#define INV_OK			(int) 1
+#define INV_ERR			(int) -1
 
 #define I_DONE                  (int) -1
 #define I_EMPTYINV              (int) -2
@@ -356,10 +356,10 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 inv_idbtoken_t
 idx_create( char *fname, inv_oflag_t forwhat );
 
-intgen_t
+int
 idx_create_entry( inv_idbtoken_t *tok, int invfd, bool_t firstentry );
 
-intgen_t
+int
 idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime);
 
 
@@ -370,19 +370,19 @@ u_int
 idx_insert_newentry( int fd, int *stobjfd, invt_entry_t *iarr, 
 		     invt_counter_t *icnt,
 		     time32_t tm );
-intgen_t
+int
 idx_put_newentry( invt_idxinfo_t *idx, invt_entry_t *ient );
 
 int
 idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index );
 
-intgen_t
+int
 idx_recons_time( time32_t tm, invt_idxinfo_t *idx );
 
-intgen_t
+int
 idx_DEBUG_printinvindices( invt_entry_t *iarr, u_int num );
 
-intgen_t
+int
 idx_DEBUG_print ( int fd );
 
 /*----------------------------------------------------------------------*/
@@ -390,11 +390,11 @@ idx_DEBUG_print ( int fd );
 int
 stobj_create( char *fname );
 
-intgen_t
+int
 stobj_create_session( inv_sestoken_t tok, int fd, invt_sescounter_t *sescnt, 
 		      invt_session_t *ses, invt_seshdr_t *hdr );
 
-intgen_t
+int
 stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf );
 
 off64_t
@@ -406,7 +406,7 @@ stobj_put_session(
 	invt_stream_t *strms,
 	invt_mediafile_t *mfiles );
 
-intgen_t
+int
 stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses, 
 		   invt_stream_t *strms,
 		   invt_mediafile_t *mfiles );
@@ -414,20 +414,20 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 int
 stobj_hdrcmp( const void *h1, const void *h2 );
 
-intgen_t
+int
 stobj_sortheaders( int fd, u_int num );
 
 u_int
 stobj_find_splitpoint( int fd, invt_seshdr_t *harr, u_int ns, time32_t tm );
 
-intgen_t
+int
 stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt, 
 	     invt_sessinfo_t *newsess );
 bool_t
 stobj_replace_session( int fd, invt_sescounter_t *sescnt, invt_session_t *ses,
 		       invt_seshdr_t *hdr, invt_sessinfo_t *newsess );
 
-intgen_t
+int
 stobj_delete_mfile( int fd, inv_stream_t *strm, invt_mediafile_t *mf,
 		    off64_t  mfileoff );
 
@@ -449,20 +449,20 @@ bool_t
 stobj_delete_mobj( int fd, invt_seshdr_t *hdr, void *arg,
 		   void **buf );
 
-intgen_t
+int
 stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr, invt_session_t *ses );
 
 void
 stobj_makefname( char *fname );
 
-intgen_t
+int
 stobj_insert_session( invt_idxinfo_t *idx, int fd,
 		      invt_sessinfo_t *s );
 
-intgen_t
+int
 stobj_make_invsess( int fd, inv_session_t **buf, invt_seshdr_t *hdr );
 
-intgen_t
+int
 stobj_copy_invsess( int fd, invt_seshdr_t *hdr, invt_session_t *ses, 
 		    inv_session_t **buf);
 
@@ -494,14 +494,14 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo);
 
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 fstab_get_fname( void *pred, char *fname, inv_predicate_t bywhat, 
 		 inv_oflag_t forwhat );
 
-intgen_t
+int
 fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat );
 
-intgen_t
+int
 fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs, 
 	      inv_oflag_t forwhat );
 
@@ -511,13 +511,13 @@ fstab_DEBUG_print( invt_fstab_t *arr, int num );
 
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 get_invtentry( char *fname, time32_t tm, invt_entry_t *buf, size_t bufsz );
 
-intgen_t
+int
 get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, int, bool_t dolock );
 
-intgen_t
+int
 put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, int, bool_t dolock );
 
 inv_idbtoken_t
@@ -527,23 +527,23 @@ void
 destroy_token( inv_idbtoken_t tok );
 
 
-intgen_t
+int
 get_headers( int fd, void **hdrs, size_t bufsz, size_t cntsz );
 
-intgen_t
+int
 get_counters( int fd, void **cntpp, size_t sz );
 
-intgen_t
+int
 get_sescounters( int fd, invt_sescounter_t **cntpp );
 
-intgen_t
+int
 get_lastheader( int fd, void **ent, size_t hdrsz,  size_t cntsz );
 
 
 inv_sestoken_t
 get_sesstoken( inv_idbtoken_t tok );
 
-intgen_t
+int
 get_headerinfo( int fd, void **hdrs, void **cnt,
 	        size_t hdrsz, size_t cntsz, bool_t doblock );
 
@@ -551,13 +551,13 @@ bool_t
 invmgr_query_all_sessions(uuid_t *fsidp, void *inarg, void **outarg,
 			  search_callback_t func);
 
-intgen_t
+int
 search_invt(uuid_t *fsidp, int invfd, void *arg, void **buf,
 	    search_callback_t do_chkcriteria);
-intgen_t
+int
 invmgr_inv_print( int invfd, invt_pr_ctx_t *prctx);
 
-intgen_t
+int
 invmgr_inv_check( int invfd );
 
 bool_t
@@ -571,18 +571,18 @@ lastsess_level_lessthan( int fd, invt_seshdr_t *hdr,  void *arg,
 bool_t
 lastsess_level_equalto( int fd, invt_seshdr_t *hdr,  void *arg, void **buf );
 
-intgen_t
+int
 DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, u_int ref, 
 			  invt_pr_ctx_t *prctx);
 
-intgen_t
+int
 make_invdirectory( inv_oflag_t forwhat );
 
 bool_t
 init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat, 
 	 inv_idbtoken_t *tok );
 
-intgen_t
+int
 inv_getopt( int argc, char **argv, invt_pr_ctx_t *prctx);
 
 bool_t
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index bae2fc5..0b6aa45 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -47,7 +47,7 @@
 /* Used in reconstruction of the inventory. We add a session to this    */
 /* storage object whether or not it has reached its maximum.            */
 /*----------------------------------------------------------------------*/
-intgen_t
+int
 stobj_insert_session( invt_idxinfo_t *idx,
 		      int fd, /* kept locked EX by caller */
 		      invt_sessinfo_t *s )
@@ -160,7 +160,7 @@ stobj_find_splitpoint( int fd, invt_seshdr_t *harr, u_int ns, time32_t tm )
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt, 
 	     invt_sessinfo_t *newsess )
 {
@@ -269,7 +269,7 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 
 
 /* ARGSUSED */
-intgen_t
+int
 stobj_delete_mfile( int fd, inv_stream_t *strm, invt_mediafile_t *mf,
 		    off64_t  mfileoff )
 {
@@ -385,7 +385,7 @@ stobj_put_session(
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 stobj_sortheaders( int fd, u_int num )
 {
 	size_t sz = sizeof( invt_seshdr_t ) * num;
@@ -435,7 +435,7 @@ stobj_sortheaders( int fd, u_int num )
 /* after adjusting their offsets.                                       */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses, 
 		   invt_stream_t *strms,
 		   invt_mediafile_t *mfiles )
@@ -567,7 +567,7 @@ stobj_create( char *fname )
 /*----------------------------------------------------------------------*/
 
 
-intgen_t
+int
 stobj_create_session( 
 	inv_sestoken_t tok, 
 	int fd, /* kept locked EX by caller */
@@ -601,7 +601,7 @@ stobj_create_session(
 /* The stobj_fd in the stream token is kept locked EX by caller.        */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 {
 	int  rval;
@@ -707,7 +707,7 @@ stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 /* caller takes the responsibility of locking.                          */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr, 
 		     invt_session_t *ses )
 {
@@ -1127,7 +1127,7 @@ stobj_unpack_sessinfo(
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 stobj_make_invsess( int fd, inv_session_t **buf, invt_seshdr_t *hdr )
 {
 	invt_session_t ses;
@@ -1206,7 +1206,7 @@ stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 stobj_copy_invsess(int fd,  
 		   invt_seshdr_t *hdr,
 		   invt_session_t *ses,
diff --git a/inventory/inventory.h b/inventory/inventory.h
index 32156dd..43ac969 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -300,7 +300,7 @@ inv_delete_mediaobj( uuid_t *moid );
 extern bool_t
 inv_DEBUG_print( int argc, char **argv );
 
-extern intgen_t
+extern int
 inv_setup_base( void );
 
 extern char *
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 51b7774..7a268ea 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -84,7 +84,7 @@ typedef struct ses{
 
 #define SESLIM  240
 
-intgen_t
+int
 recons_test( int howmany )
 {
 	int fd, i, rval = 1;
@@ -120,7 +120,7 @@ recons_test( int howmany )
 
 
 
-intgen_t
+int
 delete_test( int n )
 {
 	int fd, i;
@@ -189,7 +189,7 @@ sess_queries_bylabel(char *lab)
 }
 
 
-intgen_t
+int
 query_test( int level )
 {
 	int i;
@@ -245,7 +245,7 @@ query_test( int level )
 /*                                                                      */
 /*----------------------------------------------------------------------*/
 
-intgen_t
+int
 write_test( int nsess, int nstreams, int nmedia, int dumplevel )
 {
 	int i,j,k,m,fd;
diff --git a/invutil/invidx.c b/invutil/invidx.c
index b6ce4fa..56995f0 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -621,7 +621,7 @@ stobj_create( char *fname )
     return fd;
 }
 
-intgen_t
+int
 stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses, 
 		   invt_stream_t *strms,
 		   invt_mediafile_t *mfiles )
diff --git a/restore/content.c b/restore/content.c
index b02e38a..ac7d72a 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -216,7 +216,7 @@ struct pers_file {
 		/* no non-dirs are needed from this nmedia file (due to
 		 * subtree or interactive selections)
 		 */
-	intgen_t f_flags;
+	int f_flags;
 		/* mark terminators and inventories
 		 */
 	bool_t f_underheadpr;
@@ -366,8 +366,8 @@ typedef struct partial_rest partial_rest_t;
 struct stream_context {
 	bstat_t    sc_bstat;
 	char       sc_path[2 * MAXPATHLEN];
-	intgen_t   sc_fd;
-	intgen_t   sc_hsmflags;
+	int   sc_fd;
+	int   sc_hsmflags;
 
 	/*
 	 * we have to set the owner before we set extended attributes otherwise
@@ -640,7 +640,7 @@ struct tran {
 	char *t_hkdir;
 		/* absolute pathname of housekeeping directory
 		 */
-	intgen_t t_persfd;
+	int t_persfd;
 		/* file descriptor of the persistent state file
 		 */
 	size64_t t_dirdumps;
@@ -793,7 +793,7 @@ static bool_t restore_reg( drive_t *drivep,
 static bool_t restore_extent_group( drive_t *drivep,
 				    filehdr_t *fhdrp,
 				    char *path,
-				    intgen_t fd,
+				    int fd,
 				    bool_t ehcs,
 				    rv_t *rvp);
 static bool_t restore_complete_reg( stream_context_t* );
@@ -825,9 +825,9 @@ static void addobj( bag_t *bagp,
 static size_t cntobj( bag_t *bagp );
 static bool_t gapneeded( egrp_t *firstegrpp, egrp_t *lastegrpp );
 static char * ehdr_typestr( int32_t type );
-static intgen_t egrpcmp( egrp_t *egrpap, egrp_t *egrpbp );
+static int egrpcmp( egrp_t *egrpap, egrp_t *egrpbp );
 static void display_dump_label( bool_t lockpr,
-				intgen_t mllevel,
+				int mllevel,
 				char *introstr,
 				global_hdr_t *grhdrp,
 				media_hdr_t *mrhdrp,
@@ -883,7 +883,7 @@ static bool_t mcflag[ STREAM_SIMMAX ]; /* media change flag */
 /* definition of locally defined global functions ****************************/
 
 bool_t
-content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
+content_init( int argc, char *argv[ ], size64_t vmsz )
 {
 	char *dstdir;	/* abs. path to destination dir */
 	bool_t cumpr;	/* cmd line cumulative restore specification */
@@ -906,9 +906,9 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 	ix_t descpgcnt; /* pages allocated for persistent descriptors */
 	struct stat statbuf;
 	pid_t pid;
-	intgen_t c;
+	int c;
 	bool_t ok;
-	intgen_t rval;
+	int rval;
 	bool_t fullpr;
 
 	/* Calculate the size needed for the persistent inventory 
@@ -1599,7 +1599,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 		char *path1;
 		char *path2;
 		rv_t rv;
-		intgen_t rval;
+		int rval;
 
 		path1 = ( char * )calloc( 1, 2 * MAXPATHLEN );
 		assert( path1 );
@@ -1914,7 +1914,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 
 /* stream thread entry point - returns exit code
  */
-intgen_t
+int
 content_stream_restore( ix_t thrdix )
 {
 	dh_t fileh;
@@ -1922,7 +1922,7 @@ content_stream_restore( ix_t thrdix )
 	char *path1;
 	char *path2;
 	drive_t *drivep;
-	intgen_t dcaps;
+	int dcaps;
 	global_hdr_t *grhdrp;
 	drive_hdr_t *drhdrp;
 	media_hdr_t *mrhdrp;
@@ -1933,7 +1933,7 @@ content_stream_restore( ix_t thrdix )
 	uuid_t lastdumprejectedid;
 	rv_t rv;
 	bool_t ok;
-	intgen_t rval;
+	int rval;
 
 	/* allocate two path buffers
 	 */
@@ -2265,7 +2265,7 @@ content_stream_restore( ix_t thrdix )
 #if DEBUG_DUMPSTREAMS
 			{
 			    static int count[STREAM_MAX] = {0};
-			    intgen_t streamix = stream_getix( pthread_self() );
+			    int streamix = stream_getix( pthread_self() );
 			    if (++(count[streamix]) == 30) {
 				mlog( MLOG_TRACE,
 					"still waiting for dirs to be restored\n");
@@ -2437,7 +2437,7 @@ content_stream_restore( ix_t thrdix )
 #if DEBUG_DUMPSTREAMS
 			{
 			static int count[STREAM_MAX] = {0};
-			intgen_t streamix = stream_getix( pthread_self() );
+			int streamix = stream_getix( pthread_self() );
 			    if (++(count[streamix]) == 30) {
 				mlog( MLOG_NORMAL,
 				      "still waiting for dirs post-processing\n");
@@ -3453,7 +3453,7 @@ applynondirdump( drive_t *drivep,
 		drive_mark_t drivemark;
 		bstat_t *bstatp = &fhdrp->fh_stat;
 		bool_t resyncpr = BOOL_FALSE;
-		intgen_t rval;
+		int rval;
 
 		/* if a null file header, break
 		 */
@@ -3701,7 +3701,7 @@ wipepersstate( void )
 
 	while ( ( direntp = readdir64( dirp )) != 0 ) {
 		/* REFERENCED */
-		intgen_t len;
+		int len;
 		if ( ! strcmp( direntp->d_name, "." )) {
 			continue;
 		}
@@ -3870,7 +3870,7 @@ Media_mfile_next( Media_t *Mediap,
 	content_hdr_t *crhdrp = Mediap->M_crhdrp;
 	content_inode_hdr_t *scrhdrp = Mediap->M_scrhdrp;
 	dh_t fileh;
-	intgen_t rval = 0; /* no error by default */
+	int rval = 0; /* no error by default */
 	rv_t rv;
 	bool_t ok;
 	uuid_t prevmfiledumpid;
@@ -3949,7 +3949,7 @@ Media_mfile_next( Media_t *Mediap,
 		bool_t maybeholespr;
 		xfs_ino_t begino;
 		xfs_ino_t endino;
-		intgen_t dcaps = drivep->d_capabilities;
+		int dcaps = drivep->d_capabilities;
 		dh_t objh = DH_NULL;
 
 		emptypr = BOOL_FALSE;
@@ -4755,7 +4755,7 @@ newmedia:
 		/* eject media if drive not already empty
 		 */
 		if ( ! emptypr ) {
-			intgen_t dcaps = drivep->d_capabilities;
+			int dcaps = drivep->d_capabilities;
 			if ( purp == PURP_SEARCH ) {
 				if ( Mediap->M_pos == POS_USELESS ) {
 					mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
@@ -4929,7 +4929,7 @@ pi_allocdesc( dh_t *deschp )
 		ix_t descppg = pgsz / PERS_DESCSZ;
 		ix_t descix;
 		/* REFERENCED */
-		intgen_t rval;
+		int rval;
 
 		/* first unmap if any existing descriptors
 		 */
@@ -5007,7 +5007,7 @@ pi_insertfile( ix_t drivecnt,
 	       bool_t egrpvalpr,
 	       xfs_ino_t startino,
 	       off64_t startoffset,
-	       intgen_t flags,
+	       int flags,
 	       bool_t fileszvalpr,
 	       off64_t filesz )
 {
@@ -5428,9 +5428,9 @@ pi_addfile( Media_t *Mediap,
 			Mediap->M_pos = POS_ATNONDIR;
 			donepr = BOOL_FALSE;
 			while ( ! donepr ) {
-				intgen_t nread;
+				int nread;
 				drive_ops_t *dop = drivep->d_opsp;
-				intgen_t rval = 0;
+				int rval = 0;
 				nread = read_buf( bufp + buflen,
 						  bufszincr,
 						  ( void * )drivep,
@@ -5439,7 +5439,7 @@ pi_addfile( Media_t *Mediap,
 						  &rval );
 				switch( rval ) {
 				case 0:
-					assert( nread == ( intgen_t )bufszincr );
+					assert( nread == ( int )bufszincr );
 					buflen += ( size_t )nread;
 					bufsz += bufszincr;
 					bufp = ( char * )realloc(( void * )bufp,
@@ -6136,7 +6136,7 @@ pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
 	bool_t maybeobjmissingpr;
 	bool_t maybefilemissingpr;
 	dh_t lastobjaddedh;
-	intgen_t objlistlen;
+	int objlistlen;
 
 	/* no point in proceeding if pi not begun
 	 */
@@ -6315,7 +6315,7 @@ pi_neededobjs_dir_alloc( bool_t *knownholesprp, bool_t *maybeholesprp )
 	bool_t maybeobjmissingpr;
 	bool_t maybefilemissingpr;
 	dh_t lastobjaddedh;
-	intgen_t objlistlen;
+	int objlistlen;
 
 	bagp = bag_alloc( );
 	iterp = pi_iter_alloc( );
@@ -7380,7 +7380,7 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
 static int
 set_file_owner(
 	char		 *path,
-	intgen_t	 *fdp,
+	int	 *fdp,
 	stream_context_t *strcxtp)
 {
 	bstat_t		*bstatp = &strcxtp->sc_bstat;
@@ -7441,11 +7441,11 @@ restore_reg( drive_t *drivep,
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
-	intgen_t *fdp = &strctxp->sc_fd;
-	intgen_t rval;
+	int *fdp = &strctxp->sc_fd;
+	int rval;
 	struct fsxattr fsxattr;
 	struct stat64 stat;
-	intgen_t oflags;
+	int oflags;
 
 	if ( !path )
 		return BOOL_TRUE;
@@ -7567,7 +7567,7 @@ static bool_t
 restore_extent_group( drive_t *drivep,
 		      filehdr_t *fhdrp,
 		      char *path,
-		      intgen_t fd,
+		      int fd,
 		      bool_t ehcs,
 		      rv_t *rvp )
 {
@@ -7679,9 +7679,9 @@ restore_complete_reg(stream_context_t *strcxtp)
 {
 	bstat_t *bstatp = &strcxtp->sc_bstat;
 	char *path = strcxtp->sc_path;
-	intgen_t fd = strcxtp->sc_fd;
+	int fd = strcxtp->sc_fd;
 	struct utimbuf utimbuf;
-	intgen_t rval;
+	int rval;
 
 	// only applies to regular files
 	if (!S_ISREG((strcxtp->sc_bstat.bs_mode)))
@@ -7781,7 +7781,7 @@ restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	struct utimbuf utimbuf;
 	char *printstr;
-	intgen_t rval;
+	int rval;
 
 	if ( ! path ) {
 		return BOOL_TRUE;
@@ -7949,8 +7949,8 @@ restore_symlink( drive_t *drivep,
 	drive_ops_t *dop = drivep->d_opsp;
 	extenthdr_t ehdr;
 	char *scratch;
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 	rv_t rv;
 	mode_t oldumask;
 
@@ -8087,8 +8087,8 @@ read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs )
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 	filehdr_t tmpfh;
 
 	nread = read_buf( ( char * )&tmpfh,
@@ -8146,8 +8146,8 @@ read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs )
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 	extenthdr_t tmpeh;
 
 	nread = read_buf( ( char * )&tmpeh,
@@ -8209,8 +8209,8 @@ read_dirent( drive_t *drivep,
 	global_hdr_t *grhdrp = drivep->d_greadhdrp;
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 	direnthdr_t tmpdh;
 	char *namep;    // beginning of name following the direnthdr_t
 
@@ -8331,8 +8331,8 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 	extattrhdr_t tmpah;
 
 	nread = read_buf( ( char * )&tmpah,
@@ -8364,8 +8364,8 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 	mlog( MLOG_NITTY,
 	      "read extattr hdr sz %u valoff %u flags 0x%x valsz %u cs 0x%x\n",
 	      ahdrp->ah_sz,
-	      ( u_intgen_t )ahdrp->ah_valoff,
-	      ( u_intgen_t )ahdrp->ah_flags,
+	      ( u_int )ahdrp->ah_valoff,
+	      ( u_int )ahdrp->ah_flags,
 	      ahdrp->ah_valsz,
 	      ahdrp->ah_checksum );
 
@@ -8403,8 +8403,8 @@ discard_padding( size_t sz, drive_t *drivep )
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 
 	nread = read_buf( 0,
 			  sz,
@@ -8489,8 +8489,8 @@ restore_extent( filehdr_t *fhdrp,
 		char *bufp;
 		size_t req_bufsz;	/* requested bufsz */
 		size_t sup_bufsz;	/* supplied bufsz */
-		intgen_t nwritten;
-		intgen_t rval;
+		int nwritten;
+		int rval;
 		size_t ntowrite;
 
 		req_bufsz = ( size_t )min( ( off64_t )INTGENMAX, sz );
@@ -8549,7 +8549,7 @@ restore_extent( filehdr_t *fhdrp,
 			if ( fd != -1 ) {
 				size_t tries;
 				size_t remaining;
-				intgen_t rval;
+				int rval;
 				off64_t tmp_off;
 
 				rval = 0; /* for lint */
@@ -8558,7 +8558,7 @@ restore_extent( filehdr_t *fhdrp,
 				      remaining = ntowrite,
 				      tmp_off = off
 				      ;
-				      nwritten < ( intgen_t )ntowrite
+				      nwritten < ( int )ntowrite
 				      &&
 				      tries < WRITE_TRIES_MAX
 				      ;
@@ -8634,7 +8634,7 @@ restore_extent( filehdr_t *fhdrp,
 					}
 				}
 			} else {
-				nwritten = ( intgen_t )ntowrite;
+				nwritten = ( int )ntowrite;
 			}
 		} else {
 			nwritten = 0;
@@ -8664,7 +8664,7 @@ restore_extent( filehdr_t *fhdrp,
 			 */
 			fd = -1;
 			assert( ntowrite <= ( size_t )INTGENMAX );
-			nwritten = ( intgen_t )ntowrite;
+			nwritten = ( int )ntowrite;
 		}
 		sz -= ( off64_t )sup_bufsz;
 		off += ( off64_t )nwritten;
@@ -8737,8 +8737,8 @@ restore_extattr( drive_t *drivep,
 	for ( ; ; ) {
 		size_t recsz;
 		/* REFERENCED */
-		intgen_t nread;
-		intgen_t rval;
+		int nread;
+		int rval;
 		rv_t rv;
 
 		rv = read_extattrhdr( drivep, ahdrp, ahcs );
@@ -8775,7 +8775,7 @@ restore_extattr( drive_t *drivep,
 		default:
 			return RV_CORE;
 		}
-		assert( nread == ( intgen_t )( recsz - EXTATTRHDR_SZ ));
+		assert( nread == ( int )( recsz - EXTATTRHDR_SZ ));
 
 		if ( ! persp->a.restoreextattrpr && ! persp->a.restoredmpr ) {
 			continue;
@@ -8853,7 +8853,7 @@ setextattr( char *path, extattrhdr_t *ahdrp )
 	bool_t issecurepr = ahdrp->ah_flags & EXTATTRHDR_FLAGS_SECURE;
 	bool_t isdmpr;
 	int attr_namespace;
-	intgen_t rval;
+	int rval;
 
 	isdmpr = ( isrootpr &&
 		   !strncmp((char *)(&ahdrp[1]), dmiattr, sizeof(dmiattr)-1) );
@@ -8875,7 +8875,7 @@ setextattr( char *path, extattrhdr_t *ahdrp )
 	rval = attr_set( path,
 			 ( char * )( &ahdrp[ 1 ] ),
 			 ( ( char * )ahdrp ) + ( u_long_t )ahdrp->ah_valoff,
-			 ( intgen_t )ahdrp->ah_valsz,
+			 ( int )ahdrp->ah_valsz,
 			 attr_namespace | ATTR_DONTFOLLOW );
 	if ( rval ) {
 		char *namespace;
@@ -9291,7 +9291,7 @@ pi_show( char *introstring )
 {
 	char strbuf[ 100 ];
 	/* REFERENCED */
-	intgen_t strbuflen;
+	int strbuflen;
 	fold_t fold;
 
 	if ( mlog_level_ss[ MLOG_SS_MEDIA ] < MLOG_NITTY + 1 ) {
@@ -9323,7 +9323,7 @@ static void
 pi_show_nomloglock( void )
 {
 	dh_t strmh;
-	intgen_t strmix;
+	int strmix;
 
 
 	/* no point in proceeding if pi not begun
@@ -9345,7 +9345,7 @@ pi_show_nomloglock( void )
 	      ;
 	      strmh = DH2S( strmh )->s_nexth, strmix++ ) {
 		dh_t objh;
-		intgen_t objix;
+		int objix;
 
 		mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 		      _("\nmedia stream %u:\n"),
@@ -9503,7 +9503,7 @@ pi_show_nomloglock( void )
 	}
 }
 
-static intgen_t
+static int
 egrpcmp( egrp_t *egrpap, egrp_t *egrpbp )
 {
 	if ( egrpap->eg_ino < egrpbp->eg_ino ) {
@@ -9521,7 +9521,7 @@ egrpcmp( egrp_t *egrpap, egrp_t *egrpbp )
 
 static void
 display_dump_label( bool_t lockpr,
-		    intgen_t mllevel,
+		    int mllevel,
 		    char *introstr,
 		    global_hdr_t *grhdrp,
 		    media_hdr_t *mrhdrp,
diff --git a/restore/dirattr.c b/restore/dirattr.c
index a15abe5..d8d5140 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -261,7 +261,7 @@ dirattr_init( char *hkdir, bool_t resume, u_int64_t dircnt )
 		{
 		bool_t successpr;
 		unsigned int ioctlcmd;
-		intgen_t loglevel;
+		int loglevel;
 		size_t trycnt;
 
 		for ( trycnt = 0,
@@ -276,7 +276,7 @@ dirattr_init( char *hkdir, bool_t resume, u_int64_t dircnt )
 		      loglevel = max( MLOG_NORMAL, loglevel - 1 )) {
 			off64_t initsz;
 			struct flock64 flock64;
-			intgen_t rval;
+			int rval;
 
 			if ( ! ioctlcmd ) {
 				continue;
@@ -354,7 +354,7 @@ void
 dirattr_cleanup( void )
 {
 	/* REFERENCED */
-	intgen_t rval;
+	int rval;
 
 	if ( ! dtp ) {
 		return;
@@ -474,8 +474,8 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 	off64_t off;
 	off64_t seekoff;
 	off64_t nulloff;
-	intgen_t nread;
-	intgen_t nwritten;
+	int nread;
+	int nwritten;
 
 	/* pull the selected dir attributes into the cache
 	 */
@@ -527,7 +527,7 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 		nread = read( dtp->dt_extattrfd,
 			      ( void * )&off,
 			      sizeof( off ));
-		if ( nread != ( intgen_t )sizeof( off )) {
+		if ( nread != ( int )sizeof( off )) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not read extended attributes "
 			      "file %s: "
@@ -558,7 +558,7 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 	nwritten = write( dtp->dt_extattrfd,
 			  ( void * )&nulloff,
 			  sizeof( nulloff ));
-	if ( nwritten != ( intgen_t )sizeof( nulloff )) {
+	if ( nwritten != ( int )sizeof( nulloff )) {
 		mlog( MLOG_NORMAL | MLOG_WARNING, _(
 		      "could not write extended attributes "
 		      "file %s: "
@@ -570,7 +570,7 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 		return;
 	}
 	nwritten = write( dtp->dt_extattrfd, ( void * )ahdrp, ahdrp->ah_sz );
-	if ( nwritten != ( intgen_t )( ahdrp->ah_sz )) {
+	if ( nwritten != ( int )( ahdrp->ah_sz )) {
 		mlog( MLOG_NORMAL | MLOG_WARNING, _(
 		      "could not write at end of extended attributes "
 		      "file %s: "
@@ -605,7 +605,7 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 		nwritten = write( dtp->dt_extattrfd,
 				  ( void * )&off,
 				  sizeof( off ));
-		if ( nwritten != ( intgen_t )sizeof( off )) {
+		if ( nwritten != ( int )sizeof( off )) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not write extended attributes "
 			      "file %s: "
@@ -659,7 +659,7 @@ dirattr_cb_extattr( dah_t dah,
 	off = dtp->dt_cached_dirattr.d_extattroff;
 	while ( off != DIRATTR_EXTATTROFFNULL ) {
 		off64_t seekoff;
-		intgen_t nread;
+		int nread;
 		off64_t nextoff;
 		size_t recsz;
 		bool_t ok;
@@ -685,7 +685,7 @@ dirattr_cb_extattr( dah_t dah,
 		nread = read( dtp->dt_extattrfd,
 			      ( void * )&nextoff,
 			      sizeof( nextoff ));
-		if ( nread != ( intgen_t )sizeof( nextoff )) {
+		if ( nread != ( int )sizeof( nextoff )) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not read extended attributes "
 			      "file %s: "
@@ -721,7 +721,7 @@ dirattr_cb_extattr( dah_t dah,
 		nread = read( dtp->dt_extattrfd,
 			      ( void * )&ahdrp[ 1 ],
 			      recsz - EXTATTRHDR_SZ );
-		if ( nread != ( intgen_t )( recsz - EXTATTRHDR_SZ )) {
+		if ( nread != ( int )( recsz - EXTATTRHDR_SZ )) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not read extended attributes "
 			      "file %s: "
@@ -758,7 +758,7 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
 	off64_t argoff;
 	off64_t newoff;
 	dirattr_t dirattr;
-	intgen_t nwritten;
+	int nwritten;
 
 	/* sanity checks
 	 */
@@ -958,7 +958,7 @@ dirattr_get( dah_t dah )
 	dix_t dix;
 	off64_t argoff;
 	off64_t newoff;
-	intgen_t nread;
+	int nread;
 #ifdef DIRATTRCHK
 	u_int16_t sum;
 #endif /* DIRATTRCHK */
@@ -1040,7 +1040,7 @@ dirattr_cacheflush( void )
 #endif /* DIRATTRCHK */
 	off64_t argoff;
 	off64_t newoff;
-	intgen_t nwritten;
+	int nwritten;
 
 	/* sanity checks
 	 */
diff --git a/restore/inomap.c b/restore/inomap.c
index e5bcb55..f1604c4 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -77,8 +77,8 @@ extern size_t pgsz;
 
 /* inomap primitives
  */
-static intgen_t map_getset( xfs_ino_t, intgen_t, bool_t );
-static intgen_t map_set( xfs_ino_t ino, intgen_t );
+static int map_getset( xfs_ino_t, int, bool_t );
+static int map_set( xfs_ino_t ino, int );
 static seg_t * map_getsegment( xfs_ino_t ino );
 
 /* definition of locally defined global variables ****************************/
@@ -86,7 +86,7 @@ static seg_t * map_getsegment( xfs_ino_t ino );
 
 /* definition of locally defined static variables *****************************/
 
-static intgen_t pers_fd = -1;
+static int pers_fd = -1;
 	/* file descriptor for persistent inomap backing store
 	 */
 
@@ -103,7 +103,7 @@ static xfs_ino_t last_ino_added;
  */
 
 static inline void
-SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, intgen_t state )
+SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
 {
 	register xfs_ino_t relino;
 	register u_int64_t mask;
@@ -155,10 +155,10 @@ SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, intgen_t state )
 	}
 }
 
-static inline intgen_t
+static inline int
 SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
 {
-	intgen_t state;
+	int state;
 	register xfs_ino_t relino;
 	register u_int64_t mask;
 	relino = ino - segp->base;
@@ -190,12 +190,12 @@ inomap_restore_pers( drive_t *drivep,
 	pers_t *persp;
 	hnk_t *pershnkp;
 	hnk_t *tmphnkp;
-	intgen_t fd;
+	int fd;
 	/* REFERENCED */
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 	/* REFERENCED */
-	intgen_t rval1;
+	int rval1;
 	int i;
 	bool_t ok;
 
@@ -312,8 +312,8 @@ inomap_discard( drive_t *drivep, content_inode_hdr_t *scrhdrp )
 	drive_ops_t *dop = drivep->d_opsp;
 	u_int64_t tmphnkcnt;
 	/* REFERENCED */
-	intgen_t nread;
-	intgen_t rval;
+	int nread;
+	int rval;
 
 	/* get inomap info from media hdr
 	 */
@@ -411,7 +411,7 @@ inomap_sync_pers( char *hkdir )
 	 */
 	for ( hnkp = roothnkp
 	      ;
-	      hnkp < roothnkp + ( intgen_t )hnkcnt - 1
+	      hnkp < roothnkp + ( int )hnkcnt - 1
 	      ;
 	      hnkp++ ) {
 		hnkp->nextp = hnkp + 1;
@@ -422,7 +422,7 @@ inomap_sync_pers( char *hkdir )
 	 */
 	tailhnkp = hnkp;
 	assert( hnkcnt > 0 );
-	lastsegp = &tailhnkp->seg[ ( intgen_t )( segcnt
+	lastsegp = &tailhnkp->seg[ ( int )( segcnt
 						 -
 						 SEGPERHNK * ( hnkcnt - 1 )
 						 -
@@ -472,7 +472,7 @@ inomap_sanitize( void )
 			      ino < segp->base + INOPERSEG
 			      ;
 			      ino++ ) {
-				intgen_t state;
+				int state;
 				if ( ino > last_ino_added ) {
 					return;
 				}
@@ -552,7 +552,7 @@ begin:
 			return BOOL_FALSE;
 		}
 		for ( ino = segp->base ; ino < segp->base + INOPERSEG ; ino++ ){
-			intgen_t state;
+			int state;
 			if ( ino < firstino ) {
 				continue;
 			}
@@ -584,7 +584,7 @@ begin:
  * returns FALSE.
  */
 void
-inomap_cbiter( intgen_t statemask,
+inomap_cbiter( int statemask,
 	       bool_t ( * cbfunc )( void *ctxp, xfs_ino_t ino ),
 	       void *ctxp )
 {
@@ -612,7 +612,7 @@ inomap_cbiter( intgen_t statemask,
 			      ino < segp->base + INOPERSEG
 			      ;
 			      ino++ ) {
-				intgen_t state;
+				int state;
 				if ( ino > last_ino_added ) {
 					return;
 				}
@@ -634,10 +634,10 @@ inomap_cbiter( intgen_t statemask,
 /* map_getset - locates and gets the state of the specified ino,
  * and optionally sets the state to a new value.
  */
-static intgen_t
-map_getset( xfs_ino_t ino, intgen_t newstate, bool_t setflag )
+static int
+map_getset( xfs_ino_t ino, int newstate, bool_t setflag )
 {
-	intgen_t state;
+	int state;
 	seg_t *segp;
 
 	if ((segp = map_getsegment( ino )) == NULL) {
@@ -709,10 +709,10 @@ map_getsegment( xfs_ino_t ino )
 	return NULL;
 }
 
-static intgen_t
-map_set( xfs_ino_t ino, intgen_t state )
+static int
+map_set( xfs_ino_t ino, int state )
 {
-	intgen_t oldstate;
+	int oldstate;
 
  	oldstate = map_getset( ino, state, BOOL_TRUE );
 	return oldstate;
diff --git a/restore/inomap.h b/restore/inomap.h
index f208199..bc40f3e 100644
--- a/restore/inomap.h
+++ b/restore/inomap.h
@@ -79,7 +79,7 @@ extern bool_t inomap_rst_needed( xfs_ino_t begino, xfs_ino_t endino );
 extern void inomap_rst_add( xfs_ino_t ino );
 extern void inomap_rst_del( xfs_ino_t ino );
 extern rv_t inomap_discard( drive_t *drivep, content_inode_hdr_t *scrhdrp );
-extern void inomap_cbiter( intgen_t mapstatemask,
+extern void inomap_cbiter( int mapstatemask,
 			   bool_t ( * cbfunc )( void *ctxp, xfs_ino_t ino ),
 			   void *ctxp );
 
diff --git a/restore/namreg.c b/restore/namreg.c
index 18ba6d9..8c3b74f 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -176,7 +176,7 @@ namreg_init( char *hkdir, bool_t resume, u_int64_t inocnt )
 		{
 		bool_t successpr;
 		unsigned int ioctlcmd;
-		intgen_t loglevel;
+		int loglevel;
 		size_t trycnt;
 
 		for ( trycnt = 0,
@@ -191,7 +191,7 @@ namreg_init( char *hkdir, bool_t resume, u_int64_t inocnt )
 		      loglevel = max( MLOG_NORMAL, loglevel - 1 )) {
 			off64_t initsz;
 			struct flock64 flock64;
-			intgen_t rval;
+			int rval;
 
 			if ( ! ioctlcmd ) {
 				continue;
@@ -364,13 +364,13 @@ namreg_flush( void )
 	return RV_OK;
 }
 
-intgen_t
+int
 namreg_get( nrh_t nrh,
 	    char *bufp,
 	    size_t bufsz )
 {
 	off64_t newoff;
-	intgen_t nread;
+	int nread;
 	size_t len;
 	char *in_bufp;
 	static char read_buf[256];
@@ -479,7 +479,7 @@ namreg_get( nrh_t nrh,
 	
 	unlock( );
 
-	return ( intgen_t )len;
+	return ( int )len;
 }
 
 rv_t
diff --git a/restore/namreg.h b/restore/namreg.h
index 11004b6..8bc7b53 100644
--- a/restore/namreg.h
+++ b/restore/namreg.h
@@ -61,6 +61,6 @@ extern rv_t namreg_map( void );
  * small to fit the null-terminated name. return -2 if the name
  * not in the registry. return -3 if a system call fails.
  */
-extern intgen_t namreg_get( nrh_t nrh, char *bufp, size_t bufsz );
+extern int namreg_get( nrh_t nrh, char *bufp, size_t bufsz );
 
 #endif /* NAMREG_H */
diff --git a/restore/node.c b/restore/node.c
index 046f2f6..92a21ce 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -111,7 +111,7 @@ extern size_t pgmask;
  */
 #define NODE_HDRSZ	pgsz
 
-typedef intgen_t relnix_t;
+typedef int relnix_t;
 
 struct node_hdr {
 	size_t nh_nodesz;
@@ -144,7 +144,7 @@ struct node_hdr {
 	nh_t nh_virgnh;
 		/* handle of next virgin node
 		 */
-	intgen_t nh_segixshift;
+	int nh_segixshift;
 		/* bitshift used to extract the segment index from an nh_t
 		 */
 	relnix_t nh_relnixmask;
@@ -156,7 +156,7 @@ struct node_hdr {
 typedef struct node_hdr node_hdr_t;
 
 static node_hdr_t *node_hdrp;
-static intgen_t node_fd;
+static int node_fd;
 
 static inline segix_t
 nh2segix( nh_t nh )
@@ -227,7 +227,7 @@ node_unmap_internal( nh_t nh, void **pp, bool_t freepr )
 
 /* ARGSUSED */
 bool_t
-node_init( intgen_t fd,
+node_init( int fd,
 	   off64_t off,
 	   size_t usrnodesz,
 	   ix_t nodehkix,
@@ -241,7 +241,7 @@ node_init( intgen_t fd,
 	size_t max_segments;
 	size_t winmapmax;
 	size_t segcount;
-	intgen_t segixshift;
+	int segixshift;
 
 	/* sanity checks
 	 */
@@ -395,7 +395,7 @@ node_init( intgen_t fd,
 }
 
 bool_t
-node_sync( intgen_t fd, off64_t off )
+node_sync( int fd, off64_t off )
 {
 	/* sanity checks
 	 */
@@ -472,7 +472,7 @@ node_alloc( void )
 	} else {
 		if ( nh2relnix( node_hdrp->nh_virgnh ) == 0 ) {
 			/* need to start a new virgin segment */
-			intgen_t rval;
+			int rval;
 			off64_t new_seg_off =
 				node_hdrp->nh_firstsegoff +
 				( off64_t )nh2segix( node_hdrp->nh_virgnh ) *
diff --git a/restore/node.h b/restore/node.h
index ba98d49..25fdaad 100644
--- a/restore/node.h
+++ b/restore/node.h
@@ -29,7 +29,7 @@ typedef size32_t nh_t;
 /* node_init - creates a new node abstraction.
  * user reserves one byte per node for use by the node abstraction
  */
-extern bool_t node_init( intgen_t fd,		/* backing store */
+extern bool_t node_init( int fd,		/* backing store */
 		         off64_t off,		/* offset into backing store */
 		         size_t nodesz,		/* node size */
 		         ix_t nodehkix,		/* my housekeeping byte */
@@ -39,7 +39,7 @@ extern bool_t node_init( intgen_t fd,		/* backing store */
 
 /* node_sync - syncs up with existing node abstraction persistent state
  */
-extern bool_t node_sync( intgen_t fd, off64_t off );
+extern bool_t node_sync( int fd, off64_t off );
 
 /* node_alloc - allocates a node, returning a handle.
  * returns NULL handle if no space left.
diff --git a/restore/tree.c b/restore/tree.c
index 98f6952..46ba715 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -156,7 +156,7 @@ struct tran {
 		/* if non-NULL, is path of hkdir relative to dstdir.
 		 * don't restore there.
 		 */
-	intgen_t t_persfd;
+	int t_persfd;
 		/* file descriptor of the persistent state file
 		 */
 	nh_t *t_hashp;
@@ -253,7 +253,7 @@ typedef struct link_iter_context link_iter_context_t;
  */
 struct path_cache {
 	nh_t nh;
-	intgen_t len;
+	int len;
 	char buf[MAXPATHLEN];
 };
 typedef struct path_cache path_cache_t;
@@ -275,8 +275,8 @@ static nh_t Node_alloc( xfs_ino_t ino,
 static void Node_free( nh_t *nhp );
 static node_t * Node_map( nh_t nh );
 static void Node_unmap( nh_t nh, node_t **npp );
-static intgen_t Node2path_recurse( nh_t nh, char *buf,
-				   intgen_t bufsz, intgen_t level );
+static int Node2path_recurse( nh_t nh, char *buf,
+				   int bufsz, int level );
 static void adopt( nh_t parh, nh_t cldh, nrh_t nrh );
 static nrh_t disown( nh_t cldh );
 static void selsubtree( nh_t nh, bool_t sensepr );
@@ -355,7 +355,7 @@ tree_init( char *hkdir,
 	off64_t nodeoff;
 	char *perspath;
 	bool_t ok;
-	intgen_t rval;
+	int rval;
 
 	/* sanity checks
 	 */
@@ -539,7 +539,7 @@ tree_sync( char *hkdir,
 	off64_t nodeoff;
 	char *perspath;
 	bool_t ok;
-	intgen_t rval;
+	int rval;
 
 	if ( persp ) {
 		return BOOL_TRUE;
@@ -874,7 +874,7 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
 			nh_t renameh;
 			node_t *renamep;
 			/* REFERENCED */
-			intgen_t namebuflen; 
+			int namebuflen; 
 
 			hardp->n_flags |= NF_REFED;
 			if ( hardp->n_parh == persp->p_orphh ) {
@@ -1283,7 +1283,7 @@ noref_elim_recurse( nh_t parh,
 		nh_t renameh;
 		nh_t grandcldh;
 		nh_t nextcldh;
-		intgen_t rval;
+		int rval;
 		bool_t ok;
 
 		cldp = Node_map( cldh );
@@ -1600,7 +1600,7 @@ mkdirs_recurse( nh_t parh, nh_t cldh, char *path )
 		/* if needed, create a directory and update real flag
 		 */
 		if ( isdirpr && ! isrealpr && isrefpr && isselpr ) {
-			intgen_t rval;
+			int rval;
 
 			if ( ! Node2path( cldh, path, _("makedir") )) {
 				cldh = nextcldh;
@@ -1674,7 +1674,7 @@ rename_dirs( nh_t cldh,
 
 		if ( isrenamepr ) {
 			node_t *renamep;
-			intgen_t rval;
+			int rval;
 			/* REFERENCED */
 			nrh_t dummynrh;
 			bool_t ok;
@@ -2015,8 +2015,8 @@ tree_adjref_recurse( nh_t cldh,
 		if ( ! pardumpedpr && parrefedpr ) {
 			cldp->n_flags |= NF_REFED;
 		}
-		clddumpedpr = ( intgen_t )cldp->n_flags & NF_DUMPEDDIR;
-		cldrefedpr = ( intgen_t )cldp->n_flags & NF_REFED;
+		clddumpedpr = ( int )cldp->n_flags & NF_DUMPEDDIR;
+		cldrefedpr = ( int )cldp->n_flags & NF_REFED;
 		grandcldh = cldp->n_cldh;
 		Node_unmap( cldh, &cldp  );
 	}
@@ -2177,7 +2177,7 @@ proc_hardlinks_cb( void *contextp, nh_t hardheadh )
 	nh_t nh;
 	link_iter_context_t link_iter_context;
 	bool_t ok;
-	intgen_t rval;
+	int rval;
 
 	/* skip directories
 	 */
@@ -2525,10 +2525,10 @@ setdirattr( dah_t dah, char *path )
 	mode_t mode;
 	struct utimbuf utimbuf;
 	struct fsxattr fsxattr;
-	intgen_t rval;
+	int rval;
 	size_t	hlen;
 	void	*hanp;
-	intgen_t fd = -1;
+	int fd = -1;
 
 	if ( dah == DAH_NULL )
 		return;
@@ -2642,7 +2642,7 @@ setdirattr( dah_t dah, char *path )
 bool_t
 tree_delorph( void )
 {
-	intgen_t rval;
+	int rval;
 
 	rval = rmdir( tranp->t_orphdir );
 	if ( rval ) {
@@ -2851,7 +2851,7 @@ tsi_cmd_pwd_recurse( void *ctxp,
 	node_t *np;
 	register nh_t parh;
 	/* REFERENCED */
-	register intgen_t namelen;
+	register int namelen;
 	nrh_t nrh;
 
 	assert( nh != NH_NULL );
@@ -2937,7 +2937,7 @@ tsi_cmd_ls( void *ctxp,
 		Node_unmap( cldh, &cldp );
 		if ( cldh != persp->p_orphh ) {
 			/* REFERENCED */
-			intgen_t namelen;
+			int namelen;
 			namelen = namreg_get( nrh,
 					      tranp->t_inter.i_name,
 					      sizeof( tranp->t_inter.i_name ));
@@ -3351,7 +3351,7 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
 			nh_t nextsibh;
 			nrh_t nrh;
 			/* REFERENCED */
-			intgen_t siblen;
+			int siblen;
 
 			sibp = Node_map( sibh );
 			nrh = sibp->n_nrh;
@@ -3484,7 +3484,7 @@ Node_unmap( nh_t nh, node_t **npp )
 static bool_t
 Node2path( nh_t nh, char *path, char *errmsg )
 {
-	intgen_t remainingcnt;
+	int remainingcnt;
 	strcpy(path, "."); /* in case root node passed in */
 	remainingcnt = Node2path_recurse( nh, path, MAXPATHLEN, 0 );
 	if ( remainingcnt <= 0 ) {
@@ -3509,8 +3509,8 @@ Node2path( nh_t nh, char *path, char *errmsg )
  * MAXPATHLEN. always null-terminates, but null char not counted in return.
  * works because the buffer size is secretly 2 * MAXPATHLEN.
  */
-static intgen_t
-Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz, intgen_t level )
+static int
+Node2path_recurse( nh_t nh, char *buf, int bufsz, int level )
 {
 	static __thread path_cache_t cache = { NH_NULL, 0, "" };
 	node_t *np;
@@ -3519,8 +3519,8 @@ Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz, intgen_t level )
 	gen_t gen;
 	nrh_t nrh;
 	char *oldbuf;
-	intgen_t oldbufsz;
-	intgen_t namelen;
+	int oldbufsz;
+	int namelen;
 
 	/* recursion termination
 	 */
@@ -3869,7 +3869,7 @@ link_matchh( nh_t hardh, nh_t parh, char *name )
 		np = Node_map( hardh );
 		if ( np->n_parh == parh ) {
 			/* REFERENCED */
-			intgen_t namelen;
+			int namelen;
 			namelen = namreg_get( np->n_nrh,
 					      tranp->t_namebuf,
 					      sizeof( tranp->t_namebuf ));
@@ -4462,7 +4462,7 @@ Node_chk( nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp )
 	}
 
 	if ( n.n_nrh != NRH_NULL ) {
-		intgen_t rval;
+		int rval;
 		rval = namreg_get( n.n_nrh, nambuf, sizeof( nambuf ));
 		assert( rval >= 0 );
 	}
@@ -4573,7 +4573,7 @@ tree_chk2_recurse( nh_t cldh, nh_t parh )
 		} else if ( cldh == persp->p_orphh ) {
 			sprintf( tranp->t_namebuf, "%llu.%u", ino, gen );
 		} else {
-			intgen_t namelen;
+			int namelen;
 			namelen = namreg_get( nrh,
 					      tranp->t_namebuf,
 					      sizeof( tranp->t_namebuf ));
diff --git a/restore/win.c b/restore/win.c
index 3ca2af8..e6c0be3 100644
--- a/restore/win.c
+++ b/restore/win.c
@@ -78,7 +78,7 @@ static void win_segmap_resize( segix_t segix );
 /* transient state
  */
 struct tran {
-	intgen_t t_fd;
+	int t_fd;
 		/* file descriptor of backing store to be windowed
 		 */
 	off64_t t_firstoff;
@@ -149,7 +149,7 @@ win_getnum_mmaps(void)
 }
 
 void
-win_init( intgen_t fd,
+win_init( int fd,
 	  off64_t firstoff,
 	  size64_t segsz,
 	  size_t winmax )
@@ -250,7 +250,7 @@ win_map( segix_t segix, void **pp )
 		tranp->t_wincnt++;
 	} else if ( tranp->t_lruheadp ) {
 		/* REFERENCED */
-		intgen_t rval;
+		int rval;
 #ifdef TREE_DEBUG
 		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
 		     "win_map(): get head from lru freelist & unmap\n");
diff --git a/restore/win.h b/restore/win.h
index 50d1dcc..a6bd002 100644
--- a/restore/win.h
+++ b/restore/win.h
@@ -21,11 +21,11 @@
 /* win.[ch] - windows into a very large file
  */
 
-typedef intgen_t segix_t;
+typedef int segix_t;
 
 /* initialize the window abstraction
  */
-void win_init( intgen_t fd,
+void win_init( int fd,
 	       off64_t rngoff,		/* offset into file of windowing */
 	       size64_t winsz,		/* window size */
 	       size_t wincntmax );	/* max number of windows to manage */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
