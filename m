Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E53C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Aug 2022 13:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242054AbiHYNBV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Aug 2022 09:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242057AbiHYNBT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Aug 2022 09:01:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEA22B1BB;
        Thu, 25 Aug 2022 06:01:17 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PCkWQc022445;
        Thu, 25 Aug 2022 13:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=OUYi3DtBTxqEJ59jSgDbH49l5xrIRtGST3I/xTidCX0=;
 b=t72xqSuKClQPmzFVJnMDk9TVQv2jgK+0L9qdqG1pJwM8dDhPYbiI2E0GUNWYw6e9k67H
 fGye6ANKYoB0ef6cDkX9GACkad443+GBUQFjuTMkaMFunp9SZBTRF84uMKNtjT1kXOSM
 BfddCjTZxnDHbB21ThsW3QU9AjnIKwN/R1VWVh399dqS/19VnRJJLUXN+4r0rgBnvQ0B
 iPCNTSTwq3ny/jsA6z8nKSJrjJRpS1TaMzHT3IYyYtu+IevAR7TnURn43ztDmfMb4Rpp
 Wn1xG5/GCV3Np1bTWGA9NHuqFlg8DChov4NC6O2KhvsVsOaljGEGINpaiJlcXuXM3SY2 MQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j5aww41sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:01:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27PA47EX011171;
        Thu, 25 Aug 2022 13:01:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n6mt8ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:01:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sfc/4mp75j42EBKQJxBCIVcPeVCXsz4cebmXEOwffhdciGM3ulh5XXQyuqwaGmdHLqmxZa71CIzu7ns52v2iQToGsGkojempegp013Y+6CLpZ8z+rMRVBQpAVghF6PicW/B7V9wp3OK1zv2cf4F2rS01+63uZO4IFCnUsx4oDoijFCTTum4radHbFzGZgTzQZg6ZdTmskkZPsG9gBOjYp9bL1SyjV2CsRpSdqsqdaRyHj6SsP/lZh4WwyycF3FgGTBFyg8YWIQpDMhj9VBGs8KSAwm0lNZT1BctQld7jdjR4H3OKEJcKzBxzsy9EiV7yHtsmBTgO2NspLlsM8E3ZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUYi3DtBTxqEJ59jSgDbH49l5xrIRtGST3I/xTidCX0=;
 b=dFJqZdQTZ8GEBW91v5diS9xcgWEa0+BILJNI5doY0/oS100L071O2uV/hmL/iCv18n2uZbUN8bayFsLwXYUE0zbGLAcznPgkMnwm+01FN0TeZ1OIe322wYuMYaIE5/KYg8tOwGkQn6JpezC0KiBk+nf/4HCi4pq0pHShD3+HjQwBRYJ3MpTFd3ndO4IjBTbREIJ9616xI+sZa9zeCzRiaIQC9OE5mKiOTqqyJyLBtqX2jdzrnT8H+7GnAw+eSvbS+KRhHH2aQF7/ANeljeKhdWwAJbPzhWu2L/uMx3tAIZuvyVl1dd6jmhv1wlDTJOgefmehRoVZ0PNIa9az2C3GMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUYi3DtBTxqEJ59jSgDbH49l5xrIRtGST3I/xTidCX0=;
 b=sL0hb/Fm810uOCIJXApJIowZvuaHkfMm/LN5cB+iimFpmXaBvlZq6r6N+RqftTR1E6dNVOK2QAG2VyrXtPJyirVVJATQ4I/U490Qc7V7WjGqy98D98nA4SpZvmYZ+Nt9qUsWq4VsowcYkLBLaCzg60mdTKCYjn/cp6Jbxs1xINU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH7PR10MB6274.namprd10.prod.outlook.com (2603:10b6:510:212::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 13:01:01 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc%7]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 13:01:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V3] xfs: Check if a direct write can result in a false ENOSPC error
Date:   Thu, 25 Aug 2022 18:30:41 +0530
Message-Id: <20220825130042.1707017-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0085.apcprd03.prod.outlook.com
 (2603:1096:4:7c::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dea7852-1dea-4e58-8d96-08da8699dc15
X-MS-TrafficTypeDiagnostic: PH7PR10MB6274:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VMJA202iHfVkAE8o6zC/Hr/giH5liQHrchlowLXbV/bVzOUQNOZrjHbDBzkQ4+ose051HxXM1CIfyVeEvo2h4/wytnUsJrSOk4A79OjdM5eiS3dj1WEewcy8LohwxEf2rLE6ydaFK7exoATsfVj5OwXeNaUH7jXJypfahMiCIiglfZ0aV05STqVtm7fXXc4RD0bp1SgDjqa/P3mEcpNs/Bd32SsAE3rCPlqsA82DAn1+2ExclKLgFxR4pIpVV8PtRmKwBEU/eBz2PkYLThn6AYjU+dOzQqkR7PZuU4Gx4N/3Wu/jSEifzxpNilVPGKqyzqME4n7RnW+10QrG5QHrm1U/cDFFrriJG13+R4b0OGQ4CHMckDNI3L76SNd5TGjD2wkusJUr4AyQ//AbWWc89kYhLwJXXmh9hENE9D08sFbjMFf6GlbshORMHtGakngqiwjmkVa9jHOF7HqykhWP7o1K7lSc4U1x8jvb4HSpYWSkeU0MJfgObqEAk/9duo1yre7JuZjDonRWzOqGGmc7P4qiXz4xyEljkHK9TgqwfnexBPVfm1Dn9vvkCOFsFp/E8Mw8lI6JusBeHhLiBXLdEf6JX/zQ4SWdF9aAPW+EJKRf7/F9EqnBvWYaNDK9aV4x4De8/f4cIAHajamaCkysRPTswH67jfX5V7v7cQxHWo962lcgZOkNpSKsGMmsrG2PMN1VUpOdzG9ZCHzPw9XJRwyv94oI1MtarVvIKS6r7kViVWWktxsUG57UoECwW4MY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(39860400002)(396003)(376002)(8676002)(26005)(6506007)(2906002)(52116002)(86362001)(6512007)(66946007)(6916009)(66476007)(38350700002)(36756003)(66556008)(316002)(41300700001)(38100700002)(83380400001)(6486002)(4326008)(478600001)(5660300002)(8936002)(1076003)(2616005)(6666004)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z/bzNtU9TLigYt979w4BCukiVm3Wp393UeYTBDa/ZypapookTDyAU6pDb4TH?=
 =?us-ascii?Q?hhx+rJXii0f4TmMPCmyBU4hPRRIManP7q+h3z/ROO7NmfiMSFIQ6rZgvoSet?=
 =?us-ascii?Q?EWJod7Krz7zepnISnwHfVyxnnY3QZDKChJ1zTUsvMq2WQlCSTibPc4vCwONY?=
 =?us-ascii?Q?N29EJG5/hehkdT1pD5M6WCmZ/S0CWR8vzWJuWkli0cu/xapHlHF4QhpU1KLs?=
 =?us-ascii?Q?rh/GI67Ind86nB+0rkoZW5S3Cmpl6U9lbqjkGkD/o2DL4wQ2+u3IZJcFo68o?=
 =?us-ascii?Q?0vGfJGp9jL130FBlyiue+OfRtokn1V3yn2CpakPqbUEu8eB6hBQj+ZuBI/kn?=
 =?us-ascii?Q?CFmUkFvSzFlksZNurVrAnxYNqCZuY8ZlTxcWdf5k78/Ietwih5qHmXRJ/Upv?=
 =?us-ascii?Q?wCaz7DXC6DMKPiqhGXqE7LxRHRHXoq6C1On5iD/2dphhuRAmiUpyqpox6lGH?=
 =?us-ascii?Q?WbkadqX9yilbheaEAafZ2lLolPHL8wqxoSJgyLnxCtRntb5Vfu8VrFCA6rnB?=
 =?us-ascii?Q?3LCR8Ow0hGwfFSard3CJItsZibwS5xJDqaI6D/Y/XKHfFi6cfS+osIICNV6m?=
 =?us-ascii?Q?pOFhvpV23SObJvCFfSGY/dBjpVZGZttcoofF69axV1m5axT8YsuDknJSV+Ev?=
 =?us-ascii?Q?hsiAA9P5gx5nQlclapfIiR4TIBOjRRLTilg9d5VbGOhVQnXZPprAeX3pKpSb?=
 =?us-ascii?Q?WvNb+oeoc76mpdLDVhadR3qoTia9YUHmGHedbA5pGe6I/0UTUgTUCf8T0aWC?=
 =?us-ascii?Q?RYeB8FXiEbDRjNq6FiPyB6MRZDmvAljHaqbNY8xgbEZcXsoYPHVzJS5ldWac?=
 =?us-ascii?Q?V2VPX+Q5uChBSU4j5Pj4vOPuhcLZd2ah9OP93KjnFvkt8aJYP7uvF8v9CExA?=
 =?us-ascii?Q?SkacsZLvBgsmXWIaWryn4jXZU2Q1JSf1nBPnCrH1swi0UkCD2nx3oEl8tggA?=
 =?us-ascii?Q?ai1MGBFBL0xSk17VFMuefFltcSpfHHzQ8Zd1ywjLTPKJkXHhHGwjWRAAjvyD?=
 =?us-ascii?Q?eXRr66O+JGXp+5f+nx7DQFiPHNRHqhqvWlNbV9XIedy+r5AuHRSE23k76xr/?=
 =?us-ascii?Q?AKGFjq0wABj6h4cMX8rAKzCIhsLWg1OdheWzw4Kn5eHFBMlDIaeG9IajwtlX?=
 =?us-ascii?Q?0lyo0KPEtCcd9VdWy235MGK6FyfzU3I92FszK8Q+KlsWTRIXCx8yqwzXAQ03?=
 =?us-ascii?Q?g30fYqhJvXhpcnOGaT1lK6JOesuo1gl/qCPsvSTog1Q367MY34P/TLodqfJV?=
 =?us-ascii?Q?3apV2yEe2tSh0Vy1/YQhW2ARsaBhp8L1GzAjXXfRshnUxHomsvzlXzf6PLb7?=
 =?us-ascii?Q?WvgIzxBKrO+W/h/VxGxgkKU3CHFhGTvODJzlXQ8FhHwGpl2eDCJ+3bs9mjGP?=
 =?us-ascii?Q?tYNROiT7A7IXumo8JztJ1RMxaiDc8LzEmHcCrmd6tHf2DtCm1n5zDgFt9dqH?=
 =?us-ascii?Q?AojqXPid58vqeIyAZ7g3UUFyRgFzGjWp0Eql4O2F4BJT6AWYDPLTZmSrELKP?=
 =?us-ascii?Q?5+7Rol4wt/FYk+KlWhGQRxRDMBNTuI8sbo3gkNnYiS2qoI8KTPJzVIZFw0hE?=
 =?us-ascii?Q?i7Ac5ZCf5wIPveM+zQiSkG9UCHxQHrU5cZaLasGn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dea7852-1dea-4e58-8d96-08da8699dc15
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 13:01:00.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMUZddeNw2ADvkEe0W2fpjauLMdTQgFAP9PwlARuIZKyT4R1qm88ZCpgoOC1mr55otLND6KLn2y0fLkVKakKiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250050
X-Proofpoint-GUID: zIlensz96nhXFNLPivv1mOdbBCPjTCFe
X-Proofpoint-ORIG-GUID: zIlensz96nhXFNLPivv1mOdbBCPjTCFe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a test to check if a direct write on a delalloc extent
present in CoW fork can result in a false ENOSPC error. The bug has been fixed
by upstream commit d62113303d691 ("xfs: Fix false ENOSPC when performing
direct write on a delalloc extent in cow fork").

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
Changelog:
V2 -> V3:
  1. Use _get_file_block_size instead of _get_block_size.

V1 -> V2:
  1. Use file blocks as units instead of bytes to specify file offsets.

 tests/xfs/553     | 67 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/553.out |  9 +++++++
 2 files changed, 76 insertions(+)
 create mode 100755 tests/xfs/553
 create mode 100644 tests/xfs/553.out

diff --git a/tests/xfs/553 b/tests/xfs/553
new file mode 100755
index 00000000..e98c04ed
--- /dev/null
+++ b/tests/xfs/553
@@ -0,0 +1,67 @@
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
+blksz=$(_get_file_block_size $SCRATCH_MNT)
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
+$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 16384))" $fragmented_file \
+	     >> $seqres.full
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
+$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $destination \
+	     >> $seqres.full
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

