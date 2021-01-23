Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F39C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A4222D50
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbhAWSwU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:52:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbhAWSwT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:52:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2483E22D2B;
        Sat, 23 Jan 2021 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427899;
        bh=B0yXme5QCx/90B5R7AzLaX9Y6j2dq9GE1iNP/0zhHtk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CZ7R6hKZ6SQ2WS0zulngQVfw/5sKhS6dQzEPwp3OcPCBu8EmKKg12YSAlNrb/jtp6
         6Ud12ZXmIqWXOCj+DCUzhYnsn8hcOV6gUNBIStBccJNwu42uR6TIS/nHV0QwQGWw1N
         Tb5/hOHVP6yykxnBvenh3lrMkP/RRHhRgaFEgHWH9wO4UeOjmmPdHpoZQgkxADpz4m
         qmiz+WyNpPy7hLlPft8nJ8CRd+3F723lAf3geZI06kjQ8eAU3S8E+3O42PcQ1HZuzc
         4avLEdaXTc6Az2Y7GMQ6N83QqsRO8ROaXBi444Gk7PUwh338u0ThWDouMlsxQPw+Ad
         CWacbkQMjZ+Sg==
Subject: [PATCH 1/4] xfs: clean up quota reservation callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:51:40 -0800
Message-ID: <161142790077.2170981.3836953907583983452.stgit@magnolia>
In-Reply-To: <161142789504.2170981.1372317837643770452.stgit@magnolia>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
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
---
 fs/xfs/libxfs/xfs_bmap.c |    3 +--
 fs/xfs/xfs_bmap_util.c   |    4 ++--
 fs/xfs/xfs_reflink.c     |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2cd24bb06040..aea179212946 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4938,8 +4938,7 @@ xfs_bmap_del_extent_delay(
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

