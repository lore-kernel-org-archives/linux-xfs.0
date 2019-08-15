Return-Path: linux-xfs-owner@vger.kernel.org
Received: from userp2130.oracle.com ([156.151.31.86]:55858 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbfHOPVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 11:21:11 -0400
Subject: [PATCH 2/3] generic/561: kill duperemove directly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Aug 2019 08:19:06 -0700
Message-ID: <156588234658.24775.14952503026602339377.stgit@magnolia>
In-Reply-To: <156588233330.24775.15183725500886844319.stgit@magnolia>
References: <156588233330.24775.15183725500886844319.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While the kill statement added in the previous patch usually suffices to
shut down the bash loop that runs the duperemove processes, for whatever
reason this sometimes fails to kill duperemove.  Kill the duperemove
processes directly after removing the run file, which should cause the
bash loop to exit immediately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/561 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/561 b/tests/generic/561
index 2f3eff3c..26ecff5d 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -47,7 +47,7 @@ function end_test()
 	# stop duperemove running
 	if [ -e $dupe_run ]; then
 		rm -f $dupe_run
-		kill -INT $dedup_pids
+		$KILLALL_PROG -q $DUPEREMOVE_PROG > /dev/null 2>&1
 		wait $dedup_pids
 	fi
 
@@ -74,7 +74,7 @@ for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
 	while [ -e $dupe_run ]; do
 		$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir \
 			>>$seqres.full 2>&1
-	done &
+	done 2>&1 | sed -e '/Terminated/d' &
 	dedup_pids="$! $dedup_pids"
 done
 
