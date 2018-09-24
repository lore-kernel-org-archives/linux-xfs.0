Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728527AbeIXVUz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:20:55 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8OFEuqV018015
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:14 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mq1fmk1we-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:14 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Sep 2018 09:18:13 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V5 08/20] Fix xfs/190 to work with 64k block size
Date: Mon, 24 Sep 2018 20:49:30 +0530
In-Reply-To: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180924151942.8220-9-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

This commit describes "file hole" ranges in multiples of block sizes
rather than using constants.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/190 | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tests/xfs/190 b/tests/xfs/190
index 3275e29..13300ac 100755
--- a/tests/xfs/190
+++ b/tests/xfs/190
@@ -10,13 +10,6 @@
 #
 # PV 985792
 #
-#This is the list of holes to punch in the file limited to $filesize
-#NOTE holes cannot overlap or this script will fail.
-holes="4096:4096 303104:4096 1048576:512 1051648:8192 1065984:8192 1085440:7168"
-#filesize in MB
-filesize=10
-#Name of file to perform the test on
-filename=test-190
 
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -38,9 +31,24 @@ _supported_os Linux
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
-fsblocksize=`$XFS_INFO_PROG $SCRATCH_MNT|sed 's/=/ /g'|awk '/^data / { print $3 }'`
 
-dd if=/dev/zero of=$SCRATCH_MNT/$filename bs=1024k count=10 >> $seqres.full 2>&1
+fsblocksize=$(_get_file_block_size $SCRATCH_MNT)
+
+#This is the list of holes to punch in the file limited to $filesize
+#NOTE holes cannot overlap or this script will fail.
+holes="$fsblocksize:$fsblocksize \
+$(($fsblocksize * 74)):$fsblocksize \
+$(($fsblocksize * 256)):$(($fsblocksize / 8)) \
+$(echo scale=0\;$fsblocksize \* 256 \+ $fsblocksize \* 3 \/ 4 | bc):$(($fsblocksize * 2)) \
+$(echo scale=0\;$fsblocksize \* 260 \+ $fsblocksize \* 1 \/ 4 | bc):$(($fsblocksize * 2)) \
+$(($fsblocksize * 265)):$(echo scale=0\;$fsblocksize \+ $fsblocksize \* 3 \/ 4 | bc)"
+
+#filesize
+filesize=$(($fsblocksize * 2560))
+#Name of file to perform the test on
+filename=test-190
+
+$XFS_IO_PROG -f -c "pwrite 0 $(($fsblocksize * 2560))" $SCRATCH_MNT/$filename >> $seqres.full 2>&1
 
 # run DMAPI test using verbose output
 echo Punching holes in file
-- 
2.9.5
