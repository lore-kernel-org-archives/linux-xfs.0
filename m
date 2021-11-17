Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00094C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA52561B5F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhKQET3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:29 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1754 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233026AbhKQETZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:25 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH44w7K031988
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=JfzO3UtFegTPaUBfLv5LF15rBcn4nfi6NU8LiXOOsPk=;
 b=NrT83q40iPdao6P9LLaYzx74IK2w0xG76ei5XwYNeKvnCdKBitFgpzvX/W7kvLgmopVc
 tIMxfKWV+zsGNphizb5Ahy4MXeZd+g1zCoYhx8shEFC3lJv8+Z88ekCOU1jwcW9BK0J6
 pVTD7sVjY9aPOP50bK7rQkmYOcUpL1xYNA9qci6bTusczqz/EeQAEY5cQccTjwqNPqcZ
 hxfsP6Bo0tvmqZVCuU6YA6hOh5tSL3g1PEhDlk+ZLfj2ySoK4hkhX81L27WVb+UxdWr4
 FT4ToN1Da3GLIbtbJm4PEzy68bnoJL2ASY731b1h/VKag354s8bRN9IpLvrCa/4+Xmyn Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv86es1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4Aehf037362
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3ca566dagu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBWIDvjxxn+YUDBcNenI5I7dA8eMMEhnF/u5YKZ9HzHPazHDMhWORvru6gCI3YpG5+QBWpTmxo1GHAoTHZx9K9WSGlItAw64T7nbxH45L5IvtjP0iU/td5tq77wYyHlKkWAVqM2A1J8m6PwBt92DZ1kuMef+mvNUyYKJWbqvIJ+kpBlJyUB38aBf2GUqSkeBauxuAglyZzDpc6a9s3lqMshVXK+F/hZyBzstZ0fkJ+bc0OYlAgrTqcKSmhGqVQnm00gGevIxpjKKq/S3vz+AeWHPSCKS/NbtDc76Yz+DnRFqF2K0PB45DEZtCLOzCXhMbw9+j2oOavt0A++6d/wCYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfzO3UtFegTPaUBfLv5LF15rBcn4nfi6NU8LiXOOsPk=;
 b=gPu+9rdr6RSz4M0J8ThNBI+OYV0HcPMkG9hylDmDLTjkY1wRZxsEVPJsCOZ8tnPMWyUkcgASniu6Wz67zrdS7J61wibh/w1w9Bwf4Kx5CqM5wc0xfOUbmJT7XUt5I0yxuWAlThF0x5yEdomS69svccVub0wAB9x53Qmmh0XhJogWZRuUTdoil0jDDnjDOoI312nSuBd5DC2dR7rfyLbldZVGvOMMANfS4qrxjpmivgCQF+pI63G639pEW7JJgn3gokDiY3yWUErPZ0vd1xgP/IjjF/YRrSEbgrhlufIU5M4DGXljz5V6NZvcQDlOd+AQ5H540YuxiGqJZVVyhmpNJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfzO3UtFegTPaUBfLv5LF15rBcn4nfi6NU8LiXOOsPk=;
 b=BfhWWGLPTj+tI9RXaywDOMuq1t36ayrdFyvBosIt6r3nCLK/AlzqXL4lIkHXpVZXP1PNXRr/GLgORJXio5BZQvh96zmDO9tZuAlJxK0/Hg0VuYSxxdSdUToOyaSV70YOu1AFSzJxz93Auu8i2BvfBqkaU6M+YdFHJY4kE1+0LQk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:16:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 12/14] xfsprogs: Merge xfs_delattr_context into xfs_attr_item
Date:   Tue, 16 Nov 2021 21:16:11 -0700
Message-Id: <20211117041613.3050252-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a1e258f-2bd5-450c-2f27-08d9a981042c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4446:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44461C03371F9FF46C81CABB959A9@SJ0PR10MB4446.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kOrrxrRaw3aEl8MKZDoMnkDQVPpfGkppeZkmXnoRapw8Z1qSOuY/nSTpNC1PMhJ5wC6lqIlf0vaZ6ChC94qRie+ojvvZnOs/DWUQBRkSnNe38iGtwZscijxog6O33lbUdc7LxY+CLBe89HA0BXjf2AcLh06WN6rM3Sfnjbj0hyDE4lH8O2FtLyuohElmicF1juldDzI/GGXMF78KM8ZlgeGaw7PJpnvwxjMrbLGmZgVEq/cadEoCDQ6wqZABnhD9CStR85N1eszII84Chw6+ruKZ1lSTHf+reJ/ITcDjONo/chrYzqMFvpyzrLFsWD0LSeWiUHXqKyXxN0BFt5ENLjCyXm1zxpC5A4cGYdBUb/fblRxZy9fDNrl+gGfdvkXP23CBfCxjIMEJNtWNHpbyabOCiom6xEVKZ5w2+mT+GLKuHPgt4D6eSeAO94fGEY/cX1FYdOpf5kHOHm/vVObg3aYD6hsLh3abaXhPLXolPG15l2XRwa7HjW15trOYk62v0/KCAbv0a7BWVP1WKNqJvy5fA5N28I4Zzq/XmqfGggVQS/4eAacHqnArv9AolKDBJ27EfZE8SZoLgxfJohKdMAB+gCcJN2sVWh+nvLlIFqr3w+QJNEWuoF2zuw1QpU0xabOuoL8IAsZGGT5Pk18OWZiRU4L9JR9Oc0w69coWNtuRg+2QJkRfKmYTgDzt+ZBdgjjfcyH6rqlIOTighXx79A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(2906002)(956004)(2616005)(83380400001)(38350700002)(38100700002)(26005)(52116002)(5660300002)(316002)(6486002)(6512007)(44832011)(6666004)(8676002)(8936002)(30864003)(1076003)(66946007)(66476007)(66556008)(6916009)(186003)(508600001)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J9kVWZe74XW8HoSeNYhIeNv80q8Vs4NAgcf7UNHYDvMiQ+oEylLSkv6fPe3p?=
 =?us-ascii?Q?0Mvyf3w014WnuUk855LEPLoSGPPd6zlDazYdrbXAb+pX2FRl83RuMbz6lLrS?=
 =?us-ascii?Q?4O1yLRUOnjnX3vhCczcylUESDxLEdT7tL3KudHj5vtnel3jDQxcEii/psdmc?=
 =?us-ascii?Q?BuG8oc86xYvm4FURVcWtRYRUASqOCx5PRUkIPUxWwSZ4NS/0zCgiVC9Vxrxe?=
 =?us-ascii?Q?TM8e/JJ24x6T2iAL+Mkx+CvfKISCpSn/YGrylmCl8oSvT6G7GPG0m6FEdJEN?=
 =?us-ascii?Q?4WEu5pAypknaKaYHHZdfNK27CG3ObwYEbZLcLew0+GoPfLErp801zAKiut4y?=
 =?us-ascii?Q?nar9kPMwykPJaFr9RniOVbxCN5lIM2so8CntQOOYeB58sh20FR99PXWR8+mI?=
 =?us-ascii?Q?sMNXinFn7WoxBH/c1cCKvSHZPqnvpMkjOJzxeqops6bdaEWzeWRhg/6zVoCU?=
 =?us-ascii?Q?1WhOmY3j3LookFxDaprKNjlWDFXsc2vNdiU5KZjy2N5XkcS/piQRoZs47MFx?=
 =?us-ascii?Q?6yqRcIkPqV2RMWQfefAnQqytaexomMWYz+F1Nnrs/GEqc2it18UEg9pGvVE/?=
 =?us-ascii?Q?a/RNOnDcM4phyK6M7UOroiPIuFeAC1xzo47wT4M7gV9eXyXNSx2gA2Yr0iiz?=
 =?us-ascii?Q?pd6o/ieKRNrFiNlBPPIr55VZ3c19V59bSRbs+xVMZnhBizb024oE+1NZ941+?=
 =?us-ascii?Q?CgCt1aeWaiBRJeVaN89qil4O9l4rgv4l8eatbAP0lsKqL1L7oCS7HRChcwHT?=
 =?us-ascii?Q?b7/Tcv+yckhvgEozL+mBy1pHJCfIqtca4s3lENOdo4wk7/kDi7G5ic0Pt+HB?=
 =?us-ascii?Q?pgOPDJ8Uo+LqmJmYy+yTVyv96Q9PV81kdmAfzlenP308SLdz5XCVN0CbuaAw?=
 =?us-ascii?Q?Qnqnvp3yD4W9uhisuHYPuZUYSc/OFVE27NNNDJihc6orfc8pvmTUEVbJWhox?=
 =?us-ascii?Q?UFj5C7D/aMa3aJGZrs0qrySYGgBvz5YwQ2Ud4pkYX7IiMHDlxvAKs1CvqC+b?=
 =?us-ascii?Q?At6u6/+4i0sDc1G2Rj89WoN2pGGV15DoAMNBdxF3gLjgg7b1XumLBwJiN3YJ?=
 =?us-ascii?Q?CRYh9j7YolhFtTbqalOIYZAJNI4zddfYhOkF9xRaMXwsIiChe1rVGeEWSxte?=
 =?us-ascii?Q?AR5DFuigwJ17oTtCXKgnEY2q2r2RKD/gJwKouLm89R5Fdcjf/mZB7cTodS9g?=
 =?us-ascii?Q?ImkJ3n/8nEgUrthFEJZJ1SmqhXWv6zIfopPC/VfDwAetKJhcWh7h/oDd60LJ?=
 =?us-ascii?Q?R8biTzWdBYYCH1jgls2ORp13KNNzZbSb7YtnCB9+5qdA3gkLMtexbWuVDXTD?=
 =?us-ascii?Q?peBoswwlEoxqo4bP3yeZS3vcnAtHUrWfApkw+rBp8oEUXsfyxsmPJHdp9Jzb?=
 =?us-ascii?Q?0wkPBW5AX6T2jjZpb3V+3zA6pXHjiGjdJrLJNzyC7KDvWf/FSLdpXAG12u54?=
 =?us-ascii?Q?V86iyDkZsBHxydhksw10wyMkwIKYSXMl6KCI1ILREogcWYixgWmLtUwbnQB9?=
 =?us-ascii?Q?hgh0zDKZnU4wbFUqo66OmM+H8HPXIAW5+o91qBppn0oPvhcUfWhXfg4jZxRb?=
 =?us-ascii?Q?zLdE2TMBmrc5PbI8RM8sDxnGuTsbDAgrSEGM/dT0CPLZCcz1vSk8lJEUo19O?=
 =?us-ascii?Q?hEsiBCXbrEpa/X+EEO42MlRf8RR4PBbMwWZDyR67G+ieKodWZFUuLAr98FSu?=
 =?us-ascii?Q?EUsUQg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1e258f-2bd5-450c-2f27-08d9a981042c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:23.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3CVqYzRCO4qNWAJEW5tOLvcByLBf+RodrBZkGkVc08qt0lHkCjipFzqoSlDTf8pTnAJ9DX82cyHPtUVciKYTRXgRrp3RngRUUpiLD7AAbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: UCSwkJRSF4u_cQBu6JD8re0UgCaxwL7b
X-Proofpoint-ORIG-GUID: UCSwkJRSF4u_cQBu6JD8re0UgCaxwL7b
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
 libxfs/defer_item.c      |  14 ++--
 libxfs/xfs_attr.c        | 161 ++++++++++++++++++++-------------------
 libxfs/xfs_attr.h        |  40 +++++-----
 libxfs/xfs_attr_remote.c |  36 ++++-----
 libxfs/xfs_attr_remote.h |   6 +-
 5 files changed, 128 insertions(+), 129 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 5392a1bcb961..4b669b769968 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -123,10 +123,10 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
  */
 STATIC int
 xfs_trans_attr_finish_update(
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	uint32_t			op_flags)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	unsigned int			op = op_flags &
 					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
@@ -138,11 +138,11 @@ xfs_trans_attr_finish_update(
 
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
@@ -200,18 +200,16 @@ xfs_attr_finish_item(
 {
 	struct xfs_attr_item		*attr;
 	int				error;
-	struct xfs_delattr_context	*dac;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	dac = &attr->xattri_dac;
 
 	/*
 	 * Always reset trans after EAGAIN cycle
 	 * since the transaction is new
 	 */
-	dac->da_args->trans = tp;
+	attr->xattri_da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, attr->xattri_op_flags);
+	error = xfs_trans_attr_finish_update(attr, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7d28914894ce..c5b0abb5df20 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -53,10 +53,9 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
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
@@ -243,9 +242,9 @@ xfs_attr_is_shortform(
 
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
@@ -262,7 +261,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &attr->xattri_leaf_bp);
 	if (error)
 		return error;
 
@@ -271,7 +270,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, dac->leaf_bp);
+	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -291,16 +290,16 @@ xfs_attr_sf_addname(
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
@@ -310,14 +309,16 @@ xfs_attr_set_iter(
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
@@ -337,19 +338,19 @@ xfs_attr_set_iter(
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
 
@@ -361,9 +362,10 @@ xfs_attr_set_iter(
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
@@ -374,10 +376,10 @@ xfs_attr_set_iter(
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
@@ -387,11 +389,11 @@ xfs_attr_set_iter(
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
@@ -427,8 +429,8 @@ xfs_attr_set_iter(
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
@@ -447,17 +449,18 @@ xfs_attr_set_iter(
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
 
@@ -488,7 +491,7 @@ xfs_attr_set_iter(
 		 * state.
 		 */
 		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_find_space(dac);
+			error = xfs_attr_rmtval_find_space(attr);
 			if (error)
 				return error;
 		}
@@ -501,14 +504,14 @@ xfs_attr_set_iter(
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
 
@@ -544,8 +547,8 @@ xfs_attr_set_iter(
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
@@ -565,18 +568,19 @@ xfs_attr_set_iter(
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
 
@@ -586,7 +590,7 @@ xfs_attr_set_iter(
 		 * The last state for node format. Look up the old attr and
 		 * remove it.
 		 */
-		error = xfs_attr_node_addname_clear_incomplete(dac);
+		error = xfs_attr_node_addname_clear_incomplete(attr);
 		break;
 	default:
 		ASSERT(0);
@@ -784,7 +788,7 @@ xfs_attr_item_init(
 
 	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
 	new->xattri_op_flags = op_flags;
-	new->xattri_dac.da_args = args;
+	new->xattri_da_args = args;
 
 	*attr = new;
 	return 0;
@@ -1097,16 +1101,16 @@ xfs_attr_node_hasname(
 
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
 
@@ -1134,8 +1138,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (dac->da_state)
-		xfs_da_state_free(dac->da_state);
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
 	return retval;
 }
 
@@ -1156,10 +1160,10 @@ error:
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
 
@@ -1190,7 +1194,7 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			trace_xfs_attr_node_addname_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1219,9 +1223,9 @@ out:
 
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
@@ -1325,10 +1329,10 @@ xfs_attr_leaf_mark_incomplete(
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
@@ -1387,16 +1391,16 @@ xfs_attr_node_removename(
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
@@ -1415,16 +1419,16 @@ xfs_attr_remove_iter(
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
@@ -1437,10 +1441,10 @@ xfs_attr_remove_iter(
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
@@ -1455,8 +1459,9 @@ xfs_attr_remove_iter(
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
-			dac->dela_state = XFS_DAS_RM_NAME;
-			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
+			attr->xattri_dela_state = XFS_DAS_RM_NAME;
+			trace_xfs_attr_remove_iter_return(
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1466,7 +1471,7 @@ xfs_attr_remove_iter(
 		 * If we came here fresh from a transaction roll, reattach all
 		 * the buffers to the current transaction.
 		 */
-		if (dac->dela_state == XFS_DAS_RM_NAME) {
+		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
@@ -1483,9 +1488,9 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->dela_state = XFS_DAS_RM_SHRINK;
+			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 60806dcd5e5d..089a39a6bc7d 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -430,7 +430,7 @@ struct xfs_attr_list_context {
  */
 
 /*
- * Enum values for xfs_delattr_context.da_state
+ * Enum values for xfs_attr_item.xattri_da_state
  *
  * These values are used by delayed attribute operations to keep track  of where
  * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
@@ -455,39 +455,32 @@ enum xfs_delattr_state {
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
@@ -495,7 +488,10 @@ struct xfs_attr_item {
 	 */
 	unsigned int			xattri_op_flags;
 
-	/* used to log this item to an intent */
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
 	struct list_head		xattri_list;
 };
 
@@ -515,12 +511,10 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_set_iter(struct xfs_attr_item *attr);
+int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
-void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 42943b3542c4..72461bd47f3b 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -567,14 +567,14 @@ xfs_attr_rmtval_stale(
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
@@ -583,8 +583,8 @@ xfs_attr_rmtval_find_space(
 	if (error)
 		return error;
 
-	dac->blkcnt = args->rmtblkcnt;
-	dac->lblkno = args->rmtblkno;
+	attr->xattri_blkcnt = args->rmtblkcnt;
+	attr->xattri_lblkno = args->rmtblkno;
 
 	return 0;
 }
@@ -597,17 +597,18 @@ xfs_attr_rmtval_find_space(
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
@@ -617,8 +618,8 @@ xfs_attr_rmtval_set_blk(
 	       (map->br_startblock != HOLESTARTBLOCK));
 
 	/* roll attribute extent map forwards */
-	dac->lblkno += map->br_blockcount;
-	dac->blkcnt -= map->br_blockcount;
+	attr->xattri_lblkno += map->br_blockcount;
+	attr->xattri_blkcnt -= map->br_blockcount;
 
 	return 0;
 }
@@ -672,9 +673,9 @@ xfs_attr_rmtval_invalidate(
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
@@ -694,7 +695,8 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
+		trace_xfs_attr_rmtval_remove_return(attr->xattri_dela_state,
+						    args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index d72eff30ca18..62b398edec3f 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
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
-- 
2.25.1

