Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64405C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJBSeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiJBSeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:34:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3904A3C174
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C828060F04
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C00C433D6;
        Sun,  2 Oct 2022 18:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735647;
        bh=ui7jQCwNKjLGCEc66mlC4wXJ7iMSTMXTCGU0vMZaYz4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o24lS1Y995cgLrspQ4i6g2YdxMnW5x6FVw0EqecJk+g8tIznGeqExeZQuPZvcIH2W
         +pO/Evi+arV/FT0AGYnjrIjl5b3GHOhWYZ0wifOwCsCngQVz+TTssouDAThJk+eZrZ
         itjFYnyT7Ya2iDrXjcjHPCxe2nReTSQBpCNnBEBB5FfZ3RCGdeNJ30CMTtsBrVHspd
         i2WXFCbMeBY7W5yMaK/vM0SccWkeeiwmMzqoz/1E6O+9bBwwbE7Hdt7aj7l9t4ouJZ
         roVKpK+0bqzQRRfN5t92yE53nlHJ7ejG6iEUhYbeVd1Wi3+1B+k5qUpiCwB7XVTBXp
         t1Ym7gaXlvi2g==
Subject: [PATCH 1/2] xfs: don't warn about files that are exactly s_maxbytes
 long
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:26 -0700
Message-ID: <166473482622.1084588.7922921296626975279.stgit@magnolia>
In-Reply-To: <166473482605.1084588.1965700384229898125.stgit@magnolia>
References: <166473482605.1084588.1965700384229898125.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We can handle files that are exactly s_maxbytes bytes long; we just
can't handle anything larger than that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index dd2bf4cbd68f..3b272c86d0ad 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -368,7 +368,7 @@ xchk_dinode(
 	 * pagecache can't cache all the blocks in this file due to
 	 * overly large offsets, flag the inode for admin review.
 	 */
-	if (isize >= mp->m_super->s_maxbytes)
+	if (isize > mp->m_super->s_maxbytes)
 		xchk_ino_set_warning(sc, ino);
 
 	/* di_nblocks */

