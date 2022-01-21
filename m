Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D48C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiAUFUQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:16 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19082 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234018AbiAUFUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:16 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04Xn7009038;
        Fri, 21 Jan 2022 05:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=LBajtJ4mfv5AXObl0n7/iijujwZ93hyZ60/38RNTtAE=;
 b=sMdtASrP0baILKYOw3Tz6VhcOlpYlFIV++l8zaOfiq690louRF/NRCZniX3zxwKOecCf
 zUrvM6o5A7d+NX4f3fRNY00fTQiPDyaQd+JJuJ9FYybM2A6S3QWc851FRBc0mi4K3KJs
 ZTm0ewkz4TzOVExI5siq6zzmDYgWTd1bv8foWOd2bs44K+EgsIdeMSvB5gKHy7220V9O
 ztJMpfbaZv7b+cu201dDtzViadJFe4xO7Aj14LRpZwoYr7ysE29502rmAvsUyL3LaSrW
 79PpUIMONnLpchcOGbCgtT00G5to4h6HM//zrIztbFcGD3xeKy0ZtkHYmu/E8AC7c+8b SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhykrcpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5K9G8170161;
        Fri, 21 Jan 2022 05:20:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3dqj0mauvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAYQKu0yhzUT0tCkFEPW+a/Rnfem8K/xHOBCZDHRCLjIfB1qq2BQAH7ecjwsq6bLzb+PDsnhGu2QIUZOMBZaWHfBNP5MJ+A6ZYbuyghdmDhOapKK8NLE9BAHKl53/VEOQ1TkHHyxj8HtKGrQ+EPL8bPNSpflXkrVC3NGP3rP+iOWA5TL0IsP3ekrylzGf6fn0LRJ/2Y1SqzSq/4YmP8M/7FYnNZ8c4tJ+WTvMNDyHeflBoslmLHNN7fXRZLkEHnnzeGAgX7gM4fZc6oaLfiXnfVuPVBByec/3QUhbt2GpnrkWX3RycuFaE2ehQ9G1ixMxVZvoBTd6vFBb/AWncyozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBajtJ4mfv5AXObl0n7/iijujwZ93hyZ60/38RNTtAE=;
 b=FIRMX/CqAeMRvst5U/4VU7hCTOQ52IjAEYIyq4BhTzTezdtbp3qUmaGrzkyKM1KRPIKyZyiADQILCLYcQXQ96RbgaNNH0E12L9nSVl23ZkLglWTHxsHP+sqIMsSbx7hZEf2e2p/q9bl5Ke61fCFY4TJNP0+0+kPVoEogF2xtxevOyj/mMLXyCLSf/8DhRJbQFV4ZxJ78yg54XygN49xKNYc3gsTqvu3sBbLMIRBTalvuFxYpJC5ZshuII/mb0UOOioAYLq1Dt4MKV3Ho0p52k/Yy1JaQgYYpj5Jg2Tp+j8m8Y3xwZSL1wfKcLkxqiRG/0hueMfLcfkX+jEWxnA/wzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBajtJ4mfv5AXObl0n7/iijujwZ93hyZ60/38RNTtAE=;
 b=LQn7miBhvMwHg5aMZPftq21FHHa6sDz3D0E2BnQszX0RGXihsn9W2oLhVdykaAjW4RKfjWztONVNEA0OOCU5KpV2LSpIwQUMLA9WDfU7y4Ra+Y8kpXsyM0qGl/OkxNc3Xn09HIBGIKfZxMq3fsCZ8z/2EGj4OrK4VBECUef6+xQ=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:04 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 16/16] xfs: Define max extent length based on on-disk format definition
Date:   Fri, 21 Jan 2022 10:48:57 +0530
Message-Id: <20220121051857.221105-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2a100ce-a210-4dd2-9b82-08d9dc9dadac
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287ACF68909288FF0F89EDFF65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ikRkpkhSgxwSBP8MZ8jhCInpqcHNVUeHuKt0o+j5pv+C/OnFZ4rg7rcOLz6Z5t5lP/hAMuReCxjcWip5kACoUvcyLuq97TMVY/x7HThohbDMnGmQI2KBwpH68Kvz7ZSXHGhosbOXp0uNAIrxMbWQkI2oGgRSR8J0wVL3wDKMe23eIY0z1M1ynAqo7oNYlK6mKW4c4cIk/hnAoELGEJSU18xTYm1JMvZzwQ7mzkFcqPwNwfTKS4XH+ksB+kGmEgkZaSyh5zyW6nrflhST+p5KQCxM1U5ktcqkmNNKMXagswuNjUtlF6Gxu5lsM2K+qV3h3dAbrttSpW4x/teEHxGGPb63Og0LKoAN6HkN526J0DWUAUQ/628lAR/NMwlTYV3J0HxwE3Xz8Z8sShEWXIR3wiE9wqVUta9VfFAVnyreK0YyOuWAmSyClzcMcE7mO9MKq2FZhUqKxlfmM5FM+Z4W82C9Nme5Eu+hI3UykR8j8UZc0iAOOCzmHlS0Idj7MG1YRMCPWEF4gbu66aKkPl6os1rGXdAe1ruIfUCAt8tecTJOcdyWIi1DEDaE7iG/nyy+ApRF9+bnWVAfXJmySJhp0KizGDNXDFv7xuRQ2MYmAq883hbCgr+if9IV1GKwFTo6HPcqXikBPwSFE62AVbxmsMEHERUURXq2voFKu9tRAwW8ve8edMPpPaRa+f6DgiqDvUKMw/WQUP5XoQ1XYN7/Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(30864003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WSSWhThTMUx44GQYFh6Otw0Z4742tkt3B/GNiP526KKFx+cmjTzaHjk9RUDH?=
 =?us-ascii?Q?am+Yd0GRkx81QKmgqOT5V16aPPnh8fnQTBVvlinpLJApmHLwGZVp3PHNkH1X?=
 =?us-ascii?Q?k7IqBsN663JZsekvqFXSEs31Th9ml8wLcca7mKTwqcGLbFPkBJ+KekW0S0Ec?=
 =?us-ascii?Q?CDDdWU1XIUDjn/YayjMTBf9BpTOU/7aKox+c8yCRHeW5mHNTm/PEj/3qvGzP?=
 =?us-ascii?Q?YcaCSsspAhi/vHQzRZ/kLWwGeTJ4snxXp3oKOM7qPSUGOnUS25D6h+3SNcN+?=
 =?us-ascii?Q?T/0yqPRda/rQdbP4vPZVnDpXGj6YlMvwjBPZVp0ei2iz5zb7PM0iuqO0bmgq?=
 =?us-ascii?Q?CSSlBJWaWlP704v1IQIuVUreRnuwEg3ljpNggv9Cl+fFg6KkXJoEQqNkGB10?=
 =?us-ascii?Q?ZnhJZDhMv4JYunCqY328m/SH0wX8J6vO51t62kTBRHuc+ZpD+Q9u2CKqUM4G?=
 =?us-ascii?Q?1ZEw85zwrF3SVP/zguMKmtaysJwXXTzhyEh+XO2RIWxUMwtwN8kLq9gG7O41?=
 =?us-ascii?Q?yh8jNgdwA099ygTo0Y2VzlgJ9lYdeut41heUD2PxB4zWzUBgJJ6hIzYFvUiT?=
 =?us-ascii?Q?GMPR/VeNhu/IGohCujwQAWbN0NJ8UHN7REzSVdHt+aMB6zMWJ38yub8h/sGE?=
 =?us-ascii?Q?1w7rmMkC2teR5+XL7NRWAzKc8vnd1rjAhzTbdtHfGfiEGOq9vY8UHPsQ/Pth?=
 =?us-ascii?Q?dkanzoCpoZO/Orr0F/ehCyZC/J03ciZSEVaA6+ph22oWfErKT1ulyJWf/DUQ?=
 =?us-ascii?Q?AosutQ8+UQv549t3tReyKyRuQUVfj89n7XDgPrlF1xCQjlSF49tfOg3/mHua?=
 =?us-ascii?Q?f27l6KSPAb4vrfyMEQJL0DrPzwud9TrSrP+12on1aP8YLMxhuONB7td7NebJ?=
 =?us-ascii?Q?YRQEwfSnXMP7mpduBEkp1bL9mYWsxsnpUu1EFSqVoZ5nJKWwvYTXmXxReeux?=
 =?us-ascii?Q?kK0mOnIFxbQ/aIJsAJ0FOk50IqHw/qwXmJtCS3BEiaGsIyLY2/d7029AeWmZ?=
 =?us-ascii?Q?FXm2oeHcYVUkIvewJGRoDFWEcOdl7Q2GZCRvVf1eY/rOTN82OLhQrmosm0lm?=
 =?us-ascii?Q?OtmHbS1bQrhPLjM7JlBd0Pw9qnT9VDhXwIUuh92FIhEJ/NVQ70hLbscGrbUp?=
 =?us-ascii?Q?9zCVNw/uedhaD59SIwzky77/rvXT5gafJdFTMBVyLrIURhUDqJV3FzioQZGS?=
 =?us-ascii?Q?8z/h3uALerp3TV0+RsYXWGClFRXUEdEFYqt0bqZzgCVS3ofnXJZ+TMQUa88H?=
 =?us-ascii?Q?iX9JiMqIU99/H+YpkLe5BWxyrdW8jBrK25sJ9rFjPlp8gpj6GSXW+K4pR0v4?=
 =?us-ascii?Q?yewl8FJOJolX84oTriB/zCDA+ZL9SIdZipFo7RoVujsjPV8vm0TvtjkEo8ct?=
 =?us-ascii?Q?A0vCYXODfFU2YmnMCnC9HgKY/CKwJ7VYSD6tj4M06bUvY+KeV1N2IK53AkyT?=
 =?us-ascii?Q?4L7W4s11U5AJRpDvwKnVvoo2/0J2QkI66Ird0azdQofSTXPyoRPDVjti4vLD?=
 =?us-ascii?Q?8i5WeYw8+K94K3G4P/8CAqKkaNR3GsSWGw+0xoV0OduM0xuo8Ok2JK269wU2?=
 =?us-ascii?Q?6b+1IuW6HRJjNwtf6R4Xj6O8btsTf9SkDlsnSs8Um8FQUyFFi10CIXtAqB1l?=
 =?us-ascii?Q?zNn2rxg+uGMPwnZCytosLDE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a100ce-a210-4dd2-9b82-08d9dc9dadac
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:04.6872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TY8M3P8PxR+BqJG1DLLPwgy4VkfR3yDj+/JAH8szL7OHjf98LgNpVHxqBumy6z2GYBDbwcwMduRZQPNZ+dzVDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: 0aA6NZ1RsJIv54An01ysz7I_dLfnc50_
X-Proofpoint-GUID: 0aA6NZ1RsJIv54An01ysz7I_dLfnc50_
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
index 384532aac60a..1c3da6aac2f9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1449,7 +1449,7 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1467,13 +1467,13 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1997,7 +1997,7 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2015,13 +2015,13 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2507,15 +2507,15 @@ xfs_bmap_add_extent_hole_delay(
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
@@ -2658,17 +2658,17 @@ xfs_bmap_add_extent_hole_real(
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
@@ -2903,15 +2903,15 @@ xfs_bmap_extsize_align(
 
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
@@ -3001,9 +3001,9 @@ xfs_bmap_extsize_align(
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
@@ -3968,7 +3968,7 @@ xfs_bmapi_reserve_delalloc(
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
-	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
@@ -4101,7 +4101,7 @@ xfs_bmapi_allocate(
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
@@ -4421,8 +4421,8 @@ xfs_bmapi_write(
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
 			 * check for 32-bit overflows and handle them here.
 			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
+			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
+				bma.length = XFS_MAX_BMBT_EXTLEN;
 			else
 				bma.length = len;
 
@@ -4557,7 +4557,8 @@ xfs_bmapi_convert_delalloc(
 	bma.ip = ip;
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
+	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
+			XFS_MAX_BMBT_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
@@ -4638,7 +4639,7 @@ xfs_bmapi_remap(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
-	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
@@ -5638,7 +5639,7 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
 		return false;
 
 	return true;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b7521c1d1db2..fa11e4c1cc41 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -886,7 +886,7 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for ondisk inode's extent counters.
  *
  * The newly introduced data fork extent counter is a 64-bit field. However, the
  * maximum number of extents in a file is limited to 2^54 extents (assuming one
@@ -898,7 +898,6 @@ enum xfs_dinode_fmt {
  * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
  * 2^48 was chosen as the maximum data fork extent count.
  */
-#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
 #define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
 #define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
 #define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
@@ -1635,6 +1634,8 @@ typedef struct xfs_bmdr_block {
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
 #define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
 
+#define XFS_MAX_BMBT_EXTLEN	((xfs_extlen_t)(BMBT_BLOCKCOUNT_MASK))
+
 /*
  * bmbt records have a file offset (block) field that is 54 bits wide, so this
  * is the largest xfs_fileoff_t that we ever expect to see.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 767189c7c887..409be63fd80d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -691,7 +691,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -748,7 +748,7 @@ xfs_inode_validate_cowextsize(
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
 		return __this_address;
 
-	if (cowextsize > MAXEXTLEN)
+	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 6f83d9b306ee..19313021fb99 100644
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
+ *    the realtime bitmap: 2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY)
+ *    bytes
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
index 73a36b7be3bd..36cde254dedd 100644
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
@@ -840,9 +840,11 @@ xfs_alloc_file_space(
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
index 093758440ad5..6835adc8d62f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -395,7 +395,7 @@ xfs_iomap_prealloc_size(
 	 */
 	plen = prev.br_blockcount;
 	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
-		if (plen > MAXEXTLEN / 2 ||
+		if (plen > XFS_MAX_BMBT_EXTLEN / 2 ||
 		    isnullstartblock(got.br_startblock) ||
 		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
 		    got.br_startblock + got.br_blockcount != prev.br_startblock)
@@ -407,23 +407,23 @@ xfs_iomap_prealloc_size(
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
@@ -471,14 +471,14 @@ xfs_iomap_prealloc_size(
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

