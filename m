Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AC4C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357717AbiATATT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57542 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345061AbiATATT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B206150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD010C004E1;
        Thu, 20 Jan 2022 00:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637958;
        bh=TcFCeBPnxLvqlpWygdscfZwtNWXM7c3b54HUHS2AP+g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bx0jhdMRdQUlGWdbTc0WlUJrbPxKbkDl6UF08Fmw5s2aJ2OF59Wwc6fteTtk2fTt2
         1eOu7RIM6K7oOXDjrr7AbOsjYtdYqkzTzegeJ6AIm33d35/W3WijU486YMa6htP4CR
         fN08F+prGjRlyMrDihXH1Uu2RbDyRj6C6x0sjdfLjO4CPnVuJQKUKfTwPQvosYIO8x
         s/+5yGYphtpmiVCUNFpPTiXKKzOA/8Kt9rSdr+2bNfkGdLQNLHFQhyml6c4uQhObQj
         WBGryodjd5g0ARY9oD3FpLTesee22zfeQ64NBjZBAfpojh+X8tnCzSIOjTbpU0dRRL
         kVBWfCmTcEo9Q==
Subject: [PATCH 21/45] xfs: sb verifier doesn't handle uncached sb buffer
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:18 -0800
Message-ID: <164263795838.860211.17501178713538130753.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 8cf07f3dd56195316be97758cb8b4e1d7183ea84

The verifier checks explicitly for bp->b_bn == XFS_SB_DADDR to match
the primary superblock buffer, but the primary superblock is an
uncached buffer and so bp->b_bn is always -1ULL. Hence this never
matches and the CRC error reporting is wholly dependent on the
mount superblock already being populated so CRC feature checks pass
and allow CRC errors to be reported.

Fix this so that the primary superblock CRC error reporting is not
dependent on already having read the superblock into memory.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_sb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index b2e214ee..f29a59ae 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -634,7 +634,7 @@ xfs_sb_read_verify(
 
 		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
-			if (bp->b_bn == XFS_SB_DADDR ||
+			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
 				error = -EFSBADCRC;
 				goto out_error;

