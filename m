Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAC4C433E5
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5627A61A4D
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCZAdi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39322 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhCZAdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0WvAp085232
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/HitteRPM3O4J4gvlLmuX7017jzcJOxv/oWnXRw1yqU=;
 b=T0Gv8S440eOEHsCMzlfV75hq1XKv6LGx02LMhOz/DIgUeJ7/MrBhnE0sIFPuRe/Mw1UU
 WQzeQbT0NiHlRn6vsx/3/06KJRNTOAaZuQhS1loqic4HgTb22TIAPgZa0YZSXUWPXBGq
 sSs+xIGVeLLVwBjojbdWRBhNzMFA3w8CV/7ewR2DRI6XcpVq3LSXPVLIsvZsSXlx/7Ze
 GrRVOqgEuLIVCyNJlW8aVwdbErC6b4A4KYoviAGMgCHIAJiDJUmj+ylBZUuJ+4t6LYsQ
 qZBSnH80LE1lalkJCsulNtL8p/LqC4PDt8dNPG8ucRDGL+KKyeRjwQNblGBZ4MKB7EGK XQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37h13hrh7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PYwN096811
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 37h140qtxx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dekrjA0W2I/HMF9hOGIOSIUyf42CimeEjea8I2tqRg1yjouvTyjl195J3cgfytk16WHWIzR7AT8l+6ZsX+dEUqdCI/3OMseJAGYn4Pjt6lPbrTrHjYu0TaQuVqlvjkfFfi/ShsfTGxPk9Duxolnjd7zj4jpBfALTfKaURgMgTsn0+mykudW8ztwWcQB1aLXkh79QijCTBTzAc/hLhpVpj/h4QReT22YuS/aeOwdASDQnzouJtEVXgsmYwgQgacNZwyKAKsEPRnsOSJYEOSEAAtBe4jwcKgNPmOYM2OggNhbWD0zo5cR3d1OaGrPIfo/PieyywfqIzW1ZQajF+DjpvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HitteRPM3O4J4gvlLmuX7017jzcJOxv/oWnXRw1yqU=;
 b=PeV0tzpA+6w5bD1igeUBOlXLcdcPv7r1ceQc3SvA84/Da1DdZBqy58VLkqyQqd0vfk11hI2foz06Y6l5UpTR2DtW50Bs6XVzYEAIgmNgjTuY3tgQluN0BrtBeB0ANfFmpQFjQotkX3kbK94g3ouT97D06xlkjGAmLNJgpeQXnEisVN5Dm0gNwZx6BMvR+PKLYAHzwfWTQpGwGS2VosgteWsvDAy2kRwKCl9FDVGLO5Qchz1+3tn4LDkTgAcpKOjNpOyoAGbq1jJ/LdLW4t4Iv4inH07F8C1FJpPjadQqbmyFuhAHa910a7IL+VUPE+RTPd90wZXgV87rVm5cKu+EfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HitteRPM3O4J4gvlLmuX7017jzcJOxv/oWnXRw1yqU=;
 b=IrqOmbERrUNjHyKaiU4g03bir5miq9GCyXfnsokapozFcWwvS4a5FeYwlHouaraYckymAbXcE2iK/qpE161z9K4bZQ/ve0EEJOk4ZvImIm3W+nUCbivCmL3n8uRK23uYNugQ9bSY18OXY/PgY4SMQ1xEU8qNWNTf/v1iju7M9m4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2645.namprd10.prod.outlook.com (2603:10b6:a02:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 00:33:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 09/11] xfs: Hoist node transaction handling
Date:   Thu, 25 Mar 2021 17:33:06 -0700
Message-Id: <20210326003308.32753-10-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:33:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7332fa18-1085-48d7-c17d-08d8efeec2d9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2645:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2645EE8BD292276FE2D065A695619@BYAPR10MB2645.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9AlV2+vezzadu3feBl33xRaWSdFK5QK/GQ+u7IP+6Q8Gmb0SUvSZPa0Ffxzc6j6sF7xTaicO8RS1XiISx7Io9vF2okeabDSqlhqrl7+mJVa+Of1qkrkpeqCOagIOmvP/YZAD4VmScYrHgJxl7qGQSN4FmiKN4oqFaFJwpMOx038BeMNJASMAUAp4BDFxpxrYEpHIgL0GWjA6DgO6/Y/2PkOweI5sLL+ogCq8fI45hAGJuZehWZDOgck54Wisj9L8V00WgyE8W5G/VUKkQZ5qRsvN60wF3YfFGmWy+zCf9n17N2+EB6AkQv/nClpqNTdieNCR1b5i+YQLLYPusI9TodZfpl2ooau371QgcutBoQMsAlwbiDSFJAMdUTgPAj+LJA1/uOcP9v6AkOXr6l2uR/dQvGguwzQxyh+FlmFPHlPnasylb9ShBXMxRTqAE9BYVuSF18o7Kmf5ow42Noq4yY9Y2TN8LHqyCcFuZTNqsSEbt9SVLsjVGFyOz8IO68bhyqVLMaOa9Jn+rOZNBgKWF9rBFSdGlgC5lyswwFAGothctvCtDKkgex59p534jyI/+0Qhy61VN7CabeLEVaaC4RQ0Iist2jt25LKbar1o4BJgjKru6R33EI3+0KsuVntupAzKyrRFD355d0AYw9cRc6hHqoAPFr2DzOPnlASj9bIJG8H8sCwZ9qK3/PMRwehM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(66476007)(478600001)(6666004)(8936002)(66946007)(86362001)(8676002)(1076003)(6916009)(66556008)(52116002)(5660300002)(2906002)(956004)(6486002)(83380400001)(26005)(6506007)(186003)(2616005)(16526019)(38100700001)(316002)(6512007)(36756003)(44832011)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qm6sci4CR+wMuaT6gqFv5wG9fLl8YoQ05HM/KSw82DaUbks0vCMVv3mHDTqF?=
 =?us-ascii?Q?kU3d9lkSkep3GjR+NlTNC3sRZxqKtzPZoVOeOR1WTGGhAiU0W3jqN5PhX7MS?=
 =?us-ascii?Q?NtaYlec6iP83BclAtwnHUrnlZQbLDG09tuSXHsXm4C7j266MZCwWXnZiIloj?=
 =?us-ascii?Q?WUeu+jjnbaZGpEJxBXnRBpijWu4CXlzWPBjhGcY/uT/113fYfyQfEOGXMjne?=
 =?us-ascii?Q?TH4lc/Z89WlyeJsWqbzBHhjWV/EB3tL2KynK8BRgYpP7VP9wMYO+ZfKeZ+lU?=
 =?us-ascii?Q?uoMPKRDKt94tAOZC+ABCh/UqcI/sSsIkez/ZVgsXIqP6MVGgrMznU4JCWldy?=
 =?us-ascii?Q?UksCpHx/7dYg6U1x1/GTLyiq8PApoIr9CpUhm1MtU683Ek8bBgXfOgUwXkmJ?=
 =?us-ascii?Q?eqBHsUImaO0IlsBtR+5jHJbd3gCYuRl+XPb+pBpZCv03zJR+RTxoxm4grWxN?=
 =?us-ascii?Q?n2HmjvyGoz864kwTU+3ai0uOp9e5vhddOcZ9EFg7+pTqs8KleHdGlnRGJSnQ?=
 =?us-ascii?Q?lHNnQAbeXzVTvowkv1OnEWqNMFGyW4mmVdYoPMErjq5C5LwKCoX+rJtYcAwE?=
 =?us-ascii?Q?fsevUbdXmzMF3S++j++j9+xUUvobNak4LMlbD71LLJhgcNB0ZJsOnmPkU/Ao?=
 =?us-ascii?Q?RePbl8/PCUPZXXU5+7lkqBpFXNAZ0FbImFPfrjp7O+bK7u/K/R2EpC2xBI9A?=
 =?us-ascii?Q?8OiIi0edfXJiFespT4Q7kzc8OSpcnlIb93wyegEVpXS/ZQVuL2Wg2eudhEZt?=
 =?us-ascii?Q?hubk/h1eF3KGv7NzKB6gmkQYmLDLS2AcFVcoppNO+ZeDFx5++EUcr9L5dX13?=
 =?us-ascii?Q?mg9oio0k4ZZtr/LIc0QbfSmTHjuWZwYIy0vEkV0D929YyQXXcqz2EKmh+Slz?=
 =?us-ascii?Q?/AH9P8jiwwS48x/hrW4Smcuf+pLklsBZXBPoWkZkkelRJeyHHPZq9oZSxbml?=
 =?us-ascii?Q?FAGKK9PosGf5lmrEp8mK/X93Z505JNnp4rRgYqnwRH8adQ8q8PjzoVx1zxGt?=
 =?us-ascii?Q?ryxDjdPaHiyxW2xnwbV+CQMDIuBjywR75PE/V3Vr0qQkfG7Fb6MBBg6VTaZ5?=
 =?us-ascii?Q?6/xijm03ZeHWFMjmQG3kVYp/mFIOc6OcIyapWapIBBIA5ImWArX4ovBuAb7z?=
 =?us-ascii?Q?21cAbLtXkEcBFtBD4snCKaHfgNTNmKIh8xPjHnj4a0/5IUbxTRzwNTaXqgRx?=
 =?us-ascii?Q?4NGLCm/3IKzcpzPqd2tm6kNsHyjk7YCGIQ56sWQSrsWM63zn6W13fJIlEuJq?=
 =?us-ascii?Q?jFndRe9pT8p2GGb11F3WntyUBJ5MZTyyGeRHFK6ktdA/8C+3hzKLTRGuxOGs?=
 =?us-ascii?Q?5+0UyI0B1RyTSRSnzXYTIttz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7332fa18-1085-48d7-c17d-08d8efeec2d9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:22.4604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CY7oY5AaU80kO6MHcLEhpnaMySbhDC68HaX3jYWKjjFtdt5Mjnn13MWN1XBb+46cjwx6T34Zc98ijc4UeSC++crUzDL92pcx/y8/Z+sBtoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2645
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: aGM_l_w5QSkHS33HJaNX3CcE6at4z4Zg
X-Proofpoint-ORIG-GUID: aGM_l_w5QSkHS33HJaNX3CcE6at4z4Zg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 56 ++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 16f10ac..41accd5 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -289,10 +289,37 @@ xfs_attr_set_args(
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
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
+		}
+		else if (error) {
 			return error;
+		}
 
 		/*
 		 * Commit the transaction that added the attr name so that
@@ -382,32 +409,9 @@ xfs_attr_set_args(
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

