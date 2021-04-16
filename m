Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D332C43461
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D63611AB
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbhDPJTB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35032 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239914AbhDPJTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99K0g026179
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=la5nbg9NmKhmFiVUAgJe8heJCrfXb2X7CSyI+9IYPa4=;
 b=Es3xPMI6wzh/IlxRR4vi0YWjGKok9wYNKPBxAWgK3Y/pf5N4g9Kqm/u3jRHyC44rbmE2
 Bfff6tXe87n6VpXbsNT4vWm8AYRGT5AyePPf49nigF3V8swCWvMGMuOWRh+KULxqnM6Y
 5q2WlHYUjFrD0gEiKypk9OrMpcIECE6KTHcuQvi6xOUyK8uNHy7EpIfUL9kKwW7F42C5
 jdcBLT8jQTW7AQ5mgEDjyZhDAzDoSvgU+oihBGNMEhI0ONqsZZZAwhv8dmCwzHIYxAGf
 a1qV9VKqGMDDyvZcvL5jQuAGxDdYU0JzW9vbyV9fsmUn3vOdF1wtZkI5fqFsuoS5uzOu 6w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnrh8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXpU077087
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 37uny2cbx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qn00NTTiD2jmRyp4zClAbYPh6RQDGyRW0z+ilm+n7UFUb7xddA+H+0OdoJnqp3NdRqBAqMyolc4cowq98zA5TckoKz4Pto/L7lZaQOyUtmJZmH/PcAlKWpysCGvgAviuyAhFmB4uaAcbAAjyoMh6SYeuvGtc1ujmZ5V9j7CIPMmmCpsSbsCy+4rTGUcBsQw9P+WdvRiz1uzf1tCTyr98bq/rsrfZdvYjMTYLfC8/ie0q+oC45WSNH5L1+AlpfH5lUjDLuwrqgg4+ZR6CBirWysUzXebWwc3+rEoFBa9ibQ2x4R81mbduFajUYjZYoguBYnXD60Qf/EOH4WKeNvIV9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=la5nbg9NmKhmFiVUAgJe8heJCrfXb2X7CSyI+9IYPa4=;
 b=V/ze6FQcGk/mLt7f0fb2MT8ZK/0gvbtNspKrK9Ix8eBCcVC/DT6i1/BsJo7s84GZvtoZWf8EnRKF5ruL13VHDcukYAEfxTHYoMWqzMQ3713Sqye0CgCEy0oJnnf6OaPYOWic/AbNHlNxBRzkFXJ1n7HPN2mOqF/yaM6H+1dSpKGhtUImkpAWh5dkVDkxJB0sSwLNn8wEb6fGmsgXyX8QDllikU5MK/64GRvOA49FqzYE+M7SxGxfv9/dE0uhUGls0lh+rwxNd64uG6JABOaWNtBY5U6azfzUTCvlGfbqIFURg/ZOJae5BIcyjk17YmyukFyvNfeLTQkkesRjm70awA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=la5nbg9NmKhmFiVUAgJe8heJCrfXb2X7CSyI+9IYPa4=;
 b=PGOihGDhlafDuqk2NzQxLAtGp6s3RjVssob2UygxIgm1sqCtJS7+WkqeZhgRrmrop+bMiE8LLOJpNJ9PcFnFTGu8F46OyU6E9pxnDuUqvo1iFjX5O1TX7J1C5w4r80hTQpmAWereffewWVzkRyD0wDJYUrkPaysVwmFNOfo/xpo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2486.namprd10.prod.outlook.com (2603:10b6:a02:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 09:18:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 05/12] xfsprogs: Add helper xfs_attr_set_fmt
Date:   Fri, 16 Apr 2021 02:18:07 -0700
Message-Id: <20210416091814.2041-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416091814.2041-1-allison.henderson@oracle.com>
References: <20210416091814.2041-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6ab935b-bbc9-4f14-6c77-08d900b89b54
X-MS-TrafficTypeDiagnostic: BYAPR10MB2486:
X-Microsoft-Antispam-PRVS: <BYAPR10MB248602ABEBB4410A54D94283954C9@BYAPR10MB2486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rW6KiYjGcHC3YEVXBQbcx1Hf40c69t4v69GNWY1OC/0e7KQYOsfyPF+wqXOOW2CMkI8TjYsjwTQ89rk/C4NNG6vgbDARvGp5XgbDmy+BZ/vxL3Ri0e0gRVqpEIHstCPIc+5tgwhsSjfXHVrx3t8LyhbXirjpMgq4d7lHtSMLdndMj86WPwka/ATE7NFMJ2/YlcBw6EZP1hxfjUEavGpD/te/xfWIPmdA107hBbbmvgNidB2phBCLIPGLEtnYRfLQIU1pw7CgA2FOZcPFK3MqbWukkut9EfdccBsFohRSJkcLibwUHYQUuci667WJCZwPZzXjjUb2IFkEqs3oxN6qW8FUu7ucajRJ09VdTeRfCXBIvOM828MBRB5E3V0FjF9aV3ADeIgevTDnSWLomDIgDsk4RcE/WvAPbAjXlPqdUduR1IvT03iSk24JXEMNY5oJfmRxcoWMTqzIwdNX+klR4U1dh+Hhi+68Bi6QUjYr+tG6WUpiuDbqWQeZ2+EvaG5j6Zq0JF3vnxSweoHha6t+m121M3XLW5Fhe/Z+Yh6CkMaUfjWFtFIu0d4dnoLfq+NgxriehIf6SXlIYywneG6vjK9PyJRgH8cLf+BXC5jdj9WHK7XRExeiT6z21388H0kjck4tpKgxK7ibd05NitHG6l2JOi2sS12B1YxaMKyOkd1QUCLCgaJ6Hf398rAujKat
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(39860400002)(346002)(8676002)(36756003)(8936002)(38100700002)(508600001)(38350700002)(6486002)(66556008)(66946007)(66476007)(956004)(52116002)(6506007)(6512007)(316002)(86362001)(44832011)(83380400001)(1076003)(26005)(2906002)(6916009)(6666004)(16526019)(186003)(69590400012)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vfV1BqHJVxmOuT4qLwnZMbqicUpjt/HOVGihd3vWERvzhH4WJ8aWjQpEKF1s?=
 =?us-ascii?Q?pQ9aWRspcQAqrujg7XGXSrLQdmvK1MiG6pW9xLMsdLxy9uZfUY5ofoNVys09?=
 =?us-ascii?Q?FgpYnJnnhFEem0xGkuQ9PB3ljScunAdVnM0xzJJsmfSSynLRdrBYUZxAddSI?=
 =?us-ascii?Q?hxQEr6KfxeqpsULW6wbrX/hlUxpUx5PgQXehbgXRU4Gk///5Iv/MAbSj+beL?=
 =?us-ascii?Q?cJmRlpT2h3X7D9P8pslMbCBfHvNUpq3258apMdznt8i9OAqd/3Y9M3zpja0P?=
 =?us-ascii?Q?NniH2/oYMEFkkds5Nce8J6fSfy1K0Tbj9kQSGhMMs4wXPNQZpoHaELUc3Lh6?=
 =?us-ascii?Q?fnQwk6+mg7+10l6DQo7By1RODAxTW2U7lStkkomSf5X737bdzMNvXLjbM+We?=
 =?us-ascii?Q?Wrdyru+Z4hWd+QXJ7qlo+cL6dNYjSrSQAN7XYCHzyUcPjs85u2RcywnwtEb7?=
 =?us-ascii?Q?D1n+oLfnorAUNJykebzF/Wev/4zgdpuOX365RojBJAsaZHeIovN6mZAPMjul?=
 =?us-ascii?Q?TRiLNKB28Bq1Zt6GNWOqacIbUB/e3v3d3MQLVGlpkBj+ztZJoynM2Sg738r0?=
 =?us-ascii?Q?29EuUi5NlEExV+mypz4hw3ON8nxe8YStooQZT78OGXCad+nWPMp8nL4KG94F?=
 =?us-ascii?Q?BTo9cZH32xvklm0e1abI8/Jvll69AQ2IQNkCw3hTwZNm3zb1gnEGKTX+/ra7?=
 =?us-ascii?Q?+irp9dd26O0Mr6wzJcG1+bII46/6/uoosuuB+EkbPWiQlk6jH3IlbCwVXX6t?=
 =?us-ascii?Q?764x9mc6XODyP2evK3++0A/lWBWpxFruT95E8MH348dNtm6gxYyUCLlrR6VI?=
 =?us-ascii?Q?GilbrlQDMXQzVL4PiRF2KCEwXjhlVu4ex/+A9oPo6BPGteOBFZDhu6BzhVqu?=
 =?us-ascii?Q?7RJStbKBTuuQLQgleLW+scyZiXpdoekO0bDecpCQf48mtQAChUBrbAG7iEEB?=
 =?us-ascii?Q?vxBIF2qnN5OK7adYAsKvtFG8jHPWIpVM+yphHS7gUJBFPb+8n16ah89MH/6V?=
 =?us-ascii?Q?OKL7HBAFRPkqQpYDxif+jQxz6GfKxCojlUbVzgwflzSljRyqUoHzzHA4GAVU?=
 =?us-ascii?Q?P6dTe3ddqYzxmNEf20EDrrsUuaHZa7rMVOWl8GuW5DkCy43HcmRZufAtQg8V?=
 =?us-ascii?Q?cYAKozKfAwiJk41FdOA6Rs5r3vodU0CglxJ4YWVVPmwEPyxa7Oldl0cl+jPg?=
 =?us-ascii?Q?fyLDhn0tXwGa1mS2G/KZMdiOvplWl0tDO0jI323imUBKomwAeeEG4mofpnJv?=
 =?us-ascii?Q?RNxp4DWBPxMVzw53yoCdQlpsOmPOEIKJza/cgC1K6pd/ojYl7AmqTFgleS/R?=
 =?us-ascii?Q?Tgx0aVcMvaUp+CLREUNz5WMj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ab935b-bbc9-4f14-6c77-08d900b89b54
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:33.1172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9TsvMF8pV4GR0MlkFFHgnzD8ulUsFdAjLZDGPxh/tX/z56VLFbsGTwPG0tuhK/ikVK1SHgiiHa6HD/s1hX+8V1+fLeeB198dSquUfney3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: SiZzlb3UPFPht1PFcpWQKzd28fL8D2DB
X-Proofpoint-GUID: SiZzlb3UPFPht1PFcpWQKzd28fL8D2DB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45b71a4f3fd8bc8d47adcbdfd859ed736a54e66b

This patch adds a helper function xfs_attr_set_fmt.  This will help
isolate the code that will require state management from the portions
that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
no further action is needed.  It returns -EAGAIN when shortform has been
transformed to leaf, and the calling function should proceed the set the
attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 30d29eb..40d1e6e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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

