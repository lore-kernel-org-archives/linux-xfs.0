Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FC9C4332E
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 00:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13AC229C6
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 00:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbhAEAzt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 19:55:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbhAEAzs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jan 2021 19:55:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D625F2256F;
        Tue,  5 Jan 2021 00:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808108;
        bh=gBV7rjbDvtj1IoteKM7jbO9E67+Za0GVgMCAesn4G6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASJXzrsaVLLasAKCmNGQSKOsMzoHtyRTKBaHFlVXFQWcoZqc+MWcqkJo30DvIHloH
         AQT6fY5xNbAtk+zgP7jYSZLRrOAJ4ve0S6wO5OlKd7JqhskWjzWVlZfkpD3Cf4WlE+
         0N+puDoBQbAkS3G1vkyoVmd86/9RkrxKI5CoTed7Wx289cf491pErIMcw4G67tPHA8
         a5J36fPKHrZkxGBc4tFW4r89vKZSAxjDy5WWIk1Ep3l1oUo0Kqtv4R55KrHvZRsO78
         7NTU8xToN3ZsCH91q93mkbVXgUg7Yt4K6c7WBIk64cBmgCNGKKaSrWQCiH9ZKxWTSC
         EM9WBiVZRtw2w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/13] fat: only specify I_DIRTY_TIME when needed in fat_update_time()
Date:   Mon,  4 Jan 2021 16:54:43 -0800
Message-Id: <20210105005452.92521-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105005452.92521-1-ebiggers@kernel.org>
References: <20210105005452.92521-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

As was done for generic_update_time(), only pass I_DIRTY_TIME to
__mark_inode_dirty() when the inode's timestamps were actually updated
and lazytime is enabled.  This avoids a weird edge case where
I_DIRTY_TIME could be set in i_state when lazytime isn't enabled.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/fat/misc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index f1b2a1fc2a6a4..33e1e0c9fd634 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -329,21 +329,22 @@ EXPORT_SYMBOL_GPL(fat_truncate_time);
 
 int fat_update_time(struct inode *inode, struct timespec64 *now, int flags)
 {
-	int iflags = I_DIRTY_TIME;
-	bool dirty = false;
+	int dirty_flags = 0;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
 
-	fat_truncate_time(inode, now, flags);
-	if (flags & S_VERSION)
-		dirty = inode_maybe_inc_iversion(inode, false);
-	if ((flags & (S_ATIME | S_CTIME | S_MTIME)) &&
-	    !(inode->i_sb->s_flags & SB_LAZYTIME))
-		dirty = true;
+	if (flags & (S_ATIME | S_CTIME | S_MTIME)) {
+		fat_truncate_time(inode, now, flags);
+		if (inode->i_sb->s_flags & SB_LAZYTIME)
+			dirty_flags |= I_DIRTY_TIME;
+		else
+			dirty_flags |= I_DIRTY_SYNC;
+	}
+
+	if ((flags & S_VERSION) && inode_maybe_inc_iversion(inode, false))
+		dirty_flags |= I_DIRTY_SYNC;
 
-	if (dirty)
-		iflags |= I_DIRTY_SYNC;
 	__mark_inode_dirty(inode, iflags);
 	return 0;
 }
-- 
2.30.0

