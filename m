Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54246 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:24:39 -0400
Subject: [PATCH 5/8] xfs/266: fix restore summary counter when quotas are
 enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:33 -0700
Message-ID: <154111437365.6577.10855653156134262665.stgit@magnolia>
In-Reply-To: <154111434286.6577.15010861884505931015.stgit@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When quotas are enabled, an incremental backup has to record the quota
file updates too.  Inside a dump the quota files are stored as special
files under the root dump directory.  xfsrestore reports the dump dir
in its restore summary counts even if the dump dir was only there for
the sake of the quota updates, which makes the test fail.  Fix this by
massaging the output when quotas are turned on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/266 |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/266 b/tests/xfs/266
index c4c3e8d9..9084f5b9 100755
--- a/tests/xfs/266
+++ b/tests/xfs/266
@@ -26,6 +26,21 @@ _add_and_append_dumpdir_fill()
     _append_dumpdir_fill
 }
 
+# Quota files are stored as special files in the dumpdir of the incremental
+# backup.  This throws off the directory/file count reported because xfsrestore
+# includes the dumpdir in the restore summary counts.
+filter_cumulative_quota_updates() {
+    $here/src/feature -U $SCRATCH_DEV && quota=1
+    $here/src/feature -G $SCRATCH_DEV && quota=1
+    $here/src/feature -P $SCRATCH_DEV && quota=1
+
+    $AWK_PROG -v quota=$quota '
+	/entries processed/ {
+		if (quota) {$2--; $5--;}
+	}
+	{print}'
+}
+
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/dump
@@ -47,7 +62,7 @@ _add_and_append_dumpdir_fill
 _do_dump_file -f $tmp.df.1 -l 1 -D
 _prepare_restore_dir
 _do_restore_file_cum -f $tmp.df.0
-_do_restore_file_cum -f $tmp.df.1
+_do_restore_file_cum -f $tmp.df.1 | filter_cumulative_quota_updates
 _ls_compare_sub
 _diff_compare
 
