Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36517C47089
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B3F161420
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhEYT5J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbhEYT5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnOWM034966
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=szvJfbvwmwL0QODj5H3eGmNFZ2raelHNU9VAKOWXOIU=;
 b=TpSlQgrGJMsyphzsEn/UpRprKJJwLR3IU6sbC+/KFodg71EcuHif7R8ZswVgv24bE43g
 hDFVB9IErHRBx1t7RC/3Jqtv932in/XRlCaddc12cYC0xwlaPVI/d8mvArA3Ak/mM6e2
 Btev2L6bKz2jdso27v9vNCqvGOgr21SD9YMKdKMxDULXnUMWWu3kjbijEpkuzIvbsFp3
 /ybKSp0Lq8Gtcl82QymQmyXptX3TvkF6Ag0TSe3Zx31quKZozjbmDlsb5GN/u8RYdf5y
 HgSsgCbkyQa0NYDDhNvqbumm25roz5oRDmLOulaM/GMCxt/EQz1jDdvYl70xuAx7G4At GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xkjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoDih188864
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3020.oracle.com with ESMTP id 38qbqsjk14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wp8eAAhBh5/PlrBya5sIRRmQu5nZ95mRgIewEQ92b9D1jvpXbYezStL1jI1R16DXlIk2di8Lk6KhG1+N2/aQAvtswQJZxVsN1AlGbWFVH/U8fhDo+X85TT25+wuupUkVG9qmnkoIpKBVdZWDokURUgGO8iYnW2j9orrqtXXkUMBtXMEx9YQ2hKsaQ1eYm9npGIq7VAHwknNmleuYU8O2oQSgxGktDnc5ETbtLE0w41p7YTkm2P3I4qwJib1RlvGFxDhfH8embOzn1ZFrcNyQrXbPvGWY4Qz8xLJKrvY20+6RXBPxXLK0BHIGb39UOsPAXZ3z9LHigkRYm4zGv0aijg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szvJfbvwmwL0QODj5H3eGmNFZ2raelHNU9VAKOWXOIU=;
 b=XHHHx71ChNVDjs9lgVvlg3404YEen1a3IZDDPtj2lY+EKlnTHBiYn+MLOKMsn1wX36M808fAv+PkuiJw0mo9HKWbIb2Wo08RZ3M73uHXSzfEBcE6IJ+Q1f+1TYCFdBgTZb+6dKLiIZqMaT55MJdflmJjL15g2C3V1DYQmrZpyg8XVjSE1SLIBzN8mh1DN+QL+tKENzvb82+9JoyE/OGKbhrLnlbP08bdY2h+ksoREhm9qiEf5x7TvQSa6Schem4F5C5EjYfesQupcA7Bmc28GJPlIc1vHbmeLzc+Jy56XJxsBWvkqgmMzhRk60KZoNtfaityME5nHOTkZo9EjLCm3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szvJfbvwmwL0QODj5H3eGmNFZ2raelHNU9VAKOWXOIU=;
 b=g3Za/MAWNI6N9hPfk+ZuPVyLKiavhf6U4hgyOxCWmuo+dhveQnXIo5EWd2dHIXJkbjy1Rb5Bavi/bKOuL1p5XiEeYmEDIlJQukKRcCkBQQLFO1aKXfggZcynCFJ/Fb6o3GEeYkdGO++POnUzOnS/eoHUXPIqJ4mQbUH3lcWm5UA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 19:55:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 05/14] xfs: Add helper xfs_attr_node_addname_find_attr
Date:   Tue, 25 May 2021 12:54:55 -0700
Message-Id: <20210525195504.7332-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52de8ee4-e386-435a-193e-08d91fb70b4e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4544:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB454465EA27A2711BF36A509595259@SJ0PR10MB4544.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0EPJ46sSFTRP6CLC97qmGa/oaYCoFiYtk3vVKO1wuph6vLO58qmmsBOz/tKncehjPqV6THWBdYVgu8aDTJK0ht4WWC5xweT27ispwoNAsB+G9lqh/0DmX31SmenN+MWn12hKmj+hDzphJ7AjwhMUAkmRfJwds9W9yyTHuihKUYIyNe6KFA00ReBcQeL+yrMoCsS0bBXx+1ZGyF8kh3Z7RiZRIsl6LrdHEgMqcFxcKoPuoUH4iQwfBb+hiL8LO9CeGXIB/un3CKJy3Wk/1HfDguGB/yoOpf1psbyhJqVgEuT7b2nmGwRTPWKn99N5onm+y7ZNrHLk7O8kDoJU1KSnAHwVIROVdJbDA7PxP11I1aqtim8j+XQJ2Cz27YA82CKXppUyYfdAA0lDGW05s2NS8p2IRDW94CfgiMfwkYnDJAvClKiTjPqVDE07ZyrW6hnnQ5BZNFudw4iqXJulIu3EMEG90jufWsmJe1SsR3XcTLhs5juIg4BmiQHzX5JC8xMziFHExlQOb1ue2lKgVOFjcKU5kElQKmhj27uCBRJTugCbfuICtvFETsimj1JQoMrNonpP60So9jxiWQRyUGedTr69SYy2OcVbnuP0BOghLvoHMoXq2+T9ED2G9CO86xXiACTuU7qOrEeABMvQJH/mTLm+NsF+Ub4bD9El/ag02EE8FNHe99Y1lOi0TcfFICz3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(396003)(136003)(376002)(2616005)(52116002)(5660300002)(956004)(478600001)(186003)(83380400001)(6486002)(66476007)(36756003)(2906002)(44832011)(38350700002)(66556008)(66946007)(26005)(6916009)(86362001)(38100700002)(1076003)(16526019)(6506007)(6666004)(8676002)(8936002)(6512007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fBCPqmTlY8bZmshjvpBcQy0DRY+lsK4wh3UJdk7l07PIMCSgvgPlR/nIWiLY?=
 =?us-ascii?Q?GoDn8X5Icb8HhBFwlRv7FzhxuRd7E9hT2XuZh0XG9a5/znSnTgyPidzKGey7?=
 =?us-ascii?Q?Rg2YBudJpNP5feuzRG2fDpaoKiv7Fzk6MxSXf4MAIQ8EW1VbuqdpFB6v9CQ7?=
 =?us-ascii?Q?PsxBrJ5k4oaH3OxDgaglaLk+186PQ14D7qMvh6IO3t9JItN+ofqLvaVhdeeh?=
 =?us-ascii?Q?NrZCTqQvtBzx+K4a1k9CjfJ+jiQZGCqgB9TQZ8oqtJEnGF+dpPaSozyr4g62?=
 =?us-ascii?Q?vp91Mlcql2Jkr7AsnzrJ9ateRNbaKUTIYohRPFZrAaJ3kykaozz05uaLqOB9?=
 =?us-ascii?Q?d4kXkIjtHY7qAJx83+9jTx9vWtBFZ1/oBsJBZFwsVcTqKN2kgIxkpsM2iBe8?=
 =?us-ascii?Q?7c7ppxOFhBwXokuLDUJ3gfZOssBWS+mF3VyjGhxjVR9VVtUUloCp+uZGCqbw?=
 =?us-ascii?Q?Zr9ARqljBMkM9sP1H5S9GE1PGP2Evvw00jM3xVCwG1PlFZ6v6Pv3WWn+eNcV?=
 =?us-ascii?Q?nYsxrBP/o/4jFpU6pGKjXPkQHmEQzsID+gRSjv8fv7iMbu9cpwFiFB1LQ7gO?=
 =?us-ascii?Q?DjIoqG+0r8oj2Xb41o/N0Hkl6IrOKdopjSdeddM0VqyURvdOXXw7KQQGJRoN?=
 =?us-ascii?Q?HmePOIS9EjtIdSa4fYd05tPUaDEe3ouAy1PVYymHNGoPPU5C4dp7xscDeIk3?=
 =?us-ascii?Q?YIIG1m0vzyy4G0cGheMG631pC0bz2fIBgV5AHZnE6+2kVjhrF9zhe9li0VWi?=
 =?us-ascii?Q?mqAHHyDBcCcQH4Dorcw3PUv1xMlwea+RHB/lOlNpiwBlE5RaDBSJ8vwIwYpy?=
 =?us-ascii?Q?aaqokSOy/XHljWva0TBdKsoxYSU3R6wXr5Mq+XHT7/LU+lCzCp/8TT7tnf0N?=
 =?us-ascii?Q?yIGdO5dWaGh/KqXpfGaEaiNSWzvZHV/5nI07NBkIHGB0IhmEhogr1gikIGKd?=
 =?us-ascii?Q?oAKbmtz4MLyXPC5sSp+IA2ymwiVhG0+XM3IGy0FS+m4l+0Zr9ldLbZ+6j4V5?=
 =?us-ascii?Q?cgauP6octLfcjjCA6V8b+c+KRt0knU3Bfyy5euB3P1uEAHENxRq2yBGJwhgZ?=
 =?us-ascii?Q?mQbVcMLdCPVkevNISYkIrsMd+MbErGF4HY2FZbSXYX2F0x/G/x3TehY2WZy5?=
 =?us-ascii?Q?M2gUyl1WOw/M1yrBQpHdhnPOCfkpEjGlcWN7Dqc1cnVNr3yYtxhZlaaOUIjQ?=
 =?us-ascii?Q?yOsklz/QkCrYD0+r70OJ8Q+W2OBvmc5fgpI9a3WSII7gZp500USm8w9Ogrqz?=
 =?us-ascii?Q?RkGyqYgbFxDLF1eyd2D1FDUvKg3r6FQtw9QD4WiHJ26cN5wJ0PsaVynIdgDE?=
 =?us-ascii?Q?kA23Wb/78l5yzZCbFkZ19vz+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52de8ee4-e386-435a-193e-08d91fb70b4e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:28.0487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybtv44dUrfITg0BiHGm+lPAtdGO1MbtAeM91ijNWfoyl+OimzPdOIgCSU7OCMuMd+n+oTchRg7ZZGD9xfa0kpMAyDOkSG86ywX3m1j6pYfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: gwhKYGoHbDazRBVlSCDaKBzMTdRgsFw-
X-Proofpoint-ORIG-GUID: gwhKYGoHbDazRBVlSCDaKBzMTdRgsFw-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with an EAGAIN return code driven by a loop in the calling
function.  This looks odd now, but will clean up nicly once we introduce
the state machine.  It will also enable hoisting the last state out of
xfs_attr_node_addname with out having to plumb in a "done" parameter to
know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 87 ++++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ad44d77..5f56b05 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
+				 struct xfs_da_state *state);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -287,6 +290,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -332,7 +336,14 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	return xfs_attr_node_addname(args);
+	do {
+		error = xfs_attr_node_addname_find_attr(args, &state);
+		if (error)
+			return error;
+		error = xfs_attr_node_addname(args, state);
+	} while (error == -EAGAIN);
+
+	return error;
 }
 
 /*
@@ -896,48 +907,26 @@ xfs_attr_node_hasname(
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
 
-/*
- * Add a name to a Btree-format attribute list.
- *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
- *
- * "Remote" attribute values confuse the issue and atomic rename operations
- * add a whole extra layer of confusion on top of that.
- */
 STATIC int
-xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+xfs_attr_node_addname_find_attr(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     **state)
 {
-	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			retval, error;
-
-	trace_xfs_attr_node_addname(args);
+	int			retval;
 
 	/*
-	 * Fill in bucket of arguments/results/context to carry around.
-	 */
-	dp = args->dp;
-restart:
-	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = 0;
-	retval = xfs_attr_node_hasname(args, &state);
+	retval = xfs_attr_node_hasname(args, state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto out;
+		goto error;
 
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto out;
+		goto error;
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
-			goto out;
+			goto error;
 
 		trace_xfs_attr_node_replace(args);
 
@@ -955,6 +944,38 @@ xfs_attr_node_addname(
 		args->rmtvaluelen = 0;
 	}
 
+	return 0;
+error:
+	if (*state)
+		xfs_da_state_free(*state);
+	return retval;
+}
+
+/*
+ * Add a name to a Btree-format attribute list.
+ *
+ * This will involve walking down the Btree, and may involve splitting
+ * leaf nodes and even splitting intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * "Remote" attribute values confuse the issue and atomic rename operations
+ * add a whole extra layer of confusion on top of that.
+ */
+STATIC int
+xfs_attr_node_addname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	struct xfs_inode	*dp;
+	int			retval, error;
+
+	trace_xfs_attr_node_addname(args);
+
+	dp = args->dp;
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
 	retval = xfs_attr3_leaf_add(blk->bp, state->args);
 	if (retval == -ENOSPC) {
 		if (state->path.active == 1) {
@@ -980,7 +1001,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

