Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADFBC4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B318F6112D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhG0GT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25176 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235633AbhG0GTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:49 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6I7sc006844
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Q0j5pzsgrDkHleG5pEz3Q/LNmgqROB6NBUlhiNDmDpg=;
 b=gHkPhcel08rAA73N630kVFSRthEllFaz1Tg41DMFKtHzbIm9qondIIKwF/S1Q/nyynM5
 Ut2gyfGW/2EgmmHrh4klCw6wf5uJ0/Y8gfuS/9L0hI+BwiN+NId8Kkv9L8mNUvgvtHo3
 /5gyY1lQEKlk++PaW0Ve3Bm8h3MOyEx17C4cRZCs3kkQHe1TN36ReBO7tb98C7BwCocx
 +5OkYei4EIdyajhvZ+biCndXNgxNXCE3/Ed3je9pgOaGQXr+gTaG0J5RcfoQy/axxj03
 OBvB3SsAFSahNbUVFQYuJSUv98RLCmo45OM3zysV7e7+sZTf+GAiuCACzBYFK7D7jp92 kQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Q0j5pzsgrDkHleG5pEz3Q/LNmgqROB6NBUlhiNDmDpg=;
 b=CQfopK2b7+0jzaJb8hEjOw7RumdBvm9OeZXhAfJhGFP/A9sQEFffpg9+H5kozx+7mvQg
 bP2TGQPv+ojlQ1lB1LbwxcTeFA6kz2B6+Ka5vQwxKmZ1/yVCQhrzzbKbqW3tjOH+sgIX
 x/Vb75thdd+12J4LY3vT6VQjuODWfjOkc56A4Su1bZijDWuW8NLCTQis5sOTJfEOOAZ4
 nOEn3p9wWtaFizHt0RGcI+aBxv827y9LgXOc3kqM9b5Plkw3lxYXEI2rmQD22b+3AImO
 jyzK2Oouu1Bl+XQvvkHoz4BmKUvvyMQcYR1L5d89zYwrW7l5y39kZol2y9m18yGD7WK0 Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2356gua2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6EiaD065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvnq3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvcjvJAVsbKWDuknKdj7rCc8iUHzri3JZelshalHaMXaKMGpRVCsgGbnJJGmeeiVpPKHHnD2hU3+95R6isCp3QY/3FH6WN0puINUrXJkLU2lszNTvG8WLTRZE6PJfYVTDCdEtAmDMCL1clxu0o9TgJ3M94RF/S6ZKcvca1YV0loccD5HD9vreDzXNyL+hP5RM8Qg67cmr1V2tzSPAq1u8TdzC51q02Q0J4tDpYhajxaMLcVq0NQsc38qmT6g8JS/8jQI7cE5D8PfxVMWeSEntXslcTRjW9lnQBTcNODzeeYmdL3/iKXjoPgi2OAdb0+lkfTsSkdCfdtgh9W0HTlVdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0j5pzsgrDkHleG5pEz3Q/LNmgqROB6NBUlhiNDmDpg=;
 b=ipvq++XtbeWNrjjqiLOgoahmgLUEh5rkPCD835j7Zpdo+ZQW8iIsrVmFqa6jwlqxc0h1dWa4MYE+Vy7CPc72NYFj8uCbR3UHgXHIHgFSyrETG3PFt58GuzxC2xQP7sSJcyKoBtu35HY+cAsUzCackwPYEMXaIbSuXib5MDDTyMamodIKUHmBRWtW0++GdEnVnaZkQsWJAY2Roy0T0troZSu6Huq5QIEE63mNTNNukuV7bIQ1rXrGs1DBHxtB4zo06HcsX8UMuj1DptwS2VQRFrbTfnzNE8h3su1QxPMYYimbTlrZCtT6e4enI0QuIXAthgcAl6jYdQLm+xbL+R0I3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0j5pzsgrDkHleG5pEz3Q/LNmgqROB6NBUlhiNDmDpg=;
 b=SbqxxMeUxnaDX2KXpZpYx9pvSRtKyt+nA/G41K/lxjqO/QLPkzxAG6EYs5Mjft0VTL6nVIQRyIFR+HxeAb8jxH7oGcEGHRGpG5z+5MV4YVfy/IogbxQKVTMKKd7YvYijT23mfPYfxwRPpTtQa7BLGFowQyQk2eSKEj438FX0x4o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 08/27] xfsprogs: Hoist node transaction handling
Date:   Mon, 26 Jul 2021 23:18:45 -0700
Message-Id: <20210727061904.11084-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85c74f59-b0ce-42e0-c63a-08d950c6855d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3669972280E84F2E98E29FDC95E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9iTUwDaJtajnnEIbNePlZpvffwcoCmngqbImDmISFER58qxBdq0m1MXr3wOJHFpZANO3KYDgyr/eyvflqBQl2KuCCNBm5VUYqFq9UP9ezDJCwMfU4Id9qWT1MJjqcG2DfScu1IzDFLgcImzRAep/au436e/UjxsTKazEZMkl8BHrUt1zcjjdvOlpQLkx61WvwfPE9dFQ+SBA1Y2dcj5g1wPdal9Fxq8U174a2cI0RzpFSu6g0c4XNRWdVL0aXspsg3HOKqC4g0HsU4Ew+J4j0KL4N2IiYR5v1eW3ZBQ6Do0LHQcDagKFTQbOvyIf7i/CExlJacn72zqwB5mAjtHuBiDi9jSJT9XE4vOIegn5ZwoAZVwGpifnfmEzD4AcMwX0A+Kf3T69dwRwygmCe6C1MlpWafDYaYNPJUDhBuXU2ZTmqchkd6rEAg2N2HbfzlxyH0WV6uH8sBUqHTinh+sD1MVYwTJ+OO8lcpYUqOEzqD22pLDtcJ6UWCd8PlW9LnhDA28UHi9XhsDAp2/IyhIk8EctOjOQJVBHuZN4q6Kqqec/f3iQU++ao+1XB7Q5WgpyrVVi3JN73eMQ0qkrp3QG64M3NLPPKyGsoPiB5cRXV4QiJp0LhKIX8q6JLVQQaeO2xUxpbu8PxUsIrjFNOkAvLodS3/ZkgRNuy28VECb6vbjOFwnmRGAXZDzghD3lc2XNbAHTR/Vw9jjORes74nZnTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kWNEKEKt9Z2Dlu5F9v5hL8Sz0W7eQyjejrgZ7W9qMAEQEKuG8LwSCiZf9Wzf?=
 =?us-ascii?Q?Igjb2NJKt1kT7/XrKfZFopG6vEsroo2YvWkbITygfV49jcewQl09eaLeupW0?=
 =?us-ascii?Q?5tZ07mDMm9TPl5MOy8kb30qRvFhNd5+RQufttmvsLpmplgnZpoUSM4NUHJAw?=
 =?us-ascii?Q?kuTfC7kqxMz5yiumrEO279osEv7RpKdP5qtGuFfbPwnxLwQGFOOCtyaLf6V+?=
 =?us-ascii?Q?targ7ke9x7eDLMSyFIz277hqI/ZNuIJIae5YZCsF1Pc+hD7ZFPPGAzvFP6fK?=
 =?us-ascii?Q?boJq/MAMXmH7gL/FpRGI0ZjH1juxziJIPANpbjYDPnKJmU2+S1dBNqh1ouSJ?=
 =?us-ascii?Q?AzBnEZyj+AMSY05tKpJ6SsoMiveFA0o54oUBWFhYDOwMGsinjbEpKEjex/EP?=
 =?us-ascii?Q?zd0lTpfKWJPx5/4l1S2CqfYwjVAPLhZ3xE0tsYLoYAQVWj5P/RCn2zTVy0U7?=
 =?us-ascii?Q?F/wKK9eoRwjc+ubtCKieOfy5kgttNsLgQUDytdKazV8Mj5XToNpsKgAF2KoP?=
 =?us-ascii?Q?+Gx+UQWrXW30vfnc7LQ5oY98I7edi6rS2Tptwn1kRI2gLiorg3rruR4UgAX3?=
 =?us-ascii?Q?qMhkzDq2+/ZMDqvUA/bZKFjz8Jiw+n+rMCi5w49ud+DxsSyKfS7/8M7+NzLp?=
 =?us-ascii?Q?uwS3Nw56VrpLpc0v1w4WjAflBC0nfQGNCU/NsUBARLuXhcQ2Cc3NEAe+9iBe?=
 =?us-ascii?Q?4H8QNTQkzT+BDlASTsV9H0BxkipMl24QLq8ObJwfTHSpSonEfPR+JnKSgLWg?=
 =?us-ascii?Q?B4w3U8dAJcVnAoDAOhBYS92a0z9mfRlyF2Fc9PCLblFDvx3Jnuet529ekD3e?=
 =?us-ascii?Q?4ZjcIzgz9p6hDSkLM9A98J3jCs1F6l+m+q3arUEHXr9t2FdsFFVhM/VJ7NeO?=
 =?us-ascii?Q?qbge7dxNLPpnbtOds5+aPwlVimsULGvFp7VVtQ9aITfvjGZ6tKZGkR9u9Txv?=
 =?us-ascii?Q?ErCskkU0xvgwkLM4eZgTyCEH5RRVr3CwpfmIYfvFPlgr1VbhnTarrPGL6Ef9?=
 =?us-ascii?Q?UDHS2z3WhJqrxGYszlH8VsydlmU49fIkzF3Od2NSMHlkrp2Xiz1458WWgsHj?=
 =?us-ascii?Q?f+az1x5A9dul1nbp1dwm469cDmns7RoDSTOHlZDw0ZSB8tG6CFp+KBqdg8AQ?=
 =?us-ascii?Q?qg8tqUXkj1XfZRDj1KZuco5XzKBAUs+0xP+KA8sVHoFlr3YBlJmbSNUoLHZS?=
 =?us-ascii?Q?D3jaRm32UQ97H7hkaZcojkYP7mr6RJUADA4zVfxVRAZ+M2uh66u/qjIm0F38?=
 =?us-ascii?Q?RXQg2wjiAK7l/ypTNn34e5rv9ubiBY0rcMtTyg0OuX+hMVkv/LslZ1Ci4ujG?=
 =?us-ascii?Q?nC7bJj6LnJamuwD9Mmx0+MG1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c74f59-b0ce-42e0-c63a-08d950c6855d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:42.2670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fd6YGNMVhCYsKznIe06DbHhaY59o3Pp7VPq56qy4r2dehvKMAEwg6q+6tTGqQmDUcNwFLstL3iEZ+hNCLWL+cRe4aAkPTDzmlhusRDPuLuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: b4smrpzJfNvO2M2S0b_tbhuYH9lMgSfl
X-Proofpoint-GUID: b4smrpzJfNvO2M2S0b_tbhuYH9lMgSfl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: cb9e8e1fb89d84c77c8035b2391359f9cbf209e6

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 55 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9dc518a..118ec0b4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -309,10 +309,36 @@ xfs_attr_set_args(
 
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC)
+		if (error == -ENOSPC) {
+			/*
+			 * Promote the attribute list to the Btree format.
+			 */
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the transaction once
+			 * more.  The goal here is to call node_addname with the inode
+			 * and transaction in the same state (inode locked and joined,
+			 * transaction clean) no matter how we got to this step.
+			 */
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+
+			/*
+			 * Commit the current trans (including the inode) and
+			 * start a new one.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
+
 			goto node;
-		else if (error)
+		} else if (error) {
 			return error;
+		}
 
 		/*
 		 * Commit the transaction that added the attr name so that
@@ -402,32 +428,9 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
+	}
 node:
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
-
-		/*
-		 * Finish any deferred work items and roll the transaction once
-		 * more.  The goal here is to call node_addname with the inode
-		 * and transaction in the same state (inode locked and joined,
-		 * transaction clean) no matter how we got to this step.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
 
 	do {
 		error = xfs_attr_node_addname_find_attr(args, &state);
-- 
2.7.4

