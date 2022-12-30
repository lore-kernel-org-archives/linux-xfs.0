Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA8AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbiLaCtc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbiLaCtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:49:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0160112AD7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:49:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91FE361C11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AE9C433EF;
        Sat, 31 Dec 2022 02:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454970;
        bh=sQuOMa9oSnGABSHns4NYbXdbel83QTSrTnm7sbIeFTE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IfnF0l2FbCuaV7IPg/dkpkyJ9uowU2nKpXQICs1oMdLEd/JyhbRNbBTvm+Z7pIBgj
         lEeBOxoC2Zp3ZnD1xcIxGp7+JcAOzn70pBxtAUuuL/kAFpcNgMJTukeX8gKaMFG7I+
         psFOtakc58xwzoOl/NVNM3eRKC0X41ImaWogGRkv9HhYrcaqaW7kJrFmqxmWZ9j0pD
         5TYCXpOw3B4u7O8BzVzu5qCW2IiIcthOwnJ3Et/pvm+uaY0NShtEAK735E5NPwLgGH
         MzjmmA5O+CN9BnxYGYhBRYH2Rwk4y9KZjWrwVR1LoScW2YjK/c/CAx5VTsuVL0tk5O
         XriD6Nc3fp4xw==
Subject: [PATCH 27/41] libxfs: dirty buffers should be marked uptodate too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:59 -0800
Message-ID: <167243879952.732820.2200249553918332973.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I started fuzz-testing the realtime rmap feature with a very large
number of realtime allocation groups.  There were so many rt groups that
repair had to rebuild /realtime in the metadata directory tree, and that
directory was big enough to spur the creation of a block format
directory.

Unfortunately, repair then walks both directory trees to look for
unconnceted files.  This part of phase 6 emits CRC errors on the newly
created buffers for the /realtime directory, declares the directory to
be garbage, and moves all the rt rmap inodes to /lost+found, resulting
in a corrupt fs.

Poking around in gdb, I noticed that the buffer contents were indeed
zero, and that UPTODATE was not set.  This was very strange, until I
added a watch on bp->b_flags to watch for accesses.  It turns out that
xfs_repair's prefetch code will _get a buffer and zero the contents if
UPTODATE is not set.

The directory tree code in libxfs will also _get a buffer, initialize
it, and log it to the coordinating transaction, which in this case is
the transactions used to reconnect the rmap btree inodes to /realtime.
At no point does any of that code ever set UPTODATE on the buffer, which
is why prefetch zaps the contents.

Hence change both buffer dirtying functions to set UPTODATE, since a
dirty buffer is by definition at least as recent as whatever's on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/rdwr.c  |    2 +-
 libxfs/trans.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 1c91f557f41..fd9579f3bc7 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -963,7 +963,7 @@ libxfs_buf_mark_dirty(
 	 */
 	bp->b_error = 0;
 	bp->b_flags &= ~LIBXFS_B_STALE;
-	bp->b_flags |= LIBXFS_B_DIRTY;
+	bp->b_flags |= LIBXFS_B_DIRTY | LIBXFS_B_UPTODATE;
 }
 
 /* Prepare a buffer to be sent to the MRU list. */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 06d3655c33b..93c281c321b 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -715,6 +715,7 @@ libxfs_trans_dirty_buf(
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 
+	bp->b_flags |= LIBXFS_B_UPTODATE;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
 }

