Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7Kxhbh076051 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:59:44 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 2/8] xfsdump: remove multi-stream synchronous dir dump
Date: Mon,  7 Nov 2011 14:58:25 -0600
Message-Id: <1320699511-12281-3-git-send-email-wkendall@sgi.com>
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

When doing multi-stream dumps, the directories are dumped by each
stream in lock-step fashion. A stream backs up a given directory,
then waits for all others to finish that directory, then they all
move on to the next one. During restore a single stream is chosen to
apply the directory dump.

This patch changes xfsdump so that only one stream dumps the
directories. The other streams begin dumping files immediately.
This results in a faster backup, which is presumably why multiple
streams are being used in the first place.

It also removes the barrier routines in qlock.c as they were only
used by the "SYNCDIR" code.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/qlock.c    |   37 ----------
 common/qlock.h    |   11 ---
 dump/content.c    |  193 ++++++++++++-----------------------------------------
 restore/content.c |   33 +++++++++
 4 files changed, 75 insertions(+), 199 deletions(-)

diff --git a/common/qlock.c b/common/qlock.c
index fd0e98d..6c9ee16 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -568,43 +568,6 @@ return 0;
 #endif /* HIDDEN */
 }
 
-qbarrierh_t
-qbarrier_alloc( void )
-{
-#ifdef HIDDEN
-	barrier_t *barrierp;
-
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
-
-	/* allocate a us barrier
-	 */
-	barrierp = new_barrier( qlock_usp );
-	ASSERT( barrierp );
-
-	return ( qbarrierh_t )barrierp;
-#else
-return 0;
-#endif /* HIDDEN */
-}
-
-void
-qbarrier( qbarrierh_t qbarrierh, size_t thrdcnt )
-{
-#ifdef HIDDEN
-	barrier_t *barrierp = ( barrier_t * )qbarrierh;
-
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
-
-	barrier( barrierp, thrdcnt );
-#endif /* HIDDEN */
-}
-
 /* internal ordinal map abstraction
  */
 #ifdef HIDDEN
diff --git a/common/qlock.h b/common/qlock.h
index 54469ea..1880aff 100644
--- a/common/qlock.h
+++ b/common/qlock.h
@@ -102,15 +102,4 @@ extern size_t qsemPblocked( qsemh_t qsemh );
 	/* number of threads currently blocked on this semaphore
 	 */
 
-typedef void *qbarrierh_t;
-#define QBARRIERH_NULL	0
-	/* opaque handle
-	 */
-extern qbarrierh_t qbarrier_alloc( void );
-	/* allocates a rendezvous barrier
-	 */
-extern void qbarrier( qbarrierh_t barrierh, size_t thrdcnt );
-	/* causes thrdcnt threads to rendezvous
-	 */
-
 #endif /* QLOCK_H */
diff --git a/dump/content.c b/dump/content.c
index 54c97d1..64bfe54 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -64,9 +64,6 @@
 #include "getdents.h"
 #include "arch_xlate.h"
 
-#undef SYNCDIR
-#define SYNCDIR
-
 /* max "unsigned long long int"
  */
 #define ULONGLONG_MAX	18446744073709551615LLU
@@ -231,7 +228,6 @@ typedef struct extent_group_context extent_group_context_t;
 struct pds {
 	enum { PDS_NULL,		/* per-drive activity not begun */
 	       PDS_INOMAP,		/* dumping inomap */
-	       PDS_DIRRENDEZVOUS,	/* waiting to dump dirs */
 	       PDS_DIRDUMP,		/* dumping dirs */
 	       PDS_NONDIR,		/* dumping nondirs */
 	       PDS_INVSYNC,		/* waiting for inventory */
@@ -263,9 +259,6 @@ static rv_t dump_dirs( ix_t strmix,
 		       xfs_bstat_t *bstatbufp,
 		       size_t bstatbuflen,
 		       void *inomap_contextp );
-#ifdef SYNCDIR
-static rv_t dump_dirs_rendezvous( void );
-#endif /* SYNCDIR */
 static rv_t dump_dir( ix_t strmix,
 		      jdm_fshandle_t *,
 		      intgen_t,
@@ -485,12 +478,6 @@ static bool_t sc_dumpextattrpr = BOOL_TRUE;
 static bool_t sc_dumpasoffline = BOOL_FALSE;
 	/* dump dual-residency HSM files as offline
 	 */
-#ifdef SYNCDIR
-static size_t sc_thrdsdirdumpsynccnt = 0;
-static size_t sc_thrdswaitingdirdumpsync1 = 0;
-static size_t sc_thrdswaitingdirdumpsync2 = 0;
-static qbarrierh_t sc_barrierh;
-#endif /* SYNCDIR */
 
 static bool_t sc_savequotas = BOOL_TRUE;
 /* save quota information in dump
@@ -1466,14 +1453,13 @@ baseuuidbypass:
 	var_skip( &fsid, inomap_skip );
 
 	/* fill in write header template content info. always produce
-	 * an inomap and dir dump for each media file.
+	 * an inomap for each media file. the dirdump flag will be set
+	 * in content_stream_dump() for streams which dump the directories.
 	 */
 	ASSERT( sizeof( cwhdrtemplatep->ch_specific ) >= sizeof( *scwhdrtemplatep ));
 	scwhdrtemplatep->cih_mediafiletype = CIH_MEDIAFILETYPE_DATA;
 	scwhdrtemplatep->cih_level = ( int32_t )sc_level;
-	scwhdrtemplatep->cih_dumpattr = CIH_DUMPATTR_INOMAP
-					|
-					CIH_DUMPATTR_DIRDUMP;
+	scwhdrtemplatep->cih_dumpattr = CIH_DUMPATTR_INOMAP;
 	if ( subtreecnt ) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_SUBTREE;
 	}
@@ -1714,22 +1700,6 @@ baseuuidbypass:
 		}
 	}
 
-#ifdef SYNCDIR
-	/* allocate a barrier to synchronize directory dumping
-	 */
-	if ( drivecnt > 1 ) {
-		sc_barrierh = qbarrier_alloc( );
-	}
-
-	/* initialize the number of players in the synchronized dir dump.
-	 * they drop out when last media file complete. MUST be modified
-	 * under lock( ).
-	 */
-	sc_thrdsdirdumpsynccnt = drivecnt;
-
-#endif /* SYNCDIR */
-
-
 	return BOOL_TRUE;
 }
 
@@ -1877,10 +1847,6 @@ content_statline( char **linespp[ ] )
 			strcat( statline[ statlinecnt ],
 				"dumping inomap" );
 			break;
-		case PDS_DIRRENDEZVOUS:
-			strcat( statline[ statlinecnt ],
-				"waiting for synchronized directory dump" );
-			break;
 		case PDS_DIRDUMP:
 			sprintf( &statline[ statlinecnt ]
 					  [ strlen( statline[ statlinecnt ] ) ],
@@ -2157,6 +2123,11 @@ content_stream_dump( ix_t strmix )
 		scwhdrp->cih_endpt.sp_flags = STARTPT_FLAGS_END;
 	}
 
+	// the first stream dumps the directories
+	if ( strmix == 0 ) {
+		scwhdrp->cih_dumpattr |= CIH_DUMPATTR_DIRDUMP;
+	}
+
 	/* fill in inomap fields of write hdr
 	 */
 	inomap_writehdr( scwhdrp );
@@ -2322,39 +2293,41 @@ content_stream_dump( ix_t strmix )
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 
-		/* now dump the directories. use the bigstat iterator
-		 * capability to call my dump_dir function
-		 * for each directory in the bitmap.
+		/* now dump the directories, if this is a stream that dumps
+		 * directories. use the bigstat iterator capability to call
+		 * my dump_dir function for each directory in the bitmap.
 		 */
-		sc_stat_pds[ strmix ].pds_dirdone = 0;
-		rv = dump_dirs( strmix,
-				bstatbufp,
-				bstatbuflen,
-				inomap_contextp );
-		if ( rv == RV_INTR ) {
-			stop_requested = BOOL_TRUE;
-			goto decision_more;
-		}
-		if ( rv == RV_EOM ) {
-			hit_eom = BOOL_TRUE;
-			goto decision_more;
-		}
-		if ( rv == RV_DRIVE ) {
-			free( ( void * )bstatbufp );
-			return mlog_exit(EXIT_NORMAL, rv);
-		}
-		if ( rv == RV_ERROR ) {
-			free( ( void * )bstatbufp );
-			return mlog_exit(EXIT_ERROR, rv);
-		}
-		if ( rv == RV_CORE ) {
-			free( ( void * )bstatbufp );
-			return mlog_exit(EXIT_FAULT, rv);
-		}
-		ASSERT( rv == RV_OK );
-		if ( rv != RV_OK ) {
-			free( ( void * )bstatbufp );
-			return mlog_exit(EXIT_FAULT, rv);
+		if ( scwhdrp->cih_dumpattr & CIH_DUMPATTR_DIRDUMP ) {
+			sc_stat_pds[ strmix ].pds_dirdone = 0;
+			rv = dump_dirs( strmix,
+					bstatbufp,
+					bstatbuflen,
+					inomap_contextp );
+			if ( rv == RV_INTR ) {
+				stop_requested = BOOL_TRUE;
+				goto decision_more;
+			}
+			if ( rv == RV_EOM ) {
+				hit_eom = BOOL_TRUE;
+				goto decision_more;
+			}
+			if ( rv == RV_DRIVE ) {
+				free( ( void * )bstatbufp );
+				return mlog_exit(EXIT_NORMAL, rv);
+			}
+			if ( rv == RV_ERROR ) {
+				free( ( void * )bstatbufp );
+				return mlog_exit(EXIT_ERROR, rv);
+			}
+			if ( rv == RV_CORE ) {
+				free( ( void * )bstatbufp );
+				return mlog_exit(EXIT_FAULT, rv);
+			}
+			ASSERT( rv == RV_OK );
+			if ( rv != RV_OK ) {
+				free( ( void * )bstatbufp );
+				return mlog_exit(EXIT_FAULT, rv);
+			}
 		}
 
 		/* finally, dump the non-directory files beginning with this
@@ -2527,20 +2500,6 @@ decision_more:
 		 */
 		done = all_nondirs_committed;
 
-#ifdef SYNCDIR
-		/* drop out of the synchronous dump game if done
-		 */
-		if ( done ) {
-			/* REFERENCED */
-			size_t tmpthrdsdirdumpsynccnt;
-			lock( );
-			tmpthrdsdirdumpsynccnt = sc_thrdsdirdumpsynccnt;
-			sc_thrdsdirdumpsynccnt--;
-			unlock( );
-			ASSERT( tmpthrdsdirdumpsynccnt > 0 );
-		}
-#endif /* SYNCDIR */
-
 		/* tell the inventory about the media file
 		 */
 		if ( inv_stmt != INV_TOKEN_NULL ) {
@@ -2833,22 +2792,6 @@ dump_dirs( ix_t strmix,
 		__s32 buflenout;
 		intgen_t rval;
 
-#ifdef SYNCDIR
-		/* have all threads rendezvous
-		 */
-		if ( sc_thrdsdirdumpsynccnt > 1 && stream_cnt( ) > 1 ) {
-			rv_t rv;
-			mlog( bulkstatcallcnt == 0 ? MLOG_VERBOSE : MLOG_NITTY,
-			      _("waiting for synchronized directory dump\n") );
-			sc_stat_pds[ strmix ].pds_phase = PDS_DIRRENDEZVOUS;
-			rv = dump_dirs_rendezvous( );
-			if ( rv == RV_INTR ) {
-				return RV_INTR;
-			}
-			ASSERT( rv == RV_OK );
-		}
-#endif /* SYNCDIR */
-
 		if ( bulkstatcallcnt == 0 ) {
 			mlog( MLOG_VERBOSE, _(
 			      "dumping directories\n") );
@@ -2948,58 +2891,6 @@ dump_dirs( ix_t strmix,
 	/* NOTREACHED */
 }
 
-#ifdef SYNCDIR
-static rv_t
-dump_dirs_rendezvous( void )
-{
-	static size_t localsync1;
-	static size_t localsync2;
-
-	sc_thrdswaitingdirdumpsync2 = 0;
-	lock( );
-	sc_thrdswaitingdirdumpsync1++;
-	localsync1 = sc_thrdswaitingdirdumpsync1;
-	localsync2 = sc_thrdswaitingdirdumpsync2;
-	unlock( );
-	while ( localsync2 == 0
-		&&
-		localsync1 < min( stream_cnt( ), sc_thrdsdirdumpsynccnt )) {
-		sleep( 1 );
-		if ( cldmgr_stop_requested( )) {
-			lock( );
-			sc_thrdswaitingdirdumpsync1--;
-			unlock( );
-			return RV_INTR;
-		}
-		lock( );
-		localsync1 = sc_thrdswaitingdirdumpsync1;
-		localsync2 = sc_thrdswaitingdirdumpsync2;
-		unlock( );
-	}
-	lock( );
-	sc_thrdswaitingdirdumpsync1--;
-	sc_thrdswaitingdirdumpsync2++;
-	localsync2 = sc_thrdswaitingdirdumpsync2;
-	unlock( );
-	while ( localsync2 < min( stream_cnt( ), sc_thrdsdirdumpsynccnt )) {
-		sleep( 1 );
-		if ( cldmgr_stop_requested( )) {
-			return RV_INTR;
-		}
-		lock( );
-		localsync2 = sc_thrdswaitingdirdumpsync2;
-		unlock( );
-	}
-	if ( cldmgr_stop_requested( )) {
-		return RV_INTR;
-	}
-	
-	qbarrier( sc_barrierh, min( stream_cnt( ), sc_thrdsdirdumpsynccnt ));
-
-	return RV_OK;
-}
-#endif /* SYNCDIR */
-
 static rv_t
 dump_dir( ix_t strmix,
 	  jdm_fshandle_t *fshandlep,
diff --git a/restore/content.c b/restore/content.c
index 34fc4a0..2228a7f 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -625,6 +625,9 @@ struct tran {
 	intgen_t t_persfd;
 		/* file descriptor of the persistent state file
 		 */
+	size64_t t_dirdumps;
+		/* bitset of streams which contain a directory dump
+		 */
 	sync_t t_sync1;
 		/* to single-thread attempt to validate command line
 		 * selection of dump with online inventory
@@ -1184,6 +1187,12 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 		return BOOL_FALSE;
 	}
 
+	/* assume all streams contain a directory dump. streams will remove
+	 * themselves from this bitset if they do not contain a directory dump.
+	 */
+	ASSERT( drivecnt <= sizeof(tranp->t_dirdumps) * NBBY );
+	tranp->t_dirdumps = ( 1ULL << drivecnt ) - 1;
+
 	/* the user may specify stdin as the restore source stream,
 	 * by a single dash ('-') with no option letter. This must
 	 * appear between the last lettered argument and the destination
@@ -2237,6 +2246,30 @@ content_stream_restore( ix_t thrdix )
 			unlock( );
 			continue;
 		}
+		if ( !(scrhdrp->cih_dumpattr & CIH_DUMPATTR_DIRDUMP) ) {
+			/* if no streams have a directory dump, issue a
+			 * message and exit. first set SYNC_BUSY to prevent
+			 * other threads from coming through here and issuing
+			 * the same message.
+			 */
+			tranp->t_dirdumps &= ~(1ULL << thrdix);
+			if ( !tranp->t_dirdumps ) {
+				tranp->t_sync3 = SYNC_BUSY;
+			}
+			unlock( );
+			if ( !tranp->t_dirdumps ) {
+				mlog( MLOG_VERBOSE | MLOG_ERROR, _(
+					"no directory dump found\n") );
+				Media_end( Mediap );
+				return mlog_exit(EXIT_NORMAL, RV_ERROR);
+			}
+			sleep( 1 );
+			if ( cldmgr_stop_requested( )) {
+				Media_end( Mediap );
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
+			}
+			continue;
+		}
 		tranp->t_sync3 = SYNC_BUSY;
 		unlock( );
 		if ( ! tranp->t_dirattrinitdonepr ) {
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
