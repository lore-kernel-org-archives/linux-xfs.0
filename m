Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF659C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A243761108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhG0GTu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47556 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235366AbhG0GTr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HgR0023064
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YCEbQMAALeA7FiKvFLmh9Cv2Eqg/ZsMf0JPpzI+bWEo=;
 b=j5k5Z4mfG3XMqa6im6N+bHI6xbeQJFfO1rcDXrAfO0qB9aGPPeC7FedUvB/bhZsBpYz7
 AClIS4jZ7L6nCLgJuceV6Qy7miYjbXHv50hdeAsDJxu21URm01WjA88wbLStyV6sQNI9
 Q3jEBYNezn5FswE+q0TuGH2D4mToCkR2gH0uotZ2UtUZaKpiH6likycO+cvswmkeRc4n
 anOPvI4w7CUHIMM9yVfjPOSuy9X4vXACHGuzOVjy+dWOcYrohtethlzxdWXLxFyDEkms
 TgWB7qVQnFtdVqk0KJfL6DRPJmUo6JSp7xA9nml+WxN/EhnpyofwSiGoLKt2ZSDA3U3w zg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YCEbQMAALeA7FiKvFLmh9Cv2Eqg/ZsMf0JPpzI+bWEo=;
 b=pTPgOrzleLCUO2aY7pYdTrHhIAf7UokIikzZ0SYNmfzy6oOEM3VomZWlyf2svDL+azvo
 GuH7cXAfpZQCrX/h56njfHPMwRpVyBHUjalrSsl+xmNuYLHM/bcPnBFG4zHGVQB4G0tz
 5zNQ6R2Nzf5wbL2eaNCkR5r4bHo1wSUsMQu+y6oYZrygIIdALiiBgy1vmqLR33pI/THT
 iMGecyIFp+X55+uo3kFqjt7EBmwXD4xCfzLm7IhI7773U7QbguNSbtWQmFRa6QmM0lth
 ct8cHXI8IObfMQSRnI+H/2weU0fmx1TFmUfYWRAOZZ9OZGt9WwMpTwHoDsavvi2hoxgf WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FUJ5019917
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3a2347jxeb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTssMS9kYwWiuilnhHCi+2wRVs6wHEYA9tYi9rKSOucwGosLw8ex8jVQnTvvLGnIFVm3vouNikVTgMngSpGNNoxi9FhYQp2onzlzA3LG4u6gKf7DZlqBEf1CMeNUlPcGauJvnc7p5apyqKNkL0cYCASEJNx790X521NBPivp0iyRRE6+pw9fLl0uevyAaXIqecX/lp5XUF39hV3NfD9/mIhlc8MLdNEWTR6jRRxGGbcEh472vShDxNhhYGtirZSGD2890b97dTwu8J/Yo/WgU9R84NxqCRDjsu/whybhxh3/wEaeea3xf1Dvz1AvTvpfOLIcXJj8ykdRuyLVgB6A1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCEbQMAALeA7FiKvFLmh9Cv2Eqg/ZsMf0JPpzI+bWEo=;
 b=I8gKYAyA2ascJo/joAXtv+LyiZx401PPU6iBpih504cnFkqyYfbHnbFAQxuKRazYppe4iOeiQYwu9taQ+KRuKYl4qD/G89L+iG59Dyg5uv3bpHhW8y8PYxxRrMhAqfBHkwAN0wH73VJBd/wTYOaJyP/1pOOlCnczJcUUQsquF+aaXZy4qHKaAwLYywvr2NEGGsCLqkDMk1G3cx878LT18pbQowztq2PpOA3rnIMVPhFeBlsg+aC0B/EqcS3+Ns7mhjAL7fa7ffXpWsdLRPvOWtITt7DiwZteyQLHHMM+VmUi/nt6iBW4t46PMwipLFlUMc9UE1jp1AN/Dp6LBOyTtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCEbQMAALeA7FiKvFLmh9Cv2Eqg/ZsMf0JPpzI+bWEo=;
 b=qvzh5SNLl2675nUZkL/WsN5PqauszlssXWUiylYpFQ6pWMGzjKVYvheot4tUfjY7efVr5haRVHoXE70KOEv8/9zIVdWx6SRwgwu/4n4sA53/d4fSXdrEKySWRKAyP0dpir4XpBv5oYJi1LmAAp1/GU/nj/ExWhw+ZgX7Acrixh4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 14/27] xfsprogs: Make attr name schemes consistent
Date:   Mon, 26 Jul 2021 23:18:51 -0700
Message-Id: <20210727061904.11084-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b521b784-e8fb-4e2b-5220-08d950c686bd
X-MS-TrafficTypeDiagnostic: BYAPR10MB2791:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27911E7C3D3C0DAF43A6967C95E99@BYAPR10MB2791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FIOTjGkNLQP+36uuNRxwjQXrnn6k7yHAQxJkmGejPpUvagj2t5sHQUz3AyeRIVzCr/ZV36SuheosQOk8fcqYdUTXL+7gIkF0qLlACKkKWx7UBxBYo1H7+tCXtP7JZ/BM09FjSWVf7HufLRhi6dlLkUh1jZlzN/gac8WzuyQQssknC2ORghkmuS7spGl6DFValW5jOWjprmr+Ilx522Om7LxsmeLkvbZYxoPUjiWC977j0oIMNRT5/mTp3aTlebO0z9XPSyT3EyHZ4dIrdl47NKEigZUr7wDfkKGKBnoI0k1hAaeW1NK3noKZDnVcQDdDbttqYE5OLdPQOKQKdPmLe8LhlTVxoNRoULTMwkGlWI6p1aBOk+QUYPJDQ+whpxvOSy2nEYw9QNZvh2PW3+e2g65w28xMEnjnC73Fm+Dek7JzR/LxXtdEGoUDSWs5AIxlCODv8f7+y+MMxIo4M6E9S8/3te4N4/X91Kr1aoN+661vYbLdXwBxjdMTxy/ywmGBdg+iARRVi4tCLJ1InhXcNM0vHpMHV06hdpSomV6bbhNa/GG6zq2VOIBpuEUR3LyRi7kBbirLgY2I69BziSDwZICTfTOzW+CY3UrsxRtkv09hnB81IyT19xc7dqEGOCxO9qQx+Raog6bjwIuRafqlVV+XQ/1OozrIgjsmozXxU70o/pZS0dUsPITqPB2kx/5iOqwCFJ/O52GQXpL4plJu2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(44832011)(2906002)(36756003)(52116002)(86362001)(6916009)(83380400001)(8936002)(478600001)(956004)(1076003)(38350700002)(66476007)(6512007)(66946007)(38100700002)(66556008)(316002)(6506007)(6666004)(6486002)(26005)(5660300002)(8676002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TRLquxHLwufOfzT0j5NBJngt1l4xFwkyk8HFwyGoVKy7qQ3/DyDHTYqjJ/Q0?=
 =?us-ascii?Q?ABOC6PGiYfyhK+vXKgessYBV1IasjITQeV0M39fcWC1PpqW1W32m1HRxm5lU?=
 =?us-ascii?Q?zRg6frQ52FtqjZ42u8exHTwfITOv95NpJHOestHb4TPdBHC4V6s1kujszSq0?=
 =?us-ascii?Q?ux9pN9nEOVxXxeD5Yb0EBhEn3FcbBs/UjZX4AmPa7GYV6xNmvsXo5eNmP8Ns?=
 =?us-ascii?Q?QAs97j+bNBv77mpOghYToNREsJgdGlNC6NB7d4/WCS+PV/K4jWE7JK9PiIwd?=
 =?us-ascii?Q?PFERz/MD8RkpXChELfDQYv4peYY8cg47M54DI8INfJEgy63BV3KMJyBXrmNT?=
 =?us-ascii?Q?22xN+ADmNmlKqD5NJV8f3yieE0Fi0cR9dmW0aqaa/km20YoF9QTCHvzjYOCO?=
 =?us-ascii?Q?NeIXGaCdFcEEaKBDMVchOB5lhpsLbIwQJPUhYw8erZFvPgYH11i360GVj03s?=
 =?us-ascii?Q?57OqSseGf5Iox0/ITcW+LM+WtTsgm0aUOt9vyklzuNEMdTGOzqwQoXG6dZ22?=
 =?us-ascii?Q?CLq/bv0b+w74kc9ndJkGj6KJGz7NAA8kaEyzCDWd7xuAzAn1Coo0LgwMk5EV?=
 =?us-ascii?Q?7x8NljZEw8B2l4udIqJTZ883lmIsvFr9jRhEO1x55vnEoFmRuL+uBoDHtXKG?=
 =?us-ascii?Q?xpvT15TG5qgKSzMBwmTI7GYNEh7Lc2UI2Xo1Rg1pCO3rAy9ZrVZ++whUOOeS?=
 =?us-ascii?Q?B8PEUDgP9r0WCC8paOkf4HINzhJapWxBqf4JJzdCIiwbWlJNCABNCau3iZuk?=
 =?us-ascii?Q?/J4/LPJPChjI7SwRnp9DM7pYh/bw7tKCP5A/kJHvSUWm83rOObSk11/PHAJm?=
 =?us-ascii?Q?MfXBVmAQiPpIlg4fyrqAxhxekw1P5PmJCh4b3Ps/kUSK28vL0pjaxr+9gQx2?=
 =?us-ascii?Q?V6n9Lq2O3hvKOfEGWlPCoirHEIumfCvKYJFGoW+x6XAA1DRYmWPwolenyttm?=
 =?us-ascii?Q?Z/PPRO0SA6voBuNRnmM0AfbreJxdIcDWHojsPyWGUIHTVrNc2RuhjVtd7dDb?=
 =?us-ascii?Q?aFQGQ5+Hh1amDNRm4dpk4YsD5pjszDA+yFmRPMMHb2DxYu1aufVjBe0WU/dH?=
 =?us-ascii?Q?P1dI2cwM0WRdC+zEmMh+7pWflHbVh8N1RDGZubYq2Jjc8Pn0rd5FF9Sya5lt?=
 =?us-ascii?Q?dJQm8Pqqr2d7UUq1MBRzyAjaln6lTegxUs7bwUexihxBiEqUfMv0p1Jttjy+?=
 =?us-ascii?Q?YRiPa3DZlOgWMTd4YllOUQgjpTi21l512XiL5OY55SvF9xF7FgAIozrdnZo4?=
 =?us-ascii?Q?Hcg2Bu+WRA7TKAXCielW/Hc+oYmqdVNQ2lUVwuqoB8GZHkVWhZEimtkVI90c?=
 =?us-ascii?Q?z8NcZLqw6o6kL6SBkh/xdkh2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b521b784-e8fb-4e2b-5220-08d950c686bd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:44.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PikqLLJY1ziZpJTkuVwJMfd/IllMkf3w24/o9HyTXAqwLC9DmP1AznkQcmmPYB2rWorl7N5L0fYMFQxWyd/iXV3kPDJix66ZGdeTTadjf3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2791
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: btNJB8zv4_ENaOsZVhV2d7e8kdHj-siP
X-Proofpoint-ORIG-GUID: btNJB8zv4_ENaOsZVhV2d7e8kdHj-siP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: c910d5b5ad8de13953197637b74f3e5c25960410

This patch renames the following functions to make the nameing scheme more consistent:
xfs_attr_shortform_remove -> xfs_attr_sf_removename
xfs_attr_node_remove_name -> xfs_attr_node_removename
xfs_attr_set_fmt -> xfs_attr_sf_addname

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 18 +++++++++---------
 libxfs/xfs_attr_leaf.c |  2 +-
 libxfs/xfs_attr_leaf.h |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index cbac761..8f6f175 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -63,8 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 			     struct xfs_buf **leaf_bp);
-STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
-				     struct xfs_da_state *state);
+STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
+				    struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -298,7 +298,7 @@ xfs_attr_set_args(
 }
 
 STATIC int
-xfs_attr_set_fmt(
+xfs_attr_sf_addname(
 	struct xfs_delattr_context	*dac,
 	struct xfs_buf			**leaf_bp)
 {
@@ -367,7 +367,7 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac, leaf_bp);
+			return xfs_attr_sf_addname(dac, leaf_bp);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -840,7 +840,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
 			return retval;
-		retval = xfs_attr_shortform_remove(args);
+		retval = xfs_attr_sf_removename(args);
 		if (retval)
 			return retval;
 		/*
@@ -1223,7 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
 	if (error)
 		goto out;
 
-	error = xfs_attr_node_remove_name(args, state);
+	error = xfs_attr_node_removename(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
@@ -1339,7 +1339,7 @@ out:
 }
 
 STATIC int
-xfs_attr_node_remove_name(
+xfs_attr_node_removename(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
@@ -1390,7 +1390,7 @@ xfs_attr_remove_iter(
 		 * thus state transitions. Call the right helper and return.
 		 */
 		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-			return xfs_attr_shortform_remove(args);
+			return xfs_attr_sf_removename(args);
 
 		if (xfs_attr_is_leaf(dp))
 			return xfs_attr_leaf_removename(args);
@@ -1453,7 +1453,7 @@ xfs_attr_remove_iter(
 				goto out;
 		}
 
-		retval = xfs_attr_node_remove_name(args, state);
+		retval = xfs_attr_node_removename(args, state);
 
 		/*
 		 * Check to see if the tree needs to be collapsed. If so, roll
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 08600ea..e23fc3d 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -770,7 +770,7 @@ xfs_attr_fork_remove(
  * Remove an attribute from the shortform attribute list structure.
  */
 int
-xfs_attr_shortform_remove(
+xfs_attr_sf_removename(
 	struct xfs_da_args		*args)
 {
 	struct xfs_attr_shortform	*sf;
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 9b1c59f..efa757f 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -51,7 +51,7 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 			struct xfs_buf **leaf_bp);
-int	xfs_attr_shortform_remove(struct xfs_da_args *args);
+int	xfs_attr_sf_removename(struct xfs_da_args *args);
 int	xfs_attr_sf_findname(struct xfs_da_args *args,
 			     struct xfs_attr_sf_entry **sfep,
 			     unsigned int *basep);
-- 
2.7.4

