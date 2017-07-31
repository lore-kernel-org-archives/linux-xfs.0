Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdGaE2p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jul 2017 00:28:45 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/2] generic/224: filter out expected XFS warnings for mixed direct/buffer I/O
Date: Mon, 31 Jul 2017 12:28:24 +0800
Message-Id: <20170731042825.6250-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

generic/224 is doing concurrent direct and buffered I/O to the same
set of files, and this triggers some expected warnings on XFS. So
filter out these warnings just like what we did in generic/095 and
generic/247.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/224 | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tests/generic/224 b/tests/generic/224
index 2c30a75258f3..29b1c05d06df 100755
--- a/tests/generic/224
+++ b/tests/generic/224
@@ -82,5 +82,14 @@ for i in `seq 0 1 $FILES`; do
 done
 wait
 echo "*** Silence is golden ***"
-status=0
+
+# unmount and check dmesg, filtering out expected XFS warnings about mixed
+# direct and buffered I/O
+_scratch_unmount
+if [ "$FSTYP" == "xfs" ]; then
+	_check_dmesg _filter_xfs_dmesg
+else
+	_check_dmesg
+fi
+status=$?
 exit
-- 
2.13.3

