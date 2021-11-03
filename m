Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9CEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Nov 2021 21:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D687061073
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Nov 2021 21:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhKCVf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 17:35:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61894 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229893AbhKCVf4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Nov 2021 17:35:56 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A3KmW0D016608
        for <linux-xfs@vger.kernel.org>; Wed, 3 Nov 2021 21:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=v6Q2wYHUsJAtC8P4LflDUfO5rDY4uQMtIUTEuDAUiXY=;
 b=qS0cGSPPhh/0K8fC+8gEnNfpnVg+p2K+KMycGw3kPtsLY7SkmQAG09LNslqalmr0Ay/Z
 m17kaA82w5pmmurVR7JcSu8m82E4GFnyhnymDx27dBRycHJiwbZHEIMDtUmQc4KGKckn
 qRhLEOJ+2WcMEsJiAqCvrKW6XPk2JELCEqP6YyGqvXmEYaDlZGZbq9BiiTqa56JxBOU1
 LKb68r5175JSkcVv9RV66/HarI9Ohwc0EOwyhnTXh7/iN8y7G6zdAvmLD8kiklRsoO4A
 bWCUrvh0+4GPMwUV8mEOc2jNgzNvf7++zULJBEaEPl3Y+NlWexr0Amu4k2wcDJdCUZBQ KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxh55uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 03 Nov 2021 21:33:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A3LFvl5023699
        for <linux-xfs@vger.kernel.org>; Wed, 3 Nov 2021 21:33:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3020.oracle.com with ESMTP id 3c0wv6x93m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 03 Nov 2021 21:33:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+nWVIH+qKxsaYSJY6xwfsqCtAY1XsDNTZC1JccC49i8QGO4tPfY7AFn/NK9y2x3trZqxitfPQH4CFDjSMRgPdA/7KdSMP4+nLRyA1dRjgTDzDOD8oyd8abKcR6/QWvt2Oy51bGTtmwlFmhxdp2lHrrasIU7viNtNM/pdWYFC7aNBvyl+fWCm6OpmaxbjwHI3naeZu5fuSekKxvZbDa5culW5cu8MGbLcwl4SZ03wE0jNLy44K4+ppR1zcP5JpQNB30VXjg0xy/rdY75X8fki/slLa2LTftnQQNbUYtgBSeIpcOaY9LiEYV98tkEHo++HMYmFEQZsoNyL/iMsI4o3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6Q2wYHUsJAtC8P4LflDUfO5rDY4uQMtIUTEuDAUiXY=;
 b=R6+sX3N0duhc9QwZDV9Y+m+mxsLHjywGjgFtU42BgsSwVdHlfDcN2sZ3druSYK7IGmuFFz6DK73I2GtKWiWyVtdj4TN4v2N0wajFdNF5yiP88vwzbqcsq+HTzQnPEJNSEPTco9WxZgycxyCAlP1KxC0uKLxl5G7f4cGBayewA0yI4mAtZQ9cYQlzLBRAGnFEVWidVvUqPa/kYe+CuN9ffJMelAMOVqYHhCWpNkGNaPcSaAR0DT9aIFA8R5x3sOD1/ZXmRZ58J6qqHr6bRrAQrAbzm4a0kZZaATydrjAwT+TbTc/z/p07N5xrgiQ9gbAsDsIeuPoekBZLTbUCivSAnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6Q2wYHUsJAtC8P4LflDUfO5rDY4uQMtIUTEuDAUiXY=;
 b=nfc2n85Ll/9fxWCNrpcrwI/M/8jHVnREYGmg/FYtFX6EAY95Pc4RzDMbOALNfLS86soPLcFMbXW0p31bhd+inkGLfPSSJDILIYVM7B5ZtBAp5uWHFFheSVkOi40u0YhF1uee3Ab+OHSiNw6aAJQihsx1MptHGAjIGGkKfsuDqFU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3857.namprd10.prod.outlook.com (2603:10b6:a03:1b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 3 Nov
 2021 21:33:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4669.011; Wed, 3 Nov 2021
 21:33:16 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Fix double unlock in defer capture code
Date:   Wed,  3 Nov 2021 14:33:09 -0700
Message-Id: <20211103213309.824096-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by SJ0PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:33a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 3 Nov 2021 21:33:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66310e84-f4db-4921-ed2c-08d99f118bcd
X-MS-TrafficTypeDiagnostic: BY5PR10MB3857:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3857EDC04BE6198A6AB80028958C9@BY5PR10MB3857.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:393;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VIcrOwbWXa4rT17zL5TRRUsy7jLmJqV+ytzyHiOnwQTrNqs2+/pM9EAihapsnZJvJpTqLjsfD0ABi0zZCAiXJCYP5U0gDyeTRyU3+K5T5wE+iKSJkx2CS27pUvLVb+gV5//6N/5dwN07NXFnOShKLEu7gUBbJXKcua3Gh1KGCVU1qnpSVg7jIu0R/PXGJkPClZECHPiBTNWkiFxWS8506hqGIUlpdravxd2lFuln/njmymHj4sEhXyllgpbImhSusWV/KoKEaahDW+sD9p5dIFPHjRpcLjEUH4uhOtTDOElmVsAiu6DJddTM/96rCKyZgSBg+7iGdf+hn8qiSd0PqoiKHnp4xc1zz3ZZcs/hJKqabVaX8csFALqzauAv4CEGuZAWCjI4wuhfbSdgak3ivgN/0sY/g3d5LhZzmWQeiVThD/rIoITCpRi1+Bx3/ClYJRDFR5AmWGzmdCf5dSr7Db2gMV1gyKHd10HolTNPc/WxdcyqsTdVfG+1emf4lWR/zzFCj90kAxxaBqluEOkx1qm3MCMfoWKKl8zQ++yOyR6kxEawcf8TL3MvcmFeCFzJJdfk9tPBcbhUZDPgw13XGpw0ei79oit77czIy98fIK14fCeXBl3DFLb8xYe9PWve+zoQYeWaRTbTXuZmTCJhaXWoIT1OdkUzeddRxsS58viKNX4R+VCmpA8X5Q7OZ/tmPTETow5loBfkaDo/aMSI5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(6916009)(38350700002)(52116002)(38100700002)(2906002)(83380400001)(6512007)(44832011)(5660300002)(2616005)(956004)(508600001)(66556008)(66946007)(6486002)(8676002)(316002)(8936002)(26005)(86362001)(186003)(36756003)(6506007)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lqcosTsMrPa4+544vkN+73oKnBHU4IvhqhlmH1UMUAS98RuFmy8MW9EW5EU+?=
 =?us-ascii?Q?uNlUgY10UnB+0eB3yYnXZ5n0lLzytJew0YGYyx2k7Xz/XLMFSHxr3vs0nb+O?=
 =?us-ascii?Q?LYSIzDPb9B2JmZiJtjDqE9j789hF3HTts1Ym4ZLxlxD9z9sSgsYf9Xb0Kjl9?=
 =?us-ascii?Q?BIT9uxGGVeSDmCTkQQ2TmQGLpKJTuAHyJqDqAFAk0j6VQZADlV4TSVlU5wau?=
 =?us-ascii?Q?cpvLeTJ6LItkkV+lmvQUWvvuKBdwRgOi0xg74EWEVO/oPrjJTHRInC/Jq8WJ?=
 =?us-ascii?Q?Tm0bpSuFcA+vAsjQwFiBykjU/ymM7ZrQ1552UOq0hReS3SI5LQvwPekdWrak?=
 =?us-ascii?Q?YZasSxQetFbElyqKDOYC6n9m2bmqLUa3i5Qp5DDwItqsl0UsNaYhxAMIaiRX?=
 =?us-ascii?Q?EUIooe+q/VcbRkmKNhtDSwMOcveC81sTh+pOdrJkknzOgKAUQdWYjlQK5Ydk?=
 =?us-ascii?Q?dzJxcRkCHsTaxs9nbR3yvC84faigaFWrs/zv93XEfTEdIV9ha8kmKgLvqDT2?=
 =?us-ascii?Q?9ou5oakR2BWsdJzVQXGkOGgd1vIVuWQbNvLuf9AyncrhTJkPkB3nNvztgRna?=
 =?us-ascii?Q?W89ldiq0PB3Dd/QYp6m/NJXSHGdqW68F7JBBLAyEoDwx+0sGYYeQSGum/U9Q?=
 =?us-ascii?Q?U9CxayiCx+oRn8jl17Sh2NtDSMDtJRAVf6AjIfQKM0OYz+8UVHLaSxypTKfc?=
 =?us-ascii?Q?/jI01ZOgEXtsTwa0Qt4qnB9lUv+8IT78DMX6+cB18uJENKdfRZAFSxtvDvx0?=
 =?us-ascii?Q?5QpIuLRKL/AVk9vEezjLA9rcm8cFNzk8KpcF4lmfzrWwry7fPZzWSAHccqHC?=
 =?us-ascii?Q?D0F6MvWG7vAheHEbWFbNnDrGu908s4hi+J1UFPa7suWjRwrPfw+JFjKsTQrR?=
 =?us-ascii?Q?ZyS/3tWqpe1Ze7jnDjMHnFacJljAw2vAmv5CJRyjgevABfoKke8GPb8IliAk?=
 =?us-ascii?Q?QJYfDfYPB4FkmTcX6TAKyZND731hFBztm/Q1/Ii7lNzgEfW6Qmg0o0iZaPMM?=
 =?us-ascii?Q?NZF7t8mBZxpU1dIeIvEJRrxVYk5RbC9K5/rvCkMQ2AEPpye8pzatOaoKc8l7?=
 =?us-ascii?Q?LIinOonROmxCgzGfcwyKQkuUE21t3KZy3yKYqu9xT3TbbXsYC1RyLeFSnb5T?=
 =?us-ascii?Q?GkE4E/XpOIoMxD85ARhWEylkYJb+BGx2dGc33qI+qwgBHtsQ1jDIagjfxiSf?=
 =?us-ascii?Q?QLRF7zDp3/6QtKDv141eluHJ1MzPwClxeuMd2uLd8+gAQhIVqIKKgAQLz/4n?=
 =?us-ascii?Q?Zl3/0o6lq4ZFMx00fpNxXorpY3VIy9jkH37PQ1LoUTCVWvXKwsbwfHwWqxBk?=
 =?us-ascii?Q?F4RLNx+mkV7C8JlqL5wOuKDB58R9uF0DMP/uwl35sv+YptRG7q3br5e64EyK?=
 =?us-ascii?Q?Evt+ICOAXYfTEKWf4tizqbfnwnNrhtsVZj9HeP2/chpfGV6D2WEv1pLSkOiD?=
 =?us-ascii?Q?90qsb4F4AxdPipxkkjoDoRGsZoLyBix8Pt4ctadB3VlpNq9/zIdRqoYywGe1?=
 =?us-ascii?Q?jSY9h5LbqTARjNirZsZ0ys7yqaTDUCZz8pMDGFuFP8vD0iOE4H1U2dkY18aN?=
 =?us-ascii?Q?6i+O+h+qDdc+mXnEGXUqAT6g74zkt+6mMdg07N7jo3cUn0Lrpa2jJZul3hH2?=
 =?us-ascii?Q?i6s+h8/d2tZ4SYd94JpC5U/XqXTjrbrflnsWpMwJJZtTQ8GMv1NfVznkQWOf?=
 =?us-ascii?Q?p+gUjg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66310e84-f4db-4921-ed2c-08d99f118bcd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 21:33:16.0087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDoePOQKVMwlR3V7uUCw+7IVeVGI2Vqlji+JJK7C1j19QkdAG9vmQ39I97ZP3K5T0zr33U7EU5hcghtUPQ4jdnS0D+33dGd6c/HEbfu8lhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3857
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111030111
X-Proofpoint-ORIG-GUID: trlzt6SLtaDmaXhhNLqyioeXCIC1n9qH
X-Proofpoint-GUID: trlzt6SLtaDmaXhhNLqyioeXCIC1n9qH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new deferred attr patch set uncovered a double unlock in the
recent port of the defer ops capture and continue code.  During log
recovery, we're allowed to hold buffers to a transaction that's being
used to replay an intent item.  When we capture the resources as part
of scheduling a continuation of an intent chain, we call xfs_buf_hold
to retain our reference to the buffer beyond the transaction commit,
but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
This means that xfs_defer_ops_continue needs to relock the buffers
before xfs_defer_restore_resources joins then tothe new transaction.

Additionally, the buffers should not be passed back via the dres
structure since they need to remain locked unlike the inodes.  So
simply set dr_bufs to zero after populating the dres structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 40 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0805ade2d300..734ac9fd2628 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
+#include "xfs_buf.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -762,6 +763,33 @@ xfs_defer_ops_capture_and_commit(
 	return 0;
 }
 
+static void
+xfs_defer_relock_buffers(
+	struct xfs_defer_capture	*dfc)
+{
+	struct xfs_defer_resources	*dres = &dfc->dfc_held;
+	unsigned int			i, j;
+
+	/*
+	 * Sort the elements via bubble sort.  (Remember, there are at most 2
+	 * elements to sort, so this is adequate.)
+	 */
+	for (i = 0; i < dres->dr_bufs; i++) {
+		for (j = 1; j < dres->dr_bufs; j++) {
+			if (xfs_buf_daddr(dres->dr_bp[j]) <
+				xfs_buf_daddr(dres->dr_bp[j - 1])) {
+				struct xfs_buf  *temp = dres->dr_bp[j];
+
+				dres->dr_bp[j] = dres->dr_bp[j - 1];
+				dres->dr_bp[j - 1] = temp;
+			}
+		}
+	}
+
+	for (i = 0; i < dres->dr_bufs; i++)
+		xfs_buf_lock(dres->dr_bp[i]);
+}
+
 /*
  * Attach a chain of captured deferred ops to a new transaction and free the
  * capture structure.  If an inode was captured, it will be passed back to the
@@ -777,15 +805,25 @@ xfs_defer_ops_continue(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
-	/* Lock and join the captured inode to the new transaction. */
+	/* Lock the captured resources to the new transaction. */
 	if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
 		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
+
+	xfs_defer_relock_buffers(dfc);
+
+	/* Join the captured resources to the new transaction. */
 	xfs_defer_restore_resources(tp, &dfc->dfc_held);
 	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
 
+	/*
+	 * Inodes must be passed back to the log recovery code to be unlocked,
+	 * but buffers do not.  Ignore the captured buffers
+	 */
+	dres->dr_bufs = 0;
+
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
-- 
2.25.1

