Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42928 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfBETbb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 14:31:31 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] xfs/068: Verify actual file count instead of reported file count
Date: Tue,  5 Feb 2019 21:31:18 +0200
Message-Id: <20190205193118.30969-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

This test has the number of files/dirs created by xfsrestore hardcoded
in golden output.

When fsstress is added new ops, the number of files/dirs created with
the same random seed changes and this regularly breaks this test,
so when new fsstress ops are added they should be either added to the
dump test blacklist or golden output of this test needs to be ammended
to reflect the change.

The golden output includes only the file count reported by xfsrestore
and test does not even verify that this is the correct file count.
Instead, leave the golden output neutral and explicitly verify that
file count before and after the test are the same.

With this change, the test becomes agnostic to fsstress ops and we
could also stop blacklisting clone/dedup/copy ops if we want.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/dump       | 20 ++++++++++++++++++++
 tests/xfs/068     | 14 +++++++++++++-
 tests/xfs/068.out |  2 +-
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/common/dump b/common/dump
index 6b08fc4e..7c4c9cd8 100644
--- a/common/dump
+++ b/common/dump
@@ -1517,6 +1517,26 @@ _check_quota_file()
    _check_quota 'xfsdump_quotas' 'xfsdump_quotas_group' 'xfsdump_quotas_proj'
 }
 
+_count_dir_files()
+{
+	local dir=$1
+
+	local ndirs=$(find $dir -type d | wc -l)
+	local nents=$(find $dir | wc -l)
+
+	echo "$ndirs directories and $nents entries"
+}
+
+_count_dumpdir_files()
+{
+	_count_dir_files $dump_dir
+}
+
+_count_restoredir_files()
+{
+	_count_dir_files $restore_dir/$dump_sdir
+}
+
 
 # make sure this script returns success
 /bin/true
diff --git a/tests/xfs/068 b/tests/xfs/068
index 7f5900fc..a422d095 100755
--- a/tests/xfs/068
+++ b/tests/xfs/068
@@ -30,12 +30,24 @@ _cleanup()
 . ./common/rc
 . ./common/dump
 
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
 
 _create_dumpdir_stress_num 4096
-_do_dump_restore
+
+echo -n "Before: " >> $seqres.full
+_count_dumpdir_files | tee $tmp.before >> $seqres.full
+
+# filter out the file count, it changes as fsstress adds new operations
+_do_dump_restore | sed -e "/entries processed$/s/[0-9][0-9]*/NUM/g"
+
+echo -n "After: " >> $seqres.full
+_count_restoredir_files | tee $tmp.after >> $seqres.full
+diff -u $tmp.before $tmp.after
 
 # success, all done
 exit
diff --git a/tests/xfs/068.out b/tests/xfs/068.out
index fa3a5523..2b276b77 100644
--- a/tests/xfs/068.out
+++ b/tests/xfs/068.out
@@ -22,7 +22,7 @@ xfsrestore: session id: ID
 xfsrestore: media ID: ID
 xfsrestore: searching media for directory dump
 xfsrestore: reading directories
-xfsrestore: 383 directories and 1335 entries processed
+xfsrestore: NUM directories and NUM entries processed
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed
-- 
2.17.1
