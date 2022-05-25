Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B723CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 05:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241450AbiEYFhJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 01:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbiEYFhI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 01:37:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1032234646
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 22:37:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P01xtO023380;
        Wed, 25 May 2022 05:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=CIpRG4ywLeK9X/+IB5tP/Sn9k9R4coXp6k+d5RGIcys=;
 b=X9YL/+8l/sj8V05sjwnsuATmzLLO+eGJPfj79ncpROUUw1wzdikWohZs2+aZC5q3A/EA
 vxjbnTOSEaBhxli7OlfylBmBeLT/3ugOv+4XrtoTkm9GbS7G+elhpJN0DiCpXup6hiSz
 x4ktw4sIpxfh1q4pFGVXeNnA8b5xDmo1TUW2i2cgoUHK9QceYCzTAhErbjv4dCZjfXPi
 3hZPWDJfypMflTyO0pyM1ZW3dgdNIMDO0UL3jsaimocNK8fKP3aqFxn7qbWrZKdL8QWC
 nRLQM0pcDZ3+daRjlBISyHvzb8KhktMMhORk5b2BdgBdsZ9lduXUOCiF1SbvKC5POcjT lQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tbs3u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:37:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24P5ZteM025257;
        Wed, 25 May 2022 05:37:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93wydk9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:37:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hudeASbxdamKd4ZRS3rtMPAoFLeKSSR30tzqDWlBqj5+r1lhHcSLqjkq+3YBzrGYo0twW1HO/qdiY95CMXgdrs7bZI/dzhbhAzV2gDp115H3Oi+s43nVPAvnJuqdbbY0Mb/cK0YYc9dQRFBbrVE9sOvbkaZ+QeWMbFSK8yJWFGDlCQtvpl3v6tAf8thbeQVPT9/VqwgSc0Ydpxa2q25Qc7Me1vQUrm9vpcP0823ts+ke6GbKUneylnMU5SEZinUfRpf5XvhOBn1bUk6LOS5VEUfz93gBVFrVt/VKrZRIl0DBHHPOP5te7KvN3WyB7NbMbPXAQraWzAkMLvodtm+SMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIpRG4ywLeK9X/+IB5tP/Sn9k9R4coXp6k+d5RGIcys=;
 b=h4XHusVnjDZv4MLEhB5N2vdMlH4LSgK2BgT/8DRx7cOMJFzIyxT7RH2BbJ5xUddQ1pGhs7EnHBDqJgk8LE10w/c5MFizBmEibcWiXrrEecNnqRlSzwlgvnaUViKZI34FBOI6kHKDl2uSfF9pv8U/uXjzlsPMS4Z2FwfPYFA1P2ptskOL8FptuwbbGH+8byK3bH+iFJJjBG+NZPNo8oHCAMS2EoMYKRxeE3tCwdZiU7gfAQ08egQAZlXSZ565BlgYAVEmJTl90M1Hezo28aVZ1iKpZdMdUdOfCNf3xGS5QeztIOa+d3/v1zRhCAsR+RZhzcepK5BZ5l0CkSxj2fKVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIpRG4ywLeK9X/+IB5tP/Sn9k9R4coXp6k+d5RGIcys=;
 b=lldJ2kMT8gq9D7FEev5gRW1Nzwa7r8Wc9ld2Wd14mAfWBQf/hm2u5kOshbQ1q7hcjEjKhqIwa1wY55N7VRNiEUVPLI536jESxxwEuONw6owpwLtKblkTyowEgz7BlTW+9tRaN+EiNgR84QdrPR6+lU+YEbKiQXjIFM/JtXTYCWM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 05:36:58 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 05:36:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, david@fromorbit.com,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 3/5] xfs_info: Report NREXT64 feature status
Date:   Wed, 25 May 2022 11:06:28 +0530
Message-Id: <20220525053630.734938-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220525053630.734938-1-chandan.babu@oracle.com>
References: <20220525053630.734938-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0047.apcprd06.prod.outlook.com
 (2603:1096:404:2e::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57464212-0703-4bf6-c67d-08da3e1095bf
X-MS-TrafficTypeDiagnostic: BLAPR10MB4817:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB48178219905CB6AEEF91817DF6D69@BLAPR10MB4817.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDSyKeuUl3Zzflzc0C6lOaCZT5T+AQu3YhbjdoJnsebYj+s7RnEokRBvBE9MtcAEvrIoF5mjqT5N2vquZoVoSr1YsHnp9z5eWpE410lzjdNY/WP5+ecSALHNB3lHqme9OHRyKUJPKbeb44wF5jaW0CoQrULSlwfGa4/kDXk3LsyCPU+Uxe/bq6addK1wTnDciSCxODONzxnxSAz1zI3EhB3Cs/VIDZV8zeTh4m/2tiSh5ftzVE1fcQP3N5IXbvOyGXPBUwpYhvw6j/OcrepnEZd/W9/MUq9KtfhMklEwDWlrQJUlXCxQpNRDvvokExDfHMtpVx7R47KcvSJvOs1/7c5EJe/7D0ckRJt10AfPT9nohq5A9BHr3x422VzryQilVYetarqhvCN4msUtFF+l+G7d92D0hvRnrC5hTchbbiY4Yr0Rg9OV2Y9Usb1kYJO/is8RhHRvykBFfzIKSTZo/syrwEUN9DIf+LMw8YO7kHWfLNvWsAYRQzYQqYcJj9JEcqHFVrQYVmMi51xdMKc6UvwP82FZc1rueGoGqiVPTpY3uyLMpZ4U3cWkzvxgRyuS816kBXA7HU2IkFom5al1xGxPXHtIGsDL+MzmtaR7p+1/Pi4X9UDNnKxamjAeJstivrwTrRV75alU0aehlvsLt1klU1md+OiwsArxSLw2oQAZAl7Y9iRmaMX3RMuKRx/tbuFGI9YMxqEkMNnwD6hJwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66946007)(66556008)(6512007)(4326008)(8676002)(66476007)(83380400001)(8936002)(508600001)(6486002)(6506007)(1076003)(316002)(38100700002)(6666004)(52116002)(86362001)(6916009)(186003)(54906003)(36756003)(2906002)(26005)(38350700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Wk3+e2w+GAV6MsxOyx7msbrb0xC+Z4Qhu84p5q4VlMZKoiwEl7lSdWaCypg?=
 =?us-ascii?Q?ZFJsrjkxhl3agSO471Wg11GwUyVeHZ0eOsuTrNltMgkObk5K302BHqSNaWPP?=
 =?us-ascii?Q?zUfkrKkMpuJaTKIbrxpfxfQI8dodNv9PMx4B20dgXlDFHcHtjdbjZJDPBD7R?=
 =?us-ascii?Q?bBE7yZIOyPXmr/EgzHlqGNfbezafnsa9uKTjfdTtApMyElqMp5l0pp0Nj4dV?=
 =?us-ascii?Q?cu6Y7Jsewc3xL3BeCXqOtQIghrPb7IJqpOwpbpLKB7ItzVrFSFD3HUI8eYtD?=
 =?us-ascii?Q?uFaQPJQYAJ5PUHkJ1l9leu1Gx83oH5FYeHBK2mt4nODi+HW4TWvqErBol4Qx?=
 =?us-ascii?Q?2eLBUOhXZpCsLsEBo4U42welpkPx7wm5xh7V06xSNigFkIVZ/9H2vJdTlwOg?=
 =?us-ascii?Q?LC52D0Itf2GdBanEcaYuwg214LdKeizO+TxBrckjGANE8YF6pM34l54EoZJZ?=
 =?us-ascii?Q?s6RMd4JpF/UnKogu06J0n5YgybbbLSPWXCLvRwcSPSJIgbXrMtXMBC5I50ue?=
 =?us-ascii?Q?8E5FjqLMjZ2t+nZ/guyEWRpcUcjbQnwg/FHfcN1ksyfKfBx/+NoKfpbOlU4R?=
 =?us-ascii?Q?zw3Fc/R1dPNcqQCVd1kZIQfqIoCyU9ORBC8t9506bcbzMoIDuUFTL4pgOpsj?=
 =?us-ascii?Q?9XtgqlLyYURe9GocSvHsico56Cr4Lz6jR2LNJot3G43MtQyNVgYgfo6Dxn9Z?=
 =?us-ascii?Q?afFk3FfnMArlawXexwl1z9HZSD6ekvgHCuEEY6dYtnpJqsptbc1Y3R/RpBsQ?=
 =?us-ascii?Q?g27ymMPlbD16KZT34TwWU71Yk4gOGJpUWl/Sx9i9aLbFCISFVuybOJWmwR4x?=
 =?us-ascii?Q?I/jHGEIQrc68nbaRvf+/9mJ/3nzD1lPGKbk75QEF0ZAIiBS55HeYh9iHk3/a?=
 =?us-ascii?Q?5MbxXgFZXC858BffwMROIusgc5XRHT1ZR+KzLVSxRwVCpdS2w/ztwkrtWP71?=
 =?us-ascii?Q?VzQ7x3oM+T7SJGJVOHbDIIlIGVqP3pJceI49RLe9a81M12HfnvwK4qZ9mno0?=
 =?us-ascii?Q?ekCdzdS9li7uvWIu5TYKAU3FXXrU9c6/EmrmxoseeX9G4ESCrB7dWHrr99+G?=
 =?us-ascii?Q?kCF+rmaDRGt6ZaYGSAT6bqoBU8CqmKnx+lawMJ+ruBFfrYaf5jej6A8xZjpp?=
 =?us-ascii?Q?PLFZVfjcxYFqox6Pi0e1DIFv3P5TrfOTsOabDwOTztsfr4flbvUymgk44EuM?=
 =?us-ascii?Q?s4wZtyCaeMcWlrzWC/H4cPB1piykNeX+4TmyuDW5qBgNvOYxRDfD7huGUh9U?=
 =?us-ascii?Q?9VNDbIHrf1rKo2m69yEatmbSfFqpyrO/NE0agJqxt4YoWz1ohgnfM8hlRsx0?=
 =?us-ascii?Q?gRP7rNEohSAkrAvDJnMUYt39/BpChOzM/1g3ZazhnK8Emj4+uTBVSlJr9fvM?=
 =?us-ascii?Q?JK9hVwKqhWYsCJdBVUMcb8yDVM3fBXGx/pSsiIdn3elxgIwkySFQTz2Q7Ie7?=
 =?us-ascii?Q?7SwNh2G++rOcbrrW2W6mJbVek6xVrmWKMA21vGikgYxj/zMPpFpRPrq3I8Xm?=
 =?us-ascii?Q?Rs28z127KqHGlMZHdbglw6zhwT8XZwB1qk17QKy4FwK2WmYg7eklbsNgaP6k?=
 =?us-ascii?Q?LxW5ujEQVtfMlT5k8ozoxNVJgTlkka1vjlOtaxwnxKkHTTvrNzLDuVWdeQF8?=
 =?us-ascii?Q?u/oHRd0uDZ11KrPWqe0svgTDXWUNl+tSIjWxF+9X1TNFAajUP0oC5gHtHm0z?=
 =?us-ascii?Q?Ygoja5KlcvvMChaiRaukAKHDPyzstC1TRj/wjWs++42we5L2xk2uEBTce+Q1?=
 =?us-ascii?Q?1enfT2i2m7WPKSmVfISCdxlDu2lsqAI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57464212-0703-4bf6-c67d-08da3e1095bf
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 05:36:58.0836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xQSLPlezdP2ShE1NPy2/Qtmnjw414lmbHGR7SnSa9GWJAYKPSVCBDvDDpE8e7SmjB/iJNqutI8IXbZBHOn2T2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-25_01:2022-05-23,2022-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205250029
X-Proofpoint-GUID: QVWRteVSqv_7-c8u7ga5PaeHeOvVTYT6
X-Proofpoint-ORIG-GUID: QVWRteVSqv_7-c8u7ga5PaeHeOvVTYT6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to obtain information about the
availability of NREXT64 feature in the underlying filesystem.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libfrog/fsgeom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 4f1a1842..3e7f0797 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -30,6 +30,7 @@ xfs_report_geom(
 	int			reflink_enabled;
 	int			bigtime_enabled;
 	int			inobtcount;
+	int			nrext64;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -47,12 +48,13 @@ xfs_report_geom(
 	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
+	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -62,7 +64,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled, bigtime_enabled, inobtcount,
+		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
-- 
2.35.1

