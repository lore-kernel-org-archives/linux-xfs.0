Return-Path: <SRS0=hGtO=5P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA23DC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Mar 2020 10:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A39CA206E6
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Mar 2020 10:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgC3KJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Mar 2020 06:09:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728257AbgC3KJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Mar 2020 06:09:19 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02UA2xT0085379;
        Mon, 30 Mar 2020 06:09:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3021vte0ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 06:09:10 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02UA3DfI086977;
        Mon, 30 Mar 2020 06:09:09 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3021vte0c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 06:09:09 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02UA5N6l031184;
        Mon, 30 Mar 2020 10:09:09 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 301x763sg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 10:09:08 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02UA97Je60555604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 10:09:07 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5AB76E04C;
        Mon, 30 Mar 2020 10:09:07 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA2226E050;
        Mon, 30 Mar 2020 10:09:04 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.44.125])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 10:09:04 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, chandan@linux.ibm.com,
        hch@infradead.org, linux-xfs@vger.kernel.org
Subject: [PATCH] common/xfs: Execute _xfs_check only when explicitly asked
Date:   Mon, 30 Mar 2020 15:42:03 +0530
Message-Id: <20200330101203.12049-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=253 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1034 impostorscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300091
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fsstress when executed as part of some of the tests (e.g. generic/270)
invokes chown() syscall many times by passing random integers as value
for the uid argument. For each such syscall invocation for which there
is no on-disk quota block, xfs invokes xfs_dquot_disk_alloc() which
allocates a new block and instantiates all the quota structures mapped
by the newly allocated block. For filesystems with 64k block size, the
number of on-disk quota structures created will be 16 times more than
that for a filesystem with 4k block size.

xfs_db's check command (executed after test script finishes execution)
will try to read in all of the on-disk quota structures into
memory. This causes the OOM event to be triggered when reading from
filesystems with 64k block size. For filesystems with sufficiently large
amount of system memory, this causes the test to execute for a very long
time.

Due to the above stated reasons, this commit disables execution of
xfs_db's check command unless explictly asked by the user by setting
$EXECUTE_XFS_DB_CHECK variable.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 README     |  2 ++
 common/xfs | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/README b/README
index 094a7742..c47569cd 100644
--- a/README
+++ b/README
@@ -88,6 +88,8 @@ Preparing system for tests:
                run xfs_repair -n to check the filesystem; xfs_repair to rebuild
                metadata indexes; and xfs_repair -n (a third time) to check the
                results of the rebuilding.
+	     - set EXECUTE_XFS_DB_CHECK=1 to have _check_xfs_filesystem
+               run xfs_db's check command on the filesystem.
              - xfs_scrub, if present, will always check the test and scratch
                filesystems if they are still online at the end of the test.
                It is no longer necessary to set TEST_XFS_SCRUB.
diff --git a/common/xfs b/common/xfs
index d9a9784f..93ebab75 100644
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
+	# Hence avoid executing it unless explicitly asked by user.
+	if [ -n "$EXECUTE_XFS_DB_CHECK" -a "$LARGE_SCRATCH_DEV" != yes ]; then
 		_xfs_check $extra_log_options $device 2>&1 > $tmp.fs_check
 	fi
 	if [ -s $tmp.fs_check ]; then
-- 
2.19.1

