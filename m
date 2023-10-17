Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E43CDB482
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbjJQPzq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235105AbjJQPzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:55:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33FDF2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:55:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E62C433C8;
        Tue, 17 Oct 2023 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697558143;
        bh=uAwx71sR/AGrRScJ+mz4G2/6rb3sfqc3PL9jBLUVEXg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=AO6Xm8JsSM/q5G5M/rhCw8FnhYY081DihoyHaNVK4jYSNVADdWtjPGYyZNC29C59E
         ogKN4TnGHvAOqxlnSowQ/CllZRH4YZ2V87BnO+vZcgHf19msgB+jCtkolU02exbxwm
         yXuR9uZcya4hrebqDpqKj9lMoFoDP1VZRqkGAC6fb2mwnlC2SGjtacRsQzmIfWcu6s
         dYimT8lfClFn0t4Wkfj44Qo/H0hrEWM+Q2LbIrD92ZbMrJEJgTpdOQ+/9XIbbFARDn
         mdc9XbSyUFUsF36zLEAGwwF6ctNa5rUf9p55ibOY/NBCMZzvizp03q/uCRmrgOI2cf
         MnWsAsG8Fv1yA==
Date:   Tue, 17 Oct 2023 08:55:42 -0700
Subject: [PATCH 7/7] xfs: don't look for end of extent further than necessary
 in xfs_rtallocate_extent_near()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@fb.com, osandov@osandov.com, linux-xfs@vger.kernel.org,
        hch@lst.de
Message-ID: <169755742689.3167911.5736145188580519485.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

As explained in the previous commit, xfs_rtallocate_extent_near() looks
for the end of a free extent when searching backwards from the target
bitmap block. Since the previous commit, it searches from the last
bitmap block it checked to the bitmap block containing the start of the
extent.

This may still be more than necessary, since the free extent may not be
that long. We know the maximum size of the free extent from the realtime
summary. Use that to compute how many bitmap blocks we actually need to
check.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 12a7959913da..512c63dd7cab 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -527,13 +527,30 @@ xfs_rtallocate_extent_near(
 			 * On the negative side of the starting location.
 			 */
 			else {		/* i < 0 */
+				int	maxblocks;
+
 				/*
-				 * Loop backwards through the bitmap blocks
-				 * from where we last checked down to where we
-				 * are now.  There should be an extent which
-				 * ends in this bitmap block and is long
-				 * enough.
+				 * Loop backwards to find the end of the extent
+				 * we found in the realtime summary.
+				 *
+				 * maxblocks is the maximum possible number of
+				 * bitmap blocks from the start of the extent
+				 * to the end of the extent.
 				 */
+				if (maxlog == 0)
+					maxblocks = 0;
+				else if (maxlog < mp->m_blkbit_log)
+					maxblocks = 1;
+				else
+					maxblocks = 2 << (maxlog - mp->m_blkbit_log);
+
+				/*
+				 * We need to check bbno + i + maxblocks down to
+				 * bbno + i. We already checked bbno down to
+				 * bbno + j + 1, so we don't need to check those
+				 * again.
+				 */
+				j = min(i + maxblocks, j);
 				for (; j >= i; j--) {
 					error = xfs_rtallocate_extent_block(args,
 							bbno + j, minlen,

