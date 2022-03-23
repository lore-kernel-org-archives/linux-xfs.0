Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E8EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240959AbiCWVJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240953AbiCWVI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:08:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E878E1BA
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYAvY001478
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=a4n5szR4ar5CW6cUfu8a6RCOic85ieRG4y4Jem+qoro=;
 b=W42IL84+SbLSecofvJZV+FF7fHaul7Gc01eMCRgTopEjqrjClIJKg2vyJDrcuFxwc0Yi
 IObzJFIOQjRvVnEoPdSG7riBCXbnMjcA63ED0freqcdpZ/Ws8F99XKsOqjFjg1UWJ8fj
 bw4csfQ4Nm1MFg6bOBf7XuSOZcVqwp0wGbVP+0d3mUHqXXRw0hjmi+Ie18FIOQ75CaWp
 /dhGAWgVqjAIlRoIE4yWwwI8jxz49c3Zpu/60ELJacgGFcJd0u6zVH0pM1vX+/jWw6Sw
 sN8tqJtgjcmJexVdwld0aoud9p5s3zT3eXAi992jWSJcdlb4lAN3dVS1Bcfw7dZpDvx7 cg== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y22tcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6Ld8082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiN6pW/pShjRa5whyN4NyQhJDK3EceOGd+SosYqpNcnRDGIWitlBFDFrxlJjdAqyuovT49ICReOrHicj2Q7mb8nkxSz76woGH/DS0TFU3M645pjbXZ7obr7oLbSJDstvG+GUEsqQ47objCiaVY06Qzu5ZWX/Y6vvjk6q2LUnpqNqqsUnJyjhfluyX+v9+F/Q2WDQrvRCiju+yxMxyponFagNby1Tb/ZxH1wuEU2lKeyqSWHr54rjfkfKaegzGCCOzxjANjxqGdD4y6sPbinSGZd1wc8KaJzS9NGJ942c2x7LIM/5Ku6jyXyoUzYlVdvJJj2MtPO2RtfotpmaH5KEhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4n5szR4ar5CW6cUfu8a6RCOic85ieRG4y4Jem+qoro=;
 b=AKCqgzj1ce0XhTmWd1LtE4Ehvvr+7lxwOdE7nTMiVy1WpBN18Zhc5tS+/yjkBS4f9rOlrQgxtvswh3pY3TgkpyC2kqtQnqKf741+6kJM/qT7PhqUMkTW14QYhoQ2X4MB5Apk71RX0C6c6J6JIFdlnS6dsyUj917q7jM0fxScq6pUKSj3ZuBCt696f4bh6WoYEGwOETubOianFKR3rohv6GK9YA3gJDwCtF9W+EXTAm1C9q4JwGU6fZW45OTckvnLdLYKCtv8Edj7v0yt95qqzwm1DedGRbrdPLIZw8pjdKzxmeRdZ1SGl+9YmlnJI1Vp+9pQ/GRq80LAjoy6rKpItg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4n5szR4ar5CW6cUfu8a6RCOic85ieRG4y4Jem+qoro=;
 b=RlAdk1jCYo1mJ00YSLMwMeX9feRpIKckPYJi+3MYENqJUFdHrTVhj3Jt6NHxbQWrPO8NpynCg69l1mgpCxLlHpbBQqGMPDjIpzRppikSu5vwTGQo2XMY0oJnqLU8aCH0UDi1fl3Nqpizdo7gYlH6xNpYdQNsZyZtYJCUvpL6OOI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 01/15] xfs: Fix double unlock in defer capture code
Date:   Wed, 23 Mar 2022 14:07:01 -0700
Message-Id: <20220323210715.201009-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323210715.201009-1-allison.henderson@oracle.com>
References: <20220323210715.201009-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a82bdc1b-9113-4393-8c83-08da0d111fdf
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4744B401CD964B64AC0C9BD395189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vW+iaQmYW8lFllgZE+Zg2mwSFxZIlHUhtN/f1t1Fr9vV3OACXl62C131SjhM5ZT0stCtxB8uHcR2VjnCQbf9lFZN3CMwVNTuvOewut3DYybikncfLKee4XR6RfLgq6gvSS0n+2N/8JahtVPY0edQaypr/UWvFAUJSLrWz0Vx21zGmFrSdd/sXS2TXKwkzx3QLQbaIeuHH5USrVzkGaLeWuG+YtG5A2O8uJuu5jcAyHttgTVIxuZh5jVvM5WCmhHAz1MLmURuRIe1G1egZ+d3j6Ds0NC6Z+UEHufzgFR4eyLuwNKAiYzWulxJmHz3zGTgGBPUC8g3P0XJ+Gjyl2vzpFOR6UTNREQ5mlE3qeKE42jj/IlF0HZwL6C61saygADDeu0BILXTDkUzo/pkDSAUac/chuEV8ccBD7Ob/Jowr4W5xdG1NYNMZJ8qbutyB7DhPXPjehMaUTw4cfBblicBN0A3b+WWFNl8W6lFbp1wukFJJadc1HZBKHT9htYGSI0awA/12mQFCKpKl9NA8dk2Ounx/+BPCNtJ1+Q/oXh5FXjZSBhsmC92hNAEF7zN6+ya5WRz9X/Qv/celLCUftsvd2GAiO+oAsYnh8MaWEuiLCntg3Zn/cK+XglVSWhSCrtAyGrBM4xu60n/KWMp5Q/ZQ/jDjbMANgh7iPB4pXKho4/ZxqWvRBYWsrhiB7tqfLiDYBfgIxSPr1quTlrNrl317w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vqN8fROLtwLbk774rahC/IOdh62Jk+wmITziF7dwzVEJ7xQwpz9m3c3QcMbO?=
 =?us-ascii?Q?+viMFmNcQNVDREXX5PpI60SATLqPicyu2HexNu/K0iAvHYM2LJXPRzCfacHk?=
 =?us-ascii?Q?uHAnIPiXh+jhaJMJOe4jxNsiHv6RogQugHdnPRxCJ3LqW9DmH+3iEgYac4qO?=
 =?us-ascii?Q?PqrtlW7elkFsi3t+dhtlJCDULpEGdXsvrYBLdnm0V6/Jl5km72Zaq3udj/oX?=
 =?us-ascii?Q?vLLryODo6awB8bK1LL+YwjcGCz87I8jtaymlvAHJHeiQSl/Xpkq8XlvNZqw1?=
 =?us-ascii?Q?FdF3MTm1zDT/mviqtx5QBaERyx+rBHSQ4RJSWj3ivBZ7CtmGGfbbomM67JWG?=
 =?us-ascii?Q?lwdgSDR9WQ7Kes9UVj1823ql6Yv9B+EsDT8NPqp8dRIntPRyZv/RKL11q8P5?=
 =?us-ascii?Q?P0UVQ4bwBgCrUhw9CBD4nF+3i0ppyZGRwueq6ble+tFpf0Lakv5eFLB1U+RB?=
 =?us-ascii?Q?L0GbZZ9tMMbQW1k4SdHAWO1pJfgw1W3Rdki2q9Plgdv2JSKdlQsScve1tQ49?=
 =?us-ascii?Q?X0hIdkaIRrEcnVrFjcHoM9CGN9Mt3b0SLnhIHjJttleUxXAAkLnm7tDLXcFH?=
 =?us-ascii?Q?PfNqwDp4dPozWcPhEToLUgNhCnnZ9huj6V67TheWgcuILX2XaJQwKH2JrwR9?=
 =?us-ascii?Q?vXMVi3rDOxgvWrtK5qTQN+rxzYdIwEVw8nsVRDNpiEbDLPAeBb+4lFpGSFqZ?=
 =?us-ascii?Q?W06F/ZcJGPKvgkYfe3glHIMO5XCJx+4NLKPdgZW0sVRSFzVhjj6mF/iQ62Jy?=
 =?us-ascii?Q?Ru5R8wlPm20nHtX1dwnt+FZONDLdjT89yb/BgVIU84/llTTaGaKz7WCu7ARr?=
 =?us-ascii?Q?o5vNVCnqbPTzzNdC9Umw5d5TE5YtPwTLDEANrDLXzlqONeiSFrO0QhNH1rbq?=
 =?us-ascii?Q?ye83lk8/IpFa99CrWNcQwkmM72WV/LcTOa/4IDJxSTFnvHch16bk9tiIBuYB?=
 =?us-ascii?Q?jwMw4LUiFTH9lafHorbaMq3rpA4jVPERiSdws/SM4Cp8yJczoqdSuFSTmf3M?=
 =?us-ascii?Q?sfXLtYEZdxqVjctorYLnIYbrdAlSaYrEgASEkjQ9HSvwY5qSX1spZhqjSi0m?=
 =?us-ascii?Q?tC5yo61cqrT56nsfZw7vW6xCQdepfdyv7qRWmRY4jZxpJXCYj+s7xqxuEZEK?=
 =?us-ascii?Q?P4v0SXqcdmAys8gOPObULfNymWi2mnhnvynzQHPG6gQnH2h8vfCG6mIxDDyj?=
 =?us-ascii?Q?laxKAFBEYoUf/1c8Jrxy2dJzenO5ttsyMLrc8iN4KQ5CVSonuejGJKj2VhHh?=
 =?us-ascii?Q?DnS0PsBj1aKnll4FvefG7I81kV08olaJi3USsTJSmn89rQa5nHkfWM1LjH3o?=
 =?us-ascii?Q?m3EUW7+oKQZ1jJvAY1ieGTGY9bSShOJzsprb22EiB6hGex9tlqZ23Z3KImpW?=
 =?us-ascii?Q?SwirIDB8xZrYHzUOcpoVlt8nXW/u87MBcTcZ3LI1NApfwY29X0qdtHapnWdZ?=
 =?us-ascii?Q?rxE9avow8bHHc8VlaXFpRn97Uce86+3ksvw6nlre0Sa2ps9YRIWU7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a82bdc1b-9113-4393-8c83-08da0d111fdf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:22.8258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +6ntHf8CyUt/vdJju15Bs7awYxbWkeM/uHzNYtKIeAMO1VXMfkRVvx5e3tTKCvstuqwNcRDy+6xiEphUHhqsvy4IaVGSxbG6v2kHe/1jhHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: 4gLltsLlJ2pxkS4iQymVo4ytltbCGh5X
X-Proofpoint-ORIG-GUID: 4gLltsLlJ2pxkS4iQymVo4ytltbCGh5X
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new deferred attr patch set uncovered a double unlock in the
recent port of the defer ops capture and continue code.  During log
recovery, we're allowed to hold buffers to a transaction that's being
used to replay an intent item.  When we capture the resources as part
of scheduling a continuation of an intent chain, we call xfs_buf_hold
to retain our reference to the buffer beyond the transaction commit,
but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
This means that xfs_defer_ops_continue needs to relock the buffers
before xfs_defer_restore_resources joins then tothe new transaction.

Additionally, the buffers should not be passed back via the dres
structure since they need to remain locked unlike the inodes.  So
simply set dr_bufs to zero after populating the dres structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0805ade2d300..6dac8d6b8c21 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
+#include "xfs_buf.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -774,17 +775,25 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
+	unsigned int			i;
+
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
-	/* Lock and join the captured inode to the new transaction. */
+	/* Lock the captured resources to the new transaction. */
 	if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
 		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
+
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		xfs_buf_lock(dfc->dfc_held.dr_bp[i]);
+
+	/* Join the captured resources to the new transaction. */
 	xfs_defer_restore_resources(tp, &dfc->dfc_held);
 	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
+	dres->dr_bufs = 0;
 
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
-- 
2.25.1

