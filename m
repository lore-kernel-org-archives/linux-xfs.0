Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeFEQnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:43:00 -0400
Subject: [PATCH 1/6] xfs/439: don't check filesystem afterwards
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 05 Jun 2018 09:42:56 -0700
Message-ID: <152821697647.24976.16158232867443217035.stgit@magnolia>
In-Reply-To: <152821697018.24976.12939094615403004592.stgit@magnolia>
References: <152821697018.24976.12939094615403004592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We deliberately corrupted the scratch fs, so don't check it afterwards.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/439 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/439 b/tests/xfs/439
index 215c4b90..4ab1c986 100755
--- a/tests/xfs/439
+++ b/tests/xfs/439
@@ -47,7 +47,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
-_require_scratch
+_require_scratch_nocheck
 # We corrupt XFS on purpose, and check if assert failures would crash system.
 _require_no_xfs_bug_on_assert
 

