Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B8AB27F53
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 10:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A86308F804B
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:44 -0700 (PDT)
Received: from mail-qa0-f48.google.com (mail-qa0-f48.google.com
	[209.85.216.48]) by cuda.sgi.com with ESMTP id dZgVbijZSDBQMq0W
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:42 -0700 (PDT)
Received: by mail-qa0-f48.google.com with SMTP id i13so7229120qae.35
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:42 -0700 (PDT)
Received: from tlielax.poochiereds.net ([2001:470:8:d63:3a60:77ff:fe93:a95d])
	by mx.google.com with ESMTPSA id
	r15sm10025356qgr.15.2014.05.12.08.06.40 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 12 May 2014 08:06:41 -0700 (PDT)
From: Jeff Layton <jlayton@poochiereds.net>
Subject: [xfstests PATCH 1/4] locktest: don't assume that F_OPEN should use
	O_RDWR
Date: Mon, 12 May 2014 11:06:30 -0400
Message-Id: <1399907193-23857-2-git-send-email-jlayton@poochiereds.net>
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

In a later patch, I'll be adding a test for F_GETLK that will require
that we open the file with a different f_mode. Change do_open not to
assume that the it needs to open the file O_RDWR.

While we're at it, fix a bug in do_open. Just because we pass in '0' for
the flags, doesn't mean that this is the initial open.  Move the exit(1)
for that case to the caller.

Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 src/locktest.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/src/locktest.c b/src/locktest.c
index d6198b6c1f1b..b440a43e3947 100644
--- a/src/locktest.c
+++ b/src/locktest.c
@@ -73,7 +73,7 @@ extern int h_errno;
        
 #define HANDLE              int
 #define INVALID_HANDLE      -1
-#define OPEN(N,F)           (open(N, F|O_CREAT|O_RDWR|O_BINARY| \
+#define OPEN(N,F)           (open(N, F|O_CREAT|O_BINARY| \
                             (D_flag ? O_DIRECT : 0), 0644))
 #define SEEK(H, O)          (lseek(H, O, SEEK_SET))
 #define READ(H, B, L)       (read(H, B, L))
@@ -512,35 +512,35 @@ static int64_t tests[][6] =
 		{27,	WRLOCK,	1,		5,		FAIL,		CLIENT,	},
 		{27,	F_CLOSE,0,		0,		PASS,		SERVER,	},
 		{27,	WRLOCK,	1,		5,		PASS,		CLIENT,	},
-		{27,	F_OPEN,	0,		0,		PASS,		SERVER,	},
+		{27,	F_OPEN,	O_RDWR,		0,		PASS,		SERVER,	},
 		{27,	UNLOCK,	1,		5,		PASS,		CLIENT,	},
 	/* Acquire two read locks, close one file and then reopen to check that first lock still exists */
 		{28,	RDLOCK,	1,		5,		PASS,		SERVER,	},
 		{28,	RDLOCK,	1,		5,		PASS,		CLIENT,	},
 		{28,	F_CLOSE,0,		0,		PASS,		SERVER,	},
-		{28,	F_OPEN,	0,		0,		PASS,		SERVER,	},
+		{28,	F_OPEN,	O_RDWR,		0,		PASS,		SERVER,	},
 		{28,	WRLOCK,	0,		0,		FAIL,		SERVER,	},
 		{28,	UNLOCK,	1,		5,		PASS,		SERVER,	},
 #ifdef macosx
 	/* Close the opened file and open the file with SHLOCK, other client will try to open with SHLOCK too */
 		{29,	F_CLOSE,0,		0,		PASS,		SERVER,	},
-		{29,	F_OPEN,	O_SHLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
+		{29,	F_OPEN,	O_RDWR|O_SHLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
 		{29,	F_CLOSE,0,		0,		PASS,		CLIENT,	},
-		{29,	F_OPEN,	O_SHLOCK|O_NONBLOCK,	0,	PASS,		CLIENT,	},
+		{29,	F_OPEN,	O_RDWR|O_SHLOCK|O_NONBLOCK,	0,	PASS,		CLIENT,	},
 	/* Close the opened file and open the file with SHLOCK, other client will try to open with EXLOCK */
 		{30,	F_CLOSE,0,		0,		PASS,		SERVER,	},
 		{30,	F_CLOSE,0,		0,		PASS,		CLIENT,	},
-		{30,	F_OPEN,	O_SHLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
-		{30,	F_OPEN,	O_EXLOCK|O_NONBLOCK,	0,	FAIL,		CLIENT,	},
+		{30,	F_OPEN,	O_RDWR|O_SHLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
+		{30,	F_OPEN,	O_RDWR|O_EXLOCK|O_NONBLOCK,	0,	FAIL,		CLIENT,	},
 	/* Close the opened file and open the file with EXLOCK, other client will try to open with EXLOCK too */
 		{31,	F_CLOSE,0,		0,		PASS,		SERVER,	},
 		{31,	F_CLOSE,0,		0,		FAIL,		CLIENT,	},
-		{31,	F_OPEN,	O_EXLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
-		{31,	F_OPEN,	O_EXLOCK|O_NONBLOCK,	0,	FAIL,		CLIENT,	},
+		{31,	F_OPEN,	O_RDWR|O_EXLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
+		{31,	F_OPEN,	O_RDWR|O_EXLOCK|O_NONBLOCK,	0,	FAIL,		CLIENT,	},
 		{31,	F_CLOSE,0,		0,		PASS,		SERVER,	},
 		{31,	F_CLOSE,0,		0,		FAIL,		CLIENT,	},
-		{31,	F_OPEN,	0,		0,		PASS,		SERVER,	},
-		{31,	F_OPEN,	0,		0,		PASS,		CLIENT,	},
+		{31,	F_OPEN,	O_RDWR,		0,		PASS,		SERVER,	},
+		{31,	F_OPEN,	O_RDWR,		0,		PASS,		CLIENT,	},
 #endif /* macosx */
 	/* indicate end of array */
 		{0,0,0,0,0,SERVER},
@@ -615,8 +615,6 @@ int do_open(int flag)
 {
     if ((f_fd = OPEN(filename, flag)) == INVALID_HANDLE) {
 	perror("shared file create");
-	if (!flag)	/* Only exit if the first open fails */
-	    exit(1);
 	closed = 0;
 	return FAIL;
 	/*NOTREACHED*/
@@ -858,7 +856,8 @@ main(int argc, char *argv[])
     }
 
     filename=argv[optind];
-    do_open(0);
+    if (do_open(O_RDWR) == FAIL)
+	exit(1);
 
     /*
      * +10 is slop for the iteration number if do_write() ... never
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
