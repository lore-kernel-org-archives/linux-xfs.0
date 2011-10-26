Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QNOsxS045376 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 18:24:55 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: fix metadata restore on split files
Date: Wed, 26 Oct 2011 18:24:43 -0500
Message-Id: <1319671483-27787-1-git-send-email-wkendall@sgi.com>
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

xfsrestore does not apply certain metadata until all of the file's
data has been restored. This allows, for example, files with the
immutable flag set to be restored properly.

While testing multi-stream restores, I noticed that files split
across multiple streams did not have their metadata restored.
Looking into this further, it also applies to the single-stream
case where files are split across media files, such as when a
backup spans multiple tapes.

The fix is to check to see if a file is completely restored
whenever we hit the end of a media file. The current code
is broken because it relies on all media files being applied
during the same restore session.

This also moves the S_ISREG() check into restore_complete_reg()
rather than relying on callers to make the check.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 restore/content.c |   50 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index e5957bf..34fc4a0 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -2499,12 +2499,6 @@ content_stream_restore( ix_t thrdix )
 		}
 	}
 
-	/* out of media files, so finish the last file that
-	 * was being worked on.
-	 */
-	if ((strctxp->sc_bstat.bs_mode & S_IFMT) == S_IFREG)
-		restore_complete_reg(strctxp);
-
 	/* finally, choose one thread to do final processing
 	 * and cleanup. the winner waits, the losers all exit.
 	 * once the losers exit, the winner can perform cleanup.
@@ -3337,6 +3331,7 @@ applynondirdump( drive_t *drivep,
 		 char *path2,
 		 filehdr_t *fhdrp )
 {
+	rv_t rv = RV_UNKNOWN;
 	bool_t fhcs;
 	bool_t ehcs;
 	bool_t ahcs;
@@ -3367,18 +3362,24 @@ applynondirdump( drive_t *drivep,
 	 */
 	pi_bracketneededegrps( fileh, &first_egrp, &next_egrp );
 
+	/* initialize the stream context
+	 */
+	memset(&strctxp->sc_bstat, 0, sizeof(bstat_t));
+	strctxp->sc_path[0] = '\0';
+	strctxp->sc_fd = -1;
+
 	for ( ; ; ) {
 		drive_ops_t *dop = drivep->d_opsp;
 		drive_mark_t drivemark;
 		bstat_t *bstatp = &fhdrp->fh_stat;
 		bool_t resyncpr = BOOL_FALSE;
-		rv_t rv;
 		intgen_t rval;
 
 		/* if a null file header, break
 		 */
 		if ( fhdrp->fh_flags & FILEHDR_FLAGS_NULL ) {
-			break;
+			rv = RV_OK;
+			goto applynondirdump_out;
 		}
 
 		/* if working on a different file than we were previously,
@@ -3386,8 +3387,7 @@ applynondirdump( drive_t *drivep,
 		 */
 		if ( bstatp->bs_ino != strctxp->sc_bstat.bs_ino ) {
 
-			if ((strctxp->sc_bstat.bs_mode & S_IFMT) == S_IFREG)
-				restore_complete_reg(strctxp);
+			restore_complete_reg(strctxp);
 
 			/* start new ino */
 			memcpy(&strctxp->sc_bstat, bstatp, sizeof(bstat_t));
@@ -3418,7 +3418,8 @@ applynondirdump( drive_t *drivep,
 		case RV_OK:
 			break;
 		case RV_EOD:
-			return RV_OK;
+			rv = RV_OK;
+			goto applynondirdump_out;
 		case RV_CORRUPT:
 			rval = ( * dop->do_next_mark )( drivep );
 			if ( rval ) {
@@ -3426,12 +3427,13 @@ applynondirdump( drive_t *drivep,
 				      "unable to resync media file: "
 				      "some portion of dump will NOT "
 				      "be restored\n") );
-				return RV_OK;  /* treat as EOD */
+				rv = RV_OK;  /* treat as EOD */
+				goto applynondirdump_out;
 			}
 			resyncpr = BOOL_TRUE;
 			break;
 		default:
-			return rv;
+			goto applynondirdump_out;
 		}
 
 		/* update stats if appropriate
@@ -3471,7 +3473,8 @@ applynondirdump( drive_t *drivep,
 			case RV_OK:
 				break;
 			case RV_EOD:
-				return RV_OK;
+				rv = RV_OK;
+				goto applynondirdump_out;
 			case RV_CORRUPT:
 				rval = ( * dop->do_next_mark )( drivep );
 				if ( rval ) {
@@ -3479,11 +3482,12 @@ applynondirdump( drive_t *drivep,
 					      "unable to resync media file: "
 					      "some portion of dump will NOT "
 					      "be restored\n") );
-					return RV_OK;  /* treat as EOD */
+					rv = RV_OK;  /* treat as EOD */
+					goto applynondirdump_out;
 				}
 				resyncpr = BOOL_TRUE;
 			default:
-				return rv;
+				goto applynondirdump_out;
 			}
 
 			if ( resyncpr && rv == RV_OK ) {
@@ -3515,7 +3519,16 @@ applynondirdump( drive_t *drivep,
 			preemptchk( );
 		}
 	}
-	return RV_OK;
+
+applynondirdump_out:
+
+	/* We've hit the end of this media file or encountered corruption.
+	 * In either case, we may not be back to complete the metadata for
+	 * this file, so attempt to complete it now.
+	 */
+	restore_complete_reg(strctxp);
+
+	return rv;
 }
 
 /* ARGSUSED */
@@ -7507,6 +7520,9 @@ restore_complete_reg(stream_context_t *strcxtp)
 	struct utimbuf utimbuf;
 	intgen_t rval;
 
+	// only applies to regular files
+	if (!S_ISREG((strcxtp->sc_bstat.bs_mode)))
+		return BOOL_TRUE;
 
 	if (fd < 0)
 		return BOOL_TRUE;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
