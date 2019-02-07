Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:55104 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725910AbfBGFIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 00:08:36 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1grbv6-0003pK-Q6
        for linux-xfs@vger.kernel.org; Thu, 07 Feb 2019 16:08:16 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92-RC5)
        (envelope-from <david@fromorbit.com>)
        id 1grbv6-0006KW-Oq
        for linux-xfs@vger.kernel.org; Thu, 07 Feb 2019 16:08:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: Don't free EOF blocks on close when extent size hints are set
Date: Thu,  7 Feb 2019 16:08:12 +1100
Message-Id: <20190207050813.24271-3-david@fromorbit.com>
In-Reply-To: <20190207050813.24271-1-david@fromorbit.com>
References: <20190207050813.24271-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When we have a workload that does open/write/close on files with
extent size hints set in parallel with other allocation, the file
becomes rapidly fragmented. This is due to close() calling
xfs_release() and removing the preallocated extent beyond EOF.  This
occurs for both buffered and direct writes that append to files with
extent size hints.

The existing open/write/close hueristic in xfs_release() does not
catch this as writes to files using extent size hints do not use
delayed allocation and hence do not leave delayed allocation blocks
allocated on the inode that can be detected in xfs_release(). Hence
XFS_IDIRTY_RELEASE never gets set.

In xfs_file_release(), we can tell whether the inode has extent size
hints set and skip EOF block truncation. We add this check to
xfs_can_free_eofblocks() so that we treat the post-EOF preallocated
extent like intentional preallocation and so are persistent unless
directly removed by userspace.

Before:

Test 2: Extent size hint fragmentation counts

/mnt/scratch/file.0: 1002
/mnt/scratch/file.1: 1002
/mnt/scratch/file.2: 1002
/mnt/scratch/file.3: 1002
/mnt/scratch/file.4: 1002
/mnt/scratch/file.5: 1002
/mnt/scratch/file.6: 1002
/mnt/scratch/file.7: 1002

After:

Test 2: Extent size hint fragmentation counts

/mnt/scratch/file.0: 4
/mnt/scratch/file.1: 4
/mnt/scratch/file.2: 4
/mnt/scratch/file.3: 4
/mnt/scratch/file.4: 4
/mnt/scratch/file.5: 4
/mnt/scratch/file.6: 4
/mnt/scratch/file.7: 4

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1ee8c5539fa4..98e5e305b789 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -761,12 +761,15 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
 		return false;
 
 	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
+	 * Do not free extent size hints, real preallocated or append-only files
+	 * unless the file has delalloc blocks and we are forced to remove
+	 * them.
 	 */
-	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+	if (xfs_get_extsz_hint(ip) ||
+	    (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))) {
 		if (!force || ip->i_delayed_blks == 0)
 			return false;
+	}
 
 	return true;
 }
-- 
2.20.1
