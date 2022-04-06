Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A8DC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348879AbiDFJj6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586218AbiDFJhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:37:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BC22AEE17
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2365paEj024455;
        Wed, 6 Apr 2022 06:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=o20/PHWK5IaSkNeFO+/SkseLUtuePc2O6aNx3XrcFFQ=;
 b=0+K4OY2v9X1LN7oGt6SmyTZ53tFvE9dbBNSuSN0kievrKIc22U20kWxf7Te0ig1bqT3m
 k19OmV5IDWX9045Q9o1oCzCEn6I1jJx4EWS6XrlkcK1mwx1iFBMYHtN9N5oO4aio8FcM
 Pe1NrljfuYQK10kJXG2RLt5vyihYVlA6BREdlhkwMRveXzDqBiQtPy2bm8tlGB/GMOYQ
 0xTIUag5gfMfzYpPBmaWm7nUbmpF24G/lh/4v4Z7e6p9Wc5kVzR9ip07xU+StQN02weO
 ueuzWJQKQ/f7uWYW+i++5wwaWxdkL+u4x61VwYzn97MSIlAn6NI+EZRRlj4ZbP3B932g KA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t7yg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366Bbte040234;
        Wed, 6 Apr 2022 06:20:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx446vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9pwnXl+fVnQ72gKl2bnzGYb39X4lnAEM2SK3LYmt+ikPOhe3PCBeh01t/LgqG5on6vvg++M6HD+UrxEmEJbTrQJtCUEHtdDvVkXN5EV21Xe94hGuLAWiwBNWw6DBfk8iWifFgUm+PaaStgvxKAdGEbufcJq4hd9YbfdtJZZ/G/dkgNW7Ur1KfkHs24Gv9topLmbx9UA/78uw096wJqeENBBh74teLsVpiBFWc3043VVv63GRmXxcda8QChkDzcu5OQd1umL9zqF3cFI4woSLxzuylJTg2sTRE7sMpdJxpr4I8BKAz2VX+VtQtlcCgL3s6BpMvAdgHG0jXHHxdBqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o20/PHWK5IaSkNeFO+/SkseLUtuePc2O6aNx3XrcFFQ=;
 b=eSxjBCmxFjBEyN95X5zt/Bd8yUmVRWzeCjx3wHthedCTP8nVqVwgsaT03WTgo1I+vV9qfmV3HtxTCU46JSpZn1GBBk2iiehu6gsyTN7yelX3E2MDtIXx9CAdZ4ubsaiHL7rbXX61UtOENu2Q8NZOte98LGadaJnlcZafG+FmJHHxggZimeceQT8Qq+KcWL1ksuKk8kbbxaJtqKW5dTUoG4n816MfiWdequrYs1NQc8/zXAvtw3SxyHg5K12+ShEN3i65ZaMSkHElc3oMPo+T/SYHlAjwjs0iPUQhy/x0A8CaMl5c10o2vyLl5G/Vlx6tPKzDBNY/sbg0zo9gxkPkVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o20/PHWK5IaSkNeFO+/SkseLUtuePc2O6aNx3XrcFFQ=;
 b=kNekjsavKd2l6es62vEL1L89bHleYcaGNASwIZMYllyYWqylXtTKCAvVr1RKvQu9/xr0X/3fi3EXiU0Hty4XhLISQNJb+wcMv9HQ9nzGTpY9lJm49/qf/LPufPk5pLGoOH0EQCdlEi2CtQhEiuAyZAqzdDWQKexxskpfj1OYy4Y=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 17/19] xfs: Decouple XFS_IBULK flags from XFS_IWALK flags
Date:   Wed,  6 Apr 2022 11:49:01 +0530
Message-Id: <20220406061904.595597-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64b60fa5-2325-4d99-f44e-08da17959306
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55649A2330818EC1B7FB300EF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPeJpnqeYfpPO1Z891ChPmQDyjFadBX8AeRWtrXZk85oMPSaNCE8EiZi8JPwvHgeQ4w78ksZWUhPsefH9BqpkqCNeZluqsfXln/qPqIHPOV/lewGRxUB2YDEGGkBt41MUoHPt6aL/IyC+dK4FGBYfL9MnnNDgMPv3AlS0ADLd4B/jn+z07eWCE2UGQDYt/+uYR04My8uncvaz0hwYeU1GKfCIaekpZqB2WKxz9uozSBBwn4fFgJPM/Jg01hbeJMBVPx9iMDLQrXY9Wi9o39bQ+3cgbWceTx0nC9B7xqEVp+SF7ahLb3bRNuvDuudTp1Y+wlC7AI5s1CvRQFuIk4Lt6I9TxeCJCayRDIXInIIBBcY4rPSvtsrN0ufuBJxKiy+iQPRtRE+N1S3AHV8YQVo1fAFzh9h2nSHd9S5cz4sFHV6nVjzcZKvlG3U6DqK+64ByPOTQY0lQNZ/vswnL+pTpG7Ty3rynrZESgt4beBb7OZvKhxTgQxSe8CuNGWNFfPbOGGHCPsFval6IrLgy11Xm0MQwz/nKeH/2CuAP2BuFf5tG47ScejSVqfIpV/SPuJDCKRw5m1wATOHV9LtaWGGF75sQdesKIgbizB0Hgl/EeESZsh9CGIj1I10qGiuQrFbuaa3FIs4DHAoh21eXgPxntpGp8qWpXdy8HUpviVkBYxFtlXFUE507XAsb/zhr3d1aDoMmP8WT2IyBJa4/P5tow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4BO1K5MG9h/Y/ZXMxNnZeTFa4r1lm0g0KIJczLnbyg4mIjyewViLd8MFZ2bS?=
 =?us-ascii?Q?eAEKy7Sj+pDF3LmsgQMM+3sgD0YvlGfx2lK8ePhn6Q3JfIthJjVy0RYGhJvW?=
 =?us-ascii?Q?DOs4sQtwzyxYz+Rhdw1Xyc1zURa6JCl58gdowRNa5br/sP8HGZvSu+R6aNC5?=
 =?us-ascii?Q?WHNLtBoEFUvfnrpcY9KSa2NESzHOXAXVxufqjchqvbNlkbEZNDBv3ZIqlBxx?=
 =?us-ascii?Q?WBWzHbuLUep+uo1t/POlhxPJzdzJOWAxQ77JM0MBFkVxRNfhO8izaSGE8mWD?=
 =?us-ascii?Q?40oL5Loz12PyX5z2kl8a1hFKKDkSH5t2ML+shxmOfU4M5U4mzVm6uZ2/OGqp?=
 =?us-ascii?Q?l2/Jx6a9zOm0uALa7DI1zyYTJjUEsdGtU1u9JitxIG7q5xuthYZdnpyM5Jgl?=
 =?us-ascii?Q?O/IEq1EFEM2EgmuNf+FdALNCL+q4LZO/cdR0J6bdC6590/roGCDarJ2Z0gnz?=
 =?us-ascii?Q?Fz8oMN9PJEaWXWulaAZyPN1r50Je6D/Dxl0IHGpwZV7SddAtxh6F6UL/ZPzw?=
 =?us-ascii?Q?esSI1qUV5eehC1jyXtPzKwVfb0LSablsNtB+yrDlL/FJeJnpOXAlksEwFP/P?=
 =?us-ascii?Q?ybHuz6bPq2LYiEQc0wz/LSbhg5y+tuhszRc0+ASP/TOTDA91fpaOD4xTRUOq?=
 =?us-ascii?Q?ujsfV1NyTINJb5jAFVRaMhwWmRZEzvj3iPZGbdSuAr4Ki8WPGAtjxhff7qLZ?=
 =?us-ascii?Q?LZ34Y8/4egV7aYGLsxOFAaPHrfOncCAopHiYNALvG3yHttJGkEXgbCrbwYQi?=
 =?us-ascii?Q?mKCZ0hpBo7HDCEfzvBR5VMzV9sJTnCahdHXIJcd2B6WS6ATv1MaqS/mZuJYc?=
 =?us-ascii?Q?K9qgFHNcwT3y+Al5ANDavCKV/d2YkMLo2s/jP40yMQy1ofrEfv0bdF383eDO?=
 =?us-ascii?Q?6qE6ZOGOzfCBOsfozauT8MxSPupoN0ndtPKSwBnInw7f2Mac0T/Sbz79bVZ3?=
 =?us-ascii?Q?LBOfYRCdyqhJDTtka4SR8hqYHYr0rD6xiwoqqmBR9yRXPqIiQ6qDCe1hJabt?=
 =?us-ascii?Q?tYLogOyckaCdEnEJ9vcSfacl1ezTmFn0tG2NqgJQAbIhulJvw3lk/P2gR+wL?=
 =?us-ascii?Q?7YJ2pte6RomQYBJAN+pDUNu8f+EjMh9jS37za71y1aLsS/hRDM3RXLI45ysN?=
 =?us-ascii?Q?vECZnqVnB5Bg8YHR3DtAbrn9Y0xe7ieM4yZV60V5sp/xz/r2gL2W4VgLiPiN?=
 =?us-ascii?Q?Kw0Cw7L1CysdhkugVroj/Tkb8mljTtGvjmE2N3a9gA8ClIRa+ihA1yIwmBtP?=
 =?us-ascii?Q?GPIq49XAlPQXxAXRhO+0Gt06JN6YsNBK1DujhQ5midtKUVtqN7Kb2lJFjLLF?=
 =?us-ascii?Q?gOvdaStSnSwOyoyRFRQES3e65wNgyJoM+ad0EjI+n1EBQWofwDxoRdmHyuko?=
 =?us-ascii?Q?YVht8w3BTbit0PmbCQKUpabpfH65iqT8KTvEz11m38tOt7Pkt8d15uIoikNd?=
 =?us-ascii?Q?8SFRRilAb0BWg8NqkyDkfRH2Y3KxsHgLJ240VBUnaq1NfhM3Rshni+ZfXeHL?=
 =?us-ascii?Q?gK23d2SwNgOjq11hFvFhkYCBhmXHFHURQlMA72xmjk1EDpeRHw4V0y+91Hhz?=
 =?us-ascii?Q?OPOH8T/sZWDxgkvNy5Q3uphSICfm5K+R/bZjcBB3XwnCzzYNxSGrti8Pm04E?=
 =?us-ascii?Q?PhzORzHVNX0k1osWMVGI80gRDbjSFdOKGbBj1H95mQQaZ+nhGOXG9jsdscUA?=
 =?us-ascii?Q?w2n031owwCGDsAJNJlqKI3bQ7uKdQXN7J+sU08AAbcDz4qT8ZLKnpv1I4xYv?=
 =?us-ascii?Q?tCoyflMYh+tDwIWVGD5o3OKho1frJs4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b60fa5-2325-4d99-f44e-08da17959306
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:41.1399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pe/0u0/9w3h1rOsCtX42q/O4/GuiPs0OXh7I2E0zM2SgXSYhwNs79Q8Q+I8Y8VykUXBs+szB6EXV7hKaP1ECqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-ORIG-GUID: u8FrWq5hSEK3J_MwmDHdtfEVI00X8LQw
X-Proofpoint-GUID: u8FrWq5hSEK3J_MwmDHdtfEVI00X8LQw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will add a new XFS_IBULK flag which will not have a
corresponding XFS_IWALK flag. In preparation for the change, this commit
separates XFS_IBULK_* flags from XFS_IWALK_* flags.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_itable.c | 6 +++++-
 fs/xfs/xfs_itable.h | 2 +-
 fs/xfs/xfs_iwalk.h  | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c08c79d9e311..71ed4905f206 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -256,6 +256,7 @@ xfs_bulkstat(
 		.breq		= breq,
 	};
 	struct xfs_trans	*tp;
+	unsigned int		iwalk_flags = 0;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -279,7 +280,10 @@ xfs_bulkstat(
 	if (error)
 		goto out;
 
-	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
+	if (breq->flags & XFS_IBULK_SAME_AG)
+		iwalk_flags |= XFS_IWALK_SAME_AG;
+
+	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
 	xfs_trans_cancel(tp);
 out:
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 7078d10c9b12..2cf3872fcd2f 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -17,7 +17,7 @@ struct xfs_ibulk {
 };
 
 /* Only iterate within the same AG as startino */
-#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
+#define XFS_IBULK_SAME_AG	(1 << 0)
 
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 37a795f03267..3a68766fd909 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -26,7 +26,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 		unsigned int inode_records, bool poll, void *data);
 
 /* Only iterate inodes within the same AG as @startino. */
-#define XFS_IWALK_SAME_AG	(0x1)
+#define XFS_IWALK_SAME_AG	(1 << 0)
 
 #define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
 
-- 
2.30.2

