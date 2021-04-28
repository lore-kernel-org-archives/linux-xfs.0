Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0260C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 879F9613F7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbhD1IKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43400 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbhD1IKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S7xtct015341
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=AR4jseI5Zb6V3gVXPLi1paWpKod8QAjBGX9xYa9GzF6I3sn6CRBTpRRT5UlLKQuN+V8A
 PEwPEo/bmJztCqtQaVoojHPo04w935HUXwTFSjbSy+cEQer6dIVjsbJE2p/N3QH7ZAwP
 BETgeA7GJ2fjL4+DnxG1LBWZgXwDVgTizJFeFyg6NvdndcpQSa/DCw7oRU0ANhar7jVx
 aPk5BzB+TJ39Q06hIf2tt8kQMrFyACVaFr7u1C/x3tYYJcMUR7T1MTL0RKVmFNqmNRpr
 0sFgkCwta4Y/VhkSeAnXE7JCr87EFCsVi9k9xiMxIaUtumKHFXpoxKty9IAK2QgvGX5c 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 385aepyxdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJf196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:34 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ+mPMk6NeJEHoiYeAlGY6dO6p0nVwiOoqaGeXpPI0YgG5Ke2fm+II2d+bFfJnTQTP+bHp7EIu0Fo7wQInJlOIUt9hZ/7QB1EniZZmd2nwEjG4pQFdhnnSMj6TqbeHw46VTwQesTtnh9vJ4m1vvADqJdKwvw6ozoESJ89cHsONNd80GYauQrB4XjjwQhiaIo6hrZ2tA/fjm0o6+HI2KcjK2falZDU8aLpJUPx8/s1z4ZNuegT9Oxc0CKfuv54PVJ1Oyfdt3jh0rQujHiOBmOn1YORMpRijwibP9rcuuoYRLhtbJlYu7kRpL854kahMBN0TTMiuy0vKqLOYm2bJKSfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=eAN7GpiL5uY3nTDVecXrwoiwAT0VxU1FGa0nWFdyKSTU281r5nQAHa3JkkwtnYaSPOP0Htsbo5/h8MVCU4dCC3WlDWV7tMnMeE19fvrO2grdjdWMhkeGzgTIj53SxQTPwf4vOU2C/LLebtJaQNHczse00RQjIOTRVANWuqBVD8mYXKnMPAVoqkyhxGKS6FmjtWeGZo219I3wkL3LwLY0S0inLTSjQ+351jgL7PST4N/uV7PQ/7uOCx1egMphCk0P1+CKBps8Nz4LN5jXEhRzlxpCb+qEb/z6R64WooWVNBWTSYI7YFDAXbMp2HTOP1I9XHEw1JwOI/plyXFzniZCnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=Fc7coTJ7v6AJePN0373G5qq/d2DHNntK+ot0ZibWvg4zQ8dd/0Dxt2bGifo9jeWOOyRLkAzAfki+drVW6CpL/R9vWRMpn9uozR9lGfdPTwjyQnSZgb7ISBJ9xeQ5kC0mt964PZwZ80dOmejk3bt5s6UyMMUqmaJWKno92lni6OE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 02/11] xfs: Add xfs_attr_node_remove_name
Date:   Wed, 28 Apr 2021 01:09:10 -0700
Message-Id: <20210428080919.20331-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d096a698-f7d0-487b-e6b5-08d90a1cf3e6
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB40866EE91D452FA54F9BC4B795409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bfUP4NAj/KEp2EuZXxksH6QM2p/EN6V3L5uXQBeSIUD4ygGwFX0T8QKWz8Ly8ho843b72RKpbMJctx9OSJO2ALt0zKw3PqENaucVQ+1f88DSp1uRhl7FSea7vMHhj9XCucLM07mNO7/Mj4gb8R9RqVMPtcqk6uzjcKg/7her7LWoQU/2lFNd+/JjjcYBf07OcP3T56eOp1yG2mEY6XYY5dEx6QqsgA9XQEZtLqH7/rklyhAhDCMJZcOtI/ZUO0fv/IqRLXw9p0TQZPVLPwjlgZ6Gn98cTtFDU7jUAmWLfhDf6IC+Wezvyy0/AAhOMpieG5jSDj4Pa6zKrYbKiPaHQ9BO2wvxQ8oq6SxKCwh69qpDyaqM8LkGvX3L/tvBKLgMciHiFOuavhwqg/427qJqw3FOfWdxz4EkCdyZrdhaJhx8oqJut9r7Y4lfJ1TaxtGf/v4rTdaXZddnzmBfovJIZk8PnMZ253tRs3WQ8uwydlivEIWy5G/H5IHqkOlOrottlnolK1CbstPFn8xUE6hmpcfyy6xW4xQjsFOaE6YIkIrMPZpv0mZnxUy5dqePdHycBcdB9RwXShuILmekpokBgp3TTJ31FwC8E6UKFCZ8XTYW3fWcl2WAbsGe3WtT5sRhc7CcR3wHTMbo0CdCtdMv6M1GzSCkdFI1LchBhdU/YxSxBZzEt+RhwQdEcsDQ8qxT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GcBENTOuU5GKNBA9vc9WyreMuNyKymZ0yeysFK+p1FCD4E0kkPs08vWCdLh3?=
 =?us-ascii?Q?CNNuZbbSjUm8qFhi9GMM22AwqYvB1MM2UKUDm8xKbpYnyfSNDsjGfj4R2wUE?=
 =?us-ascii?Q?lq0GfRMT/2ZGeMjBjiX9Oj+ekNdGDcK3fw5vLgZCFSgbbKYgubqDhQKzA4Yp?=
 =?us-ascii?Q?aG3NcFdYucDJ09NaeoXedcv0ejiXP3i5YEQtSlKhQ8uEgTxP2/LLtsh/tzwD?=
 =?us-ascii?Q?EOUgC9spz8VtDjjCVXYtiyvtd2UuC/X+VgkbS0LW1ksNm0rYtIg8qBuD2QHB?=
 =?us-ascii?Q?951wuoV6HRnSz4s1S1dCimEZZmwtdMT8XhfY4U8iPuM3ixXCVEQqd853an5+?=
 =?us-ascii?Q?UqWoxNBY8zBoaB3ebC4GjiaekaBxlyH9n9fMdDTnakO3z+FQe2yoMhNU+Wgv?=
 =?us-ascii?Q?Vx47zokMOBFHueN8Zjy1jpaVSM5v4OJ7+xB56zOt614rgAWH1HNIqFYuQ/iK?=
 =?us-ascii?Q?F/rpfvONMXXqb+qwb4nmk1sEOaZE1CohZ+c6Y6PoOmWMVxgJzTmVjZnvo8pJ?=
 =?us-ascii?Q?7eBg42aP0iEZ6Il1NetGpGFQORtQ6nQBCJR/TmzPG4sQ223U1EKBq3jH8KOV?=
 =?us-ascii?Q?xVOTvnI3Tubv6aPcksg+kKTE20GSpenoOZCT9R91r5Z2VuQwMnchcWkVuHQ9?=
 =?us-ascii?Q?vxzMgpLVdakHeJWJnzeyjvnOtEHkHr242sR000Mm2PPJ1cWuvetISboVlWIb?=
 =?us-ascii?Q?ckibSf8DxVwROTxVOPdarZYU2HoiHYJFiro5d39YG5bAmubQRqJiBHAJWhy8?=
 =?us-ascii?Q?GioDYuSN2JEvU2Vpe6qU3+TbixThfgowF72P0NVd50u1qqC/zvBRgUFtvwEL?=
 =?us-ascii?Q?J0VS0DuIBqmU1U4zsKhaU1LxrCPnAsZIOPhA8FOPMq3sGbpk5ZcAA1EVKmhp?=
 =?us-ascii?Q?RYtZzz30gknUSWa1Lc3HZPbndvsOpb5BZ6ns6CEim7oTzyms/Mo4XnrhQ+Hv?=
 =?us-ascii?Q?6mGK9fvu3ed2HVyfvpXMgZ9K9wmSU8wx4MpGwm7gCd89XHAgu7ia9VM9poAc?=
 =?us-ascii?Q?SFGd8DAn3QyMt842VNX+5ngcpej+h2BQAe16rm/x/CIQIaAB/5xYzJQvYM/N?=
 =?us-ascii?Q?xbURQOICiLz6yYD3LGBLRihyUer1mYgAFRjHCzdxBSj9w+cE2iUDzHyLAam6?=
 =?us-ascii?Q?mk9teMk6Ozs2oggSwC1y2PPhsndqwljecIBv46+BdqMLeW/2NsEUqq0m9Tjo?=
 =?us-ascii?Q?/IMI7Dn9SYKqmtpBd0595sSc1t088quGvQfiSlqWqzWZEOe41UOMB1NuhHFT?=
 =?us-ascii?Q?mH+2W14AoKiz0emip7aZV4gSPT4+P59RzsyFpy59egRxCKGdkzOAVw6afaAl?=
 =?us-ascii?Q?lRZw0uLvSU7raRW57hLzK75K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d096a698-f7d0-487b-e6b5-08d90a1cf3e6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:31.8596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ORApq8SNDFogVNzRI+cG2vrNAKbNyca9ouJ5hkVq/Ql4u2ZYol8W0VqHBRvjpU1+5zmyBn6YTWMXORdcDMZCAan01xJ8/E+1Sf08zACUIT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-ORIG-GUID: 7N0JCH8FkZXz7Qs7t_h5IMK5j6iUKnEA
X-Proofpoint-GUID: 7N0JCH8FkZXz7Qs7t_h5IMK5j6iUKnEA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280054
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

