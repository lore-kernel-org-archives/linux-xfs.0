Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37244 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdGUEkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:21 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 11/15] tests: remove IRIX support from tests also supported on Linux
Date: Thu, 20 Jul 2017 21:38:49 -0700
Message-Id: <20170721043853.364-12-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

Many tests claimed (via _supported_os) to work on both Linux and IRIX.
Since IRIX is no longer supported by xfstests, update these to claim
Linux support only.  Then remove any obvious IRIX-specific logic in the
tests, and any IRIX-specific golden output files.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/str_to_bytes.c         |    2 +-
 ltp/rwtest.sh              |    1 -
 src/fill2fs                |    5 +-
 tests/generic/001          |    2 +-
 tests/generic/002          |    2 +-
 tests/generic/005          |    9 +-
 tests/generic/006          |    2 +-
 tests/generic/007          |    2 +-
 tests/generic/010          |    2 +-
 tests/generic/011          |    2 +-
 tests/generic/013          |    8 +-
 tests/generic/014          |    2 +-
 tests/generic/015          |    2 +-
 tests/generic/029          |    2 +-
 tests/generic/030          |    2 +-
 tests/generic/031          |    2 +-
 tests/generic/043          |    2 +-
 tests/generic/044          |    2 +-
 tests/generic/045          |    2 +-
 tests/generic/046          |    2 +-
 tests/generic/047          |    2 +-
 tests/generic/048          |    2 +-
 tests/generic/049          |    2 +-
 tests/generic/052          |    2 +-
 tests/generic/054          |    2 +-
 tests/generic/055          |    2 +-
 tests/generic/068          |    2 +-
 tests/generic/069          |    2 +-
 tests/generic/070          |    2 +-
 tests/generic/074          |   37 +-
 tests/generic/075          |    2 +-
 tests/generic/076          |    2 +-
 tests/generic/080          |    2 +-
 tests/generic/083          |    2 +-
 tests/generic/086          |    2 +-
 tests/generic/088          |    2 +-
 tests/generic/088.cfg      |    1 -
 tests/generic/088.out.irix |    9 -
 tests/generic/096          |    2 +-
 tests/generic/100          |    2 +-
 tests/generic/105          |   11 +-
 tests/generic/117          |    2 +-
 tests/generic/120          |    2 +-
 tests/generic/123          |    2 +-
 tests/generic/130          |    2 +-
 tests/generic/132          |    2 +-
 tests/generic/133          |    2 +-
 tests/generic/135          |    2 +-
 tests/generic/184          |    2 +-
 tests/generic/219          |    2 +-
 tests/generic/226          |    2 +-
 tests/generic/230          |    2 +-
 tests/generic/234          |    2 +-
 tests/generic/235          |    2 +-
 tests/generic/273          |    2 +-
 tests/generic/274          |    2 +-
 tests/generic/275          |    2 +-
 tests/generic/309          |    2 +-
 tests/generic/313          |    2 +-
 tests/generic/320          |    2 +-
 tests/generic/378          |    2 +-
 tests/generic/379          |    2 +-
 tests/generic/380          |    2 +-
 tests/generic/384          |    8 +-
 tests/generic/403          |    2 +-
 tests/generic/416          |    2 +-
 tests/generic/424          |    2 +-
 tests/udf/102              |    2 +-
 tests/xfs/003              |   12 +-
 tests/xfs/004              |    6 +-
 tests/xfs/007              |    2 +-
 tests/xfs/008              |    2 +-
 tests/xfs/009              |    2 +-
 tests/xfs/012              |    2 +-
 tests/xfs/018              |    8 +-
 tests/xfs/018.cfg          |    1 -
 tests/xfs/018.op.irix      | 5628 --------------------------------------------
 tests/xfs/019              |    2 +-
 tests/xfs/022              |    5 +-
 tests/xfs/022.cfg          |    1 -
 tests/xfs/022.out.irix     |   55 -
 tests/xfs/023              |    2 +-
 tests/xfs/023.cfg          |    1 -
 tests/xfs/023.out.irix     |   89 -
 tests/xfs/026              |    2 +-
 tests/xfs/027              |    2 +-
 tests/xfs/028              |    2 +-
 tests/xfs/030              |    2 +-
 tests/xfs/030.cfg          |    1 -
 tests/xfs/030.out.irix     |  288 ---
 tests/xfs/031              |    2 +-
 tests/xfs/031.cfg          |    1 -
 tests/xfs/031.out.irix     |  123 -
 tests/xfs/032              |    2 +-
 tests/xfs/033              |    2 +-
 tests/xfs/033.cfg          |    1 -
 tests/xfs/033.out.irix     |  217 --
 tests/xfs/035              |    2 +-
 tests/xfs/035.cfg          |    1 -
 tests/xfs/035.out.irix     |   94 -
 tests/xfs/036              |    2 +-
 tests/xfs/036.cfg          |    1 -
 tests/xfs/036.out.irix     |   86 -
 tests/xfs/039              |    2 +-
 tests/xfs/039.cfg          |    1 -
 tests/xfs/039.out.irix     |   89 -
 tests/xfs/041              |    2 +-
 tests/xfs/042              |    2 +-
 tests/xfs/043              |    2 +-
 tests/xfs/043.cfg          |    1 -
 tests/xfs/043.out.irix     |  104 -
 tests/xfs/046              |    2 +-
 tests/xfs/047              |    2 +-
 tests/xfs/048              |    2 +-
 tests/xfs/050              |   16 +-
 tests/xfs/052              |    2 +-
 tests/xfs/053              |    2 +-
 tests/xfs/055              |    2 +-
 tests/xfs/055.out.irix     |   89 -
 tests/xfs/056              |    2 +-
 tests/xfs/061              |    2 +-
 tests/xfs/064              |    2 +-
 tests/xfs/065              |    2 +-
 tests/xfs/066              |    2 +-
 tests/xfs/071              |    2 +-
 tests/xfs/072              |    2 +-
 tests/xfs/080              |    6 -
 tests/xfs/081              |   10 +-
 tests/xfs/082              |    8 +-
 tests/xfs/082.cfg          |    1 -
 tests/xfs/082.op.irix      | 5628 --------------------------------------------
 tests/xfs/084              |   10 +-
 tests/xfs/092              |    2 +-
 tests/xfs/094              |    2 +-
 tests/xfs/096              |    2 +-
 tests/xfs/103              |    2 +-
 tests/xfs/107              |    2 +-
 tests/xfs/108              |    2 +-
 tests/xfs/116              |    2 +-
 tests/xfs/118              |    2 +-
 tests/xfs/119              |    2 +-
 tests/xfs/121              |    2 +-
 tests/xfs/136              |    2 +-
 tests/xfs/142              |    2 +-
 tests/xfs/143              |    2 +-
 tests/xfs/144              |    2 +-
 tests/xfs/145              |    2 +-
 tests/xfs/146              |    2 +-
 tests/xfs/146.cfg          |    1 -
 tests/xfs/146.out.irix     |  324 ---
 tests/xfs/147              |    2 +-
 tests/xfs/148              |    2 +-
 tests/xfs/149              |    2 +-
 tests/xfs/150              |    2 +-
 tests/xfs/151              |    2 +-
 tests/xfs/152              |    2 +-
 tests/xfs/153              |    2 +-
 tests/xfs/154              |    2 +-
 tests/xfs/155              |    2 +-
 tests/xfs/156              |    2 +-
 tests/xfs/157              |    2 +-
 tests/xfs/158              |    2 +-
 tests/xfs/159              |    2 +-
 tests/xfs/160              |    2 +-
 tests/xfs/161              |    2 +-
 tests/xfs/162              |    2 +-
 tests/xfs/163              |    2 +-
 tests/xfs/164              |    2 +-
 tests/xfs/165              |    2 +-
 tests/xfs/170              |    2 +-
 tests/xfs/172              |    2 +-
 tests/xfs/173              |    2 +-
 tests/xfs/174              |    2 +-
 tests/xfs/181              |    2 +-
 tests/xfs/185              |    2 +-
 tests/xfs/188              |    2 +-
 tests/xfs/194              |    2 +-
 tests/xfs/206              |    2 +-
 tests/xfs/291              |    2 +-
 tests/xfs/292              |    2 +-
 tests/xfs/293              |    2 +-
 tests/xfs/295              |    2 +-
 tests/xfs/297              |    2 +-
 tests/xfs/303              |    2 +-
 184 files changed, 175 insertions(+), 13103 deletions(-)
 delete mode 100644 tests/generic/088.out.irix
 delete mode 100644 tests/xfs/018.op.irix
 delete mode 100644 tests/xfs/022.out.irix
 delete mode 100644 tests/xfs/023.out.irix
 delete mode 100644 tests/xfs/030.out.irix
 delete mode 100644 tests/xfs/031.out.irix
 delete mode 100644 tests/xfs/033.out.irix
 delete mode 100644 tests/xfs/035.out.irix
 delete mode 100644 tests/xfs/036.out.irix
 delete mode 100644 tests/xfs/039.out.irix
 delete mode 100644 tests/xfs/043.out.irix
 delete mode 100644 tests/xfs/055.out.irix
 delete mode 100644 tests/xfs/082.op.irix
 delete mode 100644 tests/xfs/146.out.irix

diff --git a/lib/str_to_bytes.c b/lib/str_to_bytes.c
index c0d7d974..ef5d4fd9 100644
--- a/lib/str_to_bytes.c
+++ b/lib/str_to_bytes.c
@@ -124,7 +124,7 @@ char    *s;
 }
 
 /*
- * Force 64 bits number when compiled as 32 IRIX binary.
+ * Force 64 bits number when compiled as a 32-bit binary.
  * This allows for a number bigger than 2G.
  */
 
diff --git a/ltp/rwtest.sh b/ltp/rwtest.sh
index da42caa1..a001c571 100755
--- a/ltp/rwtest.sh
+++ b/ltp/rwtest.sh
@@ -252,7 +252,6 @@ fi
 #
 
 case $(uname -s) in
-	IRIX | IRIX64 )		dfOpts="-Pb"	;;
 	Linux)			dfOpts="-P"	;;
 	*)			dfOpts="-PB"	;;
 esac
diff --git a/src/fill2fs b/src/fill2fs
index 60d52be3..1c3383a8 100755
--- a/src/fill2fs
+++ b/src/fill2fs
@@ -37,8 +37,6 @@
 use Getopt::Long;
 use File::Basename;
 
-chomp($os = `uname`);
-
 #
 # fsinfo: get filesystem info put it into the global namespace, initialises:
 #	$dev, $type, $blocks, $used, $avail, $cap, $mnt, $mnt_options
@@ -53,8 +51,7 @@ sub fsinfo {
 
   # filesystem space and mount point
   
-  $cmd = "df" if ($os =~ /IRIX/);
-  $cmd = "df -P -T --block-size=512" if ($os =~ /Linux/);
+  $cmd = "df -P -T --block-size=512";
   chomp($_ = `$cmd $file | tail -1`);
   $n = ($dev, $type, $blocks, $used, $avail, $cap, $mnt) = split(/ +/);
   die("df failed") if ($n != 7);
diff --git a/tests/generic/001 b/tests/generic/001
index e977a018..0edd41f1 100755
--- a/tests/generic/001
+++ b/tests/generic/001
@@ -47,7 +47,7 @@ trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 verbose=true
diff --git a/tests/generic/002 b/tests/generic/002
index 0433882d..d8cffeaa 100755
--- a/tests/generic/002
+++ b/tests/generic/002
@@ -42,7 +42,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 rm -f $seqres.full
diff --git a/tests/generic/005 b/tests/generic/005
index 70f60738..030d90b1 100755
--- a/tests/generic/005
+++ b/tests/generic/005
@@ -23,9 +23,8 @@
 #
 
 #
-# Note1: On Linux, ELOOP limit used to be 32 but changed to 8, and lately
+# Note: On Linux, ELOOP limit used to be 32 but changed to 8, and lately
 # its become 5.  Who knows what it might be next.
-# Note2: On IRIX, the limit is around the 30 mark.
 # 
 # What we are looking for here is: no panic due to blowing the stack;
 # and that the ELOOP error code is returned at some point (the actual
@@ -50,9 +49,7 @@ _cleanup()
 
 _touch()
 {
-    # On IRIX: Too many symbolic links in path name traversal
-    # On Linux: Too many levels of symbolic links
-    touch $@ 2>&1 | grep -q 'Too many.*symbolic links'
+    touch $@ 2>&1 | grep -q 'Too many levels of symbolic links'
     if [ $? -eq 0 ]; then
 	echo "ELOOP returned.  Good."
     else
@@ -69,7 +66,7 @@ _supported_fs generic
 _require_test
 _require_test_symlinks
 
-_supported_os Linux IRIX
+_supported_os Linux
 
 cd $TEST_DIR
 
diff --git a/tests/generic/006 b/tests/generic/006
index 7a38dbfa..7309f1f3 100755
--- a/tests/generic/006
+++ b/tests/generic/006
@@ -53,7 +53,7 @@ _count()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 mkdir $TEST_DIR/permname.$$
diff --git a/tests/generic/007 b/tests/generic/007
index cfa45541..327bbe9c 100755
--- a/tests/generic/007
+++ b/tests/generic/007
@@ -47,7 +47,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 status=1 # default failure 
diff --git a/tests/generic/010 b/tests/generic/010
index 1c9d8f7e..d23a58b1 100755
--- a/tests/generic/010
+++ b/tests/generic/010
@@ -55,7 +55,7 @@ _require_test_program "dbtest"
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 rm -f $seqres.full
diff --git a/tests/generic/011 b/tests/generic/011
index f3c2f7cf..7c4b80c3 100755
--- a/tests/generic/011
+++ b/tests/generic/011
@@ -45,7 +45,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 out=$TEST_DIR/dirstress.$$
diff --git a/tests/generic/013 b/tests/generic/013
index e31fe354..d1ba697b 100755
--- a/tests/generic/013
+++ b/tests/generic/013
@@ -37,11 +37,7 @@ _cleanup()
     # we might get here with a RO FS
     _test_cycle_mount
     # now remove fsstress directory.
-    # N.B. rm(1) on IRIX can find problems when building up a long pathname
-    # such that what it has is greater the 1024 chars and will
-    # stop and complain - so get rid of complaint
-    # Ref. pv#935754
-    rm -rf $TEST_DIR/fsstress.$$.* 2>&1 | grep -v 'Path too long'
+    rm -rf $TEST_DIR/fsstress.$$.*
 }
 
 _filesize()
@@ -90,7 +86,7 @@ _do_test()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 rm -f $seqres.full
diff --git a/tests/generic/014 b/tests/generic/014
index d2dcc282..28566956 100755
--- a/tests/generic/014
+++ b/tests/generic/014
@@ -43,7 +43,7 @@ _cleanup()
 . ./common/filter
 
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_test
 _require_sparse_files
diff --git a/tests/generic/015 b/tests/generic/015
index 66c33c22..78f2b13d 100755
--- a/tests/generic/015
+++ b/tests/generic/015
@@ -48,7 +48,7 @@ _free()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/generic/029 b/tests/generic/029
index a83d02d3..c2f02fb9 100755
--- a/tests/generic/029
+++ b/tests/generic/029
@@ -46,7 +46,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 
 testfile=$SCRATCH_MNT/testfile
diff --git a/tests/generic/030 b/tests/generic/030
index 8e6827db..8b7e6fba 100755
--- a/tests/generic/030
+++ b/tests/generic/030
@@ -46,7 +46,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_xfs_io_command "mremap"
 
diff --git a/tests/generic/031 b/tests/generic/031
index fcb5f89b..3f25f8b8 100755
--- a/tests/generic/031
+++ b/tests/generic/031
@@ -46,7 +46,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_xfs_io_command "fcollapse"
 
diff --git a/tests/generic/043 b/tests/generic/043
index 784683eb..5dadab32 100755
--- a/tests/generic/043
+++ b/tests/generic/043
@@ -37,7 +37,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_scratch_shutdown
diff --git a/tests/generic/044 b/tests/generic/044
index f0dc0df1..804b1b17 100755
--- a/tests/generic/044
+++ b/tests/generic/044
@@ -37,7 +37,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_scratch_shutdown
diff --git a/tests/generic/045 b/tests/generic/045
index b49d09e3..5fa7b09f 100755
--- a/tests/generic/045
+++ b/tests/generic/045
@@ -37,7 +37,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_scratch_shutdown
diff --git a/tests/generic/046 b/tests/generic/046
index 54cb557b..bf38d53a 100755
--- a/tests/generic/046
+++ b/tests/generic/046
@@ -37,7 +37,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_scratch_shutdown
diff --git a/tests/generic/047 b/tests/generic/047
index 20f157e5..7d09b04c 100755
--- a/tests/generic/047
+++ b/tests/generic/047
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_scratch_shutdown
diff --git a/tests/generic/048 b/tests/generic/048
index dc2ab204..ae561fca 100755
--- a/tests/generic/048
+++ b/tests/generic/048
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_scratch_shutdown
diff --git a/tests/generic/049 b/tests/generic/049
index c7f19446..ef2b44c4 100755
--- a/tests/generic/049
+++ b/tests/generic/049
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_scratch_shutdown
diff --git a/tests/generic/052 b/tests/generic/052
index 65d430d1..cf0f4568 100755
--- a/tests/generic/052
+++ b/tests/generic/052
@@ -41,7 +41,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 rm -f $seqres.full
 rm -f $tmp.log
diff --git a/tests/generic/054 b/tests/generic/054
index 4d4be59b..db415009 100755
--- a/tests/generic/054
+++ b/tests/generic/054
@@ -40,7 +40,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 rm -f $seqres.full $tmp.*
 _require_scratch
diff --git a/tests/generic/055 b/tests/generic/055
index aed3b28c..1bbe3108 100755
--- a/tests/generic/055
+++ b/tests/generic/055
@@ -67,7 +67,7 @@ _get_quota_option()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 rm -f $seqres.full $tmp.*
 _require_scratch
diff --git a/tests/generic/068 b/tests/generic/068
index f9f5f5aa..bd12278c 100755
--- a/tests/generic/068
+++ b/tests/generic/068
@@ -49,7 +49,7 @@ trap "_cleanup" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_freeze
diff --git a/tests/generic/069 b/tests/generic/069
index aaf6bbf5..15586e9b 100755
--- a/tests/generic/069
+++ b/tests/generic/069
@@ -37,7 +37,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 rm -f $seqres.full
diff --git a/tests/generic/070 b/tests/generic/070
index 7591b25c..de0c45c7 100755
--- a/tests/generic/070
+++ b/tests/generic/070
@@ -45,7 +45,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_test
 _require_attrs
diff --git a/tests/generic/074 b/tests/generic/074
index 737b49bf..5f205b50 100755
--- a/tests/generic/074
+++ b/tests/generic/074
@@ -42,7 +42,7 @@ _cleanup()
 . ./common/filter
 
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 rm -f $seqres.full
@@ -116,37 +116,16 @@ _process_args()
 # These params can take a while on different CPUs/OSs
 # so we set them differently for different machines
 #
-if [ $HOSTOS == "IRIX" ]; then 
-    if uname -R | grep -iq debug; then 
-        # e.g. getting around 37secs for 1,1,1 on IP30 debug
-	numchildren=2
-	numloops=1
-	numfiles=2
-        param_type="IRIX debug"
-    else
-        # getting around 1 sec 1,1,1 - 10secs 1,10,1 on IP30 nondebug
+if uname -a | grep -q SMP; then
+	numloops=10
+	numfiles=5
+	numchildren=3
+	param_type="Linux SMP"
+else
 	numloops=2
 	numfiles=3
 	numchildren=3
-        param_type="IRIX nondebug"
-    fi
-elif [ $HOSTOS == "Linux" ]; then
-    if uname -a | grep -q SMP; then
-        numloops=10
-        numfiles=5
-        numchildren=3
-        param_type="Linux SMP"
-    else
-        numloops=2
-        numfiles=3
-        numchildren=3
-        param_type="Linux UP"
-    fi
-else
-    numloops=1
-    numfiles=1
-    numchildren=1
-    param_type="Default"
+	param_type="Linux UP"
 fi
 
 # can override the params here
diff --git a/tests/generic/075 b/tests/generic/075
index 6a214bc3..321c7217 100755
--- a/tests/generic/075
+++ b/tests/generic/075
@@ -124,7 +124,7 @@ _process_args()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 size10=`expr 10 \* 1024 \* 1024`	# 10 megabytes
diff --git a/tests/generic/076 b/tests/generic/076
index a29f160a..ac765333 100755
--- a/tests/generic/076
+++ b/tests/generic/076
@@ -53,7 +53,7 @@ trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_local_device $SCRATCH_DEV
diff --git a/tests/generic/080 b/tests/generic/080
index 43c93d73..a4c111b9 100755
--- a/tests/generic/080
+++ b/tests/generic/080
@@ -41,7 +41,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 echo "Silence is golden."
diff --git a/tests/generic/083 b/tests/generic/083
index 2f8c4a0d..9f09a7b0 100755
--- a/tests/generic/083
+++ b/tests/generic/083
@@ -53,7 +53,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/generic/086 b/tests/generic/086
index 5eeee50e..9c92c9bd 100755
--- a/tests/generic/086
+++ b/tests/generic/086
@@ -51,7 +51,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 _require_xfs_io_command "falloc"
 
diff --git a/tests/generic/088 b/tests/generic/088
index 46ce6ae4..1f01c4f5 100755
--- a/tests/generic/088
+++ b/tests/generic/088
@@ -47,7 +47,7 @@ _link_out_file
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 path=$TEST_DIR/t_access
diff --git a/tests/generic/088.cfg b/tests/generic/088.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/generic/088.cfg
+++ b/tests/generic/088.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/generic/088.out.irix b/tests/generic/088.out.irix
deleted file mode 100644
index f31ecf90..00000000
diff --git a/tests/generic/096 b/tests/generic/096
index daf9981a..bfdb93a1 100755
--- a/tests/generic/096
+++ b/tests/generic/096
@@ -45,7 +45,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_xfs_io_command "fzero"
 
diff --git a/tests/generic/100 b/tests/generic/100
index e5e819dc..8aff7b44 100755
--- a/tests/generic/100
+++ b/tests/generic/100
@@ -43,7 +43,7 @@ _cleanup()
  
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 # Use _populate_fs() in common/rc to create a directory structure.
diff --git a/tests/generic/105 b/tests/generic/105
index 9b7beb4d..8b6aa526 100755
--- a/tests/generic/105
+++ b/tests/generic/105
@@ -46,7 +46,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 # real QA test starts here
 
@@ -78,14 +78,7 @@ echo data > subdir/file
 _ls_l subdir/file | awk '{ print $1, $3 }'
 
 # add an ACL with a user ACE which has no exec permission 
-if [ "$HOSTOS" == "Linux" ]; then
-    setfacl -m u:$acl1:r subdir
-elif [ "$HOSTOS" == "IRIX" ]; then
-    chacl u:$acl:r--,g::---,o::--- subdir
-else
-    echo "Unknown OS!"
-    exit 1
-fi
+setfacl -m u:$acl1:r subdir
 
 # With the bug this gives: `ls: subdir/file: Permission denied'
 # because one needs at least an exec perm somewhere in acl
diff --git a/tests/generic/117 b/tests/generic/117
index b634861d..58165eaa 100755
--- a/tests/generic/117
+++ b/tests/generic/117
@@ -76,7 +76,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_attrs
diff --git a/tests/generic/120 b/tests/generic/120
index 9cf4ea8d..7d65f620 100755
--- a/tests/generic/120
+++ b/tests/generic/120
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_atime
diff --git a/tests/generic/123 b/tests/generic/123
index 453ede4b..e0948dff 100755
--- a/tests/generic/123
+++ b/tests/generic/123
@@ -46,7 +46,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_test
 _require_user
diff --git a/tests/generic/130 b/tests/generic/130
index 1e96630e..90bd1693 100755
--- a/tests/generic/130
+++ b/tests/generic/130
@@ -46,7 +46,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _require_sparse_files
diff --git a/tests/generic/132 b/tests/generic/132
index aa52c7db..24e568b2 100755
--- a/tests/generic/132
+++ b/tests/generic/132
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/generic/133 b/tests/generic/133
index f1a221e0..37a86e83 100755
--- a/tests/generic/133
+++ b/tests/generic/133
@@ -37,7 +37,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 _require_test
 _require_odirect
 
diff --git a/tests/generic/135 b/tests/generic/135
index 14b81321..52c1227b 100755
--- a/tests/generic/135
+++ b/tests/generic/135
@@ -37,7 +37,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_odirect
 _require_scratch
diff --git a/tests/generic/184 b/tests/generic/184
index d7c0eb9a..5690cd18 100755
--- a/tests/generic/184
+++ b/tests/generic/184
@@ -43,7 +43,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 rm -f $TEST_DIR/null
diff --git a/tests/generic/219 b/tests/generic/219
index bdeb0334..9a8d017e 100755
--- a/tests/generic/219
+++ b/tests/generic/219
@@ -41,7 +41,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux #IRIX
+_supported_os Linux
 _require_scratch
 _require_quota
 _require_user
diff --git a/tests/generic/226 b/tests/generic/226
index a099ec6d..cf6913ee 100755
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -35,7 +35,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 _require_scratch
 _require_odirect
 
diff --git a/tests/generic/230 b/tests/generic/230
index 28ca87da..0d2b2794 100755
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -41,7 +41,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux #IRIX
+_supported_os Linux
 _require_scratch
 _require_quota
 _require_user
diff --git a/tests/generic/234 b/tests/generic/234
index 75a2c23c..4605072e 100755
--- a/tests/generic/234
+++ b/tests/generic/234
@@ -88,7 +88,7 @@ test_setting()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux #IRIX
+_supported_os Linux
 _require_scratch
 _require_quota
 
diff --git a/tests/generic/235 b/tests/generic/235
index 309540ac..f991b1b7 100755
--- a/tests/generic/235
+++ b/tests/generic/235
@@ -41,7 +41,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux #IRIX
+_supported_os Linux
 _require_scratch
 _require_quota
 _require_user
diff --git a/tests/generic/273 b/tests/generic/273
index 578b1dab..de787e7a 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -125,7 +125,7 @@ _do_workload()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 
 echo "------------------------------"
diff --git a/tests/generic/274 b/tests/generic/274
index 61ab2209..7d093865 100755
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -46,7 +46,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_xfs_io_command "falloc"
 
diff --git a/tests/generic/275 b/tests/generic/275
index 955c4aca..4129cfcf 100755
--- a/tests/generic/275
+++ b/tests/generic/275
@@ -44,7 +44,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 
 echo "------------------------------"
diff --git a/tests/generic/309 b/tests/generic/309
index c6b89db9..9dee88c7 100755
--- a/tests/generic/309
+++ b/tests/generic/309
@@ -45,7 +45,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 echo "Silence is golden"
diff --git a/tests/generic/313 b/tests/generic/313
index a9069260..5a3cb859 100755
--- a/tests/generic/313
+++ b/tests/generic/313
@@ -44,7 +44,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 testfile=$TEST_DIR/testfile.$seq
diff --git a/tests/generic/320 b/tests/generic/320
index 3dd3bead..83ad21f4 100755
--- a/tests/generic/320
+++ b/tests/generic/320
@@ -49,7 +49,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 
 threads=100
diff --git a/tests/generic/378 b/tests/generic/378
index 8139b4d5..7f4d3061 100755
--- a/tests/generic/378
+++ b/tests/generic/378
@@ -51,7 +51,7 @@ rm -f $seqres.full
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 _require_user
 
diff --git a/tests/generic/379 b/tests/generic/379
index fb7420b0..408ade56 100755
--- a/tests/generic/379
+++ b/tests/generic/379
@@ -45,7 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 cp /dev/null $seqres.full
 chmod ugo+rwx $seqres.full
diff --git a/tests/generic/380 b/tests/generic/380
index 2a6dbb78..7d2e1d2b 100755
--- a/tests/generic/380
+++ b/tests/generic/380
@@ -48,7 +48,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_quota
diff --git a/tests/generic/384 b/tests/generic/384
index 452d26e3..fd162b60 100755
--- a/tests/generic/384
+++ b/tests/generic/384
@@ -46,7 +46,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs generic
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_test
 _require_quota
@@ -97,11 +97,7 @@ touch $dir/2
 cp $dir/2 $dir/3
 report_quota
 
-if [ "$HOSTOS" == "IRIX" ] ; then
-    mkfile 1M $TEST_DIR/6
-else
-    xfs_mkfile 1M $TEST_DIR/6
-fi
+xfs_mkfile 1M $TEST_DIR/6
 
 #try cp to dir
 cp $TEST_DIR/6 $dir/6
diff --git a/tests/generic/403 b/tests/generic/403
index 81d36608..17897ffb 100755
--- a/tests/generic/403
+++ b/tests/generic/403
@@ -49,7 +49,7 @@ rm -f $seqres.full
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_attrs
 
diff --git a/tests/generic/416 b/tests/generic/416
index 925524b8..7c6ced75 100755
--- a/tests/generic/416
+++ b/tests/generic/416
@@ -50,7 +50,7 @@ rm -f $seqres.full
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 
 fs_size=$((128 * 1024 * 1024))
diff --git a/tests/generic/424 b/tests/generic/424
index 1810e850..3653a31b 100755
--- a/tests/generic/424
+++ b/tests/generic/424
@@ -50,7 +50,7 @@ rm -f $seqres.full
 
 # Modify as appropriate.
 _supported_fs generic
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 _require_test_program stat_test
 _require_statx
diff --git a/tests/udf/102 b/tests/udf/102
index 8fd46976..dd644c01 100755
--- a/tests/udf/102
+++ b/tests/udf/102
@@ -43,7 +43,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs udf 
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _setup_udf_scratchdir
diff --git a/tests/xfs/003 b/tests/xfs/003
index 0fd4cfa0..3cc52423 100755
--- a/tests/xfs/003
+++ b/tests/xfs/003
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 [ -f core ] && rm -f core
@@ -72,14 +72,8 @@ test_done
 echo "=== TEST 5 ==="
 xfs_db -r -c 'inode 128' -c 'push' -c 'type' $TEST_DEV >$tmp.out 2>&1
 test_done
-# On IRIX we lose state after a "push" operation and don't
-# know the type is still inode
-# Probably not worth changing xfs_db on IRIX for this.
-if [ "$HOSTOS" != "IRIX" ]; then
-    if ! grep -q "current type is \"inode\"" $tmp.out
-    then
-	    cat $tmp.out
-    fi
+if ! grep -q "current type is \"inode\"" $tmp.out; then
+    cat $tmp.out
 fi
 
 echo "=== TEST 6 ==="
diff --git a/tests/xfs/004 b/tests/xfs/004
index f27f4b79..f06c4f0f 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -58,7 +58,7 @@ _populate_scratch()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
@@ -67,9 +67,7 @@ rm -f $seqres.full
 
 _populate_scratch
 
-[ "$HOSTOS" = "Linux" ] && DF_PROG="$DF_PROG -P --block-size=512"
-
-eval `$DF_PROG $SCRATCH_MNT 2>&1 \
+eval `$DF_PROG -P --block-size=512 $SCRATCH_MNT 2>&1 \
 	| tail -1 | $AWK_PROG '{ printf "blocks=%u used=%u avail=%u\n", $3, $4, $5 }'`
 echo "df gave: blocks=$blocks used=$used avail=$avail" >>$seqres.full
 echo "blocksize from mkfs is '$dbsize'" >>$seqres.full
diff --git a/tests/xfs/007 b/tests/xfs/007
index 92ec915f..d80d380f 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -43,7 +43,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os Linux Irix
+_supported_os Linux
 
 _require_scratch
 _require_xfs_quota
diff --git a/tests/xfs/008 b/tests/xfs/008
index 9f22087d..d38d320f 100755
--- a/tests/xfs/008
+++ b/tests/xfs/008
@@ -86,7 +86,7 @@ _do_test()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 rm -f $seqres.full
diff --git a/tests/xfs/009 b/tests/xfs/009
index abef2e05..1a5bd4d3 100755
--- a/tests/xfs/009
+++ b/tests/xfs/009
@@ -76,7 +76,7 @@ _filesize()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/xfs/012 b/tests/xfs/012
index 7b9a54d2..e2c810dd 100755
--- a/tests/xfs/012
+++ b/tests/xfs/012
@@ -103,7 +103,7 @@ _do_test()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 rm -f $seqres.full
diff --git a/tests/xfs/018 b/tests/xfs/018
index 451735fd..253af940 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -47,7 +47,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 # prelim
 rm -f $seqres.full $tmp.*
 _require_scratch
@@ -68,11 +68,7 @@ cat >$tmp.seq.params <<EOF
   version=2     logbsize=256k
 EOF
 
-if [ "$HOSTOS" = "IRIX" ]; then
-    start_blk=0
-else
-    start_blk=2
-fi
+start_blk=2
 
 # do the work for various log params which
 # should not effect the data content of the log
diff --git a/tests/xfs/018.cfg b/tests/xfs/018.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/018.cfg
+++ b/tests/xfs/018.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/018.op.irix b/tests/xfs/018.op.irix
deleted file mode 100644
index e3d3cd32..00000000
diff --git a/tests/xfs/019 b/tests/xfs/019
index 4d2fdeda..3e4f1692 100755
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -63,7 +63,7 @@ _filter_stat()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/xfs/022 b/tests/xfs/022
index b2b6142c..1cd6d28e 100755
--- a/tests/xfs/022
+++ b/tests/xfs/022
@@ -43,13 +43,12 @@ _link_out_file
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_tape $TAPE_DEV
 
 # note: fsstress uses an endian dependent random number generator, running this
-# will produce different output for big/little endian machines. This issue was
-# resolved by using different Linux/IRIX out files.
+# will produce different output for big/little endian machines.
 _create_dumpdir_stress
 _erase_hard
 _do_dump_sub
diff --git a/tests/xfs/022.cfg b/tests/xfs/022.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/022.cfg
+++ b/tests/xfs/022.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/022.out.irix b/tests/xfs/022.out.irix
deleted file mode 100644
index f72876aa..00000000
diff --git a/tests/xfs/023 b/tests/xfs/023
index 9a899a86..d304384b 100755
--- a/tests/xfs/023
+++ b/tests/xfs/023
@@ -42,7 +42,7 @@ _link_out_file
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_tape $TAPE_DEV
 _create_dumpdir_fill
diff --git a/tests/xfs/023.cfg b/tests/xfs/023.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/023.cfg
+++ b/tests/xfs/023.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/023.out.irix b/tests/xfs/023.out.irix
deleted file mode 100644
index 97845dd4..00000000
diff --git a/tests/xfs/026 b/tests/xfs/026
index 4cd77896..2111190b 100755
--- a/tests/xfs/026
+++ b/tests/xfs/026
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _create_dumpdir_fill
 _do_dump_file
diff --git a/tests/xfs/027 b/tests/xfs/027
index 10056838..58a62482 100755
--- a/tests/xfs/027
+++ b/tests/xfs/027
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _create_dumpdir_fill
 _do_dump_restore
diff --git a/tests/xfs/028 b/tests/xfs/028
index e6348902..19e09603 100755
--- a/tests/xfs/028
+++ b/tests/xfs/028
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 # wipe test dir clean first
 # so dump can be real quick
diff --git a/tests/xfs/030 b/tests/xfs/030
index 15f41edd..4d8d7d67 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -67,7 +67,7 @@ _check_ag()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/xfs/030.cfg b/tests/xfs/030.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/030.cfg
+++ b/tests/xfs/030.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/030.out.irix b/tests/xfs/030.out.irix
deleted file mode 100644
index 56adfd05..00000000
diff --git a/tests/xfs/031 b/tests/xfs/031
index 59d68c31..678c3249 100755
--- a/tests/xfs/031
+++ b/tests/xfs/031
@@ -95,7 +95,7 @@ EOF
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/xfs/031.cfg b/tests/xfs/031.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/031.cfg
+++ b/tests/xfs/031.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/031.out.irix b/tests/xfs/031.out.irix
deleted file mode 100644
index 32e902d4..00000000
diff --git a/tests/xfs/032 b/tests/xfs/032
index 6d644ad8..a6923b08 100755
--- a/tests/xfs/032
+++ b/tests/xfs/032
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_test_program "feature"
diff --git a/tests/xfs/033 b/tests/xfs/033
index 45caf081..a6f93f29 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -72,7 +72,7 @@ _filter_bad_ids()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/xfs/033.cfg b/tests/xfs/033.cfg
index 88e90e57..768ca9e0 100644
--- a/tests/xfs/033.cfg
+++ b/tests/xfs/033.cfg
@@ -1,3 +1,2 @@
-irix: irix
 linux,crc: crc.linux
 linux: linux
diff --git a/tests/xfs/033.out.irix b/tests/xfs/033.out.irix
deleted file mode 100644
index 59601179..00000000
diff --git a/tests/xfs/035 b/tests/xfs/035
index 25f2f697..6b6c86b7 100755
--- a/tests/xfs/035
+++ b/tests/xfs/035
@@ -41,7 +41,7 @@ _link_out_file
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_tape $TAPE_DEV
 _create_dumpdir_fill
diff --git a/tests/xfs/035.cfg b/tests/xfs/035.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/035.cfg
+++ b/tests/xfs/035.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/035.out.irix b/tests/xfs/035.out.irix
deleted file mode 100644
index 653f950a..00000000
diff --git a/tests/xfs/036 b/tests/xfs/036
index 280d0366..c65523f5 100755
--- a/tests/xfs/036
+++ b/tests/xfs/036
@@ -41,7 +41,7 @@ _link_out_file
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_tape $RMT_IRIXTAPE_DEV
 _create_dumpdir_fill
diff --git a/tests/xfs/036.cfg b/tests/xfs/036.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/036.cfg
+++ b/tests/xfs/036.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/036.out.irix b/tests/xfs/036.out.irix
deleted file mode 100644
index 6680373f..00000000
diff --git a/tests/xfs/039 b/tests/xfs/039
index 2f765b82..62735906 100755
--- a/tests/xfs/039
+++ b/tests/xfs/039
@@ -41,7 +41,7 @@ _link_out_file
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_tape $RMT_IRIXTAPE_DEV
 _create_dumpdir_fill
diff --git a/tests/xfs/039.cfg b/tests/xfs/039.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/039.cfg
+++ b/tests/xfs/039.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/039.out.irix b/tests/xfs/039.out.irix
deleted file mode 100644
index 9bd188fe..00000000
diff --git a/tests/xfs/041 b/tests/xfs/041
index 50385288..1b9500f7 100755
--- a/tests/xfs/041
+++ b/tests/xfs/041
@@ -46,7 +46,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/xfs/042 b/tests/xfs/042
index ba5eed32..182cebc3 100755
--- a/tests/xfs/042
+++ b/tests/xfs/042
@@ -46,7 +46,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/xfs/043 b/tests/xfs/043
index 59eeff6e..caca73da 100755
--- a/tests/xfs/043
+++ b/tests/xfs/043
@@ -43,7 +43,7 @@ _link_out_file
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_tape $TAPE_DEV 
 _create_dumpdir_fill
diff --git a/tests/xfs/043.cfg b/tests/xfs/043.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/043.cfg
+++ b/tests/xfs/043.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/043.out.irix b/tests/xfs/043.out.irix
deleted file mode 100644
index 61c226cc..00000000
diff --git a/tests/xfs/046 b/tests/xfs/046
index 841c12b6..446a69dc 100755
--- a/tests/xfs/046
+++ b/tests/xfs/046
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _create_dumpdir_symlinks
 _do_dump_file
diff --git a/tests/xfs/047 b/tests/xfs/047
index d7c0dce0..6ade1678 100755
--- a/tests/xfs/047
+++ b/tests/xfs/047
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 # wipe test dir clean first
 # so dump can be real quick
diff --git a/tests/xfs/048 b/tests/xfs/048
index 3dd685f0..32dbc057 100755
--- a/tests/xfs/048
+++ b/tests/xfs/048
@@ -43,7 +43,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 src/fault $TEST_DIR || exit
diff --git a/tests/xfs/050 b/tests/xfs/050
index 130df77e..ac7feb48 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -46,7 +46,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 cp /dev/null $seqres.full
 chmod a+rwx $seqres.full	# arbitrary users will write here
@@ -213,12 +213,7 @@ EOF
 projid_file="$tmp.projid"
 
 echo "*** user"
-if [ "$HOSTOS" == "IRIX" ]
-then
-	_qmount_option "quota"
-else
-	_qmount_option "uquota"
-fi
+_qmount_option "uquota"
 _exercise u
 
 echo "*** group"
@@ -226,12 +221,7 @@ _qmount_option "gquota"
 _exercise g
 
 echo "*** uqnoenforce"
-if [ "$HOSTOS" == "IRIX" ]
-then
-	_qmount_option "qnoenforce"
-else
-	_qmount_option "uqnoenforce"
-fi
+_qmount_option "uqnoenforce"
 _exercise uno
 
 echo "*** gqnoenforce"
diff --git a/tests/xfs/052 b/tests/xfs/052
index 56231f37..faad218e 100755
--- a/tests/xfs/052
+++ b/tests/xfs/052
@@ -48,7 +48,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/053 b/tests/xfs/053
index 80c244dd..353dda34 100755
--- a/tests/xfs/053
+++ b/tests/xfs/053
@@ -48,7 +48,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 # real QA test starts here
 
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_attrs
 
diff --git a/tests/xfs/055 b/tests/xfs/055
index 920ba288..383058a5 100755
--- a/tests/xfs/055
+++ b/tests/xfs/055
@@ -41,7 +41,7 @@ _link_out_file
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_tape $RMT_TAPE_USER@$RMT_IRIXTAPE_DEV
 _create_dumpdir_fill
diff --git a/tests/xfs/055.out.irix b/tests/xfs/055.out.irix
deleted file mode 100644
index 8bff6e9c..00000000
diff --git a/tests/xfs/056 b/tests/xfs/056
index 7e2624a2..613539a7 100755
--- a/tests/xfs/056
+++ b/tests/xfs/056
@@ -38,7 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _create_dumpdir_fill_perm
 _do_dump_file
diff --git a/tests/xfs/061 b/tests/xfs/061
index 2600f03d..8a4e254a 100755
--- a/tests/xfs/061
+++ b/tests/xfs/061
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 # src/dumpfile based on dumping from
 # _create_dumpdir_fill_perm (small dump)
diff --git a/tests/xfs/064 b/tests/xfs/064
index 410b4870..306e2cce 100755
--- a/tests/xfs/064
+++ b/tests/xfs/064
@@ -51,7 +51,7 @@ _ls_size_filter()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _create_dumpdir_hardlinks 9
 
diff --git a/tests/xfs/065 b/tests/xfs/065
index 6b2139f3..b7da0b8c 100755
--- a/tests/xfs/065
+++ b/tests/xfs/065
@@ -58,7 +58,7 @@ _list_dir()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 #
 # too much hassle to get output matching with quotas turned on
diff --git a/tests/xfs/066 b/tests/xfs/066
index 736439b4..061ce2dd 100755
--- a/tests/xfs/066
+++ b/tests/xfs/066
@@ -44,7 +44,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 _my_stat_filter()
diff --git a/tests/xfs/071 b/tests/xfs/071
index cf69b66b..c214dd51 100755
--- a/tests/xfs/071
+++ b/tests/xfs/071
@@ -100,7 +100,7 @@ write_block()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
 
diff --git a/tests/xfs/072 b/tests/xfs/072
index 43aa4211..5393cf8b 100755
--- a/tests/xfs/072
+++ b/tests/xfs/072
@@ -44,7 +44,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
 
diff --git a/tests/xfs/080 b/tests/xfs/080
index e0f5b1b9..20c4a72a 100755
--- a/tests/xfs/080
+++ b/tests/xfs/080
@@ -42,9 +42,6 @@ _cleanup()
 }
 
 _supported_fs xfs
-
-# Apparently should be able to work on IRIX,
-# but not at the moment.
 _supported_os Linux
 _require_test
 
@@ -57,9 +54,6 @@ echo
 
 # real QA test starts here
 
-# to get sh working like ksh on IRIX
-export _XPG=1
-
 $here/ltp/rwtest.sh $quiet $clean -i 2000 -f direct,buffered,sync
 status=$?
 [ $status -ne 0 ] && exit
diff --git a/tests/xfs/081 b/tests/xfs/081
index 6f6f8256..b54c8d54 100755
--- a/tests/xfs/081
+++ b/tests/xfs/081
@@ -38,7 +38,7 @@ status=1	# failure is the default!
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _cleanup()
 {
@@ -62,12 +62,6 @@ _scratch_unmount >/dev/null 2>&1
 # do a simple quota test to ensure DQUOT data is happening
 export MOUNT_OPTIONS="-o quota,gquota"
 
-if [ "$HOSTOS" = "IRIX" ]; then 
-    start=0
-else
-    start=2
-fi
-
 # mount with quotas?
 _scratch_mkfs_xfs "-l version=1" 1>/dev/null 2>&1
 _qmount
@@ -77,7 +71,7 @@ _scratch_unmount
 _mkfs_log "-l version=1"
 _create_log
 _check_log
-_print_transaction_inode $start
+_print_transaction_inode 2
 _cmp_output $seq.ugquota.trans_inode $filtered
 
 # got thru it all so we may have success
diff --git a/tests/xfs/082 b/tests/xfs/082
index 0c0b98af..f824d5ef 100755
--- a/tests/xfs/082
+++ b/tests/xfs/082
@@ -47,7 +47,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 # prelim
 rm -f $seqres.full $tmp.*
@@ -88,12 +88,6 @@ for s in sync nosync ; do
 	if [ "$mkfs" = "#" ]; then 
 	    continue
 	fi
-	if [ "$HOSTOS" = "IRIX" ]; then 
-	    # don't have umount rec at start on IRIX
-	    # so we won't have to skip over it and get to 
-	    # another stripe boundary
-	    start=0
-	fi
 	echo "--- mkfs=$mkfs, mnt=$mnt, sync=$s ---"
 	export MOUNT_OPTIONS="-o $mnt"
 	if ! _mkfs_log "-l $mkfs"; then
diff --git a/tests/xfs/082.cfg b/tests/xfs/082.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/082.cfg
+++ b/tests/xfs/082.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/082.op.irix b/tests/xfs/082.op.irix
deleted file mode 100644
index e3d3cd32..00000000
diff --git a/tests/xfs/084 b/tests/xfs/084
index 7aa193b5..6d20ef3a 100755
--- a/tests/xfs/084
+++ b/tests/xfs/084
@@ -50,17 +50,9 @@ pgsize=`$here/src/feature -s`
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
-if [ $HOSTOS == "IRIX" ]; then 
-    if uname -R | grep -iq debug; then 
-        # taking up to 23 mins on my 512K octane on debug
-        # not worth worrying about
-	_notrun "don't bother running on debug IRIX"
-    fi
-fi
-
 echo
 echo "*** First case - I/O blocksize same as pagesize"
 $here/src/resvtest -i 20 -b $pgsize "$TEST_DIR/resv" | _filter_resv
diff --git a/tests/xfs/092 b/tests/xfs/092
index f195077d..5a693195 100755
--- a/tests/xfs/092
+++ b/tests/xfs/092
@@ -45,7 +45,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_no_large_scratch_dev
 
diff --git a/tests/xfs/094 b/tests/xfs/094
index bf9eb2f9..d3606f81 100755
--- a/tests/xfs/094
+++ b/tests/xfs/094
@@ -43,7 +43,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_realtime
 _require_scratch
 
diff --git a/tests/xfs/096 b/tests/xfs/096
index 64754b2a..a9451f43 100755
--- a/tests/xfs/096
+++ b/tests/xfs/096
@@ -102,7 +102,7 @@ rm -f $seqres.full
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_v2log
 _require_xfs_mkfs_without_validation
diff --git a/tests/xfs/103 b/tests/xfs/103
index 48b8c59c..024416bd 100755
--- a/tests/xfs/103
+++ b/tests/xfs/103
@@ -64,7 +64,7 @@ _filter_noymlinks_flag()
 }
 
 # real QA test starts here
-_supported_os Linux IRIX
+_supported_os Linux
 _supported_fs xfs
 _require_scratch
 
diff --git a/tests/xfs/107 b/tests/xfs/107
index 2bd20a3d..7640bff3 100755
--- a/tests/xfs/107
+++ b/tests/xfs/107
@@ -51,7 +51,7 @@ s/Inode: \#\d+ \(\d+ blocks, \d+ extents\)/Inode: #[INO] (X blocks, Y extents)/;
 }
 
 _supported_fs xfs
-_supported_os Linux #IRIX
+_supported_os Linux
 _require_scratch
 _require_xfs_quota
 
diff --git a/tests/xfs/108 b/tests/xfs/108
index addb8e7d..86415366 100755
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -38,7 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux #IRIX
+_supported_os Linux
 _require_scratch
 _require_xfs_quota
 
diff --git a/tests/xfs/116 b/tests/xfs/116
index 1d13d15d..af2bcb99 100755
--- a/tests/xfs/116
+++ b/tests/xfs/116
@@ -47,7 +47,7 @@ _cleanup()
 # real QA test starts here
 
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_xfs_quota
diff --git a/tests/xfs/118 b/tests/xfs/118
index a5f5593f..fac3aa77 100755
--- a/tests/xfs/118
+++ b/tests/xfs/118
@@ -53,7 +53,7 @@ _cleanup()
 rm -f $seqres.full
 
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_command "$XFS_FSR_PROG" "xfs_fsr"
diff --git a/tests/xfs/119 b/tests/xfs/119
index 156d5e4a..ad6db455 100755
--- a/tests/xfs/119
+++ b/tests/xfs/119
@@ -47,7 +47,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/xfs/121 b/tests/xfs/121
index d301808b..2f84a3c8 100755
--- a/tests/xfs/121
+++ b/tests/xfs/121
@@ -42,7 +42,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 rm -f $seqres.full
 rm -f $tmp.log
diff --git a/tests/xfs/136 b/tests/xfs/136
index 0177698a..cbba64f7 100755
--- a/tests/xfs/136
+++ b/tests/xfs/136
@@ -50,7 +50,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_attrs
diff --git a/tests/xfs/142 b/tests/xfs/142
index a1efcc23..8a11d8bc 100755
--- a/tests/xfs/142
+++ b/tests/xfs/142
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/143 b/tests/xfs/143
index c389a2b8..4a3bd473 100755
--- a/tests/xfs/143
+++ b/tests/xfs/143
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/144 b/tests/xfs/144
index 41041c4e..da3995e9 100755
--- a/tests/xfs/144
+++ b/tests/xfs/144
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/145 b/tests/xfs/145
index 44b3e4ef..14a979b5 100755
--- a/tests/xfs/145
+++ b/tests/xfs/145
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/146 b/tests/xfs/146
index f6cd3f30..ea448db2 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -45,7 +45,7 @@ _report_filter () {
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 # link correct .out file
 _link_out_file
diff --git a/tests/xfs/146.cfg b/tests/xfs/146.cfg
index 7ffdfc07..7fd51a7d 100644
--- a/tests/xfs/146.cfg
+++ b/tests/xfs/146.cfg
@@ -1,2 +1 @@
-irix: irix
 linux: linux
diff --git a/tests/xfs/146.out.irix b/tests/xfs/146.out.irix
deleted file mode 100644
index 827be545..00000000
diff --git a/tests/xfs/147 b/tests/xfs/147
index 73ff7f9f..26b885c7 100755
--- a/tests/xfs/147
+++ b/tests/xfs/147
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/148 b/tests/xfs/148
index 42c04810..89f6906d 100755
--- a/tests/xfs/148
+++ b/tests/xfs/148
@@ -63,7 +63,7 @@ _check_ag()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/xfs/149 b/tests/xfs/149
index 1307d5c0..a72a5ba4 100755
--- a/tests/xfs/149
+++ b/tests/xfs/149
@@ -97,7 +97,7 @@ EOF
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/xfs/150 b/tests/xfs/150
index f9e690a9..8ab2682d 100755
--- a/tests/xfs/150
+++ b/tests/xfs/150
@@ -43,7 +43,7 @@ _filter_fs_handle()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/151 b/tests/xfs/151
index bba70944..982f10b4 100755
--- a/tests/xfs/151
+++ b/tests/xfs/151
@@ -64,7 +64,7 @@ _check_sids()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/152 b/tests/xfs/152
index 72bdabf2..1a6473f2 100755
--- a/tests/xfs/152
+++ b/tests/xfs/152
@@ -44,7 +44,7 @@ _filter_handles()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/153 b/tests/xfs/153
index cac77228..4fd348d6 100755
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -39,7 +39,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/154 b/tests/xfs/154
index 810a6ac1..398dd280 100755
--- a/tests/xfs/154
+++ b/tests/xfs/154
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/155 b/tests/xfs/155
index 1a1631e2..6f5ebfe3 100755
--- a/tests/xfs/155
+++ b/tests/xfs/155
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/156 b/tests/xfs/156
index d6e22b66..9e17e078 100755
--- a/tests/xfs/156
+++ b/tests/xfs/156
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/157 b/tests/xfs/157
index bf655902..ac7b63b7 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/158 b/tests/xfs/158
index 596f4c24..22710a12 100755
--- a/tests/xfs/158
+++ b/tests/xfs/158
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/159 b/tests/xfs/159
index fc5193ff..29bd7243 100755
--- a/tests/xfs/159
+++ b/tests/xfs/159
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/160 b/tests/xfs/160
index 9a2e2d04..8b8e2ec4 100755
--- a/tests/xfs/160
+++ b/tests/xfs/160
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/161 b/tests/xfs/161
index 11e53def..4124c7f9 100755
--- a/tests/xfs/161
+++ b/tests/xfs/161
@@ -45,7 +45,7 @@ _filter_get_allocinfo()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/162 b/tests/xfs/162
index 4edb68fd..4e6fc6f7 100755
--- a/tests/xfs/162
+++ b/tests/xfs/162
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/163 b/tests/xfs/163
index e283545c..32fff300 100755
--- a/tests/xfs/163
+++ b/tests/xfs/163
@@ -49,7 +49,7 @@ _filter_handles()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/164 b/tests/xfs/164
index 64133240..d8efaa63 100755
--- a/tests/xfs/164
+++ b/tests/xfs/164
@@ -66,7 +66,7 @@ _filter_bmap()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 testfile=$TEST_DIR/file.$seq
diff --git a/tests/xfs/165 b/tests/xfs/165
index 4080a88d..c4ae531f 100755
--- a/tests/xfs/165
+++ b/tests/xfs/165
@@ -63,7 +63,7 @@ _filter_bmap()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 # io tests 
diff --git a/tests/xfs/170 b/tests/xfs/170
index f772bc40..c5ae8e45 100755
--- a/tests/xfs/170
+++ b/tests/xfs/170
@@ -47,7 +47,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/xfs/172 b/tests/xfs/172
index 43ef5ab1..17463d79 100755
--- a/tests/xfs/172
+++ b/tests/xfs/172
@@ -46,7 +46,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/xfs/173 b/tests/xfs/173
index 8c4f9a6f..3a20a9e4 100755
--- a/tests/xfs/173
+++ b/tests/xfs/173
@@ -46,7 +46,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/xfs/174 b/tests/xfs/174
index 5e2e61b0..daa65a96 100755
--- a/tests/xfs/174
+++ b/tests/xfs/174
@@ -46,7 +46,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 
diff --git a/tests/xfs/181 b/tests/xfs/181
index a2010455..07d75171 100755
--- a/tests/xfs/181
+++ b/tests/xfs/181
@@ -49,7 +49,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 rm -f $seqres.full
 rm -f $tmp.log
diff --git a/tests/xfs/185 b/tests/xfs/185
index 17334de5..d7dfef7a 100755
--- a/tests/xfs/185
+++ b/tests/xfs/185
@@ -38,7 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os Linux IRIX
+_supported_os Linux
 
 _require_scratch
 _scratch_mkfs_xfs -b size=512 >/dev/null 2>&1
diff --git a/tests/xfs/188 b/tests/xfs/188
index 8798ecf9..370b93ca 100755
--- a/tests/xfs/188
+++ b/tests/xfs/188
@@ -51,7 +51,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_xfs_mkfs_ciname
 rm -f $seqres.full
diff --git a/tests/xfs/194 b/tests/xfs/194
index e9e85889..3226431f 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -42,7 +42,7 @@ _cleanup()
 
 # only xfs supported due to use of xfs_bmap
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 # real QA test starts here
 rm -f $seqres.full
diff --git a/tests/xfs/206 b/tests/xfs/206
index d549a4cc..70997e3f 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -52,7 +52,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 _require_loop
 
diff --git a/tests/xfs/291 b/tests/xfs/291
index c1cbe32c..3f5295c5 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -41,7 +41,7 @@ _cleanup()
 . ./common/filter
 
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 # real QA test starts here
 rm -f $seqres.full
diff --git a/tests/xfs/292 b/tests/xfs/292
index db890b5d..98404085 100755
--- a/tests/xfs/292
+++ b/tests/xfs/292
@@ -45,7 +45,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_test
 
 fsfile=$TEST_DIR/fsfile.$seq
diff --git a/tests/xfs/293 b/tests/xfs/293
index 6ac08c6f..60245a99 100755
--- a/tests/xfs/293
+++ b/tests/xfs/293
@@ -44,7 +44,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_command "$MAN_PROG" man
 
diff --git a/tests/xfs/295 b/tests/xfs/295
index 2325537c..c783df72 100755
--- a/tests/xfs/295
+++ b/tests/xfs/295
@@ -45,7 +45,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 _require_scratch
 _require_attrs
 
diff --git a/tests/xfs/297 b/tests/xfs/297
index 9accffd4..708a7f86 100755
--- a/tests/xfs/297
+++ b/tests/xfs/297
@@ -44,7 +44,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 _require_scratch
 _require_freeze
diff --git a/tests/xfs/303 b/tests/xfs/303
index de7b27ea..532abd7f 100755
--- a/tests/xfs/303
+++ b/tests/xfs/303
@@ -43,7 +43,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX Linux
+_supported_os Linux
 
 echo "Silence is golden"
 
-- 
2.13.3

