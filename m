Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27668 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752616AbdJLBkx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:40:53 -0400
Subject: [PATCH 01/30] xfs: return a distinct error code value for
 IGET_INCORE cache misses
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:40:49 -0700
Message-ID: <150777244964.1724.18204520366062829583.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

For an XFS_IGET_INCORE iget operation, if the inode isn't in the cache,
return ENODATA so that we don't confuse it with the pre-existing ENOENT
cases (inode is in cache, but freed).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3422711..43005fb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -610,7 +610,7 @@ xfs_iget(
 	} else {
 		rcu_read_unlock();
 		if (flags & XFS_IGET_INCORE) {
-			error = -ENOENT;
+			error = -ENODATA;
 			goto out_error_or_again;
 		}
 		XFS_STATS_INC(mp, xs_ig_missed);

