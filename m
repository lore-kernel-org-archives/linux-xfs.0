Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E541C433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07F8361A42
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhCZAdf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhCZAdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OopG057478
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=B9sWea3/YaG96nhmVZAVqAHTn7obC4YkltX7E1wKzB8=;
 b=BQKjJhxEXbOsy2k8Bw52nAwsWrE9spl5f/IVDNrO2KDj6lI6aFhIaN8JDM/r8Qthg4CF
 dk8acD2cjDrM7TRIJ0/WavCbY6nW3AsUmI82A24xLw8Rtmt7VSRnLkqLFgAdAj3mRi6P
 XZOmUYiZlCXB19U4C0Jjt+V+uNq79ecZQ03Ebcrz+0LuRXVe3auSnIMvspmxDYvO42vr
 kQ4i1U/kqomyBw11Peb33Ci6WWcKSnrzO1pflr+qWjADdjA4FokdfK+Ut1qJlRvfv6Fu
 Uuhe9MOKPbWh2P5nw/QBiMjoNDzFxvJzu4T9iAl6VrHVNgBXw+NuYaNqC1fJIw0Nw9qw 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37h13e8h63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0QXnB076081
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37h14gg490-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMWtlg+pefF9w+uVCztEI0GoH7iDh9fj7m4fF0E4+tzOKkvYpWl5AO2bRuEw/UoV7uxG/xmzkt4uioR31muPN9LQzEOjAkZ+HEIfUM4sxwV7974BpI/R57FOvQG7OhRK2Q5gQxRfS6fARvO5rsUbi2tdPEKOQMp9optn5bpekVj12u8h71poxCD/OtmA5Mm/Ug/uf+MbD0DSAiPHcyROtL/GSalp7uVDpGU+Nx8Dn3+s97qftT0iLXstNu13h15RouUNHaGZ00rx2X/5xTkue1Vc1YqgAcUKsI2san5ZbZfLpkakJipTd8yHvIb2Ec+nctYTpqI2nIVCENN6K+YnfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9sWea3/YaG96nhmVZAVqAHTn7obC4YkltX7E1wKzB8=;
 b=id6CJ+MQNWUo3IrMUTP4B5aZclBzrWOr4WulAn9LZgZqNLcncH7V3Rmm+6s9BdmS49+SD/fMMuHgPL5dz+jM0x48uEp59HuLwGObeysg6MkEHcH2mr2xJlmj559CvR1DQ16Nc2PUUfra8soo4r2jESZJFEAS9y+EcVaD8/Kn+h2GdlVtKOUiJpg3MwBOkyekE23aXVferfv3nWapj3Qcje3220N9fBbcnayvrQ9pE72+vk1K5r0Bi4EZUIk+spRZkxE592mC69lppoZAP8Tv6dg5yrN0QzEtu75bGIOcCM69F1qSC7FT03hkTN2xh+gZwLRx5jgK0QyD67KRIts5/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9sWea3/YaG96nhmVZAVqAHTn7obC4YkltX7E1wKzB8=;
 b=kCLMfLyG1DcBfo9ZLiDrQlXaT9dEX2HfdfthbMLbaB0ucOHrDnbqQHdsStRs6+UUUrqDyedwIUKV1j2nzABUEBikiMi8p9O4lb//H5BDC82BVtRi0ZKuT6sbYL7b8+DiAVVyjQrTaoGHqhnZpzP8My1jXKKW7bbekhPf0VnAg7s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:33:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 03/11] xfs: Hoist xfs_attr_set_shortform
Date:   Thu, 25 Mar 2021 17:33:00 -0700
Message-Id: <20210326003308.32753-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003308.32753-1-allison.henderson@oracle.com>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:33:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0c747ba-002c-40cd-efb8-08d8efeec19b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB270937E4DB421EF986595E2295619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yAoONLhLzPAU/Z34ZQsuGwUPaDu+AVZ9vkJDrD6zHKhC9/LCS1/ZVYEyXeK6kw3wVVX7gh16dPh4ZLdwPmTd6pceD1FuwwsEY4KgdW6JdiKEWRouszamC2TQTcNRpI36SSl2h5CS6m644OxT+8zXuDR0BHnFxLsGt/1p0ot8qNONT6KKh/yJijDTY9PnNggtua5F8jhBKGmPd/7nsCL+2ikYYLd9jvbhTopWl3xwjYtObNGNy15LQ0bOIXsCkXpJD4CIaHDdEqPh4uZPV32cYml+O4MwetIzpnsAhI3TvK+JNWTcvwZlLVxDLZpT4XnMvdk8x0zSi5ldCos1mT/cCGIfdJLbvNXJxAbxoYUL8oPcRY94ii7vXjOlFWvqGuWhfuPJOTY7avVpYcOtS+hxHSmuVf2HDGBsaYcM4U4KH1Q36nZJICc8aQDc9+FT9AKthp41jUKz5Rzdj3xaZEHEzu2XtPSzzgnHE3VBHBr/vAMaTzPXqn6mlNqiIZJzK1KOl21zMmmkYabXTm0mghRCWBZFRiaQTU9XkryLKmCnJJ4KIOsxUbZ3DzRaLd1nknEabnw0Rfkq+rKcGAR1GWd/4hqI2ary6g2zX2aYG7rXxuYFywuPcDBguX/cKfFiKlrz9qH9tQzstsk/ngsxTrVNg9auxhgW73gz5KBBMDgRK6IG+1QKWa3ptN8GWt+FdcPv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aR4cxoq+elZipEMLxSP6dvhL6Kf3jQdNq28Ropsg+kqFeD5yLmK+mLw3awyZ?=
 =?us-ascii?Q?xZgDr6hUGVZo4DVf0oAHeAn+mO8CTJBAhyKttsIIWPYgDITglpLpFiZZfxiS?=
 =?us-ascii?Q?t8+1LPum8uHenA/f3/bCfBwUOitQyclj7HgXo9PeAT7Gqa7wElvVyn+Vok7v?=
 =?us-ascii?Q?k5a6Qm2biO5cImITLodp8hAo2OgTIYxtPMJKwqPBY66EPbZrhhiIDHIOEMYI?=
 =?us-ascii?Q?jv5E6NNzZzC3qj17lSW8r2Bm1AUN+htvUSiDlqGmUprFCvGpUdlK9+9vC4oz?=
 =?us-ascii?Q?KC7ePS7sVQDECKiRtJlqlQoiarMuIYRzPYpN3vfqkZ6MhooesR0iayDpTqSe?=
 =?us-ascii?Q?Wv5JYI+oPu6yAjT3PDPkrXuV+6evzLT2KTpKQXd07fYPYDf54r/7VxEoEps+?=
 =?us-ascii?Q?Ipkst3Bbayb22mi3DdXAZ4P6qJxgL8/UOejkquYH0Kggenn74+evBxqb1shj?=
 =?us-ascii?Q?jFLPNXiHlsnkXwGPnwOxB46JBXExRk1TotErtdSixcapIt2333FMB8/217m2?=
 =?us-ascii?Q?a3+Vaz8s53dOvQsbKt9HhQOsSY5SV6TyRXwODkCJqmZO2+tVk5tAyEupGqyb?=
 =?us-ascii?Q?74dEc1FjsQBIw/liSzP6Zh6trkl48cDrc6PgsfBWk0+r/36YEVTgD/RmSgZ8?=
 =?us-ascii?Q?dIeN3RTUL+/ofuWh4tn4CWwVjx1RF3hjHj0MaFC7auWRcj9utiyee84duYz8?=
 =?us-ascii?Q?6lLE/R2WW+ASSoQT39NBuVU0+0Kc14dOTzByLcqlQ1xP/i9KVg20SRQZ+XzG?=
 =?us-ascii?Q?dxlqNF2Q7cb5yBwGsJv9UDGmhqNfyv9dGbi1CdS6XzoOcrnWxg0yJcsy846J?=
 =?us-ascii?Q?ifI89+pniAaP3T8X1A7ItVI/wtwUYvloPBmHQpHyuZM0XoomHeKAp1PSbaeL?=
 =?us-ascii?Q?aGLpj7LqgslTAIgifTZwvnBiIQvcMsXiRRx3CYjYaq/lgM0L9qWjV7DHKESd?=
 =?us-ascii?Q?6RfxlSRzFXI8AcLGqHun65yk21Dv5T6nsLkgme3dcraTaf3ZmI7/VHtk2inE?=
 =?us-ascii?Q?D7F+XI+LgHvDV/vldYYO8xECTYN62pwrIgVPsVuCDaw6bH2X0rmRh8N4MlPo?=
 =?us-ascii?Q?LFAMmlUWGhGJTA8LR7CvmcPGWNkzoL46aRGfi5cI8SburJB1aRNJewibZQUo?=
 =?us-ascii?Q?BeybkE6H4e5kmhm+qCpD6XwyPxg7AlDNQ7clMlpFJ1w7Pmeu5fSWcKG0L6dN?=
 =?us-ascii?Q?KhoyJ8IGy2/u34q9xbfmfW3WFbgL5CLhD/ZGt3wbk7XlAgWPaSe583eEmsQl?=
 =?us-ascii?Q?9fM8UZd1uHMr9dCSA2GfQPhO84FS6xge8bIxx6Q10KH/ATKcNqPGPWIjmqpU?=
 =?us-ascii?Q?Wsc95+/joerMSYbnI0Xx3zaz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c747ba-002c-40cd-efb8-08d8efeec19b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:20.3616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsRXRUZJIF8V6hzkNjywRWIdVmmQ6XknwUdLjRYqN+9S+Qff7NpNR2D0AG0w9NL3mH64Ye5z276Ck1YEAjs7YL5kjqzkEMe7OrD2g9bvWg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: AsWY5QdhaOhtDEc4wnD-UsRbnXeV9Tnr
X-Proofpoint-GUID: AsWY5QdhaOhtDEc4wnD-UsRbnXeV9Tnr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_set_shortform into the calling function. This
will help keep all state management code in the same scope.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 32c7447..5216f67 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -217,53 +217,6 @@ xfs_attr_is_shortform(
 }
 
 /*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
-STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
-{
-	struct xfs_inode	*dp = args->dp;
-	int			error, error2 = 0;
-
-	/*
-	 * Try to add the attr to the attribute list in the inode.
-	 */
-	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
-	}
-	/*
-	 * It won't fit in the shortform, transform to a leaf block.  GROT:
-	 * another possible req'mt for a double-split btree op.
-	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-	if (error)
-		return error;
-
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
-	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
-		return error;
-	}
-
-	return 0;
-}
-
-/*
  * Set the attribute specified in @args.
  */
 int
@@ -272,7 +225,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error2, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -281,16 +234,36 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+		if (error)
+			return error;
 
 		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf buffer
+		 * and run into problems with the write verifier.
 		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		xfs_trans_bhold(args->trans, leaf_bp);
+		error = xfs_defer_finish(&args->trans);
+		xfs_trans_bhold_release(args->trans, leaf_bp);
+		if (error) {
+			xfs_trans_brelse(args->trans, leaf_bp);
 			return error;
+		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-- 
2.7.4

