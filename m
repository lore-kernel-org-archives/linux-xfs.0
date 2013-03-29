Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A14F7F90
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 23:50:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79616304039
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 21:50:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RrFdZBLzFJyTApq4 for
	<xfs@oss.sgi.com>; Thu, 28 Mar 2013 21:50:13 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2T4oCj4031022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 29 Mar 2013 00:50:13 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] xfstests: fix common source file path
Date: Fri, 29 Mar 2013 12:49:55 +0800
Message-Id: <1364532595-21273-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

After the re-factor, common.* have been renamed to common/* but there
are several files still look for the old path, fix it.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2:
  Fix more files containing common.*, not only file new

 README               |  6 +++---
 check                |  2 +-
 common/config        | 10 +++++-----
 common/dump          |  4 ++--
 common/filter.btrfs  |  2 +-
 common/rc            | 12 ++++++------
 new                  |  6 +++---
 setup                |  4 ++--
 soak                 |  4 ++--
 tools/README.auto-qa |  2 +-
 tools/auto-qa        |  2 +-
 11 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/README b/README
index 2d231de..d4d4f31 100644
--- a/README
+++ b/README
@@ -65,7 +65,7 @@ Preparing system for tests (IRIX and Linux):
                environment variable set to "yes" will enable their use.
              - setenv DIFF_LENGTH "number of diff lines to print from a failed test",
                by default 10, set to 0 to print the full diff
-        - or add a case to the switch in common.config assigning
+        - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
           machine
 	- or add these variables to a file called local.config and keep that
@@ -113,7 +113,7 @@ Test script environment:
 
     When developing a new test script keep the following things in
     mind.  All of the environment variables and shell procedures are
-    available to the script once the "common.rc" file has been
+    available to the script once the "common/rc" file has been
     sourced.
 
      1. The tests are run from an arbitrary directory.  If you want to
@@ -166,7 +166,7 @@ Test script environment:
 	_within_tolerance	- fancy numerical "close enough is good
 				  enough" filter for deterministic
 				  output ... see comments in
-				  common.filter for an explanation
+				  common/filter for an explanation
 
 	_filter_date		- turn ctime(3) format dates into the
 				  string DATE for deterministic
diff --git a/check b/check
index 18cae75..fdc7e2e 100755
--- a/check
+++ b/check
@@ -56,7 +56,7 @@ if [ "$HOSTOS" == "Linux" ]; then
 fi
 export FSTYP
 
-# we need common.config
+# we need common/config
 if ! . ./common/config
 then
     echo "$iam: failed to source common/config"
diff --git a/common/config b/common/config
index 7a95adc..bf62996 100644
--- a/common/config
+++ b/common/config
@@ -241,12 +241,12 @@ fi
 
 echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
 if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
-    echo "common.config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
+    echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
     exit 1
 fi
 
 if [ ! -d "$TEST_DIR" ]; then
-    echo "common.config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
+    echo "common/config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
     exit 1
 fi
 
@@ -254,7 +254,7 @@ fi
 # to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
 if [ ! -z "$SCRATCH_DEV_POOL" ]; then
     if [ ! -z "$SCRATCH_DEV" ]; then
-        echo "common.config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
+        echo "common/config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
         exit 1
     fi
     SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
@@ -263,12 +263,12 @@ fi
 
 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
-    echo "common.config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
+    echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
     exit 1
 fi
 
 if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
-    echo "common.config: Error: \$SCRATCH_MNT ($SCRATCH_MNT) is not a directory"
+    echo "common/config: Error: \$SCRATCH_MNT ($SCRATCH_MNT) is not a directory"
     exit 1
 fi
 
diff --git a/common/dump b/common/dump
index 5d4d2ae..73d0304 100644
--- a/common/dump
+++ b/common/dump
@@ -973,7 +973,7 @@ _parse_dump_args()
 	    shift
             ;;
 	*)
-            _fail "invalid argument to common.dump function: $1"
+            _fail "invalid argument to common/dump function: $1"
             ;;
         esac
 	shift
@@ -1018,7 +1018,7 @@ _parse_restore_args()
 	    restore_args="$restore_args $1"
             ;;
 	*)
-            _fail "invalid argument to common.dump function: $1"
+            _fail "invalid argument to common/dump function: $1"
             ;;
         esac
 	shift
diff --git a/common/filter.btrfs b/common/filter.btrfs
index 4aaaa9b..b1aa733 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -1,6 +1,6 @@
 # Filters for btrfs command output
 
-. ./common.filter.btrfs
+. ./common/filter.btrfs
 
 # Some, but not all, commands emit "Btrfs <version>"
 _filter_btrfs_version()
diff --git a/common/rc b/common/rc
index 5145cb6..09fb83f 100644
--- a/common/rc
+++ b/common/rc
@@ -151,12 +151,12 @@ _fsck_opts()
 [ -z "$FSCK_OPTIONS" ] && _fsck_opts
 
 
-# we need common.config
+# we need common/config
 if [ "$iam" != "check" ]
 then
     if ! . ./common/config
         then
-        echo "$iam: failed to source common.config"
+        echo "$iam: failed to source common/config"
         exit 1
     fi
 fi
@@ -2065,7 +2065,7 @@ then
 
     if [ "$TEST_DEV" = ""  ]
     then
-        echo "common.rc: Error: \$TEST_DEV is not set"
+        echo "common/rc: Error: \$TEST_DEV is not set"
         exit 1
     fi
 
@@ -2075,11 +2075,11 @@ then
         # $TEST_DEV is not mounted
         if ! _test_mount
         then
-            echo "common.rc: retrying test device mount with external set"
+            echo "common/rc: retrying test device mount with external set"
             [ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
             if ! _test_mount
             then
-                echo "common.rc: could not mount $TEST_DEV on $TEST_DIR"
+                echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
                 exit 1
             fi
         fi
@@ -2087,7 +2087,7 @@ then
 
     if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
     then
-        echo "common.rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
+        echo "common/rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
         $DF_PROG $TEST_DEV
         exit 1
     fi
diff --git a/new b/new
index 94638f6..d9c38c8 100755
--- a/new
+++ b/new
@@ -23,7 +23,7 @@
 
 # generic initialization
 iam=new
-. ./common.rc
+. ./common/rc
 
 trap "rm -f /tmp/$$.; exit" 0 1 2 3 15
 
@@ -121,8 +121,8 @@ _cleanup()
 }
 
 # get standard environment, filters and checks
-. ./common.rc
-. ./common.filter
+. ./common/rc
+. ./common/filter
 
 # real QA test starts here
 
diff --git a/setup b/setup
index 5225951..eb7bdb3 100755
--- a/setup
+++ b/setup
@@ -15,9 +15,9 @@
 # along with this program; if not, write the Free Software Foundation,
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
-if ! . ./common.config
+if ! . ./common/config
 then
-    echo "check: failed to source common.config"
+    echo "check: failed to source common/config"
     exit 1
 fi
 
diff --git a/soak b/soak
index 0cf27a7..7e9eea0 100755
--- a/soak
+++ b/soak
@@ -19,8 +19,8 @@
 #
 
 # get standard environment, filters and checks
-. ./common.rc
-. ./common.filter
+. ./common/rc
+. ./common/filter
 
 tmp=/tmp/$$
 seq=soak
diff --git a/tools/README.auto-qa b/tools/README.auto-qa
index 82a873e..0380b3f 100644
--- a/tools/README.auto-qa
+++ b/tools/README.auto-qa
@@ -4,7 +4,7 @@ ______________________                                      ______________
 
 	- pick/create a user to run auto-qa and check they 
           can use ptools to check out of the tree
-	- add your host to xfstests/common.config and check this file in
+	- add your host to xfstests/common/config and check this file in
           OR create a local.config file in your xfstests directory
 	- make a directory "$HOME/qa"
 	- make a kernel workarea "$HOME/qa/2.4.x-xfs" for 2.4.x-xfs
diff --git a/tools/auto-qa b/tools/auto-qa
index 4025e78..8d8f5ef 100755
--- a/tools/auto-qa
+++ b/tools/auto-qa
@@ -86,7 +86,7 @@ STATE=$ROOT/qa.state
 QADIR="$WORKAREA/xfstests"
 SUDO="su -c"
 CONFIG="$ROOT/$HOST.config"
-COMMON_CONFIG="$QADIR/common.config"
+COMMON_CONFIG="$QADIR/common/config"
 SH="/bin/sh"
 LOG="$ROOT/qa.log"
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
