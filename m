Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB258C07E95
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E05C61CD4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhGGWYL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22536 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229987AbhGGWYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:10 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MCVHw018224
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=i7Gz12boQuXm7tveaglDaXBNtQU9iduvp16ELuABak8=;
 b=TjgJfXi2/etBhKaBAzoZ3Hgl0b0J2d9C9GE7Shw2h+XHM6HgOms8HJsfcWdUWPYFTN8R
 INou4nZuSQmkqlKatS/c+0JymxW0FI+TJ4KjGVyXk7qNt25rneUMZN5se0kIqhaXoCiR
 qHBU7rgByjb1iSlVpwC4KxXeSWi6jYrekTWOwmlN3cKTFVJTrfOILmLbdVpbHTYPR49H
 O1yJna6k51nVk+7vicCclBXDOm79BlM+q+BJDENGHosas4F9ot0xEJN3v5s5pYL3EN3c
 ZhiVXF6sivT+wmFVcm6xQxVcr0pfU+uVjujdeSwJh1grHRgB3rO5pQ/M87X0s7K4eIvI FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39n4yd1wb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSi092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8bKdxJN8+/RpNXzpx7eXJ4ClFnYhUGdJI7lzbqIaYADbyA5ItSQJTYnOVBbeq3dzl5ZByjf2wYute3+bUgdmdz40wSz4nAnODomPukT3HeBD082Pa88jKMH5W8+V+91MtKJk7gKrLsW6CmxzkW+s/qmHugNux1ay0FSUEQTLyD8mt67kY66Rsh0aP7AqrmZLDYK9mqtsccrNh1wcO0ysIIMqSk77EvKI+blOuuUWmpHXci9aOlYyDpuh3sK8z5KHPhOAoNCjQeaAzbwLeadlx4XMB9ZOdpj9pYVBTJWnwNiRD5x2GwOEqexqW0dp8EKAb92IjTEBnMcok2dYno74Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7Gz12boQuXm7tveaglDaXBNtQU9iduvp16ELuABak8=;
 b=Dswgp6J7n6jlZImNeHPZXrx1sQ3t7NeM7elQFJHi66fFXPlG2QnZLnl2KQSLJByaYGa/2ErxyM6jJfecPpt2bouf0tt+ZSetnZ1Ve4ehDNURDPSHIAK8PQGda+sSiSb7oPpcj+AVd/V1z1nLEL/wr/kno8rZ9Mt+z+WkBrOEV4ST4QA+wqZx76EVPSoqI5Rjd/TrupbznifsniVFH6d8lB27GcuI6LQFVrBQzPcTh4zcE47QuZ+wPSrzRb7tbId27YTJ0oAoFtE2Viq1AaCS9aIPf5EyhOKMvXJImmeRnC/Vv/w9DelYT1CZXVnerDCxo1KjvWqaFBL2yyimtXdGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7Gz12boQuXm7tveaglDaXBNtQU9iduvp16ELuABak8=;
 b=oJ2lIIimt9IfhQZDL2IOYaYkY4Zm9fFbmF0pBDpxLM68ax1gTV9KP9PWGKqMU7Z07sjZx+vGTtPTSiNbOCdE68ULWpdVsmETApu78y+bAKXaxhQwhBNTlcC6xKHDzmhlOP/BDPplXuKpPhioJakD2/p90vXF8rlc09Nlb14bgSY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 08/13] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Wed,  7 Jul 2021 15:21:06 -0700
Message-Id: <20210707222111.16339-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 113f96a4-7aa0-4704-bf7a-08d941958f35
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2760E751FAAB6EF42AD79FF9951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KlS+u/7Pylo8umsiVen6fYlEppIyxHlNinlMTYp3Q3bsUNygCvivUB6oEg39YYrtBCn35eJ6Z1CSDb8sGk9W44PkXaOTQ0ZhG3krVeG0+G4U1g1jhdbdLau17+2VZRBAR8DkRzZNgsY48ppefAVS1KDFpeSfeS5O1iHtpBRqJ4q3IxQEynPjVOgq8PktxsUsdEnypKHhLo+1hPyB63CODF1fcSEbXSRDWKCvlpMtXoQHLOFC+mHunSyGv3Ss6glg6fafEJ2ff5Q0QzLjLx0WvzKYITr7bCXu6jr5KzlnlaN0DIL06jwC5GSo2wc1WVVLNnouLx9qpHk7a0W6AZRm5D8Lyd4fQb2+uA3midVAlk5XASgt08xOzoMGvmuEBFuueu/eK8Bju9zIpDJdXfmDAQReLGBLx7Eh6wo5BoAhNN+PlyXaMeBPWYdTin/IpZI9CLca8/BYPu9Gwc2gupUZ8u5Zz+VWy5nhnsEHqWZjDZYZsN0ob+q2VKZGJjmOzrbYLW0WdvG5y/NBYsd0cK+UNxeFEJG2ZDuBNu8vjEeuQZx7mzjwhfr/kDSpaOLRURp7+0UcmMDgDSypjhUPws+cJpNML8axk/xk0fKPLxYeduAR93MfSoW+4RSK4i3KgReL1l+JqMAxq9MVd0tjeP1wkDQdSq0UvOJ9WH+90uk/Tta2SBGEM7BCNF91bgRsPo18XLLQvMqri+P6g37stTBpjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PVk9hTTgBTbf0zrd5xH0FE1EKSM2cucxu0ac48ykBcvgqyAl8fJqvO85EOgA?=
 =?us-ascii?Q?WQkTcl5Kkm/hZCQIgmz+fnctbUyXVcFYHTe5pQQU/wwQc9o4o4q1gHYw7ywW?=
 =?us-ascii?Q?L2g31RV8PzrO8HW056Ra5UgaA4HV/RNSOMLweeVSmbh/JrLlN7S11rEKD1te?=
 =?us-ascii?Q?7nMtuU/NsQ6xoXjl4IhVeofkHwL3c5/wsAy3s0EJth88AvtD+RJwu5MK8u3v?=
 =?us-ascii?Q?r7wDeoI9pVcj1VM2ECi4j1Ljcfw7ZAlI+E5DVEo/akRzhgqJXixEjb61FKWW?=
 =?us-ascii?Q?aet39QBOCN34rDFeaSGTmsjkmbrY7DqgwtcpFix3OyIFkjCn/HLNHJEvi8nq?=
 =?us-ascii?Q?2+a0++KgC3YZvH8YzsBe+BQg0HQe7HEXU/7BXTtMZa3i8rtkLYqambR9JFo0?=
 =?us-ascii?Q?OFk+3smMeccpQHQKFAMGEdVOnG08TdEqvrcvwZn1tZjDaCfNj42TrP4gPBvY?=
 =?us-ascii?Q?Dj7vuoYxnbWpNFTpkle7YyX8vkdEzPZJBHR9M78v9oydqZMOkhY52kTTqRVp?=
 =?us-ascii?Q?8a+TK/IN7OZWTk77q1dBiZMCoyiQ+G4mm933TjVjvEEW6WgocJa3lND8XZ6W?=
 =?us-ascii?Q?LfKbXifVabeM73Lmy9mB04i47I//1bokB2yGITHokSFvGc8KRK7LJuvROz/C?=
 =?us-ascii?Q?0A/POKUinwtE4v+DLpFmE13RYGwUfhZ/nn7N84iMQ8eOed/fHxWB6wAf6O8S?=
 =?us-ascii?Q?5PaVbRoL3yjZ06myB7MIi4EkKIeLu4Gt8wzU2PKcm+bfncAhoP3p/efgAHSV?=
 =?us-ascii?Q?8FW/g7RWwcblvnXG/YkHJygjOsG+wYMLDEGUdXHxX3BDbJrgjqvPeUrQWyCv?=
 =?us-ascii?Q?qA2UDv7YOKi9O1PC7bd/C8SpWoS3zQhVwKesYrLIiHk34yCwNYTQAjRd47gb?=
 =?us-ascii?Q?xNTr42/1ss0tcqmvA8VkTLgqWnhT1VY2m4GhQv1o/1KAJGBHrA0WZXldCzFo?=
 =?us-ascii?Q?9msLJpRl6dyEmciIzLu3SNtUvuRddNRhSUPiH6r/M1QxtdcBcrsfFMm5jxu9?=
 =?us-ascii?Q?AU9ulkDhVX3QbV6dJtMaIf7GOaOI5ViaF0UX4552BW1l78cvM2m5gSxC3RhZ?=
 =?us-ascii?Q?mG+5S0OMzm8lRmCs59YEvfAqPWtS9aA86djIlbiu/rzAy7TT+JwTsmpkhtpK?=
 =?us-ascii?Q?lOr2sW8vkdZvK7qzlxVHeHkB254Vi3Sv9rdvjp6bbjXFhRR+I/R8+2eR94NU?=
 =?us-ascii?Q?cd0BZbF+IgRu61KfF+bi+gI1TtxHGoVKv0S7VWWxr5dt6sMpJacuegbddKCM?=
 =?us-ascii?Q?/54fF+mFKEjy9wGhLRZQwTbg82+ND9QG9/0FCB/YkOTh7hKJer6LjOW7p75c?=
 =?us-ascii?Q?ofQvGpoC4Wd99AVX4pJxfa8e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 113f96a4-7aa0-4704-bf7a-08d941958f35
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:26.0074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUoiw4c3gcVwXr0m9WTk9GNmORSW3gY0YSbr17MubXwA45I49p1+QjdhesI3UySIYQR0/baSF4NsSwfFT/5R1SJ70QVgnaat5jIpWrenBxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-GUID: sQeNoZH0GrBeE9DKVvaPOipuamluNOxY
X-Proofpoint-ORIG-GUID: sQeNoZH0GrBeE9DKVvaPOipuamluNOxY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

These routines set up and queue a new deferred attribute operation.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 034d08b..becf9c0 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,6 +25,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
 
 /*
  * xfs_attr.c
@@ -803,9 +804,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -814,7 +816,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -844,6 +846,58 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 4ee5165..d638d12 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -527,5 +527,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

