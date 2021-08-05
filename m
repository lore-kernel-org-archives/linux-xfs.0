Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF39C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9366761078
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbhHECHc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhHECHb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 386A36105A;
        Thu,  5 Aug 2021 02:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129238;
        bh=19dHhPpkzH7XvnWf8NXKANELN1jyZ8G4WIQas3xfWHg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iYZalK8Px2CCShq+/27vj8wTwxUYge/K0dqx/3YHW9/0x4YztOBvFiTgmBAfS9MYm
         hRG91mASJvyMRV1sdT7rnIiNqR34Y78HcWbaV8aVxckSw7H51oMLlfMbExf1e8jHfu
         7r5DnPn7FHEtn8dElICoGbHxUfldXY1VpGIj+KoGRGT82Mbyn/j0yFSSIP6qx/1jn8
         0Edgl+v204sXRsxXNMvILGfXI1a6KfPYsaZmmNcbawEWelfauhGBjcz0c3SZsfe7+t
         YsnjL6Tu2yxXCMG6u2m5M3y3LQkOJyN0nsYFrBu28H+MRQreW1nxSOXfVOs3DmKqjU
         v73HCbKNLRRMg==
Subject: [PATCH 10/14] xfs: flush inode inactivation work when compiling usage
 statistics
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:07:17 -0700
Message-ID: <162812923793.2589546.9838243331962795901.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Users have come to expect that the space accounting information in
statfs and getquota reports are fairly accurate.  Now that we inactivate
inodes from a background queue, these numbers can be thrown off by
whatever resources are singly-owned by the inodes in the queue.  Flush
the pending inactivations when userspace asks for a space usage report.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm_syscalls.c |    8 ++++++++
 fs/xfs/xfs_super.c       |    3 +++
 2 files changed, 11 insertions(+)


diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 982cd6613a4c..c6902f9d064c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -481,6 +481,10 @@ xfs_qm_scall_getquota(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	/* Flush inodegc work at the start of a quota reporting scan. */
+	if (id == 0)
+		xfs_inodegc_flush(mp);
+
 	/*
 	 * Try to get the dquot. We don't want it allocated on disk, so don't
 	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
@@ -519,6 +523,10 @@ xfs_qm_scall_getquota_next(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	/* Flush inodegc work at the start of a quota reporting scan. */
+	if (*id == 0)
+		xfs_inodegc_flush(mp);
+
 	error = xfs_qm_dqget_next(mp, *id, type, &dqp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ade192ea4230..2ac040c95703 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -788,6 +788,9 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
+	/* Wait for whatever inactivations are in progress. */
+	xfs_inodegc_flush(mp);
+
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
 

