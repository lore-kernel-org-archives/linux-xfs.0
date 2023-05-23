Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FC2C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 04:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbjEWEr1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 00:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbjEWEqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 00:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200C5E52
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 21:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9890462EE1
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 04:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1783C433EF;
        Tue, 23 May 2023 04:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684817207;
        bh=uu4pYpjyB8JxXVQO4XGhBBwqNqbp/BVTuUG8iBD4GOc=;
        h=Date:From:To:Cc:Subject:From;
        b=CtkGdf4T8f2dd1D4NAWNU20OJBKIcvHxa+C0Kul+yZcJuJzvk2k2qacFw4I8uoHdB
         17upkoYpILJEtolN3dxdytY30xCiDZyiB4kYyOpekOMMM50wyUycB8zz7s62ges6iF
         5Bx4+sDx63zBpPsj8tierEVPl9q1YlV/13DeUzTo89gZT6/qwewAkdro/7pmMmy1vA
         PuXqzRiIqskOdTiQdxeE09PblC8vgmywRM5ASsAHKh/4LkthxAVBX3JYmjLNezo1Cq
         35kIsl2oZ+d3VhA8kk2Xp6RoZZwRWyfSEOaO4y7bhkKmh4OW9cfphn09Fm2gGbDcPq
         z7yhrGvot+Gng==
Date:   Mon, 22 May 2023 21:46:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't deplete the reserve pool when trying to shrink
 the fs
Message-ID: <20230523044646.GB11594@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then, xfs/168 fails with this logged in dmesg:

Reserve blocks depleted! Consider increasing reserve pool size.
EXPERIMENTAL online shrink feature in use. Use at your own risk!
Per-AG reservation for AG 1 failed.  Filesystem may run out of space.
Per-AG reservation for AG 1 failed.  Filesystem may run out of space.
Error -28 reserving per-AG metadata reserve pool.
Corruption of in-memory data (0x8) detected at xfs_ag_shrink_space+0x23c/0x3b0 [xfs] (fs/xfs/libxfs/xfs_ag.c:1007).  Shutting down filesystem.

It's silly to deplete the reserved blocks pool just to shrink the
filesystem, particularly since the fs goes down after that.

Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 13851c0d640b..5f00527b8065 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -140,9 +140,13 @@ xfs_growfs_data_private(
 		return -EINVAL;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
-			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
-			XFS_TRANS_RESERVE, &tp);
+	if (delta > 0)
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
+				XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE,
+				&tp);
+	else
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, -delta, 0,
+				0, &tp);
 	if (error)
 		return error;
 
