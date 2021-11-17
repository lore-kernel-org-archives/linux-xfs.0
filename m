Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA4AC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D50D261266
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhKQEQ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:59 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17346 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233008AbhKQEQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:56 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH44w6h031988
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Mb9n37Weayy5SBC/BVLjLcAimIOaLWkk8jmusVtdRfs=;
 b=trIu2GzAIRTBxyzhTLy6VDQuGvRD4cmu4hfvxy+Zx3oWXMdWxDOOz7ePCKj6nlHihvpw
 yCqXHUCUSwKByS6Q5FwoSgWGHb4SYQjQpnBakIHmfSSEpKvoMbXvY8SsG5CqIw7O4sCq
 sEDis9eMz8MzbBcHMnVlhZh9a8h1utvQ5upUNZflqNT2D1HGIVoO0UijIh94gs5Wpn1Y
 LemwR5Uu3jp2oESsnwu2Y9clwnkJP2/ZutV7FesRkNh7J0H04DSA5hpBQp0FBXJkw8gV
 bndqVJXu5x8GJaquctCfK98W56L9xNa8ErMoLA2Ji59YKwIMMiC+nPjfoEkFoP7dQv+K yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv86em1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEJc180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3ca2fx68vt-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXVOYWmtgdcFd5UljJq7Jc2bxJ6SFCXulD+tFdCEqlwRos+CwDFJKA1YeqfIYWewltCJhDDNUm7dsedwsATSgcr025Ihwabp2Dy2UFoEMBADz7sLmf0ajXp+gTqvaUJ+BrVQeEaGFZoiGvPAhsnU5Gyf01iGm/YtebgckHeCUWTEbGdfmYFNSKH/dQzJkXsZrKMr2cIq1a0DnqNCAJ2SIK1ssi49JymSnfCfBuyiZqEILTqPKTsqMa1ximwjbOQLGRxh5LfF499u8GX/+mDsuX8RQyRvsj13QCgauFIaT0MpzI4c5ODCG727CIJt6gcDHg5nD20DB4kHCbytegKKtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mb9n37Weayy5SBC/BVLjLcAimIOaLWkk8jmusVtdRfs=;
 b=JwJBOiPluDVwx8ze9k8zt5B/W7cj+L2WY7LlVN5Se0KmC+V+3NXBa5+ED8gWaK9fZA0TlCDPPZOflpHUUfyLRjvYp0rV2mQ53Kdp/UKt8IC14oJ1DcrUnm4JBKA+5Rj0a3S7ki9kQgfMyo2PuNcN3OcyfQmsosrkTrImTuhxFRy+C6ChgrlM7xbOjsLOCE8t0rXPMPs876Auo1b1lE4A+FNYNijRZ0GZLXFA6+5T8JPlf+nbIIFwK1/YIu1hjLspUjDW2CIjBpUsAJtQgebydX5cEl8aAukVoi9UPqJo0ixiLsD7ey1mGIaS9CP2Yy0egVY5pOds9A3wWlolX5dXQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mb9n37Weayy5SBC/BVLjLcAimIOaLWkk8jmusVtdRfs=;
 b=a+1HOI4Vx+NJJikmfyZxQySWbx+r2oO6rDCxOSfczCNfuaRI8Z8+J7NgWz+VLIc9tGckDlRqXM3XMvxKHkEjKYzDrySGTsEZ2URjJ719GyEwWX13wl0mfD6NxcCmXkmtwHkXZrIi1TLLYMO+VFc6dbFPJFG5BfonvDH4Jzo8W3U=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:13:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:52 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 11/12] xfs: Merge xfs_delattr_context into xfs_attr_item
Date:   Tue, 16 Nov 2021 21:13:42 -0700
Message-Id: <20211117041343.3050202-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdc59d05-132c-46cb-d43b-08d9a980a9f3
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB392172E8F3FD66D66C505E5F959A9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:250;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ki+Hk8xbnGNXec50q+YTkaen7S41Ng9qYPCGy8ykzP4h1UiPvvZ6UJbyYd+oxICQ1LnqE2yqCNyCSKNQMoKCJl65KTi4Yh6fqDKZUpxVoZn9cQOqk1D1wXzoy46wd19saSGKSSuIvf3rB9GggeAtuuAfSryJo3o3QFUWBGrjY2aZyi2XepA9GS6eYiYP4DWxSmz/jOtsseGGqNDq+Bcg43zxBatEWh50OhhDVUi+pTHzIsphb+cCVvA4A/eX2ZWZun4oc4xyG22UkSPk6xwWRJEe7hH64oI0LFp+Vj2we6IFEyvOumE6Qp335cBrWslBn7L0TyT8KIvAFd9gslbWYG4SKQYxnsS4TCEwmvenyek4gbxcCfjJBRZGMAkfwMaCfNmZp7DfqpM8op/I+TZSUcq62MtoZGYZjWk+66GIVMBxY46QdzKcfHbEJgDKwdWhuXNhHUIpRY3PeC+VHY5I31bk9IgtkdpvvdNnzaGsTG3Fw2LirSkWPm3pWA+hTy1LLcd1VubS2nSzvPtHOPzfXOPOhzfvG76tjgGIIJFvtfy235onyUS+KA4/J7FrhOklk4YhvZ+jmvykzuwiVM61NHxc+YFFXz+DG+fQPzf6Y0mD+9yguJhoFaTneFIiUqUROkYDyn8LKqlGJv0MHdvz2NZ0HDP4eV28j7ZIHWqXz41kh06or0qdcMwR/Y4nRV94aEcBDYnOE4kEbWEbg96UXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38350700002)(6506007)(2616005)(86362001)(30864003)(6512007)(5660300002)(8676002)(2906002)(36756003)(83380400001)(508600001)(52116002)(186003)(66946007)(38100700002)(6486002)(316002)(6666004)(44832011)(66556008)(1076003)(66476007)(6916009)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fge0NUbQI6jGj3CX9ce6wjXe6D+l+bWKYenchf9i++CcB4a0iSxoqxWguRVP?=
 =?us-ascii?Q?YTs/ltVaW4ctyCSshhYGBYv4F4QAu7pYla7XaAgmPwOiRSZsF+rGbXuS8B79?=
 =?us-ascii?Q?mp75q3FWxC0SXdtw2joJe609gDwTOoPgUrJ4nVhk6VC0rfmsBasJhOHZpm1M?=
 =?us-ascii?Q?OghBE1dPWZaYwvxjOc3csTFoSSZHmQ9Vytrd3O7YHKrSvtHruax3lmFzURly?=
 =?us-ascii?Q?t9lzJs33N9B94T0VDCDZH8ZjOoDDf8/HYIU2Ti5xu+jNpDWJdZIqKRZiiPPt?=
 =?us-ascii?Q?aokv9dBPWTArfFgeyxdo1re4h3kLD3nQZYmBj3JeHzSDPC2KkUImgK6WIaSs?=
 =?us-ascii?Q?33teIj0IZzg1X4N/G+ZWP6KherPwr2BPDi/2au5t1xxuin8FQ9cjgseECnTZ?=
 =?us-ascii?Q?JvM2DPpoXGeelnmjXuGZCy6xO2ONL+NRQKMPXRo5GRN8pJqYY2EEzbiGN6Gd?=
 =?us-ascii?Q?xI7rOVHvWK6Wb2HfDUr9uzJxb41drokDriktt7qQ9hK2gE53KYEjfsBEKF/n?=
 =?us-ascii?Q?zHbUfGFy+VUJ5l9MpaKdGpA0OZspdNpxIOfURNOjRBCobNFhzkOxr6RI1dj5?=
 =?us-ascii?Q?yw26YlCBiLghAlXFIuvjIRmHIP+yzJw/i00qgi9DfRNU6Hgp4MIra+clJtCT?=
 =?us-ascii?Q?cSEC1vYQ1mFddLzolsscPPXYhR9Sssv2LSnaCpOlG8L0ZsMBOmfXsaY2EvAh?=
 =?us-ascii?Q?tAMavmIpI/+eyW3AEcyKBnr50JaXlRr6Q+6lvrtBrCR3/f9id86BvC/MaDwZ?=
 =?us-ascii?Q?Zd8c2RbRfHMv8EBVKg9L9XujuB/yVdI9CkGi44O533TudwD6ySXdOCkDV1uD?=
 =?us-ascii?Q?Gx1QTLDt4cbSiUWS4y2lgdEzrIkLNpk7lO3sos5BMBvoqPiOO/wvyEwKiX1O?=
 =?us-ascii?Q?yS0ReHv+HWs5KEVlWoBMfMuUKmFcJx3B3zNUd1Ylkv9ZXh7VtWQ7+VoD+19d?=
 =?us-ascii?Q?Ti8dULjrvj75JlEZq0QkgDuy7dEzh1wzTWcuva4/21/U7qJJtJRWretPQbsv?=
 =?us-ascii?Q?nxIo2sdObtb8jtvN9Fi4mzjbKgD5gABSyknZrZhje9o909nwKaPx7TpguuJu?=
 =?us-ascii?Q?o0LSVfx37kDwDCEV4EYsKMzJH8v/n26yPMFD9AgFQ89Qi2F8NlamY9uO2Rec?=
 =?us-ascii?Q?54c33IUUiYHefmFuTnhVPVG4xGUd+tLq8Je6kPeAC6qC5mleLcJTrFOnpEE0?=
 =?us-ascii?Q?bHPaWoC+Q6ng1G/LPQOmXka4vpChO5zE877QmanyYscMKnIcetaQ97IkXApB?=
 =?us-ascii?Q?hs+VPH/DcdMuSX6UQ/RsN43IQAYEkCn/CUFekD/t58wBmEGW3vb+kuMonXQS?=
 =?us-ascii?Q?Yvme23wGip0wPjmoEzEZmtVFtJXC6pe+26yJKdWVfKAAb9cWsW/eZmLmgxP/?=
 =?us-ascii?Q?yMy0hXeNQSkHvCGchcnMXO0xr9IY90KlBtizFcDwU2fR/FhtUizVhb42ysux?=
 =?us-ascii?Q?KlgrYDMQ/Gh6m13yaG04lEOur7ws98jxVDV/RgtpMm/HH5+TRztqERvOP8F7?=
 =?us-ascii?Q?jZwooKJmrRE/EYIK17hSzxh9ObYs0Tpg9YHbygGN9o/9W1ioiUQfo9kHtFz/?=
 =?us-ascii?Q?n2MFFkVl+tvKEWb90cLVpgi7TkZF8gAjVvswTb7RsDCu5XSaYxNeKid2LQbw?=
 =?us-ascii?Q?1cWaMKKo/hH4URWBq9xT61QQ4vEweI6OYbKnlzk9CbhpuPWPwHNkhKPKPsNJ?=
 =?us-ascii?Q?FDwSBA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc59d05-132c-46cb-d43b-08d9a980a9f3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:52.3645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3oxjNu/YGyfOXDVmxVAkbIPGUC38uCQsTlAaaaBJrkIF16oqt2ZH81zBMcderQeSoUOcBjLjo/byWirq5Y6ZBAuZKMn9UBy2oPDk5CE0ppE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: _ymAnLOMjAgjtc5EM3UhXnckzt5ElcIe
X-Proofpoint-ORIG-GUID: _ymAnLOMjAgjtc5EM3UhXnckzt5ElcIe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that merges xfs_delattr_context into
xfs_attr_item.  Now that the refactoring is complete and the delayed
operation infrastructure is in place, we can combine these to eliminate
the extra struct

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 162 +++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h        |  40 ++++----
 fs/xfs/libxfs/xfs_attr_remote.c |  36 +++----
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/xfs_attr_item.c          |  40 ++++----
 5 files changed, 142 insertions(+), 142 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1186c0702a0f..6a04c7e5933d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -56,10 +56,9 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_clear_incomplete(
-				struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -246,9 +245,9 @@ xfs_attr_is_shortform(
 
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
@@ -265,7 +264,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &attr->xattri_leaf_bp);
 	if (error)
 		return error;
 
@@ -274,7 +273,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, dac->leaf_bp);
+	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -294,16 +293,16 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_da_args              *args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
 	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		/*
 		 * If the fork is shortform, attempt to add the attr. If there
@@ -313,14 +312,16 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac);
-		if (dac->leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans, dac->leaf_bp);
-			dac->leaf_bp = NULL;
+			return xfs_attr_sf_addname(attr);
+		if (attr->xattri_leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans,
+						attr->xattri_leaf_bp);
+			attr->xattri_leaf_bp = NULL;
 		}
 
 		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, dac->leaf_bp);
+			error = xfs_attr_leaf_try_add(args,
+						      attr->xattri_leaf_bp);
 			if (error == -ENOSPC) {
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
@@ -340,19 +341,19 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			} else if (error) {
 				return error;
 			}
 
-			dac->dela_state = XFS_DAS_FOUND_LBLK;
+			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
 		} else {
-			error = xfs_attr_node_addname_find_attr(dac);
+			error = xfs_attr_node_addname_find_attr(attr);
 			if (error)
 				return error;
 
-			error = xfs_attr_node_addname(dac);
+			error = xfs_attr_node_addname(attr);
 			if (error)
 				return error;
 
@@ -364,9 +365,10 @@ xfs_attr_set_iter(
 			    !(args->op_flags & XFS_DA_OP_RENAME))
 				return 0;
 
-			dac->dela_state = XFS_DAS_FOUND_NBLK;
+			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
 		}
-		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
+		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+					       args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -377,10 +379,10 @@ xfs_attr_set_iter(
 		 */
 
 		/* Open coded xfs_attr_rmtval_set without trans handling */
-		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
 			if (args->rmtblkno > 0) {
-				error = xfs_attr_rmtval_find_space(dac);
+				error = xfs_attr_rmtval_find_space(attr);
 				if (error)
 					return error;
 			}
@@ -390,11 +392,11 @@ xfs_attr_set_iter(
 		 * Repeat allocating remote blocks for the attr value until
 		 * blkcnt drops to zero.
 		 */
-		if (dac->blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(dac);
+		if (attr->xattri_blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(attr);
 			if (error)
 				return error;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -430,8 +432,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series.
 			 */
-			dac->dela_state = XFS_DAS_FLIP_LFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -450,17 +452,18 @@ xfs_attr_set_iter(
 		fallthrough;
 	case XFS_DAS_RM_LBLK:
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_LBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			if (error)
 				return error;
 
-			dac->dela_state = XFS_DAS_RD_LEAF;
-			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+			attr->xattri_dela_state = XFS_DAS_RD_LEAF;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -491,7 +494,7 @@ xfs_attr_set_iter(
 		 * state.
 		 */
 		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_find_space(dac);
+			error = xfs_attr_rmtval_find_space(attr);
 			if (error)
 				return error;
 		}
@@ -504,14 +507,14 @@ xfs_attr_set_iter(
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-		dac->dela_state = XFS_DAS_ALLOC_NODE;
+		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
 		if (args->rmtblkno > 0) {
-			if (dac->blkcnt > 0) {
-				error = xfs_attr_rmtval_set_blk(dac);
+			if (attr->xattri_blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(attr);
 				if (error)
 					return error;
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -547,8 +550,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series
 			 */
-			dac->dela_state = XFS_DAS_FLIP_NFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -568,18 +571,19 @@ xfs_attr_set_iter(
 		fallthrough;
 	case XFS_DAS_RM_NBLK:
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_NBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 
 			if (error)
 				return error;
 
-			dac->dela_state = XFS_DAS_CLR_FLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -589,7 +593,7 @@ xfs_attr_set_iter(
 		 * The last state for node format. Look up the old attr and
 		 * remove it.
 		 */
-		error = xfs_attr_node_addname_clear_incomplete(dac);
+		error = xfs_attr_node_addname_clear_incomplete(attr);
 		break;
 	default:
 		ASSERT(0);
@@ -786,7 +790,7 @@ xfs_attr_item_init(
 
 	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
 	new->xattri_op_flags = op_flags;
-	new->xattri_dac.da_args = args;
+	new->xattri_da_args = args;
 
 	*attr = new;
 	return 0;
@@ -1099,16 +1103,16 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	struct xfs_delattr_context	*dac)
+	 struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				retval;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, &dac->da_state);
+	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		return retval;
 
@@ -1136,8 +1140,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (dac->da_state)
-		xfs_da_state_free(dac->da_state);
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
 	return retval;
 }
 
@@ -1158,10 +1162,10 @@ xfs_attr_node_addname_find_attr(
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
 	int				error;
 
@@ -1192,7 +1196,7 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			trace_xfs_attr_node_addname_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1221,9 +1225,9 @@ xfs_attr_node_addname(
 
 STATIC int
 xfs_attr_node_addname_clear_incomplete(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
@@ -1327,10 +1331,10 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		**state = &dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		**state = &attr->xattri_da_state;
 	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
@@ -1389,16 +1393,16 @@ xfs_attr_node_removename(
  */
 int
 xfs_attr_remove_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	int				retval, error = 0;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		if (!xfs_inode_hasattr(dp))
 			return -ENOATTR;
@@ -1417,16 +1421,16 @@ xfs_attr_remove_iter(
 		 * Node format may require transaction rolls. Set up the
 		 * state context and fall into the state machine.
 		 */
-		if (!dac->da_state) {
-			error = xfs_attr_node_removename_setup(dac);
+		if (!attr->xattri_da_state) {
+			error = xfs_attr_node_removename_setup(attr);
 			if (error)
 				return error;
-			state = dac->da_state;
+			state = attr->xattri_da_state;
 		}
 
 		fallthrough;
 	case XFS_DAS_RMTBLK:
-		dac->dela_state = XFS_DAS_RMTBLK;
+		attr->xattri_dela_state = XFS_DAS_RMTBLK;
 
 		/*
 		 * If there is an out-of-line value, de-allocate the blocks.
@@ -1439,10 +1443,10 @@ xfs_attr_remove_iter(
 			 * May return -EAGAIN. Roll and repeat until all remote
 			 * blocks are removed.
 			 */
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN) {
 				trace_xfs_attr_remove_iter_return(
-						dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return error;
 			} else if (error) {
 				goto out;
@@ -1457,8 +1461,10 @@ xfs_attr_remove_iter(
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
-			dac->dela_state = XFS_DAS_RM_NAME;
-			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
+
+			attr->xattri_dela_state = XFS_DAS_RM_NAME;
+			trace_xfs_attr_remove_iter_return(
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1468,7 +1474,7 @@ xfs_attr_remove_iter(
 		 * If we came here fresh from a transaction roll, reattach all
 		 * the buffers to the current transaction.
 		 */
-		if (dac->dela_state == XFS_DAS_RM_NAME) {
+		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
@@ -1485,9 +1491,9 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->dela_state = XFS_DAS_RM_SHRINK;
+			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 6f5a150565c7..6e4c8e763690 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -434,7 +434,7 @@ struct xfs_attr_list_context {
  */
 
 /*
- * Enum values for xfs_delattr_context.da_state
+ * Enum values for xfs_attr_item.xattri_da_state
  *
  * These values are used by delayed attribute operations to keep track  of where
  * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
@@ -459,39 +459,32 @@ enum xfs_delattr_state {
 };
 
 /*
- * Defines for xfs_delattr_context.flags
+ * Defines for xfs_attr_item.xattri_flags
  */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
  */
-struct xfs_delattr_context {
-	struct xfs_da_args      *da_args;
+struct xfs_attr_item {
+	struct xfs_da_args		*xattri_da_args;
 
 	/*
 	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
 	 */
-	struct xfs_buf		*leaf_bp;
+	struct xfs_buf			*xattri_leaf_bp;
 
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
+	struct xfs_bmbt_irec		xattri_map;
+	xfs_dablk_t			xattri_lblkno;
+	int				xattri_blkcnt;
 
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
-	struct xfs_da_state     *da_state;
+	struct xfs_da_state		*xattri_da_state;
 
 	/* Used to keep track of current state of delayed operation */
-	unsigned int            flags;
-	enum xfs_delattr_state  dela_state;
-};
-
-/*
- * List of attrs to commit later.
- */
-struct xfs_attr_item {
-	struct xfs_delattr_context	xattri_dac;
+	unsigned int			xattri_flags;
+	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
 	 * Indicates if the attr operation is a set or a remove
@@ -499,7 +492,10 @@ struct xfs_attr_item {
 	 */
 	unsigned int			xattri_op_flags;
 
-	/* used to log this item to an intent */
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
 	struct list_head		xattri_list;
 };
 
@@ -519,11 +515,9 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac);
-int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_set_iter(struct xfs_attr_item *attr);
+int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
-void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index c806319134fb..4250159ecced 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -568,14 +568,14 @@ xfs_attr_rmtval_stale(
  */
 int
 xfs_attr_rmtval_find_space(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int				error;
 
-	dac->lblkno = 0;
-	dac->blkcnt = 0;
+	attr->xattri_lblkno = 0;
+	attr->xattri_blkcnt = 0;
 	args->rmtblkcnt = 0;
 	args->rmtblkno = 0;
 	memset(map, 0, sizeof(struct xfs_bmbt_irec));
@@ -584,8 +584,8 @@ xfs_attr_rmtval_find_space(
 	if (error)
 		return error;
 
-	dac->blkcnt = args->rmtblkcnt;
-	dac->lblkno = args->rmtblkno;
+	attr->xattri_blkcnt = args->rmtblkcnt;
+	attr->xattri_lblkno = args->rmtblkno;
 
 	return 0;
 }
@@ -598,17 +598,18 @@ xfs_attr_rmtval_find_space(
  */
 int
 xfs_attr_rmtval_set_blk(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int nmap;
 	int error;
 
 	nmap = 1;
-	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
-			dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+	error = xfs_bmapi_write(args->trans, dp,
+			(xfs_fileoff_t)attr->xattri_lblkno,
+			attr->xattri_blkcnt, XFS_BMAPI_ATTRFORK, args->total,
 			map, &nmap);
 	if (error)
 		return error;
@@ -618,8 +619,8 @@ xfs_attr_rmtval_set_blk(
 	       (map->br_startblock != HOLESTARTBLOCK));
 
 	/* roll attribute extent map forwards */
-	dac->lblkno += map->br_blockcount;
-	dac->blkcnt -= map->br_blockcount;
+	attr->xattri_lblkno += map->br_blockcount;
+	attr->xattri_blkcnt -= map->br_blockcount;
 
 	return 0;
 }
@@ -673,9 +674,9 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error, done;
 
 	/*
@@ -695,7 +696,8 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
+		trace_xfs_attr_rmtval_remove_return(attr->xattri_dela_state,
+						    args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index d72eff30ca18..62b398edec3f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -12,9 +12,9 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
-int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
+int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 6c5a59c87526..02bc2d8d468b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -266,11 +266,11 @@ xfs_attrd_item_release(
  */
 STATIC int
 xfs_trans_attr_finish_update(
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_attrd_log_item	*attrdp,
 	uint32_t			op_flags)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	unsigned int			op = op_flags &
 					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
@@ -282,11 +282,11 @@ xfs_trans_attr_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac);
+		error = xfs_attr_set_iter(attr);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
-		error = xfs_attr_remove_iter(dac);
+		error = xfs_attr_remove_iter(attr);
 		break;
 	default:
 		error = -EFSCORRUPTED;
@@ -330,16 +330,16 @@ xfs_attr_log_item(
 	 * structure with fields from this xfs_attr_item
 	 */
 	attrp = &attrip->attri_format;
-	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
 	attrp->alfi_op_flags = attr->xattri_op_flags;
-	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
-	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
-	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
-
-	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
-	attrip->attri_value = attr->xattri_dac.da_args->value;
-	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
-	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_da_args->name;
+	attrip->attri_value = attr->xattri_da_args->value;
+	attrip->attri_name_len = attr->xattri_da_args->namelen;
+	attrip->attri_value_len = attr->xattri_da_args->valuelen;
 }
 
 /* Get an ATTRI. */
@@ -380,10 +380,8 @@ xfs_attr_finish_item(
 	struct xfs_attr_item		*attr;
 	struct xfs_attrd_log_item	*done_item = NULL;
 	int				error;
-	struct xfs_delattr_context	*dac;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	dac = &attr->xattri_dac;
 	if (done)
 		done_item = ATTRD_ITEM(done);
 
@@ -391,9 +389,9 @@ xfs_attr_finish_item(
 	 * Always reset trans after EAGAIN cycle
 	 * since the transaction is new
 	 */
-	dac->da_args->trans = tp;
+	attr->xattri_da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, done_item,
+	error = xfs_trans_attr_finish_update(attr, done_item,
 					     attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
@@ -515,7 +513,7 @@ xfs_attri_item_recover(
 			   sizeof(struct xfs_da_args), KM_NOFS);
 	args = (struct xfs_da_args *)(attr + 1);
 
-	attr->xattri_dac.da_args = args;
+	attr->xattri_da_args = args;
 	attr->xattri_op_flags = attrp->alfi_op_flags;
 
 	args->dp = ip;
@@ -552,7 +550,7 @@ xfs_attri_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
+	ret = xfs_trans_attr_finish_update(attr, done_item,
 					   attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
@@ -568,8 +566,8 @@ xfs_attri_item_recover(
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 out_unlock:
-	if (attr->xattri_dac.leaf_bp)
-		xfs_buf_relse(attr->xattri_dac.leaf_bp);
+	if (attr->xattri_leaf_bp)
+		xfs_buf_relse(attr->xattri_leaf_bp);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-- 
2.25.1

