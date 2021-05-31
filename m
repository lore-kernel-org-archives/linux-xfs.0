Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F69C47082
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC8A6611CA
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhEaWmy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhEaWmx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F5D60FDC;
        Mon, 31 May 2021 22:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500873;
        bh=ve4/+B7ihihTcsno8nIpyoQCEzSiyEeYfiPNOHlwcn4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FVHIyTp391sCKBHJQXRe47gTCU0Xhba7y/Uo8ju3kLew9I3AxskGzuBAkQSbyOWys
         nHzo87He9t1SQSOxaNnSxqxTD0W9We664JlCeW5NjsyPXea85EVqE+O8jSS47CRwOx
         lo8IoTZ9uvuPvTEbOSBrmSSRJ26EhiZbHqM09D3j4Nuqfg9I9u8fp2oYEIdyjrgrYx
         bUI6bwfEK2kyvBbVuwy++l9r0suABsSb9OIlr14THyB69oNvV8lDGuBJI9unrT5wrK
         cxOoOaufhJdp7pTb9pgxOOYcm5C3nApfVd79ao7mKyPQRTZB+lhN3GgGLnu392/uLG
         wAjDlWVkZR1qw==
Subject: [PATCH 4/5] xfs: drop inactive dquots before inactivating inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:41:13 -0700
Message-ID: <162250087317.490412.346108244268292896.stgit@locust>
In-Reply-To: <162250085103.490412.4291071116538386696.stgit@locust>
References: <162250085103.490412.4291071116538386696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During quotaoff, the incore inode scan to detach dquots from inodes
won't touch inodes that have lost their VFS state but haven't yet been
queued for reclaim.  This isn't strictly a problem because we drop the
dquots at the end of inactivation, but if we detect this situation
before starting inactivation, we can drop the inactive dquots early to
avoid delaying quotaoff further.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a2dab05332ac..79f1cd1a0221 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -637,22 +637,46 @@ xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 
 	trace_xfs_destroy_inode(ip);
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
-	XFS_STATS_INC(ip->i_mount, vn_rele);
-	XFS_STATS_INC(ip->i_mount, vn_remove);
+	XFS_STATS_INC(mp, vn_rele);
+	XFS_STATS_INC(mp, vn_remove);
+
+	/*
+	 * If a quota type is turned off but we still have a dquot attached to
+	 * the inode, detach it before processing this inode to avoid delaying
+	 * quotaoff for longer than is necessary.
+	 *
+	 * The inode has no VFS state and hasn't been tagged for any kind of
+	 * reclamation, which means that iget, quotaoff, blockgc, and reclaim
+	 * will not touch it.  It is therefore safe to do this locklessly
+	 * because we have the only reference here.
+	 */
+	if (!XFS_IS_UQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_udquot);
+		ip->i_udquot = NULL;
+	}
+	if (!XFS_IS_GQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_gdquot);
+		ip->i_gdquot = NULL;
+	}
+	if (!XFS_IS_PQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
 
 	xfs_inactive(ip);
 
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
+	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
 		xfs_check_delalloc(ip, XFS_COW_FORK);
 		ASSERT(0);
 	}
 
-	XFS_STATS_INC(ip->i_mount, vn_reclaim);
+	XFS_STATS_INC(mp, vn_reclaim);
 
 	/*
 	 * We should never get here with one of the reclaim flags already set.

