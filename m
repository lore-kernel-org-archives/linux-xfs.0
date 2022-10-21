Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A61C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiJUWaJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJUWaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8013A10B7A6
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDjad030003
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=xMwKTIFsaR+eRVSLBWQG5r6hmqNlknxw9ETDYTSAm1Y=;
 b=LNUILGGU/XJREt8kMJUGmvYC5sXr57TIawSP0ckbmbk2kn9RIZUMchluxgCLsfa0/iRE
 ipAMaE8mMYazj1zf5dzg2mc6z7PT9U/VW+go2uiTqeSg3THfVjAI/8QFK1y/b2ImBZId
 bYDeak97Uu9YDc65vp0VlcsE7qq6cW3CM2Cz1e5yIvQkT7McD1U44j1sgZCyZvK9u+/2
 dols41YyJfbE5eLpPwqEw4TVdp7oCY5gliUOgvWCF+MyVc9Of2nP/L1XDxhFn3R28Gjd
 Gn/XOp+eGD3KOa8gMgZuwhIodh9Ityk38EM9rSlnIi31pzWllun/6Yji/8aFfl4+hpFX 8w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3tc2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LMJZRB014699
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hua4xcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIGCd0dpPskhoElDY9mr7xWhgaYXY54iwD7gMoyDXSjfrv5SfqiFh/VEH2POgJP1CVnYiMd7AngUnfhLMVMMjWAucBH7G7lhEWvAhbwqzYNIHaUaLXJi6M0LPcLx7ZnsxXMXxi+61dIf3feNieLaAmep9OrMdEGpRbH04SCln09Eo4OTkcPIm9Fb0ziRifvX22b035nwdJmu7fA0VkXp/qwhWmLmddZB8T/QjI0hVAAWNFdUy49wao+qVKCFAWvMl4i2KgGh6xqtYziBni1NvnBnP6oqBwvQzNSBLXUX9oiUOS6VIDRXlkrRpVINIbKGN7B3LiDHG7KI1xOsqUn85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMwKTIFsaR+eRVSLBWQG5r6hmqNlknxw9ETDYTSAm1Y=;
 b=AQyOfojVoOUIgnUWQvh9ZmLCNWWH0iPEhTbvnLkm6zNtNEti1XryX0gN8vvBtYRoilDRjtK9hYMgNr3t935/qgbLYapIFAJ6yByKxGuEa1DLYSQPt4ERna1GbPyKpjcHa60/v+QgssaTOqtRKzYpWz1xWqXWc/fhpea2jXqTgZzq9bn2893pSf//6f+nDno9R+owolP80J8VaskVykuFM/W8WjRuWNNe2j49h9RxxqotVEfuDU6uLNqNqEeqyZ9ZqreCQJJSd1ziJpMLt8tohmTqwzYMpE4ZQXKq4E5T/iXVomvkkZjV1/Pck8bYKw3n8L4Pq2wDM0Nyp83nF4m+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMwKTIFsaR+eRVSLBWQG5r6hmqNlknxw9ETDYTSAm1Y=;
 b=suqgwRh3LgErjBAOsJneCZURqLcea5rI2INbw3VEdniz0MkXwUNxbyumjdoWa4E+s0RT8J6Jm3OR1dQkr/JQAEGzV6oFoXaD4ad8sWWZTPJftmpnpaTYC8FZ0w1uhAKoM7yBVX7ig18rIkWN7OWvvRdzxLvyemex69PCwuvLVM8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:29:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:57 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 13/27] xfs: Increase rename inode reservation
Date:   Fri, 21 Oct 2022 15:29:22 -0700
Message-Id: <20221021222936.934426-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: b0621621-13a9-4a32-94a0-08dab3b3c889
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kT8OMbF8q+FvombBh7V0FfRk2e1NPXplnQPtjhyN+CsOYirmXPlixldd4Ifw7ephyVeT+7r/+8c98BESzQe4PqdoEvZR7lmk5Zzy06Xbz37+wZXD9ImLk+xtlN8mJzDL3HgekBhb7Xjog9o9tu20rrLVo4UxWCDw942qZyAq9QVKq73CxJVNF46N0dXI0Y1vDI8wUu+AXfcaimWiDoi34TVlPsFC6akifii7rS2Mqx7PoUlO1BLtuA5ZgdWBP4uDKbxsnQrIK3mAY1emaFgkiBSWS4RIXDIVLWZt6IMvMnm7p8LiHfEgcB+648fydM5Th8O83tNBFhvl0ERV+MzQXGjXwxH66FDOvUiQy1F7rv2jSFsHsY3pTWYYAPd0ub2dea2fVVV2mnDBp9SjTrBBfSGoi8QKYNTY9unDKAV5AQaSFqakX9bYFrt8+OgmHjKuNPYqxIcL2dgWPusLy5FfHJbcbYFwcECwBhgJt6V7q0q8Wgnt/vDRANXOtkdFMYir0PLXCYcJ2Q3BJw1xAN0GAsn/j6v/WTa8XopuFTEBvNh/RIW+IoBypnsiZQsMjimjF++tn7jB/j7kFxgSGKBjUgimQvMqqsyoCOj2m5khoeqmvt4lbiKRnVjmathb2YeZXPTkVALlaLQuAfDvd65elKHUgsR7e/zJZedQQK1mzLYoqSBjm/MAQ1+dFoN0dA+zMovsCRaqf93FBb32LYlFrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wqCx2wh0gBMBlQ/wKlPuapFWlNW1PRAvMcB0Idxz0domtSr0VYQE4M18JnoU?=
 =?us-ascii?Q?B90Cc2oJc9/cRsh9d959M3AxfJ86SoQzbQ+IR9hMrjhapEfK+ZM8dDrkxEZc?=
 =?us-ascii?Q?ScLGXR+CN3DGN1IN/UO/dSw6mf3aYfEZtp79MU3XBcLeM89KJ1kLvoEXlg9G?=
 =?us-ascii?Q?HKprHEW3zYnaAIvVPubdTMZDlwUYiyzMBV6xE9Dl4ngpeQ+DBwc/GMLvipvv?=
 =?us-ascii?Q?9aU4CfQmXpa9WJJ2cjUMge5Cr1t6Vdhqmc4ENyL9vJyHv02pXUOh7x4jx8Zx?=
 =?us-ascii?Q?vTGr5eEiY3JDGAytnRxiz4HDmVKPxRiswsby/n5xNpUOAGJnZ24o/WxFKjIi?=
 =?us-ascii?Q?jd1tBGrN7S92mmFPcw89SNCSU4UHT0aYbV3J1FEZaEBUVs2oxlMZ0+Zmaawi?=
 =?us-ascii?Q?TAN8fMIih0gjEhzlM0pzd5r/Bk3I9daRPrhjis5KE9gu/sep5GE9aaKwIi+h?=
 =?us-ascii?Q?SLiP/KsIx3I41pIlGEON1s5n901+EYIaSqw4tQUPxTk7mkfQqnyd2f47CTxb?=
 =?us-ascii?Q?UibyPNQK4VOrWqY2KBg5aUl7w+y95BJE8c5WXOpVOzSHbXuMRh4mGwW9jETw?=
 =?us-ascii?Q?PtkGHZJ13Bqkmd34yrawyS0GjKC1g4Q73VONmEmniZhoW7Lkk8ljyE3Blk2h?=
 =?us-ascii?Q?woomPb4fgoZ3XdrNke2Y/kcTjyffXRopdpuh8ntKoeNp7VjKCsbn+Pne9u63?=
 =?us-ascii?Q?2DEJbktOT7t/mR1rX04SjtWYHyauSXdV3IUikAF+kmv8bU4zDoELLyPwrLmu?=
 =?us-ascii?Q?BOn7McfdgKoLjcJOVBFuDry5rKhvJ3uE1ZtRUU11K7dXOMe4RZBb+MGWTpe0?=
 =?us-ascii?Q?ZESIHhbtTLVu+u02bri7rA8q1aK9xytg228UyVtFtfSHVCRiYst95pch9MMg?=
 =?us-ascii?Q?Ya1lEoh8WYC/LwuyjNdzksf4ObalNQ4Zt2EILIf6bqWGq8e1DiVcxAItcTPB?=
 =?us-ascii?Q?TBtMzTx3Jz6DdsrNIL/pG2BsZeXa1iWGwJ9rsXauRPAmGiceCXO9u8TB+HN/?=
 =?us-ascii?Q?CAnJBlW5+yCcIn39DP554op87dJGCu+RaZ845+qTonDSlDeiGlWzeUION7nh?=
 =?us-ascii?Q?H4B94og0k6mUknpNxVeYv2IppxGZQGSA0w+wmasuhSYZDyukOU6OQNjeluTd?=
 =?us-ascii?Q?OXgfaP1uIMJTsZiV2Z3L+PmvE/3JxBDdv7JGwenkZSUNM74dpH+1TGH6sH7x?=
 =?us-ascii?Q?KGNsmt+Y+Cb5VkFLMnZkP8aq7M6yGYssVlCy8qMuSHzcVcBJtyTZ0EQG55U9?=
 =?us-ascii?Q?uWO9ptGkqkSU4BmGdmfahWNkBN6s75k5R+T0MMPMC9dx5oXDZJOw8aZiJpG6?=
 =?us-ascii?Q?z02WD8anmSeuuS6/fhNrVHSBUSCVv0JcwS5oc+4ZVn1hJV2bw8n1iWuMVgan?=
 =?us-ascii?Q?a7UlpSRh9LcRr3FV7ufzZn8e/GfNVKDgZ4msJ9M1or9abDN9oVN2E6EN5Xqi?=
 =?us-ascii?Q?+SimLI/GW6VlD0lZHgf3AzNm7cbt4iobwHgabY6BgEjGHwsmKEvVz89HnGqE?=
 =?us-ascii?Q?dZ2kMugsIgvWKS9sw/aozzpQ0d2+VxBqXRyRFncz1qVGYD6IWXATkqMiJ1L3?=
 =?us-ascii?Q?fuT3/+D1kalD72hjjmtGlEtziKbhzQJdcsHrk6p9OzsyY2dXcU1M+tNqGCSy?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0621621-13a9-4a32-94a0-08dab3b3c889
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:57.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsuAGy/8gyeGp5yFvxP9Iv120w4wjOsUu+5Z8K7nXRRg347vCuS1+WisPAcq+irAuA/B0yYz8no9YFV4upsa5RcZtD2ejyeoIejwOphed3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: GfDktbCUwJ542qxT6xfYNM_h37tLwAUP
X-Proofpoint-GUID: GfDktbCUwJ542qxT6xfYNM_h37tLwAUP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

xfs_rename can lock up to 5 inodes: src_dp, target_dp, src_ip, target_ip
and wip.  So we need to increase the inode reservation to match.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 4 ++--
 fs/xfs/xfs_inode.c             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 2c4ad6e4bb14..5b2f27cbdb80 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -422,7 +422,7 @@ xfs_calc_itruncate_reservation_minlogsize(
 
 /*
  * In renaming a files we can modify:
- *    the four inodes involved: 4 * inode size
+ *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
@@ -437,7 +437,7 @@ xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 4) +
+		max((xfs_calc_inode_res(mp, 5) +
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 71d60885000e..ea7aeab839c2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2848,7 +2848,7 @@ xfs_rename(
 	 * Lock all the participating inodes. Depending upon whether
 	 * the target_name exists in the target directory, and
 	 * whether the target directory is the same as the source
-	 * directory, we can lock from 2 to 4 inodes.
+	 * directory, we can lock from 2 to 5 inodes.
 	 */
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
-- 
2.25.1

