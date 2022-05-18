Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240B6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiERAM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiERAMq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7EC49CAC
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKdXG9008006
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ah1GyGptRsFpKeV43hKA+otpXeZ/7FBjpbS5EyUDo/g=;
 b=b8rhO/mBtjcHTMyXloJPiV/Witz3bZBQm6fmHdhiC5doOM8vTDUt7/wZnhcIqkiap+uk
 vAosVCV9xrBQdjr0nzSJ01VELZN+vuc7LU3u+IC6ANkcFPoZFeEIe+DduSFtlWvK2Rur
 0uWTUaz0Hpui/sikbgX6vTwzTUQysBZBuAqR0nFdzXgH5/jW8apAdoLSQTUNBCkvw4Uu
 TiFPU3cug1nC+Nzf3gsuF3LJlTFJrGmJCV2xESIc7Jd5p0aHRfKFExHzqtFvHlS1oo/s
 aIGwoKh9tCKkK3TeXdbLRn1jJ+hKouMZokilatC1rrjH5nBV2kpKRQqusciqeJEiFSSw mQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc7m38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0BXpi017045
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3ebar-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCKopsrDBa7Sex+/+B/e9kfRf8D+77kEgoGxCsI5ESCjYgSxeAXOK/Qnq79XU2McfTxxrryyZg3SzJI0HoucwNalwXTQOrGkSQLDmSVxvS4ZVcduJEZ8yxr/sOReP/GgrokXJDUJ5TWdapAuesIEpjzYAcWAOrD6wx2GPwlO0GEP7xhz/Of2+BXfD6oC6G087EC12e9rz7exaxJ2Q1DsO9g/JEME5ACyycLA/+92VFfXePw+Q8EMQuSSFqzF3NI2QmFGzVNyjKXvPoG3qWzl/8Lz5jW9c6ML+JY84M1Mowh42aRR4K30MLUXF32Yo15SOpwxb7e7RCG71W429GmTzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ah1GyGptRsFpKeV43hKA+otpXeZ/7FBjpbS5EyUDo/g=;
 b=B9xnVpWPcmUN6xsddDiV03ced+pyPpS5Tfb6ujeb9UREccWIGpFW8fWZLS6Tgdsix0EqIRk6uE7vaFK9qDwnKo2gf56UfN71eK/JfpJmwqqZD8lhTmzjqwIQ9md42vmiaCLe34EkTgcpNIMyv9odAfYMDDQ1RVQtZpA31MeFRoU3AFq/YqY2z5MZA/ZRM2THQUsOgOObAImq7d+Dyx7w8YWtgmTADy+3xePZUTapJxCtiCHIPBCovlHMpkv/sNAQAV6okAE/CvyQFXsdwZ+mJeHPyOvc1THX0+CJY3LXoT/vDPxYXpsFOZyF+Tu4IFFhJUcJCfCzBrIJq+PYgKGkig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah1GyGptRsFpKeV43hKA+otpXeZ/7FBjpbS5EyUDo/g=;
 b=XPVkukMh0qz/US8rwYwXoCWK16tt0xrZpUAK8Hu9YtMaXbWmmk+3OG04kZuyfXqcBkhKDAr6kb5ASiYtEjFR2LqqnLpwNmU4ZgOdqJda4m3vvT2rchQo0GZtKWgPlmGIk5PHMqfbj7zN2J2qhU5qWBJv7Qj8Wq66AxrY3BhUOrM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/18] xfsprogs: Add helper function xfs_init_attr_trans
Date:   Tue, 17 May 2022 17:12:24 -0700
Message-Id: <20220518001227.1779324-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21626066-791d-464b-a4b0-08da38631f7c
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB15287CAC1CAE15578B3A0E4E95D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: siO1Jsmj9P5ds4/TkzY7yu/uZbe6TPY7VwkC7aBkbsPRj1ASscIQSjmdfh28cpcxwI8Hqjq0oRSJ7EDFDvaaC6j3U2y3o9zU4QDR/Ztt+YPWfwPQTY7lle3hfPJdUVd+hKO/oCA5KOZX56DSvDwqkrJcUDplB/V3Ss1kWYApZL7vyf1FphGlmUsehrkptuIwtTU1gvA+mLlHz0soMM6M4axJNdx7PJIANhiAPbTnFac7ihdjANcVFfjuYCf6mSz96Wl88PZsFIpCobmccAm3NK3P/Z+EMUjAXlTu8UXBL5h/Gfxwd8c7cN4ZKTCSkhHt92aqzFxih6FYvRv92jPePnqVrdiFrZEej/eoj59PbjAx7m0ASW9fb0aeJX9VRCtq+1+hToXXEY3F/tRUGGY2hvAFQLgcu2hViNCIQ1FoejkDEd73yr8jG5cP3Bg7LGqZYaYoRAuk7JaU2RU+4MrIWzy3QEfEzLkcfvGb+5iXRlBfLEneYVHVjf8jM77UeB++DfZ+2o/jHvZEXLDb/9nLWHKoz73bbTWRuOMozE4S1MsZR1n6nCuhmKJgp1fM8pgAQbQf9a3Ismlz7ytfNEynOV3pHwAcmsnOsO7FvVkWibinaUGBB3J2YIy80eP+ZKD021LIuIaICc8zMec7SkSCgQUW3xqReec1D45RLwRohLzYK7lJVhpxN63Ssv8G+vfxFshCQzmSEiU2BQkg/CN5bA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x8Dai6mYoQ8iW/Nu2ptdRf4sofwqWpha92ZrHLbCBkIb+UqJt+EfK/X65WDw?=
 =?us-ascii?Q?7CH7owCR2xFfut6UYvGJ5ejag1K7D3NAZKpuQ1vTGtySPfsZI7RhtmMQpBSj?=
 =?us-ascii?Q?HZ/TIDgPsrI+sAgm7WUCP41wKCnPCSNtgxWbvvCbB2mQ/GKh7iX+hJuqcKFZ?=
 =?us-ascii?Q?9lID17+LHdNKRgnkhnlFq2k/EC/pZncudSAMFLKjYbcaX7pyIN7p9XiHHLeK?=
 =?us-ascii?Q?Kq1/qd7J02SwiCOn21QKnunTpRDyRpJgQaATZa8MjugzTpczgmmx82nEImGW?=
 =?us-ascii?Q?H9SlvXJ3GeuHGfEh7Up//C7Xcj1hwOxyjBCiALZML+uVbiVd/YrtSYMKlqL2?=
 =?us-ascii?Q?CmPYVQJ4kRuyKd8wpd48sZhx8bu7TyVPaNRrgzsuD+hCuQaays6bLva7JYTH?=
 =?us-ascii?Q?Syvx6Jlp4gQmPk3LjsFW4G88MjhxHk4hUFBUKrN7COgPLkS74grLkWB2AHX7?=
 =?us-ascii?Q?0ZovCg26XS6EQilq85QoihdWgJuD6eScVgSf1WPMNA+SSEL5LyOWiPblyNBw?=
 =?us-ascii?Q?AILxuREOrgViGywTvKQ1sii5UyXBA5GZNWps64w76I4Wg0elGOBqUlCU+rUB?=
 =?us-ascii?Q?3bFMBPM/BWsOG0bFUWsVnb1gy5tfh92qUYMSCt72ddbu2/RaC/9krn1gNuUj?=
 =?us-ascii?Q?7cKqRNsxGMoxgBaNWlRfmXQS/trmoNAErVeN4LRNkoUAxU0/ZK3PWQvOEmey?=
 =?us-ascii?Q?YC0w9VgHEFMrwK7xw3fX/bgeiUCasuAV9Url3rpG7sAheK1L2Z0o01/bp5OP?=
 =?us-ascii?Q?0CeBbjG+UV3tb/6OVXv9ki9F7JdcsnfvsNIQiUI61wbN04YoqJ4VQ+qJkUqf?=
 =?us-ascii?Q?aVY/jgUthSi8hku8qjv6YPYzdrYgbM5dcPv75x8P1dNpUhvLpobwEyEpWZIE?=
 =?us-ascii?Q?FWZPXkgyLOjWIT5bjy8ZQGcXVrVIf6IbmPjCASqaz4qDArERXSqHJ8pcLu1W?=
 =?us-ascii?Q?pEzoF36d4JWu/NH8lDUrodNuuVkQ3T5yfYr+54Sp9d5HzjE1VSsTpZvVLbNW?=
 =?us-ascii?Q?QDUkSd+RY165G/sxImOWgoe5t5HDSaS+uoMRzzHgnAn6jjdPNGmuGqc9Dne7?=
 =?us-ascii?Q?iEhxBDQj49aWQ+7DqHcc3ki4y86J70Iao3+3wfO5izWyyx28R+aAg1dcpgNN?=
 =?us-ascii?Q?S7IUUwxg0cIIZh36OAY/x2uwmJgJIhCEuO/8wcL50a8QvWKjURfu2yFJUuwL?=
 =?us-ascii?Q?eE2OfoWlcYY/zGmGbnWVqLjsmY5Xzbb4TdJ7ACw2WcW7YOQl11cL8MfM1IjR?=
 =?us-ascii?Q?mpOnPleh/e8G0QF6ZrKQaoDwLtjBOt5xz8+yYkGh7dvNwhA85EfcKNGPieqf?=
 =?us-ascii?Q?4SlaqQCrUu77dfKKlWHjpU8SKb3ApfTXuL53zFJ/tYarc567O27DUva7fwjo?=
 =?us-ascii?Q?KKQ0Lgj3q03167DyMtAPGXuvwetNkL7iCzZQ0rt7QjXW0dvRNwYLToMBunTr?=
 =?us-ascii?Q?YpDW/Kjpxrcic6RPxeece60u3+5xEhtxNVJO58R+WzzKZw9ofW46LFWFTfSc?=
 =?us-ascii?Q?n/+D/2Z/3SR2chV3rMrMclXlEP7UqSAfhYQWXE5EcFydKlfOrfuMq17CfMCC?=
 =?us-ascii?Q?70yBcn8Zf6FNE5oFFY4DzF+KnI91Md8eGdWrM0XjlOmOyWPtVWIsWbJo54k8?=
 =?us-ascii?Q?8Rah1C/h5EmPQik7EDyb2KhPuAsS2l0osanYtLn5iSxh0RqBHKuoJm3kXZnw?=
 =?us-ascii?Q?UERv+xNLwccnpqgLQSZ9l0wh8XSaVtrqM7jA/1qjQTZ5G72DOFLG2LVK468a?=
 =?us-ascii?Q?vEck5rlILCae0IOuqYOnoIf7Y0i6Rpw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21626066-791d-464b-a4b0-08da38631f7c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:41.0507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2Ir7CSoMuo28SQB2fjywC16bF93ix4YcE/qskwP4zapE2AIaOJDIt+0eH2gf0MXUnd4Y/xXclWC05mW1UiTItmMoAvx7h7w25D++iOFLgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: Qo2MoAkFr19TId7felYy0U4CNEmejb_D
X-Proofpoint-ORIG-GUID: Qo2MoAkFr19TId7felYy0U4CNEmejb_D
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: c3546cf5d1e50389a789290f8c21a555e3408aa8

Quick helper function to collapse duplicate code to initialize
transactions for attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 33 +++++++++++++++++++++++----------
 libxfs/xfs_attr.h |  2 ++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6833b6e87f3d..bddadb143179 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -196,6 +196,28 @@ xfs_attr_calc_size(
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
@@ -695,20 +717,10 @@ xfs_attr_set(
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
 
@@ -722,6 +734,7 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
+	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		goto drop_incompat;
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 71271d203d01..c0fb4315a7d0 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -515,6 +515,8 @@ int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
+			 unsigned int *total);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
-- 
2.25.1

