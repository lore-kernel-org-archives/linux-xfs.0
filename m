Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888A9C4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8D6610A0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhG0GUE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50746 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235695AbhG0GTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:51 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6Hlhl023082
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=j8Gq9Y8PWrE/L2p7yPywza/y6db8MuyHSV6v2gUyiEg=;
 b=iZRY0ymF7cHY4WaKOhMH7c0ZZUdBq4C89K/4MyIHWUxLh5YhQF01Ymk0mFRviGbX9tgP
 xFk9QNE9D/fKdjOVAAxnk0H8vgzYu/Y8ndegXfguRR2ZF+z9OJuALXl22QoM/YVvHCOd
 i2x62PYAGH2kSyBMqF+xWaeTnmHsMOXilt1VpkH3aK0VDnavX4IBGSPLu8hgnp58n9Y1
 x8Ff1GAKKTjhmVDym5NVqPXtKzL4Ck0UQ6dlEj2jwzoLYS9Fj2PadQq1O05PoAp6x639
 Gcr2VVNn1kM33iAIHog3N2NZZJevd6Wc8cNZBuk74JamcQnccuN1l1qcse0QtO4UdWeZ Rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=j8Gq9Y8PWrE/L2p7yPywza/y6db8MuyHSV6v2gUyiEg=;
 b=LLSfzHM7lZtzqFKyESDzWXx+zfjHb/ONGLyYvHCoEHMrJOOx6mNfYE+K6G3BjMO0pBnQ
 YGlicGuTJCiRMHBgM+L/FjHeFlQm7eABNgzW3O0z5ZNyq3jtRH1TJb9Z2/sjDfEYttht
 GeYVN/9wJok3+0vv5fnKqEVEH5qbsh3UQVJfhcNC04rwP/oaFlhlnkwPy9qTPrlr5H35
 BfPSjXmRPuFy4Vnxa6V3EwMeRq5QYX0N31m1AsoQk3IuqexyaEKrmEVd3zSdvwPYGbLN
 HOGu/4HYALGnTLwhPYuvCrZotE8Jq9araZy0OIKWI0hpAk3yE/nTj3zokI7lrKxii7gu AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJA114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNJYuBXLKw+rpuvpQ+7q3WRO1OgKKWlc05Tx3hwayXHe3MSMH4oHZmjQNvkzszgDtcwo4ihJKmYFpB4a6+54qjYpNNdGca6iZjwQDM5s2I2zSTvR1Paqhr2Jygy1w1yR4zYWPZg9L1aMFgaTFIUbLg4FldW1hTlZzEJ11A5ZE1LllIQuVA5aQGK0DXJyvkpgvaJT+bu4fwQ+INjsYzB2QAex95E4e/S7z/TVoENNjPgF+b3ULI+J45Cn2/XPyMExz+aANqZMqlMQgVgJxYx11c1J8bdv7pNUMlKJFhX4SKiBsCByCmX9nuG9jmTkM9hblMfOTINLrodDngLOrcxUKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8Gq9Y8PWrE/L2p7yPywza/y6db8MuyHSV6v2gUyiEg=;
 b=AcTg08PrGdG6qyoOpEhzbjs+Gv2gL5++V39xZi8eT0Q9ALqgdVFMS4HPonrIuPNIlgyKDakHLYNeNZ77Aica9KDQIJw3ZZmP9vV0DAPMK8GO7KLUHFfVyUwL8DgyguMi+HZcKSjbRXG5v+TKO4Nof1pO4+27qvBtGBjNbq7f9H43nujVcotEk+TGz4nbBkDo+IhgHtW3lrBJFHCKKQDpRx/FoXL8j305OXQDKa8+nY7gWSDedjF5PjlCS+3yaIPbvp4s1/muRJcM2waIQstFTB771kO43bo/HJBcMZnnVNre2MYujYUu0x9n9vUqCCwnAgP2gO6Ez8HvDrJKuA04rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8Gq9Y8PWrE/L2p7yPywza/y6db8MuyHSV6v2gUyiEg=;
 b=AusgoDXPL71RYSH1gEnOA+nR3xi2pCTkWGxE5IDTmyFGM/zroHAmRpiPy1kPOm0Gxusz0/G0EUzti68zw6cpKdnKgOdrP1vWZS7akFFhtWo2VbYA9+LGIINOqfAGscKLPFfI3SGR4OIXzrm05/wuii2FcBR3Y+vHW8gRjhrpl0Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:48 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 23/27] xfsprogs: Remove unused xfs_attr_*_args
Date:   Mon, 26 Jul 2021 23:19:00 -0700
Message-Id: <20210727061904.11084-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a470cdff-7c85-4005-0938-08d950c688e4
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27090A7AC4B67A1E949FBF7395E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WzMqyDYfNDqZF23jV5GhC/Ob+1SSXQKaJLcmq0Ai7o4fUfhpdhu5XqlQCaMuZ9Zjbnm0eiAC+B4g5ofAZc6agFx4J7Psp+nn5hieIzzxkEITjuXOSagZ4ARXken1uFAc1b5g2ttVNUpt7ah7V+T0U4Nm0rfk2hORJBLfOXNPcFuvbVmCFLZDtCuYaeGQ44ZRofv76XrfzqBUQPUguA7Dg9PaeJy3xLi2Ih+aL1/E73jTeTGPnYxncg1kKLLeomuVBQVYWuYREINIP7Ea+2M4tWA4SVN5QDC21d3wXxHzho8FKHLREoVEtvFz+oqA/WCgRNz3doXCBKaB70rRctbb/VV5KcuaR3kQK6VIOsJbEPRONdgop6yGncIWWCLd10fYOwx3SvkaAa3+hswriIBF70IFlV8VaEqdTMli5RisY2w00+cib/4EsKeAIcF02iTb4lyVEoZEAXGNce2tQJer5FDeafrx/Jl4uCKBQKwC9uNOjy9/YmQVVj+VYHMPoVDDyC6GlGVRgXkS76NOg3ai0kLB9exEAuBtCxK1UT59hi1B5FSGG18frSrJMmadr93BfHGwyPtIEUW/bUu3oUkjqzYCSuPegRc3h/6xeP+rp17aqtGixrsikXEjPAUAWqJXXkRUpOvBk8l9mqi1nNgnpw1/m9J4znZTxr5aPgcKl5ChsYFcZHwOSesCokDTvNb2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(6512007)(26005)(1076003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eGaABnocbCmIRw9SuQeYe9DK561XUeKErlt0JoBrj6h4BP6356e6Q9uw/1Gz?=
 =?us-ascii?Q?ku/althtkIdBZUfFKPBaVXrUdI528Tolxe8OwgvSGd/+23ahEN+X0ZkNqCE3?=
 =?us-ascii?Q?Kcp/NW0dVKhQkwiM2gaC0Ph//yu+GzBrx+S5SYo3Pg66ly5ZqpY8kqNhp4yE?=
 =?us-ascii?Q?ESMx7fGMgCscRj8rmEYJ/bQS2V6kqY33dLHnonv1SYvvWfYEHGQBkvr8yacK?=
 =?us-ascii?Q?yazoI6siNT5eio7ZViA6WlreL4ANCD63wkEtk5Mh7cLOAV4+Va7CffvGJsCV?=
 =?us-ascii?Q?JH1ZG8RW9ZlpbLyPvPgb38SW+ghzaLZfeEPj0nZNIZ7XS/mGcGUIxOgp047i?=
 =?us-ascii?Q?7f4nNDOD5l3DrLwojpQ64NU9HvbtjM3H6b89RfWGttw/OiHWdstg2k4WguLW?=
 =?us-ascii?Q?FYPpF+t/pxX2Zpyx80z9pq5/orm9NOSpnkWBXEzsJyu8Nrrwzb6oTDsJ0/wa?=
 =?us-ascii?Q?f4qZA8a63Z7KowgoeK9TgEuwxF42cMka8eLmKsKT/YCi5GGroUxW5y1T59Qh?=
 =?us-ascii?Q?S0ffWUss273gvthJCI5u4tYc4gdZKnAEdwDXwi9POtfkjJnrtFw5osd9JGq0?=
 =?us-ascii?Q?BO7HnW5PC4Nnd+aoA8KgoyNLGAaEEmIzzQh89Hpo8v6eJJELhGcCByZTR1bF?=
 =?us-ascii?Q?g4fgA9+z1yZJEh77TCsxq3VXCavE+g2uJtV6JAUj1wPfl5bTkunA/pYzSnEn?=
 =?us-ascii?Q?uwoiQL80m/tgok+SGF62eXNJ68mFqrmbgeOKKXTthU+Mhd7t5OACBZPFQ4mj?=
 =?us-ascii?Q?gW6x9oSYh5Ak5lVtHy5hdjDpNAcQ7KQhq2s8AfUAVsGF5JkZIgBm5Ri7k7ep?=
 =?us-ascii?Q?9TAVW/+QmK8P5k6XqwPZo+TKRHoZO/+k8CgXxg95Q/DAdI5j5W1Kg2qil7B5?=
 =?us-ascii?Q?dXsOh7cTwRXn5ATeikXy5E5Aen5snIP0wf9pf8YetM+XOQ3Hk8xsUxiIHaz+?=
 =?us-ascii?Q?qRtjzej6zT9v0T0ttyRay0diuqroUqCSVpKKDH5u4Qj/M/eSIiAhmlYtdSHM?=
 =?us-ascii?Q?uzpZcdSVCWsiGOWqh64iXdoPYK5PM8BMsG+DcVxVwZnGyZPrOQ9ILWQpdaiz?=
 =?us-ascii?Q?oJc78hpqrymtpzavXN6n3cUv46GcLYlPfqQXH03V7t5qHMciNaYLJH/w+cZx?=
 =?us-ascii?Q?3Hnow9XlD27WYIe8Pr7vMeS+ZVVW8s80SsBfHzlkJv+cK7Op59qu26f+fOe2?=
 =?us-ascii?Q?0bGmwhVdcQ4WPLxIqs9s5CK+CEo0fSJ3D9Nr6rnqIfpAIiSLF2NgWOqHijPb?=
 =?us-ascii?Q?Y05Vjh4zdMDx8v6Hf+mfqjIg/hKe8DXHbGb47dV8EbIiCnSmeGoO6yj80Scy?=
 =?us-ascii?Q?hnI6etRWcE1+74UJH5A+oy3f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a470cdff-7c85-4005-0938-08d950c688e4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:48.1681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bl98HnlV5XcEvJuQFaPeBWxjTF4zwOSApS/hZXPjGUBoNwmZ9TN0u8CZkO/uQMqWHWonncPsFlrMumFXTzM60Mes4fIC3bdTdxXcSvVBu9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: Bh0TelF-Dx7E3Q-VMMBqQ0aW1Kq4diq6
X-Proofpoint-ORIG-GUID: Bh0TelF-Dx7E3Q-VMMBqQ0aW1Kq4diq6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c      |  6 +--
 libxfs/xfs_attr.c        | 96 +++---------------------------------------------
 libxfs/xfs_attr.h        | 10 ++---
 libxfs/xfs_attr_remote.c |  1 -
 4 files changed, 10 insertions(+), 103 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index f144ed6..41cf921 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -124,7 +124,6 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
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
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -224,8 +223,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, &dac->leaf_bp,
-					     attr->xattri_op_flags);
+	error = xfs_trans_attr_finish_update(dac, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 260ae8f..36ef8e7 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -241,67 +241,13 @@ xfs_attr_is_shortform(
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
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	int				error = 0;
 
 	/*
@@ -334,7 +280,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -347,10 +292,10 @@ xfs_attr_sf_addname(
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
 	int				forkoff, error = 0;
@@ -367,7 +312,7 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac, leaf_bp);
+			return xfs_attr_sf_addname(dac);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -393,7 +338,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -682,32 +626,6 @@ xfs_has_attr(
 }
 
 /*
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
-/*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
  */
@@ -1269,7 +1187,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1284,7 +1201,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1535,7 +1451,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		}
 
@@ -1562,7 +1477,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 72b0ea5..c0c92bd3 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -457,9 +457,8 @@ enum xfs_delattr_state {
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
@@ -517,11 +516,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
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
index b781e44..42943b3 100644
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
2.7.4

