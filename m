Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RIrLTp204139 for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:53:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 402761A2DC41
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:34 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id hveYnRtqbnRlfAFC for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:34 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 3/9] Support "generic" filesystem type
Date: Wed, 27 May 2009 13:53:27 -0500
Message-Id: <1243450413-12681-4-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

Create a new "generic" _supported_fs type for tests
which are not really filesystem-specific.  "generic"
tests do expect that acl & attr are supported though.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 001       |    2 +-
 002       |    2 +-
 005       |    2 +-
 006       |    2 +-
 007       |    2 +-
 010       |    2 +-
 011       |    2 +-
 013       |    2 +-
 014       |    2 +-
 069       |    2 +-
 070       |    2 +-
 074       |    2 +-
 076       |    2 +-
 093       |    2 +-
 097       |    2 +-
 099       |    2 +-
 100       |    2 +-
 105       |    2 +-
 123       |    2 +-
 124       |    2 +-
 125       |    2 +-
 128       |    2 +-
 131       |    2 +-
 184       |    2 +-
 193       |    2 +-
 common.rc |    2 +-
 new       |    2 +-
 27 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/001 b/001
index 2ff2c05..2dddffb 100755
--- a/001
+++ b/001
@@ -33,7 +33,7 @@ done_cleanup=false
 trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 verbose=true
diff --git a/002 b/002
index 13c6be3..c2d2b5a 100755
--- a/002
+++ b/002
@@ -30,7 +30,7 @@ _cleanup()
 }
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/005 b/005
index d21dcb5..644f63d 100755
--- a/005
+++ b/005
@@ -53,7 +53,7 @@ _touch()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 
 # IRIX UDF does not support symlinks
 if [ $FSTYP == 'udf' ]; then
diff --git a/006 b/006
index 4da277f..49b5949 100755
--- a/006
+++ b/006
@@ -40,7 +40,7 @@ _count()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/007 b/007
index 290f716..7a97d71 100755
--- a/007
+++ b/007
@@ -34,7 +34,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/010 b/010
index c51ecb2..f1bc885 100755
--- a/010
+++ b/010
@@ -42,7 +42,7 @@ _filter_dbtest()
 [ -x $here/src/dbtest ] || _notrun "dbtest was not built for this platform"
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/011 b/011
index 655229b..e1a3d7d 100755
--- a/011
+++ b/011
@@ -32,7 +32,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/013 b/013
index 1c99e8f..e417d5a 100755
--- a/013
+++ b/013
@@ -78,7 +78,7 @@ _do_test()
 
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/014 b/014
index acc3696..f5b64d0 100755
--- a/014
+++ b/014
@@ -30,7 +30,7 @@ _cleanup()
 . ./common.rc
 . ./common.filter
 
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/069 b/069
index 11efd98..4950901 100755
--- a/069
+++ b/069
@@ -23,7 +23,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
diff --git a/070 b/070
index 65e158a..9302500 100755
--- a/070
+++ b/070
@@ -30,7 +30,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/074 b/074
index d5e0364..0bd0807 100755
--- a/074
+++ b/074
@@ -97,7 +97,7 @@ _process_args()
 # real QA test starts here
 rm -f $here/$seq.full
 
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 #
diff --git a/076 b/076
index 975de2e..c0f6675 100755
--- a/076
+++ b/076
@@ -39,7 +39,7 @@ trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
diff --git a/093 b/093
index c1243e2..1139788 100755
--- a/093
+++ b/093
@@ -43,7 +43,7 @@ _filefilter()
 }
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX
 
 [ -x $runas ] || _notrun "$runas executable not found"
diff --git a/097 b/097
index b7fe1f2..9c38d18 100755
--- a/097
+++ b/097
@@ -58,7 +58,7 @@ else
 fi
 
 # real QA test starts here
-_supported_fs udf xfs
+_supported_fs generic
 _supported_os IRIX
 
 _require_scratch
diff --git a/099 b/099
index 1c5daeb..6b824dd 100755
--- a/099
+++ b/099
@@ -62,7 +62,7 @@ rm -f $seq.full
 
 #-------------------------------------------------------
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX
 
 _acl_setup_ids
diff --git a/100 b/100
index aa6c4ca..57e9bb6 100755
--- a/100
+++ b/100
@@ -29,7 +29,7 @@ _cleanup()
 }
  
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 # Use _populate_fs() in common.rc to create a directory structure.
diff --git a/105 b/105
index cd201dd..f154422 100755
--- a/105
+++ b/105
@@ -32,7 +32,7 @@ _cleanup()
 . ./common.attr
 
 # Modify as appropriate.
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX Linux
 
 # real QA test starts here
diff --git a/123 b/123
index 63cd48f..ba7c454 100755
--- a/123
+++ b/123
@@ -57,7 +57,7 @@ _user_do()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _require_user
diff --git a/124 b/124
index 29af340..5adef48 100755
--- a/124
+++ b/124
@@ -33,7 +33,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/125 b/125
index ff538ef..f432034 100755
--- a/125
+++ b/125
@@ -28,7 +28,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _require_user
diff --git a/128 b/128
index 24bdac7..227d05c 100755
--- a/128
+++ b/128
@@ -30,7 +30,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/131 b/131
index 78627f5..67adb81 100755
--- a/131
+++ b/131
@@ -28,7 +28,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/184 b/184
index 30839cb..408e645 100755
--- a/184
+++ b/184
@@ -30,7 +30,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/193 b/193
index 54c51a2..743c70f 100755
--- a/193
+++ b/193
@@ -50,7 +50,7 @@ _cleanup_files()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs nfs udf
+_supported_fs generic
 _supported_os Linux
 
 _require_user
diff --git a/common.rc b/common.rc
index 317e009..f649bc2 100644
--- a/common.rc
+++ b/common.rc
@@ -546,7 +546,7 @@ _supported_fs()
 {
     for f
     do
-	if [ "$f" = "$FSTYP" ]
+	if [ "$f" = "$FSTYP" -o "$f" = "generic" ]
 	then
 	    return
 	fi
diff --git a/new b/new
index c924ffe..ac61221 100755
--- a/new
+++ b/new
@@ -99,7 +99,7 @@ _cleanup()
 # real QA test starts here
 
 # Modify as appropriate.
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 # if error
-- 
1.5.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
