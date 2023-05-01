Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2B2C77B7C
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 18:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjEAS1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 14:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjEAS1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 14:27:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D95412F
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 11:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5B761E87
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 18:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22553C433D2;
        Mon,  1 May 2023 18:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682965636;
        bh=nxKbXQGzPB6KdQ/TnzCDlRXYG7CQJ61vqkEFXhnCv/w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O7KW0mLJgvEwRk0CuwoOtePF27suuJ8eAoR9R1LpsdsJoQPc1YkhTXxKNyj1Lhmm+
         7GOh1IRR49G19lPYcJRG0U+8hQySaXfLM1KhumMbXJmU8gRU1f/rWBwb8ARgPKXl+t
         BwwrQ6RkQOBJrX3BX0iNsxmsxw0N2r0fMCx1XoiuKEWrMKdIPv+f5sJ/jRXXMkKysQ
         jaHg5LVtsWfo9Y6RhAtJOYx7XeUHkVUrWkqRRlQCLyvYfYlLDwzi+Cq9qMkqSbhzMH
         awNmE7z0U4XiS9bBeXXrNEbI125mNzpQzYPvSg8ntuHvul7WW3a6RfKn13gjTf/kB8
         Y9ci1xCL776Xg==
Subject: [PATCH 4/4] xfs: don't allocate into the data fork for an unshare
 request
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 01 May 2023 11:27:15 -0700
Message-ID: <168296563575.290030.8748741047509895798.stgit@frogsfrogsfrogs>
In-Reply-To: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
References: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For an unshare request, we only have to take action if the data fork has
a shared mapping.  We don't care if someone else set up a cow operation.
If we find nothing in the data fork, return a hole to avoid allocating
space.

Note that fallocate will replace the delalloc reservation with an
unwritten extent anyway, so this has no user-visible effects outside of
avoiding unnecessary updates.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 285885c308bd..18c8f168b153 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1006,8 +1006,9 @@ xfs_buffered_write_iomap_begin(
 	if (eof)
 		imap.br_startoff = end_fsb; /* fake hole until the end */
 
-	/* We never need to allocate blocks for zeroing a hole. */
-	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
+	/* We never need to allocate blocks for zeroing or unsharing a hole. */
+	if ((flags & (IOMAP_UNSHARE | IOMAP_ZERO)) &&
+	    imap.br_startoff > offset_fsb) {
 		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
 		goto out_unlock;
 	}

