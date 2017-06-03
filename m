Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60056 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdFCNLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:11:53 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/23] xfs: BMAPX shouldn't barf on inline-format directories
Date: Sat,  3 Jun 2017 15:10:55 +0200
Message-Id: <20170603131103.23712-16-hch@lst.de>
In-Reply-To: <20170603131103.23712-1-hch@lst.de>
References: <20170603131103.23712-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 6eadbf4c8ba816c10d1c97bed9aa861d9fd17809 upstream.

When we're fulfilling a BMAPX request, jump out early if the data fork
is in local format.  This prevents us from hitting a debugging check in
bmapi_read and barfing errors back to userspace.  The on-disk extent
count check later isn't sufficient for IF_DELALLOC mode because da
extents are in memory and not on disk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index cad4e3e2df00..9581e90fd559 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -583,9 +583,13 @@ xfs_getbmap(
 		}
 		break;
 	default:
+		/* Local format data forks report no extents. */
+		if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+			bmv->bmv_entries = 0;
+			return 0;
+		}
 		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
-		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
-		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
 			return -EINVAL;
 
 		if (xfs_get_extsz_hint(ip) ||
-- 
2.11.0

