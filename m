Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99015C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJDK2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiJDK2x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:28:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6903136C
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:28:49 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2949HsRI029347;
        Tue, 4 Oct 2022 10:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=glTN2Q9DV0MtQfM+6FDm1vbpdyH1uwOJtosGtuFofnY=;
 b=qK+K1u0MNGZ8Vgi9jNXYD0POPa9fnJbyQtjD2fM4gOLxVCj9qVWCUCYOtl/MNuDWOIVl
 X3x9N4UMPpIJfULXVjQtDJ09ZMfhEkgYvhhAD/IXgQ00NG93dc13Jwc2hK5ZYwqy7awS
 tVFil8Na2ETkDTVhdfoJC1rHJ77YGO2POG+wspW8IW2rfJ8kgU+GsDR/vhLhhL5vE7Yr
 mNmrTH4cXu0c7mF7i+PBFAVzqflGCEx+for5+UpIAH5OHR/WjEEg6vfSpoyvn7dsSaQ2
 OoW36Wy94OJw0cIk01eO9GzEOavO5N5VGERrtDqh067UVyIQDHD4S81bBIcHJ3JNWja2 gA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51xb2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948B3m3001079;
        Tue, 4 Oct 2022 10:28:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc049n73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWjrH/2GZ+FDFOVtO6aRjaTjDO+W6K1KLCAp7bA2eCh4w3eJNdsCx7qODwfpoENZXPXIboQXTFQ5Jr4ZObkgpnXEqSDZbNmSq2upWkLY1VLGcAUCOYqxWx6O3emwtiV0CnideHyXRBvKzCr9uNBYBhPDP8xaUU81kODWQMd2PrV9s9qtYBw8JGiJnSUIXpM7pQn6uhemotrU5P6QxaiX6GhZ4mJyrM3q18Hr7Vg3HyHiVYDk5QQEN7w/LuZhA/IhS4kOn+sbkLbDTIp1TUylbNscFp2dFsnmgAe2FSMq18V3TgJjWg73vLPfdt0IVa8eZ+MMxdX7jwINfaidejzaxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glTN2Q9DV0MtQfM+6FDm1vbpdyH1uwOJtosGtuFofnY=;
 b=ErfzyS+s8gIHbBNS11SFoM7SgEyVAszmK8h7eCQzmHb9qZQ9iIvl6xcGbxQNwpAaUYTAffdit58BsPoHKJa3dMnu6o7AWQy7u7CfGmIJA3hEmYML/xLYRR4OXpr/0OIs09rmLi2q7dLYXIymIViFIh3zrpWXCByaAT7FxHqI9pC0bdIplg8RWcZp4VU9Yz/JBE3MK0hpBDgCCnA03i2N4CqcHa7FAaPw/pLgFQcvL0IuhYVETK7Vj7DxVFtfcrij1T1X6CFI0fEVTf+lwpef1K3nd0giliAkIFIhztMRt9tps9gqTxVVoiIpPZB8d7PK0Q6knClBYJ1zhzUoHiyd3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glTN2Q9DV0MtQfM+6FDm1vbpdyH1uwOJtosGtuFofnY=;
 b=oIg7QCDu/V12cunHE4qshy70IZ6m5hC70Jo+SvXJLgHuBCmGmKflSuMREuVkMR6kp8JWfnaOteztu7TWcKm3w0HZ0eyZaHmdEMyUeewAdIn/fU1rpK6jQd0460hpMLuqWeptqByhXsndiPLaDjhJ64QO1HolNUiUlkoZxT8iepo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:28:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:28:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 02/11] xfs: introduce XFS_MAX_FILEOFF
Date:   Tue,  4 Oct 2022 15:58:14 +0530
Message-Id: <20221004102823.1486946-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 82c85dcf-f5cf-44b1-e038-08daa5f3361b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W82kHNnK15ig09f9O5oyL/IyOnybtkM/Uoe8tyTCJZf3UXTv+XQpgVLDRZdMFuhxSwjLCah11Vk0UxjH7bCbfaiitiTdjc6B+8vjUm+QLVgNdbTCN9XI3C/I0iWoE5cQqlLDXruv6AwHwr83IgWyRBTMhzl5RoadJOXIMncV9uvx1stM2rVPAg5xuEW7W/usg2nlI6TvOoV/XjN1xt1oBpegjRQYi6krXdIcS7Ug+3hQ0PLRb9ao7y3ufgpFTPrGT6G+MtymhjRd/Q9VB+U2dirlfmRUjdhIw6BB/YbE9p35H16HDMtsFt0mJD2yQ4K9gLN0Pt1HySH3zme0Ooqp/c7i40pJsKQHx1mK44pcsLMHDkVTkirzwBxlPjKEDTvz+ymEWjieOjr6YsXkM9SKCMJeTFMAPuIJABFp2IfwZsJ+QliIcLJWWRh0bbcN9PJ9taGDizZErJNsRGZL6LfC30UmMdxMNP4dqiclZSYuzjY8iQYo0nsAyzGhdDpgzBL7EWFPOV+L5zNZSW8OwxYGfr4g72GAO37jz0ZvlXolFW12GrDbL20lOcEbn18GOnQMUA+copEDC3qO3cYLVwwehtRIM6XGzgdYrsib2yY1XzmQ3zZ+8SXCTV1S62K+d/T3CvP6R+1MZxDH4sRKnDaY6pXrS0O45mvQmhN0GhU/zshXRufs5sbF2N+rEqpEO/3/n3ZsCrSNmwcBSHPJJFN14A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vZTy8wcBlg4WUOjHDNLt6ZX4aLhxcakbxp9grQlgNHGkW5aw+AcJ6T+rJ6u8?=
 =?us-ascii?Q?5G2xstFcvcFOQ/u7xYJA2z4hO8t4uqFnRxEueOrY0/7FG6iwqtOfyeqALlor?=
 =?us-ascii?Q?WBXlqC0XbLx7NLdpSX30ee9vmXEay+d+P6rWq8TXdH9WjHyzjDk4/uuoIYm/?=
 =?us-ascii?Q?ok3A5GE3+3qWUAArPGNlopncVlSrs8/0jvriXq91fLBVOh6fQs3W+wND82zo?=
 =?us-ascii?Q?e0pK7onRgDB1No/HMJJhnGq9aCNS/B54lUn/ARfx0FIBrkE6ejQRyTacHkMg?=
 =?us-ascii?Q?dNhURihjpx6jR90KJS3PYSuLaEnFrbDjN76iEChiwKLMFx8gKNyLLCbsJkn9?=
 =?us-ascii?Q?kM1nc6qvr2EZvdqThB764r/FmGCmXjOxNeIxVFq5hFhWiqxaV44xXnmZ7IBU?=
 =?us-ascii?Q?U/RdmWdQsOpteRBcyYQ2jpC9drsrhUOkRwplz1yGIeeLxYDsnCc4P9SMIfVZ?=
 =?us-ascii?Q?prGYu1d318osJec85kVbCY4NqqnheKiGMUaxtwklf+SVisipXQJQA/5z5Mhd?=
 =?us-ascii?Q?45y3mv1iThRceRnqXnLbwft1pD/l+33WJeAUbXgRjUauu6+bvlkQMMn9K+1O?=
 =?us-ascii?Q?4BxJMB0lT0+Uo6pritrdalxEb3iQfWIuCUeIFfwbeW5YIaV7ZQQFTtnk2PK6?=
 =?us-ascii?Q?7Kcs7a36Tg9FRtlDszrBLKxwH8LCb1//fq3Tcp7cjzRKblK2OQm36WmDkYrE?=
 =?us-ascii?Q?2WU4FCsSSikdGQ1gFN7sFWT3F7+SYU1h9+kc24lAAsz5n3v902JP/Ye7gabZ?=
 =?us-ascii?Q?TTKH/+TYPnNlhyPrgQx/0A67m621l3/IPieoed6rqToftQKX792/3BD/Evz0?=
 =?us-ascii?Q?FUHSHXyW+KcyeWGzsxGt71O76lJQuVhRcByJjT8smyhU8MfpHzUOEfC9kKX1?=
 =?us-ascii?Q?z6dRS5sYevFR0wi85ngTpfD6URVG5eBjrulu6uBYnZzgd7mYkfnLeyTNyp77?=
 =?us-ascii?Q?51jgat+1vp+hdU3TFe+EbdUZMo/VZv2kMj5vyDeJQPZcu1r6aLXpj8vH3G9r?=
 =?us-ascii?Q?ekuw2Rbg7VpQJvTO7wRz5hJjspthWxGMBNVXwvft3xEdu2X/hjMR5rKhIDed?=
 =?us-ascii?Q?SxJylEe2mYdVq7ilHOc0iEILGDTbpZVGPMfVweYLhDHmgjVRH6zzYgiXwOgT?=
 =?us-ascii?Q?e5DJAWtlN9F1+HmMNGufVr+kAFq7eSMpgXpeRjM2yoH4gKugYdkRzEZTSDQZ?=
 =?us-ascii?Q?tSZkT2ikyfNhWS2EYPwMzbRm4N373gvL6uBTL5FuLRJW+ETI9Eh2gezlkD/J?=
 =?us-ascii?Q?UqtQovaDMUko0SFmH5uYMoTLctrC/4E/a409y9ZopTQYZyyn4dueKvf8QhPf?=
 =?us-ascii?Q?9384Yof5Amlm5R326T/nFmixNMjDrJhmRI7/R2a7jqx/DD6TxgccJP3uP1qI?=
 =?us-ascii?Q?tjtHkjKEtt8OwXzGTIUUMkzzc3Antm1x3Q6u0x9N6DYETOUTbXj152Ni3rbC?=
 =?us-ascii?Q?dsnCR4Ga85nDoKcS03JcgoB/bCl6AqO4nVNtMplcn0glYrRzYX3Tj2tBgsFd?=
 =?us-ascii?Q?9RhKW8JrafeQTWeqYhiElgWWSOZqMe2hmf4yEwZn+FFyd8r0fttgPQdJ+JKG?=
 =?us-ascii?Q?O+m2s6NS/yLvlsDpbw0+XT/JY8llMoZ3xEfIsT56oNc5TpPGZUXbWpJF+yNU?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c85dcf-f5cf-44b1-e038-08daa5f3361b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:28:43.2278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCJaujlr8W92H2wwmlQRzFXwT06zpL/b367L8Ghu+dxm68QWkK9m/jBzRJksRvMSnkxHaoP+08D87WKnAiNekQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-GUID: zeKHg3Jx_Se0UJVjxOKBzyme0EReEE92
X-Proofpoint-ORIG-GUID: zeKHg3Jx_Se0UJVjxOKBzyme0EReEE92
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5084865524dee1fe8ea1fee17c60b4369ad4f5e upstream.

Introduce a new #define for the maximum supported file block offset.
We'll use this in the next patch to make it more obvious that we're
doing some operation for all possible inode fork mappings after a given
offset.  We can't use ULLONG_MAX here because bunmapi uses that to
detect when it's done.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/xfs_reflink.c       | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c968b60cee15..28203b626f6a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1540,6 +1540,13 @@ typedef struct xfs_bmdr_block {
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
+#define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
+
+/*
+ * bmbt records have a file offset (block) field that is 54 bits wide, so this
+ * is the largest xfs_fileoff_t that we ever expect to see.
+ */
+#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK + BMBT_BLOCKCOUNT_MASK)
 
 typedef struct xfs_bmbt_rec {
 	__be64			l0, l1;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 904d8285c226..dfbf3f8f1ec8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1544,7 +1544,8 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
+	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, XFS_MAX_FILEOFF,
+			true);
 	if (error)
 		return error;
 
-- 
2.35.1

