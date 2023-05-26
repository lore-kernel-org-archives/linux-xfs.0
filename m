Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F4BC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbjEZBNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbjEZBNn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:13:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D982DD8
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D6764C26
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B20C433EF;
        Fri, 26 May 2023 01:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063621;
        bh=PTzTJn4wBB7uPB7xlzqXd2ZGvrqJHHwxrX0ci9yEYG8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hslUfWfyouXGBaSMBwM0rqzKBxVjSM0zfyDhQX8DVnbyUx7NFqXzPCY/HwLqdLCbz
         riKtPDgGi+ieZc3og7V1GFkB4/AhYLc9x4F2PNSuAqIc7arZ3zhYtY/OdfXOF/9/QW
         EiB/LYZlOXKoBCNRd5B8znleYJpCS8tQIqE6K5Az+yT3E5E4Wbbobe5f1fxFiKdy96
         j2a9W+835j5aSgNdlAuyEgh6HzLJ/1Ph87LKEhiaPlztLSwPc1SwzWRKQiNM+l8tsq
         DjGRh594XOgrs21Vwxr7IfzFlzBbkvhDGNAUhBT9yMkSvsNC67KKMDJ8kNj4B+utvH
         T98Wn2ENgYt+A==
Date:   Thu, 25 May 2023 18:13:41 -0700
Subject: [PATCH 2/2] xfs: xfs_bmap_finish_one should map unwritten extents
 properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506064252.3734210.12830491557535368274.stgit@frogsfrogsfrogs>
In-Reply-To: <168506064221.3734210.16655685789262733930.stgit@frogsfrogsfrogs>
References: <168506064221.3734210.16655685789262733930.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The deferred bmap work state and the log item can transmit unwritten
state, so the XFS_BMAP_MAP handler must map in extents with that
unwritten state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f1715be091b3..5d9e0af35017 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6227,6 +6227,8 @@ xfs_bmap_finish_one(
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
+		if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+			flags |= XFS_BMAPI_PREALLOC;
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
 				bmap->br_blockcount, bmap->br_startblock,
 				flags);

