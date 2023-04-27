Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8F0C77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344334AbjD0WtT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344332AbjD0WtT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD812123
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8C2E64036
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7A5C433D2;
        Thu, 27 Apr 2023 22:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635757;
        bh=L4yJX2axuZPpRaDk7xfCDWP9fZR1zfid7aU8oPR5DJg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IDpJhhLWao2OxI4tKw19ejvd+ERPF66FAeZ9pKZkYeG9sJlxrfPIITRtcGx+NqVXK
         1yhwzWkeWluqaOArYlPtsA3pNGTB79Er+Gkkwzjf9OvHjYqW5XP5T25LRD2syORX3e
         oUZxbNntdFlCBhJt5cMuyE1ZRvzqY4q1Xaj8QrjK/0PshJbQUB2Qy4VRqupNmAsqMv
         +6t0nG565Ce+mLJjLRtrJSWQ24O3hMcZYwUEgD8ksmYFJxiwq6iBztRyjyT8RrBcPs
         s9XwBFAlMm3/KO0ehEQ95NZ/r58nUeyKQ1r1dcwMGLmVlUmuooO4H4NMuiLBeE7vmt
         ht7yRxou4vIRg==
Subject: [PATCH 4/4] xfs: don't allocate into the data fork for an unshare
 request
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Apr 2023 15:49:16 -0700
Message-ID: <168263575686.1717721.6010345741023088566.stgit@frogsfrogsfrogs>
In-Reply-To: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

