Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B41C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B8CF613D3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbhELRGY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239713AbhELQPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGAfv4012623
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=c3GDTrPZMjkfclDu/3E4rkHg41Gf03hUsJQJhqMYAFE=;
 b=usA4LTB7TTPqjoIHpPdSJ2vYi6LwMYiTdWisR7WbxrL7xk4hvV6g0ptc+3AoH0T4DKZg
 DFEvTYIQARR13JRSdfSW8ETtI92OoeK2pJNUXuhi/LPySPc54Po1QrdS5eJEpsXTrShp
 bCSgM83uQF3lJF+4X1l5N7wRKfDoMlAW6u0xiFhP++ndockkfX3b7lJdCeYRzybo0fx5
 mHDPhe3F8M2ZM/wEhUvudyPnfILZqTFMdmT0KRhYr4xkQXt2jU2Rh2hvB2izSTeS24EE
 8W3/S+HtjLm35TLcpbYL5JkHRJZIyA8UDsyVG8RXeN4b6izqo4eVxLQWQI4fhrpTwgTu Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmjjn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9swn194902
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3030.oracle.com with ESMTP id 38e5q026eb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhBcqfChIaUHVF5W5utuTvAdxdJuH+w8+4EhKeoEheMaRQ670KuwJxQmrk3IKYABMHMt15ZUNitjOm9hWAeUbgeKNqHti/qMJzeJSyGG1T31o4xEej19uioQ6bmXnOl5dULNJ/vT7FCIlOXWHcrVJtOzhIAbhRiYL57MI4UpCAgyjvJPovt3ARRBo18ImkF3aPB41HYLlfOo2f5dEwoLfK7WK6gEgAZfS75yLcD5z/trlvD5QQ28W3PJUgj66PKhBgfg5YYObtgX9AzjBwAsmfUBwyMuq2CtiZWLFvdko2ca+iFfAV7i2K5weK5VvaSN3OF9iyrsY9IKdwkA1Ct47w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3GDTrPZMjkfclDu/3E4rkHg41Gf03hUsJQJhqMYAFE=;
 b=Z4uPEU2/FMad3Q9Q67ePIshssDoSgW8J1jSLQsFo8p68Xo0UmcKB0a4FL9wehfNP5BPiSs90M7t2Tn+ZB48fbcF/w6YXCQPZa2GECQfhrpGdXOVuK7ICsFOzpYdeSM1QZNVE7g+tI3+pL1sCiRTpBDvYLdw6leKzBDYJnjcTdTw/eveY28x1S6oLzwsDxr6yhsNeJRDdPqWCRxG8s8mrpcduSfiL5WbnMl/6m6te60aI8coHOzoBIqKh7aeq+qrunXOY0FhdI8X5IzM9MfDNEIDEhR/GZEy5WSCXpkO13GSodBHeRviIHLzlUaN4W5d7Q/tbnWMiI9Cqgs/71MTVgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3GDTrPZMjkfclDu/3E4rkHg41Gf03hUsJQJhqMYAFE=;
 b=n3XXSnzhgWyppWsk9O9aNLQx+ok89sqT7113C0lccTJ+jVHQWJEqWrYUa2AKafWLGH31sBIHvwCZ8Rjfn4SBt2mji1axmX7gwGYpghcznGNJxsQCz6xd7MrHoBPpLFahypuUk+X3A0zMrDFqpUAZ49bKn0YkatYOaSm0fftyvwk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 03/11] xfs: Hoist xfs_attr_set_shortform
Date:   Wed, 12 May 2021 09:14:00 -0700
Message-Id: <20210512161408.5516-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512161408.5516-1-allison.henderson@oracle.com>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9c20337-5743-44f5-fed2-08d915610166
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31129B461E6E868F0F5173DF95529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wBSBEFCDMjhWh8mRJAyF4BShOl0BuH/XQWbYqvKGH0oJSPsxtkI4R0VlnFGI9jgCsBF3/F+p2WcKiFvnzUDFGNG9sWCJgQ8E/HAbk49WqG3KHxEKnPZ4vu+dDQowgpf/ysBHxnnG/CxCGEsxTuLlGA5P+KQpc1qf+gC04qRzOLKJZc/opOngYxTPTYvfMaQPU5o4nJRCCXPwKYTSegItUKhzUzpG8Ns807RzbrEptI+SrLvYJHMn+q3aaGtkjX2BUn3cWiPs4US16TLJdmvyNNKH0Qwdvh5xYhGMhvXY+9XQCAjo5m2fUgNCB4YJ5mbi2rtzFm83VOE6eZENcVh0RXsUccBYy9ghxUT4n6C4JCNZuU7svCYJ5VIlZdwkLP14xREKG5V83WxDriLarYrRlo0+D5SO3//t4AddhAk7ncUokrw6o1Oy220Dfex0sg0VSyD+6ld3jyDXtbI7NFJKpDvMJcg1g+8JL3R0ZGEwSoYHGS9Q2U30u6S/rSqOWI81L5WAQDQtzCVj2tCpY0t1ahuCmrLpg1ksqX9ZIAYeSW57H6BjN2+Wf1UaU9eop0i4I1nzW73z5ZEW/BHNRs5e5CqQtsSpF4hvr1PQv7Bbod9KuID19rZQE3NrBuB9Gse9qYk728S6C2Ao8yInpbAsgefFD4uKV4pg6SWRAAJi1US8mXNlemmfj1xmqgKNtgjr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(83380400001)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uTnXp54q/OGWyMefehDB9+Z9HBIcwGxD6vcCTwq7KhMiT33CCdc40IQ8t3e5?=
 =?us-ascii?Q?lJMffkBiG8evbqKHEJf4K14Yt3RIqw6uNynTvAV/cwc9m1DPKzMioGNlZpIA?=
 =?us-ascii?Q?wmOu8Utk5HILcrtdaJhfpZmZRJ4pIUcooaCD/H/MvZnxldfeJ2CzJEP0Cp15?=
 =?us-ascii?Q?NY8Sxuu7WT3cztXGSvONohp6wSvHHakNy3/2tpCTAboguK+j4vYcU/grvuIs?=
 =?us-ascii?Q?WhLMxqvgws3M+7VvaAXZWxwpnfgdXQC0auWDICS1ge2mKSoBOLd/GrQQ97Ju?=
 =?us-ascii?Q?74M9G7eFCcoDOemCY86krdavRhrWkoV928NHmOggygwPpsa+cmnbbUG5AWZc?=
 =?us-ascii?Q?a/VVjJmYrPlUgsO4BkwwesV75hw2nXR+4PfokGPCMZqw2D/ASyt3MVjZRvyD?=
 =?us-ascii?Q?4p+aufPZhJ5SrSgaQQaNWrw3Oc9+1tbP/0NC2UYgKrs5VraAlnkZmUrE4Kmf?=
 =?us-ascii?Q?x14CQKheXGpCg6dASrRomBJG5HSoFIblOlRzT/hHiTKjVp1lJqDpuJI2HsL2?=
 =?us-ascii?Q?ONHpMbvmQdYWo8Aa6XVzHAf5woA7iCZ1hye+uk3ZOqVZoDL33E+OX79avHCZ?=
 =?us-ascii?Q?R0KuatbkWgMHF0H1MdVEzddT34m4Vpxrx+b9PFH3S5yg9AUNepkiOgZlyzkS?=
 =?us-ascii?Q?u1BLlrrC6tLKeAwh7BnbiwpeIn6ypp5fb2XM3D51TG+vtUW1sihpOXtVOEMo?=
 =?us-ascii?Q?Z+YC2WnqF1LU3v/syNjn8GAvgCQggWZ/AUlZd1I/GfN5LAp2i1qjFangT57V?=
 =?us-ascii?Q?8NZ5viVOZp3Lu3vGIv8hJJ6hW6d8pX75gbsZlAECNf7crDi1XCe11EqBC7gv?=
 =?us-ascii?Q?0pkDCeJAyzV7RcesL/jm7fz2VFFa0dJTzYp5pASmTLjbKLtDKE/YylaU7O4V?=
 =?us-ascii?Q?guxJDsdDCE7IyeTVIrEWJZ6/4E7eiMwbcjqogXO7omCrj4quQOR75urogrcn?=
 =?us-ascii?Q?GmtpC+NvDnxDvApxrPhMH3iuimxD4cAV7tAxEjlVm3s4pnmSDY8Fk8jOXkw/?=
 =?us-ascii?Q?go14YueWA9TYthYLdsIXAEKQh3gd5d0jS58KrsZy1uT3F5YmtnujZ+Gfn6oU?=
 =?us-ascii?Q?D073AwEHs2bzNeQt1bR0V4fu3SEwfmBZ2qu/WLhfJpp1rblSgrCHzN8uRqw8?=
 =?us-ascii?Q?Ks4jNzxk6DcZhF6pP8xCx4iYB+y1i52gf87C/gNHtHnCoV1o268jJ1njQCLA?=
 =?us-ascii?Q?se016us/QPJZJEgsuRhH6qcNS12xyEaktI9bk9NnIjzdHE8N/iy8xdWax+sl?=
 =?us-ascii?Q?fa6iSLq9anArOlw37qwXbMcH/u992v51CTJEVPZciU44SWQSMV1cuCTMekkI?=
 =?us-ascii?Q?buLkaeNasD1Ug0XU4HoQEAIU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c20337-5743-44f5-fed2-08d915610166
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:23.1215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJngVFNiXPzvdoHzjnTL20GTO/AsDsOu8ECgD5Xt2dUqeS1ff7hWgcn5QXWHX+V03MElgLE3aiA+GIevrJ9xjk1G7KD77gOb5QKMkukKiJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
X-Proofpoint-GUID: zBVZk6kDPlKEyGX9Dir-ms47nGx4NnSX
X-Proofpoint-ORIG-GUID: zBVZk6kDPlKEyGX9Dir-ms47nGx4NnSX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_set_shortform into the calling function. This
will help keep all state management code in the same scope.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8a08d5b..32133a0 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -237,53 +237,6 @@ xfs_attr_is_shortform(
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
@@ -292,7 +245,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error2, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -301,16 +254,36 @@ xfs_attr_set_args(
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
 
 	if (xfs_attr_is_leaf(dp)) {
-- 
2.7.4

