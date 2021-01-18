Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3B2C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354F3230FA
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbhARWM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbhARWMU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:12:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CB3122D58;
        Mon, 18 Jan 2021 22:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007899;
        bh=uXtiwuJyWsmGT5hI+rYkU4ZpGHgdmFb6kCmvHO+FQLQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=blP0zMopNLeBFYyXHMvzdx8pniVbsQQJ7fo9Xi7p3Uqw/xv8sDL8zfbFXY4469SKd
         VaOILTPUMKTCfAnDmiQ1EwXLj990dwb/CoNru0wvVF7O9pmlUvMu0hDt/qqOoUK3T8
         RxWM51QxjtL69F26eZyqkn3sdFuv5Q270dCtJrOjyGfFfY4jN9nHu57LER/1i/8XS7
         A74BIap6Awxmu7/llo0iFisjZIgoJ2xu6vJ1sI54axthnPwLO+sRtPgQQC3Tsx8xqI
         2kXxCKfc+RQLyEETRzfljHDxILuNmhLeKW3tuJ/dHwrIAuEJlPGrkTSxyqatW7LaWX
         tHJQAtRYSr8Dg==
Subject: [PATCH 1/4] xfs: clean up quota reservation callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:11:39 -0800
Message-ID: <161100789930.88678.12106031748396086815.stgit@magnolia>
In-Reply-To: <161100789347.88678.17195697099723545426.stgit@magnolia>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert a few xfs_trans_*reserve* callsites that are open-coding other
convenience functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    3 +--
 fs/xfs/xfs_bmap_util.c   |    4 ++--
 fs/xfs/xfs_reflink.c     |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bc446418e227..21076ac2485a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4826,8 +4826,7 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_trans_reserve_quota_nblks(NULL, ip,
-			-((long)del->br_blockcount), 0,
+	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
 			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7371a7f7c652..671cb104861e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -879,8 +879,8 @@ xfs_unmap_extent(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot, ip->i_gdquot,
-			ip->i_pdquot, resblks, 0, XFS_QMOPT_RES_REGBLKS);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+			XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..20321d03e31c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -508,8 +508,8 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_trans_reserve_quota_nblks(NULL, ip,
-					-(long)del.br_blockcount, 0,
+			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
+					del.br_blockcount, 0,
 					XFS_QMOPT_RES_REGBLKS);
 			if (error)
 				break;

