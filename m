Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55679C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiAUFTr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:47 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46552 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbiAUFTr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:47 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L03ra2001018;
        Fri, 21 Jan 2022 05:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=qhIIeDKvPbp8B9I1H+KIoHvECTRCU/qO0WQc3YXzzL8/3oG7xNwZA4cpMss3YnpvmQ0g
 PKRmeGKv9c8QMIjBRX6iDw8wK43cnaMGM+hw3UaR7HHMhHKABCK81QXKnjYubO9QVUaX
 MqmzyYrfYdBNMznmg2bPckSfb21blJ2TCOmr4dkJdaNYFAO0qRYyDJ/bu74a5JvR6a/8
 fUvXpnsxcehx8VjkmwjGHjJQAvfjzvysAcJBTWkcYzK4SMlUTtsS9RYMs/6cfunQG4st
 6dCx8KRBQfAqVS9HY8nhVXVaVEk+R+jJ7IEGUEsrSU3ILmgBLtClUldxYtHHvN0c66hm jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhy9rcn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5GUWO190261;
        Fri, 21 Jan 2022 05:19:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh03x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MG+GLmZnsZANShRPvQncsZNgbrle4HTgpe9faN/DqKORdgBT9Wv8TmpBhEudgnE6DDeaJ1+tYElkkGqPdhBe6NNn9hNX25/LI9Ecg69cbe3qqvFtpNtMUmGXHhqEiychfje/QThsjGquup+vIqO1V16+zpLdNwAdy3gx78wcYwkCLQ7NjJUaeWem3ZshSnvuNlNJAcIFkibkdJUbAii2E+GOVA5Ee1c4s7oHhM2tU9WiQLRX2JqUJenyXO5pyOty+56CdxJrdRE3qMFmZq1rkaXTu3M9CUZoTx1Sbm+k8vtcVBo/Uemf8tpkD3GxQardHdD4JUggAxym3fPFsAnxKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=Flq7gBrY8sMDLvE94jddMsxUHM/2IKcWsWOtnD3lwNKgCUD9+bgc2o3LHtveDm9Xtp1bFxFT/spT13BQIMkXIYipdt9Y1/VsJ3hBoeXD0sA4U/Mxj1fgiI1xJRdT8LjSjxLU9nWM7bKZIGPxj4HZxP/+/9k5Q1DqumpTPgPhM9a8QaOcF81gB6Iwi5bXv7yFBvsYz2nN1aKXAkU5Y2A9akIO/L7ohOaH5F2/2AG/6e4No65drSN7DEuHW7EP+hryJe88hqyXn98O2lDYS6VTh6jawSAAlDdL5pBYEwpvVeDFO2ZG8KatjfapuyBDXu6gUdclS0nO/49JHeMEaKM0Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=AowCfoWIlypqQp/6fTL9NDnR2FINGTqBsGBIh64JMJbfxtFVBypcp4P0jxoI3z+68eP6sepautzLUo5WCNbWlCyozHsE8O65XEYAuDI5S/+04zFPi2M2a2mVPGXu8kg49t2z58SPhdpekR05FXytVxjAcwdP1rc2ezHCSYGkrpc=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:42 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 07/16] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Fri, 21 Jan 2022 10:48:48 +0530
Message-Id: <20220121051857.221105-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 624e5ed6-f3c7-4d30-b218-08d9dc9da0dc
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB123667F2C4AF716A729EB61BF65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e2y8gaAeNYSDX3Fr73bH8f4s7tmdoRmwuIgw9fP/bTvLtUlgPpsg3gfolS+KRy9ov2hjT+mSlLf2j8A34NbPCLTnISDvsLAY4CGwXRDVkiM1tyLCLsHLLXsL0f/RK+HeTxOAnC/4sFjpASstbYEqtOmeW2LmW9yqDqaXFjoLB0tKRQhsAfLZ9gy0Q6oev/BjHLoh9beQ4ZsqldkQUzAL22NAQVDBHHTw2Y0PehbRSw2S9oWjfxR8zAG8w9n+rm6bNTgWcltHtwxdGyb8J8zk7cXXhbxx4snznLsXY/f4trgMwq4+uMoxAfNR/5i74yNlf5CWYJq4LhlUFQifykp9IHJcfd/BYt1gEp0K9+twk21lnnGC/Y93ZehLUUWvNYaCfio7cnTjbvIYQ38CKRGNM9ZTGYGmZ+isT2zNQKj4YItWyj8Nm6nyFLklDCVEaBFQHtr9zXDDxuh+LHM0ypGr164smznJyq9HYnYG5Bp34Us3JDnVPJoZ63wDYSo9jFrDa8AwMDAieBnevKLUQJ0Gaww7oBwGOJ7A4ghfyf78z8Kazyox2lKhn/Gq8TGGMzizo9f3TP4PegPooavXD9ifxk3ypkKr+4VcEmuj0UflyXYdxp29rOzVkoGcMCq71B/x5F6nBPYPHblfhGs2o/ILM9yCDRzHMN1E35bxrX+Aw7FesJg+GlK3tRkEtniwWb3K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(6486002)(52116002)(38350700002)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iLJ0c+ACDMz48Wq5njgtGgRTwloku30QHppEBlDO+PVrJdvYOWwx5pv2Ek/N?=
 =?us-ascii?Q?hmRSebxX3uDo13kJx1FUiw4GnQzZZ9YQUxLQcJj+sUwhxrtvAKL5CRzl6nxJ?=
 =?us-ascii?Q?veFJYBGP4yLP2SNdOj4gihhKDhjg5lae5LLFYtK2haJnNfOjZHzKeaGV9+Fa?=
 =?us-ascii?Q?YluhaFC0sqA7lXsMgQo3eQxO9uW+ZMaLLzAwaqwvcLyzA4qUIvkPCFMcj8Z2?=
 =?us-ascii?Q?AIMc/X9Y0RhiNe0Gpug3137tTjxASzk+WoA17Or/fPmvSP1zsyiQhyyYOV5w?=
 =?us-ascii?Q?e5rT61XJijwPuP3cHShnzlZ003MlbsgOUmiS6xiZjfu/hTkbHrEvr2Wo7e89?=
 =?us-ascii?Q?PzajYa2I7onApV8ErLsU/HfO/ffHlgXyeseRWLWEjGLo9gZWsjXSWd8cBmCc?=
 =?us-ascii?Q?sz+FynrHvuraLB73LpjuQt4gh+VqndIwbNYDCjLe+hp9obU/mggL8HDi0YeR?=
 =?us-ascii?Q?FY0fT960lT2woi7JNP1ScPvm2pNRM3cLDYyXaJJ8mDB9Yx16jBueNPArtv1j?=
 =?us-ascii?Q?IO2Wy39HyEAwS7LB9GT16eTMDrLmoJ9InjqQK6WrK75wS+ZpsUU8oiixY8Co?=
 =?us-ascii?Q?U9NAQu5fdf1V0o8vo0Iys4ZAyjpzVt2qk5VxHpfEbJhbKl2A/CkBqSqQROkS?=
 =?us-ascii?Q?PltgNxI4b3MRNapzEyKjOaKeoPmtlUD0Up992GdmkkkW/tsaeDfRsgviBnv4?=
 =?us-ascii?Q?6kUX+TLpZwi2CG5W9xAg0zbcTY3C3nUq+1HtsqCN3bM23AbSjBfF4+7Qv91y?=
 =?us-ascii?Q?Celf40EYT6wBFvceK/mbbYnV8afLVzBqiNmpZ5+tcPZD+hsO5VPZbDkWK6pU?=
 =?us-ascii?Q?0/X3ZxEzftO4y+g8ZE2qF3GzxBrm7ArzQ1vTs8FxEp/5dFo7bUSsI/TpsoCB?=
 =?us-ascii?Q?1dJvBbnZ8XWqxH2RXj9irofaIYdY/YOUAksb5IbVb2fhAIO1ZXfYrtlI/NTu?=
 =?us-ascii?Q?xEZjl8DgFg0DEvMPIjdYUHat8nGSilAKEy+JQQLLA15844W7+LfuxE2XHhMe?=
 =?us-ascii?Q?ai3j8rSZT5RuE9A32Z6efUyPE0fxrQEhwtiuLxNpl3UWBLrkkg3Vxqakfiyi?=
 =?us-ascii?Q?Ol+gLUyf+5osajUxZZ9kkLMlIv7COStgXsqBoQ5bCB0zfJKqFvLNlHmFQMeu?=
 =?us-ascii?Q?KbOOK3NEG/v0miQVw+T0xKnx6QjZGogGEPdom/ZsI8ArWRX/1bZCGOb9TBio?=
 =?us-ascii?Q?GcTrW2PSV4WQ74C7FLkW99UtNEUzovaSIKgvwsSK+4ZKMRj3t3XE85eBbUHt?=
 =?us-ascii?Q?P5uQADSdTgGDPMUoWNS3LkEBskBoj2maGHC8f9iBvrnNJOnzsaHp/bgK7zpN?=
 =?us-ascii?Q?QhqJiej6UeShuGWvGZeRlBY+8tXLTmZu8pINdjY/MtZb2E182H4NdjOpGWFW?=
 =?us-ascii?Q?4ivZP550plnhXOmFdjuNNx9xM+jZyflvUSv6aipZLJY14c1+PEJaKqHqQD/l?=
 =?us-ascii?Q?OEE963C6r1oM0RpO9neJFSRDFa04WABIMrZUD8A4vbMzrJ4koZKAIlQyoO9v?=
 =?us-ascii?Q?GteEVjwXQKMAxTCj/BXqWknk1Gq8zXuW6UT2Q2UUx6B+SYhWlnYzt0TSCzcW?=
 =?us-ascii?Q?GkYvWP/nX60kK0B9UUfG5uQ9lUCDLAh/DZTOo2bDrOxTF8D03FNylVbCzLL0?=
 =?us-ascii?Q?DkoEwr+LLYnB4dw8OpV08lk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 624e5ed6-f3c7-4d30-b218-08d9dc9da0dc
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:41.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvZEBdIY6PyiUnSdlcbUoXDOvzl8XHz7QlIL7ZmmK4gfFlCYa5xp6f3gVxnEc4bnz1rrClOEQ50rcpX88mhhfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210037
X-Proofpoint-GUID: MepnMzKEZnzcXI9jrgGqS-BD9ueZjqK2
X-Proofpoint-ORIG-GUID: MepnMzKEZnzcXI9jrgGqS-BD9ueZjqK2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 3 +++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e5654b578ec0..7972cbc22608 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4e84aa1d50a..bd632389ae92 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -124,6 +124,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_BIGTIME;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 		features |= XFS_FEAT_NEEDSREPAIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
+
 	return features;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 00720a02e761..10941481f7e6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -276,6 +276,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* 64-bit inode extent counters */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -338,6 +339,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(nrext64, NREXT64)
 
 /*
  * Mount features
-- 
2.30.2

