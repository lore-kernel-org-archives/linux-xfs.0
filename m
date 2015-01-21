Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 020847F58
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 18:40:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93DF6AC009
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 16:40:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CjSvpH1FTD8eOssD for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 16:39:58 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: set buf types when converting extent formats
Date: Wed, 21 Jan 2015 11:39:40 +1100
Message-Id: <1421800780-26008-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1421800780-26008-1-git-send-email-david@fromorbit.com>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

Conversion from local to extent format does not set the buffer type
correctly on the new extent buffer when a symlink data is moved out
of line.

Fix the symlink code and leave a comment in the generic bmap code
reminding us that the format-specific data copy needs to set the
destination buffer type appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c           | 6 +++++-
 fs/xfs/libxfs/xfs_symlink_remote.c | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 63a5bb9..61ec015 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -973,7 +973,11 @@ xfs_bmap_local_to_extents(
 	*firstblock = args.fsbno;
 	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
 
-	/* initialise the block and copy the data */
+	/*
+	 * Initialise the block and copy the data
+	 *
+	 * Note: init_fn must set the buffer log item type correctly!
+	 */
 	init_fn(tp, bp, ip, ifp);
 
 	/* account for the change in fork size and log everything */
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index c80c523..e7e26bd 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -178,6 +178,8 @@ xfs_symlink_local_to_remote(
 	struct xfs_mount	*mp = ip->i_mount;
 	char			*buf;
 
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
+
 	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
 		bp->b_ops = NULL;
 		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
