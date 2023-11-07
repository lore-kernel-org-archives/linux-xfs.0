Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A15C4167D
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbjKGHJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjKGHJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82FB11A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:03 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NoSN031388
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=R+OIMSXaSSdWpaclGhG9JzqsC/R7PmckAA2Vt05yIeg=;
 b=LEJGrljqk5r08IxAVkJlJDepLeD46RF/MRlmuz2dLNVYANIL+UvkQZMQHd1fg09K+YDE
 uS52SlSTn/tzzW4YVnP6mfPqQF/5opOhQGYVv007dDtmrp+c4xqNBCRwyQUHt5rR+tik
 dnPSBpsd/4Qa+XLFu/hZO11ld26XcWvFkW+uHuHb72xDYq9vgEE6tUfhaVD2TtcVSRz1
 T4TFciFOtOILvh25mJat/QQjMYgwgoeNZyrOdNGdOSsLuVMEvVIy5wRaCm7kepsg4hxX
 EdpwDT/K0g3XEZ0MIYJEplJ4Z92VPUExp15gZoryPOTzVLlxRm8x6/+AlQ41g3NiLDSJ dg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdw9xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76PYwL030550
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63fev-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+L27LMjxdM6XhQcSR9uVUSUsQPpfdKNoN8CWE8xchzTZtsWzG9l7c7jM3eNfsJHMRdLmdavO5kGJt8iqb3F5ldSjQI8cqtPpUrKJ4eSQM5LhhgwWh+Ev3sbreH6aiwpZyE2k/7yDwfRz4Y/Glt1rKGR8xd7xQ+SO35DPYGI4lvB0btA07NkwMwi0Se0P+oU0+K2RA0oBvAOmBF/CkJEDAJuCeuEJ+X1JRHOGBytQpj+dnvY9pDgn+t8quNd3v2g63HMES6p6EFJe8vxiPUgFCBua8OGnxBZuVKAdnxLxwNkC1bVFfa7UdP1UiMTW186HS9ZNzbFHk+38s/ZElYN/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+OIMSXaSSdWpaclGhG9JzqsC/R7PmckAA2Vt05yIeg=;
 b=kmCTmNodFkgnDCu5XJAFTOb9DPmc0fcwSPSqe+xx8Oiwmceq2RF2+oD4x3vrJxrl1XDnvBKNiuLABP0EAzrCCS7jhh2aDBwS1HX5C3ZuDbVphCh/GI0vzHkURi9RkeULUEElbxT9DeEw1AU8px8LiVQUf/3TxAB1JFz9C0//aFC6KYSrsLpNpAgjGiOBjoZILqJpYwbGmtUdOPYfRdrk9Je3SwnKlmj+yYSPUaXTVgEPgueec5oRRIxG5Z4e0gJaBR+tN2fGIx68BKE+/uWNxsqDa7aIUgijfZ5QD+wWYHMEMV7RWFmoKamjwsKMPE8mRrrPHOHDH8sDg5rSj7zTYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+OIMSXaSSdWpaclGhG9JzqsC/R7PmckAA2Vt05yIeg=;
 b=NuJT93Dydv9M3U3Kb3dcPHDayB2UXAUOMUnhjBHG+gyLgCPQYETe/cLzNmZY68l8MSsumfzqw04CSErdinAqLYiH7YVtOmFQdbTgRY7ALm+RkegTcoUgS6vBKCrGnRx5wYrLM42kLpOHiKvJK1ZNB8yYrsduqlQST2t9K3ls+x4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:59 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:59 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 17/21] mdrestore: Replace metadump header pointer argument with a union pointer
Date:   Tue,  7 Nov 2023 12:37:18 +0530
Message-Id: <20231107070722.748636-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: a74b9ddb-9679-474a-7370-08dbdf606a08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wezHch0pMwgK329To1AekKAtFLMzW1HX/YUVczXqPUd/yreabFbuLJJces2+7pyHiSOwaue7s+fTFfR3yX+aulnRSlHAJU4UkD5I1JZlXWRr9jNZN/lvxfE5fAk0mG0JMwjy6/XvY6KXrzm/RoPiUUJyL44j5zV1o6p5puO3+6g61ExopiytSvUncHzkZsRgUeZsoOMIDxE51uQext0IRELGj7JO4bOuTj0zpxwcs8wFA5AjGeZZ6UEb1fq5zPTaVVboTRTeHElmgvfntVTWh9djXop5IDgV+SZFLXtOQMZcUauMvRyYS3kOnOmqXa4R0gAfoRt+jVJolUBqB+oV4BL9JEUJZnplpRkCxbgHMzca0Q+IqZNMXE4N2hvJdnyG05qKdGXhPWV6JnFXz1y4jh7guBjsLA6IJfEqTwZLWhrei2r7qK9wzQDmsJQsflmnl6156+MLvWaa23uUOosB8iaF6HH6Mic2hLgRDq2gLWn5bz0l0uTMJPcfEyThKQbzkVfGtCoEGjQIlF7UvssWtn3o5UsPuMne6IVen1MkqPuKGMztMXtB6C+YdNy011jKCix2Enu7P6v00/tHIYPSiHlIcv6p0eaMIm4um+mXmbaZJaBhp59ExVFtRTZ97tQ4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(230173577357003)(230273577357003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xiFnoMCdjfinlbNHPTgazBiawo5sSJal6mnJVR9t9ZkPUvUQ3I/qb9Qx1g73?=
 =?us-ascii?Q?AaDgQoimGsZC5YktUXEjmi2WDnEInyfSsv5LmLQdJombmLhN1ev1mQVPrWBj?=
 =?us-ascii?Q?iukEtj0jgRtutzCAZGswmyiU84XU1Oz9KhDGRxDL0HRNWspJb3SZSq4CddCo?=
 =?us-ascii?Q?m9orZRYWmaPWv3tDDz3kb0PtfimHes0Abqb0TRUoLN1sihLDNheIpbOwKP/j?=
 =?us-ascii?Q?AoI3MWZiwnrdr/sUkaLjvF1A+V6m5ye9g0ARzP2SBvfBjFtF8yZOFi+5olBB?=
 =?us-ascii?Q?yfHiU53FcvQ8flggAs0dBgb1mOcXei8Vd0wrQsGMQe0/poex9yw0ZrDGn/9Y?=
 =?us-ascii?Q?PefJm1eT8u9eqvPY8N0mCIr3nbkHaVpHBbDJDwxJ+foyK1PkqB4X2QOunxg2?=
 =?us-ascii?Q?h+jn+vjS/aTWWPCoNDNNvEX2Y8kGqq2RLAkcBflZw0pSbTnkhLhLlUx+FI1t?=
 =?us-ascii?Q?SEHK8sq05WUTkFJhcM+6bdLWxw2zKlUza4LAev+X2VYCvbJrRIkZ+Nc4gXnb?=
 =?us-ascii?Q?eNhngOsHr+Vk9ITQc0Urxm3I4i/OuPTo/NM+Mu+7AySDMnTlhglVflfFoQdR?=
 =?us-ascii?Q?3XkgdXs2lVK0j24PBoAtMiomdBuLOxdZj7/gZnzetIbtYkmEGd2D82okMIQP?=
 =?us-ascii?Q?t4rsTL4iCIifs8Cl4LfV2Vcp8d1heeyDHtN3WxzpuCzcrN1HutoUu2iCHctE?=
 =?us-ascii?Q?Rs5U11vipGFb//GaZNYXUERvBIpL4y+r9xKnobHspXa0sOMgekvfHdl+I6pJ?=
 =?us-ascii?Q?2wcbXmYW5V9QkZjY4lr5x5PZc7GVffPaAep+KAg7Bn5FKAljLmastpLE76DL?=
 =?us-ascii?Q?28aKnGvDtw8E6G1EwzpHH6cZf2GLGm2CRKcFgMesJV/heFADHmx1wGq7e5ye?=
 =?us-ascii?Q?7P9HDEMWij1DnT7lF2pIyjWhsNykrYEwImWQ0aTSncjAK30EtLRGFNxFvNFt?=
 =?us-ascii?Q?97ZJV+6lpr2BZCofampyQIg2/JhaIuuSvoWiFLR+/rmEmogBqVKbZiqs5liS?=
 =?us-ascii?Q?QQOrVXWk1OkkZkGKO3GKwaJUaSiCE7vAtHx8QLRyV3dfQc8P6BXUeXpZj4QB?=
 =?us-ascii?Q?+aXWQ96QTKhGlpBvKVGJgk06mCAt8ozbTCYHdINazvErA/E3zn/vBkKYBu+H?=
 =?us-ascii?Q?N8ffLjQolcf8hd3ZgEm9icEqYouGVZZIzuwe9gvX8CA/gv8l7jyT6dd0k69g?=
 =?us-ascii?Q?Nz/6NkWnaSoWHEadcAyLk+bqTUppq6H1it/tu/hANNWsJx8H53cFoLV7XME5?=
 =?us-ascii?Q?nVBQB/pbeWF1LPSTEnRSZmGt5YNDVHFIEX21rqUdLNUKBN0/mZK8Sb4v8Gua?=
 =?us-ascii?Q?Zb1x5gMetCAsdSim5kvVMzVND5sssTbeTHjagIjNrjJrJxjBfyedkBaM6f9k?=
 =?us-ascii?Q?LpULdRyPQosKyULQRUobcTBeG9GTlFWWo8moNNutM2iR8irC69aN91BbDLtZ?=
 =?us-ascii?Q?B8/OgbgKAKRih/3EMe1pizDg9/M6CQt5T5uq2vy5N3p2B3uowhaH8NFn05/8?=
 =?us-ascii?Q?wtjoVOMDi/3YbFr5BClvlHpj8eoeNRzLkL9mvoD9pMoy5ohZOq3sCh/VELrY?=
 =?us-ascii?Q?DnJFMby6xAugUmMduADIW3qTzf2KcEfquFF+8CNm9mVV/FZrhddTCQUcGwU3?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: M/Xf0pq9goe36zeN2EpH4K3p3u+a0YVVtIO9hEoam/S0DhcH5w2lHgFBbJwnjjSIOk3WoRGJ0FRT+IoDVPq0gQXjbu8jrTwa0EW58gjcYnk4VqlQ9ly3QuIIqdZoqCb/qgkoWhR4tnVZGVT4uY3yCmk4s87Lo+Wn9tVxzy+oa2aT1+8KPQU/kAf7cDWIN45VmlTRcr5d8LrMypLlXrv+U2ImmIaNBZwV+EpWrl/QD2Dwt0FKC6tmxG4rW70MMeshSdWt6J9rhSJknqI0EHndasLFUrBSdlTVCQ1hlHHNOvA7/cNWqKfsRdykWSRoqMKdzEprD5zcgrrpNeQNrz/FXMXqQA4+qgp2lwP8AhBtjiM6ceG/V9KlrEfrYiHr+h0CHoe1LoR3E3D+jjDUeuoDiek9M0c8ef03Xu2Xkjou3d0dlqseIUVdeydfGYFP3eZnW8tiYwjm66PDMc+BAnatGILmZoOfIG+hcrzgIOo0QTIfndPfHYMPr4FgU8ddiWA0PDAy/TQzxkxPOZtDyojBm7jTg34PvzUccna+kFW/kHN0RaXqapbGLafghiewO4ZP9oI4O4mh8PB5XywsOdwQOH1npDUij30SqvH98OA0PwqizjmYWym2ziduz6tF6dqQth/ERADVHCt10GYKaM+jizCZO/q+eik3if8nwrifDpVDnVYZuUngIZSUq886nCLWJ7Z09JPR9L28vkDZnawySRt5omWI1A9j5hYAgc9jgwYpmrl4Tl+nPuoEaxLIuQM7lMs+ebnf5TX9oUZRxzGpcA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a74b9ddb-9679-474a-7370-08dbdf606a08
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:59.4601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzswx0z0+RD3hDW63Gpfv3tUykFrf6zUHa+45QNJx98WMwb+Tc/Pwc6DmwsKRyD+BdaXhnTpaj8kKlVYqQswOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-ORIG-GUID: -0zDRNirYN3mBN2qE7d5JWtw5Q_69thw
X-Proofpoint-GUID: -0zDRNirYN3mBN2qE7d5JWtw5Q_69thw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two variants of read_header(), show_info() and restore() helper
functions to support two versions of metadump formats. To this end, A future
commit will introduce a vector of function pointers to work with the two
metadump formats. To have a common function signature for the function
pointers, this commit replaces the first argument of the previously listed
function pointers from "struct xfs_metablock *" with "union
mdrestore_headers *".

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 66 ++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index d67a0629..40de0d1e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,6 +8,11 @@
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
 
+union mdrestore_headers {
+	__be32			magic;
+	struct xfs_metablock	v1;
+};
+
 static struct mdrestore {
 	bool	show_progress;
 	bool	show_info;
@@ -78,27 +83,25 @@ open_device(
 
 static void
 read_header(
-	struct xfs_metablock	*mb,
+	union mdrestore_headers	*h,
 	FILE			*md_fp)
 {
-	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
-
-	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
-			sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
+	if (fread((uint8_t *)&(h->v1.mb_count),
+			sizeof(h->v1) - sizeof(h->magic), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 }
 
 static void
 show_info(
-	struct xfs_metablock	*mb,
+	union mdrestore_headers	*h,
 	const char		*md_file)
 {
-	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
+	if (h->v1.mb_info & XFS_METADUMP_INFO_FLAGS) {
 		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			md_file,
-			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
-			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
-			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
+			h->v1.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
+			h->v1.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
+			h->v1.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
 	} else {
 		printf("%s: no informational flags present\n", md_file);
 	}
@@ -116,10 +119,10 @@ show_info(
  */
 static void
 restore(
+	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	int			is_target_file,
-	const struct xfs_metablock	*mbp)
+	int			is_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -131,14 +134,14 @@ restore(
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
 
-	block_size = 1 << mbp->mb_blocklog;
+	block_size = 1 << h->v1.mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
 
 	metablock = (xfs_metablock_t *)calloc(max_indices + 1, block_size);
 	if (metablock == NULL)
 		fatal("memory allocation failure\n");
 
-	mb_count = be16_to_cpu(mbp->mb_count);
+	mb_count = be16_to_cpu(h->v1.mb_count);
 	if (mb_count == 0 || mb_count > max_indices)
 		fatal("bad block count: %u\n", mb_count);
 
@@ -152,8 +155,7 @@ restore(
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
-
-	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
+	if (fread(block_buffer, mb_count << h->v1.mb_blocklog, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
@@ -200,7 +202,7 @@ restore(
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite(ddev_fd, &block_buffer[cur_index <<
-					mbp->mb_blocklog], block_size,
+					h->v1.mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
 				fatal("error writing block %llu: %s\n",
@@ -219,11 +221,11 @@ restore(
 		if (mb_count > max_indices)
 			fatal("bad block count: %u\n", mb_count);
 
-		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
+		if (fread(block_buffer, mb_count << h->v1.mb_blocklog,
 				1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
-		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
+		bytes_read += block_size + (mb_count << h->v1.mb_blocklog);
 	}
 
 	if (mdrestore.progress_since_warning)
@@ -252,15 +254,14 @@ usage(void)
 
 int
 main(
-	int 		argc,
-	char 		**argv)
+	int			argc,
+	char			**argv)
 {
-	FILE		*src_f;
-	int		dst_fd;
-	int		c;
-	bool		is_target_file;
-	uint32_t	magic;
-	struct xfs_metablock	mb;
+	union mdrestore_headers headers;
+	FILE			*src_f;
+	int			dst_fd;
+	int			c;
+	bool			is_target_file;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
@@ -307,20 +308,21 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
+	if (fread(&headers.magic, sizeof(headers.magic), 1, src_f) != 1)
 		fatal("Unable to read metadump magic from metadump file\n");
 
-	switch (be32_to_cpu(magic)) {
+	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
-		read_header(&mb, src_f);
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
 	}
 
+	read_header(&headers, src_f);
+
 	if (mdrestore.show_info) {
-		show_info(&mb, argv[optind]);
+		show_info(&headers, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -331,7 +333,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(src_f, dst_fd, is_target_file, &mb);
+	restore(&headers, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

