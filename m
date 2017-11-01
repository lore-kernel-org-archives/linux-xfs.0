Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43373 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933912AbdKAVrW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:22 -0400
Subject: [PATCH 08/14] common/xfs: remove inode-paths cruft
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:17 -0700
Message-ID: <150957283781.18388.9309616767855804002.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the inode-paths check from _check_xfs_test_fs because we don't
support inode paths, xfsprogs doesn't have a xfs_{check,repair}_ipaths
tool, and it's broken anyway because we ignore _check_xfs_filesystem
(which tells whether or not the filesystem is even still mounted).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |    7 -------
 1 file changed, 7 deletions(-)


diff --git a/common/xfs b/common/xfs
index 5643adf..79efb78 100644
--- a/common/xfs
+++ b/common/xfs
@@ -471,13 +471,6 @@ _check_xfs_test_fs()
 		TEST_RT="$TEST_RTDEV"
 
 	_check_xfs_filesystem $TEST_DEV $TEST_LOG $TEST_RT
-
-	# check for ipath consistency
-	if $XFS_GROWFS_PROG -n $TEST_DIR | grep -q 'inode-paths=1'; then
-		# errors go to stderr
-		xfs_check_ipaths $TEST_DIR >/dev/null
-		xfs_repair_ipaths -n $TEST_DIR >/dev/null
-	fi
 }
 
 _require_xfs_test_rmapbt()

