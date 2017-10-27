Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49733 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752768AbdJ0UZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 16:25:56 -0400
Date: Fri, 27 Oct 2017 13:25:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/6] common/xfs: remove inode-paths cruft
Message-ID: <20171027202550.GL5486@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150899709935.18389.17266737014565285073.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

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
