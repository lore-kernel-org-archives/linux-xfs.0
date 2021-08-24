Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32761C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A3561371
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhHXWpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25276 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhHXWpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OJGjVW025058
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=36oRWiIKZ7x2f4yT2eh46gx0opTIue39d6UEZcudQLE=;
 b=bVM5IqSCt+sFCrg+479WNEYlx69c9QBiZmqT1l21qJq1Wi5ra0jm4NcO2UjuIiIgZXj8
 KDUh2qPj7WXHfupY4TVG+0kQ+Ewo0BNohN+VxeisOYYkz0RT+DxeoGlgtbL62DD6jNDb
 zNdDCoBmQgJlTCnLs9jiTenumlIc1gJ8K1l8HzSZacLVv2xHZVOHueOHDIFywSwxSudj
 +pRIA0I1lxl5KXhAblybFfR7pIqCYm6HYBgDA1E4Xap2uhw7ImFec50bgdoc0TfWjJLO
 zuaPpFasgs7VAKrzmeVQTt/8LhjRSeznpVq7EthbuPVBaODm+g6U1M/dHu3qj65YnWzo 5g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=36oRWiIKZ7x2f4yT2eh46gx0opTIue39d6UEZcudQLE=;
 b=x22woJBYReN5vD8Ouyo0ezp8KBq6YDrHqjisJtRTsfhkHPCGCTSrr5c0lQd8Dxl9Vv8A
 e8peTkyFRMcQsVvhiz5W9jUo5NJZJSdD/zPP/yDqZVj8jS+wbhOSsVnaPPNDakDuX3ad
 IY51wi3QFk+aSyVrZbrTPezFb8KEDsK3Vin4d6ANMLFPjGeV1Xg1gAHxnizVCNhz8J0e
 BtlFDo4P1t/voivmAt2iSKsyrUttt8X58oPPgIdJLp6Ve+Gxmj8AhkNU8zx/uVvTil8X
 tzM9yQOBK+7is4ssz5YnLgjDMDUV2X2Dyhyq5JhU4LU+avylVE/NfkCaf5/y7UJprtzP Gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amu7vtdx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfLTF138047
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 3ajqhfehfv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTIiCA/6PMx3D02mzKg1Bj/07PrTyQ425YzIa4OdbhQAUCMoBXJkRRklec5hFXr2hbkowtnB+VPMhokfZrm1YYx4W2lvB9czE6QvT6PV+nMlnRrVqRMm26/T75YS1ZWgM9V226Uj2npcqctWdnmHJ4SBn+qcm8HdrP8xhJ70eK6ROm94/xD54uTvL7IEINSZZff8lDme/vGuybma5yQ4tHOmDuHQMFEJKC78xeJ69kM1hoI7lNsAiq7KfbKZoWoE3LF0UTMEiDnWJv2D5UWfL7uOGvUyBFvlty1tQM5u8/p38rGkWeFeVpouo3H4odZ2CJ0xMVp29dkn99aHD3tTEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36oRWiIKZ7x2f4yT2eh46gx0opTIue39d6UEZcudQLE=;
 b=fpu00OJbmBUCBiA7mHD2BH59xkKX8aYLl/TvlsT9csDcs4M1XOeJNvPWYR40U+/h52mThjkSFNVDzjT/lkz6e6xdkbyYg4QHA24xB6JRtnHAv6q2xzmKvmbwGe3LVuPg6d16bVTREGPEMa9At/xxMTHzrzOyeSN7k4Eibm+2xrFXyo7kRTkHf4S7aAvQ4312AGp0tcltQCI1l2+QWjk0khSKCJhWMb2mFt6/ImBRxoCSVJt1dJr3EPRXHa0mV3te9G1dCC/7tj0EbhgN1L8LNsPtSs0KIOO6n5kBd4cwTiEa62Lou8ROOCsShB+HpNNrjVWSw3knNxTqpFkwh24GUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36oRWiIKZ7x2f4yT2eh46gx0opTIue39d6UEZcudQLE=;
 b=f7a4AcfRiE6CPb6ejbNRX3Q4vACPMNWmpTQDPlhVKyOIDda/cdxFNHUziivIdIBf9xLtAcIHvup4UUEfwH2ZOX+LhA1CuESP1ZJx4hGWIk/9bthBzCnMZZjitwPXu34FS5pUmhi7r2hrP4YPoZvXmKFPtaiNFNOosjbQFjg3Eic=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 02/11] xfs: Capture buffers for delayed ops
Date:   Tue, 24 Aug 2021 15:44:25 -0700
Message-Id: <20210824224434.968720-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4cd42a7-eb44-4628-38ff-08d96750c328
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46530A695297EBE8CE3C890A95C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZPGtqG98KgE8JcHGDLxq/p4XNqQneO9kLSH3hkLILpS/Lh28AkrFMIp/wC6Rt/OnXPI8PtGfEnHzVM7bQ6cnUEOKeIrddqwkVnB0iuCAdJJsjHYcqPIIZzu+lXTJ0CC5EZSvQzMNa9KPcSUL/kbkHahiflRf/Y3it2DjBckx0gpoF4YYev+I02rjDrN+dc9hPDDeTJI9sFfJcLTbjNH7pLR41h2PIS8VTOc7MwCjVNCdXMkq1JrLDR3xq03KR1MpbFZY5vPPdBU1LuxcHHqEdrlpz3d8v4krBKSsnxQghtgyOCtl4gCgBddVvngm9dGWt2T9PfE78eYnHQRQ1MgfeY/nV0+OnRavmDUhrNzn+m2OtsmZXnzgU1s5aIN9LoBycdxl/qmIvP7FbqBpFvtpqYBPDJN7H/qxye+l+nzJUDnpinB8JpzuOH41ellZbceQihD4YmwqLs9j4YU1D2ddq5Tu+NIJ3ZExBkVPE/kd4wrw0Dz/o/8Xm6u8w4ANGSFmE8SjxBd+vmyOFoFPBz0RNJBvLQgZdVX9ZLnNdY7w39h1WnfAUkuLtWVILkdvyugxlmJ/JOA4tZMHLzuPd7+w4cng3tTRg8RxbaTOVhozdadK8lDQi/NQWEwYg6HJ6OhKXveFoWXCHTboNlY+/TEjxQTxMG7mcZfd+u0FqBML9AeLIe8C4bT3YZXkKdiRc+iYSIZWpEzVCcLoJCg6tmnOnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kTpYvv+h/gyyUk7+/tILhTiWhs5et3kO8T56JLjsfZbF+RYEH/394vpD2Cpy?=
 =?us-ascii?Q?3nI0hYYz656DdDdFtiT7kXI0VBt+iZAq7lvIthyLdTIALQ8Moy3IcCuEtt3+?=
 =?us-ascii?Q?l3aoLKWBwiHEt7dUgLmhW1PYZgDFBz71lqKLJKUcAg5wAIz/C0s8WDNKS9yl?=
 =?us-ascii?Q?R58cugJ4fNDZ/4WLGc7+Mvcl2ZwURpKsVEdQ0U3wIUqyHzUo9VI1lV6pwsX1?=
 =?us-ascii?Q?hKBaOj/w/3741rU0lncD+Xnes+aKhxL8H/TwNQYMKEjLgniH+yJW9xz4IBmG?=
 =?us-ascii?Q?ZAFwntdFqTN5P2VWQU86zTMJH+FKgT8H60Jx0M6XSBKq/UsuU6iMk/xvM50n?=
 =?us-ascii?Q?uSRNciydZtiZdOBTSzEC2bg8xUiHe4LY6BSWuIOpN8aXzILvfO8G80OWq8SA?=
 =?us-ascii?Q?9vY91jvg1vNyXjAoXPgUwiTuxpF+N8KQVoCBUG4xSDnqCWIIZFkzgXOKrAQz?=
 =?us-ascii?Q?rNkEQQBAjgyTiDSDi4FEaADp1/BYWgUKeqhPQlaxkxOM4FBO2lofI912WmKU?=
 =?us-ascii?Q?wzJp8nidOsY5O6X9EKWSNrFXn4CzUqqffRtyLprdDVWMts/NXq73yi8Z5QPm?=
 =?us-ascii?Q?WTHIQmqcMK/sNGQ+56ctIMz8FC/03capGBUNJXFhbrGAm5yCfsmrlcb4pokW?=
 =?us-ascii?Q?ZQEzK+5XuPTutHcQ/xvrIpDZ56fJSaufeyfTQer/YJLgukWlM0sTiDm2XwIk?=
 =?us-ascii?Q?700HeX60+eSm2ZQ5qEIFNW38BUVNrpUY/Vh5cZ8CaLgX1BLGrnt6ug7SWQU6?=
 =?us-ascii?Q?LdT7mEHcJBfmgCf9DEBV5Mya1Uo/6qyqqysyBxDQ3gCESh9I6XZ5ZXSMpZoH?=
 =?us-ascii?Q?U/Sv8/G+7S6Nhx4NY5ARyf5VMcboIsF/fuu45Yl/l95iRuZu9RA8apvL2WAs?=
 =?us-ascii?Q?HTMXiDoeFO9Qjvlj9KZ/w9npnczJdYhbpKQ8G/80daqTuDki0TMkoMT0Mi+5?=
 =?us-ascii?Q?bNdU6XAKHPXdp1JGeTQy97UBI/5zPxKP9helEnEqzTrZ5aBhY2llcs+vOX4q?=
 =?us-ascii?Q?FAPNc076OwDlqJvKLAH4uYv4iFE86mE0leFP5Ucnj8MSsG30/QCaDvd8+ZGm?=
 =?us-ascii?Q?P6Dq8YWRO3m05rVRnRMtjaNyQCRvEZ6gNcYl5SIkZyPd95XIgMmjOKD+aixs?=
 =?us-ascii?Q?3I+EsXZBoiNW0DZQpzqSWuPcfDKqTc896wJhWcDVZFTJkALbuX6ZckqF36v9?=
 =?us-ascii?Q?2P5Kdd4YzI7z77Oo62obJGDCK91hN/j7VuihItRYHTsxtvPozhJMf2/Pu2q1?=
 =?us-ascii?Q?RaInvwCn53tMVnCclI6GFXhchluxkGXXzlP1F8FK+THDueMX6swFor1qiIna?=
 =?us-ascii?Q?GNNDayTqw3Tvz1ng1HW0fjtd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4cd42a7-eb44-4628-38ff-08d96750c328
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:42.0884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxsazdlL8azqCpoIvrKDzeZFyN4l2JezGtpU9gWaGzK9HJ+qHil5kYd9m+mwraN6mQ4OQSf0SAWLhFgj661oTlKUMjRpNI0KUgZlkfPUFxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-GUID: sG4zjPIfWjFXPP-3b6gFtv2v5vSvaY_U
X-Proofpoint-ORIG-GUID: sG4zjPIfWjFXPP-3b6gFtv2v5vSvaY_U
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch enables delayed operations to capture held buffers with in
the xfs_defer_capture. Buffers are then rejoined to the new
transaction in xlog_finish_defer_ops

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  | 7 ++++++-
 fs/xfs/libxfs/xfs_defer.h  | 4 +++-
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_buf.c           | 1 +
 fs/xfs/xfs_buf.h           | 1 +
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_log_recover.c   | 7 +++++++
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 9 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index eff4a127188e..d1d09b6aca55 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -639,6 +639,7 @@ xfs_defer_ops_capture(
 	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
 	INIT_LIST_HEAD(&dfc->dfc_list);
 	INIT_LIST_HEAD(&dfc->dfc_dfops);
+	INIT_LIST_HEAD(&dfc->dfc_buffers);
 
 	xfs_defer_create_intents(tp);
 
@@ -690,7 +691,8 @@ int
 xfs_defer_ops_capture_and_commit(
 	struct xfs_trans		*tp,
 	struct xfs_inode		*capture_ip,
-	struct list_head		*capture_list)
+	struct list_head		*capture_list,
+	struct xfs_buf			*bp)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_defer_capture	*dfc;
@@ -703,6 +705,9 @@ xfs_defer_ops_capture_and_commit(
 	if (!dfc)
 		return xfs_trans_commit(tp);
 
+	if (bp && bp->b_transp == tp)
+		list_add_tail(&bp->b_delay, &dfc->dfc_buffers);
+
 	/* Commit the transaction and add the capture structure to the list. */
 	error = xfs_trans_commit(tp);
 	if (error) {
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 05472f71fffe..739f70d72fd5 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -74,6 +74,7 @@ struct xfs_defer_capture {
 
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dfc_dfops;
+	struct list_head	dfc_buffers;
 	unsigned int		dfc_tpflags;
 
 	/* Block reservations for the data and rt devices. */
@@ -95,7 +96,8 @@ struct xfs_defer_capture {
  * This doesn't normally happen except log recovery.
  */
 int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
-		struct xfs_inode *capture_ip, struct list_head *capture_list);
+		struct xfs_inode *capture_ip, struct list_head *capture_list,
+		struct xfs_buf *bp);
 void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
 		struct xfs_inode **captured_ipp);
 void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 03159970133f..51ba8ee368ca 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -532,7 +532,7 @@ xfs_bui_item_recover(
 	 * Commit transaction, which frees the transaction and saves the inode
 	 * for later replay activities.
 	 */
-	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
+	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list, NULL);
 	if (error)
 		goto err_unlock;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 047bd6e3f389..29b4655a0a65 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -233,6 +233,7 @@ _xfs_buf_alloc(
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
+	INIT_LIST_HEAD(&bp->b_delay);
 	INIT_LIST_HEAD(&bp->b_li_list);
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	spin_lock_init(&bp->b_lock);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 6b0200b8007d..c51445705dc6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -151,6 +151,7 @@ struct xfs_buf {
 	int			b_io_error;	/* internal IO error state */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
+	struct list_head	b_delay;	/* delayed operations list */
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
 	struct xfs_mount	*b_mount;
 	struct xfs_buftarg	*b_target;	/* buffer target (device) */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3f8a0713573a..046f21338c48 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -637,7 +637,7 @@ xfs_efi_item_recover(
 
 	}
 
-	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 10562ecbd9ea..6a3c0bb16b69 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2465,6 +2465,7 @@ xlog_finish_defer_ops(
 	struct list_head	*capture_list)
 {
 	struct xfs_defer_capture *dfc, *next;
+	struct xfs_buf		*bp, *bnext;
 	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
 	int			error = 0;
@@ -2489,6 +2490,12 @@ xlog_finish_defer_ops(
 			return error;
 		}
 
+		list_for_each_entry_safe(bp, bnext, &dfc->dfc_buffers, b_delay) {
+			xfs_trans_bjoin(tp, bp);
+			xfs_trans_bhold(tp, bp);
+			list_del_init(&bp->b_delay);
+		}
+
 		/*
 		 * Transfer to this new transaction all the dfops we captured
 		 * from recovering a single intent item.
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 46904b793bd4..a6e7351ca4f9 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -557,7 +557,7 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5f0695980467..8c70a4af80a9 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -587,7 +587,7 @@ xfs_rui_item_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-- 
2.25.1

