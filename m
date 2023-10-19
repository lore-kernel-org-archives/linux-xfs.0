Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FDFCDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjJSQWh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbjJSQWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:22:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960EF130
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:22:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326CAC433C7;
        Thu, 19 Oct 2023 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732555;
        bh=QQhyK6FpL3mVUuCHFM7X2+txW/0JHwtoUs2Jn5mO8Ss=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LVppenrlxDx9s5KXYZp02+i6l7YmgSK4aL24lZ6eQsE2WLGDYo/fzTiKUAiZFCblK
         bGtr9gXO/O2yWTX41vPLLCXZCQTvMfDFcH4eXgfUebcvelQxMeEyBQGdmU/CnhlMLi
         uG9QcLPC9FPZcCgXl/qtHGeC0TCbDQsVYdNoSSu0be+18/ye/LhqOunQ4bHINWFgtI
         Q6f51QIrWu86qq1kUilH8c4fgZxm1mWuCpRUbwK2pYsjxVME3xIY5YUf6SbSNFTDnA
         DZE59WnTcNZpP/cMGdgxafagBNUx3ovURBWvMREd0hIkyjngVA0WQKTizVN6hugig5
         iyaJyutn31kCg==
Date:   Thu, 19 Oct 2023 09:22:34 -0700
Subject: [PATCH 1/8] xfs: fix units conversion error in
 xfs_bmap_del_extent_delay
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210138.225045.16946186575490390808.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
References: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The unit conversions in this function do not make sense.  First we
convert a block count to bytes, then divide that bytes value by
rextsize, which is in blocks, to get an rt extent count.  You can't
divide bytes by blocks to get a (possibly multiblock) extent value.

Fortunately nobody uses delalloc on the rt volume so this hasn't
mattered.

Fixes: fa5c836ca8eb5 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 26bfa34b4bbf..617cc7e78e38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4827,7 +4827,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t	rtexts = del->br_blockcount;
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);

