Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51314 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfBZCfj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 21:35:39 -0500
Subject: [PATCH 1/2] misc: don't oom the box opening tmpfiles
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 25 Feb 2019 18:35:29 -0800
Message-ID: <155114852926.9683.4048206997940455508.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For the t_open_tmpfiles tests, limit ourselves to half of file-max so
that we don't OOM the test machine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/530 |    2 +-
 tests/generic/531 |    2 +-
 tests/xfs/501     |    2 +-
 tests/xfs/502     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/generic/530 b/tests/generic/530
index a2968d25..2bc4a992 100755
--- a/tests/generic/530
+++ b/tests/generic/530
@@ -42,7 +42,7 @@ _scratch_mount
 # Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
 # so that this test doesn't take forever or OOM the box
 max_files=$((50000 * LOAD_FACTOR))
-max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
+max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / 2 ))
 test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
 	max_files=$max_allowable_files
 ulimit -n $max_files
diff --git a/tests/generic/531 b/tests/generic/531
index f3eb5cde..5d60e4b6 100755
--- a/tests/generic/531
+++ b/tests/generic/531
@@ -44,7 +44,7 @@ nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
 # Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
 # so that this test doesn't take forever or OOM the box
 max_files=$((50000 * LOAD_FACTOR))
-max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
+max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / 2 ))
 test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
 	max_files=$max_allowable_files
 ulimit -n $max_files
diff --git a/tests/xfs/501 b/tests/xfs/501
index 51cdb020..d689145f 100755
--- a/tests/xfs/501
+++ b/tests/xfs/501
@@ -47,7 +47,7 @@ _scratch_mount
 # Set ULIMIT_NOFILE to min(file-max, 30000 files per LOAD_FACTOR)
 # so that this test doesn't take forever or OOM the box
 max_files=$((30000 * LOAD_FACTOR))
-max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
+max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / 2 ))
 test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
 	max_files=$max_allowable_files
 ulimit -n $max_files
diff --git a/tests/xfs/502 b/tests/xfs/502
index bfb063f4..5ad10316 100755
--- a/tests/xfs/502
+++ b/tests/xfs/502
@@ -46,7 +46,7 @@ nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
 # Set ULIMIT_NOFILE to min(file-max, 30000 files per cpu per LOAD_FACTOR)
 # so that this test doesn't take forever or OOM the box
 max_files=$((30000 * LOAD_FACTOR))
-max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
+max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / 2 ))
 test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
 	max_files=$max_allowable_files
 ulimit -n $max_files
