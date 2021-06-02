Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB36C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7890C613DE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFBW1g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhFBW1g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96173613AC;
        Wed,  2 Jun 2021 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672752;
        bh=vxXoZgRI6FiBtxwPWteePD1FNJU6WoaJGZrddSUlDAA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EBAXnYLHXbOC/Na3UGjkKD6uG6OGc5UuAUxy1FKNJQAVvYiEuzT15znid1eDURA9j
         9yS+fF5l0T8hygCOI6XVEgaQiUwNTBmVSj9jfD8DaD+D4opuW8sfPR75mgsvLWIH3m
         HwQchHoAGfoW3Pc940UjGTCG6uvmIGMLPxPJwf+r0Voiackk2cSwwu15f4nMYt4lII
         JcsP9f6Osg41PCpvY/09niVYyYx8QTaCE9gBGwoPwc4Samrnld0vOjt1ddaIzQrTQb
         XlMiydyQ/YUAZYl6hHf2vswD4yAW42CP15aces4iyD6U7wCpNtmcR96gRHr4eqEHht
         zoFoxEGRSfcoA==
Subject: [PATCH 10/15] xfs: clean up inode state flag tests in
 xfs_blockgc_igrab
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:52 -0700
Message-ID: <162267275227.2375284.10086521959797919134.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up the definition of which inode states are not eligible for
speculative preallocation garbage collecting by creating a private
#define.  The deferred inactivation patchset will add two new entries to
the set of flags-to-ignore, so we want the definition not to end up a
cluttered mess.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5ca5bd2ee5ae..94dba5c1b98d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1533,6 +1533,10 @@ xfs_blockgc_start(
 		xfs_blockgc_queue(pag);
 }
 
+/* Don't try to run block gc on an inode that's in any of these states. */
+#define XFS_BLOCKGC_NOGRAB_IFLAGS	(XFS_INEW | \
+					 XFS_IRECLAIMABLE | \
+					 XFS_IRECLAIM)
 /*
  * Decide if the given @ip is eligible for garbage collection of speculative
  * preallocations, and grab it if so.  Returns true if it's ready to go or
@@ -1551,8 +1555,7 @@ xfs_blockgc_igrab(
 	if (!ip->i_ino)
 		goto out_unlock_noent;
 
-	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	if (ip->i_flags & XFS_BLOCKGC_NOGRAB_IFLAGS)
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 

