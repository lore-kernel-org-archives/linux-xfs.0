Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36053 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750748AbdIEFoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 01:44:05 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v855i5h7142992
        for <linux-xfs@vger.kernel.org>; Tue, 5 Sep 2017 01:44:05 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cs9f2e75d-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2017 01:44:05 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 5 Sep 2017 01:44:01 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] mkfs: Remove messages printed when blocksize < physical sectorsize
Date: Tue,  5 Sep 2017 11:14:42 +0530
Message-Id: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, sandeen@sandeen.net
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
physical sector size of loop devices. On ppc64, this causes loop devices
to have 64k as the physical sector size.

With these changes, mkfs.xfs now prints error messages when filesystem
blocksize (4k) is less than underlying device's physical
sectorsize (64k). These messages (printed on stderr) now cause several
xfstests to fail on ppc64 machine since xfstests' _filter_mkfs() isn't
able to filter out stderr.

Also, the messages themselves describe a possible sub-optimal setup. But
the setup is still usable.

Hence this commit removes the calls to fprintf() used to print the
messages.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 mkfs/xfs_mkfs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dfffae7..0bb3897 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2011,12 +2011,6 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 					      XFS_MIN_SECTORSIZE;
 
 		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
-			fprintf(stderr,
-_("specified blocksize %d is less than device physical sector size %d\n"),
-				blocksize, ft.psectorsize);
-			fprintf(stderr,
-_("switching to logical sector size %d\n"),
-				ft.lsectorsize);
 			sectorsize = ft.lsectorsize ? ft.lsectorsize :
 						      XFS_MIN_SECTORSIZE;
 		}
-- 
2.9.5

