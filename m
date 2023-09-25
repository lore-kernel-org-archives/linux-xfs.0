Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEE5CE79A4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjIYV7Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjIYV7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA805116
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED0EC433C7;
        Mon, 25 Sep 2023 21:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679156;
        bh=dnjE6OyBIMFbJ1OvPrN4iSaHwRqvnEiliaxOUIC2b3w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gRud6WL17wbJbH7d2edHW5UHMiV4jKIpQjeWH7tOjmSj0HkNTKSxC5vIKv4T3rYYO
         WZTyX+89iTI2tbqUA5BKX+xnwouJia6I2wyfYg8FfrpNGlMWDC/Pm4imijQxsFtkTM
         FeXLdghYPHZQxvzOy1qot1U59ex7lTI4dHzHf7M0bBdOL/5dda/7X32NzHpv1DCdof
         fJ/sCDv1YqacUOymUxxRluMDsFI0AULHTyBr3CXTRmc7s5ges7nlBkQB46h+0cpWp3
         M2vaC0tLETjBtex5P78JyXm5SnmmFGgN8rchHUBwrvS5l0R7SvOq8XhXXgz9Dmq8/8
         4/59cPbyj0EEw==
Subject: [PATCH 2/2] xfs_db: use directio for device access
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:16 -0700
Message-ID: <169567915609.2320255.8945830759168479067.stgit@frogsfrogsfrogs>
In-Reply-To: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
References: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS and tools (mkfs, copy, repair) don't generally rely on the block
device page cache, preferring instead to use directio.  For whatever
reason, the debugger was never made to do this, but let's do that now.

This should eliminate the weird fstests failures resulting from
udev/blkid pinning a cache page while the unmounting filesystem writes
to the superblock such that xfs_db finds the stale pagecache instead of
the post-unmount superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/init.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/db/init.c b/db/init.c
index eec65d0884d..4599cc00d71 100644
--- a/db/init.c
+++ b/db/init.c
@@ -96,6 +96,7 @@ init(
 		x.volname = fsdevice;
 	else
 		x.dname = fsdevice;
+	x.isdirect = LIBXFS_DIRECT;
 
 	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
 	if (!libxfs_init(&x)) {

