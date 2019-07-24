Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45734 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387438AbfGXP5B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:57:01 -0400
Date: Wed, 24 Jul 2019 08:56:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/3] xfs/194: unmount forced v4 fs during cleanup
Message-ID: <20190724155656.GH7084@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Unmount the V4 filesystem we forcibly created to run this test during
test cleanup so that the post-test wrapup checks won't try to remount
the filesystem with different MOUNT_OPTIONS (specifically, the ones
that get screened out by _force_xfsv4_mount_options) and fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/194 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/194 b/tests/xfs/194
index 3e186528..1f46d403 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -18,6 +18,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
+    _scratch_unmount
     rm -f $tmp.*
 }
 
