Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C62C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344388AbiCUFW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiCUFWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C083B3FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:20:58 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KIpkdw008826;
        Mon, 21 Mar 2022 05:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=M/CEGHdqHRizhtei5Og9y52hHFnZg/xmGNOZ+hkYkkk=;
 b=JZr4rjO1nCHuxJzhHD/pGq9cFKesI8hFu4uWcq6wIzVWS39tQ1dvFjIBi3FXZf6jPAJY
 Ijvi/YI661Hr+CpGrKZ4zBBV8EB8CtlNK4vwR5HmvZGlaNfk7JXfKvwYPOcq+Z26HE91
 RJCdAaOp0hINfkrKOpvfJKyRDg2pvPRr+O4k0ltc4VVXQvIl9a44XB/BcLIqyJj/SjZ1
 EBNVrgjWzk+psY6LrZiLBKf7tXC3/k5HJQe270JjKF6g74t9IVsqmQ3BWrBqNg18oTbU
 fkFW7OSCWz9aflgPg0pubHZ2Qbtkq+SqMI6hSBQDhuvRolYHDpPV+2ZgS6FLsZZhMlKL Cw== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qt22yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5KrCY125205;
        Mon, 21 Mar 2022 05:20:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 3ew578rnv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoaZ+zPOF1/aidYbaOBgbbj+UX/Two1jEGqGatpicxo5hvkItkEhRJfXZwGLiJLndcUarC5rvNKxdwhnf3aRodflRywpcg8OX7YFjIMsb2uDafPL9Mobd9JIbDQaX4HpC0Whh8QDktwXa1b+jpUyO8W4dLTMoflEddXIjUQHQx24ZjWMiU5UaENm6/89KJ8wcCuUeuEWVomWNu0LM2RFjrsAetg+jPXhmpZRwckbm9WzYeEuEPg/gXcMkJZLtFL2+jamwTWw39Otf8N0POSr8yP/C2ALLqvkqp9Qg+KcQ0T34lSvEJUilVDotgLATBm8i+58rdCa3TiG1YYQUFUoOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/CEGHdqHRizhtei5Og9y52hHFnZg/xmGNOZ+hkYkkk=;
 b=QbuPwIkZ7Zb7TfXLyb1yrFau11bqji2GnCV/kea0UoOJTcsi1IK7PunlW57bxnaw98mztfGqZ8KCnKJg0nOhyp5sSUFSXVtMuQTCGcq9PwNdvxKL/Tnv+FoAVwiRAD1/tthvY5WXV+14CkPnwutfO7xIAVkM7cHxednjFEsj/xMmhndzP3zJtFFh4g0a4vWDaEk1O4yR0Tyne4A3pF+wTPyTabp9S7HjeRcg53WK+F1MfXfpnnRhnPgJrAIPTOTTg01ISzRrptf8YtG2Dk/+4OQcaNy7irBGooDvgv9cmczlHaBF0mxojxTv+rfiBZJh3nMxkCJGI59xUKl3b2PIbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/CEGHdqHRizhtei5Og9y52hHFnZg/xmGNOZ+hkYkkk=;
 b=BJQ4guJswhdlV1bePKC8fSD6Vp1IB03c2bLv9RXpbC7z0CNVtqGRGbc7YiCw40ULQE7wF0eexPnPqgiUy976rWjaTLA4QWhvn2Pc/9vaBacrFlszEwYZCrj+223gtbNBysMpaoPjpou0o+CysMDXgWFfQyVQH0RVA+wXHfsoPdM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:52 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 05/18] xfsprogs: Introduce xfs_dfork_nextents() helper
Date:   Mon, 21 Mar 2022 10:50:14 +0530
Message-Id: <20220321052027.407099-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57857f95-1e4c-4f6b-f47d-08da0afa9112
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55632B34D9661CE2F863B013F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uLxDQsyckRq3jM94/rgRpLFiKZsR5JOpTWKsglnG02xO1fwq61zOcS6CZQimB8SPQwvFA/SlJuJBO1nI9OH9pkKZF++/6YEw0H+ENKaH5GoI644tu2vFkegTnJB11Os+nUMMZdWAfvK/lT1/0SFbRIieQHmNf8HlahXW4J/QkL3uUGWf7uYGnZaSo1fwR/piVqFSAZ1+2vu05Vyxk6x5IbbkSMpoDDRq4vGK6ItYc21Soj6jZo20mJ6OouYDekLngw5nqKuKpfyzRN06iGchY2iktGbOIvyOLBrqv2MGKRuZpizgkN1KQiKWQ9NEotRsPUQ1tHbbENSx86yixIKsiN26QY5VG6tiqggYR9dT2eZndh8hcC1sI/w2UKogYICJR0q2db0xBFuC2+KHBzdm6i1fDCEeZ1OxDOQR8HWjlT+LCSJfEn+LY+qHPaJf6BOOUV9Xt9l81dlBXHCLS1AIy1nbhvlUmxSf0/mu5AZnjMX8SZrFXu60wJ5I36PhLpvVVzLg2aq9InSKy08PcBHc/YwK5QMBhybZgl/8CYrL6d6M6/P4yZwHnPUw7B7GEmB+YwAiY5iKKxSrB6Sat/JYSkel1cxA+TS4wqTlT8KojgL6g35DZIRmMACNiYvtyMtlb6F10fhctHekfIgSDxMFJuyaMWnKN9hXUAN7wlWdQfwfo91CxilkjQd7pIKYRYtX6Adif+kFX+xq2d/4PDe2iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(30864003)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zuGA13CF04+7bJevDzaOOtRxVb2JGEMgRIzMWSueQnrYMCnbTPpr6m5ekNxI?=
 =?us-ascii?Q?3Pu37NJGSZmrg9gmMkLmHjs2BN7VK+McqLQ1svPcHN9VFiUmshPhLpEGXwPd?=
 =?us-ascii?Q?zGVSsJf+U9moxW02yQ08pSQPPFfEaaxrNPbf08cDIaorUme6mIkyatMpdVOy?=
 =?us-ascii?Q?w/eoFTF0gu8JZLcAzTT0yc2oJ37KcBD9AvLNstWjfbC+LqF0hT0asdrtf2gB?=
 =?us-ascii?Q?aPTm5EDmuyNJaIUU6tCc6k3l8Yy1GcLCp6DaYdNdeb8X8IpaFc5sfnhS9HVC?=
 =?us-ascii?Q?i/PdAjRrEmyZxVYfHHu3hJe2TmJ/f8Mfy6jPNA+zlmjJMqWdg4KRpchx7YoL?=
 =?us-ascii?Q?oE2fQkGCziYR5NdRcmtMlN/GiNxpuVTYtWebwTgDEShXEj5xyRVBdmnuxaH4?=
 =?us-ascii?Q?VHzLBeO5tluMWuZHondmkXzyIaCT93J3vAXizRPwheD1efQREJAVTM0apAVs?=
 =?us-ascii?Q?eztpGQZ10Asqwok/55dBnkSZcAa3c27QRHTuYYpn/Cm/0YO9+VloV1AcWuFN?=
 =?us-ascii?Q?hXALL6goRbo5lnVlVS63o2S1xW+Pvyh6+sRYuNGmAiCq5z3KsnO9J5GG+1Uu?=
 =?us-ascii?Q?oaV0C7lRXv/oPx8ghTQpl2aV1LaFgPCST59JYvpBCEJMdegrcBiOA2oqV1ZT?=
 =?us-ascii?Q?bEHLVDoGjwMCBNaZM18bwhz3RNVQVlmkb+qcHIHPJ4iJCR+eRu+n3DJEK/iT?=
 =?us-ascii?Q?C9HoL0A1aZjC0+u64Mz3K10cO7ducJeisOpPJ08nXjQxqBfMkA75ufWoAwVY?=
 =?us-ascii?Q?szYD76IIWedEfALDAUk882PtueBjMVWeuKHuzUmT75Uj9q4JU5aBq0lNBXl8?=
 =?us-ascii?Q?IQfmrXTbNBMlxxlqMyx83XHmVh/PY012KY0KoikUONJpx/7u5XZJPrDXB4OP?=
 =?us-ascii?Q?Ky3m70+WoCxrELWAk2mDMX9oShj3eXbOiZ1k8Zo/7XvGvnDbLL1K4fW4rbWb?=
 =?us-ascii?Q?xps4HxQDda5oW/G2jwYVmz7kIHOHOqzDlklfJEVi5U1pqJTWF8+RjuaHxGhw?=
 =?us-ascii?Q?urPXjQHFP6HAeF64C+W5yhL2AMQuObF0pVXrTVV4HxnAbheSZVGP/HZqAEbw?=
 =?us-ascii?Q?hSFyZ0G9l7NLBdqZJxZuV7AbCcE7eDTkPzm6evj3N/oUSdbsBgGxOMBUFrTx?=
 =?us-ascii?Q?ntORs0WHxyeDFZGXf9UeE1SnQtzCzaTSlnCzMYO68IL9M57hz9+TuuKaSDRz?=
 =?us-ascii?Q?Ymx2BG7zhlKKwo8BJAluF823owWYhG26OyY4Agzkyg8BMCvY3iTlWh/ArHZB?=
 =?us-ascii?Q?XrfXRa8WNSCsyigZsTC7WVs360keE3KFRLhfSN0sYoQyBCWEFRvkqX1GJ50Y?=
 =?us-ascii?Q?4ePrePrXCvEL1a56H7wc0r9vLuR3UiFEZQY1xac0SqnaE7V5jzArgQhDpmbJ?=
 =?us-ascii?Q?w0pD994CPNl5EkteqkV3JflywjnQcqPMqECRn54LaLu7cOHna0Mhtl/Td3XB?=
 =?us-ascii?Q?vKXmp442rYr2Hnk/fVvR6yk3TlZ6ALVW/IqCt510VHC8Sp2ZoqxDqg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57857f95-1e4c-4f6b-f47d-08da0afa9112
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:51.9324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJAdumL9+Zcov5h+fZILDqDdin29Z16rfMIdcSCiLefSIb+i/DlV2wAcs1kX8eOTc5Rkb3KSenQCSBE8y+wN0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: EcVaiNva2TwUlnvumzs4G-t8NI8Ax49X
X-Proofpoint-ORIG-GUID: EcVaiNva2TwUlnvumzs4G-t8NI8Ax49X
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               |  6 ++---
 db/btdump.c             |  4 ++--
 db/check.c              | 28 +++++++++++++---------
 db/frag.c               |  6 +++--
 db/inode.c              | 16 +++++++------
 db/metadump.c           |  4 ++--
 libxfs/xfs_format.h     |  4 ----
 libxfs/xfs_inode_buf.c  | 17 +++++++++----
 libxfs/xfs_inode_fork.c |  8 +++----
 libxfs/xfs_inode_fork.h | 32 +++++++++++++++++++++++++
 repair/attr_repair.c    |  2 +-
 repair/dinode.c         | 53 +++++++++++++++++++++++------------------
 repair/prefetch.c       |  2 +-
 13 files changed, 117 insertions(+), 65 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 8fa623bc..d0c0ebac 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -68,7 +68,7 @@ bmap(
 	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
 		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
-		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+		nextents = xfs_dfork_nextents(dip, whichfork);
 		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
@@ -158,9 +158,9 @@ bmap_f(
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (be32_to_cpu(dip->di_nextents))
+		if (xfs_dfork_data_extents(dip))
 			dfork = 1;
-		if (be16_to_cpu(dip->di_anextents))
+		if (xfs_dfork_attr_extents(dip))
 			afork = 1;
 		pop_cur();
 	}
diff --git a/db/btdump.c b/db/btdump.c
index cb9ca082..81642cde 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -166,13 +166,13 @@ dump_inode(
 
 	dip = iocur_top->data;
 	if (attrfork) {
-		if (!dip->di_anextents ||
+		if (!xfs_dfork_attr_extents(dip) ||
 		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("attr fork not in btree format\n"));
 			return 0;
 		}
 	} else {
-		if (!dip->di_nextents ||
+		if (!xfs_dfork_data_extents(dip) ||
 		    dip->di_format != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("data fork not in btree format\n"));
 			return 0;
diff --git a/db/check.c b/db/check.c
index 654631a5..1fdc1817 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2713,7 +2713,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	*nex = xfs_dfork_nextents(dip, whichfork);
 	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
@@ -2737,12 +2737,14 @@ process_inode(
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
+	xfs_extnum_t		dnextents;
 	int			security;
 	xfs_rfsblock_t		totblocks;
 	xfs_rfsblock_t		totdblocks = 0;
 	xfs_rfsblock_t		totiblocks = 0;
 	dbm_t			type;
 	xfs_extnum_t		anextents = 0;
+	xfs_extnum_t		danextents;
 	xfs_rfsblock_t		atotdblocks = 0;
 	xfs_rfsblock_t		atotiblocks = 0;
 	xfs_qcnt_t		bc = 0;
@@ -2871,14 +2873,17 @@ process_inode(
 		error++;
 		return;
 	}
+
+	dnextents = xfs_dfork_data_extents(dip);
+	danextents = xfs_dfork_attr_extents(dip);
+
 	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
 			id->ino, mode, fmtnames[(int)dip->di_format],
 			fmtnames[(int)dip->di_aformat],
-			be32_to_cpu(dip->di_nextents),
-			be16_to_cpu(dip->di_anextents),
+			dnextents, danextents,
 			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
 			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
 			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
@@ -2893,25 +2898,26 @@ process_inode(
 		type = DBM_DIR;
 		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			break;
-		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+
+		blkmap = blkmap_alloc(dnextents);
 		break;
 	case S_IFREG:
 		if (diflags & XFS_DIFLAG_REALTIME)
 			type = DBM_RTDATA;
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		}
 		else
@@ -2993,17 +2999,17 @@ process_inode(
 				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
 		error++;
 	}
-	if (nextents != be32_to_cpu(dip->di_nextents)) {
+	if (nextents != dnextents) {
 		if (v)
 			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
-				be32_to_cpu(dip->di_nextents), id->ino, nextents);
+				dnextents, id->ino, nextents);
 		error++;
 	}
-	if (anextents != be16_to_cpu(dip->di_anextents)) {
+	if (anextents != danextents) {
 		if (v)
 			dbprintf(_("bad anextents %d for inode %lld, counted "
 				 "%d\n"),
-				be16_to_cpu(dip->di_anextents), id->ino, anextents);
+				danextents, id->ino, anextents);
 		error++;
 	}
 	if (type == DBM_DIR)
diff --git a/db/frag.c b/db/frag.c
index f30415f6..1d013686 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -262,9 +262,11 @@ process_exinode(
 	int			whichfork)
 {
 	xfs_bmbt_rec_t		*rp;
+	xfs_extnum_t		nextents;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
+	nextents = xfs_dfork_nextents(dip, whichfork);
+	process_bmbt_reclist(rp, nextents, extmapp);
 }
 
 static void
@@ -275,7 +277,7 @@ process_fork(
 	extmap_t	*extmap;
 	xfs_extnum_t	nex;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	if (!nex)
 		return;
 	extmap = extmap_alloc(nex);
diff --git a/db/inode.c b/db/inode.c
index 083888d8..57cc127b 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -275,7 +275,7 @@ inode_a_bmx_count(
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		be16_to_cpu(dip->di_anextents) : 0;
+		xfs_dfork_attr_extents(dip) : 0;
 }
 
 static int
@@ -328,7 +328,8 @@ inode_a_size(
 	int				idx)
 {
 	struct xfs_attr_shortform	*asf;
-	struct xfs_dinode			*dip;
+	struct xfs_dinode		*dip;
+	xfs_extnum_t			nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -338,8 +339,8 @@ inode_a_size(
 		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be16_to_cpu(dip->di_anextents) *
-							bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_attr_extents(dip);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
 	default:
@@ -500,7 +501,7 @@ inode_u_bmx_count(
 	dip = obj;
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
-		be32_to_cpu(dip->di_nextents) : 0;
+		xfs_dfork_data_extents(dip) : 0;
 }
 
 static int
@@ -586,6 +587,7 @@ inode_u_size(
 	int		idx)
 {
 	struct xfs_dinode	*dip;
+	xfs_extnum_t		nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -596,8 +598,8 @@ inode_u_size(
 	case XFS_DINODE_FMT_LOCAL:
 		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be32_to_cpu(dip->di_nextents) *
-						bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_data_extents(dip);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
 	case XFS_DINODE_FMT_UUID:
diff --git a/db/metadump.c b/db/metadump.c
index 9bc20a84..9ea388b9 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2282,7 +2282,7 @@ process_exinode(
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (show_warnings)
@@ -2335,7 +2335,7 @@ static int
 process_dev_inode(
 	struct xfs_dinode		*dip)
 {
-	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+	if (xfs_dfork_data_extents(dip)) {
 		if (show_warnings)
 			print_warning("inode %llu has unexpected extents",
 				      (unsigned long long)cur_ino);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 66594853..b5e9256d 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -924,10 +924,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 15b03d21..06e7aaaa 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -333,9 +333,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -402,6 +404,9 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_rfsblock_t		nblocks;
+	xfs_extnum_t            nextents;
+	xfs_extnum_t            naextents;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -432,10 +437,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	naextents = xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -492,7 +499,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (naextents)
 			return __this_address;
 	}
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 4d908a7a..0530c698 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -103,7 +103,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -228,7 +228,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -293,14 +293,14 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents = xfs_dfork_attr_extents(dip);
 	int			error = 0;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 2605f7ff..7ed2ecb5 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -141,6 +141,38 @@ static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
 	return MAXAEXTNUM;
 }
 
+static inline xfs_extnum_t
+xfs_dfork_data_extents(
+	struct xfs_dinode	*dip)
+{
+	return be32_to_cpu(dip->di_nextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_attr_extents(
+	struct xfs_dinode	*dip)
+{
+	return be16_to_cpu(dip->di_anextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return xfs_dfork_data_extents(dip);
+	case XFS_ATTR_FORK:
+		return xfs_dfork_attr_extents(dip);
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return 0;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 50c46619..954a2f1e 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1083,7 +1083,7 @@ process_longform_attr(
 	bno = blkmap_get(blkmap, 0);
 	if (bno == NULLFSBLOCK) {
 		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
-				be16_to_cpu(dip->di_anextents) == 0)
+			xfs_dfork_attr_extents(dip) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(
 	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
diff --git a/repair/dinode.c b/repair/dinode.c
index e0b654ab..386c39f6 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -68,7 +68,7 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
 		fprintf(stderr,
 _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
-	if (be16_to_cpu(dino->di_anextents) != 0)  {
+	if (xfs_dfork_attr_extents(dino) != 0) {
 		if (no_modify)
 			return(1);
 		dino->di_anextents = cpu_to_be16(0);
@@ -938,7 +938,7 @@ process_exinode(
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*tot = 0;
-	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
+	numrecs = xfs_dfork_nextents(dip, whichfork);
 
 	/*
 	 * We've already decided on the maximum number of extents on the inode,
@@ -1015,7 +1015,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, struct xfs_dinode *dino
 	xfs_fileoff_t		expected_offset;
 	xfs_bmbt_rec_t		*rp;
 	xfs_bmbt_irec_t		irec;
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	int			i;
 	int			max_blocks;
 
@@ -1037,7 +1037,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	}
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = be32_to_cpu(dino->di_nextents);
+	numrecs = xfs_dfork_data_extents(dino);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1543,6 +1543,8 @@ process_check_sb_inodes(
 	int		*type,
 	int		*dirty)
 {
+	xfs_extnum_t	nextents;
+
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
@@ -1597,10 +1599,12 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_data_extents(dinoc);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1618,10 +1622,12 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_data_extents(dinoc);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1780,6 +1786,8 @@ process_inode_blocks_and_extents(
 	xfs_ino_t	lino,
 	int		*dirty)
 {
+	xfs_extnum_t		dnextents;
+
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(
@@ -1802,20 +1810,19 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
 		return 1;
 	}
-	if (nextents != be32_to_cpu(dino->di_nextents))  {
+
+	dnextents = xfs_dfork_data_extents(dino);
+	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be32_to_cpu(dino->di_nextents),
-				nextents);
+				lino, dnextents, nextents);
 			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be32_to_cpu(dino->di_nextents),
-				lino, nextents);
+				dnextents, lino, nextents);
 		}
 	}
 
@@ -1825,19 +1832,19 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
 		return 1;
 	}
-	if (anextents != be16_to_cpu(dino->di_anextents))  {
+
+	dnextents = xfs_dfork_attr_extents(dino);
+	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be16_to_cpu(dino->di_anextents), anextents);
+				lino, dnextents, anextents);
 			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be16_to_cpu(dino->di_anextents),
-				lino, anextents);
+				dnextents, lino, anextents);
 		}
 	}
 
@@ -1879,7 +1886,7 @@ process_inode_data_fork(
 	 * uses negative values in memory. hence if we see negative numbers
 	 * here, trash it!
 	 */
-	nex = be32_to_cpu(dino->di_nextents);
+	nex = xfs_dfork_data_extents(dino);
 	if (nex < 0)
 		*nextents = 1;
 	else
@@ -2000,7 +2007,7 @@ process_inode_attr_fork(
 		return 0;
 	}
 
-	*anextents = be16_to_cpu(dino->di_anextents);
+	*anextents = xfs_dfork_attr_extents(dino);
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index a1c69612..1a7a4eab 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -393,7 +393,7 @@ pf_read_exinode(
 	struct xfs_dinode		*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			be32_to_cpu(dino->di_nextents));
+			xfs_dfork_data_extents(dino));
 }
 
 static void
-- 
2.30.2

