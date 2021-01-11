Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1295C4332E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 676E822DFA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403823AbhALAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404053AbhAKXXd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:23:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DD8A22D0B;
        Mon, 11 Jan 2021 23:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407372;
        bh=o0EuMUu85P1K6I8TN8omIXUC8NMS64DJj4NrqllsCgo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V8jwZEn3iWUqLctbW7z9RSxpUZ/8i7Jcidug7ZtlOJYOcTugmnejrqssNILLCcdDh
         fYTxmWZlVYMfJfVbn+tSDNhbKB+A8KLpGM+d56K/mhOctlMN14/4Ynu7pNuPq/E5se
         c42dJHxaBijkyWUN/vWrbTh/jnkySxJCijrDMtoTuPyXLPmvOM2OK5yzn1c4FdtRof
         HWCdG5G0I+Mfyy8++qtHrMpm+AnnDIv2e+jjuXO/uyPjkTOtRw86dcc3Wpi4wFprct
         7O0E0Lnd0aNXhLkUfkofkT9JGLPpLHGzfPO0I2zleranMgMmvkMKP1roPfBWE1aDRT
         s0JjkO4DC/6fg==
Subject: [PATCH 3/6] xfs: don't stall cowblocks scan if we can't take locks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:22:52 -0800
Message-ID: <161040737263.1582114.4973977520111925461.stgit@magnolia>
In-Reply-To: <161040735389.1582114.15084485390769234805.stgit@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't stall the cowblocks scan on a locked inode if we possibly can.
We'd much rather the background scanner keep moving.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 66af84c578b5..4e226827b33d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1624,17 +1624,31 @@ xfs_inode_free_cowblocks(
 	void			*args)
 {
 	struct xfs_eofblocks	*eofb = args;
+	bool			wait;
 	int			ret = 0;
 
+	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
+
 	if (!xfs_prep_free_cowblocks(ip))
 		return 0;
 
 	if (!xfs_inode_matches_eofb(ip, eofb))
 		return 0;
 
-	/* Free the CoW blocks */
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	/*
+	 * If the caller is waiting, return -EAGAIN to keep the background
+	 * scanner moving and revisit the inode in a subsequent pass.
+	 */
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+		if (wait)
+			return -EAGAIN;
+		return 0;
+	}
+	if (!xfs_ilock_nowait(ip, XFS_MMAPLOCK_EXCL)) {
+		if (wait)
+			ret = -EAGAIN;
+		goto out_iolock;
+	}
 
 	/*
 	 * Check again, nobody else should be able to dirty blocks or change
@@ -1644,6 +1658,7 @@ xfs_inode_free_cowblocks(
 		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 
 	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+out_iolock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 	return ret;

