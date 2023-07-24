Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 783D3C0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjGXEi4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjGXEiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:38:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1069D1A3
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:38:54 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMvFpB025014;
        Mon, 24 Jul 2023 04:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=YhWDXRrEH4qfI70nbkbmV9QuDNJBQv+jwm2p+r0Icos=;
 b=jlZW3g7ZqsfrjZoznqLknaSMeWgfB/6BUAeOoNUELbNL14yoW4eS5Le3/jN2emQGavTD
 rG15hodbZyxrMzkRykQThBreLBa1I1tBGmYaWDv4cIPlVTYrcr8NYTflKhE0is3j5jcD
 XohKyinBGqggAfWX2Yv5Pb7S53YRa9H3cCgLcif4w3KKfdu/0os6bYHGhkaKi8cMWUOC
 Lt2ZuwFWQWXbpRlhmpzL3jTZ633V1JeYuWGCRzhvhRmawqSYKGk5ADsRrLpjVVmEhz3X
 dWlDgZAFwAwAERW8pVi2w1V9ZqNbtpHHoT0ff0vEMsH8TDVB+K5znPx/k3X0tqzznY/v 3A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdsva4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1usn1040849;
        Mon, 24 Jul 2023 04:38:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j3eanp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vogqk0FF/IFRYpF2IlLSSM5piF+YUOzIp7lclFr77FUA+ghoWitC+i3o3Jcnj3r18TeXqdtCJkDqlhc0XMQVkyxGd5iodj5Ku0wE0OP2DOzF9/ut4dw92VNzzrhMLZZ+F58l+qZy4L7REY5yEwaAiYxGpxjVBBHL5a83R7W0h2DToJT31xgp8m5TPm5e+C+PMtI10qsDjnkmD5QGkbKoV7t2VLiwPieSPt0pwOGEumhl7PTyY+VeGvLnOigtaB13IzrM995BZiwtq4cZYG/V1p+JGs7X4clNsCZg22cEYz05oFWx9tfckzD/OQcno+xaqe1swn04O/D6Ev2Th2ZrhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhWDXRrEH4qfI70nbkbmV9QuDNJBQv+jwm2p+r0Icos=;
 b=n1s/jjm94m1t4SlVTId+YjdmG+VoB+LjiXDJWhdNZFtdlIjKOSVuiIPdE127up1sYk3BuLlWYgkE9/g5l/hJ18DAykLlxDlPIrT3XGz4qRFZYSDeoxOQ7vp44gddVcGwLezWzFq4bincOTV0SLFARru2DGAGe+Dl449PuLZPVNCCpBWGR4UJO8l5WBQNS1EoO05pQw4r4c/xziIRNQVISb9hwrbfO201nLjd/om61QoF0B0WxosaZfoNrwhN60A/5gxSIiRT5O+2iOH5IGnRFYKEj8MNtiMCjBY9j5xcSWj5h7Th4OOquAG7Z13JBNv228C3DwGqFwKe7zDKie1UWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhWDXRrEH4qfI70nbkbmV9QuDNJBQv+jwm2p+r0Icos=;
 b=jhmpmI/IYa54Q1xRXOR5kWoomPChsuTGWSKi+UJ7pbtzKil/P5Wymc9wZsZwii6e/1+tjFYSGoefgo5tNygNXy7IhnDaUAOLg8RNcTIDaRtkHW4BgaZKS0nWS5jWANVMAyYMiEYC02d5jL8xGqUn3z+07c1s+HQdlM9oA4lTZ18=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:38:46 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:38:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 20/23] mdrestore: Introduce mdrestore v1 operations
Date:   Mon, 24 Jul 2023 10:05:24 +0530
Message-Id: <20230724043527.238600-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0213.apcprd04.prod.outlook.com
 (2603:1096:4:187::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: b65500a4-0832-4dba-1fef-08db8bffde07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nulOixjYn6a9fqwTtAlwRj2MvREWvmJE1uXAGKwbF6+/pZoCPqNGrAjkbYXEd2cORP5nugSDgQlns2JWVF8K2qPTjbD2rNVpMyLgg9v7L8rzViAEFzp4hEdwC5xHP/5bXjElC9WEtVufsPA9XZ4cU8kGN0IMRoKsY97+H4Vsq4aSxk94Uorsbc5rvYXoMISpsVEaeC0p74Ah3MoAQdUPL1j2dv68dN0ewfjze1zG/k+ZYQGGCB6r6IvzOLT9ppjdZyz4GmqAKWiIM1vCofc7Z8vwM4VOpZPlAyfW31lMzvTVCENa9YsbygQ/SbKd1gT8VV6DI7qzGR78jyvNRsSLKnbC4AKlEv6Y6Yn3urhMhmHo+rif6COo1lDApcMUkPXLtzHYXS8ZqwDegiriOgkdqbJRHqKNE8qyKh9PFxygUlM4rL8TvVwyVD0FQIaWgsoqUId+4HYDPTGngfDqlAXNS8LKUCtYw47ZKS48KSKM1sxHMIJ4NDhsrip1s3D0fJzc5Se5ZZ0MT2i0SzvVxgXrns5HkhUGrOF8bq9mZkz7bI2+v1s6z+KvyMjdnqUOYLb/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jKf3ty+iCeOQzuN8YYlUr9maVG1NatIHbvGzg/wXRBWh+y/sie+1iJD9krRY?=
 =?us-ascii?Q?2mq9NHMMAApR3r7Vtwqxts8bu8kPG3rUJXSTg0a5fV2n+yu3JKIaLIH+t78P?=
 =?us-ascii?Q?8Uc7Dh6uwnmZzuxvHtHKVQD9vVhJ3JPWpiZ8RD0Ztv/q8LIwbCFkbmuu8uQm?=
 =?us-ascii?Q?kuSCNBtbwn+72+iuGTuRfcZzYChaQubGq3ahYSdtuQpb88U/9z5/3yWh0ZPX?=
 =?us-ascii?Q?kMCJZIghzXeiJVCrMaNvcYj3gWwUrOgxEmealbHd/X5QUXMigUi437g4hqOr?=
 =?us-ascii?Q?iLl4KCfA0hdfue+a+67+KMGI4ZDt0n8lGOitUJKNY35pwb8Vp0AVU2EU57Ke?=
 =?us-ascii?Q?0gir8fSojCEQ/8rwIJXL0FbhqLWUO0b6LoAtDd54nKdG6hO/yUVjhVxPx1J7?=
 =?us-ascii?Q?VyqQSEbRfUTNg9qZvfoGMS7njTbtdcgDECpX4cRjGdmp+3vm5CwLB7ysaa80?=
 =?us-ascii?Q?xBCD72NW8nrKn6bt/Jl4YueRaMrBzltoS3pLjV++bkOvwTzuhrl6TbhpJ5H3?=
 =?us-ascii?Q?lcS4bl3vdJ4o1Al0kscS/nBK3iWKipBdZ+9T6KDyQ0SkDCEJPSD85P1rY4c9?=
 =?us-ascii?Q?0X74Ly/m+CnOl/iuaBNdWmod/7/B8XM1TLejwq4JfYTssb3CYL4mSVCGr83L?=
 =?us-ascii?Q?i6761Sq5X2LOz2YPJ2nLXvq0vCi502dtWIz1DRRJtjAc5vHs9Iln68TMtNU9?=
 =?us-ascii?Q?ZDUwN9nuGOfCI5Lhx+tcRio7cFvDJiYUdDmljIJmHYMm/GOViXQIIwxLwICU?=
 =?us-ascii?Q?J7KS/xxAGUJC309OzHSqRqB+PysczwLnstvAZAVGIxgyYxoStT4+PqEW+1t8?=
 =?us-ascii?Q?KtiTy0douGuzX1kLZbZLClfu7rKnSUDnA8nkOi0U+08fKs/287X5o/h+ZnYE?=
 =?us-ascii?Q?0G6z2g9WCkZstG3OSbd0JAY1LJw+ctTCdDuaWoN588IdKfJWB2fsRxpAd7Yn?=
 =?us-ascii?Q?5YhJitzIVKfpHxpfVBWm0a0LoaizXfG/f73nFAByZYwZbiSFIJC2Bhb9PB4b?=
 =?us-ascii?Q?Dwv1R6Ow76f+nWOFc1ZijWiRQSla4q+0FBvEdvopo7grGkLUljPgFPBG9Rt3?=
 =?us-ascii?Q?nTvKaz9NQD2qTVBv34SL4aHAXeF+J0EpVyK9wfeIsMGmYShaD1L5o6kisatF?=
 =?us-ascii?Q?ik7t/JHlKrzhoe4MtfxGamBmzfcVVFI5lAnJKxMAtEoEcIdhK68V2MMl1J1n?=
 =?us-ascii?Q?i1QZ45Kjr7CRvp8HYXTYPplnbhdGyVrmQ/XE3CF8bFIekYCBpWMv9l3GpKz8?=
 =?us-ascii?Q?NteCpfkjkvTgtH1kb5TDyyAgN7E/+CIFokF2OmGKMO1Y4u/Uq26xuWsyd4QI?=
 =?us-ascii?Q?JLyFblvuQREyL5l47vsApCHLkEbLDRQlEcPBYpg+kiIyIFNP382r15er5oG4?=
 =?us-ascii?Q?CWkNzxneN57DsyKkO+Bm9B3Ry3A7jd2qJ/K1rwZdZUXotxjNIMOAnAB9ri3d?=
 =?us-ascii?Q?8TsO3DUyX6UJfwN47u27rk8DGcAudKb+YVrNMFzyZTNvCv+JAy+TcbHVLEk+?=
 =?us-ascii?Q?34S5DTHhkqATUTTTM29MzXXmi7XSIOtnO2X7uX5EkNLJ4MTYYoLuv0A3U9aJ?=
 =?us-ascii?Q?gbAQ3YnR11v0RTeFKJUiYsXEyT11EsfAumd2iafW1hX/sG0YAq+6uzj/+EsY?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EA86otLdktCg7mbQl64kXXE2BOTGZRanMJzTHisD2kgP1wA1eZyqNXbH9cIDHgB+BgYUPucALpdVts5EvFqXLfdU/zh19mhce78PqvlwUSZ1EAoB+JNz6rMm4HxBllupNXQlZH6+aDGoKyDuEiiuNfHnKsW4gzVeolphVpQfKmBace2WFsMVSbCZ2vQe6VPGdxd/ZjHqcC0RPrlRrPZITJU0+KxmGwuU+E19O5ynIFRa/17ozRFqjnOVDLrUZ4yFjeds8aK/GOXALDRfgr5heoKR/xv51Wg7vAlshxHhOsBn36fDp2NzqagMBVdFZFz7EdRzRLSPvbW4gaVoPd+MLPbKffa3PKAutP7/88xK9B8acZFjt1voJvzTTlVFZgNRrWk2P4k9pucbfWOINQEEuaJ8cLRQ+XhBJW7Y4Z3gyvXKKflgWHo2tr08C7AK4nFMjWxksmqc30wbm4+QP5WAua7kDtzyRXqmnTamt5uwBP48SKZQJOMDLOhT9Y1WknN0WrkdhqH3VxwDeHUkgNkITP7vJ8y+0xQa89y9PZDklGC0e2YRipHHrfIPpBjTzIoAZZu+p6ckbBu2br2Ul7ZlPVVbbdNe92SSSshw3hgvYypRJ+r4xBT06Mm7G5TC1g7FmEsHE3ZW6p6W8jidtP7kzhi1XNXvY8DO7jN+KF/MkxHbU1LhqE146dsrcOmTlzYiICW45BElBJeH9m4+LiyU5mguRjOG3+gMx5IxiCWc0FPAPQAQdJDkJyjixF+GGcyUF/G3h/E+8jhhv+jJqYB7hx9wrdxMW6jjAEKeEhP8UQg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b65500a4-0832-4dba-1fef-08db8bffde07
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:38:46.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiWmaXDryGKcC01baUNcbNn9vWrwFoq8qaVE/A3ORtwL8IA4z/bOCam2tUWLnR6HFX34Kkps4HQBXVz/iINDTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240042
X-Proofpoint-ORIG-GUID: kCjEXgRazn8YHn6oSBfdiy1nSJ49zIKR
X-Proofpoint-GUID: kCjEXgRazn8YHn6oSBfdiy1nSJ49zIKR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to indicate the version of metadump files that they can work with,
this commit renames read_header(), show_info() and restore() functions to
read_header_v1(), show_info_v1() and restore_v1() respectively.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 4d1bbf28..b247a4bf 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -90,7 +90,7 @@ open_device(
 }
 
 static void
-read_header(
+read_header_v1(
 	union mdrestore_headers	*h,
 	FILE			*md_fp)
 {
@@ -100,7 +100,7 @@ read_header(
 }
 
 static void
-show_info(
+show_info_v1(
 	union mdrestore_headers	*h,
 	const char		*md_file)
 {
@@ -115,22 +115,12 @@ show_info(
 	}
 }
 
-/*
- * restore() -- do the actual work to restore the metadump
- *
- * @src_f: A FILE pointer to the source metadump
- * @dst_fd: the file descriptor for the target file
- * @is_target_file: designates whether the target is a regular file
- * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
- *
- * src_f should be positioned just past a read the previously validated metablock
- */
 static void
-restore(
+restore_v1(
 	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	int			is_target_file)
+	bool			is_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -253,6 +243,12 @@ restore(
 	free(metablock);
 }
 
+static struct mdrestore_ops mdrestore_ops_v1 = {
+	.read_header	= read_header_v1,
+	.show_info	= show_info_v1,
+	.restore	= restore_v1,
+};
+
 static void
 usage(void)
 {
@@ -302,9 +298,9 @@ main(
 
 	/*
 	 * open source and test if this really is a dump. The first metadump
-	 * block will be passed to restore() which will continue to read the
-	 * file from this point. This avoids rewind the stream, which causes
-	 * restore to fail when source was being read from stdin.
+	 * block will be passed to mdrestore_ops->restore() which will continue
+	 * to read the file from this point. This avoids rewind the stream,
+	 * which causes restore to fail when source was being read from stdin.
  	 */
 	if (strcmp(argv[optind], "-") == 0) {
 		src_f = stdin;
@@ -321,16 +317,17 @@ main(
 
 	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
+		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
 	}
 
-	read_header(&headers, src_f);
+	mdrestore.mdrops->read_header(&headers, src_f);
 
 	if (mdrestore.show_info) {
-		show_info(&headers, argv[optind]);
+		mdrestore.mdrops->show_info(&headers, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -341,7 +338,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(&headers, src_f, dst_fd, is_target_file);
+	mdrestore.mdrops->restore(&headers, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

