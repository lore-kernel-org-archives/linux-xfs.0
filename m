Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F62C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A37264E3B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBACEt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhBACEl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:04:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E892064E27;
        Mon,  1 Feb 2021 02:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145040;
        bh=lfkA60S3I/aD55G5mErbs2Pkmu4gHV0l6V0RjvCBEjg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SCl4eDBxYuO01e80vyrIN4JYQENO2L+EK5WPXzu8mzUxL89jkigHXq0J2N1KCowdk
         k46mp/Gyv+RWSe2g1cPgjlZQhT0l5yBfg/aJheHpKJ6ilgPvv459gUFzuwH4gc14QB
         G+RS9FkuTm5fi3vO+WKQ/WhkuQk2TgeAEcbgDrMISjesHXnny1zJUQxgeH8SoPa7CP
         zIwwZ8fZRSx608KW1kTMsQuJmNhMVngK1W3o4iaVdjoc0zPq0295UKdYeaKrCnTbz1
         OknhG7KkJBRSoGejK0angoTAcyvQCDSTZOXO19t/c46kz17dkjwTBXX/H1yNd9fhCP
         BiS9EF3jdZJcg==
Subject: [PATCH 02/17] xfs: clean up quota reservation callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:04:00 -0800
Message-ID: <161214504017.139387.372496616035709194.stgit@magnolia>
In-Reply-To: <161214502818.139387.7678025647736002500.stgit@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    3 +--
 fs/xfs/xfs_bmap_util.c   |    4 ++--
 fs/xfs/xfs_reflink.c     |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7ea1dbbe3d0b..c730288b5981 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4937,8 +4937,7 @@ xfs_bmap_del_extent_delay(
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
index f3f8c48ff5bf..792809debaaa 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -884,8 +884,8 @@ xfs_unmap_extent(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot, ip->i_gdquot,
-			ip->i_pdquot, resblks, 0, XFS_QMOPT_RES_REGBLKS);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+			XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e1c98dbf79e4..183142fd0961 100644
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

