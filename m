Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C5BC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbiGRUUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiGRUUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A402B611
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHcQ6g008091
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6WthS4Uec0axxI14KQX6+y5AY4eEC4kG2n9QVsARoMk=;
 b=W2E/Bg9v/tc8iXZbjMSv+kbBWmBKOeRh6JjMryosAU7Z6PKbUZrVkpA8Nxj8nq+Ngswe
 G+DozSdVDmW7Xm3UuYPz6WBnuyVPBksqJiFaqKwOpegcW2u0TKDRN0dPttXscSx2BwFE
 CA5Bgr1rn/0CQhohz9dd42Ix6WYHPSm0LgBNnnpCiSVge5DI7PJnV15cT9sePx2BCDKo
 0ccbNqyOP4xqIfKKGSFMRJf8ZkMlW2/eBf0NXSURmFiqCmcSE7UYmJF8gs27n/WZLewO
 ubt6yF2yqsLeAwGJtiPFOYSS0YtVR2iCuP+OYFXf8Tl6ZzHzCxoYFkMhtP4Ieq7gzbG7 lg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc4cv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4t5001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFdVG4V39/jyHr0Fz5EemU9+TAqHZtdwHb8TphFV9/hbx3IfntqbE785zUb6WPmu+BZgpMYnxfTvjwBT8jcGIpdstVFPZdCXuP/T+8EbJhIkggKhtQmYjWuYSqDM0v+FG7ZCxxbV/zNxSe6fsrpPA83pqmml3m6uT/SEgWhwAtzBJEZ1uUlpq6FdTJjti4l4knLVGhOz6mhitE5b/ShrzGiA1DytG6btbRDTGbiICg0sYnAqnM+gCq2MEkqN/oVBJUkZfa0Ps0hsuUSvE0RXQPr5GnF+UT0CO+ngmkxOtyTUVwXWGypSN17FO1k3pXT02xPxveAIpFP1w1HTQGoDwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WthS4Uec0axxI14KQX6+y5AY4eEC4kG2n9QVsARoMk=;
 b=g9x0g0lH8TbkAxzI8zAfxcZa/fslSsBQWz9qxHQw9QbCGV2XbtuJBG+Gmf4w/uiCGm7EX6OFa5nib97hADgR3CauZ+HXRMYD93cRsbBwbfQ3binmYRTSgidsw3hjg/tWr42cDlYQt9MMuGL1AuEQEW7jtcq6mJdMqDy0RenJEfQc/AntekDf27zNaKswAuaXjW0pSp87pwPGQ0jwGV8irJJS+ja56lk8h+qNZ8uOxP1QQG22ZumfcXaWMGs9PbujIs4rejPDu3WpLWpZFzFmkwaL+vc1QsRTkOk6KFUwgAAt+xyKxBYdr4WoR80vd4cKyQTGG+geAvHu5e/rNSsySg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WthS4Uec0axxI14KQX6+y5AY4eEC4kG2n9QVsARoMk=;
 b=d2QL5NXyY89KgulepJzckV9GMAa3ngz+D8qrzLNFzZzVuH6qjL9MUof1INf/u3pH0MSA+r9oNuVk5V7ElQL9umCaM14PyIOdvVKGzuBwYr8BovqlGsvfLiUFwCer4yfMrc++xUGyZvWNabeAvaRdgRlYU0BCgLCazwtturphsG8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:30 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 02/18] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Mon, 18 Jul 2022 13:20:06 -0700
Message-Id: <20220718202022.6598-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00107a0a-92f8-4055-790b-08da68faf55b
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BnLTb7jzj6jOzmkWdw4mdpSaVOxQ5sDq6EzKP9SiE2Ld0dw7XaHDEqN2qVnDEXeBGGYtoWyGggfgir95fpmPOIxo17F7bNLrry8BD4VF/wjcnixLIoL40d8ehAp75R25XQ7Uu79JpT4WVCd4DgDn+XKN3WdmengaHMvTasJ/2RsG2pPpWrBhGhPjcEF9o/cqQ6ASFjXxTA5ph5VXwLoCsKM0ajJrKT08UZm2jGeo7Z/oWv3K1iQBQAPiD7CRHnRwK/woVA4H5JRg523ndx3bZoVG1oezTzW1DWpgDYyQsNPNgf/Ph0asuHVEvls4RFasgFuHSIqy3rOymGn24DdxZqZ+/rg8+2BcJ0rfUAvXs6reQzTiBwSo2YtWsvBReZyT29c3erzcok+QWKumFYt51+hsQW0dI2XHrlV8FMS+FhIcP+KbvOjdZHgZiUrraUw3alMpHe4Q9U32wIXJ3Xlm5uSBhjiOSiTLP6VhL2BwLVYVfueKnOxQrb1dMiRI+NG7AATP55ZNdBHawMX2+qgdTlRGQDdc42OrhAtP91uQtxyHqnM+/vWFIKkMhH5sYl45aGuZ5T6R/nqGlqEllKgfLu6f9fTfEgXk01O0PoHMdcR5Y2+QR8ZFv07ggA+VGTZv7yaRC3Se5yTauCJh8xcUXQErbaUoput4h6ayrXoL87UVimJqAYnzX+6XWp5UjeGRcCplxW6bcVgJ5EWdcEzZwAAPKC9sgRUF9VXSLwA/pLhi2jsYGc5e5EFwYwokEJrKdy0vklhG6mD0uThb+LXlSqVLEcYBurOLDzEJeyfM6pA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l5m/9ZDhetb8pBKR1ga5kmpWLvTDcG5OEgFcfywGFBNxUKRWCyC/Vonxhymt?=
 =?us-ascii?Q?KRh7c0iDb/9M4/TX7PwlZz6iiLSnnoQm6PrwoA39cyDbfUPYt1oortDkR6Rk?=
 =?us-ascii?Q?MtpQHMUhe29NyPCacrQUPknoYO2fChPg2u2Be5TBrrEHWK9LWZyL36z2ZDl4?=
 =?us-ascii?Q?mXZwFQYsZNJ3XKevwBdcDjcWmZVPRmjMsGZJyW7iiThNbohq0j0eIfBgi2go?=
 =?us-ascii?Q?2zk5ek90/mxEJvmQ9hPkjM087hvVzVVig6C75ZmIMlcoLfOwUExXjKzNkjMJ?=
 =?us-ascii?Q?W4OJA0MGilSYGFKmwDwpGYlx0J2n/Gsq1Djm6E9y8ZkbutlQ76PKocGgfeDd?=
 =?us-ascii?Q?twCzBfpSIyC1juIFDhhQoI11S9CRq1lgTerQ5TPKf44myoY+ggNeTKxboFV3?=
 =?us-ascii?Q?wrLKFpG02Hf0YU7izd47urDRtKAVt4Ip8fH82Ux9336RpkMN2tI2D7FJ9lcS?=
 =?us-ascii?Q?Mn+GBsL1jPLsaewiy/xFxoLlSnwrg08/165xLJLVxFpzp8+BcODyHgqEwXbD?=
 =?us-ascii?Q?LPAiRKwrub7cP/Jpo8QKdPRcgerDwz8K+yhpanM5O0ym4tP5oQNkLZE4och2?=
 =?us-ascii?Q?aNsDMMDSE8LbeU+wB4XGwv1n4+W6nqFeq9+aSUXxb9yxnlxqzZPIfeV9/NeO?=
 =?us-ascii?Q?9jERGWql9RTliBOBqbihXzziOkpHQ1gDCwNkYyIJPiLiecL9dVk7nYnp269F?=
 =?us-ascii?Q?sJtmGvx1Z/SUCgO+2S3eT7jqCZ6HA8ZZA3onRSOHbl9kACwaVl24fxcnZdvy?=
 =?us-ascii?Q?0Z+jVP+YMvmaFS85Jof5Bt1UVkq/iMEL1bCfc9J7nB6Ea1bY+52KxsQ+nGQp?=
 =?us-ascii?Q?Qs/cMcWLXVtZx2kCNHGIpdZ583oiNdLxLaOmFqPDQFZIYIyOdhPOsBFjISd+?=
 =?us-ascii?Q?xMnDELvb8FABcLQ2Z+2smfyHgLsrzQgx2qpOQqwjHgLvgorYkhVg5UXhXQLB?=
 =?us-ascii?Q?/0HB10+zmY3/HP6fw8CLp3Azr5E2OqxMG2QAmSnKCitHFBZ+Og+db26fvzaa?=
 =?us-ascii?Q?OqwpK1WkUn0wM6r9DlilvjZuu0rLPI05IUuzMromzuB37ZduKQpuoCE6aZuP?=
 =?us-ascii?Q?EjTHtzMrkugc71CtH4DkYn24bXTsh0aviEfyOT7Bpf8tIelxErgJBVfjlbLY?=
 =?us-ascii?Q?ktaeb7jf5xaT2qPQzAyteScBD89ll5/+JgucVUS45nZBOPnn6iPQfUZx2VyD?=
 =?us-ascii?Q?GgBm7QjZ/utEDZN7IIO+oEs8gCa9g26EyVndHQwSmnxvmLWG5z1Zzu+gXsdF?=
 =?us-ascii?Q?TWyD9venXZM0DYGQkT2RXIS8UcvdhVMHjBJo4vJgXhvvTgwr/1vBmCLZnOlD?=
 =?us-ascii?Q?v4ycXIbKMvwZf3MzDdqKxzo2my3WiX6WwH85BedLCb/LpyGpuFEsKzC+1fRG?=
 =?us-ascii?Q?l9GrG82DmvYEYD6Gm6HL62HU9Lw/3wHb/T0rJFriXl3B6AJLSvCqBmDCseCu?=
 =?us-ascii?Q?lPhyzoc9Fi3vFHotywCEr+jYfj1istAu3xhDJWvNXc3fJqMLjLCexYXVkX9I?=
 =?us-ascii?Q?a7nZQJXvV66SOiT9/zpzZOSQkOOKDodW4gqIUOTyxSp1yqNnq/D6U9lpYRtq?=
 =?us-ascii?Q?VJPxVYrOc0zjDNmGokq7dP5QrD3ODz4ZVv4IQa71+KDdOovRiqoKpxRar6V4?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00107a0a-92f8-4055-790b-08da68faf55b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:29.4965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMSm9kHioVaNzn4dNWVDwJj6b7P836R/ICoN9387zTwMUjqzlsy5MlhxuGj1YZHj/FsAt04/ftQKIpz8rVtibgfNk5JtiCjTWTtA1g/f2Ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: v3T8-5EETHgPhk69EXlkiow8DpPdWnv0
X-Proofpoint-ORIG-GUID: v3T8-5EETHgPhk69EXlkiow8DpPdWnv0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..3e4029d2ce41 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with defered ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3022918bf96a..cfdcca95594f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4d626f4321bc..bc06d6e4164a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -573,5 +573,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

