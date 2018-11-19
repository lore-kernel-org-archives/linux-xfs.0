Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15953 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730913AbeKTHbC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:31:02 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj7-0000XW-4V
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj7-0002G5-33
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] xfs: don't ENOSPC on writeback when punching holes
Date: Tue, 20 Nov 2018 08:04:58 +1100
Message-Id: <20181119210459.8506-7-david@fromorbit.com>
In-Reply-To: <20181119210459.8506-1-david@fromorbit.com>
References: <20181119210459.8506-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Just tried to punch a 40T sparse file when enospc was triggered due
to extent size hints consuming more space than expected. It failed
with:

# sudo xfs_io -c "fpunch 0 40t" /mnt/fast/xfs-arekm.img
fallocate: No space left on device
#

because the writeback error of ENOSPC was being reported. We're
going to free that space, so we don't care if there was a ENOSPC
writeback error. So ignore ENOSPC errors and punch anyway.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 167ff4297e5c..cc7a0d47c529 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1060,8 +1060,13 @@ xfs_flush_unmap_range(
 	start = round_down(offset, rounding);
 	end = round_up(offset + len, rounding) - 1;
 
+	/*
+	 * We're going to trash the data in this range, so if writeback reports
+	 * an enospc error, don't let it stop us from /freeing the space/ in the
+	 * range to alleviate the ENOSPC condition.
+	 */
 	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (error)
+	if (error && error != -ENOSPC)
 		return error;
 	truncate_pagecache_range(inode, start, end);
 	return 0;
-- 
2.19.1
