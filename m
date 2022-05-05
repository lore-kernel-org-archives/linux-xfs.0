Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BD4C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243945AbiEEQNb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381813AbiEEQMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:12:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF775C751
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25DA761DED
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84646C385B1;
        Thu,  5 May 2022 16:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766921;
        bh=WQAsxoalogc3BA9aLQj4joB87tZnQmot+iMaFW8K3Qc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JvCA8ht8DmHA7mCHiZwu6VgypdRYogHhSJmEJO6ON5FUKFWSLfVGbo0JUuhTGXezH
         bu2maCE3/UrpCPrFTNYcjG66Lkp7TjKtiJf5PK38CsJSICbDr1xpfQv3yaAzOQYAAR
         qBPA0bRAyI5xVak2L5qWHtJhgCsBOzHLNIx5HnlyCL+kQ8hbluFN2WHQrCl58G8dZp
         cLVbOHBrO63wAojAP+U2l0HDOSs/YS0LQ6y6qqX7z6icAMNm/AwONwti4ajvQBvwpg
         ayuohV523GWEeqUSUKad40aCwK+L1tgBcAdKtyJn/w2VITKZrNaXx+Xt36mDEInCd1
         vwQO4lasOvXKg==
Subject: [PATCH 4/4] xfs_scrub: don't revisit scanned inodes when reprocessing
 a stale inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:08:41 -0700
Message-ID: <165176692113.252326.17366876599203152992.stgit@magnolia>
In-Reply-To: <165176689880.252326.13947902143386455815.stgit@magnolia>
References: <165176689880.252326.13947902143386455815.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we decide to restart an inode chunk walk because one of the inodes is
stale, make sure that we don't walk an inode that's been scanned before.
This ensure we always make forward progress.

Found by observing backwards inode scan progress while running xfs/285.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/inodes.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 41e5fdc7..85bc1a06 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -210,6 +210,7 @@ scan_ag_bulkstat(
 	struct scan_inodes	*si = ichunk->si;
 	struct xfs_bulkstat	*bs;
 	struct xfs_inumbers	*inumbers = &ireq->inumbers[0];
+	uint64_t		last_ino = 0;
 	int			i;
 	int			error;
 	int			stale_count = 0;
@@ -229,8 +230,13 @@ scan_ag_bulkstat(
 	/* Iterate all the inodes. */
 	bs = &breq->bulkstat[0];
 	for (i = 0; !si->aborted && i < inumbers->xi_alloccount; i++, bs++) {
+		uint64_t	scan_ino = bs->bs_ino;
+
+		if (scan_ino < last_ino)
+			continue;
+
 		descr_set(&dsc_bulkstat, bs);
-		handle.ha_fid.fid_ino = bs->bs_ino;
+		handle.ha_fid.fid_ino = scan_ino;
 		handle.ha_fid.fid_gen = bs->bs_gen;
 		error = si->fn(ctx, &handle, bs, si->arg);
 		switch (error) {
@@ -260,6 +266,7 @@ _("Changed too many times during scan; giving up."));
 			si->aborted = true;
 			goto out;
 		}
+		last_ino = scan_ino;
 	}
 
 err:

