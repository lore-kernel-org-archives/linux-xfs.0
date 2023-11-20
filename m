Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7A5C2BB3F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 18:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjKTSbn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjKTSbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 13:31:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0207CD
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 10:31:39 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6220FC433C7;
        Mon, 20 Nov 2023 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700505099;
        bh=LWGYxjl7IvPfAnPTQ+tP0ChwxVYMjuKVLgOEtHJ7M1c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QuFFtFDb0wrjVZMQphIumTYsjBftphR3xQwUPEmFdyN5O7iKkBEWmBeT2JYwGFNu2
         ZAo7ZxLt06qOKzNpXQOCuSMvhud1J0NA5ncc9pggUNsz9kJEcD2lQARSAzFAXDTDk+
         J9wucEvPwzBG/8clOlbx6kjwflSTDA+54Jx+fzY+2Z2ZE71P7CG+iMXhaZqMOI2hOc
         v7hPm2gaGDOQfNpnzfrSaaWyEZDn/LtyL9YBSexA04gCObLT1AX00eO5xiqNIOfMMs
         Bwk4ReQiKXqHLmbKXCNtn4W4r6rxB8zM27+ElJqfI+rvEhAcTh41k+dACkjIOtsb2T
         oHCs0SAPja/ag==
Subject: [PATCH 1/2] xfs: clean up dqblk extraction
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org, chandanbabu@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 Nov 2023 10:31:38 -0800
Message-ID: <170050509891.475996.3583155500177528277.stgit@frogsfrogsfrogs>
In-Reply-To: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
References: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since the introduction of xfs_dqblk in V5, xfs really ought to find the
dqblk pointer from the dquot buffer, then compute the xfs_disk_dquot
pointer from the dqblk pointer.  Fix the open-coded xfs_buf_offset calls
and do the type checking in the correct order.

Note that this has made no practical difference since the start of the
xfs_disk_dquot is coincident with the start of the xfs_dqblk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c              |    5 +++--
 fs/xfs/xfs_dquot_item_recover.c |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ac6ba646624d..a013b87ab8d5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -562,7 +562,8 @@ xfs_dquot_from_disk(
 	struct xfs_dquot	*dqp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
+	struct xfs_dqblk	*dqb = xfs_buf_offset(bp, dqp->q_bufoffset);
+	struct xfs_disk_dquot	*ddqp = &dqb->dd_diskdq;
 
 	/*
 	 * Ensure that we got the type and ID we were looking for.
@@ -1250,7 +1251,7 @@ xfs_qm_dqflush(
 	}
 
 	/* Flush the incore dquot to the ondisk buffer. */
-	dqblk = bp->b_addr + dqp->q_bufoffset;
+	dqblk = xfs_buf_offset(bp, dqp->q_bufoffset);
 	xfs_dquot_to_disk(&dqblk->dd_diskdq, dqp);
 
 	/*
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 8966ba842395..db2cb5e4197b 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -65,6 +65,7 @@ xlog_recover_dquot_commit_pass2(
 {
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
+	struct xfs_dqblk		*dqb;
 	struct xfs_disk_dquot		*ddq, *recddq;
 	struct xfs_dq_logformat		*dq_f;
 	xfs_failaddr_t			fa;
@@ -130,14 +131,14 @@ xlog_recover_dquot_commit_pass2(
 		return error;
 
 	ASSERT(bp);
-	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	dqb = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	ddq = &dqb->dd_diskdq;
 
 	/*
 	 * If the dquot has an LSN in it, recover the dquot only if it's less
 	 * than the lsn of the transaction we are replaying.
 	 */
 	if (xfs_has_crc(mp)) {
-		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
 		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
 
 		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
@@ -147,7 +148,7 @@ xlog_recover_dquot_commit_pass2(
 
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
 	if (xfs_has_crc(mp)) {
-		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
+		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
 

