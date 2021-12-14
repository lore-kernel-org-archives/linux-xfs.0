Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A6AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhLNIuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:03 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17136 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:02 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7KL6Z022072;
        Tue, 14 Dec 2021 08:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3KfxxSxLkQmS9vEJk81E/eRVCc9oNIDNWKI50uq0Uo4=;
 b=biHa7kgkelvhkiE2FERznVL3/iLAy3Hy7aaDdEgPg+wDFDOb/rZg+Sl8Azhc/3fpx9VS
 tTNaw0lOABJh9BBo4pfcX3dBKC31UkAf5TtqTXkpjk7ugmpJirlATMu4GHIOqRVJjtf+
 sNNu21T3K1mTnBFnqQGfsjUuvaKzTh2/6OLJklgEe+/hNcZg8W9JnkpKiZNZ9zOA7omv
 ZQoHVxlqsRI448Ysqq3zq29mlVDTDHf5D5qxeBdit7/C5xKeUjn7+NuzMZTEDtiqG7i5
 bJFssnY0yhxdwRMNzna+/0SNLxsqN0s8xLaTQHQONFZ0KMAK/xCjvuj/R2UFpmdAzKBh Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfb6k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8foTR104448;
        Tue, 14 Dec 2021 08:49:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 3cvj1djt1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4m9P36U1ffPYAgzwG7j2Kc9wkd0srXjBm+XnZOvV5e8DhwsD2bsAELDBgvbmPaNLtJkEgFFvJzR1UuKyuLGvvztX2wz5789tzc/sYD0zHxxzLEGr+vSHOOglWtS9OKTgT9J0dMBpLH6yjgIdS+ntlWEZHldvjlF+lx89M4LxLeZJw+4KusAHjuo6MhVSVjIlESd2fUXJfrq1YYcK0/Mx3JhRKYSvBxlUySQf3I3Xx1e3yY1SbKEfrikakkw8W8ymnjW/FzKT3hBLreS2cKKpL27PBZYY0NpG+gzu9MVeMOD6op/VPtoFkkzdjM3rcRMh4UjiasnQYjEMuc9CxF+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KfxxSxLkQmS9vEJk81E/eRVCc9oNIDNWKI50uq0Uo4=;
 b=TTFOnxYT8/UYd6V2M95WjWInSvAWFFQWOMXu/FHUbwRchcrNafBjVdCYUrbfh2Bf8BQmIJ6fc3WJnyaGgAxQIpD6Em6Bypfjcpx9oB7P9XyDUtVq1v/uWguKyzDMNbhXgM0ngjw5ggDxogLPYRl6041HQXNq9Yh9oTHwJ9hJ4EaeUAi3TfYtwHSIcTrPxDfSWHLXl0L/dhyS+j5aIXviOJ2z69OkbvjBtH62oy9UnKXFQrWDA71Q6DXrf4V18vcjp9H8JWb4da7HS8NzUszv+lPj+8qwu4vnSzX51h+389/BAJKek77i/QSa0pnQyJCzYjj+62nzw2G+hz4By/dC6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KfxxSxLkQmS9vEJk81E/eRVCc9oNIDNWKI50uq0Uo4=;
 b=I4RhiUYx3wdx/iEfKw1baPM8atG5Zqrr2mm37D/gCUGXkNZ6ocJLOkjfkepbI3EHX19rY8jBE67c08TrLtZH2FajYBlCmQBXdX/EeYKxhapZX8pFFf9z17t/hEmgFcOO2z4oNz3Vd7qU3bUrk69uqg/9Vhn9SdGMlqLQg9Dqh90=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:57 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 10/20] xfsprogs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Tue, 14 Dec 2021 14:18:01 +0530
Message-Id: <20211214084811.764481-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c672a07-717a-4a83-6447-08d9bedeb452
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB26561958B4AFA72E4349A063F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQcbi3uX7kES4HujtD5y9GakiIzSkbGNCAqsYhoko0h0GvdEro8Gg8pHbPWoqQDT6nTtyC2uxxV170Z9M3B3yESR0mHOtFIpFJdMU9el8C1gNFOOefOql3ZFOAd8/5HhQxM2Knzy5ZNK7NT4Ud4EtEyj8fFgKrYvin2VRRvsre4BxsAKwGdxRpELbRAVprC5gsyE40IT7flUXlgKX1LU6nVkdQjN/Fgk8IbckaYYkQjL16OjGAKKnhVdmPuJ/H4WgRZiSkGqlfGmMrdxgOHJzse5DB68FAwrzNGXPsbU2L9Zs3HUsjFQBeIieDl+KwqSr808v4g4LQSK6bUUeP8ReERt9IMKu1LpaXxch7AgUwgE81yUD+EG+LLAGA4Jjd5V7O8mc+Pd3Hku6s0pFCToYUq9qQSTulFB6yqNjWzrLgMEmXZctvGkEjpVleQHhw2+V4KWf0vmEys/4AGMyCfVwI23qWlG/aF25ihuzgIdy5kPxCiatFlsdTdXShyqKYM9vzmG+AJolQJ8rI4yDVgyiS3zqgcUuL27L65QmW0obLtxvqXJSK32ONeTyCfMPfolr4Xnt66BRQ2iucD6wm0CZIrxBH51EBbI0jDM7m8e+2b9CXKTbHObltVGDF1hfLDCmoQbyJsEc3bxcHB9SP7NUWTOoDSr0/UZqjVYiv1uqBnx7b/UIP+USUYEZJdZdKBlAU5x//yG3eo32BHxpXbkUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tl5QKVgbOgDPh+9YoePeJecsktPo6bPv+527h6ck0cSS7Sci4jBdLHBdSjwF?=
 =?us-ascii?Q?4Vr32we+AlN7seAlx39eizHU1k9hL6v0ANHWUgfuFfdmr8cszUCC+EbZ4Vvd?=
 =?us-ascii?Q?KHZHa0xEFhpVh3fD55TvkIW4yWVMU/V3Cxohj78phMlzRo6XSL1E6Zazwl+i?=
 =?us-ascii?Q?tdHNPF171F+HVZdCfpJaflmQX6fF+IW82HucucxwHwROKebNTRjmMxvIkMVM?=
 =?us-ascii?Q?8P2RjYgvxLIh0KLywo17e9tiL2o6yPUaL8ouuOJtwJXb8owq8uAwQJUNO+Wf?=
 =?us-ascii?Q?LAp+7nlQCahZeXthB+DTOef0qfKEBUCm+H+i2DKJXKRBSb8HXwnTpEVFJZt/?=
 =?us-ascii?Q?iErEqcB6sdc2B9/+pd75eO3SYp8QlXOYiKJsqKRb6AuEWb4Wj823T83uHs3L?=
 =?us-ascii?Q?ToflROq3Cu/lTqAT9uZUWScRXAqTf0UcRxh7OTeJwMs8vv7STsEGTg/57tMj?=
 =?us-ascii?Q?YhZ8fPcA+JABKDMppcUb4NRPfHkeGsNIizsM48OJH6z6aAcRMGjQURg8+kMx?=
 =?us-ascii?Q?H6td8/5rEPndoVMwcLcsLpF/ZyU+iVJIxIga1/SleZp771XS/NbLpSk7WbuE?=
 =?us-ascii?Q?/g52sIDQYyJ9NBUGQma8+snqfkALwpP/QS8eBMzq8PzkY6KQSdZuHjaipsWO?=
 =?us-ascii?Q?elU2udSh97R2hZmDWTZFNotPVhZlvRrGVKnzNVCdV8S1oCJqEKh4mcxOrV5/?=
 =?us-ascii?Q?WncRYxTAFmnfVJ/OCT5mPd/JejO0kBrgmzLtPSbIGAAfyzm3Vjua6OwWYJOA?=
 =?us-ascii?Q?K+eyoiYrn9U0yzgdSGeyS18WXEkmypWRWbfiNf6/gEJidymKQr7oQ/WKc5Vs?=
 =?us-ascii?Q?c30NZ4adA4tQNRsrB+gdT7sgce0ktmHTLgx0VJQkzZhwxtObHiIBo94Fnh57?=
 =?us-ascii?Q?uE8hfis0DxOdR7hHN3jMvj+YBowi3fCtBa0cNnKzNofDsa57TvELhZVOil6f?=
 =?us-ascii?Q?Vfbc4WVpJZG+Z84/uk8QkYWNWDbOBf9UsjdnsFLhDm8PGXfQ+utvrupumOHU?=
 =?us-ascii?Q?kfvJuT6xv8cYGhDTx+6QgSLxZWjJtoipbOvoPva+rh4jLFzliepUMkTFRkEn?=
 =?us-ascii?Q?7JunX8wQnnhV31BDvEScMSmfEhplwmLfu3cVv/Z7iVK0mpXbOnuNdqonBQ4N?=
 =?us-ascii?Q?FG8j7qfF5IEPRAZWuQqI/8Xs9Xa1bnHT00NLkkhQnkgvqoaxL0Vd0xoR4IFA?=
 =?us-ascii?Q?OfVe57m1t2rRqhyJ6uhQqI1GfumSSHQaDNidIW3pw51YeIu7cd7gJ6fER29v?=
 =?us-ascii?Q?7AQJpWaPAzpyS7yApYagKI0OpCvfxkCwj4jGfIUyqlx0LXiSdwEaGhzqNsBA?=
 =?us-ascii?Q?gkyQDgfLHbZ1LlNjyCmah/w0itVU9BPWX072y6jO1KIHISvCafaRjn9BdG25?=
 =?us-ascii?Q?WzHRZ0Y9j9SBMP1T1szRi0JH4E0lSiqXZkKlZtNv1V0MQ+IQIu7mXRud+Aai?=
 =?us-ascii?Q?mldvvpQY0GrqF9CRWBUQ4w7XIhxUExE9y4ZBG1We+C3ExG5rkzgD+oov3a7R?=
 =?us-ascii?Q?1AJ/nKPd3HrvbQAc2QxXvdxT848clRie1ICsDRPRju6iEZrwfoB645K4Aj8X?=
 =?us-ascii?Q?FXrOI3W11zLevLKVs0StffbILJkgXGC3BArJaP2IQ0VfVoZi/hJbxs9qCsYN?=
 =?us-ascii?Q?Al/AKEsmUcDkX4fX6bDnxRs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c672a07-717a-4a83-6447-08d9bedeb452
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:57.0396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hau7In+2fAymKuewRi1odDZ40FGbRNkQer5be1TiwIY9RFl1xaF4BdWeD4XSAB864dooO0EgKs+0LJozG8KCJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: MU4fStQMIQh8UEua72lNClwAZAfX9M0c
X-Proofpoint-GUID: MU4fStQMIQh8UEua72lNClwAZAfX9M0c
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/inode.c          |  3 +++
 include/xfs_inode.h |  5 +++++
 libxfs/xfs_format.h | 10 +++++++++-
 libxfs/xfs_ialloc.c |  2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/db/inode.c b/db/inode.c
index 9afa6426..b1f92d36 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -178,6 +178,9 @@ const field_t	inode_v3_flds[] = {
 	{ "bigtime", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_BIGTIME_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "nrext64", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 08a62d83..79a5c526 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -164,6 +164,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 typedef struct cred {
 	uid_t	cr_uid;
 	gid_t	cr_gid;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 23ecbc7d..58186f2b 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1180,15 +1180,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1196,6 +1198,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 570349b8..77501317 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2770,6 +2770,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_sb_version_hasbigtime(&mp->m_sb))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_sb_version_hasnrext64(&mp->m_sb))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-- 
2.30.2

