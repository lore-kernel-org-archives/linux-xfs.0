Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730791AbfFRVHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:07:34 -0400
Subject: [PATCH 4/4] xfs/119: fix MKFS_OPTIONS exporting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Jun 2019 14:07:27 -0700
Message-ID: <156089204777.345809.18314859473454869520.stgit@magnolia>
In-Reply-To: <156089201978.345809.17444450351199726553.stgit@magnolia>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test originally exported its own MKFS_OPTIONS to force the tested
filesystem config to the mkfs defaults + test-specific log size options.
This overrides whatever the test runner might have set in MKFS_OPTIONS.

In commit 2fd273886b525 ("xfs: refactor minimum log size formatting
code") we fail to export our test-specific MKFS_OPTIONS before
calculating the minimum log size, which leads to the wrong min log size
being calculated once we fixed the helper to be smarter about mkfs options.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/119 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/119 b/tests/xfs/119
index 8825a5c3..f245a0a6 100755
--- a/tests/xfs/119
+++ b/tests/xfs/119
@@ -38,7 +38,8 @@ _require_scratch
 # this may hang
 sync
 
-logblks=$(_scratch_find_xfs_min_logblocks -l version=2,su=64k)
+export MKFS_OPTIONS="-l version=2,su=64k"
+logblks=$(_scratch_find_xfs_min_logblocks)
 export MKFS_OPTIONS="-l version=2,size=${logblks}b,su=64k"
 export MOUNT_OPTIONS="-o logbsize=64k"
 _scratch_mkfs_xfs >/dev/null
