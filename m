Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24142C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbjFFJ37 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbjFFJ3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:29:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD5A126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:29:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566P7DE003844;
        Tue, 6 Jun 2023 09:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=p+MszovmGui6BPu0ZCS88WXwgy2jxhc11Swm6Rnk6gc=;
 b=bKFwq1dDcksJHg4aYPf8O3XiFTETiREvXJujeB8WxG0PPljzaAU24Mao5jo6riH+o6hw
 CwoyTrxMq89caOlXQP9aOARDOLNTTED0d/FXMoOURDu8SFdpgAeiSDqjFb9/dwkBcoge
 dzBqmUKXaSuc9HcAfXDp3Jg4N3fNUv5E2T27SqSYhrlizctahW4croK/DvTfnqjFmf1z
 2rLdPsSMZr7BF2HLW0TRE1g12FvwCUwy0bqPDpDrpXbEXCRE4H0N3VxvGwzjPNCMLRMl
 6FjZTk2fiyGbeF3eWlJ8/Y9EozVS21xdSEO+A9ZA/gPvH94twehsA8SOzuURWCjEmMW1 +A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx5emtsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3567fhCs001615;
        Tue, 6 Jun 2023 09:29:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tr0c7f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8fCG+XDHbHvXnuNTiYsy+k3+UjrDMEYd3/401wEGItQK1wwGS/v/stDBwi8PsAAsH7FobLeED9iB2wcmKsaJoIihHUVmPLI7BLyi3fr7br0l1pqiTUqN35NVJ1DfgxoHk7Zb3BvN1QTlALBMMURXMA5E2JKoDFndMCjKOmIXhP0DMp7K/VOz9WGMBKx+e7HcxSJzMB6jAxMkK9EghFl2Tf+Li9J0q5ITnpQseXgR/kjnWB50O0oaSFb01VY5wD1mvtntCLpMKC1bBa5gaXR48kOZAAL0mdFhDVBjYXugStHCZMjd16rz/Xd05Wf67JasyUBqSm73/CbY/EKHaonvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+MszovmGui6BPu0ZCS88WXwgy2jxhc11Swm6Rnk6gc=;
 b=ii8X3CJaDli1PK79hKC8qYDht7d8txwgs1ZE/j6SbAFEJx1lBZm+IKW601y3k0A8kS7dtxGEA9HB/Q0p2+TMDqjHVBj8d2TpUVPq0pM7XfaZB/Hu2jXs5ZIuwC/oK5YSIjLqwOlGWfnwiXscpUmMOxJ/ArEqTdzw5dwA2wzhVjdpJEnR0pAzN89EleiQqC4+5PB1MaUjhJpfYNpoeeT7nnjDAYadrqbh4kAdd52CW6mKtT/oDsMzdtYfGuhO7OSPs7lzNohzw8ulTpmq7Addtcl1VrUbuKQb9vbXTmWbLLz4TvtzfL2oIA9Jba2DZQGPLv7ze20eubjW7Oo2srA8uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+MszovmGui6BPu0ZCS88WXwgy2jxhc11Swm6Rnk6gc=;
 b=pRyODqsGgpsos7hFo3lVyDPchFfOv+F6yx4Mhi65q/1ExkEGduKm3z5aV6TGf4w1NLcqNaio5uAHhPfhG5IJfHHY1BSLkUPhW4hCcvvtwqKc/t4ymsNN0LyM2mPPw8TkR8xwrB2acwbSngrDJvjNvI+gH19s5L+lU5QfZlm5UPE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:29:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:29:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 10/23] metadump: Define metadump v2 ondisk format structures and macros
Date:   Tue,  6 Jun 2023 14:57:53 +0530
Message-Id: <20230606092806.1604491-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096::28) To
 SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: a502e1a7-8408-4e40-b8a9-08db66708b3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u51xdSLg5ejC/8UTfuIad65ZWN+oqzQs8KeMTDI3NYNb1qHjCPu76eCsor55quI/eZYe2nL8fXGgsURaon/qP6+yjyFnj2P7ylM0IDo2Aej9wXxpPIeH9ABtbhyJwuwKPkvHe/y7nG3Uhh8sRhm6Xjx8LLzTcoZ+/rZVB8m9PHrIREYrSIVq70wFNyns3INryxWdYMkMoBTIXwtL8H8x7/LZpmuwDqD7TC8k4ObGyzkdUCvver7n6a0r0LFsTxJW3ekOI0Jdkg5z9Hzsnd9InNCPZ77qGYoIno6G2VwQvhqSaspHAHyxG9LUo3+dNR/urRAxPL4aDoJyX89r8+YK00CHNai9aeiI/mDAbvU9yVidJcgMhEWP/MRTJuEap7S7gVL6AuuQsNq4K8w5WEm2nBlcprAP8ZcSult8GgJl+3hRjWYOOVCrswNjO04Q54jw0BmF935oLNZnH2pKeDcxC/tYBd1IWEDQPTDfWyLYs3jlJcbIFdQHVCsRBswBa3OwSz/CRad7EHwSbVR+2pvwRIGPEITJoF/rQRM5Qv6dWReVGzUMxCAHvah1KWwXWgiU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fehVq4v2Ggr8+Lp0jmVWD/FvwtlNPgEJaORChQG8xXCG0UrLU5aj7l9KWD/n?=
 =?us-ascii?Q?i5xcqmuopVoLpWhp4ql/einWoH09UN7RD4l+oxEU3lVn4sj/TOB/UadoIpYV?=
 =?us-ascii?Q?kTOP388K27/9DwaZk5NEQInuRUWsm6XtnSUjr78Shd0KOY+HX4IIfeUZMJPv?=
 =?us-ascii?Q?bwFQ5GTRwerhwH1/OCtINvGGu5mHqCm3i287Rj+SFvcxRra+a2m2q9SZVIPT?=
 =?us-ascii?Q?YGZ44EbZkNdOYs5DkvmNB6amq14Zu49qlbHU/gOYnZHuWXkO+8uolAJQV5pm?=
 =?us-ascii?Q?/oFFJYyufLj93aDcewCCrOkbgaPG4Wtn9tmW17KOR+/HBXWfT7mfSVseunyE?=
 =?us-ascii?Q?gw3GZ/AXbQUC3H6JjVYbTS1w4yCLP69Ky8Woy3NmCHeyihrqbiJDox5LV2wS?=
 =?us-ascii?Q?1FEaOrPxLejFp2h3GYQBfSRnVvHflcx1R6EViTU+GKwAUZnt8oeUV7HIR37v?=
 =?us-ascii?Q?K3K3xTLssuvAE6Hs5SfdBnIANbSGUEU5RTu3XZlAmxAIf03PbHr358nAsgq8?=
 =?us-ascii?Q?S4wjaolVBjYzqqJhCloi+s74Vxfx9lfzH5hSsUIpg5uD7KryX7aw9ZrgCWs0?=
 =?us-ascii?Q?FoN2BKJWEgg3LW9Vw3DnXg8JUy94iACUXWyDdPBgvxrmE+Hf11VQU8s7w0Yz?=
 =?us-ascii?Q?z4MyiyBbl5pS0KVUdTd54BoKvym9TlJuZdI0U+6Gdz7fvjfO3YWIh3L4g0ZG?=
 =?us-ascii?Q?6vF10GQyr5WrTFGvWOqLzPCS0x3su9eu6KAHnz1InNVeClKMPyMjpN9K7UTe?=
 =?us-ascii?Q?g742WzvVD4TKBy4GDTMacMcuREA10g/a91PHbslcnV2rDTfd/k5LXC6vVaVP?=
 =?us-ascii?Q?x5STD0XLBSzqwefQ1kFImNVlN4W9GNEeSo38Fjqax53Ok3cRuUa0Sscm84CO?=
 =?us-ascii?Q?n1vNrGzP+aKBiS6BHZMKolWOK5O6hPBZJQQdOh+hUcZ9iILiw8H/XYUV/IR6?=
 =?us-ascii?Q?SDBWeoKhTY4pnHN1tFAk+94uvi6ruuI6i74f7qqV2wZOa3h6m5U+3n6trP3X?=
 =?us-ascii?Q?u0B5uv0LZo56xyh+ZEwia49ojTTNp/dKRz4in9g33f5orvI+ommneX1stEAD?=
 =?us-ascii?Q?2RiQgxUc+VcYlbo+B+QJDzUZeYkY9Cv5uNFemRo8MHvzoita1wIObg4YKOOL?=
 =?us-ascii?Q?KDJ1zcalIzEJhmagMbZnq9AzTSDsOPPdn8yObVp1szMxcIAyiq152gRfW3HT?=
 =?us-ascii?Q?UV+mKbvYrwO3B8XevoXckQsDh4+2loZ/kgWtcthDeiUUZmZ5BHAg242CwbRd?=
 =?us-ascii?Q?A9rLwCsax4FrReRNh6WDk6VaYkQUfeGXJNEwwTR/Hh5tBFKfniV5DSjz5UBW?=
 =?us-ascii?Q?ZyaRrzTZox1NS/2AHvIstDdVDZV1Y26dSUsawf+aasZSB3fwKx60mIM5LahN?=
 =?us-ascii?Q?EmDL+4pf3n0OTMy1h75vU4EovMGxVx5oSC2guv43IAGETqov+SJADXruhKFL?=
 =?us-ascii?Q?9gY113BZBfvLUws1O6wkNCzJE2W4TtOFqbHdJ1cAAd3pOn7/aG9ABpWaL2oK?=
 =?us-ascii?Q?QsRZSjkC3GKsvn5FXpcb6RxnK3NhEXSmwG+CUfuM41URbOXrULxdROEmrlMw?=
 =?us-ascii?Q?pqqRZOqdEBDuAmNhpnZudTPoU47jIJRUPYlqr53/z/nYGv+8rTgxlFD6VqtO?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JP+UsiQFD9ucG5TeufWJ2SiyFSs0/D+11s+Yekc3XuLu5by3veYej+W4Pkl/OB0NbBfTBoqbm2YimhhZkB627ShdJHAuvXrACXW77xzl32vVd5IX2ohDTL8J+6stH/Y/TGKmT0dMyLeEy3EWHXpzjN7n77Mzq+oTWbV0qcZCvsoH85XlV6g9J7Et1SzAUPjuwsywX3LJycZ9NUeJJNOpojNX1E/PMJ+KW3DclQz288zZJzMrY9vOjU0nByIzh/1LkFMuKz+7F8kQsBWClOipunlA+FucVElGDSTq6juK2Havyoy4ktQZ61cOQM0mD0ZvPmqiPNo/ATLC8pAbmYhMCaJHEZXV/CUhLZ8Y05xuDUNSgjtfF6yJQ4jDasKTyYDZgUU+xgtHax9VD96rjrckrKm9pHG/a9roTu2gBJCh7xzOQdruRxXjdWNEKsk05efh4UWVoSZvYuqFejoK4nuc7dq8h8MNvGMxRgkBV9b2+oHHNEDHkQA+Ulncdf0/Fp6/w4AmLylhCV31F8PhPmySMnAbG1MXzfyxDg48TYXk29gWAcDcpxVmBz9vaRc2Vw7gIX5R6Z/DC8JqqqIUoA++wV5ED0SMFHy3ACdwnU1oDa5fqBgFeyX50mTYffCsTHZgwp7z+AoiqX7MqvwEIEnB09uK3Timir9oN2HTIH4FYe6r3V2rcjltq1pLf/OTsfuSqvhYDVzBMEYV+TErjchfZmfILHagFi+j4SJ+jjlbTRIqaim0npCxBwgVQE5c/4feoF218RczVBabH9+md7NjQ2EGAEaaW6b0hJ3zTa+xLYM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a502e1a7-8408-4e40-b8a9-08db66708b3f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:29:36.4344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XMuDbG8J2YDz76G33ApOQUkOA0IXPe0qcQuM9L+XgaAJ2gqfpq80XAnQRuPWleKt1jY9yBT/VMtwlG9kfPRMdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: _avHkhE41PS6mPQw0QpTZF90j0IVxE4n
X-Proofpoint-GUID: _avHkhE41PS6mPQw0QpTZF90j0IVxE4n
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
 include/xfs_metadump.h | 58 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index a4dca25c..518cb302 100644
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
@@ -23,4 +25,60 @@ typedef struct xfs_metablock {
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
+#define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)
+#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
+#define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)
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

