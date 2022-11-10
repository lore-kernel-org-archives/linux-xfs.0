Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38D2C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 06:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiKJGgb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 01:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKJGga (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 01:36:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C8A2C671
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 22:36:29 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6AkF1018042;
        Thu, 10 Nov 2022 06:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=r+rU5uecP00AYjnu5WErHf4dthFkxmtHMsa3mO6ii1Y=;
 b=Qw3bbw7pXXsnULGoJFX9R97/fX4qFlA7PoJKBQvdzWoqnH44YG2G01KA73C3A/ZMkrTR
 QJsgcZp8IOqD+MbfikKAxEb5tf+IICiogUpeSbY6X3aMFX4Q2+2bGzNdgSU9WEk5i6Sp
 UR+D7q+r8kz3OLneKFUEn0gJC1w6qVXlabYM9M8HwsPrXqI3kzmDyvogr+jCWI6S6lS0
 E0SNDtxjO2gqvdwwr4zKpsGQB8tsFjCB2ZqB6iLsY6UzZsWwbV7U4x1QzjWQmlRWVqyf
 0Wxiswc5R0rFIpyesNW4j0w6Try7ABM4AXEYlQVpIzKrGsbXDkFUTyxRtKV6++fEusnW TQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krut203df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6ORhI000349;
        Thu, 10 Nov 2022 06:36:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsg2cws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alhczztbcRXtBEsUzZbtut/AsNB4EyFT0Vaf5l3Z1MDJ3vb/2Fpaea+xSpwq7C4V5wy4eSa5BnUcrtpyqW5jZzHrPAqX74ZxU0k0iEZOGpuHBBG2xNV73pIDJherdCGw/Cd2/qndkq8wuHb5zlujJxK4rw9q9KSDdBMVBlq2xKvWYxf5F2tBBSDlSCKYBbcKunxYZyNhdWRS67oRPmyzR3f7Zh2n0SLUBd8r1VLws5Iy3951LXu0EpNnPTcUYozIhpSQOXwy+8N3XtJUq6CW46m2FoW/zvMjWA8Q7+sxFN/H7ScGI/6ofrW+5pTEKFwhlVfrVVgQufXd4Gyo388ZBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+rU5uecP00AYjnu5WErHf4dthFkxmtHMsa3mO6ii1Y=;
 b=A+hNCHqdhkjAaLdP58D7fbG3lcI67CKLV4bMwbLQvMJZKaDRIiT64OvepozUkNXXIH7SY3boaBkJtD/pbm5RmQ6irCIloYUvhYTuS+SoH5P90a6/K5yQTeL8PzKQ60H736f9J9R5zXRdiBoiZSHJIUlhvOK4t91CHbTDUklY3xdD6ArCfe6nnYBAbtE00e6i+91ZknA+J6d4xXpFLYgFn2jto1HdmgSSQVcmJFI0nWtMw08BugmQfOC0z+wJff0L7M3SGz7wetSsloBIAB9sXMkEx2lYRiman/PElofV3RJh6PmdkloHY7aVcxLqZtUite+KVJ2Ny4M31e3fUuwS/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+rU5uecP00AYjnu5WErHf4dthFkxmtHMsa3mO6ii1Y=;
 b=edFprwOkslhM2YkKZ4NVUMYsGCz9qB+jRn8YfyxCyS/og+JtY+/pMbcbJsL1ECBsVArdZgZTD2z/0erkd6UqmXebVOnuBd3iMOK02yt/jBYW0nOTLVCg9J+1/YHuiL78lEMB7066r6Ag1rNGKPsAZ8ltWNKteAVkRP9OCdU41Z0=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by PH0PR10MB4742.namprd10.prod.outlook.com (2603:10b6:510:3f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 06:36:23 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 06:36:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 1/6] xfs: preserve rmapbt swapext block reservation from freed blocks
Date:   Thu, 10 Nov 2022 12:06:03 +0530
Message-Id: <20221110063608.629732-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221110063608.629732-1-chandan.babu@oracle.com>
References: <20221110063608.629732-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0111.apcprd02.prod.outlook.com
 (2603:1096:4:92::27) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|PH0PR10MB4742:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9936b0-1f56-421b-ac03-08dac2e5e27e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pUrYNRFroqO49GDT/o6efTeX32S5igF+6rBZaOoVM1lerggLlgGNPCEU9F3s+rUJPn5EmCrEQA1E3xO2JPshh5MJ2wFMppBAmczxotqHFwoyflXr3U7k1eCbzZxgMAd0eQAi60BjVGqB5Ow06tqusAiBNi37rA5Fbj1w8eyj8UUvFyo/ihyVjF3MBoMnUL9LvF9YgblzoII2MKF9ZgtPiawz1l5jdsOj9poX5jcNxNk60/Hh6TXW8IMyGoxvJZs2zzj/blsrgJ39sqxSJ7p7BqexloBDGBQvgszVinU8wGurikVSuVl7uYDd/l8lopu3ZabOXS9KB0MzpOXbBcZOkXpibpS5f2YQvFdYru9X+lFN+WL2NoeH0vfecMDfM2sUP6MOJNXHzkNuIvQOoy70XSgAWkGg/WNUhQ/cBVXAaPKUiCHlmGudY6dUEYrimmTZTAomnF+1ISym0wmf4ntITuISnZYIHhgpzFaThxiCTlggQseW9o9MWkzXPQhjuL0rR5KX4Fo11TplLpaSzGACpSxOKAk7t+45eJacKlvjGgzWS96N7f3RLKSr/Ha3UbX3AWymEsZkfMn7pQfn7v7vXwBhHANCdv4f9llaYZ0q2NrSPRjeeE3UIZlZf6hfPMaXBGYgoP3KBFNSdZ3vSn8ILVQf+NlRfoJLVenGzJdTZ5HioQKJtT+T7l2pAXLud4H3lkH/4mf6RZFY2ovBNfLxCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199015)(86362001)(36756003)(5660300002)(2906002)(8936002)(38100700002)(83380400001)(66556008)(186003)(26005)(6512007)(1076003)(6916009)(4326008)(2616005)(41300700001)(66946007)(66476007)(8676002)(316002)(6506007)(6666004)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CLMRb3V7P+PFYpcgALFvVi+YxCs5n4s4e0rRO+p5LmfodacVETBWfJaLrRfP?=
 =?us-ascii?Q?3aSpYYWefjn27VnrdHpeiaXYWl7ytTftJlIDgtxrVHzJ/QxBonZ3hTU7Y7OT?=
 =?us-ascii?Q?J7CpiYSISWnguQnc5zOely6VTzbrpytB7FlmyNR+w2I6vi9hw0MlyA9PMq86?=
 =?us-ascii?Q?3jOg3pq90yCRdv1A8MAECPXBH5YkUMmdutbFm6ghi7vR4GLCpoxdycmQm9tJ?=
 =?us-ascii?Q?ZYFLEhYpPgR5Cv0jRx35LORXvdNT8Aeu3+gD7rV0WyIgGqN8dteFQoSnTS00?=
 =?us-ascii?Q?/zGszKG3YufgusjE0JAwW7layfr0CvS5J5UeDeHwjFd3/4cfig+/Uj6i4oiS?=
 =?us-ascii?Q?Te6eIoKUwUoxxRLLUlHgQpeEeE3gUwq8PJGCzzQ6lFI2jidMzNcYnbCD7BPE?=
 =?us-ascii?Q?WpzukfRpn3dCRbVIRI0qR/E73nH0hNJ2d5FE2JVzdp0ALpO3raH3rjIozvPT?=
 =?us-ascii?Q?j3rRoucQMlxGUued85N7aomH3x/A2i2ckaVMarBWKvBP7FjuAMKpyArH2uQr?=
 =?us-ascii?Q?WZ5ZzhoR1AS16KTvmeCjz6xY4U2o+q1Sbdn1uf06VT3DZp1NVK76VBEransh?=
 =?us-ascii?Q?76JDERvA6pxMoi5XdD5/flrcfz3W3TCFNtr2tiQAZpEvBJ1FLKLVh7BJxHB/?=
 =?us-ascii?Q?oAiKqbvzIXAOE2wSTXjKea2QS6Kq/VNlQhnw5UGJjsm/JTv6fvDW/+2YNdkj?=
 =?us-ascii?Q?uLRNLWhHhKjeVgu7S4Ci8JMuhPkHcjcG1XRj1f7HRlKH1B29j5sKjygVf/l0?=
 =?us-ascii?Q?sFUEJFOTVh+esdKQUAtRm8ulhW45EplAe9rpLCdMk/CLKFMM3UUqDo76eDgF?=
 =?us-ascii?Q?XeGhTvb0WVfhTM0r8YM5O8rIfjjwg/55WWysFRnvmkJRuBD/h26KQw24B+o3?=
 =?us-ascii?Q?JK8jBp8oJhEPW9dH3zgcSMOdNlncKWqn2EmwQboBjqa1DTZGnsz9EZ+Nf/Ml?=
 =?us-ascii?Q?a/42XD/1eViQuuaABuQ8fJNOEdeijzO+bq/vnUE1vFxTYaMIMzDAMYtBPIqM?=
 =?us-ascii?Q?BBOXo2BdyI3xRSq5dX3NxAtEmg7TwWAQdLS03v2aMcxmrVVPSTuu+gBwxdn6?=
 =?us-ascii?Q?95Dx4CbOqINboefOoE5RlHKaWqOQbh1+h2OOi+c/BLYLLTri5ftpMgvbKh0L?=
 =?us-ascii?Q?Zf4fnk6uPrBN3YFIxW1CtqmXL84nUwS5NIU3SF4AB2E3BGag4ftlo3z5kL0h?=
 =?us-ascii?Q?jh9z/soqzCJhJzPUjY+OJjvJCyVeKahj68oQPBow9r7P/RAFMnVGo3U0z8Eq?=
 =?us-ascii?Q?JjfOPtSK+Ils3gUVWhF4sq6ZEKF+49Vw6UXKWdVZD5r6gLKCfpZ9oJevtic0?=
 =?us-ascii?Q?A3YGl53+ASmDdIKdTU9CmvWccOs2mwk3eUweFiEzsoNk/oQcsPRQCs66nWC/?=
 =?us-ascii?Q?CwDDzStun1RDMxJ6RC0i1EjjNurnWpNxjhAqD37bAvv1eRIDkYpHT1jlVZ9B?=
 =?us-ascii?Q?xOYLgb8+kQJ4xnOUcF8U6QY5uDGUB/7Dr6jl3G50YPe5NaPcGSUj4KQCl5VH?=
 =?us-ascii?Q?qBKdj9a5DCHc9/qh2ZNf0pLQvCL4owupV1QXz+4cZkn5Xa+OdQxN02X7y3H2?=
 =?us-ascii?Q?UVHnpt3I8FFBE+T7/5Pve8fzv0qG2iiZnO2Nk+Td?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9936b0-1f56-421b-ac03-08dac2e5e27e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 06:36:23.2878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGmm4WCrA2PMuXqVc064n9XNBsgKob9fFi66MIM3yew1SxOSroCEGXkQLc/+idwkJ1vGUZMUSk21YdxTVnKBwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100048
X-Proofpoint-ORIG-GUID: HeRtCV_NfuE_SnkhS_eFdbETt-RoySAt
X-Proofpoint-GUID: HeRtCV_NfuE_SnkhS_eFdbETt-RoySAt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit f74681ba2006434be195402e0b15fc5763cddd7e upstream.

[Slightly modify xfs_trans_alloc() to fix a merge conflict due to missing
 "atomic_inc(&mp->m_active_trans)" statement in v5.9 kernel]

The rmapbt extent swap algorithm remaps individual extents between
the source inode and the target to trigger reverse mapping metadata
updates. If either inode straddles a format or other bmap allocation
boundary, the individual unmap and map cycles can trigger repeated
bmap block allocations and frees as the extent count bounces back
and forth across the boundary. While net block usage is bound across
the swap operation, this behavior can prematurely exhaust the
transaction block reservation because it continuously drains as the
transaction rolls. Each allocation accounts against the reservation
and each free returns to global free space on transaction roll.

The previous workaround to this problem attempted to detect this
boundary condition and provide surplus block reservation to
acommodate it. This is insufficient because more remaps can occur
than implied by the extent counts; if start offset boundaries are
not aligned between the two inodes, for example.

To address this problem more generically and dynamically, add a
transaction accounting mode that returns freed blocks to the
transaction reservation instead of the superblock counters on
transaction roll and use it when the rmapbt based algorithm is
active. This allows the chain of remap transactions to preserve the
block reservation based own its own frees and prevent premature
exhaustion regardless of the remap pattern. Note that this is only
safe for superblocks with lazy sb accounting, but the latter is
required for v5 supers and the rmap feature depends on v5.

Fixes: b3fed434822d0 ("xfs: account format bouncing into rmapbt swapext tx reservation")
Root-caused-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_shared.h |  1 +
 fs/xfs/xfs_bmap_util.c     | 18 +++++++++---------
 fs/xfs/xfs_trans.c         | 19 ++++++++++++++++++-
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c45acbd3add9..708feb8eac76 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 12c12c2ef241..5eab15dde4e6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1740,6 +1740,7 @@ xfs_swap_extents(
 	int			lock_flags;
 	uint64_t		f;
 	int			resblks = 0;
+	unsigned int		flags = 0;
 
 	/*
 	 * Lock the inodes against other IO, page faults and truncate to
@@ -1795,17 +1796,16 @@ xfs_swap_extents(
 		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
 
 		/*
-		 * Handle the corner case where either inode might straddle the
-		 * btree format boundary. If so, the inode could bounce between
-		 * btree <-> extent format on unmap -> remap cycles, freeing and
-		 * allocating a bmapbt block each time.
+		 * If either inode straddles a bmapbt block allocation boundary,
+		 * the rmapbt algorithm triggers repeated allocs and frees as
+		 * extents are remapped. This can exhaust the block reservation
+		 * prematurely and cause shutdown. Return freed blocks to the
+		 * transaction reservation to counter this behavior.
 		 */
-		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(ip, w);
-		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(tip, w);
+		flags |= XFS_TRANS_RES_FDBLKS;
 	}
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, flags,
+				&tp);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2ba9f071c5e9..47acf4096022 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -107,7 +107,8 @@ xfs_trans_dup(
 
 	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
 		       (tp->t_flags & XFS_TRANS_RESERVE) |
-		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
+		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
+		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);
 	/* We gave our writer reference to the new transaction */
 	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
@@ -273,6 +274,8 @@ xfs_trans_alloc(
 	 */
 	WARN_ON(resp->tr_logres > 0 &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
+	       xfs_sb_version_haslazysbcount(&mp->m_sb));
 	atomic_inc(&mp->m_active_trans);
 
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
@@ -368,6 +371,20 @@ xfs_trans_mod_sb(
 			tp->t_blk_res_used += (uint)-delta;
 			if (tp->t_blk_res_used > tp->t_blk_res)
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
+			int64_t	blkres_delta;
+
+			/*
+			 * Return freed blocks directly to the reservation
+			 * instead of the global pool, being careful not to
+			 * overflow the trans counter. This is used to preserve
+			 * reservation across chains of transaction rolls that
+			 * repeatedly free and allocate blocks.
+			 */
+			blkres_delta = min_t(int64_t, delta,
+					     UINT_MAX - tp->t_blk_res);
+			tp->t_blk_res += blkres_delta;
+			delta -= blkres_delta;
 		}
 		tp->t_fdblocks_delta += delta;
 		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
-- 
2.35.1

