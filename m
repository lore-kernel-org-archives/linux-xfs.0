Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACDBC64EC4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 05:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjBVF3L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 00:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjBVF3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 00:29:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A99026CF2
        for <linux-xfs@vger.kernel.org>; Tue, 21 Feb 2023 21:29:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D55611CD
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 05:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2819C433D2;
        Wed, 22 Feb 2023 05:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677043741;
        bh=2hAkQW4+bNOUc1oh90tStNnoDovMR5PQCz8K42bsWl0=;
        h=Date:From:To:Cc:Subject:From;
        b=Qq2WSpJ1GoXMi5+4w0zofkQCSB2GGZBICojKvdBa5LQh9wUgSK0BmTixN2YuwpA0K
         FRklBwvIBuezPOVhHOiV095RD/EzqypLz3FT2fuLUmqwyG7ZePScZy6xbn7gC6VBOA
         j8oX3s9GnTuTdWSHx+DhwgGeVvljVHRr9okxP/UHqzSz6JSfT7qaMSHNIMzmgEZpOy
         4BB6OJvFmtXqFnYZuLmBPJ4BSqz6wFI8i4Qp7r6HUtmoU2cF6+qBU00z50l1YEXwPm
         n4fJKe2UU9eHyHj6qW5UtWsSR5n2zCfSLQJ8TzLv17JtKHXS/XOcSzlcAXt1GlKEG4
         SDvwFx7xZvsew==
Date:   Tue, 21 Feb 2023 21:29:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: restore old agirotor behavior
Message-ID: <Y/WoHLYbp82Xj7H8@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to the removal of xfs_ialloc_next_ag, we would increment the agi
rotor and return the *old* value.  atomic_inc_return returns the new
value, which causes mkfs to allocate the root directory in AG 1.  Put
back the old behavior (at least for mkfs) by subtracting 1 here.

Fixes: 20a5eab49d35 ("xfs: convert xfs_ialloc_next_ag() to an atomic")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 65832c74e86c..550c6351e9b6 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1729,7 +1729,7 @@ xfs_dialloc(
 	 * an AG has enough space for file creation.
 	 */
 	if (S_ISDIR(mode))
-		start_agno = atomic_inc_return(&mp->m_agirotor) % mp->m_maxagi;
+		start_agno = (atomic_inc_return(&mp->m_agirotor) - 1) % mp->m_maxagi;
 	else {
 		start_agno = XFS_INO_TO_AGNO(mp, parent);
 		if (start_agno >= mp->m_maxagi)
