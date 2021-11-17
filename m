Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE2AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC69F61A3A
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhKQEQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:56 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15058 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhKQEQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:53 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2u8cB023615
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=lyZr8ZR7meKQDVJuLCfKJ1Kibo8kO8sJWO78Vpq11HQ=;
 b=GzEXwinUB9lBn0mL+0dmM2g3ywFJhVzqRoExbvW8UZaZrgpT52J8Ws3DvA5d/TVZ2T0x
 ycSCmUErhUV6i7Su7Ft6PXmpGBgs2B7Hszjo5mVJld58BOBo7sZKVZtpFNBH95Vy+ZkM
 4KBEzcK1/qru9CWV7hsMt+w2RfhkLUiqznkZ2PjEV+b6AikRSAVKge0o3P0UDW2sa+Hc
 qAd+M8S6WMKz99mZCiR4iLT5ESjrlv0ACfDwPMnI0h9YQAWB+t8svonDh1GvNsa9WTG1
 LEBgBTaq1KRTKNpeEo0rlj2YEWcmHTi653PuHim7jXJ9BE7a9k+kiknfekFuLgm0xu2C jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbfjxwwma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEJY180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3ca2fx68vt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqgUG2xgdu1vuBBFL/+cclk5FMvz17tutU9q8M/9Jynd454Qu29a3fvu8wmywBXNhhbc//nbB4ewZtzXwn11k/1VGbo5N+4yQz2bjUCMHkdhCtvXhrdzHAbIqK3qNBr2O07RVa1kFyUc4wShhi9j3umYu0ztXArjhjBhDOiXeYHYG66gvwg3AQznUFqsHdM14DN+i0mYDmDzasdZgw9dB/4RYIl6n4XKhKvRHUZ3YNyan6PmyFMR7ns5VdVd2+S3wc2Jg6UkMUXbokH684pzNZh/DSu3NSE6FC5PimLBhap9TnzbxTmrzM6crpoy4JyTgeUUU3R0sSADDX7oUmQiMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyZr8ZR7meKQDVJuLCfKJ1Kibo8kO8sJWO78Vpq11HQ=;
 b=IoZj3PTrtoB2CM+2W9/pZnyVU6V1U6LuQ/cn7OlE+VwY79Uuv1sca2QBHtYpjFFD95Lks+SRfcj3Su8PPuKt4vFYmuOB/Gs2GwTk5RdnWn44WjcSQGThUogsulbnkAUTPG6aC1ZCKPZ8ezOJe7IgqaXZD+Uj3P3Kw1SVNUiDwFPJbJ7hBryxpYsCKa15U5O0M5yw8R0brBCJYZP0kjv0RhhZWTUD6tg9vIGXTP2gX4DjKSH9f0XLxObq6OALCWFjODnjvqmHQcApj0aRQYZD1rve0rWuBiizu7+1/h962g8Xo7fK9fkSmHKoNUUaZgiLaRViaxaJ7m4fAnf8I7i4aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyZr8ZR7meKQDVJuLCfKJ1Kibo8kO8sJWO78Vpq11HQ=;
 b=mlVdDJVdoR5AwXGVWjYdgHTrng+i7jstZ/+po+Ci9eLzSF2cQPQrq5g8Ckbglwb1wevFRr3wGWrf0bHpQke9ILYgFfAy97K1Pw5Y/fv99oJyuGd6SlihSRNTlNVe4hMGerKquoOpBuTraxM+0xUx3ZDTVqH/7jG436uBfheK6dM=
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
Subject: [PATCH v25 08/12] xfs: Remove unused xfs_attr_*_args
Date:   Tue, 16 Nov 2021 21:13:39 -0700
Message-Id: <20211117041343.3050202-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb33d6a2-ebe3-4436-6757-08d9a980a96b
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3921B43DC5A97120771CADB2959A9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7QmJX8oms5CXhvza5sFx7YBnPxiRTSRnELa2tq4hZGbB9moPOIFnv0uOc8lBX8U434lbb9Up9EtyYA+Erz3XsSOKOwGVf8UY3itbknC9hDu31LYENRWRI6RXYHd5JvzZEUuOfz4mXnwGHnv5nJQh9U6mpJTz9RIO/j9cS7glTV5Audr0nNrdt7CzvdR43OHmvoG0VJ6WiJTSvSUYDASFprV0v8Jjzi+twyfK5wJ9eWi64IbgOiYCYPOnkblKj1uni8uiPayMLMbesWFZixl+sBMxi5VJsNaV5lFAlxpMTNqhnmggFtSmcJoBBRkvmEoIndXbempPbWJ2MeakTtxfd2J1+9vLdmnJQCeA43xROHanutSVNzGufBlZF/Gz2sP782AwjjhLVTVuE8YPj5q++6SdG3Ta+zmbqU8ZmoA6/UL9C30odmgT2f4ouCV4a5p6fdMdbvSHdHHAaajsW+h62CKMTiPWAUey4rmh0KSlil/XiWQezmbTWhF42ETgTdCCoCZMeHSlAEWYStBl9ntYP0bma5fbjDbdZFqUVrkzVsOm0Dw95x84f1KDiiK8vARrBWR/moiRnEsB3ac60keyOBv4gK0+wCZ4up/JOTonNEzsnEFLOC6rMlMYvQBXKKuugYMIUQGb0eRtLw0dh3khpOKYBrbAmV9jXFHeZWDozMYPm7I6IJuvq09sGB0mGqETWZ0I4rpWqsgoQEhg5CKyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38350700002)(6506007)(2616005)(86362001)(6512007)(5660300002)(8676002)(2906002)(36756003)(83380400001)(508600001)(52116002)(186003)(66946007)(38100700002)(6486002)(316002)(6666004)(44832011)(66556008)(1076003)(66476007)(6916009)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?te5g8cb0tIE2A5vMdtrJ4jt//wJ/PwprpySLEVcQYsfsBAs9STD1T7i8wl8b?=
 =?us-ascii?Q?mqK9THHcyICmHL2yKleyE0X7NT6xjeD0YC6v70+ochcFRdGQy1mddWyEOAEI?=
 =?us-ascii?Q?Ydis4aYPk+IjbC3fxJAXh0gyoWlsVUBLYYnulN4+jIJXd+4iK0NaCjy5T4w6?=
 =?us-ascii?Q?wZRhlvLD7Y3AKmKOi/3ds3rUWq5iggE099PJZ1relzJpd1LGBP7QVZCBeS0t?=
 =?us-ascii?Q?Ya7vh7IkeJ+e2ScCfVQeVA8cU9hy5FaHGOTVfZzbP9GqYOQzRxy6radScbTo?=
 =?us-ascii?Q?BKrd8+RxK9AnJI06Uh89y1JxSZfHr5fH6t10w+cGJ57iGcFfbHe5Z7j630cg?=
 =?us-ascii?Q?rNlEvw35ptUw0eUhfLky/y6WZfbSuV8kLPC6x8B2Y5ts7c6yLr9nJTFwsv0/?=
 =?us-ascii?Q?5floJ6VG0EJQ96wXZKDAhKOtOE2NxhplJ+elQMI34W6EoHjbndgUffKa9Pxl?=
 =?us-ascii?Q?Kacu2MZFnrIFdT2Fravn7Wmwuxo1z916/wvTP58jxV4uqFcFvAwuVSkCSefm?=
 =?us-ascii?Q?ORXFzMlRxRFaqlqwBSOnVzzKJ/r+OhlyLIobcsjtUz00TCZ82Pkszo5c/u8M?=
 =?us-ascii?Q?mULd2Wvk82vRWihl9lpgMtfeNJghAVtO1Jcw93rxhz9VNOik9Nid+IJ+GBy9?=
 =?us-ascii?Q?235TnokbwwIY0NJ9+FEzuyfLdXNn0F0q8d/99WDepxRg4vNNg+/hZO53Hm5k?=
 =?us-ascii?Q?vTPIhIbWlVqY4NIqrmub+z7jTpthdxR/cvaAYJRGDu7uLMT+4TU3YV1dnhdv?=
 =?us-ascii?Q?kUbupuPdUduCQc4EXPzJsaA8lb+KnzAWJs76pMhUgQwOnvrryQtRnm9wfwqI?=
 =?us-ascii?Q?/py2tIERAJkzFbSIt55JR6hHStbnI6HExLBWEYCwRCwG8znIG2WCcVZl477/?=
 =?us-ascii?Q?m4lkvJEpptfYzxhPFCxVY0s+GLNKP+jIeYtasW82GVaO1hvO8W75kpHw6Wt9?=
 =?us-ascii?Q?OpihbSPbsn/dosdqtalvvvD9qEP27hRMV4aL3JziFmRdm9xSnqHxXO6Rrpll?=
 =?us-ascii?Q?q//JvW3g+hkMyGv1CBAYZoKlUIamtI9G3XVU3DIn2Wx4tel5RMxphtYoHLNn?=
 =?us-ascii?Q?/sdQ1UQV5aMYpwFlM9QhFcjgdoEQbnXC51Mlea+SusN3He4Ks8voRdfGcTf5?=
 =?us-ascii?Q?4FBCm9MXr+Gg4AowXw7GCbi4++d745OxRCMzndjuEzDWDdWyrTj+N9wcnBIz?=
 =?us-ascii?Q?VU3Lz8py/knh33a1TACzULnvvtlqmFUotEKwpNb1CgSJwv80J0fyNLDvuTMw?=
 =?us-ascii?Q?rZ16A7NLFSLb2pVutDQ00cijEgp/X/sBD3z12o6MCicEgdA/CLysjWK3VFD4?=
 =?us-ascii?Q?sHWc2t06nITWhgmKmrp+EQALQeeNIKFtbm5RAQ/oLm+bHxLbR/ewaapWWneG?=
 =?us-ascii?Q?NJHSSyHnuJ1whE61fRQoh5nRY+CGCzqXKbHBWVOx+T4RX1mJlcZzQY9cQ6lg?=
 =?us-ascii?Q?CxR5+fO++RNNf14eTPGcLntKYnR4UwbUz0Tc31hrWtoSbqLiXvSYEthK/NXe?=
 =?us-ascii?Q?loi40uw8uGS/ZKBPKJJXxWgMW4xXO+6/h/lnRJrx/H3Q/6VcherVW9hUAetF?=
 =?us-ascii?Q?1n/zBIV0WjBjqUMzKZ5XzzIS8p/6hGLPV7pxKttXuFBlYthmcbT6ST1ol+vl?=
 =?us-ascii?Q?k31YCuj8KDb8Jdnb/Q0zPpERUTI7uZU7uTa/jjT3wQLlluQZBn4tWeB5dzpC?=
 =?us-ascii?Q?3rbvLA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb33d6a2-ebe3-4436-6757-08d9a980a96b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:51.4057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HI2jzYqU7GGwDdpKtMX2GaphaXfbbcnImoAnFeQ0ZCiGzPZusNjJZE1sD97bjpPUGyNmrlOOG11b+ppUmyNdP1QKiU8o6JFxp4FgHnUwl/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: AEgM_MLgLdnPyrrxnbqQJxZaYuiAQBNS
X-Proofpoint-GUID: AEgM_MLgLdnPyrrxnbqQJxZaYuiAQBNS
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
 fs/xfs/xfs_attr_item.c          |   6 +-
 4 files changed, 13 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2bdd1517e417..1186c0702a0f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -244,64 +244,9 @@ xfs_attr_is_shortform(
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
@@ -320,7 +265,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
 	if (error)
 		return error;
 
@@ -329,7 +274,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, dac->leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -337,7 +282,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -350,8 +294,7 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -370,14 +313,14 @@ xfs_attr_set_iter(
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
@@ -396,7 +339,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -687,32 +629,6 @@ xfs_attr_lookup(
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
@@ -1275,7 +1191,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1290,7 +1205,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1544,7 +1458,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
@@ -1572,7 +1485,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 8eb1da085a13..977434f343a1 100644
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
index 5d0ab9a8504e..950ccbc9918a 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -267,7 +267,6 @@ STATIC int
 xfs_trans_attr_finish_update(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -277,7 +276,7 @@ xfs_trans_attr_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -387,7 +386,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
+	error = xfs_trans_attr_finish_update(dac, done_item,
 					     attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
@@ -547,7 +546,6 @@ xfs_attri_item_recover(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
-					   &attr->xattri_dac.leaf_bp,
 					   attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
-- 
2.25.1

