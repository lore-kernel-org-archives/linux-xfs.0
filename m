Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60754C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A0261185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhIPKKF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22986 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236417AbhIPKJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:09:06 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xkpf012725;
        Thu, 16 Sep 2021 10:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ue0OuPKcW9LhfwvkMALuhADN0yh0xDt+Ow7tIb3nKcc=;
 b=Ua5Eybg0azji7ac7ya7jHQNqp/4hCz+L+EdukMaj7LAIPYBiIwKG+n3m62JC6vG4ybI3
 Y9ZNEy6AsW6WapQSGyYjDCNydzkLV24FgnMftQIvzXDQtFJPPVdZtwbmZPXzO41ccUeY
 18egFS7jsLU7kRIS5cgVxpOpNST0zAeNISh085L9OzBwNul96zSTMpROBU+szxryaHk6
 MLyiBa4/meGahZwebgHycEPesDtgluWMpdAoE8nI5ASW9d6nGvvJGWNXYODnkMxNKeOG
 3cR6ImtQjQNcv65EP92DRL1N+AbX3quQYF4K/RMwK3mDY9uoUExOuQnlk1r+DAQXz+dA pQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ue0OuPKcW9LhfwvkMALuhADN0yh0xDt+Ow7tIb3nKcc=;
 b=EslxxPmmfV0LkBA1W8dPwzJw/Xnu4ohN9/4+PXN8v0mubMOmtYD5t0IlnPJfIBck/DLo
 rYen7nMpxe/sKPmzLmrnxPUyHH43vlQkJndcXXzzqCbXsRPNL1tGUNrAnpWH27PUlgsy
 kGB7oUMLsT6tb1tFGAwW+paXvxbIPKfqL9YD8pqypAEjHXs0Snga9+tpVzg2jg2MwgiQ
 pSuEe38LhnWEfM+uihr2Mx3XLlpoaJTtBRR7twlm7MoNsCg0mAe/IcekIdenRXxQZAbF
 Fdfrd54ZUKsToagvjX4UMmKRnga2V3zaO/rFK2ycmqNuW7hT9rHfjhrIR4NjQJxCGaNc jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3s74hgkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5FkK030661;
        Thu, 16 Sep 2021 10:07:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 3b0hjxyc1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqihWjKlrAu+aKjZ5AcjPtdpKZnlfy3h6vMUu2DQk5piELRrPTzA3ANr/EM+gH+ifEvjD2P/I7y50DMYeWnPZxJ2MWug83nNd40B3KMCzmu7e4zOyHSlR1DIheaEnuN0mZRRnYQYYBLDwlxqg0OLsqdAjN5eNG2p7LvdCJQKqeLk4oqrIDkJoaGKA9gSlvGG8+hOe8OMJGjpjcVwsviNwPTe1EvmhvjYL6oQob7EDM5RSsaaxxFzXMyS0SFrDlqILQc8Iv3k0MZIc2SIGmIvZM5OYd5hiTry14hHaPHjor3JIQX124U/Z/3QMIaMXp3xJPVX2twsi4ZEP7q+g3jsjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ue0OuPKcW9LhfwvkMALuhADN0yh0xDt+Ow7tIb3nKcc=;
 b=TZpH7lWtdphJ6I4gF7lsjdtNAIkL/UX5bk+pqlagdScWSQpnHz9yCDEgJUg7qr44vFW5Sc7zWUaQYhF+JRKlSPnaOngEe5n85DC4obsR9OcyCHRHIeoxv/Ds8Q9QdPIonvmv6Zz3P/JdCITUvAcPceXcEbDs14gQJkLBfMT+/G7W9FPnf5QpwNSJtMq+y3qoeaVbYjIOpZXqCBAVqZAiyzly7JjjUpEK7lrmwiZXcW1bva0/aqtXTPOUb19C1ZtHNaLt3sDIUnMh38+FtP1AxUv3VmZc6kpQFsByaaAEJbSXJcezvRzxLJMKTvNCz3/G3lSTFwm+bcwsSX+OBINt+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ue0OuPKcW9LhfwvkMALuhADN0yh0xDt+Ow7tIb3nKcc=;
 b=LiEj00p7aYzetPEo5kuUEMG59tV3GeTvFfHuw0oOu2EjOc9lTdreVAkQ+5Yf4kVUw/u9hWyPwDwlvt+/VkIKiDFxaicw+7xpQuwnnU1QJFeRScoVc+5J2N11WAK+s9nAWzDYmrXIq2lj0lIGgTano8SIT/dPos+cVBfmNgmGawY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:40 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:40 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 12/12] xfs: Define max extent length based on on-disk format definition
Date:   Thu, 16 Sep 2021 15:36:47 +0530
Message-Id: <20210916100647.176018-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0815f13-20ab-4ee0-e888-08d978f9d12e
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2878C9BD8AB01F611F54A698F6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 45SVp66fCO3MNfsCJ5QOVfs58hiapN4yn+V94reYqO6UpWX/7KB5gqTFzNodPjcu7RgfF2+K60mmbGj4wj/9sb9jKehPKIuvrbovUyHr3fTUw9E19PcshsSFOPHv4c1jX7bh47r6NJKHru5ImizHHSdlMODdLna1fkIrFfdfzgERl5XSMwOnbhwCm3jSRQD2NMZwXmmwqoPvSlY3id0Xg1yyKTT79oPsKqwmoLR/99Hmnf1ssLA1yjtlgQWkK02dUXOg+b1BytcyCIVe8ZVK1fhYtGIdijNvCFD1hHNdGH4M2LnGVmvAiRLzicuKKk4BsvFniBJ0WxlbvJy0taUJyt8Bs/YIv9IeAxW9vlGp7mPFryHJPeCwQtG9PxC3OiTg8qH5nArbm45luvgRBBG6fhzX7v5jAYLarTq7O43ImUYTPfoAy9rNqMkNU9QMYvPKNf7+ZcX2PQVLB1Yjsv0K4YXCyFW2KODYA68FbkpcwxOv3dQ581oxOSTSeLhUaTD9IJFw9KFUmB2DaxbjvIumZ+yhJQ+WR3KqgZf/Z+Sn06DUgiRLQrMyjdtMPW2U7ivWDmun4OMDKblCXSNJ6IXWRjaPc2RQqdauU0GGOgsS7FXF4XmBKhTfg4h3LlORkiC6/cCpT5yHfkFWnEPfhUgE4JKyW4HjF7QVaXGnNKg9bNc8I0BpMykymD3fEc3bp0nd7dCIpHfZDEjYAhy5R3qomw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(30864003)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aB/gXPdU3W0PYbSJbbkb9ZI/vSntT80Y1jbuFd3ChO8pYv0B+v+gBJN3p1kV?=
 =?us-ascii?Q?iCmpvRLmz4ikJgm6fZgctDZJ2Ba+rY0yEgqBY/eYhYFozlExcpJ9qLzM7QV/?=
 =?us-ascii?Q?HzX8pzXsbIfQP41f6doWgn/XDwINSM53O79EKEKmp1VagbAEKdS5ZmG2QUHT?=
 =?us-ascii?Q?pyXeI+jS6xw3CRKBTTMLdYlijQ1WWUKzKe4VjcO9X6CEu0pwL64By+KBd21Z?=
 =?us-ascii?Q?0HT2qoJ2otMT0efxxQygB6apzbhAcFJsNpRi2BI8amT7ryh8KNTXxpYoRqMG?=
 =?us-ascii?Q?KoCSCR1JzC66dFkz7CXtoMB8rQlki1GfZnGdiSeJ61uVeLT8MZDFSYemq4AC?=
 =?us-ascii?Q?N69DIjqMetr15h4WgMuln2i6I4PjMFdz4mRqS7IapMQFQUWGUE2FXq5bby4O?=
 =?us-ascii?Q?j122hGakFrq/76rEJdRLrXHQHpKysJkdpJ+8R71QOOjuK3/B5XRYxJKkrWuG?=
 =?us-ascii?Q?XtrBNGwgL28aGDKrBmKojpD+UecBHw3w0khuOFS8t+0EnxaM9jiMhiD8eAO5?=
 =?us-ascii?Q?xVJBd84SbC0YI4OeGpa7gZChZ27hH50bEx+yTBBTSxsWFs4pA2AKiMkDtJAl?=
 =?us-ascii?Q?TthfiLSfQPJtYqNxatkNmvzPPE3xp6qoiekyGBS9GzuAstXUpUBe6sP7zEoK?=
 =?us-ascii?Q?vpX7NKH7tOUX6ZmZMAnGibp/8H7L29VuUf2GwN1hJ4shauQJCxZZT/S3YKGv?=
 =?us-ascii?Q?YLbpfqE3u1K/T425XBgnfmYnGnd7WQt7qSBwAivE8qbQOQmfN6of6kMFYK6f?=
 =?us-ascii?Q?30eR2lzr6rtd7uUySjyJBpbqhQq5KMjMHpcwzfMIIVOKZYuJr7Dh+Rra2SxX?=
 =?us-ascii?Q?v7nrnSr/YPhzOIx6/q6qe5qwp2AxKLEoGS/LH/QhXzrRJZZx61qb0NOgGE6p?=
 =?us-ascii?Q?c2w/rWXThBNoLR2ee6IGSGehKLQa/ZygfyZKRs8WADOU9KMu/EcpJtJl+LrZ?=
 =?us-ascii?Q?+PQSM4hiI1A9LIFMojN4sZjGexqqmMcqFYNetE3l+Yoki6NktYDkC6cWmWVN?=
 =?us-ascii?Q?PipaKbxYWV1BLjoc0VT9jW9YxaWVatiif+6fpVKi7kb6oKVAZJEaRDqMYPG3?=
 =?us-ascii?Q?7OPXHa8KQphgddwPU+dRRsIuNY1Edlorm0P85q14GXaA5SZ0Wc9U3U8ZfApO?=
 =?us-ascii?Q?BMkW71J5zdjx3ON5cTxE4oxWu2pDJIsSHXmgBFAM+NdRB0eTrVdMollUu562?=
 =?us-ascii?Q?L+IndMTaXv8iSf8CwHbGd0KBOnD6x90eTxSM+nilpuAdX1rHrGsuR/hDUuiN?=
 =?us-ascii?Q?xQ51pxnHMagcb918G2AXQ4LTRDVgNBxtM4BF7FAXSJDvG+aNkbCIpPtQfLWO?=
 =?us-ascii?Q?JOnwkse+JocLZX+RsFY1/3s+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0815f13-20ab-4ee0-e888-08d978f9d12e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:40.7490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /s1YrMjRTza9D4tcirHz8tkCbTB6Jd37drWBBVHtjL0momgemdq7ogBudPT6Arntao1c0v+oOcg7X/9LTxbgAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: les0j0iU9GupyPJBhxqses6oIryhRXzw
X-Proofpoint-GUID: les0j0iU9GupyPJBhxqses6oIryhRXzw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum extent length depends on maximum block count that can be stored in
a BMBT record. Hence this commit defines MAXEXTLEN based on
BMBT_BLOCKCOUNT_BITLEN.

While at it, the commit also renames MAXEXTLEN to XFS_MAX_EXTLEN.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 59 +++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_format.h     | 20 ++++++------
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 +--
 fs/xfs/libxfs/xfs_rtbitmap.c   |  4 +--
 fs/xfs/libxfs/xfs_swapext.c    |  6 ++--
 fs/xfs/libxfs/xfs_trans_resv.c | 10 +++---
 fs/xfs/scrub/bmap.c            |  2 +-
 fs/xfs/scrub/bmap_repair.c     |  2 +-
 fs/xfs/scrub/repair.c          |  2 +-
 fs/xfs/xfs_bmap_util.c         | 14 ++++----
 fs/xfs/xfs_iomap.c             | 28 ++++++++--------
 11 files changed, 77 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a77cf8619ec0..fb10ea078361 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -548,7 +548,7 @@ __xfs_bmap_add_free(
 
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
-	ASSERT(len <= MAXEXTLEN);
+	ASSERT(len <= XFS_MAX_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
@@ -1504,7 +1504,7 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1522,13 +1522,13 @@ xfs_bmap_add_extent_delay_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2067,7 +2067,7 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2085,13 +2085,13 @@ xfs_bmap_add_extent_unwritten_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2600,15 +2600,15 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= MAXEXTLEN)))
+	      right.br_blockcount <= XFS_MAX_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2751,17 +2751,17 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
 	    new->br_startblock + new->br_blockcount == right.br_startblock &&
 	    new->br_state == right.br_state &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= MAXEXTLEN))
+	     right.br_blockcount <= XFS_MAX_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -3003,15 +3003,15 @@ xfs_bmap_extsize_align(
 
 	/*
 	 * For large extent hint sizes, the aligned extent might be larger than
-	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
-	 * the length back under MAXEXTLEN. The outer allocation loops handle
-	 * short allocation just fine, so it is safe to do this. We only want to
-	 * do it when we are forced to, though, because it means more allocation
-	 * operations are required.
+	 * XFS_MAX_EXTLEN. In that case, reduce the size by an extsz so that it
+	 * pulls the length back under XFS_MAX_EXTLEN. The outer allocation
+	 * loops handle short allocation just fine, so it is safe to do this. We
+	 * only want to do it when we are forced to, though, because it means
+	 * more allocation operations are required.
 	 */
-	while (align_alen > MAXEXTLEN)
+	while (align_alen > XFS_MAX_EXTLEN)
 		align_alen -= extsz;
-	ASSERT(align_alen <= MAXEXTLEN);
+	ASSERT(align_alen <= XFS_MAX_EXTLEN);
 
 	/*
 	 * If the previous block overlaps with this proposed allocation
@@ -3101,9 +3101,9 @@ xfs_bmap_extsize_align(
 			return -EINVAL;
 	} else {
 		ASSERT(orig_off >= align_off);
-		/* see MAXEXTLEN handling above */
+		/* see XFS_MAX_EXTLEN handling above */
 		ASSERT(orig_end <= align_off + align_alen ||
-		       align_alen + extsz > MAXEXTLEN);
+		       align_alen + extsz > XFS_MAX_EXTLEN);
 	}
 
 #ifdef DEBUG
@@ -4070,7 +4070,7 @@ xfs_bmapi_reserve_delalloc(
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
-	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
@@ -4203,7 +4203,7 @@ xfs_bmapi_allocate(
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_EXTLEN);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
@@ -4524,8 +4524,8 @@ xfs_bmapi_write(
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
 			 * check for 32-bit overflows and handle them here.
 			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
+			if (len > (xfs_filblks_t)XFS_MAX_EXTLEN)
+				bma.length = XFS_MAX_EXTLEN;
 			else
 				bma.length = len;
 
@@ -4660,7 +4660,8 @@ xfs_bmapi_convert_delalloc(
 	bma.ip = ip;
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
+	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
+			XFS_MAX_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
@@ -4743,7 +4744,7 @@ xfs_bmapi_remap(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
-	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(len <= (xfs_filblks_t)XFS_MAX_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
@@ -5716,7 +5717,7 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_EXTLEN))
 		return false;
 
 	return true;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7d08bb0fe510..e0fb19761669 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -885,16 +885,6 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
-/*
- * Max values for extlen and disk inode's extent counters.
- */
-#define	MAXEXTLEN		((xfs_extlen_t)0x1fffff)	/* 21 bits */
-#define XFS_IFORK_EXTCNT_MAXU48	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
-#define XFS_IFORK_EXTCNT_MAXU32	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
-#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
-#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
-
-
 /*
  * Inode minimum and maximum sizes.
  */
@@ -1701,6 +1691,16 @@ typedef struct xfs_bmbt_rec {
 typedef uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
 typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
 
+/*
+ * Max values for extlen and disk inode's extent counters.
+ */
+#define XFS_MAX_EXTLEN		((xfs_extlen_t)(1 << BMBT_BLOCKCOUNT_BITLEN) - 1)
+#define XFS_IFORK_EXTCNT_MAXU48	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
+#define XFS_IFORK_EXTCNT_MAXU32	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
+#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
+#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
+
+
 /*
  * Values and macros for delayed-allocation startblock fields.
  */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0ab332c913c4..1b27095b423d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -747,7 +747,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -804,7 +804,7 @@ xfs_inode_validate_cowextsize(
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
 		return __this_address;
 
-	if (cowextsize > MAXEXTLEN)
+	if (cowextsize > XFS_MAX_EXTLEN)
 		return __this_address;
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 7b70ac58a1dc..0ed94079f72c 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1015,7 +1015,7 @@ xfs_rtfree_extent(
 /*
  * Free some blocks in the realtime subvolume.  rtbno and rtlen are in units of
  * rt blocks, not rt extents; must be aligned to the rt extent size; and rtlen
- * cannot exceed MAXEXTLEN.
+ * cannot exceed XFS_MAX_EXTLEN.
  */
 int
 xfs_rtfree_blocks(
@@ -1028,7 +1028,7 @@ xfs_rtfree_blocks(
 	xfs_filblks_t		len;
 	xfs_extlen_t		mod;
 
-	ASSERT(rtlen <= MAXEXTLEN);
+	ASSERT(rtlen <= XFS_MAX_EXTLEN);
 
 	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
 	if (mod) {
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 36c918776ba0..6a5564e534eb 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -757,7 +757,7 @@ can_merge(
 	if (b1->br_startoff   + b1->br_blockcount == b2->br_startoff &&
 	    b1->br_startblock + b1->br_blockcount == b2->br_startblock &&
 	    b1->br_state			  == b2->br_state &&
-	    b1->br_blockcount + b2->br_blockcount <= MAXEXTLEN)
+	    b1->br_blockcount + b2->br_blockcount <= XFS_MAX_EXTLEN)
 		return true;
 
 	return false;
@@ -799,7 +799,7 @@ delta_nextents_step(
 		state |= CRIGHT_CONTIG;
 	if ((state & CBOTH_CONTIG) == CBOTH_CONTIG &&
 	    left->br_startblock + curr->br_startblock +
-					right->br_startblock > MAXEXTLEN)
+					right->br_startblock > XFS_MAX_EXTLEN)
 		state &= ~CRIGHT_CONTIG;
 
 	if (nhole)
@@ -810,7 +810,7 @@ delta_nextents_step(
 		state |= NRIGHT_CONTIG;
 	if ((state & NBOTH_CONTIG) == NBOTH_CONTIG &&
 	    left->br_startblock + new->br_startblock +
-					right->br_startblock > MAXEXTLEN)
+					right->br_startblock > XFS_MAX_EXTLEN)
 		state &= ~NRIGHT_CONTIG;
 
 	switch (state & (CLEFT_CONTIG | CRIGHT_CONTIG | CHOLE)) {
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index b3de538ea7ce..0c165bf3c357 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -209,8 +209,8 @@ xfs_calc_inode_chunk_res(
 /*
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
- * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
- * as well as the realtime summary block.
+ * blocks as needed to mark inuse XFS_MAX_EXTLEN blocks' worth of realtime
+ * extents, as well as the realtime summary block.
  */
 static unsigned int
 xfs_rtalloc_log_count(
@@ -220,7 +220,7 @@ xfs_rtalloc_log_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = (XFS_MAX_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
@@ -279,7 +279,7 @@ xfs_refcount_log_reservation(
  *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
- *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: ((XFS_MAX_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
  *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
  * And the bmap_finish transaction can free bmap blocks in a join (t3):
@@ -334,7 +334,7 @@ xfs_calc_write_reservation(
  *    the agf for each of the ags: 2 * sector size
  *    the agfl for each of the ags: 2 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: 2 exts * ((XFS_MAX_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 5fcaa2518799..d57509090788 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -427,7 +427,7 @@ xchk_bmap_iextent(
 				irec->br_startoff);
 
 	/* Make sure the extent points to a valid place. */
-	if (irec->br_blockcount > MAXEXTLEN)
+	if (irec->br_blockcount > XFS_MAX_EXTLEN)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (info->is_rt &&
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 471f67d7acb1..6f1edadbadac 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -92,7 +92,7 @@ xrep_bmap_from_rmap(
 
 	do {
 		irec.br_blockcount = min_t(xfs_filblks_t, blockcount,
-				MAXEXTLEN);
+				XFS_MAX_EXTLEN);
 		xfs_bmbt_disk_set_all(&rbe, &irec);
 
 		trace_xrep_bmap_found(rb->sc->ip, rb->whichfork, &irec);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 5ea55a4f4c2b..67268a534a83 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1127,7 +1127,7 @@ xrep_reap_extent(
 	xfs_agblock_t		agbno_next = agbno + len;
 	int			error = 0;
 
-	ASSERT(len <= MAXEXTLEN);
+	ASSERT(len <= XFS_MAX_EXTLEN);
 
 	if (sc->ip != NULL) {
 		/*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f43f1d434fe2..45a86b36c9dc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -120,14 +120,14 @@ xfs_bmap_rtalloc(
 	 */
 	ralen = ap->length / mp->m_sb.sb_rextsize;
 	/*
-	 * If the old value was close enough to MAXEXTLEN that
+	 * If the old value was close enough to XFS_MAX_EXTLEN that
 	 * we rounded up to it, cut it back so it's valid again.
 	 * Note that if it's a really large request (bigger than
-	 * MAXEXTLEN), we don't hear about that number, and can't
+	 * XFS_MAX_EXTLEN), we don't hear about that number, and can't
 	 * adjust the starting point to match it.
 	 */
-	if (ralen * mp->m_sb.sb_rextsize >= MAXEXTLEN)
-		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
+	if (ralen * mp->m_sb.sb_rextsize >= XFS_MAX_EXTLEN)
+		ralen = XFS_MAX_EXTLEN / mp->m_sb.sb_rextsize;
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -841,9 +841,11 @@ xfs_alloc_file_space(
 		 * count, hence we need to limit the number of blocks we are
 		 * trying to reserve to avoid an overflow. We can't allocate
 		 * more than @nimaps extents, and an extent is limited on disk
-		 * to MAXEXTLEN (21 bits), so use that to enforce the limit.
+		 * to XFS_MAX_EXTLEN (21 bits), so use that to enforce the
+		 * limit.
 		 */
-		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));
+		resblks = min_t(xfs_fileoff_t, (e - s),
+				(XFS_MAX_EXTLEN * nimaps));
 		if (unlikely(rt)) {
 			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 			rblocks = resblks;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2c8eee2fe5be..e5e5d1482ff2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -399,7 +399,7 @@ xfs_iomap_prealloc_size(
 	 */
 	plen = prev.br_blockcount;
 	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
-		if (plen > MAXEXTLEN / 2 ||
+		if (plen > XFS_MAX_EXTLEN / 2 ||
 		    isnullstartblock(got.br_startblock) ||
 		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
 		    got.br_startblock + got.br_blockcount != prev.br_startblock)
@@ -411,23 +411,23 @@ xfs_iomap_prealloc_size(
 	/*
 	 * If the size of the extents is greater than half the maximum extent
 	 * length, then use the current offset as the basis.  This ensures that
-	 * for large files the preallocation size always extends to MAXEXTLEN
-	 * rather than falling short due to things like stripe unit/width
-	 * alignment of real extents.
+	 * for large files the preallocation size always extends to
+	 * XFS_MAX_EXTLEN rather than falling short due to things like stripe
+	 * unit/width alignment of real extents.
 	 */
 	alloc_blocks = plen * 2;
-	if (alloc_blocks > MAXEXTLEN)
+	if (alloc_blocks > XFS_MAX_EXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	qblocks = alloc_blocks;
 
 	/*
-	 * MAXEXTLEN is not a power of two value but we round the prealloc down
-	 * to the nearest power of two value after throttling. To prevent the
-	 * round down from unconditionally reducing the maximum supported
-	 * prealloc size, we round up first, apply appropriate throttling,
-	 * round down and cap the value to MAXEXTLEN.
+	 * XFS_MAX_EXTLEN is not a power of two value but we round the prealloc
+	 * down to the nearest power of two value after throttling. To prevent
+	 * the round down from unconditionally reducing the maximum supported
+	 * prealloc size, we round up first, apply appropriate throttling, round
+	 * down and cap the value to XFS_MAX_EXTLEN.
 	 */
-	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(MAXEXTLEN),
+	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(XFS_MAX_EXTLEN),
 				       alloc_blocks);
 
 	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
@@ -475,14 +475,14 @@ xfs_iomap_prealloc_size(
 	 */
 	if (alloc_blocks)
 		alloc_blocks = rounddown_pow_of_two(alloc_blocks);
-	if (alloc_blocks > MAXEXTLEN)
-		alloc_blocks = MAXEXTLEN;
+	if (alloc_blocks > XFS_MAX_EXTLEN)
+		alloc_blocks = XFS_MAX_EXTLEN;
 
 	/*
 	 * If we are still trying to allocate more space than is
 	 * available, squash the prealloc hard. This can happen if we
 	 * have a large file on a small filesystem and the above
-	 * lowspace thresholds are smaller than MAXEXTLEN.
+	 * lowspace thresholds are smaller than XFS_MAX_EXTLEN.
 	 */
 	while (alloc_blocks && alloc_blocks >= freesp)
 		alloc_blocks >>= 4;
-- 
2.30.2

