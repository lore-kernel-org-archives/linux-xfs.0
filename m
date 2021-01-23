Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E059FC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAB9C230FC
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbhAWSx4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbhAWSxw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1317C22D50;
        Sat, 23 Jan 2021 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611428017;
        bh=kqWzicUVW6RyqOR45MuHTs/05B21CrK8bFBbSYnz0yQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mYwEYKejJtuxieB5l9UO//FG6fbJ08+O24+PqXEyl6w01s3oZsln7bZYr8uIuXCYe
         yKRIzzdvPBFN0D52GzixXhZREpCKFA9YKiFn/EQgs5+4tLlM1hY1B7sYO8kyzmqqac
         TC7EDCfLPHYX3KLWAxKMNUbYx/WMvAQqvgIlWcF8M/RrWnexnq5On5CCZoLRftFvxK
         ndQ28HefjW8VQBn4Ie9F67A4D2/Qn8Y3+4QvwMnqtZgrsVPGetTRTw0+fw/aCncw+5
         gL9Lx1eRzDwjpekgeRxkkedVIB3Gwul4jKulGpxUQD3nA04K592rB4+1yYeaK+IZUt
         01Svw4HNJsVXA==
Subject: [PATCH 3/9] xfs: hide xfs_icache_free_cowblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:38 -0800
Message-ID: <161142801869.2173480.15740054426783383934.stgit@magnolia>
In-Reply-To: <161142800187.2173480.17415824680111946713.stgit@magnolia>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change the one remaining caller of xfs_icache_free_cowblocks to use our
new combined blockgc scan function instead, since we will soon be
combining the two scans.  This introduces a slight behavior change,
since a readonly remount now clears out post-EOF preallocations and not
just CoW staging extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_icache.h |    1 -
 fs/xfs/xfs_super.c  |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4137ad853b17..db32ad2f6ced 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1567,7 +1567,7 @@ xfs_inode_free_cowblocks(
 	return ret;
 }
 
-int
+static int
 xfs_icache_free_cowblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index c23e49aab683..8566798d42ab 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -66,7 +66,6 @@ void xfs_queue_eofblocks(struct xfs_mount *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ebe3eba2cbbc..e440065ec503 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1713,7 +1713,7 @@ xfs_remount_ro(
 	xfs_stop_block_reaping(mp);
 
 	/* Get rid of any leftover CoW reservations... */
-	error = xfs_icache_free_cowblocks(mp, NULL);
+	error = xfs_blockgc_free_space(mp, NULL);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;

