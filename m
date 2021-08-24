Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDC4C43216
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 943A161368
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhHXWpf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28566 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230292AbhHXWpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:35 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OJtEOs001055
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=DVh7eBi/ZV4ynP5Wciy32Lz9Ep6dkrzfquYLT7uBew4=;
 b=oh3Y4r+6h53Za/mx3zFWZljgx4QHwrYUaTAVrPmxORW07/o5POUPtODN/hXQjWNXbgOS
 G4pC6nc0WwKHFGKVdXMKXpWiE+aFBtN2jIHl8Ggwb1qodfOs5uuuaReITwqx9kj+UfdZ
 /IB9D1/E8wGPyJsh6BjBIi+nGPr08hcgFavoV16rKL4G6SM9pg/9Z9m9Vx6ZBE3ieMoH
 jYyO95LQ9DT0raMaFDtWYEjh8RiRAG22uBQrdoq9IS9JWp/LghudQJaeIZ4S0ZM4P+Cz
 UpfLHCsD17bKyfyp+DhzsjfTa3rOa0u5knCYjS+5uI4AYEIln+sjE58xcpXwbxoKiTjn EA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=DVh7eBi/ZV4ynP5Wciy32Lz9Ep6dkrzfquYLT7uBew4=;
 b=yTLXupQ10/HggsXM9/kNVwjFivVYX5u3sbkM3Zec0zasTsn/R1dJ1ZSvC0SwtEVE/W+4
 YPefdkVhj0jMkz7/9E8k0zdHsvuygp4kFIbdnW6HJD+4LHQl2mqBHmrqHEKl08tPgSsp
 9SHB8IBMxvi396EXuubevxMBCqBbN4VgLeGYcjDztxxiUuWHRDnR35u7HduuAxq652lx
 vuih2BtZmEh5tmnnyfplJWv7/R9v56pn8AJ4J7Sd3ierH9It1zP/MoAo5El+pPEOSj42
 rqcfVTHbm8zNp5K9goNjw7zmHAkSEwqecyIwrxa0ENoaI6TbCuPaOPpmD22VRTcbpScE CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amvtvt4uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfYQ0025324
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ajpky4yms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KROI1RJEPfVtS2hGt0ndP9SCRE+xHo4vbXAgDqM1UErGNhAYGBV57S6QQ/IJnBUKAhNywDZFxA/YNXmW0YGfF3R3lPcMurisPcmPHmnbcrl/86OsoScN36DpY7JR9auhAkWKQorg6be9ld6WOO1C6rPcjhJsbpgeyX/CT/1+1JLpv0KIvoFNkQVxpbXO8Ze2UJc6PHECRLqg77rVdv96zJvnmVGl0s1UzQcEFK8eBxU3EAARXiJwsSFJq2mcYJj8ng3TYfgwzwfV1rQYiV3ZEbdgYXCr4vOa8iSpmeclrrXp7e41AdcWvg4SQT+c1JzJpjaRRhRt4OuIk1Fkv/nXxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVh7eBi/ZV4ynP5Wciy32Lz9Ep6dkrzfquYLT7uBew4=;
 b=XC3pmRtEdnxxNTiQrBftbgwzpKRJ1n2c0QUZWyJXT4TTn73Y6GAYh2ChWZL0jbIbcdu0DL+sjz14x7nPp/MMtNAjdbAh+Bf2JdovsWf797vzO08nTY4HhuAsk1yWAPAbzwb0dR+r6ub5aySZBMVlwv5Eren51RKGdxdd0JV4mLs85Vp0PiOWEx/wSHiQ+NH7oJ93Dd1P5sQuk8V+XA/SndCPrTp8wFCEuniY62L7u5UFesZwvpHL0Kmgufxbev0PVKvd8AZAAfHFUBp9pPhyKQzkq8vQpmAfJVZhx2+Lly8on3V57SPHSsbW+ywxCH6el+GONQ1ZxLY2FqRIx3rNEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVh7eBi/ZV4ynP5Wciy32Lz9Ep6dkrzfquYLT7uBew4=;
 b=0JsWd/rrcPvF+VM4DMUdQomNWGAVEfWqIGZJdzCQ9/xtSCCNxMQo4eLdYwPdc93L3dYtBOikK3+UeJw/ksvCNbdUEY9EgNuy21x8WVPTcsCHImPkAmR3tHzOXFSx7MvATtjU/CvBKb9LAHsKdDM9WS1u5K9Jp5aG9WwmSPDsxMI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 04/11] xfs: Implement attr logging and replay
Date:   Tue, 24 Aug 2021 15:44:27 -0700
Message-Id: <20210824224434.968720-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 240f73f6-3d36-4012-686f-08d96750c3b1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4653195F5DA26F53BEB57FF795C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:207;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kGPs4buA02nEAji5M+8pc4sJpmFB/m32HR5Gg3ESYoLNIUcL4XgI8msSAqPYKbri2NSDA2MdGRZ8VzEmEeGzH/YwFu15gG+Ln/lKXHmK6na2vATtJ9R+2mtINQGge3Xolhp5hCMhw0h9W5tdIjdhjITwPbfDVtEqm0e5pgrVq4+Krlm1gd6XYDRFXmjJruMFf8/XcxnCmw7mE/3t4sz5+OUHFKfNzuLDDCJeYMcRiQESwAa5YBLY27f7LiEMN0TAC0mEZwswMHZJjg9AlSJAtA/H3wd21mue7D1Fv0RVyHcIW3S0VISoBbr5SW6Sd024Y/WHZOGqqbSa/MrbqPGgwzFjB7FAISuwAKT3hwywwhLuFbI7mE+zH1DAirU8cp4je4FnkJOSAxnbi2iOkQGAQJTUd2iSYgZ/+Q7rzTKIHluKa2jfHeG+YyxPFPwG51Nw3zg2DC6PvYVrro9V0vPzz11tZbEVt3uApHRQQaOt67XSXSG2MO3RLyagFcNW6RawvaowE63JP+V/Qea4OhNVNnLbdIPHNgr3RxlegZ45Ym8HwN+NYniPS7b2Oocx7pU2us6KDFWUEf6HxQe/cLZ0YqS/5fMoafjCsCh2JcJ4lsjNpC+/ZZ+Tl1TnylZ4fAiqLYdSHAjjwCleQBX06QwU1Lq/vGI1czQTPexq49S/jKHKwCr++7cFLuA5CDPJ6zXkjRSZ6WlTfirfs2LwhsmbWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(30864003)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fEo5ob5x0kFxg3EMDlcLOW4QSxazXf9zuMKSmvlydJ/KY1xF6zvbWe+S8fXL?=
 =?us-ascii?Q?dXXlx5gzRVs0BO941SfGT0UiMiwd7Dl7GlEIruI1TEimgOhAnAUcTjWNbStf?=
 =?us-ascii?Q?GA4uMuMfcsv0k+8EWfM1HRFXD7owtrNY5Ye9lmvqWdUpS5zE8JoQT2BEjz/D?=
 =?us-ascii?Q?zxhDiPr+Jk3SGbMK8hGKN6C4TrI54f89FSCwg8HOrX2DiXvlULPQhyUUb3jt?=
 =?us-ascii?Q?miaK6c580fIrnM/rmNHMj1cRfIgK9H6ZAjr8k0lobtAfQAF5yhVJ58voJ54X?=
 =?us-ascii?Q?YuYbXon4OLAI4lC/UWCWLvCNhJWk7THEs0d5Of+dzGGu1wdrVH373yvbgrlz?=
 =?us-ascii?Q?xjKAdhzUtwCdxQPrOsXGXmSVgaG0CFIcj2ZMqspQYVFmuJEfHbTa7G/Ay/OK?=
 =?us-ascii?Q?zy/C8EOynuCAXnkMN0PTgOrI7HMaOugaXLB/UNMrI/n03B/i6HL+fKZRWaYw?=
 =?us-ascii?Q?TuvknYiDIiapFPvE4BPtQaOObcN2rBnKIAm1dxk4VD7FlwCVMfQUU55gOfvk?=
 =?us-ascii?Q?hxTs34W5iP/hUj6tJ4Q+QgVIHg+jz4fXUC3nLo8bDi0N7au8cL1j84FRB3P0?=
 =?us-ascii?Q?OGOmxKHbvnWmdqxyUSJYFYebk1aK3eOXpc+QqdX8CoKOulfyYdDHNaIvQIQX?=
 =?us-ascii?Q?3Wnb1W/JQBcnonYMArsW3yHhz0DQKPZMEnLMDHTu1YDeyDYjgqd5zIR+RaTa?=
 =?us-ascii?Q?0viaR45UsDf+EXZ3rA38wgX8Ph1BUFPdrEkxvOpp+KfG6khrKWqw6x+PJ+Lp?=
 =?us-ascii?Q?COqYJRT0Si0s24RM4PySp3+53EHNd7bId4rKfZ2cBXBBDVVeM9afEseyuKYw?=
 =?us-ascii?Q?vNuVzcRDEehR6VZ/+C/HuZU4IZUzij+tnJlpAIrEm0guD4IpBqgn32B5bCmZ?=
 =?us-ascii?Q?QmVartOGpP01xZsv2GMhSqIsMzyGCkK4ZiVEVLsKUttF/ED0lcjTPknuFmtZ?=
 =?us-ascii?Q?dX5JVocq2LSHiVJePXU+Jwe64kuIAHyWVm4o8rKarm5cnSq/Wm1DBWbOMv5p?=
 =?us-ascii?Q?bMgCSwntIb2HJk2OGv45mAu6iX8LBIAtQgjuWgptG4hrwrm3eK0QuSm6Z/Kw?=
 =?us-ascii?Q?tq2cZaRRWdBxSu2PHY7Hu5UWtOM+GzRxQEpX6AGjrq2v2xsPM5WvsqMj65Hi?=
 =?us-ascii?Q?qGnousPG231KKQJdhMl3k6C2ycqiPUW1DoYzo8493Mhv4bvzvvtag6Ir8sth?=
 =?us-ascii?Q?74XJcYRmA0Lv6QjuGsjKuaGQ/SGBRFR2DGFE4iC0pAq3jJ71SQ/6L1505soH?=
 =?us-ascii?Q?3TDDfMFnq7whbPWc8u8sr3ELXHF8UR6bI3FkgRfF9734A786XCutP9KGeeWL?=
 =?us-ascii?Q?e8qLeSmrdrt025gbH5dFVKoT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240f73f6-3d36-4012-686f-08d96750c3b1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:42.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQsMjBHdnDE7ic/Krx+7u8Ny3AJNAXqCLolwGXhlpguapVL5/3IiCORtS2flmbKq8+6TYBe7vwxx4IHVSV16Sk9hLMhRzVKPE2JGDqTAItM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-ORIG-GUID: 357oV0BzIncG-vpjNH9811oBjyPMxCUZ
X-Proofpoint-GUID: 357oV0BzIncG-vpjNH9811oBjyPMxCUZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  |   1 +
 fs/xfs/libxfs/xfs_defer.h  |   1 +
 fs/xfs/libxfs/xfs_format.h |  10 +-
 fs/xfs/xfs_attr_item.c     | 358 +++++++++++++++++++++++++++++++++++++
 4 files changed, 369 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index d1d09b6aca55..01fcf5e93be5 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static void
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 89719146c5eb..d70525c57b5c 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2d7057b7984b..2e0937bbff6d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -413,6 +415,12 @@ xfs_sb_add_incompat_log_features(
 	sbp->sb_features_log_incompat |= features;
 }
 
+static inline bool sb_version_haslogxattrs(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_log_incompat &
+		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+}
 
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 879a39ec58a6..c6d5ed34b424 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -275,6 +275,163 @@ xfs_attrd_item_release(
 	xfs_attrd_item_free(attrdp);
 }
 
+/*
+ * Performs one step of an attribute update intent and marks the attrd item
+ * dirty..  An attr operation may be a set or a remove.  Note that the
+ * transaction is marked dirty regardless of whether the operation succeeds or
+ * fails to support the ATTRI/ATTRD lifecycle rules.
+ */
+STATIC int
+xfs_trans_attr_finish_update(
+	struct xfs_delattr_context	*dac,
+	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	unsigned int			op = op_flags &
+					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
+	int				error;
+
+	switch (op) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		error = xfs_attr_set_iter(dac, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q(args->dp));
+		error = xfs_attr_remove_iter(dac);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+
+	/*
+	 * attr intent/done items are null when delayed attributes are disabled
+	 */
+	if (attrdp)
+		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	return error;
+}
+
+/* Log an attr to the intent item. */
+STATIC void
+xfs_attr_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_attri_log_item	*attrip,
+	struct xfs_attr_item		*attr)
+{
+	struct xfs_attri_log_format	*attrp;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
+
+	/*
+	 * At this point the xfs_attr_item has been constructed, and we've
+	 * created the log intent. Fill in the attri log item and log format
+	 * structure with fields from this xfs_attr_item
+	 */
+	attrp = &attrip->attri_format;
+	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_op_flags = attr->xattri_op_flags;
+	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
+	attrip->attri_value = attr->xattri_dac.da_args->value;
+	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
+	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+}
+
+/* Get an ATTRI. */
+static struct xfs_log_item *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attr_item		*attr;
+
+	ASSERT(count == 1);
+
+	if (!sb_version_haslogxattrs(&mp->m_sb))
+		return NULL;
+
+	attrip = xfs_attri_init(mp, 0);
+	if (attrip == NULL)
+		return NULL;
+
+	xfs_trans_add_item(tp, &attrip->attri_item);
+	list_for_each_entry(attr, items, xattri_list)
+		xfs_attr_log_item(tp, attrip, attr);
+	return &attrip->attri_item;
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_attr_item		*attr;
+	struct xfs_attrd_log_item	*done_item = NULL;
+	int				error;
+	struct xfs_delattr_context	*dac;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	dac = &attr->xattri_dac;
+	if (done)
+		done_item = ATTRD_ITEM(done);
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	dac->da_args->trans = tp;
+
+	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
+					     attr->xattri_op_flags);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
+	return error;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_attri_release(ATTRI_ITEM(intent));
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item		*attr;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(attr);
+}
+
 STATIC xfs_lsn_t
 xfs_attri_item_committed(
 	struct xfs_log_item		*lip,
@@ -306,6 +463,30 @@ xfs_attri_item_match(
 	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
 }
 
+/*
+ * This routine is called to allocate an "attr free done" log item.
+ */
+static struct xfs_attrd_log_item *
+xfs_trans_get_attrd(struct xfs_trans		*tp,
+		  struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attrd_log_item		*attrdp;
+	uint					size;
+
+	ASSERT(tp != NULL);
+
+	size = sizeof(struct xfs_attrd_log_item);
+	attrdp = kmem_zalloc(size, 0);
+
+	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrd_attrip = attrip;
+	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
+
+	xfs_trans_add_item(tp, &attrdp->attrd_item);
+	return attrdp;
+}
+
 static const struct xfs_item_ops xfs_attrd_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_attrd_item_size,
@@ -313,6 +494,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
 	.iop_release    = xfs_attrd_item_release,
 };
 
+
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	if (!intent)
+		return NULL;
+
+	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
 /* Is this recovered ATTRI ok? */
 static inline bool
 xfs_attri_validate(
@@ -337,13 +541,167 @@ xfs_attri_validate(
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
+/*
+ * Process an attr intent item that was recovered from the log.  We need to
+ * delete the attr that it describes.
+ */
+STATIC int
+xfs_attri_item_recover(
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_attr_item		*attr;
+	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_inode		*ip;
+	struct xfs_da_args		*args;
+	struct xfs_trans		*tp;
+	struct xfs_trans_res		tres;
+	struct xfs_attri_log_format	*attrp;
+	int				error, ret = 0;
+	int				total;
+	int				local;
+	struct xfs_attrd_log_item	*done_item = NULL;
+
+	/*
+	 * First check the validity of the attr described by the ATTRI.  If any
+	 * are bad, then assume that all are bad and just toss the ATTRI.
+	 */
+	attrp = &attrip->attri_format;
+	if (!xfs_attri_validate(mp, attrip))
+		return -EFSCORRUPTED;
+
+	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
+	if (error)
+		return error;
+
+	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
+			   sizeof(struct xfs_da_args), KM_NOFS);
+	args = (struct xfs_da_args *)(attr + 1);
+
+	attr->xattri_dac.da_args = args;
+	attr->xattri_op_flags = attrp->alfi_op_flags;
+
+	args->dp = ip;
+	args->geo = mp->m_attr_geo;
+	args->op_flags = attrp->alfi_op_flags;
+	args->whichfork = XFS_ATTR_FORK;
+	args->name = attrip->attri_name;
+	args->namelen = attrp->alfi_name_len;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->attr_filter = attrp->alfi_attr_flags;
+
+	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
+		args->value = attrip->attri_value;
+		args->valuelen = attrp->alfi_value_len;
+		args->total = xfs_attr_calc_size(args, &local);
+
+		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+					args->total;
+		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		total = args->total;
+	} else {
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
+	if (error)
+		goto out;
+
+	args->trans = tp;
+	done_item = xfs_trans_get_attrd(tp, attrip);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
+					   &attr->xattri_dac.leaf_bp,
+					   attrp->alfi_op_flags);
+	if (ret == -EAGAIN) {
+		/* There's more work to do, so add it to this transaction */
+		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
+	} else
+		error = ret;
+
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_unlock;
+	}
+
+	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list,
+						 attr->xattri_dac.leaf_bp);
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+out:
+	if (ret != -EAGAIN)
+		kmem_free(attr);
+	return error;
+}
+
+/* Re-log an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_attri_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_attri_log_item	*old_attrip;
+	struct xfs_attri_log_item	*new_attrip;
+	struct xfs_attri_log_format	*new_attrp;
+	struct xfs_attri_log_format	*old_attrp;
+	int				buffer_size;
+
+	old_attrip = ATTRI_ITEM(intent);
+	old_attrp = &old_attrip->attri_format;
+	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	attrdp = xfs_trans_get_attrd(tp, old_attrip);
+	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
+	new_attrp = &new_attrip->attri_format;
+
+	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
+	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
+	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
+
+	new_attrip->attri_name_len = old_attrip->attri_name_len;
+	new_attrip->attri_name = ((char *)new_attrip) +
+				 sizeof(struct xfs_attri_log_item);
+	memcpy(new_attrip->attri_name, old_attrip->attri_name,
+		new_attrip->attri_name_len);
+
+	new_attrip->attri_value_len = old_attrip->attri_value_len;
+	if (new_attrip->attri_value_len > 0) {
+		new_attrip->attri_value = new_attrip->attri_name +
+					  new_attrip->attri_name_len;
+
+		memcpy(new_attrip->attri_value, old_attrip->attri_value,
+		       new_attrip->attri_value_len);
+	}
+
+	xfs_trans_add_item(tp, &new_attrip->attri_item);
+	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
+
+	return &new_attrip->attri_item;
+}
+
 static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_size	= xfs_attri_item_size,
 	.iop_format	= xfs_attri_item_format,
 	.iop_unpin	= xfs_attri_item_unpin,
 	.iop_committed	= xfs_attri_item_committed,
 	.iop_release    = xfs_attri_item_release,
+	.iop_recover	= xfs_attri_item_recover,
 	.iop_match	= xfs_attri_item_match,
+	.iop_relog	= xfs_attri_item_relog,
 };
 
 
-- 
2.25.1

