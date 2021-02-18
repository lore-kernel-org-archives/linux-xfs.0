Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F1BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F8561606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhBRSpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUDuX180370
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=29IGMbuAuuDJGBDVu+2bt5pNwENewRu+e+BiBAV2QG8=;
 b=QDlSgd3xg4BjIQU+CLY3sYO9U0hB6k9vZu7ny3poLeU1wmbGsjogTlftXwWOoSUx6SEn
 9W4UZEJftmALS74vaqnfSqLeJM5fESvKbradn4CZJ9FR2bTvjMHaWsqiO7vx005ft3Xp
 Hn7wBxch3rcBZ4phwHmlA4Z7Jaj+2OObdoTc0QSOYseBeR2GqemCWk9XdoCWwnpvmneg
 VdX8LXjrC1TLwnhYfvfID03S/XOJrsw6wU3956c2HzWNZoe3Hifx5wzug9rkyPSd6AiQ
 3UOtRDDW1vrpIDW4NA3/r5hMILGlcF0rtLbOOMYwng0XBiRpFI33maeSHG6p3UkZ9CCh tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dnph1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUBLo032269
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3030.oracle.com with ESMTP id 36prq0q55k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qh0ItKCTlsTrLzsR8BBPdTMb+7HPfQBrmDJ3ypJYOUxiEgtyEcaFMh486H2ZK2bra3BVCpJxWCCa5SNw2ITZA29soSrZ0nk40LmTiHOZeP9XdNQIs5mQ369laK81a5lsKmfqcLCFkfIgk6CAPiFqLTPl2CvMrnyxvECChY1zsPn9z6IULhWUYPSjWYVCrp4D4mAHhcfWWZi34nWIm8SPSSYw0wQYzpHGc0jL4s74pImjG7czzSz8gmMMnAgVx/en93E/Ima1oaZeE+UCFztTfOsAimV+4QBcbtob6TkjUtLRThOcuagKqW8lh3OWth6YFHIhNa29BQYVh1k4q/5x2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29IGMbuAuuDJGBDVu+2bt5pNwENewRu+e+BiBAV2QG8=;
 b=iSd90+L2mF4Y2LeIZrypc3k1BAQSk+otyY1Q62Q0/iNOylkE3v0CeFKxz/brre1kLs7jRweDX/cHqYCuReQDrVOo9cCyAvOcT9/7MBGfQrNkQe6sSk07TwlHo+GGltQFeWQSaVyTcjTozZge2QWztKORIU70qEhPK6Yoa5n/cY07nLAfeHmRzj/5dBU2IJcuKdF3MreJdXBDXwuRpSZT/g2wvDV+pMaXixcuyupKvtY7CzcC1LsJGJWcfEfhlH9xmDN/YQfiC3O4JioKwRQaxmigHW7MTI8zl3errz0eKCgEJvYUyUcFGHFmoNGUR4uZk73upxqpqmJPpyPOxWYMXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29IGMbuAuuDJGBDVu+2bt5pNwENewRu+e+BiBAV2QG8=;
 b=vATPS6VhqzC5cd/YIdb/jKR6d/aPROxYtA2/tNLarra782gOJc9KTwO7hqEfK8t298VVu+gcIRy7ub/kbAfnbNJjUkB100WXaFYbkfLDBHIzedMCeQfdLquhgbR+xjQ/tmV13vDLHJfEbRRN8zTOPYdIZKmUMwy8JK3yi6q90h4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:45:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 27/37] xfsprogs: Hoist node transaction handling
Date:   Thu, 18 Feb 2021 09:45:02 -0700
Message-Id: <20210218164512.4659-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de05e290-67e9-489d-1e29-08d8d42ca20b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2965F1CA6C0770A8BEB3CF3595859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VB1r9cIxPj+nMDmqPNvcFimz0JGRKVQjdEOG5G3SJ/h9qMMGlOhCoViAkJNwiRQsBed9/45ulGfiFUQojA9vh1IrEnGj66sffwV7o6XWImTMgEiPenjKva2tJfx2/hYL9eokbORTTpQkXsDXPFDyRtw1acW1U+tUd+t2c/OuIcfMJp9FGLqvoMJ/4B20mcqMzEV+hzuDlh+QIJiIkqTIi2dVDBF2ag8EvoTeYpdXk5tkPif6V+GtFhL8GFDqGIrtNrVYIm+HAPyH+fI1cOGSZkvZn2aT9PD4oqv3iSxRjABv8gNoBNruEykQlvQwtzLMvhgNw3uFEZ9nTW8TvExSRIlDRPHgZg1uF8YnU/1deYglFXEvZlmlXMvdHxZnYUI2/d2u9C+M/lU6MJt2MAdYSiBEHe1HDHmwA9BsXND7BCqS2dEeMmH3skK89cDpJUCPQHzpLbekb+Q8UjszX/oLyU5OFVCdoPM1VCCVZLTVBNryMq14F0OqNIHE5iRnocCf60141kBIVJ3f2ZrTHkw02zr5nkR6fuCKltZ1r6z2KfzFtwUX4ZFNuZrUUaoAvXCfKpVWVi0H3xNuJdyHOulrZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(69590400012)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IbAxev15hzKwss0U/YNVlv2UKAz/XAE2OJzt5lguxVWcAkzrQfuVu6o5TKhX?=
 =?us-ascii?Q?uSXf6KHq3AagNRjQoUCn85mq44o558BM9v7jqYhs7EeEBboRoAQHC/j/0vdb?=
 =?us-ascii?Q?bvnDHHHqSSrffEuYW9gn3yTIOnEHTNppRk9YhccbBiUAZhsF/KVuywXuoxfT?=
 =?us-ascii?Q?t0kuw/RZagYTUCRo+JA4I4Qo6ee3OM1IRtijcYJWuJy7n54SazSkkZW+teyv?=
 =?us-ascii?Q?Xb0SHOmSEiiTi/iCLIDTvPLayQTbWOrTuMphYfT0vRGoteyYdkKAnWC5skI2?=
 =?us-ascii?Q?R86lmNaCGy3ATb7ETW+yXo6wZPyUd11mHr2Kula3/mG6tVf0J2WtPKR8ZlOv?=
 =?us-ascii?Q?yzA3DVcdjF9s1h2TsqH3wfEKc6RTXl9T3WX3yOiOq/a0xdszelt2nVA/iPIL?=
 =?us-ascii?Q?G+161HQ+H4jf/XMnhXKt5SElEslY/79qqvXdScZESM8RuS9THpM5jK7Whudt?=
 =?us-ascii?Q?Sgxkn5GBU1oD4CwN/usJbrwPJPrxK1OF1o9mME953PZbi9SBKDH2PYb9bMO1?=
 =?us-ascii?Q?ojz18uAMbToX1BVkUoufGq8wgVsf2udfdV9hsy5csyF19hHJsXWQVLx1uiIb?=
 =?us-ascii?Q?tGAvE3ukiX2VlDHuynPqpKLZ8ZcDdzAxGUd684CXe555Dr3K9bdsRPWe8MYi?=
 =?us-ascii?Q?Sg5YovMJ8wQSUhuGuXtx986InTQjqUeSeUie1EAcutannqZG1uInTYt7j5BC?=
 =?us-ascii?Q?WJT5uiLgltTLlPq9Ey49tV2qEqbE2+tPCDLstAV8MWb8/YyCj4HnM0SryUkT?=
 =?us-ascii?Q?VElGW9bw1teFssYR7+e3xzkEPgt0WDzjoXQ6m5BN4o96vFj2lfzvlwmCrfFV?=
 =?us-ascii?Q?j0fkTDGM3lPctkdPyYyX2AdoiXdcqThst8uJc7DhW7hxiWKBj8cTTB9t1RZ1?=
 =?us-ascii?Q?2tF16twE66Q1V9q0CjJHZkmpN88uFdx6HGxX2CH6Qv8aSZ37u8gpZ5+Vz2YL?=
 =?us-ascii?Q?9ewG03VSL97Wo4xT3h0zb+e8eKcf6cZQ3MLzZrzc5dKfmwKWXudYyqMaGpD2?=
 =?us-ascii?Q?W1WGAYpk2e+4gkgqetnJVu0NjOERLn4qVZyMkxz6FL8FEHZL5dxqYZBcPADY?=
 =?us-ascii?Q?DHEqTNg9eJcZbe6oGyTCKanlLSP5TlVE2xhMjv+hJwrxHbOMaD3qlRbjPUXu?=
 =?us-ascii?Q?g0kE6VV1dFhnAQcDLoWmamlUJ6GbaL9NHXezWz3+HUh1BtuT5r6lB1N+efv9?=
 =?us-ascii?Q?0pf5LCKiaiQIKE8SAeVLB6pT4hX42KW1GLEoPv6ACQpavnHMTa8Bbg15VSfu?=
 =?us-ascii?Q?wKPgjEWknUmEsBwgW9DCbArA9qJ6L9CSE65It6+Vwv7w4GqDRFFsdjSlG6pV?=
 =?us-ascii?Q?uB4axp22pPB3sA0qbXqfd9+D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de05e290-67e9-489d-1e29-08d8d42ca20b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:43.6456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NE6XD4J+Kq1KbyXuA16Z8GENOD4ZGMAXONvyuaCjawPR8rcfSXcI8sSkcxvWLWHAAUBmPwd25rlLuHfcLGGsw8BWQQb7/rRMHnP0zWkXaCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: cb9e8e1fb89d84c77c8035b2391359f9cbf209e6

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 53 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6a9d9f2..82dc851 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -288,8 +288,34 @@ xfs_attr_set_args(
 
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
+		}
 		else if (error)
 			return error;
 
@@ -381,32 +407,9 @@ xfs_attr_set_args(
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

