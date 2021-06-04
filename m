Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5475C4743F
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D3FC613BF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFDXoa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhFDXo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NggwT041765
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=IkA7W9KOxc/ye7hGsDKFTAXjCjcmRFlWYXXURRz9uwQsmxictWvLnGRyZzD2sEBO2Avx
 aaWsygcpVmtYg2BnrPa3h19bFrRL6VAEyOw9Xf27xdOj+0mNDRjxtQVESilbC0cpnJ4t
 dpTVxAkY0+wYAB/emBj/0Fs/GCpdc9Bj4lAqhPPQbj6hpg5ds2CLTd9XXRD2jP3L1+GM
 KHwIunTzqbFFuoYa+qXR9/l/S45hMTx37gB7r9GyUnRBFPyJH3UUmFTKYDA6A2lCrS+u
 vC4qxOKjWjqhsgZYItuKG3g2Svtnfz/HsN+rap5DcYL2Tn5ekoSyo0VcAgR2r4L5nFU/ DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38udjmy0vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Nedi6056299
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 38yuymb0mg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Caw1V/PpVJTVVdf2iSjemGAt7jER98/6BneSsou47XhWAg0hzZljvB/brfj056Pp0i5etBxLMrGn50ZoqeVhjetOh3wTxa69A4neiCFAvYGfJRMM+48OFLgISTHYPrTpiCd8xsSNHaE298LSenYw3rlr4NHIzkdwLgSHOGs2bZgBjKzzjwPRNpzJd1ov+WRnRN6ZO21nMmuK1c9975f9WDonsq9aOOQ2pL2BxhnglWaTYRg0k6s8zJdmOb2DcEAqwnhmkACTDbF8oe2bvEhIOH70wB4o98TGrcBhSzCJWVv6kdM1bPJ7EoMPElFTMCP1tMRACJoLV0W49+27UzztZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=OZL+CgsNS1B419I+0WIWqiOfnyhIgQ8VNO5TTr7uNCPQUoSFUDFnSxtQhIOjNaSex0y4KUIFHF1j82WsOV/RwPPsKkBVdFAPSMr8U34JNuiT0DuujtJhGLTOXZ/1Eft4frbZLVWc6MyBSUcMIA9L1l0UjthDd5zMinR1AAfCFNbp7Vf287bHbJaM8LVx60UU1ajACqHu2xaPLjp5vM5D6p8UulXY53bYtBFJZ46V4RGoIqjKzU52DCYosPwGBRnXIM5E2kuQYQ6dm8RadsprwnosCw1OV6qkLkFMkL30X9zeUfy8sa+NhgwUOje4GiNu/hIsFszzrgELZ9X2MmsekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=rBSanHSWzjaRm8v1pHx5j9rXp6wtmvX/P+/s1MPng1xCv+fbkcH5O+UHdjlUIkm/7xHvtpu+RqqH2+vD7Hp6a4aPSYjAkGlgZ2w8qJowLx+++Ur1+/GuawHpkRa59TZSPXQWxaK7fVzxb/z/VbbMRyhbwme08sDjJs2SpYBivFo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2485.namprd10.prod.outlook.com (2603:10b6:a02:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 23:42:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:40 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 02/14] xfs: Add xfs_attr_node_remove_name
Date:   Fri,  4 Jun 2021 16:41:54 -0700
Message-Id: <20210604234206.31683-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210604234206.31683-1-allison.henderson@oracle.com>
References: <20210604234206.31683-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR07CA0095.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c256c427-b1d7-46e8-b06c-08d927b270b5
X-MS-TrafficTypeDiagnostic: BYAPR10MB2485:
X-Microsoft-Antispam-PRVS: <BYAPR10MB248595E860E7A583AC971F8E953B9@BYAPR10MB2485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3P0LB9cX549o8q47gPHqKyNU68MbZTfTXqbL7vBMyrNibEJppmXL9G08ynxxpM3MXc1E7mmxWUKzUkcGpFrSv2Q/uzlZjYerG8B2PWvj6QNWR1LZcAA4UvkT0AHft1ej92QTOFg5d7/hhfMJ+TXS8WVSkyOYEP4Hdes9fvWG1jQzeoFjA0Gg0xOh58SCNVS6y/ksBtYQiA8gCwF2klBracrdPaWDbqTwOlmK+OsMOFXwEa7PbD3AwZQCHCIY6LW/gFZ8VaI9tTvWmPcwmcTfmciAs0aKllUpvwBUUVl5z1bfL60vLJcAAAwTjVvrPiCwOvM4MP2QA9DGupRqsMG15tK96rTdyPuEKjlalENVuY8mqnQ0l56GeqSdFym2iln5YY4X0zKomFLga3sATD18D+9LcyRTACqKETs2DSgSBa0HPcBo0ADaIBoSI3YbKFYs4v0oJQPhc5rK9JJdcl924rGgU9gz5QTjajiwBPvF54sRLT9fg7C8LDcHEBzMTC4T7I453jUsIpNMAOHOlhiYXaNvpwSK/0rnDHaos03pzKcTRuIMPZaB1lan156WI6M+tS7puYe4Np/Gt6xA4WzzIcZEkhmywBDipZpvidAkbm8oOZLaSLp8c/QIKmbWRlSu6123vpMpKU406EPwbSGZgd+NbI6pdPlWrTbwb5lJUlsqwglZVR7Hp7kJelRNWh+G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(346002)(39850400004)(316002)(956004)(38350700002)(2616005)(83380400001)(38100700002)(16526019)(44832011)(6666004)(2906002)(1076003)(186003)(6916009)(8676002)(6506007)(6486002)(36756003)(8936002)(66556008)(66946007)(86362001)(478600001)(66476007)(52116002)(26005)(6512007)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?n9zd/jO6S6oZfMEO4xZsUZiEWr4LdHv0fwhVdqmG/c7pue8W3k01Xhh0wg9M?=
 =?us-ascii?Q?U5+ACFr9yZ8O546SHebo93CmkNVvVT+vSb0vCtoYAS6fXGqtc4/1rTI5CDaX?=
 =?us-ascii?Q?TDfqlOY8aCi/pUhCy/CDjVGU9UfCmpdNOMhXvQXpe5/Us0BOwYj3FmxywFuK?=
 =?us-ascii?Q?EYhYiAShdrTbt9dB8mkfh6tDyrrHXUHeiIsqZzXy9JFxAYjsA0+TDYwgSX93?=
 =?us-ascii?Q?e9dJ6goYUK6DjLSEkfeqs+yb67VzvFdlhenoHrj816de+Xzxr1jtoobMfMVc?=
 =?us-ascii?Q?YKQypCh5CgmHfDYE2Sdl4IYctzgNM4GYW9q7+d9h/vVE3nc0lcqHdV11bqLW?=
 =?us-ascii?Q?va6f2700+M/rg0pp/EDb7/YTug08lORPvYz1nZomIm4rByskSbMvcfWYxP0k?=
 =?us-ascii?Q?qxfehOWP7Rc1CX1FBlRCkUn6kzlpjcXWOJ2EgyLfbQx9EhZiMwPKAYitTJM3?=
 =?us-ascii?Q?NoI4Ob5IPkkCJxN0JcVs4aOjx/rsM2I4oKxMOpNVVrjcChr9NVxeLhvyCyYe?=
 =?us-ascii?Q?/HyWE4GXYmCqV2yVTOJjmm7FTZX/zJbGOZS3Cow6OwYGsy1ySzcr9OxtWy8v?=
 =?us-ascii?Q?PcMY1OGApoi+vsLHzcX6Em7BEkhPUgclWYFdFLhLDPYdDM29oaHyBMjAFM33?=
 =?us-ascii?Q?3XUEFT6p+m6tEmTjOHpq/ojtsxBlns4eZlCfWJT/uOpRHhCJoOHHoDxvTf7c?=
 =?us-ascii?Q?b9bOhjO5fg/gfKT+CbZgaFePg6XssdkTArnVa8bokD7NIgbejYif5CKVs+Tm?=
 =?us-ascii?Q?/JZIuzOIulmcwUUgfqJMs6Azynn8JivZrt1WxzTzeK+yYgCMilGwTiVUJ5NL?=
 =?us-ascii?Q?VM8EjWfWS/AoDTucRN4KvmX0k4fJnuizwxSLU6lE5giULae1jTcisY1GbhZj?=
 =?us-ascii?Q?Z//UqpZpto3LHcKXYDStKBGn5ncbOQgaKFbe2Slzu/vZTel9OYCd6UrMNbHY?=
 =?us-ascii?Q?4wzJBBmFomvcbgiF2qV15MYIlTx7jgCifI21XiBxtZLqFzod90wTs9kw1Ieu?=
 =?us-ascii?Q?FGbxcXGxR97F3A/DL8rizMTZ5DPTXqoFtXSk6EV4ZM44pYufc9qdjsMCi6UU?=
 =?us-ascii?Q?+qgc/m0FTW9Zjl6ScTYw41BaRhLG8ZSBFDzu+hpeK43JnOoJby7HZS0xJmil?=
 =?us-ascii?Q?WSrOdOwoRGAelZcmJ8BcVsBv78QHCBp9QhdrSsLj73tJSVCRgfqi2EcxIV0k?=
 =?us-ascii?Q?fCb+qCG8hddvUs37DtbdflGu+4Z41sVVubd/cRKdJUP8/oUN+0HEk4MMcfp6?=
 =?us-ascii?Q?irbb6eBAEglzwC23IpEI3pLQtScUkujUneuaDlZO4O3unRI92uFIP1jlcnVP?=
 =?us-ascii?Q?UAUe9CF0fKh/ml4X/2+P4QCO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c256c427-b1d7-46e8-b06c-08d927b270b5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:39.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2Z0UT5KmtH3ZI4Yx8XbQrih4aohpNP7RFmCt/WY7E+fh+87Tc+LBppmMnR/jYY8/izX/E5HpWaOjqCWf7qR2GAF06LQl9v7XUYB4eYy8hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
X-Proofpoint-GUID: 6lc5HtvJtKEJYH42s-5fdg2_8rcgY8SF
X-Proofpoint-ORIG-GUID: 6lc5HtvJtKEJYH42s-5fdg2_8rcgY8SF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch pulls a new helper function xfs_attr_node_remove_name out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 190b46d..8a08d5b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1214,6 +1214,25 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_remove_name(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1226,7 +1245,6 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1254,14 +1272,7 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_name(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

