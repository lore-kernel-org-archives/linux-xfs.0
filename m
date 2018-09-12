Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbeILL1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 07:27:21 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8C6JhYG043108
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:21 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2meqxw2wcm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:21 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Sep 2018 02:24:20 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3 02/19] xfs/050: Fix "Push past soft inode limit" case
Date: Wed, 12 Sep 2018 11:56:09 +0530
In-Reply-To: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180912062626.14349-3-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

The test sets an inode soft limit of four but only three files are
created. This commit creates two more files in order to really push past
the soft inode limit.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/050     |  2 ++
 tests/xfs/050.out | 36 ++++++++++++++++++------------------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/tests/xfs/050 b/tests/xfs/050
index dd77971..8569c2c 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -143,6 +143,8 @@ _exercise()
 	echo "*** push past the soft inode limit" | tee -a $seqres.full
 	_file_as_id $SCRATCH_MNT/softie1 $id $type 1024 0
 	_file_as_id $SCRATCH_MNT/softie2 $id $type 1024 0
+	_file_as_id $SCRATCH_MNT/softie3 $id $type 1024 0
+	_file_as_id $SCRATCH_MNT/softie4 $id $type 1024 0
 	_qmount
 	xfs_quota -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
diff --git a/tests/xfs/050.out b/tests/xfs/050.out
index 5cb4a10..ff9eb1c 100644
--- a/tests/xfs/050.out
+++ b/tests/xfs/050.out
@@ -16,11 +16,11 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
@@ -48,11 +48,11 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
@@ -80,19 +80,19 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** unmount
 *** gqnoenforce
@@ -112,19 +112,19 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** unmount
 *** pquota
@@ -144,11 +144,11 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
@@ -176,18 +176,18 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** unmount
-- 
2.9.5
