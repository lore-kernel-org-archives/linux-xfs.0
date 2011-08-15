Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FIxVcW117602 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 13:59:31 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: call mlog_exit in content_stream_restore
Date: Mon, 15 Aug 2011 13:59:23 -0500
Message-Id: <1313434763-22340-1-git-send-email-wkendall@sgi.com>
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
returning from content_stream_dump() and content_stream_restore(), but
many paths in the latter did not do so, allowing for the stream exit
status to be incorrect.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 restore/content.c |   64 ++++++++++++++++++++++++++--------------------------
 1 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index e3e4994..a2f20e3 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -1930,7 +1930,7 @@ content_stream_restore( ix_t thrdix )
 		      "chdir %s failed: %s\n"),
 		      persp->a.dstdir,
 		      strerror( errno ));
-		return EXIT_ERROR;
+		return mlog_exit(EXIT_ERROR, RV_ERROR);
 	}
 
 	/* set my file creation mask to zero, to avoid modifying the
@@ -1951,7 +1951,7 @@ content_stream_restore( ix_t thrdix )
 		      _("malloc of stream context failed (%d bytes): %s\n"),
 		      sizeof(stream_context_t),
 		      strerror( errno ));
-		return EXIT_ERROR;
+		return mlog_exit(EXIT_ERROR, RV_ERROR);
 	}
 	strctxp->sc_fd = -1;
 	Mediap->M_drivep->d_strmcontextp = (void *)strctxp;
@@ -1972,7 +1972,7 @@ content_stream_restore( ix_t thrdix )
 			unlock( );
 			sleep( 1 );
 			if ( cldmgr_stop_requested( )) {
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			continue;
 		}
@@ -1989,7 +1989,7 @@ content_stream_restore( ix_t thrdix )
 		     * into pi, and makes persp->s.dumpid valid.
 		     */
 		if ( ok == BOOL_ERROR ) {
-			return EXIT_ERROR;
+			return mlog_exit(EXIT_ERROR, RV_OPT);
 		}
 		tranp->t_dumpidknwnpr = ok;
 		tranp->t_sync1 = SYNC_DONE;
@@ -2036,11 +2036,11 @@ content_stream_restore( ix_t thrdix )
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
 
@@ -2050,7 +2050,7 @@ content_stream_restore( ix_t thrdix )
 			sleep( 1 );
 			if ( cldmgr_stop_requested( )) {
 				Media_end( Mediap );
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			lock( );
 		}
@@ -2134,7 +2134,7 @@ content_stream_restore( ix_t thrdix )
 		}
 		if ( cldmgr_stop_requested( )) {
 			Media_end( Mediap );
-			return EXIT_NORMAL;
+			return mlog_exit(EXIT_NORMAL, RV_INTR);
 		}
 		if ( ! matchpr ) {
 			Media_end( Mediap );
@@ -2145,13 +2145,13 @@ content_stream_restore( ix_t thrdix )
 			     ( ! ( dcaps & DRIVE_CAP_FILES )
 			       &&
 			       ! ( dcaps & DRIVE_CAP_REMOVABLE ))) {
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_UNKNOWN);
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
@@ -2186,7 +2186,7 @@ content_stream_restore( ix_t thrdix )
 			 * if this is a match
 			 */
 		if ( fileh == DH_NULL ) {
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, RV_ERROR);
 		}
 		uuid_copy(persp->s.dumpid,grhdrp->gh_dumpid);
 		persp->s.begintime = time( 0 );
@@ -2226,11 +2226,11 @@ content_stream_restore( ix_t thrdix )
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
@@ -2257,7 +2257,7 @@ content_stream_restore( ix_t thrdix )
 			sleep( 1 );
 			if ( cldmgr_stop_requested( )) {
 				Media_end( Mediap );
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			lock( );
 		}
@@ -2278,7 +2278,7 @@ content_stream_restore( ix_t thrdix )
 					   scrhdrp->cih_inomap_dircnt );
 			if ( ! ok ) {
 				Media_end( Mediap );
-				return EXIT_ERROR;
+				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_dirattrinitdonepr = BOOL_TRUE;
 		}
@@ -2293,7 +2293,7 @@ content_stream_restore( ix_t thrdix )
 					  scrhdrp->cih_inomap_nondircnt );
 			if ( ! ok ) {
 				Media_end( Mediap );
-				return EXIT_ERROR;
+				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_namreginitdonepr = BOOL_TRUE;
 		}
@@ -2326,7 +2326,7 @@ content_stream_restore( ix_t thrdix )
 					persp->a.dstdirisxfspr );
 			if ( ! ok ) {
 				Media_end( Mediap );
-				return EXIT_ERROR;
+				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_treeinitdonepr = BOOL_TRUE;
 		}
@@ -2357,11 +2357,11 @@ content_stream_restore( ix_t thrdix )
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
 
@@ -2396,7 +2396,7 @@ content_stream_restore( ix_t thrdix )
 			sleep( 1 );
 			if ( cldmgr_stop_requested( )) {
 				Media_end( Mediap );
-				return EXIT_NORMAL;
+				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			lock( );
 		}
@@ -2416,14 +2416,14 @@ content_stream_restore( ix_t thrdix )
 			break;
 		case RV_ERROR:
 			Media_end( Mediap );
-			return EXIT_ERROR;
+			return mlog_exit(EXIT_ERROR, rv);
 		case RV_INTR:
 			Media_end( Mediap );
-			return EXIT_INTERRUPT;
+			return mlog_exit(EXIT_INTERRUPT, rv);
 		case RV_CORE:
 		default:
 			Media_end( Mediap );
-			return EXIT_FAULT;
+			return mlog_exit(EXIT_FAULT, rv);
 		}
 
 		/* now that we have a tree and inomap, scan the
@@ -2476,11 +2476,11 @@ content_stream_restore( ix_t thrdix )
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
@@ -2521,11 +2521,11 @@ content_stream_restore( ix_t thrdix )
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
 
@@ -2545,7 +2545,7 @@ content_stream_restore( ix_t thrdix )
 #ifndef EOMFIX
 		Media_end( Mediap );
 #endif /* ! EOMFIX */
-		return EXIT_NORMAL;
+		return mlog_exit(EXIT_NORMAL, RV_DONE);
 	}
 	tranp->t_sync5 = SYNC_BUSY;
 	unlock( );
@@ -2569,18 +2569,18 @@ content_stream_restore( ix_t thrdix )
 #ifndef EOMFIX
 		Media_end( Mediap );
 #endif /* ! EOMFIX */
-		return EXIT_ERROR;
+		return mlog_exit(EXIT_ERROR, rv);
 	case RV_INTR:
 #ifndef EOMFIX
 		Media_end( Mediap );
 #endif /* ! EOMFIX */
-		return EXIT_NORMAL;
+		return mlog_exit(EXIT_NORMAL, rv);
 	case RV_CORE:
 	default:
 #ifndef EOMFIX
 		Media_end( Mediap );
 #endif /* ! EOMFIX */
-		return EXIT_FAULT;
+		return mlog_exit(EXIT_FAULT, rv);
 	}
 
 	/* made it! I'm last, now exit
@@ -2588,7 +2588,7 @@ content_stream_restore( ix_t thrdix )
 #ifndef EOMFIX
 	Media_end( Mediap );
 #endif /* ! EOMFIX */
-	return EXIT_NORMAL;
+	return mlog_exit(EXIT_NORMAL, rv);
 }
 
 /* called after all threads have exited. scans state to decide
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
