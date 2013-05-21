Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BED0829E17
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 03:02:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB20D8F8049
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 01:02:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OinyaWjEv0sKcCb7 for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 01:02:39 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/11] xfs: fix incorrect remote symlink block count
Date: Tue, 21 May 2013 18:02:09 +1000
Message-Id: <1369123330-9579-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1369123330-9579-1-git-send-email-david@fromorbit.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

When CRCs are enabled, the number of blocks needed to hold a remote
symlink on a 1k block size filesystem may be 2 instead of 1. The
transaction reservation for the allocated bloks was not taking this
into account and only allocating one block. hence when trying to
read or invalidate such symlinks, we are mapping a hole where there
should be a block and things go bad at that point.

Fix the reservation to use the correct block count, clean up the
block count calculation similar to the remote attribute calculation,
and add a debug guard to detect when we don't write the entire
symlink to disk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_symlink.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 5f234389..195a403 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -56,16 +56,9 @@ xfs_symlink_blocks(
 	struct xfs_mount *mp,
 	int		pathlen)
 {
-	int		fsblocks = 0;
-	int		len = pathlen;
+	int buflen = XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
 
-	do {
-		fsblocks++;
-		len -= XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
-	} while (len > 0);
-
-	ASSERT(fsblocks <= XFS_SYMLINK_MAPS);
-	return fsblocks;
+	return (pathlen + buflen - 1) / buflen;
 }
 
 static int
@@ -405,7 +398,7 @@ xfs_symlink(
 	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
 		fs_blocks = 0;
 	else
-		fs_blocks = XFS_B_TO_FSB(mp, pathlen);
+		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
 	error = xfs_trans_reserve(tp, resblks, XFS_SYMLINK_LOG_RES(mp), 0,
 			XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
@@ -512,7 +505,7 @@ xfs_symlink(
 		cur_chunk = target_path;
 		offset = 0;
 		for (n = 0; n < nmaps; n++) {
-			char *buf;
+			char	*buf;
 
 			d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
@@ -525,9 +518,7 @@ xfs_symlink(
 			bp->b_ops = &xfs_symlink_buf_ops;
 
 			byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
-			if (pathlen < byte_cnt) {
-				byte_cnt = pathlen;
-			}
+			byte_cnt = min(byte_cnt, pathlen);
 
 			buf = bp->b_addr;
 			buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset,
@@ -542,6 +533,7 @@ xfs_symlink(
 			xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
 							(char *)bp->b_addr);
 		}
+		ASSERT(pathlen == 0);
 	}
 
 	/*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
