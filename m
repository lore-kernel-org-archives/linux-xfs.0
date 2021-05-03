Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D494C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 21:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3E06611AC
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 21:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhECVft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 17:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhECVfs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 May 2021 17:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA647611AC;
        Mon,  3 May 2021 21:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620077695;
        bh=yhrc0FfyvVnfaZE4PKu9dshwPFjjBHfQ9yHqkyRUjfs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HfrkZRt8rkfqLkDiIDBGh0NrrnqRUmtG55McdjIuV7spmCnDayY23YAf1T6Q8+f5Y
         sFarMFBk0OSj1myevkKwWY0r4x7aj+H1FzA9cdPh2ZoshACwdAyGb5SJVYL14jFsDF
         HLZe7tKTrkTup/u3OZNnJwfF+4Xewiv3G03foAEwVCCEIMig58VVopnzlFOi9D7gfH
         ka6fg+UGE079jUQf9+Osu0gikfOI5mvaey+rCjwBUOqmGX/8X3ysN5LUpXH5nvyspa
         kYwkD90QjbKw64P13so3GIUbh5B0ghrvTJjEgXwBbgTgqCRnWUqla1g7UkELHU4CCJ
         gZRoe24SDWv9Q==
Subject: [PATCH 2/2] xfs: retry allocations when locality-based search fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 03 May 2021 14:34:54 -0700
Message-ID: <162007769456.836421.14886406791989530317.stgit@magnolia>
In-Reply-To: <162007768318.836421.15582644026342097489.stgit@magnolia>
References: <162007768318.836421.15582644026342097489.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a realtime allocation fails because we can't find a sufficiently
large free extent satisfying locality rules, relax the locality rules
and try again.  This reduces the occurrence of short writes to realtime
files when the write size is large and the free space is fragmented.

This was originally discovered by running generic/186 with the realtime
reflink patchset and a 128k cow extent size hint, but the same problem
can manifest with a 128k extent size hint, so applies the fix now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c9381bf4f04b..0936f3a96fe6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -84,6 +84,7 @@ xfs_bmap_rtalloc(
 	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
 	xfs_extlen_t		raminlen;
 	bool			rtlocked = false;
+	bool			ignore_locality = false;
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
@@ -158,7 +159,10 @@ xfs_bmap_rtalloc(
 	/*
 	 * Realtime allocation, done through xfs_rtallocate_extent.
 	 */
-	do_div(ap->blkno, mp->m_sb.sb_rextsize);
+	if (ignore_locality)
+		ap->blkno = 0;
+	else
+		do_div(ap->blkno, mp->m_sb.sb_rextsize);
 	rtb = ap->blkno;
 	ap->length = ralen;
 	raminlen = max_t(xfs_extlen_t, 1, minlen / mp->m_sb.sb_rextsize);
@@ -197,6 +201,15 @@ xfs_bmap_rtalloc(
 		goto retry;
 	}
 
+	if (!ignore_locality && ap->blkno != 0) {
+		/*
+		 * If we can't allocate near a specific rt extent, try again
+		 * without locality criteria.
+		 */
+		ignore_locality = true;
+		goto retry;
+	}
+
 	ap->blkno = NULLFSBLOCK;
 	ap->length = 0;
 	return 0;

