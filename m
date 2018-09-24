Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27621 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730785AbeIXVVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:21:38 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8OFEgrp000683
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:57 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2mq2830paa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:57 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Sep 2018 09:18:56 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V5 18/20] Fix generic/459 to work with 64k block size
Date: Mon, 24 Sep 2018 20:49:40 +0530
In-Reply-To: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180924151942.8220-19-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

With 64k block size, 200MiB disk space is not sufficient to create an
XFS filesystem. Hence this commit increases the size of the
overprovisioned dm-thin device to 300MiB. The commit also increases the
other associated disk sizes (original physical size and new physical
size) appropriately.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/459 | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/generic/459 b/tests/generic/459
index aee71a0..c430952 100755
--- a/tests/generic/459
+++ b/tests/generic/459
@@ -59,14 +59,14 @@ vgname=vg_$seq
 lvname=lv_$seq
 poolname=pool_$seq
 snapname=snap_$seq
-origpsize=100
-virtsize=200
-newpsize=200
+origpsize=200
+virtsize=300
+newpsize=300
 
 # Ensure we have enough disk space
-_scratch_mkfs_sized $((250 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((350 * 1024 * 1024)) >>$seqres.full 2>&1
 
-# Create a 100MB dm-thin POOL
+# Create a 200MB dm-thin POOL
 $LVM_PROG pvcreate -f $SCRATCH_DEV >>$seqres.full 2>&1
 $LVM_PROG vgcreate -f $vgname $SCRATCH_DEV >>$seqres.full 2>&1
 
@@ -74,7 +74,7 @@ $LVM_PROG lvcreate  --thinpool $poolname  --errorwhenfull y \
 		    --zero n -L $origpsize \
 		    --poolmetadatasize 4M $vgname >>$seqres.full 2>&1
 
-# Create a overprovisioned 200MB dm-thin virt. device
+# Create a overprovisioned 300MB dm-thin virt. device
 $LVM_PROG lvcreate  --virtualsize $virtsize \
 		    -T $vgname/$poolname \
 		    -n $lvname >>$seqres.full 2>&1
@@ -92,7 +92,7 @@ _mount /dev/mapper/$vgname-$snapname $SCRATCH_MNT
 
 # Consume all space available in the volume and freeze to ensure everything
 # required to make the fs consistent is flushed to disk.
-$XFS_IO_PROG -f -d -c 'pwrite -b 1m 0 120m' $SCRATCH_MNT/f1 >>$seqres.full 2>&1
+$XFS_IO_PROG -f -d -c 'pwrite -b 1m 0 220m' $SCRATCH_MNT/f1 >>$seqres.full 2>&1
 
 # In XFS, this freeze will never complete until the dm-thin POOL device is
 # extended. It is expected, and is only used so xfsaild is triggered to
-- 
2.9.5
