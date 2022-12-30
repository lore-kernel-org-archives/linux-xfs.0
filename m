Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEF2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiLaAXJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaAXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:23:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC26D104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:23:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC6761D24
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20351C433D2;
        Sat, 31 Dec 2022 00:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446187;
        bh=85iVNAdmHOY0bUx2A+Ojd86NEj3aM3EoERfZIP+sC3Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VUXWRlpQ8+NNk0caCoHhzPaHlBwHsIMjW3EEAtBxoi/2r01Rk0/fYq8Og4tPY+gQM
         UG8tqsBpMsoTowWhy+5zLs6CpE4FArg2LIFYZ4Fu6uHhIfIlYSXkwJL7mMwJdo27oM
         zrqH+dz9Lzav3tmBRp8MowiMZGIvQ3i66PO9NMtviO7B3GsOseHVQiAJq4lSAVyiXM
         XBWTF4Kj+7xUsQWCaZzumOICRKi32ymiEM9nJz6pZjLeWxyszGPB0rPGjDWSVQIFuZ
         GXMh73V1QaYiZ6EppVIsJlrzKqFgRKgTZ1g2TfQ7wO9qD66zuNzV3X5XoJgRit7mtp
         fb1VcQsIJjRow==
Subject: [PATCH 17/19] xfs_fsr: skip the xattr/forkoff levering with the newer
 swapext implementations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:01 -0800
Message-ID: <167243868162.713817.497073374813827926.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The newer swapext implementations in the kernel run at a high enough
level (above the bmap layer) that it's no longer required to manipulate
bs_forkoff by creating garbage xattrs to get the extent tree that we
want.  If we detect the newer algorithms, skip this error prone step.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fsr/xfs_fsr.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index bbc7d5fcabb..1fb2e5e7529 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -969,6 +969,22 @@ fsr_setup_attr_fork(
 	if (!(bstatp->bs_xflags & FS_XFLAG_HASATTR))
 		return 0;
 
+	/*
+	 * If the filesystem has the ability to perform atomic extent swaps or
+	 * has the reverse mapping btree enabled, the file extent swap
+	 * implementation uses a higher level algorithm that calls into the
+	 * bmap code instead of playing games with swapping the extent forks.
+	 *
+	 * The newer bmap implementation does not require specific values of
+	 * bs_forkoff, unlike the old fork swap code.  Therefore, leave the
+	 * extended attributes alone if we know we're not using the old fork
+	 * swap strategy.  This eliminates a major source of runtime errors
+	 * in fsr.
+	 */
+	if (fsgeom.flags & (XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP |
+			    XFS_FSOP_GEOM_FLAGS_RMAPBT))
+		return 0;
+
 	/*
 	 * use the old method if we have attr1 or the kernel does not yet
 	 * support passing the fork offset in the bulkstat data.

