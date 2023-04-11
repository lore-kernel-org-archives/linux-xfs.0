Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32EDC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDKDg7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDKDg5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:36:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C16EB
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:36:56 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJZsMq026479;
        Tue, 11 Apr 2023 03:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=P7pXKonUTI/eWlsTECWfw125oqs6oD1m4/cjyKm5NJA=;
 b=WdFHsDOjI6RLDpfkPwK7WWNjsNXQAv1SxeElZTpQOv14iBSEHC38k342h3SEHes4V1df
 m9uBIeNxrWmiC22MSJFOPc29VMqT/PatuYPbBrmfMZ47UY26ov4Bi623UbmgNk3/rvim
 io9Pf0bmmchLBaSR/vXw8RmgF18OXlz3u926nM2dTywVc2K+ocifs/hkZZxTxw/UtINj
 3d6sTs2wy89U15SyphEStSNbp+g8KBqd4gVFoWq/X23Ydc+W94kFzhIllVRRiQk5oddG
 qAlT5HIRKIrWZHZvEbmuGl2MGB0PZ0emkTKRCFpmtN4uJ4J5/LTLN9OGvaDK2M62LU5q 6Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvvan2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B0kYei001780;
        Tue, 11 Apr 2023 03:36:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe69afw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrJgd7DzhmX0UHvwdfyBhNtKJPsjNXd4qzQYAdY9VY1u7pBRfo1LMO+nfjHZlRttw3W3Ezj+7rWUW0rxj0oUjbnsbPw6XtktXZljn7vRHHnhEVoaAfiFXemOE5/bW5IuLSA8PlByJi/u8/gRnThgpRil4iQenb5dOx07S57Z1Y5vz7+uqVlCjUeZqZBs+xwgtwOwDZVUFCByk3ud2ezLufwRe3Ev3O77TS0L9TZbsIg3bC6gp+JZT1Sjzfcj8cX1GvGS2NvYIvhqZl4808d6sWMXSebVet1U2vTFgOlkXr/0r05BoskNlLc78H+bFqlv3trlG/2RNb7X/43dFZm5qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7pXKonUTI/eWlsTECWfw125oqs6oD1m4/cjyKm5NJA=;
 b=hVxGVBeOThKv26JsEZtyZXduoooqKO2dL50xKp8hGCwpdKMSOeeLbz+9tijhPJv+vIiUyvG1Ch2yq+M0JOuSzP1pP5XRoZVtqmlhEI2wz2Q9RfJFPJVESyFfYYJVw4ELIsJbp8g9lRFOSK5CQkQ/qKBXUFEqTA/jrEfnZSylsu/Qf7nVpZvNFgbMMTPXt5MjOZnazz5/W/QfgYzXI+pIZxYdveaVXR/y0vxNrtHzUKhV6iQXI4+FqokdswHRJRN6ZTwHF/i+JZA31crL7zBD6FPkoKG6+sut6uokAzD1T0LRE71qzisE/GYEWDQZ0oVi778raThah+6G2G57jVu4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7pXKonUTI/eWlsTECWfw125oqs6oD1m4/cjyKm5NJA=;
 b=xxjwQqcPbcjnv4oQwuQrGeOiF/xPuD5PHB6VzH1she/UCFGL1I7MdaFOJiFr5yw+H7Ce1P2NENZwu1TYtVVO/xOwlrCPHK0IWlO70EOtt6BOWAFim3SuAeBW7+cSUydjeg3KRsr9LPVO/LLtrikyBdJDRAD5jA0cdRgjtajd5MY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:36:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:36:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 11/17] xfs: fix up non-directory creation in SGID directories
Date:   Tue, 11 Apr 2023 09:05:08 +0530
Message-Id: <20230411033514.58024-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0196.jpnprd01.prod.outlook.com (2603:1096:403::26)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 1437ca68-5c16-4bee-7b2c-08db3a3dfc3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F7ZWzi0IzJn82i/+uPCE4yg0GotLd3ii0KfE0IMUxS61Al9R/9Cu2KJvBKV05mDRxveXES4l0zDxfEdU5tq5xwsFJAUYL4pFro3Lm+vdncYQjHHmAwen2n1RW0/KKnGYyjezXxLPj5mLv2XmKpvl2s7MlZ4LuFzeeS2BUnpNaTZ4aTzyz1j+aOoDtW7aWSwtJe6nDQdQ99R07jTKCJ+NH7oiTzTWQwJI2js8k0uE8uNA0gHROcO0NqTguWDxzqcB+XATKehPzLspwGoUVax/0nG+vnpJbTSPaf7DiLxUrIJLfk4JoVdG/qopyAl9Z7YJOd9qIFPa2HE/NEfGFGzZxyBmo73yA0/lQK354UToSdP4w5zVz7IS43LORemekbMwNCBYKv/JKeOIvXGWbuudxLzrjcGFwhJjhNVeNOoVR8/cIy0SFSn/J49as+8aabeL8NfGILG2Y1jA3DguF5F6Xqi2YIBATQcC4mA3z02iHiBW0CeB0KJvGlqA1FbtTdOjEF4Th5TKvDKNMr/hivoNMAJCW3tSwaDKg+IE5QWFHJG9XFnX1zDZYt1T9kkfyFUO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nd9Y5r2pRhdNfrV5uxdQwSVqhrigTyrUKZKpfPgNrIeFxpKOM+TdkZTjR3p2?=
 =?us-ascii?Q?yDt2LqDaAl+6f9trRNS5grI+KqUAWYcT/+NTI8VUr8FC5GRSuYKA5mexBrY2?=
 =?us-ascii?Q?0W72klUOxbZU5NHQumyHNIijVFAuAGDd+qPmJf/Zkig4q9TW8KttnkXigCzf?=
 =?us-ascii?Q?+dcNNSvgFsdg/K0+WfmCsx4J4sbp6dMYRB6xdKPjCBOpQ18vc/zhRHgZNnL1?=
 =?us-ascii?Q?3uolvkWMsqsIYyQdbWcX6ZdZbLWhyZpcEEilNWC1S/nznOPcFJY6KDR9J7aP?=
 =?us-ascii?Q?DmtM7Z8PS/Q36nYrqK3OBRnFR9g/FdxmvLZHG+7Zk3pdlUNeUrHoWKHfB43d?=
 =?us-ascii?Q?jHqClAx9FW7q1PQ9TNq4GzR+FbCTKe6OQqRgBBwJgC/1ShNMXJs3E/3wEKcF?=
 =?us-ascii?Q?Gc6x8vBE4H0sFv10Z9D4G5NJl2tai87YWYZ8ZhPiTFLBapJ36MuTOP89O190?=
 =?us-ascii?Q?i1gCfXtVDGD7Es5t4Xk73pwhv8iopNd6phafFvMf1zi8LAt6scyPtpZ/GPzJ?=
 =?us-ascii?Q?sWgRb0QVJOGhdzvPkp+bZWwpe/wCNYndnCJFjMVmzaZrZhpxrn/czlobIBqc?=
 =?us-ascii?Q?1KXaOYmMacHF9nc4Z9wAz0P6ymRYO5qLpdSIRI6C76oFswFcs3GiYhGZk7uy?=
 =?us-ascii?Q?8HDGrv91q2ee7gFXHhVWiqUNIqvB8x2wRP0HYHEdseJqQlDj9VC0UfMRDoNK?=
 =?us-ascii?Q?PnpZHo5Kq6rzbTwXj/z0Hs1nYbluXj+JbyrZkmiwMWPTNB5QznA+kF/kH7bm?=
 =?us-ascii?Q?7BRDKgthcEMiM2sDzx5uUMHuQ3BwrI0vhtthLMcZOM7zYiUrBPkUcV6oT/KQ?=
 =?us-ascii?Q?wJsZAFu+mqEoQa3+lA4QUiuFBnZPycFV5G4uurFJAxi8GJ4f4+oFUIOzwJk2?=
 =?us-ascii?Q?bphbZuedgxxcx1Yi68xkr6nI7Ev7u7oeAx1m+GfqbK4lSIOtGp79yLm5gt31?=
 =?us-ascii?Q?/dG9XVYyA7vXbOFAuiyGz6Ndy8fMVcwbEPUV0SsYRwJ9qSGn/bBNthwayfp+?=
 =?us-ascii?Q?0JShp70ugKnpxanlHPJqSMZBT47P0s4qlqk2QIbsnw8omP933TwXVitKe/dx?=
 =?us-ascii?Q?yh+ssv5d5GYHL2aRMxu5Y1FCQTcFXxetnJx2B067yysnbp9Se+B0XTyD6VgJ?=
 =?us-ascii?Q?zHKA1QtXWJr0iMcDJRJSdBvy2a9nX1TcLx2QK52Da/vG0XgcbL8rHoKGFOjG?=
 =?us-ascii?Q?dr4Mpi1Zreo7ZioVrQfCGBAGTK1QndHXLO578F5ww1xjUisupMxsC3dhlalk?=
 =?us-ascii?Q?PXLdO1Oyb0LN86ZpqMTMC8Z+vd3QV/O2XedHnq+hvfTtMVqNB+1b0gRGZo4S?=
 =?us-ascii?Q?jDWbFVKltes+Gt0HreMK/S/BDVq4c0lxGaGsAMPRp8pN7l0/7a4WdWIofhuW?=
 =?us-ascii?Q?Tkf0usj+S03DEMwJljNo0/hd7ml5AZeW9Fj71zlp327ks7MuAPpAajXYRp3c?=
 =?us-ascii?Q?RrYE0DDFkQIm2V8iQh6bRBVRvkpLHTnYbYLpQL8EOEU9lUCAWGIE6Q1+dxc7?=
 =?us-ascii?Q?5B2p+TUtGN3b3dqg3+7OfVVrp1cDfmQty2eNZfLe1WGPYwEQICgYfmbqCoF4?=
 =?us-ascii?Q?gmDNryHOVwG2vhenw8L+5RujowLjSfoo9mreqrcXESPi+q/fBMgL/sqa/SeR?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /Q01TLwza6hSpRc2PtuNtNVtpZXh8GEn0yv0zIlLqTKrjZCTn6tGxEZTKw/GTJn5sLNIegOIZsi4jMLceBSZRJRVafrKkjMPYpNNBEnx2jz5+7RZibmZy4H0Z+LARjFMGa7Dwdmp87b8WE4d4mGu4oSNa5VfKtw/49SYWseoC7u3NxUkPe3Wn7YXQGG+95C+spzifUvQgYMDO5l/B3ECAEWAfiUdT7AONXjq/DGf/+vr/lPZnm9jYvwPVAGJXF/3cZuVmW5DGuwxzcJktWN8VKStwqa3SEAkHkT3UK6u0K5uQJ4HMmIfZfE2RClZbOGBpYxdUG/aHuVb7Qd/27NM7iUitEAWuXhDkT+vq2n7rMVGTg1HbKd26SEzb3kAVgVIjCt8iZnD46EQQ+wbSjQp2TkdFtg9mQNl5t5vi0Npm+AW/swhOZKeyGUNMD+7k+6IgYPI32/yYb+EABUJ/yU+JKlrMc6g9cVJmNWMhr6MNI2pno0HZXP025SMIZ/c7TrE6e0Ie1jUfHjp+DhgASycccsfe+r8lclWiNCLftdzN4Lz8cB9nXj7Y4oFDupOOk1rZfOYKFFRSxuO0B+BPNEJdexP/YvHcqXQcMoWPFEdSgg8ZRiGON27wkOQt5iJ1pkjeTIdvwemzwOhZjA4dKC+DzphIgxRRuOf8MCPlv4+cU2Y92A/fLT+GvbiA1q7M03+6C8ZWR+EloDRZPn6VpYrdLMP2VVn1NadBBOIAmeQQ8BG9GnFX++GFQZipqXxrFpU3OjMDMUSc7EpU3SWHl1aqunwSFDnBkQZD8AIujdxCHbv+RjLxIuFNenVcfrG8k4f
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1437ca68-5c16-4bee-7b2c-08db3a3dfc3c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:36:50.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8RnbmzR5zxX1CanQvDlB/yRmj+k0D8nQuK4udq/CurKGBEGqTr5HkGCi58EsPvk58FMde3OYeUc1yq5U+TGUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=901
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: kucQfyRbjaPqIOxw-ZdpfgfomN6fnoXt
X-Proofpoint-ORIG-GUID: kucQfyRbjaPqIOxw-ZdpfgfomN6fnoXt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.

XFS always inherits the SGID bit if it is set on the parent inode, while
the generic inode_init_owner does not do this in a few cases where it can
create a possible security problem, see commit 0fa3ecd87848
("Fix up non-directory creation in SGID directories") for details.

Switch XFS to use the generic helper for the normal path to fix this,
just keeping the simple field inheritance open coded for the case of the
non-sgid case with the bsdgrpid mount option.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6bc565c186ca..568a9332efd2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -750,6 +750,7 @@ xfs_ialloc(
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
+	struct inode	*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount *mp = tp->t_mountp;
 	xfs_ino_t	ino;
 	xfs_inode_t	*ip;
@@ -795,18 +796,17 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	inode->i_uid = current_fsuid();
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
-	if (pip && XFS_INHERIT_GID(pip)) {
-		inode->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
-			inode->i_mode |= S_ISGID;
+	if (dir && !(dir->i_mode & S_ISGID) &&
+	    (mp->m_flags & XFS_MOUNT_GRPID)) {
+		inode->i_uid = current_fsuid();
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = mode;
 	} else {
-		inode->i_gid = current_fsgid();
+		inode_init_owner(inode, dir, mode);
 	}
 
 	/*
-- 
2.39.1

