Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7D2C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBMEF2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjBMEF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:05:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBCEEC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:05:24 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iKMS012067;
        Mon, 13 Feb 2023 04:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/vVC6OqKYPVOcntgWydM6vwQAwRiqD+nv526KHY190g=;
 b=r06PlduC9b1PGRAwFHG/qqlZRd7vqEYh+QsLD5rEF3pQqytqYEvTX//Pncg3dxH2m+Mf
 hegyGnD4jxtAEvhLtv8P7TErUaOTVMw5mikbglQnLRUjKeBN8kapAic5tS2a9BIXA8iB
 OzpMYp91GMFzkc5SJ+nl3paESd2riYZMk5xTkRgiwwMh0ky83h3VlxpaBAfpCztmY8vD
 f1JBrNSfghQlAyIAutFYXOBqfZ2WgHruTYrVc5wW2Teg6wzNTBrPAOSHl3MGM+kCXPJ3
 nULtAhKH0hfUXuT/2bgVIGiRbCNk3TghM1aC5CkO0/Lcn6Go3jAtrbWnbkjziwnXJIvH Sw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t39v1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3hEMe018082;
        Mon, 13 Feb 2023 04:05:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f428k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSRRdr97HtqnJm9pc+qfWFSXnMhF9xzGt0lr5MhytQznTYHfP0lOXd2mCZxdoHcc/gbY8dnxX1pLE2PcTkyBVPTPx2UO78cEopg19FCavedDQwCkQEwaFIY6hLlt1tylQLzmS5v74tcWAw3ck1Fk/XDElmSdwbgYwENcd2xwtE8fCgy8TUR0FID6kxysiAamREo259uGfd58F/lU9aYRTvXKd0D6/2uYKPDbr4WyyzoYUq/5U86urVQmhSL77DWNA4GWMzE1loTU+kiY0+bVjhOMKj2rekBKC7jPgduDjIsr3tBUtOkm6hEWS9ISi4qBg/oiEBgYSDVioQC0/u1uaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vVC6OqKYPVOcntgWydM6vwQAwRiqD+nv526KHY190g=;
 b=TXfV4Wd5ln+QSdXMVHwNrDao5RfLAkMNNGiYndUZYp4MOzqMlmai8ipdknGspuhVjVFe7G5NGKo926aa9teWlgmHu6+AdiSWkB8tbF2UJETmslmV9fQVL7PZvboXFp7bvYEdN9073I5vmrMqCQgHQVKkef8LkYo+J4D/yqHod68dxi7JdqX0iT3VLHsVi9ffYK1E/LpYO468sZQMosLw8zmv/oeuhqYwC9V0XT7/bF9ec4KHyXvst4StLKyRT6TreguPyQkm+9+I4S/zbPhge4GLHB+oHvD4izEe4M0h9mYgznqXKXM839tlNw/6bIUxsqE4MN2yIfSNMRevrwUdrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vVC6OqKYPVOcntgWydM6vwQAwRiqD+nv526KHY190g=;
 b=fxsQUD6olfTzLUQjuqffti76dntlbkjGdCZP4Oykr7iHB5K2BD9F5wN0wj/g6SxNLMlxKUFiYJ4BZlWd1YpcE4ymwVzCDkwYawvoRUs2YnBXvjOv8Ptbf+/aFMdm7a0Oq5TGSJcRtevCC9uC6J8r0+ybwuCGmPT75Ox/UFKbHDE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4492.namprd10.prod.outlook.com (2603:10b6:806:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Mon, 13 Feb
 2023 04:05:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:05:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 03/25] xfs: remove the xfs_inode_log_item_t typedef
Date:   Mon, 13 Feb 2023 09:34:23 +0530
Message-Id: <20230213040445.192946-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c1defa4-bbf2-453e-c84e-08db0d778431
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w7Gdw6P0jTdvtjERDSGDh41jIEa+EhYd3A9/IJAXJgTSjwd5CB/GA+xblbh4J+TLytgUB+4WTDEjPFTa66ezObfXWxlVooaoJB7cAkSx6m3ukoxCXYK68JVBEh0BmNf8KKP39jNaza+f5dugGMDTxyrf8BbB524HW6eA3PA6nyTiMgfPCoaVhIUpZAOYCsgGuok9iN1aNSaOEyoQHcSaZKd//Vnfryo//KfifbS460z00QpCiCs+p+XcMasUWYj5+AEf2Enc2x4KSMSytK0fuA3mNymUUAo1vNdq8dlHzQr0Ide4Ty+cYTc/GdsE4mcnc5OL2aOUAUnJanabgn2/h5b6mmX9bKAUF8/2SQhwMmdMtNFVRqQo/RnsyXq6J5WnsbbHZRmPn+1sCzb0w251sP9RosoYyrPoh1K94NRMnLbh62gMfXX7+vGfnfK/1sMhMk8mDfvyR/qjT4PSi5SoqHnqIpoU1Xf61jdQcHHzqiMzbuDWYfvNqMrRnLShPtgfcQIpCIIRkMvxXfrxe1muEuIyZxPzz9I2bt9R3b45TvSblHz5EeeVDU1uZsizMEzsMS+fnu3fLF3g7f4+4ydJpYlEufPc3g1XPU0SvtTCyd1BtSaNOgVMCKe7x8IaImcpweUMiCQx9J3THRLLzCMp+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199018)(26005)(1076003)(6512007)(5660300002)(8936002)(6506007)(186003)(83380400001)(36756003)(86362001)(38100700002)(2616005)(2906002)(316002)(478600001)(6486002)(6916009)(8676002)(66556008)(66476007)(41300700001)(6666004)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LpbMTOF+0bc+RujanVFhizKxPdjQFN9q5sXlrwO1o86CZ8V1k1QAiT8yaD+I?=
 =?us-ascii?Q?04F1M5Y1xkHvavg6Nlma7arIUGBEZP6W4uAQNbm8ceuIMTPxOjaBjM79+OMS?=
 =?us-ascii?Q?dpe9lQ/cq+Jy8MWu7yBfdZ5FY/Uo62m2acRmWjQOCQ/nqNnTekOELWlIDXbf?=
 =?us-ascii?Q?W92tXB2BMYDEPgJC1NcEpnwnWZVkNiYWWDbNCfVy2IaOlSkHvybC/TFNIaV1?=
 =?us-ascii?Q?G99jN9M9CcGwAlsOO1SbYcpkVs9nyO1W1I14TGPnrietkNZ/2AAaKheMLC9E?=
 =?us-ascii?Q?QhhBc9dByKRHg/7Ap5c0t7d6+/OLJ3nJXCddWej25YLt01If+JH8cn9XL2XO?=
 =?us-ascii?Q?2RwzerzP/HLnEwfRf8UWlZ6Bq8EIsDvWRqHe78QF4aYwQ1U0w1qkQrMbTB3m?=
 =?us-ascii?Q?Dg4/hUENSaAlGPFWoGJXm1XY02JyRVoaf8iYmoSX0687f57mRlIV5fu7wEtT?=
 =?us-ascii?Q?BTBBhU0rw7ZzSF2YLmMU2dFaiUlpQN2EnjilCMVe9OVINwm0Owh0Rvzof8xn?=
 =?us-ascii?Q?Vp1B3Cl11IYMFsWdodDcZ/S9ZNmjj0Lu3rLyrsAoy6CdTegLsUmNua5QZfxP?=
 =?us-ascii?Q?d2+0rB7Uz66RS7rF7zYLdco5q+mc/E+MMUisn0Wf/JlH0kdIQ+QHBk/uBorO?=
 =?us-ascii?Q?i8603ZdPNmewFn/r+Uu9UVMGcTKFNbVA3DmBOEZnGph/yExzj939opRfwUSh?=
 =?us-ascii?Q?ZgqtZ2ALTXtdZgpDAbRtzCzQFpKFQzCrGr49oYyNt/F/gnXvuWv/X89QvqxA?=
 =?us-ascii?Q?GGTL6iCeBMhvoGu8h6OBPnM8awe19vhZDWRZOOoE84ewiBu6xpGyb5x1SvM9?=
 =?us-ascii?Q?HYRgc0oH+07XvJiUXYsHlyJvFxAOVdAzVFeK56t+7CE8VzIOD2Fq21NEj9iX?=
 =?us-ascii?Q?MIEfYjO+rJjsKZ9JFbP2x+ux3FGnAPmNJuDQLhPnybMKl63F/f5esZhuihfK?=
 =?us-ascii?Q?FpeIJ+CTPlYFM7hX5a0ZhSdbWrq1gHLRDP4f4bZSrYrJHZY35h+n+JRhQBDD?=
 =?us-ascii?Q?ieZOVeM4HBP7rIAd/aGKVHVyxhk3Upw/tQWRp8E0x4SekVwA7wNrJ2TmBWwG?=
 =?us-ascii?Q?OUQJsYi/pWD0jVgUxRqpj+2qOyIlNkWGWs5w2+n0uxOAqr6ZmrbM5MPK9EVH?=
 =?us-ascii?Q?7tqU0146OMoGR7AWENK48JGWOhFMMLBUPJMilsEJojIWniW7MvToQCox3FJv?=
 =?us-ascii?Q?zVrpmtAqGsI2Qea5vK2JmpJOWADk2qsKMH4resSdVoAS+iFC97eT0PjCosF8?=
 =?us-ascii?Q?1CDT23HCaoCarxtVhzX3KB4C/EVIxNIgXUGShf7mILwbzSsTmEJpVi6gVJjd?=
 =?us-ascii?Q?wNUdXalzTBa70IYtv4Fv5Nscwfyu2ayz1vCgb/n503ZJubL6sIpFvQ1ZVY+o?=
 =?us-ascii?Q?X55JofQtusYxKlLnyBMLSDizc96HCOnwsULl4559fOtKPoErWyhrv6CMWeaI?=
 =?us-ascii?Q?uo0fjoZqOOoUxzUVaE9fN+f7yOXrcZdll4yWvr83cHy6q/juUk9XcrHUZTKU?=
 =?us-ascii?Q?ey6nRR376R661ASlOTneyDr26m2Gqzb4nlR/GUTZrUUe6q1dtwLW70jTt/bZ?=
 =?us-ascii?Q?5G+SERPYsJb1FMsvHkqklnaXJRbJOeBtXOjhx9MO1XQozQw6hLLoEglllzpQ?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EQ822hG1jF+QMVtpy50l0QiNcaLU1VoBdmkk0TXYqLWe9JaVtGzA4vAfphMWXNG0/JJgr4niYXNZlWC34yMqTlUCFqLMV2yHOghPRV0gTY2nCR9fUngMdFNkxPepsiTqdYFH9LEn3jvZu2q86JaGG7kJbqw1c9PKuQaUZ8/IiEAPO7cT/B11XS/GBM6KFyDYWVcK7asQACxXyq0bIN9AV14KEvWIhCOk0ZIA2R7HEbpPfkL/G1zEvIb266+sgS/RvnTaobrukIbvadVQ1IyShsPrz9OC0gvVxeK6uzK+nQV4cI8z7jUfNbtL2tZcPhYIw/AQVuI3yBnoJ5GYphpF67j/M2lX2Tg7KPTAmL5n7/qd02Rvn27dt/UbbFcXL4F3ENzwKl4ylbTsLHch/ZUmCkgsSma9DsVKq9rtmnZOnUdueODxSbzssYF5eRSfoeP8MhovdkW1JOaSDEq1+QgDF+d0vHDCDyPgJ7Unaz4wUHMi0BBiMgMaK64OZpBWwCzj5XBdlmCduMmI37/vVhCinIchc2r6ZVSyh2X6SbpmyYKZq/Y7Pr87t4LAsraaTSeYRAGv4OZoWvHnQtWd54BmBJ9Rn48HtqHUEFYOZcuaIXYUShEVzez56xHeBJYZlw6V21ELiVvspt1y0QVm4LeCSZM2KHt1RBrlgkB7fEITz1c9sD1nz+Cde5nXRoQmOzdZ7ErW51AXZYylirhBxTtQ+jnTgJZRjPmAnb6DmDv+iHNi8MDpNKdh9hnZNqCb1RbLjnydb0EcI0VCgR08eMXedSJ99MG6VhgcvF4fhIkM/kLwjvnva6FrlKVW8OQhalo1
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1defa4-bbf2-453e-c84e-08db0d778431
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:05:17.5837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26YOdCfIqa1ePXlmw2cZQp0ii5Rgc771bljtEehZKbkVp6rZGDEky3BnbwKwkqv+jcWsb21Rw2jKQGL/FwAUvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-GUID: cnTmPdXotzATtO9oDV1OfdT-fZydZtc0
X-Proofpoint-ORIG-GUID: cnTmPdXotzATtO9oDV1OfdT-fZydZtc0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit fd9cbe51215198ccffa64169c98eae35b0916088 upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c  | 2 +-
 fs/xfs/libxfs/xfs_trans_inode.c | 2 +-
 fs/xfs/xfs_inode.c              | 4 ++--
 fs/xfs/xfs_inode_item.c         | 2 +-
 fs/xfs/xfs_inode_item.h         | 4 ++--
 fs/xfs/xfs_super.c              | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 15d6f947620f..93357072b19d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -592,7 +592,7 @@ void
 xfs_iflush_fork(
 	xfs_inode_t		*ip,
 	xfs_dinode_t		*dip,
-	xfs_inode_log_item_t	*iip,
+	struct xfs_inode_log_item *iip,
 	int			whichfork)
 {
 	char			*cp;
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 0ba7368b9a5f..1d0e78e0099d 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -27,7 +27,7 @@ xfs_trans_ijoin(
 	struct xfs_inode	*ip,
 	uint			lock_flags)
 {
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (ip->i_itemp == NULL)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e5a90a0b8f8a..02f77a359972 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2555,7 +2555,7 @@ xfs_ifree_cluster(
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
 	xfs_inode_t		*ip;
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 	struct xfs_log_item	*lip;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
@@ -2617,7 +2617,7 @@ xfs_ifree_cluster(
 		 */
 		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 			if (lip->li_type == XFS_LI_INODE) {
-				iip = (xfs_inode_log_item_t *)lip;
+				iip = (struct xfs_inode_log_item *)lip;
 				ASSERT(iip->ili_logged == 1);
 				lip->li_cb = xfs_istale_done;
 				xfs_trans_ail_copy_lsn(mp->m_ail,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 76a60526af94..83b8f5655636 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -781,7 +781,7 @@ xfs_iflush_abort(
 	xfs_inode_t		*ip,
 	bool			stale)
 {
-	xfs_inode_log_item_t	*iip = ip->i_itemp;
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 
 	if (iip) {
 		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 07a60e74c39c..ad667fd4ae62 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -13,7 +13,7 @@ struct xfs_bmbt_rec;
 struct xfs_inode;
 struct xfs_mount;
 
-typedef struct xfs_inode_log_item {
+struct xfs_inode_log_item {
 	struct xfs_log_item	ili_item;	   /* common portion */
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
@@ -23,7 +23,7 @@ typedef struct xfs_inode_log_item {
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
-} xfs_inode_log_item_t;
+};
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
 {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9b2d7e4e263e..9e73d2b29911 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1934,8 +1934,8 @@ xfs_init_zones(void)
 		goto out_destroy_efi_zone;
 
 	xfs_ili_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
-					KM_ZONE_SPREAD, NULL);
+		kmem_zone_init_flags(sizeof(struct xfs_inode_log_item),
+					"xfs_ili", KM_ZONE_SPREAD, NULL);
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
 	xfs_icreate_zone = kmem_zone_init(sizeof(struct xfs_icreate_item),
-- 
2.35.1

