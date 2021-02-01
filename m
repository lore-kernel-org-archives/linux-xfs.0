Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3F5C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAADC64E31
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhBACG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231299AbhBACGS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:06:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14D5364E30;
        Mon,  1 Feb 2021 02:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145138;
        bh=jn/dvz5OiwnVJgieJe/JeDwwsQvJajjHf++sPF6wJUI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EaAym+lGTiCAeyIsjCimuO1i5mAP8QBzDoAgrXaMdI3kX47u4Ha1uuwCtIga5Hryo
         4+eIhvYIdRlS1lutRSpG+j0v8wybsGcCsGzaHpTpcKTAZhlxr7TZHdoDAItxo0mL63
         HlZvn7iFzTy3jWpT7ouWK8Vj2q/TDg8FFDpjY1gI7MF+LS6LKmXuYoJjRNiH3Q56y7
         UIZO1uoH55ZpdP8rjaL04hEW1ypiBNfYQMA6GLgl6/tBZrHbe/01zNHu8iX/UBfiL1
         bs714wVxJjb4ssIHE6CCiyi4N21JRfQ/DTqfzv8SUYU9dnomi2Qx0ND3Ynp6tB/Akj
         uISAsc4/mGf2Q==
Subject: [PATCH 02/12] xfs: don't stall cowblocks scan if we can't take locks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:05:37 -0800
Message-ID: <161214513774.140945.16055676820244681370.stgit@magnolia>
In-Reply-To: <161214512641.140945.11651856181122264773.stgit@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c71eb15e3835..89f9e692fde7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1605,17 +1605,31 @@ xfs_inode_free_cowblocks(
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
@@ -1625,6 +1639,7 @@ xfs_inode_free_cowblocks(
 		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 
 	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+out_iolock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 	return ret;

