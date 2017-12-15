Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60551 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754594AbdLOCOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 21:14:05 -0500
Date: Thu, 14 Dec 2017 18:08:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 8/8] xfs/068: fix variability problems in file/dir count
 output
Message-ID: <20171215020859.GN6896@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314505158.18893.11894289091110903029.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In these tests we use a fixed sequence of operations in fsstress to
create a directory tree and then exercise xfsdump/xfsrestore on that.
However, this changes every time someone adds a new fsstress command,
or someone runs with FSSTRESS_AVOID, etc.

Therefore, check the counts directly from xfsrestore output instead
of relying on the golden output and do much more rigorous checking of
the dir tree complexity and the intactness of the dirs and files after
restoring them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: moar checking
---
 common/dump       |   40 ++++++++++++++++++++++++++++++++++++++--
 tests/xfs/027.out |    2 +-
 tests/xfs/068.out |    2 +-
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/common/dump b/common/dump
index 898aaa4..db2e156 100644
--- a/common/dump
+++ b/common/dump
@@ -316,7 +316,8 @@ _create_dumpdir_stress_num()
     echo "-----------------------------------------------"
     echo "fsstress : $_param"
     echo "-----------------------------------------------"
-    if ! $here/ltp/fsstress $_param -s 1 $FSSTRESS_AVOID -n $_count -d $dump_dir >$tmp.out 2>&1
+    echo $FSSTRESS_PROG $_param -s 1 $FSSTRESS_AVOID -n $_count -d $dump_dir >> $seqres.full
+    if ! $FSSTRESS_PROG $_param -s 1 $FSSTRESS_AVOID -n $_count -d $dump_dir >$tmp.out 2>&1
     then
         echo "    fsstress (count=$_count) returned $? - see $seqres.full"
 
@@ -1240,9 +1241,44 @@ _do_dump_restore()
     echo "xfsdump|xfsrestore ..."
     restore_opts="$_restore_debug$restore_args - $restore_dir"
     dump_opts="$_dump_debug$dump_args -s $dump_sdir - $SCRATCH_MNT"
+
+    # We expect there to be one more dir (and inode) than what's in dump_dir.
+    # Construct the string we expect to see in the output, since fsstress
+    # will create different directory structures every time someone adds
+    # a new command, runs with a different FSSTRESS_AVOID, etc.
+    expected_dirs=$(find $dump_dir -type d | wc -l)
+    expected_inodes=$(find $dump_dir | wc -l)
+    expected_str=": $((expected_dirs + 1)) directories and $((expected_inodes + 1)) entries processed"
+
+    if [ $expected_dirs -lt 100 ] || [ $expected_inodes -lt 600 ]; then
+        echo "Oddly small dir tree$expected_str"
+    fi
+
+    # Measure the md5 of every file...
+    (cd $dump_dir ; find . -type f -print0 | xargs -0 md5sum) > $seqres.md5
+    (cd $dump_dir ; find | sort) > $seqres.fstree
+
     echo "xfsdump $dump_opts | xfsrestore $restore_opts" | _dir_filter
-    $XFSDUMP_PROG $dump_opts 2>$tmp.dump.mlog | $XFSRESTORE_PROG $restore_opts 2>&1 | tee -a $seqres.full | _dump_filter
+    $XFSDUMP_PROG $dump_opts 2>$tmp.dump.mlog | $XFSRESTORE_PROG $restore_opts > $tmp.restore.mlog 2>&1
+    cat $tmp.restore.mlog >> $seqres.full
+    echo "xfsrestore output should contain$expected_str" >> $seqres.full
+    cat $tmp.restore.mlog | _dump_filter | sed -e 's/: \([0-9]*\) directories and \([0-9]*\) entries/: XXX directories and YYY entries/g'
     _dump_filter <$tmp.dump.mlog
+
+    # Did we actually restore as many dirs/files as we had?
+    if ! grep -q "$expected_str" $tmp.restore.mlog; then
+        echo "mismatch counts between directory tree and restored filesystem"
+        grep "directories and.*entries processed" $tmp.restore.mlog | sed -e 's/^.*:/found:/g'
+        echo "expected$expected_str"
+    fi
+
+    # Does the directory tree match?
+    diff -u $seqres.fstree <(cd $restore_dir/$dump_sdir ; find | sort)
+
+    # Measure the md5 of every restored file...
+    (cd $restore_dir/$dump_sdir ; md5sum --quiet -c $seqres.md5)
+
+    rm -rf $seqres.md5 $seqres.fstree $tmp.restore.mlog $tmp.dump.mlog
 }
 
 #
diff --git a/tests/xfs/027.out b/tests/xfs/027.out
index ba425a3..7665021 100644
--- a/tests/xfs/027.out
+++ b/tests/xfs/027.out
@@ -19,7 +19,7 @@ xfsrestore: session id: ID
 xfsrestore: media ID: ID
 xfsrestore: searching media for directory dump
 xfsrestore: reading directories
-xfsrestore: 3 directories and 39 entries processed
+xfsrestore: XXX directories and YYY entries processed
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed
diff --git a/tests/xfs/068.out b/tests/xfs/068.out
index fa3a552..f53c555 100644
--- a/tests/xfs/068.out
+++ b/tests/xfs/068.out
@@ -22,7 +22,7 @@ xfsrestore: session id: ID
 xfsrestore: media ID: ID
 xfsrestore: searching media for directory dump
 xfsrestore: reading directories
-xfsrestore: 383 directories and 1335 entries processed
+xfsrestore: XXX directories and YYY entries processed
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed
