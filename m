Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E23FA7F50
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 08:53:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A6DEAC003
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 06:53:13 -0800 (PST)
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id GbyDpaO9O9jxJTI2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 07 Mar 2014 06:53:12 -0800 (PST)
Received: by mail-qa0-f53.google.com with SMTP id w8so4129641qac.12
	for <xfs@oss.sgi.com>; Fri, 07 Mar 2014 06:53:11 -0800 (PST)
From: Boris Ranto <ranto.boris@gmail.com>
Subject: [PATCH v2] xfsdump: Fix memory and fd leak in invutil/stobj.c
Date: Fri,  7 Mar 2014 15:52:42 +0100
Message-Id: <1394203962-17080-1-git-send-email-ranto.boris@gmail.com>
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

Brian Foster noticed that the function also leaks a file descriptor
in case the file cannot be fstated. Fixing that, too.

Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
---
 invutil/stobj.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/invutil/stobj.c b/invutil/stobj.c
index 428b419..a74ba0f 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -578,23 +578,24 @@ open_stobj(char *StObjFileName)
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
     if (fstat(fd, &sb) < 0) {
 	fprintf(stderr, "Could not get stat info on %s\n", StObjFileName);
 	perror("fstat");
+	close(fd);
 	return -1;
     }
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
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
