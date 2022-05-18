Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87461C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiERAMu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiERAMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE9949F04
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKcweu031717
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=zTi0aiDqR59ux0k76Iwf0o+Rou+7Os1r5aRpMMwrkx0=;
 b=lwDEcmyD43oCrD0mo+TxY3W13CcONq6zYrrbntDIoRi5rIeyr8h6I6PL8I2X+z3c+hlY
 PNs3Kw0ccisYcOLA2rOS9gh2mND8F4De8Pt33sz9pZUxd78xwnXio2Ho+DlckveYgHsG
 oHIskMfFCntPWgeThCpsktXKYysrSorPfRSM7emLldqmF3jpAsdx0PHx46zfPXRIs5Rk
 9R2TMWCBynd7nInd3B5nLpVIBWRTMmJYtVoD6Ruf4ZnlXY274RXuwTK37fPLEjAZ/Qiu
 ZzMfrMNfOuOs4+LFErVdowlwYWq8bW161b2Cx02nf95Jl1ADS/dKVCdiPDr1RPN+sQZd ww== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aafptu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0BhWF008599
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cprqmw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIxh1+TqRAau+1ZtfRk7vg64MuGx8/3pq9YfUjzwvkZAKbzC7e+XXb5vRucVzuOCG3fK76+5Em30iPJEHHg2E9jg/dhp4QYq7XYbc6thaZCWAg7wCT9IO7x2VkpgS/c58/xzE4v2Da+cXRoDpry2aiFWIb2Z+kaKIrpKWXDiJBvGLzT9E2JtWYUZkw4eY+LVcdO3ltIHQ7v288xp3gZoDMzWLatpG+M0auvRamf8J+0qKVZ+GGSp2kzp/zS8aJCFPfd3e4cr32R8oue7FhjwXUYxTUQF7zyn8Nt4B/yarjDCWPSGdA1MRGxfI7/YogEo9eIZls1qnfKcQMLABLPmAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTi0aiDqR59ux0k76Iwf0o+Rou+7Os1r5aRpMMwrkx0=;
 b=gduBlp+5u57taPTirH8yRkiLwTu+yUIAxzvzwdG/CsdUoDXIzt6OtyxRm5AHauYeYL3ogkraHwv7GN3ITg6cnzgWjA7UfSI3A/mTzFQmTqlukpjXKn18lLUzCkeKbr35WcSwJil0at1h/MF6Xlv/pcrxDTmGsibTd5TLEjEeJUEZDsV4ZTVyJmxHK2Qtd28IufUzVI2DAQx1i4zrEKf8yUjC2FRal7FRzGJpLn3bdlN9m2w5lyM2NkzRw/SbG59IHwCYhiI7P6/kBx1SVl2tOLtmkktXFV3031fOgY0pjtng8CiDksvtZe2XNKQOEMh2Qkh40Kcnw69z/eIoWsCqRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTi0aiDqR59ux0k76Iwf0o+Rou+7Os1r5aRpMMwrkx0=;
 b=gNfngJ8YARnEcNRY+EY0QVO9Dw/nKW+vzFpzucXHW7UOgRqVE3RZeQPu1LfeF0xxs0aLvt28SjPz9EFO4z+YEI+FzoNr82kshVpkkWiXiHPG0LNSQjW6/7CsMGQc0v+KBbP/Rz+TczCCjoPV4oRRY6yUNbIIGIih6s8tqf49eJc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:38 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/18] xfsprogs: Remove unused xfs_attr_*_args
Date:   Tue, 17 May 2022 17:12:20 -0700
Message-Id: <20220518001227.1779324-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8acc0e71-fbee-4380-cb8c-08da38631e41
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528285A3E75D542FACB43A495D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKW7K51nEVcRyemeqPHc49R+eHWb3xj/5HZGkIV75mSTfTrtViI5XPdI64ukc/zluObtXDgBuiJeDcoGOZKULF+KFmiTSqprkeCn3YKlT71St73eo5DzZBS3Q7nSmKvFOu9r99xDx27rbP7/K6gfrKN6B6hFDFQhKZtUDt17CFrtF+Y1/umc08WT2BGais9EI1urUDJxJoDRlQlNbq2RnXnHQ7yF7K6B/pRqzRDesfPTdmzWnu7SnnOn2EYXqclXLGlI48UR9U7YzX6dHuouVTnCi9FUB9oqviEoKRriuc0HtF8BNjJm2JWb59GfIpcygcOf0Z9trhgSLo0JdxMTvWQDNZyajO/nsQa8Pyw9xFWP1sI2rmlghxD05O21RId5S0wvV3bIVSMFLWmi9I44l2eS0BM6bTVK96ufV7dMA/C+eNiGDCnUUqF2oqtYYTQE9sQ9wvngOsKZbp+r4ZEUhcga2eSYk7ihVKMhORIazpcKgxPnHHdX0F93jbw4WYxYQ5V0RXNJqc0UcmUYP7xk8ZXBQF0lVCwB9nrNPyQlGd0jj/4kmuki8oBE611eSBOBbInmEYpBh2E34Abi+bLDkoWy5abiATKw12NoU+ygrUdvOP0CNUR8ErYmS3pqec/pSlMy0MDgzvurfuBVMOXzrT6EYdRLD5uExED4DegXTX4VuFm4MxzluIx/rEsI+NJMGsea/X89fYopMuIIJQTtlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FwR0KLHxnDg3gMHkWWB3SdoFjMjd6uOOmE+PkhY8eaWJSPoVxB7Xf7Fzhh/6?=
 =?us-ascii?Q?BNr+gG+KV4pD0x1SsGeH3MNCksloYuQUP/WSPRiYQI168ZSgfk4VgODxfhuf?=
 =?us-ascii?Q?HkOCrvnMWd3lnJnG4HrddUYboFJAb2qIQeAWJe2Jyha2nG0F+6VoB9fTEhSM?=
 =?us-ascii?Q?GMrNiRlOeZLiAqx0b9y3hvmg7y5zguNQHYze5lEUVGdxheXBLXxHldXzCbgM?=
 =?us-ascii?Q?HHNzZCTxOBHHmkuXDd5gWQo57U0lPwBVbyw1JciYT6Xnsnm/wWEZR0GgZUwl?=
 =?us-ascii?Q?88F+9HLPMg6fpVuPFRS1pWdZBK/n/1h3efWvwPbvoZKGyfUMsqhbkkMjVv4A?=
 =?us-ascii?Q?pmT7fGdfdFssAzD4dRQsONUlEwTDtyktvSgycl7bXFH+kY+mBQKO0jFWCmmK?=
 =?us-ascii?Q?TTn+VOsx7TK7iZ+la6es82AwBmEuQ8Xdu6eQohqfaLI2h88r+IfWp0U+s3HC?=
 =?us-ascii?Q?B88oT7hqr60hMJ85dGMArSuJVha/aCYaLLrztJ+jHy6pAgmOPkyUzWLfoLwd?=
 =?us-ascii?Q?c+I98pGnnPi3X84jHtfNIfE4/hwNi5Sfnhvv/SIGiPWtBsqcVE2Iz4209aWh?=
 =?us-ascii?Q?e4GzqpZMlz/zqmTaOThfyF0YNAcbqRPnBI4lx2u9Et5p/Dwd/j9xWkeSUm4x?=
 =?us-ascii?Q?tTao1LR8Xz0q+Pa9gIKUPZ7fDGhlWqVkclih2QnBDivHAezs9vEoZBolCzlZ?=
 =?us-ascii?Q?8qVD3lLyWUMH65//b656eyYz/VAzwJ4T/jFUu3iWEKcgRlsoJ5ltU/AFm0IB?=
 =?us-ascii?Q?nG9sEYSxJ00AoszVQXawrsz8d2CUz5Jgj+btK/w+DPFMmv8uw00XlKFvUAql?=
 =?us-ascii?Q?ty8OcPjRW9iObFVIhQW3fOGNJhVvW1k72V84HK4yfpCEK6saQ+8yvliMS/Uq?=
 =?us-ascii?Q?Omx2I/hfqGNFHcBJIcWMHcMgPBKbOSYCL0C5qipYnj3bQT2P0zpC/+D4pnNs?=
 =?us-ascii?Q?LzFQfJD3jGkFthJLM1FTxu4tpelZ+JhABhHkJm5aO26ButJ6hixU/Xcd2VDp?=
 =?us-ascii?Q?lj9GgbXDVXaYl0dS+YJefPCvfXq6owL51ZRHYuGuv2/fVnXXmkD8aUwJXvgp?=
 =?us-ascii?Q?iy4VNZZxgFlnV8TZ387rX+1yV+ZKw+DfEEb0t4bev06e6xrF07wIAzIdgg1r?=
 =?us-ascii?Q?bpAatCcLdebgwrfAqH4plvHRYIwVwZoYGx5d2OnZph3+OaBWtYTANuDoZ4LG?=
 =?us-ascii?Q?k/ldXi9qWwq0pqJ3YEX+g5+MzvU5ajxeHaItaWvH8wew+iVbMiMd91m2mSkx?=
 =?us-ascii?Q?KTzIqLGE41Fp+V3aaLW8TV9zh44961j3Q+ziqriXTxX/K84uItj6ILjv89Mj?=
 =?us-ascii?Q?N7RTK8L2RGDSAnaZDo8DMI9ogbPTBPBijb27ULxyDwoN8F+Phmsksg9qLli5?=
 =?us-ascii?Q?BX5I91navUCsRrwsyuHBJwTpcl3pnBVuW27wHgYVimm41HIBmbjj3LjLPG8G?=
 =?us-ascii?Q?DSv94oQPAI3MGvUUkRBvl2m8Iowt726YSlKonI5yhZVvrJZddX3ZJClhwM76?=
 =?us-ascii?Q?Pjt/2o7EFb0TD+CE/el1bhGLkAz4h/67CnpJeqQ95w8ftQr9SlnCE0bSqXOm?=
 =?us-ascii?Q?kldSw9lY4w3CALhhKwMFPyS5JYeVKKjaGWn2D/ESaRK61KFpThxgFlgWvDe0?=
 =?us-ascii?Q?GMYuZF8KOWIPRg8W3TmbIJVSbq6pqCKs75oIEplxr2H0dDCINYZlRb7novwL?=
 =?us-ascii?Q?wBT3rQ9ll1hEr+aytTDGLVHZccVMG1LRcuqHZ1QmwUn7HeFb8KolpDAY+Bj7?=
 =?us-ascii?Q?NQCCymclzfKVk38ILus53rxiiREPhKs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8acc0e71-fbee-4380-cb8c-08da38631e41
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:38.8454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idBUB/dCoZQY36oqbsXpxjykUtStWkFCAciMc+bXxMZQA0ZQ44jE1+Hjfuz/w0wm3BgS2qhxfrigCZokOowZMKETrQ90y52ASxMg+vKdtxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-ORIG-GUID: Lbb5lqnUIoHAuKVNGp32nLiBjcKC9UBh
X-Proofpoint-GUID: Lbb5lqnUIoHAuKVNGp32nLiBjcKC9UBh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 73159fc27c6944ebe55e6652d6a1981d7cb3eb4a

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c      |   6 +--
 libxfs/xfs_attr.c        | 106 ++++-----------------------------------
 libxfs/xfs_attr.h        |   8 +--
 libxfs/xfs_attr_remote.c |   1 -
 4 files changed, 13 insertions(+), 108 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d2d12b50cce4..c6dd6f235124 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -129,7 +129,6 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 STATIC int
 xfs_trans_attr_finish_update(
 	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -139,7 +138,7 @@ xfs_trans_attr_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -211,8 +210,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, &dac->leaf_bp,
-					     attr->xattri_op_flags);
+	error = xfs_trans_attr_finish_update(dac, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4550e0278d06..3d9164fa9a2b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -241,64 +241,9 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * transaction is finished or rolled as needed.
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
-		if (error) {
-			if (leaf_bp)
-				xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
-	} while (true);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -317,7 +262,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
 	if (error)
 		return error;
 
@@ -326,7 +271,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, dac->leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -334,7 +279,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -347,8 +291,7 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -367,14 +310,14 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac, leaf_bp);
-		if (*leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans, *leaf_bp);
-			*leaf_bp = NULL;
+			return xfs_attr_sf_addname(dac);
+		if (dac->leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, dac->leaf_bp);
+			dac->leaf_bp = NULL;
 		}
 
 		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			error = xfs_attr_leaf_try_add(args, dac->leaf_bp);
 			if (error == -ENOSPC) {
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
@@ -393,7 +336,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -684,32 +626,6 @@ xfs_attr_lookup(
 	return xfs_attr_node_hasname(args, NULL);
 }
 
-/*
- * Remove the attribute specified in @args.
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
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -1269,7 +1185,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1284,7 +1199,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1538,7 +1452,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
@@ -1566,7 +1479,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 8eb1da085a13..977434f343a1 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -457,8 +457,7 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -516,10 +515,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
-int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index afa932904602..5dc93c3b26d4 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -694,7 +694,6 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
-- 
2.25.1

