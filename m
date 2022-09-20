Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEC3ECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiITMuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiITMuT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:50:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703C460508
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:50:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAQUMj011862;
        Tue, 20 Sep 2022 12:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=KItixb9RcQ+lN988BqYPCGn2Tn2Sw9d3W27SRsTi/s+8l6mEGycPWRAaL4U2tBg2v2rv
 kX1rXkxkycRQd9d1yAniemNnfaPRuma5ki3wRyJfufekaAB1Uh1ZNQZTvQ+AbZi/vxDE
 Y7K2QUE6/++hCpd8I052kAxGzBjEqxMZb4Srhsfbl0pmviEWf5jDT4Uwqobai7bHtpeU
 7d2J0O0FbZc7L4kJKK9n5FipXEg4SoR+oUTo2SAXdddMKQ38kJ/hNkOMNUpXmnV35Aeg
 Ry8yNF0pu52g+b4nVF5FpJekwb8VcMy9CjncRcdJJ6jj0aIyQGsLPVkmaJLm8ZK7G1bP Tg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m6syy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KArn6a022887;
        Tue, 20 Sep 2022 12:50:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39qh2qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byOd00q1S/fTdADYicExBFWDhjFhBtx8BzPLSVyDs5f+ckg4cZffkjSA5t0S35R6+34jtoLyetDsEIrBQr08XjHP0zSKPSJfNaiSw247o0KyLW6Yj962jC6IaZ/Z8kBhEbmcP6ww1oAsvVXJibyZ8w9ReQHgmgoXG4zq31I49uXEpGNkFZkqQ2g55ghf5Clk1T+0bmjCwkhLfitJV2t0upz+hWfJZVQ/OcS9BG/KaWKi83x+wycxiIyNKGif5vGU6KXL7JZkSYppGbc28S8W+kCJg4lBSuN+Fk4SEk5MBCZDx9uotGFjAoTex32z0EWDmUmU3tJFzdHIuP2RczniJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=iwFAH1uZ1XTjkmm5p76bLs7UoFEmzc/alOVwzm1wFODNLTn/sQGpr81EOHCiNZ2WBs7xyTXJM1Lqq+WZlNdcAgPBeNiOHyQo5/jL/546M66OoRt+pgDI/71j9BDOEjHzyWTG5f22nv45pakVwwGKAblqbsdPSmAw64EgrjjO7eTFOdgPQaCwBMvk/xyYhrp0uM+c3Wz/Q6UDakJtMy6/87DtD3daRgvjcTkJcfrk7eMzkYIdQFV3gbb9Ml7nsDBJ19PLscMhPe2lOe0Ryf8FDA67pgEuWLndcwbb4VPA8RqNhHtN0DWrVQAlNuciv3k5PikRV8mtDLRe80F4UWo6Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=ILPoOfUoc4qyJndeAiFdGnB1tgk1MckiWqZA+5Tr+llsXa86U5mrBSTBCZXqp4OFua4YaQpgZLrTqMYxYVN6J5rFJvt2rihPQfmghJRibL5p4kiH25qeTQFwkA08pk5ZiQZWikgQ5gu20muQk/aSQ+fdm7Ynn6ESjukgMpFBoYQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB6304.namprd10.prod.outlook.com (2603:10b6:a03:478::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:50:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:50:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 13/17] xfs: stabilize insert range start boundary to avoid COW writeback race
Date:   Tue, 20 Sep 2022 18:18:32 +0530
Message-Id: <20220920124836.1914918-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: 211ca5e9-8934-431c-2f1f-08da9b06a76b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6TKrWAviyRxlmkekVSSznYSoB4zxyXTFGkGKhef9j41UF8773oEL3jVE3yQ2EvBa30BL450y3CBQ57DgUWAE4vtBeyLNXU0gVj/DEeB3IuI/oU3AYLHvXtagzG/glmYv1QTKZ+I8ZjdCtC8enZQ5q40kng9PtDh+0nuxekdwWRY8+oJ824ZSlvagiC1aQGJg1tg7iqBqzHz2mw+uCmg8603BY/KBgvBEP715HTpDN8s/s+J648vCRGlBSoElmrHS0C5LAfOmBooacG49O9mLBAoEAwQ8JBIoah4jxZaHU93zI5yw1oP+hGnzKYOcnVZT4n2tQqcRiwCyU2xJBek0deilLHNDRCTsmeKPelJQKD0RkaAtlljyVBB8lv+51GOQuQslkV+ORcXRHyMutD7h05/iUUNebUJ7B3UxwV00sSdClOdupPMU4iuV7h2X1jnZKDpeesgveCUqBBd8bQng+6LTuVZ564bsFomVoGgESQbvXUyeJ7YRiiq/O/X/5pCrixGZNH0s785E0+P0bVSqXoPBRmHpFmAwvStk7hxEqG/2YnEhVCAuV/w+1mgmgnzFhp8JnBZ8zfQ2hfOJPXhT6gttmPjpgbxaHXYn9hE4Hp9SuxavXa8qtnUG0t51I2EBV3OdzUqVkUCclfESwBH98xLRNwi3vZW9gnHGy5FjdgnT78ihtCT3gKTFlZ0SjwVHOzrVmwDT8HSfsxMaAVQmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(26005)(6506007)(6512007)(36756003)(6916009)(5660300002)(66476007)(66556008)(38100700002)(86362001)(186003)(2906002)(6666004)(1076003)(83380400001)(2616005)(4326008)(41300700001)(478600001)(6486002)(66946007)(8936002)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PrLJyqPXbqs3V5hlG52L6bbI9oeZVxxjIuEXqu2etdWqOKTu4lhVUy7uk8KM?=
 =?us-ascii?Q?B1Qza1W2+3RAmrkwEucbC9rr+gY8TrBcXRfPceXhRPH0JGTrgv+pUpHZaSVz?=
 =?us-ascii?Q?p4DtoI1e7vVVT9C2vCfjePjiEukJN7evJEpVMWRCrX/jjAZ9L2zI5uJhVIz6?=
 =?us-ascii?Q?MX/tq9T7wMuMHoNUttz7pxrdpinbR+lyJCpv8fqQP0mQHMoRtZDKzpzo4Kxe?=
 =?us-ascii?Q?DJpl0UzeaPTVTmcsu2Fb9BovEMaEfYSOZ4byZgDxE2nDyS65Ic6Pm4HWDvz8?=
 =?us-ascii?Q?Fj2/mwH98fi5muXrCwaJD2XuJlZ/g+fzLLNuzPw3XR8fxMLWQILgFhlvuW6K?=
 =?us-ascii?Q?oZr/QTCfuaseyV82CZ7OFZFwoEOaX9zrdmBtXb3wu9bH6qDdRJo9t9g3fazG?=
 =?us-ascii?Q?f8gEqMq/99xfdLeo9rE1BKBVYKldJlIpAcJtiB0LpX+wgf4SzUtml43M/SZa?=
 =?us-ascii?Q?XDCzM2F6rAPupvZzhzAUz8s5FTWks8VHaC5Yidb4uHwscIVGnUJs0Jr6IIlk?=
 =?us-ascii?Q?wchQtJiHD+5QscKa73rEN5frlpyOLjuBZCiIOyR+nHcgbB61YMAHWafjBEjd?=
 =?us-ascii?Q?K/sqhBAUrTqujNl6GNLtaqeCOEpDTOOU1JnOVoQBI6LEX+e1yH6IOfQJn0tZ?=
 =?us-ascii?Q?hla+Cxl43lgEJrSrKL+QAIcn+VaYX2EM15qtHQ/uIX5NLV1kQQDuGTBQ+E7A?=
 =?us-ascii?Q?9OQ9W3PsOsPHg8xaUJNUidx+8pYzVslKLL7aFBakEzhIYI2JFGdDcWzsOLQS?=
 =?us-ascii?Q?2bpGTQYIk01OUgfEchazqabEmya+Kt+LxIa0TXhCvnif3hQgCiJTVWA0LYJO?=
 =?us-ascii?Q?nVL7oMLoXmsmtDsz7Z3D+5aCvvuGLZi07Q4xAyNVfXXttaUB4X54ANw5Eg7/?=
 =?us-ascii?Q?8HlgSfMmC+7lRsaKjZf/zQYMl6/HIwnKlGuBIGxVfzffPAEEBzSMkReVNH4X?=
 =?us-ascii?Q?DCV4wOIOBBTpwPppn2MMOZ/RpeFFDxEGAtLTNz1aj9fluDuTzGp46nriP9VK?=
 =?us-ascii?Q?lgOx4OqSAVneLHwnqgaR0EckUvipV0JlHi9bE1G6G8JIzA+meNxRWyUR4qzk?=
 =?us-ascii?Q?7chcFVPTWALSAiBobkDmO6/RdZUVCXmuNkJjPBaxkqdb33fUZsPOXzZzcrYm?=
 =?us-ascii?Q?wvqUxJS40A+z+2qxalVRMwr89wm27PSRBQfjkCnC5CYbfXOJdL1Hap0f9+Qr?=
 =?us-ascii?Q?IoD0cm+NaNlQckhM5Y565v/Jn7rZOPeWOaqi8G3vwXhwg49QuH1+pNO9ouZU?=
 =?us-ascii?Q?TjJ/sRqlfPaZQTz+obmispMYrlXrzm1Jyx0GGDrsbI3c9YTLeLK1BYH8VBZn?=
 =?us-ascii?Q?3CWuvJCsyttemiFbAEwyvr4BbpNWqhey6c3jPtPMA5AIJaMdg/LIaUFgsMhV?=
 =?us-ascii?Q?5tGM5as3RjKDoa8mydYRzWc50l4egLV1sZG2YAD4GuC4XC+ftOC6S0aiqMP3?=
 =?us-ascii?Q?0qRRj5xL9LyqMLjU5tHZsXotx8aJbbgq/tzL2ks1lwdkg2Wht+O3wrrlBIbI?=
 =?us-ascii?Q?ue9vcqEv9MmloWp9UhHeI1SZ9odfgAHzVK7Nx4iypG502C2QE9WvNw/zkZCC?=
 =?us-ascii?Q?nf9QUKMhiNWeqEywXY5Jr+u/VF9wFffr8zZLfGK8YXATi93Dctk9PbsSrUMu?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 211ca5e9-8934-431c-2f1f-08da9b06a76b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:50:10.9305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Ga1ZySJzwzYkAkxv0THC8qDmnHUGcFRrWPiqFtp4maVHpYkcNUYd7WtT0wB3tle9Y7trvDBEx4zn9RVS8j+WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6304
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: Z5DxyHgmypt5tRq-FuTncgfHteD8F-KE
X-Proofpoint-GUID: Z5DxyHgmypt5tRq-FuTncgfHteD8F-KE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit d0c2204135a0cdbc607c94c481cf1ccb2f659aa7 upstream.

generic/522 (fsx) occasionally fails with a file corruption due to
an insert range operation. The primary characteristic of the
corruption is a misplaced insert range operation that differs from
the requested target offset. The reason for this behavior is a race
between the extent shift sequence of an insert range and a COW
writeback completion that causes a front merge with the first extent
in the shift.

The shift preparation function flushes and unmaps from the target
offset of the operation to the end of the file to ensure no
modifications can be made and page cache is invalidated before file
data is shifted. An insert range operation then splits the extent at
the target offset, if necessary, and begins to shift the start
offset of each extent starting from the end of the file to the start
offset. The shift sequence operates at extent level and so depends
on the preparation sequence to guarantee no changes can be made to
the target range during the shift. If the block immediately prior to
the target offset was dirty and shared, however, it can undergo
writeback and move from the COW fork to the data fork at any point
during the shift. If the block is contiguous with the block at the
start offset of the insert range, it can front merge and alter the
start offset of the extent. Once the shift sequence reaches the
target offset, it shifts based on the latest start offset and
silently changes the target offset of the operation and corrupts the
file.

To address this problem, update the shift preparation code to
stabilize the start boundary along with the full range of the
insert. Also update the existing corruption check to fail if any
extent is shifted with a start offset behind the target offset of
the insert range. This prevents insert from racing with COW
writeback completion and fails loudly in the event of an unexpected
extent shift.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/xfs_bmap_util.c   | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e7fa611887ad..8d035842fe51 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5876,7 +5876,7 @@ xfs_bmap_insert_extents(
 	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
 				del_cursor);
 
-	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
+	if (stop_fsb > got.br_startoff) {
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d6d78e127625..113bed28bc31 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1167,6 +1167,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
 
 	/*
@@ -1179,6 +1180,17 @@ xfs_prepare_shift(
 			return error;
 	}
 
+	/*
+	 * Shift operations must stabilize the start block offset boundary along
+	 * with the full range of the operation. If we don't, a COW writeback
+	 * completion could race with an insert, front merge with the start
+	 * extent (after split) during the shift and corrupt the file. Start
+	 * with the block just prior to the start to stabilize the boundary.
+	 */
+	offset = round_down(offset, 1 << mp->m_sb.sb_blocklog);
+	if (offset)
+		offset -= (1 << mp->m_sb.sb_blocklog);
+
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
-- 
2.35.1

