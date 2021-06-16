Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174B6C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 23:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2ABD6113C
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 23:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhFPX5u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFPX5u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 19:57:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEA1F60FD7;
        Wed, 16 Jun 2021 23:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623887744;
        bh=V+Om14e3dFOtK4Atx9RV7J+I68Z2jf2MKd3eJwEIQaU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HuM1j5iha3OpU/FgqkgNhpsVbx9H+MLRQWYUoSPwuvdOXub6kfm3hUS/kEgfiSQHt
         XipCIh6MeRsj5FsGH8mxsVfJsvM/mPVVUzVyX1EbDMjeF66sfJ3Ywqm0c7boQXLko0
         ZJuAv3nFQZ7kLJ5WR0fDA+InkR5/RjYmBR6K3+GWWBx5Odvm7C1fXp7d/SRXB4jpn7
         4JK2pblPyStKMXp2b4CSYzArj8ath+NzS1f+cLFLCK9JXc4gajBXk3dflQZVQrFiI4
         YGguTeNuzqnfgyKqm5YJoSJ0Y+FNhPdEyTm6IPg7w3ZO7pJ+fnK7z4MEsTbqpziQWA
         Cmeko1LvYMmEg==
Subject: [PATCH 1/2] xfs: fix log intent recovery ENOSPC shutdowns when
 inactivating inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 16 Jun 2021 16:55:43 -0700
Message-ID: <162388774359.3427167.14326615553028119265.stgit@locust>
In-Reply-To: <162388773802.3427167.4556309820960423454.stgit@locust>
References: <162388773802.3427167.4556309820960423454.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During regular operation, the xfs_inactive operations create
transactions with zero block reservation because in general we're
freeing space, not asking for more.  The per-AG space reservations
created at mount time enable us to handle expansions of the refcount
btree without needing to reserve blocks to the transaction.

Unfortunately, log recovery doesn't create the per-AG space reservations
when intent items are being recovered.  This isn't an issue for intent
item recovery itself because they explicitly request blocks, but any
inode inactivation that can happen during log recovery uses the same
xfs_inactive paths as regular runtime.  If a refcount btree expansion
happens, the transaction will fail due to blk_res_used > blk_res, and we
shut down the filesystem unnecessarily.

Fix this problem by making per-AG reservations temporarily so that we
can handle the inactivations, and releasing them at the end.  This
brings the recovery environment closer to the runtime environment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c3a96fb3ad80..d0755494597f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -859,9 +859,17 @@ xfs_mountfs(
 	/*
 	 * Finish recovering the file system.  This part needed to be delayed
 	 * until after the root and real-time bitmap inodes were consistently
-	 * read in.
+	 * read in.  Temporarily create per-AG space reservations for metadata
+	 * btree shape changes because space freeing transactions (for inode
+	 * inactivation) require the per-AG reservation in lieu of reserving
+	 * blocks.
 	 */
+	error = xfs_fs_reserve_ag_blocks(mp);
+	if (error && error == -ENOSPC)
+		xfs_warn(mp,
+	"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
 	error = xfs_log_mount_finish(mp);
+	xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;

