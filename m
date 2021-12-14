Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D504C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhLNItx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:53 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5942 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhLNItw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:52 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7KL6V022072;
        Tue, 14 Dec 2021 08:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Up0VV4bBM8FVS+3NhVtTyY7xtGOXYmSOzKWlsQo/NyU=;
 b=iVuymFAL0ziatIqmJN9dX1RQhtd5gJDGjOGgkungTyKZb5GtuvYZbcFQuucJpDUYYjcc
 MZF/UN5Lz0aLsjt5NjuuNaafPGbzum06n91IP7eavqmPcbmO3CtwG/Bx+yoqZP928qbw
 cyHhbE/Ajt8GbZNWPtJzrJjCy5Nw8HFbJg2/ZSwRtBhNOkINFOg3n/4stiP5041n8Fby
 R9UH2vW7AeMLCz0ipLVMDvwLRl9BqGxchL5oGZB8E9px+Hnih7KIuRSPNMUzPYFWrqm0
 +OJbaraj8Tk8j2txGfily/c4htejit/MSx0htKsfnytQnyGdelUkCu087V1B818vNUt4 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfb6jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fXKf156420;
        Tue, 14 Dec 2021 08:49:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3030.oracle.com with ESMTP id 3cvh3wy7kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUdmhU1mvDv2UPqj4vAUoyw9+7KoQPJ6hnY4rBkkhF9bsxetkO6vOrCTY9VEyGh57pjXRtGsmsxKCIb4Mlobumuh7XqdydsPg4TTo2LQZdWqQxM1n6NbK7FztAK9mJf5irTp0oT3I+rejAe1+3t8OwnemtaP0vfvKhLKrd3MM5Cng311swsJeZR6+UAyeYMygNNsqz07TTzIY9UeHvHW5LpwRfokJedQ3OhcjtTV9ugiT/SWqzvNLu7Izb6+ZshN+A5jEOSDQ8OkwGRs1qr0CidUAvzfoR4xhjk6yywbU0t72tNQxWO4VNlZup1bo93eGUqiDu1HZqR7fzEXlQyvRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Up0VV4bBM8FVS+3NhVtTyY7xtGOXYmSOzKWlsQo/NyU=;
 b=fqfeyH6IKbRVRds7FLNUVBJfFmn2BxDu/UXqRPafcZln4xSERhWzkwNSeDvstA/t/U/esYUdFNUGREcT8jU4C6RAe0ULiJQ679oh2f2ITx8uhyovHNV+XMdp3jaZxqmhVc1vQ0V1jVpZAdAqFbqmZqYSWOjPQLBVLyPGRI8OQQVbWoCd01VNyELTk3yVUo6jc9eFVKeJv1glKS48S7pQwaSdX+AC6btrMGo5LX2Uo/sAmQQQKMDGMt2Ad6w5KVx39YA29KjcvhNb4M9nhoa9jmfKCkBfr+ddRlBqhI8l/Iru0VvB953QVCmcAicHJWx/L95JEGpWWB8ALVbCbpleNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Up0VV4bBM8FVS+3NhVtTyY7xtGOXYmSOzKWlsQo/NyU=;
 b=ULRoLbJpvrVj203OgdobFzFnSHiAlcQRR1Qyfio+8DS6Ix7aqMDde9VegGLK2eJqgT+CiyrJkCOv/VcsqmQbdmHc/l86Rc7u5GLfHaUdBPsy8lDAtg3OWKJPD2pr6F2bz1tKWn221+V3G/YP9UTgf/aE7Gho1pb3xXN3GQEiE50=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:45 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:45 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 05/20] xfsprogs: Introduce xfs_dfork_nextents() helper
Date:   Tue, 14 Dec 2021 14:17:56 +0530
Message-Id: <20211214084811.764481-6-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d7901b28-7093-4deb-5f79-08d9bedead8c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656A36C042DCF99F41572DFF6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NA8vp7d/tdCwCUNpLJ/9++/6viMGI/Orfue23GU5FH3owtakSXnbQDSBUKSknAs9LY2mbZxv+3gDDd2yEcMvJ3N+sukITb9S+KsDtEQZF7IHuuiLiXrdlbDLAMFJMEeax+OCf2j3S7L5WleeTI8SfvBcCLuswc1AcdDVXoez3z/v0TKslqYLTKZmBY1CMAHhCvcBniGXfbrLr6gqyHgbiXg60OrkEj19qXpavJZBOhQxB2Av9gpuZ4PWX6SRoOeJlLlEMKgBDqgaIGuftPhiLoyEchsiOwzbfz0MGYjHanTQu6IghsSm4zXhBE7UvcgnhXjbV0lrlNFjw71PubxF3gCvn7nxCGdzoCgq0KoTXEfNLxSJqhR2/4ylDtooeonUbrnob1tn7wBT4E9ashPdEHwSJXGKu5l+j8S77JQYi2GEiSUR1sENNqeXeiVBBew/b2ZMorf8L5O5tUg3Kga9uiNZy++yQQEUcNklYRTyf/5pCK1mubmHvAjM4ajYOjiDabtlo4syNwnKOsk8tDexr2WPmSAYvnAgzS5ARqkcuENf9TLZpq8VR0hftQdtEGQmFi3F5NnmhsppBpeavf8PFA6qKii6Cygb28n5HedC7R+4CuysHlM8o91tx/SC3Oa5+/90NdLj4Ofkk4dB40YPELDxnIvtrFKT6k8WxJd5So4fOk5NlFx7C90jhWl5I/HX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(30864003)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mUbzcju+4YcCQhpjN8l8UIRbmpwhHc/DoZcIyGluh/FT4sQ9TNylmUSsdznt?=
 =?us-ascii?Q?np8OpwZFySMCP5HMx729Zfi898IQCztjcFAUTpSo5jIwhureeiBMHA0F+EFC?=
 =?us-ascii?Q?kaOun69EfM5zj2n+2yPAVthil5FeNQZKutzNxeS27hUb7AuvcLD6wn+KGgHB?=
 =?us-ascii?Q?UlbodFQzq01IAT09Ju2h4lbsZYul0Qpy+oRLThSf6fmy2PvufeFEfLhP2M/e?=
 =?us-ascii?Q?WbGtCb+/Egyw3L3IxcTXTVfBKSM9h6HG4lakxLVa+m/twstMO9Hz59GCOGAY?=
 =?us-ascii?Q?7LXEvpG8dlv0afuEOfqSS3ICXc9eTpVfWYbl7+LevrIvDRJqQ+CQo4wzRB8K?=
 =?us-ascii?Q?9csqs0JWt7cj1Kg4WFSexEn7sFs78UJ0heMVOcSz6AupHugPND7OMN8ecDSv?=
 =?us-ascii?Q?ZmJTj2GTKk9Z8b9zhIAr7cCg8GwIa65K1yIV3VeWdylatpBngrw1vJK9SAZr?=
 =?us-ascii?Q?Oty+sEW/BHLOLtqXC8jDHWcYfXgQrbTxF6U8VRLtLLbCr47zldDBgQxDbkTD?=
 =?us-ascii?Q?7QtaTMXdo83V7pPItr5LPG0P3NVlfaFJNAnjn9/zaSDg1bv0+tNI5JSBordc?=
 =?us-ascii?Q?AAi2OG8VacJvZJB7dXfQ1QTr+oDCW2iyPrcP3D6cF9XenVZR0d3mptLzdI7w?=
 =?us-ascii?Q?5U8DUNv2IkamOgpQFEBAfrfKAglpeXMibt8Wo2j+P/Q1/BN6AIPe7RcOxxWx?=
 =?us-ascii?Q?nsDj2YGbHZVvuha5v9IRvLmboIjnUh9n3iFPfuJLj5+Yn9xkZCAa1i60FT/e?=
 =?us-ascii?Q?svBshwCAuRK+RMkKwoRacPTyvHGzkLyLFEctSdL6vVUr+V4hcUuNrfGRmrXC?=
 =?us-ascii?Q?yDl63bq070Bpgk9Nn+2ryk8P8cUAAtXiGH4yZTOxGmLN8S0g7Ezi6OD/LRt/?=
 =?us-ascii?Q?yQh3gstPIjiy4AaPon+QBPiOyc4MvTJXRC7+p3QuFH9F1GODJwgQhX7alJaU?=
 =?us-ascii?Q?K7hyrZ+vug6GNwinxy7yUiQKM8O+ljmo4Ciq9yju1XP5B3SKum9kWIa60luO?=
 =?us-ascii?Q?mjnXqSF+FRqluqou8xVGS7jKYlkt2OFiWQs2QJmolXUcJN4rcsWRX66N5vQP?=
 =?us-ascii?Q?uiimJgm+d86cZ3k147VCBJR2TAdENy06c/nWiYF9tbQFypXx0H/isXo2t5/c?=
 =?us-ascii?Q?m6Ip2jFLWq9aVz2HG5955MjL74zcLbdENkcCsJvjZghWgR7Je5VYC4h09GxV?=
 =?us-ascii?Q?j/OZhz9qRtM7z8ZvzByhSevltvsqMea5wy/zRhRihuHY/Mhh4KRjqFOTRDZF?=
 =?us-ascii?Q?RodcGEtwUILpnMopYn0ZKEa7heSmXZnJ2WApYJmwI6rPwyYBO+p26k3krb+J?=
 =?us-ascii?Q?fvOndTBwQoON81zDyEommhyDQDx0R0w0WPOdaR+jLo4rGeoXMaM4NbbmN9UI?=
 =?us-ascii?Q?NtapiMzWLAoOdcAsJ/9Hwg2gy9k+T6cpEqVVtASGvIwHpf4DBemHmZtupGH/?=
 =?us-ascii?Q?e2RhGQ3+UZttuy8gcU8zN2Q7mYbgEL2Y2926ktpBV1O62yHyL/lYn8rce+xe?=
 =?us-ascii?Q?zPEAXVS7OvxJqsp97fPD7ftRW7Au/s7UQ/9OGiybScjnxwcG0r6kIxp/DDdn?=
 =?us-ascii?Q?xW9DQjYLyIHr8OaMxP4zEr6sw6PINisGFIaV+sM4qS7NTI8iLZMdk2zKDh8K?=
 =?us-ascii?Q?FibMH19on3TLxqxpbiIrJ8s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7901b28-7093-4deb-5f79-08d9bedead8c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:45.8766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FTtoktdVka/rftFE1KpCW0bNlwWQ7QBVADNctRqhme7671iCd/GdlsVmhPuuNnnPgYwcyKDXcRmF6X5aqWUBsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: SwPtDbAGQxB0rMqBOBvWHKQ0c7rc3vaZ
X-Proofpoint-GUID: SwPtDbAGQxB0rMqBOBvWHKQ0c7rc3vaZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               |  6 ++---
 db/btdump.c             |  4 ++--
 db/check.c              | 28 +++++++++++++---------
 db/frag.c               |  6 +++--
 db/inode.c              | 14 ++++++-----
 db/metadump.c           |  4 ++--
 libxfs/xfs_format.h     |  4 ----
 libxfs/xfs_inode_buf.c  | 16 +++++++++----
 libxfs/xfs_inode_fork.c |  9 +++----
 libxfs/xfs_inode_fork.h | 32 +++++++++++++++++++++++++
 repair/attr_repair.c    |  2 +-
 repair/dinode.c         | 53 +++++++++++++++++++++++------------------
 repair/prefetch.c       |  2 +-
 13 files changed, 116 insertions(+), 64 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 7925a197..6b0246d9 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -68,7 +68,7 @@ bmap(
 	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
 		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
-		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+		nextents = xfs_dfork_nextents(dip, whichfork);
 		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
@@ -158,9 +158,9 @@ bmap_f(
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (be32_to_cpu(dip->di_nextents))
+		if (xfs_dfork_data_extents(dip))
 			dfork = 1;
-		if (be16_to_cpu(dip->di_anextents))
+		if (xfs_dfork_attr_extents(dip))
 			afork = 1;
 		pop_cur();
 	}
diff --git a/db/btdump.c b/db/btdump.c
index 920f595b..6d0041b0 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -166,13 +166,13 @@ dump_inode(
 
 	dip = iocur_top->data;
 	if (attrfork) {
-		if (!dip->di_anextents ||
+		if (!xfs_dfork_attr_extents(dip) ||
 		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("attr fork not in btree format\n"));
 			return 0;
 		}
 	} else {
-		if (!dip->di_nextents ||
+		if (!xfs_dfork_data_extents(dip) ||
 		    dip->di_format != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("data fork not in btree format\n"));
 			return 0;
diff --git a/db/check.c b/db/check.c
index 485e855e..c164fef9 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2713,7 +2713,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	*nex = xfs_dfork_nextents(dip, whichfork);
 	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
@@ -2737,12 +2737,14 @@ process_inode(
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
+	xfs_extnum_t		dnextents;
 	int			security;
 	xfs_rfsblock_t		totblocks;
 	xfs_rfsblock_t		totdblocks = 0;
 	xfs_rfsblock_t		totiblocks = 0;
 	dbm_t			type;
 	xfs_extnum_t		anextents = 0;
+	xfs_extnum_t		danextents;
 	xfs_rfsblock_t		atotdblocks = 0;
 	xfs_rfsblock_t		atotiblocks = 0;
 	xfs_qcnt_t		bc = 0;
@@ -2871,14 +2873,17 @@ process_inode(
 		error++;
 		return;
 	}
+
+	dnextents = xfs_dfork_data_extents(dip);
+	danextents = xfs_dfork_attr_extents(dip);
+
 	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
 			id->ino, mode, fmtnames[(int)dip->di_format],
 			fmtnames[(int)dip->di_aformat],
-			be32_to_cpu(dip->di_nextents),
-			be16_to_cpu(dip->di_anextents),
+			dnextents, danextents,
 			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
 			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
 			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
@@ -2893,25 +2898,26 @@ process_inode(
 		type = DBM_DIR;
 		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			break;
-		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+
+		blkmap = blkmap_alloc(dnextents);
 		break;
 	case S_IFREG:
 		if (diflags & XFS_DIFLAG_REALTIME)
 			type = DBM_RTDATA;
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		}
 		else
@@ -2993,17 +2999,17 @@ process_inode(
 				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
 		error++;
 	}
-	if (nextents != be32_to_cpu(dip->di_nextents)) {
+	if (nextents != dnextents) {
 		if (v)
 			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
-				be32_to_cpu(dip->di_nextents), id->ino, nextents);
+				dnextents, id->ino, nextents);
 		error++;
 	}
-	if (anextents != be16_to_cpu(dip->di_anextents)) {
+	if (anextents != danextents) {
 		if (v)
 			dbprintf(_("bad anextents %d for inode %lld, counted "
 				 "%d\n"),
-				be16_to_cpu(dip->di_anextents), id->ino, anextents);
+				danextents, id->ino, anextents);
 		error++;
 	}
 	if (type == DBM_DIR)
diff --git a/db/frag.c b/db/frag.c
index ee058aad..52ff0d8f 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -262,9 +262,11 @@ process_exinode(
 	int			whichfork)
 {
 	xfs_bmbt_rec_t		*rp;
+	xfs_extnum_t		nextents;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
+	nextents = xfs_dfork_nextents(dip, whichfork);
+	process_bmbt_reclist(rp, nextents, extmapp);
 }
 
 static void
@@ -275,7 +277,7 @@ process_fork(
 	extmap_t	*extmap;
 	xfs_extnum_t	nex;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	if (!nex)
 		return;
 	extmap = extmap_alloc(nex);
diff --git a/db/inode.c b/db/inode.c
index 3453c089..9afa6426 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -275,7 +275,7 @@ inode_a_bmx_count(
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		be16_to_cpu(dip->di_anextents) : 0;
+		xfs_dfork_attr_extents(dip) : 0;
 }
 
 static int
@@ -329,6 +329,7 @@ inode_a_size(
 {
 	struct xfs_attr_shortform	*asf;
 	xfs_dinode_t			*dip;
+	xfs_extnum_t			nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -338,8 +339,8 @@ inode_a_size(
 		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be16_to_cpu(dip->di_anextents) *
-							bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_attr_extents(dip);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
 	default:
@@ -500,7 +501,7 @@ inode_u_bmx_count(
 	dip = obj;
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
-		be32_to_cpu(dip->di_nextents) : 0;
+		xfs_dfork_data_extents(dip) : 0;
 }
 
 static int
@@ -586,6 +587,7 @@ inode_u_size(
 	int		idx)
 {
 	xfs_dinode_t	*dip;
+	xfs_extnum_t	nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -596,8 +598,8 @@ inode_u_size(
 	case XFS_DINODE_FMT_LOCAL:
 		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be32_to_cpu(dip->di_nextents) *
-						bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_data_extents(dip);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
 	case XFS_DINODE_FMT_UUID:
diff --git a/db/metadump.c b/db/metadump.c
index 09d990dc..8a9aec75 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2282,7 +2282,7 @@ process_exinode(
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (show_warnings)
@@ -2335,7 +2335,7 @@ static int
 process_dev_inode(
 	xfs_dinode_t		*dip)
 {
-	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+	if (xfs_dfork_data_extents(dip)) {
 		if (show_warnings)
 			print_warning("inode %llu has unexpected extents",
 				      (unsigned long long)cur_ino);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 1e31c31c..68f42fca 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1107,10 +1107,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 2ba84dac..06b6c09f 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -333,9 +333,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -402,6 +404,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_rfsblock_t		nblocks;
+	xfs_extnum_t            nextents;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -432,10 +436,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	nextents += xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -492,7 +498,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_attr_extents(dip))
 			return __this_address;
 	}
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 12656c74..42a7e4e9 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -103,7 +103,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -228,7 +228,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -293,14 +293,15 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	naextents = xfs_dfork_attr_extents(dip);
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 370246ee..494942ad 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -141,6 +141,38 @@ static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
 	return MAXAEXTNUM;
 }
 
+static inline xfs_extnum_t
+xfs_dfork_data_extents(
+	struct xfs_dinode	*dip)
+{
+	return be32_to_cpu(dip->di_nextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_attr_extents(
+	struct xfs_dinode	*dip)
+{
+	return be16_to_cpu(dip->di_anextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return xfs_dfork_data_extents(dip);
+	case XFS_ATTR_FORK:
+		return xfs_dfork_attr_extents(dip);
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return 0;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index bc3c2bef..618f4f1e 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1083,7 +1083,7 @@ process_longform_attr(
 	bno = blkmap_get(blkmap, 0);
 	if (bno == NULLFSBLOCK) {
 		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
-				be16_to_cpu(dip->di_anextents) == 0)
+			xfs_dfork_attr_extents(dip) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(
 	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
diff --git a/repair/dinode.c b/repair/dinode.c
index 4d125db4..735ba066 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -68,7 +68,7 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
 		fprintf(stderr,
 _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
-	if (be16_to_cpu(dino->di_anextents) != 0)  {
+	if (xfs_dfork_attr_extents(dino) != 0) {
 		if (no_modify)
 			return(1);
 		dino->di_anextents = cpu_to_be16(0);
@@ -938,7 +938,7 @@ process_exinode(
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*tot = 0;
-	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
+	numrecs = xfs_dfork_nextents(dip, whichfork);
 
 	/*
 	 * We've already decided on the maximum number of extents on the inode,
@@ -1015,7 +1015,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
 	xfs_fileoff_t		expected_offset;
 	xfs_bmbt_rec_t		*rp;
 	xfs_bmbt_irec_t		irec;
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	int			i;
 	int			max_blocks;
 
@@ -1037,7 +1037,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	}
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = be32_to_cpu(dino->di_nextents);
+	numrecs = xfs_dfork_data_extents(dino);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1543,6 +1543,8 @@ process_check_sb_inodes(
 	int		*type,
 	int		*dirty)
 {
+	xfs_extnum_t	nextents;
+
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
@@ -1597,10 +1599,12 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_data_extents(dinoc);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1618,10 +1622,12 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_data_extents(dinoc);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1780,6 +1786,8 @@ process_inode_blocks_and_extents(
 	xfs_ino_t	lino,
 	int		*dirty)
 {
+	xfs_extnum_t		dnextents;
+
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(
@@ -1802,20 +1810,19 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
 		return 1;
 	}
-	if (nextents != be32_to_cpu(dino->di_nextents))  {
+
+	dnextents = xfs_dfork_data_extents(dino);
+	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be32_to_cpu(dino->di_nextents),
-				nextents);
+				lino, dnextents, nextents);
 			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be32_to_cpu(dino->di_nextents),
-				lino, nextents);
+				dnextents, lino, nextents);
 		}
 	}
 
@@ -1825,19 +1832,19 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
 		return 1;
 	}
-	if (anextents != be16_to_cpu(dino->di_anextents))  {
+
+	dnextents = xfs_dfork_attr_extents(dino);
+	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be16_to_cpu(dino->di_anextents), anextents);
+				lino, dnextents, anextents);
 			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be16_to_cpu(dino->di_anextents),
-				lino, anextents);
+				dnextents, lino, anextents);
 		}
 	}
 
@@ -1879,7 +1886,7 @@ process_inode_data_fork(
 	 * uses negative values in memory. hence if we see negative numbers
 	 * here, trash it!
 	 */
-	nex = be32_to_cpu(dino->di_nextents);
+	nex = xfs_dfork_data_extents(dino);
 	if (nex < 0)
 		*nextents = 1;
 	else
@@ -2000,7 +2007,7 @@ process_inode_attr_fork(
 		return 0;
 	}
 
-	*anextents = be16_to_cpu(dino->di_anextents);
+	*anextents = xfs_dfork_attr_extents(dino);
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 22a0c0c9..fa6a3893 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -393,7 +393,7 @@ pf_read_exinode(
 	xfs_dinode_t		*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			be32_to_cpu(dino->di_nextents));
+			xfs_dfork_data_extents(dino));
 }
 
 static void
-- 
2.30.2

