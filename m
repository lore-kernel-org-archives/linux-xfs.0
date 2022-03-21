Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2F4C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343929AbiCUFTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343854AbiCUFTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:19:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEAD33E10
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KL409f012459;
        Mon, 21 Mar 2022 05:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=XJTt5oLyR1xITM+tSGSRTH2IZ4K9y7GzE8ApSszBZgQ=;
 b=h1jn7ECPXxTzqTb90/dNcOAi05VTVhuGzcsD3Al4K9gCeyU2oGcHTpK2GW3v9OzSVXY6
 fqW93S7wIBqtCPlWkBlFZAoDejtBahV5Xv61wW0d6CQHgNDg5w5jQ6QUSPP5IVTdrg77
 7DunWDqOGoZL/+vBaGfbBRKSiJOe4xbHhWi82ue0tdCEBjxhTvzX8SmAEoqGeJA3Tf2p
 1RQiYsD1Yl0cLeaEed88WgJ3LmnTLewj2RVJlum9hXjmcKskQcs9/Um03ZSthQ4ii4z6
 6hOtsInQC7O3L4YgVJ97OP24slhthZxXxucde+1dcgaacMc7SqZZFe9F11C9zJCXZDBq GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss23ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5G2xL058068;
        Mon, 21 Mar 2022 05:18:18 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by userp3020.oracle.com with ESMTP id 3exawgeuyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYQ0qH6o/P3l78T6S9klOQnkFTsUpzROus4ozWTEqf5zhIAeQJeKsL+4JJ2ikiEecQvlXsY/fgJpFQrjlhLsUUvnPFB375FFUheaaWDcIa0ePsn4gY/4EqcbTLMxO/6wMvuV7mAHL6LADcvjG0IACgEJRqtfZmt5T7k787grE0MutqMqa/A1yC9f4jezrjCkU69Z+1M9Pj6PWxFGBSThLZz0eEcHWb+Brmq28RzeovxqZHtZQzQuJ3tKc9GYNebuUJ4S4eujN9VroY9JaBvLf6Ue8ag1ERl8a8KtWItivxKpFRi1lZgxddKWjw1GSUDv6qb5e4wKCpZRvENRM7V+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJTt5oLyR1xITM+tSGSRTH2IZ4K9y7GzE8ApSszBZgQ=;
 b=KXJSKo0g9UrpsaLR/bLGuIgHKQ5MMHgNfqgKbQ/d2XZ7u20o1vd2ZbutLEv91hipTwU+vcJTYP5cCS17BZ5Qgy0fP2ZQwL9/zAXa7apvQWqI3pCXQFYs+RHYrW9nXRp/bPBV/cMyxJBXspos4YyAJAxgdeku+yZEDkeVhslkVlaJmA/NXvzomlKNUlnJGIA4ARoPYBtw6bBpgEN3lsiJEHpalFIZbkZuwsMvZjX1aRLwMDVaKnBwDXXUd8NXHssCJQfARIfbMAwXOyCTIeLmAoaxaL0gP6lTZUk9DRuJ7GMElOnIeo6gFNPK5mz+M5wnzOpP3aZX/TC5q3lBK2msmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJTt5oLyR1xITM+tSGSRTH2IZ4K9y7GzE8ApSszBZgQ=;
 b=FvVI5et0mUAWyl1cUGzhO4Y2Fdb5MdjTW4qu/kR4CQ56J825o/QnMVVFcHCN+xAv6nE60OKRYYTyLNJymY2QYpXP7eKyWyrRIfr673giHvPiyUwbGlu0n8NiiOlILYuArc4Bcsc2oepw29H/9G9rmPOIWm+asWkxTJ/qvhhK/ZY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2105.namprd10.prod.outlook.com (2603:10b6:4:2b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 05:18:15 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V8 02/19] xfs: Define max extent length based on on-disk format definition
Date:   Mon, 21 Mar 2022 10:47:33 +0530
Message-Id: <20220321051750.400056-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f09cb6c-211c-4132-ecbf-08da0afa33ae
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2105:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2105494FE41E9C29CF8D5F2FF6169@DM5PR1001MB2105.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c2rTWR5mdpx+c3w4FaPlOCH7qKYuRMJp6iTe8GDp/fTAntnT/nlV4HdG97QTzZjoipyB/OUu5alKxMN+tkvVrLtEBHisPGsGrJIgL3CHNOqn1ILe4buH3upgymI4rNQhTRqeFjGlg5NECV1hU4BGy6EDS0YgGGjalWjvB12Ujgg+gwX4b4txUwDnTxdeDKxAJdUcFtGewSWL5e8rncI/dcMSxyLb2sP9sK5/MfdiIJnf6QwD4Er6f2vAgsctmqJO00/kmvJc9JiDgkpRqUnLPmYCMvhTFG40BJLatgw5+xfdDItYY1TKjltouJV5PU1hLrjYdFLtoL3riGpTEXMWBPxyPWAg/Ksxs1iv4amPDu5bXpderYTIfFpNFCQjC/dvbH7BZBgNaqKqwuPC09Vp2mDErGIioEphcc7CuEi4hn9wk2JE/mrD0v2fohWmgvVEeZoGXXNGfEDHExPWAK9MyHBoZ/J48q3O5QN9GidH0polMy26Xpr1H6vmHLV432AFxAE9ms/SechI17qoEiVrQGjdc43LIO6tjqm1Ot9YvST6jiKYysXiNbRvxTYHhE1lvq2YgWbCer50XgjVimxtdcA+OiG3LnXqSnHhlSrq1XbfVRGe8HiwLuQv7N1JHtze601tPGwByzKCfSDMNtDNalPbZXMPzO+QctKjEQcAFcxGDUIR/2M7NeiJNEZelYuQy+CGd39s5TddHu5kn/vwGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(86362001)(30864003)(8936002)(508600001)(6666004)(186003)(1076003)(26005)(83380400001)(52116002)(2906002)(6506007)(6512007)(2616005)(38350700002)(38100700002)(54906003)(316002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iBUi+B4xIbEomrHgVcYN8220v0jBKLghqNcNNXwK9uAtCcKQZQ87Ly9A6njg?=
 =?us-ascii?Q?Wh5N71A2lhveNy1VpiFWALFsaAusg3M4UtFoeaR4z7ZEkeKlccSWXN1LCBjO?=
 =?us-ascii?Q?qCCf2N2th86SVCF5BxiIttkqUkhE8AOGEsST7A/Du/3jItbFOn2kndVPQZGe?=
 =?us-ascii?Q?j+//G2drvmNOLB2zSHmY0MfF1rafQwshhFdhPJPWF4rJiaQCWAPUTbfCMDLl?=
 =?us-ascii?Q?gz3+Cr3diaRNuVCIs6xwL6KiddJ2w8+csWQ+ej/5VL13AMSi32b9mV83m2S5?=
 =?us-ascii?Q?soVZgQnT+OMYDbPr7GOBlI0FJXCr9IU24AsBQjUlho2fEB2S0wAxUBmaBiye?=
 =?us-ascii?Q?V4EGqWSXHMesQslTZ4weKAovCRLpoQc6CDtqBDynl1LwiIpxAWtDKIwf4/WV?=
 =?us-ascii?Q?fIbW1674bVj/oksz9SCfghvlVxdk0XiGqZi/szQV1IfhkI5WfSrkmw2+aBgT?=
 =?us-ascii?Q?lZCsJC5xGgcyEuwTYk/VSHPRckD8ahhVeaSg7aw2aALfuLt6QF2p9wwyR2X+?=
 =?us-ascii?Q?mtPft7EqF+8f36JmnE2qtJM1cFtJ0JrNG1obzoJ2PT258nfYcEbumZaUIJQt?=
 =?us-ascii?Q?IcaTSQfOuXHaNrZPWjlC+T2QMPBS24NLebMKAXoFITeZikBqsmStLdIbPCFe?=
 =?us-ascii?Q?4l1xPEOMK9fMJyPP3uMN2aPImbvB2M3mGpeEkp0hNQdZPdDrugEVeqs8ZYqe?=
 =?us-ascii?Q?DNi7TEsDm1QKdAkq67ALOURgBJqu6vw5pnDnuOBwYmoVOy8EzNlzfcG7oEbO?=
 =?us-ascii?Q?uw/GaI2/66aGxiZmhuPh+Smp8w/4uphnne1YNxBDUiDquTYEoShtKlnUrHp8?=
 =?us-ascii?Q?U3cJ8cNxn9tz3mrjxEOTf4mSKPEEbzyPjIt6J461MCQp4Yr/6gtaeT8pPbxr?=
 =?us-ascii?Q?bl3ycRe99HB0FUSduDcvcINXbFrFETdrBt325nseP5o+ko+GgMhicpPFwf8E?=
 =?us-ascii?Q?xvzarTqVJ4EWxhjkv3QHmvmkV6BOK61SQ+bi/VZxXJS8qx2Mz3KG1yEGz6sz?=
 =?us-ascii?Q?HbMHIUjvHwgWeqs3mPKRESNOjeXBOIWxlUwZjwfMEsOdaM+K9b9seC60NfYt?=
 =?us-ascii?Q?p/VM6iE3wAHgeuLBNnMpFZFFhluExgKT/jpM5/ZGJZiJ/RNnTdk+tlMnuFs7?=
 =?us-ascii?Q?qs8qYYd5z0D+CW6i4UfbtKG3woW/wto3O+zGPE2rDqQSs13UWZgmwTIWqIR9?=
 =?us-ascii?Q?sn4q4Fe2hrUr1zMi+Sj9UvLn6ttr3FfVHHtfPkTyzArouPjyW83AE4AGiDNg?=
 =?us-ascii?Q?MFcA0PN/RKVhdCGnf/MZsUl1dWx59v9J2S2SqwzmqU1+YbbmM9095yndRbbc?=
 =?us-ascii?Q?vz7isgZ1d20xdkIT8y0xzuuSYdvnzCIWm6RAy23iOxVqnp8EQ042s1TzYtuW?=
 =?us-ascii?Q?16dlj1s7l6z2MlsEXyXzP9U4c4VTlCH9J59rXsdG9lXg4N9c1VDKZW82+H99?=
 =?us-ascii?Q?fhhbIxJ8NoqjqSdMc4rJbJl1+PufXqZAsgbvgW/3zSJaH1zwQLLSbw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f09cb6c-211c-4132-ecbf-08da0afa33ae
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:15.3737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+Tc3UvMwH3SXV5C7M/R+2Ca/2wHDKw3DLyPRsvlDNqowo2lQzBHVXteUfGw6J+uftTQ4onpkTx+pKk2iJ4LaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2105
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-ORIG-GUID: pWa5LzhcHNTqTVRiff98KAnam9lLVBj5
X-Proofpoint-GUID: pWa5LzhcHNTqTVRiff98KAnam9lLVBj5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum extent length depends on maximum block count that can be stored in
a BMBT record. Hence this commit defines MAXEXTLEN based on
BMBT_BLOCKCOUNT_BITLEN.

While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |  2 +-
 fs/xfs/libxfs/xfs_bmap.c       | 57 +++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_format.h     |  5 +--
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 +--
 fs/xfs/libxfs/xfs_trans_resv.c | 11 ++++---
 fs/xfs/scrub/bmap.c            |  2 +-
 fs/xfs/xfs_bmap_util.c         | 14 +++++----
 fs/xfs/xfs_iomap.c             | 28 ++++++++---------
 8 files changed, 64 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 353e53b892e6..3f9b9cbfef43 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2493,7 +2493,7 @@ __xfs_free_extent_later(
 
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
-	ASSERT(len <= MAXEXTLEN);
+	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 74198dd82b03..00b8e6e1c404 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1452,7 +1452,7 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1470,13 +1470,13 @@ xfs_bmap_add_extent_delay_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2000,7 +2000,7 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2018,13 +2018,13 @@ xfs_bmap_add_extent_unwritten_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2510,15 +2510,15 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= MAXEXTLEN)))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2661,17 +2661,17 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
 	    new->br_startblock + new->br_blockcount == right.br_startblock &&
 	    new->br_state == right.br_state &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= MAXEXTLEN))
+	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2906,15 +2906,15 @@ xfs_bmap_extsize_align(
 
 	/*
 	 * For large extent hint sizes, the aligned extent might be larger than
-	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
-	 * the length back under MAXEXTLEN. The outer allocation loops handle
-	 * short allocation just fine, so it is safe to do this. We only want to
-	 * do it when we are forced to, though, because it means more allocation
-	 * operations are required.
+	 * XFS_BMBT_MAX_EXTLEN. In that case, reduce the size by an extsz so
+	 * that it pulls the length back under XFS_BMBT_MAX_EXTLEN. The outer
+	 * allocation loops handle short allocation just fine, so it is safe to
+	 * do this. We only want to do it when we are forced to, though, because
+	 * it means more allocation operations are required.
 	 */
-	while (align_alen > MAXEXTLEN)
+	while (align_alen > XFS_MAX_BMBT_EXTLEN)
 		align_alen -= extsz;
-	ASSERT(align_alen <= MAXEXTLEN);
+	ASSERT(align_alen <= XFS_MAX_BMBT_EXTLEN);
 
 	/*
 	 * If the previous block overlaps with this proposed allocation
@@ -3004,9 +3004,9 @@ xfs_bmap_extsize_align(
 			return -EINVAL;
 	} else {
 		ASSERT(orig_off >= align_off);
-		/* see MAXEXTLEN handling above */
+		/* see XFS_BMBT_MAX_EXTLEN handling above */
 		ASSERT(orig_end <= align_off + align_alen ||
-		       align_alen + extsz > MAXEXTLEN);
+		       align_alen + extsz > XFS_MAX_BMBT_EXTLEN);
 	}
 
 #ifdef DEBUG
@@ -3971,7 +3971,7 @@ xfs_bmapi_reserve_delalloc(
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
-	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
@@ -4104,7 +4104,7 @@ xfs_bmapi_allocate(
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
@@ -4424,8 +4424,8 @@ xfs_bmapi_write(
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
 			 * check for 32-bit overflows and handle them here.
 			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
+			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
+				bma.length = XFS_MAX_BMBT_EXTLEN;
 			else
 				bma.length = len;
 
@@ -4560,7 +4560,8 @@ xfs_bmapi_convert_delalloc(
 	bma.ip = ip;
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
+	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
+			XFS_MAX_BMBT_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
@@ -4641,7 +4642,7 @@ xfs_bmapi_remap(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
-	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
@@ -5641,7 +5642,7 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
 		return false;
 
 	return true;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d75e5b16da7e..66594853a88b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -870,9 +870,8 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for extnum and aextnum.
  */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
 #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
 #define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
 
@@ -1603,6 +1602,8 @@ typedef struct xfs_bmdr_block {
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
 #define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
 
+#define XFS_MAX_BMBT_EXTLEN	((xfs_extlen_t)(BMBT_BLOCKCOUNT_MASK))
+
 /*
  * bmbt records have a file offset (block) field that is 54 bits wide, so this
  * is the largest xfs_fileoff_t that we ever expect to see.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index cae9708c8587..87781a5d5a45 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -639,7 +639,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -696,7 +696,7 @@ xfs_inode_validate_cowextsize(
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
 		return __this_address;
 
-	if (cowextsize > MAXEXTLEN)
+	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 6f83d9b306ee..8e1d09e8cc9a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -199,8 +199,8 @@ xfs_calc_inode_chunk_res(
 /*
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
- * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
- * as well as the realtime summary block.
+ * blocks as needed to mark inuse XFS_BMBT_MAX_EXTLEN blocks' worth of realtime
+ * extents, as well as the realtime summary block.
  */
 static unsigned int
 xfs_rtalloc_log_count(
@@ -210,7 +210,7 @@ xfs_rtalloc_log_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
@@ -247,7 +247,7 @@ xfs_rtalloc_log_count(
  *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
- *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
  *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
  * And the bmap_finish transaction can free bmap blocks in a join (t3):
@@ -299,7 +299,8 @@ xfs_calc_write_reservation(
  *    the agf for each of the ags: 2 * sector size
  *    the agfl for each of the ags: 2 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap:
+ *		2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index a4cbbc346f60..c357593e0a02 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -350,7 +350,7 @@ xchk_bmap_iextent(
 				irec->br_startoff);
 
 	/* Make sure the extent points to a valid place. */
-	if (irec->br_blockcount > MAXEXTLEN)
+	if (irec->br_blockcount > XFS_MAX_BMBT_EXTLEN)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (info->is_rt &&
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index eb2e387ba528..18c1b99311a8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -119,14 +119,14 @@ xfs_bmap_rtalloc(
 	 */
 	ralen = ap->length / mp->m_sb.sb_rextsize;
 	/*
-	 * If the old value was close enough to MAXEXTLEN that
+	 * If the old value was close enough to XFS_BMBT_MAX_EXTLEN that
 	 * we rounded up to it, cut it back so it's valid again.
 	 * Note that if it's a really large request (bigger than
-	 * MAXEXTLEN), we don't hear about that number, and can't
+	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
 	 * adjust the starting point to match it.
 	 */
-	if (ralen * mp->m_sb.sb_rextsize >= MAXEXTLEN)
-		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
+	if (ralen * mp->m_sb.sb_rextsize >= XFS_MAX_BMBT_EXTLEN)
+		ralen = XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize;
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -839,9 +839,11 @@ xfs_alloc_file_space(
 		 * count, hence we need to limit the number of blocks we are
 		 * trying to reserve to avoid an overflow. We can't allocate
 		 * more than @nimaps extents, and an extent is limited on disk
-		 * to MAXEXTLEN (21 bits), so use that to enforce the limit.
+		 * to XFS_BMBT_MAX_EXTLEN (21 bits), so use that to enforce the
+		 * limit.
 		 */
-		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));
+		resblks = min_t(xfs_fileoff_t, (e - s),
+				(XFS_MAX_BMBT_EXTLEN * nimaps));
 		if (unlikely(rt)) {
 			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 			rblocks = resblks;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e552ce541ec2..87e1cf5060bd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -402,7 +402,7 @@ xfs_iomap_prealloc_size(
 	 */
 	plen = prev.br_blockcount;
 	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
-		if (plen > MAXEXTLEN / 2 ||
+		if (plen > XFS_MAX_BMBT_EXTLEN / 2 ||
 		    isnullstartblock(got.br_startblock) ||
 		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
 		    got.br_startblock + got.br_blockcount != prev.br_startblock)
@@ -414,23 +414,23 @@ xfs_iomap_prealloc_size(
 	/*
 	 * If the size of the extents is greater than half the maximum extent
 	 * length, then use the current offset as the basis.  This ensures that
-	 * for large files the preallocation size always extends to MAXEXTLEN
-	 * rather than falling short due to things like stripe unit/width
-	 * alignment of real extents.
+	 * for large files the preallocation size always extends to
+	 * XFS_BMBT_MAX_EXTLEN rather than falling short due to things like stripe
+	 * unit/width alignment of real extents.
 	 */
 	alloc_blocks = plen * 2;
-	if (alloc_blocks > MAXEXTLEN)
+	if (alloc_blocks > XFS_MAX_BMBT_EXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	qblocks = alloc_blocks;
 
 	/*
-	 * MAXEXTLEN is not a power of two value but we round the prealloc down
-	 * to the nearest power of two value after throttling. To prevent the
-	 * round down from unconditionally reducing the maximum supported
-	 * prealloc size, we round up first, apply appropriate throttling,
-	 * round down and cap the value to MAXEXTLEN.
+	 * XFS_BMBT_MAX_EXTLEN is not a power of two value but we round the prealloc
+	 * down to the nearest power of two value after throttling. To prevent
+	 * the round down from unconditionally reducing the maximum supported
+	 * prealloc size, we round up first, apply appropriate throttling, round
+	 * down and cap the value to XFS_BMBT_MAX_EXTLEN.
 	 */
-	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(MAXEXTLEN),
+	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(XFS_MAX_BMBT_EXTLEN),
 				       alloc_blocks);
 
 	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
@@ -478,14 +478,14 @@ xfs_iomap_prealloc_size(
 	 */
 	if (alloc_blocks)
 		alloc_blocks = rounddown_pow_of_two(alloc_blocks);
-	if (alloc_blocks > MAXEXTLEN)
-		alloc_blocks = MAXEXTLEN;
+	if (alloc_blocks > XFS_MAX_BMBT_EXTLEN)
+		alloc_blocks = XFS_MAX_BMBT_EXTLEN;
 
 	/*
 	 * If we are still trying to allocate more space than is
 	 * available, squash the prealloc hard. This can happen if we
 	 * have a large file on a small filesystem and the above
-	 * lowspace thresholds are smaller than MAXEXTLEN.
+	 * lowspace thresholds are smaller than XFS_BMBT_MAX_EXTLEN.
 	 */
 	while (alloc_blocks && alloc_blocks >= freesp)
 		alloc_blocks >>= 4;
-- 
2.30.2

