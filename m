Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38050 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDVQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:16:57 -0400
Subject: [PATCH 1/3] check: try to insulate the test framework from oom
 killer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:16:49 -0700
Message-ID: <155968300919.1646947.15217696927864278918.stgit@magnolia>
In-Reply-To: <155968300283.1646947.2586545304045786757.stgit@magnolia>
References: <155968300283.1646947.2586545304045786757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Some of the tests in xfstests (e.g. generic/224 with 512M of memory)
consume a lot of memory, and when this happens the OOM killer will run
around stomping on processes.  Sometimes it kills the ./check process
before it kills the actual test, which means that the test run doesn't
complete.  Therefore, make the ./check process OOM-proof while bumping
up the attractiveness of the test itself, in the hopes that even if the
test OOMs we'll still be able to continue on our way.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)


diff --git a/check b/check
index 8677141b..08419811 100755
--- a/check
+++ b/check
@@ -499,6 +499,17 @@ _expunge_test()
 	return 0
 }
 
+# Make the check script unattractive to the OOM killer...
+OOM_SCORE_ADJ="/proc/self/oom_score_adj"
+test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
+
+# ...and make the tests themselves somewhat more attractive to it, so that if
+# the system runs out of memory it'll be the test that gets killed and not the
+# test framework.
+_run_seq() {
+	bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq"
+}
+
 _detect_kmemleak
 _prepare_test_list
 
@@ -740,11 +751,11 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		fi
 		_try_wipe_scratch_devs > /dev/null 2>&1
 		if [ "$DUMP_OUTPUT" = true ]; then
-			./$seq 2>&1 | tee $tmp.out
+			_run_seq 2>&1 | tee $tmp.out
 			# Because $? would get tee's return code
 			sts=${PIPESTATUS[0]}
 		else
-			./$seq >$tmp.out 2>&1
+			_run_seq >$tmp.out 2>&1
 			sts=$?
 		fi
 
