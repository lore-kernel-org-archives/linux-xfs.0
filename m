Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:21745 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751085AbeDQGj1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 02:39:27 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: validate allocated inode number
Date: Tue, 17 Apr 2018 16:39:16 +1000
Message-Id: <20180417063916.13069-3-david@fromorbit.com>
In-Reply-To: <20180417063916.13069-1-david@fromorbit.com>
References: <20180417063916.13069-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk

From: Dave Chinner <dchinner@redhat.com>

When we have corrupted free inode btrees, we can attempt to
allocate inodes that we know are already allocated. Catch allocation
of these inodes and report corruption as early as possible to
prevent corruption propagation or deadlocks.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7b764f746ff2..12e6c1aec386 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -790,6 +790,19 @@ xfs_ialloc(
 	}
 	ASSERT(*ialloc_context == NULL);
 
+	/*
+	 * Protect against obviously corrupt allocation btree records. Later
+	 * xfs_iget checks will catch re-allocation of other active in-memory
+	 * and on-disk inodes. If we don't catch reallocating the parent inode
+	 * here we will deadlock in xfs_iget() so we have to do these checks
+	 * first.
+	 */
+	if ((pip && ino == pip->i_ino) ||
+	    !xfs_verify_dir_ino(mp, ino)) {
+		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Get the in-core inode with the lock held exclusively.
 	 * This is because we're setting fields here we need
-- 
2.16.1

