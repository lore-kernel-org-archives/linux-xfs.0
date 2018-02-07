Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50274 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932196AbeBGVT3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 16:19:29 -0500
Subject: [PATCH 1/4] xfs_scrub: remove -y parameter
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 07 Feb 2018 13:19:24 -0800
Message-ID: <151803836498.19313.14327204884614672549.stgit@magnolia>
In-Reply-To: <151803835881.19313.17455678207236452557.stgit@magnolia>
References: <151803835881.19313.17455678207236452557.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the -y parameter from scrub runs since we're removing that
option from xfs_scrub.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy  |    2 +-
 tests/xfs/286 |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 8c5417a..f78fc17 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -217,7 +217,7 @@ __scratch_xfs_fuzz_field_test() {
 		# Try fixing the filesystem online?!
 		if [ "${repair}" = "online" ] || [ "${repair}" = "both" ]; then
 			__fuzz_notify "++ Try to repair filesystem online"
-			_scratch_scrub -y 2>&1
+			_scratch_scrub 2>&1
 			res=$?
 			test $res -ne 0 && \
 				(>&2 echo "online repair failed ($res) with ${field} = ${fuzzverb}.")
diff --git a/tests/xfs/286 b/tests/xfs/286
index 67128b2..e71b933 100755
--- a/tests/xfs/286
+++ b/tests/xfs/286
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FS QA Test No. 286
 #
-# Race fio and xfs_scrub -y for a while to see if we crash or livelock.
+# Race fio and xfs_scrub for a while to see if we crash or livelock.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
@@ -75,7 +75,7 @@ end=$((start + (60 * TIME_FACTOR) ))
 killstress &
 echo "Repair started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
 while [ "$(date +%s)" -lt "$end" ]; do
-	XFS_SCRUB_FORCE_REPAIR=1 $TIMEOUT_PROG -s TERM $(( end - $(date +%s) + 2 )) $XFS_SCRUB_PROG -d -T -v -y $SCRATCH_MNT >> $seqres.full
+	XFS_SCRUB_FORCE_REPAIR=1 $TIMEOUT_PROG -s TERM $(( end - $(date +%s) + 2 )) $XFS_SCRUB_PROG -d -T -v $SCRATCH_MNT >> $seqres.full
 done
 
 echo "Test done"

