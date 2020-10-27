Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A8DC4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96FB9206D4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pSFb3jvk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502003AbgJ0TEG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:04:06 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57278 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444462AbgJ0TEG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:04:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItCvp021945;
        Tue, 27 Oct 2020 19:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FcgvApeAFi2x+2hlgEZnzGcD/mrEAiH5VemFqtAvZNA=;
 b=pSFb3jvkPbiHb+LhicQIt+y/SABU6alx7vlwAWNWworZlRawH3a6T9s/oXYNPxQgKUW8
 2deFTGGWni8t4CyQl+QEiGhiNYBHd0VYrFYTfciKbkf3JEfvP80eUsT9ndVokpJ9h047
 WgTLKGYwhnpFT41U2z9cQa4uC6LoU3qWSfWITMjqsT7zlVFJnQgHYwcvPH7q282NQlBV
 FzlbmzybPBf3p1YawVoVfWkOVWJmEmZZqPI+8nir52Rd+KASzN58uG6k6aROVKytf3f4
 mIDiOu8W6q38a8QAPLpfMkelgT6lQBCuWQ+CITcFpjL/CQUAvtP7HPv514ELvq6bz6tz Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9sav0dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:04:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsPA0076525;
        Tue, 27 Oct 2020 19:02:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwumrhsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:02:04 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ23pr023269;
        Tue, 27 Oct 2020 19:02:03 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:02:03 -0700
Subject: [PATCH 5/9] xfs/327: fix inode reflink flag checking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:02:02 -0700
Message-ID: <160382532250.1202316.4733915561999380155.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This is a regression test that tried to make sure that repair correctly
clears the XFS inode reflink flag when it detects files that do not
share any blocks.  However, it does this checking by looking at the
(online) lsattr output.  This worked fine during development when we
exposed the reflink state via the stat ioctls, but that has long since
been removed.  Now the only way to check is via xfs_db, so switch it to
use that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/327     |   18 ++++++++++++++++--
 tests/xfs/327.out |   13 +++++++------
 2 files changed, 23 insertions(+), 8 deletions(-)


diff --git a/tests/xfs/327 b/tests/xfs/327
index 017e2a84..7a14798f 100755
--- a/tests/xfs/327
+++ b/tests/xfs/327
@@ -49,10 +49,21 @@ seq 1 $nr | while read i; do
 done
 sync
 
+ino_0=$(stat -c '%i' $SCRATCH_MNT/file.0)
+ino_64=$(stat -c '%i' $SCRATCH_MNT/file.64)
+ino_128=$(stat -c '%i' $SCRATCH_MNT/file.128)
+
+echo "Check filesystem"
+_scratch_unmount
+_scratch_xfs_db -c "inode $ino_0" -c print \
+	-c "inode $ino_64" -c print \
+	-c "inode $ino_128" -c print | grep reflink | sed -e 's/^v[0-9]*/vX/g'
+_scratch_mount
+
 echo "Check files"
 for i in 0 $((nr / 2)) $nr; do
 	md5sum $SCRATCH_MNT/file.$i | _filter_scratch
-	$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/file.$i | _filter_scratch
+	$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/file.$i >> $seqres.full
 done
 
 echo "CoW all files"
@@ -63,12 +74,15 @@ done
 echo "Repair filesystem"
 _scratch_unmount
 _repair_scratch_fs >> $seqres.full
+_scratch_xfs_db -c "inode $ino_0" -c print \
+	-c "inode $ino_64" -c print \
+	-c "inode $ino_128" -c print | grep reflink | sed -e 's/^v[0-9]*/vX/g'
 _scratch_mount
 
 echo "Check files again"
 for i in 0 $((nr / 2)) $nr; do
 	md5sum $SCRATCH_MNT/file.$i | _filter_scratch
-	$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/file.$i | _filter_scratch
+	$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/file.$i >> $seqres.full
 done
 
 echo "Done"
diff --git a/tests/xfs/327.out b/tests/xfs/327.out
index 5b3cba21..0e204205 100644
--- a/tests/xfs/327.out
+++ b/tests/xfs/327.out
@@ -1,20 +1,21 @@
 QA output created by 327
 Format filesystem
 Create files
+Check filesystem
+vX.reflink = 1
+vX.reflink = 1
+vX.reflink = 1
 Check files
 8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.0
-[] SCRATCH_MNT/file.0 
 8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.64
-[] SCRATCH_MNT/file.64 
 8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.128
-[] SCRATCH_MNT/file.128 
 CoW all files
 Repair filesystem
+vX.reflink = 0
+vX.reflink = 0
+vX.reflink = 0
 Check files again
 8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.0
-[] SCRATCH_MNT/file.0 
 0f17fd72b7bbf5bda0ff433e6d1fc118  SCRATCH_MNT/file.64
-[] SCRATCH_MNT/file.64 
 0f17fd72b7bbf5bda0ff433e6d1fc118  SCRATCH_MNT/file.128
-[] SCRATCH_MNT/file.128 
 Done

