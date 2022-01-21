Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AE2C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiAUFTm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:42 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40744 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231174AbiAUFTl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:41 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L043Ok017784;
        Fri, 21 Jan 2022 05:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=wn/tD7mSYrxMmy1EU5ENfB5SjmSnBXqM+Wo4odWZ7srLzWt5dJ8C7ipWRVoXeHfddzfI
 ngc0DPXBeqSSZHw2ADKGbvWyi3doKOlsvs67ANsa1ojt0f5KnQSgjAupUiHK1dSRgK5S
 sCjkXfg+R3/sjDcUSL/ZNunVycN9+DWuuQvB9BdFpNdgQf9gBDxaJf+8XzMyT5zipe/0
 f10OBcyEah0Bk1gmNRAHRW7oz4AiXSy7VyP/a/4FX8GNg3iLI0ATgIbiYrcatzfhyUnJ
 RivObYQ4KaoEeiqmf/uCgglbSFkTBrYtwUzouuVzepyZM2TbGR/rHFC2eVSkqycIKFgO 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyc0d29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5Gg4e081935;
        Fri, 21 Jan 2022 05:19:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 3dqj0vbk08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixWR6neTWyEWOlCGmAR1EUzuD7tOnaHkAuCn9kzIqHvkgzG1UhcWYzbDIDkDnX9ks/HbzG4YkhOrc2EnDkdychd5ytkx8yqIWsVjU6HDzEFxuDquDRy25qh8s87o8CuMvbSk1A+S3v+RZkAc4J3y4XhFcGm025YmTklOwlJpZz/kelwfTmfWqnGGFQxa69e3uTixjWbf2BfrhklX07TNz33/V52e3NM9tVMzmoREb8jyWuJsvB3uEt3DUbdYny8LIIAFlBy55rWm9cmjgDaHrbXIBt1me7t3is2+aE2oWsl+kt14/wnXhWUoCnPM0fsrNHKli2fmFzRKeeW3QBxYRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=HDu8VfBhmQYtCvHBniqIjebzUqVpcRoZa/RR+NJIAV1a2HVFb7zCP2Jlrz1MVQuM9OaGr1wGdXE7tu+Cwlpppv7KBhILfvdAHTEY9BayXnkcmZb8HV9DLGKQEMmwX5AAYqOQu/CtI6PrQGp9DBkqo/ShT1qVrTYFfygDLG2XcOi3CLSik6P0QfED5SiMECpHSqL2Pbt2avQl8LV4GZg5M7i/Ib1NtoJRq6LUHeT778/OAi2VNtn/6/E2sqaHqYmNNP4eULJxYVI4uxi9PQd7hm9uw0H/W6nJqnnALfSPC1otm7XeJoVqnFA/hZ+l31Sn0qcrX1xY3AavdNTd71jwxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3lMqiif1aKxdn3iKKw48ManH7yGbbzd4vjwDIFeWlo=;
 b=Xakas4C24bWYPrOEfHDVgS9UHTZ8PQEzyXsjbRKBZnYHuxu/uvwOrL7BQFsbzg00wFacQ0qTWp7Y66Pveifayt4NQYqCxexXHP/D8hgquriLWerIgFCuGhZqcWiNwsLYBm2RZrUTmEm4sX2Kjy8YCdt3wFg8ozYTqva/GyfdeEY=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:35 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 04/16] xfs: Introduce xfs_dfork_nextents() helper
Date:   Fri, 21 Jan 2022 10:48:45 +0530
Message-Id: <20220121051857.221105-5-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9da37860-3504-4811-41ca-08d9dc9d9caf
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1236407D47CDFBF05AD9A011F65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xJnjpNmljwYuhCmokGoqYSrmXVZFvAv+EIvBQIxzQlYnJgiYrJAy2PAHw7pTQvAIUeOn8OjHToBcp7g9HqtQv75FEHvd1S6nmETlgYj/GRHD4OM3NZ68wP3b/jcrE3TQLoDcHKq59yHePqXbQ4/ceXwa/pyPoC1EvYM3728EGaohMT9kFDWDrCSHH+YzEsJKyRX8cy11b3ANSAio39/l1lFz5Wkr1PqVs8g8RdURTrmxXDG5RGx/8MVMohJy+EstoLfK8kOX3zZDUv/fwsHRA/g9qBwccI3Ep6qm04AtAyIRu+aB+20nY/xKyE14LP/4daqXZ7OnV+mLGXgDQRV/l8ISen46zNnVDW+0SjLzA/GTESGjCqduw5RpVPYSD15xHkh2QZM10ApwOeLcAUie4Y4FOuBE3rZ1j0bTw87ACtX2j2mVMRnaKsRNOZ6t5Se3yi2GE9Xajxll3yVPFsptuEL3Mj1vPX8oJriWsvlKYP/IAzrETrg0aiy3F4Bz3eODbErf/eXp5s1cv9teywuisrM8I4DeNx3AWEuqu2/HV3QDoMElbXonr/BmcYgqRXGvWrS3D7g31njlOmbjG1YsTE8l3zvKMTBhExFpBH2ivQchP5s435Guclm4Ap5BST/fzS7pW+IX8fA3Ev3aHPziuQzMXGgrx1q5X99as5tf2TEYXB68H/xQKuuO+4WXkdEjUKVP8Tb27xWVOTwd5NTM2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(6486002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gVlO9IlFPYSPrUGgv3ODWSNSRmjSzWZ0l7BRdL2Oi4WvHVQIfQjJx4dc7KkI?=
 =?us-ascii?Q?hCY0WmEG+8wtlFmHNPvdD9Luz5sMQNVYk8gRhh3vb/4NbCTfUMEKIwtNweYh?=
 =?us-ascii?Q?0/J5ePc8twz+bJO1VgAmWQHRTNoU0vVy8ygWN/3iEiHIdftmtnXaPC8g6E8A?=
 =?us-ascii?Q?1CFaeV+2Ym6vbzn9y1rPPNxWljlyyCImNJIgX9JIC2wX/llNCvqfUuGw6BWX?=
 =?us-ascii?Q?eFVxO4jGkf54GcT84blTziVpIcp7BkuRP6LQi/Xhw5EooYvJJw6mGMRue9HD?=
 =?us-ascii?Q?gFzTJffIwkSdBWd26QHQn4o6Xf/ZUKxvIjBNu149CmVa9JsgM3VEeXbgxFhP?=
 =?us-ascii?Q?ZfDrO6xIf2yvi1tr6NQ2iO1dRvqtpgO1YlQVtnNuqsRz642oZe1OrqDZUhMh?=
 =?us-ascii?Q?G2IkiyhsXon56tVlKDYNjRPbALheR7UQ3JyFqeXsOyqzMF8AETFG1pU6OFsz?=
 =?us-ascii?Q?rjH95VjjehG8sgbbR8NqWhIdV5SNh6RFlZbZ/NF5KP4JD7kbp/+ltQA9i4Wc?=
 =?us-ascii?Q?XisvsI7aF3gnnWIgkszVh3Wmoic6Fhu7vTd5cWNSfOkh8fFiS+yfWfJf8oKw?=
 =?us-ascii?Q?iTvjorqiQsyEt/m4TkpQmJjB6ZjsnxATC5JnyuEfd9GN8hc6MeOYOdVsZ1ZZ?=
 =?us-ascii?Q?BEY+18yMoQnGmzYQFZqL83JMEdor/nyScyVOfnlQ791F0egsrPMJ1fF72AQM?=
 =?us-ascii?Q?X5mcOIv8qBDJVNSgZ5dRiQlZ1WbqN8M7JUUssMYXTk8ujYHSHD/BBf71CDdf?=
 =?us-ascii?Q?nCs6IyY29nCsYOIz6uR/CRKpGaqePhADqmtz4mNnW1XLYMQaQDSymeS0n4yw?=
 =?us-ascii?Q?Hp8m9IcVKG8liECd5dN4kjkq6qPvzjZAcFI4nsZGUyhfABGNq8OYBrQF+m/v?=
 =?us-ascii?Q?gvqw5Z4g9/j0Lc6uAcCVk3p337ckXraVlnZ0eDMHiWp3Gna8gSt4NKtprAeQ?=
 =?us-ascii?Q?HHvIVnB4XS1r6JeNZfEvA1EW8q8i8nMhtdh5UnsdRVVYUFJtsIZqLidIByUO?=
 =?us-ascii?Q?Rfy2iQ9eWKf469vNCnL+JW4t6XlStENFcJtYNkgG+VlZ1qLFp7R7WpC5cL2W?=
 =?us-ascii?Q?YwWaPKXFv0YSO689ZjNhdBTFRy2eSi+1qq7Fz3Z4eM5NuYk7XCu5L30WcTfj?=
 =?us-ascii?Q?75fep2TLMMAQzKs0Z61lcETU5wroJPP/gQ5A9j/wKtiaG93c+6XVRFGRFgLH?=
 =?us-ascii?Q?J/2sQioZB3tHt/lGnPebHZFNEYJwiVEU0Jgw8c6epA/A7W6VIn74GXak5Szb?=
 =?us-ascii?Q?kyoTUBBYXVzLPN6l7fX8jX6mgw9zJ+waA6oF4+wj2VW9x0uSpju7qEYLJZ9s?=
 =?us-ascii?Q?SZTJ48M3wnv0DUfDIqbHzcp4pc798ujDWfTv8EGAlSEb7kRcxwDkg89hfdkm?=
 =?us-ascii?Q?askbehYBlB2XToalehIcJxGSgrikTcoSVtbcdoPnuKocz5tnvFVTO0KPKOa9?=
 =?us-ascii?Q?ybBeW/Q+ZBLE1SCMoPS3n3wHqKM25Cjh3fCnILBLeBeaiD/3oORnqInXPHV1?=
 =?us-ascii?Q?IcY54uKJgN9yrxFSy3niekAsKbonB3j3K9tWlkBnCcFD66sNOYQOsyLIugAG?=
 =?us-ascii?Q?036jKEnFpuV+bvtLSH9M4ROLUuQ3GrisPOSOTTCYiE8nx63XTXYQ2oq+QpOL?=
 =?us-ascii?Q?+FB/Fj5Kk2rvFUBN22qXL5g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da37860-3504-4811-41ca-08d9dc9d9caf
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:34.9623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBeFwnk9b/+C3BPt3zZ8pawJ6No7eLgVgWZ0lwz5tMLbXzIaiDqJwsKQnGjMVb77utATKvXWop/9uwdDrEUgcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: 1qv9RY2qGitj7-fhIHum0soKHjBBgr_E
X-Proofpoint-GUID: 1qv9RY2qGitj7-fhIHum0soKHjBBgr_E
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |  4 ----
 fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
 fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c           | 18 ++++++++++--------
 5 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d75e5b16da7e..e5654b578ec0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5c95a5428fc7..860d32816909 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,9 +336,11 @@ xfs_dinode_verify_fork(
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
@@ -405,6 +407,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_extnum_t            nextents;
+	xfs_filblks_t		nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -435,10 +439,12 @@ xfs_dinode_verify(
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
@@ -495,7 +501,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_attr_extents(dip))
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a17c4d87520a..829739e249b6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -230,7 +230,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -295,14 +295,16 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 2605f7ff8fc1..7ed2ecb51bca 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
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
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 87925761e174..edad5307e430 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -233,6 +233,7 @@ xchk_dinode(
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
@@ -391,7 +392,7 @@ xchk_dinode(
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
-	nextents = be32_to_cpu(dip->di_nextents);
+	nextents = xfs_dfork_data_extents(dip);
 	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -408,10 +409,12 @@ xchk_dinode(
 		break;
 	}
 
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -423,19 +426,18 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	nextents = be16_to_cpu(dip->di_anextents);
 	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		if (nextents > fork_recs)
+		if (naextents > fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (nextents <= fork_recs)
+		if (naextents <= fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
-		if (nextents != 0)
+		if (naextents != 0)
 			xchk_ino_set_corrupt(sc, ino);
 	}
 
@@ -513,14 +515,14 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < be32_to_cpu(dip->di_nextents))
+	if (nextents < xfs_dfork_data_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != be16_to_cpu(dip->di_anextents))
+	if (nextents != xfs_dfork_attr_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
-- 
2.30.2

