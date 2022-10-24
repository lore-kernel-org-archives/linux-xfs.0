Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7488DC3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJXEzq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiJXEzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C157A57DD0
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NMxxcl018071;
        Mon, 24 Oct 2022 04:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CgXVi2k0Vdd+sQLhnUay8afZ14RDjpbm/8UvAWBy404=;
 b=A0kX6pIGaURgVTpArVWiiJhPEhbMHBFF/m/BoolVyObNN4Vezs6leiyyczDiojh31Mup
 donEkjMHI3dwJrxKNLq8+t0HhA8qgInMfPn9YKt/AODl6iu/k/odr6lxfoBGI5l2oJO+
 M2YuDANBNSSnTeJ7VrvQ76LuydQnKUejJyvFq7ZLEe1/OaGMZSsZj4up4eqx1ngICxoU
 u4QlMslU74jK6CUkeBFawgfH/764ZMRjy19QhosXVSoKlLALrKwkmuwB9jG6pQWAgxgF
 uw/KUi32U68/QDZlbMjUGU0AbjE/YpVIKceKCOkgZO2bM2vh196cbJFqOe01Dz6etk4w kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741jw72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29NM2V2r032034;
        Mon, 24 Oct 2022 04:55:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3k8u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbvpUZPRzwxEVwMEAic6T9CL3FndDSduS7Bpy5kGnxhSAfn8uA1RGjBdLyD9Yf7crfwoMFKJxeJ9PWEshXyvfNPW7uUnpVX9qDzjcib85Scyo54fJHbHj8GzD5YubQKwAZARFhTg6hnPimQ8W2jxSzmSSsj60cfLNI8RNUbyvwigNM/yoCz6ymKq4nfcvzfzB1eSDK7LGiNwuwHLTg0dM4zEOY5lpVUc5quQzMHooH2toL5j4etgHe52VniGCqpKguCicYVG7OYXpyksx7Wrr8YBlrQfi5sYElGeXvSBcgmlFAP/ZI23WNlyT4hj0runWVHcugF5+eMGKz8RNY8oTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgXVi2k0Vdd+sQLhnUay8afZ14RDjpbm/8UvAWBy404=;
 b=f8pqR891cd1RAeoNUyQoUYka8Z6Vi7TKbbQBm9ot6csHH1OqiR74agl2z3vTyR+9oQ00ElrFPdCM8IRtIax7tKcJOdeKxK4KoqA5xem8c/G+LXTwX7etMWec+ea+cBrPSLjAWKbjOBd1q52ylNsy4Hr0B4Wo+/FEHJDpKARmF/FA8nZf/i7j2+CCcjrKJs1vei5hyN2v9BSVRDgg6tiR398ssTDHnpQE8BBF8QFIrZ/oIi6bsjIpa+a+TkC4Ms4tephoK75p3FupYziFaE3vUcgSUrPGWjw0HJKQwdlNZ3eqEBz0U4QjsWn4+3eN0BRgUhNVnfvJmjs44tbnO+CP2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgXVi2k0Vdd+sQLhnUay8afZ14RDjpbm/8UvAWBy404=;
 b=g3ZFab0ldea2oqDg7F5bWtTdskxybNErNcpD0DKWIozxl/eiB9Wi8sdPZoiKSaajM6tNw6I6jw61qFhk+ykD83/BMdPhpfELZAVlNsPPBvfwh5fXMu9/cemEYgTDAhRuliRjDQHwjAxOZF4BCPhjE/5RoYvE7YYiC3aUew33ovo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:55:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:55:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 18/26] xfs: Throttle commits on delayed background CIL push
Date:   Mon, 24 Oct 2022 10:23:06 +0530
Message-Id: <20221024045314.110453-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0044.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::8) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd5a936-d34b-48aa-fb0d-08dab57bfc94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lzorpDJntf1kUScInop2Tt0TEjmNMCUM3880TnGtban1sul4ZB6t1uy24HHpwd6VdKjStFM/+feL5ZrdE/cq6TDeRkXiO7UenlXDatBQgpDccTYUI6W1QNQ86+dJa5DZ/ISsJJYPyYk/0CxDPOFRoLlUZu/jV+iScS1hIU896uMv+8/EEMxz8nrDdhKO+wZf/mHuMNGLhbNnoynwDH+SJkEbLfZVvmmJbdnE9Vzqkp/73YLtBf+ud6u4atKPwOViQNgECtm3hNBiFAnBMi+bBvuWDpj4EMOMqc5g2x8RQRYr3RCgyROtIqG/0wlliGQjXHq31yg6MfQRFg3rcq2uzQGUSYhKFu9zN8qTWaqIfkQwwc6DJPXjtmCQgkun8tb6nSw9LOikrnkIIh73o8Js749IR+YH83WKQFteh0k81Yhw3maMjQ+o7SXFwFC7Bvau8TgVft//uvRmi6aAmlMCItMr3cKE5B0w/9teZhxfc4FavCA+TEQrkkaXKFMNzrT4KJJGuy6s8Vd+8cVsNVaEO6f3DgkgyRexVSymVTlUrd41lBrHfSq9FfLOdKgZXmZvk4QOlxvEtU/cwOFHURJO4t4t0DnOAm41yd51RVEzKwuswfB/1lCJfHGaeuE5hv0yUgIGy1ntvc14abp2DMRuSbQcByN4XNA41nkXpCMvGBbXYSY6GXrXjDZF9Hza4NXcBm//5JrKm7gdmDEpiq0frQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(6666004)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YNcqK9tMHBh0GVr/m/efCqgvBc4o60C6ico4gZ2cY1WpYWu4EglH5SbdQ5p1?=
 =?us-ascii?Q?sze3BBWhX2DRWd0nQu+dmYvMkDLy8neaeeQC9/qwlfUCCse9q/PcHQ00IFp8?=
 =?us-ascii?Q?EIT3Z+3BVjTPnf8dIe+esTHpvi2YP/QEpc1SSVcG6qjuRTTqk6fll5KcfjrM?=
 =?us-ascii?Q?VZPGI+3zXc/fLz/J1ZuxU33iAGSO2FQJBk21gbNORfnTi/8b+TvCY+aaptJM?=
 =?us-ascii?Q?fqqEyuZFGkT9m9/bzx3y2CWIGs5iPfK8+etcGOmkw1DrW3Mvz6uZODd6tUdb?=
 =?us-ascii?Q?dCvKCiCv+8Lg8ruwH/EzYPlBVpTU7RSDEKzpPg+FfQSDpBbqOgLFvrllNa97?=
 =?us-ascii?Q?2TV+qX4Zy0eu7L+BQZg9ToiCX3V0nIiaEwbnSsj8wSicSyu2i/1mKCG0ynYe?=
 =?us-ascii?Q?YV1JM3WTVNDLWkG0nRL7MOjQ8lx+/Rr4lQevtielGq0gf4oMluEaiV88qnXr?=
 =?us-ascii?Q?AYozVE5V6J3w6eddZGNfMN8G8LEphvN2awirUFPlHuSHk/hcOR/PlBjeoWUf?=
 =?us-ascii?Q?uHFXOcUKHe+Y2nlDn4KOXa0bOMsidE0a8iXX/hizn1FVAb6kkPeNrwXqpMj1?=
 =?us-ascii?Q?Agq11HFSS/CcACi7JQe0LSZNilISQTJSoMoyI/rpRGYaq6GoLXNc1dZhVI7c?=
 =?us-ascii?Q?FIeipExsRmseFvd5fbgSmjZ+mzzaEvr1smAAWjJls3O3/Rr4kAXl17E0kPXx?=
 =?us-ascii?Q?sY4X/8D0zsJYdRUDMwBi6o6xb+jqtIhixzhbHcPzZF9ssvmrcR+lgGoGZu5r?=
 =?us-ascii?Q?LhQYqj1x3nCXTFGQTjTRxpFb061RdvCPE0R5oZhkO9MRGbmgqhWnJdrgiJCh?=
 =?us-ascii?Q?AkDOD1KSkJAAGJ/T43Xd9+4Vy7RdefiZ46F8Ty15t/kWUcY+h9wk5a9Wri/z?=
 =?us-ascii?Q?PKiqH9/Ec+IWCANgxfH1qhNlo/7gBq47gN2eoEcCTWKDNsv8ZAMtprOtsbSW?=
 =?us-ascii?Q?Tgigwjs5hqA41qb5C4PhmIMwE3VLNmDY2aFe0KijyWy1XOtZWrcHBwjPEWXX?=
 =?us-ascii?Q?SEg4/Z0BaLuutIEREM8jDpkaCV7F4V0rb3DFE7Lp7j0XoUGOTTjjrMJ4uIbn?=
 =?us-ascii?Q?hgjhLzuRcneAt1OaVfO9DbeKA1Ea63DE0GqUHelzzlM0IuMeCr9gisqVve0j?=
 =?us-ascii?Q?Dt4h5liozIQiVGq2d+U1g/oryPnL4VmD/79VB51/wTNZXWV0T6ot1cqh+TNP?=
 =?us-ascii?Q?kLrTxSGTZV0v6+siDTn+2Z/eRYIwoeaZ3qzVcOSkr3OysQE8BoxI28Pt+C0A?=
 =?us-ascii?Q?MlfrsSa6ZtAMNJx0oIjdGC1qI4SaAOIR1i/+MzahnlapobxpKBrXPMDoy3G1?=
 =?us-ascii?Q?tfy6KaH4+Kt46QMUoldfDaena6VKiW0TOWH7Uj+HxrrZXLKoNqOIBdg2eamH?=
 =?us-ascii?Q?5cXo2rBrKeJcffL6Gs4GFFBohLbKmxd9Zy6gTgbGQDF6IMLR0iH8cRdd5nKI?=
 =?us-ascii?Q?Jw5QpMahOIfTLASKrGCOZO/FZQa7LlZdRcxKY8Wy6OlW+4Mb3vxQHvqa6O40?=
 =?us-ascii?Q?SI7BV3Ad7TxehIJ6k+xRpy3ZXcvN8A6BUXTSjUt41tyWGIakpnojcpL70mUA?=
 =?us-ascii?Q?fNduPKOC5yGaB7JuFXu54np9V6nWMl9PjqSZK2PQQsP7X0ouiXmvjUbS90NA?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd5a936-d34b-48aa-fb0d-08dab57bfc94
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:55:35.0510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yp/4zZdQM20U26zImJ2AMsl+nqPG13yHK5MCZOUaqtabboFf+fgx5aVCU2b5wiFbP0q3FwyrV/yEyfaoV0aqLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-GUID: aETKqUVedSDW4pZPM5F7IoKgHRBWoMLz
X-Proofpoint-ORIG-GUID: aETKqUVedSDW4pZPM5F7IoKgHRBWoMLz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 0e7ab7efe77451cba4cbecb6c9f5ef83cf32b36b upstream.

In certain situations the background CIL push can be indefinitely
delayed. While we have workarounds from the obvious cases now, it
doesn't solve the underlying issue. This issue is that there is no
upper limit on the CIL where we will either force or wait for
a background push to start, hence allowing the CIL to grow without
bound until it consumes all log space.

To fix this, add a new wait queue to the CIL which allows background
pushes to wait for the CIL context to be switched out. This happens
when the push starts, so it will allow us to block incoming
transaction commit completion until the push has started. This will
only affect processes that are running modifications, and only when
the CIL threshold has been significantly overrun.

This has no apparent impact on performance, and doesn't even trigger
until over 45 million inodes had been created in a 16-way fsmark
test on a 2GB log. That was limiting at 64MB of log space used, so
the active CIL size is only about 3% of the total log in that case.
The concurrent removal of those files did not trigger the background
sleep at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_cil.c  | 37 +++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_log_priv.h | 24 ++++++++++++++++++++++++
 fs/xfs/xfs_trace.h    |  1 +
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ef652abd112c..4a09d50e1368 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -670,6 +670,11 @@ xlog_cil_push(
 	push_seq = cil->xc_push_seq;
 	ASSERT(push_seq <= ctx->sequence);
 
+	/*
+	 * Wake up any background push waiters now this context is being pushed.
+	 */
+	wake_up_all(&ctx->push_wait);
+
 	/*
 	 * Check if we've anything to push. If there is nothing, then we don't
 	 * move on to a new sequence number and so we have to be able to push
@@ -746,6 +751,7 @@ xlog_cil_push(
 	 */
 	INIT_LIST_HEAD(&new_ctx->committing);
 	INIT_LIST_HEAD(&new_ctx->busy_extents);
+	init_waitqueue_head(&new_ctx->push_wait);
 	new_ctx->sequence = ctx->sequence + 1;
 	new_ctx->cil = cil;
 	cil->xc_ctx = new_ctx;
@@ -900,7 +906,7 @@ xlog_cil_push_work(
  */
 static void
 xlog_cil_push_background(
-	struct xlog	*log)
+	struct xlog	*log) __releases(cil->xc_ctx_lock)
 {
 	struct xfs_cil	*cil = log->l_cilp;
 
@@ -914,14 +920,36 @@ xlog_cil_push_background(
 	 * don't do a background push if we haven't used up all the
 	 * space available yet.
 	 */
-	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+		up_read(&cil->xc_ctx_lock);
 		return;
+	}
 
 	spin_lock(&cil->xc_push_lock);
 	if (cil->xc_push_seq < cil->xc_current_sequence) {
 		cil->xc_push_seq = cil->xc_current_sequence;
 		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
 	}
+
+	/*
+	 * Drop the context lock now, we can't hold that if we need to sleep
+	 * because we are over the blocking threshold. The push_lock is still
+	 * held, so blocking threshold sleep/wakeup is still correctly
+	 * serialised here.
+	 */
+	up_read(&cil->xc_ctx_lock);
+
+	/*
+	 * If we are well over the space limit, throttle the work that is being
+	 * done until the push work on this context has begun.
+	 */
+	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
+		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
+		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
+		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
+		return;
+	}
+
 	spin_unlock(&cil->xc_push_lock);
 
 }
@@ -1038,9 +1066,9 @@ xfs_log_commit_cil(
 		if (lip->li_ops->iop_committing)
 			lip->li_ops->iop_committing(lip, xc_commit_lsn);
 	}
-	xlog_cil_push_background(log);
 
-	up_read(&cil->xc_ctx_lock);
+	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
+	xlog_cil_push_background(log);
 }
 
 /*
@@ -1199,6 +1227,7 @@ xlog_cil_init(
 
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
+	init_waitqueue_head(&ctx->push_wait);
 	ctx->sequence = 1;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index a3cc8a9a16d9..f231b7dfaeab 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -247,6 +247,7 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
+	wait_queue_head_t	push_wait;	/* background push throttle */
 	struct work_struct	discard_endio_work;
 };
 
@@ -344,10 +345,33 @@ struct xfs_cil {
  *   buffer window (32MB) as measurements have shown this to be roughly the
  *   point of diminishing performance increases under highly concurrent
  *   modification workloads.
+ *
+ * To prevent the CIL from overflowing upper commit size bounds, we introduce a
+ * new threshold at which we block committing transactions until the background
+ * CIL commit commences and switches to a new context. While this is not a hard
+ * limit, it forces the process committing a transaction to the CIL to block and
+ * yeild the CPU, giving the CIL push work a chance to be scheduled and start
+ * work. This prevents a process running lots of transactions from overfilling
+ * the CIL because it is not yielding the CPU. We set the blocking limit at
+ * twice the background push space threshold so we keep in line with the AIL
+ * push thresholds.
+ *
+ * Note: this is not a -hard- limit as blocking is applied after the transaction
+ * is inserted into the CIL and the push has been triggered. It is largely a
+ * throttling mechanism that allows the CIL push to be scheduled and run. A hard
+ * limit will be difficult to implement without introducing global serialisation
+ * in the CIL commit fast path, and it's not at all clear that we actually need
+ * such hard limits given the ~7 years we've run without a hard limit before
+ * finding the first situation where a checkpoint size overflow actually
+ * occurred. Hence the simple throttle, and an ASSERT check to tell us that
+ * we've overrun the max size.
  */
 #define XLOG_CIL_SPACE_LIMIT(log)	\
 	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
 
+#define XLOG_CIL_BLOCKING_SPACE_LIMIT(log)	\
+	(XLOG_CIL_SPACE_LIMIT(log) * 2)
+
 /*
  * ticket grant locks, queues and accounting have their own cachlines
  * as these are quite hot and can be operated on concurrently.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ffb398c1de69..b5d4ca60145a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1011,6 +1011,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
 
 DECLARE_EVENT_CLASS(xfs_log_item_class,
 	TP_PROTO(struct xfs_log_item *lip),
-- 
2.35.1

