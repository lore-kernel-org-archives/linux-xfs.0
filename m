Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEF1C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8F0761078
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbhHECH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhHECH0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2D4B61073;
        Thu,  5 Aug 2021 02:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129232;
        bh=BOm2pyA7dH73sxTmrKF8WEk1vdYEyI4OKt+8CGGYeyY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VdZk2G2lLNNh+agTbGJKgL5cgzKLvA9flmglangiGY76uTFA/hn3E+NjJS0SdVtVF
         IIzLNx7hbBF+rZXIAveFYhmbF2rmqg87Cw1REa/bYkG5PKyCQ8uaUy+1jD/XfX2XYo
         x2XMj1awfVQW2Tz1ZPA72YoBiSN2VLKdCt6Lm7PcTsegHxpfxLd5bl+2sHyywh/wnb
         CEsSmTegELsszKV6OM2QEgR9hMuFNohkYApqevPKjg0V1kKm+LohvT0GOELaMOODRi
         PPuaoxVtTUrHxmWm3S7K/uUNpGKOVogtouytjoQkk0hG45gS/bHUtbHdZEO5zs1vnd
         BLJeM4ULf/n4w==
Subject: [PATCH 09/14] xfs: inactivate inodes any time we try to free
 speculative preallocations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:07:12 -0700
Message-ID: <162812923242.2589546.4318604170788681871.stgit@magnolia>
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

Other parts of XFS have learned to call xfs_blockgc_free_{space,quota}
to try to free speculative preallocations when space is tight.  This
means that file writes, transaction reservation failures, quota limit
enforcement, and the EOFBLOCKS ioctl all call this function to free
space when things are tight.

Since inode inactivation is now a background task, this means that the
filesystem can be hanging on to unlinked but not yet freed space.  Add
this to the list of things that xfs_blockgc_free_* makes writer threads
scan for when they cannot reserve space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4a062cf689c3..f2d12405dd87 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1468,16 +1468,24 @@ xfs_blockgc_worker(
 }
 
 /*
- * Try to free space in the filesystem by purging eofblocks and cowblocks.
+ * Try to free space in the filesystem by purging inactive inodes, eofblocks
+ * and cowblocks.
  */
 int
 xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_icwalk	*icw)
 {
+	int			error;
+
 	trace_xfs_blockgc_free_space(mp, icw, _RET_IP_);
 
-	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
+	error = xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
+	if (error)
+		return error;
+
+	xfs_inodegc_flush(mp);
+	return 0;
 }
 
 /*

