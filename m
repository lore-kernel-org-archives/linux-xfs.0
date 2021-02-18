Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C57C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075FC64EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhBRSpP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTrbp040610
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tquYq95B4F3dQNABa4M+L1zagXWFvourHas/BCRrN8o=;
 b=cnRrJpX9yE1t49ZMC0nF6xqY3wc9+tRaWrVILN1OouWtRpnxfiG24h+ZnBPkgmNn0Fja
 9r0ADSBOrWEkZOf/A0guJ49oVuh7KvVftRJu1hn+WhqoAvz6XzqQTVhONom7UfibdL7k
 kc8I25z1b3BH9sTYNv7i5ao/FHYSbpYLqSsusFtbkmzLgDR1TQAeUysxkF5oN2TxCWhL
 ZS40X3WRMNn9kUvup6KWvVyqrJpDirPAV2A2Naq7p+x5AsbgDMpJdEKca8I8jmbfb5tP
 lv/RSIUj+CD66s9x7T3C9fl4klKCMWUM5Kki7FvOkmQ9Nw8ugQvmbcKc2hlp6rxQEJac Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTffq074752
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 36prhuf43k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPXpSac/hKShQOp8wE0WQrjSBIbNkbSFZZbeyH/Lz3W7RS7YaB1pEQP0SubuOtFfk7grzwXIqI/5o5ZeKgql8k3At9xQV23aLAbIBX9hELB+bXSlXY5jfDlcDJKUX4avESF2WhmG60HtimYOTFQPcf9IduxaRopAPGPI22zQymL3W6Phi8FT1iEVXwQ9HIiy6FBphIYtjDTQkQ3FimtGwHAHmkkPV6adOBCGKvBtKtJVuF69EimpzjGRoHbzriQxFJhxjdeSawMo98YDptqowo4KqY4UubqvDjUM1zvkdmF+RcJWOLmXnajpVG1YDxHr19g4pksX76Pbtfcbs9ok2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tquYq95B4F3dQNABa4M+L1zagXWFvourHas/BCRrN8o=;
 b=dI9OhanC/ALzN2K5t/GwK3aBlILJHREU9XD3aTfb3R0E3mTnAP0/YEGl6I0xwm8Ajb5hrmyCC7u17PLNeiP9+AloDO1SKVZ7ate3X36ivtAtwp87LEszywAh1vOhqTe9F8it6POObyPx6FBlW/SCk591Lxzu6ssUVz+vFIZ8HThWlQ0EJullHYi08dwJe0U0qoQm5SI9z2eyE+72cnwY+pjAMoLZxiaXS0JrSXnxuU80ogCdaPk8yBcS6P5e1ZSv0s2VIQj3tkV8MazD6y87qmsqT4PJYQbHGaIdAEqbNwx1W+q4a0xwwCqi++gN9rcbR91VbUQpZE44qp5TmLOVbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tquYq95B4F3dQNABa4M+L1zagXWFvourHas/BCRrN8o=;
 b=I7R9RJRKb19Vct1Gu7eVEZjt7QRiL5BJLP6hhc5GmRsTONDsEfYxQjQ3IaZUekzQJNIgceX3YrTzkALF8hqpdkqYmKin6xCyuMM/YR3AWrcvoyDzryyq8hoXW+5oo0kqQe1hsNVNoP2VF2WxYlgMEc/61cDM0qXPhWiW7sAZXZ8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:45:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 21/37] xfsprogs: Hoist xfs_attr_set_shortform
Date:   Thu, 18 Feb 2021 09:44:56 -0700
Message-Id: <20210218164512.4659-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9928b377-cc5f-486e-2152-08d8d42ca061
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44956A741CC37B0559EF153D95859@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B7J4kHyeJHAeRT8G//OQnn+rMgjTUiBu1lbS6NZIqZAWfZPFkucikso/B9g4H0zA3vy/LwmQaCtpMPgBIZZSYUKi5eNxJs2aoVXsHe1uj0dlssOUZlOIwHxOX7WSWmixyEmEV6Jj7Pr97MuQ+nsSjevTjVPaySiJvNZ0QjKSDn3V2dnXg7DPL1CySacdHN+O3C/7WppW44aOTntGYP//o+mOgBuIEZKjmYHkug99VYtSRMOMKIIPcXR9LopEFR4Q8fLQktlEHgeyJehveM5RgTVmPQqaqeKDDahYMlHMpibuZ0LmtulUjV0P0zjAbMUUZwVdgWHcFo4zBcr/OmwVxn2k7qTW6g9B1oM7gEMeq0qymBoajhpySwPM3EZyEP0ok7cFuUImJMsS3BlN/01YXVhTQko6Kfe7iWT/Kl7fBDoSx4I/SZ3rRTOFvKwO7QYO3lFA33lfgTqe9aLlFLaJ6P6rRa0lmAPfO5s3Dj1PF2U6W+9xpN+8HszXQO1hc97NWJkmFgjuZIL8Q8ESTvRnRHdYWeQ/sNYkdu/AfH2WX2npNcu+P6/YcMmXgAsSTi8oGaG7agzdG7xYN04q1HHIeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(478600001)(86362001)(6506007)(44832011)(2616005)(956004)(83380400001)(16526019)(52116002)(26005)(6916009)(186003)(2906002)(6486002)(8676002)(6666004)(316002)(6512007)(1076003)(36756003)(8936002)(5660300002)(69590400012)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?W4edNVD5DpmP4oMz3qKGHHnaTF45bux9QtojM8tD6nsiH0xyTNXVBOGFSiXR?=
 =?us-ascii?Q?eyk0SDZE+rXhwItvsMJddysU4qssGFbfEejrbgmUdwKK0rHWiL2eli/l57i6?=
 =?us-ascii?Q?MmYapCmwnkmFFEocOytu/mgrydWqGGnAxDsLypEgAs8hbTwKPmnzyXxDnbTv?=
 =?us-ascii?Q?JIDCaqnLdnzIjjYb9XswqRURDDvrM2Uu0ND0ixuaAZG+ygVOD3noM8prt/OV?=
 =?us-ascii?Q?xWB6Rm6MgACNnvpbLs04/7NBXlsq4HbRPbFzsRkA1/NiMc0FFQb/6mBmgQfn?=
 =?us-ascii?Q?bm2jyyMYEef4yRtz/g1fxkckttbCBBmboA6cQCyFKrmtgqFMcn2rayL3gDQJ?=
 =?us-ascii?Q?pcZ3klWpu1ADdml9yv7F82ABcxXF2YejUU0rZ+ryFUF241kMhXKRtVRc98wz?=
 =?us-ascii?Q?sB74yjucD+Hu/BBlFFsUee9tOJV/0crV6h0EyK6cXCQJHa4exiR+v3SqunEM?=
 =?us-ascii?Q?v/HfzDS/pfyB23OfATzpWr4+/HVZIBh2gFlCwIewlbRRVUTokbCvVeWVF0jd?=
 =?us-ascii?Q?64JQI5gHbELOd/WA0fxs0v1L9c48k+fEKGIQMdc/cszM5jjYiW59Dgb4d+aA?=
 =?us-ascii?Q?DTDrbjJvEFmZZP6frn40rm4HDmDVtt44n878SQ968/WeSyGpUoAX+mOaDsjc?=
 =?us-ascii?Q?RGUEEBUUuy+p3c3ULoA+5Ex6A1/PF2SD9QdjeS1I5py43R4ItBOAdiNdK3Tu?=
 =?us-ascii?Q?9Jn7j9UqHaoy5u/1jbLsH7YdCnNavxbssI+fR74wQLE3qgOXB49Nm9aMsYUz?=
 =?us-ascii?Q?3hdQm1rDnj8d/0e+FAo7dNd+o+yRJ+Qru1m0DUubaBB6RQlJK/uJ6CLOOBhW?=
 =?us-ascii?Q?Te8Gu5kGr8AwnFXDvwMytscBW59ES2U44bzjR19GKOtEQcAtX8/0xVORsnT5?=
 =?us-ascii?Q?FplRTIHV25nZEXdIhOg4q2zkdiAaOs1jbUQuwkUGdBBmyIKOdObz4oRGndCK?=
 =?us-ascii?Q?cfbXiiZMdZxKQyBdI9utCJst8pBBFveOzMpWjL0dO0VUFjUz3JDGUitCmSq7?=
 =?us-ascii?Q?CHvtPqnS878nWguuDMA9e0ncaMIcUhMft+p7J1mIqXntxGQKo4VGUMJGQpuP?=
 =?us-ascii?Q?oM77VWcU+ANE75PThRH5qCfa33CbX9dCt9KvWVb+2DoICx2KCA7r/P8RsYFt?=
 =?us-ascii?Q?nRh2pGcJxhzVQ3AVc3OT1se45Xr5W3cDSnhIC4a9yXxJDKPRDtR6fVI4wyV4?=
 =?us-ascii?Q?MNv10ObFlINt0AEhxyfGLI+KT2eBxl0mXssqZHinG8Cz/TaE/4YNK+PXKfl0?=
 =?us-ascii?Q?01go2VPhhcB/1R0hX8mzkL7A37j0aCuKDyY4lt8Kh90+PHaG5aSmm8Vb9PYp?=
 =?us-ascii?Q?chyYVSZp0cajikuksopPi6QU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9928b377-cc5f-486e-2152-08d8d42ca061
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:40.9116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PuqZfFMrLi+wb64e95SPR35n/gQk2MtvACkj1sRb6IqXUzXLKVrrTUoiaESIIB8eBkVVwcVWu+eSLWTY69ZqEuLwEiMpFVR0NzygcjD7ku0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_set_shortform into the calling function. This
will help keep all state management code in the same scope.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 81 +++++++++++++++++++------------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1ee5074..92eb8fa 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -217,53 +217,6 @@ xfs_attr_is_shortform(
 }
 
 /*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
-STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
-{
-	struct xfs_inode	*dp = args->dp;
-	int			error, error2 = 0;
-
-	/*
-	 * Try to add the attr to the attribute list in the inode.
-	 */
-	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
-	}
-	/*
-	 * It won't fit in the shortform, transform to a leaf block.  GROT:
-	 * another possible req'mt for a double-split btree op.
-	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-	if (error)
-		return error;
-
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
-	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
-		return error;
-	}
-
-	return 0;
-}
-
-/*
  * Set the attribute specified in @args.
  */
 int
@@ -272,7 +225,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error2, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -281,16 +234,36 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+		if (error)
+			return error;
 
 		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf buffer
+		 * and run into problems with the write verifier.
 		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		xfs_trans_bhold(args->trans, leaf_bp);
+		error = xfs_defer_finish(&args->trans);
+		xfs_trans_bhold_release(args->trans, leaf_bp);
+		if (error) {
+			xfs_trans_brelse(args->trans, leaf_bp);
 			return error;
+		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-- 
2.7.4

