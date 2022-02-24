Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A07C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiBXNDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiBXNDV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BEC20D537
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:51 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYKAH000960;
        Thu, 24 Feb 2022 13:02:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=zrnJL3ibGxy711PAIg66j5yvgQesJpE+BZpSLdWNEsE4sqTWPsYaQ8hauoo7e9FJOYYG
 gE2iZO7WEEq29xwJZQIUYGm+9PfdbzxmYdhsQBVMaReI+qQxI2aGOoudtlfF3TCwMRuZ
 TkWVkaXN5peSJXM7EphUrH7xXwOwPFoKmytTf+qkM2bP/b8LIdq3xQGMaZHj88VLebbt
 ioCjwliqWPFq/6zl49e+h1YuILc6lQzC74Vd2ogYRMKY7jhWXAvtXkBz7+pBWx6CzqCP
 9RrE+ESbW8PRBDiZqqUGHFTszN5Mnb4w1V+rpmo5/Ko7VDfGN5In5rMZMWFud6xjBvIX MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqa74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1gqB039576;
        Thu, 24 Feb 2022 13:02:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3030.oracle.com with ESMTP id 3eannxdd65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtqJ2yKet/d3v45aeWHUT6RIw3Mr5GX0fXdojl8tgTfqlfnExNtjGcgMSUDDUmD/CT4lxKvL7/WELJKkPGaG0VE0hr155OYe6Ld8UG1UisHDk/bFqyB2wCHk9M3J1IJpT2rd3ijTb5aE3aLa1RGoBSsrgqfj/knJMXH3s2B9rLWepYym89PW678hkHQEm5Y+CxNOdM7voiJ8SqT39b1p7S2gd9kcZcQmnoqfwYyue325AcVfF8JcfTjKW8QghR8CXMs1H51JSoDIDe1ha0psNxWZn98GXX/LzvSI47WDb9YnH1LZB1UaZPDXTAEKbtzgHStGbjnyY7VGPmmuaLcLnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=Zv7OIZSw6rcgJhQQbPilUfoUzlB8u9FQ6urNNTxpHjtUiLwsAv6tIqnnBeGHhmq/PHrI6lbwE7IySSZHteHIy86N7fRdaMEjSg8fLdyI2wx2Nh4mQsuL4q5jFkp6yKvg13EJS/1/7YtcF5HFgGq3ftF+MVcRInvILIX5U4kFTE9ekD5ztDf+rFNupJuiNZ4QKzIZfwTXGTQZR52boh93r/bCjcI3dU+PnYFsAzLPhQV3r3O7J0qG5QrFhKYrgCjQ+zL5XTBcccLYp7i/dih4opdEQMB4fsK+bE/A9DkhOIAyOhMtaPijzSXBszV2taXJsLlXq1Fwmsroh7KZwxW1Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=RVQOhPK/3Hw3cLbGQ6n50Sfp7zvBHMG/ljkKUjPJ6styDVvG3PdA7C0mOW/lEzyDB7cwtKruJxqGB6pBfnmgRNXWfwM65MQwkpowvfa+CXbSPaXefOIo0lEIvpCc67yuxBYMzH0WjhFg1Xe9Pw7nXMMUAaUF/PATOFSmv7LBFow=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:43 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 04/17] xfs: Introduce xfs_dfork_nextents() helper
Date:   Thu, 24 Feb 2022 18:31:58 +0530
Message-Id: <20220224130211.1346088-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bd8e5ba-151d-4284-2d7e-08d9f795f22e
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3665B67642860E5C3C590D5CF63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PKSo+cHGSE2hIT5Kw/lqbfRD0ukD8WDZvUhQsp6G0JOKkn3AQbBKQuh44+KtEQwciv2+/MTUMOezuPS0TbpE2PSaFN+66QpR95C/w2Pl53KPpsK+c97qMz8xaj6SKxGIHUXJXpCJnzPkVouRBdDvW75IpKIeoF+VT4CgmfJ1jB++i2u6cENrZXPR4Cv4o2GOkpFsxlPwjKg6090zSppgiILW0OHf0Bx6ySegAAKBRV+x59KzpFfA0PTNvVLVFxoleNR28iC2n7N5DIEFwSHly4RpEWBxeHfZYv4CH2ESN1WPLzIk59d48b6d20gGNNOoeKHo6HBE7onLdpug8CHWonSsJKNm05XtB02kXfVvIPi2sqdDTLJMNdrthZXZj11iqPoVTB3KMBqHJYN60LLbD73pS/vO0IMAjFcgOdskAZpevZqNThwHBEz316C5SlYym90GBLD+93vHMTEq1Pg15SgcodNoDYE27qXS/BdmDqV12hKKmvfthSam5KBPkNQnMlzx8whVaakA22MTQujVtfve1C3C4+WDpDr+Yzx/84sR7I9y98ysBZSQrdWyW+2s95GmDZxdlXLqIN244VBlNHEcoVFcy52DMju7VWhSVOdGvGJdYKMd5X/xbULwyN7nvBPUowaH6Mp0a+O8az/363ywxBh4Lwt14pVUHmjPh+W7ZTKJF1TSf/P1t9BBngJOu0EcYuWvx3cHdlPQtxqsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i6PxN3/Qb/sNa9Zq7s/z45E6N34K+cZNBTrnrdyYdfbrqK99HJA64YCHDZ/q?=
 =?us-ascii?Q?+XTyQwIY2wnRsWP91tDLjQSCk/gxv+MWZZlGEzSkJqpOwkqPJGpkGdLIs1xL?=
 =?us-ascii?Q?RUU3MEgrqmS9dziQYh7+3e7qCJNhQLS5BCmx0ZASJ2hH0Zdyq17VnNBnxZzP?=
 =?us-ascii?Q?EVfGpXgAMa3yClK14VTBMfX/LjhMd8SW6JEg24p7TGos43ER0TLIGxumiRaQ?=
 =?us-ascii?Q?GbZ1BWAUhyPluecu1k/TToQC7abYjjJ6n+yxGzkqdKxt/c+WcaL9qRxPSRT9?=
 =?us-ascii?Q?cSeSY+mlGqEgVpvIXrDnMgcUii6fPjqLZlQAFlYOi+/MrbU5XL/33t6jl0dn?=
 =?us-ascii?Q?uqDCXGxS/USm7gTshFwOECWm461fUxsl28LVlkOeW+jWiUDxIIsaSVGHGdn8?=
 =?us-ascii?Q?2XoMkad/k2bqs06OSonzNyf907M+C4lE109OzRtvX68xc1B6vJF5pO/ayJBH?=
 =?us-ascii?Q?sIfuz0ZZAYj7WBVYBEH7nOwpRl4D1MglRE1YpRxRxxYjcf+Ods3FlyhYCWFl?=
 =?us-ascii?Q?YMJzltHiv+dS9UDBb/E5NN3AGHCw9uNicZIEtsVdJ7P0VOSf82WsZ/3yaj1w?=
 =?us-ascii?Q?RQTiOLM6JuCXdp+yMcA6L0W9TIzJlQjUlaul0T7dgLjlKBgDdcLOAsYwMYCi?=
 =?us-ascii?Q?sIYBVXGOAiz9+fwTwQeUq+hU49BBJuA7GeV6Y2JDlQchxjpfYnHR9OK59K6I?=
 =?us-ascii?Q?lkJgepH/ZQxfCyGR8GE0+QN8Sshx/DtIiw8m7CGwZABiWNWIhqIx66buNA9r?=
 =?us-ascii?Q?mFWdC259WwACHQ1bsG6gbWFwKNvye4EMN5uBNH7jLcF+XNlbS57s873KSr7j?=
 =?us-ascii?Q?JDH4YjPGENNdGT8E0z/uNwzL5Y8swj7cqeeTO9UJQMWNYM5VbgjQGg3A7a1m?=
 =?us-ascii?Q?kHR0W6lNldbduXVlHxit79Bu1/BPT0+VXMqzk9jQiHSaHkp/OvS8MVd4El1H?=
 =?us-ascii?Q?gkf6YmHp3rQ2C0k7zkZDgYv+5L34y+8IhDrbAhkv1WVhqLYEGDWqs6evQk5d?=
 =?us-ascii?Q?ZiEfjTmq8mqfXGrVxJTNWW7lyFgFN7yE9AStp/a/kCC64QZGBykx6IbWJozG?=
 =?us-ascii?Q?uC0irDsxGQdOkM27Ruyk7cbdProPIhvEh2zyUata+1vyEvVmJYkS4hriAT6X?=
 =?us-ascii?Q?WTqTvkuH00jyGe6NVsJagTCtdp2rnQD6qvjW9U+z0Zp67s9juEUvVa5igCLg?=
 =?us-ascii?Q?azihoFpb4BNuOH+6FUuITL1ehiUrHzd5y0nbe9bU7um+oJid/1Dpy9B8J8ND?=
 =?us-ascii?Q?HFMGEFZgvNnuGzeHvmZgpK/G/G+ZntyUXjxBpypvMj5CQCwVGbkf+hnDHPLC?=
 =?us-ascii?Q?xpVeqosjVm6qBID15Scq+2Op9t+A7S9f8aCFoVl6HkQH73gK6P05VEM+P/TM?=
 =?us-ascii?Q?kYtVB6m//fvIpjrTpkANRUQgHa/7aX/79DR7PI3o87c8o9WSdnkK0G7U2pus?=
 =?us-ascii?Q?De9oUOAH316EzZ1fl/KrbLGRXIgtXdpPY5V7oICLbvBPN0/y7eDArX1ZM5ne?=
 =?us-ascii?Q?AcTIMWGaZ4NXJ3KD1kXsMTIpdjLoRz0JMu7tm4EPLsvBNkJVEzEs6Zp7CF//?=
 =?us-ascii?Q?4nb3HHAhDFleSGeDDawuCWvS8OZE4MHWzF4eASK6SNIRxoCrAMkIPES3MT0o?=
 =?us-ascii?Q?qPDkyhc8bCmIGwkyCVRd3rg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd8e5ba-151d-4284-2d7e-08d9f795f22e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:43.7582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PHcOewKMpLFtqHlfqKOlXkxRuO1ONK1lWr5fF9jWfJIQtNQPu/DU45BfkG3W7VHtDey5gbM+JhM43l39rf8xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: p1kDsO1ISWHUaK5k2OV8zvqflu984SXm
X-Proofpoint-ORIG-GUID: p1kDsO1ISWHUaK5k2OV8zvqflu984SXm
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |  4 ----
 fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
 fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c           | 18 ++++++++++--------
 5 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d75e5b16da7e..e5654b578ec0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5c95a5428fc7..860d32816909 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,9 +336,11 @@ xfs_dinode_verify_fork(
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
@@ -405,6 +407,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_extnum_t            nextents;
+	xfs_filblks_t		nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -435,10 +439,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	nextents += xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -495,7 +501,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_attr_extents(dip))
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a17c4d87520a..829739e249b6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -230,7 +230,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -295,14 +295,16 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 2605f7ff8fc1..7ed2ecb51bca 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
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
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 87925761e174..edad5307e430 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -233,6 +233,7 @@ xchk_dinode(
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
@@ -391,7 +392,7 @@ xchk_dinode(
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
-	nextents = be32_to_cpu(dip->di_nextents);
+	nextents = xfs_dfork_data_extents(dip);
 	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -408,10 +409,12 @@ xchk_dinode(
 		break;
 	}
 
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -423,19 +426,18 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	nextents = be16_to_cpu(dip->di_anextents);
 	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		if (nextents > fork_recs)
+		if (naextents > fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (nextents <= fork_recs)
+		if (naextents <= fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
-		if (nextents != 0)
+		if (naextents != 0)
 			xchk_ino_set_corrupt(sc, ino);
 	}
 
@@ -513,14 +515,14 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < be32_to_cpu(dip->di_nextents))
+	if (nextents < xfs_dfork_data_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != be16_to_cpu(dip->di_anextents))
+	if (nextents != xfs_dfork_attr_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
-- 
2.30.2

