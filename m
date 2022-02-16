Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8643C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245501AbiBPBhi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245509AbiBPBhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3855819C29
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:25 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FN8hX1028765
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=UE/2wFqtfItHI3QAqlVvaN0fRZbE2IM2eQcUBhZT/xI1Xi7n0g0L0oXsnSwwgdyzb97r
 c10FaWMXdGOglo1xoBg+wt5CyHXkbkV+ENNM5hBmnKnp3PyqdF2PYNxL/X841+ZGgD7Q
 I4gzApv+N86uCWE6/+5MByF982cxYOrOf0KeG0JJSy8tlhZ5YDxZIGcBQ8uIBms+1jdF
 gK6kP9sqeL4JbrdGNRiqYl2tiMtTLf2KExJZKfgHPqScmnq/oRtrhaqn+/L6RzZLEma5
 y6AO578UX8/y53dY4/JI6O/niDuUFyki5FxDbLwzu4/Aw/lMl8qquxVlkB9idbz1VAmJ 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nkdg6kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1VQCZ138909
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:23 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by userp3030.oracle.com with ESMTP id 3e8nkxj2rq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVTdhbdx3/AvCiR2IsCKuMe5fOm6guk+lXuZOjqFlZp0+FGOJlDzE0IQ6qeQksiFqeFJUBInqidXuAmkC2Q0KN8ItxhXcnSX9XQGipkWAaGRmPUPwwgr+gXkewBaH9e/0dPdxnYceSfzg69SCcif9PYQmB02UXJaj9N78caZStaGuoJRqzfS3RuGDw9AbZzGwRvJFybOGf4A7Tn+kL9oEkrLs4g74xDyM04uekzlNi8JQxG3dR3ApoBeKj/jOPU7FLX+rBge65x2I/9CQ5PQhT5Ee9r5RP/WNOqjdqi/hJ38BBSqZbMAc8h+oJeJ9mgOE8zVG06Nq9b8dMjztSGUxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=AQyQTkrSDIS4DhY51+1dpouqyDwmhLSaam0a2ueibMJ2TLgzD2XXsSt9D4OG3clYKJpZSx81LpFNCxoFpG5nTzylZ+2BsTmabIxUIrfNwC89PKTHmeWi3M6HzD8cW1Rz+MuO6d3qvmQUV7SI+2HI8UCr5JOzeMNLJpt10kuUEs0If7eE8JY3SL0LsHsfrsH/nzHKEmLLMLv6rmtsplV1iqnBhb7D+tuMTO9N6Llq3DzCb+ut+YGqs79mfff9lUcSg9p4VnxHUjjdJxIFGsgd4aqimkBqbHyZTbT9ULl44SZIejPlHE0SBErYBaiZjfKvMRGMh37JznRhZ92uWOeeAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=v3WsuWe6oZSVV7ub7fX4qZ1Ugcg5oBJUut/OofKA6itHG/U1ksJilzixcxLa5IJd3xZnsOja3sxY2bJgxOBBJUV3Xx9xKta9Up+NwYeOfBFzPN4hMSXbK31W3tOucyrIW28eZh7TKRdVVLysZzug7yMIiqPmjRU74RufbUgLvLU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1283.namprd10.prod.outlook.com (2603:10b6:404:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 16 Feb
 2022 01:37:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 01/15] xfs: Fix double unlock in defer capture code
Date:   Tue, 15 Feb 2022 18:36:59 -0700
Message-Id: <20220216013713.1191082-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00451f92-914d-4a4d-85ba-08d9f0ecdf85
X-MS-TrafficTypeDiagnostic: BN6PR10MB1283:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12839B6B3363C584841E2ABD95359@BN6PR10MB1283.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMQzJVUroMi7z3/+BuX9AXVZEULXNiOxCrSBJykIEecvzsKIjY8/KyvoAdeTnVhCI4dzmuEeB11gRsJ7f5/PE48CwWFz8QepNbY+zfysrflQtlAZIX64hPmWSEeML2hKcVMsOQlxROEkp+XjIDXFwpo2l2elaLOTc7dBT4SSnnU/LDDDXrr2hisaIxj0tdvYiX/DKekHdX859oshih0xGAOecNTjcrsYckaN3tIrLxSmElqUye7CxJDnVi9d+XhaigTErTOo3mX6jMEUOGTupB5W3C3Y9K8KYc+t7f6jGCbWV+rU4Lp4diunP7DoVhecRVQsiKO+VSmRmdax9gM7VDhvrUlVfmfQJsAGodaqMRFfuzW2zTB2XRY7QRtW01JtbzrkQjMfpbhTbhcYyUPfpf1PUmgwQwjA2mA5F8NbBQ/QiY53eKf8Q/h16y2FEvKpkWE4n1s7KlM2ZKVxcNUefLmEA4k5DyuUW2210jrQEK/O+rf1w3005adKie4QTRhL53XdT52YVRoe64Ik0VCyp2IET3TdHxnEWczWrR5Y3cYFfWRrIn1umuH0a2GRUgTJqUbLXvHAe2z4SwuW9rJ6flBNbqrcSiz+/O+cWazeO8svpr9SW5a+BrsOWQC2Aix03iriQbcJMSTcBfDDvNpCNzVECN4SBC13NLhXgj8pIxRqzD6iGx70JGXnqiOe/fcMDEYGqVzkvMgEV8CTSY3g7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(8676002)(6506007)(66476007)(52116002)(83380400001)(86362001)(6666004)(66946007)(66556008)(6512007)(36756003)(38350700002)(38100700002)(2616005)(26005)(508600001)(6916009)(2906002)(5660300002)(316002)(1076003)(186003)(6486002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YaoFuv6R6u4M1JrPxNi4KCYyikY2Vrk603Hs95aAs0KLXaiFq67hrMrXWR7B?=
 =?us-ascii?Q?RHsm12VtjKI1DPf/Iw1XOd2t37EBp1SfUqmkFYPb8/7UKv8hsSemakNvPZ/K?=
 =?us-ascii?Q?Pk9ILTbupxFlTN/XBpb+cEcBlvV4c+JEw9gQyHRrvpRBEy1LdghtTHCCL12Y?=
 =?us-ascii?Q?9OuOuiyV2JDYnfssNKGcvLKKjRCUwAmsGJ36EKFXcV/9U2IqkRF2m6sQkFn6?=
 =?us-ascii?Q?tJ9CKAsHgbX7+CDsdTs4gEC726CaGMiHqgBjtI0bGmyVcWSbBiCIDdGuKV87?=
 =?us-ascii?Q?HpG4Vivp4T5+xdw1tBMtnH5hpPP3GTfaAdBNvYaJM8MTQxTvPDe8lB0mECk3?=
 =?us-ascii?Q?XfCSARFKMaYcDj+kK+5yq18ItZuL9nt4K+OPvxaYsG2sW4VPN2o93tW840Qi?=
 =?us-ascii?Q?2aPUB3nlTx7SBH7PQjmG2T9PKJRWp9A+FI3zyjS4Q6lTRGRcKkBs2XcpkwbE?=
 =?us-ascii?Q?iyFGLzJbg4c0aitoVZLjF7N71eJSjOtzgp7ojwZLMQz+vb2bOG+3FnKryb8J?=
 =?us-ascii?Q?ve0gBXi+KPR7/j2Keei4NPgAI2KvgCQp42aLY0y9HwtmFzw1cMhK8lcuHHfo?=
 =?us-ascii?Q?sG05ldgMT86hY8Ysg78aQFNTRlJ4FO7u4DPOLE+/zPUTdBvaKCZpFMTfr6v9?=
 =?us-ascii?Q?NXmimqNyLxQxkHvJnyEO0DptSOIvYhZvsLRnQtXtQfWiylTwu2P7sm2An7qn?=
 =?us-ascii?Q?cGJeR6SyOsyjv8Eljh+/FxIjLdL9m1m9dMyf6WM9O5BdXRS1tyf7JvpKWZ7b?=
 =?us-ascii?Q?YlZBvuAOyXtpX9IgQ7I1QX1WwOW/QoT1DdmLsTXU/w54x0Geb8RekH/MAXOr?=
 =?us-ascii?Q?zzPKYYwDkxdGX4cNQ9eWZnO9pU//ToNhGGHT1OuobeczMXCMDlgqIt213vDB?=
 =?us-ascii?Q?kL3kx8W7aL9YqFZtdLQV2ec+BnFp4n2q41FqdpfyKjTYI4p5rWrC0USUmZTm?=
 =?us-ascii?Q?iWFzxbGlzEg7wMzKVFcAv2vQhPhSX3nsUf++JPXNexPws/3ReuTmPf1BIZNu?=
 =?us-ascii?Q?k1kQs3ToKGe1pYMssX3dkPNFVON+q0y8qyWXZiB8BxGU8I08dPfRooIxEiXI?=
 =?us-ascii?Q?CdeWPPpBCxG4hGY7Laz4Rm96tkYMawF6FUZGHClXTTGqaZMCMcfTdC9PKu28?=
 =?us-ascii?Q?CcHxZSRx2JVjmjh2/GYH538lh8uOM/gz2jjY73EY3iUD9Dq42/W16f7z6iod?=
 =?us-ascii?Q?AwGmv5hthy5b5vfUjG7lpRC9tPun9Y21TNP1eoyRr/kuIPD24L9nwLSynExV?=
 =?us-ascii?Q?e5SySeXbKuPl//rhLcD6gQMo3hMrsI2CNqYKdqCH0ur2c/LVFuIvDT2vI0YB?=
 =?us-ascii?Q?sMjT2kAReLaNIp4bk6wJhMjq6BmrS14l2OnVWtOV2E3HlK74cFbYe4zn5dBQ?=
 =?us-ascii?Q?kd/udsI7aERQ4xW8eKa0lwM44uqwA4E/XNcMyLDg8KtoZvTbWik8gNi4nJqe?=
 =?us-ascii?Q?57NJX/XptqdNc5wRR73g7JklwMXCbyjDWvEcS1Q7860EgZTd8bxaRlbSs5c4?=
 =?us-ascii?Q?RSDDBkA5jSAC1TMjcC/PaB6kHPJGIvEKLVOoYADxquPYDCX+unesAeDdrAeW?=
 =?us-ascii?Q?tOialxtthAzlp1WTLM1ESgb0xKgTlDVhdu+wMWKyP0t984o4OrSgYQq2OJs4?=
 =?us-ascii?Q?4f6YpvObFqId830XE+uuqUmLBBuF33J+TY0sJGl+o0gWNLLbA9NQuQW46yVn?=
 =?us-ascii?Q?jqynHg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00451f92-914d-4a4d-85ba-08d9f0ecdf85
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:20.3761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2mhLOd0YMBcZSdAkCF0anoUE8YB+zKKxZqh0j/zIDoZS7t0litBN2G3cgZrgtM9P4b6RiWpKarDkxls6oUdzu5wiUDgaODHDUBhAVwoSdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1283
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: mMpoBuxma_2IcrKCLH-KYY3YKPZpCdG5
X-Proofpoint-GUID: mMpoBuxma_2IcrKCLH-KYY3YKPZpCdG5
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

