Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6588C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 08:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344251AbiFJIwT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348469AbiFJIwN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 04:52:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CF9203D1E;
        Fri, 10 Jun 2022 01:52:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A7vnbr002868;
        Fri, 10 Jun 2022 08:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JmgUli9E0+jNE5VOAjOYaDOY2oGXB+Sxi2jNBpBIROA=;
 b=j2ejXycepJAxoUSw1tGZR5qq/Du/BHqIcZY5f6GGQ70yABBFMbZ4z+QmdHMkDFnYd3gQ
 rTamu1lC7kbA63/YJGMe6AgJE1LLC62yYXEuWELEjWkgBH4lz2uuVBFtS3YJdr95Lob2
 YM889EylURvpspQcS6dm36SZwNE5dox2r24QnN0ZhVbYMzXQ2FEnYpCi0BUlWNMIYQZ6
 7s/NF5rNzyOigGKNwBDCUUyBJVm7hKXVENeJfyRmqgMm3B7JijrtJ96Rdwb3Xh4EaooA
 fVeei8W0ZLi+nv1rN7K2EGFB/TqONyd8dQgfBoQx+d7g0y0jLwFKzbc9eJ7EQQjTN9o3 SA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyxsncmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25A8oRZB023935;
        Fri, 10 Jun 2022 08:52:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu65bt0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTujFr5LKh+hm6fqSciBsSdMCcRqzR51TNnzrkTW4RC/F3w1TGq//fba+LoHX4SwdJGQCQiG+p9CPDoN1P74bdv+i/idUUHAn5CL9AZEmDvGN2oP1FzyOhVVFu1j8MPZ5d7/gyv8/BscwsVeOXm7pMkUfnXAiFh+1kyrA27057Uc3YOrZ241AaKEl087/+KQdk6TyYjNSpgj8INc+TLoGm0m0/tydh+BzH8MI/2f8Pv/UuYODl2S7qE7lOJxJ77skCnAP9oTGm/KpmU5blc+oHF3jxiFXyrDrIeCb9Bt0ikFjYLJrvT1KkNS1Pvx12LaaJSDfzFFJsaHb9eG7mPjjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JmgUli9E0+jNE5VOAjOYaDOY2oGXB+Sxi2jNBpBIROA=;
 b=YimFw3qcS3FApEK/5iCoLUcv0xkCgkN17/Z1JMHmLxmSOtz241PQRRucDdawThskNcOx3M6JpAmZuzz+MEbTI0kzP5ISRQ+cXghd4KSI0x5qZfpT370/ZYblZ9ZKXe5VZ/jd7IKU1sMPbTLui/38+Zi3U6B4iMyXvXpV1k9O5angygVAQ3pLfUMbdMKPNM+nlyKHSQLxUmqykY85PFSPiMgu4unnmFlhtk6p7zPyBv12bGlqafLxZUeurSZf3pRsmw9rI31X6mhQRbhltSJjC5hiDFhKJjWDXs8AiewrVsq2MvBzt3BqHWiNdBkaORn6dmw4QMFJ5CFLWPZfKrVptg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JmgUli9E0+jNE5VOAjOYaDOY2oGXB+Sxi2jNBpBIROA=;
 b=owEQwvNdAy9chUOsmcaz5szWeoL3EEb7wJ3ZuMu7cobaFXa0NcmOjmIiFATl+/YgjbNCXCFpCTvCz0kNDM8rSLHBfvj8OkC44RczP0qMAMIeQ0uI9gqEzB53+aGJpJgDZN9HY1Vw3d9v4TCqu3X9mYeWpQzZX74Pz1zLbWnh3u4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MWHPR10MB1965.namprd10.prod.outlook.com (2603:10b6:300:10c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 08:52:06 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 08:52:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V2 4/4] xfs: Verify correctness of upgrading an fs to support large extent counters
Date:   Fri, 10 Jun 2022 14:21:35 +0530
Message-Id: <20220610085135.725400-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610085135.725400-1-chandan.babu@oracle.com>
References: <20220610085135.725400-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0229.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::25) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e099409f-f3a3-4e51-7e2a-08da4abe7d6a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1965:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1965C6E9FBE509F52DF77BDAF6A69@MWHPR10MB1965.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h78up8/Ha40f8fNbT1o4nfbVokty6EG5mrr7Y4feyIE5ZQwbha+xRwh52jcdvX6fOvHFqP0DAvIhHEm/nmM7bowg0jt8bhAsHZbQ3u6v4yeq0Hts1Gem2yohlVGAOE7oS17obwH+F8bMm9xwXQuyhUEc8aYrhbFW+xIftBpsT+a4oUcGbnG5FXFeFmu00Mu7mIVt2Mm3tMzXHzd9ZCuWOP01yjeusJSSFyEzikai42F5MhBEc67c9xB68enLXVO6xnOeNe7xMvsydHcsiu1Vkd+vC9Aui3Q8z6QSaX8bn4X+2T4QVu5biJiBNTbo9UCIlOiY1XBEFmMGx6UsNq9l6oecCUt2Hv6jhnf8z1gPhz4c+uNuoRcnJZH96siCncC2vxA55kaMLpaf71Jl2QRoNjfh5xO0YGLjyhwzPeS4JOoy0kKIjOstxVys2eL1kBg//okoSDO1hvTI1vBg63HzuuFEvCibmTnH7PBdnc95wiV2JvjFlDAkpUzb6/8oUs9m+1lhjO5wrP3SVsNneMevXAWe5ra30jRFSn32hgmyaY0hHL2cMEPAMclHkdnaZs3he5J3kM6aQFwwhpvIJ2IN4LXQCPDFnL1IuEna7jeD8gAuFwAgLLhxrh5QMcJ9GdE9MmCh2h66tZiiPuiLZ3CREJZt/UBzy2KYrtTXrLtyjeKtwuwC8f22ODYIjAVJ7hMDMxn1MNb6nG19lUcmYZIq6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(15650500001)(6506007)(6486002)(508600001)(86362001)(52116002)(26005)(6512007)(6666004)(1076003)(186003)(2906002)(83380400001)(66556008)(8936002)(5660300002)(66946007)(36756003)(316002)(38350700002)(6916009)(38100700002)(4326008)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8PCiMPKZBt55mkqjt1nGbGFjfrdiEUjVG0gFoeTZ1dia/FrF2uproXzC6nvP?=
 =?us-ascii?Q?S2tGyiYC/VYf2dn7tk60Su0TiHZm9HmxAC03w4Hab7BUmZX26WCr08VvGyh+?=
 =?us-ascii?Q?fZAvD0jgqQvX6eZvOX/N4+usi+SApX6zLA3kj+bHSb48JaxoPsd3ESGT7jma?=
 =?us-ascii?Q?c4id8fU7FcWfUG/CpGwaKmGPFLorVNSEcVQvTwWIzUUNfqk8/+JqKtldFZf5?=
 =?us-ascii?Q?f1Lve4pwnm3+YbjOI/0kwnmzgB+8i1OBYJhlHV0re8MDP0NfTGomIRw3EEsX?=
 =?us-ascii?Q?RhvA664vHaHLiUlg6GznFwebU9jJ5TB3XLm69Ab9/qkJrln8+5nzjSluHpNg?=
 =?us-ascii?Q?mNSPQsVAveKDX0zImjQoEeP2/QHpMCGLPvzgVR4QyczX/ngVtkp8c8Xdv3PY?=
 =?us-ascii?Q?zuQEFXIYCfyHmrv+Ke624baBuymBGUhkZ+03H1a6L8ktP8fHRyEirb65l5I1?=
 =?us-ascii?Q?xPjKNnIflClismqIPEvUqXrTZptwN4+PRQ4gs53vgDVUMxIJX+7OENIqi3Qy?=
 =?us-ascii?Q?vTjwZ/fZPoS/rSy2ytVRCImTDZArAQIxdFCPVB8i4+f1OG2zliWsaAsvyvQm?=
 =?us-ascii?Q?sNyjQDjIZxwWSvH4zAZm6kTnMO84CPsI+JAC1I1FRwAVmhFXwU8kYxxCxSN9?=
 =?us-ascii?Q?ABbCdKYeWEFKsz09uDE8qR6MKwTd5Ba9ZVd+ZqrsvfvcHsrCZS/KVFl0kZfd?=
 =?us-ascii?Q?fMCV/oBzn7QXlnbcgNiILE1kfQGmq+m65ndpToY/9a+X25vcBkfwX8IWrxYQ?=
 =?us-ascii?Q?8blUDDkcrodi2uRPZuWlfGq2O2UhSFeTKmOk4q/be4mejp5Xje5HGiL9f4yh?=
 =?us-ascii?Q?/JPaYaXLB/1bGygFjpxPjKOM3DCl7YPiInGmtv1tHiOoWgDST7c8u/cXiZNr?=
 =?us-ascii?Q?/1NZFUNBZ53luFwyHtJy5RX04lzYnoqIcCB/KPObImx640ego2AorBI+1+v+?=
 =?us-ascii?Q?tz6y7vUTSuClNjCHm/73x08uL9g9qJ463ObhXDHNgcuB4eXlwW0NwT3Fs4Yz?=
 =?us-ascii?Q?5OsrAtezj0FElFY44arKEYJtoHwwK+YZRaM4DUNsJtKVYTDwUfmoKGqE4XOx?=
 =?us-ascii?Q?5CQD/8aizDlsWHiRI7a7Y+uQHwY4jfwTdmv+7mksacpmufzb4T7rB/rHeXHl?=
 =?us-ascii?Q?2kcRYTebAxN+jrwN+EzTjySkrMKsmygBXADycvziDKFGFaBRKMRWMUE0IrgP?=
 =?us-ascii?Q?vZd21uBkc7YKXCgacNwTOAwuDaRRfqWfHdujbBKlhLIcOyDAvnSee+0/SMsI?=
 =?us-ascii?Q?C8xPs+rVXAO+359GwNG5tRRXqX4CDMnwG9CbFX3jsza0OR/rQlrVHwBa9D/r?=
 =?us-ascii?Q?mxL2p6UeEga25fkYwfPMGR7QAbqaW+S3E5NGoukG0jkql9+GJ3uGS01eOxdt?=
 =?us-ascii?Q?tOlbc05m1fSK1BM+HjzwUFwpOdHQYAMRmBnPZqmcwyxegewhZYYmNpw96r0g?=
 =?us-ascii?Q?TIHmDdDPeXIfksV1Qxud9gMeTjo4BUMdJYEkTN8eRxwlWasvh5BINv+XCqEV?=
 =?us-ascii?Q?vcPi84L5heR/BkcKy6jHY8iMLfLzTEO0DpzeuWJQbf1GifI/6Prl4/sUjCh1?=
 =?us-ascii?Q?yISDVL09dYX1pMUYcjIrQXS7wy0PPBx2+PTHQjsuu/fxoRCIgmgzT5g1RoUV?=
 =?us-ascii?Q?QVNWzxtfyAOKxisyqaAO7LmmEcsQN3BX5+8x3nokp9AAEt9KxJP6R0mTOK6R?=
 =?us-ascii?Q?JQm/KLd0As1mRfjBx+cgtRiYix0ww4KB5Aurn1yJ9fCVCcPfQbksPVdb4GWQ?=
 =?us-ascii?Q?aA8qxTuiBOpjfVgfTjt1uJmAPi2zUbI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e099409f-f3a3-4e51-7e2a-08da4abe7d6a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 08:52:03.7062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+SoIC/CyJyA98Nnre2CTC4BKMzRqQ/z7mESex5TZ94a0rU+vLx0FG3Np1WeuZ3D8fv7EQMyTiZsGDoJjek3oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1965
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_02:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100032
X-Proofpoint-ORIG-GUID: 5a5sTDWmrZaXzkSKwQp1I-UBvaSlggoc
X-Proofpoint-GUID: 5a5sTDWmrZaXzkSKwQp1I-UBvaSlggoc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a test to verify upgrade of an existing V5 filesystem to
support large extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/548     | 112 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/548.out |  12 +++++
 2 files changed, 124 insertions(+)
 create mode 100755 tests/xfs/548
 create mode 100644 tests/xfs/548.out

diff --git a/tests/xfs/548 b/tests/xfs/548
new file mode 100755
index 00000000..560c90fd
--- /dev/null
+++ b/tests/xfs/548
@@ -0,0 +1,112 @@
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
+_require_xfs_nrext64
+_require_attrs
+_require_xfs_debug
+_require_xfs_db_command path
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
+echo "Unmount filesystem"
+_scratch_unmount >> $seqres.full
+
+orig_dcnt=$(_scratch_xfs_get_metadata_field core.nextents \
+					    "path /$(basename $testfile)")
+orig_acnt=$(_scratch_xfs_get_metadata_field core.naextents \
+					    "path /$(basename $testfile)")
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
+dcnt=$(_scratch_xfs_get_metadata_field core.nextents \
+				       "path /$(basename $testfile)")
+acnt=$(_scratch_xfs_get_metadata_field core.naextents \
+				       "path /$(basename $testfile)")
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

