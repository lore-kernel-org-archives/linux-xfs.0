Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67722C43217
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiJDK31 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJDK3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4438E36784
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:29:17 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2947Ucsg029880;
        Tue, 4 Oct 2022 10:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ylzL7FG6QI4xWbrJhRXITolGfX/z5tkx+CfP13kC5DE=;
 b=TPWqs3wDFHJ8jFF3vgUdXZ/Mz8I64oP3N7OXdfl6LIGUUWYQBBaXzZkwfOyhd1IrR2Ce
 orVb7lnj053tz2KeGvp9kyosBBHaRV7xUNJDIexq7lXJVUcWTDWil3UQDtjEjs0fAARb
 j/bG3BnnGo9uxbo4oxqcQgObKmuNBCAHML0uVZ+KH4W9M4iDwaj3vB3EGjTB+b2x8a7V
 bAAgznymQSi01BbkwU1WiQqffBbZ2ihL+B+bdJuFQYxqtUk5SQ0ueFpoqJUDiTwPzFz5
 /zYan3QLxHMPa4loxdlCrz/SRj8GU8cER+4dABdTuqTH2+6YfUjUMvuohzRT2mDmRl4Q EQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2p1bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948B1C2000940;
        Tue, 4 Oct 2022 10:29:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc049nk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jy8Ym+BOKSOTWixr/lNmuD/GyVMKOb+ta21kZrSwFkVOjQ2X89+iJ4tjNheqf76sS4EZwLunMjwB39p1f4ae0WHJjav3XJjaCukOV5vMx31qaIA65zz2ncuiFrsbdGfIYTRhbx5AUa93eI2rWKidOc2/D/dGs/q+49oQZa3SfKqalEf8VBUc0XONQoQx2mR7z1s7Qmo3QZ9LFjDY0ylqstj2DHBrX9fQwsVGJi3i/40wbrgJAJvAOQY4WVWesJ6BKnvAtxuGooUiuCFfwv5kcaTiirQ8DxQahG9JyHyu05ISHLD/0F29yn/VKm/09Prr0ljjFebOZAzujZnquA4F4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylzL7FG6QI4xWbrJhRXITolGfX/z5tkx+CfP13kC5DE=;
 b=bjFOT+9SBAfqJZBOokii+GnHz5s4un4bIsDXS8hboTum27ND5knbvLUR3fiiPYKJaDC409gLSxMi9PLjKnhG7cM5+rtQEb/o2U2mrI2wJX0DAhGskcShV9rJH1J5XHVRfephbod501khYc61MA1GpCE16nxfDKIK9R1Tox8Y5IE3E6fsyQNsf4zihemuAN1KogHFYMfM5LSD2koa7THABSa2G7SMxLAJ+aUo4d7JIP4x51CNkj3c4C11hxWq1CSrdMyohgPHo1b88p1WGhtLT0MyUlsv7xCNfOjsd70T7xLT2c3tCRxc+AVmr+XCz+I//O3hopv20JqTD5gLIT2C+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylzL7FG6QI4xWbrJhRXITolGfX/z5tkx+CfP13kC5DE=;
 b=t/hsdxgGRSbjIKtmAk/uDucGl3s8V8etBnVM7qkwC4y+KKCcDaOnpVObCB24d0bIwSGLFZPshfcrFAenPWBQbfdgZdpq4XKlvbTf81I3cei0JCRqryWWdKwQHJ9CAPoTAp4lVjGNNLHCKCfq7OhfIHUzYNRlXNK0Vm4v1d9nDV4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:29:09 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:29:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 06/11] xfs: refactor remote attr value buffer invalidation
Date:   Tue,  4 Oct 2022 15:58:18 +0530
Message-Id: <20221004102823.1486946-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0182.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b11b2f-5dd0-49d9-dcd0-08daa5f34606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7aZ12X6ME5o6yLRGK01wzo/T/xtct2PMYEwPOFjLQdlcwnEgSSdmlgBNaPKWAIaBN4NjR8+sqyyLAptY4Z/Ca2fJ8aQQWWmulidNNlQ2IMAmtdd9S5De7V5z7yr1opUdPa9AibfCWDMfNkREWHEDWj4Z/IFcOYKqM13o/+efOSigUIb9tZL+JK1IpWKsiJncCUbh9RJWi2GVpF+1p+h6HEnukQgStNXk6m0QO2dgIm8XbySnz0lY8ZoeLEbvbuuBCPGXvF/+JXavVF6mXxRgUkhX35ZgVDEIy6Ujg1Z3w/kQn/9VbJv56s9rWIT0u/VWYa/DVeSenpPNIuRhXt1nX9+XL85cya1TGXuO4En0lp3Gn1L73LugsExX8+IMIIP5d1kBKxrRlpTuyzfSHrter6frxSkPzQXgA0eKHAYhVnrJbzA7SOg8xmF5NkIiv0edB3Fe3p5WEB5aNaUgwb+wEUWhHgGembHyqGlTB1010E6iKl/TVKrQH5AUma4G3Lbo77pduxvZ2iD0QnYG4xh7SwJKJ+9oJSRTbf20oJYGm4XNJAVSLoGbiLMrKClQIyj3Z4LjdMs+uUVhHYD3WVXjetmsMVH7ANaAsylMjKrqnzZu0mxVVJGgKAupNGBXKMlRXPnJnesc2SstY9yVhu+kS+CjiRD9b5UFs/imLJU5ECDgz7PYPKD3pztRCokL0UE1CXlxcN5cD0q2R3fzrKajTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IugO1uw4jdEaRRi46lK6Tp04k8YhDMOqdiVS9/3NXTcpxFPXX1Ebt8JZ6uq/?=
 =?us-ascii?Q?zaEi7HtGeV0RjkM9kxIY6hNXEukOwEW1tbVa1KX2hwlQ/WaUSQbhxslsPPW9?=
 =?us-ascii?Q?rC9cmxwsZGhx+tZ/a9FtLmRDGs8QS/hi5QPZ6pIDomlYfT6pfZIgGPSGzw4U?=
 =?us-ascii?Q?8OBkM8l9nAddHQ8/zeFnFjmTuZVrdo7khb3klAs+ZZ9vw8mrK18+WnpIXCs7?=
 =?us-ascii?Q?Fs+ZPYfhOOjBhArF4/VO6GhW+cQBZXL5xYFog8cs70sKywOihp9YNcEXM0yi?=
 =?us-ascii?Q?EaDwrPX75jLmK/ueZx6sA/B54VnBt+SxWRl8qDacnhrLpQgAlEw2yKWhpa5X?=
 =?us-ascii?Q?Pa4HJPGfgSoX/9SPcdE3plIAq6AsZpa5IlI87l5cjXRvbG5vud1CaX/3KL4c?=
 =?us-ascii?Q?il6xryy0NrEUF6tdog27e74V+F5DRJT5uI2bm+JOUv6P7X0+Nlc+CcIi16Qv?=
 =?us-ascii?Q?xWD7UArsmn2vR64plNMmmIQbgvF84ifu246ZbBHIf+gGHor8st6gUhbekdyT?=
 =?us-ascii?Q?6AQSrUI7lP922ZAbVEzaxYWPdFsDrlsLobBwmppFz9JTX4At3eoiC/E39D/J?=
 =?us-ascii?Q?MVvTCHUPeriZSKp+SETnoUsUJDn5BKDBK/Y6NA3alWSafQyVlXmHZ1A9ptZG?=
 =?us-ascii?Q?Y5eOdOts5uLLp1MLeLU1JeCjRiClQY5N6y17/JDMUtb+UOp3EBTC2xUbBWHh?=
 =?us-ascii?Q?uaiwHbZ91S0/lxgWLcC3zqUkJlkYs6/G2ddi8ZYMZU8SwTLwNUXmjPFfMrPg?=
 =?us-ascii?Q?JkTSPL98hldgSgV/x/zIJMMSSqxOYEafDR++Kme8vPv8A4Ml9Sx4UnPORUxY?=
 =?us-ascii?Q?5I9Ivi28u0KtbCQzONGAmr69vocOUXEsSv0HdRDRm8OuiDu5J2erqAxpWGg+?=
 =?us-ascii?Q?qDjJZ43gFMUSy5hipFUKdfyFEkMyGkCLpLhEVzcISxpwFB5CCencpWaV2jla?=
 =?us-ascii?Q?0Cdxs2mf71NfEFbFXtwMVywQf3NpqrdIX6rriB9ht53xLS5+6aEMa5cMij3L?=
 =?us-ascii?Q?Mx5zaRg2nwp4X0T00AxLsF4MX1gsTllNrbYI/t3+aM44lXAyFjA3cqI/p9x+?=
 =?us-ascii?Q?M7/ftq8GF2DGglfUpU5JwgjfY/ZZMdXAhX9ZrbQic95iH3Ul/3srrYsrp56A?=
 =?us-ascii?Q?nfXvffXESZavPHZAJq5XC7Pp3fDztpgUlfN8DHyQ8xrx+55gyQnmxEspRHjE?=
 =?us-ascii?Q?kUnLa8mktVfhh4xQxLiq40RyOKEFWOzk/IqtZzF3lSIEJZu2y5ovWzsBCrf5?=
 =?us-ascii?Q?KGXfYwxUhE8pgz9Bm9aPA45U6j204yVz95hJbqi/5aMND9stOglYeQpvAPBR?=
 =?us-ascii?Q?HKBaaNfHa4flPKYCyCMhXYPurJQmRkJt6JccjlAJJf3qvN793SqVIgGlXn9e?=
 =?us-ascii?Q?MipqHdQsObplUlooxEkG+bTmJRtT2ndOaxykadc0KpOV5wigt6CKEIIxm7nY?=
 =?us-ascii?Q?2lIX1jBJ4WtY5sweNf2ZWV3djQawN7JHWe+Q8gHYhi+kkb1VPBiQgW3mKZLp?=
 =?us-ascii?Q?LWgxazeWqFTs9ZGd2VIqdrG88FZINSw7A4vVd27dYRzMlCZxoFVIU2RM+G5E?=
 =?us-ascii?Q?OD9GNN5KVj2YVW1MPb3SB7DV6VfEk6n4lLErMQpefhnUZ3Uclip77c4W1ovR?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b11b2f-5dd0-49d9-dcd0-08daa5f34606
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:29:09.7482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DzKtLDkxO0cY8vrLlQdjX/JzkH2KEsNT17YGZWYtmRJ+6wIo8ZpkiJXBZRzB9TRue3PmL5Vz1uLtwiyO1yP+eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=976
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-GUID: 9pS2cPTcntTmh9_EEC2bb6v4IA8douRa
X-Proofpoint-ORIG-GUID: 9pS2cPTcntTmh9_EEC2bb6v4IA8douRa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 8edbb26b06023de31ad7d4c9b984d99f66577929 upstream.

[Replaced XFS_IS_CORRUPT() calls with ASSERT() for 5.4.y backport]

Hoist the code that invalidates remote extended attribute value buffers
into a separate helper function.  This prepares us for a memory
corruption fix in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 48 ++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_attr_remote.h |  2 ++
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3e39b7d40f25..4e5579edcf8c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -551,6 +551,32 @@ xfs_attr_rmtval_set(
 	return 0;
 }
 
+/* Mark stale any incore buffers for the remote value. */
+int
+xfs_attr_rmtval_stale(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*map,
+	xfs_buf_flags_t		incore_flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+	       (map->br_startblock != HOLESTARTBLOCK));
+
+	bp = xfs_buf_incore(mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, map->br_startblock),
+			XFS_FSB_TO_BB(mp, map->br_blockcount), incore_flags);
+	if (bp) {
+		xfs_buf_stale(bp);
+		xfs_buf_relse(bp);
+	}
+
+	return 0;
+}
+
 /*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
@@ -559,7 +585,6 @@ int
 xfs_attr_rmtval_remove(
 	struct xfs_da_args	*args)
 {
-	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error;
@@ -574,9 +599,6 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	while (blkcnt > 0) {
 		struct xfs_bmbt_irec	map;
-		struct xfs_buf		*bp;
-		xfs_daddr_t		dblkno;
-		int			dblkcnt;
 		int			nmap;
 
 		/*
@@ -588,21 +610,9 @@ xfs_attr_rmtval_remove(
 		if (error)
 			return error;
 		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
-		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
-
-		/*
-		 * If the "remote" value is in the cache, remove it.
-		 */
-		bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
-		if (bp) {
-			xfs_buf_stale(bp);
-			xfs_buf_relse(bp);
-			bp = NULL;
-		}
+		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_TRYLOCK);
+		if (error)
+			return error;
 
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9d20b66ad379..6fb4572845ce 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -11,5 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
+		xfs_buf_flags_t incore_flags);
 
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.35.1

