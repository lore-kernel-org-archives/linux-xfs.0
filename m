Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90756C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiLaByD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiLaByC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:54:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F07A1DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE52D61CE2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AC3C433D2;
        Sat, 31 Dec 2022 01:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451640;
        bh=pg4B0x7QVtQ7GFIuSuXOfuGL4WVeub5JqBpUKgko6S4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gNhUw08tiJmq2zwDM7MNZ8120I2/hUsgxYqU3/LQXj8bpTAsD92tMHAjwx7hG4lc4
         N+CGELYABHVoY6HhyTxqIFBXVR+6BnJXaRBqfANJoRL6UquCSdm1a84EbKZjDzjCKi
         aMt2b181qkYGJ4WBlQlsLeMR5u2znkJFL/Czfm1JpC1RymUhIOHyhBf+9zgJwJDtI8
         qa4ce51h7rf+QBXK5dyz3OmJrzFvaTcpB883a+hp6ls0OxhJQaj9TMXBnvUX7dmlgH
         44oJMC8/8XqwKoDPbLIIrXSHnBCrGxgRAk61uPmKWQWGcbDnLlDWHrroa9yl8nAlHP
         im7SqFilVxgdA==
Subject: [PATCH 23/42] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:32 -0800
Message-ID: <167243871222.717073.2381159476227762923.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_bmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fe31f3cb5d91..552875ddcc4a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6427,9 +6427,8 @@ xfs_get_extsz_hint(
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

