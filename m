Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5694BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C0F64EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhBRSra (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:30 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60800 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbhBRQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUQA8059500
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=p8JLMAV21ypQ+fbUrM1aNJ2npqqowBD3v+LopmbHjjQ=;
 b=oAJSBLrtsXIxjVxnDE3KdGer2QubhjMB9qIalS06TerPqhfh+iG3DPSIEri8Q3+ynuN/
 FNzUdoD3sq0xwijaW5Mq9eYTR3MCN9AL9apL+x6RnyNDlduXFpox7DCPoz3X9cRTK70g
 rcOUS045yNbQKTM+94BonQnqyDNr7MfECwVP0LGqm//udirxUqF2DCk8+2LeInkJIxZh
 kB0r6TAjeHcqEipVkDqViojPVELWz9cAEMrRQOJyKYu7YMSyYfrIhmncKK+Ozduq0gt8
 xBGcO0F70f7dJuN4WjO2N9PM247ljkZnV5pEEDHTwVvKhmeCoHenu+ic+IGMBWBf9IjT dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49beruq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUJtI067880
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 36prp1rkmw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbxeT0bqkK1gVbs3RtfspYvOf6zi50xKl6UMmjX7HM2HKXcAVnVuWZRBwYxWaV7cCE0fl9vZj9OtEbQD9hLopcvzWM0ZhrLm4+nZGfCymBWYDwv+n/SIJP5rm7GrMzX6WXubRLT4ZIvqcW5X1iDf3Yy9KR3ZsveS01GeYG88RfR7r7/Ap2v9eWZX1/p+nILXO9+exaue3EsI14lfcgwVwkKUx1aOu4Ccq3tLFPCF8HlAwbZ1kWexXfNMBNHPk1jJb1wqKS3WyDxbYxp1fYuAMSt42Dq0DnaCnTNO/0tOfjRDNaNgcObTOmJl0lSohh0+cxSJnu3DoiIMY9I3sA40mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8JLMAV21ypQ+fbUrM1aNJ2npqqowBD3v+LopmbHjjQ=;
 b=EDVidDmpAyMX9kYoN+Oi8nGaNYd7Qx7IRjfKJNklVL2jwiskqEuI014ocujsUBPC/yuLUOTEyin1Q8NYbuoC5eCl/smyAKHmsNHhtI/EqK/9+Be82adfa+yt3AEVBoANRw6urh9DQQZLcVumwNtzw7kqSFmhYzf8+DlyjeJYUSw29Ph4uvtkZwgoYqTQokL3GKNMAojAZl+BZm1CXBE9f68RrflrxzZCklR1WTz5iyOa4n2l+eDGI9+1lEVu10NqN/VDEM6SG2nYdbV+EMKN2K/l+1SPl1pwCCPYhSntGPTevoIZLj3Un8VjcQZ68TqDl5h/ebJQCmK9wEK+LDxPAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8JLMAV21ypQ+fbUrM1aNJ2npqqowBD3v+LopmbHjjQ=;
 b=leK7yFjNZdJGQg4A1u8dxL4yelBbFH6bfOg4ZvT7qeqlWwEpLhpKfXQMUBvNylpeEN5NUFpENQpIs6+Q5P95ufOG5Ll5fEvAn3dl1jent0mdLtB36BYH5zDMbkA/8Z4bbdpnOVLZ40/r5Ny/zRqlKLqNtoEJAkDr7OxEzEfPbD4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:46:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:46:16 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 33/37] xfsprogs: Skip flip flags for delayed attrs
Date:   Thu, 18 Feb 2021 09:45:08 -0700
Message-Id: <20210218164512.4659-34-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28a00ada-4177-41e1-06d5-08d8d42ca3a3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2965B0DECB4744B513F60E9095859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2StMEf2z3rV4vLyED8ARi7FXSQsFRPOJD68KQ4SON4stB4ZwfDuXPhXD3u81XQmHTimZsmYaJNc2bvbsbdPhj/Bz7yVM4QFqKU8lwbfuJ8Rn7bNQsNqKEH31IcBXrlpBSz/KLAvzKYqDy+60qJH0uNUH+5NSQ2s0nyDEU5mRoIrC1gfR4UQ3g0jMfF/dcvai5RDzf7vlCsL3mH1JBpNzltI8asMyqpscV2D5GLMr71EBshGoVMcmfpttjOpeADDk+KcaFut3Ge4ntRu1Ejt/UWG9Y91Awo4RJuYASku44aq4u1/PAfkYOptkQWxYWKBxHCn+wcgcUVHvsBXxUmB030PQ8EheDjdCupF/xWBVrx2Ri0zqrIAxkWrZrcrIMTi8ZbhzGkZsWPAcoY4NxDPbdCtOw4Jftwst/uFod8f+QTLHbRp7qyGzfPqmS0tMk8tPO2cgppT4cVI7EXD3xjq0ss24bm6RvyanVr0iwX6BFc4y+y6tjqmdmbKfm1E74VkiF0Rx50biN1JM5/7+3wKBKXBidKG7zkXRZi4x1cwuuWWPwI7B0aOa/DqEMJND+hFjK0rpcvQMumDNGWWNM3xnfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(69590400012)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/IJpvU+eZ/Idn02TLIJHT1Aw90WrR6yVJjdtlqnOWppSP27V8j0ABoV+3YI+?=
 =?us-ascii?Q?u+3ZNAwafb0hFemt4hRKAyB7ZqeHM+0tgamAxw3PwNguiXnCyr1PItmfBCyX?=
 =?us-ascii?Q?L5wP5UECHHj8ydGjusyfkGKkgsOLsqTkvrgvv3vBzXyz+nk43BRYMaWR33fo?=
 =?us-ascii?Q?DWGaf8+mH0KvWlct06oP6Ek+GecQqQn74QHsi0UgN1+UXU9ksuxQbb7YMMXm?=
 =?us-ascii?Q?NGrEd7yILja1OQGZgzMInJF5aJUzoLaxJAwosDRcDUZEda4/WmSzxJZe9gnT?=
 =?us-ascii?Q?Fwi9CLA8cf55IpuDktkBTlidYVx/I/bGKue3Xbgh1igW/UvbOuo+5zc/lIWt?=
 =?us-ascii?Q?MtRG/3K89TjVGKrTfIPnmLPqyGSsj3VATvL8bfs8dtRXY24uEWmb6k1dD726?=
 =?us-ascii?Q?5vh6HiYO/X09pn6HI9/yrvSCaJEm/qp5DajJI844OC20lyAFwX391GSXpnhw?=
 =?us-ascii?Q?TfVsemYg4QEnfYVguPxY7MEIBG4pAaBYOHGjzPL0GY+dQKfapago1FjbelLZ?=
 =?us-ascii?Q?r8ETjPiFI5HidP7cxa1o6isUt0jgJdRYSjeuyb3b3RzLA+umZYR8JzhWmXcg?=
 =?us-ascii?Q?v6PEp6VtEilQpw3SllTPcxHeLpJOQgFf63d9Ebqy6rMBbyzR6QYK3RCntb9U?=
 =?us-ascii?Q?25Sxf9QDf4p0aLMP6evZ8SSMCaYxz2F9pch5/afE/YFjz98FXvmLhJRVawNJ?=
 =?us-ascii?Q?+gCtRHIEuCEWCk2E/35UHhvQ5WXwTfuL7aZ7MKKNwOhS0GUz43+S+7rIPagf?=
 =?us-ascii?Q?RZWct0TPBakDvraqJzCzynoQnzQ/unAZAAEF6pSvxq1g+/cequY/m7GqECOL?=
 =?us-ascii?Q?uGzCGIlGL6yxQwpFgcbj47q20hl+lNFbajhhVkfb3iHcca7Y0e2zbaFe/rSD?=
 =?us-ascii?Q?xo+LrV042SYvvMUbVeme5gYQqe/8pwnnvxoNeva6a0DyeXpR4HunfAffQNcQ?=
 =?us-ascii?Q?k4/f6/mPte4tpetXUSGEmOGwWzDi3yMmZZedhEDmnrXBUDxEqBcPHC7cwkzz?=
 =?us-ascii?Q?eX2XO3zAOWoQzDnRxGEznMCTuLg0xgImpf5RNd+nNaOVY235hcgzpCudTOrH?=
 =?us-ascii?Q?syNzzguf5cGkh2GcvOc4WtwjqVIwd7DmlCvzWjJ55NhmYmuM+xRXy0GgHu1n?=
 =?us-ascii?Q?u7iwnV/SeurGc8Fvkb+GBC+HnKewyQ4mGFI4vinnMWAzxQQfKB6QeXebZPcH?=
 =?us-ascii?Q?96AcnFzM+yEbxQNG1FyRusNOceVcYZeYAmaszxoHFwGnM5MoFbrOCd0FE7Zp?=
 =?us-ascii?Q?Xwy5C9lBuyItIs8rudIpWDCJaO8YG7Cso1JCFWTPzQzb9ov2qx3n/NOtSVal?=
 =?us-ascii?Q?WT8xPL5QmnjR48vB8g/9zh84?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a00ada-4177-41e1-06d5-08d8d42ca3a3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:46.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojwPM8A32QMr7i0uUVCgiNVmLESYhOO2RqoL6qGkUK8DZgocW7uEolsIYHB3iZ7QEN8Duvx8oUqG/l+6nshV/x9AD3Dk9YswCuQg3zTZcPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 2b1c81a8c3f453ba16b6db8dae256723bf53c051

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++++++---------------------
 libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 28212da..3f81b3e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -337,6 +337,7 @@ xfs_attr_set_iter(
 	struct xfs_da_state		*state = NULL;
 	int				forkoff, error = 0;
 	int				retval = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -470,16 +471,21 @@ xfs_attr_set_iter(
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
@@ -588,17 +594,21 @@ xfs_attr_set_iter(
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
@@ -1290,7 +1300,6 @@ int xfs_attr_node_addname_work(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 2c7aa6b..9837bd5 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1483,7 +1483,8 @@ xfs_attr3_leaf_add_work(
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

