Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA17C432C3
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE16D601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245659AbhCCDP4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360768AbhCBW3i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F60164F3C;
        Tue,  2 Mar 2021 22:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724128;
        bh=u/PZbnCVgqyAPpoXei0rDp5pzgZlOdXbA9oy/iIJnBQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QEZZN9UdCMpLjyRyyFGCRJCTnAhU0Cw6/QVU11FJiVtv/YNsqMWgHeXzqgDToER+k
         Y2d2l/e1laAeHF8ihlvZG2uIpnj5MoXDWQb4RpBgtQgrGN6VhARtHjXX1SWgEO+Wsz
         W7vOzCJta80LlK8sb4j4XON8TUZU5FbE7W/CAIPLgCeDeYfzMesqqcxjG37Es+F3ed
         kklANTZn0Jfor5tHHTnFLLteO8w+EY3ODueclCgf/NgwByaIZMKJKsG17MlFITEAGt
         zZzL9K9MY2o3DRmcRRRvhLxU3hfYVITK/nESq+FvF4YWf5ITzqyggz6dY362Cgxd8w
         4dJV55CC8P7DQ==
Subject: [PATCH 2/7] xfs: fix dquot scrub loop cancellation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 02 Mar 2021 14:28:47 -0800
Message-ID: <161472412783.3421582.2613422908869140732.stgit@magnolia>
In-Reply-To: <161472411627.3421582.2040330025988154363.stgit@magnolia>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When xchk_quota_item figures out that it needs to terminate the scrub
operation, it needs to return some error code to abort the loop, but
instead it returns zero and the loop keeps running.  Fix this by making
it use ECANCELED, and fix the other loop bailout condition check at the
bottom too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index e34ca20ae8e4..343f96f48b82 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -85,7 +85,7 @@ xchk_quota_item(
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
-		return error;
+		return -ECANCELED;
 
 	/*
 	 * Except for the root dquot, the actual dquot we got must either have
@@ -162,7 +162,7 @@ xchk_quota_item(
 
 out:
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return -EFSCORRUPTED;
+		return -ECANCELED;
 
 	return 0;
 }
@@ -238,6 +238,8 @@ xchk_quota(
 	error = xfs_qm_dqiterate(mp, dqtype, xchk_quota_item, &sqi);
 	sc->ilock_flags = XFS_ILOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
+	if (error == -ECANCELED)
+		error = 0;
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
 			sqi.last_id * qi->qi_dqperchunk, &error))
 		goto out;

