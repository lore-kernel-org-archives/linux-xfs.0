Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46306 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfA2QRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 11:17:17 -0500
Subject: [PATCH 1/4] xfs/093: make sure the scratch directory still exists
 after repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 29 Jan 2019 08:17:12 -0800
Message-ID: <154877863279.9277.4463697450629081138.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that we still have the scratch directory after repairing our
corrupted filesystem, because repair could have nuked it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/093 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/093 b/tests/xfs/093
index 2b16020c..2dfad39d 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -97,6 +97,7 @@ $CHATTR_PROG -R -f -i "${SCRATCH_MNT}/"
 
 echo "+ modify files (2)"
 broken=0
+mkdir -p "${TESTDIR}"
 for x in `seq 65 70`; do
 	touch "${TESTFILE}.${x}" || broken=1
 done
