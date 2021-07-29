Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68A5C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A5B60F4B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhG2SpJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhG2SpJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E0C60249;
        Thu, 29 Jul 2021 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584305;
        bh=5dRdYuhZFWv0aEbiwime3hjro4i/rifAXqHYC4hfY5w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oQLpXohiNSEG6yjgQECpdh2382F6nkXxGPdrSt7+ABzr+nt62NtrpCHg2SKkHQekw
         pIi+NBNs3lRer9gNYPzedHMEotxfkDuOihd9JgEqY/t8xGf4A7iHdRvNFg8ACAgWWS
         UstiQUFlvs5+vnnG+bQ8qdOGTMGKuy7GRZsZxs+kXJEZdnLTTmnZVMkeupMGLesIEg
         XzP9Fjr97FkDnSpOVs7uMxbSyHAhRxhGn/71J630cGowvip9EYK1elo/B1ZwwHRrWy
         f5kyhvW+mQH/UjJ9hAbpbFNu+zgGB5OvCiHvCf19mzjY/QCsD93do838IcfAhIRv+f
         k62XilgT4b3mA==
Subject: [PATCH 13/20] xfs: flush inode inactivation work when compiling usage
 statistics
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:45:05 -0700
Message-ID: <162758430518.332903.4841716756724944511.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
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
index c8207da0bb38..1f82726d6265 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -757,6 +757,9 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
+	/* Wait for whatever inactivations are in progress. */
+	xfs_inodegc_flush(mp);
+
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
 

