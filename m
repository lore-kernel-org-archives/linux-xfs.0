Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ULlGYf159382 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 16:47:16 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: remove unnecessary #ifdefs
Date: Tue, 30 Aug 2011 16:47:04 -0500
Message-Id: <1314740824-4231-1-git-send-email-wkendall@sgi.com>
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

There are a number of #defines in xfsdump that are always enabled and
no longer need to be conditional code. This patch removes the
following macros and enables the related code unconditionally:

- SIZEEST is required for multi-stream dumps for determining split
  points.

- RMT, BASED and SESSCPLT are tied to command line options
  (dump/restore -m, dump -B and restore -Q, respectively).

- INVCONVFIX, PIPEINVFIX, and EOMFIX are all related to fixes that
  went in a long time ago.

- WHITEPARSE allows for filenames with spaces and special chars to be
  properly parsed during an interactive restore session.

- DOSOCKS allows Unix domain sockets to be backed up and restored.
  Other special files (block/char devs, FIFOs) are always backed up,
  so do the same for sockets.

Additionally the definition of F_FSSETDM has been removed from
restore/Makefile since it is never referenced.
---
 common/drive_minrmt.c   |   12 ------
 common/drive_scsitape.c |   12 ------
 common/drive_simple.c   |    2 -
 common/main.c           |    4 --
 dump/Makefile           |    2 +-
 dump/content.c          |   46 ------------------------
 dump/inomap.c           |    2 -
 dump/inomap.h           |    2 -
 inventory/inv_stobj.c   |   11 ------
 invutil/Makefile        |    4 +--
 restore/Makefile        |    4 +--
 restore/content.c       |   89 ++++++++--------------------------------------
 restore/dirattr.c       |    2 -
 restore/namreg.c        |    2 -
 restore/tree.c          |   33 -----------------
 15 files changed, 19 insertions(+), 208 deletions(-)

diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index e76345e..836b663 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -57,7 +57,6 @@
 
 /* remote tape protocol debug
  */
-#ifdef RMT
 #ifdef RMTDBG
 #define	open(p,f)		dbgrmtopen(p,f)
 #define	close(fd)		dbgrmtclose(fd)
@@ -71,7 +70,6 @@
 #define	read rmtread
 #define	write rmtwrite
 #endif /* RMTDBG */
-#endif /* RMT */
 
 /* if the media file header structure changes, this number must be
  * bumped, and STAPE_VERSION_1 must be defined and recognized.
@@ -242,21 +240,17 @@ typedef struct drive_context drive_context_t;
 
 extern void usage( void );
 #ifdef DUMP
-#ifdef SIZEEST
 extern u_int64_t hdr_mfilesz;
-#endif /* SIZEEST */
 #endif /* DUMP */
 
 /* remote tape protocol declarations (should be a system header file)
  */
-#ifdef RMT
 extern int rmtopen( char *, int, ... );
 extern int rmtclose( int );
 extern int rmtfstat( int, struct stat * );
 extern int rmtioctl( int, int, ... );
 extern int rmtread( int, void*, uint);
 extern int rmtwrite( int, const void *, uint);
-#endif /* RMT */
 
 
 /* forward declarations of locally defined static functions ******************/
@@ -345,7 +339,6 @@ static bool_t isxfsdumperasetape( drive_t *drivep );
 
 /* RMT trace stubs
  */
-#ifdef RMT
 #ifdef RMTDBG
 static int dbgrmtopen( char *, int );
 static int dbgrmtclose( int );
@@ -353,7 +346,6 @@ static int dbgrmtioctl( int, int, void * );
 static int dbgrmtread( int, void *, uint);
 static int dbgrmtwrite( int, void *, uint);
 #endif /* RMTDBG */
-#endif /* RMT */
 
 #define ERASE_MAGIC "$^*@++! This tape was quick erased by SGI xfsdump $^*@++!"
 
@@ -2760,7 +2752,6 @@ set_recommended_sizes( drive_t *drivep )
 	if (contextp->dc_filesz > 0) {
 		fsize = contextp->dc_filesz;
 #ifdef DUMP
-#ifdef SIZEEST
 		if ( hdr_mfilesz > fsize ) {
 			mlog( MLOG_WARNING, _(
 			      "recommended media file size of %llu Mb less than "
@@ -2769,7 +2760,6 @@ set_recommended_sizes( drive_t *drivep )
 			      hdr_mfilesz / ( 1024 * 1024 ),
 			      drivep->d_pathname );
 		}
-#endif /* SIZEEST */
 #endif /* DUMP */
 	}
 
@@ -2964,7 +2954,6 @@ tape_rec_checksum_check( drive_context_t *contextp, char *bufp )
 
 /* to trace rmt operations
  */
-#ifdef RMT
 #ifdef RMTDBG
 static int
 dbgrmtopen( char *path, int flags )
@@ -3039,7 +3028,6 @@ dbgrmtwrite( int fd, void *p, uint sz )
 	return rval;
 }
 #endif /* RMTDBG */
-#endif /* RMT */
 
 /* display_access_failed_message()
  *	Print tape device open/access failed message.
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index e436eb1..8c1bd49 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -53,7 +53,6 @@
 
 /* remote tape protocol debug
  */
-#ifdef RMT
 #ifdef RMTDBG
 #define	open(p,f)		dbgrmtopen(p,f)
 #define	close(fd)		dbgrmtclose(fd)
@@ -67,7 +66,6 @@
 #define	read rmtread
 #define	write rmtwrite
 #endif /* RMTDBG */
-#endif /* RMT */
 
 /* if the media file header structure changes, this number must be
  * bumped, and STAPE_VERSION_1 must be defined and recognized.
@@ -284,21 +282,17 @@ typedef long mtstat_t;
 
 extern void usage( void );
 #ifdef DUMP
-#ifdef SIZEEST
 extern u_int64_t hdr_mfilesz;
-#endif /* SIZEEST */
 #endif /* DUMP */
 
 /* remote tape protocol declarations (should be a system header file)
  */
-#ifdef RMT
 extern int rmtopen( char *, int, ... );
 extern int rmtclose( int );
 extern int rmtfstat( int, struct stat * );
 extern int rmtioctl( int, int, ... );
 extern int rmtread( int, void*, uint);
 extern int rmtwrite( int, const void *, uint);
-#endif /* RMT */
 
 
 /* forward declarations of locally defined static functions ******************/
@@ -390,7 +384,6 @@ static void map_ts_status( struct mtget *, struct mtget_sgi );
 
 /* RMT trace stubs
  */
-#ifdef RMT
 #ifdef RMTDBG
 static int dbgrmtopen( char *, int );
 static int dbgrmtclose( int );
@@ -398,7 +391,6 @@ static int dbgrmtioctl( int, int, void *);
 static int dbgrmtread( int, void*, uint);
 static int dbgrmtwrite( int, void *, uint);
 #endif /* RMTDBG */
-#endif /* RMT */
 
 /* definition of locally defined global variables ****************************/
 
@@ -3292,7 +3284,6 @@ set_recommended_sizes( drive_t *drivep )
 	if (contextp->dc_filesz > 0) {
 		fsize = contextp->dc_filesz;
 #ifdef DUMP
-#ifdef SIZEEST
 		if ( hdr_mfilesz > fsize ) {
 			mlog( MLOG_WARNING, _(
 			      "recommended media file size of %llu Mb less than"
@@ -3301,7 +3292,6 @@ set_recommended_sizes( drive_t *drivep )
 			      hdr_mfilesz / ( 1024 * 1024 ),
 			      drivep->d_pathname );
 		}
-#endif /* SIZEEST */
 #endif /* DUMP */
         }
 
@@ -3657,7 +3647,6 @@ tape_rec_checksum_check( drive_context_t *contextp, char *bufp )
 
 /* to trace rmt operations
  */
-#ifdef RMT
 #ifdef RMTDBG
 static int
 dbgrmtopen( char *path, int flags )
@@ -3732,7 +3721,6 @@ dbgrmtwrite( int fd, void *p, uint sz )
 	return rval;
 }
 #endif /* RMTDBG */
-#endif /* RMT */
 
 /* display_access_failed_message()
  *	Print tape device open/access failed message.
diff --git a/common/drive_simple.c b/common/drive_simple.c
index 1938619..cb88aa8 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -35,7 +35,6 @@
 #include "media.h"
 #include "arch_xlate.h"
 
-#ifdef RMT
 /* this rmt junk is here because the rmt protocol supports writing ordinary
  * (non-device) files in the remote /dev directory! yuck!
  */
@@ -52,7 +51,6 @@ extern int rmtioctl( int, int, ... );
 extern int rmtopen( char *, int, ... );
 extern int rmtread( int, void*, uint);
 extern int rmtwrite( int, const void *, uint);
-#endif
 
 
 /* drive_simple.c - drive strategy for standard in or a file
diff --git a/common/main.c b/common/main.c
index 980d2d4..55cdd93 100644
--- a/common/main.c
+++ b/common/main.c
@@ -970,9 +970,7 @@ usage( void )
 	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY );
 	ULO(_("<maximum file size>"),			GETOPT_MAXDUMPFILESIZE );
 	ULO(_("(don't dump extended file attributes)"),	GETOPT_NOEXTATTR );
-#ifdef BASED
 	ULO(_("<base dump session id>"),		GETOPT_BASED );
-#endif /* BASED */
 #ifdef REVEAL
 	ULO(_("(generate tape record checksums)"),	GETOPT_RECCHKSUM );
 #endif /* REVEAL */
@@ -1043,9 +1041,7 @@ usage( void )
 #ifdef REVEAL
 	ULO(_("(pin down I/O buffers)"),		GETOPT_RINGPIN );
 #endif /* REVEAL */
-#ifdef SESSCPLT
 	ULO(_("(force interrupted session completion)"),GETOPT_SESSCPLT );
-#endif /* SESSCPLT */
 	ULO(_("(resume)"),				GETOPT_RESUME );
 	ULO(_("<session id>"),				GETOPT_SESSIONID );
 	ULO(_("(don't timeout dialogs)"),		GETOPT_NOTIMEOUTS );
diff --git a/dump/Makefile b/dump/Makefile
index 8c6172e..ce964a0 100644
--- a/dump/Makefile
+++ b/dump/Makefile
@@ -92,7 +92,7 @@ LDIRT = $(LINKS)
 LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
 LTDEPENDENCIES = $(LIBRMT)
 
-LCFLAGS = -DDUMP -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DSIZEEST -DPIPEINVFIX
+LCFLAGS = -DDUMP
 
 default: depend $(LTCOMMAND)
 
diff --git a/dump/content.c b/dump/content.c
index 2cf15ba..1f8b326 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -386,9 +386,7 @@ static int getxfsqstat( char *fsdev );
 bool_t content_media_change_needed;
 char *media_change_alert_program = NULL;
 hsm_fs_ctxt_t *hsm_fs_ctxtp = NULL;
-#ifdef SIZEEST
 u_int64_t hdr_mfilesz = 0;
-#endif /* SIZEEST */
 u_int64_t maxdumpfilesize = 0;
 bool_t allowexcludefiles_pr = BOOL_FALSE;
 
@@ -555,12 +553,9 @@ content_init( intgen_t argc,
 	bool_t ok;
 	extern char *optarg;
 	extern int optind, opterr, optopt;
-#ifdef BASED
 	char *baseuuidstr = NULL;
 	uuid_t baseuuid;
 	bool_t baseuuidvalpr;
-#endif /* BASED */
-#ifdef SIZEEST
 	u_int64_t dircnt;
 	u_int64_t nondircnt;
 	u_int64_t datasz;
@@ -569,7 +564,6 @@ content_init( intgen_t argc,
 	u_int64_t direntsz;
 	u_int64_t filesz;
 	u_int64_t size_estimate;
-#endif /* SIZEEST */
 
 	/* basic sanity checks
 	 */
@@ -604,9 +598,7 @@ content_init( intgen_t argc,
 	optind = 1;
 	opterr = 0;
 	subtreecnt = 0;
-#ifdef BASED
 	baseuuidvalpr = BOOL_FALSE;
-#endif /* BASED */
 	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
 		switch ( c ) {
 		case GETOPT_LEVEL:
@@ -694,7 +686,6 @@ content_init( intgen_t argc,
 		case GETOPT_DUMPASOFFLINE:
 			sc_dumpasoffline = BOOL_TRUE;
 			break;
-#ifdef BASED
 		case GETOPT_BASED:
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
@@ -714,11 +705,9 @@ content_init( intgen_t argc,
 				return BOOL_FALSE;
 			}
 			baseuuidvalpr = BOOL_TRUE;
-#endif /* BASED */
 		}
 	}
 
-#ifdef BASED
 	if ( resumereqpr && baseuuidvalpr ) {
 		mlog( MLOG_NORMAL | MLOG_ERROR, _(
 		      "may not specify both -%c and -%c\n"),
@@ -726,7 +715,6 @@ content_init( intgen_t argc,
 		      GETOPT_RESUME );
 		return BOOL_FALSE;
 	}
-#endif /* BASED */
 
 	/* the user may specify stdout as the destination, by a single
 	 * dash ('-') with no option letter. This must appear between
@@ -822,20 +810,6 @@ content_init( intgen_t argc,
 			     sizeof( cwhdrtemplatep->ch_fstype ));
 	uuid_copy( cwhdrtemplatep->ch_fsid, fsid );
 
-
-#ifndef PIPEINVFIX
-
-	/* use of any pipes precludes inventory update
-	 */
-	for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
-		if ( drivepp[ strmix ]->d_isnamedpipepr
-		     ||
-		     drivepp[ strmix ]->d_isunnamedpipepr ) {
-			sc_inv_updatepr = BOOL_FALSE;
-		}
-	}
-#endif /* ! PIPEINVFIX */
-
 	/* write quota information */
 	if( sc_savequotas ) {
 
@@ -888,7 +862,6 @@ content_init( intgen_t argc,
 			     INV_SEARCH_ONLY,
 			     ( void * )&fsid );
 
-#ifdef BASED
 	/* if a based request, look for the indicated session.
 	 * if found, and not interrupted, this will be used as an
 	 * incremental base. if interrupted, will be used as
@@ -1004,7 +977,6 @@ content_init( intgen_t argc,
 		inv_idbt = INV_TOKEN_NULL;
 		goto baseuuidbypass;
 	}
-#endif /* BASED */
 
 	/* look for the most recent dump at a level less than the level
 	 * of this dump. extract the time, level, id, and predicates partial
@@ -1129,9 +1101,7 @@ content_init( intgen_t argc,
 		samefoundpr = BOOL_TRUE;
 	}
 
-#ifdef BASED
 baseuuidbypass:
-#endif /* BASED */
 
 	/* now determine the incremental and resume bases, if any.
 	 */
@@ -1535,7 +1505,6 @@ baseuuidbypass:
 	scwhdrtemplatep->cih_rootino = sc_rootxfsstatp->bs_ino;
 	inomap_writehdr( scwhdrtemplatep );
 
-#ifdef SIZEEST
 	/* log the dump size. just a rough approx.
 	 */
 	dircnt = scwhdrtemplatep->cih_inomap_dircnt;
@@ -1574,7 +1543,6 @@ baseuuidbypass:
 	      "file hdrs: %llu bytes, datasz: %llu bytes\n",
 	      GLOBAL_HDR_SZ, inomapsz, direntsz,
 	      filesz, datasz );
-#endif /* SIZEEST */
 
 	/* extract the progress stat denominators from the write hdr
 	 * template. placed there by inomap_writehdr( )
@@ -3992,9 +3960,7 @@ dump_file( void *arg1,
 	case S_IFNAM:
 #endif
 	case S_IFLNK:
-#ifdef DOSOCKS
 	case S_IFSOCK:
-#endif /* DOSOCKS */
 		/* only need a filehdr_t; no data
 		 */
 		rv = dump_file_spec( drivep, contextp, fshandlep, statp );
@@ -4005,18 +3971,6 @@ dump_file( void *arg1,
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		break; /* drop out of switch to extattr dump */
-#ifndef DOSOCKS
-	case S_IFSOCK:
-		/* don't dump these
-		 */
-		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
-			lock( );
-			sc_stat_nondirdone++;
-			unlock( );
-			contextp->cc_stat_lastino = statp->bs_ino;
-		}
-		return RV_OK;
-#endif /* ! DOSOCKS */
 	case S_IFDIR:
 	default:
 		/* don't know how to dump these
diff --git a/dump/inomap.c b/dump/inomap.c
index fcb5792..3055391 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1089,13 +1089,11 @@ inomap_init( intgen_t igrpcnt )
 	return 0;
 }
 
-#ifdef SIZEEST
 u_int64_t
 inomap_getsz( void )
 {
 	return (inomap.lastseg.hnkoff + 1) * HNKSZ;
 }
-#endif /* SIZEEST */
 
 static inline bool_t
 inomap_validaddr( seg_addr_t *addrp )
diff --git a/dump/inomap.h b/dump/inomap.h
index 4c3cfa9..ce6bd9d 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -64,9 +64,7 @@ extern bool_t inomap_build( jdm_fshandle_t *fshandlep,
 			    size64_t statcnt,
 			    size64_t *statdonep );
 
-#ifdef SIZEEST
 extern u_int64_t inomap_getsz( void );
-#endif /* SIZEEST */
 
 /* inomap_skip - tell inomap about inodes to skip in the dump
  */
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index d1d6f08..becac17 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -1287,23 +1287,16 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 {
 	inv_session_t  *ises;
 	int i, j, nmf;
-#ifdef INVCONVFIX
 	int nstreams;
 	invt_mediafile_t *mf;
-#endif /* INVCONVFIX */
 
 	ises = calloc( 1, sizeof( inv_session_t ) );
 
 	stobj_convert_session(ises, sinfo->ses, sinfo->seshdr);
 	ises->s_streams = calloc( ises->s_nstreams, sizeof( inv_stream_t ) );
-#ifdef INVCONVFIX
 	mf = sinfo->mfiles;
 	nstreams = (int) ises->s_nstreams;
 	for ( i = 0 ; i < nstreams ; i++ ) {
-#else /* INVCONVFIX */
-	i = (int) ises->s_nstreams;
-	while ( i-- ) {
-#endif /* INVCONVFIX */
 		stobj_convert_strm(&ises->s_streams[i], &sinfo->strms[i]);
 		nmf = (int) ises->s_streams[i].st_nmediafiles;
 		ises->s_streams[i].st_mediafiles = calloc( (u_int) nmf,
@@ -1311,11 +1304,7 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 
 		for ( j = 0; j < nmf; j++ ) {
 			stobj_convert_mfile( &ises->s_streams[i].st_mediafiles[j],
-#ifdef INVCONVFIX
 					     mf++ );
-#else /* INVCONVFIX */
-					     sinfo->mfiles);
-#endif /* INVCONVFIX */
 		}
 	}
 	
diff --git a/invutil/Makefile b/invutil/Makefile
index cfd6cb0..7136ee9 100644
--- a/invutil/Makefile
+++ b/invutil/Makefile
@@ -49,9 +49,7 @@ LINKS  = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 LDIRT = $(LINKS)
 LLDLIBS = $(LIBUUID) $(LIBCURSES)
 
-#LCFLAGS = -DDUMP -DRMT -DEXTATTR -DBASED -DDOSOCKS -DINVCONVFIX -DSIZEEST -DPIPEINVFIX
-LCFLAGS = -DDUMP -DBASED -DDOSOCKS -DINVCONVFIX -DSIZEEST -DPIPEINVFIX
-#LCFLAGS = -DINV_DEBUG -DDUMP -DBASED -DDOSOCKS -DINVCONVFIX -DSIZEEST -DPIPEINVFIX
+LCFLAGS = -DDUMP
 
 ifeq ($(ENABLE_CURSES), yes)
 CFILES += $(CURSESCOMMON)
diff --git a/restore/Makefile b/restore/Makefile
index 588a8f0..003ea16 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -102,9 +102,7 @@ LDIRT = $(LINKS)
 LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
 LTDEPENDENCIES = $(LIBRMT)
 
-LCFLAGS = -DRESTORE -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DPIPEINVFIX \
-	-DEOMFIX -DSESSCPLT -DWHITEPARSE \
-	-DF_FSSETDM
+LCFLAGS = -DRESTORE
 
 default: depend $(LTCOMMAND)
 
diff --git a/restore/content.c b/restore/content.c
index 25849d7..e3a9966 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -19,10 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
-#ifdef DOSOCKS
 #include <sys/socket.h>
 #include <sys/un.h>
-#endif /* DOSOCKS */
 #include <sys/mman.h>
 #include <sys/param.h>
 #include <sys/stat.h>
@@ -874,9 +872,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 	bool_t ownerpr;	/* cmd line chown/chmod requested */
 	bool_t restoredmpr; /* cmd line restore dm api attrs specification */
 	bool_t restoreextattrpr; /* cmd line restore extended attr spec */
-#ifdef SESSCPLT
 	bool_t sesscpltpr; /* force completion of prev interrupted session */
-#endif /* SESSCPLT */
 	ix_t stcnt;	/* cmd line number of subtrees requested */
 	bool_t firststsensepr;
 	bool_t firststsenseprvalpr;
@@ -938,9 +934,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 	ownerpr = BOOL_FALSE;
 	restoredmpr = BOOL_FALSE;
 	restoreextattrpr = BOOL_TRUE;
-#ifdef SESSCPLT
 	sesscpltpr = BOOL_FALSE;
-#endif /* SESSCPLT */
 	stcnt = 0;
 	firststsensepr = firststsenseprvalpr = BOOL_FALSE;
 	stsz = 0;
@@ -1159,11 +1153,9 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 		case GETOPT_NOEXTATTR:
 			restoreextattrpr = BOOL_FALSE;
 			break;
-#ifdef SESSCPLT
 		case GETOPT_SESSCPLT:
 			sesscpltpr = BOOL_TRUE;
 			break;
-#endif /* SESSCPLT */
 		case GETOPT_SMALLWINDOW:
 			/* obsolete */
 			break;
@@ -1405,7 +1397,6 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 			usage( );
 			return BOOL_FALSE;
 		}
-#ifdef SESSCPLT
 		if ( sesscpltpr ) {
 			mlog( MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c option invalid: there is no "
@@ -1414,7 +1405,6 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 			usage( );
 			return BOOL_FALSE;
 		}
-#endif /* SESSCPLT */
 	} else if ( ! persp->s.valpr ) {
 		if ( ! cumpr ) {
 			mlog( MLOG_NORMAL | MLOG_ERROR, _(
@@ -1430,7 +1420,6 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 			usage( );
 			return BOOL_FALSE;
 		}
-#ifdef SESSCPLT
 		if ( sesscpltpr ) {
 			mlog( MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c option invalid: there is no "
@@ -1439,7 +1428,6 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 			usage( );
 			return BOOL_FALSE;
 		}
-#endif /* SESSCPLT */
 		if ( existpr ) {
 			mlog( MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating "
@@ -1477,7 +1465,6 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 			return BOOL_FALSE;
 		}
 	} else {
-#ifdef SESSCPLT
 		if ( ! resumepr && ! sesscpltpr ) {
 			mlog( MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c option required to resume "
@@ -1489,15 +1476,6 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 			      GETOPT_SESSCPLT );
 			return BOOL_FALSE;
 		}
-#else /* SESSCPLT */
-		if ( ! resumepr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
-			      "-%c option required to resume previously "
-			      "interrupted restore session\n"),
-			      GETOPT_RESUME );
-			return BOOL_FALSE;
-		}
-#endif /* SESSCPLT */
 		if ( tranp->t_reqdumplabvalpr ) {
 			mlog( MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
@@ -1569,7 +1547,6 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 	 */
 	ownerpr = ( geteuid( ) == 0 ) ? BOOL_TRUE : ownerpr;
 
-#ifdef SESSCPLT
 	/* force completion of interrupted restore if asked to do so
 	 */
 	if ( sesscpltpr ) {
@@ -1637,7 +1614,6 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 			return EXIT_FAULT;
 		}
 	}
-#endif /* SESSCPLT */
 
 	/* for the three cases, calculate old and new mapping params
 	 * and wipe partial state
@@ -2158,13 +2134,11 @@ content_stream_restore( ix_t thrdix )
 			     sizeof( persp->s.dumplab ));
 		sessp = 0;
 
-#ifdef PIPEINVFIX
 		/* don't look at the online inventory if the input is piped
 		 */
 		if ( ! drivep->d_isnamedpipepr
 		     &&
 		     ! drivep->d_isunnamedpipepr ) {
-#endif /* PIPEINVFIX */
 			ok = inv_get_session_byuuid( &grhdrp->gh_dumpid,
 						     &sessp );
 			if ( ok && sessp ) {
@@ -2173,9 +2147,7 @@ content_stream_restore( ix_t thrdix )
 				persp->s.fullinvpr = pi_transcribe( sessp );
 				inv_free_session( &sessp );
 			}
-#ifdef PIPEINVFIX
 		}
-#endif /* PIPEINVFIX */
 		fileh = pi_addfile( Mediap,
 				    grhdrp,
 				    drhdrp,
@@ -2513,9 +2485,7 @@ content_stream_restore( ix_t thrdix )
 		switch ( rv ) {
 		case RV_OK:
 			DH2F( fileh )->f_nondirdonepr = BOOL_TRUE;
-#ifdef EOMFIX
 			Media_end( Mediap );
-#endif /* EOMFIX */
 			break;
 		case RV_INTR:
 		case RV_DRIVE:
@@ -2542,9 +2512,6 @@ content_stream_restore( ix_t thrdix )
 	lock( );
 	if ( tranp->t_sync5 == SYNC_BUSY ) {
 		unlock( );
-#ifndef EOMFIX
-		Media_end( Mediap );
-#endif /* ! EOMFIX */
 		return EXIT_NORMAL;
 	}
 	tranp->t_sync5 = SYNC_BUSY;
@@ -2566,28 +2533,16 @@ content_stream_restore( ix_t thrdix )
 	case RV_OK:
 		break;
 	case RV_ERROR:
-#ifndef EOMFIX
-		Media_end( Mediap );
-#endif /* ! EOMFIX */
 		return EXIT_ERROR;
 	case RV_INTR:
-#ifndef EOMFIX
-		Media_end( Mediap );
-#endif /* ! EOMFIX */
 		return EXIT_NORMAL;
 	case RV_CORE:
 	default:
-#ifndef EOMFIX
-		Media_end( Mediap );
-#endif /* ! EOMFIX */
 		return EXIT_FAULT;
 	}
 
 	/* made it! I'm last, now exit
 	 */
-#ifndef EOMFIX
-	Media_end( Mediap );
-#endif /* ! EOMFIX */
 	return EXIT_NORMAL;
 }
 
@@ -6436,9 +6391,6 @@ pi_hiteod( ix_t strmix, ix_t objix )
 static void
 pi_hiteom( ix_t strmix, ix_t objix )
 {
-#ifndef EOMFIX
-	pi_seestrmend( strmix );
-#endif /* ! EOMFIX */
 	pi_seeobjstrmend( strmix, objix );
 }
 
@@ -7253,9 +7205,7 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
 #ifdef S_IFNAM
 		case S_IFNAM:
 #endif
-#ifdef DOSOCKS
 		case S_IFSOCK:
-#endif /* DOSOCKS */
 			ok = restore_spec( fhdrp, rvp, path1 );
 			return ok;
 		case S_IFLNK:
@@ -7707,11 +7657,9 @@ restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
 		printstr = _("XENIX named pipe");
 		break;
 #endif
-#ifdef DOSOCKS
 	case S_IFSOCK:
 		printstr = _("UNIX domain socket");
 		break;
-#endif /* DOSOCKS */
 	default:
 		mlog( MLOG_NORMAL | MLOG_WARNING, _(
 		      "%s: unknown file type: mode 0x%x ino %llu\n"),
@@ -7734,7 +7682,6 @@ restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
 	}
 
 	if ( ! tranp->t_toconlypr ) {
-#ifdef DOSOCKS
 		if ( ( bstatp->bs_mode & S_IFMT ) == S_IFSOCK ) {
 			int sockfd;
 			struct sockaddr_un addr;
@@ -7782,29 +7729,25 @@ restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
 				return BOOL_TRUE;
 			}
 			( void )close( sockfd );
-			goto sockbypass;
-		}
-#endif /* DOSOCKS */
 
-		/* create the node
-		 */
-		rval = mknod( path,
-			      ( mode_t )bstatp->bs_mode,
-			      ( dev_t )IRIX_DEV_TO_KDEVT(bstatp->bs_rdev));
-		if ( rval && rval != EEXIST ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
-			      "unable to create %s "
-			      "ino %llu %s: %s: discarding\n"),
-			      printstr,
-			      fhdrp->fh_stat.bs_ino,
-			      path,
-			      strerror( errno ));
-			return BOOL_TRUE;
+		} else {
+			/* create the node
+			*/
+			rval = mknod( path,
+				      ( mode_t )bstatp->bs_mode,
+				      ( dev_t )IRIX_DEV_TO_KDEVT(bstatp->bs_rdev));
+			if ( rval && rval != EEXIST ) {
+				mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+				      "unable to create %s "
+				      "ino %llu %s: %s: discarding\n"),
+				      printstr,
+				      fhdrp->fh_stat.bs_ino,
+				      path,
+				      strerror( errno ));
+				return BOOL_TRUE;
+			}
 		}
 
-#ifdef DOSOCKS
-sockbypass:
-#endif /* DOSOCKS */
 		/* set the owner and group (if enabled)
 		 */
 		if ( persp->a.ownerpr ) {
diff --git a/restore/dirattr.c b/restore/dirattr.c
index ec160af..68d1b49 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -197,11 +197,9 @@ static dirattr_pers_t *dpp = 0;
 bool_t
 dirattr_init( char *hkdir, bool_t resume, u_int64_t dircnt )
 {
-#ifdef SESSCPLT
 	if ( dtp ) {
 		return BOOL_TRUE;
 	}
-#endif /* SESSCPLT */
 
 	/* sanity checks
 	 */
diff --git a/restore/namreg.c b/restore/namreg.c
index 619a7d7..80d558a 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -114,11 +114,9 @@ static namreg_pers_t *npp = 0;
 bool_t
 namreg_init( char *hkdir, bool_t resume, u_int64_t inocnt )
 {
-#ifdef SESSCPLT
 	if ( ntp ) {
 		return BOOL_TRUE;
 	}
-#endif /* SESSCPLT */
 
 	/* sanity checks
 	 */
diff --git a/restore/tree.c b/restore/tree.c
index 25652e9..7bddddf 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -511,11 +511,9 @@ tree_sync( char *hkdir,
 	bool_t ok;
 	intgen_t rval;
 
-#ifdef SESSCPLT
 	if ( persp ) {
 		return BOOL_TRUE;
 	}
-#endif /* SESSCPLT */
 
 	/* sanity checks
 	 */
@@ -3028,8 +3026,6 @@ tsi_cmd_quit( void *ctxp,
 {
 }
 
-#ifdef WHITEPARSE
-
 static int parse( int slotcnt, char **slotbuf, char *string );
 
 static void
@@ -3047,31 +3043,6 @@ tsi_cmd_parse( char *buf )
 	tranp->t_inter.i_argc = ( size_t )min( max( 0, wordcnt ), INTER_ARGMAX );
 }
 
-#else /* WHITEPARSE */
-
-static void
-tsi_cmd_parse( char *buf )
-{
-	size_t argc;
-	char *t;
-	char *b;
-
-	if ( ! buf ) {
-		tranp->t_inter.i_argc = 0;
-		return;
-	}
-
-	argc = 0;
-	b = buf;
-	while ( argc < INTER_ARGMAX && ( t = strtok( b, " \t" )) != 0 ) {
-		tranp->t_inter.i_argv[ argc++ ] = t;
-		b = 0;
-	}
-	tranp->t_inter.i_argc = argc;
-}
-
-#endif /* WHITEPARSE */
-
 struct tsi_cmd_tbl {
 	char *tct_pattern;
 	char *tct_help;
@@ -4579,8 +4550,6 @@ tree_chk2_recurse( nh_t cldh, nh_t parh )
 
 #endif /* TREE_CHK */
 
-#ifdef WHITEPARSE
-
 static char *whites = " \t\r\n\v\f";
 
 static int is_white( char c );
@@ -4894,8 +4863,6 @@ octal_to_size( char c )
 	return 0;
 }
 
-#endif /* WHITEPARSE */
-
 static int
 mkdir_r(char *path)
 {
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
