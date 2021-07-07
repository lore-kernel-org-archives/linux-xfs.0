Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AB5C11F68
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4C261CD3
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhGGWYL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21936 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230371AbhGGWYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:10 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKp0K013780
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BVF4NE4S68Km0eRx5AwkuKHN9UjojE9+vUscfwQ9HMg=;
 b=Amfq0sXIM3xs4WFnZ9dvDnql/3uzDEDM7PSo7WcZWNHhwZmIXZtwGk4CRU4TnKUeM2VI
 BB5o4/dIhHWt/1hLeDS/x1/QKNgmUg7ZxE2FfCQk6mNOscjOORUunYCoao16LSJzF2KY
 CNIwBPEm1uc62Rh9aYiutJnvhu7vkObt/lVTFWAWtiGdj0jPabj3GJUI99jFs4F+PSbL
 sMTWiMPQSRy1ebzRdgeKzELZ/xpgXhXCBHnPXbxWNrFaR5jyQ4PJ9C6RQoP/wfN2Eyb+
 Ogw+sesH3mDcBb5wqgTWpDRkw27UZrP+GXo/La0T3hQwk5Kf6ynigXVs8+S6c8fZi/Aj hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nbsxs6rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSg092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeuMwYh1GKoM6aXP4++TVagx+6jXrlvv23ylSMO2tjrf9/K/duhwtX7SbgdN5Tpw7///aKn2lEgBB09dipyi7+7OvWp+okw2tkxSaE+of2AoaxFSrALz5FruCZRPi4b+5lulou/K43RUw/YX9KbHnnFDOI/UgJz4P5E7Qn+0U2erVKBTog61JIzZth5kd5OiVRSOEKXNlBMwfNlorZw2+ey3ylp22JvemQT2Z+kKfXBo2pVr0tDyYY1sYH8JL0Z7cvw43RA3Z/X8/loe9KUuY4D0Re2SXGo9FFwOUDbywQoUuENq516vhtq+V8YhCPa3upIcd7DdBpqKe1evfAqINw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVF4NE4S68Km0eRx5AwkuKHN9UjojE9+vUscfwQ9HMg=;
 b=nL7wZvMiFvng/5Ph/HlDn3z/1PjOnjRiychjiKml/PzREtRNtaOOX0kePGOpGkFcuFWpWGD4iCPbQBRr0hE8tXNDDJHI6nelZFUnwTrI/OY1gl4vCcZHxk+Eb+UP4cDSCq/FrsIS18G29rtHYJb+gscxsdtOP+KP2dYZg2t8Jz5ccSw8bOhYBJ+cGCDpOLS6e6/D3Ov4DHlTxPvumwx0N/4RYnlvlquC+Jc0fkX5hM6RMb0sWQFF7EzEqOsQxwPTSvcX1e3s8M+LTo3676CqUVDoTQlkUdsepba8d3hNHL0xi7HnDJ5HsKqqb3y50ujNMZtJrer8WW5Ro9nUQ46P7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVF4NE4S68Km0eRx5AwkuKHN9UjojE9+vUscfwQ9HMg=;
 b=y02rdR1Ov+KkAyDwXHXoH23XsPWLRnCYMIhJforEZfGQ4KCcHK7FqiXM4OVk7MFUI+0xWrSjGaXD2J1g0wDP8RxZ1Yx2xdAUaqe3rVqYS9iP0KnBHUurHp+T9T5QvizGSru8jeIUphhGOxCjqSFZ7kuYiV/mCq3oZ+cPxgkaeN8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 07/13] RFC xfs: Skip flip flags for delayed attrs
Date:   Wed,  7 Jul 2021 15:21:05 -0700
Message-Id: <20210707222111.16339-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f3b2173-3728-4cd7-ca57-08d941958f01
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27609B9900DAE5ABF1595B47951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nvkGE2f9jnkgu6jzJv5zXLqyuo1FYCtgPiENo+bGlq9fY69OA1UkW5fC9EeJeKYQPy0EzSReWuOhAc0+Cj6LLuZYSjDy/lmyuKB1o8XaMbTBZJKxAufpptcYIN2/fm+F+cike6rMngOailui9apPqlN5Cgk0Dr93rdlCgLMue5o8XjZvakakEf/tafbTK4McjZRJHFxr9fplAwNBjy2askvmfNaytYq7S3QWQga63J89NQlCgmKWpUKZ7n/9fpKGQFyaslZLeDpwnmL2oTFK4djetXSXsW/R67408WvAFDV5KrSNk5h+chVTHs5M+FdIcvBHY3Na9tWZG2Mc8Ry8aBAxubZi9y7ffXmZOXxzMkXxJB30e2PK6R0FrbGPTRX9BRMIvC46r6xL6gxyFaHHbdDhVENYysceOnveJnnXb/DSj/CfTvwArG2wGijC9zZfx9Wlr+vl8YTUfgKzLgOKu3hulJQSe97oASx2tmqiZ/VwgXTQ6/0QhShF6I6fcbTkThyM9YfvApsQQ4UuipN4lHlrTmHt4vqSspIcqvDCVGwvPzrodH8/kU/mKsj5cPr/aQAXOKcEqzqTYpoOQcQmM1/SxgOGxIsK7HhDmh/XGq2/JQyVDEEwy+rcytpTQg1vflwcBNgxWZBxB4Q8VJDkNwN5rol0pMNIflPYxJPPMpL9+suT34dYpYNXNSO9X0PH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gft64SwOWQ6VS311dyexcU52y4j9bsi/zHbislksfd8NqrxEQ9AY+WCA74IE?=
 =?us-ascii?Q?omxECoEwRnZxzD6X6gSlydlzxedpN8OgmB/JfRUDJUx6D8Wpjhu9pDgkOhgc?=
 =?us-ascii?Q?Z0xl2gOpAXpFuCLtbVqAJPK8UoVTkhojFULQtcA+RaB4YUKKS1AiMgSezmvS?=
 =?us-ascii?Q?yEvnlj+IHIt2YaSI6dxxRdUWeO2ABZ/UB3DRyP9oXbgierQ3vRShZDngYgFQ?=
 =?us-ascii?Q?YuN8QLYMdZ2n8QEyVIXfnf4CHbnn5/Qu/bIWCKYHRrS5wUtJ0rlv/vym50zg?=
 =?us-ascii?Q?qgDRUI/NCXWhNSC9fGfXrVylgrwmQQsHG2Jwzlgq4+TvXtAJTVXi4XNUWVis?=
 =?us-ascii?Q?Df0jw9a0yMAa0x88oI+hdcboepHQmuXw8JD8ctDDDCANvoBqWDyILtKriE5W?=
 =?us-ascii?Q?hRb+pDquCZiS4puFKXyVAPjaY6wv9pBHcNHbqV+Ay8Xt1yMbDeFYBwscZud/?=
 =?us-ascii?Q?NCEesYVr2dNeFgzlN3fLpEgxhpzRXutcqc8lfFpVaseC85/219kYHaCnvBqO?=
 =?us-ascii?Q?mA22z2Xh97MOaByqKAIlGhjK6YSD9kDnl2/Yxb1VFkYXe2hlky9qenVqICiA?=
 =?us-ascii?Q?V0u0svrODznpMCDJFuoViaA5k/Jez4kx4kaWCMI69GrB6hrHI21xtKg0V0mQ?=
 =?us-ascii?Q?3xGc+RG1y29ptnFhAuYlJHm1WT1GDCXaqtjBsjMbi9djz9e1I8PlNPmONIs8?=
 =?us-ascii?Q?g0uvWysRcn7YcXCHgKCeYcEw8rCAVxuUIbaaj3Vj+9MureyAS5indZ5Kgvdg?=
 =?us-ascii?Q?GSgqsbodHYitvlw0YPZ6vuJKI9mWNRO1jBa/+Mzgx1Kxm5EIZ048LIfF4He/?=
 =?us-ascii?Q?TXlbk9csjZMKqitDUSucF5rr7W5RXnRskYurnvxHPKW0EOKvXqRSopsptmkX?=
 =?us-ascii?Q?uXpA1JFoWmtjTMFNyK5sPgn7n/k9ejrYhFXVfoF3C2IFpOklkYgJzNdzDYx4?=
 =?us-ascii?Q?rHkcIKTVWM/xetONoYYbJUW9fskOVqlYdyu3rsYAOOk4U0YRUQOkbe7u4Hfn?=
 =?us-ascii?Q?e1s5LrAzihWk/zkQqupQ4fwsAzwV6BBdpvmzUo7dUoGXc5qjL8f8jVbMPBaX?=
 =?us-ascii?Q?O+m8ZYCcyHsQpXg3QSc7byKhCOHeLWPgau33KTDDMv6HXwSKNK1KBUDGsSZg?=
 =?us-ascii?Q?6/v5+fO2QLz0uKyMJ6Btqsz0OyJqhQGIOT/aE9jhGu9NEnov3ouvKKBOjh0N?=
 =?us-ascii?Q?ocvfB/4Tao7AXeqRTDlRbZSF0beqez5a1cAWddO38lcOmZTNQPOb82Yerw0M?=
 =?us-ascii?Q?Nu0t9DWKFEw80fv8XIa9dxcklroVnI6rXoSZv6LWrRUcZtsx0CyzNSbhfo/v?=
 =?us-ascii?Q?Cz4a3je1QZnfOMLKoqtZhdxa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3b2173-3728-4cd7-ca57-08d941958f01
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:25.6350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2q0vl9T3Xv0RwjRjI2S0pz/IfUeuUCxxtjZVDYJVYwopPpOfuFuLwe6WtzWQcdETTkb6TbprzLNzl81B5zcIo7obeehYFZthn+5SHisKnoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-ORIG-GUID: p8N0wj5Ih4okVjdi-fqJjMDZ1iaP1k2Z
X-Proofpoint-GUID: p8N0wj5Ih4okVjdi-fqJjMDZ1iaP1k2Z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

RFC: In the last review, folks asked for some performance analysis, so I
did a few perf captures with and with out this patch.  What I found was
that there wasnt very much difference at all between having the patch or
not having it.  Of the time we do spend in the affected code, the
percentage is small.  Most of the time we spend about %0.03 of the time
in this function, with or with out the patch.  Occasionally we get a
0.02%, though not often.  So I think this starts to challenge needing
this patch at all. This patch was requested some number of reviews ago,
be perhaps in light of the findings, it may no longer be of interest.

     0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter

Keep it or drop it?

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index bdcdadc..034d08b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -355,6 +355,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -476,16 +477,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -587,17 +593,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		/* fallthrough */
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1241,7 +1251,6 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b910bd2..a9116ee 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1482,7 +1482,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_hasdelattr(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.7.4

