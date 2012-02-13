Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DNAg9S049501 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 17:10:42 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: handle files with no extent headers
Date: Mon, 13 Feb 2012 17:10:34 -0600
Message-Id: <1329174634-6337-1-git-send-email-wkendall@sgi.com>
In-Reply-To: <CAGdb-8fFOAOSZAZNJDB9kyQJHoWKh+4SUohZfkknLDkaGnQFcQ@mail.gmail.com>
References: <CAGdb-8fFOAOSZAZNJDB9kyQJHoWKh+4SUohZfkknLDkaGnQFcQ@mail.gmail.com>
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

Normally the first file header for a given file in xfsdump is followed
by one or more extent headers along with the file data. If there is a
problem opening the file, the file header will not be dumped and the
file will not be created during a restore. This is working as designed.

However if the inode indicates the file has extended attributes, a file
header will be dumped followed by an extended attribute header.  Since
this is the first file header xfsrestore sees for the file, it expects
to see an extent header and bails out complaining about an extent header
checksum error. This patch changes xfsrestore to look for the extended
attribute flag on the file header even if it's the first file header
seen for the file. The result is a zero-length file will be restored
along with the extended attributes, if they were successfully backed up.
More importantly, xfsrestore will continue on to restore the rest of the
backup.

This patch also changes xfsdump so that if it fails to open a file, it
does not try to dump the extended attributes. This prevents xfsrestore
from creating zero-length files in the situation described above.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 dump/content.c    |   13 ++++++++++---
 restore/content.c |   29 ++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index 3a7f508..f915a8b 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -270,7 +270,8 @@ static rv_t dump_file_reg( drive_t *drivep,
 			   context_t *contextp,
 			   content_inode_hdr_t *scwhdrp,
 			   jdm_fshandle_t *,
-			   xfs_bstat_t * );
+			   xfs_bstat_t *,
+			   bool_t *);
 static rv_t dump_file_spec( drive_t *drivep,
 			    context_t *contextp,
 			    jdm_fshandle_t *,
@@ -3690,6 +3691,7 @@ dump_file( void *arg1,
 				       cwhdrp->ch_specific;
 	startpt_t *startptp = &scwhdrp->cih_startpt;
 	startpt_t *endptp = &scwhdrp->cih_endpt;
+	bool_t file_skipped = BOOL_FALSE;
 	intgen_t state;
 	rv_t rv;
 
@@ -3835,7 +3837,8 @@ dump_file( void *arg1,
 				    contextp,
 				    scwhdrp,
 				    fshandlep,
-				    statp );
+				    statp,
+				    &file_skipped );
 		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
 			lock( );
 			sc_stat_nondirdone++;
@@ -3883,6 +3886,8 @@ dump_file( void *arg1,
 
 	if ( rv == RV_OK
 	     &&
+	     file_skipped == BOOL_FALSE
+	     &&
 	     sc_dumpextattrpr
 	     &&
 	     ( statp->bs_xflags & XFS_XFLAG_HASATTR )) {
@@ -3903,7 +3908,8 @@ dump_file_reg( drive_t *drivep,
 	       context_t *contextp,
 	       content_inode_hdr_t *scwhdrp,
 	       jdm_fshandle_t *fshandlep,
-	       xfs_bstat_t *statp )
+	       xfs_bstat_t *statp,
+	       bool_t *file_skippedp )
 {
 	startpt_t *startptp = &scwhdrp->cih_startpt;
 	startpt_t *endptp = &scwhdrp->cih_endpt;
@@ -3996,6 +4002,7 @@ dump_file_reg( drive_t *drivep,
 		      statp->bs_ino,
 		      statp->bs_mode,
 		      strerror( errno ));
+		*file_skippedp = BOOL_TRUE;
 		return RV_OK;
 	}
 
diff --git a/restore/content.c b/restore/content.c
index a9e0b20..a773552 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -763,6 +763,7 @@ static rv_t read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs );
 static rv_t restore_file( drive_t *drivep,
 			  filehdr_t *fhdrp,
 			  bool_t ehcs,
+			  bool_t ahcs,
 			  char *path1,
 			  char *path2 );
 static bool_t restore_reg( drive_t *drivep,
@@ -3425,7 +3426,7 @@ applynondirdump( drive_t *drivep,
 			strctxp->sc_path[0] = '\0';
 			strctxp->sc_fd = -1;
 
-			rv = restore_file( drivep, fhdrp, ehcs, path1, path2 );
+			rv = restore_file( drivep, fhdrp, ehcs, ahcs, path1, path2 );
 
 		} else if ( fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR ) {
 			rv = restore_extattr( drivep,
@@ -7153,6 +7154,7 @@ struct cb_context {
 	filehdr_t *cb_fhdrp;
 	rv_t cb_rv;
 	bool_t cb_ehcs;
+	bool_t cb_ahcs;
 	char *cb_path1;
 	char *cb_path2;
 };
@@ -7165,6 +7167,7 @@ static rv_t
 restore_file( drive_t *drivep,
 	      filehdr_t *fhdrp,
 	      bool_t ehcs,
+	      bool_t ahcs,
 	      char *path1,
 	      char *path2 )
 {
@@ -7180,6 +7183,7 @@ restore_file( drive_t *drivep,
 	context.cb_fhdrp = fhdrp;
 	context.cb_rv = RV_OK;
 	context.cb_ehcs = ehcs;
+	context.cb_ahcs = ahcs;
 	context.cb_path1 = path1;
 	context.cb_path2 = path2;
 	rv = tree_cb_links( bstatp->bs_ino,
@@ -7212,6 +7216,7 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	rv_t *rvp = &contextp->cb_rv;
 	bool_t ehcs = contextp->cb_ehcs;
+	bool_t ahcs = contextp->cb_ahcs;
 	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
 
 	int rval;
@@ -7237,12 +7242,22 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
 			ok = restore_reg( drivep, fhdrp, rvp, path1 );
 			if (!ok)
 				return ok;
-			ok = restore_extent_group( drivep,
-						   fhdrp,
-						   path1,
-						   strctxp->sc_fd,
-						   ehcs,
-						   rvp );
+			if ( fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR ) {
+				*rvp = restore_extattr( drivep,
+							fhdrp,
+							path1,
+							ahcs,
+							BOOL_FALSE, /* isdirpr */
+							BOOL_FALSE, /* onlydoreadpr */
+							DAH_NULL );
+			} else {
+				ok = restore_extent_group( drivep,
+							   fhdrp,
+							   path1,
+							   strctxp->sc_fd,
+							   ehcs,
+							   rvp );
+			}
 			return ok;
 		case S_IFBLK:
 		case S_IFCHR:
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
