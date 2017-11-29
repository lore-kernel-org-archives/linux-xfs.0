Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51160 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752187AbdK2BJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:09:09 -0500
Date: Tue, 28 Nov 2017 17:09:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] generic/388: use TIME_FACTOR to scale test duration
Message-ID: <20171129010904.GA31372@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Use TIME_FACTOR to increase the amount of time we spend testing log
shutdown recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/388 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/388 b/tests/generic/388
index 2760208..4f5a63b 100755
--- a/tests/generic/388
+++ b/tests/generic/388
@@ -65,7 +65,7 @@ _scratch_mkfs >> $seqres.full 2>&1
 _require_metadata_journaling $SCRATCH_DEV
 _scratch_mount || _fail "mount failed"
 
-for i in $(seq 1 50); do
+for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
 	($FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 999999 -p 4 >> $seqres.full &) \
 		> /dev/null 2>&1
 
