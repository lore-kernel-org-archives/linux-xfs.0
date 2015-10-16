Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B00C7F3F
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 20:45:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26B01AC003
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:45:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yY5E34ehLO2aEgeH for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 18:45:19 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zmu4v-00019x-0O
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zmu4u-00006K-VB
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] cleanup: move fold_t out of util.h
Date: Fri, 16 Oct 2015 12:45:00 +1100
Message-Id: <1444959901-31319-8-git-send-email-david@fromorbit.com>
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

Many files just want the fold_t type, but pulling in util.h requires
all the XFS and JDM headers to be pulled in, too. Move fold_t to
mlog.[ch] as it tends to be common with log output. Similarly, move
the PREEMPT_* definitions to common/types.h to remove that
dependency on util.h as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/mlog.c  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 common/mlog.h  |  6 ++++++
 common/types.h |  5 +++++
 common/util.c  | 45 ---------------------------------------------
 common/util.h  | 11 -----------
 5 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/common/mlog.c b/common/mlog.c
index fd21c18..c8b3129 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -802,3 +802,48 @@ mlog_sym_lookup( char *sym )
 
 	return -1;
 }
+
+void
+fold_init( fold_t fold, char *infostr, char c )
+{
+	size_t infolen;
+	size_t dashlen;
+	size_t predashlen;
+	size_t postdashlen;
+	char *p;
+	char *endp;
+	ix_t cnt;
+
+	assert( sizeof( fold_t ) == FOLD_LEN + 1 );
+
+	infolen = strlen( infostr );
+	if ( infolen > FOLD_LEN - 4 ) {
+		infolen = FOLD_LEN - 4;
+	}
+	dashlen = FOLD_LEN - infolen - 3;
+	predashlen = dashlen / 2;
+	postdashlen = dashlen - predashlen;
+
+	p = &fold[ 0 ];
+	endp = &fold[ sizeof( fold_t ) - 1 ];
+
+	assert( p < endp );
+	*p++ = ' ';
+	for ( cnt = 0 ; cnt < predashlen && p < endp ; cnt++, p++ ) {
+		*p = c;
+	}
+	assert( p < endp );
+	*p++ = ' ';
+	assert( p < endp );
+	assert( p + infolen < endp );
+	strcpy( p, infostr );
+	p += infolen;
+	assert( p < endp );
+	*p++ = ' ';
+	assert( p < endp );
+	for ( cnt = 0 ; cnt < postdashlen && p < endp ; cnt++, p++ ) {
+		*p = c;
+	}
+	assert( p <= endp );
+	*p = 0;
+}
diff --git a/common/mlog.h b/common/mlog.h
index d7bbfce..e080f9e 100644
--- a/common/mlog.h
+++ b/common/mlog.h
@@ -123,4 +123,10 @@ extern void mlog_exit_flush( void );
 extern void mlog_lock( void );
 extern void mlog_unlock( void );
 
+/* fold_t - a character string made to look like a "fold here"
+ */
+#define FOLD_LEN	79
+typedef char fold_t[ FOLD_LEN + 1 ];
+extern void fold_init( fold_t fold, char *infostr, char c );
+
 #endif /* MLOG_H */
diff --git a/common/types.h b/common/types.h
index 0923897..f902828 100644
--- a/common/types.h
+++ b/common/types.h
@@ -136,4 +136,9 @@ typedef struct stat64 stat64_t;
 typedef struct getbmapx getbmapx_t;
 typedef struct fsdmidata fsdmidata_t;
 
+/* flg definitions for preemptchk 
+ */
+#define PREEMPT_FULL		0
+#define PREEMPT_PROGRESSONLY	1
+
 #endif /* TYPES_H */
diff --git a/common/util.c b/common/util.c
index 93dd9c8..0d49d5c 100644
--- a/common/util.c
+++ b/common/util.c
@@ -532,48 +532,3 @@ cvtnum( int blocksize, char *s )
 		return 1024 * 1024 * i;
 	return -1;
 }
-
-void
-fold_init( fold_t fold, char *infostr, char c )
-{
-	size_t infolen;
-	size_t dashlen;
-	size_t predashlen;
-	size_t postdashlen;
-	char *p;
-	char *endp;
-	ix_t cnt;
-
-	assert( sizeof( fold_t ) == FOLD_LEN + 1 );
-
-	infolen = strlen( infostr );
-	if ( infolen > FOLD_LEN - 4 ) {
-		infolen = FOLD_LEN - 4;
-	}
-	dashlen = FOLD_LEN - infolen - 3;
-	predashlen = dashlen / 2;
-	postdashlen = dashlen - predashlen;
-
-	p = &fold[ 0 ];
-	endp = &fold[ sizeof( fold_t ) - 1 ];
-
-	assert( p < endp );
-	*p++ = ' ';
-	for ( cnt = 0 ; cnt < predashlen && p < endp ; cnt++, p++ ) {
-		*p = c;
-	}
-	assert( p < endp );
-	*p++ = ' ';
-	assert( p < endp );
-	assert( p + infolen < endp );
-	strcpy( p, infostr );
-	p += infolen;
-	assert( p < endp );
-	*p++ = ' ';
-	assert( p < endp );
-	for ( cnt = 0 ; cnt < postdashlen && p < endp ; cnt++, p++ ) {
-		*p = c;
-	}
-	assert( p <= endp );
-	*p = 0;
-}
diff --git a/common/util.h b/common/util.h
index 5284811..558bf7e 100644
--- a/common/util.h
+++ b/common/util.h
@@ -143,22 +143,11 @@ extern int diriter( jdm_fshandle_t *fshandlep,
 			 size_t usrgdsz );
 
 
-/* fold_t - a character string made to look like a "fold here"
- */
-#define FOLD_LEN	79
-typedef char fold_t[ FOLD_LEN + 1 ];
-extern void fold_init( fold_t fold, char *infostr, char c );
-
 
 /* macro to copy uuid structures
  */
 #define COPY_LABEL( lab1, lab2) ( bcopy( lab1, lab2, GLOBAL_HDR_STRING_SZ) )
 
-/* flg definitions for preemptchk 
- */
-#define PREEMPT_FULL		0
-#define PREEMPT_PROGRESSONLY	1
-
 /*
  * Align pointer up to alignment
  */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
