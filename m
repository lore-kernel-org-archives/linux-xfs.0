Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeFEQnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:43:18 -0400
Subject: [PATCH 3/6] xfs/310: fix _require_scratch_nocheck ordering
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 05 Jun 2018 09:43:14 -0700
Message-ID: <152821699476.24976.8261670705297495398.stgit@magnolia>
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

In xfs/310 we have to _require_scratch_nocheck last because anything
else that calls _require_scratch (e.g. _require_xfs_scratch_rmapbt) will
create the "check scratch after test exit" file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/310 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/310 b/tests/xfs/310
index 5c1f20ce..f7b7e30e 100755
--- a/tests/xfs/310
+++ b/tests/xfs/310
@@ -45,8 +45,8 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
-_require_scratch_nocheck
 _require_xfs_scratch_rmapbt
+_require_scratch_nocheck
 _require_xfs_io_command "falloc"
 
 rm -f $seqres.full

