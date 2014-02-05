Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B89DE7F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 19:49:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FC21AC003
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 17:49:03 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	25CgevVVQQOd43Vw for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 17:48:58 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WArbT-0003mH-1Z
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 12:48:39 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WArbT-0006eI-0M
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 12:48:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] restore: don't trash file capabilities
Date: Wed,  5 Feb 2014 12:48:38 +1100
Message-Id: <1391564918-25524-1-git-send-email-david@fromorbit.com>
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

xfsrestore fails to restore file capabilities correctly because it
sets the owner on the file after it has restored the capability
attributes. This results in the kernel stripping the capabilities
when changing the owner of the file and hence the restored file is
not complete.

Fix this by changing the owner of the file when it is created rather
than after it has been fully restored. This ensures we don't kill
the caps as they are restored after the owner it appropriately set.
This fixes the xfs/296 failure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 restore/content.c | 116 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 77 insertions(+), 39 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 54d933c..b655ed1 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -362,6 +362,15 @@ struct stream_context {
 	char       sc_path[2 * MAXPATHLEN];
 	intgen_t   sc_fd;
 	intgen_t   sc_hsmflags;
+
+	/*
+	 * we have to set the owner before we set extended attributes otherwise
+	 * capabilities will not be restored correctly as setting the owner with
+	 * fchmod will strip the capability attribute from the file. Hence we
+	 * need to do this before restoring xattrs and record it so we don't do
+	 * it again on completion of file restoration.
+	 */
+	bool_t	   sc_ownerset;
 };
 
 typedef struct stream_context stream_context_t;
@@ -3429,6 +3438,8 @@ applynondirdump( drive_t *drivep,
 	memset(&strctxp->sc_bstat, 0, sizeof(bstat_t));
 	strctxp->sc_path[0] = '\0';
 	strctxp->sc_fd = -1;
+	strctxp->sc_ownerset = BOOL_FALSE;
+
 
 	for ( ; ; ) {
 		drive_ops_t *dop = drivep->d_opsp;
@@ -3455,6 +3466,7 @@ applynondirdump( drive_t *drivep,
 			memcpy(&strctxp->sc_bstat, bstatp, sizeof(bstat_t));
 			strctxp->sc_path[0] = '\0';
 			strctxp->sc_fd = -1;
+			strctxp->sc_ownerset = BOOL_FALSE;
 
 			rv = restore_file( drivep, fhdrp, ehcs, ahcs, path1, path2 );
 
@@ -7351,6 +7363,61 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
 	}
 }
 
+/*
+ * Set the file owner and strip suid/sgid if necessary. On failure, it will
+ * close the file descriptor, unlink the file and return -1. On success,
+ * it will mark the stream contexts as having set the owner and return 0.
+ */
+static int
+set_file_owner(
+	char		 *path,
+	intgen_t	 *fdp,
+	stream_context_t *strcxtp)
+{
+	bstat_t		*bstatp = &strcxtp->sc_bstat;
+	mode_t		mode = (mode_t)bstatp->bs_mode;
+	int		rval;
+
+	rval = fchown(*fdp, (uid_t)bstatp->bs_uid, (gid_t)bstatp->bs_gid );
+	if (!rval)
+		goto done;
+
+	mlog(MLOG_VERBOSE | MLOG_WARNING,
+	     _("chown (uid=%u, gid=%u) %s failed: %s\n"),
+	     bstatp->bs_uid, bstatp->bs_gid, path, strerror(errno));
+
+	if (mode & S_ISUID) {
+		mlog(MLOG_VERBOSE | MLOG_WARNING,
+		     _("stripping setuid bit on %s since chown failed\n"),
+		     path);
+		mode &= ~S_ISUID;
+	}
+
+	if ((mode & (S_ISGID|S_IXGRP)) == (S_ISGID|S_IXGRP)) {
+		mlog(MLOG_VERBOSE | MLOG_WARNING,
+		     _("stripping setgid bit on %s since chown failed\n"),
+		     path);
+		mode &= ~S_ISGID;
+	}
+
+	if (mode == (mode_t)bstatp->bs_mode)
+		goto done;
+
+	rval = fchmod(*fdp, mode);
+	if (rval) {
+		mlog(MLOG_VERBOSE | MLOG_ERROR,
+		     _("unable to strip setuid/setgid on %s, unlinking file.\n"),
+		     path);
+		unlink(path);
+		close(*fdp);
+		*fdp = -1;
+		return -1;
+	}
+done:
+	strcxtp->sc_ownerset = BOOL_TRUE;
+	return 0;
+}
+
 /* called to begin a regular file. if no path given, or if just toc,
  * don't actually write, just read. also get into that situation if
  * cannot prepare destination. fd == -1 signifies no write. *statp
@@ -7442,6 +7509,12 @@ restore_reg( drive_t *drivep,
 		}
 	}
 
+	if (strctxp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
+		rval = set_file_owner(path, fdp, strctxp);
+		if (rval)
+			return BOOL_TRUE;
+	}
+
 	if ( persp->a.dstdirisxfspr ) {
 
 		/* set the extended inode flags, except those which must
@@ -7623,45 +7696,10 @@ restore_complete_reg(stream_context_t *strcxtp)
 
 	/* set the owner and group (if enabled)
 	 */
-	if ( persp->a.ownerpr ) {
-		rval = fchown( fd,
-			       ( uid_t )bstatp->bs_uid,
-			       ( gid_t )bstatp->bs_gid );
-		if ( rval ) {
-			mode_t mode = (mode_t)bstatp->bs_mode;
-
-			mlog( MLOG_VERBOSE | MLOG_WARNING,
-			      _("chown (uid=%u, gid=%u) %s failed: %s\n"),
-			      bstatp->bs_uid,
-			      bstatp->bs_gid,
-			      path,
-			      strerror( errno ));
-
-			if ( mode & S_ISUID ) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING,
-				      _("stripping setuid bit on %s "
-				      "since chown failed\n"),
-				      path );
-				mode &= ~S_ISUID;
-			}
-			if ( (mode & (S_ISGID|S_IXGRP)) == (S_ISGID|S_IXGRP) ) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING,
-				      _("stripping setgid bit on %s "
-				      "since chown failed\n"),
-				      path );
-				mode &= ~S_ISGID;
-			}
-			if ( mode != (mode_t)bstatp->bs_mode ) {
-				rval = fchmod( fd, mode );
-				if ( rval ) {
-					mlog( MLOG_VERBOSE | MLOG_ERROR,
-					      _("unable to strip setuid/setgid "
-					      "on %s, unlinking file.\n"),
-					      path );
-					unlink( path );
-				}
-			}
-		}
+	if (strcxtp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
+		rval = set_file_owner(path, &fd, strcxtp);
+		if (rval)
+			return BOOL_TRUE;
 	}
 
 	/* set the permissions/mode
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
