Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LJYje6170415 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 14:34:45 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2] xfsdump: call mlog_exit in content_stream_restore
Date: Wed, 21 Sep 2011 14:34:34 -0500
Message-Id: <1316633674-25677-1-git-send-email-wkendall@sgi.com>
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

This patch adds mlog_exit() calls to all the return paths in
content_stream_restore(). mlog_exit() is supposed to be called before
returning from content_stream_dump() and content_stream_restore(), but the
latter did not do so, allowing for the stream exit status to be unset.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
Changes from v1:
    - Reworked now that that #define EOMFIX has been removed.
    - In code like "return mlog_exit(EXIT_NORMAL, rv)", replace
      rv with an explicit RV_* value if possible. (In most cases
      though rv could be more than one value.)
    - It was suggested that this function could be cleaned up
      using goto labels. I looked into that but did not see
      a benefit. Most return paths were different enough that
      they could not be combined.

 restore/content.c |   76 ++++++++++++++++++++++++----------------------------
 1 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 2d131c7..a98a9c7 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -1906,7 +1906,7 @@ content_stream_restore( ix_t thrdix )
 		      "chdir %s failed: %s\n"),
 		      persp->a.dstdir,
 		      strerror( errno ));
-		return EXIT_ERROR;
+		return mlog_exit(EXIT_ERROR, RV_ERROR);
 	}
 
 	/* set my file creation mask to zero, to avoid modifying the
@@ -1927,7 +1927,7 @@ content_stream_restore( ix_t thrdix )
 		      _("malloc of stream context failed (%d bytes): %s\n"),
 		      sizeof(stream_context_t),
 		      strerror( errno ));
-		return EXIT_ERROR;
+		return mlog_exit(EXIT_ERROR, RV_ERROR);
 	}
 	strctxp->sc_fd = -1;
 	Mediap->M_drivep->d_strmcontextp = (void *)strctxp;
@@ -1948,7 +1948,7 @@ content_stream_restore( ix_t thrdix )
 			unlock( );
 			sleep( 1 );
 			if ( cldmgr_stop_requested( )) {
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			continue;
 		}
@@ -1965,7 +1965,7 @@ content_stream_restore( ix_t thrdix )
 		     * into pi, and makes persp->s.dumpid valid.
 		     */
 		if ( ok == BOOL_ERROR ) {
-			return EXIT_ERROR;
+			return mlog_exit(EXIT_ERROR, RV_OPT);
 		}
 		tranp->t_dumpidknwnpr = ok;
 		tranp->t_sync1 = SYNC_DONE;
@@ -2012,11 +2012,11 @@ content_stream_restore( ix_t thrdix )
 		case RV_QUIT:
 		case RV_DRIVE:
 			Media_end( Mediap );
-			return EXIT_NORMAL;
+			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
 			Media_end( Mediap );
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, rv);
 		}
 		dcaps = drivep->d_capabilities;
 
@@ -2026,7 +2026,7 @@ content_stream_restore( ix_t thrdix )
 			sleep( 1 );
 			if ( cldmgr_stop_requested( )) {
 				Media_end( Mediap );
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			lock( );
 		}
@@ -2110,7 +2110,7 @@ content_stream_restore( ix_t thrdix )
 		}
 		if ( cldmgr_stop_requested( )) {
 			Media_end( Mediap );
-			return EXIT_NORMAL;
+			return mlog_exit(EXIT_NORMAL, RV_INTR);
 		}
 		if ( ! matchpr ) {
 			Media_end( Mediap );
@@ -2121,13 +2121,13 @@ content_stream_restore( ix_t thrdix )
 			     ( ! ( dcaps & DRIVE_CAP_FILES )
 			       &&
 			       ! ( dcaps & DRIVE_CAP_REMOVABLE ))) {
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_QUIT);
 			}
 			continue;
 		}
 		if ( ! dumpcompat( resumepr, level, *baseidp, BOOL_TRUE )) {
 			Media_end( Mediap );
-			return EXIT_ERROR;
+			return mlog_exit(EXIT_ERROR, RV_COMPAT);
 		}
 		strncpyterm( persp->s.dumplab,
 			     grhdrp->gh_dumplabel,
@@ -2158,7 +2158,7 @@ content_stream_restore( ix_t thrdix )
 			 * if this is a match
 			 */
 		if ( fileh == DH_NULL ) {
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, RV_ERROR);
 		}
 		uuid_copy(persp->s.dumpid,grhdrp->gh_dumpid);
 		persp->s.begintime = time( 0 );
@@ -2198,11 +2198,11 @@ content_stream_restore( ix_t thrdix )
 		case RV_QUIT:
 		case RV_DRIVE:
 			Media_end( Mediap );
-			return EXIT_NORMAL;
+			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
 			Media_end( Mediap );
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, rv);
 		}
 		dcaps = drivep->d_capabilities;
 		ASSERT( fileh != DH_NULL );
@@ -2229,7 +2229,7 @@ content_stream_restore( ix_t thrdix )
 			sleep( 1 );
 			if ( cldmgr_stop_requested( )) {
 				Media_end( Mediap );
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			lock( );
 		}
@@ -2250,7 +2250,7 @@ content_stream_restore( ix_t thrdix )
 					   scrhdrp->cih_inomap_dircnt );
 			if ( ! ok ) {
 				Media_end( Mediap );
-				return EXIT_ERROR;
+				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_dirattrinitdonepr = BOOL_TRUE;
 		}
@@ -2265,7 +2265,7 @@ content_stream_restore( ix_t thrdix )
 					  scrhdrp->cih_inomap_nondircnt );
 			if ( ! ok ) {
 				Media_end( Mediap );
-				return EXIT_ERROR;
+				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_namreginitdonepr = BOOL_TRUE;
 		}
@@ -2298,7 +2298,7 @@ content_stream_restore( ix_t thrdix )
 					persp->a.dstdirisxfspr );
 			if ( ! ok ) {
 				Media_end( Mediap );
-				return EXIT_ERROR;
+				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_treeinitdonepr = BOOL_TRUE;
 		}
@@ -2329,11 +2329,11 @@ content_stream_restore( ix_t thrdix )
 		case RV_INTR:
 		case RV_DRIVE:
 			Media_end( Mediap );
-			return EXIT_NORMAL;
+			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
 			Media_end( Mediap );
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, rv);
 		}
 	}
 
@@ -2368,7 +2368,7 @@ content_stream_restore( ix_t thrdix )
 			sleep( 1 );
 			if ( cldmgr_stop_requested( )) {
 				Media_end( Mediap );
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			lock( );
 		}
@@ -2388,14 +2388,14 @@ content_stream_restore( ix_t thrdix )
 			break;
 		case RV_ERROR:
 			Media_end( Mediap );
-			return EXIT_ERROR;
+			return mlog_exit(EXIT_ERROR, RV_ERROR);
 		case RV_INTR:
 			Media_end( Mediap );
-			return EXIT_INTERRUPT;
+			return mlog_exit(EXIT_INTERRUPT, RV_INTR);
 		case RV_CORE:
 		default:
 			Media_end( Mediap );
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, rv);
 		}
 
 		/* now that we have a tree and inomap, scan the
@@ -2448,11 +2448,11 @@ content_stream_restore( ix_t thrdix )
 		case RV_QUIT:
 		case RV_DRIVE:
 			Media_end( Mediap );
-			return EXIT_NORMAL;
+			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
 			Media_end( Mediap );
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, rv);
 		}
 		dcaps = drivep->d_capabilities;
 		ASSERT( fileh > DH_NULL );
@@ -2491,11 +2491,11 @@ content_stream_restore( ix_t thrdix )
 		case RV_DRIVE:
 		case RV_INCOMPLETE:
 			Media_end( Mediap );
-			return EXIT_NORMAL;
+			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
 			Media_end( Mediap );
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, rv);
 		}
 	}
 
@@ -2512,7 +2512,7 @@ content_stream_restore( ix_t thrdix )
 	lock( );
 	if ( tranp->t_sync5 == SYNC_BUSY ) {
 		unlock( );
-		return EXIT_NORMAL;
+		return mlog_exit(EXIT_NORMAL, RV_DONE);
 	}
 	tranp->t_sync5 = SYNC_BUSY;
 	unlock( );
@@ -2529,21 +2529,15 @@ content_stream_restore( ix_t thrdix )
 	mlog( MLOG_DEBUG,
 	      "tree finalize\n" );
 	rv = finalize( path1, path2 );
-	switch ( rv ) {
-	case RV_OK:
-		break;
-	case RV_ERROR:
-		return EXIT_ERROR;
-	case RV_INTR:
-		return EXIT_NORMAL;
-	case RV_CORE:
-	default:
-		return EXIT_FAULT;
+	if (rv == RV_OK || rv == RV_INTR) {
+		rval = EXIT_NORMAL;
+	} else if (rv == RV_ERROR) {
+		rval = EXIT_ERROR;
+	} else {
+		rval = EXIT_FAULT;
 	}
 
-	/* made it! I'm last, now exit
-	 */
-	return EXIT_NORMAL;
+	return mlog_exit(rval, rv);
 }
 
 /* called after all threads have exited. scans state to decide
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
