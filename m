Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE80C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbiLaBRY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbiLaBRW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:17:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330D11DDF3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:17:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4F8161D78
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31930C433EF;
        Sat, 31 Dec 2022 01:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449441;
        bh=NpcS68SNppusa38Iu9fJ4vk7KNtkJ4f/M3I+j9a2MKk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bfRRZArxf37ncoLS/7E/w/lvgaHBD2YOtbNhZNDeexKxEubyCAX1MB29bUVQQAxUu
         fwm7Xrp7QBxTtauhPKu+XycMxHkhKRGkMPhYNDWvxR7UC3yacthklDUXAImEPU7FTW
         7z3fizdFW8JFuJmkiJObeWZ0yJGE8Dz4hA4xBVFuTB0cyxZ67sDplSz3ZRmuu6voWo
         K5KqNQsqQZlRecQD0A8FBzjzBcJRSVlk59mjioUHxWPlE0L34hSPZyJrl8zotdvNAg
         OVnkY8P31eJPjttyIU3FqgDNoZJiW1otQg90QPPoP7m+xEMRGkNNz++oKfQTSvIFox
         z+DOowuAu7gIw==
Subject: [PATCH 04/14] xfs: fix a sloppy memory handling bug in
 xfs_iroot_realloc
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:31 -0800
Message-ID: <167243865165.708933.12401569768700467243.stgit@magnolia>
In-Reply-To: <167243865089.708933.5645420573863731083.stgit@magnolia>
References: <167243865089.708933.5645420573863731083.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While refactoring code, I noticed that when xfs_iroot_realloc tries to
shrink a bmbt root block, it allocates a smaller new block and then
copies "records" and pointers to the new block.  However, bmbt root
blocks cannot ever be leaves, which means that it's not technically
correct to copy records.  We /should/ be copying keys.

Note that this has never resulted in actual memory corruption because
sizeof(bmbt_rec) == (sizeof(bmbt_key) + sizeof(bmbt_ptr)).  However,
this will no longer be true when we start adding realtime rmap stuff,
so fix this now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 0f220f100069..b73b971b83cd 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -466,15 +466,15 @@ xfs_iroot_realloc(
 	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
 
 	/*
-	 * Only copy the records and pointers if there are any.
+	 * Only copy the keys and pointers if there are any.
 	 */
 	if (new_max > 0) {
 		/*
-		 * First copy the records.
+		 * First copy the keys.
 		 */
-		op = (char *)xfs_bmbt_rec_addr(mp, ifp->if_broot, 1);
-		np = (char *)xfs_bmbt_rec_addr(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
+		op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
+		np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
 
 		/*
 		 * Then copy the pointers.

