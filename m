Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o31KcF4A144464 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 15:38:15 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 131DCAC011
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 13:39:57 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 03F4B7001E56
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 15:39:57 -0500 (CDT)
Date: Thu, 1 Apr 2010 15:39:56 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: exempt quota files from filesize checks
Message-ID: <20100401203956.GA28295@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfsdump backs up quota information by generating quota dump files
("xfs_quota -c dump") in the root of the filesystem being dumped.  If the
user filters files from the dump based on max file size (-z option) the
quota files may not be dumped. The following patch makes the quota files
exempt from the max filesize checks.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

diff --git a/common/content.h b/common/content.h
index e21f38e..03b72f0 100644
--- a/common/content.h
+++ b/common/content.h
@@ -65,6 +65,8 @@ typedef struct content_hdr content_hdr_t;
 #define CONTENT_PQUOTAFILE	"xfsdump_quotas_proj"
 #define CONTENT_GQUOTAFILE	"xfsdump_quotas_group"
 
+#ifdef DUMP
+
 struct quota_info {
 	char *	desc;		/* Quotas type (user, project, etc) */
 	bool_t	savequotas;	/* Quotas saved OK */
@@ -72,10 +74,14 @@ struct quota_info {
 	char	quotapath[MAXPATHLEN]; /* Full path to quotafile */
 	char *	repquotaargs;	/* Args to repquota to create this quotafile */
 	int	statflag;	/* quota stats flag for this type */
+	ino_t	quotaino;	/* ino of the quota file */
 };
 
 typedef struct quota_info quota_info_t;
 
+extern bool_t is_quota_file(ino_t ino);
+
+#endif /* DUMP */
 
 #ifdef DUMP
 extern bool_t content_init( intgen_t argc,
diff --git a/dump/content.c b/dump/content.c
index 7637fee..c6840e5 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -498,9 +498,9 @@ static bool_t sc_savequotas = BOOL_TRUE;
 /* save quota information in dump
  */
 static quota_info_t quotas[] = {
-	{ "user quota",		BOOL_TRUE,	CONTENT_QUOTAFILE,	"", "-uf", XFS_QUOTA_UDQ_ACCT },
-	{ "project quota",	BOOL_TRUE,	CONTENT_PQUOTAFILE,	"", "-pf", XFS_QUOTA_PDQ_ACCT },
-	{ "group quota",	BOOL_TRUE,	CONTENT_GQUOTAFILE,	"", "-gf", XFS_QUOTA_GDQ_ACCT }
+	{ "user quota",		BOOL_TRUE,	CONTENT_QUOTAFILE,	"", "-uf", XFS_QUOTA_UDQ_ACCT, 0 },
+	{ "project quota",	BOOL_TRUE,	CONTENT_PQUOTAFILE,	"", "-pf", XFS_QUOTA_PDQ_ACCT, 0 },
+	{ "group quota",	BOOL_TRUE,	CONTENT_GQUOTAFILE,	"", "-gf", XFS_QUOTA_GDQ_ACCT, 0 }
 };
 
 /* definition of locally defined global functions ****************************/
@@ -3976,7 +3976,9 @@ dump_file( void *arg1,
 						     1);
 			}
 
-			if (estimated_size > maxdumpfilesize) {
+			/* quota files are exempt from max size check */
+			if (estimated_size > maxdumpfilesize &&
+			    !is_quota_file(statp->bs_ino)) {
 				mlog( MLOG_DEBUG | MLOG_NOTE,
 				      "ino %llu increased beyond maximum size: "
 				      "NOT dumping\n",
@@ -6698,6 +6700,18 @@ check_complete_flags( void )
 	return completepr;
 }
 
+extern bool_t
+is_quota_file(ino_t ino)
+{
+	int i;
+
+	for(i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
+		if (quotas[i].savequotas && ino == quotas[i].quotaino)
+			return BOOL_TRUE;
+	}
+	return BOOL_FALSE;
+}
+
 #define REPQUOTA "xfs_quota"
 
 static bool_t
@@ -6707,6 +6721,7 @@ save_quotas( char *mntpnt, quota_info_t *quotainfo )
         char            buf[1024] = "";
         int             fd;
         char            tmp;
+        struct stat     statb;
 
         mlog( MLOG_VERBOSE, _(
 		"saving %s information for: %s\n"), quotainfo->desc, mntpnt );
@@ -6747,6 +6762,16 @@ save_quotas( char *mntpnt, quota_info_t *quotainfo )
                   strerror( errno ));
             return BOOL_FALSE;
         }
+        if(fstat(fd, &statb) < 0) {
+            mlog( MLOG_ERROR, _(
+                  "stat failed %s: %s\n"),
+                  quotainfo->quotapath,
+                  strerror( errno ));
+            close(fd);
+            return BOOL_FALSE;
+        }
+        quotainfo->quotaino = statb.st_ino;
+
         /* open and read dump file to ensure it is in the dump */
         read(fd, &tmp, 1);
         close(fd);
diff --git a/dump/inomap.c b/dump/inomap.c
index 3a5cda0..fcb5792 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -558,10 +558,12 @@ cb_add( void *arg1,
 		} else {
 			estimated_size = estimate_dump_space( statp );
 
-			/* skip if size is greater than prune size
+			/* skip if size is greater than prune size. quota
+			 * files are exempt from the check.
 			 */
 			if ( maxdumpfilesize > 0 &&
-			     estimated_size > maxdumpfilesize ) {
+			     estimated_size > maxdumpfilesize &&
+			     !is_quota_file(statp->bs_ino) ) {
 				mlog( MLOG_DEBUG | MLOG_EXCLFILES,
 				      "pruned ino %llu, owner %u, estimated size %llu: maximum size exceeded\n",
 				      statp->bs_ino,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
