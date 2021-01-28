Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7FFC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E7564DDF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhA1GEZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:04:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhA1GEV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:04:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A098064DDA;
        Thu, 28 Jan 2021 06:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813845;
        bh=4YKG876IBqT95Pw8jEZsOh8/TOGpBs+fQAQ6l7u9QKA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=obFPQy06yVWdXqiRWr0ARk2mvjmHZBEO1eJjmug+3+/FbtVP21ZaqbdzTh+NxQJi0
         t3uM3N3C2FDzOddy0KJG5LUh4dZGxClc0UK7SMdXLRZhTe/N3GkZUEutNa4JeVD6B6
         ba8soKZ3O1/+eDPue2rvKPJdfVkXF9hvX9VuSnKAMH89tWeZTrQ3GuulwIK02fDlcB
         GbSChiuvnTQ0Wxqs0kdwKTp9OYyi4O7cCGJctSyCdQ8/njkvKbTsSO92qrngk3z9ZF
         MgfcDC6xfaN82v9SxDxtwot1oU45SWrVaqbP8tKKA4neCCbP7zsA9TYH4ul0E4Rn6y
         cbHdvbjWnOhXA==
Subject: [PATCH 04/11] xfs: remove trivial eof/cowblocks functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:04:01 -0800
Message-ID: <161181384185.1525433.2813580381124919097.stgit@magnolia>
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

Get rid of these trivial helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ef4c0659f38f..7440ae93b204 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1324,15 +1324,6 @@ xfs_inode_free_eofblocks(
 	return ret;
 }
 
-static int
-xfs_icache_free_eofblocks(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
-{
-	return xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
-			XFS_ICI_EOFBLOCKS_TAG);
-}
-
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
  * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
@@ -1358,7 +1349,8 @@ xfs_eofblocks_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	xfs_icache_free_eofblocks(mp, NULL);
+	xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, NULL,
+			XFS_ICI_EOFBLOCKS_TAG);
 	sb_end_write(mp->m_super);
 
 	xfs_queue_eofblocks(mp);
@@ -1567,15 +1559,6 @@ xfs_inode_free_cowblocks(
 	return ret;
 }
 
-static int
-xfs_icache_free_cowblocks(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
-{
-	return xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
-			XFS_ICI_COWBLOCKS_TAG);
-}
-
 /*
  * Background scanning to trim preallocated CoW space. This is queued
  * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
@@ -1602,7 +1585,8 @@ xfs_cowblocks_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	xfs_icache_free_cowblocks(mp, NULL);
+	xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, NULL,
+			XFS_ICI_COWBLOCKS_TAG);
 	sb_end_write(mp->m_super);
 
 	xfs_queue_cowblocks(mp);
@@ -1653,11 +1637,13 @@ xfs_blockgc_scan(
 {
 	int			error;
 
-	error = xfs_icache_free_eofblocks(mp, eofb);
+	error = xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
+			XFS_ICI_EOFBLOCKS_TAG);
 	if (error)
 		return error;
 
-	error = xfs_icache_free_cowblocks(mp, eofb);
+	error = xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
+			XFS_ICI_COWBLOCKS_TAG);
 	if (error)
 		return error;
 

