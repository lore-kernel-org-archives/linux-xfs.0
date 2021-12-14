Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105F0C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhLNItt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1270 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:48 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7H6TF022081;
        Tue, 14 Dec 2021 08:49:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=18I5opLXPb/wf03Gd9SCf8SrzsnaJjy7W6UtWYEZBbo=;
 b=ikMkry0x+hxtg44X44TGxFazo91sI53xOgdihFDR6/kD2JZ2vQQybnvQ4rUld6bDRud6
 BSWJEAN6NxGHABpF1aOHv4IhfRB6nGVlytT7X6kzG97bZqTA/d2GFekgHLUayM/uCAOR
 V+CcbUrwR3NJp96I75r10LDf/hfzfDnWP7G98bOnJsF4st3N51XMAsBmUDNEJf3hxcq/
 GUrea2WcMvvTlwzi8G3AyarTozlFNqqVLA5L0g8cr1+J1uyGAb1E4Cn7N1o8dvrXlW3c
 yh7FwI7DHkd2YTc0ZvwxSK5OniSkklE403d0cfkmBIVpa4ZX4baDM8koWP+YX2z18rZU qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfb6je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8f5D3107700;
        Tue, 14 Dec 2021 08:49:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3cvnepm598-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvKFS80PWIQ4j3PCqJyYvvkd4+4V+RjlGrjr/SOqImZ1uR0AtAvMrj48SUtrc4dDACsWGZHgLpUj+V3EXDXRfguYTr71p9jb8HU3edU3AauiaqSEgLGSQUcV2Z8cLLeRqYhe57b9DHA9Oldrr/UniB/UiOPTRJCSmlvPlTZpM6isRHn20ZypAPAI8hBXtnNyc1fTrM66LZs8StNbor4m8JPVhdZx5FRqArddgcvbxs0U9Bi2dXYluKJrWjtJrQsiF+esS/LiBHHDgVFWqnNDfMNINih8BrivVIvrfiBo39SG59XejbSgP0tbcHLZQx5EE9LwAJYb1+qJ7AUWpx9OPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18I5opLXPb/wf03Gd9SCf8SrzsnaJjy7W6UtWYEZBbo=;
 b=CSELKrUPKnS+sR/LeITmHvNMLOBLXHrtL9lsuHANlT1aGpYNVEQ+PzRVrfb74DQl+zcRP7nRZ1SSNjM9FdrMxmiXpzfaJMhZhhjJ8mkOvMjmQ7w91F4rm7yKMcLkyb9XBLXWD3j8Fg9TvTtBoH9hwCi6E8G5AwhfFNELqaABFhcV8GzpXRzIJyitMMdXMs2YkPGJNx4byGZJrva1x6SzyWJmdiNtDvXdzuMEPCd10CK2mJ+xSnjnVnwZusiwPnDSzq5rLfxwxWltdXJ1HuGsWurcE3gVsgd7VWGe+iDdxO2etWVWSVvgAGsMoC0PdvHYsGqmA88Q8P16jZ3Km5cDLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18I5opLXPb/wf03Gd9SCf8SrzsnaJjy7W6UtWYEZBbo=;
 b=MXeOhFyOS8W1aOJSFYlZn/WKy/Plgl+mTgIrUuPEcm5QTX+OLbMWZvD80frsB3+0Qcb6aZStRZQkcjzPSLb9NEZ4CJ2JQgIqD6eHgXf9tA5M4hjrovqW9UJGxTzl90hItEfPogoXOxIQUY9lGloCJp5nWvS0eOSY+g5WOhoXWA8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:43 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 04/20] xfsprogs: Use xfs_extnum_t instead of basic data types
Date:   Tue, 14 Dec 2021 14:17:55 +0530
Message-Id: <20211214084811.764481-5-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: ef9ec3e3-fd25-48d2-8073-08d9bedeac3a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656DF49DCE4A9BF19F3BA48F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:77;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpK21mshBo00C7jk3Ap7fCVD4p0zcjc//LIR0U7KYGtPMYD7HEfHfqP8G2HZrNwBXRGzHzYhsJgeeHcIezft7xG7f2hgdzHQL1LqB4i/hvhWEvaZz582o/lbgu077xETZGyBD3CfPCrNBQwsn6nW70gWrSdlyPUJsVuRz/zDz4b1TB0y45PJ4O1Z7y+4QObgHbn6pdv47tt4Ox8i/hDNnVFs2JtOfHtgeXtlNSTL2mmpG30VkcOP/GyQst95l1Ryn6tTI64BuLnNjbT0gxnRx5StJ4lyXe5+A5ZVomPT7ERleFVQYRWRS79RQ450Tb7F+ManVPlnF86ZzBNKCHuQaA03JokJ3/LN8/kAd0R4/rcgwqpmBxnKv89DmmCOLE2euzbyZJTQOGkPLu40HAEuEAznngXjkNsoqeUFsGxt8ZrJ4FSR69xGf7YTQAOvs0Pdv6pn/V/rjs4EClTAddOkUJ7vJ1kXK2SuGi6v/rE+Lisk1cUvJZxEruKZ5uCaNUFkLIn1L53WUNmOoq0QQynIZXxUkL38HYk1AmND9e3Aq0iwxqoH3WVlTxdPf4E9PlvEM5xtQ8BN9rDY+vTye5+LTLAMSj+sUTx7GguWiucM9oGdvXpvHNFqe7lLuSS/GPm8OPq70EYqIqCk10pduHbGZF6q8rlTarmRDIDtC3jZK6jti4HOOnEwc4Llvk2hGxoq99lqbRxHnMEVijDhGCwqmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CIF38jSyiZNLwh75VtaHuGFv71Aj4QW35UCdXwDj9GXEGlZta4G1DBQ0ODMe?=
 =?us-ascii?Q?n0EbrSPJiWSJ0AovMgRTHVfPgnoZETdZGCqqpegM2XXT0sPsjznkgmqjQV4V?=
 =?us-ascii?Q?//3IbRkDx5dldi7XvHVpNK9aFIvh7w0yV6rG03/icP8H073D/JajOIJtB0/r?=
 =?us-ascii?Q?r4UoD6Jn3vFB6ZW/HQG4Tjlv9CSJVfYvfgoA2JvlbLP+5J2fR1lk/9djqorG?=
 =?us-ascii?Q?ebqBExjpY1zBJStBe2Mh+/4dF0mAOonHlOdWHNswOy+FiL54Y/tcMcTfGDPe?=
 =?us-ascii?Q?IPsU6hH2bRSWc6aD28RSqWnieHDHXAVtFmAIAsRPILZaU/d9WwWU775b4njN?=
 =?us-ascii?Q?CzvfU8zLZ2al7s5oja45aCMAfktGbZuwv69jo93AiBC5hm7eqWFFz4U45mwS?=
 =?us-ascii?Q?h9fhSm5XyNoOln03KFY99Ehcv2vTxKQ2bg3447qABhGHWMOuy0lIowZ2rg86?=
 =?us-ascii?Q?7bd0zXOzaAhMWqByf9X+Fpxy/7dc3wRTgUk6shYzy0ywsemNjoeZwHwpjyfB?=
 =?us-ascii?Q?6Jf8yImpwb6d6A59MyBh893tvHDmXfkid89eSV+5ZJBb3u86chn69wqHlzZ3?=
 =?us-ascii?Q?Wif7e2F02I1jiF9660KMKc49Y204MQqGVwjRZi5v3TVAcLugVldzlWdcrxbY?=
 =?us-ascii?Q?ldkOGOiZcZZUeshypTpajxIPZgb7MdRFZJ3Y+MJt/hr/sd+jLC/ghkR3myG/?=
 =?us-ascii?Q?xDNgJ1nTI8dpQncwpMVUZzexJH6yEDjb6HK1Am6KhLCIWLcsaBoW/+NtNwjI?=
 =?us-ascii?Q?hbFwvQ6QpPGEPFGc/PEjt+ZeA6FUaMpRgA7oMq5u+IyKE3oYcgSdXKrK8bel?=
 =?us-ascii?Q?1s8m/xmcHrJfQUNxhLCr9ryOWO6a5VGAA/DUWK6xTfNkXXJl+hiO68RrUSN0?=
 =?us-ascii?Q?jpjE9BLFp8JbF0ODDJSJIFsOcPZnh96HHlqYmA2uV5u2NmjQUnkb5DgBWIRg?=
 =?us-ascii?Q?7GUEIOgSDAEsC14WCMU5qzvZmN1suQDoqDnyWmiem0NuQilQJTT/UblwL3WE?=
 =?us-ascii?Q?41e8mPqaO7dMMUO/oDTzKRRk5QslpF+Mct+YK7wGyIBJl84pVj2v2XAcLd3i?=
 =?us-ascii?Q?XC6Kq3WolaLceEH/fnuT6CN0t/Zt04kXYsvxopOsYyvlHkNfNt52R29vfpxW?=
 =?us-ascii?Q?iiwGYkcWW8Tprka0ALpVnAPU/HJYN9Pe1vZ+YJaUBeGdTyxNRJxZkwADkz9b?=
 =?us-ascii?Q?ZR6bF+0MzEu+0FV7lwzpKB2FV2BEGgO7OeMccA7JV/B0fWNDd17JaeeIyRVo?=
 =?us-ascii?Q?vnev6vFtKj3bbTKBVBuPD/tfUhS9VJPWhgufJ8byTZTUo7a9+su1vbqbABcM?=
 =?us-ascii?Q?0hZtvO5UzDVg19Vh6qSB3zSHIKEBcUP9CELahKaOKeBgTUGUfjIYEy4BTffw?=
 =?us-ascii?Q?yI20NWY4MvHGjQPA267vfUVOwuP0XBKCfNkzlyqAIKZBg5xuSkfeDnBre/pX?=
 =?us-ascii?Q?hKg4m+CEcr99OjuFXc7T+/S3HdAcPNF+aDKBORghDvzKiNLeQem4AINJsnhM?=
 =?us-ascii?Q?ieWz+1nYis5EXMczzj0wpsALVn7kT9uRRNdBObRQ2qzS9yenGw9wP/lU6T2W?=
 =?us-ascii?Q?RpjNVrFeNKYmP65meo2EBWKTHl9BCX4KspJHJfQFHeJPjwg3NogfVL2gqdJC?=
 =?us-ascii?Q?NmfAJK6U0ZMmqkfHIbt5Rj0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef9ec3e3-fd25-48d2-8073-08d9bedeac3a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:43.4632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNXSDkPkv7khSdjrrCY3nynwS2WlJmGtjfKU34VtHFdy5oN5A0WUPh6dzi6bGQqnPB94nvkE7TcVsAOSaekr/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: sJzXsqRbEW47RHcz9OgG58H3pijYot1y
X-Proofpoint-GUID: sJzXsqRbEW47RHcz9OgG58H3pijYot1y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               | 2 +-
 db/frag.c               | 2 +-
 libxfs/xfs_bmap.c       | 2 +-
 libxfs/xfs_inode_buf.c  | 2 +-
 libxfs/xfs_inode_fork.c | 2 +-
 repair/dinode.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index fdc70e95..7925a197 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -47,7 +47,7 @@ bmap(
 	int			n;
 	int			nex;
 	xfs_fsblock_t		nextbno;
-	int			nextents;
+	xfs_extnum_t		nextents;
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmdr_block_t	*rblock;
 	typnm_t			typ;
diff --git a/db/frag.c b/db/frag.c
index cc00672e..ee058aad 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -273,7 +273,7 @@ process_fork(
 	int		whichfork)
 {
 	extmap_t	*extmap;
-	int		nex;
+	xfs_extnum_t	nex;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	if (!nex)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e7911a2a..46e4c1d4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -48,7 +48,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 46dcfe77..2ba84dac 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -333,7 +333,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 9a7c2c91..12656c74 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -103,7 +103,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/repair/dinode.c b/repair/dinode.c
index 962285d5..4d125db4 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -932,7 +932,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
-	int32_t			numrecs;
+	xfs_extnum_t		numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-- 
2.30.2

