Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB95C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED93961418
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbhD1IK3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35826 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbhD1IKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S7xP2X010061
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NYCBjTkB0ufDS/cT1In+t4bRFyWQh1tJLthLRHR8kK8=;
 b=fec4jfSgYhfHxceONi9XHtUJSj1n9jlB5fdz7z1DKNEMh2LA/Fj6iU69QjbZMSKDl8YU
 o2orAT7c8R2PidO6I340V6YSsADLcO57gY/JBf3XzUoHz+UEhOARYmJZ+jffXOgu0mFk
 xEViXJub90qQ4IMBGISAQ4u0V2GxwG7WS0HuLIOpaj+r2xD/5KQ2/WYuRJaPSoLKCH5C
 c9j+4BgaBpBmL0y/+N0aTNjoPkwFh/EXLbXR6cXgWuUSNbTuCwjwQnNcqQjJwG6JxVsD
 Kb5szIPRyKUKEt8RgeydkQD0wrPaGJ6ieVbb4j9QF8KbKqcJl7ovEfRO5Jwkv411H09w Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385afsyw35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJl196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:37 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCFZgtIB5E/EpGh9iYKonaONy7W3P8qongNIjUT2CmTNF55baagkV+ixdaqLVhepFcwhJkFf8Fw/XU+9THVw7AZun6m/ros7/BhnAzkH92zEZugp0I1flWA6QLWFPm6p1bD4q9FKFC1CkNLFGXL7gCNGG6FNVpZP//Pp5jBhg1SebdCXK8ZhtDgsiaEPAVtvixAL9CcEJZibywNRoHza+hZB6Yvpa1wEIHRkTxY2vmU29ZchTQYGWHN1Pnw1mxWSiC+bw9ne0uGFuqnr0vkVssVUmgwh8P1Vo7BwOD/lpuTFlG5SlzKTxR7L6pdBKIvp5DloZ/UygaZgvRgNtDIqsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYCBjTkB0ufDS/cT1In+t4bRFyWQh1tJLthLRHR8kK8=;
 b=W9eSsShA+nP6Ve7HZwsLqhgIHwxiiB+nEohB5GY0HfvgHy7fTN12MAziEyGgmvsykerZj0IvgrP88jmYYObLcVvM+5eyx/4ZXG+JnZxfm0jZOTQKxsbFwQ6jcX1spb/6ArosZYsH4/C6SR9J9YTIiwMy6yWLmbcjRrazzrI14r0QlNt/mm4P5kn9QBI0IrbikT4xZVE2Zw/YkAIe8Q+ICeaoSBCMoCA/FXCDVbwAvLOFXabjBImd8KAkVJBKGER68edI1cRg+aHoaX7cf2IbSdlCy82MvHLS26P+zM5Ms6plyfOxfZ9ETMPc9T65Yi9CY+eOIlbxxKowF6Ec31MEHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYCBjTkB0ufDS/cT1In+t4bRFyWQh1tJLthLRHR8kK8=;
 b=uT6dTjfW6hlBoXF35ysVZddZ0qW20vWlSHkZvciFk/rPHh6wU4/DC0I5TUqUvlEQnhNfJ5n2WrgB0bndiKuhdHuqqhPXyoHVDHgrhmOro8BOqNG6cdDjC+qXyPfrDhptr4q2qedmc2EXoqmR2algHHItPj6yaTBaaBaT0PwZ9qA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 08/11] xfs: Hoist xfs_attr_leaf_addname
Date:   Wed, 28 Apr 2021 01:09:16 -0700
Message-Id: <20210428080919.20331-9-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f88db0b-1c01-4c19-8718-08d90a1cf564
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB40862B6461F9CC9E5DEA85B395409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4KnSJIqMg6OdvKwqJ11CnZNZSlnI/1irUx7qZQ+3DlcYSFRNYIxwypafaRFCKnVDOBrhGMZ9AaeSWfrfq2w2TRUw/KTjAJ76pQelWBFiVb3jdFMhqfirj5m5/v8chGT+/ThySYIA4HqGtpmshzGB8KqEdRenuno9d4l2iSz95b4Y1skJ5Jg4qWeVcv1zGT/K5UzC/M2dx78rnve75kaeKDCZUlTfVU5EmE9VT6vSjO2b6sYv5PFaA7a5k5mFzFzXEv9BhewROCh4iXbs2JLvqEHanIucLoAUD/gbbwuHbWsghYUdYw7srML695E4r14A6gTvaIgFnl0C674o4fud6F2hVDA5a6tJKnBqsFyS4Jr0aEayjzGJZYVvyNbMF9hWNXCRs3Nb0leOuVhhDXfQDb67I6KomexGOXDekno1B//Dcp0OEmsy8MimjMWIeDObZvHO3PJ8lNJiTp9UhDw91a6UL4W7QOFuVTbtQhSX8qOGPFof+/djQJX5QkP7+nP8BiOzjoHnKSfd5O8zO1Kj5ftUcek3LBddaLfBJDJxq9bm1hEKn6U8RlbZxDAqnBV0YjSRm1miropXvYP1DeaP5Qfbes7aw2K2OavItzMxXMoBeelSSWaaD6kDB0saGbr2Q/NZcnb65V423wXrKhp1MrzG4WmXL4TbjyBbx8rdf05LWhDrx9jKNRgVPRx1F+e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9t4O2RQiusTGiSDtp6MlICgar8Cy2mSD7xifOGeezNbFcqc8GP5ghEX9T/hc?=
 =?us-ascii?Q?6X7X3ujB3XB6Ijc+W5aZWqTLKrrflBsYSWPPndjFIL0VzVb37TbTDvKq3PmP?=
 =?us-ascii?Q?XcNY/DTyI+d9JlP8V9+ZcVB6pZnn5oduNbRjflhtF1VJ1U23Ska7W9yP4xo7?=
 =?us-ascii?Q?Vbo6EXEY83/YDjXuwMpDuRPuFFMk9hhFlZiIXAkTI7L+K9fydp5hdLv+BHdl?=
 =?us-ascii?Q?4ID1GQEWZY10dKjRG5cJKUy8BSZLUcBKPXir6E/dTP4pjTWeRoDKzj9H7zcs?=
 =?us-ascii?Q?YRQ0JLpwhSJ1wV7RxBji1yrJzLZUCvF8UhWQQnxlpVf3DVL5JH9b559xLxGC?=
 =?us-ascii?Q?/N7t8i5DoWYo8aLsYgYPNFbwlj9y2CcaBJ7/EhgF54j81A6Qapfu/YeisfsT?=
 =?us-ascii?Q?0BJbLztF7EgaZY7IHcrA7W13oYxqSydhD9gWrXaxE8JUiIfb9pVmvVtON2fT?=
 =?us-ascii?Q?4t4QQkqwvK0r5PyrwZS/T1p1dk5hTrBc5DwaXtYNz22aZMjhj7OFDC5TWGzz?=
 =?us-ascii?Q?aNTUDpUgSWaBzPp3RtKpLOF/5uPw7SAWspYQLmxXaag/BEHhXzNuPsSE0TK7?=
 =?us-ascii?Q?e2bG49nbrNa4VE1ZIl8XQuMLIClwoNgdrFb2eh+AdaH/3P3tM7LccGCl1V55?=
 =?us-ascii?Q?idp2ONyQKqLd74FO0a+6hwRmGq++0cQgEDbnr9x9E7X/xkrYmpBo7BsCNdkc?=
 =?us-ascii?Q?4ny7dJeyu4g9WiVFiG+ckNf5kwkBputmvsvO5niity/AFOHrM6TJ7QYvukhQ?=
 =?us-ascii?Q?zUQWW1gP5vO+94/bLC13tWt339KoCwr8sZG65cZbJ/9UWFsBYzzhHW/pLQgT?=
 =?us-ascii?Q?7be5rYEOwLCAzXzwXQsOP/nnGEf7o6ivHVBibp6As8vxgMQBYWysjfPZGpE+?=
 =?us-ascii?Q?Sq2MXu0N9jmjivjCoi+7mlf7XsieX+cYNxHfi+6d7duEAUQlH+wmFEWh4nDL?=
 =?us-ascii?Q?ByBBYYuP7cAGS5BArmhOSJnYxmqUt/it8yUpJzYmSAzNz/aVdO1ex3/VPp9m?=
 =?us-ascii?Q?UqyZZlMIpXTbfR0TMXtEoJh/mFgEw2OTrnXDo4e+lgW8OHp8mT/Cd3ATfMyb?=
 =?us-ascii?Q?PT04buATDZwY4bErFCu15J39Qe7uSx6/fyCDMvRuzRCOBOx8El4u/u8cYhsx?=
 =?us-ascii?Q?PHOTqJSn5DQc7AQPHJaWiz5fCYdJdSdhSjlSlQ4WZchzLerKXU/gVorUqDt4?=
 =?us-ascii?Q?vrPLUPyXG8mOQTbdmlJghkkR6XmL/Jtc8H8R4+QiNrsTF3xhv14qAiwD2Zwk?=
 =?us-ascii?Q?X04bVzHUcuXULzAp3nG6dOy/xg1J87PO8flsR9hpuQq9gXnspQCExIQC27N/?=
 =?us-ascii?Q?wXFTdNExBBS1UYO12Q+tdV+M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f88db0b-1c01-4c19-8718-08d90a1cf564
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:34.4154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: teJyIw1xt1MkfuyuknGSvJs2BCA85AgbvMMaee37G47seG2GK1qR27JVYXFOg92AJP0yCnlow65LXPdejDavurGUp9lToAj6qfu7oi9i5CU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-GUID: 6wdJhFE4NF6NCzcfTeg5dg91JevrWzwa
X-Proofpoint-ORIG-GUID: 6wdJhFE4NF6NCzcfTeg5dg91JevrWzwa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particularly aesthetic right away, but it is a
preliminary step to merging in the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
 fs/xfs/xfs_trace.h       |   1 -
 2 files changed, 96 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3cc09e2..6edc3db 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -44,9 +44,9 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -291,8 +291,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -307,10 +308,101 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_addname(args);
-		if (error != -ENOSPC)
+		error = xfs_attr_leaf_try_add(args, bp);
+		if (error == -ENOSPC)
+			goto node;
+		else if (error)
+			return error;
+
+		/*
+		 * Commit the transaction that added the attr name so that
+		 * later routines can manage their own transactions.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_set(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete
+			 *flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+
+			return error;
+		}
+
+		/*
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 */
+
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			return error;
+
+		/*
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
+		 */
+		xfs_attr_restore_rmt_blk(args);
+
+		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
+			error = xfs_attr_rmtval_remove(args);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Read in the block containing the "old" attr, then remove the
+		 * "old" attr from that block (neat, huh!)
+		 */
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+					   &bp);
+		if (error)
 			return error;
 
+		xfs_attr3_leaf_remove(bp, args);
+
+		/*
+		 * If the result is small enough, shrink it all into the inode.
+		 */
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+
+		return error;
+node:
 		/*
 		 * Promote the attribute list to the Btree format.
 		 */
@@ -737,115 +829,6 @@ xfs_attr_leaf_try_add(
 	return retval;
 }
 
-
-/*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- */
-STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
-{
-	int			error, forkoff;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-
-	trace_xfs_attr_leaf_addname(args);
-
-	error = xfs_attr_leaf_try_add(args, bp);
-	if (error)
-		return error;
-
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-
-		return error;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		return error;
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		return error;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
-	/*
-	 * Read in the block containing the "old" attr, then remove the "old"
-	 * attr from that block (neat, huh!)
-	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-				   &bp);
-	if (error)
-		return error;
-
-	xfs_attr3_leaf_remove(bp, args);
-
-	/*
-	 * If the result is small enough, shrink it all into the inode.
-	 */
-	forkoff = xfs_attr_shortform_allfit(bp, dp);
-	if (forkoff)
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-		/* bp is gone due to xfs_da_shrink_inode */
-
-	return error;
-}
-
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 808ae33..3c1c830 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1914,7 +1914,6 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_old);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_new);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_work);
-DEFINE_ATTR_EVENT(xfs_attr_leaf_addname);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_create);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_compact);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_get);
-- 
2.7.4

