Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BDDC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 940A722B40
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbhAWSxI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbhAWSxE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 303932310A;
        Sat, 23 Jan 2021 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427929;
        bh=lj5ly+kqPX3/icV0ZJlW+tlNZgyAPlY0iUkOkNPCU1A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YMYRZNJamIwTbLI9hYqQpbgkiXl0efRdkr/cMyIAmycVRRK0EFyECBm/vTuNkgLs4
         Ov3g5hTRHygswnxOLGhzwg9RuXATG35C47bI9Gly7RH2863YJuwwoal+oeavAIUAuS
         9x5JHXpob0+CMw6BrRxWVDxUBzU31yV3yMpkxWhOxezEUxY5dA0QJ3W07E3H9mroDd
         zoVkvAdml1aa267ZEs4JHW41M3vF7qQ+vxAMTw2aV4seRj/jKYgaat5/grOfOpc7vO
         4O55FGzdMUTQcN0TDdBtvxPBwwAVCuQQxso5AAtPbV1FtIXOE6PN4mzjt3mWy44+Kk
         1jbHEywIUC87g==
Subject: [PATCH 02/11] xfs: don't stall cowblocks scan if we can't take locks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:52:10 -0800
Message-ID: <161142793080.2171939.11486862758521454210.stgit@magnolia>
In-Reply-To: <161142791950.2171939.3320927557987463636.stgit@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
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

