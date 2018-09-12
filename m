Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726919AbeILL1h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 07:27:37 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8C6KerI045538
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:38 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2meshgyy2s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:37 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Sep 2018 02:24:36 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3 11/19] Fix generic/102 to work with 64k block size
Date: Wed, 12 Sep 2018 11:56:18 +0530
In-Reply-To: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180912062626.14349-12-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

With 64k block size, mkfs.xfs fails with the following message when the
filesystem size is 512MiB in size,

"log size 2037 blocks too small, minimum size is 2473 blocks"

Hence this commit increases the test filesystem size to 1GiB. Also, the
size of the test file is increased to 800MiB which is ~80% of the test
filesystem size. This is in proportion to the 400MiB test file used with
the original 512MiB test filesystem.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/102     |  4 ++--
 tests/generic/102.out | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tests/generic/102 b/tests/generic/102
index faf940a..29abd89 100755
--- a/tests/generic/102
+++ b/tests/generic/102
@@ -31,14 +31,14 @@ _require_scratch
 
 rm -f $seqres.full
 
-dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
+dev_size=$((1024 * 1024 * 1024))     # 1GB filesystem
 _scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
 _scratch_mount
 
 for ((i = 0; i < 10; i++)); do
 	echo "loop $i" >>$seqres.full
 
-	$XFS_IO_PROG -f -c "pwrite -b 1m 0 400m" "$SCRATCH_MNT"/file | \
+	$XFS_IO_PROG -f -c "pwrite -b 1m 0 800m" "$SCRATCH_MNT"/file | \
 _filter_xfs_io | _filter_scratch
 
 	rm -f "$SCRATCH_MNT"/file
diff --git a/tests/generic/102.out b/tests/generic/102.out
index fc9275d..b58aa5c 100644
--- a/tests/generic/102.out
+++ b/tests/generic/102.out
@@ -1,21 +1,21 @@
 QA output created by 102
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 419430400/419430400 bytes at offset 0
+wrote 838860800/838860800 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-- 
2.9.5
