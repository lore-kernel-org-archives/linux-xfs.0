Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA454C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D26E861A8D
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhKQEQz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:55 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14436 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232453AbhKQEQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:53 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH3CImO027666
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=55SiZo+Yck2WaHEQ9E43/KKORSy2FgCUXVYYoi2lsWY=;
 b=Wqfl6YEG6B+jexRKDrwC0xhucOqhoTf8aIeX+ZmiCCwNiapFvzfsVFA92Tu62vklfCTu
 64mCdh+pWc3dGiBa6PMOeLYSqRMWGnUwQH04ESczzbg0OH9XCXnHrWso2MZ23D9zPuH/
 oZ/TizCf4ABB64/cknahRGvp7R6wLcyenpAfzb+rF6wLRVMp/hhplhB7BZ8NO3Y+PdoY
 asGHzY9PfXHIbmiYdNBqk73ADb3E6XZz0xSOS2UzpnLKa7xWFqmQKYkECgcVAYvoa4v3
 oD5ULFlHd5K4ICUEGCmiseyPhMMcZwnbnPgzdUESUF5K+pDdY72VKow2qowManBkCf6p kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhtvvpc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEJX180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3ca2fx68vt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nE6+qpswWzoUOUxNxAt6CqwiVs4qba5kbX7KVotr7Xcnibk+jecNRx0FF8/xuVaOFmnl0iTI+wkNnLSTRe+jGK4ewe3U75iahvttgSYYcEjRnQjHJ2mnuRSfmBUkftoBeWhEdsBDuAQiXfNDbaEIuHGZaSLLsGaNnJfDnLWUuAY0/eEFjOPldXdgA1DNkeHbZIxgpBzFrs4bn4LUQcbM4gg8E0HDNE9XY/24q9ObMNnh90j5qCGfeXEIj+mRVrmTHcMqDhlVBYGY23SGUZxyfOUiJ7Cryk380/IqZ0Z8eV7XRn7XHcXcyoKNLR+Pxfy890BTJ9KzfS2uMrjv4n+JjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=55SiZo+Yck2WaHEQ9E43/KKORSy2FgCUXVYYoi2lsWY=;
 b=Rx7TA85nwfjJrWaXgrSkRETYd2jxFoRvCna1N1WA/yhSuuanB4s4mqa+ThUa84Llig8M7gdAxiDLAvh3phnU8qcf6jXSpEjWFk2FeTch/+kSYv8N1FnwnPXvvv+2wsPN/iVrpZUo3VU7gwKw1xoBMBqWDrqk55kTH/VGzrnjcHkyx9Z18eGy16+wlvNPGomfjorixBXxR4/8jNf7EhqaGmei2Vao2j57Wkge+4KnBr6nRYYgM3x7kKsonIO76KOZYxPHBdgWfbcwAWFkh+mAFIr5W8DoUR15uV0LFhroS3Dr0BFccJF7eosESOIjhGOdCWV7HiCtWBwTT4UIhgLW/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55SiZo+Yck2WaHEQ9E43/KKORSy2FgCUXVYYoi2lsWY=;
 b=bcvjY9a06nNDFTK0ehzG/tVaQ5G2lA2baBo5i1fMU5ChNthM2JoJUorYtHqOqrzGzn456o3If27icXmoKeFUpUZy5AMNw5XYvw/mS8m8PU1ZNtrZ2VU/Vd8PWWW0GmHmR6oTubYdnRCf7R5mfIHH493xalIk2aXNj0eNZxYY8Bo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:13:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:51 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 07/12] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Tue, 16 Nov 2021 21:13:38 -0700
Message-Id: <20211117041343.3050202-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c124f31d-f2e5-49bb-115a-08d9a980a93d
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB392196804C3E9879E0444C1C959A9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:494;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/Pws+TvQIg7bWdHGHtm8YBNvfgxvY9cfJWL4eCyFVj70leNArz8tA+W6wF6LnuxntUTXGBdIFSqZj6UfkH1Hi1533yuOfNYNxO2ztXAKMHVAG4npFAZL+hPC7s8XRoMzy/lbEAPI1gB+nDZpHrvmUMK1mZMaNLQsnEnfi2d944RLrLFzrfnjdPgLNudcgXNB0mPc/k+xkhCCGU6V9VvQxbDNv6Ii9dZViALWSK57C+WSbegGvd/v8bro8NAHaJmWQq2uH9AXER14bVfWZehej99OhISvTpHeTXKe8s6GHuAXz6a83xCebckXFZ2jyGNXcz4Tvwh5OMALdzQE0I02KKu/Pljb6shmA2/lJ+xglqfuqRnQWhCY9orWXUg1/63dKqjCy5ltNbNB2jwfMiPWoy16g4gIdwPCbaOHkTyQp9jKBMqLrJ2h46M9ibzesX3fov8KKurTGgzZGOCPPL04qZE7SNtRU6WvdUKe2vKbiqcjHRImarIMqDQcuwsW6OYSqot2IhEgCzqx2aX8rXw/trEmFX300izaFA4SremEvEnQmNEkiXcAiF/hRP6xn/Bea5jEYLHsTdJtjzZkkMo2+6AtNWWOl7e2P72icA3gtpjNKO2GHA8s1556dW8khYMxVEL7hRBcNmPt8tFr8kJE7C5Bt3rxq4tm3cxZ/UB1Uugptk7D2SbS0Q1PvqI+ymVkCr1KUFkpsf/wniNsFtwDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38350700002)(6506007)(2616005)(86362001)(6512007)(5660300002)(8676002)(2906002)(36756003)(83380400001)(508600001)(52116002)(186003)(66946007)(38100700002)(6486002)(316002)(6666004)(44832011)(66556008)(1076003)(66476007)(6916009)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?POj+FZuL8E0eYSG87SWIMr9r2NmlPpfVDucyx2yX1mMALO/8LyKxalMQ51I6?=
 =?us-ascii?Q?wLk19dYKkF4w1aLOquX4O9LELWCQug8+lpw4SV1TzbAPTGOKMmw32nbiZopN?=
 =?us-ascii?Q?mquCoEXFzFB7RwA/2uf3oDGk7Uw+2xR06va196DyWzhwM9M0MhKbfmKBC2rJ?=
 =?us-ascii?Q?hNO997FMFN/12c6LnG6kA6AkKEkB1NviQNxfy22o9TJozc6F1V9ybb6RBOzg?=
 =?us-ascii?Q?kCwXguAwP77oxwX87bvhb469wPLJZFch2QV2vUV9a6j4iBl5UbzasC6sDX9B?=
 =?us-ascii?Q?ECLJvj3lPoCflQD6DkThwbs3IInT7j6z5FaMssBInBuW8HFiVOk40HcJ2zKC?=
 =?us-ascii?Q?8UWAMHFY4omblDAVjjWwrhfKK567ozVIgjKI8kiCuKvVbDofSHuA0ctsNJbe?=
 =?us-ascii?Q?Y2IMdUjvxk2iUZC1sFLd4ALxb83vbPr9Lu3YnwsyHRmLqZqIgsAiEVi9rNcN?=
 =?us-ascii?Q?2X2Z1m6Gn01n6uYSW/OIXMAoXn1i13moE6w68bZYkL03Nxkn6LTzJJKpLD6E?=
 =?us-ascii?Q?5CKAJA9r/eZZh1ayjdKh6POf4ixLkOWZtFGCzIFwIPH7/WOUXWRPBLrxiH0m?=
 =?us-ascii?Q?ywdLqYHAlWkQRUojzkCUrfSvMo2n1BGBXtUi/Nk82kN9sNRY4N43NXbZ/N9A?=
 =?us-ascii?Q?JjOerXCM6jVsqZerfhlHS1YeSnEy6ESZDFOTGsyLpxBnp8P5JmBXCYFfDXcP?=
 =?us-ascii?Q?2qiwJRMr/XZ6MfUzoc9Qrj1iGGh0kwKBOoI0cE2x+UBllY8F7RiUjZhVc3gF?=
 =?us-ascii?Q?03eAlZvxPgLYKBFVktVEuy9P/DQkskPrqRizvdkYzdBOYV9GY6Z9LBk9sNHQ?=
 =?us-ascii?Q?RAWMRATRgtV4NmK/Q/VvCezrfDUWcHRKs3aYt2pBz3ydPqdhplYtQp0ZDi+A?=
 =?us-ascii?Q?/Kuyo9tCzkp61XJCNuNYgR7YzNbtKzudMHl5QFmOGAE4O/xUdikOEduXgQ4U?=
 =?us-ascii?Q?f/CksbRKBcGEOEVU6VO4z3c4KhQBLHSWb2jcYotLYHwTQzFuesFnDDkJ+gcY?=
 =?us-ascii?Q?DzejU46KtC1vDpofe01GsM6cuFjfTvp44QoyMR48rH1W+UD3jzhmdrKNvXF+?=
 =?us-ascii?Q?w2AVfYaVtUOar1tk20HZCsnzCXJ7kIH7vLOxg744mtiZb7FkLLR33O5KedV3?=
 =?us-ascii?Q?/VFbkeRl84j9xGeJrgmCRhRw7nIyHAiiZKFQtxNhlt3Xty2AoeoH4M2jVVRS?=
 =?us-ascii?Q?wS2Fw2gOiUSeXYCrviRnKQC6J7ojJO5C5HyOZflHS21efJX6GrQ6NLir1ibk?=
 =?us-ascii?Q?I6RzReRO6kcFW7/tp8SXzIqzv43HM0rU8ttWVsbQXoRifev1KWlk+bcTiSmK?=
 =?us-ascii?Q?D/897UisHyY+dmHMlSz7ZUTKd9ymg3+VULM92E/3rGBBzfdKktvzlTT1S/kF?=
 =?us-ascii?Q?uz7D3zUE44VSa+KQe20DSU6i25YaDY2xtc1AsJ0CcCBRzeGRIu7U9W2/EtnM?=
 =?us-ascii?Q?wiZfYBG/S3UswhgcXJMPptkGvWz9lkyKo8WB5o/nd8p7zNdhm4AuxK3qUwto?=
 =?us-ascii?Q?0U+l4ks5ML5rW+2qtgZb+JqOYiWnDK28+n51A8/oritnEdSb0DS+oWX5+7ps?=
 =?us-ascii?Q?LctQZwpUxu3qOyEX7dkcX6XekG6uwDP9ZeRT6OUyxcaNDKwV9MJiksEPcV/w?=
 =?us-ascii?Q?5Nhd7sF8YsWz1dk9iH1NyX1htPif1WwKNIWTDHN4QQvuQE7YzcnObDOMO/8I?=
 =?us-ascii?Q?Aix8VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c124f31d-f2e5-49bb-115a-08d9a980a93d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:51.1050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 406aivzQ+wD6ps8W4m+WfJtoleWoX6eFr1bFcPabXEj9TRPzdtyYImiHqOqOABSdf3lJCOyMwpT6znKE3KToa3jB4AzUdJXK/4b3IpO9yf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: FQbADWm3GlKMpO6vKSDrh7fBRr-GkKCa
X-Proofpoint-ORIG-GUID: FQbADWm3GlKMpO6vKSDrh7fBRr-GkKCa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

These routines set up and queue a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 fs/xfs/xfs_log.c         | 41 +++++++++++++++++++++++
 fs/xfs/xfs_log.h         |  1 +
 4 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2ae5b3176253..2bdd1517e417 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,6 +25,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
+#include "xfs_log.h"
 
 /*
  * xfs_attr.c
@@ -726,6 +728,7 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
+	int			delayed = xfs_has_larp(mp);
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -782,13 +785,19 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
+	if (delayed) {
+		error = xfs_attr_use_log_assist(mp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		return error;
+		goto drop_incompat;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -806,9 +815,10 @@ xfs_attr_set(
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
@@ -816,7 +826,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -838,6 +848,9 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (delayed)
+		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
@@ -846,6 +859,58 @@ xfs_attr_set(
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
index b8897f0dd810..8eb1da085a13 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -525,5 +525,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8ba8563114b9..fdfafc7df1dc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3993,3 +3993,44 @@ xlog_drop_incompat_feat(
 {
 	up_read(&log->l_incompat_users);
 }
+
+/*
+ * Get permission to use log-assisted atomic exchange of file extents.
+ *
+ * Callers must not be running any transactions or hold any inode locks, and
+ * they must release the permission by calling xlog_drop_incompat_feat
+ * when they're done.
+ */
+int
+xfs_attr_use_log_assist(
+	struct xfs_mount	*mp)
+{
+	int			error = 0;
+
+	/*
+	 * Protect ourselves from an idle log clearing the logged xattrs log
+	 * incompat feature bit.
+	 */
+	xlog_use_incompat_feat(mp->m_log);
+
+	/*
+	 * If log-assisted xattrs are already enabled, the caller can use the
+	 * log assisted swap functions with the log-incompat reference we got.
+	 */
+	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return 0;
+
+	/* Enable log-assisted xattrs. */
+	error = xfs_add_incompat_log_feature(mp,
+			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+	if (error)
+		goto drop_incompat;
+
+	xfs_warn_once(mp,
+"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
+
+	return 0;
+drop_incompat:
+	xlog_drop_incompat_feat(mp->m_log);
+	return error;
+}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index fd945eb66c32..053dad8d11a9 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -155,5 +155,6 @@ bool	  xlog_force_shutdown(struct xlog *log, int shutdown_flags);
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
+int xfs_attr_use_log_assist(struct xfs_mount *mp);
 
 #endif	/* __XFS_LOG_H__ */
-- 
2.25.1

