Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EF1C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiB1Twt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D5ECA73F
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:01 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJpnH009902
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=6oksdl0xSeED8x8EbDpEW73VohtH6i/Cuf108ctLttU=;
 b=xcS/PqFw9tRaGDEC8SruWPj0i7BOhm8lQaOJ7SrOoZQQeQ9CYv8RxSJrLSGP9JShNtZR
 +s529iSv5HX2HsRQw3cwdnKWtv9583yt1/PgABRDxhUjSf881UGFozObHwo8977hYGY9
 3fcc0WSRSbY594/frQ574j8sShPZG+cibJoNfX2OUibvGq1/pt753lF8ISjBNPDj0Ktz
 Ws3Itv5jC51M5YT9f+QlwAy0IxPuXUay5JBsVaDqrr75XRDCm4cD6+DKxOHzNfuNQvS+
 TMyGadJrlcrqKpn1Ryu7gQlCJmYfcTa5Wu7vYsJHV1HxwLqu2jzIFJhLfGMJ5aIdo22k QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14brsj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJklto076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3afVPP02b28zUwToON/eoJzuPy497hWxlkSxpDRpEmRWoapdP7mxG0tKcoxh9cXn+EDe0deD6SROtGTXv3SdpI0gikwyBoO+wPa5rUNzGu30XmI2jl7xXn8fO7lNmyvr67p0tTFcXPfLMjtcNKpDOOU8qOoUUQEmG2c/LK+wNhTtKNNMLe27Gi0WUf+7ofsPE7TmerT/Ah8bfu3NI+6LjmExspcT9PQNBGtvM/5zPBhCG/EoXhmppPiH/mM7vOOxj7TOhURZ1KCIPdDUmJkoPD1sO89gLA/JQDx2Yss3mKXbPgXbtpGaoc0RIePL7oE8Ic7a5iwTPH3ZoUgbkbumQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oksdl0xSeED8x8EbDpEW73VohtH6i/Cuf108ctLttU=;
 b=RgW1tQ529S/F4Qtkkjtb10ARUkwSWh2NZs6L3LYm/sGdH4L4flN+jAo2s6d4iHlHTFtcXe16ORsZEDdVJJeRxsT9DY4nPkPDjxQGyAWsLXzjVHRu5z/YHDzOCy6UDd1aTcz52im4YJQOwhX+mTCA61k/T5fXIu/fqMRKhQlMOkEhAy7duQ0N8YBE/NnOPyFTISGWMh+C6NFSwbRiIfUfbV9JqDHYoOeUYYFuH+jVQEELZkhYLErwLh7Myk//jKl71P0LXZIvUy7i1b8hV2rrwP60iLC0S7eKzdpCtFAndlARdlvqde2jvn71UhCQDs8mkhJtIXW8lC9vM3nZiPRqcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oksdl0xSeED8x8EbDpEW73VohtH6i/Cuf108ctLttU=;
 b=oIGR9RzVeArEZUSMNBc+KFg6mXfZI3Y87r5KRsDAeSoQQDIT9eLQEiESpStH4DDrzPkhBmZu1paZOLIrkPxfJQIENYUVc1R2SkxNfk8ViBzK94RYd+WzZvDRrLJsMVjNlwWAjIBjGB9rtxaDcWPAZD+oCVtO5whgYUvs9/uCBtA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:57 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 08/15] xfs: Remove unused xfs_attr_*_args
Date:   Mon, 28 Feb 2022 12:51:40 -0700
Message-Id: <20220228195147.1913281-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c763ce3-a953-4a5d-0cb0-08d9faf3c6bb
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5612B6D7A6A7E903D96A990D95019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9kV/EvPpB4sJJN85lX6QshnYy5m2R0y6puTW+kZ6Mv5despsVMjVLfUOFaVJlRAiR0id94Ui3YqMqSx4Cb9GYde4v7bt8FSmqlTMvpH/F7F+SYqIxHHWZP8bCi0Rb+yVMITmHLeEjX+Tp8M7HkmHtI7CZ4scCbIzmLmmLFa+qKXm3d56zxEv7ApNyJPB9JwO43VfyolpJhbkHcH5PddQLwyh/JEsAhoUwp331SLlxlMuv5n/Zi+h0I/7G5SYXsBT15lNpCnGmIZXg6cCq9KheKziuuiKvrOy6O9D1wt/G3vHTuxafuPZebEzq/AXJ+IYJy4OnlIasPtWKrF7YqOuqF63qTr3HeuOLZgWcSDIv1fogyv9wBHHD2FrWVhq1b7+6602VHCa5GNSSWre/gCmdQsXzObxbe3gYK77lL29J+Pb6KX+WNYVL/18OvVWp0KrFepf7VjY0e3wF8y3Sz8T2fowL7d6vqe3FLNIF9MkPmUso9Gb6I7NABAcW0WU6Qy4XALXRjBZTKnpvK4qEY1MsuzLfshLnPHgU7UJhX+T/Hi2SQDOJJTV+uU7kdtuTevkAaKJDyok3ayiYJ2stxIavI7Tb5wEHmvDzlRLB39X80Oy6uY17LFLUloLJNtfQZxvWnkFUDqB0kp7a7LezMSbm/dc/BFyn3NVuljvEX3NbNp1OI3a4oE+gcMxk1/yMykb8fuu6J/QlDSmE7hgBfMf+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U1KxYFM3NBsYe0WoOKgD5jkmXzRDyJuWDRidvQf7poiXfVk0YupMXwk21BSE?=
 =?us-ascii?Q?0PhXyzD68TsP/ayVTA0tm/q2ZmD3DjUHcvdsBRgwrl6Xk+Ax7p5f6KUmbuZf?=
 =?us-ascii?Q?+oYeEP9XPkcsfix/x1AknfsiB7g+3j0wvFQJADra7O2pj5bhSJbyJnUsllzG?=
 =?us-ascii?Q?qUg3BGrrXc0+jjq4iIGi64ipJhWO5/nMULkNCELnSbTQKnNrLh2+Kv27PiZy?=
 =?us-ascii?Q?Y353/1OQoxl/OCZH1Yhh0yBvwV+7c98PF86Iz4W0mNjihNt0yvWYuhX0b7qk?=
 =?us-ascii?Q?cAi7iOpCh+hIqi7ibwp2NlpZeaG0wJAUHhlgtWgGyJHOUqArPYx/JC6ErPgs?=
 =?us-ascii?Q?y/s4b5vSXQBHe3O/mQNGaKk5mHj2MTyPbdk2PwWjq1oaQzArHpUXGVzdBEOI?=
 =?us-ascii?Q?Ef7ktZ/+ZeOXbNRntB1UlZ98CzQ8I9MFL7G3TJI4fjO+l9J9ZLlUyRVt4lj+?=
 =?us-ascii?Q?QfmEQ1mYj5WYQD4ugFNxJIKSFSBgNpSQay80ofNjA+TwpQaVO9wh1B+hH6xg?=
 =?us-ascii?Q?P0MznLjfMXyMDLrLEQp1ZXlsvwQXtztU4yFId7lejRTbvOhgVisLamh/sats?=
 =?us-ascii?Q?cQrD8FZK2BbjeKL5NdV2FV7g/IeRGGaLvsJ1NSdOXzNHoOeegay0/rGMa2FD?=
 =?us-ascii?Q?Kz5aAoX0e2QFoT7g3cozHHoe13JDLq8hWNxRUvK20u2zXUS5wNIFuS5qTezB?=
 =?us-ascii?Q?UP3+S0hRf5vhbDwt8ruodLm65mElbiL1QSIWiGTfWEnA8hC51cBrZRq6MDD9?=
 =?us-ascii?Q?OvK6rBdqcHHhan5p3OVdHLchEDZikglNfMf3Ky6patmkxnEAlrp2fsG9f17+?=
 =?us-ascii?Q?6X7wqcFr/BZFZ6KjFPBjKvn+Z9ma6gyWPjRmdNccaoGKgxe9zJEFDFp5cfRP?=
 =?us-ascii?Q?4LLmQQvqIJ7goydzep/8g2g6EuUIMVjbhnY/RELbHHmCpSNqOJ31cJmaQVBj?=
 =?us-ascii?Q?cHrOr/NO1hHfH81DKTtQlNR4ZTqyMo2EchLN+WZNNT4IXzsWFKkhYaZ4U+bH?=
 =?us-ascii?Q?3NK6rIP3UyDiE21OeNxL2TwLa1pMW6MMNIzEpaBN8NNU2w4xU+FZ0kzT9blY?=
 =?us-ascii?Q?Na385st0Gsk4ewOH2eA9QIBvJ1WUYtTwQbL9fe4cVvtLh0AeTGcWY2VkF8VM?=
 =?us-ascii?Q?IxvGU6GCPB0VfRxKKzZXqpAfLB0aMqfbBaK8PcRrjGnbybmeYE4fnGGdec3V?=
 =?us-ascii?Q?6odil/aXnSGSMqNLVTvmDV3eiKia5j51441RTxDJdyRD8eH3WaKwe9xxw1bg?=
 =?us-ascii?Q?WTxyqKHUoLLp1wBIfBwbb9XPUOFnlLw9/TazOOIk1goS4JV7QWWGFdhfS60v?=
 =?us-ascii?Q?PDxuMycMXk2drQpgMEOUQw6ifjqHeEGr+3DXcI78VcrEd+uxQsbB6jPPpJ5/?=
 =?us-ascii?Q?sDKv0SKvtCaopsLGz0k2wcO4LnEbO12fPZWPj3tedSOPwE2Lik5fFuOTorUL?=
 =?us-ascii?Q?g9OyhKr0rIXn4ZR8tl8bnQulpI1W+j0UBUy+6V4JghBK89+XSsQ/sN2vF+Nx?=
 =?us-ascii?Q?zH3WeSpzBflOcI8AE+675uevcsq8HLmIOt7ZTyYPbHdAXQf6J/16QNknud66?=
 =?us-ascii?Q?oF9UojGT+yh95InyknutfDZlkYakMDhRqhoMiqV14LCi1x4HN0wUfGYik0Ul?=
 =?us-ascii?Q?n5qSUyikIfFB45ngV/gLgr2JQPGiZS9hjwSKF2inRsQn30FVzJzozHy2kcuI?=
 =?us-ascii?Q?gYtygw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c763ce3-a953-4a5d-0cb0-08d9faf3c6bb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:57.0279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRFkPsV2Q9eJWyZV+hR3P59NjXxAJLvANmJ+D+QFcJ3soTUZTObPjm/44Xs68FYmtciz1eLmwNhyBpf1k8vunpe/FyTBUeYeLRI3wRmDyCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-GUID: svDCPVw8KMBilYY5xYk3tHDfXMJ2qTbD
X-Proofpoint-ORIG-GUID: svDCPVw8KMBilYY5xYk3tHDfXMJ2qTbD
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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 106 +++-----------------------------
 fs/xfs/libxfs/xfs_attr.h        |   8 +--
 fs/xfs/libxfs/xfs_attr_remote.c |   1 -
 fs/xfs/xfs_attr_item.c          |   9 +--
 4 files changed, 14 insertions(+), 110 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 848c19b34809..3d7531817e74 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -247,64 +247,9 @@ xfs_attr_is_shortform(
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
@@ -323,7 +268,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
 	if (error)
 		return error;
 
@@ -332,7 +277,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, dac->leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -340,7 +285,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -353,8 +297,7 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -373,14 +316,14 @@ xfs_attr_set_iter(
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
@@ -399,7 +342,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -690,32 +632,6 @@ xfs_attr_lookup(
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
@@ -1309,7 +1225,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1324,7 +1239,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1578,7 +1492,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
@@ -1606,7 +1519,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b52156ad8e6e..5331551d5939 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
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
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 83b95be9ded8..c806319134fb 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -695,7 +695,6 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 6e4c65d82db5..468358f44a8f 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -270,7 +270,6 @@ STATIC int
 xfs_xattri_finish_update(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -280,7 +279,7 @@ xfs_xattri_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -390,8 +389,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_xattri_finish_update(dac, done_item, &dac->leaf_bp,
-					     attr->xattri_op_flags);
+	error = xfs_xattri_finish_update(dac, done_item, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
@@ -550,8 +548,7 @@ xfs_attri_item_recover(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	ret = xfs_xattri_finish_update(&attr->xattri_dac, done_item,
-					   &attr->xattri_dac.leaf_bp,
-					   attrp->alfi_op_flags);
+				       attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
 		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
-- 
2.25.1

