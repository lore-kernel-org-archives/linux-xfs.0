Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712C3C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3784561A42
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhCZAVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCZAVF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84DDF619F8;
        Fri, 26 Mar 2021 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718065;
        bh=KnJlOksD1+2L0pzxZsr63lstx3kgGP+xpaXd48aCnls=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WCeW03oiF0HwcvUr9k/6sBF1Jf/PvLvpOHP31af7xoJSEJKUSRHoUhihRhDTGaY3p
         rQ9eswVt8zsAH0aVz6kDz0o9CaDJtx4UdHN4CgIez2qqVdIJqG8pWnmd1/feHMnOoC
         vruh+ajWvKT49yx5w41oQZT6GxZDnONk5BLwxOdpbtIkxq48HbFx1GNAhU3dkvgr6Q
         3u6B6R974BiKB9CiYmNPby18yNS/9cCo9g2fhC9HXYvst/plSoOc9yyjZt+12MnDb9
         ITUIGo/DUW0vBILhWj+yGf38YzSVUg+vqTQL9rBEOyHHatL8VCOP3Q8Pv07Sb/U4ds
         WFBaXce4m/Y5Q==
Subject: [PATCH 1/2] xfs: move the xfs_can_free_eofblocks call under the
 IOLOCK
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:05 -0700
Message-ID: <161671806513.621829.6973192250605604420.stgit@magnolia>
In-Reply-To: <161671805938.621829.266575450099624132.stgit@magnolia>
References: <161671805938.621829.266575450099624132.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In xfs_inode_free_eofblocks, move the xfs_can_free_eofblocks call
further down in the function to the point where we have taken the
IOLOCK.  This is preparation for the next patch, where we will need that
lock (or equivalent) so that we can check if there are any post-eof
blocks to clean out.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2fd4a39acb46..3c81daca0e9a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1296,13 +1296,6 @@ xfs_inode_free_eofblocks(
 	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
 		return 0;
 
-	if (!xfs_can_free_eofblocks(ip, false)) {
-		/* inode could be preallocated or append-only */
-		trace_xfs_inode_free_eofblocks_invalid(ip);
-		xfs_inode_clear_eofblocks_tag(ip);
-		return 0;
-	}
-
 	/*
 	 * If the mapping is dirty the operation can block and wait for some
 	 * time. Unless we are waiting, skip it.
@@ -1324,7 +1317,13 @@ xfs_inode_free_eofblocks(
 	}
 	*lockflags |= XFS_IOLOCK_EXCL;
 
-	return xfs_free_eofblocks(ip);
+	if (xfs_can_free_eofblocks(ip, false))
+		return xfs_free_eofblocks(ip);
+
+	/* inode could be preallocated or append-only */
+	trace_xfs_inode_free_eofblocks_invalid(ip);
+	xfs_inode_clear_eofblocks_tag(ip);
+	return 0;
 }
 
 /*

