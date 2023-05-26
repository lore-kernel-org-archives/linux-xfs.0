Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB89AC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjEZAmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjEZAma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:42:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC5812E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:42:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEAC761B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA5BC433EF;
        Fri, 26 May 2023 00:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061748;
        bh=YIjt1TRtea6DMt7puXVy4BDWdak8S+duCLDtXIGaxE0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oBSL30Hm02KiJJ5hpqz9t+ToICjXnVHzgt3dQvU7s98udT2+E4oBIxhodoUVh692D
         lD+4nnfYNn1FBquT7yxH4tt9gYMnKJXC9OGY1nuiByMHLy8yewb7IAnwGDUXXZVbFm
         HEIrr76J576lC/29nOnYxb7DMNKr3Kolv+WS9cFGFDSROQ4DjzS891g4cyHI4VOVop
         vyJ/vcakRVv1umyfrK7SY/jwQSMcj1BD+PBaxyn/jz2w5CIeWxARzKAEDntKJAeaYG
         H2VNZI++8novUZmAaLYBl216org/of/GY5/23VadEKfaiI933Ll1jmVBHCsuYti0Vp
         pfWzawajA1iqQ==
Date:   Thu, 25 May 2023 17:42:27 -0700
Subject: [PATCH 5/7] xfs: fix logdev fsmap query result filtering
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055269.3727958.10078389356069082226.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
References: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The external log device fsmap backend doesn't have an rmapbt to query,
so it's wasteful to spend time initializing the rmap_irec objects.
Worse yet, the log could (someday) be longer than 2^32 fsblocks, so
using the rmap irec structure will result in integer overflows.

Fix this mess by computing the start address that we want from keys[0]
directly, and use the daddr-based record filtering algorithm that we
also use for rtbitmap queries.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 47295067f212..ae20aba6ebfe 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -437,36 +437,22 @@ xfs_getfsmap_logdev(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rmap_irec		rmap;
 	xfs_daddr_t			rec_daddr, len_daddr;
-	xfs_fsblock_t			start_fsb;
-	int				error;
+	xfs_fsblock_t			start_fsb, end_fsb;
+	uint64_t			eofs;
 
-	/* Set up search keys */
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
 	start_fsb = XFS_BB_TO_FSBT(mp,
 				keys[0].fmr_physical + keys[0].fmr_length);
-	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
-	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
-	error = xfs_fsmap_owner_to_rmap(&info->low, keys);
-	if (error)
-		return error;
-	info->low.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
 
 	/* Adjust the low key if we are continuing from where we left off. */
 	if (keys[0].fmr_length > 0)
 		info->low_daddr = XFS_FSB_TO_BB(mp, start_fsb);
 
-	error = xfs_fsmap_owner_to_rmap(&info->high, keys + 1);
-	if (error)
-		return error;
-	info->high.rm_startblock = -1U;
-	info->high.rm_owner = ULLONG_MAX;
-	info->high.rm_offset = ULLONG_MAX;
-	info->high.rm_blockcount = 0;
-	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
-	info->missing_owner = XFS_FMR_OWN_FREE;
-
-	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
+	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_fsb);
+	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_fsb);
 
 	if (start_fsb > 0)
 		return 0;

