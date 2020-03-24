Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1AEC41621
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 03:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0D382074D
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 03:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgCXDog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 23:44:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727060AbgCXDog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 23:44:36 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O3XUTJ010480;
        Mon, 23 Mar 2020 23:44:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywet335g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 23:44:34 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02O3XxQk011598;
        Mon, 23 Mar 2020 23:44:34 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywet335g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 23:44:34 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02O3aDIq030543;
        Tue, 24 Mar 2020 03:44:33 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 2ywawf5fsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 03:44:33 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02O3iXtS45285810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 03:44:33 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A61CB2064;
        Tue, 24 Mar 2020 03:44:33 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ECC2B205F;
        Tue, 24 Mar 2020 03:44:31 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.45.156])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 03:44:31 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandan@linux.ibm.com
Subject: [PATCH] common/xfs: Execute _xfs_check only for block size <= 4k
Date:   Tue, 24 Mar 2020 09:17:29 +0530
Message-Id: <20200324034729.32678-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_10:2020-03-23,2020-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 impostorscore=0
 bulkscore=0 mlxlogscore=271 adultscore=0 spamscore=0 clxscore=1034
 phishscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fsstress when executed as part of some of the tests (e.g. generic/270)
invokes chown() syscall many times by passing random integers as value
for the uid argument. For each such syscall invocation for which there
is no on-disk quota block, xfs invokes xfs_dquot_disk_alloc() which
allocates a new block and instantiates all the quota structures mapped
by the newly allocated block. For a single 64k block, the number of
on-disk quota structures thus created will be 16 times more than that
for a 4k block.

xfs_db's check command (executed after test script finishes execution)
will read in all of the on-disk quota structures into memory. This
causes the OOM event to be triggered when reading from filesystems with
64k block size. For machines with sufficiently large amount of system
memory, this causes the test to execute for a very long time.

Due to the above stated reasons, this commit disables execution of
xfs_db's check command when working on 64k blocksized filesystem.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 common/xfs | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/common/xfs b/common/xfs
index d9a9784f..d65c38d8 100644
--- a/common/xfs
+++ b/common/xfs
@@ -455,10 +455,19 @@ _check_xfs_filesystem()
 		ok=0
 	fi
 
-	# xfs_check runs out of memory on large files, so even providing the test
-	# option (-t) to avoid indexing the free space trees doesn't make it pass on
-	# large filesystems. Avoid it.
-	if [ "$LARGE_SCRATCH_DEV" != yes ]; then
+	dbsize="$($XFS_INFO_PROG "${device}" | grep data.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+
+	# xfs_check runs out of memory,
+	# 1. On large files. So even providing the test option (-t) to
+	# avoid indexing the free space trees doesn't make it pass on
+	# large filesystems.
+	# 2. When checking filesystems with large number of quota
+	# structures. This case happens consistently with 64k blocksize when
+	# creating large number of on-disk quota structures whose quota ids
+	# are spread across a large integer range.
+	#
+	# Hence avoid it in these two cases.
+	if [ $dbsize -le 4096 -a "$LARGE_SCRATCH_DEV" != yes ]; then
 		_xfs_check $extra_log_options $device 2>&1 > $tmp.fs_check
 	fi
 	if [ -s $tmp.fs_check ]; then
-- 
2.19.1

