Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8316BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbiLaC6j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaC6i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:58:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7DA1929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:58:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14694B81E6A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B317FC433D2;
        Sat, 31 Dec 2022 02:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455514;
        bh=loPNYSJperFnLtw9sGbZjRudtTrdHv3EKh6l1AgB9Ss=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JqMYdpKa7wYy0y8pG0awIA+vOPUoJeB0wlqoBaMFD6WIyMrhg/QGSGtVVz0nIK2r3
         AVD0PI5LtKu0LTCVKLPDjHrkZjDzI+P2lYjGBH/cHOl5H+uhJ1KaBuAuFpNtiw6NOl
         0n7YjaHRZLYAfO7krV0ztH63vVWFK0SC9+DbogGtToVPYcB0sRtSI7eBRw3bNta1r7
         d5bBNkgf5G5IURlW7h7qHy3oKz8xwRLmjBr2A9MC4XDk4F1aVp8k40/I+B/Hc9hZQj
         64nzeAQCaRIZI7ezXicHn4ibTDSbChGjvBvf6JFP/Bjp+FVafNgLN0b6j5O2RZtd0j
         87hfH4SzUz1ZA==
Subject: [PATCH 17/41] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:09 -0800
Message-ID: <167243880994.734096.12858246011425433777.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, we (ab)use xfs_get_extsz_hint so that it always returns a
nonzero value for realtime files.  This apparently was done to disable
delayed allocation for realtime files.

However, once we enable realtime reflink, we can also turn on the
alwayscow flag to force CoW writes to realtime files.  In this case, the
logic will incorrectly send the write through the delalloc write path.

Fix this by adjusting the logic slightly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4bf5ce838a9..16f0683caef 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6421,9 +6421,8 @@ xfs_get_extsz_hint(
 	 * No point in aligning allocations if we need to COW to actually
 	 * write to them.
 	 */
-	if (xfs_is_always_cow_inode(ip))
-		return 0;
-	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+	if (!xfs_is_always_cow_inode(ip) &&
+	    (ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
 		return ip->i_extsize;
 	if (XFS_IS_REALTIME_INODE(ip))
 		return ip->i_mount->m_sb.sb_rextsize;

