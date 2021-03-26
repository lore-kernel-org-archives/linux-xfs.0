Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56018C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C021B61A0F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCZAdf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39304 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhCZAdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OtrH066416
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=niRsdzHL9xK5RHpOId50sCexYB3pdtB6cKJ9osUtZls=;
 b=QpSaNoZDdq4RTDkr7ID4kSjhDTHPDc1VmQb4x/DOZcZG2pzMUAlfMVNbjQA/ixz9nK7I
 bxqJqOC3Awue4KNkk41f+mrFlpucvm2CL1jtnaHnvAGnzIqFY23WHv3JeumdpRzTllY8
 6Sv1LP/w4zb4UFkOmzFO0CbiWOvSsQq/hBYHENGz69RTZWSMpGPtucuWvAMIn+FQ/zu1
 gto96jzv0nW4qolGQj0gVoImwCBuJLpaWKWkVd7AGvJiWIhIlFyYIVFprAJVr1bcCqXm
 4rSLVkSx3lXASa4m2mxl2YWZStO+hVysJfYim4PmPkt8eq9dA1hNI2zcBJStMawXAU1D tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37h13hrh7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OlNK009463
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 37h14mfud0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MT465HgQNcWSo/XmONRy8Uc+vX25e6XswmMwzaz081qntXnlfgzJxNQ1Ef/nHpLQa/ccokM+MdfHx3GmUjiMbQ3ZrDprk40vLZ3pBRy4fMQXY0D1W6LxldShgHfaTfQ028jQXxwivZOe+1WApSUVzcv/9Z7eBsjkAavI6ypsi5z7aF+e6Do1hVYnDbi6n/e9WSFkjiPECwf21TRvKjfXkA1olRyUEVQ/NuYGWt0epODb9kZ5oZo0JtPH1ubzhSdo37YYXRrjv2mE6WNfDXqTSdvgpTWCL6OroaMDdSaiw9qrlrwOm1osuIlk7GoUixYlmE0LMBDam43RNV3weRniWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niRsdzHL9xK5RHpOId50sCexYB3pdtB6cKJ9osUtZls=;
 b=MewLYwxkk6SdhczXAe/kU4oIinKnfIgz/5khFgwtATE8PdS3TERYVUU9TEPxCkpfoLrKHEKMAxabIH/k6/9W7r20b/8lXLI6lxEAW8Y8MBA9o30HAaJU3QFOwaq6hs2v62Y/T4gCsRoCS9PXN8777BTpIEXf9MX92whuW2YrRfE8SUNEVwFJ0su1xkTCEDMvTdrtQcDIOJOnnhCpe3t5LeMwlpTtlHQ/B+x/ryz508/P86VxYs7YBEo17OVkxn9oVSRCKlLNfxLcdb5mngUTPw3pP5j71V8Ogt4WRq278aOn8sBqSl8+BlOwReZ6Prd6eGesR1G0zRwfTBE2LxJNkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niRsdzHL9xK5RHpOId50sCexYB3pdtB6cKJ9osUtZls=;
 b=jp3N6Qpme61DvhokTmtlP1S8a5Q7HZBuU7H4r2h8CeQ8e7Cdi3A+L/Vwca+oOlv5/GNoeGdZ8DOGjKLqFA+dxMnSKDEcByqUzkJnWRYD/YO+SSpgoW7KvvjPIJKgxj4Zq4gYff5dyKYuE8XLPEop4IyJNvVOn3KEwFpJ94Ijryk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 26 Mar
 2021 00:33:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 04/11] xfs: Add helper xfs_attr_set_fmt
Date:   Thu, 25 Mar 2021 17:33:01 -0700
Message-Id: <20210326003308.32753-5-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0b69f7ed-21e1-4782-596c-08d8efeec1d0
X-MS-TrafficTypeDiagnostic: BY5PR10MB4162:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4162CCFA5B443AEB52C85F9A95619@BY5PR10MB4162.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpMaAIAVQhUXb14g0fwGiB0V52OAYkmU2bRD4gYjULzRa6DR48GhuuNaCnB4Hq3LBNYCsETTNSGUehCJPI3IsOFZ78LeHeVNhOJzfXMA31M3gjD1ehL3OCtZd6ZWIGJBTlM96n2uCQUJZeMmWLCoH5d8jfYOH8MCTBs/k6oEYtwgNXoY63OEjlrrUCFX0p83p1EEhKAy6idMuKjXOZewrGPcc95kkvRcrLvNMm1jQb3vQ9418IwlFVIkvsL+4KIRfkAWMMaHNw0J2bv6wEjDZtIWiw5fuZrWQZ2j5MjFiaC7APpt8izSLW25lzJHCSRCk8/60HyX/OmJ+ftRvrSHsFTvG4NhheBD4T/RH4hcHKrp2j84XasM4ArhvoGM9Zl+s+gkKZJGWwt++9Ao2r/l8pFjC71LIhzQ89g4b6WWW058fvr2uMeySrHbgjO6EzIsBIuh44zKXcF7ElHNzPaKDKUJXOLHBJrC1fr/SxJUojkdhSQw2uZqNfHA5KhVhTGkdg4ZN/BipXy4nC9MycZ0J7G3vOeFr3LScS2cpijsg9u0D+juffjnWTBKxJ9Kwm7UBbE/rGjqeDRsMJMFU+DaXlrPweDb0vvJH1pa/lzeAj2YPHho9pFvDNbTnYbhbdzOQ4twxs9nRv8g/2f02deUHhUNBj58IklPWnJmPNBxlQ6ZcuSTzRieXysRaV2werec
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(16526019)(186003)(44832011)(478600001)(83380400001)(6512007)(316002)(86362001)(6916009)(26005)(956004)(2616005)(36756003)(66476007)(6506007)(52116002)(5660300002)(8936002)(69590400012)(6486002)(2906002)(8676002)(66556008)(6666004)(1076003)(38100700001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q/GrzzQs/q4V/clJqN3gOrSMDH/EA6YBjgrWuQKqnsHaBmwecOiHGQAAzTj2?=
 =?us-ascii?Q?RcCO1bzwrG9UxWT5uzAHtYCv0nTwfSMS5+elmDuKA9w6ADWrkOPGBt9k6E5i?=
 =?us-ascii?Q?LiQEaE4lv1b8tj+INjoD0k1+NgTHhkhyx42z7wv4bApVFUNlImWKReSXYWbU?=
 =?us-ascii?Q?KSZiqx9u+ERM1EEG6vwMhCLQU5/9IbqUDGo1xq+jU7D8Ru6G8pW7JLOQs8bn?=
 =?us-ascii?Q?0ei0+4Gz0SGV6hmrDX3R5oGqvh6Ztsia5pEBBFlV6m/0E0O1QP8mN+Y+gy1x?=
 =?us-ascii?Q?NF2BGWMzus5X/C5Wni7Pl8TZzGnYf8v35M79HlJeqy0rjJSCnCtiP16PeGe0?=
 =?us-ascii?Q?wDHIRzDXtw7aIzedrQOA4phlnnia3mdGS+P13AR0XRqImbG5YFKzoU6cG4RY?=
 =?us-ascii?Q?MzBELfA7GLZiP7sA8Z37YLhDzm/pS4pWKNC26yHiKvSfKUgZHuXhjDayivpw?=
 =?us-ascii?Q?Yh8+NxoEOdZJIjOPE1RwiWVoMDnOpJyPgNs8yPzSrGQruwxnUKfDGsfnAW86?=
 =?us-ascii?Q?tFIzdAi6kDXr13MbNBgmUKHanDSJashpRVS9SizcFt0XYfrvSDmhk33ldrJZ?=
 =?us-ascii?Q?x8rC5FVGJCU3Xb5Da51clRjDziHZUbeu4da8b3anzQZanUwSkUDcLGJ/Spj4?=
 =?us-ascii?Q?nfRpVIV2GlEp7NZGxRVRageBJCM+NC8KUJFI7YBTeVHVWNrvVyT7X4PTL4Bk?=
 =?us-ascii?Q?dy0E4NwDrr1Kt3IX+maXU3UwfucUmvgcT7UvsadExavaHohMj/6It+StFjlT?=
 =?us-ascii?Q?X6fNKYxCFYZdzrWN0DQGnI4oU4Q5106WQlZvuJmk4KJpRdvC3NYHE69SEkTm?=
 =?us-ascii?Q?aF9mpSA1Q7T0rgw3cn8n105Ipw02nkUyP4yKLbaqVn19gvvRp2oXk1J6bNTc?=
 =?us-ascii?Q?OhqzDLDuyjhBJ62Zsmm1DAA4/73TOgnPXEcEMk0jXAUAwSsZMth6xvei52hB?=
 =?us-ascii?Q?WH4+3JSWNjxaDf2EC+RiIgKI/a9vS6xMmvfBnxXGBF7cHbTrOQhNKrO1KHW5?=
 =?us-ascii?Q?xqyL7kC8IvKmFvP4XfM1D+kPHWTmkV0OT3LFDLKjEGKPbYdZv8rf0PeYoETW?=
 =?us-ascii?Q?ELWC8zyDVXCH7smWjAYO9i5qo4PLRiwYOvCqi/F4hYtv6I6dmKXuJt1QG2cr?=
 =?us-ascii?Q?xQmcAH/ROH8Is8EGehlfaxfbXqReYufoahNxYWDwNCUqQ6JIhqvA/WgevU70?=
 =?us-ascii?Q?Hfz18gurNJi24LJT5xkRPyDtYPQbVJ0a1Qp0GvBDfgbAAKwL63GQc0HOFYyI?=
 =?us-ascii?Q?q+Ety/Kde4nkWcnGIEpirZU/ZYfyFa1z9fDgJZE7Fl14bDyCa+m36T4W6PDy?=
 =?us-ascii?Q?psliFe2cciIJkSHg1Kf+wO6n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b69f7ed-21e1-4782-596c-08d8efeec1d0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:20.7061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TXvaLjIRI6W2yUJdnFHKWLXl/WKk0tbMSku9lKm1X6Qvgc+NfZUjA9acyaQo5SOBGFY7lqNC0SUEAStRpKgW6qg7TCZWKysyFskam9lhLf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-GUID: 4JK4b6-nVXH9bXw8e7gfr--WD-wNAxV4
X-Proofpoint-ORIG-GUID: 4JK4b6-nVXH9bXw8e7gfr--WD-wNAxV4
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
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
Reviewed-by: Brian Foster <bfoster@redhat.com>

---
 fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5216f67..d46324a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -216,6 +216,48 @@ xfs_attr_is_shortform(
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
+	if (error) {
+		xfs_trans_brelse(args->trans, leaf_bp);
+		return error;
+	}
+
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  */
@@ -224,8 +266,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error2, error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -234,36 +275,9 @@ xfs_attr_set_args(
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
-			return error;
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
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
-		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
@@ -297,8 +311,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

