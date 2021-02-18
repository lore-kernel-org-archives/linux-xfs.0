Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D94FC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 19:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB53264EAD
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 19:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhBRTaf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 14:30:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49886 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbhBRTJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 14:09:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUIT5180403
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tiIUF2AxMmcvwigG1rTN4NhMBXcuIwWONLAb6l+Z6Wo=;
 b=CdVdLV/O1qloxuINib8PW2AkM4l7r1ekGgPXJPUIb1I7OHyMw/tA6ynONBfoy30t8+Dl
 n+5XcJTxFX5bTyS1agUyPkhCm7at3b+J98Gsq2uz2s6a4yiXd14SA6dLeOKm79oTWN8Q
 A5E06+Jgsu1QxX2E0yjS0vD3efUQvVq485z57sDzf2BmlJSQvcN4k0wGjgMbDYXQTR2I
 C6ZtsCIElDo09/8AuzcPxR4x9flQ0QDhuq8uPZHtkZlBz4zU4GZyL6iywsKwXdFjvnjr
 8py6DVRIAnTsFo2StN6dXGJt/xq3ZapHeNNsuFWl7JbNpko0N4FW55gWXT9rjSVWPI2u ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dnph1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUBLq032269
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3030.oracle.com with ESMTP id 36prq0q55k-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBABtVSpPXlopmkqmJ9wQWISOm/Xc0a3j6sdVD0uZ3AK1n0FUMC0O/L7cisEtKqVinHUwb0WLwr4rOcUAL0HW7fzcWpq7tj6Sw/5LZlg3hui9tJ35v5P+XYzOdBrcrZn+kqIM0Z8TprXYVk3TuLwiklUfZwgpCRYN32H/SKHmBcnLy5jYe64+WAluAIlFutCy2g/xVE19/clg9157QHy3KIzxFmPZUaOhewz+EA369riH6nKXo6HyWUmj/ytS1uHr6XOpouQsnyhCSqGnoHDvcHyLqy13Z9riF3jwchdYQsfFOXOIC4qWazZG8pNsKthqwREHw/Dup+ZaDB8jkJL1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiIUF2AxMmcvwigG1rTN4NhMBXcuIwWONLAb6l+Z6Wo=;
 b=Gg42prdsaeCz2tg1Iyaz+n87edX3C2bDaxKGnB0hOdLgHjY/eqFVxTOG4mi3ZmsgoipzRmOTqVNaXo8vgJFJch7xSafSiM2HoG0+8MJFTEZKZw/5SpvnooPJerCB41j86A9xbGI4pM+z6KJwa7M7Y95lud0tr8TQ21Ld2qRQLnOfODqvMIeK65DCyrCssBCLrfK7X0FZZVxi1G0VEv55QhL/kkm7ZU4/UOS/c+iSGsN7So13xvG6oH3z/Z11eoew5htHiPbqgvRNqKANQS6maZlZXAab9fegW+1oL7Gp6wNOk8Rbfc5GOcuiFCu73wMqbhxr/+l5L1eIK2WerESK1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiIUF2AxMmcvwigG1rTN4NhMBXcuIwWONLAb6l+Z6Wo=;
 b=fR5vAAxwpBhJ1+kT3RVsiFcRDw+ECWnnGDOaCQGF1JqXuAB2XtBq2id/5bAxZ8eh2ejM++z9NaHzRmhauEtUWmcm6SrMO9usi/rFQjQIxK72e/kUk4/njktogV2zp1MatXhRH9z6hpBXviKDno1RDDj/0VLaIazs8SLhPC2/SlA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:45:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 29/37] xfsprogs: Add delay ready attr set routines
Date:   Thu, 18 Feb 2021 09:45:04 -0700
Message-Id: <20210218164512.4659-30-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5392e59-cb56-4dcc-ec7c-08d8d42ca299
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2965A796ECF2683CCD45CC5195859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RjHSNCNrH23B4rYiqXE0OTUhYHPpXaTCHMSz6o2IyieCXH2V5lXW60o4PZcC5cpncnXibEfH38ptWUm2i6gb1McyPCTaiJrA97tlCFcqZ2deerLOfNw8OZgcBBm1q3vUGGYDR/lgCalo4+2IPBC/pOusYtJcLcQagaWnm2yEKBmp3/V07QrnJ1da3h78iSC+w2c0NHwlu4IshcdmVxsVR2LzZsB0jfo+4/l/qbABxs1oG4vcRcpfKrytxO+nLi8kQaDFzJHS2C4B/0i/57iIwz26OiM32L8e9g2Iz5AOAT2vorK8EDm/w939w1eyx2i8isxtXDG1MkpnGUfz6hwrmBV53WxNA9ctqAmdQxESA8nJNp3QafUHkN+knRcRCRpttVN40BeP+sxLqTPmaxrcCLs6yCWy7bk+kCCznntMVCLUgawPSyW9zH57Q6n5/MCHVO9A8PDjqvMRGc/crWhVLXzeTPdB8p1QOu2ZrRhnS/ACNh4EMAEPRkT+2ef4E8+2jFcQB45HW/8gU3pF/Y0Uhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(30864003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?y0K+91Wvrg2/JSAgQSXoKcpzBrAfSiiN5GXtHX1z22YoIcUNv2wilpANKLdo?=
 =?us-ascii?Q?IHVNGJr9m59mUqvUOiBv26lUYm+cPeHazWZs3Z4K5EDXSlwf3M84ehJn4ojo?=
 =?us-ascii?Q?EehP3FoUhC8TuShpQVpHxJbu5j/xckeqprDF+UetQKfX5d3eJMCL0AtcTFrA?=
 =?us-ascii?Q?ZxbbdZt/lXx1ivI/3PfuKjUHlvPk1ilvIfbpucH7JEBl+4hvZVDHnt3BGE5H?=
 =?us-ascii?Q?j0PPyWa92EHebvKuDmFXS0ueWvRtFLfEp8k+50WuuCnKKguMpXQ3+MoKRjb3?=
 =?us-ascii?Q?PBMnQgYFqLs5ek0yDXt4EWnP16MponinBHDRDZhZ2U7KTyRWvy2YvgohATGk?=
 =?us-ascii?Q?D1TrRqKuynN44jAmJYvA6ZTHZAXqnZz8j/XMFTidd1ZMJUD+AGQLvxGcw31N?=
 =?us-ascii?Q?hyijo4LwCHODGcBQhYtOca8yaN2Lhv/tpcjnybhCr4NCm4rZRW2sds6p0KmM?=
 =?us-ascii?Q?4C/EQrYgqSPcgOBj2e0BnDO59LsDtaRbAykyhgdzLDVMaa5NLWoBwTRinWtA?=
 =?us-ascii?Q?85809uBSq5nhbcJfeLsWDWz7QllKNX3Sd8VyJ0rkHxT5ms03MgeFUb3lj4DZ?=
 =?us-ascii?Q?JQiHsaO+dhWh4rvzuTWS2o9RrBcJ/fJhPTUoO6orgIZSTnfY19AAXnfbfUMn?=
 =?us-ascii?Q?E2h9VPriy5UehXRcgXYHKHqgKeOO/U0Bh8MUNUqBEsiWM8bOeQ2hpw2nqfJk?=
 =?us-ascii?Q?4YDUr1oNTZuG1HoYSQYTMydo8Luwm183entuu2UfR3bnwBNxlczeqbHBMRC1?=
 =?us-ascii?Q?vF7X0pOxtfPRwx61hqCpf+WMhgX1aYgXqQ4cAcQfVZ+BJp9H3WOt1zCd+gPM?=
 =?us-ascii?Q?TKblTU0G8CthvotfmBhVIZ0rDwotHUmMWsqygEIfl+NPc3QPI9eJSGZa/3q4?=
 =?us-ascii?Q?s9qxWcqKk7DbaLksBF59Q21nEPrith+F7grZb/EENwSxmGaxVOQZJEJ0o6Xx?=
 =?us-ascii?Q?JN4DROzoEJhwobdSoOUC1deoUer4rdjheXHhLb5H5MpB+K8TL0xg5QH6myAx?=
 =?us-ascii?Q?MDCZCoGC9fKpnBdFgQ4cv02QtnyUrUcWo+p6UTwxQOPWK33szn5Bx5echBJm?=
 =?us-ascii?Q?Ri+lh+hlDtn3Y9YXZs8x/49YBwDevbjp2crMtc2EcSDsbizAqSkxe79r98zx?=
 =?us-ascii?Q?6uVoQPJ+dXb2g2slnim1gijx5yjsLnqoiRvI8Slt2QWbvClhlkVKyB1oVfS0?=
 =?us-ascii?Q?Fhvw687MhN/X6lYiDKrf90D7aCTBaZ5ag9urvlqBvvrxvYwnk/7BB3zagZgn?=
 =?us-ascii?Q?AWn58vkAAwm99Vf1weV1rBR9gpR6c/85VKMd3sy01gVnKAJEXkOBsD3+hs2y?=
 =?us-ascii?Q?Uo4kZYg3TlaPLr6e1hV8AcYu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5392e59-cb56-4dcc-ec7c-08d8d42ca299
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:44.6263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BDXxLO2oskMo46nYIfvj/ycUx/HLMW9RhfmZWFm5/VsCB4+1YI+Z3AJ9TlOeF9+XbqTceIczEN45AlLBIPfKfrQax7xXTtjXKYE8xXa0LYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45e46c998cd75749f6975ffdeeb9a59768e4fcd3

This patch modifies the attr set routines to be delay ready. This means
they no longer roll or commit transactions, but instead return -EAGAIN
to have the calling routine roll and refresh the transaction.  In this
series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
state machine like switch to keep track of where it was when EAGAIN was
returned. See xfs_attr.h for a more detailed diagram of the states.

Two new helper functions have been added: xfs_attr_rmtval_find_space and
xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
xfs_attr_rmtval_set, but they store the current block in the delay attr
context to allow the caller to roll the transaction between allocations.
This helps to simplify and consolidate code used by
xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
now become a simple loop to refresh the transaction until the operation
is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
removed.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c        | 448 +++++++++++++++++++++++++++++------------------
 libxfs/xfs_attr.h        | 241 ++++++++++++++++++++++++-
 libxfs/xfs_attr_remote.c |  98 +++++++----
 libxfs/xfs_attr_remote.h |   5 +-
 4 files changed, 583 insertions(+), 209 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 27c0939..e4c6268 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -53,16 +53,16 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
-				 struct xfs_da_state *state);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
-				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
+STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname_work(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+			     struct xfs_buf **leaf_bp);
 
 int
 xfs_inode_hasattr(
@@ -226,7 +226,7 @@ xfs_attr_is_shortform(
  * also checks for a defer finish.  Transaction is finished and rolled as
  * needed, and returns true of false if the delayed operation should continue.
  */
-int
+STATIC int
 xfs_attr_trans_roll(
 	struct xfs_delattr_context	*dac)
 {
@@ -249,29 +249,55 @@ xfs_attr_trans_roll(
 	return error;
 }
 
+/*
+ * Set the attribute specified in @args.
+ */
+int
+xfs_attr_set_args(
+	struct xfs_da_args		*args)
+{
+	struct xfs_buf			*leaf_bp = NULL;
+	int				error = 0;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
+
+	do {
+		error = xfs_attr_set_iter(&dac, &leaf_bp);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
+			return error;
+	} while (true);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp)
 {
-	struct xfs_buf          *leaf_bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-	int			error2, error = 0;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
 
 	/*
 	 * Try to add the attr to the attribute list in the inode.
 	 */
 	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
-	}
+
+	/* Should only be 0, -EEXIST or -ENOSPC */
+	if (error != -ENOSPC)
+		return error;
 
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.
 	 * GROT: another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
 	if (error)
 		return error;
 
@@ -280,93 +306,140 @@ xfs_attr_set_fmt(
 	 * concurrent AIL push cannot grab the half-baked leaf buffer
 	 * and run into problems with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, leaf_bp);
-	if (error)
-		xfs_trans_brelse(args->trans, leaf_bp);
+	xfs_trans_bhold(args->trans, *leaf_bp);
 
+	/*
+	 * We're still in XFS_DAS_UNINIT state here.  We've converted
+	 * the attr fork to leaf format and will restart with the leaf
+	 * add.
+	 */
+	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
 /*
  * Set the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
  */
 int
-xfs_attr_set_args(
-	struct xfs_da_args	*args)
+xfs_attr_set_iter(
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp)
 {
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_da_state     *state = NULL;
-	int			forkoff, error = 0;
-	int			retval = 0;
+	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_da_state		*state = NULL;
+	int				forkoff, error = 0;
+	int				retval = 0;
 
-	/*
-	 * If the attribute list is already in leaf format, jump straight to
-	 * leaf handling.  Otherwise, try to add the attribute to the shortform
-	 * list; if there's no room then convert the list to leaf format and try
-	 * again.
-	 */
-	if (xfs_attr_is_shortform(dp)) {
-		error = xfs_attr_set_fmt(args);
-		if (error != -EAGAIN)
-			return error;
-	}
+	/* State machine switch */
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
+		if (xfs_attr_is_shortform(dp))
+			return xfs_attr_set_fmt(dac, leaf_bp);
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC) {
-			/*
-			 * Promote the attribute list to the Btree format.
-			 */
-			error = xfs_attr3_leaf_to_node(args);
+		/*
+		 * After a shortform to leaf conversion, we need to hold the
+		 * leaf and cycle out the transaction.  When we get back,
+		 * we need to release the leaf to release the hold on the leaf
+		 * buffer.
+		 */
+		if (*leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, *leaf_bp);
+			*leaf_bp = NULL;
+		}
+
+		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			if (error == -ENOSPC) {
+				/*
+				 * Promote the attribute list to the Btree
+				 * format.
+				 */
+				error = xfs_attr3_leaf_to_node(args);
+				if (error)
+					return error;
+
+				/*
+				 * Finish any deferred work items and roll the
+				 * transaction once more.  The goal here is to
+				 * call node_addname with the inode and
+				 * transaction in the same state (inode locked
+				 * and joined, transaction clean) no matter how
+				 * we got to this step.
+				 *
+				 * At this point, we are still in
+				 * XFS_DAS_UNINIT, but when we come back, we'll
+				 * be a node, so we'll fall down into the node
+				 * handling code below
+				 */
+				dac->flags |= XFS_DAC_DEFER_FINISH;
+				return -EAGAIN;
+			}
+			else if (error)
+				return error;
+		}
+		else {
+			error = xfs_attr_node_addname_find_attr(dac);
 			if (error)
 				return error;
 
-			/*
-			 * Finish any deferred work items and roll the transaction once
-			 * more.  The goal here is to call node_addname with the inode
-			 * and transaction in the same state (inode locked and joined,
-			 * transaction clean) no matter how we got to this step.
-			 */
-			error = xfs_defer_finish(&args->trans);
+			error = xfs_attr_node_addname(dac);
 			if (error)
 				return error;
 
 			/*
-			 * Commit the current trans (including the inode) and
-			 * start a new one.
+			 * If addname was sucesfull, and we dont need to alloc
+			 * anymore blks, we're done.
 			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
+			if (!args->rmtblkno && !args->rmtblkno2)
 				return error;
 
-			goto node;
+			dac->dela_state = XFS_DAS_FOUND_NBLK;
+			return -EAGAIN;
 		}
-		else if (error)
-			return error;
 
-		/*
-		 * Commit the transaction that added the attr name so that
-		 * later routines can manage their own transactions.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
+		dac->dela_state = XFS_DAS_FOUND_LBLK;
+		return -EAGAIN;
 
+        case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
 		 * identified for its storage and copy the value.  This is done
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_set(args);
+
+		/* Open coded xfs_attr_rmtval_set without trans handling */
+		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+			if (args->rmtblkno > 0) {
+				error = xfs_attr_rmtval_find_space(dac);
+				if (error)
+					return error;
+			}
+		}
+
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+		if (dac->blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+
+			return -EAGAIN;
 		}
 
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+
 		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 			/*
 			 * Added a "remote" value, just clear the incomplete
@@ -395,22 +468,26 @@ xfs_attr_set_args(
 		 * Commit the flag value change and start the next trans in
 		 * series.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
-
+		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		return -EAGAIN;
+	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
 		 * "remote" value (if it exists).
 		 */
 		xfs_attr_restore_rmt_blk(args);
 
-		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_invalidate(args);
-			if (error)
-				return error;
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
 
-			error = xfs_attr_rmtval_remove(args);
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_LBLK;
+
+		/* fallthrough */
+	case XFS_DAS_RM_LBLK:
+		if (args->rmtblkno) {
+			error = __xfs_attr_rmtval_remove(dac);
 			if (error)
 				return error;
 		}
@@ -435,94 +512,117 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
-	}
-node:
 
+	case XFS_DAS_FOUND_NBLK:
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			/*
+			 * Open coded xfs_attr_rmtval_set without trans
+			 * handling
+			 */
+			error = xfs_attr_rmtval_find_space(dac);
+			if (error)
+				return error;
 
-	do {
-		error = xfs_attr_node_addname_find_attr(args, &state);
-		if (error)
-			return error;
-		error = xfs_attr_node_addname(args, state);
-	} while (error == -EAGAIN);
-	if (error)
-		return error;
+			/*
+			 * Roll through the "value", allocating blocks on disk
+			 * as required.  Set the state in case of -EAGAIN return
+			 * code
+			 */
+			dac->dela_state = XFS_DAS_ALLOC_NODE;
+		}
 
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
+		/* fallthrough */
+	case XFS_DAS_ALLOC_NODE:
+		if (args->rmtblkno > 0) {
+			if (dac->blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(dac);
+				if (error)
+					return error;
 
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
+				return -EAGAIN;
+			}
+
+			error = xfs_attr_rmtval_set_value(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete
+			 * flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+			retval = error;
+			goto out;
+		}
 
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 		/*
-		 * Added a "remote" value, just clear the incomplete flag.
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		retval = error;
-		goto out;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			goto out;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series
+		 */
+		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		return -EAGAIN;
 
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
+	case XFS_DAS_FLIP_NFLAG:
+		/*
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
+		 */
+		xfs_attr_restore_rmt_blk(args);
 
-	if (args->rmtblkno) {
 		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
 
-		error = xfs_attr_rmtval_remove(args);
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_NBLK;
+
+		/* fallthrough */
+	case XFS_DAS_RM_NBLK:
+		if (args->rmtblkno) {
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error)
+				return error;
+		}
+
+		error = xfs_attr_node_addname_work(dac);
+
+out:
+		if (state)
+			xfs_da_state_free(state);
 		if (error)
 			return error;
-	}
+		return retval;
 
-	error = xfs_attr_node_addname_work(args);
-out:
-	if (state)
-		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	default:
+		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		break;
+	}
 
+	return error;
 }
 
+
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
@@ -1034,18 +1134,18 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	struct xfs_da_args	*args,
-	struct xfs_da_state     **state)
+	struct xfs_delattr_context	*dac)
 {
-	int			retval;
+	struct xfs_da_args		*args = dac->da_args;
+	int				retval;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, state);
+	retval = xfs_attr_node_hasname(args, &dac->da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto out;
+		return retval;
 
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto out;
@@ -1071,8 +1171,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 out:
-	if (*state)
-		xfs_da_state_free(*state);
+	if (dac->da_state)
+		xfs_da_state_free(dac->da_state);
 	return retval;
 }
 
@@ -1085,20 +1185,24 @@ out:
  *
  * "Remote" attribute values confuse the issue and atomic rename operations
  * add a whole extra layer of confusion on top of that.
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ *returned.
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_state_blk		*blk;
+	int				error;
 
 	trace_xfs_attr_node_addname(args);
 
-	dp = args->dp;
-	blk = &state->path.blk[state->path.active-1];
+	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
 	error = xfs_attr3_leaf_add(blk->bp, state->args);
@@ -1114,18 +1218,15 @@ xfs_attr_node_addname(
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 
 			/*
-			 * Commit the node conversion and start the next
-			 * trans in the chain.
+			 * Now that we have converted the leaf to a node, we can
+			 * roll the transaction, and try xfs_attr3_leaf_add
+			 * again on re-entry.  No need to set dela_state to do
+			 * this. dela_state is still unset by this function at
+			 * this point.
 			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-
+			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		}
 
@@ -1138,9 +1239,7 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1157,8 +1256,9 @@ out:
 
 STATIC
 int xfs_attr_node_addname_work(
-	struct xfs_da_args		*args)
+	struct xfs_delattr_context	*dac)
 {
+	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 3154ef4..603887e 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -135,6 +135,233 @@ struct xfs_attr_list_context {
  *              v
  *            done
  *
+ *
+ * Below is a state machine diagram for attr set operations.
+ *
+ * It seems the challenge with undertanding this system comes from trying to
+ * absorb the state machine all at once, when really one should only be looking
+ * at it with in the context of a single function.  Once a state sensitive
+ * function is called, the idea is that it "takes ownership" of the
+ * statemachine. It isn't concerned with the states that may have belonged to
+ * it's calling parent.  Only the states relevant to itself or any other
+ * subroutines there in.  Once a calling function hands off the statemachine to
+ * a subroutine, it needs to respect the simple rule that it doesn't "own" the
+ * statemachine anymore, and it's the responsibility of that calling function to
+ * propagate the -EAGAIN back up the call stack.  Upon reentry, it is committed
+ * to re-calling that subroutine until it returns something other than -EAGAIN.
+ * Once that subroutine signals completion (by returning anything other than
+ * -EAGAIN), the calling function can resume using the statemachine.
+ *
+ *  xfs_attr_set_iter()
+ *              │
+ *              v
+ *   ┌─y─ has an attr fork?
+ *   │          |
+ *   │          n
+ *   │          |
+ *   │          V
+ *   │       add a fork
+ *   │          │
+ *   └──────────┤
+ *              │
+ *              V
+ *   ┌─y─ is shortform?
+ *   │          │
+ *   │          V
+ *   │   xfs_attr_set_fmt
+ *   │          |
+ *   │          V
+ *   │ xfs_attr_try_sf_addname
+ *   │          │
+ *   │          V
+ *   │      had enough ──y──> done
+ *   │        space?
+ *   n          │
+ *   │          n
+ *   │          │
+ *   │          V
+ *   │   transform to leaf
+ *   │          │
+ *   │          V
+ *   │   hold the leaf buffer
+ *   │          │
+ *   │          V
+ *   │     return -EAGAIN
+ *   │      Re-enter in
+ *   │       leaf form
+ *   │
+ *   └─> release leaf buffer
+ *          if needed
+ *              │
+ *              V
+ *   ┌───n── fork has
+ *   │      only 1 blk?
+ *   │          │
+ *   │          y
+ *   │          │
+ *   │          v
+ *   │ xfs_attr_leaf_try_add()
+ *   │          │
+ *   │          v
+ *   │      had enough ──────────────y───────────────┐
+ *   │        space?                                 │
+ *   │          │                                    │
+ *   │          n                                    │
+ *   │          │                                    │
+ *   │          v                                    │
+ *   │    return -EAGAIN                             │
+ *   │      re-enter in                              │
+ *   │        node form                              │
+ *   │          │                                    │
+ *   └──────────┤                                    │
+ *              │                                    │
+ *              V                                    │
+ * xfs_attr_node_addname_find_attr                   │
+ *        determines if this                         │
+ *       is create or rename                         │
+ *     find space to store attr                      │
+ *              │                                    │
+ *              v                                    │
+ *     xfs_attr_node_addname                         │
+ *              │                                    │
+ *              v                                    │
+ *   fits in a node leaf? ────n─────┐                │
+ *              │     ^             v                │
+ *              │     │        single leaf node?     │
+ *              │     │          │            │      │
+ *              y     │          y            n      │
+ *              │     │          │            │      │
+ *              v     │          v            v      │
+ *            update  │     grow the leaf  split if  │
+ *           hashvals └─── return -EAGAIN   needed   │
+ *              │          retry leaf add     │      │
+ *              │            on reentry       │      │
+ *              ├─────────────────────────────┘      │
+ *              │                                    │
+ *              v                                    │
+ *         need to alloc                             │
+ *   ┌─y── or flip flag?                             │
+ *   │          │                                    │
+ *   │          n                                    │
+ *   │          │                                    │
+ *   │          v                                    │
+ *   │         done                                  │
+ *   │                                               │
+ *   │                                               │
+ *   │         XFS_DAS_FOUND_LBLK <──────────────────┘
+ *   │                  │
+ *   │                  V
+ *   │        xfs_attr_leaf_addname()
+ *   │                  │
+ *   │                  v
+ *   │      ┌──first time through?
+ *   │      │          │
+ *   │      │          y
+ *   │      │          │
+ *   │      n          v
+ *   │      │    if we have rmt blks
+ *   │      │    find space for them
+ *   │      │          │
+ *   │      └──────────┤
+ *   │                 │
+ *   │                 v
+ *   │            still have
+ *   │      ┌─n─ blks to alloc? <──┐
+ *   │      │          │           │
+ *   │      │          y           │
+ *   │      │          │           │
+ *   │      │          v           │
+ *   │      │     alloc one blk    │
+ *   │      │     return -EAGAIN ──┘
+ *   │      │    re-enter with one
+ *   │      │    less blk to alloc
+ *   │      │
+ *   │      │
+ *   │      └───> set the rmt
+ *   │               value
+ *   │                 │
+ *   │                 v
+ *   │               was this
+ *   │              a rename? ──n─┐
+ *   │                 │          │
+ *   │                 y          │
+ *   │                 │          │
+ *   │                 v          │
+ *   │           flip incomplete  │
+ *   │               flag         │
+ *   │                 │          │
+ *   │                 v          │
+ *   │         XFS_DAS_FLIP_LFLAG │
+ *   │                 │          │
+ *   │                 v          │
+ *   │               remove       │
+ *   │        ┌───> old name      │
+ *   │        │        │          │
+ *   │ XFS_DAS_RM_LBLK │          │
+ *   │        ^        │          │
+ *   │        │        v          │
+ *   │        └──y── more to      │
+ *   │               remove       │
+ *   │                 │          │
+ *   │                 n          │
+ *   │                 │          │
+ *   │                 v          │
+ *   │                done <──────┘
+ *   │
+ *   └──────> XFS_DAS_FOUND_NBLK
+ *                     │
+ *                     v
+ *       ┌─────n──  need to
+ *       │        alloc blks?
+ *       │             │
+ *       │             y
+ *       │             │
+ *       │             v
+ *       │        find space
+ *       │             │
+ *       │             v
+ *       │  ┌─>XFS_DAS_ALLOC_NODE
+ *       │  │          │
+ *       │  │          v
+ *       │  │      alloc blk
+ *       │  │          │
+ *       │  │          v
+ *       │  └──y── need to alloc
+ *       │         more blocks?
+ *       │             │
+ *       │             n
+ *       │             │
+ *       │             v
+ *       │      set the rmt value
+ *       │             │
+ *       │             v
+ *       │          was this
+ *       └────────> a rename? ──n─┐
+ *                     │          │
+ *                     y          │
+ *                     │          │
+ *                     v          │
+ *               flip incomplete  │
+ *                   flag         │
+ *                     │          │
+ *                     v          │
+ *             XFS_DAS_FLIP_NFLAG │
+ *                     │          │
+ *                     v          │
+ *                   remove       │
+ *        ┌────────> old name     │
+ *        │            │          │
+ *  XFS_DAS_RM_NBLK    │          │
+ *        ^            │          │
+ *        │            v          │
+ *        └──────y── more to      │
+ *                   remove       │
+ *                     │          │
+ *                     n          │
+ *                     │          │
+ *                     v          │
+ *                    done <──────┘
+ *
  */
 
 /*
@@ -149,12 +376,20 @@ struct xfs_attr_list_context {
 enum xfs_delattr_state {
 	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
 	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
+	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
+	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
+	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
+	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
+	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
 };
 
 /*
  * Defines for xfs_delattr_context.flags
  */
 #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -162,6 +397,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
 	struct xfs_da_state     *da_state;
 
@@ -188,7 +428,6 @@ int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
-int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index dd4f244..628ab42 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -440,7 +440,7 @@ xfs_attr_rmtval_get(
  * Find a "hole" in the attribute address space large enough for us to drop the
  * new attribute's value into
  */
-STATIC int
+int
 xfs_attr_rmt_find_hole(
 	struct xfs_da_args	*args)
 {
@@ -467,7 +467,7 @@ xfs_attr_rmt_find_hole(
 	return 0;
 }
 
-STATIC int
+int
 xfs_attr_rmtval_set_value(
 	struct xfs_da_args	*args)
 {
@@ -627,6 +627,69 @@ xfs_attr_rmtval_set(
 }
 
 /*
+ * Find a hole for the attr and store it in the delayed attr context.  This
+ * initializes the context to roll through allocating an attr extent for a
+ * delayed attr operation
+ */
+int
+xfs_attr_rmtval_find_space(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_bmbt_irec		*map = &dac->map;
+	int				error;
+
+	dac->lblkno = 0;
+	dac->blkcnt = 0;
+	args->rmtblkcnt = 0;
+	args->rmtblkno = 0;
+	memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+	error = xfs_attr_rmt_find_hole(args);
+	if (error)
+		return error;
+
+	dac->blkcnt = args->rmtblkcnt;
+	dac->lblkno = args->rmtblkno;
+
+	return 0;
+}
+
+/*
+ * Write one block of the value associated with an attribute into the
+ * out-of-line buffer that we have defined for it. This is similar to a subset
+ * of xfs_attr_rmtval_set, but records the current block to the delayed attr
+ * context, and leaves transaction handling to the caller.
+ */
+int
+xfs_attr_rmtval_set_blk(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_bmbt_irec		*map = &dac->map;
+	int nmap;
+	int error;
+
+	nmap = 1;
+	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
+				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+				map, &nmap);
+	if (error)
+		return error;
+
+	ASSERT(nmap == 1);
+	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+	       (map->br_startblock != HOLESTARTBLOCK));
+
+	/* roll attribute extent map forwards */
+	dac->lblkno += map->br_blockcount;
+	dac->blkcnt -= map->br_blockcount;
+
+	return 0;
+}
+
+/*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
  */
@@ -668,37 +731,6 @@ xfs_attr_rmtval_invalidate(
 }
 
 /*
- * Remove the value associated with an attribute by deleting the
- * out-of-line buffer that it is stored on.
- */
-int
-xfs_attr_rmtval_remove(
-	struct xfs_da_args		*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac  = {
-		.da_args	= args,
-	};
-
-	trace_xfs_attr_rmtval_remove(args);
-
-	/*
-	 * Keep de-allocating extents until the remote-value region is gone.
-	 */
-	do {
-		error = __xfs_attr_rmtval_remove(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-	} while (true);
-
-	return error;
-}
-
-/*
  * Remove the value associated with an attribute by deleting the out-of-line
  * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
  * transaction and re-call the function
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 002fd30..8ad68d5 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -10,9 +10,12 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
 int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

