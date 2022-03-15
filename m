Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3820C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 23:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiCOXYs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346865AbiCOXYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC502C102
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA8C66149A
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F22C340ED;
        Tue, 15 Mar 2022 23:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386614;
        bh=rKX+eb+yfSIxd5Bd+6/TuVsVbFbQRcA6YCw361Kp3Dw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=siK1aJ8CEEtdakoYSj6WbDH7pUM2hbHZScFk7QkoCP7IQt0EYEnzmYLIdV0ACnQqh
         FbG4YXv6dKglvxAqo50IeDo3ulrvR0OZnwLwnlyAJCGRHhXYRqyGufwO2mzts+5NpC
         SdTGya29c0fSo2hxvQFd+uLD9tpe1RwVMHqmXqzLdnuS9tYy1GyzUxmWkMM7ZIqsQo
         3lsW0uy+wQZKJTddiaIf4k85jKhUV7sitQd/ADw7yofS/atq0kawzEFHws2sTD9WVT
         4F97HKVmgsJeH6cECegtoNsgcPyH+6+e+phHombFWQZzLd02A4welBZzsvYxBb1+am
         MpwmAczN8yyaQ==
Subject: [PATCH 2/5] mkfs: don't let internal logs consume more than 95% of an
 AG
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:33 -0700
Message-ID: <164738661360.3191861.16773208450465120679.stgit@magnolia>
In-Reply-To: <164738660248.3191861.2400129607830047696.stgit@magnolia>
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, we don't let an internal log consume every last block in an
AG.  According to the comment, we're doing this to avoid tripping AGF
verifiers if freeblks==0, but on a modern filesystem this isn't
sufficient to avoid problems.  First, the per-AG reservations for
reflink and rmap claim up to about 1.7% of each AG for btree expansion,
and secondly, we need to have enough space in the AG to allocate the
root inode chunk, if it should be the case that the log ends up in AG 0.
We don't care about nonredundant (i.e. agcount==1) filesystems, but it
can also happen if the user passes in -lagnum=0.

Change this constraint so that we can't leave less than 5% free space
after allocating the log.  This is perhaps a bit much, but as we're
about to disallow tiny filesystems anyway, it seems unlikely to cause
problems with scenarios that we care about.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b97bd360..ad776492 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3271,15 +3271,18 @@ clamp_internal_log_size(
 	/*
 	 * Make sure the log fits wholly within an AG
 	 *
-	 * XXX: If agf->freeblks ends up as 0 because the log uses all
-	 * the free space, it causes the kernel all sorts of problems
-	 * with per-ag reservations. Right now just back it off one
-	 * block, but there's a whole can of worms here that needs to be
-	 * opened to decide what is the valid maximum size of a log in
-	 * an AG.
+	 * XXX: If agf->freeblks ends up as 0 because the log uses all the free
+	 * space, it causes the kernel all sorts of problems with per-AG
+	 * reservations.  The reservations are only supposed to take 2% of the
+	 * AG, but there's a further problem that if the log ends up in AG 0,
+	 * we also need space to allocate the root directory inode chunk.
+	 *
+	 * Right now just back it off by 5%, but there's a whole can of worms
+	 * here that needs to be opened to decide what is the valid maximum
+	 * size of a log in an AG.
 	 */
 	cfg->logblocks = min(cfg->logblocks,
-			     libxfs_alloc_ag_max_usable(mp) - 1);
+			     libxfs_alloc_ag_max_usable(mp) * 95 / 100);
 
 	/* and now clamp the size to the maximum supported size */
 	cfg->logblocks = min(cfg->logblocks, XFS_MAX_LOG_BLOCKS);

