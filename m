Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05859C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B79DF64EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhBRSrh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbhBRQyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGnNOl185646
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=WHPVxYttsJ5MpLMajqtks/Wvuwpcn1wYQLiSDY59BS8=;
 b=iDwKMrV2PcnsFGN2zNFeo+cODiRh+m5kbKdUVp1xCDITwAaDwq/zshsIjbzbgDzQR224
 EP0vOM5qVNfsusg2ylxsL3EwGZRZapHuIMKr7/hmErxebfYfnN77a7FakmIOKJBAmabq
 4BFRAUE6ukaiHi+3lZunvL5+VKxoYwLo/jkdpaq94z6MTrfXUtUCGqEa86WDASzgv9wJ
 xjCZZBxJs2enIg+hn5PmttKWx79xrcINz+vhHsisXJwJC/nwY+8LUeMJFZg3stxsvG8x
 HJoXHmnTUKp1cH8ZNG8305WUUKfmdfiCyXzlsHK6VgoTJ9WpaMe8yaKwYl8/aXdS6KyE 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r6n8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoG3O155234
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 36prp1ruuc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WV+DUUVIXwkzinqjZ0vDWgLQlRs64GLP/5ySdWREZNsyfh/VOW4D4rxiOMM7zkXMjLW+SoBwgZgGGJiwgSKpKrrRoPSbm9RzjC5wpdC1/C+WeC/faKT2eMDKdNRrD6oc0R8qStrZRr2bVCPQxDkEb695Xk0mosAIrSwVzU6kW8VyEEmrILUKRgJRzGL6NG9PUsBsFFpwGuNocqXPhoB0t+QdbJ8iPwzQiKc4uJn/PWcxQesumUXoiOzf8syabSvogNsjLjtWKlAK9trMmdSEygsrG8HFqLrwV3Fi4l3TRGMeh03XpSPYGJPcnAaDFW5sBzHRlcqAGb6xSRjbwM2uuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHPVxYttsJ5MpLMajqtks/Wvuwpcn1wYQLiSDY59BS8=;
 b=XA9ixw534q39Bqug2uysNqmsdwpXoMOZor3DFWbuKP0iFed7g2T5guNs0UbMpgk50eZVo4QHawg93kRFbyfRAzFBZQoE2oUaMtaB1fdR7TsX7INWZQbH4Gy5Zhhh4nsq9K6CDN7+dq+9czCX5KJQRvVSFKy+EaqLJL0WnxBCZIBxFr2hlsdNtfYs5KZ5sWcjz97/LOgX5gL7Nby+E4FMop3OoZZJzxLpChhVsbcLPD1+suh9MoPlSNcN65KElqjNWJPGLLEABOdgmexIZm3AyiR5UzHRpJ6zs+gUgqSstr7exwDc39UMRq3cPZhDxl8DnKJXD3WK33ZbLnQHSlrh/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHPVxYttsJ5MpLMajqtks/Wvuwpcn1wYQLiSDY59BS8=;
 b=DFXL/M/bZ6fe6V0BmILLSTbGyxps4wHxPwTha41cGv0y60jFSHKEiD0TDa2NIYymbbKApAw4MZsejme93TyT+pGYqvKSb8WFrq7l6Tq6V89+HXbNpfvbEX0D5+n6Qb28SfZI2sKYO3anHyTjwIxIBwLDdI3rIG98IIBFyCFO2Mg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:05 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 05/22] xfs: Add helper xfs_attr_set_fmt
Date:   Thu, 18 Feb 2021 09:53:31 -0700
Message-Id: <20210218165348.4754-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f92eceab-348c-48f8-0189-08d8d42dccf7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3381D3919CADE1EF597B9E1795859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NxxOcYpA1AfhhWmGNHZ++pezSHovIHq3VegGk/+gkRc1OYXv1lFbTlgBolxy6Y/dSvkkDJ6L/c/D41M4Q28zj6/nqYEpI4lMnLPdybLdudUnelFiXNNxmgJKwe+64DsOhg9Xk6dj5fyQpRXDdPijxkeWtpZj4m1VflNXr3ocX2D3GFMjGk91R0tPr6zKyyZSUjw1xV+KFZ2i+RiLzwWzH/VLZBfb6MbITD6PcLStIPO7jSkM6yzEkNEYL8x1TAmfaYDtti1ErVdqjOTMXv+SF2JVRi4dNDHZizxDZsxvRuYYzlicudK6RUT4T3jKffyJbWGpZ+m7xDhSbL+ws7XQRJBEpknkDrk046D61PFKvVgZVarq/G+qtfu8iy9IBVjrZay3Bgpx1O6fxM+l2nLHA4PcHe4u9qKDfbk2GiibtjhlzslOYU/ceJI6ScFwmRW2BTNC7hJSdNlQ3yEcgYWWlmtUprGKMEtst2r413/YoKFlA0+jVPx+R6SoEgs+z2KJ0IuR5UiyeGHuS2HRd0KTC0nDVCILrsUugaIVdrkwW5gy7NM86JrX1DfUgkwOqrzFkvAbve8hWPxJkhx6MUMR9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dqhFawxk3yR794OU4bkxbKqExhG4Fmq8NQuCMaywnVGkd2+VqUzkS4IzyDtP?=
 =?us-ascii?Q?1gXc+ql6Tn6C37kGQUwfibQwKMMHmgvg5un75ZZiFOzExsQFvQz7VCNTckuM?=
 =?us-ascii?Q?T+l54l7yHkcLzT4BJAjCagnmIsIXfpyUtCgFfXc65vmywd2cWXrUBiv4ycuv?=
 =?us-ascii?Q?nDPmqvFRLYHG/fgu09TkJCfWz6iHES3MXJ3QT1AewhTMP0pSL2kqmksRco8X?=
 =?us-ascii?Q?0Tt5hc6z6QNomOKdvBgnsc2J8krZf2tn5fCKCG8WYDVifr7MnNisL6kYs7bN?=
 =?us-ascii?Q?yuHyBxDIDumIe7fHg6ZVVVvXSsZKaJ300WoyumRcgUVlkZhxM13bHkPUOfFN?=
 =?us-ascii?Q?gL+h7jZFbk09CVKS0So3FVHPGeP8Xka01c5yA5OEWmXIikvtNeyVtO2xcAQl?=
 =?us-ascii?Q?NzwyERugVvXLOJgz3hRlHKP1M1NGRieTuJEUDKX/U/dFUmK4w3hqV6mzC7ow?=
 =?us-ascii?Q?r4adh31UnrnyguVkInTf815BATREOVE919lTw13Ks/3EqkXpjXzGXvedATaO?=
 =?us-ascii?Q?EppoY5xoU8v2257UopHksXoreDBsstDRvElZTp04h5RhpAbqXCCT1UPa+VFi?=
 =?us-ascii?Q?8xg/ECz8YE5jZnQaJrQcGLD0M+HjQ0Za5eg2QJMojxlFYBgnkS1AMtng4WpJ?=
 =?us-ascii?Q?ND0giLYkkSW/C6ylvxq2ci/IIos4728IRuMsarKImOSEr+qGHyfDwF4+z39Z?=
 =?us-ascii?Q?hlZdpsXQ70fSyWGwWNQ6EIUqI9f4LL+UAv0A0NxJsZAx/mwxouSjExidlYfl?=
 =?us-ascii?Q?wdgP7dRR6s+Hc90ckGMc6X94bA8Rjw6zHrlavqFK5OxlgBna9D4H81M4w3fX?=
 =?us-ascii?Q?bz3Ld0e9Tdt+sst4gTOVAPk3+kE7o8P38geEPYvD5SAYZGTeLmzBGmy/RGuP?=
 =?us-ascii?Q?xUtj/5ugcExtTsZWqqk1I9YTIQ4u+1oc0fYv6Y9cJuFGwqVKIxlCdxr3u6fb?=
 =?us-ascii?Q?TrT9r0//VoTxeHc2Ht75xBahnUxbU2st6fNR5jRl8VOoiS3xCDwPTwyuzkuT?=
 =?us-ascii?Q?F1Vt85/qTTdKa/GUBdJUa360l7KX+dS36fkQA6HMkzAxhDJlktaES8QfmoL3?=
 =?us-ascii?Q?ICw99MWLBAnNSEMxf7sr2Z5X7FKyeB98nDUuD3+jYFUDRffqYJ8tuTUD0x+S?=
 =?us-ascii?Q?sQI7ovzidl/J3Vjqmxgpme+NhNB21zq2vB1iqDbM156j8r5k5JSmOGtrR1YA?=
 =?us-ascii?Q?aTRTwVbJcQvKlvpN7KspNFHa0IMOFMZ5xNnOCuLfj8LhbLwBzgSAK5EclzIS?=
 =?us-ascii?Q?rSaxIYiNtFOUeBt3u9TKRu8/O+W8VtuGtLqDXq9t35BRfzkPWZ4aLZdTL0dj?=
 =?us-ascii?Q?mXSOut0SiL95WSbaTrASm5f3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92eceab-348c-48f8-0189-08d8d42dccf7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:05.1795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGiSLqUbCWR10lxT7RljcB7t+awxOd5cTbRO6x1Fx6mLEXEMYkJ5FzLSQvk40w1XGRCGgwWqD4t9rFhFXYRLMJ00U7+U6YBz/+OOLkR4g3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_set_fmt.  This will help
isolate the code that will require state management from the portions
that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
no further action is needed.  It returns -EAGAIN when shortform has been
transformed to leaf, and the calling function should proceed the set the
attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 77 +++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a064c5b..205ad26 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -216,6 +216,46 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+STATIC int
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
+{
+	struct xfs_buf          *leaf_bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+	int			error2, error = 0;
+
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
+	if (error != -ENOSPC) {
+		error2 = xfs_trans_commit(args->trans);
+		args->trans = NULL;
+		return error ? error : error2;
+	}
+
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.
+	 * GROT: another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a
+	 * concurrent AIL push cannot grab the half-baked leaf buffer
+	 * and run into problems with the write verifier.
+	 */
+	xfs_trans_bhold(args->trans, leaf_bp);
+	error = xfs_defer_finish(&args->trans);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
+	if (error)
+		xfs_trans_brelse(args->trans, leaf_bp);
+
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  */
@@ -224,8 +264,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error2, error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -234,36 +273,9 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC) {
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
-		if (error)
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
-
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf buffer
-		 * and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
@@ -297,8 +309,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

