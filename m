Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDACAC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245516AbiBPBho (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243706AbiBPBhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D8F19C28
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMrfZW024709
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=6oksdl0xSeED8x8EbDpEW73VohtH6i/Cuf108ctLttU=;
 b=f5NIbpusFfpoq/KDZQCRHH3b0T6ACCaa77HRc7SkQIxZU8gk9ckr+xP+cLDy5YX8S966
 npSk4jQ1YihfOe1oLDAe/EDpX4UC1jzI6oCqHuekhpA4jp9uE/BBYqcbpkF7bGwIgMLx
 CE8QMPxPMaHLCnaYraZ1LM+HMlbDiBVShnRQx3nzSAdYZOtQK+ecx6dldTijJkpJjtMl
 Uvdy9p8XBM/XtqtR24IGhIGPRHY7ae1Jrj1sQqIyDpDsJEiAEmNBZemRZByhoVm6zdb6
 oPbBdg628V3THvH+3H+DWRIxyqg08h7Ths19lo+OuF8eQWpHaGhkfceEHnaZjMtj0NUl VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8ncar77d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1UZxN165528
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3e8n4tuxvp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR7hvSVEv5IxqRL0KqUMECsI8ECYk3sIGD99iffWVUHO73CrlrxueYi+9hmJTkyT2aPrxxa1/ChgeLO9wicHR8nFlWXE3bANpRYvZspeRxWXxnXL0DM4UDOJF6aiIlVGqUwRCvkzvDZo4yKyXxh7Xnp7XyBlyme2+GJI0R19p2e0WhzNxgMX0j93Cgd6S1m+NQfUTnClucrtF7ZYmJRyTIj3vkAaC8jR0NjG5jBgKc50tueraJS8v3HBMTqm+OXRwaTmS5HlfN9gOrRhp4wZywh0lj/qhLMN0LguAe/4ilnf2aR/RcfvlnnxoGpRPIALgisO8VK6LjT1o9HpnK8aAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oksdl0xSeED8x8EbDpEW73VohtH6i/Cuf108ctLttU=;
 b=HC8r+UqpPPB1eUx5dKy0oPlnf71yRiUgAp2u7BlTT9vjeZvu2aWwZaaJeXGJC73urabQRo+i6TZ2xHr9BKeZBqVLdoxlpqthbGPHEWesXjeNuDXtDtotTxifCnz7of0i7gdanUMXMMM5vqcD1Kow9G6mgMjCY4f39YaoExP9H2eJ1HvvvDjpYIIdLDE5yF18xUQxqOSs1fpKbabAz8jqNs4nRdT4Q2A7+BeEiy/grtWXovp7L+JVGbSwatOz5P/7iibT6Jz6i+yFwqz/dacN32Jjwv332s8q+WMYhwGCPQQPS8DYwxBbxaXkWX8M1CoaszkHCkzNCnTR9hVELYWCkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oksdl0xSeED8x8EbDpEW73VohtH6i/Cuf108ctLttU=;
 b=XKzK979RzA+X7gX8U+TadBsT/ZVemas9TnXBBxNL2xrInM0B+Z/eRwCuzwqVtg5S7e4WTWLQa/8mhwOkJ8uIIZFarzCArIMMIZ1IqGQIO94a7LErrmoASgUvZ5TIl/gQFdBlXMtsiFBnsBH5GmZUidHOhDMPhWnRFy7JiDDjZyQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 08/15] xfs: Remove unused xfs_attr_*_args
Date:   Tue, 15 Feb 2022 18:37:06 -0700
Message-Id: <20220216013713.1191082-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32b7a87a-0e3f-423b-51af-08d9f0ece111
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB28029A12DCEB505A3642551295359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5b1+DJoj/GIq7Exm4CEOC5a+yqBZlvWPDnglF9vD6BnA8fyNVeP3fdqhU9LLtCG9HSI/bm3SzP0cCgFMlvymd6ewkuYv2DpmcNuCHmma0JJwP/YKhyTappAQ9SXxDhG+ZKVvBQget5RcRHIfzyoAqreimby3WDF6PgJaFuShU2NCE75gWrM7Wh2znsS7BYFz+YTPAeL3lxImhbKA/3zMXgKSHpYTwpS/34cHT+N1lYkzk/rrCGC++E3Dq1FIOUYfAckFHlYdSqBoG8P5mIPx8K2Mm8+Lssje/m3ypWRF5a78PIDFYi008wIuKyxgRmxTusZWoNp6xA/yS8inopvc3d/e7zdCuvLOmS+w745z650Q/Q8X90sXEEE0RoQzQFJU/LYXq5AfI1P0DRUVuJV+A9tXVyY+xW9QKuYPgIaxTOBvmglurwmqO52uAi0kkLd3w321gZYKBwqdIrd8biH05uP3EORocfI7vhLXkl0LAj7/oQt267DVTH1byGUUbo/5Ys66j9i6Ix0GJzLvEXOoA3IkZtHUXdibwhLF2oKgWLcQpkauQM1cdH9btayrbDrm8ox+vQY3TyEe9dy+7iLAARl+hNbvy4ftR80V2SIJiZ/70BpBGzTAl0eHNBg2CxwFlr1ievlKDBFMR8irU8WeulADxjVODsrmmHND71dPZJg4IYhapA+NW2BdWX3rD8OVPnZAf8QiIKziZOOis+Aag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iVWb1KMVPzLvw+1BThxti12IAXlapUs/A5DcrzW8+alLZ0WvRbQi74rDpDN2?=
 =?us-ascii?Q?I6lFQwyVAiXhs5N+hBgMRBpt3wUDK1O3NDyPyF/g+pWlSHaF/Koj5aShYdwe?=
 =?us-ascii?Q?km0RsQSne3gf36ZBNiHEK5c15B1S5CtXlhtr/NBo0MnvPwCoKqR+rZ7SelfO?=
 =?us-ascii?Q?uPPgQPoEjfqbAGSz5xTAyNAkGgSicrA7CySnNrZvW//FrJauCklbbFtLuIcJ?=
 =?us-ascii?Q?SliFumLwAiagypz6MY4EUe2k7UwVPsAvdj5VcGKJKwuoqjfU/gqsw5Ps1VDG?=
 =?us-ascii?Q?Y8hvGJbqowC/Qo9wVnSRKBHdbR03gn2WnDJTR45/3yJw0Q0UqoZfrYEgibW4?=
 =?us-ascii?Q?rLUOQmQTNWZJS3G2YOw7vJG4Ix8u/7XZRXc9EjHASV3Ds8lhRvGim9AmE5fY?=
 =?us-ascii?Q?3/yeG4HpgP4EdGnCiWAfdDZYFy9jXVCNHbRjJ5isQATazP71fCaft+oTV0bX?=
 =?us-ascii?Q?/Dfhtl3eW7tee8fJGrG9OZ5rQkgKIQRNfqt2x/eE/Lxo+ggO/gdEaFd2z2VY?=
 =?us-ascii?Q?+9iuLhQZak/OYniMN18LdI5CEJ9vJ2wDE4S+n5pX6i/+4nAFEdSI1BJZCM+G?=
 =?us-ascii?Q?GvKZK7cRPh20AdqDkbg3+8c7FwxCPBp3nNNP3BSTMDUIiSwueii42GjDoUjt?=
 =?us-ascii?Q?plr2RvD7nfyHnoMvrp9QREuS3mqGPKfoJWB5+rpuDC6cURxx8Z8o/IyYQo63?=
 =?us-ascii?Q?tqTspinX4bVA3KTxgW0wnr69sRGnj23Qfv87sOnQ2tNdp0xYF9V7TG4XKK5H?=
 =?us-ascii?Q?jZDM5Y/pMJty6QzqryTVlePV3J3bcA+GKGUv2gQqIui6vnhmdLLe+mDY4UrI?=
 =?us-ascii?Q?ePFo1XfjFzhsF+iTr3pE8ZXh5H4F0Qfti3mLkfzHn1Kfj4FqBdnrgFjb9Twa?=
 =?us-ascii?Q?CvSNZWjPlO84JwPxTqO/mzepsXEXt55NhhG1zdBL+7Xw67P979O/z8nufKEU?=
 =?us-ascii?Q?G0kEdjAihOy7TLtvXY9GJZs/U/YZ52skQnk2Bk0jgNF2/yxb4ZZ0FrB0KI40?=
 =?us-ascii?Q?qJMvJjXPd2XPJOYyHP1KQKMN3BSOE4FQqcKzweX52g1TDiEenlw6sQIwbFWA?=
 =?us-ascii?Q?nf6JhFZ2iF/cTXIzPVB0Q2RAzStuJGWtIaPTAulCexh1KvudvPtUSJEdMu6y?=
 =?us-ascii?Q?FvS2+oYMjwSKw1Lyv9dGWeCSuX2IBXReVCW3QPfQSqt2r/pYybLQxuWHE0ZI?=
 =?us-ascii?Q?flLI46U6vPlGH+ibp09AoUG/abgs8EgwdJ0WZKop8isi7Q5RJfcZKDGiupmS?=
 =?us-ascii?Q?szAakDJP/LlRFkY5OeRDsjHzTZTY4wnnipPtsGhpEcLNFxblVFOV0UPMIzhM?=
 =?us-ascii?Q?bxIQ9ZKlJUc4j8PbQaWRj2cv8NqOm0U25275T4fo00yWROJHtcqo5D+fvAcs?=
 =?us-ascii?Q?D3y8Fnqz48QcE/b+JLDHY6XHr61ew9y2dUkJncYlLGH0c/9LexF9FIMl51yQ?=
 =?us-ascii?Q?QUIqVM30e9SVe32ecOQKaTtXUC36JUpxz+ULxP71S1Z1fZKfGh0+EJ6KjsEH?=
 =?us-ascii?Q?ezTtxPaIsAzkpv2mlyO1N7YjX3KQy9KI20RXDo05f8adiZQDDgxwtIEl5M3z?=
 =?us-ascii?Q?y8HzpLMH4bMFviRRkyli7ROQUiq0x+x+XNWK1IeQWn26ypksSQUqO3h5qWH+?=
 =?us-ascii?Q?M3IVAbQrpLlbNcP57F1p2c3zFIHZbJaYYQDyquXVsP6AN3Cq3N4wnwUIl7eD?=
 =?us-ascii?Q?oTfMBA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b7a87a-0e3f-423b-51af-08d9f0ece111
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:22.9373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yjo0+Te4XAYL7NUCb9ajpTlzonwUpnhYDwKdca6MQubZ4kTp4yNP+XvHCknjZ4CxZi2MT6E/AJdRtND9XQNyrZavQfcDbgsMCEN3/JO6Eic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: bSZkylBlNCWWWWwUBsOANgY6eRxW5-te
X-Proofpoint-GUID: bSZkylBlNCWWWWwUBsOANgY6eRxW5-te
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

