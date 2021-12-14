Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC87C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhLNIrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:35 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15478 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231426AbhLNIrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:31 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE716DY004456;
        Tue, 14 Dec 2021 08:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=O7Gf4A55dCLozobWCVgnAuzuZ4SAfOemnwzfzPXBm9c=;
 b=U12pDaDc47tZrBn4OQnr4RXWSseSVKzmYH5NIYlkdkWjLwVp+0QyFN3nHQ/JurRbHlAU
 ZSsrxoQ4HTqLKWIF2DThpMe2vsGyZP+d4uiWr0hQH3UTYCQ2V2iqc9iE/lVhKcgst0P3
 58L5VuEfG03syuURwgTBz9a7HMfAr4hCj8mhipzb3uUYogAuUwsCIoM01lR+dBr2/wUM
 aqgbB5dBdob+ltOMtVxAcLml/OCcRGsPguaALIrjvXUqd940G+dHDX+nIlljvtgH+x3C
 dKaKhz/6ugh/82itBjlY86URVEq80O9RJata1em//QxyHpYtjME0+OuzxfdOmRhIkdIP Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mru5wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8foUG104522;
        Tue, 14 Dec 2021 08:47:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 3cvj1djqnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INDugvO2BXgljxCNLLKSPOviwBT06mQV/hf29x05197EvjQex/qYo6YIfnSqMSIvEwf8UaAmlWP3Tj71RKPWxTjZ87vvCGsBtO6Bq76qShSDZFwSnJG+uaj2x7sk1QkReLFCoMc54MyU3a00pZMGtOxAvo2TgovGhuig7nTa0DXTfHm0ANcM/qVfMkOxJW/+dfFcXiS+iLprmrCDkZ5DIMHB7LF+zntcJsGX0KqgP7dbBjvhHLHnZCXTCkhr8Zzmwe4qM3zDs+rj5dyzdAsV4VybxAeKnaH7CTtmJg/BdsWt3/EeyQ6hTJ6W2BnTyEAbKrLV6JF3ZTmRxe/cDM1taw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7Gf4A55dCLozobWCVgnAuzuZ4SAfOemnwzfzPXBm9c=;
 b=ja+O7/9XSZVjfP2mMvf3LELRf5gUhHxUiiu0PWjxO+kGJ/GV/awDh3FTjZFQ19AYRNMCJz2bOfRbRHqsFBm1Q809S3RKertoTO3FD9EN0OFo+9FYY5ok/1jtSLkZ5BP4kEkpLV2l1gfwrLGdDRAHGRRc5uiq9rxFRbp/3aRotPLcXRwg8aLF6QZo2Dblp7rFmZ/98SWqqxRepi6pOh0PzC9xDsRfXLuotcxwoFWYUxeoaMVWDDHisH1SdlCUwirFtxLbC2rkHWEAllBKThbSI7BqFA8qPngHADNjhmbYirCuVWNEPbPwdAwnP26dbkXWxiqPZ5KqurMwwEzsEbu0gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7Gf4A55dCLozobWCVgnAuzuZ4SAfOemnwzfzPXBm9c=;
 b=k8oQ4q9pgAk1uppw1ZeVAJ+nXID1TrKjIoehrYYv6RK9T770AfZmCV7/9KNXpGsDa+Nr0grCORAHAUirzU9j3JkvrKhtCOZB7RhsWuHu5fsbHJmy9fYwkpRxz86y3J7/NTNc2ETr5xZGJA11WPlh7FVuWPCGqjHVDMHVMV0BXVo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:23 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V4 12/16] xfs: Introduce per-inode 64-bit extent counters
Date:   Tue, 14 Dec 2021 14:15:15 +0530
Message-Id: <20211214084519.759272-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4045fd7d-5085-4f60-3e26-08d9bede58c6
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB305401ADA5CD7C176380CB80F6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PinI1YMDR0bZBUZfgXBAQ32UlszPNaxiFrWEhVXREA0r+CQWadQXpPlPiyxwRb+BHIeYmzaHdGIK+3Ze7dmfAPg4xIGsuVVIXSY7uKeJZK5pP6ff7JAhPdq7pi3+ucH9tGR4CzoU52CQjduF2cC34UXRcS+/ON7XOmAQ4bnH7vb1D35zEze/GCYOaaI3QFbxxD7oG6mn4QkUvd9Ym6HQwCJavtIIkfIh4aknRU1ujxGEsej3cmvIve9zZ8ZDRED0xjbDUjtsPk13IzXMxR+z3w5WymQdh0SKv1atNbglAyHy9mb02edDA5AU1KeJfNlvbZoKO6VLfpdPYcubKIYYbnLuSqxAdKU+Ww+JE7OP/O5AQ3JVM8aQ+ZR453N2vyYFW7tYbSdHqSOJyVPmZT6ntfqfi9lyDX3yDWj0daFjOUiRUDUT1JRzaNhmbW5/Qiv8EQtNkkkwyP9HlwHjTIJAsU8Ean2Jfa0bVZL8VFxar49QEeQ0lldKOPlMn1pdEgiD2yKFyQrHRFDeb1qKGb6XeEIRRiq2dzQLzV3VVf2xGJyDpCLd3IOz5FpdWS/ScDdHJjDSGLJyq2iiC+5YchiHBbHpcw4+xev5hqg5uZy9L8sN8OlRVcxJnrmjESnhtz5oOFJYRw0eDDu3UuRj2QauOb5kfIEMQfeuXrVk0svDtb01P38vTJGDU0IdYhKRaro0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(30864003)(66556008)(66476007)(6486002)(316002)(6916009)(54906003)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qdqUI95T1LyVHXfnHxut+17fK4he3l64VW0fLSf6OOxNdw6pkuNnbw8TaVXM?=
 =?us-ascii?Q?KzbTCFNjt8zwiZAlAhf2B8/gfAYn1V4Mk2/pJjYCqL0iTPbD/iEYJJnHGfCp?=
 =?us-ascii?Q?zQalD9MkLiWe20mFPTdbejMeBBgU/jwPSYjwJ8L0YXxBdbx7AcnmTMU9+IgA?=
 =?us-ascii?Q?iHcDNMDxahNW+aQa3tF7xWI7Jh+muW7g5PYeLM2nECcp0Ais5zL373NeU6st?=
 =?us-ascii?Q?mTXaFPz5tKmmVi6QvHq6DpfAjc0rtbwcFzwLvq+7V/tdPvd9dQYyqkRe5dLc?=
 =?us-ascii?Q?LKs/74QEyeK+BCzrasfS+jGG45RyeZJX6fTXSHa1hFh37QDt0M7eo6msIfC6?=
 =?us-ascii?Q?UMzcQ9fkGQuwHFFvuwceeylHlbfbMrRV5Uvu/bsns4YIzA19kg4U8nss4mZD?=
 =?us-ascii?Q?cUgiWEUbLZ9VL6h1i7Mbm1JE+gFkEiE5Dsm/DqWeRIepEHOfHYs3eVlgKqWC?=
 =?us-ascii?Q?8zx63LntO71wX9VKweTc2DBLmniQPRny1Zp9DTVzXwz8W54LCj8gFoYqx8qe?=
 =?us-ascii?Q?cbuCe8x9Q+ofjwRvsHVyosjYG7TUgi+hVqpb8mfMJsPVSDXf9WGoJ/zRY2UF?=
 =?us-ascii?Q?ZcJJ9B6jnxVW1OWW9S4kdg+2+DEJhm0YH5LD/LPDrNsWzfBD13NXzA6jmaoZ?=
 =?us-ascii?Q?Kwi7nxtvMreT0rIXh4yjt5+mt1JEjoJO5V+WmyfQw1X5leRJuahSW3es0AU1?=
 =?us-ascii?Q?HeiWSqJa8Vi2tj8D8RQld2xpuDd5xAKHSvb3bbKHbT8eyrUHUj6zcKHRD469?=
 =?us-ascii?Q?5T1aczI4fkrt/Xj+NpNN0xn0v1BTk4DpaJo1pJH1qsHicVJWczikTyGJvNxO?=
 =?us-ascii?Q?0Tf4bsoTw6oL9trYS4LgQrPibsC/iF6TFpdz7CvtFVIYFc8ESz1AZxd1OTt2?=
 =?us-ascii?Q?aPLisZW4nPdjbbtW4aaBQz1a08067QIyeKR/HFpBNZDnIcjECdSCAjIOEHIJ?=
 =?us-ascii?Q?yc2M7TMxnM7zU6EYZfixdzdoRZQIw1qU3bJ9Wa6ty8iO2StvnpEwGycr03Lr?=
 =?us-ascii?Q?HUgZUZ1hofeXaLOpRLp+iPnaxD+UVThy9AyzTfBv4SJlneUV86Dfb/h8Xv8B?=
 =?us-ascii?Q?x+C7AD+kgI3c5ozcmrtwQnjL5dzE0EZmPGhyCwSx6tXOjQCNQJmlefb+OgNX?=
 =?us-ascii?Q?yHnpW+88aFV6WOU/us3YQROkbRbJmTul2ByLQHdreZHjgLhmp58p2i7pWGln?=
 =?us-ascii?Q?Gi4d1WL7SkdUZY2QL/94dVIuIYtXeq470S4dVZQValqVQ5iJyQCySIJogOVV?=
 =?us-ascii?Q?qT91cFd0awfZP1TFbDfTB5IPYHDeT/xRUcSd+nPVyjWfdg1tr+N03h37btvD?=
 =?us-ascii?Q?0vhn4XjYxSnmptM1MxBNFOdyx9fGaA22MldFdd3f9nvrqNcH7IkRPxikujuF?=
 =?us-ascii?Q?w6M163Ibhaps/Y04OdD3ETPqIbv7x2FCrvOze/KoNNsxxrEgvgggzsXpntE1?=
 =?us-ascii?Q?ozb8G3OzMBgxbN71onBfB5zm5PYsj9s/F7Qi4FSI8KREBuh6Ikva4lZ6b5Vs?=
 =?us-ascii?Q?ecw5aoGJ+Vjf3Jhe4zxPv4Ehk1zKxs+jugC8Sjv1xJWCapZrG9OjoccRGACI?=
 =?us-ascii?Q?7Qn4VAcwomv+zPQLq0NaYXINdeOj+UlB3tyaynZ6X86fDevcF2//g9rBl7RY?=
 =?us-ascii?Q?hWi6lDHk3SHRAVsYRXeoxd4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4045fd7d-5085-4f60-3e26-08d9bede58c6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:23.5390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8g48kT35FHR2awDZZpBX/x1hJ3IKg9NnpZuWMhZeh4Ve7SyUxgJX++DvO8A5vm1jeyBizv2bLwi1Fn5xqwUpXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: l4mjgOVwoDRX3q34vxmNjB8LmrZ3bhLZ
X-Proofpoint-GUID: l4mjgOVwoDRX3q34vxmNjB8LmrZ3bhLZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces new fields in the on-disk inode format to support
64-bit data fork extent counters and 32-bit attribute fork extent
counters. The new fields will be used only when an inode has
XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
data fork extent counters and 16-bit attribute fork extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h      | 22 +++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  | 10 ++++-
 fs/xfs/libxfs/xfs_log_format.h  | 22 +++++++--
 fs/xfs/xfs_inode_item.c         | 23 ++++++++--
 fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
 6 files changed, 176 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index eff86f6c4c99..2868cec1154d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -792,16 +792,30 @@ struct xfs_dinode {
 	__be32		di_nlink;	/* number of links to file */
 	__be16		di_projid_lo;	/* lower part of owner's project id */
 	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
-	__be16		di_flushiter;	/* incremented on flush */
+	union {
+		__be64	di_big_dextcnt;	/* NREXT64 data extents */
+		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
+		struct {
+			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
+			__be16	di_flushiter;	/* V2 inode incremented on flush */
+		};
+	};
 	xfs_timestamp_t	di_atime;	/* time last accessed */
 	xfs_timestamp_t	di_mtime;	/* time last modified */
 	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	union {
+		struct {
+			__be32	di_big_aextcnt; /* NREXT64 attr extents */
+			__be16	di_nrext64_pad; /* NREXT64 unused, zero */
+		} __packed;
+		struct {
+			__be32	di_nextents;	/* !NREXT64 data extents */
+			__be16	di_anextents;	/* !NREXT64 attr extents */
+		} __packed;
+	};
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 34f360a38603..fe21e9808f80 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -279,6 +279,25 @@ xfs_inode_to_disk_ts(
 	return ts;
 }
 
+static inline void
+xfs_inode_to_disk_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_big_dextcnt = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_big_aextcnt = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		/*
+		 * We might be upgrading the inode to use larger extent counters
+		 * than was previously used. Hence zero the unused field.
+		 */
+		to->di_nrext64_pad = cpu_to_be16(0);
+	} else {
+		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	}
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -296,7 +315,6 @@ xfs_inode_to_disk(
 	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
-	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
 	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
@@ -307,8 +325,6 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -323,11 +339,14 @@ xfs_inode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
-		to->di_flushiter = 0;
+		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
+
+	xfs_inode_to_disk_iext_counters(ip, to);
 }
 
 static xfs_failaddr_t
@@ -397,6 +416,24 @@ xfs_dinode_verify_forkoff(
 	return NULL;
 }
 
+static xfs_failaddr_t
+xfs_dinode_verify_nextents(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	if (xfs_dinode_has_nrext64(dip)) {
+		if (!xfs_has_nrext64(mp))
+			return __this_address;
+		if (dip->di_nrext64_pad != 0)
+			return __this_address;
+	} else {
+		if (dip->di_version == 3 && dip->di_big_dextcnt != 0)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -440,6 +477,10 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	fa = xfs_dinode_verify_nextents(mp, dip);
+	if (fa)
+		return fa;
+
 	nextents = xfs_dfork_data_extents(dip);
 	nextents += xfs_dfork_attr_extents(dip);
 	nblocks = be64_to_cpu(dip->di_nblocks);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 0cfc351648f9..fa5143fb889b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -156,14 +156,20 @@ static inline xfs_extnum_t
 xfs_dfork_data_extents(
 	struct xfs_dinode	*dip)
 {
-	return be32_to_cpu(dip->di_nextents);
+	if (xfs_dinode_has_nrext64(dip))
+		return be64_to_cpu(dip->di_big_dextcnt);
+	else
+		return be32_to_cpu(dip->di_nextents);
 }
 
 static inline xfs_extnum_t
 xfs_dfork_attr_extents(
 	struct xfs_dinode	*dip)
 {
-	return be16_to_cpu(dip->di_anextents);
+	if (xfs_dinode_has_nrext64(dip))
+		return be32_to_cpu(dip->di_big_aextcnt);
+	else
+		return be16_to_cpu(dip->di_anextents);
 }
 
 static inline xfs_extnum_t
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index fd66e70248f7..46aed637c98b 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -388,16 +388,30 @@ struct xfs_log_dinode {
 	uint32_t	di_nlink;	/* number of links to file */
 	uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	uint8_t		di_pad[6];	/* unused, zeroed space */
-	uint16_t	di_flushiter;	/* incremented on flush */
+	union {
+		uint64_t	di_big_dextcnt;	/* NREXT64 data extents */
+		uint8_t		di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
+		struct {
+			uint8_t	di_v2_pad[6];	/* V2 inode zeroed space */
+			uint16_t di_flushiter;	/* V2 inode incremented on flush */
+		};
+	};
 	xfs_log_timestamp_t di_atime;	/* time last accessed */
 	xfs_log_timestamp_t di_mtime;	/* time last modified */
 	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	uint32_t	di_nextents;	/* number of extents in data fork */
-	uint16_t	di_anextents;	/* number of extents in attribute fork*/
+	union {
+		struct {
+			uint32_t  di_big_aextcnt; /* NREXT64 attr extents */
+			uint16_t  di_nrext64_pad; /* NREXT64 unused, zero */
+		} __packed;
+		struct {
+			uint32_t  di_nextents;	  /* !NREXT64 data extents */
+			uint16_t  di_anextents;	  /* !NREXT64 attr extents */
+		} __packed;
+	};
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 90d8e591baf8..82f4b9bb871b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -358,6 +358,21 @@ xfs_copy_dm_fields_to_log_dinode(
 	}
 }
 
+static inline void
+xfs_inode_to_log_dinode_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_log_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_big_dextcnt = xfs_ifork_nextents(&ip->i_df);
+		to->di_big_aextcnt = xfs_ifork_nextents(ip->i_afp);
+		to->di_nrext64_pad = 0;
+	} else {
+		to->di_nextents = xfs_ifork_nextents(&ip->i_df);
+		to->di_anextents = xfs_ifork_nextents(ip->i_afp);
+	}
+}
+
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
@@ -373,7 +388,6 @@ xfs_inode_to_log_dinode(
 	to->di_projid_lo = ip->i_projid & 0xffff;
 	to->di_projid_hi = ip->i_projid >> 16;
 
-	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
 	to->di_atime = xfs_inode_to_log_dinode_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_log_dinode_ts(ip, inode->i_mtime);
@@ -385,8 +399,6 @@ xfs_inode_to_log_dinode(
 	to->di_size = ip->i_disk_size;
 	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = ip->i_extsize;
-	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
-	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = ip->i_diflags;
@@ -406,11 +418,14 @@ xfs_inode_to_log_dinode(
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
-		to->di_flushiter = 0;
+		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = ip->i_flushiter;
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
+
+	xfs_inode_to_log_dinode_iext_counters(ip, to);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 767a551816a0..7434ad4772dc 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -148,6 +148,22 @@ static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
 	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
 }
 
+static inline void
+xfs_log_dinode_to_disk_iext_counters(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to)
+{
+	if (xfs_log_dinode_has_nrext64(from)) {
+		to->di_big_dextcnt = cpu_to_be64(from->di_big_dextcnt);
+		to->di_big_aextcnt = cpu_to_be32(from->di_big_aextcnt);
+		to->di_nrext64_pad = cpu_to_be16(from->di_nrext64_pad);
+	} else {
+		to->di_nextents = cpu_to_be32(from->di_nextents);
+		to->di_anextents = cpu_to_be16(from->di_anextents);
+	}
+
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
@@ -164,7 +180,6 @@ xfs_log_dinode_to_disk(
 	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
 	to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
 	to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
@@ -173,8 +188,6 @@ xfs_log_dinode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -192,10 +205,13 @@ xfs_log_dinode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
-		to->di_flushiter = 0;
+		memcpy(to->di_v3_pad, from->di_v3_pad, sizeof(to->di_v3_pad));
 	} else {
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+		memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));
 	}
+
+	xfs_log_dinode_to_disk_iext_counters(from, to);
 }
 
 STATIC int
@@ -209,6 +225,8 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	struct xfs_dinode		*dip;
+	xfs_extnum_t                    nextents;
+	xfs_aextnum_t                   anextents;
 	int				len;
 	char				*src;
 	char				*dest;
@@ -348,21 +366,60 @@ xlog_recover_inode_commit_pass2(
 			goto out_release;
 		}
 	}
-	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
+
+	if (xfs_log_dinode_has_nrext64(ldip)) {
+		if (!xfs_has_nrext64(mp) || (ldip->di_nrext64_pad != 0)) {
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
+			xfs_alert(mp,
+				"%s: Bad inode log record, rec ptr "PTR_FMT", "
+				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
+				"ino %Ld, xfs_has_nrext64(mp) = %d, "
+				"ldip->di_nrext64_pad = %u",
+				__func__, item, dip, bp, in_f->ilf_ino,
+				xfs_has_nrext64(mp), ldip->di_nrext64_pad);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	} else {
+		if (ldip->di_version == 3 && ldip->di_big_dextcnt != 0) {
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
+			xfs_alert(mp,
+				"%s: Bad inode log record, rec ptr "PTR_FMT", "
+				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
+				"ino %Ld, ldip->di_big_dextcnt = %llu",
+				__func__, item, dip, bp, in_f->ilf_ino,
+				ldip->di_big_dextcnt);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
+
+	if (xfs_log_dinode_has_nrext64(ldip)) {
+		nextents = ldip->di_big_dextcnt;
+		anextents = ldip->di_big_aextcnt;
+	} else {
+		nextents = ldip->di_nextents;
+		anextents = ldip->di_anextents;
+	}
+
+	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
+	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
 			__func__, item, dip, bp, in_f->ilf_ino,
-			ldip->di_nextents + ldip->di_anextents,
-			ldip->di_nblocks);
+			nextents + anextents, ldip->di_nblocks);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
 	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(8)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
 		xfs_alert(mp,
@@ -374,7 +431,7 @@ xlog_recover_inode_commit_pass2(
 	}
 	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(9)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
 		xfs_alert(mp,
-- 
2.30.2

