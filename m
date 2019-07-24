Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGXENV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:21 -0400
Subject: [PATCH 3/3] generic/561: kill duperemove after sleep_time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jul 2019 21:13:06 -0700
Message-ID: <156394158687.1850719.7335587409056156645.stgit@magnolia>
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

generic/561 can take a very long time to run on XFS (45+ minutes)
because it kicks off fsstress and a lot of duperemove processes, waits
50 seconds, and then waits for the duperemove processes to finish.
duperemove, however, fights with fsstress for file locks and can take
a very long time to make even a single pass over the filesystem and
exit, which means the test just takes forever to run.

Once we've decided to tear down the duperemove processes let's just send
them SIGINT and then wait for them to exit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/561 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/generic/561 b/tests/generic/561
index c11d5bfa..2f3eff3c 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -47,6 +47,7 @@ function end_test()
 	# stop duperemove running
 	if [ -e $dupe_run ]; then
 		rm -f $dupe_run
+		kill -INT $dedup_pids
 		wait $dedup_pids
 	fi
 
