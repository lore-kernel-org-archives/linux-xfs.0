Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 30D397F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 10:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A37D30405F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:46 -0700 (PDT)
Received: from mail-qg0-f42.google.com (mail-qg0-f42.google.com
	[209.85.192.42]) by cuda.sgi.com with ESMTP id EFslaLtW97zdubqX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:45 -0700 (PDT)
Received: by mail-qg0-f42.google.com with SMTP id q107so7864217qgd.15
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:44 -0700 (PDT)
Received: from tlielax.poochiereds.net ([2001:470:8:d63:3a60:77ff:fe93:a95d])
	by mx.google.com with ESMTPSA id
	r15sm10025356qgr.15.2014.05.12.08.06.43 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 12 May 2014 08:06:44 -0700 (PDT)
From: Jeff Layton <jlayton@poochiereds.net>
Subject: [xfstests PATCH 3/4] locktest: consolidate do_lock and do_unlock,
	and add ability to F_GETLK
Date: Mon, 12 May 2014 11:06:32 -0400
Message-Id: <1399907193-23857-4-git-send-email-jlayton@poochiereds.net>
In-Reply-To: <1399907193-23857-1-git-send-email-jlayton@poochiereds.net>
References: <1399907193-23857-1-git-send-email-jlayton@poochiereds.net>
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

Eliminate do_unlock as it's just cut-and-paste of do_lock (down to the
bad stderr fprintf). Fix the debug messages to print the cmd and type,
and add the ability to do a WRTEST and RDTEST.

Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 src/locktest.c | 61 ++++++++++++++++++++++------------------------------------
 1 file changed, 23 insertions(+), 38 deletions(-)

diff --git a/src/locktest.c b/src/locktest.c
index 0a674a7ff5c2..c9cd04ca4a59 100644
--- a/src/locktest.c
+++ b/src/locktest.c
@@ -110,6 +110,8 @@ static int	D_flag = 0;
 #define		UNLOCK	2
 #define		F_CLOSE	3
 #define		F_OPEN	4
+#define		WRTEST	5
+#define		RDTEST	6
 
 #define		PASS 	1
 #define		FAIL	0
@@ -629,14 +631,14 @@ int do_open(int flag)
     return PASS;
 }
 
-int do_lock(int type, int start, int length)
+static int do_lock(int cmd, int type, int start, int length)
 {
     int ret;
     int filedes = f_fd;
     struct flock fl;
 
     if(debug > 1) {
-	fprintf(stderr, "do_lock: start=%d, length=%d\n", start, length);
+	fprintf(stderr, "do_lock: cmd=%d type=%d start=%d, length=%d\n", cmd, type, start, length);
     }
 
     if (f_fd < 0)
@@ -650,7 +652,7 @@ int do_lock(int type, int start, int length)
 
     errno = 0;
 
-    ret = fcntl(filedes, F_SETLK, &fl);
+    ret = fcntl(filedes, cmd, &fl);
     saved_errno = errno;	    
 
     if(debug > 1 && ret)
@@ -659,35 +661,6 @@ int do_lock(int type, int start, int length)
     return(ret==0?PASS:FAIL);
 }
 
-int do_unlock(int start, int length)
-{
-    int ret;
-    int filedes = f_fd;
-    struct flock fl;
-
-    if(debug > 1) {
-	fprintf(stderr, "do_unlock: start=%d, length=%d\n", start, length);
-    }
-
-    if (f_fd < 0)
-	return f_fd;
-    
-    fl.l_start = start;
-    fl.l_len = length;
-    fl.l_whence = SEEK_SET;
-    fl.l_pid = getpid();
-    fl.l_type = F_UNLCK;
-
-    errno = 0;
-
-    ret = fcntl(filedes, F_SETLK, &fl);
-    saved_errno = errno;	    
-    if(debug > 1 && ret)
-	fprintf(stderr, "do_lock: ret = %d, errno = %d (%s)\n", ret, errno, strerror(errno));
-
-    return(ret==0?PASS:FAIL);
-}
-
 int do_close(void)
 {	
     if(debug > 1) {
@@ -1016,13 +989,13 @@ main(int argc, char *argv[])
 		if(tests[index][TEST_NUM] != 0) {
 		    switch(tests[index][COMMAND]) {
 			case WRLOCK:
-			    result = do_lock(F_WRLCK, tests[index][OFFSET], tests[index][LENGTH]);
+			    result = do_lock(F_SETLK, F_WRLCK, tests[index][OFFSET], tests[index][LENGTH]);
 			    break;
 			case RDLOCK:
-			    result = do_lock(F_RDLCK, tests[index][OFFSET], tests[index][LENGTH]);
+			    result = do_lock(F_SETLK, F_RDLCK, tests[index][OFFSET], tests[index][LENGTH]);
 			    break;
 			case UNLOCK:
-			    result = do_unlock(tests[index][OFFSET], tests[index][LENGTH]);
+			    result = do_lock(F_SETLK, F_UNLCK, tests[index][OFFSET], tests[index][LENGTH]);
 			    break;
 			case F_CLOSE:
 			    result = do_close();
@@ -1030,6 +1003,12 @@ main(int argc, char *argv[])
 			case F_OPEN:
 			    result = do_open(tests[index][FLAGS]);
 			    break;
+			case WRTEST:
+			    result = do_lock(F_GETLK, F_WRLCK, tests[index][OFFSET], tests[index][LENGTH]);
+			    break;
+			case RDTEST:
+			    result = do_lock(F_GETLK, F_RDLCK, tests[index][OFFSET], tests[index][LENGTH]);
+			    break;
 		    }
 		    if( result != tests[index][RESULT]) {
 			fail_flag++;
@@ -1126,13 +1105,13 @@ main(int argc, char *argv[])
 	    ctl.length = tests[index][LENGTH];
 	    switch(tests[index][COMMAND]) {
 		case WRLOCK:
-		    result = do_lock(F_WRLCK, tests[index][OFFSET], tests[index][LENGTH]);
+		    result = do_lock(F_SETLK, F_WRLCK, tests[index][OFFSET], tests[index][LENGTH]);
 		    break;
 		case RDLOCK:
-		    result = do_lock(F_RDLCK, tests[index][OFFSET], tests[index][LENGTH]);
+		    result = do_lock(F_SETLK, F_RDLCK, tests[index][OFFSET], tests[index][LENGTH]);
 		    break;
 		case UNLOCK:
-		    result = do_unlock(tests[index][OFFSET], tests[index][LENGTH]);
+		    result = do_lock(F_SETLK, F_UNLCK, tests[index][OFFSET], tests[index][LENGTH]);
 		    break;
 		case F_CLOSE:
 		    result = do_close();
@@ -1140,6 +1119,12 @@ main(int argc, char *argv[])
 		case F_OPEN:
 		    result = do_open(tests[index][FLAGS]);
 		    break;
+		case WRTEST:
+		    result = do_lock(F_GETLK, F_WRLCK, tests[index][OFFSET], tests[index][LENGTH]);
+		    break;
+		case RDTEST:
+		    result = do_lock(F_GETLK, F_RDLCK, tests[index][OFFSET], tests[index][LENGTH]);
+		    break;
 	    }
 	    if( result != tests[index][RESULT] ) {
 		if(debug)
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
