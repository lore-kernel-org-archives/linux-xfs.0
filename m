Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A37C37F3F
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 20:32:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 96F898F80E3
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:32:27 -0700 (PDT)
Received: from mail-qc0-f179.google.com (mail-qc0-f179.google.com
	[209.85.216.179]) by cuda.sgi.com with ESMTP id
	iNcrFf6MFPEJ3W1x (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 18:32:16 -0700 (PDT)
Received: by mail-qc0-f179.google.com with SMTP id m20so2090295qcx.10
	for <xfs@oss.sgi.com>; Tue, 08 Apr 2014 18:32:14 -0700 (PDT)
From: Ming Chen <v.mingchen@gmail.com>
Subject: [PATCH v2] xfstest: log operations properly to generic/001.full
Date: Tue,  8 Apr 2014 17:31:21 -0400
Message-Id: <1396992681-9757-1-git-send-email-v.mingchen@gmail.com>
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
To: xfs@oss.sgi.com, david@fromorbit.com
Cc: Ming Chen <v.mingchen@gmail.com>, ezk@fsl.cs.sunysb.edu

Part of the operations were written to 001.full from the awk script, while the
rest were piped to 001.full using tee.  The resultant 001.full did not reflect
what are really performed.  This makes debugging difficult.  The output of
executing 001.full is discarded.

Tested-by: Ming Chen <v.mingchen@gmail.com>
Signed-off-by: Ming Chen <v.mingchen@gmail.com>
---
 tests/generic/001 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/generic/001 b/tests/generic/001
index 6e5f3dd..6a10810 100755
--- a/tests/generic/001
+++ b/tests/generic/001
@@ -190,7 +190,7 @@ _mark_iteration()
 #
 _chain()
 {
-    $AWK_PROG -v full_file=$seqres.full -v verify=$verify <$tmp.config '
+    $AWK_PROG -v verify=$verify <$tmp.config '
 BEGIN	{ nfile = 0 }
 /^\#/	{ next }
 	{ file[nfile] = $1
@@ -210,7 +210,7 @@ END	{ srand('$iter')
 		printf "if [ ! -f %s ]; then echo \"%s missing!\"; exit; fi\n",file[j],file[j]
 		printf "if [ -f %s.0 ]; then echo \"%s.0 already present!\"; exit; fi\n",file[j],file[j]
 		printf "cp %s %s.0 || exit 1\n",file[j],file[j]
-		printf "ls -i %s.0\n", file[j] >full_file;
+		printf "ls -i %s.0 > /dev/null\n", file[j];
 		total_size += size[j]
 		printf "# total size = %d\n", total_size 
 	    }
@@ -219,7 +219,7 @@ END	{ srand('$iter')
 		printf "if [ ! -f %s.%d ]; then echo \"%s.%d missing!\"; exit; fi\n",file[j],link[j]-1,file[j],link[j]-1
 		printf "if [ -f %s.%d ]; then echo \"%s.%d already present!\"; exit; fi\n",file[j],link[j],file[j],link[j]
 		printf "cp %s.%d %s.%d || exit 1\n",file[j],link[j]-1,file[j],link[j]
-		printf "ls -i %s.%d\n", file[j], link[j] >full_file;
+		printf "ls -i %s.%d > /dev/null\n", file[j], link[j];
 		total_size += size[j]
 		printf "# total size = %d\n", total_size 
 	    }
@@ -231,7 +231,7 @@ END	{ srand('$iter')
 	  for (j=0; j<nfile; j++) {
 	    if (link[j] > 0) {
 		printf "mv %s.%d %s.last\n",file[j],link[j]-1,file[j]
-		printf "ls -i %s.last\n", file[j] >full_file;
+		printf "ls -i %s.last > /dev/null\n", file[j];
 	    }
 	    for (i=0; i<link[j]-1; i++) {
 		printf "rm -f %s.%d\n",file[j],i
-- 
1.8.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
