Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 838907F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 14:12:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51133304032
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 12:12:22 -0800 (PST)
Received: from mail-ea0-f175.google.com (mail-ea0-f175.google.com
	[209.85.215.175]) by cuda.sgi.com with ESMTP id
	HeEUCm2yylwSS7Sv (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 12:12:17 -0800 (PST)
Received: by mail-ea0-f175.google.com with SMTP id d10so1263618eaj.6
	for <xfs@oss.sgi.com>; Wed, 05 Mar 2014 12:12:16 -0800 (PST)
From: Boris Ranto <ranto.boris@gmail.com>
Subject: [PATCH] xfsdump: Fix memory leak in invutil/stobj.c
Date: Wed,  5 Mar 2014 21:11:51 +0100
Message-Id: <1394050311-17965-1-git-send-email-ranto.boris@gmail.com>
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
Cc: Boris Ranto <ranto.boris@gmail.com>, branto@redhat.com

The function open_stobj duplicates its argument, upon successful
duplication, the fstat is called. If the fstat command fails then
the memory for the duplicated string is leaked. Fix this by moving
the string duplication after the fstat call. This is ok because
the fstat call does not use the duplicated string.

Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
---
 invutil/stobj.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/invutil/stobj.c b/invutil/stobj.c
index 428b419..55abe63 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -578,12 +578,6 @@ open_stobj(char *StObjFileName)
 	return fd;
     }
 
-    name = strdup(StObjFileName);
-    if(name == NULL) {
-	fprintf(stderr, "%s: internal memory error: strdup stobj_name\n", g_programName);
-	exit(1);
-    }
-
     read_n_bytes(fd, &cnt, sizeof(invt_sescounter_t), StObjFileName);
     lseek( fd, 0, SEEK_SET );
     errno = 0;
@@ -595,6 +589,12 @@ open_stobj(char *StObjFileName)
     size = sb.st_size;
     mapaddr = mmap_n_bytes(fd, size, BOOL_FALSE, StObjFileName);
 
+    name = strdup(StObjFileName);
+    if(name == NULL) {
+	fprintf(stderr, "%s: internal memory error: strdup stobj_name\n", g_programName);
+	exit(1);
+    }
+
     return add_stobj(name, fd, size, mapaddr, (invt_sescounter_t *)mapaddr);
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
