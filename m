Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46501 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729102AbeIXVVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:21:15 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8OFEZVs108113
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:35 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mq20j1g0f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:34 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Sep 2018 09:18:33 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V5 12/20] Fix generic/102 to work with 64k block size
Date: Mon, 24 Sep 2018 20:49:34 +0530
In-Reply-To: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180924151942.8220-13-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

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
