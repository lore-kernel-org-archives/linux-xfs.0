Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BD3C25B08
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbiHDTkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiHDTkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DF911827
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:34 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbggU018626
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=FxTCf1NND+bkYSwaypWn7co4/i9UK2kB4unz5Fn49rM=;
 b=cUmhoSHs2McmctnXu5/YkxMz5Iuk36pWVq/LcwfxIqDxqVn9gD5k53cJHuV/F1orvjY7
 6DcxnL1oOCGJMZKClSJz0n9YDWIV06eqUA2plPn6U5Bz9VGm4V1c2fAFLdNWlUHpXPOg
 Rbh7EiIobX/Z2ty5U/jT/NpT84DItvX06CzVOKz/spy8o77Sfx2BF6aJR5Y7vUJGtZHl
 O3vpH0+1U317IzOZJB7RMEQcJH8ED/OIqCVFaJ+FsWUOe5JJZx6eUhzBW8YzDRzmR6gN
 fgt0wGwHfDlxcR4xtyNtYDYOfSgJlWTXtrt2RJdj8bH1usalNgMTed0ETsz2GP534/G8 Lw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9wmyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274J7Jnn030850
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34mm40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gP95uHFtB/Meh9BbvXRHLSHsHfRT200wFRbf+OWhRZ4MTjairDqWjvG8LY/c8k6aLdBVN4sVoTS6mFh7Si5NK2feBeeX5Kxd6mN2PDHx1PBs3ZvrACGIETrNjBVhuF2wtPK+Z3MD/PQG7hEdAV/PtzLPQ5mrv2DzDb1dGYFYefRwN9Jk2Rw/nOTPAtbVYPMHUvIdRslQUlKLfvFY2TK6QZ7kqh3MiQPe75RskknJh+jojhXIhr54ErJL1KbBoMFW+7KaeEzcqYPRfyIEoW2DDoCp8/2IGv2FD/0TcfgGhGkPB6lkJxBOI8apqCQvb4/X5BBluzUpK/CiI/hoYCYlLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxTCf1NND+bkYSwaypWn7co4/i9UK2kB4unz5Fn49rM=;
 b=KWB9PlOP0X6pZi+MzQGb1D8A3i2HxF9pjd5Y03Z9JLE91AgcFEVVoCSm+jNwl47i/UVQyefnLo5POHsQXGOqxISiw82GvlfSdxw4+KUje8xvYRdcLAtxNqjGIiwb2GvgEFpkqxM2nNJvdKaF8+BELJuueQQIKmu6/FPAYFvNQbvB424/LyvCEqxw/0fhq7j2Jow1Jf2gJEeTM+kNRUuHm0EAmvss5PkmZ/llgFLjwHiQd34xcf8XncbIc6xxykzMIfu45IaGwB0fgHhEp3wS/PTZ6C5K5jIhz5HiTebzkenD5tsYSMagInIeJoCl8YLMU9HMUpnfulKNUkpetZxgBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxTCf1NND+bkYSwaypWn7co4/i9UK2kB4unz5Fn49rM=;
 b=HHhWkLpi+qANo6j+mRbeT7JcLjLFu76TAYhfrzj6IadqoaG+j7FXRFSshEVgOoPxeGs42+hBwAkP9Ryyaxqb3AWvPxl0G9AcSQSHq9SxQKZpG/8YBT0Dq+f0x6jVeACL0vNlBNfCQQNQUFHVF3gMHg6N2FKJXYBJ8XTQ+2szf/A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5011.namprd10.prod.outlook.com (2603:10b6:208:333::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 4 Aug
 2022 19:40:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:29 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 16/18] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Thu,  4 Aug 2022 12:40:11 -0700
Message-Id: <20220804194013.99237-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a96c00dc-9f92-4949-10b0-08da76512e51
X-MS-TrafficTypeDiagnostic: BLAPR10MB5011:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sVwHOH62MSTKvkJt5udE9xWaDI2ZvnG5Z4T3KvgbOUwBtfygrbBcD9sWc9YcJzz03nx10zut/0JDmJZLoMIrGfZlyK3PM/fJMUEsPafoQluCeV3o9oRoFMHOz5Ee3MV0OQNg0LOEPmXWIID7e8bksoh2RJ1UDJNm8AptEoULDnaxIcLV9SCw//kVSmSD77T3w09ZeHXgbtty51zrPa6BJZo7MXmvNHZLhY4LxZjZqif+g/aqEdNgZGQuP/zuGQ52BZ7h7du77m+GNxIap45k96jEVqeB0yTNspqnEHO/PuIGKX7Ewy5pZzLqe2xM3jWKJSWxVIbYH0HRfnr1lRUPwWNj7kzHoIPzM2Ln5IuX2f7UgS9Ye3x/d5nRJckftoo7Hj4yW+d+39H1DDMYloL05WpcACdH509fKxeJY54D6ocNFnhrb7qbjfA9YXqbZRelzjMs0oVGlcfqNO0q85lA09PzVxsHcglWh3NkaYpOjzodqFPPD4AOVI/AQe5CTF7b94fYDHUUwgvdsXN17nJ//L7grNlRdhgh5BbxJCwthtbEq3nfDC7kJvFyz8wEGAGpZnWawgpcnSwh0zC8NvD4VrVIR9PnC9BPcIP7okDesgq/wH2NYP2WbpWlkw/+AZ9zPNyGvakoEqEcBG6+r79nUEV8XJRydBLCUXKgc4NyXJNjeovbgh5sJg8SpKKufA4aHexEjCu2TSe0RJLxQpIYFPexJkjNxwY1wS6TeRKUt5CUvlLpqDiq7Fx1pF1K8U4pbemyh6qdfsyZRdbCCKrR74VuVTevLszPiGLg3HTZAUY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(136003)(346002)(376002)(6666004)(41300700001)(478600001)(6506007)(52116002)(6486002)(6512007)(26005)(44832011)(2906002)(36756003)(86362001)(6916009)(316002)(1076003)(38100700002)(38350700002)(8936002)(66946007)(5660300002)(66556008)(8676002)(66476007)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q++3/rqYQZKfepwfvImKSPcpEIGgf3bu9Z/no/yQA0NGrdVlWc7eOuQbpHYL?=
 =?us-ascii?Q?MO2rkbCKCzfY/RO8e9rKGv9OX58P4viuRgqLWvFIoW0iSYSeDsxDHiECkCmB?=
 =?us-ascii?Q?z9M7Fd6FBqL5qqEqrOR/w6EfnbL4/eawzf9apO4t+7Chrjn+CjiwOztjOjeu?=
 =?us-ascii?Q?7yNpYbfIV7itsgAe6OmIqi/Bs/Q6I0vCiZRCMkWt29LId9Fmbas107xDNEqo?=
 =?us-ascii?Q?fJiSLjq5bJ/ucrSl4X7HYMFAZQpRWj8FlECuiAcFhbSiGQ+5Xy13F6dZwaNJ?=
 =?us-ascii?Q?Kh8l7WM6JRIgjNrsSP52cDrVd7GokvlChFBGA4Jo2DZw9XxRjyjq8swJhFan?=
 =?us-ascii?Q?qO/B+i9nQSuPTIhRcJVD8ax4bJWkMGw8UlhR8WaDvhjU8SSv/EkcxEW1zSiF?=
 =?us-ascii?Q?GS39KwhGLUiXUetc9RgHN+OeGCgQeT9IODe/7GgNrUt7lpcJE8oVp7b8vdkr?=
 =?us-ascii?Q?xiWB28ADWpqHS7x3Aq7c5iFJjRvwh+DjnjDMBgym+fIfsOfPJQyHIBgWyri3?=
 =?us-ascii?Q?E2uerj5QdXkh1ZKWw0zgG1jOXSjUhePC0Cx9/O6MPtvgPSavo8CtDplCEgXs?=
 =?us-ascii?Q?WDyXkXYyiVwMQ+7ixjk1pWWW1di9u46cX8fvRlY9OHYoKkT4oRpXRHiSk/4T?=
 =?us-ascii?Q?7Ogcz1we4q2/7kzuQQfhZH1QBsbNCdLkdR/a7wUJGEIrQlnkctabN9dIDG01?=
 =?us-ascii?Q?XFLT5cy3HpGEbmMPsfKqJMMbeJnnJChhG6HxPuAGF2zOWLJ54UXEC90Fo25i?=
 =?us-ascii?Q?frPCAjOeeC4XfqeOLIW5U2/Bu9cMA8rd5IMoboJTxszOVGjP+r014ThmeKBF?=
 =?us-ascii?Q?SiBXlgIsiPUMDghj4UJopK8igWKqUvziv9L97/KXX25qjRONDBqf2lEwpciB?=
 =?us-ascii?Q?hEHqspkjBOt9G+FKWEwQj2DX6zL7MzwkwjktTs2l2kVRRN7ivWGR0482l1zZ?=
 =?us-ascii?Q?KvYU2no0i0xErvVSsuWbFybzYAYxZcCafOBjeFC/pimXjBmnJJ/S3B7NLnED?=
 =?us-ascii?Q?qDwnw5DNyFD/N3UYTW61IFnNPYCabD4K6TF+fu2+5v7E/+r9ZI/lo5qiwTY4?=
 =?us-ascii?Q?mxhLPYd8U8UUF3iOvkdjbE/QAhApaeuf9qtGyAhdU3afpiWDkZU8fiosabNA?=
 =?us-ascii?Q?nV9RK6GsgqF35LuyBotOE2zcmDWsmwECzXP1G9NjbDjiatX70KrdQjkocK5E?=
 =?us-ascii?Q?zI7nYaU5DIGRtaqGw8zMwfhxrjtrd3eKbYVDMxwtvyjsrR3yDT7cI6wD/shi?=
 =?us-ascii?Q?dApzSs24bwCd5APaXnjOlvEME1wXFYvQGnya1/hXmh6nWylp4YA+BcP0IpUR?=
 =?us-ascii?Q?biR4fTdO6ICXbEjwA+pKqqbV6Vw1d3gOQK65A4lCcG0zs3PfP7y3Bc7pYDsM?=
 =?us-ascii?Q?H+JBZXnpgKRq5w5ZQW3yURwgCVxGZHpA+yT3RE8myryXfg6Mzv4TAhhSkPo/?=
 =?us-ascii?Q?xw9XnVGABWv/AlKdnLValA5iAJbBYv2eBfVi7cT4ktFWVX4RyZ6K/cGWG41A?=
 =?us-ascii?Q?xQFR7pMVst33uvwoeKm+p1Gz5H2Mipg+nmDemmvEnBSy+l05Z9nX05iPWJl+?=
 =?us-ascii?Q?E+H++KRlR3v3qEH0DlM5ku9eJb3ogGYotZLOQRwOwkbGeYw5DezFsoMt8ELg?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96c00dc-9f92-4949-10b0-08da76512e51
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:26.8933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwK4/JlfeJNS+YNsOJ5bQY+OgffJyBFOYFG36+Shue0sV0ZO+sNUaz1SR53dSBF85Vn2JlgJMmaADb5Ewr5cFVNlktZqkc4awZybJXmGA0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5011
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: DW5EdxDiXKOsWKq2ZOyEA1bVTQiGg_by
X-Proofpoint-GUID: DW5EdxDiXKOsWKq2ZOyEA1bVTQiGg_by
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[dchinner: forward ported and cleaned up]
[achender: rebased and added parent pointer attribute to
           compatible attributes mask]

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
index 3d27ba1295c9..eaa2bb63621b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1655,6 +1655,10 @@ xfs_fs_fill_super(
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

