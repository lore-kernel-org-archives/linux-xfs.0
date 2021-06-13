Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C9AC48BCF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D5D61078
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhFMRW7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhFMRW7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A934761107;
        Sun, 13 Jun 2021 17:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604857;
        bh=zFgBoTO21uNmTCMlEEzvIbDbrRdHu1ZBnRuFhgH0hqs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nhKzpp8Stts8nq4AzLiKf1FCyIBt95t3lJZydR90wjcscFIKW/1HU8Fs2urIa3eVY
         1u+bhkP9CB0vs3OKP4j8t6BH3uyQ1SaOn74FIe1BvgUYa1ZK7ervfaa0KAbiycqXN3
         /6Xnrbn/ujwqRjJ21RseB4Faar0iqi7JHSkVQjcoR64gjgjYmPSi82O3dvi3I0tXPB
         swGA++xiUcCc9Kv4CKi6D9oIj8GQFgtWjDU2d1Qxsi6oxGoNWqmIAp6W2ShaS2A1HA
         5y0/OeFgZB4i7AayJM2K+JJlgM7X2E2cKHkdXSaSZIABgDEMnXp4hSc2idBupSQqWM
         tGVJvRvWpub6A==
Subject: [PATCH 11/16] xfs: flush inode inactivation work when compiling usage
 statistics
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:57 -0700
Message-ID: <162360485739.1530792.14898030232791253243.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
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
index 13a56e1ea15c..e203489cd212 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -698,6 +698,10 @@ xfs_qm_scall_getquota(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	/* Flush inodegc work at the start of a quota reporting scan. */
+	if (id == 0)
+		xfs_inodegc_flush(mp);
+
 	/*
 	 * Try to get the dquot. We don't want it allocated on disk, so don't
 	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
@@ -736,6 +740,10 @@ xfs_qm_scall_getquota_next(
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
index 0b01d9499395..45ef63b5b2f0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -769,6 +769,9 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
+	/* Wait for whatever inactivations are in progress. */
+	xfs_inodegc_flush(mp);
+
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
 

