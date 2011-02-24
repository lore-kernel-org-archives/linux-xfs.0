Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OGNThJ147615 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 10:23:30 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8E6E8F80A8
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 08:26:12 -0800 (PST)
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: prune inventory sessions by session id
Date: Thu, 24 Feb 2011 10:25:20 -0600
Message-Id: <1298564720-11447-1-git-send-email-wkendall@sgi.com>
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

Allow xfsinvutil to prune inventory sessions by their ID
instead of only by filesystem and cutoff date.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 invutil/getopt.h      |    3 +-
 invutil/invutil.c     |   99 ++++++++++++++++++++++++++++++++++++++----------
 invutil/invutil.h     |    7 ++-
 man/man8/xfsinvutil.8 |    7 +++
 4 files changed, 91 insertions(+), 25 deletions(-)

diff --git a/invutil/getopt.h b/invutil/getopt.h
index 14c9ec5..7170ac6 100644
--- a/invutil/getopt.h
+++ b/invutil/getopt.h
@@ -18,7 +18,7 @@
 #ifndef GETOPT_H
 #define GETOPT_H
 
-#define GETOPT_CMDSTRING	"dilnu:wCFM:m:"
+#define GETOPT_CMDSTRING	"dilnu:wCFM:m:s:"
 
 #define GETOPT_DEBUG		'd'	/* debug */
 #define GETOPT_INTERACTIVE	'i'	/* interactive mode */
@@ -29,5 +29,6 @@
 #define GETOPT_FORCE		'F'	/* force - do not ask for confirmation */
 #define GETOPT_PRUNEMNT		'M'	/* prune mount point */
 #define GETOPT_PRUNEMEDIALABEL	'm'	/* prune media label */
+#define GETOPT_PRUNESESSION	's'	/* prune session id */
 
 #endif /* GETOPT_H */
diff --git a/invutil/invutil.c b/invutil/invutil.c
index af6836b..37489c0 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -60,15 +60,18 @@ main(int argc, char *argv[])
     bool_t mntpnt_option = BOOL_FALSE;
     bool_t uuid_option = BOOL_FALSE;
     bool_t interactive_option = BOOL_FALSE;
+    bool_t session_option = BOOL_FALSE;
     static char version[32];
     char *mntPoint = NULL;
     char *r_mf_label = NULL;
     uuid_t uuid;
+    uuid_t session;
 
     snprintf(version, sizeof(version), "version %s", VERSION);
     g_programName = basename(argv[0]);
     g_programVersion = version;
     uuid_clear(uuid);
+    uuid_clear(session);
 
     while((c = getopt( argc, argv, GETOPT_CMDSTRING)) != EOF) {
 	switch(c) {
@@ -83,6 +86,13 @@ main(int argc, char *argv[])
 			 c );
 		usage();
 	    }
+	    if (session_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 GETOPT_PRUNESESSION,
+			 c );
+		usage();
+	    }
 	    interactive_option = BOOL_TRUE;
 	    break;
 	case GETOPT_NONINTERACTIVE: /* obsoleted by -F */
@@ -103,10 +113,10 @@ main(int argc, char *argv[])
 			 c );
 		usage();
 	    }
-	    if (mntpnt_option) {
+	    if (mntpnt_option || session_option) {
 		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
-			 GETOPT_PRUNEMNT,
+			 mntpnt_option ? GETOPT_PRUNEMNT : GETOPT_PRUNESESSION,
 			 c );
 		usage();
 	    }
@@ -131,6 +141,13 @@ main(int argc, char *argv[])
 			 c );
 		usage();
 	    }
+	    if (session_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 GETOPT_PRUNESESSION,
+			 c );
+		usage();
+	    }
 	    check_option = BOOL_TRUE;
 	    break;
 	case GETOPT_FORCE:
@@ -151,10 +168,10 @@ main(int argc, char *argv[])
 			 c );
 		usage();
 	    }
-	    if (uuid_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n", 
+	    if (uuid_option || session_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
-			 GETOPT_UUID,
+			 uuid_option ? GETOPT_UUID : GETOPT_PRUNESESSION,
 			 c );
 		usage();
 	    }
@@ -164,6 +181,31 @@ main(int argc, char *argv[])
 	case GETOPT_PRUNEMEDIALABEL:
 	    r_mf_label = optarg;
 	    break;
+	case GETOPT_PRUNESESSION:
+	    if (check_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 GETOPT_CHECKPRUNEFSTAB,
+			 c );
+		usage();
+	    }
+	    if (interactive_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 GETOPT_INTERACTIVE,
+			 c );
+		usage();
+	    }
+	    if (mntpnt_option || uuid_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 mntpnt_option ? GETOPT_PRUNEMNT : GETOPT_UUID,
+			 c );
+		usage();
+	    }
+	    session_option = BOOL_TRUE;
+	    uuid_parse(optarg, session);
+	    break;
 	default:
 	    usage();
 	    break;
@@ -209,7 +251,12 @@ main(int argc, char *argv[])
         char *tempstr = "test";
         time32_t temptime = 0;
         CheckAndPruneFstab(inventory_path, BOOL_TRUE, tempstr, &uuid,
-		temptime, NULL);
+		&session, temptime, NULL);
+    }
+    else if (session_option) {
+	CheckAndPruneFstab(
+		    inventory_path, BOOL_FALSE , mntPoint, &uuid,
+		    &session, (time32_t)0, r_mf_label);
     }
     else if (uuid_option || mntpnt_option) {
         time32_t timeSecs = ParseDate(argv[optind]);
@@ -221,7 +268,7 @@ main(int argc, char *argv[])
 	else {
 	    CheckAndPruneFstab(
 		    inventory_path, BOOL_FALSE , mntPoint, &uuid,
-		    timeSecs, r_mf_label);
+		    &session, timeSecs, r_mf_label);
 	}
     }
     else if ( interactive_option ) {
@@ -396,7 +443,7 @@ GetFstabFullPath(char *inv_path)
 
 void
 CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
-	uuid_t *uuidp, time32_t prunetime, char *r_mf_label)
+	uuid_t *uuidp, uuid_t *sessionp, time32_t prunetime, char *r_mf_label)
 {
     char	*fstabname;
     char	*mapaddr;
@@ -410,8 +457,9 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
     invt_fstab_t *fstabentry;
     invt_counter_t *counter,cnt;
 
-    if (mountPt == NULL && uuid_is_null(*uuidp)) {
-	fprintf( stderr, "%s: neither mountpoint nor uuid specified\n", g_programName );
+    if (mountPt == NULL && uuid_is_null(*uuidp) && uuid_is_null(*sessionp)) {
+	fprintf( stderr, "%s: mountpoint, uuid or session "
+			 "must be specified\n", g_programName );
 	fprintf( stderr, "%s: abnormal termination\n", g_programName );
 	exit(1);
     }
@@ -480,10 +528,16 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 		    printf("     Match on directory name only: %s\n", mountPt);
 		    IdxCheckOnly = BOOL_FALSE;
 		}
+		else if (!uuid_is_null(*sessionp)) {
+		    // no session id to match against yet, defer deciding if this is
+		    // a check-only run until we have a session
+		    IdxCheckOnly = BOOL_FALSE;
+		}
 	    }
 
 	    if (CheckAndPruneInvIndexFile(
-			IdxCheckOnly, invname , prunetime, r_mf_label) == -1 ) {
+			IdxCheckOnly, invname, sessionp,
+			prunetime, r_mf_label) == -1 ) {
 		removeflag = BOOL_TRUE;
 	    }
 
@@ -538,6 +592,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 int
 CheckAndPruneInvIndexFile( bool_t checkonly,
 			   char *idxFileName,
+			   uuid_t *sessionp,
 			   time32_t prunetime,
 			   char *r_mf_label) 
 {
@@ -551,7 +606,6 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
     invt_entry_t *invIndexEntry;
     invt_counter_t *counter;
     invt_counter_t header;
-    bool_t IdxCheckOnly = BOOL_TRUE;
 
     printf("      processing index file \n"
 	   "       %s\n",idxFileName);
@@ -594,14 +648,8 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 	    removeflag = BOOL_TRUE;
 	}    
 
-	if (( !removeflag ) && (checkonly == BOOL_FALSE) && 
-		( invIndexEntry[i].ie_timeperiod.tp_start < prunetime))
-	{
-	    IdxCheckOnly = BOOL_FALSE;
-	    printf("          Mount point match\n");
-	}
-	if (CheckAndPruneStObjFile(IdxCheckOnly, invIndexEntry[i].ie_filename,
-		    prunetime, r_mf_label) == -1) {
+	if (CheckAndPruneStObjFile(checkonly, invIndexEntry[i].ie_filename,
+		    sessionp, prunetime, r_mf_label) == -1) {
 	    removeflag = BOOL_TRUE; /* The StObj is gone */
 	}
 
@@ -657,6 +705,7 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 int
 CheckAndPruneStObjFile( bool_t checkonly,
 			char *StObjFileName,
+			uuid_t *sessionp,
 			time32_t prunetime,
 		        char *r_mf_label) 
 {
@@ -668,6 +717,7 @@ CheckAndPruneStObjFile( bool_t checkonly,
     bool_t	removeflag;
     int		prunedcount = 0;
     int		removedcount = 0;
+    bool_t	session_match;
 
     struct stat	sb;
     char	str[UUID_STR_LEN + 1];
@@ -776,9 +826,14 @@ CheckAndPruneStObjFile( bool_t checkonly,
                checkonly, StObjhdr->sh_pruned); 
 #endif
 
+	session_match = !uuid_compare(*sessionp, StObjses->s_sesid);
+	if (session_match) {
+	    printf("\t\tMatch on session id\n");
+	}
+
 	if ((checkonly == BOOL_FALSE)
 	    && (! StObjhdr->sh_pruned)
-	    && (StObjhdr->sh_time < prunetime)
+	    && ((StObjhdr->sh_time < prunetime) || session_match)
 	    && (uses_specified_mf_label(StObjhdr, StObjses, temp, r_mf_label))){
 	    bool_t GotResponse = BOOL_FALSE;
 
@@ -1112,6 +1167,8 @@ usage (void)
 		    pfxsz, "", g_programName);
     fprintf(stderr, "%*s%s [-F|-i] [-m media_label] -u UUID mm/dd/yyyy\n",
 		    pfxsz, "", g_programName);
+    fprintf(stderr, "%*s%s [-F] -s SESSION_ID\n",
+		    pfxsz, "", g_programName);
     fprintf(stderr, "%*s%s -i\n", pfxsz, "", g_programName);
     fprintf(stderr, "%*s%s -C\n", pfxsz, "", g_programName);
 
diff --git a/invutil/invutil.h b/invutil/invutil.h
index dc42108..f1b1681 100644
--- a/invutil/invutil.h
+++ b/invutil/invutil.h
@@ -44,9 +44,10 @@ extern bool_t	wait_for_locks;
 char *	GetFstabFullPath(char *);
 char *	GetNameOfInvIndex (char *, uuid_t);
 char *	GetNameOfStobj (char *inv_path, char *filename);
-void	CheckAndPruneFstab(char *, bool_t, char *, uuid_t *, time32_t, char *);
-int	CheckAndPruneInvIndexFile( bool_t, char *, time32_t, char *);
-int	CheckAndPruneStObjFile( bool_t, char *, time32_t, char *);
+void	CheckAndPruneFstab(
+		char *, bool_t, char *, uuid_t *, uuid_t *, time32_t, char *);
+int	CheckAndPruneInvIndexFile( bool_t, char *, uuid_t *, time32_t, char *);
+int	CheckAndPruneStObjFile( bool_t, char *, uuid_t *, time32_t, char *);
 int	uses_specified_mf_label(
 		invt_seshdr_t *, invt_session_t *, char	*, char *);
 time32_t ParseDate(char *);
diff --git a/man/man8/xfsinvutil.8 b/man/man8/xfsinvutil.8
index 27db5dc..cb878be 100644
--- a/man/man8/xfsinvutil.8
+++ b/man/man8/xfsinvutil.8
@@ -5,6 +5,7 @@ xfsinvutil \- \&xfsdump inventory database checking and pruning utility
 .nf
 \f3xfsinvutil\f1 [\-F|\-i] [\-m \f2media_label\f1] \-M \f2mount_point\f1 \f2mm/dd/yyyy\f1
 \f3xfsinvutil\f1 [\-F|\-i] [\-m \f2media_label\f1] \-u \f2UUID\f1 \f2mm/dd/yyyy\f1
+\f3xfsinvutil\f1 [\-F] \-s \f2SESSION_ID\f1
 \f3xfsinvutil\f1 \-i
 \f3xfsinvutil\f1 \-C
 .fi
@@ -64,6 +65,12 @@ in addition to those imposed by the date and the \f3\-M\f1 or
 references to media which may have been overwritten or lost. Note that
 this option does not apply to sessions with no media files.
 .TP 5
+\f3\-s\f1 \f2SESSION_ID\f1
+Prunes the dump session identified by the given session id.
+.I xfsinvutil
+will prompt the operator prior to pruning a dump session unless
+the \f3\-F\f1 option is given.
+.TP 5
 .B \-C
 With this option, 
 .I xfsinvutil 
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
