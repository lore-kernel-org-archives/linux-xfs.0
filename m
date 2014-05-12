Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED41D7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 10:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCF9C8F804B
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:47 -0700 (PDT)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com
	[209.85.192.41]) by cuda.sgi.com with ESMTP id 9l15JW1aNIZz2UEn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:46 -0700 (PDT)
Received: by mail-qg0-f41.google.com with SMTP id j5so7832524qga.28
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:46 -0700 (PDT)
Received: from tlielax.poochiereds.net ([2001:470:8:d63:3a60:77ff:fe93:a95d])
	by mx.google.com with ESMTPSA id
	r15sm10025356qgr.15.2014.05.12.08.06.44 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 12 May 2014 08:06:45 -0700 (PDT)
From: Jeff Layton <jlayton@poochiereds.net>
Subject: [xfstests PATCH 4/4] locktest: add a F_GETLK vs. openmode test
Date: Mon, 12 May 2014 11:06:33 -0400
Message-Id: <1399907193-23857-5-git-send-email-jlayton@poochiereds.net>
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

POSIX says that you're allowed to do F_GETLK for a F_WRLCK on an
O_RDONLY file description.

Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 src/locktest.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/src/locktest.c b/src/locktest.c
index c9cd04ca4a59..23bb2406dc24 100644
--- a/src/locktest.c
+++ b/src/locktest.c
@@ -180,10 +180,11 @@ char *descriptions[] = {
     /* 26 */"Acquire read and write locks with overlapping ranges",
     /* 27 */"Acquire whole file write lock and then close without unlocking (and attempt a lock)",
     /* 28 */"Acquire two read locks, close and reopen the file, and test if the inital lock is still there",
+    /* 29 */"Verify that F_GETLK for F_WRLCK doesn't require that file be opened for write",
     #if defined(macosx)
-    /* 29 */"Close the opened file and open the file with SHLOCK, other client will try to open with SHLOCK too",
-    /* 30 */"Close the opened file and open the file with SHLOCK, other client will try to open with EXLOCK",
-    /* 31 */"Close the opened file and open the file with EXLOCK, other client will try to open with EXLOCK too"
+    /* 30 */"Close the opened file and open the file with SHLOCK, other client will try to open with SHLOCK too",
+    /* 31 */"Close the opened file and open the file with SHLOCK, other client will try to open with EXLOCK",
+    /* 32 */"Close the opened file and open the file with EXLOCK, other client will try to open with EXLOCK too"
     #endif
 };
 
@@ -521,26 +522,32 @@ static int64_t tests[][6] =
 		{28,	F_OPEN,	O_RDWR,		0,		PASS,		SERVER,	},
 		{28,	WRLOCK,	0,		0,		FAIL,		SERVER,	},
 		{28,	UNLOCK,	1,		5,		PASS,		SERVER,	},
+	/* Verify that F_GETLK for F_WRLCK doesn't require that file be opened for write */
+		{29,	F_CLOSE, 0,		0,		PASS,		SERVER, },
+		{29,	F_OPEN, O_RDONLY,	0,		PASS,		SERVER, },
+		{29,	WRTEST, 0,		0,		PASS,		SERVER, },
+		{29,	F_CLOSE,0,		0,		PASS,		SERVER,	},
+		{29,	F_OPEN,	O_RDWR,		0,		PASS,		SERVER,	},
 #ifdef macosx
 	/* Close the opened file and open the file with SHLOCK, other client will try to open with SHLOCK too */
-		{29,	F_CLOSE,0,		0,		PASS,		SERVER,	},
-		{29,	F_OPEN,	O_RDWR|O_SHLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
-		{29,	F_CLOSE,0,		0,		PASS,		CLIENT,	},
-		{29,	F_OPEN,	O_RDWR|O_SHLOCK|O_NONBLOCK,	0,	PASS,		CLIENT,	},
-	/* Close the opened file and open the file with SHLOCK, other client will try to open with EXLOCK */
 		{30,	F_CLOSE,0,		0,		PASS,		SERVER,	},
-		{30,	F_CLOSE,0,		0,		PASS,		CLIENT,	},
 		{30,	F_OPEN,	O_RDWR|O_SHLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
-		{30,	F_OPEN,	O_RDWR|O_EXLOCK|O_NONBLOCK,	0,	FAIL,		CLIENT,	},
-	/* Close the opened file and open the file with EXLOCK, other client will try to open with EXLOCK too */
+		{30,	F_CLOSE,0,		0,		PASS,		CLIENT,	},
+		{30,	F_OPEN,	O_RDWR|O_SHLOCK|O_NONBLOCK,	0,	PASS,		CLIENT,	},
+	/* Close the opened file and open the file with SHLOCK, other client will try to open with EXLOCK */
 		{31,	F_CLOSE,0,		0,		PASS,		SERVER,	},
-		{31,	F_CLOSE,0,		0,		FAIL,		CLIENT,	},
-		{31,	F_OPEN,	O_RDWR|O_EXLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
+		{31,	F_CLOSE,0,		0,		PASS,		CLIENT,	},
+		{31,	F_OPEN,	O_RDWR|O_SHLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
 		{31,	F_OPEN,	O_RDWR|O_EXLOCK|O_NONBLOCK,	0,	FAIL,		CLIENT,	},
-		{31,	F_CLOSE,0,		0,		PASS,		SERVER,	},
-		{31,	F_CLOSE,0,		0,		FAIL,		CLIENT,	},
-		{31,	F_OPEN,	O_RDWR,		0,		PASS,		SERVER,	},
-		{31,	F_OPEN,	O_RDWR,		0,		PASS,		CLIENT,	},
+	/* Close the opened file and open the file with EXLOCK, other client will try to open with EXLOCK too */
+		{32,	F_CLOSE,0,		0,		PASS,		SERVER,	},
+		{32,	F_CLOSE,0,		0,		FAIL,		CLIENT,	},
+		{32,	F_OPEN,	O_RDWR|O_EXLOCK|O_NONBLOCK,	0,	PASS,		SERVER,	},
+		{32,	F_OPEN,	O_RDWR|O_EXLOCK|O_NONBLOCK,	0,	FAIL,		CLIENT,	},
+		{32,	F_CLOSE,0,		0,		PASS,		SERVER,	},
+		{32,	F_CLOSE,0,		0,		FAIL,		CLIENT,	},
+		{32,	F_OPEN,	O_RDWR,		0,		PASS,		SERVER,	},
+		{32,	F_OPEN,	O_RDWR,		0,		PASS,		CLIENT,	},
 #endif /* macosx */
 	/* indicate end of array */
 		{0,0,0,0,0,SERVER},
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
