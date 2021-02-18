Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9E4C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C82261606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhBRSrw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbhBRQyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngmr069610
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=clKcZJdLjHg6bd50Fr+2oNJzg5EPFjZgxeEk/SRh8pc=;
 b=C7GqT4hKWijXp5jhQJHYo6l70j+9Z2qBoJsQ8Oiv6nv9WK/594ZQKYc+cM6zoor6KDSC
 RbcdmsnmRqcYXJgmJalSdUduOfkagGvas/NTm5UXGl+OzDOBya6HWZ+imOzjqQZXEEwo
 RjQCAy0kWbHSfObFxGw0u1w24plZj/ntynN2kAiTWTnCl6z1P1+mV+Bz7KaISQGr/0f4
 ztEVeg36+8T0WS7wzaToeC/tUasbh8oP0WLVf9+w/QFJ5/2AkRgk2Em+31pYqxWCSXGd
 g4xrO7I69qSrhrZeGR1UAAPViTJHa+b4OsSPTYHiTZsHniQSkC/Hta4miTyyqE6nPYeQ LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngUl162355
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 36prhufdh3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaI2Q5pmtclLIx3wOSGzCCnxKtJbp6ybhL9SZ8levwwD30Xv2JU4jcecGmMoDfRocJN5YzzQAL9qYnoXZAuTgcU7RzUsxyR65pkc/vVfwwOdPLWsu7BznqJOXd1Q5Dog6VyYFnLELGfHmc4nwMu4PXbLkJ2RsqHoJva51TgVKYKULS4PxTwpl8Cc3B39m1MkriDqvL5kAyMzZ0lRnQywL1JyPBn+8HGm061acnP5tHBEaKPlPyMh3zbh5Vx8ymzCrRKFSGNknt0z5u57XpHAcEMnlAROIljHfNf1xXB+atG8Rps1POIILhua/9urc6jmydRulfMpTwCIz0tl3WmuLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clKcZJdLjHg6bd50Fr+2oNJzg5EPFjZgxeEk/SRh8pc=;
 b=CcIDHIWXexQelpSh6A/0Roj4Uc2LXVE6Xqy2cYUm8CClmC2aNQ1x6gprr8YZ20yKDgVKe4bE1bGXP+A55C6KzY5IefKLkmlqzMG/zeIKm78NcE5vCrM8hND5F6GyWLldFufkPIZO3M4XpFBAv8PPf1Ne9TH4lDzcLZ8qHnT5oBoGo3g2qzEu82i6mJdtdkDMio4W7TOc3Wz4EG9FrQs+PqkhrsfoxcIBud8wFcCTCDO++GGDLPAGuiEo3rKFpXt8hMIVFoKjhTPKlg2LZ4wbJSMO1iU6He6xyotW81YzGLqoUULQrsU7qoodjrDWVCEW8uDPy5UJuxPWg510u+YHiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clKcZJdLjHg6bd50Fr+2oNJzg5EPFjZgxeEk/SRh8pc=;
 b=GtbboYDuT8bJfRBuic3XTgelR9+msbVU34h5au00JJUyLYBesAM1+DV586Zw4mNIwOa1hIew+z0rMi9Nkqic81R5DoqWYMoZBGOHvFdG8/zdCxQjSBwSASGsa3B1ZOTy4QwIMLFXEfxfLRFjKE36LNnyuBx4J9ko+c3wTeUJeh4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4161.namprd10.prod.outlook.com (2603:10b6:a03:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:54:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:03 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 02/22] xfs: Add xfs_attr_node_remove_cleanup
Date:   Thu, 18 Feb 2021 09:53:28 -0700
Message-Id: <20210218165348.4754-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11429e4e-5d23-4415-f951-08d8d42dcc1e
X-MS-TrafficTypeDiagnostic: BY5PR10MB4161:
X-Microsoft-Antispam-PRVS: <BY5PR10MB41612D5444D74F36086B67B695859@BY5PR10MB4161.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zRXtuwsI6p3i2GaljjBajq+vsTFoD6UYdt4TwNOeoyXEg0ecGUhjLxHPG1PPFldbXoej41I7pDEGY1V7w+swjNPEPsDRFjugQ4oPyqEtIhCVqZVmmjLx96uU0oc3RoSfNRyWBYDl0bj6K8BM6+pbylSQ2WlGgvQeBcmcSP+NYxEVou1521w6mz4W6TJnmwUvMBpnbNFsyq0jn6kQdENMO4ZohFfW/IE+Dik1sJA+v+U+hNv4y1MN3JC289RQIfzGfMzr47sZvYAIKWYMepZ8mEp9TyUF5fwbycZDaT5sgIB9Ch36T3zSi+wkR11Z11AXx1e25vp8UT2tjK26Zc/2BJHJK67QhkkuthYzPyiahrKcvgzXJ8vfZuAO87ZDq5r2z8h6Ag2Ey0jk7nrMV0+w/Downifzt8lK+EGmROiYkuG7Hhr50j0yXUjytZiZgf0UGhGxgBZExukAzgSXMGxgEZY0C8idB48jtssUXJKOmg7F8IE5OBOrh1fiG5S/3xh2B1InDaDNGzH45lhFj1xVMfgEMOg/BkXqy/0Jme5lM+VMUk8aX+Noa8vD6WGLawt47etrh7CdPLoz+B9kPVnlfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16526019)(66556008)(6506007)(478600001)(5660300002)(956004)(69590400012)(26005)(6486002)(83380400001)(66476007)(186003)(66946007)(2616005)(52116002)(6512007)(1076003)(6666004)(316002)(8676002)(8936002)(6916009)(36756003)(2906002)(86362001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LGwwttblWOPY9xAnE3WtAL7MhZjAJCxg6TRxAeUg9YxcGBly1k0kqcfNbIWd?=
 =?us-ascii?Q?aOPM4oK2vmbnK0r6egMPxBELSqkhVVDrOZzwsKQGviNjcJCpwjYIGyoZabUt?=
 =?us-ascii?Q?I5XUcDSlsQ/B48n9K39vcg55nepdvQfemLm8ekCvM5+mo9W1bCU7UNkLmNnB?=
 =?us-ascii?Q?9/bLcrx+oFOQA9966N3gLfsfeBrVskUVe09FsoB2kVpdw/sPKjHAlm9bgUan?=
 =?us-ascii?Q?Cwf8SCVHE7OP/1G9VErG9AG2x/1J8CCfLmukzHVFF2QoqoF2S7zWKJZpA7Df?=
 =?us-ascii?Q?FpvGukfMYkIwSwmvlFw1BW++p8esxYBk5PrmSfDTrvlhjaUGexVre9hgGnnl?=
 =?us-ascii?Q?TnOeYthvIlAqV9Kq1MPwcBjy6d9TZNNu3GmLpJPRrTTrFRXipLGWv83djrTW?=
 =?us-ascii?Q?KLybFAWftCoYGl8ia1kiN6CvRH4r8X8mXuNgZQ1WHX60FL78dFa9eCBrgSdI?=
 =?us-ascii?Q?W+rIBkzJ0kK1Imyra+2abzzmV02NfEZz2H2ysalIewGEIXOnq9xHA3hqaWno?=
 =?us-ascii?Q?0gNsGnFogJYL/PukIiK64Xd5T8uU6ey0j8/Z5rpj64cXdiZzhWBeT4Kr5RYT?=
 =?us-ascii?Q?nqUmsLpQOhiP9684BWiMwr3yn2+OmZRw517yf5ZSfyokQdT0ZcsFLeeS4d5r?=
 =?us-ascii?Q?E2tQOr8+o0FUoROBOnlC6WLG4g5UT93OS17lbhCMl/u45zbx7WntgwOZ4/rV?=
 =?us-ascii?Q?0BQAsaoHIitr+o72C04pnSbKvKNnIp+HFmuJ/nvmMT+P3wS/cty+l4KPPqUf?=
 =?us-ascii?Q?u2IpeND35TScQUuFsvvvg30XSaUWS9BG+9c59dFXNFSNc5NRSLr0lchEEtLE?=
 =?us-ascii?Q?3jFZRBQWvQ5wolxPTej+e+/bQH9pMofyfnrLCNlSAYs9JtKXQ51T1x1/kvzo?=
 =?us-ascii?Q?98zj7kgQMAQy7KLBQjH5cE3692C1mSomr5Rh/DBdT2P/0sPx5mBIhRGCdgRw?=
 =?us-ascii?Q?xrNMPnwX+CgFcsY84rnK6PKG7iAaANf9D2aw3MekxbcA2kH8cLpJRTPz5RkC?=
 =?us-ascii?Q?rVqCDKS9OSsxWEQnpqmMXWyIo9M+BcfF00bVnhXOAomEgQDaWl/WDR8rYx0r?=
 =?us-ascii?Q?UTJgZA13dQSoAaIzubaTYzuFJ5r2G0oduT2n3/AfXiqCHohb+EUXZgUU1oam?=
 =?us-ascii?Q?95WzrSrVdxbAflxOv13PYOfy5DYjw5nZ/oMVI1x5ElRwvU/ephK/8c529CH/?=
 =?us-ascii?Q?EFg5Dhd7NI9MECkwgYrqw+5nIMYcRqrMOXQ7/tWZO3JFTDoaIOOEuGA70U1C?=
 =?us-ascii?Q?KzQkaWlhG3xwIilZ3euJP8sRomLQ4WBgiATk39G1M6HBBQMPnepDoA7yGJ3/?=
 =?us-ascii?Q?47UpGIW7PoXYLOk52XPsCSCb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11429e4e-5d23-4415-f951-08d8d42dcc1e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:03.7358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dFr8+PUWq7z2/R4Xql+98yDrU4iPbshs+4fBbawcW57jupd9pUrUTnnjJUWY7hYx5dunDuoFENHLpaDQ7i6+z0iWWvs+2DJXB/Z7l2eOKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4161
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch pulls a new helper function xfs_attr_node_remove_cleanup out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 28ff93d..4e6c89d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1220,6 +1220,25 @@ xfs_attr_node_remove_rmt(
 	return xfs_attr_refillstate(state);
 }
 
+STATIC int
+xfs_attr_node_remove_cleanup(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1232,7 +1251,6 @@ xfs_attr_node_remove_step(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1247,14 +1265,7 @@ xfs_attr_node_remove_step(
 		if (error)
 			return error;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_cleanup(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

