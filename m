Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA1JriNM129346 for <xfs@oss.sgi.com>; Tue, 1 Nov 2011 14:53:44 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 4/4] xfstests: refactor dump test argument parsing
Date: Tue,  1 Nov 2011 14:53:07 -0500
Message-Id: <1320177187-18871-5-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320177187-18871-1-git-send-email-wkendall@sgi.com>
References: <1320177187-18871-1-git-send-email-wkendall@sgi.com>
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

The dump and restore helper functions all call the same _parse_args()
function. xfsdump and xfsrestore have some common options, but others
have different meanings/syntaxes or only exist in one program or the
other. Split _parse_args() into dump and restore variants.

Further, a test cannot pass most options to xfsrestore because many of
the parsed args are not used by the restore helper functions.  Change
the helpers so that the parsed options are available (to be used in
future tests).

Also add a check for a missing --multi argument, and change a couple of
callers to be consistent and use $* instead of "$@".

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common.dump |   95 ++++++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 71 insertions(+), 24 deletions(-)

diff --git a/common.dump b/common.dump
index 552085f..076517d 100644
--- a/common.dump
+++ b/common.dump
@@ -876,9 +876,10 @@ _dir_filter()
 }
 
 #
+# Parse xfsdump arguments.
 # Note: requires a space between option letter and argument
 #
-_parse_args()
+_parse_dump_args()
 {
     OPTIND=0
     dump_args=""
@@ -897,10 +898,8 @@ _parse_args()
 	    session_label=$2
 	    shift
             ;;
-	-o|-D|-F)
-	    dump_args="$dump_args $1"
-            ;;
 	--multi)
+            [ -z "$2" ] && _fail "missing argument for --multi"
 	    multi=$2
 	    shift
 	    ;;
@@ -910,6 +909,9 @@ _parse_args()
         --no-check-quota)
             do_quota_check=false
             ;;
+	-o|-D|-F)
+	    dump_args="$dump_args $1"
+            ;;
         -l|-d)
             [ -z "$2" ] && _fail "missing argument for $1"
 	    dump_args="$dump_args $1$2"
@@ -923,13 +925,55 @@ _parse_args()
     done
 }
 
+#
+# Parse xfsrestore arguments.
+# Note: requires a space between option letter and argument
+#
+_parse_restore_args()
+{
+    OPTIND=0
+    restore_args=""
+    while [ $# -gt 0 ]
+    do
+        case $1
+        in
+        -f)
+            [ -z "$2" ] && _fail "missing argument for -f"
+	    dumptape=$2
+	    dump_file=$2
+	    shift
+            ;;
+        -L)
+            [ -z "$2" ] && _fail "missing argument for -L"
+	    session_label=$2
+	    shift
+            ;;
+	--multi)
+            [ -z "$2" ] && _fail "missing argument for --multi"
+	    multi=$2
+	    shift
+	    ;;
+        --check-quota)
+            do_quota_check=true
+            ;;
+        --no-check-quota)
+            do_quota_check=false
+            ;;
+	*)
+            _fail "invalid argument to common.dump function: $1"
+            ;;
+        esac
+	shift
+    done
+}
+
 
 #
 # Dump a subdir
 #
 _do_dump_sub()
 {
-    _parse_args $*
+    _parse_dump_args $*
 
     echo "Dumping to tape..."
     opts="$_dump_debug$dump_args -s $dump_sdir -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
@@ -942,7 +986,7 @@ _do_dump_sub()
 #
 _do_dump()
 {
-    _parse_args $*
+    _parse_dump_args $*
 
     echo "Dumping to tape..."
     opts="$_dump_debug$dump_args -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
@@ -956,7 +1000,7 @@ _do_dump()
 #
 _do_dump_min()
 {
-    _parse_args $*
+    _parse_dump_args $*
 
     echo "Dumping to tape..."
     onemeg=1048576
@@ -971,7 +1015,7 @@ _do_dump_min()
 #
 _do_dump_file()
 {
-    _parse_args $*
+    _parse_dump_args $*
 
     echo "Dumping to file..."
     opts="$_dump_debug$dump_args -f $dump_file -M $media_label -L $session_label $SCRATCH_MNT"
@@ -984,7 +1028,7 @@ _do_dump_file()
 #
 _do_dump_multi_file()
 {
-    _parse_args "$@"
+    _parse_dump_args $*
 
     multi_args=""
 
@@ -1025,12 +1069,11 @@ _prepare_restore()
 #
 _do_restore()
 {
-    _parse_args $*
+    _parse_restore_args $*
     _prepare_restore
 
-
     echo "Restoring from tape..."
-    opts="$_restore_debug -f $dumptape  -L $session_label $restore_dir"
+    opts="$_restore_debug$restore_args -f $dumptape  -L $session_label $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
     $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
 }
@@ -1040,12 +1083,12 @@ _do_restore()
 #
 _do_restore_min()
 {
-    _parse_args $*
+    _parse_restore_args $*
     _prepare_restore
 
     echo "Restoring from tape..."
     onemeg=1048576
-    opts="$_restore_debug -m -b $onemeg -f $dumptape  -L $session_label $restore_dir"
+    opts="$_restore_debug$restore_args -m -b $onemeg -f $dumptape  -L $session_label $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
     $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
 }
@@ -1055,11 +1098,11 @@ _do_restore_min()
 #
 _do_restore_file()
 {
-    _parse_args $*
+    _parse_restore_args $*
     _prepare_restore_dir
 
     echo "Restoring from file..."
-    opts="$_restore_debug -f $dump_file  -L $session_label $restore_dir"
+    opts="$_restore_debug$restore_args -f $dump_file  -L $session_label $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
     $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
 }
@@ -1071,20 +1114,20 @@ _do_restore_file()
 #
 _do_restore_file_cum()
 {
-    _parse_args $*
+    _parse_restore_args $*
 
     echo "Restoring cumumlative from file..."
-    opts="$_restore_debug -f $dump_file -r $restore_dir"
+    opts="$_restore_debug$restore_args -f $dump_file -r $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
     $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
 }
 
 _do_restore_toc()
 {
-    _parse_args $*
+    _parse_restore_args $*
 
     echo "Contents of dump ..."
-    opts="$_restore_debug -f $dump_file -t"
+    opts="$_restore_debug$restore_args -f $dump_file -t"
     echo "xfsrestore $opts" | _dir_filter
     cd $SCRATCH_MNT # for IRIX which needs xfs cwd
     $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter_main |\
@@ -1103,7 +1146,7 @@ _do_restore_toc()
 #
 _do_restore_multi_file()
 {
-    _parse_args "$@"
+    _parse_restore_args $*
     _prepare_restore_dir
 
     multi_args=""
@@ -1116,22 +1159,26 @@ _do_restore_multi_file()
     done
 
     echo "Restoring from file..."
-    opts="$_restore_debug $multi_args -L $session_label $restore_dir"
+    opts="$_restore_debug$restore_args $multi_args -L $session_label $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
     $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
 }
 
 #
 # Do xfsdump piped into xfsrestore - xfsdump | xfsrestore
+# Pass dump options in $1 and restore options in $2, if required. e.g.:
+#     _do_dump_restore "-o -F" "-R"
+#     _do_dump_restore "" "-R"
 #
 # Use -s as we want to dump and restore to the same xfs partition
 #
 _do_dump_restore()
 {
-    _parse_args $*
+    _parse_dump_args $1
+    _parse_restore_args $2
     _prepare_restore_dir
     echo "xfsdump|xfsrestore ..."
-    restore_opts="$_restore_debug - $restore_dir"
+    restore_opts="$_restore_debug$restore_args - $restore_dir"
     dump_opts="$_dump_debug$dump_args -s $dump_sdir - $SCRATCH_MNT"
     echo "xfsdump $dump_opts | xfsrestore $restore_opts" | _dir_filter
     $XFSDUMP_PROG $dump_opts 2>$tmp.dump.mlog | $XFSRESTORE_PROG $restore_opts 2>&1 | tee -a $here/$seq.full | _dump_filter
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
