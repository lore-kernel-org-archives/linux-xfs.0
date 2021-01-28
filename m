Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B935BC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D77D64DDC
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhA1GFe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231276AbhA1GEk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:04:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC18364DD6;
        Thu, 28 Jan 2021 06:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813840;
        bh=FRvfSwh0xnJz3472kG4IgSzE/6pf76d/1slWLgIRZus=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cW3KdHRJVhtA6W3gK0OJI6nTw7xcCs9ulgnB+nKTsXpKzyPvN0J2gf76ivp0nJS2A
         BzsjWwCd4maHYrEY3bRFX9SkGTa/f+jCdMjSfRyTTuir6KF7bzWGNDPTyuzKkTds/+
         nzWj4jA1ssP/fXxVC81QJECAjYdEAuH30FkX9dNVarAONW+7laFpFna9pH+0MS/M2L
         lkB6LQCglFEC9aJ/Ee9ng4RsWt54DRmC6jbQ4TOzRUkDa9uuIWOZgEeBD5EnQNVTbf
         eTPCxWQB3YFvS1i2L9Pm2fSXBlc9NZYD1EZ4zJzBzMXEpRqhxYir6GTLeLQEPtlDfv
         9/+6BeyAhTL8w==
Subject: [PATCH 03/11] xfs: hide xfs_icache_free_cowblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:56 -0800
Message-ID: <161181383624.1525433.366988385340897400.stgit@magnolia>
In-Reply-To: <161181381898.1525433.10723801103841220046.stgit@magnolia>
References: <161181381898.1525433.10723801103841220046.stgit@magnolia>
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
index 2e1b3887754a..ef4c0659f38f 100644
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
index 8959561351ca..e8f71714d737 100644
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

