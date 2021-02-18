Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21143C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA6764EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhBRSrb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41590 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhBRQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGT7rK155810
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZM22k/FCdVeZUKgbhlHuLG3cskqLz6ux9x5ACiicHZs=;
 b=QBz7ipUimZ+gFjZuqbTgYgLdm49FOUC3bEThKPPhTJQLHPaGg6QTpz16fvjVRu0HcW5e
 B2BmSiItwryuJAD69eTCtiieQhXOa/W/G4PZiIPdHqkBuZPb/qlO/OBA3VP6HAXlfmmU
 vHhMAX+hkDcja1UKj2m+I03mUa3WfxLbNDcQnjer7bW+nWy5S+FK2oQPs1eLQezE1lz+
 bRiiOdCfYB528amzjoJfl3g2Zi4gWeIfUeYSgVEO1kLwd5TRTrzJ7p8gpNKNhyjZc5a4
 5lxwxCNHSaJumMfyftcfs6zIa4eBW6jxRJzTQmEepTx0LWkGZB2Stl24FFPHSgYrH2Mi 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r6m7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUJtE067888
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 36prp1rkpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLVPSSG71D+BOnuDMJz8HnX0ozs2Mp76f5dQS38r7HTOqCoxKVKOyRkgED/WXEeOFyEtT5JzzFhOT9tme9kuAxaK/0kOppU4UCCGkeF16SnynBbH+xh0PI7OL2h6Be+1U196Sh6ATK7q6E8QP0+XCks0qqPd9gz7bfsnBE4GaF9EviyB+vVENETaOs3JnDi6T+xP7DpzD4TMuX56J14XnpS+J0DCEsbhtyvRUkV8uGPUUgZoQzXTd5D9k/NzK24+pLOsUz/ptt5ApQ8FcNVLv3goj8W3s2ndVNKEmvEhQtNqNv8baHJkN2Zx6zHgq37f0YZlQLoqVzvsvSu4lAcSsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZM22k/FCdVeZUKgbhlHuLG3cskqLz6ux9x5ACiicHZs=;
 b=mHZC2TBYtgrDeM3jA6BSvbhsc7qU09uJg0p2CvLJwBJU1AEUGVbaR6xj9gG+4l86XIO/SgpOXba9AaOHGDxZrb56r+HC4vhOlqaN0hHKVL1Zcl5c2q/faFrng/TgCMHZllYlhAzK3UYrVcwA5Zbg+QNOw5il7eieAfLjDfletJO84itdNUo9Tjj336MpmnKh79C2iVCLxXKUiyfYCZif7rMjrh9TiLpPeuYEitz+uAHprb3G/wsevRrkFaetniLE++PULVwfpxM0i00Wbiig8Qoz6Zb6Uzmdhu8s1V5ybkHhjKqznXPQ5YdDoIiBf8JFzAhHbLLw/IfMO6C6lChIMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZM22k/FCdVeZUKgbhlHuLG3cskqLz6ux9x5ACiicHZs=;
 b=e6DB7xMrQJt7N2zpbLKCJbU+rYBDQkPbM2nYkNJ0V9G3VD7YH1JC9AtmUMJLN/mUYHT1gsjMbE0lwSDZCyKKfU9sTK/CSGZO/EGYsrli7X1sFnPJCPOWPZbsmi3HUhpsWIvHYL+Tmgzg3y54+y3WWga0sl3IOB4rbOEZqY9sIbU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:46:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:46:19 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 35/37] xfsprogs: Remove unused xfs_attr_*_args
Date:   Thu, 18 Feb 2021 09:45:10 -0700
Message-Id: <20210218164512.4659-36-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 07dc3506-affd-4cc2-e503-08d8d42ca426
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4813AE08B9D0757E3CB513C795859@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4NlIWmXPX6sGUroUC5owPz6KL0CKZUtYHUiyWDKr0yu2BV0v95kxaQCY0uRk1Exbu0uwp76DTcTe5QTpg87dLl1yM7uZjI5aWuK8iR88Yu8nYn8iIfluH4y6nX5ZU2z8OVf68Gi29hYBTVWA1Dpr72PwnbQnYJ0xYpeR/eK8Qzbjh5R1E6cD+3Qn8usSIufyTE78uR685SeepLl5Bb9bIPh/nDRqB7q6Vatyytb+crIk9jHyQuSTkQefFy7XSTzhtAaDsFWa7X/XragWpPnc98CeMuE+ZwE4kSbLldDjDfxjSVFUn6eC8FKW+baE0Rpnjo0rfqomjAo+Sxa9Lyt1TDVaeFTG9k2oMv+ZoMDZsgmigJj6UnJOIVVsdJYNT9r6I2XmOSKRqVZT2aw+YPwg8/az1rHhphaAd4FPC42K+bhzcxehMIZihzFC93OO+c3R9UuR8QuU2/BtQd26ClFBJrdh1jFvsi21N2xWpJmGzXa8J34M80lr0HQjrj+/MM5cg3KoDWchbKUDYLYKawo1TXh3FS+pCu78ogHsvvJX7Mz4j3DpyeKqks3chnio75Ezwr3GfaJg/iV0rXnRZee3vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(366004)(39860400002)(6506007)(83380400001)(478600001)(2616005)(2906002)(66946007)(66556008)(16526019)(956004)(8676002)(86362001)(26005)(1076003)(52116002)(6916009)(66476007)(8936002)(6486002)(6666004)(316002)(6512007)(5660300002)(186003)(44832011)(36756003)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OdNBH8LkiqFzfm1hrxi6vf9R1i6gMkMVT074bxNc+20gUxCu5fKcKWUYyH23?=
 =?us-ascii?Q?K1U4GsVvxjDXuXn1ZbAY2nPcCPfssTSEyDuuZvA3ikNBkdeYRyqjyS3O1M8T?=
 =?us-ascii?Q?EjwaMEzU9yyR9PcRVfk33S5NKc5LYc2IaLWGC8ekthiGEL28pya3H4IDPx6U?=
 =?us-ascii?Q?qE/bLgNXYcNkE/btStxMiDR/ZOn3d/ciA2jII/+zlkp11YUO0+4IuOjEHuCc?=
 =?us-ascii?Q?0J/+pYmDF5XjeyBSazozXsPbkQQeV+y4fqRmxBjuzIIpt+thuBWddw7GTxzl?=
 =?us-ascii?Q?XV2dAmGlytkQPbE6brClKObzqxxXI/2tyXafH2rKIVeyC3E4icF0E+Ckd1bu?=
 =?us-ascii?Q?ZZGylXAhCSKPFzy0COV8bGkpvyzR5xRjX+8jlComF6NAVzCh3z9hFsNHb4n6?=
 =?us-ascii?Q?2aMk6eYMQ1kALlCGKagubXomzqCHP8hGsLDjNDxlnrZ2s3OxkGw2IoGUInmj?=
 =?us-ascii?Q?wk3Ovp6XKM7yCnLzknrTcHr8IvkdBZRhZo7MpflUhQGHW8BgurC35XoKHA60?=
 =?us-ascii?Q?W0kow57XlO3uc7u6fziA+VomyZkmVulW4eFz3u3cbuIU0Ek36u9ZbckNpy3Y?=
 =?us-ascii?Q?2E2dXEr+rLBh9mi/KGWPSxdqjRsSnOucDvBPUx8GcVo9mmx6eLS+uVpFKB7E?=
 =?us-ascii?Q?TCYYfIN+f8pU8TOdcHbxahyoqoXgCyrLVZDF3cbKhRdTibbLv0Ed+uf5ht30?=
 =?us-ascii?Q?sarZHbiSdJQ0DeAQKAXzlYtCXAL2pckvbjFChNVMLsmr1BdkpD5t/ifJ1mk9?=
 =?us-ascii?Q?i9G/9davGG35QALKe5RfvhLxLXGcXeTJYEafIRE7nHuibpFzUHAnIz8oAUcx?=
 =?us-ascii?Q?JdHpeirWP2NsxMlT/97Bbfc2MJOKj23ccO2KcxPM2CUEEdD8NBdaK9vvWZ8A?=
 =?us-ascii?Q?pZbcfJOJlwduKlo8VoHkm+KGd5G8ZJ6n933ZCMkL6XtUfuZ97h1ONVK/nD7T?=
 =?us-ascii?Q?H0fgxExKu4tu3m5NfxlGMjmQui4Q+lmtv2HY+zc8sLWgbpohaQdIp9e3oU2y?=
 =?us-ascii?Q?rjlqM6eHnfYsWFkpt/nq/uIyGH94KlDh8yyzJWFTviBu9vhTfH4/2dOaiNhx?=
 =?us-ascii?Q?u/ZwPqiujbykYBcxdznuoyjrefp2dyUcC52PunC+6lLKWcHV12pE34Yo+SNd?=
 =?us-ascii?Q?PFnvRMPMJOH/m27HSsAiVTSVpj4UIqKYrkIUylJt50eQS2WavoIx7I4acfCN?=
 =?us-ascii?Q?1jxocWtdlZh5IhEAIni1jZZC3qfR1GppgFlJVdIOCVtsqWxYNRpor5h8MOtN?=
 =?us-ascii?Q?glc7qIyt36mFWIDwkj1IFWOhIjWQWhHmacEgWTvhes1bzgSU9bCGMWPDEyin?=
 =?us-ascii?Q?ez/884gbQzqj5nfI5fjc2RL2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07dc3506-affd-4cc2-e503-08d8d42ca426
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:47.2329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LP2Nk5jqmB3yeGMWGJmIEiurwSEfiGiBamPPkpMJ8uvQcBqIgcrvwtj7HhFG/ppLJKX1+gG6s0+dHCdtQe0vOGoIm5cptVS2LYPf1dTgxQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c      |  6 +--
 libxfs/xfs_attr.c        | 97 +++---------------------------------------------
 libxfs/xfs_attr.h        | 10 ++---
 libxfs/xfs_attr_remote.c |  1 -
 4 files changed, 10 insertions(+), 104 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index ab21173..054d158 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -131,7 +131,6 @@ int
 xfs_trans_attr(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -144,7 +143,7 @@ xfs_trans_attr(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q((args->dp)));
@@ -216,8 +215,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr(dac, ATTRD_ITEM(done), &dac->leaf_bp,
-			       attr->xattri_op_flags);
+	error = xfs_trans_attr(dac, ATTRD_ITEM(done), attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index e01ed6f..8f638ee 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -62,8 +62,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
 
 int
 xfs_inode_hasattr(
@@ -222,67 +220,13 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * also checks for a defer finish.  Transaction is finished and rolled as
- * needed, and returns true of false if the delayed operation should continue.
- */
-STATIC int
-xfs_attr_trans_roll(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	int				error;
-
-	if (dac->flags & XFS_DAC_DEFER_FINISH) {
-		/*
-		 * The caller wants us to finish all the deferred ops so that we
-		 * avoid pinning the log tail with a large number of deferred
-		 * ops.
-		 */
-		dac->flags &= ~XFS_DAC_DEFER_FINISH;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-	} else
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
-}
-
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args		*args)
-{
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-	} while (true);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_set_fmt(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	int				error = 0;
 
 	/*
@@ -315,7 +259,6 @@ xfs_attr_set_fmt(
 	 * add.
 	 */
 	trace_xfs_attr_set_fmt_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -328,10 +271,10 @@ xfs_attr_set_fmt(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	struct xfs_da_state		*state = NULL;
@@ -343,7 +286,7 @@ xfs_attr_set_iter(
 	switch (dac->dela_state) {
 	case XFS_DAS_UNINIT:
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac, leaf_bp);
+			return xfs_attr_set_fmt(dac);
 
 		/*
 		 * After a shortform to leaf conversion, we need to hold the
@@ -380,7 +323,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -686,32 +628,6 @@ xfs_has_attr(
 
 /*
  * Remove the attribute specified in @args.
- */
-int
-xfs_attr_remove_args(
-	struct xfs_da_args	*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_remove_iter(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-	} while (true);
-
-	return error;
-}
-
-/*
- * Remove the attribute specified in @args.
  *
  * This function may return -EAGAIN to signal that the transaction needs to be
  * rolled.  Callers should continue calling this function until they receive a
@@ -1309,7 +1225,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1324,7 +1239,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1611,7 +1525,6 @@ xfs_attr_node_removename_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_node_removename_iter_return(
 					dac->dela_state, args->dp);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 4abf02c..f82c0b1 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -393,9 +393,8 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
-#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -452,11 +451,8 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index b56de36..d5c2ce7 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -761,7 +761,6 @@ xfs_attr_rmtval_remove(
 	 * by the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
-- 
2.7.4

