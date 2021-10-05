Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9CEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Oct 2021 22:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4280061100
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Oct 2021 22:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbhJEWds (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Oct 2021 18:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236810AbhJEWdr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Oct 2021 18:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EA9E60F92;
        Tue,  5 Oct 2021 22:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633473116;
        bh=AV/69SeaJmxUhvutKSm2px7nvcOtTBo99tNFniu/y5g=;
        h=Date:From:To:Cc:Subject:From;
        b=qrtVBqcba8lYo8c8cD9Iayv44TXrm6IbdJ/RcMSyJOKPfNN7/Pf92W0J+ojQcrJYH
         wq+KMT6u1MpjWf8w9SxgmVAbLqdYkghkRzUGx02WlcKKiqa6pRxOzHwkYgxbsittbR
         wfrYTwni+Y5IWj7Yq7Yp7JOTpSP8K5+P1nzIuOU6IChGUivkOO/A3lcH51xzEk5BEr
         X9f2dzTT5pTuTv/JB9aDLxWqBjxzbQdS+CLZg/y2b/WiqzfV4GHS7Wv6caL7kQuX4Y
         +8U/ErGmiIYL+njt57770pxW3MKKY/pGDOrejHCC2RXyw2it5/X4ASv6bREOHh7I+O
         BCvJAc8wSju7g==
Date:   Tue, 5 Oct 2021 15:31:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs: fix call_rcu crash when unmounting the fake mount in
 mkfs
Message-ID: <20211005223155.GD24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit a6fb6abe, we simplified the process by which mkfs.xfs computes
the minimum log size calculation by creating a dummy xfs_mount with the
draft superblock image, using the dummy to compute the log geometry, and
then unmounting the dummy.

Note that creating a dummy mount with no data device is supported by
libxfs, though with the caveat that we don't set up any perag structures
at all.  Up until this point this has worked perfectly well since free()
(and hence kmem_free()) are perfectly happy to ignore NULL pointers.

Unfortunately, this will cause problems with the upcoming patch to shift
per-AG setup and teardown to libxfs because call_rcu in the liburcu
library actually tries to access the rcu_head of the passed-in perag
structure, but they're all NULL in the dummy mount case.  IOWs,
xfs_free_perag requires that every AG have a per-AG structure, and it's
too late to change the 5.14 kernel libxfs now, so work around this by
altering libxfs_mount to remember when it has initialized the perag
structures and libxfs_umount to skip freeing them when the flag isn't
set.

Just to be clear: This fault has no user-visible consequences right now;
it's a fixup to avoid problems in the libxfs sync series for 5.14.

Fixes: a6fb6abe ("mkfs: simplify minimum log size calculation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    1 +
 libxfs/init.c       |   13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 2f320880..9e43cd23 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -190,6 +190,7 @@ xfs_perag_resv(
 #define LIBXFS_MOUNT_COMPAT_ATTR	0x0008
 #define LIBXFS_MOUNT_ATTR2		0x0010
 #define LIBXFS_MOUNT_WANT_CORRUPTED	0x0020
+#define LIBXFS_MOUNT_PERAG_DATA_LOADED	0x0040
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 17fc1102..d0753ce5 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -912,6 +912,7 @@ libxfs_mount(
 			progname);
 		exit(1);
 	}
+	mp->m_flags |= LIBXFS_MOUNT_PERAG_DATA_LOADED;
 
 	return mp;
 }
@@ -1031,9 +1032,15 @@ libxfs_umount(
 	libxfs_bcache_purge();
 	error = libxfs_flush_mount(mp);
 
-	for (agno = 0; agno < mp->m_maxagi; agno++) {
-		pag = radix_tree_delete(&mp->m_perag_tree, agno);
-		kmem_free(pag);
+	/*
+	 * Only try to free the per-AG structures if we set them up in the
+	 * first place.
+	 */
+	if (mp->m_flags & LIBXFS_MOUNT_PERAG_DATA_LOADED) {
+		for (agno = 0; agno < mp->m_maxagi; agno++) {
+			pag = radix_tree_delete(&mp->m_perag_tree, agno);
+			kmem_free(pag);
+		}
 	}
 
 	kmem_free(mp->m_attr_geo);
