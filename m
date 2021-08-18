Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB20DC4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CADE61051
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbhHSAAQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 20:00:16 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:35448 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235064AbhHSAAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 20:00:15 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 4264E106DF9
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 09:59:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-002JPO-6L
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT7-000cw2-Ux
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/16] xfs: sb verifier doesn't handle uncached sb buffer
Date:   Thu, 19 Aug 2021 09:59:20 +1000
Message-Id: <20210818235935.149431-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818235935.149431-1-david@fromorbit.com>
References: <20210818235935.149431-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=wdQ27fpmZP10mFi4_HMA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The verifier checks explicitly for bp->b_bn == XFS_SB_DADDR to match
the primary superblock buffer, but the primary superblock is an
uncached buffer and so bp->b_bn is always -1ULL. Hence this never
matches and the CRC error reporting is wholly dependent on the
mount superblock already being populated so CRC feature checks pass
and allow CRC errors to be reported.

Fix this so that the primary superblock CRC error reporting is not
dependent on already having read the superblock into memory.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c | 2 +-
 fs/xfs/xfs_buf.h       | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 04f5386446db..4a4586bd2ba2 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -636,7 +636,7 @@ xfs_sb_read_verify(
 
 		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
-			if (bp->b_bn == XFS_SB_DADDR ||
+			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
 				error = -EFSBADCRC;
 				goto out_error;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index cfbe37d73293..37c9004f11de 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -133,7 +133,12 @@ struct xfs_buf {
 	 * fast-path on locking.
 	 */
 	struct rhash_head	b_rhash_head;	/* pag buffer hash node */
-	xfs_daddr_t		b_bn;		/* block number of buffer */
+
+	/*
+	 * b_bn is the cache index. Do not use directly, use b_maps[0].bm_bn
+	 * for the buffer disk address instead.
+	 */
+	xfs_daddr_t		b_bn;
 	int			b_length;	/* size of buffer in BBs */
 	atomic_t		b_hold;		/* reference count */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
-- 
2.31.1

