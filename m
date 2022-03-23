Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A89C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbiCWVJO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344885AbiCWVJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052EA8EB51
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYUam011994
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=79c6zpZdeboofoM9tiGBGDOO5n4VwpSabJbfqGUT/Ac=;
 b=A+nNXdUyUiA4gi9lKK+Cz2fom2ZvpRMjSpYwha8lHKXv/sgNPsm1ojV/ErC6rCjEjwAr
 SDIQ5FcJLOq5r+8Z++7VTegSIgShTanfEdn8MPMbahqlI+U88RRX0vkNk17gWNx/TYJ5
 sXNJ5Pcmy5zhQMPAQhLjF9zgED6qs3Xa5Lcw6XIGgfR/kcJ6CSnDGgpuaQDAMxwTgh4H
 3oSboG/zOPSbNKvU+nOPmDWxf1xASSO9w8TmQd92NeyL7QJkREJ8Mm6WpG2+b2zNuKH4
 VfDrzSopnIqSbrK7cGRt+mJIh4gA044yklxkVbDp+cpD8ZqEAHvv4W4g/D9WICGL24PQ DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0tt89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6R9p154749
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3ew701q88e-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNiM4Jor1SeZGuWXCWbOMlLZ1DChcraHhVkJiJNFg6hHTLTc1R061YsZDG3tPuWuW6Ya1S3h5MN3P9Xg4n0mw/uH9Hz/Ndbgtlg3GcjAgAI5ESx8jbyHBH1u+pgRjUlsB8wquS8z1jhcsUHG73d5pzpz4LlSi3omU+ok5tFutbT1DC1utNgfbW8bRTq+6hhzcqPEPOgS9yJsuTYwsR50eWMmXArUIZblCvSsFudxfCER7tl+5xSLKUfIr0XrXMMemVRA8uk7l4wQyPR3sLY8m9cmR824/H8pa+wW/LgEOKbpMXllNci5LtYNZJLYDv2227SdApC+RzCTmTY4qqL51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79c6zpZdeboofoM9tiGBGDOO5n4VwpSabJbfqGUT/Ac=;
 b=YMQ8LjpKd+LBf5sX61GikbgasVyBMhxCNz3nqI91vhgmpen1yY/DxkoDHM5NJDiN5Iv/EYAzgsJNTtiyFVPidKtkO//g4v4xJwmwPjSjQbQWqbuS0m66/g2g7PbTlU8deA1Ju8LKUHMoxVyVzchzG3WRSSir8OikCGItUpPYUq4SYi/1J3SqJfltkYEDIIOyJgxvtFvUi3jszWlFrYnIAawXMu68ycRcol7ZI3109B2/0qYKKNCkdAW2pW3XNjmgpKQs1+yHfzbHHZPfBALTQGxt/fmqL3MhG0hZS39WOOEE5RX1nhOoELJD16mNvQdB/9MOZMUn6bAcoUfXoBc66Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79c6zpZdeboofoM9tiGBGDOO5n4VwpSabJbfqGUT/Ac=;
 b=jTD116zXNXREhVXcZBCAsUJa/l7+0IHB122pAtrbkEzQWmtNtBtBYkNtUuTB//puvrzbN7ChDL/5Z0X33bw5M1EA0YJHNJivmnomoUhC4ym8u6FudsXF5o3TRf0c/IpfJWoeCMNrXT75LR+A6p0GeUYqvATgk/DXhvKJNwWS5ME=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5600.namprd10.prod.outlook.com (2603:10b6:a03:3dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Wed, 23 Mar
 2022 21:07:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 13/15] xfs: Add helper function xfs_init_attr_trans
Date:   Wed, 23 Mar 2022 14:07:13 -0700
Message-Id: <20220323210715.201009-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323210715.201009-1-allison.henderson@oracle.com>
References: <20220323210715.201009-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1670771a-dc3b-4ba5-c481-08da0d1122c9
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5600:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB560032A324E69FD5DCB22AEC95189@SJ0PR10MB5600.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hx9uvAHbAlcbE3es8529bc7WHDN/5ZYG0ePnjFBvqz1TxBbK1Cs7Ssv31eAqnk/zVE6sAuvPOOpzfbQ7y/I6e6iipxqmRd+QZtdDnfsspfmnWYJBgdYef7ipMh+ozd990qHhZYvVL8i6VJU++cmABrYkVEn1o5zN8Bi8HH4nRoYNfWnALhdkfRofOFcBBS2FZOdkruATIiZOpgOmWHBJdFYRBNCCJKA8o27f27teR5kKjsharlKNNsowljnyA7Yqo2Mj4lWTnyFIeFY44bpMqSd6rm/ul0bgVlPxBSEFvenpt/FhfUEPk9MALo3YujLB9LzAUmfO6nsO6sFCB1fsPs0JkqjpsIjvbrnKTUrwng4/dipRN2VHwfqqBQq1RCwMR9wMAVedZ6+/h7CXqHRV6VcPKQzPwJLFMkHVzOt/8cwe+JiaSac301N3OfCGeAVWXOO9ngUHbFSeAb42bMJ0dALHkybq+Rktmj5E7lGyqm0pYAq54/jsZYPufIh3YhzGrngtrx9sSvkpTDGJft7qvL5AoVjr7IZ2i4a/X3om+bJCUAlqSH/L3skh1nKk18ZO9hZ9/OT55fP1Wg4SSKrGnpf6RQm9wxiL2u4A9AtvyOUtVQ3yb/c6wI8AI+CvedShYnpk2hd4Cmiib3L0iYESCNzLqmcnWED0BjaCUNA1yrSjjg26z2onuuFOEKvkV5X+3avwMNXf0pm4yhtOUkGZfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(66946007)(44832011)(8676002)(6512007)(83380400001)(86362001)(52116002)(6486002)(6506007)(508600001)(6666004)(2906002)(6916009)(2616005)(36756003)(316002)(5660300002)(1076003)(186003)(8936002)(26005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LD3IssTOIIEGyucQiH1vOtFTq8c3f6S0TNimz7hiIu3wRvwkke649th96Kvg?=
 =?us-ascii?Q?/Y5C7jpTOnVuK8UMnkqWjTHIp21XFi7+JbboMcj6CtXCA0x5M1wuOqL8n5fg?=
 =?us-ascii?Q?KdG5G71DwE7/UOY5DT5FnmB5ZcSxB8HKgzQDrYcPqiEXPRJHgsXBPKZirqpz?=
 =?us-ascii?Q?dHF6uRTOuofueNcyjtxfu6iGkNfCmHN0KZd/4ayed6ndevOX3wdeLYKLzYXH?=
 =?us-ascii?Q?9U1GjU8X/KAZ609nVd/FsyOi8SdFBx4hqL3sb1m8dYX5bwFE9Jh5Gd/rl+VV?=
 =?us-ascii?Q?L0FBuGlJ2ejr0zeG1y3C2sDYdBCODnpEXgap+bRHzt3x3P+jIM4BJH/tk0iF?=
 =?us-ascii?Q?AnXSCgmnJgZCeXE+QaUndcxlubpAVULjQZyOGMCEd3LlI6Ro93AR4Y3FfqIl?=
 =?us-ascii?Q?CEHUMdDTVOiLqHtd3DKOKIRgUHz3zskTSEYJU9RrlUTxc19yObcp+wmmrWbx?=
 =?us-ascii?Q?FjPe+i9FEctp6HB2aG9vF4olZivNobVqbUN8eP8Kkh5oY/4PYdb875ZqMGLx?=
 =?us-ascii?Q?ltEev2iO7k9YHmO8uihOqD/C355fapzhpK9QtAlmVCIGllrHgRJBPZ56LDOO?=
 =?us-ascii?Q?KxIIccfhpPBhOBDqhmXT0wyzbpZL2qkEGkR9t26dz6bjUoxvS0GTfzOYNqhG?=
 =?us-ascii?Q?GEm368B1+X6m1NDwOVn/DT+egPdcytIR20CusYzOngZcyTqR3PzApk9dHye2?=
 =?us-ascii?Q?W9eWLQMkO+0SXqmBkxRys3QL68U9VEJtb1XzOnXotS2yR7aFpQ6ppSB+doJr?=
 =?us-ascii?Q?xgVaN2Q2e2xw6dY0QlQza2AFF36Pm4xniwkbygvmwD1BboBHKcQned+O7hJQ?=
 =?us-ascii?Q?XieUW1hU2VEC4Nqn/sQeZkvYXLm10Q/lyaTfkAOMK2b7X2B56WO5Cegm6nsL?=
 =?us-ascii?Q?RF2Ziuo9MZCvUJW8lSneDS8oWc9KI3PtJ8dYFYzytvC4A1XuKwi/5/JhHmxu?=
 =?us-ascii?Q?+gl8JXVUaQW0mRfPj2d6qJtFFayqwItoagq62/UImb/GsMToe1oHmIeEWt/l?=
 =?us-ascii?Q?dJ/nBIsTyhvbiQzUjYOaZ2AizelzhGlrCsmdt2ZQXS9NXU+vhj5IdMxJa7Ct?=
 =?us-ascii?Q?Ac2cWezXFNLy+KqPNHNe8aVhe4WTDliNnPk1K+M+kPkxzfD6OkzCs2OpE07N?=
 =?us-ascii?Q?NJ4jBet0yRNISn/lUtm6ZLVk/uwBHiZjdM0t/W7tsVARVkdDbl0nkmOKGMxG?=
 =?us-ascii?Q?PkSiOzrYEmvm1NwCM4waW4sF73ytULWqoVKr3sHEPPKCY2cdOguCtyJhm1Fx?=
 =?us-ascii?Q?EgLY9sK4LWi8AoDr3qbicL/KA3FMdUwPZk/Sgyu2pgEEQMZZ+x5oOke00jA3?=
 =?us-ascii?Q?+R18bjgGjEo0ogUyZ0f5TGiI/XPWUP4Xwm1IJja5Rsxe6Ul9EM/qjEKdnMGf?=
 =?us-ascii?Q?z+Sdq9opQEsTgEvEmBk/SjwAXBp418cxF85DeRjE+lB1oELLBeSvDd55t/Gx?=
 =?us-ascii?Q?BB9X16e788KgloV7BAzkmQR/26yz2afXOPFhQnh5bkXXeHQW0SXdng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1670771a-dc3b-4ba5-c481-08da0d1122c9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:27.7162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OdquI3x6jxHzJTrfpDQiyHLPylhN4x+JiblL2LdzpzAx7ucCVjbhY3rQqb1Lo3ORtzcR74WV2XQTg0YXiwN+DRC9+muC5xFhpYnzqLIr1mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: diGDGyklDIDxSncYPQEPU0807SBkJU7V
X-Proofpoint-ORIG-GUID: diGDGyklDIDxSncYPQEPU0807SBkJU7V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Quick helper function to collapse duplicate code to initialize
transactions for attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 33 +++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 fs/xfs/xfs_attr_item.c   | 12 ++----------
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7d6ad1d0e10b..41404d35c76c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -202,6 +202,28 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+/* Initialize transaction reservation for attr operations */
+void
+xfs_init_attr_trans(
+	struct xfs_da_args	*args,
+	struct xfs_trans_res	*tres,
+	unsigned int		*total)
+{
+	struct xfs_mount	*mp = args->dp->i_mount;
+
+	if (args->value) {
+		tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+				 args->total;
+		tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		*total = args->total;
+	} else {
+		*tres = M_RES(mp)->tr_attrrm;
+		*total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+}
+
 STATIC int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
@@ -701,20 +723,10 @@ xfs_attr_set(
 				return error;
 		}
 
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args->total;
-
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
-
-		tres = M_RES(mp)->tr_attrrm;
-		total = XFS_ATTRRM_SPACE_RES(mp);
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
@@ -728,6 +740,7 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
+	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		goto drop_incompat;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 1ef58d34eb59..f6c13d2bfbcd 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -519,6 +519,8 @@ int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
+			 unsigned int *total);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c80ea443d380..f2d8d6998bfe 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -567,17 +567,9 @@ xfs_attri_item_recover(
 		args->value = attrip->attri_value;
 		args->valuelen = attrp->alfi_value_len;
 		args->total = xfs_attr_calc_size(args, &local);
-
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args->total;
-	} else {
-		tres = M_RES(mp)->tr_attrrm;
-		total = XFS_ATTRRM_SPACE_RES(mp);
 	}
+
+	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		goto out;
-- 
2.25.1

