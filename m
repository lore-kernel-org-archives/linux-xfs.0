Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52562 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCTAp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:45:58 -0400
Subject: [PATCH 11/12] check: wipe scratch devices between tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:45:55 -0700
Message-ID: <155304275552.31707.6473598082840688691.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Wipe the scratch devices in between each test to ensure that tests are
formatting them and not making assumptions about previous contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check      |    1 +
 common/rc  |    6 ++++++
 common/xfs |    1 +
 3 files changed, 8 insertions(+)


diff --git a/check b/check
index a2c5ba21..bcf08dfe 100755
--- a/check
+++ b/check
@@ -737,6 +737,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
 			# _check_dmesg depends on this log in dmesg
 			touch ${RESULT_DIR}/check_dmesg
 		fi
+		_try_wipe_scratch_devs > /dev/null 2>&1
 		if [ "$DUMP_OUTPUT" = true ]; then
 			./$seq 2>&1 | tee $tmp.out
 			# Because $? would get tee's return code
diff --git a/common/rc b/common/rc
index 1c42515f..40eef80f 100644
--- a/common/rc
+++ b/common/rc
@@ -3942,6 +3942,12 @@ _require_fibmap()
 	rm -f $file
 }
 
+_try_wipe_scratch_devs()
+{
+	_scratch_unmount
+	test -x "$WIPEFS_PROG" && $WIPEFS_PROG -a $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV
+}
+
 init_rc
 
 ################################################################################
diff --git a/common/xfs b/common/xfs
index 24065813..af2b62ba 100644
--- a/common/xfs
+++ b/common/xfs
@@ -295,6 +295,7 @@ _require_xfs_db_command()
 	fi
 	command=$1
 
+	_scratch_mkfs_xfs >/dev/null 2>&1
 	_scratch_xfs_db -x -c "help" | grep $command > /dev/null || \
 		_notrun "xfs_db $command support is missing"
 }
