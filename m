Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE3DC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiCUFWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344123AbiCUFWS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC9C3B559
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:20:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3PwEL017596;
        Mon, 21 Mar 2022 05:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=vaY2VuU3sF/0TgvhnYRH8soEXuAje3B36XwyE7fHSdM=;
 b=VOY+drwJB8MSK5AdfXLbuoHjGpf9Y5qRNpKARJLMkXd5T3SJcplzs/irC0BI/ayRlKHO
 EUtDH+wCMJODNamE4CNV+uL9JdjYtQV8EEnH7mfZepU39VYEEGouxYRR2qNRjZOlcUQW
 UzHcnVzV1NuS0hzVjzHfhtv8SWDVhTrHsu8Rx0DdCHoNshlhdFd466NAqbjP5AQpWF2f
 ZKVSC9FJugD2HftEgQU/gi7UVs0tjpicNulD6uDHYfDi0Q9c7VfJsF3dA+9W0F1vWZMX
 RxCIlSHaotcrl5lQuWxfS2/QQrufaU3bMDy1dOgA9mK4xDwt3N59j3mjHaYCOwsHqacf 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72aa3n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5KXMo163298;
        Mon, 21 Mar 2022 05:20:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3020.oracle.com with ESMTP id 3ew700976c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/igy3Xg6bSfsXUaScIReLDccEiLjwrBf76Sdn6xHlrweyoCpWFVIma6QDbAD1h8J/NyuDBbHYvlYg1J+wOpnBZAdTDzX7C5v4fyxEpEmSiwxKyVPoFVNTjX208a4uPERIAmHPI04mZygIYbZuzjPzljAo2fCwz3SDYJAOT7gW24W6TjRtU3DYkb7l0xtrrzDSW7nxO+NTT1pIcLGwNOoQkWGLyQ54s9FYxkEYi+uaiMoVjS4eUYbL/vD8zW4b3wrouHQuYD/LAaG6FhWDZzwjXZYjGsYeJGeSZWgy2AYS1RlQkRbJ85h02wzEvbLmpRObhacZMGM1FATXCRGSa98w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaY2VuU3sF/0TgvhnYRH8soEXuAje3B36XwyE7fHSdM=;
 b=l8gM4pe/AhWxP+MSN8JL9pwU55tMjRHds6G0BHvG9LCbr1H8mKqHjt0PcPKJoPDwuDHrUNrvKAqccbA9y56M8jHkPBf4GRxWu4v1HriCVojK988ic5XdnDMPu4Wbk+JWRuafGwgisk/QbDskm1U5Dg55i95pmdKrWU/zQ8ljRGZMktMpXu1PGwylILoJlzyAR/AAYXim4vGFhNGEZMspIX8E+d5bwsmseUP1/2N457uxcw0W3HE7qATn4q1dVCwtbc5I+SUpIBm56mv4RhRRWltfySxvTgVjG9zbqhgnaGeVm4hENJxaoFmeY4FcbpiX0NPNY9x+JFQkF7VVZBF+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaY2VuU3sF/0TgvhnYRH8soEXuAje3B36XwyE7fHSdM=;
 b=ZaxtSsewEulG+dWd/2VIhpzwMHhqE4Ruk6diJBH5EHXW/yPlkggbFImcve9r1vuqKFVdoypN0hdHDydzMHD8bmD9ONTy4lLSBBfv8IfL2Uf/RvQp+Miu4afrchpRS+oRUaXsDzV94/fiieZmxpuSLBgq3tb5qzgWe7OOt+FI/sU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:45 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:45 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 02/18] xfsprogs: Define max extent length based on on-disk format definition
Date:   Mon, 21 Mar 2022 10:50:11 +0530
Message-Id: <20220321052027.407099-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ebfabcd-4924-4b49-ee11-08da0afa8d40
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5563646A618A3B270563E7E0F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FE0+Dq1a02+zzdEnBK1KoEWu9l995M3AWmaBk/Ho/1fSp8ZmXkEx648AWgmeUFUUA+O/uG5PJkfnzaIF3wcD+oLPwOqp83ao1ZGHCkLDRhUJCqYn97wnsjf0dkb3T12qsT1TqmA72bjumhNKeiUCyD8ltncnw7RDvGXcjBIixTU1MI3Aa9zrX2Q+S7w554BavrHJSX50wk99u7aFgtWiY78gRwLxy2BNiCCacsD13vKVuw/lbbkUNL78thylGhSNuEFC3qMBYSklv/92JCEvADHGrJTIr5lhm4vFUG/W2ee33gAQVDAEPBteQotEeVXHJPr74S5RImW2NmCmI0F4aaNdiOS7ee9Mmq3XcLbYkbCVrhhINehvCfYdY3YGq6OGWm0kiY1oZqNCD4U5hSo+NlbYYDlV6d8ijeTOK/KER+zJz3twgJ7R0R+wKC0B7G8RhDyQ9RmmyB/yuSQVzE60V+rp5ebcv/ozmo3sCjDyGgeUKrgg7vAn0aahW/Yb2kPbpZ0R60IHockskP3mHJuYv0uJaZER7XstPvPMNdkgaHeog15g1C/DZFcxlbGfkC+1tVkqvS927GXxJpRErttDbiRUHAcp/NhgiD3e0Xrq4EC2SXTPcQW+W0k9t5O/ISIlYuwGf7CkqS8bafHPEhax7d+CByVUJYoGJjIWqp7k18XJiXUXLZko8BH6h4ndPBCz5WVHQFjWErpm9a6b5/O3eA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(30864003)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?czvAjjYUPTYt5XxnfudFwy9lOPeHqD/hucVdTaArnsMD4rOVq+CBbv2fDbfe?=
 =?us-ascii?Q?QnPa+kTee6TdzWrizu9g459MkpUE2CfRMI+PwHUf+sfcstnxeEBq03WePmQ9?=
 =?us-ascii?Q?mf1H5u6Op47hr/b0X3hWVWb0gM8gwBy+nO/eXadMsSudNzhxxgC0aTqPe9sG?=
 =?us-ascii?Q?0ydEmCzWwwacnY0q/UKASdj0drPuVc1v/YTlxY29xWHjV2t6PDoguHZMggF4?=
 =?us-ascii?Q?dAAAMKNhCErFk8+cdQXjHPIMdiBE0Z9HNvsiqHFJpnyj2Y022eVQd1yoY9Cd?=
 =?us-ascii?Q?Y7LEtaOr3lxTZP5bFeMIJsMzN2rEHTajbsSAezk/0i67IdkQutcCDLMmYZ0R?=
 =?us-ascii?Q?EBCS1XcaqpmEV+82TcNqIrYKYoKAfH79kIoit/LWH3ek07lDXK36NC3MoNts?=
 =?us-ascii?Q?ON6hwBxRnd8bcCC7olHtgw/bhqmoHWMa4hbWy2E+c3kcUtTEJtBKtq+x3+fT?=
 =?us-ascii?Q?cIDxmtWPGW/5uJ77DdZBFbT39aK9UToSm1TaiOM1fmccXZm145DS5rK3dZkP?=
 =?us-ascii?Q?dsvz0ZTu12BjLFiVJ9qGJ4VYKcyNDoQB0W+fV39t3EsUZ65SBNHkdglVysCH?=
 =?us-ascii?Q?vSuY7Z4Bny7IpPLJ6brOqZ1tdamedHOBNt0WxuPA6OcZZYBSqUVLzXNICIeC?=
 =?us-ascii?Q?t8yu0kpwUAPnejZaM9tvYtYDFQEKqT0HTm63Lqc3VcNauRbRZdYBUDviV3A8?=
 =?us-ascii?Q?xzyp0sPLOMVGCG8QQd2czSubwn+CnMyd4xgA9wWlBSIFI/SO3SJmOP1oGnVq?=
 =?us-ascii?Q?zoutKNwgPpDNiqx0jXmRqlPl0/vI2iYXeMqnxS51/7fYU2jvu96f1U3jhIG7?=
 =?us-ascii?Q?ptaan8j4wpIca8UFzKkH9F8M9bxf4ULCumdDQdALNqgjFZBq5XFMcABaOGpY?=
 =?us-ascii?Q?zIQaHmIjUT5MfjyGH7hgTzuJOyttktBpc4iBMhwPijf9ZqpOeYmZOr9fnuVb?=
 =?us-ascii?Q?HOkFIfMkB9XXoyPI9vPJzru+zMfFXU5B1Fjjafag1iPLbqpQN/Wp8mj5DDjM?=
 =?us-ascii?Q?l7CqUKzUZkHHBVhvM+vzOlBNXY6FQp4hghcn58meDbndOKyV95Ji00zofkVy?=
 =?us-ascii?Q?ogWuGSTb4WlU9+aPHsDkPryfEWyG66scmv11z3LtY4XVx/gfKVAaWYQTsnft?=
 =?us-ascii?Q?yUXsTXFzULypZX2dl89Cv1NbXiVe/xVQ/QdZJSFCkcfcEqm9Zv0VxwBSynHA?=
 =?us-ascii?Q?jrISewY4iCp4RYd5f/tCSq4Dl1NNXJrDWiVL/4FScju7DxEP1vau0gwv22J+?=
 =?us-ascii?Q?ARuVuRn4rN/jWWw6Y92BP2tHxxJxs/IbRySnRyTfi0UptYTJ8xXjj04eztJZ?=
 =?us-ascii?Q?fSp+cxWDILysmyWHOTdaTMCr4yz+3OkPb/XA5AXqisuzv+Szkc46lrC8PltL?=
 =?us-ascii?Q?0MfnP6zsN+bBw9MtVo0xFd3GicRABmM7K2QokLxMBovUc0OiFevcNEB1ZyTO?=
 =?us-ascii?Q?U9ZWJPVHU0gWUrmCnge1fL0njszlhEUFWOgfywY5BoCQq6rss4BIzw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ebfabcd-4924-4b49-ee11-08da0afa8d40
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:45.6790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xOAlHuQZEREVaJHabIagl1tdQHuCeGhpioDLsjDFNlgx4E9steu6lTvbtAeqvjBMGocWrHQXtpWBjvFKIgzUhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: kDem2b99Uyzo4F1JSkLzRHPiJhHJPyeC
X-Proofpoint-ORIG-GUID: kDem2b99Uyzo4F1JSkLzRHPiJhHJPyeC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum extent length depends on maximum block count that can be stored in
a BMBT record. Hence this commit defines MAXEXTLEN based on
BMBT_BLOCKCOUNT_BITLEN.

While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c           |  2 +-
 libxfs/xfs_bmap.c       | 51 +++++++++++++++++++++--------------------
 libxfs/xfs_format.h     |  5 ++--
 libxfs/xfs_inode_buf.c  |  4 ++--
 libxfs/xfs_trans_resv.c | 10 ++++----
 mkfs/xfs_mkfs.c         |  6 ++---
 repair/phase4.c         |  2 +-
 7 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 2993f06e..9bc20a84 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -20,7 +20,7 @@
 #include "field.h"
 #include "dir2.h"
 
-#define DEFAULT_MAX_EXT_SIZE	MAXEXTLEN
+#define DEFAULT_MAX_EXT_SIZE	XFS_MAX_BMBT_EXTLEN
 
 /* copy all metadata structures to/from a file */
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8906265a..9057370f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1445,7 +1445,7 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1463,13 +1463,13 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1993,7 +1993,7 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2011,13 +2011,13 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2503,15 +2503,15 @@ xfs_bmap_add_extent_hole_delay(
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
@@ -2654,17 +2654,17 @@ xfs_bmap_add_extent_hole_real(
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
@@ -2899,15 +2899,15 @@ xfs_bmap_extsize_align(
 
 	/*
 	 * For large extent hint sizes, the aligned extent might be larger than
-	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
-	 * the length back under MAXEXTLEN. The outer allocation loops handle
+	 * XFS_MAX_BMBT_EXTLEN. In that case, reduce the size by an extsz so that it pulls
+	 * the length back under XFS_MAX_BMBT_EXTLEN. The outer allocation loops handle
 	 * short allocation just fine, so it is safe to do this. We only want to
 	 * do it when we are forced to, though, because it means more allocation
 	 * operations are required.
 	 */
-	while (align_alen > MAXEXTLEN)
+	while (align_alen > XFS_MAX_BMBT_EXTLEN)
 		align_alen -= extsz;
-	ASSERT(align_alen <= MAXEXTLEN);
+	ASSERT(align_alen <= XFS_MAX_BMBT_EXTLEN);
 
 	/*
 	 * If the previous block overlaps with this proposed allocation
@@ -2997,9 +2997,9 @@ xfs_bmap_extsize_align(
 			return -EINVAL;
 	} else {
 		ASSERT(orig_off >= align_off);
-		/* see MAXEXTLEN handling above */
+		/* see XFS_MAX_BMBT_EXTLEN handling above */
 		ASSERT(orig_end <= align_off + align_alen ||
-		       align_alen + extsz > MAXEXTLEN);
+		       align_alen + extsz > XFS_MAX_BMBT_EXTLEN);
 	}
 
 #ifdef DEBUG
@@ -3964,7 +3964,7 @@ xfs_bmapi_reserve_delalloc(
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
-	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
@@ -4097,7 +4097,7 @@ xfs_bmapi_allocate(
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
@@ -4417,8 +4417,8 @@ xfs_bmapi_write(
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
 			 * check for 32-bit overflows and handle them here.
 			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
+			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
+				bma.length = XFS_MAX_BMBT_EXTLEN;
 			else
 				bma.length = len;
 
@@ -4553,7 +4553,8 @@ xfs_bmapi_convert_delalloc(
 	bma.ip = ip;
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
+	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
+			XFS_MAX_BMBT_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
@@ -4634,7 +4635,7 @@ xfs_bmapi_remap(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
-	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
@@ -5634,7 +5635,7 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
 		return false;
 
 	return true;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d75e5b16..66594853 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index e22e49a4..28662aa7 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -636,7 +636,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -693,7 +693,7 @@ xfs_inode_validate_cowextsize(
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
 		return __this_address;
 
-	if (cowextsize > MAXEXTLEN)
+	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 61a0a1ac..4759de1b 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -198,8 +198,8 @@ xfs_calc_inode_chunk_res(
 /*
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
- * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
- * as well as the realtime summary block.
+ * blocks as needed to mark inuse XFS_MAX_BMBT_EXTLEN blocks' worth of realtime
+ * extents, as well as the realtime summary block.
  */
 static unsigned int
 xfs_rtalloc_log_count(
@@ -209,7 +209,7 @@ xfs_rtalloc_log_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
@@ -246,7 +246,7 @@ xfs_rtalloc_log_count(
  *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
- *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: ((XFS_MAX_BMBT_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
  *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
  * And the bmap_finish transaction can free bmap blocks in a join (t3):
@@ -298,7 +298,7 @@ xfs_calc_write_reservation(
  *    the agf for each of the ags: 2 * sector size
  *    the agfl for each of the ags: 2 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: 2 exts * ((XFS_MAX_BMBT_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 96682f9a..d8bab2f0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2398,7 +2398,7 @@ validate_extsize_hint(
 		fprintf(stderr,
 _("illegal extent size hint %lld, must be less than %u.\n"),
 				(long long)cli->fsx.fsx_extsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
 
@@ -2421,7 +2421,7 @@ _("illegal extent size hint %lld, must be less than %u.\n"),
 		fprintf(stderr,
 _("illegal extent size hint %lld, must be less than %u and a multiple of %u.\n"),
 				(long long)cli->fsx.fsx_extsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2),
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2),
 				mp->m_sb.sb_rextsize);
 		usage();
 	}
@@ -2450,7 +2450,7 @@ validate_cowextsize_hint(
 		fprintf(stderr,
 _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 				(long long)cli->fsx.fsx_cowextsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
 }
diff --git a/repair/phase4.c b/repair/phase4.c
index 2260f6a3..292f55b7 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -372,7 +372,7 @@ phase4(xfs_mount_t *mp)
 			if (rt_start == 0)  {
 				rt_start = bno;
 				rt_len = 1;
-			} else if (rt_len == MAXEXTLEN)  {
+			} else if (rt_len == XFS_MAX_BMBT_EXTLEN)  {
 				/*
 				 * large extent case
 				 */
-- 
2.30.2

