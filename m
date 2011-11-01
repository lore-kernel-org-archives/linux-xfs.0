Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA1JrU16129301 for <xfs@oss.sgi.com>; Tue, 1 Nov 2011 14:53:30 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 1/4] xfstests: refactor cumulative restore tests
Date: Tue,  1 Nov 2011 14:53:04 -0500
Message-Id: <1320177187-18871-2-git-send-email-wkendall@sgi.com>
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

The cumulative restore tests call _do_restore_file_cum(),
which requires a dump level to be passed in the -l option
in order to determine whether the restore directory needs
to be prepared or not. -l is not a valid xfsrestore option,
so doing things this way prevents tests from passing options
to xfsrestore. It's more straightforward to have the test
call _prepare_restore_dir itself prior to starting a series
of cumulative restores.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 064         |    3 ++-
 065         |    3 ++-
 264         |    5 +++--
 common.dump |    6 ++----
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/064 b/064
index 16960c9..bf8a7bc 100755
--- a/064
+++ b/064
@@ -97,12 +97,13 @@ while [ $i -le 9 ]; do
 done
 
 echo "Do the cumulative restores"
+_prepare_restore_dir
 i=0
 while [ $i -le 9 ]; do
     dump_file=$tmp.df.level$i
     echo ""
     echo "restoring from df.level$i"
-    _do_restore_file_cum -l $i
+    _do_restore_file_cum
     echo "ls -l restore_dir"
     ls -lR $restore_dir | _ls_size_filter | _check_quota_file
     let i=$i+1
diff --git a/065 b/065
index f21a87f..2ebe1cc 100755
--- a/065
+++ b/065
@@ -174,12 +174,13 @@ while [ $i -le $num_dumps ]; do
 done
 
 echo "Do the cumulative restores"
+_prepare_restore_dir
 i=0
 while [ $i -le $num_dumps ]; do
     dump_file=$tmp.df.level$i
     echo ""
     echo "restoring from df.level$i"
-    _do_restore_file_cum -l $i
+    _do_restore_file_cum
     echo "list restore_dir"
     _list_dir $restore_dir | _check_quota_file | tee $tmp.restorals.$i
     let i=$i+1
diff --git a/264 b/264
index 9544a58..1caa15f 100755
--- a/264
+++ b/264
@@ -63,10 +63,11 @@ _do_dump_file
 _add_and_append_dumpdir_fill
 dump_file=$tmp.df.1
 _do_dump_file -l 1 -D
+_prepare_restore_dir
 dump_file=$tmp.df.0
-_do_restore_file_cum -l 0
+_do_restore_file_cum
 dump_file=$tmp.df.1
-_do_restore_file_cum -l 1
+_do_restore_file_cum
 _ls_compare_sub
 _diff_compare
 
diff --git a/common.dump b/common.dump
index 3942e83..56b348a 100644
--- a/common.dump
+++ b/common.dump
@@ -1065,14 +1065,12 @@ _do_restore_file()
 
 #
 # Cumulative restore from a file
-# Need to specify the dump level e.g. "-l 0"
+# Must call _prepare_restore_dir before the first
+# (and only the first) call to this function.
 #
 _do_restore_file_cum()
 {
     _parse_args $*
-    if echo $dump_args | grep '\-l0' >/dev/null; then
-	_prepare_restore_dir
-    fi
 
     echo "Restoring cumumlative from file..."
     opts="$_restore_debug -f $dump_file -r $restore_dir"
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
