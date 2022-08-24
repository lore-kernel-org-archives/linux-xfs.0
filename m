Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D61C32796
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Aug 2022 09:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiHXJcM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Aug 2022 05:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbiHXJbw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Aug 2022 05:31:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5197A956B9;
        Wed, 24 Aug 2022 02:31:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27O7uREO024822;
        Wed, 24 Aug 2022 09:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=qATF6Py0m8kccRavC04c3YevHot6dYTD7SD51i3DAuE=;
 b=K/GzeyiWWj51mrQSTV+6jPWL9Jxqt5JPM7EjKkYkoa5j5do0p94hm7yabYKDGGZBLrWP
 UQ73m8HVAdslJ2DiFueQam2+L5nnsKSUqn4reTZvlPEIW+aUhsp+H394f2DO1VkmRJfM
 ypRFAVEfedKnHkSknxA3Z3C3RiIR7dSPTC8p/zZqFavUxo7izSUeB/YZXYXFR5wCENWa
 ZiUKq2v8c8K7j4N99S1L+lJnEmWEBln4MRrqOkS5aoMsTf6ajpIwuUUM9WfiTCSO9nFR
 XDKUjRIk+08FIlq2gCJ60bVXYAk6EMfZlDElwosYuFJP41KW6bXPwpztkyxYFBaoojrv Ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4w23tyab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 09:31:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27O6jLbK015266;
        Wed, 24 Aug 2022 09:31:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mn65uee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 09:31:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGk+HjPre5Ik59il73o0CwyPsvu8lsKimmDwvZDM9UWFATsSHFIcKTnJSwU6KfcuDZ4K8Rawe4O58WfwOlmMf52u+c41iwGYOnhE6MJJdAyo8kRgTyhy0opzk8t2OEdaIKoKdAqMPwQMWB5pqkD6wy2SYOA6/FaTiroxF8VWqegJc9ISM91KWG5oNNLkFQuQrdv/J0B2YDD2UbDz8Tcf08TqaGaw4ApMPKy/6WXvLkwpyHXcVvUQ092/LXKrvHAdomXRiohmZxzqqLf3CpQ7zo9TjtHfL6P9WPxAWwcrXVfl2JzHJLTiB2OeeEpRacYqyRA2PJwv1lLWDH5jsJVwHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qATF6Py0m8kccRavC04c3YevHot6dYTD7SD51i3DAuE=;
 b=SBlDSdSHUf7xLIe7fhwQGHM0kLnmReh2/A3D46WyY9JQrYIpe08MYjOQlyDu4II6rtjjTudlGFOu7IXqWSqjDv9GsLQoMiTbynDReNucM13uDCUX/YjZV6GspAQ2dInb5xtWwW1TsKgfDTZzDLGnmhLBPtfGuZ+9YQv0OlqnTEjpfPYkjkXIWJgAAsFYKjlvFAdDxXwjpE6ZdcFmUOQ0GUJJE6S9z/C6DXi8Ww0kPw88cbS64jK4pGth2KnkTu7LP2XPLsq3pE5XIH5kyTCiM9WhfLAlPF03mXNxA3EBNT90ue/v6+jZPHmEz79NuSKTynYxDje3t5VWn8q58Q7G6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qATF6Py0m8kccRavC04c3YevHot6dYTD7SD51i3DAuE=;
 b=bIvC56fP7uj0fKTHvRLqAvo6Pf/ochMVP1rTWra0Jle9011++5G6DThLrBfUvgtAi4H0oUuoKnnoQfA76wvSVzatHv0RPV7Dk1I3uJ6FbkfT1uwxLNmIi/MYHl34RODcMskvSVoD1pNTyB3IFP98MR+myahBcAKhhSNxtGy/rnk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB2459.namprd10.prod.outlook.com (2603:10b6:5:af::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Wed, 24 Aug
 2022 09:31:30 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc%7]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 09:31:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V2] xfs: Check if a direct write can result in a false ENOSPC error
Date:   Wed, 24 Aug 2022 15:00:57 +0530
Message-Id: <20220824093057.197585-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0134.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 312363d9-3e1a-4742-d694-08da85b36bab
X-MS-TrafficTypeDiagnostic: DM6PR10MB2459:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmm9DdjYF7nTQiNCc7uW68GA5g7BCx/otPB3BXEvYoq5nqovxOBeZeidtLj9v8Q9IwPuajld7PVzaYXGDyGl1SOuWTnvGnqBSuTphu2fn4jGtTU+BxaAZVqnN5Hxg8a2qGtklFZx9mf7qfmb2Isrwrwm5a1TaZp7Y18BSTHt+jJuIgtFT3MwMfhSVZkfirOF42o86UNk4sFu1iUCCpLokBgdv9KdA7Z6u48pXE7sT4zynH/cVQgEx4K+eU7kIaLSsd/zU0vm0Cu79fjlU3HEuPniyXDx2xEUBtKkBDgh2GPfhoK68OK5iImqE6lqXI8Z8jo9xA8ktux2ySXygB5ZTteJuuNALyMC+mfEJDc6fFTaiWEWUvOUnKbdTb04HyJiGuwY2iFLvbQMEVFY4+qLzibxOI6gh9UHl28kls3H3priPD8Si3aR4T3t/E/FR6FZR8o8Kt3Zy5nUeQCnFk2Ky5O8asI7LyA6PB9VhqHkQOyoNDrnHTFx9H8GieeAY/QJDiyUar2vKpDdwWoo16oyLHvBApTQktDVQlLz+qRpay5xbVj1qchA/qydN4jhFCKuVd5fze/sxXCoqtmmYthwLvRkgfh+TPW86eEbnI9xvNKbLMciEdZ4cnKExcw36sVHTcgUyx3wSjyzRQDmCi7JoZ6UdUOyi3CvUSSUGo8epNkHH05I6y6bIpYyMcjmKDCCR88glx75H5ivdyN/a9YimhZtqGL9uVElv9ZAuJFsVXjsozuLa7MaP7lGJUaSB1W0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(136003)(376002)(346002)(396003)(6486002)(1076003)(478600001)(83380400001)(41300700001)(2906002)(38100700002)(36756003)(38350700002)(8936002)(66556008)(4326008)(8676002)(66476007)(186003)(26005)(66946007)(6916009)(6666004)(52116002)(6506007)(316002)(86362001)(5660300002)(6512007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ab9UMoMaqooFlIECqTc8WAHG4u65pPokln369lHzQxv2OiUWk123ii/2AzeC?=
 =?us-ascii?Q?oglxHZe/g6OQtuCc8YWQrVN5kgXBkeECu9GOw1j6DqiBbGNNFyXNJuQpeSVP?=
 =?us-ascii?Q?LqS278Uze+QOFdotfB4Ld7+pu81jSN0ourLToqtN6JyyPyDZZ9cobP7CKYFB?=
 =?us-ascii?Q?fokSLH/SLNjp8QZt3UdkE5dj0iqXQPyudM900uHA0rZ/bnfBzVxpEX+ix6gh?=
 =?us-ascii?Q?WL+sgK8r0jyvLWzLX+S7noJ9SQHPzN7u7V4HD7NxnOVBPUacNrKqQT2BZ3VQ?=
 =?us-ascii?Q?a55Zc3jqHCKdbdY0anSXTR7AS36JNDZsG0YmfhaS8afIuvS3rgzqL63rWiVZ?=
 =?us-ascii?Q?ZrrQJTuibnfKqGjIi20RedbJI4efPIfP6XIi4w/5D9n9VSmiNihrTqKhVsBP?=
 =?us-ascii?Q?431losQ2qq5obJqoGEutR9s2wKAa5xD7RgewfPKdGxGi79VKQFFNnWgxZwU9?=
 =?us-ascii?Q?fyG7xJbp9zScI/45AIzLvJWCEuDl4NGbBe7U0yIfpKN31FZewzxLck03Hsgb?=
 =?us-ascii?Q?aEiAvcYZ7XZRhhny6gwA1CtThk+MFDrkGXU4f7OXqs1/ofl+oUBm1/H5MrKl?=
 =?us-ascii?Q?QnFGON8PG5zOddwNrcdDf/KnOVQuAqRb/SSKIuny0oycOiVGAyLroS0kIc/M?=
 =?us-ascii?Q?5v9E9owzvV2kvxvqw9VkhNKNxdU0Fv2PMuiX4zUHAkkD++kgWPJBjhFYAFT9?=
 =?us-ascii?Q?0F1toT+bx+58KiQWZXDfc0SV8fE/2bkyPfL6mD8YbOL7bHMjbgm/Cuws7YTV?=
 =?us-ascii?Q?Pz67BLCuXHxdsbn56wppH8cZPwKHJ/eqTf0w+eD+BNQr8Nd8kXAc1sjxRrem?=
 =?us-ascii?Q?Yjg7rSdcC4iOCyXfZjRQXsdjecmXDK0lTX5t3HiSji/FSFEessNvwpTszfUy?=
 =?us-ascii?Q?6gSgWL0V2r97Dnh/fhMH5VXogWil5xcGpl5lGnrpKq96HHWAc+7/SB7c85e9?=
 =?us-ascii?Q?lc/zmhoUvDEL2fzrrh+1BrptMutxMA+077F/WnlS8EFmBb+cjGAE499ztnps?=
 =?us-ascii?Q?Ywgc4cQBedXCdFdfXheptEYxdzqmaFI+spJsBvvAg68P9il/Nv/afSfdNztO?=
 =?us-ascii?Q?83tY6j6Nl7LwzbILPeJbyxhJu0dODlLcUrWHMMeyjq/j8iVW8Jc4Ah769g2+?=
 =?us-ascii?Q?uTe0/M+Tt8Yl5unO1hWE+tjxMR7p4/nradPWb+udGxbP+lgNjyxvlfbrnaYh?=
 =?us-ascii?Q?l6XFXhoai0gtQaUjW5anGUOwvBHDux7txviMBhTlp+ahGOX/q9/UIk9f0bSx?=
 =?us-ascii?Q?kPTJ9re9GqJKvPF3a0CT2hbviAj9pn/RBijJ+/KrogV2KRKAdcvcbj9Auaa4?=
 =?us-ascii?Q?oOqNImxUB7mvMv9tLy7I7v0SglkwxE7PcM6rTHgYm2/bMdFHOb9CbhhBCXax?=
 =?us-ascii?Q?AJFV8uHHL2z+B8zBuSKFkB/b96I0SOIZfrCpfBjtchwrk+tSFZcUQTkSTE60?=
 =?us-ascii?Q?2Ay+20+bwfwFrcvhoYotxqRWTilW31Oxh7vJoBQAQ1uenYsj+k/hCNTRnwp6?=
 =?us-ascii?Q?/PmZepxXJmjr8A+qvdM6zGrykLNDZQOLNHdGc2DKkczZG8Q0GNBcQzE3s+7Z?=
 =?us-ascii?Q?z+a9ervc3AADbUBD5JN80AveqvPwOGSl/pCUb6kb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312363d9-3e1a-4742-d694-08da85b36bab
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 09:31:30.2616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZ/fBt67BD7zjorUAK4Z+iS4V0co29ake8vElxtBo3W6ml0LOsyrb2gRY8NP5kdEY/t5FprMuPd2BfgxYfGNbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208240035
X-Proofpoint-ORIG-GUID: Nv8aqGUEno3q4-4BDQt4BixImHgQ7dQO
X-Proofpoint-GUID: Nv8aqGUEno3q4-4BDQt4BixImHgQ7dQO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a test to check if a direct write on a delalloc extent
present in CoW fork can result in a false ENOSPC error. The bug has been fixed
by upstream commit d62113303d691 ("xfs: Fix false ENOSPC when performing
direct write on a delalloc extent in cow fork").

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
Changelog:
V1 -> V2:
  1. Use file blocks as units instead of bytes to specify file offsets.

 tests/xfs/553     | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/553.out |  9 +++++++
 2 files changed, 74 insertions(+)
 create mode 100755 tests/xfs/553
 create mode 100644 tests/xfs/553.out

diff --git a/tests/xfs/553 b/tests/xfs/553
new file mode 100755
index 00000000..ae52e9fc
--- /dev/null
+++ b/tests/xfs/553
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 553
+#
+# Test to check if a direct write on a delalloc extent present in CoW fork can
+# result in an ENOSPC error.
+#
+. ./common/preamble
+_begin_fstest auto quick clone
+
+# Import common functions.
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_fixed_by_kernel_commit d62113303d691 \
+	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
+_require_scratch_reflink
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "cowextsize"
+
+source=${SCRATCH_MNT}/source
+destination=${SCRATCH_MNT}/destination
+fragmented_file=${SCRATCH_MNT}/fragmented_file
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+
+echo "Create source file"
+$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 8192))" $source >> $seqres.full
+
+echo "Reflink destination file with source file"
+$XFS_IO_PROG -f -c "reflink $source" $destination >> $seqres.full
+
+echo "Set destination file's cowextsize to 4096 blocks"
+$XFS_IO_PROG -c "cowextsize $((blksz * 4096))" $destination >> $seqres.full
+
+echo "Fragment FS"
+$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 16384))" $fragmented_file >> $seqres.full
+sync
+$here/src/punch-alternating $fragmented_file >> $seqres.full
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+echo "Create delalloc extent of length 4096 blocks in destination file's CoW fork"
+$XFS_IO_PROG -c "pwrite 0 $blksz" $destination >> $seqres.full
+
+sync
+
+echo "Direct I/O write at 3rd block in destination file"
+$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $destination >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/553.out b/tests/xfs/553.out
new file mode 100644
index 00000000..9f5679de
--- /dev/null
+++ b/tests/xfs/553.out
@@ -0,0 +1,9 @@
+QA output created by 553
+Format and mount fs
+Create source file
+Reflink destination file with source file
+Set destination file's cowextsize to 4096 blocks
+Fragment FS
+Inject bmap_alloc_minlen_extent error tag
+Create delalloc extent of length 4096 blocks in destination file's CoW fork
+Direct I/O write at 3rd block in destination file
-- 
2.35.1

