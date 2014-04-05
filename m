Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B700A7F5D
	for <xfs@oss.sgi.com>; Sat,  5 Apr 2014 00:52:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A198C304053
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 22:52:48 -0700 (PDT)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
	[209.85.213.171]) by cuda.sgi.com with ESMTP id
	MLVDBdukjTwvFuzT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Apr 2014 22:52:44 -0700 (PDT)
Received: by mail-ig0-f171.google.com with SMTP id c1so1797399igq.10
	for <xfs@oss.sgi.com>; Fri, 04 Apr 2014 22:52:43 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 Apr 2014 01:52:43 -0400
Message-ID: <CAG+wggbx13tnYB=J8q83oK72td2VV=V1Fg=-q3JnZb=5tCgCSQ@mail.gmail.com>
Subject: [PATCH] xfstest: log operations properly to generic/001.full
From: Ming Chen <v.mingchen@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>

Part of the operations were written to 001.full from the awk script, while the
rest were piped to 001.full using tee.  The resultant 001.full did not reflect
what are really performed.  This makes debugging difficult.

Signed-off-by: Ming Chen <v.mingchen@gmail.com>
---
 tests/generic/001 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/generic/001 b/tests/generic/001
index 6e5f3dd..e1142ed 100755
--- a/tests/generic/001
+++ b/tests/generic/001
@@ -190,7 +190,7 @@ _mark_iteration()
 #
 _chain()
 {
-    $AWK_PROG -v full_file=$seqres.full -v verify=$verify <$tmp.config '
+    $AWK_PROG -v verify=$verify <$tmp.config '
 BEGIN  { nfile = 0 }
 /^\#/  { next }
        { file[nfile] = $1
@@ -210,7 +210,7 @@ END { srand('$iter')
                printf "if [ ! -f %s ]; then echo \"%s missing!\";
exit; fi\n",file[j],file[j]
                printf "if [ -f %s.0 ]; then echo \"%s.0 already
present!\"; exit; fi\n",file[j],file[j]
                printf "cp %s %s.0 || exit 1\n",file[j],file[j]
-               printf "ls -i %s.0\n", file[j] >full_file;
+               printf "ls -i %s.0\n", file[j];
                total_size += size[j]
                printf "# total size = %d\n", total_size
            }
@@ -219,7 +219,7 @@ END { srand('$iter')
                printf "if [ ! -f %s.%d ]; then echo \"%s.%d
missing!\"; exit; fi\n",file[j],link[j]-1,file[j],link[j]-1
                printf "if [ -f %s.%d ]; then echo \"%s.%d already
present!\"; exit; fi\n",file[j],link[j],file[j],link[j]
                printf "cp %s.%d %s.%d || exit
1\n",file[j],link[j]-1,file[j],link[j]
-               printf "ls -i %s.%d\n", file[j], link[j] >full_file;
+               printf "ls -i %s.%d\n", file[j], link[j];
                total_size += size[j]
                printf "# total size = %d\n", total_size
            }
@@ -231,7 +231,7 @@ END { srand('$iter')
          for (j=0; j<nfile; j++) {
            if (link[j] > 0) {
                printf "mv %s.%d %s.last\n",file[j],link[j]-1,file[j]
-               printf "ls -i %s.last\n", file[j] >full_file;
+               printf "ls -i %s.last\n", file[j];
            }
            for (i=0; i<link[j]-1; i++) {
                printf "rm -f %s.%d\n",file[j],i
-- 
1.8.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
