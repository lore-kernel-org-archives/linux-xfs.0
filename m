Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB12C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbiHDTkk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbiHDTka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97C17660
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbYB0001460
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QmqzOcgnG9Wlu661xvk4KAibIhyTM3ZJiJGmHaN7aO0=;
 b=bcO0oKI5lZ8AhhjAuKDjvwB0dYA4dWWon1a0tHpjFvDeqbFnAYrJ/zLmRNEAMOzVM780
 LkGH/3IepB/NEkTpSynkdJaA9oh05tKc0TyZ34RTGB+mwAe42vB5Go0ojUnqZtXCsZTx
 ZcBKH0mTqRnu7hT9dGXrGT0aL1R+qiebdlglWPR/uiKYBkqCtSY884vVUU6IDr0Y4jrx
 bV+t8Mv8HV4UbDRwb1kzdErK3E7zp76hzLFu3YFzwEGZT5qFxckZwAXHnsuWTZox2mlI
 aH9u3L/x9K3cifQLUQvkP16U0jpG/yKLkbtXq5nR5Y/BEh76B8oEMe0Sodc+JYlb/Jwy Zw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2x31k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274JO4XD014188
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34p7ev-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHtV3fAErKzoOx0BjYElWjFZNBVposHIgJWUTcOWfxjtbbOZXqRe0xa3COH31tacL5NMBBGmjVP48Vp6WhtFHjUUIHR4HK27ixnXRG5QQ7otClYeB2xVGTeYXE+fGn79g4GdqMoMPQn5SK/wgTaOHyNVmJlZ/3c2C57ukujE5WVxjqrDP6w2DxJBs/lf97xNMw6nG3kQMjmq+tk9qRoTvKNLiTpG2/x0+8Cupspwxy200QLNuREWnI/AW00hrjGkDzTGAfVv4htLbqJ90EPB00pL0DjhuuTn5A4zygzX91S0e2kIeDdsI8KP5TIdmYCWDSStIxMj05Wv9LmvG3zCRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmqzOcgnG9Wlu661xvk4KAibIhyTM3ZJiJGmHaN7aO0=;
 b=Yl2cLNcQ90kf0ITQ2CE01n0LSxK+vA27h1oVtPrJfZI94CKBTQhhpeCHjaHjKEla6vSY9VqMHCFrWxrQXBFt6fAb1LLM74UevCZIhzVNBGXiKZNpe5noTpkKimk1vS4ghAJUDoKDvg7g7IfWpKlx+k1J6UMwHwto6a2e6sCZq9U563JCv4W2qXiyX+53DcrcH+p2hSBfX7F6GjkydTiOdImPmsADnMvfNHDBLALDEtplNQ6f0eKZhyyZb7Zk2dZODd9kYZ6In3bVXoNRuJUBkPYY8KFlVgIbSmBqBAvRe25HPltd3EdDXZ+cQnGCaLDD9upCI8COFCs9Ns8Kem+MIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmqzOcgnG9Wlu661xvk4KAibIhyTM3ZJiJGmHaN7aO0=;
 b=rfc4bYKfyEP3KdF5tV4KwmC6JNuoX+AdHykXyAhKZK72Qt81P+9ztWCaegwJQx9w0W9to4U82b/cFN7aj2v0sFbGzs3hqyebrR3jRVYskZ1eXti3UcC2Fn4kRpVXRGdFLhVcB6MeGkAJHNTZbQfdrOyP+Am+h11LRJCOAJVbFcs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5136.namprd10.prod.outlook.com (2603:10b6:5:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 11/18] xfs: extend transaction reservations for parent attributes
Date:   Thu,  4 Aug 2022 12:40:06 -0700
Message-Id: <20220804194013.99237-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24dacf44-9379-404a-62c7-08da76512d1d
X-MS-TrafficTypeDiagnostic: DS7PR10MB5136:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KAjTebul6fV0ZBgvdn5cUiolq5qqWS4QBVsjFmjnQQgj820q1Wzf6ZaP27JVJpCAvw0x+L47fjEa3P/kmUEJgdpBiYOVhjafcj38ySiNJxWkyVejW/2G34DSYllMA8ZBFk4pc0zuZa+AtqQ+P6txkhUwfD3tBAdIAYDcl735mVmkqLfC9bfz5Pj2BisHypZxNMp4e439IeZhQYK9abxUXGSq0UJEghT7SFE6TEZWbB/EIOTocWJvmpr5EC3EEnOMZLiurNBH2AFISxA7DvC1Fnd/I+TyyN140aXcX8SmrYU3VyFa6+nWauwesoxYd0fN7M0B18/jgWDamzNEcri36GAMZk3VVMYl55tGjCYfHCIASQKk+gk41HtQCjpn4WoKi+fA8bbcwA3HdNOdVOdiXtnxlinyOWJGbGTysDc+YCaw16yPbUOiOe662AKiNc56PnPSDZTtvBDjejrQ2O52A69cs1b92BY1FUqOWp7YwLEQGvWTyHjGwBUc8vREQOAMAYz/pVuH5HJrvuObTlh+CCeQeHHJ81JKgIyypOUsIlVwGCKdGGcx4DuJiZ9dPAxOfqKDWoyv6CKwizALjz/ff1fvK0BKkuRb/LSPcOCauRW64HQBbgnfmbV3NQi1M3w/H00PT8yUl3Lcquuii7WUvpVEYL+EHQvxZNWoHup3DYl12HYkUvAhlInx9m+f9DuniNlY7ceM3XJ0xL5LjNGFNelD0u1TmzpiRYrYkM9afVRiBWuJJb1NEl2uCRDEIzSj9gHpL8D8unSclGK0V0vTTvE5dxi1nqQ8yI2Mn0lpOxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(366004)(376002)(6486002)(66946007)(66556008)(316002)(8936002)(6916009)(478600001)(38100700002)(44832011)(66476007)(5660300002)(8676002)(36756003)(52116002)(6512007)(1076003)(6506007)(26005)(186003)(2906002)(2616005)(41300700001)(6666004)(83380400001)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZI2d+C/k8r9eLWptAr5RvVjLieljyZFzn+ojPLxmMDuOCqVUaJ9Gnh2IKx1v?=
 =?us-ascii?Q?JXdXeEJTvDMbD6spU6Tm/BVgSNDxuKcFgDRUQTOWLm09FK7sSpn4uQ4qX9c9?=
 =?us-ascii?Q?6AvNp68W0pXZg/NXH5JLYkzgmV3GrmooAjTHtQAYJO1jRBkjJMAVW7VCkIMI?=
 =?us-ascii?Q?yqaG85K8xtL3ARujof8PZQhaiyiWs912Je4ajH7K84xz598lGcdSE7xlTD/2?=
 =?us-ascii?Q?/k58Z8iKfDHPE9yu4SiQWyYMqQye5GpX4QSByPu0sljqq4b9+1nKYTwSGK07?=
 =?us-ascii?Q?a/S6E8lmHDW3wMlwIwu+251A638vrR47bGTanJda3rm/2eYYAGPGlITy69Df?=
 =?us-ascii?Q?JQY2BTySe+1rXLNPFnOTTummjEr7EcJ/KJWtEElJbCZ4u4q3bz3W+JJay7hM?=
 =?us-ascii?Q?S5auyPI+LUXGPZWbJahk4JkMcZbnE0iH6G+gjrN65WIGkdPmw5Y54PpU3OiD?=
 =?us-ascii?Q?ccTAbWj4cJ4JOdAd5/OoaxIg/3TbjttbSDr5ng+PrCy45OdwG9iFYEEdtmmh?=
 =?us-ascii?Q?uGw6lStVUHaDFRfKh4bjJCf/hyRsKCEn9JOS6Pfwh+fJAfI+IUaCjsD/8Fhs?=
 =?us-ascii?Q?lRvvrrU4cCSPrqYkpfGIgMRNsIe0zkIntnC6e0FExVRAkIrPgkr5WId+N0k4?=
 =?us-ascii?Q?XJtVS7ilrtYp20vf8Natir8iH0EbAKac79DSQNjMQTJTX/ohqJNDhmXoZhmk?=
 =?us-ascii?Q?syyPJW78C8aVRn2Qjia3zJQtWoTOVgzndm3qsrLJhJOcJd+BK6PYSS9uERHa?=
 =?us-ascii?Q?bmxKqVEraMYrgXqwxUQVQKhUwDEa0fyvyO4wveOaOYQqZ7RaqyIpHCqtpqvw?=
 =?us-ascii?Q?+5/k+fHpZEyrVPVFI3ybwpdJNZz8tXznN37CgF2pzbO03nfYtz388KEKHrPc?=
 =?us-ascii?Q?krJh0pCrMr7ElL+ms4Z5OrbjHUyCoAs2VRKgepVHlDSGkFmZA0w4LBmISWU+?=
 =?us-ascii?Q?1Im3DV1FRU3dwkkxLHaBk5fEd75ZY4MbvruWSkFTHt8rbTbtTbnvCnYpbKmF?=
 =?us-ascii?Q?LvRzCBgY4183QwSSkWof9aH+0iNi9c5S8jpKvA7U8Xsm4UdwEJbju5RW3ZVc?=
 =?us-ascii?Q?H101M7XamwfO7fzXfr7iOUcB8FeDA14DCZKvAu8A+NswDPh24wAVsaJTUWDP?=
 =?us-ascii?Q?5uoXc6jl5FESfhGAQUSCf3J/t985m6LVqKx+/865/H1GHZyD+lyCGiw6s4kk?=
 =?us-ascii?Q?9+U2wWcFjc3C9Kvj4EZ4tWgn2XnT6VCevkAQx0oRXQqFWr607uRJ5wOrAtS2?=
 =?us-ascii?Q?z0G8wDh0LMca1D2ph1+YmFtaLLt7j1ZnUqNZaQ/xScMZ+Nwpum9Ed7LP7At0?=
 =?us-ascii?Q?NYan5jHMFcV2D2H5P6AiU7T41wCRWa68vyz37H58M7g5w4m2fg1I8uzOxEcE?=
 =?us-ascii?Q?U/2jnpZB35QObLbDlznhVZGtDHMkb/Zz37C28o3lEULZsz6ZbWA/4PCVueFr?=
 =?us-ascii?Q?T9MIzE4PVeQmk+bVCplDZI+4tysC7s/tq2IzhrB6kDxWDTLUjg09SgUNUoBq?=
 =?us-ascii?Q?4Y6GlAP37RmoarfZdssci1tH6HhSisK/y5uFv+luhKOi300LCjs4U+J4lifZ?=
 =?us-ascii?Q?fSNmuw78DUZtZ1ywkhoi4zJrpjVEASR7ofIv/G+2NaeYZlQmAA/E4aBFMeag?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24dacf44-9379-404a-62c7-08da76512d1d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:24.8769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DTbpiwpj8lpjKx2eYhR1sd2E5bLFeJWBNgvYmwN8yTRDQYEGOP9i+4ruvhJa2Ouz5swlVsdo+/qZILo1dwNZS8aZdvtKcDdMddBbGwqYERI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: Td4DKX94c0fLCulJm6swo-azV6f32FPr
X-Proofpoint-GUID: Td4DKX94c0fLCulJm6swo-azV6f32FPr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

[achender: rebased]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 105 +++++++++++++++++++++++++++------
 1 file changed, 86 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index e9913c2c5a24..b43ac4be7564 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -909,24 +909,67 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
-void
-xfs_trans_resv_calc(
-	struct xfs_mount	*mp,
-	struct xfs_trans_resv	*resp)
+STATIC void
+xfs_calc_parent_ptr_reservations(
+	struct xfs_mount     *mp)
 {
-	int			logcount_adj = 0;
+	struct xfs_trans_resv   *resp = M_RES(mp);
 
-	/*
-	 * The following transactions are logged in physical format and
-	 * require a permanent reservation on space.
-	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	/* Calculate extra space needed for parent pointer attributes */
+	if (!xfs_has_parent(mp))
+		return;
 
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	/* rename can add/remove/modify 4 parent attributes */
+	resp->tr_rename.tr_logres += 4 * max(resp->tr_attrsetm.tr_logres,
+					 resp->tr_attrrm.tr_logres);
+	resp->tr_rename.tr_logcount += 4 * max(resp->tr_attrsetm.tr_logcount,
+					   resp->tr_attrrm.tr_logcount);
+
+	/* create will add 1 parent attribute */
+	resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	/* mkdir will add 1 parent attribute */
+	resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	/* link will add 1 parent attribute */
+	resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	/* symlink will add 1 parent attribute */
+	resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	/* remove will remove 1 parent attribute */
+	resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
+	resp->tr_remove.tr_logcount += resp->tr_attrrm.tr_logcount;
+}
+
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This assumes that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ *
+ * Note for rename: rename will vastly overestimate requirements. This will be
+ * addressed later when modifications are made to ensure parent attribute
+ * modifications can be done atomically with the rename operation.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
 	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
@@ -948,15 +991,37 @@ xfs_trans_resv_calc(
 	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	xfs_calc_parent_ptr_reservations(mp);
+}
+
+void
+xfs_trans_resv_calc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	int			logcount_adj = 0;
+
+	/*
+	 * The following transactions are logged in physical format and
+	 * require a permanent reservation on space.
+	 */
+	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
+	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
+	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
 	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
-	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
@@ -986,6 +1051,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

