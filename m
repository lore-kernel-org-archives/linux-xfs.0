Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9462CC4321E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiAUFTm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:42 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38878 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229608AbiAUFTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:40 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04MqM016482;
        Fri, 21 Jan 2022 05:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Jn9g1OToqf5eYnzOn4oPzopnlEgzyMI9HzPFjzEx+x4=;
 b=Cchj6vf/wHar5VkhZnKb9LiiaHplCeFwYcCtZh+MAIJU6x/hx5aauhYnRYarcYl71m4c
 /k70eCYy23imRkmieI6BTd55vX9O/ID8hwJ6Y5SDPbElRY8fBs7JiiR/gZFS6Npna8WI
 Si9t9CtT3qYWWv+FuUTO1XPcCORkq/o/Umu38+MYa0Gg1uAf8vJJ6RxoGHl3p8mUxLyn
 L/+Q8x016kF4xt/jNeBBahqc9WfRxOz5fbq0Yppry7x/vmCQlV3BZc5cruJdD7D0c8kx
 NRnWiRPh+VkjvMk8y7/VqTaLf0BVDsSgYUE40AyIrWm9vathECrENDtNio/vThaj4JUD IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5GVYk190279;
        Fri, 21 Jan 2022 05:19:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh02g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jk1d2ovCZAubcWCrlQ6/6zGXU9DeUZcCFsDjBJzZGjwryyibRhlfZWie6uwqPvezbqrF8n3E9H9WhJK0DrrMCqbZVFEKNIcUPEOstH7sCHmKZmWK++4x16M/n55trXC4IrNNZTBEPK67uxXK3pfPRq5B79/ZyxnpZZ5eoEUaylEkLhFEPD39lt5BEcf2ZiLQMAYeSiNT2tvXfNuzJy8qgyic7sfe6RxzXvH1cubm3O8Z+aH8WgBKToQ3fMjRN168Qn/8zCzvlKO6L9S9EBiSYVuFBxHp/qK7UqvCRewic5Bz7nbG3zH9rgXjTxp5cF02UMEg7kFeEYqt+ONS+EdCHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jn9g1OToqf5eYnzOn4oPzopnlEgzyMI9HzPFjzEx+x4=;
 b=BU1Oabe+ASAJh0mstuFu3w4PGpPbEMR/iElJYr2U8/vydBYuTc3Qq1v4pwHXVU1DGQtG/Bz6Z4V7kisDgFodaWYDSuAQkzrbuFxYiZQL5Qzx1bwPlPABpBahguW7G0bpX6deNMG7DbAlHpD899s3csZGAqn9Rz1zUGOi++LknBqEn3V5fT+Y2S/jonwOTJ/xPr3lmKlIjsVVG35dDjqm05PUFBgAIRoKWpPlDvuovarhLRoZ8guEbUu/puC0MT1NkqAYHvYtv9bErpbR5OqS/PcjCsdSsqqpaQUA/HlKaF0v02TZdKT4pSYL1vFXFyoUJ32pGQ1A8CmUjPh1I0qXNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jn9g1OToqf5eYnzOn4oPzopnlEgzyMI9HzPFjzEx+x4=;
 b=vGYypcwpC/FP6/rHf35mnx+hV+BZ4WgLIvSPwwYbR0LoOzyOJ4XpUfDGf7mOVCIv6Eb80zDClApzV/dlLv2fhZzRkfRyKWY/t3pM2Ak3KxPaLeX4dvAkfzWk/BiNwNJ+JKyqf+3y29l6/cputVJXmj4KxxlLb0FcXiyA0CUavVU=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:32 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 03/16] xfs: Use xfs_extnum_t instead of basic data types
Date:   Fri, 21 Jan 2022 10:48:44 +0530
Message-Id: <20220121051857.221105-4-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 21d8d8aa-ff54-4090-177b-08d9dc9d9b66
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1236589A923172F567F76FFAF65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:376;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ph93uBbRA0KpVW6hVtpdpiJAyD0xtq5FzPI7gPnfetH7H6CBsvL57mSb5Z1IeLFsXNZCsF84qCwx3POOP6+YoaZk8+X1wkjgBgNUkLlrrjgKRUouikugsfXI8TzArEPtXvcd2eINZO02gU9bSBt3Xx84LsIGXDSuEuzMLcy4sHMzOypOBV41PiMbWALTNWCYMVz7pCkD8YmvEmDIPr/hYkkxwIBbARz8tAkcG7+GGdoBhCRLphC5JSE77bHgKsK/V8y3zDWp0EBsVOMCuvHXlXkjJYE37rXkmwMpzdf3DLpPl7xqs5Uq+JEumbJLrz4lZcYiXn9DCJKRd6PmhToANdvt6xpc4XLXv9nxDo8fMCsvvf+qCUxzzPtTtElfA6rCMCefeGZuNtMiBLUlODuEgkeEz59tenOauzUBg75noDK0B/ps3vH333o4BGkKLb7H2PbTHD2vosMYobBgcDGk7U142QPst0TmFxJFnNuJ4XLquH+DRsO9RN3giJx87fJjMaqrZ3ShHyr3QT3nqHqQXp0ygGlZV5Rc1kGVCVCHh4LK+ILH31OlaOXm9NU0hz5zwmWvEjT05TxAVzmvfOu9NA3vDL5wbMf6BW7Ecd7WsJnbDz23cArATCVVNNbh6gN8h/R6Axnf4ShL90fYfkIFxMt4y/7fyxfT3pt0Ddnja81w51CqJog483ER3KboQXESxKqPk2ZkKp+4FubYg+DuLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(6486002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CpFWA1FK1ruVNE8SakSkeON0bCOanbMn/X/ELjX4jFzsetrDNgRdpAryJUyb?=
 =?us-ascii?Q?GvRfXwb0t0ENd/ouU2RH5k8d1dxoOeZhaPWNZ1rtSHj7xMM7SGIzMcNSmZ7h?=
 =?us-ascii?Q?mo0pE552LyeatTFnTZH49BainLuyOtw6saGIGW594S5+0p90Zdf3RJcGRgNB?=
 =?us-ascii?Q?IEwdonfNUn6izBbrLGThRQo/S7WxH9oAyjKlL+MMJPShYpEq6JZa102FaPBt?=
 =?us-ascii?Q?MrvW5FQMNbyl6Lyv4bRxVlqdCb/a5qiAH1I9yfsEItj/JQwAwONRhHCOWdxK?=
 =?us-ascii?Q?b6Z5TCS+/5jxKsLAgJ42CUaIkqpg3v6wmXcZpFr4QWlgfZw63m07ja8Rfz9W?=
 =?us-ascii?Q?+CwbFy9/UAtqH5YHiUEyIUt4o6kWbmCUcYp4AAcmdSDbNxSEPR+wfXm0ChJx?=
 =?us-ascii?Q?/kL55PAbHLb70S3HFmd7+bj95hjw53jxs4v+4sn+1jyRW56CvLgtMVN8/7hR?=
 =?us-ascii?Q?8hDpUlE0OC4kVW1/IZK5nW/ngv1qpobkz5rQ66J39fouh5ugO3JFvhqm7S0e?=
 =?us-ascii?Q?0GTbc9n1jCK2m1SF2CTLH38q/TvMoMg0nrv+aWw6ifyzLdKvkfoyZBFojKTp?=
 =?us-ascii?Q?Jslgo0pMYDNlcXdV/Jl05kNVH8lDa0whbapXSupGkDot1u+cvrJeV8hn/Zja?=
 =?us-ascii?Q?fEXQeQCTm8GWXPt5O0opOEm3lKtn46dz/fizzLgAQtNDkOyHlhwM4vHPcMUe?=
 =?us-ascii?Q?Qa4iTQ37OLxcfmbCjhCCBIKklJRTo3IqdwlO4nGd0uW4nGAkUsemg+Rwqedc?=
 =?us-ascii?Q?r/yw4+DGJix1QvG0CwZtxnxuwAgfLYqVtvgI8+OgosDX0jOS9kmWWjMfL9/k?=
 =?us-ascii?Q?3F/hAFWLDt2kdeRKd0LOknCdhfVl8eSW1lfJ0njsjk1uVkvK43XVf+Vpz/UO?=
 =?us-ascii?Q?K1RWeM0XuPH4IxH8eoDTDLGgzNP+QCRNAQmyda5EiSK7UJTfAz6VKH4p/lTD?=
 =?us-ascii?Q?MvO4G2kFkZXZ1/Dt3TFlOMnClWT6P686WpwIbMU3f6LsMuaQuCAxJqAMHwn8?=
 =?us-ascii?Q?pumjVR37RrsELJvMBoxHphIb2HJAL9Swd+cBzrDJiY7Apcm027URNeJKRmip?=
 =?us-ascii?Q?w4xhcFrQxt0z7rhHAbMHvx60/HS+oEU16U3ku+SHm7hQ2yDrtU22ihKb1kpS?=
 =?us-ascii?Q?LYwac/EIkxcJ2cv6QsOha6Aa8BUOtD9JgqYuCZLF0z1xKvA3EunLEIs/NeJX?=
 =?us-ascii?Q?peUoPU6VidfbY+rHWcSk1c1LDLE/3y8h3eyvKozoUFmsoDV8cwAZwCPbcveT?=
 =?us-ascii?Q?hluGR+1MvJLIG1wEUVfVMiLoGh+LVqztwfwopTLLzXB5xYIgByzL+PpoWze9?=
 =?us-ascii?Q?nA/o+0Yn56qD2pXidG/9noAzUColFz2unv0aZ1CfDJSe11eBasnpl9M28nvE?=
 =?us-ascii?Q?msh+7SLLKwTtfxxfdzqQ4DftnYkfETLfQETNcMGNCnR0SJ63cKWxvBuCcF7V?=
 =?us-ascii?Q?WkDL3+2JBnux399iWPgC2MvNTror1zT5AVwL7Exh0en8mOwYOHeVz/ZRzpBQ?=
 =?us-ascii?Q?tb1Mx/rH7XFv54bDTrgePmYFVp+G0nLazF/mIWmeb8FkTVG1HxSrwXLOemgU?=
 =?us-ascii?Q?sNbTFPZg4E1Me4sNCLLs4AEdIJVX5ETNRzocwAgLnPR7nOCns5wi2VJlREew?=
 =?us-ascii?Q?OGQbWPTLCOkzmYpF1ju4M+0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d8d8aa-ff54-4090-177b-08d9dc9d9b66
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:32.7426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2lgOK3P8Ag/9lqUlq0jyDWd7I2cL0Lxob8+wbrwiAdf+9uXsAJzYDNDJuwMdSalv6bJwUxpP0O54RlGgaNbSoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210037
X-Proofpoint-GUID: 9lfFJUyMz2zk56BcDmWckjo4uIvpdCEj
X-Proofpoint-ORIG-GUID: 9lfFJUyMz2zk56BcDmWckjo4uIvpdCEj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/scrub/inode.c           | 2 +-
 fs/xfs/xfs_trace.h             | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 75e8e8a97568..6a0da0a2b3fd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -54,7 +54,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e6f9bdc4558f..5c95a5428fc7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,7 +336,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e136c29a0ec1..a17c4d87520a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index eac15af7b08c..87925761e174 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -232,7 +232,7 @@ xchk_dinode(
 	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
-	uint32_t		nextents;
+	xfs_extnum_t		nextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..3153db29de40 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2169,7 +2169,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__field(int, which)
 		__field(xfs_ino_t, ino)
 		__field(int, format)
-		__field(int, nex)
+		__field(xfs_extnum_t, nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
-- 
2.30.2

