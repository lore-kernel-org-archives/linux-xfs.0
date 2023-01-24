Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98776C25B50
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjAXBhE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjAXBhD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:37:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACBC1ABD9
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:37:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04UI7021115
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=MmcTiS6LNlsK2nLlgjz3iJnVXUEtY02SM291h1WcZsoJ421fSARiFxfGMrzP8g8FJobF
 V+CjBlCWT3n+ee2lFT0+cID7idOi6gs/AB+FAf50mRF2MLOoXMAfSkXGtVH7u3ZOm59n
 HgmPSdMCpdFNtL/MCYbg8VRPcBUmOEuaFmI0bu2+pj6nxELMUhLGp58u05L0jgck7jOx
 inY+T6G0Bbozza8b3jVYZlrEPolh94oCnxy2wq0GldiYbsINvqexFy82hJygZcUeX6JI
 xSUQt84ard6kC2yatGfT0KVsCObnYukkwW7FUvUvhIpuzytb9W5OgOW+3GXbdz+l1+CE 3Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa4a1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O1ITrb039678
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gb4b63-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAQhmMrzHKv5pwoTTUpcYf1k+GHL6M2Z8dunjUuz3zNg1MDOfdAbPwBdHcGKky8z9eEmmxGy+AL5CjmoLw4XsLALgiFvVjyEXfHmD912Ewm3P0AGyeJL4v/Uz31tEEFRJPyHG77NecH8ukZojamZA6ccwAn2Vs89Vm7BNd9nHI46cisPdQOBzatzlOEshFvlwEbHPOGOnZXhrDqT1JuXYPYqgT3OsmX6lsk/Be9ohn2g8OIQ0KGlpKjQWS5eyTz903l1JYUbu5yvsY46cLA/5ykxO5Fbl/WBERMz+l8R1VQ3bmxqt5My/mjJuYK3VnMICqKj5B5LRGq8f92j9AtGLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=Pb5l1DPZ5vqnpRVg1tZIxnlGi9A0kOjmMBt+9HrqXZJqZNVLsq53MSdvj4qFwA5e5GO10743aeXEX0tt0/wKNSmDgy3k21DSqg0/2CquvalM7dlW6EXPriYiCa511al/QQoj2Dp5NxPrjwep49TwbPDoayGhB21xdkT/FWVOA7GQXOKwS5L6jbwT5rFLMODlOf3XDGde52ERKoI9+7gqfERB5BxEr7/5+UMuxi8q8/yOAYTEq2yuGntafj7s9FMd6rZnaEXAEMOdEW2Pc6CapM7vaLFvrjZZASZwVGArFd5Ptv8/tO5mpJnhm5RFbGtE7juS8nUeSrt2VSLlPWkb2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=CVCtMWNVqeBWfhYKcGmf9brCKSsE9YX/KNNhClNtZ9eXlziT6a2iN4fXve1nXdT7Q88rdRCsKAKmqtXlrMRZBO/xmiR2nXSpuojIvGOpJ/LsUz4MFmE251CMXqqyQXoP5NHUI+SlZVo8QaF3HT7W5cWr8cf6abOC8lHex3bhHTE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:57 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 22/27] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Mon, 23 Jan 2023 18:36:15 -0700
Message-Id: <20230124013620.1089319-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0142.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: d60b409d-0451-4549-eba2-08dafdab7b56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c9Jb/TDve4iQcyQbnPZkd/19EHk//yWA3b+6gRItn40OYtTFgZ7pJ69GhqWzuyH3s8u/YXnYA56Wkoh2F9I5pKq74XLIVrqcFWCrMtnIg8CtAII2CyBZz4tekISA7rr4YLQHvBqJY8LMtZb0TPWAAjFxim24VSrDCyxPZXNoYmlWy8m2O1OCwOgRaN9Vhk4E1isV5E3/iRL6HKP4BQSKhMWYwTWQQKQ6sTKyfECqG8mslmwfO7nATkGz0cNtAWJcAVSaV9hw8brsfq7iH44uDAh25ctY2utHVwUeU7wL4rsut56JPi+6qwH/1R8usAwHRaJA/cMwSkf4TbC04t4CiEqkSPXt62kFeEE7twZxKkhtKLGXxsf18uWpToDP2zMvH+XJYSXX1dGYZSIXV6Ch8+b07vjpwcsk3VKN288/k+V6q68E6i8RyhwMqhF9gnEQxyVXKsXxCZpv8TreER/VryvSCgczK+PW0kgP8jCRXxvYktpatgrlRX4EfJ9NSmutaXjzvv3nD9G2km26uyxkjQOXBKystawnK8rw4lVX3AY2XJqGqMtL31Udb0MbGBGu2CZRpxuZw8oaemahA+ygG0mJWnp8pJbZkOQjzCmTvoFjtlvHWs32pD5vR+9ZXZ00rRxE7M88fEqTUnE1uqUtNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mS4lIhJ4rH5LnpPzLtoVcMxinL1Bu07cEFvKvHZlTWq3xjYQc+1vG2pEzBjr?=
 =?us-ascii?Q?Iq0CKIJcDUQuvnxBsBRz+Lk+kZyevNbcBZf1dwjP0DC2zjMPLT64mJkwI2TB?=
 =?us-ascii?Q?74N3OTlO4toJyoZQ/3YYZFP1UF7l0UiiC3aVuwVpGTCiG8veymE0nT/IAuVC?=
 =?us-ascii?Q?H6NNhUsveSX6Fhsppx6SpaT+WMJ7UxsCLkdAi48dtTPTkiETPMElnGR4eHZf?=
 =?us-ascii?Q?8QKy9wPmKvJuDiuI5Z0sbBeRU1qeys3XPDTPGMprRqtO19L9y1rpc6s3LlOq?=
 =?us-ascii?Q?8PXNDVk0Idq2YpWwaTqsefZ2gaPnKnXi7QewejCHmC1Bj2XDhtwuX4nf3N3q?=
 =?us-ascii?Q?uNH3m8dBdhYeVct0sF/9jQoXg20+woG6Sdz6jDageug3KcX0cz3jSvfde40G?=
 =?us-ascii?Q?FwgeGgyBCizkbmsIj9nzJU28cxIoKY2JJIxyliMCpGjwstjnTsVGjGro5JNQ?=
 =?us-ascii?Q?oR9bNps/KTcaL0TWyUTMUHM6LY5bywoHaIKS9nVE6S3/qdj1tsfd0+93TOxY?=
 =?us-ascii?Q?SRLnh0Ir4x+pbY0yUt7Ws4pzrqCvy5h4xat54JChFnICjTtI96B2/7OHijPU?=
 =?us-ascii?Q?knpA6JWPxb14iyheIECt4aeWvO56jYmnTf18H4PQI1OpJBZ7jLZxdEcVt2/n?=
 =?us-ascii?Q?TCotb+h1wLQe7N7BCaA3IfAkQlhtC3vwgCcNKEHkWomp97Z5M7ohsLLbxsx4?=
 =?us-ascii?Q?2rbO8WbbELfjvst6dBOV/VpkclWYmp3m+CvQYk1XtUwc2Q6qUBVkveqXOL80?=
 =?us-ascii?Q?aNphDTIAiHGKXs/B2SlwxrsDxtuFtd5uXLGSCgQUAI/C1HgdNrZeATeYbqmr?=
 =?us-ascii?Q?YG9D9JpQXp72N5gk+7H/sqefHddTtYNKKK802cEjNlKnDXs6Ntsf3osi853x?=
 =?us-ascii?Q?GyXWrLrYcw0iZKH+8xUiVqj53oYV3okWJZOSOub24DPg8fo3UxQPLxAzpYlP?=
 =?us-ascii?Q?lLa9vCjpimjw3Lud5zuENBPn3pJ0ryhYGDlqxQOFAs6knd1HhnPMXTqMh42d?=
 =?us-ascii?Q?AS5IK7vOeOoiXtNTmM2Yze3nO3szHhlFV9OyrvcXgf9660umC3qtpLKGwcOX?=
 =?us-ascii?Q?kCkdI88lP73Ww0n6keRzirkNwuollSvsu9vuQIjuQVH9odosM0B10u64EVfh?=
 =?us-ascii?Q?oVh28D7YE9JQeGKvRpN/z3Qn62RqUNr+mpbvud/jrAVce7t+poOEQkk2MjAL?=
 =?us-ascii?Q?AIYrAAaSXu3xle5dkT1JB3TMeXPRIwRwrdK+dFbv/LS+fWNSQGGjHpdYanyz?=
 =?us-ascii?Q?xjG9Xn414RGkGOUU1vl34y1Jv3UEBhlmFz1XK7dEfhSHiqt597p7HGX9HCUH?=
 =?us-ascii?Q?D6Ad6CAzE2TMGmIsOM/74DbYXAwU0SJs9U+rwYkp+3jrm6hnRXJvg54swHup?=
 =?us-ascii?Q?tvXeEMtumcL+VoeMTlKzvgKPvJkZGtyYYXzF4bfjAr4PBnbSRsJEZbVuU/U7?=
 =?us-ascii?Q?JBlD06NlOADaaW0eqZsDdSloJwiV14iWXFCEGinFrcgVtxTFyKePbag/Y55H?=
 =?us-ascii?Q?N9lXbXKh3ZJ3kUQBGBjLXxwargvc+GU89HYN/VX9efEy3uJhivA/uAmfiP1j?=
 =?us-ascii?Q?lHxorzNkCw5RhH6NFK/uaMHp1xbNWVGoFEnvOiyo+1mBahkMPYPbzDKnHanN?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ledAemPxpQwpkiKvyHm3eWsHb0vf3hl5NHTsYO1a3N/H8wmFR1DBdgdbC7D1/uJ17L6V6bOkKW7Jbf5K/u1myVvmd/i0x5IJ922gWksY1gRHTbint650Z5MYBooQNBemseWPAXbN5QrxtFcMzniHtS4D+lvOHEt9l6NiPgvMnZuVVDIFxrghUOKjiLy6zheK9mTaHuXsq6e2QOBreAksu1ZsRKx4ev+CsrjOCTG2FuQqzWTcqgtmB2kxLWl3v594ekRjVVQ276/zz20QTq17Poi+xaCF8bSI1IVTWsN+lPU2Tlc4AnRAlY3hLUZ7oATCbz/mv0VFZ1CRUdSfhOGGiLrU0pQs9iVRDOvgrDEMRqwKl6SEAPzAKR3Vg+/X09hJZm3hRCFLUYnT5m9S7CDTPVNWRRh7+h5UuZoOvbAbFzdvOY/nL1yxhYRiYYiI1JAUYltzJABZRoKbD8CYpYDxno6MD+JeIZgac4NzZXah0azaMSRKpINd/pArS5Lg529RKU7MEi44qaJlQNGVGgsUUSdG6ZemaJ0fOIWJzYczW5p0eVZze/XKr74Uf5vOZCluHu+QvS8Cf6ZokcMV5ajKducLMjVN3zf69LFvWV9hSUjj2pz6FHqGBz5rZlqntYSuEOD3FdMke7NuI2tRgPtpUJ5Axku9eRjPXY7npXigcLsSzWgiMCqk7uPmvDtgftgMASPNnOZ4rUu126zUBT6YUgzbvW7m/JFMt5Q7CHTC3c7X2tbfRJXRizr+7zoUkfM/ZAb/62lBoZLbeDYbi92yag==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60b409d-0451-4549-eba2-08dafdab7b56
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:57.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R3TfN3oS+CA560VGFzd5YpP//MsGtaoBiTnL4zWrj1snv60Xs5SlKtH6NoOtQmZdfgS7Vvcnq9bD6/AtYNmxPBemhcqFFStGKdeX+wjkrrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-GUID: dN-VeWIVR2BbsL3VMiZU9e-Y2ZpVVBHK
X-Proofpoint-ORIG-GUID: dN-VeWIVR2BbsL3VMiZU9e-Y2ZpVVBHK
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
index 371dc07233e0..f413819b2a8a 100644
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
index 1eeecf2eb2a7..a59bf09495b1 100644
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
@@ -1189,6 +1191,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0c4b73e9b29d..8f1e9b9ed35d 100644
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

