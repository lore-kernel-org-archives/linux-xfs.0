Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2D9C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65ECE61107
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbhG0GUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51408 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235366AbhG0GTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:52 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GunL007326
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=7hn+/kfRV/bjjoR9w506HS9owY8p4367NlFHckTYsSg=;
 b=KAPyJXhR76s+j+siVt3zQCcGjazUcz2iGe6hDwIdWfRaj18iX0VOLWwNDrkAQnNVD126
 GBIQnyL/p6ZfZmTriMXdz3BOl5gWKh2okkFPp4StZzLG4qeg5MMJsW3yN05xLFmDYaPf
 SeGJsLf7NZKb4asLsjbTomdJ4AO/KBt5v6BFvVo7w4PqOwsidrQpHq0+HbG4KBjx04PE
 bM8ICKQHgPtd8ChKgQ2miBWmuqN4rO+pS2UAOtVQCy5BgDaHMuAPFECVVmeLgA8Zfdaf
 os7o/5Hy/Mx1+n/RnP41CdmyFLld9/CgDTXZLitG7MDHNVeoQdJj879PCqNFZDCRtvyv 2A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7hn+/kfRV/bjjoR9w506HS9owY8p4367NlFHckTYsSg=;
 b=njTshsAAMfNsR/Dlbqu5Bl8+A4ITJMhIIe9xU4cam55XC0RDyIwpIw9Kjos4OXb/x8dR
 3QweYoOWBAzLBT2twdMLYYASL1uAb+1RdB3DfB4DvmESU4ZFC4sLPaSdLdlAzUOwcEgm
 gHKVoI4UC3egRnqY9ixvhohDxBXe05cAGDmKabJdOBgu7I6MY3TLacU4GaHGa8LjTx5A
 nqc0wK8YK/3W/93c8HhgDJ05OvkpT+k8vUaOBivQYA5+II6pxGlgu3ldzHgMgFUEICKG
 /Ko2xLq2285DhjhS3ripQwJRDNL5MsvuvHQjzohfMmvAYu+fPIeGRD/Zwn4zM93+d6+W Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0ue3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJB114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMpNyn4ZU4qCdQY+Khuk4t+70Dk3GuvJyMUFy6FxLKPs8W57kRMdx32UZmhd7TNINOGnr6mvjbxvIihtTMHrK0wgt4JwU/T/WeX6YNP/eOKhl7Bw/fEOTKVr5gdlcNnW1oW258zE/YH7k12nUp7Vy3I25sTe+8hlUzkHdG9wMsMfHz0GDj68+kmLsOSidGSEwXusEaXxG3056sdV9rYWFlJe7r6DjdUmCeWggJNACjiyRNq4SACeoTIXYxJQhcfUdaVcSL73kNf/kI39pPA1hJXrnLOJ93ipNc0XFVHDFRIMmUFmJmkM1hKsp8kge2e6uUHTtDBCiitwjAk5NRxNvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hn+/kfRV/bjjoR9w506HS9owY8p4367NlFHckTYsSg=;
 b=PHB/eavuoFvZWZYsX3yk6o7BXgyL4pbZYnrszNAQ8hsCzOQqN4uotkiDH8tFZM+P2PLJTCnImsXBIxQNuPl9KoTtzErRucCzlA2cSVA0UqndYXfVWirdrL4ut/+lZA0pX28FNlJa7phgaKANZyRNAeX7Orn66MomDHoBira9stoFXaB7QwliVc63cwOO/HQrs6X8H3BLuJRONSfoB4wT6jUIqdI5KIM/re8vTIoawboUzzXlXSXQEK3khsWQ02WWlpFJtlsN99UmoH9CLHjDOQHPbHu8laGEZtaFIXsHVwjBw0dHleqAfm7Rzi62lQTgn+TpSP1N1zvJAqfKk3y1NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hn+/kfRV/bjjoR9w506HS9owY8p4367NlFHckTYsSg=;
 b=mmcuqfuIpHeotYZ9o1PsSOhIw6KZcreLKc1cF3jFE/KgsOIYq9T8+Ce1y6AwoxI46pFV7MU0TqFujMMAM3kzmYSom+7E7Xb060y1MYOicsAUysGMDTXmcjxJKpRsUlK6PcRRF+IS6qsv16R/CEWSma7Ptj9ow5oBVNU4gdhe3gU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 25/27] xfsprogs: Merge xfs_delattr_context into xfs_attr_item
Date:   Mon, 26 Jul 2021 23:19:02 -0700
Message-Id: <20210727061904.11084-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4a9fce9-277c-460d-e37b-08d950c68956
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB270950124EA56406F58EE7ED95E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mtBzYIWUcthhsirE2/h0gLZDFQQyvnPlk0lLCdAbcy9/r+jaNt09UBfS3/6RXiWnEh3ry1JVzGS25+5HmmmIDP+rNuyrOvoHJJuznBz+zQn3asPnrNoApvxTxEsmfuwT8/fX7Z8rOgI3rlptNX44bws3k8GEsZuN2RZVCpeHdc8vKYiy9w3ONwgt1OTAMtrShT2NNywTYWL6vuuz+nEzHhmzq7JSPcc/cWqV3sICLlKT/O886lKsZp3uijlPNvammR19Fr7hv/ZiqUuv8Q8k0PO19/D9lJW2EiOSnWvDk/Tfayc83/G7YlPYtxGMBiUTIB9/Uv/UkORtnWvy/TUE6fF94zl4KbazOhEn/v69OZNZ6PP2iDn43BjuONY2KqcCV2V0PIYz324wR3VgOwwsQI8BYGKJ7EV9ZHFj56bJOP3Qt7/0OcMJNidAya72WE+JufKzaiXyqk3Vy7A6zv+dGOkfSe5p8GYYI/ABhRltL4P1fOCq5VhtxSt56mKzWqPJyACudhwCMZFSdZ4zzzLmhYJMo00pZxVOwxyD5N4yg1ux2DYhFMGbhPxPNG0b5B+B4fLXXL6oqkSBHv4GhxISeVAZI6t/t9drlK7b5WQp8MAFxbURAFeMqXQBA1uBLTUEh3Bf/WxzRorcS947wg9ky2w3Ms492f+2AM8LjISx52qOQPaC23EoXkKF7W23SMtPauT/hPUg4ynfdk6XD2WwAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(30864003)(6512007)(26005)(1076003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RfZrLd0Zwv8Es12UaG30OGyUQWp/egvpRVP4HF+6FhHCwnFRjTxUhXM3Mlps?=
 =?us-ascii?Q?OPiih3sigqLzpafKDn4uDrkNEv4eaWRi/uG1w3aA3HqrCZflpTpMV4ffglPs?=
 =?us-ascii?Q?z4oT1jEl5/zn5zdX3/kEvNYTj7JfbrWlFdXVlyowx1QZLtU9SiJZK1CAM2nC?=
 =?us-ascii?Q?PzLyIR/BNHBHITJ5Nm9ru0YFDrxrzWN+AByA+kuIMSkUEErheF2rI3/R6ib1?=
 =?us-ascii?Q?yIp26A/qz92Vu4qxJCnaaoj8JevVtMGhqYynIo9OScrZ3JYUAkPpmI2Sr8lF?=
 =?us-ascii?Q?z7BvJQBzqmLE4Cu8XQPXuTSStn3Pqd4aNKchiEzk8jQve0xbxX01sg6KLvC8?=
 =?us-ascii?Q?fwvp+hSIQ4h0b284RC99Pj/8dh3C9kurp6kvEwJJqgiCAxRxN2rX5ec+rWnR?=
 =?us-ascii?Q?0+VcQJqb3tmwWnCz+dmKByB96PhuidLNduE7owttz/lIf4VregEpEVemXCVv?=
 =?us-ascii?Q?Q7zPWn56c+wPp6inTJjwCYBzcG1XGh7iLIgDWeeTJ5ahBHrdYunrfn/0P0Ra?=
 =?us-ascii?Q?dBRHrYcjYFS3cLbqNdooTjA588wpOLlAZiWqXt3wFtCm53peMIxoPd3t0hrZ?=
 =?us-ascii?Q?EvlWRnbQVwJIflVY7C8Rv1pjVmaC5yj1mo1a9RrGRt4LpcqlccZqGHnOCzQo?=
 =?us-ascii?Q?syje5bIij/eYn1O1gXZbnJYuKl0maaQkXfOJ6GvTzmcYCQnm/qQ3+wn+RlwR?=
 =?us-ascii?Q?Rmt3PvBdnq9hkdE4y/XwFUqA6086z1N7O80eCQJEdVcGVuO/VwsOtNYHrgtC?=
 =?us-ascii?Q?5EKS5VXgyhzFJIXCGlH32kgb3VPQ62e5oq94AOjhpX5x4z2VQq+irUU4b56C?=
 =?us-ascii?Q?4ma6RGHIzVooTeMlGRQXf7W6CMAECmKvzOB2C8OnVhCdDE9OXwow7kwKa5WZ?=
 =?us-ascii?Q?1F3LYB/oJC0k/F/vx7xbQZgxj5kH/X3jCTL1joPVLgEOlx2oxM0gdx+bqGob?=
 =?us-ascii?Q?4WW3GD6utDRQc/GqitqfzWH3qJX8QuB3GOYaiYQHiZf+6CSLzHJCeL8oUzxd?=
 =?us-ascii?Q?UxkIcjWswfP7xrBYig+HevfoI6N/nAUdowsRp3xyLN/viJXp4AFzURD6U57o?=
 =?us-ascii?Q?2d2/qQpqyCk+eS5+0R/nHwO9LCeC++R4l7QXU1Nn9HTJL2u2xO41kmizVASp?=
 =?us-ascii?Q?VZEYjWKnool6xhC0obtHgo3LtWT5jFI5TiNeM5OcGmGKnLrkrMC5/rxu+DTh?=
 =?us-ascii?Q?/RNltp3HtUsbOUB2jbLOVOPc5wCnnh+g/WXBtbaIfdf92UiI58TzdgUXKfv7?=
 =?us-ascii?Q?wF7zuYWnQOdFUZ/SiOmrrWR8p9KMvhEXyi6jGhYXPTQ7HZbt3ww2rQIh2LW1?=
 =?us-ascii?Q?mrN/yCP9CMIcRQMp9WQpbxhZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a9fce9-277c-460d-e37b-08d950c68956
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:48.9596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8WEDxRfXqjEQqVmKHBcrNstzSOuhbvk/Bx/lMnkMOyURZ5oRwIA0AXpG+hs6MUuxCGKBL2H3lj92ZBv1t/F3M4+w6UsJ+i/Y3aSvXU69Bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: eSqp5mAhtL3-ECLAHkj-DNQGQZNMBl2o
X-Proofpoint-GUID: eSqp5mAhtL3-ECLAHkj-DNQGQZNMBl2o
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that merges xfs_delattr_context into
xfs_attr_item.  Now that the refactoring is complete and the delayed
operation infrastructure is in place, we can combine these to eliminate
the extra struct

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/defer_item.c      |  21 +++----
 libxfs/xfs_attr.c        | 142 +++++++++++++++++++++++------------------------
 libxfs/xfs_attr.h        |  40 ++++++-------
 libxfs/xfs_attr_remote.c |  36 ++++++------
 libxfs/xfs_attr_remote.h |   6 +-
 5 files changed, 119 insertions(+), 126 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 6db4380..a595e8c 100644
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
@@ -143,11 +143,11 @@ xfs_trans_attr_finish_update(
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
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
@@ -205,10 +205,8 @@ xfs_attr_finish_item(
 {
 	struct xfs_attr_item		*attr;
 	int				error;
-	struct xfs_delattr_context	*dac;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	dac = &attr->xattri_dac;
 	/*
 	 * Corner case that can happen during a recovery.  Because the first
 	 * iteration of a multi part delay op happens in xfs_attri_item_recover
@@ -217,19 +215,18 @@ xfs_attr_finish_item(
 	 * in a standard delay op, so we need to catch this here and rejoin the
 	 * leaf to the new transaction
 	 */
-	if (attr->xattri_dac.leaf_bp &&
-	    attr->xattri_dac.leaf_bp->b_transp != tp) {
-		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
-		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
+	if (attr->xattri_leaf_bp && attr->xattri_leaf_bp->b_transp != tp) {
+		xfs_trans_bjoin(tp, attr->xattri_leaf_bp);
+		xfs_trans_bhold(tp, attr->xattri_leaf_bp);
 	}
 
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
index 36ef8e7..f5d4380 100644
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
@@ -243,11 +242,11 @@ xfs_attr_is_shortform(
 
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
+	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
 	int				error = 0;
 
 	/*
@@ -292,17 +291,17 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args              *args = dac->da_args;
-	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
+	struct xfs_da_args              *args = attr->xattri_da_args;
+	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
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
@@ -312,7 +311,7 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac);
+			return xfs_attr_sf_addname(attr);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -339,19 +338,19 @@ xfs_attr_set_iter(
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
 
@@ -362,9 +361,10 @@ xfs_attr_set_iter(
 			if (!args->rmtblkno && !args->rmtblkno2)
 				return 0;
 
-			dac->dela_state = XFS_DAS_FOUND_NBLK;
+			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
 		}
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+					       args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -375,10 +375,10 @@ xfs_attr_set_iter(
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
@@ -388,11 +388,11 @@ xfs_attr_set_iter(
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
@@ -428,8 +428,8 @@ xfs_attr_set_iter(
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
@@ -448,16 +448,16 @@ xfs_attr_set_iter(
 		/* fallthrough */
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
+			attr->xattri_dela_state = XFS_DAS_RD_LEAF;
 			return -EAGAIN;
 		}
 
@@ -488,7 +488,7 @@ xfs_attr_set_iter(
 		 * state.
 		 */
 		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_find_space(dac);
+			error = xfs_attr_rmtval_find_space(attr);
 			if (error)
 				return error;
 		}
@@ -501,14 +501,14 @@ xfs_attr_set_iter(
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
 
@@ -544,8 +544,8 @@ xfs_attr_set_iter(
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
@@ -565,17 +565,17 @@ xfs_attr_set_iter(
 		/* fallthrough */
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
+			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
 			return -EAGAIN;
 		}
 
@@ -585,7 +585,7 @@ xfs_attr_set_iter(
 		 * The last state for node format. Look up the old attr and
 		 * remove it.
 		 */
-		error = xfs_attr_node_addname_clear_incomplete(dac);
+		error = xfs_attr_node_addname_clear_incomplete(attr);
 		break;
 	default:
 		ASSERT(0);
@@ -782,7 +782,7 @@ xfs_attr_item_init(
 
 	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
 	new->xattri_op_flags = op_flags;
-	new->xattri_dac.da_args = args;
+	new->xattri_da_args = args;
 
 	*attr = new;
 	return 0;
@@ -1095,16 +1095,16 @@ xfs_attr_node_hasname(
 
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
 
@@ -1132,8 +1132,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (dac->da_state)
-		xfs_da_state_free(dac->da_state);
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
 	return retval;
 }
 
@@ -1154,10 +1154,10 @@ error:
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
 
@@ -1188,7 +1188,7 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			trace_xfs_attr_node_addname_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1217,9 +1217,9 @@ out:
 
 STATIC int
 xfs_attr_node_addname_clear_incomplete(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	int				retval = 0;
 	int				error = 0;
@@ -1320,10 +1320,10 @@ xfs_attr_leaf_mark_incomplete(
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
@@ -1382,16 +1382,16 @@ xfs_attr_node_removename(
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
 	int				retval, error;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		if (!xfs_inode_hasattr(dp))
 			return -ENOATTR;
@@ -1410,16 +1410,16 @@ xfs_attr_remove_iter(
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
 
 		/* fallthrough */
 	case XFS_DAS_RMTBLK:
-		dac->dela_state = XFS_DAS_RMTBLK;
+		attr->xattri_dela_state = XFS_DAS_RMTBLK;
 
 		/*
 		 * If there is an out-of-line value, de-allocate the blocks.
@@ -1432,10 +1432,10 @@ xfs_attr_remove_iter(
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
@@ -1450,7 +1450,7 @@ xfs_attr_remove_iter(
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
-			dac->dela_state = XFS_DAS_RM_NAME;
+			attr->xattri_dela_state = XFS_DAS_RM_NAME;
 			return -EAGAIN;
 		}
 
@@ -1460,7 +1460,7 @@ xfs_attr_remove_iter(
 		 * If we came here fresh from a transaction roll, reattach all
 		 * the buffers to the current transaction.
 		 */
-		if (dac->dela_state == XFS_DAS_RM_NAME) {
+		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
@@ -1477,9 +1477,9 @@ xfs_attr_remove_iter(
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
index c0c92bd3..8a5acde 100644
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
@@ -455,7 +455,7 @@ enum xfs_delattr_state {
 };
 
 /*
- * Defines for xfs_delattr_context.flags
+ * Defines for xfs_attr_item.xattri_flags
  */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 #define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
@@ -463,32 +463,25 @@ enum xfs_delattr_state {
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
@@ -496,7 +489,10 @@ struct xfs_attr_item {
 	 */
 	unsigned int			xattri_op_flags;
 
-	/* used to log this item to an intent */
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
 	struct list_head		xattri_list;
 };
 
@@ -516,12 +512,10 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac);
+int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
-void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 42943b3..72461bd 100644
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
index d72eff3..62b398e 100644
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
2.7.4

