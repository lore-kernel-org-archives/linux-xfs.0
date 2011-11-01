Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA1JrcRP129331 for <xfs@oss.sgi.com>; Tue, 1 Nov 2011 14:53:38 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 3/4] xfstests: allow dump file name to be passed as arg
Date: Tue,  1 Nov 2011 14:53:06 -0500
Message-Id: <1320177187-18871-4-git-send-email-wkendall@sgi.com>
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

xfsdump tests using tapes (rather than files) can pass the tape pathname
to the dump/restore helper functions using the -f option. Change
_parse_args() so that this can be done for file-based tests as well, so
that they don't have to set the global 'dump_file' variable before doing
the dump or restore.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 061         |    5 ++---
 064         |    9 +++------
 065         |    9 +++------
 264         |   12 ++++--------
 common.dump |    3 +++
 5 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/061 b/061
index 2b08e11..8f1d149 100755
--- a/061
+++ b/061
@@ -44,11 +44,10 @@ _supported_os IRIX Linux
 # _create_dumpdir_fill_perm (small dump)
 
 _create_dumpdir_fill_perm
-dump_file=src/dumpfile # override dump_file to checked-in dumpfile
-session_label="stress_056"
+# override dump_file to checked-in dumpfile
 # we have no quotas to restore
 # if we happen to run this on crackle then put the hostname back
-_do_restore_file --no-check-quota |
+_do_restore_file --no-check-quota -f src/dumpfile -L stress_056 |
 sed -e 's/HOSTNAME/crackle/g' -e 's#SCRATCH_DEV#/dev/dsk/dks0d2s1#'
 _diff_compare_sub
 _ls_nodate_compare_sub
diff --git a/064 b/064
index bf8a7bc..8e9e694 100755
--- a/064
+++ b/064
@@ -78,8 +78,7 @@ while [ $i -le 9 ]; do
        cat $tmp.dates.$i >>$seq.full
     fi
 
-    dump_file=$tmp.df.level$i
-    _do_dump_file -l $i
+    _do_dump_file -f $tmp.df.level$i -l $i
     let i=$i+1
 done
 
@@ -91,8 +90,7 @@ i=0
 while [ $i -le 9 ]; do
     echo ""
     echo "restoring from df.level$i"
-    dump_file=$tmp.df.level$i
-    _do_restore_toc
+    _do_restore_toc -f $tmp.df.level$i
     let i=$i+1
 done
 
@@ -100,10 +98,9 @@ echo "Do the cumulative restores"
 _prepare_restore_dir
 i=0
 while [ $i -le 9 ]; do
-    dump_file=$tmp.df.level$i
     echo ""
     echo "restoring from df.level$i"
-    _do_restore_file_cum
+    _do_restore_file_cum -f $tmp.df.level$i
     echo "ls -l restore_dir"
     ls -lR $restore_dir | _ls_size_filter | _check_quota_file
     let i=$i+1
diff --git a/065 b/065
index 2ebe1cc..c1dee5d 100755
--- a/065
+++ b/065
@@ -158,8 +158,7 @@ while [ $i -le $num_dumps ]; do
     echo "Listing of what files we have at level $i:"
     _list_dir $dump_dir	| tee $tmp.ls.$i
 
-    dump_file=$tmp.df.level$i
-    _do_dump_file -l $i
+    _do_dump_file -f $tmp.df.level$i -l $i
     let i=$i+1
 done
 
@@ -168,8 +167,7 @@ i=0
 while [ $i -le $num_dumps ]; do
     echo ""
     echo "restoring from df.level$i"
-    dump_file=$tmp.df.level$i
-    _do_restore_toc
+    _do_restore_toc -f $tmp.df.level$i
     let i=$i+1
 done
 
@@ -177,10 +175,9 @@ echo "Do the cumulative restores"
 _prepare_restore_dir
 i=0
 while [ $i -le $num_dumps ]; do
-    dump_file=$tmp.df.level$i
     echo ""
     echo "restoring from df.level$i"
-    _do_restore_file_cum
+    _do_restore_file_cum -f $tmp.df.level$i
     echo "list restore_dir"
     _list_dir $restore_dir | _check_quota_file | tee $tmp.restorals.$i
     let i=$i+1
diff --git a/264 b/264
index 1caa15f..949e911 100755
--- a/264
+++ b/264
@@ -58,16 +58,12 @@ fi
 _create_dumpdir_fill
 # ensure file/dir timestamps precede dump timestamp
 sleep 2
-dump_file=$tmp.df.0
-_do_dump_file
+_do_dump_file -f $tmp.df.0
 _add_and_append_dumpdir_fill
-dump_file=$tmp.df.1
-_do_dump_file -l 1 -D
+_do_dump_file -f $tmp.df.1 -l 1 -D
 _prepare_restore_dir
-dump_file=$tmp.df.0
-_do_restore_file_cum
-dump_file=$tmp.df.1
-_do_restore_file_cum
+_do_restore_file_cum -f $tmp.df.0
+_do_restore_file_cum -f $tmp.df.1
 _ls_compare_sub
 _diff_compare
 
diff --git a/common.dump b/common.dump
index 09f1a91..552085f 100644
--- a/common.dump
+++ b/common.dump
@@ -889,6 +889,7 @@ _parse_args()
         -f)
             [ -z "$2" ] && _fail "missing argument for -f"
 	    dumptape=$2
+	    dump_file=$2
 	    shift
             ;;
         -L)
@@ -1080,6 +1081,8 @@ _do_restore_file_cum()
 
 _do_restore_toc()
 {
+    _parse_args $*
+
     echo "Contents of dump ..."
     opts="$_restore_debug -f $dump_file -t"
     echo "xfsrestore $opts" | _dir_filter
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
