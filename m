Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B028C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240858AbiAXF1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:20 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2146 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239492AbiAXF1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:19 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NL7IQ5014813
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=bacY3qPNiTI0bP0G9KrVMKocj7kl4hPMSQjG5uJEGe6XAzpeP8VQmCFek5jFhFkAj5NM
 /9OnPojYeJ2nztfgMJY3t3BnAaKDcwGZWwCASX1Kk+egpUnDrtyr5DSNsuUqfZf8PCJH
 FH7DWUKHo90dzLxBKutAWP4c/7RJGKfSUqS16nsXQb+VKdv1Uuy75VHjMJqbJMG9BMcx
 yKp/8zjt878PkBG3cIQ3/XSYG90SrL3ct29TTX1y2WydymWy81Jym9exz5d+3IPoUSUB
 e/R57R6ak73ErV6+aAnLe0sCt8NIUqpXwGeYZ1nAY9cy9+SsTDRsXKaRzjePS9whDghn kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr8h1b52a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5Qr8K087767
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3dr71up23q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3HpuAFhAqmXReapWRQFrsbc0jNAAxhSsOCkYWfQ4jsyW0XJ5Py9eY7JVQEHK7qJQENwOiWkQyMM8sYcmes7zW0dJ37wtJwjLOYetd5oMpDCctRorV3a3vd4D6Z6DEVefk0dA6SXVjZQlMbs66+sQbHqdyLOIZQq83R8Dpk4tgkbJxYbj55nR9KOkuKdV9M0Cbq78ltNtSgtvx9ALKKYF13QtZ8MJ+pPVXOxNZ+e+RZSt2t7XJhdcj8OMhHfJ2YGNWpBWAvwwxgKOafcmpcUUV0nSl7iTPTuWjauRS6hIM6FYQgfJXDj7MTFXZUJ4lqvE7a4p2Mxy4NS2Fx/viXnyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=n+5qWXf1lyZaeIQVLuQ8tf6Mo6rWuQCCoXX7mHx1Qj+n7sAsSbdCas4ZgRCGXuPMghTj8XOjHmaYOvNbjXzFQclmCgq073KjvZw7tfPQ2dQ7ZxEwVNLd39S+MtUBiz0Kw9lH5bQyQAhq+SuWrY1BdZg9pAd9GZmQGsHnHbgzWxygC415ku6moewFs/MUFQV1DVUYqGDD16c6MHDuYh6qfK3Tw49UOYieYaycf+DaapuASVNP6JfNU0wEUI+L8RzdJbXnBjowp0PjAkmfJNpiZIiWT+4h2vPF/9Tm38zyh+tw+bToQdyvRKqnOOGfma+RkG+FDamIXEaaHaGawmSnlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=Q2TtXZ9HZL6ZQbX1OucfItx3nAw6WezEkj179cCUMR9XTW6f8T5Wx5D8XEr1DlQADBMfeFq8VC6bBsacjdUphA0mrlRjEqbMb6Y+5uMPRaMNqZmcGS2XYBLwpBNd0LTcbYCZhEcJqOnwcbiQGn8g43e4aAPQcr4P0QnUBvVYLD4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Mon, 24 Jan
 2022 05:27:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:15 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 01/12] xfs: Fix double unlock in defer capture code
Date:   Sun, 23 Jan 2022 22:26:57 -0700
Message-Id: <20220124052708.580016-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55a99111-148e-40b3-da58-08d9defa2eaf
X-MS-TrafficTypeDiagnostic: MW5PR10MB5874:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB58742C54B347823A51BE03D5955E9@MW5PR10MB5874.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eYMt2uCF8jJnE4R0kZAGiYO7dP1wYhRRphPZVT+ZqyXbGpAX6kd+LtUcwYSEshoZkAVmf0vr+9BedMI5DFm6imjw4tHFYd9ru4E96td6CfsSYIvSoeRZwfJ+MQRt+J0/qwcXTS5ZRW02tJPrYspZPzQxF0aAi9jVfx6JVVEijc5phCO5T0Y/ffRtXB2lfbFRVZpcVzZd8xixEXYKQr3nyIsn5uctsslKr0SfSH7pxzzjQFC0/zzqILRcMzc6QBxbEBO+XkyYmIsgjpsyGvNDrbC9dRvWj1Dh/MgYzbgLMgvIf9jmvjf0nuY9TggH3PYipqztvR38x3F0J8BE3eyJhV44DKLSwBys2Beqv74G4FlxAVglzaX4P7yVhPNN9flCe4Vrbxgcf2YYtTc52W7MfH2CdRHp+QdDx8s2/+p/K9XxeEmM+kpmwRPy+NPZFE4N9TxkcUE2KgvWIIPxYMtmpR6fHwfyItND7UGuUDR8DHjMBRioKJk3CQ9ID1FnpjwjbXhFN3f8w54FUyN2eW+DjhjNkkRESRCp91uQUb4OqxWG0irQzBfBKaYLbJacHHhTgwWAOR/nVoGIal5wuBXlMpz9dPqOuKRpKFlxEQsnMu8mZb7gfuMqjNVAb8fHfEE6docCejp4pUdwY3nUVIpygDvOKgZWxtt4N0EFh/6FBVYvftG6k6TK/p/ffLqDSZE74ERPiremhgU5yfrW16dDQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(66476007)(8676002)(6916009)(6506007)(6512007)(66556008)(6486002)(44832011)(1076003)(2906002)(83380400001)(8936002)(38100700002)(38350700002)(2616005)(52116002)(86362001)(508600001)(66946007)(6666004)(316002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJonmTyALk9xKOtK5fwJeNarCS+g+5BxaFX8ZVzGO0pRB7D0XcoMyxlxmPUi?=
 =?us-ascii?Q?h9CiTuRvr1dBo6KVz85/fST4vSlGQTDCwu+fzCrl7h/baPSxAwb3+udmWEzx?=
 =?us-ascii?Q?f9tB9X8tTZEWxzqDl4+Awh7YFNqTJIEVDLQl9He0L9YgaXZMxQnHBikdw4+9?=
 =?us-ascii?Q?h6NShktu3k9LkVnBi12ayq9WTTrQFASn6xagvaAJ/6cenDh1ZzXT6N+xMI1N?=
 =?us-ascii?Q?W4XMNjtJafe3nNN+8PUbR+j0/Zjdha+ZJ1Rf+hgsJ9Btf8jiAN/gL7KCgW9m?=
 =?us-ascii?Q?Vb5DHVNU6E/P/LzNlRni8X4cQYtiJbN5LkZi50OdByHOHXzkhbALx1MCAbE1?=
 =?us-ascii?Q?/pXgdCvPFq/N82Z3V7pC0QR1jKm7DRbdUTO5hWLWA9dtKbDYFJhcNZoELm2r?=
 =?us-ascii?Q?7IvL+u5zfUdC98qLhaWs0DsOW7DfzH+8sVAPVm7+QSx3ipAKN3NTnoUIDOSQ?=
 =?us-ascii?Q?tZcfC6PYNcdPFFDokGaFVYy42E+vS2GARr56YpH6InEDjWHOvCLNJJ07fkQQ?=
 =?us-ascii?Q?VQ0iwPvOKOnVsu9PPMeVCG2+HL4aRCNtl0CJ8tgQoORRbJNWuOgrFNaFX7FC?=
 =?us-ascii?Q?+7HYmb/tXZ5zf+32iOuzAWjLQALTe364jbrjdjYFfr9jdg0bUPCrWfEq03bR?=
 =?us-ascii?Q?tHLArqgnMe7Jx/l7VcH8Q5BzG8TF00ix+GLpo0j1rXkfhbLRSDdZV0UDeHnc?=
 =?us-ascii?Q?YcB7AlDXH2u7Pr99zqccZ+51ekGMhIHJqZRl9kDuHzyNTjNUY7EgI30+/x7G?=
 =?us-ascii?Q?NnM46OE3ptQCmx21Sv4Dt7sS9AO4vJvhH06wGW4aR05nEewrziQS/TXOz6jZ?=
 =?us-ascii?Q?IncacfGONVCGBhwkyTN7ubOx9vNS+FbkyFgk7LERtc4joXiaCzDV/Xf2KOyG?=
 =?us-ascii?Q?l4PhdEQzzk8ecpvowwhZw9qlS2KAJn/lXvN+HqUD8Eq5DL8F4U+jTySAHnWm?=
 =?us-ascii?Q?QLGJJbpCfVhG8xTrOXJ79RFLFO/b6KSWBC1ftu+QHMmP6w+RhzXWiYoklP4x?=
 =?us-ascii?Q?tnNR/bMscy+kLdL9emxZD6nnLuZxdHTyw8AKhzom0iw4GumPE232nZ7XYOh/?=
 =?us-ascii?Q?xw4n/UnTXY4gaZso24/KZso73NmFbMMCreE7/eKesnnaKN0YZGyOwgtUki6M?=
 =?us-ascii?Q?ACwRjCAAsJeqs6W1i5QqDu5dZVdZ+pfQhia7wI/lX8Oayoc+Qp0P1gR16if6?=
 =?us-ascii?Q?G/1fOVHFaRF2BaO+z54X2Hxc3UkZV2XTgPZZZRKxpR+Yddqe5oNFodWcnfje?=
 =?us-ascii?Q?rjRTUE79C1hoJGZqmT6f13i5XdTOMM0xp7cG0Xyh2O1dN+oepe/7sp5gKag+?=
 =?us-ascii?Q?n19EE6cPOmM/LWO5AGiUyxufT9Rhq9kRJ92XE6IYjA76exuMoQjZduADkk4H?=
 =?us-ascii?Q?I+RH+zs7P45P2IrMjshB9TmHg5XLSUlw6HVYwF9+uPqhKWTIFp9OUfcjpjgD?=
 =?us-ascii?Q?2/XmuFNDMZjSpplfLelr1Ysu+O/RuXvsLBlteDTYQFM/1+sKCCSUwKKFCCEa?=
 =?us-ascii?Q?gy/ivyxdo+gQ4VAarffaYkJ/LbcaiM2f553ritxEdv4Xpdgfv+Ce0T7vIH4j?=
 =?us-ascii?Q?9rLmJJHdauXlU/qAXAazeUf0q/oL5zcfG7vWdMqjfUi/t3abVQGgmrKxItIR?=
 =?us-ascii?Q?ptH5OU+xiI4iVsByRq9UF/WxPqzo89CCqrntgrm/5fd1Bx9RN5YoQvS/F8jq?=
 =?us-ascii?Q?mTrIjQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a99111-148e-40b3-da58-08d9defa2eaf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:15.7835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OuE2TdnVunmGhNfZxmttwLytUvL5SNoHBwpjPxjzZFr4suJds6SkR9YauXk4L9qCHMs5apuRE/b5IzG9xUZEGWwQdRabfeMnNuQkS7Znp2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240036
X-Proofpoint-ORIG-GUID: JIt0LbehQerEh7QBQAks8YmesKaOqAzq
X-Proofpoint-GUID: JIt0LbehQerEh7QBQAks8YmesKaOqAzq
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

