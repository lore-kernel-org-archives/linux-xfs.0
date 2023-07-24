Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2A7EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjGXEhe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjGXEhc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:37:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38B31A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:37:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMan1D018630;
        Mon, 24 Jul 2023 04:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=5KL2dSRBJcX6W/k04xfgLvJGNrMRIWN2CaQHACXy2V0=;
 b=c57HzYu6QoAkxGJJ6wae76KNExjxS1+wCyWCpHFm4YLN6Bcj03HP+Rtevfsve4yXb5Oc
 j0IpSOb9Gte41ZiktyhKCQYh4NprNnz+TlBddW4sMWbsb9n6oQjbGIEGqInre+Je3nQy
 cvwqD/xfji9Vg4LJjCRDVpefuj+P1fqCN514tXUc5vbqsDU0YdkXR0Yflb1cF9qG8QdA
 BAPXS9ZXQbpW4iaG8iIPJCzOnQiuYP7AZHaHDTkc0Sh7a4YrxsXVZ2ChAH5NbsmRkYsG
 HfGJG3VaiRX8+U+zt8UjEIr2Z0poifP/dL1Mdap6kABWOk/InkJSxO1Dxdzot7kRssmX mw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07nuhsmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O0i39O003916;
        Mon, 24 Jul 2023 04:37:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2x90j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDQ9nAUfAT8HGec8BwdlstIbRmMfj6j72wD4iIJlL9Qmf9fxAlEX3l4UUC303HIqdklRNSw3msP+yPRiKxYMWQbdFZvtLJVqNPyEW88mTLimt3rINuai0xjHnVyqiRRw4Z5Chi3SN9X35sYfFEN+XbqhGyAGPHeAPnwnaDPBgBhs2Ke+yVKxPinWxXf4gI0ZuuH2PEnijKF6ZREqtR6qSOxBTbGVG1gFMEsYO3HTfRxe2N4K639zg2dlUF7s2Nf2BYj8s23VsEi8EqBmc5QwPEnqNjB9qRz7wFvn8ctF4yZga+hefJy7VqvCeFgwtk3+udbyiHkNIVx81+Pxh0tmaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KL2dSRBJcX6W/k04xfgLvJGNrMRIWN2CaQHACXy2V0=;
 b=cYK8slRIqCICH09VzMFMArC7eMZLCuY3DoJI6QFpX768SmdisdGLC+WJrwqR8+NwZLFGPgteUC6AEErvauhtwd+z6b9ciiULH6Ol739XQtN9jeV4LawzyNrNiSNLLhKSt2v3e+v261uWupCE48CNau81o5BVw8QrwypXE1skVEIEk57Z1hoPNCOFtMTKcaRj0deKxJzSMyCkcs2v4jecyszuhNig5C1GrgFfCOYOqI2r2mYrb+mn24hee+GRFZ2nj7dClANXakJrozDroou2fHtb9NH11fSYxw1E9NO1aUtuUIwq8xZ3OQxUpfBcf7wiY2i6cCMV/SVABEptoIV9MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KL2dSRBJcX6W/k04xfgLvJGNrMRIWN2CaQHACXy2V0=;
 b=JyqhhgeTcfrC1fEn0aSY52H4uxNclMCzMxxpLzBTcdNoLEh/Mei0GvoK/v4h/WF8YIV69JnkGK3Ok9jyHzyjAMANnWfrsPIiDdgbufnnHl/wqRrr19hDx6H2YTac74gWbwtdyy37ZCDGhBTfyvFndHNtXDmRLlEFlxUGtxQWBRc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:37:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:37:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 10/23] metadump: Define metadump v2 ondisk format structures and macros
Date:   Mon, 24 Jul 2023 10:05:14 +0530
Message-Id: <20230724043527.238600-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0165.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:383::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: a0f3d952-bb05-4df8-dfbb-08db8bffadff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7X7ZV/GyLtHydX2KMTH/vil4WCTSlMYKwhewKISagM7ByUW3mhh6vD6nYLHdZ1nwj52oxpCkJR4SkqAQhVWNJiQasRRTbnugg/AXJhMf9dQZGdlEC3U5SC1Z+9aIzsY63k1B3cjcSY9+WCF89fbVWlpssXWxdUXSWiEX976DxMHXqD92QpWtdoog5N4Krh7tyO4MTan1jTEFl9NN98vhI7G/QBT724jjifv+W9w+6sTIRKOd78YyGaVfyDC/gvpF+2TJB1FNglxiN9lMHE2RsWA3LYNGD99sEb7n2B7NqWYAVMD8BgQsc+8k6Wcaad7f9fH9lZc6cQCQ5AsKfirGE/zqxsXNNlYLu5hXe+NmUKFqj+5wjdO7F1s4kHPz9jRSLEmTK2d0J8NoxR3UCXPUGqQ+oodWOKZj6BIcgwV/i1SAj2hJHhTLas+nO+VhQ4yhFZyDGsh9s/pVh4TkXnp/PJ9TZtY2WU1+gmykC9SKhmB3TFLR2wcrZyIPYFiKQTN+LurTnDfuxD7QeCRjapZXaiFhthiXccmz7wbvyT0vkVzNb1NdWDfq0UA2bx1RL8Rv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5o6wUYEXbNdzo+23rcAdUxdb0P7venUUWmkWlOrd0OxjaaQRJ127teAyXSjh?=
 =?us-ascii?Q?JeKgtsji0xhSwNIaoXpi2iNDYOfPxpUeVIGI7qpJtOFumT6NChKzMRTR3M5N?=
 =?us-ascii?Q?4j76ZyQ/2uWmNByPHkUymspSUXByWptp7QiFwHl8yxXs4R1OxTdNo96TiVd5?=
 =?us-ascii?Q?jnK++4xQjZIZRwuLPnx2QVDZHPxHZ1pMCzSKmIJJCMJyk0Q7efikZxbfJk7R?=
 =?us-ascii?Q?2zN4aqqg4W9TfnC5BFYyihHmTxAA4eysApZAYSQWBXcEZSa8OkMAKT/8m4Tv?=
 =?us-ascii?Q?3SbXEhbqFx/vPunl0c6te/+VH75C4K9JEO370JjXJbix6kunL7SOamXzOaPa?=
 =?us-ascii?Q?tpQuOg3qqIsuiFt64xtVgY3Qvsv4tu+H+5LLNIx3qHM4odo2he5O3MS2XehS?=
 =?us-ascii?Q?7GFDScDBjEFWTpLMuB7748Dt9jXPJxMDgUUssemkZx+IcX7ImIR9uCT4ayQZ?=
 =?us-ascii?Q?AkiqfVDcMmgBsl6VlymDaxoEyb+cfAc3M8MH8IbmQvgL8HgrD1SXt4QiFSX8?=
 =?us-ascii?Q?mHbJB+0vmA15oF3zCBD/B+r3MCkEHYhjK9W6DCy5xWy0U1tqnl2+rz6GxNeE?=
 =?us-ascii?Q?sAqkvmUMKdi8sUstgfUfBoMzrMOgF/9f41n1rPpZ3SGOtUXX90PC+/tc9cpW?=
 =?us-ascii?Q?NHnsSVNG1Ebzax0qxPz2xkhpoKS/OzfmMKrdupZ5RhgLJ3kXeja+b5F27ykM?=
 =?us-ascii?Q?KdH2eSMdTAEbSZ8cn6YmG0TWLcJx53axXNo3osOAGxBupyiupYH23O+4aZpi?=
 =?us-ascii?Q?yVxMg0UNassiqW7kZxg/Fdz/VmgAKzXSCVC8QewlQcVfz6LcEItYubnjS9YY?=
 =?us-ascii?Q?4QAbERJp4xvoIBqj0r1Ojj0bssaNuWX6M2h/jA4MNPRNKvneynySqTCZXJGX?=
 =?us-ascii?Q?ktUgZIirPCXp965SHNHal6zcgcXlNWjJ8V76SFgdzIe5VaX0fIcIQouwJZFq?=
 =?us-ascii?Q?ZZ9qheO/+74uaZULQ1FZ/2zkgMToZg93YlCEsHgEIMm5rsrV1lUXxaQyb6bh?=
 =?us-ascii?Q?5xbsIKeHHtDYgMhTh7JtCxCXjW7JM8rUkSHzwFYuK880ylIlvixYv+qSZwAu?=
 =?us-ascii?Q?0iAkRKOU8C/1ylKfmQAyy8BsVXGlRa8xEI+rgGlGJKgLHH4NchVGOklgPXf2?=
 =?us-ascii?Q?i2w9r8bNbUB//v63ucsd5V1uorwgyCaPaCK9v1gAJW5Y3MusY/PoaXrGHnQB?=
 =?us-ascii?Q?iUi4JquVPrWa5AleI1zteTJffYyo/Tr/QoeN8pSQffxp/VggKIBP91R1nrMq?=
 =?us-ascii?Q?bmghId3AVBv3q9zCHuvd4Pn1w9YEQ1GkWA4UpZ2uMrC1xOAT5MV6ogcTpcRp?=
 =?us-ascii?Q?gg6eZpKGehtJkN0tt9Ljb70YNKcW/btJvIGs+WAovUYFBv4AYVisDusIRm7Q?=
 =?us-ascii?Q?eK04JGDoBa810q9a/IFlldpWwDnrHbV/YXAI6efPT4NqfRS2BNPoVU8kM1zb?=
 =?us-ascii?Q?OGJJdQz+Yl4amrnn0MEHIGrPIWW2MBB6TEfIcML0ZsXVHMc+9unTWCh6I+rr?=
 =?us-ascii?Q?QZG3w6bMgMRb8jjKC4RWbbPj87Bw3X2S82SaFEP0E/bdtcsgoGJA1oivHpt0?=
 =?us-ascii?Q?QEySnlPNWZaQXWOk/b1GjVpTAmCHhdJJ8on1nmTuexMJpWkr1AIcCnkXJDZu?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bn+hp1gZgju4NVTMIJEpCnkOyW3Y9hzE63CNEHQ3vfV0jv0bcyKMeEoPz+v/FvSSbNBhzzZNaIZYcP81dCrBY54jM2bZrxcEBfh39+9CYCSM57dqmanrgFpictNuBs18470ebt8xsD3C10N0Ww/m3bFCZP6lk2vvMX2rmYN4TPLuEqEDu+h54SBBhQPLPmdaxjez9I2706BeRcx2vWdVOsAYTCkSXx3Qb5U29BNqbR1S2MKUj7pxsQEgvjwcOLCf1f2do7klVbolqDOOZkVqOJLNmlRf1m+v5i34RSXUUTOKqInu6to17K7VMfZkvNAIaftwIbsZ77NtRq165uUKQSbtkJBMVvnVlty+7pc/IaCKBB/Sc6t71IuoXPH9K378UPcq4eoDHhl6vdYEJ6s6wlHvHMfQXyZFZ2/4eLorD267gPIjvd1mbwG7XTHK9oWjHjZgQTSD8kIyQ3LrajQ6aHwCwhZxiLk9PQha2+2BJijmVZO2F6ok3CrOJZ5myxmQhytS6vQTNFh5xnMLtK2NMTEfVvbrh6VC6U7c7tBGCfevTvWn/n8EgawkFQrUSzNTph1xYlHLekyFZ2rf31u+xlU16ENRlgj4gC6HUkGCRAE3wTGNMLVzkjUWDM4Gixt3nob4L+YMfeh7RO+SiXAVo7BkPNOEHsJGtmpVoPIMrdcMWHMJ0IxWjBhyavTjlJWd/D0vNsTPqKSkrDu4utEJ85S+oEv1h2Kvh+UesyHkcwYrkPvpJUbjv74LFi0JvhJxiLEiw7XVkkFl3oDHgQiDWalxGlfXczs7oEkfVib6Mic=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f3d952-bb05-4df8-dfbb-08db8bffadff
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:37:25.7133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJQ/kYw3A7YqGCheQ8l1jBlAfyTc3fXm9912amTop6fzYJrcjvSfxDnJu7HZjrX2i9gyVhJ8K6CBOamrAZWIoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: mgslu71VCDcuIggtbO34-Fos84d5wYtC
X-Proofpoint-GUID: mgslu71VCDcuIggtbO34-Fos84d5wYtC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The corresponding metadump file's disk layout is as shown below,

     |------------------------------|
     | struct xfs_metadump_header   |
     |------------------------------|
     | struct xfs_meta_extent 0     |
     | Extent 0's data              |
     | struct xfs_meta_extent 1     |
     | Extent 1's data              |
     | ...                          |
     | struct xfs_meta_extent (n-1) |
     | Extent (n-1)'s data          |
     |------------------------------|

The "struct xfs_metadump_header" is followed by alternating series of "struct
xfs_meta_extent" and the extent itself.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/xfs_metadump.h | 68 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index a4dca25c..50175ef0 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -8,7 +8,9 @@
 #define _XFS_METADUMP_H_
 
 #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
 
+/* Metadump v1 */
 typedef struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
@@ -23,4 +25,70 @@ typedef struct xfs_metablock {
 #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
 #define XFS_METADUMP_DIRTYLOG	(1 << 3)
 
+/*
+ * Metadump v2
+ *
+ * The following diagram depicts the ondisk layout of the metadump v2 format.
+ *
+ * |------------------------------|
+ * | struct xfs_metadump_header   |
+ * |------------------------------|
+ * | struct xfs_meta_extent 0     |
+ * | Extent 0's data              |
+ * | struct xfs_meta_extent 1     |
+ * | Extent 1's data              |
+ * | ...                          |
+ * | struct xfs_meta_extent (n-1) |
+ * | Extent (n-1)'s data          |
+ * |------------------------------|
+ *
+ * The "struct xfs_metadump_header" is followed by alternating series of "struct
+ * xfs_meta_extent" and the extent itself.
+ */
+struct xfs_metadump_header {
+	__be32		xmh_magic;
+	__be32		xmh_version;
+	__be32		xmh_compat_flags;
+	__be32		xmh_incompat_flags;
+	__be64		xmh_reserved;
+} __packed;
+
+/*
+ * User-supplied directory entry and extended attribute names have been
+ * obscured, and extended attribute values are zeroed to protect privacy.
+ */
+#define XFS_MD2_INCOMPAT_OBFUSCATED (1 << 0)
+
+/* Full blocks have been dumped. */
+#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
+
+/* Log was dirty. */
+#define XFS_MD2_INCOMPAT_DIRTYLOG (1 << 2)
+
+/* Dump contains external log contents. */
+#define XFS_MD2_INCOMPAT_EXTERNALLOG	(1 << 3)
+
+struct xfs_meta_extent {
+	/*
+	 * Lowest 54 bits are used to store 512 byte addresses.
+	 * Next 2 bits is used for indicating the device.
+	 * 00 - Data device
+	 * 01 - External log
+	 */
+	__be64 xme_addr;
+	/* In units of 512 byte blocks */
+	__be32 xme_len;
+} __packed;
+
+#define XME_ADDR_DEVICE_SHIFT	54
+
+#define XME_ADDR_DADDR_MASK	((1ULL << XME_ADDR_DEVICE_SHIFT) - 1)
+
+/* Extent was copied from the data device */
+#define XME_ADDR_DATA_DEVICE	(0ULL << XME_ADDR_DEVICE_SHIFT)
+/* Extent was copied from the log device */
+#define XME_ADDR_LOG_DEVICE	(1ULL << XME_ADDR_DEVICE_SHIFT)
+
+#define XME_ADDR_DEVICE_MASK	(3ULL << XME_ADDR_DEVICE_SHIFT)
+
 #endif /* _XFS_METADUMP_H_ */
-- 
2.39.1

