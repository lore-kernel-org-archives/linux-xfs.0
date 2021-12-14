Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3D6C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhLNIt4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:56 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9310 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNItz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:55 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7BktL021573;
        Tue, 14 Dec 2021 08:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=G7cg3agS1vhSpQDUBPC4kL6j/7KbZ9eh2gITGYX+FjI=;
 b=z6Nmfg40gP6GKz2Ouxb0BW2bo37IEehwombRzA/+hfIZ4a75lcm5vR+cyKX5tLiwyl1z
 GlH8XMjAHo664o5GJmX3boM19DX00bfyG3buCRVSudLsvMMQzOr5XtVJVuAh6EgkqqrH
 11X1Utgftx0SZGoZgwHpb/XtQHPesJrA56SbCH7S+3YiQ5mOMa4Hd2zg74R08OSsP0Ea
 KZxJj196v8A12qBZ07EAySy99960xO3qYyVWs/ojL4i8s6OdFnqZIRnURQNaokt3i10K
 UeyufoMbhbJYjKgcZ8QL8ukmN1lFS/w6sNHISpJXwC9Zqm9pXbgW9/ddbrrZuucW+mjb Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3ukb2y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fnjE104426;
        Tue, 14 Dec 2021 08:49:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3cvj1djsx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnEs8BTjqKxRLqvEfiQ/515QEEhcpu7ZgoP3AGdh1QQIAx6NC9oJ3TXPSM5OO6VwxvihiOokwLTO8dKkxVtR7CAFNDGGr2lU49DeQfu0s9XbDur0yo1lwEHZO9/ABJmSZ2YcSbysGAOzSzYVffO6eMkM3bAwKGScHk6AvF+BKPoeMeHmXWTkuvqa8FfsG6nJIvQvJa2Y8wUWa+vKpBq/86VCCOptnk14CUY48Oo+WOO08uvHOTXY64qz/QiGpYcyQCRN9GFHdjhR8bYeRlIhEa3/dXZ/ewpBhX2nmtWfWbv+aDSJbTgsdl3DFxXK4fog3Wz/CYJD2gjhz0W1LNekCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7cg3agS1vhSpQDUBPC4kL6j/7KbZ9eh2gITGYX+FjI=;
 b=YUGXxrkzvDSSn5v1HrUVC4Vpx3qvYFkYy+TLus9dLI+rvX8HKjjMMrFrjNxGOrmlBsDTZLpguobSGD0hYV6aturwRidxG+op17R6h8nslLHCH682MKTsTDMPWfwDCjzhv2h6hL1t1AT5bTPaOpJApTE3jZgmON+doXz08XgXlu7dL5Z7+2gkmZhDJV5IdjO4cJ2NnQ7ekvGJlcP7vEM5CoAGtP63YZ2Uf2Gny6V0FoDgjhjVSJ7MkCm/f8PLFT+Vn3+lCOwyBoJ2XyPtVJimIMVhFD63ThL2ARxCDT06hpPB8MsfJzl4aKjHJ41Hxh8rEsZhXhaSfGKCkdSdjq7/+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7cg3agS1vhSpQDUBPC4kL6j/7KbZ9eh2gITGYX+FjI=;
 b=u+Vo5PAZOIN3f+GHRoQD91MaT8t2hdaOUZRux3OfBzpK84ez7GAe6dZLEQa1Oa5+Ug8bj1ENnDStcBZLkoZF/hjCGzbWz3g+wfnCd11RCg+cOePiKu/cZg6rXBQOCG1lsi6k4JZaMXWxAXlH9k4SgtcpXDCf40MYn5ACRv1zaGY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:50 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 07/20] xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Tue, 14 Dec 2021 14:17:58 +0530
Message-Id: <20211214084811.764481-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20a0dbfe-7daa-4fac-48f1-08d9bedeb059
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB26568751A4BE5533258C70B9F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:26;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNlCtC261J6B9ke5kTPQJZxsUdlXUH5rfyrjdO7Qdnm/lnRYiXas/lWOcwKkwBSui9jkXmEycHcF94EF8+7lJ8vcQep5AMVteZ6JwMposvzQDhMYDNiRgjoKf01P8NLjhwyCREkuqlWOZHN1U6jBuUrt75iI7Btx4crf3PaFNyqYy0yxNwIPC/ZyQ0M5TN6zDeoCHMUHcyh+5VWGo96jgNUb8fvSL0DkgUqny7ww4FHPyRMSN3OZsamZfzDkb+qnJBRmFBLBlV/ZQZ3Cr7tzqxWbeEH+liB+r7BKtbkw+UsLvHwfaXwoMRikRObL7XWr0wvuxMFmrMbfAr345oFhG3jY3UsUSoB99uXDd/F+WcbZPCsgleqqs8311IOyM3PMphhB3RJr6E3d8Gq7kjPfROW9teNsw9i4LGHctj/mtN4u2oSNu+aoN/xckQNm40HUNIDrpN5yF5RpNGL+q2n3Y1diUkPqT5puUxmwp2ufY9z3LKrfzfRbvd2I846iXKMjcxjcQOkTqpwQpCuj2RyEQ0gG7rRfh4TdHQAHBhelXua1q/0VUF5Fhzr9BqQu/8gYRPL7iMMBpuEDUTfNT78RfF8SRsnRFGDmfEBHpMVpo6sW7t0iF8/8LD+tejgso8AcL2JbOtOymmT71VIJ52JlKNJ0yzbD+SyG2DIGAp9qc83/OhH9VsFoY5xcndrUZw07TB046kFQ7KhrTFz9v6lzhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0MLtd2sgAWNFLJmmAClpvY5EGedPiCbNHhdwRI3fq6nenlnde1AySK8luAW6?=
 =?us-ascii?Q?2u09hfY+yq4dpgme/h8gnCFRW5DVHttsHupvBl3SeE1iCxdJu2kHy5RqBwFt?=
 =?us-ascii?Q?HYQtvgpiCI24F5GIOQYZO5Bzyr8QZx2ors/XfoyF0JBQaGZ+ej+A84z9I3Bm?=
 =?us-ascii?Q?ykR2np+Z0Om3O7DBw6FNfQTg+PFJzbS00HXVluGnVCmiPnzLblIxpyxxwOeB?=
 =?us-ascii?Q?e65cyEi9Y6UvQSbK234MhREFsGQVyJx2fUJFR54LfH4uxwGHThhVA5h+fYvY?=
 =?us-ascii?Q?PZHAg/wd5PPLZe9JhsGsMgefcRiYqivHgoKflh7E7keKHcqTfgE8NVs5G93T?=
 =?us-ascii?Q?nX1JqgioeONb6dNpnfQQ8GE4CAqkRgLMSdkXMrfgAZ/s/JGQn1BdfWSl99T9?=
 =?us-ascii?Q?WYc2XqEn/T3DzOlgl+fYjYRaxe7c5bVOTuP/97LLPiVFxEwu0tP6IjPIwY1l?=
 =?us-ascii?Q?ygfZC3Ps1rulMgGWpAz6BI9CAJFBcbNvcwl3+yh4dOOeBKfMQdt9nXrZZh5Y?=
 =?us-ascii?Q?u2hyIm9TqWt3QRpgJufQjEbAytZ9kKIXHoNH9inwAoWOVObiZyTNyqT8g3iz?=
 =?us-ascii?Q?5+E7J4oAS8hE0GCVPqjalNGujF0Uh7j15FhTTJ8QC1W7M0OcYMvvSyXnDy3+?=
 =?us-ascii?Q?meIsjGOmb5ZmX6M3h7wx8GxQB+TbeLMnck8hnQxS/G2EWpFtltlQzZ+1xYTu?=
 =?us-ascii?Q?dRUGLdzJvuz+RpR8IqqCVqbbkuxIBpL7GCJkbkpq5nAIfMjDLaIxLVgSO7JM?=
 =?us-ascii?Q?Xx+FRgEsH0kPa41FckPkdXLe4AwDEWFf/Ituuo5baYn84H8M/idHg7T8xJZB?=
 =?us-ascii?Q?1GzZdS+QiKdaRSGxKCl5SiyGHSTN7NvxyARx2kQZTt70HXwUgfnMqkXbhKT3?=
 =?us-ascii?Q?NHL1oW/6cJRt6MMXxltWtBK9MWb1jYqlkgrVFxn1KL2rQhQvgj0FipBKhzPO?=
 =?us-ascii?Q?TerFsKf2722qIfVDzM/kAlUevTsKVBKLH5Z2RMaht7uHQ/W53FJBHeHQezwm?=
 =?us-ascii?Q?ZMYJFTLTVFWIU6PNFP0js7iElQURVWHyvKfofkm5gdBT+JSWlGkcAConKQCT?=
 =?us-ascii?Q?6qMDZa5ODAVcn4zPBz2ePHqNuL4qNbbxbobDf1OWFve06O7SIj9If8rSadWM?=
 =?us-ascii?Q?xctN0jFHrMWEiawiNx1EMWc57pWJyWsfcL229FeEQCO1xmH2Lr/Z3LChsInM?=
 =?us-ascii?Q?RnDQbUkk/L1HPTtzla7V0z8twzTlOtjgcwa9wuhPpsKmeJce/r5vMW/ERB11?=
 =?us-ascii?Q?jtpQOKUtSMxevSNzpq21DSKCzxuafF3tUixdd0DR3Y+zJ2PMYn+IgCNlii0R?=
 =?us-ascii?Q?U6NsYAzf+z/yLMcFAjganBIhCwUdHmkzptlzgPoGwt05umT2bQg//oghudP5?=
 =?us-ascii?Q?8M1dI3aXPEEYPz8V0MhdLMzDlAY92ywMoyNhYbuKyOvVxyazvaxeNl3lblVy?=
 =?us-ascii?Q?7g933q6v2oMcuYNt2weXXgMZr+bE1cbSN2K9RzNiKpG41DzcoAE/IbeEm+sq?=
 =?us-ascii?Q?RJJQl5PA+w7WGXUbBwIFVxdc9suMbpi6C1iIbTsN2sN/eSIKduwfHKe+n/Hl?=
 =?us-ascii?Q?dt5xFQKV90m8PUYU4giYjXnrbdQYPKe+P7RwuTGLS/kv5QC3ZQv6DVTtUIaR?=
 =?us-ascii?Q?ZyNkuPVtFe/GozmxDd1daYU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a0dbfe-7daa-4fac-48f1-08d9bedeb059
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:50.3779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ue/xa5SH9R0oegLoJ059DmIk7lWWlztX0babRQNYvH1zSJQYeL5PlVywCpOJvMqiUiykmN0A46szTdxKgcdxRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-GUID: JfLH6e25AIT0hQQ74DHCnJwWP0Di0E3V
X-Proofpoint-ORIG-GUID: JfLH6e25AIT0hQQ74DHCnJwWP0Di0E3V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       |  4 ++--
 libxfs/xfs_inode_fork.c |  2 +-
 libxfs/xfs_inode_fork.h |  2 +-
 libxfs/xfs_types.h      |  4 ++--
 repair/dinode.c         | 20 ++++++++++----------
 repair/dinode.h         |  4 ++--
 repair/scan.c           |  6 +++---
 7 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 46e4c1d4..04466348 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -46,9 +46,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -460,7 +460,7 @@ error0:
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 42a7e4e9..627eb23b 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -115,7 +115,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 494942ad..b34b5c44 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -21,9 +21,9 @@ struct xfs_ifork {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
 /*
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 7ff162b1..89ab3f48 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 735ba066..8b6cd60d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -342,7 +342,7 @@ static int
 process_bmbt_reclist_int(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -645,7 +645,7 @@ int
 process_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -666,7 +666,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -1045,7 +1045,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	 */
 	if (numrecs > max_symlink_blocks)  {
 		do_warn(
-_("bad number of extents (%d) in symlink %" PRIu64 " data fork\n"),
+_("bad number of extents (%lu) in symlink %" PRIu64 " data fork\n"),
 			numrecs, lino);
 		return(1);
 	}
@@ -1603,7 +1603,7 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 		nextents = xfs_dfork_data_extents(dinoc);
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime summary inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1626,7 +1626,7 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 		nextents = xfs_dfork_data_extents(dinoc);
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime bitmap inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1815,13 +1815,13 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
 			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad nextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, nextents);
 		}
 	}
@@ -1837,13 +1837,13 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
 			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad anextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, anextents);
 		}
 	}
diff --git a/repair/dinode.h b/repair/dinode.h
index 1bd0e0b7..3aec7bc1 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -20,7 +20,7 @@ convert_extent(
 int
 process_bmbt_reclist(xfs_mount_t	*mp,
 		xfs_bmbt_rec_t		*rp,
-		int			*numrecs,
+		xfs_extnum_t		*numrecs,
 		int			type,
 		xfs_ino_t		ino,
 		xfs_rfsblock_t		*tot,
@@ -33,7 +33,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
diff --git a/repair/scan.c b/repair/scan.c
index 4488e084..6b6c0519 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -220,7 +220,7 @@ scan_bmapbt(
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
 	char			*forkname = get_forkname(whichfork);
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
@@ -425,7 +425,7 @@ _("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
 		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[0])) {
 				do_warn(
-_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%lu, min - %u, max - %u)\n"),
 					ino, numrecs, mp->m_bmap_dmnr[0],
 					mp->m_bmap_dmxr[0]);
 			return(1);
@@ -476,7 +476,7 @@ _("out-of-order bmap key (file offset) in inode %" PRIu64 ", %s fork, fsbno %" P
 	if (numrecs > mp->m_bmap_dmxr[1] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[1])) {
 		do_warn(
-_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%lu, min - %u, max - %u)\n"),
 			ino, numrecs, mp->m_bmap_dmnr[1], mp->m_bmap_dmxr[1]);
 		return(1);
 	}
-- 
2.30.2

