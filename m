Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4A7C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FE660F93
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhG0X4n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232766AbhG0X4m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 19:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39EB460F6C;
        Tue, 27 Jul 2021 23:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627430202;
        bh=fwQ9yUCnZB0ZjrDHE1r2MaJCicjnXEUOLiraEmMij1I=;
        h=Date:From:To:Cc:Subject:From;
        b=B0+7vboeiwf+wZQQkKBYQ6K2rKyqPWa+5A5SihzECcDKr1oljzdgFTujc+ppgiRI0
         gAC+4j9SJFxGJBairhLG4o6mYRHHIfVAgNY1aL3MiTgWB6AUpCA9QuVWVaUgsK/5RS
         Uwqpd79cR8mhlVz+lJTqU+oKn7XA96/StQxcSMjCliqWgCDLAu+xPqJM87l4w+U73t
         GPeEtrxkPma0sQGDYnvcpsPfawdjMTJ3nWM/qzvZufCXl7jOX80Wq0OeNvP8UOmB7x
         KG8Pg32Mb8TI3eKzC3ZEMPwqZ8KNi27/YkJb1ORzgNCwbXYer3PW2KZdldxSTIsav8
         dTgmiGmKlPLeQ==
Date:   Tue, 27 Jul 2021 16:56:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: prevent spoofing of rtbitmap blocks when recovering
 buffers
Message-ID: <20210727235641.GA559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While reviewing the buffer item recovery code, the thought occurred to
me: in V5 filesystems we use log sequence number (LSN) tracking to avoid
replaying older metadata updates against newer log items.  However, we
use the magic number of the ondisk buffer to find the LSN of the ondisk
metadata, which means that if an attacker can control the layout of the
realtime device precisely enough that the start of an rt bitmap block
matches the magic and UUID of some other kind of block, they can control
the purported LSN of that spoofed block and thereby break log replay.

Since realtime bitmap and summary blocks don't have headers at all, we
have no way to tell if a block really should be replayed.  The best we
can do is replay unconditionally and hope for the best.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 05fd816edf59..4775485b4062 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -698,7 +698,8 @@ xlog_recover_do_inode_buffer(
 static xfs_lsn_t
 xlog_recover_get_buf_lsn(
 	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	struct xfs_buf_log_format *buf_f)
 {
 	uint32_t		magic32;
 	uint16_t		magic16;
@@ -706,11 +707,20 @@ xlog_recover_get_buf_lsn(
 	void			*blk = bp->b_addr;
 	uuid_t			*uuid;
 	xfs_lsn_t		lsn = -1;
+	uint16_t		blft;
 
 	/* v4 filesystems always recover immediately */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		goto recover_immediately;
 
+	/*
+	 * realtime bitmap and summary file blocks do not have magic numbers or
+	 * UUIDs, so we must recover them immediately.
+	 */
+	blft = xfs_blft_from_flags(buf_f);
+	if (blft == XFS_BLFT_RTBITMAP_BUF || blft == XFS_BLFT_RTSUMMARY_BUF)
+		goto recover_immediately;
+
 	magic32 = be32_to_cpu(*(__be32 *)blk);
 	switch (magic32) {
 	case XFS_ABTB_CRC_MAGIC:
@@ -920,7 +930,7 @@ xlog_recover_buf_commit_pass2(
 	 * the verifier will be reset to match whatever recover turns that
 	 * buffer into.
 	 */
-	lsn = xlog_recover_get_buf_lsn(mp, bp);
+	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
 	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
 		trace_xfs_log_recover_buf_skip(log, buf_f);
 		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
