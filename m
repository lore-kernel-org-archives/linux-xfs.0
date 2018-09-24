Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729106AbeIXVWJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:22:09 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8OFJRjk045623
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:19:28 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mq167c5dh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:19:03 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Sep 2018 09:19:02 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V5 20/20] Fix generic/108 to work with 64k block size
Date: Mon, 24 Sep 2018 20:49:42 +0530
In-Reply-To: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180924151942.8220-21-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

This commit increases the size of the scsi debug device to 300MiB to
accommodate a 275MiB sized XFS filesystem with 64k block size. mkfs.xfs
fails to create a 64k block sized filesystem on devices with capacity
less than 275MiB.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/108 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/108 b/tests/generic/108
index e464335..9b4fe60 100755
--- a/tests/generic/108
+++ b/tests/generic/108
@@ -48,7 +48,7 @@ vgname=vg_$seq
 rm -f $seqres.full
 
 # _get_scsi_debug_dev returns a scsi debug device with 128M in size by default
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev`
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 300`
 if [ "$SCSI_DEBUG_DEV" == "/dev/" ]; then
 	_fail "Failed to initialize scsi debug device"
 fi
@@ -59,7 +59,7 @@ $LVM_PROG pvcreate -f $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
 $LVM_PROG vgcreate -f $vgname $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
 # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
 # (like 2.02.95 in RHEL6) don't support --yes option
-yes | $LVM_PROG lvcreate -i 2 -I 4m -L 100m -n $lvname $vgname \
+yes | $LVM_PROG lvcreate -i 2 -I 4m -L 275m -n $lvname $vgname \
 	>>$seqres.full 2>&1
 # wait for lv creation to fully complete
 $UDEV_SETTLE_PROG >>$seqres.full 2>&1
-- 
2.9.5
