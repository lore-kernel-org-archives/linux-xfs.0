Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23BFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbiCAKky (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiCAKkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:40:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635356E36D
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:10 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22185lf5024480;
        Tue, 1 Mar 2022 10:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=tiQXeV/AGmvj81nE4g7YeVFELsqsjeSUFa0dvyNV+ic=;
 b=vqcyyuIz9AZXIp7Sp1MjWLtKlFvuBwdSvaxmAmlCfVbYYW8IkDzg8/uoSNHk+sCjc6ZL
 B/efwZE28jdeQgVbMCx3Mt+a3eTPYYOHz5W+ZE0G4rpVJYwFJEIe3SmxqbLMSZHMWoxp
 c6nv7A8oHcbh3JXREtcCl3+BMtvGb2h/ZulL+u/l+Q5k1yci6DT6+9Yi5Md34GeH0Ooa
 YnW88eJrxOQU9773yBM9tFSnP7JQMZkZbTh3ffCTuAYfhTtluMeSnZnKWw/Z/ceKMC9N
 uaH/i40MDqgGlsWQBcfhJQuU4kyssXUbhZrE8/A0217l6/fahpTHLGLKQbeso3F5P4ai FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehbk98v34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZLGb134202;
        Tue, 1 Mar 2022 10:40:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 3efdnm9qp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ww1EOTbDJEsvqTr386MzBoYGCq9aD4p9bORYrrbEbcnP0HNBLJu2DFzOh5niBR7f5vbgqWjZW1gBjO3aH8i8kfILvFQxFLfFCAXyI4IaGF4FCqslT+65PrUjWaQDyaFZwVJn2bzkpiwJOpBJp/NC4vjjJvDZ0QVfuc6WAwLhwR/hEQO2Iitc7FHzL9LazkXqsBHuA6fW24sFNXQbNLHHCf90ir2BCtGmCaRmlvPTC5hLaBcxgOLfOsRoyLgJ9J8fQ/niPDHWX3LupS3go4e2MTzsihwasGpm6vAwF1Q71Dtql8iYYMVf+9MFgL/WEYbwu8BGlImUrW2L/5m+IDfG/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiQXeV/AGmvj81nE4g7YeVFELsqsjeSUFa0dvyNV+ic=;
 b=anq0QwRhFTQcb8AjNT6WQ51slNtJ8nwTicrVxfzYGxZ7l30KkwLoDXlSZDv1wqXqan6Pq3NgY3sWR+heQFSjeRdFJwfrSdwMqGlnFlMSRUpLMCLsPEW9iyD6giZkfRPhcZ7i+ftPndW6nVUimE1OFIOjR+uQjTubZ9rb+kftnz1dAd/5K9KJ5pc9msa4jTEUGlw5rPnHhjyH3LN7vluvJrynBRdf/zLT7a5v4AGCH886LVItwKhDu1V/GWAD9+wDiWaaKL3nfFt3mgctfokklSQYCaJWX+/v8/6CPeFLKNevCfqed4pGbFq7Ps8Fcs8JzYnZwSFdH0OIb4wDqGu3IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiQXeV/AGmvj81nE4g7YeVFELsqsjeSUFa0dvyNV+ic=;
 b=fK7rfKYtsHCU78KNrfj9rWMr1Iclw0g7dgkVsgVv/zemsTnQPPAA/nQyrLF7jdzsVFz+J7rzAMwHrtoeitFqLbggsSQOQj+27d8tEzv/2JrP8Quzsa/T/QJMQqUkkbZ15qYwyQMg1i1jMU03Hi5y+/inDmbCetYKubT5rjDFPXk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 02/17] xfs: Introduce xfs_iext_max_nextents() helper
Date:   Tue,  1 Mar 2022 16:09:23 +0530
Message-Id: <20220301103938.1106808-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02a6971c-df80-4806-7603-08d9fb6fd79e
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB416029E26DBD5423C46E04C3F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Ceq7tTq1ep/imDhVKqEKZBR5kLoSst8s5odmDqRoqHbSzdAhUQsRtoaRFG0OHcEKYDf1vKOi9Q4jUyAYdqSD+tZ9a/dSTriyZYl0U/p49WlrhkMNY1LtTbTYOnbWlxK/vlmy4vU3twzIsapnh42Ng6LW0ir1CD+0IUKpL1LjOnVFIzRKcdEzs9WuF06cAgskGHNtzZhkY166mGEF2QhwUdR4Ukhhpdk/8QR/PKGwa2O8wCfDB9P6AAh0psQ8JsOrm0Rupf5CskiIVZ8lis6wC+6oMDlyqz7g1hnOAng/D70TKyTcsW6sK5KTc2VKuYAJE2CWo9gmKdW9mxPkCoPh9toYafFSo8JKBvERAq91SpfSvmvwh+4wbjFngqC2sRgh5W9fPYEPtcsc7+tXR4DW0IBFK+LcPmZdTa+o5EwltzHsYBqyGg7lCFHA7xNNVblQx3Y1XbxkQdyd5LPuiML8PxNtg79jTUISftFq/REJ5mtPf07NiKzsr9H1gmMTR6OZmB1ejftyGJTyO20sa7E8JSTyiwXr2J/NLtYIOpMfTlh4YsHoPnJP/LyrcddUPV0RX8CmJsvqQCsfpEhXkanyEKSg1TYg1eZLDFC9wTZDi0AODAWbai7LNKwh/Uery3r/pDApRa1xzut+Viid77nSJ3R+g18K01pHF4OO5GWLp3agp9DbsnFCRF1neW8dxhN/vOKKQ69gVQiO7Eg04zhSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+znBxGWMlDDH5ExzuK8es745DPeonNCRTLGulKQ0xYdybVYIHdlEqwIuvFe2?=
 =?us-ascii?Q?4tnLVoquR5OPCxN/R3KAzLr8QS7FgY6sETKrXYRI/iRmYb61oX/mkZbS3t1I?=
 =?us-ascii?Q?+eFxiqopyALQgb8XamWTbyGCkwXLaRQA3pTbo357FOjb+ahzS/r3AuyFw0sS?=
 =?us-ascii?Q?zi7MimLko/M1NfNWsmLW50r2WT+9Ae/zZA8KQSp3uie29rwh5j7OHmhfD95l?=
 =?us-ascii?Q?2H14/R+eT7vwFjsPvg76u6Evw4OCGnJdn+D3mTcKDigg8Bg1bHrR4Aordh2m?=
 =?us-ascii?Q?GFJGdPsCPmBwzDgOzM0bhorPGHLA4VyKYdx2izFkOHuiQd4VxUTFXEFBRLFi?=
 =?us-ascii?Q?R9LAZGej3pPR6B/6z0pHTFBoTBHaBHxsi6tl+JNYRqxh9WVJ+Kkb/tk/9/Pz?=
 =?us-ascii?Q?5w0oRXqqi2DKu+J6ImZlGFNe1CQisWNjxm631sAitwC/aSikMGWQ2JcYBlAp?=
 =?us-ascii?Q?NBISzzLwpzVm7CcdihY1LOkZM7S2jBdkfBqTyJyedagYUE/VA+gOfpFIycsa?=
 =?us-ascii?Q?9Ty9TDtVxN/Xx30sCjZszm3n0Wv+OeAuSGXrA20PFy8lmbZydOb7J+LLsMmh?=
 =?us-ascii?Q?kapW7qXFP0859AAML+1LO0TtUf8WDJ339ucBikmj0WNa1ZLwIfTxkSbwhx7y?=
 =?us-ascii?Q?gVKQHzU1n1RCbQB8nyZSJT50lCuOys69MUC94yURMn6yj+6mnbkyJzGhggLu?=
 =?us-ascii?Q?+v0SJBl5xvvxSY0zTmvMQmb5mhFI1h3Jj7Ehd2qeFF6ckEO40HOv6b/t2Gx6?=
 =?us-ascii?Q?g6bqQBUQwaDCMfyvF6kH1o4X7GNEhp9Ei5ptpleRGUNs8LdfgrGASGHDDyiA?=
 =?us-ascii?Q?Sg3Os5Lt5D0mLwPnW1xW5LGOcr/k1JUZ9qF18SIFhmH8DhfLlnM++w9w2uAN?=
 =?us-ascii?Q?fvvznEpukfhURfQSuMEL1jciOa0D88qQ1Ll5EOLODQ+BTV6A8EQeDl6OXlTx?=
 =?us-ascii?Q?XVuQBIsR1U9QMVZqmCd/GytG7kEQprLadV7Y3KjbsQpGcYAHqQhYNaNn/IX3?=
 =?us-ascii?Q?WEeam2lfVLyjAZ/gkF1igEu4KWFpQyPrvsxi1NoXXT2pDGE7olUtG7zUFa93?=
 =?us-ascii?Q?qArn/1pUm2ckfVZP97GhxrRswTmfxMsZJM/oi+36RufYsdj6dXcSVPo4dObc?=
 =?us-ascii?Q?9bBRYtiXncXnAps2b7DCNPSYf/X23p7QIIdFa8FQsIorKgAgOdFDyEmELaSa?=
 =?us-ascii?Q?mGPSA2xOXxEiLiQDJjuw7WDgY/+dRbDLeNcWy7RU0Bt4alEc3OYg2NHXkn2a?=
 =?us-ascii?Q?tck8polUQhyWcEzeqBSrNEwuHRZzzmMnjzHrfBfUj+gItXJZfIl7Hb3okf9G?=
 =?us-ascii?Q?UJtrWa54lDiSbsZb47Ctbx4sCewhZ1w+8xioNmywzWOCQdcfDOtueD7Lr0yh?=
 =?us-ascii?Q?0kskJvl/0jQjJOMnIGkS3xncPGjMA6GN4yWkU3m8vdxv7fX/MDxZVcyFykYL?=
 =?us-ascii?Q?5HIPkyg8pT7gkb7RTJu/EOpdm2QRYohDBTEM7WSRt7vgUrCk/ktIvndIZVjL?=
 =?us-ascii?Q?9JEVxoLSH/OI6KGo7uyAto0DRLiumrD8ZSsrpzBAIKH2ohDUmga56dvSIGLg?=
 =?us-ascii?Q?wHoThj5guRIGQ0UGySoXDFO22SIA4GIwbaiBQWqSPfE7w1zfjjEL8ZsJORE4?=
 =?us-ascii?Q?iS9eJeEOAK5Ejwt1vXXBSBc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a6971c-df80-4806-7603-08d9fb6fd79e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:03.2218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpSfIAmTRhj+iGAh/z0qJJukTdjCmVxHky/Go9hDpWKKR7JUlx4CIhuliTWFqM6EnRiTdE7PDYSznZcKUpL3JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010056
X-Proofpoint-GUID: hsQeVAl0MfTetAoM1a0qnTrqCO4v7qRM
X-Proofpoint-ORIG-GUID: hsQeVAl0MfTetAoM1a0qnTrqCO4v7qRM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max_nextents() returns the maximum number of extents possible for one
of data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute forks
are increased.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 9 ++++-----
 fs/xfs/libxfs/xfs_inode_buf.c  | 8 +++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 74198dd82b03..703ab9a84530 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -74,13 +74,12 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+	maxleafents = xfs_iext_max_nextents(whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
-	} else {
-		maxleafents = MAXAEXTNUM;
+	else
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index cae9708c8587..e6f9bdc4558f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -337,6 +337,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -358,12 +359,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		max_extents = xfs_iext_max_nextents(whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9149f4f796fc..e136c29a0ec1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -744,7 +744,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = xfs_iext_max_nextents(whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 3d64a3acb0ed..2605f7ff8fc1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,6 +133,14 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
+static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+{
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
+		return MAXEXTNUM;
+
+	return MAXAEXTNUM;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
-- 
2.30.2

