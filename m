Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E74C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbiFFMll (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237517AbiFFMlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:41:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68A5262AC1;
        Mon,  6 Jun 2022 05:41:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256CJIgx006767;
        Mon, 6 Jun 2022 12:41:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=i5xR3HvblMTwQOnZP+WU9E+ANOj4jXHCKWg+PwsBGcQ=;
 b=b/eguF4qmBKmNY/WD8bPuOdo//gD37jVFHKxhl29KgSg+p1bnL4vblzxjng1mIXK5FAU
 8Q5HnznEprT/1UeWetYBKmQwHmoxCQMlgaaEcUt/j9Ds1nrUrNcdV11GgifaPyZ+S1kf
 jxUfpURAkj1dSyBMKq/xBBJRm+eJayxP76Ga5I+EE66npZq3MiWWGeBufmNDo/aUlpP2
 VBiC9VrXjDbqKR3WdezGpv2rmSy/lBF8k1G5MQdgTn91YzSc2ICs01QKpmxTwknBOLrb
 iCBRnh8AabBDsWYetX2iG0PL7eViHTuWVXitYM2EvHT4euoQ+fngguj4/bNkPmKjDDxH hA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxmsdtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 256CeODi014050;
        Mon, 6 Jun 2022 12:41:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu1f0p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hzc3Ef/T5kGEQvPuQ0fK2OpLrZXkRJ36Ycu/FTkZ0Vlo1RTrRccusa6b6LYNKtN0rjIcS3Btb1Z7np0vxJHO7Iy0DsUeUpehL/9oex4A0ZJ26Qx0kNWhQYJROfi72YBBuiVk//dCVQknnPEKShyDp5wYaiUXe7Y21OOBMxU8jeu+A7Heo5lmKUladAvV+EmjDfeRJ9+EAW0IU1+prQv/aGJEe5lKeUW+Spu2BWiPNQ7ff6kiqov+xcK6FZoT6ult7kR31Lkr8J2biCbS/mqdXlsVuFBWMvozjJOAFLudA8+33kayiDAT+qn9HsM/fznP014QuHJ18uEWSjlTqS+iRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5xR3HvblMTwQOnZP+WU9E+ANOj4jXHCKWg+PwsBGcQ=;
 b=kjH3YkMhRGaUeYAxmZAhugwHbwZBSMt/2C1wOV60f0kUU5wjjdicr46Za7KPboAmcGF7FLFTkj4WDBXaeOcSel15eQnQRMm8E9NfzrIdKmlarSR2M+bdUTODFHE/ls9S9XDxuvNZQkP7WlixHe4ch/BO++l4ujrDNhzAgLOXxC++YtVqaO0EWLGSEv5uJBa6F1h8GWD1bNUA+Bf3id75GspMBcTiEIEBLURDAz4sfadZah3wMGbAyY4Ag7PNsbq+ixWcLMJ9K3UtS+Bis9c/RyjsJ179HLWNz1otb1rthFJMIy3Ka2o5FM3UQdgGq5P5PYBoFZ9FSRfBQLazrb/oHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5xR3HvblMTwQOnZP+WU9E+ANOj4jXHCKWg+PwsBGcQ=;
 b=TEo5pVDtE2WHIah2K3AugAcD8+L6MhyOMhG/3BeebHwp1fzj+XQC2B1HQUnqmGLmRf6Ji70yPzaV0oFlFdCfTuOEylQQnyVIv84uGjzaul0L+RrkJ1FZMKCCaim1Q26rR7d0D01lcETkIP17XrviZS/FnrqLz2lo351DJlG3m7E=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO1PR10MB4706.namprd10.prod.outlook.com (2603:10b6:303:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 12:41:31 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 12:41:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs/548: Verify correctness of upgrading an fs to support large extent counters
Date:   Mon,  6 Jun 2022 18:11:01 +0530
Message-Id: <20220606124101.263872-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606124101.263872-1-chandan.babu@oracle.com>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::18)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b89b0561-3f34-4a2d-01c0-08da47b9e1c4
X-MS-TrafficTypeDiagnostic: CO1PR10MB4706:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4706B6FEFCCE801F66759F3AF6A29@CO1PR10MB4706.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C9AdDPrFQzBV4XnWtIEx8xRy7Vkn+0Mznd2nL3D0loo5z3e7zivWITNVP2JZXY5CEYJY0FLhNAojP4xfIoD7ITxyX4AFnMRK7pb1W45lJFoUiO9fDHATz+FHa4hGbS2D8FGiRsWzcPPBfDgTS4khYiyE1skd0T2nPBzrrNO4lQ2ydGvUjPgK0QHhKD3+0kmLw2VOE6HT9C8NnmfgESlyx+9olNFQiiv6kOjHna1wIazX2HlL4R3vtt4Wgezs6SD0PJG1QK32Ry7WfP+ZnyXxZ3G/qKYDvsLTkwDoO+iH67P/waI83uQT7R2odESi+S1lkS9a2qzTBBvaz3nZW4mT2QKQIeV0VzARgCixz/Ve00+X2sFe1J4gHXJst3XRgbdyKyY7b+dEcxsuwSUNmp9N4wOvzwYFdAIK+AfRIy8rvUOmnQY4W5D5U9GK3W0tvv+YOzGG7msZsEuZ/9ph6pHqmzZIfbhMl+05gWt68pWZZizy8G63ppJ0zUPfqVOoLeJJjzw8l4TYOm75CIQ4R2i90TtpOL+ru8/sqVtTvOljWQb3KNHW4Qu7ZyzZ3iEa2uD2Sbf6/2X6lQcjTdNEvPHyz7BfZe/NDHeVc51GP4GON0w1MqaXNuxQbVLbQv01lbTGjyKtQKH4Bx7Pifz6cJUrmEZealID5uhNV328ovy0kXJ7AHWXgqYKNvbNHLflqivwPnWJxywl0EbbkB+bKejlAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(316002)(86362001)(36756003)(2906002)(5660300002)(66946007)(66556008)(66476007)(8936002)(2616005)(15650500001)(26005)(1076003)(186003)(508600001)(6486002)(52116002)(6666004)(6506007)(38100700002)(6512007)(38350700002)(6916009)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wluwUeFwhhOeB7Vrz3Ply/1frj0hdsRYfTBowP5ooCuM3UMVJy6CNNR+LELT?=
 =?us-ascii?Q?VHvqYN8b8PrFA461Z5eKv9iDhBCSbK1vx+owpFp6keR2kzThTehav1oOEa37?=
 =?us-ascii?Q?dpGYH6egwcTD7vdAlN1ZfL0IhWRyadCVDQNVKXWtF+p2AFC6tjxinIuBdQro?=
 =?us-ascii?Q?pvF+GTRpwmkhLNFBsP3d94grcjx0M+522zMSK/KA21amjFv7nRTZlvpibrO8?=
 =?us-ascii?Q?vFCYFMDKx9NlKByiYUF4GzzN9z1iWHyl640okolm5WL8sYnPUuSfcAGd5o/N?=
 =?us-ascii?Q?Yxt+GEHfL1rLEo7aHuqMKsgIthewAg8hgh5a1Kz/Q6Aj35d/ATD0bNtqRgiq?=
 =?us-ascii?Q?NCnqPTMKzIuNkEF2zg3O2fo02/14jZ1JTl9XedOv/PxDi7tcCaKIw8sNxFYd?=
 =?us-ascii?Q?ULbl+bFiOEWKjchTQ3CG9LejE0XpnOtrQ+W7CpOBvxUvx5HCSWlJI8yqCehp?=
 =?us-ascii?Q?L2DNI9GZKo1z/4WKWx6AYp4lUvcLyAa0EXOP6z0g32ZvhpzwFzOl3uXOSI4K?=
 =?us-ascii?Q?U3foYNN5Y1Anj0z/sY94YvFhdkg8s8rdUAG5xlIW63rifC6gXbAT6aQuZuic?=
 =?us-ascii?Q?yFq+D6WsaOI1F2JtmuHatIHrmMD64Mp2O8pl1m7Jjyauvn88Vk0HAXVzDMS+?=
 =?us-ascii?Q?Po8kU1ZJS6btBbkuAw+or4tExs5nNJ0iK2hn6USA6twMEkW0rRnpG/abP2Ha?=
 =?us-ascii?Q?pS1BzjUCd5Ykw7br0Z+KmKjG+yIFhToHzvgq4lAKL6vheW/B1jXDdTX737fC?=
 =?us-ascii?Q?E2aiRrIM3q+7MJz0I9QqqMe7JSqzxaVkK3ROrrv9mhU8sGLdhKIE3/yC7Zu5?=
 =?us-ascii?Q?7nKFV9P5f6vMcmgTDQRwiJ+ysmodVAF5SvEzMIS0e9ZHxhj33IFBHSvYRXni?=
 =?us-ascii?Q?6GvwOrZObH0/RUnDTnVyNeSU3Gj3GKngnjPUQx95eA/jxRsQaM/1CSC8eE59?=
 =?us-ascii?Q?OJnKcTOeXqcxVm/BdJYYEWVzj/x+5HZf9xoIgQjtYDiRQ1wJYhDECFiSEP8D?=
 =?us-ascii?Q?ODaIE7DBgPBRspnX2mNmvNNgSFuBCbn6sbZO6IfWH1SqQH8KGSfI1RqslSvU?=
 =?us-ascii?Q?JOahwpw7u5kkRvIqAvggYBn0ls4m/n+XegKVTBHQnjzTH/+U/PVRQHBJL39g?=
 =?us-ascii?Q?/7GKlq1PWeFL1fMNV5Pb4Hq7Cr3r2YXG1m2JVdd+x+v8BYS9YaveW6adAc1u?=
 =?us-ascii?Q?7qmRmrEwf2VSEaO04LSH9963cEhdGiwWB7UqYshf0dkCE0FG7TagseHJiabE?=
 =?us-ascii?Q?fg9xIaZ5SMLE1wPMVM2EW80M37KYtYCcPQjfeN7RzFWQQm/MR6vZmNDJ2auE?=
 =?us-ascii?Q?/xaZPk0Iz+KqXVHflklz6Rm06YLrfMxsWYgvAHTic5j2xUEYcO/j1wHbs3qv?=
 =?us-ascii?Q?TOtMJhK3gvMSdfi83AHOAokB9z0QJDvYwlvI3GK5NM25OZ8sZDyk2NLCeMYD?=
 =?us-ascii?Q?iGHdXS6pm/32JrIQBuoeM/kyM2N2UTqqYqxdbpt+QLOZRXAB9t/rvtqniTYb?=
 =?us-ascii?Q?YS+UVUO96wyhq1r5hr+BgvhICF+oZ0lXFqzggCPJjTP6LGTXsCZUvgHTEyMp?=
 =?us-ascii?Q?X7rIUgo9ZS5SJVLzGejkbM2YbNVnDTVB6putPSvxI9r7OxhIGTMraYw8li48?=
 =?us-ascii?Q?C/gnMtSiedJRsbbovK/oRAMltwY73aiZhratRrQgq3SR2Pr80txpu1XAIhoh?=
 =?us-ascii?Q?U2z5d6Z7Iiby2v2z29lUDNIIRWcmTqhD9QAhi65M4JllnAE0t4AAixrfFbt+?=
 =?us-ascii?Q?UQr13VBJfF7fasREJdMuoXOaQjmLILA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89b0561-3f34-4a2d-01c0-08da47b9e1c4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 12:41:31.1255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixx5cYQYZg5ZhI44e4IJZVvZVBdXI9VtWY5LTHAKUCftyrj/Hc/3ivikjhHCI7+fqf72vzElmmHIqZ0NQJzohw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4706
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060058
X-Proofpoint-GUID: KacFECck7cWh2ASaqsTJ9FOBgQwZmskT
X-Proofpoint-ORIG-GUID: KacFECck7cWh2ASaqsTJ9FOBgQwZmskT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a test to verify upgrade of an existing V5 filesystem to
support large extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/548     | 109 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/548.out |  12 +++++
 2 files changed, 121 insertions(+)
 create mode 100755 tests/xfs/548
 create mode 100644 tests/xfs/548.out

diff --git a/tests/xfs/548 b/tests/xfs/548
new file mode 100755
index 00000000..6c577584
--- /dev/null
+++ b/tests/xfs/548
@@ -0,0 +1,109 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 548
+#
+# Test to verify upgrade of an existing V5 filesystem to support large extent
+# counters.
+#
+. ./common/preamble
+_begin_fstest auto quick metadata
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/inject
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_scratch_xfs_nrext64
+_require_attrs
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+_scratch_mkfs -d size=$((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+testfile=$SCRATCH_MNT/testfile
+
+nr_blks=20
+
+echo "Add blocks to file's data fork"
+$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
+	     >> $seqres.full
+$here/src/punch-alternating $testfile
+
+echo "Consume free space"
+fillerdir=$SCRATCH_MNT/fillerdir
+nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
+nr_free_blks=$((nr_free_blks * 90 / 100))
+
+_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
+	 >> $seqres.full 2>&1
+
+echo "Create fragmented filesystem"
+for dentry in $(ls -1 $fillerdir/); do
+	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
+done
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+echo "Add blocks to file's attr fork"
+nr_blks=10
+attr_len=255
+nr_attrs=$((nr_blks * bsize / attr_len))
+for i in $(seq 1 $nr_attrs); do
+	attr="$(printf "trusted.%0247d" $i)"
+	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+testino=$(stat -c '%i' $testfile)
+
+echo "Unmount filesystem"
+_scratch_unmount >> $seqres.full
+
+orig_dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
+orig_acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
+
+echo "Upgrade filesystem to support large extent counters"
+_scratch_xfs_admin -O nrext64=1 >> $seqres.full 2>&1
+if [[ $? != 0 ]]; then
+	_notrun "Filesystem geometry is not suitable for upgrading"
+fi
+
+
+echo "Mount filesystem"
+_scratch_mount >> $seqres.full
+
+echo "Modify inode core"
+touch $testfile
+
+echo "Unmount filesystem"
+_scratch_unmount >> $seqres.full
+
+dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
+acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
+
+echo "Verify inode extent counter values after fs upgrade"
+
+if [[ $orig_dcnt != $dcnt ]]; then
+	echo "Corrupt data extent counter"
+	exit 1
+fi
+
+if [[ $orig_acnt != $acnt ]]; then
+	echo "Corrupt attr extent counter"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/548.out b/tests/xfs/548.out
new file mode 100644
index 00000000..19a7f907
--- /dev/null
+++ b/tests/xfs/548.out
@@ -0,0 +1,12 @@
+QA output created by 548
+Add blocks to file's data fork
+Consume free space
+Create fragmented filesystem
+Inject bmap_alloc_minlen_extent error tag
+Add blocks to file's attr fork
+Unmount filesystem
+Upgrade filesystem to support large extent counters
+Mount filesystem
+Modify inode core
+Unmount filesystem
+Verify inode extent counter values after fs upgrade
-- 
2.35.1

