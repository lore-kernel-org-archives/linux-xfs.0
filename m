Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20009C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F3964EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhBRSrC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36060 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbhBRQrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTgkj040328
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=WeZG1GapVtLMuRouhhk3mz7KKd+tcqo0EBoi9+gUa4s=;
 b=ACLqjQXK0X6JaYKH3ATK4ti7/1FijQ42PYzNUeUmAX0ZZcLt1TKEmnjF+kz6038vXjjH
 174rtBkhhSqzN7omnIe2cwgKjKTwZWvOul60WhutQPqKI6RzDXCZnX7AlwGfhJ4nN2qb
 gQJmF5eu+zEqo42rOF39vN1oZ3xf0a/22EdAoh059p9lxfpotgrOJ8LoGQsl0jGRLeRh
 gyCdMTVD17peJU2LxSZCVLegdSol8stjt0x/cZlR4HKIq1TrY2BYm3ggXCGexGY1sNKc
 onYQ6Rk+5jgqIeFtIqQGcG1KolqGMUjY1t36RjryWPaTivJZGGI4dGYa2T09IWWzH1F5 dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUJtG067880
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 36prp1rkmw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNCFsPqlUaxd1RtOWqWdyZlSBz4BK5ZnsKKxERVTpfsrmKnPdjkakltWmSO2IpAVrwlpq/pJKUeiUVEDt7REHyejOy/JpLQWzhqBSEON2AEP/YoEQpUU2g/ZW5yCl3OY00BfojpJJdB/heGqexz6tzAmHm3kgqncusZ/Fl6ZnaicBU3g6+QBUvulsNo1EcyG/2oHYM4tymYB3zpYAOT8l1xT3W90e1LyBwIlt/gSZhImj7rmJww/hQX1w61EnnWMIM9M00Oj4NiSL1+Ib/sYDqJyjoKb9Z6DLz59lVLNgWKye+g9Ol3FeDr57DWfey08I1CAg8wdKrZslkqZ4eEbNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeZG1GapVtLMuRouhhk3mz7KKd+tcqo0EBoi9+gUa4s=;
 b=V/vDkwooeAwjDjqqJdzG7Zhyp+72Tro3O+/9gIRJFCG61gtj4oopmi9xsr9jdLvFHlRBgXFuo6JUC5GA4OHvYUoCzOzCNpDzDu3gHS9NufUKbzArMMgQEaJaupjBK3xTpOYmM2ezPqNhs6FezoGTG2vgQ11hG7O9ScYJcOEoxghQnSuAST7BjwNnu/UUi+2CPvGLolYeeJ8ig0eTK4JeZm89JcLZ3cMMSFq2ePGTazEb9FSDvPKu3JWJWNHr+2KO46YRrwpxICdtSkrMWsKw23WgMFsiT+rSu0zKNsdsvHgTe4L65AXlSWFAt15oXDeFVlnmn4FwZ3sxfduTq1xgDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeZG1GapVtLMuRouhhk3mz7KKd+tcqo0EBoi9+gUa4s=;
 b=gqPjkImSXFfmZ/Tqi3nlMn+ulx+fFQD7UzRGjxKDwsPaZWEhmFGil6ExBawIHbIFMkQWkkBlogl11UIyD1qVb1um45l6JiK75R1W2BC+AqP8bdWR98r5C8ySV9OB1U+jNcySXG76CTQ5fsDj+el6VTL5eyYT+xzPVU2paJKlRuw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:46:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:46:15 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 31/37] xfsprogs: Rename __xfs_attr_rmtval_remove
Date:   Thu, 18 Feb 2021 09:45:06 -0700
Message-Id: <20210218164512.4659-32-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81e32cab-ba8d-4143-fb6d-08d8d42ca320
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB296528F109FB840E27A366FB95859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WYJ1nqxMHoVC0tY5dzr56qB4WLdoKC7EE1g2+WxXWo/3ObgnnBl2bdkSDFiapOjJXwXRhftigsYHnlrsjVbxCUYbZpyWpFiwIkV7WA50XWA4c8t0Vb6OnEOJtonvHQ/YnKDtJhw4cqLC5QgESe4DXbn8STspGMXNKpPOxrUYRg29BactuZLEmm94BTRLNjDsbfvVTH7mWh8B9ozf+C3+ixR3UWeYt/kYp0Gh1AGOjGjOK+TEVcZKltWlcJzN0BGtwTAjAHyH62SBrfGbHi++CJbJO5mkTiuqPHHJ1ZMgR/knp3rcL1iz7BhQOMIOVnwp8hPa2u6GisJyBJlkSQo6r1UwU7gpxQgao8R8BQPepGIUAxaxTmjfD58m+3delz/Dr9b8lO7lWdvDZ5qHnM7wFH8PaWHDEkzgxQoQl7uhbbZ9eNLtmnqIGidLHxkGmD+Ak3qlCAy944dtOC7AOiivqH6ob4eHF7RH12fg9wJHzGmnKvjpz0Rgznn2zfls1ibQVBlCOCRywT8LOqgFfBiloIiwEQsdRPnOhDSDnyzHE7nBUAT3hJkSUvYVQEBKNT7nFZKdAVWtdyEJlrn7G8ERSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(69590400012)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UsQDsXswvnA9Bou6b2TqE4d1DC3EJyNU6MTw9gjaSCu6oH38YTixL89nRfGy?=
 =?us-ascii?Q?cBL2X3ebFv5kjlKAUyXO/4uZnbwWUYeGHYRQZvcPgUzJLngE1E9HkPjiK+OG?=
 =?us-ascii?Q?BZcDW9LtkR/0todVxXUVfkX3NBcfGKeiYPZeE/OXe8FxRp7Ms3p2K1dfifjv?=
 =?us-ascii?Q?cB23yVama30LI4EvkSZz0oroPljE0W0kAypq+47j5hQGMhPMLfkR4doDbMRz?=
 =?us-ascii?Q?pngzLNlN8kTYnx83n6s91/UVOv9Ij7col14Cxc52BGtjO4Fy1GwZM233OZ4Z?=
 =?us-ascii?Q?3sRZAJDAIsDxfKhrrw3Y9FTTVgkSe9vz9bTwD1zv4s/w6Kyc2ixuGwQvDbXc?=
 =?us-ascii?Q?/zHuem/j0B4t/B/73QmloOeJDn9iU1MS8r6uLbjZQ6XwSvC69r0bERP4bBj1?=
 =?us-ascii?Q?Ka1dvjRF1a/NB4ef5R+dHHr+D4D6vJVbPBVSYpDDsUPnQoMJLgIBInuyW71P?=
 =?us-ascii?Q?bnevYAroN99PwmYux6FKrzKW0pCaIdZ6Z+2v2GKUVRkhkDgaw4Knf2hujhTK?=
 =?us-ascii?Q?CgcxwPubUEYGB1tYuhZzv8l6skNp3tVz/TF5/rz4gx+pQqM2BU860QYawcLR?=
 =?us-ascii?Q?pM6j8vZyEdGM3UXCs8Ye4oXfkJsqV+kNn1u/ctPHEs43mX/5Wii6xXzZlt4B?=
 =?us-ascii?Q?NAypiI/HbFkZn/yELkKamrurSVqpYaXr+6AfqWcAHjgQGFp1uq4w5JiGV3dm?=
 =?us-ascii?Q?aOqu0qI3LiVvxjmAvSnZGDBUMrdgfhLsqwKUfgTdAZvXAJtVwJlwHImzcqVB?=
 =?us-ascii?Q?JOVM4q+cKKRdJ7k+tkZdLKrD2ikJClaEI4B0Udkoj9z7VTsCuTayjYukBH9I?=
 =?us-ascii?Q?AwPihQ/zu7ZScW5rZCSlB/Zx3XB7JaHv7KXNuCnYejhbmFNAsO8hDQfQ0L//?=
 =?us-ascii?Q?iBgGrdnF9Umny09HhWIQZcpBoTmXjsqgO6ReflIqtB9oRqDs+s2s5Xxg2tzx?=
 =?us-ascii?Q?ir8lTd1mVRtRoqUEqSGu5VfFiejvRk3ymORXOXLV6p5c9YNflsgSHvTp4ErD?=
 =?us-ascii?Q?/YDTPdlVc1exPNXwZ0YGSWL249SVL/icfU1Ohvyro6/fmDGhJ/pahQRH2kXv?=
 =?us-ascii?Q?7deT79LW2IYx268u+CJJT4piOR0Yux0bT09sXZqSNFy3/x4EprAcrTiSQ1+e?=
 =?us-ascii?Q?biEWw5Z9GKosVds3aGbtJAa/fW+pTKMeVkEIVODOEdnTbD+edGvAOyVAf3uv?=
 =?us-ascii?Q?I5iUg+P1hPNmTmmEEsoVUYzKM9VezbUha5qxgK6VA86BaEJmBIuP6h5+kRPC?=
 =?us-ascii?Q?mOZBY43bwkkm61e1EdHLr/wYukmBwFn58rGNc3JW4DP3CxZ3sFcEikldQ9+8?=
 =?us-ascii?Q?eguljLlHaEFEt9MvCP0z9Ucx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e32cab-ba8d-4143-fb6d-08d8d42ca320
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:45.4776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qY/NJbx+nI/0+GJ1djmsI2Qaadix/TLzOsEAiFGo+MglnXQoFM5T6H7pJ3c39jMaLmiubFmgUrzwR7AwrlYTlwmt95wFOwr+1IjmtxnpP4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c        | 6 +++---
 libxfs/xfs_attr_remote.c | 2 +-
 libxfs/xfs_attr_remote.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4aad38d..b960340 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -496,7 +496,7 @@ xfs_attr_set_iter(
 		/* fallthrough */
 	case XFS_DAS_RM_LBLK:
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -615,7 +615,7 @@ xfs_attr_set_iter(
 		/* fallthrough */
 	case XFS_DAS_RM_NBLK:
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -1427,7 +1427,7 @@ xfs_attr_node_remove_rmt (
 	/*
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
-	error = __xfs_attr_rmtval_remove(dac);
+	error = xfs_attr_rmtval_remove(dac);
 	if (error == -EAGAIN)
 		trace_xfs_attr_node_remove_rmt_return(dac->dela_state,
 						      dac->da_args->dp);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index a1c9864e..b56de36 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -736,7 +736,7 @@ xfs_attr_rmtval_invalidate(
  * transaction and re-call the function
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 8ad68d5..6ae91af 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -13,7 +13,7 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-- 
2.7.4

