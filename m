Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6FBC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 19:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F3860F37
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 19:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhG0TPD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 15:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229945AbhG0TPD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 15:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5A6A60F37;
        Tue, 27 Jul 2021 19:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627413302;
        bh=4q8jkj4LtfjZARn/ENGxf6kfGaD4/ZqK8x2zq5JnmAE=;
        h=Date:From:To:Cc:Subject:From;
        b=jniHodGXbKDt8dDvSsIP+5YYZBOxfDq7rHSmICyKYKpm75lthA4v2xA6TOZIrNzEM
         u4xVuQby+7RGdFs4ZQHiTbBZSXfrcjtr+Ah8Ng0d9fw4yBvOB39sBleqf71fDHbiaw
         cErJujOozKSpsUtYDxE3CgZSC8HVbvvxhd32dObu0CrfvMvGNeYJP5qyDQxmr7v73B
         EThJyz/a/nkjxbEXJ6sdB+gsc+AWYunYcENTjBv4BpIK7k+erWSd0baaHJ9bsYJ4lY
         pjuHrPJ97B/HhjcCmtNaJ7/w8x4fzsxvL+rTJl7tsI+WpNLE4ViL+r97N5N552qt+g
         d6NBkghz8IbMw==
Date:   Tue, 27 Jul 2021 12:15:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH] xfs: prevent spoofing of rtbitmap blocks when recovering
 buffers
Message-ID: <20210727191502.GH559212@magnolia>
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

XXX: Won't this leave us with a corrupt rtbitmap if recovery also fails?
In other words, the usual problems that happen when you /don't/ track
buffer age with LSNs?  I've noticed that the recoveryloop tests get hung
up on incorrect frextents after a few iterations, but have not had time
to figure out if the rtbitmap recovery is wrong, or if there's something
broken with the old-style summary updates for rt counters.

XXXX: Maybe someone should fix the ondisk format to track the (magic,
blkno, lsn, uuid) like we do everything else in V5?  That's gonna suck
for 64-bit divisions...

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 05fd816edf59..a776bcfdf0c1 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -698,19 +698,29 @@ xlog_recover_do_inode_buffer(
 static xfs_lsn_t
 xlog_recover_get_buf_lsn(
 	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	struct xfs_buf_log_format *buf_f)
 {
 	uint32_t		magic32;
 	uint16_t		magic16;
 	uint16_t		magicda;
 	void			*blk = bp->b_addr;
 	uuid_t			*uuid;
-	xfs_lsn_t		lsn = -1;
+	uint16_t		blft;
+	xfs_lsn_t		lsn = NULLCOMMITLSN;
 
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
@@ -786,7 +796,13 @@ xlog_recover_get_buf_lsn(
 		break;
 	}
 
-	if (lsn != (xfs_lsn_t)-1) {
+	/*
+	 * ondisk buffers should never have a zero LSN, so recover those
+	 * buffers immediately.
+	 */
+	if (!lsn)
+		lsn = NULLCOMMITLSN;
+	if (lsn != NULLCOMMITLSN) {
 		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
 			goto recover_immediately;
 		return lsn;
@@ -805,7 +821,9 @@ xlog_recover_get_buf_lsn(
 		break;
 	}
 
-	if (lsn != (xfs_lsn_t)-1) {
+	if (!lsn)
+		lsn = NULLCOMMITLSN;
+	if (lsn != NULLCOMMITLSN) {
 		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
 			goto recover_immediately;
 		return lsn;
@@ -834,7 +852,7 @@ xlog_recover_get_buf_lsn(
 	/* unknown buffer contents, recover immediately */
 
 recover_immediately:
-	return (xfs_lsn_t)-1;
+	return NULLCOMMITLSN;
 
 }
 
@@ -920,8 +938,8 @@ xlog_recover_buf_commit_pass2(
 	 * the verifier will be reset to match whatever recover turns that
 	 * buffer into.
 	 */
-	lsn = xlog_recover_get_buf_lsn(mp, bp);
-	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
+	if (lsn != NULLCOMMITLSN && XFS_LSN_CMP(lsn, current_lsn) > 0) {
 		trace_xfs_log_recover_buf_skip(log, buf_f);
 		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
 		goto out_release;
