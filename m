Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2502C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbiCWVJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344880AbiCWVJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753C38EB4E
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:29 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYFfE019841
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=4lZk2qI5oRE/oOjKu+/53ym6UisnjP+x0eag4vasz2E=;
 b=YAB/iJAVNcETTHe05Qta1S36EBw3VeZsbUA64GizXsyi2rWYHkwwOsJFbuWXuyonXxUP
 NTlJv+myWV4+42KRtj1RMhqujQ9Ouwc4/bJorwTJFndgNidnde7hq5/WMmqXFBqPIYvW
 2MC2zdoA2fTeGd+QOCPx+BhZ1ej3Q9YhJTocTvFSvP8VpByudkrq5tcqE/LDop9a5wvz
 tUGWq1WhRTcO180L3lyRM4GeL3s1/oU018KXMS+YbvVX1JRIfHUxnpK4DrAtLmFnXwlu
 k+nfOfCLz6AdJQroUyi1sOTReBC8iYWXXEPXa6lx6MuG9EC30Sj4J6J61oPLRKphFhnR 2w== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcth7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6LdF082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C29cLOfLKvE3cyLzZwoJuS5W3Qc9nXYv0/oNfnpbVnGjJkDbx/MiW0pkt0HAg/Rv6YzvAb7sStPEAw07o2JFZ6s9i3vQBwXKjOfrSinPwi0PN/V2q0NKSI+cSGb89dZ8W4Xb+1ipqXfMk2tG1tzMdYxt51FO0U3hRsrFpaU+xsFGM1Yfx7RZh5m5ezcFmOL50Gr3EMe8CeqXH0mCYLIqGJpeS25dIGjP83V/+7Sz8S1LuTL9eJEaR77riWQELKtihiAKmrZMUi+YV0Ibxpsn3oEwnWNg3G2n3v9A/ePQ4dE6D7LNzw99HamN0Ip52QsBD+VjNh5hOK1lcgkYCpEHCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lZk2qI5oRE/oOjKu+/53ym6UisnjP+x0eag4vasz2E=;
 b=ZdHQHonwYIHm+5JL/VjePtLYUh+hA8gztGcb8iQ4cKenxsu2eltQ0CwXly6F8rQ56J6/tfLYLFtf+Dtfv9K3vkEhHFmNnIB4QHVxnDh+g0+uxl0CQrrmJMz3YenuBFQRhoWHnEj0k7+XdJ0RKDCL93qdnIc5+8HL69S7Mpxc8rEfbctTp5QBJmajCTQ5KCO1yIsrGqbGpogEUApv2CHy++LjokwuCBKpFXLbf0KlEMWRJrK+Pn0QO2IM59d5KAYAy7ZWmIgPBt6Teneu4qCx+fT0M4nnSdLsO8KvOJ4XczQsDpLy2EyhpNRV7lTdQf6VEZ2/p6QMBUpv8ymq8OusLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lZk2qI5oRE/oOjKu+/53ym6UisnjP+x0eag4vasz2E=;
 b=GULevByRPYlLKQ8vAkiGm6+zK3dRfs9dSYgedgxo9XrskOXzh0IWW5cfQscOxdBBQIskJpTyJ6sUVVdcZNM+A1q0RmliJvd8HnE/an1X66qEJDTs8VeIOXsyx/4yhTr2Y/oFHri6teCpqBzZi+YNONm/zKLS2EUYDGfK2F+CH2Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 08/15] xfs: Remove unused xfs_attr_*_args
Date:   Wed, 23 Mar 2022 14:07:08 -0700
Message-Id: <20220323210715.201009-9-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9f129718-37de-4c0f-97c9-08da0d112191
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4744A8306CF1B38EAD68B78395189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fPSWT+EHGXgxfUfBc+2cmBvTQycF7Gv+Paw/NNwxy/i1vIgPKM/GGu8NJ2Oug/h/C3k4vePKn42b+Q12RTK8XvevJRJ4iwe3HlXfgtAZobPOeexa+dxrCA9fa+FaK2IiQRNdSEcii63HqIvccRuNbU7/6ka5NUXrvPvNCP5SJZN/Xr468PMUSPKtzJ+HGzTJ1lKDskXfa2sqfda335tcAFud08jrBiDYQ7Zv+lnB8TEa8ovENc4nNJ3ehso2JnnusUE6C18kse3IGs+0pkUs3psUD+4iXjo1Z2VGkGOPN0nBBPLrb9cUmaWb//JhEVGU+cu7kYZKl6MsUUtME/ygGeMlb09q/F2RrBRFXWBJwiDiQPyY8dRfhTywCGnHMShecGEQYb/VSBYxLeFLWW787Thw+Tj9fADYs9QNzDurNyDg8jAVWpVAy7nP90VSUd1skTdGlMbPiAhChSNJUQzj/2wxro2Vs6B0qwrVHyPF9QdwMaSZHQlCkvVyzDwx+pOg4dSu6EprYGmA1+851ScqV5KVyDMA+kckaJtUo5B4hUqFbb2MCyAV0aEb2Kk/yisUHnJ7bEQA5Zn3sSOFc3ONN+TsEEm6F6DzG4O1fEnhXEa4NMoKdyZYBwPI+NjVc2ty/SLUXN4C3SyM1hMQECECFTHzLHuRLyS7BWQnroPsWkBXmOJrrCRG8Ug7qIdGRuVkpe6PLVdQj0/dapAXzhrYsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GwuaB+sL0GLIYWxMdI1whQ9Cj4tBDOD6Td5d7wm8k3xtJbehzxGJAsVFtvpm?=
 =?us-ascii?Q?ceRXxjMj/SowU17JPb1QdtEqEw9scmRhxJXWGi2IqNeNe3HMMyyv5iXGVO8E?=
 =?us-ascii?Q?rMU4Wrytw4Yb/cd4OH5Bmh0jCVDdqhJ7b8Cf8pqRxeLBWSTdCc9YgtodfIrX?=
 =?us-ascii?Q?fUplZwWEOzYDUdQCX0EeAxzkV21foQ0dL1/4P1LWBcPiB+MI0Sb6zBS/ufyN?=
 =?us-ascii?Q?VcRPToGEqq56YYJv7DJv5szUScW4+f1IUqu6PXsNDqnVulVnGWC5SAGwfYLW?=
 =?us-ascii?Q?OhhYq1WscyBsUcPi9VV+v8ppbUSEEkgup+a68r+cboZk1/tuVRkxCjKSRdqm?=
 =?us-ascii?Q?h5OypMtzMuj+Kt1REzqqCAMYJmAngIoOEaIPUw1YXNgL1i20Xz5rWOxlBk7u?=
 =?us-ascii?Q?KucyB13pFqZWd3VGxmOoJzm1w3W/APd7sk+CYpMp6OEVUT9I7KpoO0LtAVkt?=
 =?us-ascii?Q?8fsGlxOqoHk8U3BKUAqDwO9UVMbi2wl21c1vtVdF1wHNny0lr3bMSxASvNi1?=
 =?us-ascii?Q?M1zgjDsCcDKeitugkS9qQnMPWPzzMPzvVhGuL8w/+26z6mcnc3mihrNs0oBE?=
 =?us-ascii?Q?004GUXTNYwHiEe0+pN+1p0ziUHGElpfX4zA3cZZG/Pcd05SC/ldtdbWXF00h?=
 =?us-ascii?Q?Wb0DlGO86GQ6MoRS3Vuyl/00u2i5XiINfXPyErnLR4VW64FbuMCqP/S0iY+S?=
 =?us-ascii?Q?qXCe96z6hd+mijh4mCAIcK+EEVfYxYNLv4VpVEf1Q3U6PpB1AVY1Acta2hQm?=
 =?us-ascii?Q?qrPO+Tjb1TSVgyICedtwRPK3yKLjYrGMFbjpwsnRtXCVNurL5h9nKZtWN0N/?=
 =?us-ascii?Q?8/MSUm6nrgLkRM1qNStd2ZmRfTOATbey9qWBkEUJMEJcEET/kN8wEtSUf/9l?=
 =?us-ascii?Q?UdW01QW1rAWhjIrYsVFwqJDjs5zJWmGjKNIvTXPnuKg0VdRC5bpoaZCMSzqE?=
 =?us-ascii?Q?H4CFf4jfwy1LLSF5NcgSie51L8dDRnlf+A6Np0KdJw25A//hsZ0Al9jtyLhW?=
 =?us-ascii?Q?ONG8lZ/ZZnLqjPSN4KDCAJM0OU797CC5T+jW8ofmu+Bo6oTS5LkxJSJ67Ax8?=
 =?us-ascii?Q?a00uhtPP/nHCj7qZoWUj7vVd4H4txO76A1s2cIVT/zSRkLKEVQnwswHgYVGN?=
 =?us-ascii?Q?WtjapApdjuNXumITl35XHji8loTf4FyqpHBoEythZoqzwcmeftOpVf5ywGDC?=
 =?us-ascii?Q?fIkxr6ntwpFIalOG073p21j3haIbWScmvu0jM2WHxXCaEn35t8igpCLqCfxs?=
 =?us-ascii?Q?Nt8Wz4lhi6yuxJlCORHBKs3OZhskxxke0KyDkRDnBhdPsYZdC1G/yJiFsI/5?=
 =?us-ascii?Q?PKQx/J48imj6XwxT1y0BgnWMHjlfQgbnqz51sHbRXBZopMwPVLiiF1RCPEbC?=
 =?us-ascii?Q?uDqxO0/dDZaj1uUbY/uZcUZlvW/kRySoMqhSB8JpH/QXdA7jzrKxDde8DBtJ?=
 =?us-ascii?Q?YM4GiWKfSo14zPUfyEbZ7bZtFv1Lr1yLZJQ6QiZiEK9ZkO99w+rPeQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f129718-37de-4c0f-97c9-08da0d112191
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:25.6703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewA9uHW58bhNo0vTa+XtmBtP0DixTQpAqXRC/iU/AA9TFrH9WafE7U21IKiy1STkooZrV9jk9mzClRHjZP+sz6LUHMhfQKTCANn2lQcDVws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: t6PDB8y6NJYDL-hvDOp4h7biK6o0fjwP
X-Proofpoint-ORIG-GUID: t6PDB8y6NJYDL-hvDOp4h7biK6o0fjwP
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
index 1e2fcc9da340..e10202c4e299 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -296,7 +296,6 @@ STATIC int
 xfs_xattri_finish_update(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -306,7 +305,7 @@ xfs_xattri_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -425,8 +424,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_xattri_finish_update(dac, done_item, &dac->leaf_bp,
-					     attr->xattri_op_flags);
+	error = xfs_xattri_finish_update(dac, done_item, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
@@ -585,8 +583,7 @@ xfs_attri_item_recover(
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

