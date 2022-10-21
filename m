Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B846C3A59D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJUWaV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiJUWaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE8A262061
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:18 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDqvI005623
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=JD6DT2w7vlJEVrX25WJRekq57I3PmEswp+QZu0gHBR0=;
 b=XNAHoh/yEfrFdWyJVOCx/VGn6J0KkVSMcNa4O4ZZOYmT7qlTUabdI+fsdC6LC35pD3OQ
 WnefW4MfYrnxHj7z3syzMgX8SPMrnXcqFEpvfmjWbAwE1kZ7/RG6Usd95SK70RXgyFkc
 klZvtk6ebiKMArhg3ZqEj92qwJ/QmcaDR8oSmjCnICIp+6FJFaY4SpWn5MlDBRM6aiR/
 pZv6xFhXca8u5Z0dQNV00V6nXH4VSlUTY7pms8FawPS+lzp3hdEnAHER2ymPZbpHP9uR
 PrugsG03Slr7F2gnp3RByEIsF1mgtUS36Np2JzUW3SsiRFVN1nGh+tYrMGNdBI+6jcat 3g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndtua88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLJj1l017056
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hub8ju4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJA1QucDTm9sK5twBA0W1Pb3NeLjIRHrWBEq5tgH+LVJexIZvTJFxoKHIawkC4BPeta14Pt9lyBtsbVMViU2wAMk45iXiD/mzgmxQ/erMe44Lxt3Tbq5JaChzv/yqRFrObykn09yn734V4Ym2fc40EMZQhiFkKU34aO4zlCjpHpvClQ4hWoUplAmlX5LJ4LX9zVW00h/B+5ZmK7aIIqQV/PzI/efp8yYwmdT3j4yszQyxIl8AmV/WZnVXEF09rzO/EqFLJ4tqLuowrweAIxTn/xUa9T+MKMGYpORxl+xgvcyN8GWWH5rFv9eyb2ysmc09Pv0iGKFppsIE/513l4bwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JD6DT2w7vlJEVrX25WJRekq57I3PmEswp+QZu0gHBR0=;
 b=WwArCFVcylGilQId7H1Fx7OYnmo4Zqlr8xNFnRvBVP+kLcmgFHmhO8q4iqXGz7ZPGHgdXTngQ8BjRdWCSPfFt1w1oKheHYecGGC3U7EGfpdTDRAwAbN7Z+0k9hJNPKALkKVVF0949v5M9GbRRyESEPluMQHzcs3hYRIEZJiE1QB5PRnRGPG2HiWYxn6NENOmlAhEjuXKg1xaXQXKSVs32eIWnrlAko+FIpEpUUEClGeD1KEdhcemeirPWXHwtHZjmbLIEQh/1aDEjHXYI8INFXyJD/+qiW3d+/sXZclCt5FMUszQ2+QztdIhZbyF/zma019/sTsWSx/ZTM/HTyjGeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JD6DT2w7vlJEVrX25WJRekq57I3PmEswp+QZu0gHBR0=;
 b=exkFlG/f0k9+wyVZUpoB6m4bDMngSLIVNtjJOiu58e6z4Us4/dklwKwTif4GdMOgxNHX336o1lqoRBSYqMvYnkykQ7+YTTgBtCXgXltqoGkbArywE+SBU4z4DL6odWfL8MK344ows78JWjLddJc5I/mVwfPdEWjm/YnsSfPKw8g=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:14 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 22/27] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Fri, 21 Oct 2022 15:29:31 -0700
Message-Id: <20221021222936.934426-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0120.namprd05.prod.outlook.com
 (2603:10b6:a03:334::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 420795c4-8932-4f1c-d3eb-08dab3b3d2b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PbHvwwQHy+FojfJ4CPTUuUV+DKibfVLXLX4xJKhLH5aX+Flem7DxYq1HkV3bbWSkH1irMjw3rnQowSZ4LafRBFiRtw/GVtnS7K3WQtM7wuZtdSHqSNqkIaxasQEpL4NhPPdXm75cYMlM62xw/DATH39M0cYFf+tjPADixzdDoT3KsnjlnWBtLOwjswNRTG7hzeDY/c+0E2OZCEmfq8sAM9pj3klgq/Q8XHpNnEaZaK4VxbHqn4NCW/sS+DUXL8HIDFfuBLC5u6AgUTJf4qW85qcnRqmZFzdcVBR376mGihFtZEKtqgSzR1oBf6s2i9omS6n7IYsH+aYdXzeA3th1Do7RrBnv1m32dk3dQrXHWj3YH6xEMUWk48EKg/ZrAH/vfeB/8AoomwOINHVzo9K3LRfw9PgshNytfgOlf7EHrLHXd15gwTyLmixX8TfoajCo0ybVKT9oCTGsan9zRnCeVC+jLG+T7DXCN+jjk5lTdURcvIyRO1arqu9xHGPSwWtFOOw3R/r0aeUv/XMw/wEmtW7TKyFJD0VPUTEKHtbLPcyY/2ftV4xHXchYl9l2yWzKlQ6JPMkQWfoCvRw25l0e4vFJylJ7gQ3xe4fMs0GwcPoAGFHmD4T33oItGifI1kCVt/uGIoXsRs3V5kJUrjqXU3Sw/L2W0Dy4zVFziTScnu6gS39yq+wnFgxk36yplqk4vJ7HkibxiQ1qJ4ckUZCpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pxDxKQGDr6Ht/gfjcoZydc2QeMkanc8fjYCPtAIt3Nwr+XUX24C3NxEwSLOC?=
 =?us-ascii?Q?2X+4M5BlAv8vCcdcSukbOU0Z2UXmzzIf1IPBFO9r4wFdHiVDCYHJ2IEOF4bB?=
 =?us-ascii?Q?qGlcqVa2WQoTUAFctglV2MuRaEEKJ5eHDcdtj2h1c4ouqiqV2qJ9/erVddG4?=
 =?us-ascii?Q?Y0xHdi3ns6BVuGMfUEGQEF3dPsIGyPvRTwYKXeG4Uv5Jwipa3NN6AbFU4RIS?=
 =?us-ascii?Q?07udiPkurryS4dbdh4PLdAVDfKIMTs9WhcbuVAz/h9xT3nOrpUhP9wiVCMrF?=
 =?us-ascii?Q?pMiusOO1UH1aSWpcvRnC/I7dz3t6Lc5R3ETYR7VdnY0ZeuXs0Cd7XTJUF1SL?=
 =?us-ascii?Q?oxjz1Nsoe4eZnoPdoLbwHNSJ/TIy4z948ZpoEfdAIlqYG7WlnDF5Jm0/Ip/p?=
 =?us-ascii?Q?ovr58qL99gkGXL2tSqSOwSs3YDut8ZGTcugPrL/00jY11IScItk2LwWmRc3K?=
 =?us-ascii?Q?7rFgIGSXOee1WIzc+NVQkOnGX8GX9ISVkS3XTHPntLKOVhHnw5xb7JR/cS2U?=
 =?us-ascii?Q?WA0aFCumPjxtPj+yK1DpZYRPL/dsu53vyy/nLqv75e1gLOWZx1jOu850yDgt?=
 =?us-ascii?Q?q2gzWZ8BrsWzOMQBIoDt8eV1oMqihu72FGGtXSGfXxDQKehvmOsZ209QPYIf?=
 =?us-ascii?Q?eBY8Ut5g16S1c+lui5L3VDSMjuGIXNK4D4r6jk3KJu3mc2OKrMSO5aplHTZ5?=
 =?us-ascii?Q?Q2ZmLrDTl7a6R8l/a4bX3tCinOnWqkHV46xqT6hQFFsDuGOc29lX1KjNgoqj?=
 =?us-ascii?Q?01gfZFyyWQFFop7AJTgtdYVEgTmsJw7jzeaTRB6DmkP/3lNfSY7LAEJaRzr0?=
 =?us-ascii?Q?UhO4ZgrxE+Ro41BznUrutZkKLML/13Twz0Yd/LRh0POyqXjaOkpHKbhwCnb2?=
 =?us-ascii?Q?tk1dkcPcrsOpCQ5ANs9iHKmBGflCAUOHutFA0OfLQ977zXmu2yAX5Jot192x?=
 =?us-ascii?Q?kimQf9XqpYhIhkzsG9ZW5GDd7yWUcg89C5bPvqMebQI4HpVqkK/lrT0oeKC4?=
 =?us-ascii?Q?KT2a8edXxizo7MQ8CQKLI4b4rjSBjYKcQ0JsVjIqEc9s72Vwh6V1VOgJrDCj?=
 =?us-ascii?Q?dLwSBUsnRREuqkd/YZScc8pouPYZ87aP+OLA+Sy0pNR3ZmEQygDorUsA+5SZ?=
 =?us-ascii?Q?fM4crxlP+Lpojs2pIfgO992db5z/qyzW7vUxyS+gDDv3EXr5NTeNCnAFTgls?=
 =?us-ascii?Q?dGNnLnLXsqIWDRq0ePwvzoqulfjco+bOINJq8b6zJXBrF9m6a/exWyljtaj5?=
 =?us-ascii?Q?F5IZ2eeBVY4EEPX6k8DWtZLkqKhe7rLCtkFngONKm3oKymB4wXpMR35yRIRC?=
 =?us-ascii?Q?kZ44rlV0Lt6rap8sXukE5t2619VFAr7Op4q8hWJHMdUm7HRUwgqGN3cDaGx+?=
 =?us-ascii?Q?Iwmsu3tnWPOVoQzzFqhU3SKZhrPi60jULVY/wmsU6+TSDdvRBIUalSgaM43T?=
 =?us-ascii?Q?vUFyujcLvvZ19MDy54fOgBD+WQduXrRK1ZSxtg0XW1dmBDvKX7mkz5Wg4/25?=
 =?us-ascii?Q?6DYQGk+aYhwvKuRkYPaSPSTxGUVi1WDksKPBoUWun5X5F6KBfsmMdMV1o8Un?=
 =?us-ascii?Q?4nz0Ad+iZybmum1NwsISuggWtq6KjJgF9CWwiZYKCYvatPwWMYI12PcKEoSG?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420795c4-8932-4f1c-d3eb-08dab3b3d2b4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:14.3648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLepls98uuFmaF8TdHDdWo4s8tespEsXO+xsLipKPk8cPyYP6B1uAC4SZdhKBiwQvAuFU4pinqZP4BDdna3oWZXmTEQ+DfwXVGf7ecAjFeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: PYF_tdBDG4GXPVsK-QLwrS3qg2RVGSGE
X-Proofpoint-GUID: PYF_tdBDG4GXPVsK-QLwrS3qg2RVGSGE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 4 ++++
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b55bdfa9c8a8..0343f8586be3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..b0b4d7a3aa15 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a20cade590e9..75e893e93629 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -173,6 +173,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1187,6 +1189,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f029c6702dda..0305698cd5b0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1663,6 +1663,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.25.1

