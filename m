Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B8D229E09
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 14:31:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 035CB8F8065
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:31:30 -0800 (PST)
Message-Id: <20131206203128.786826439@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 12:30:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/11] xfs: reinstate the ilock in xfs_readdir
References: <20131206203006.914776999@bombadil.infradead.org>
Content-Disposition: inline; filename=iolock.diff
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
Cc: Ben Myers <bpm@sgi.com>

From: Ben Myers <bpm@sgi.com>

Although it was removed in commit 051e7cd44ab8, ilock needs to be taken in
xfs_readdir because we might have to read the extent list in from disk.  This
keeps other threads from reading from or writing to the extent list while it is
being read in and is still in a transitional state.

This has been associated with "Access to block zero" messages on directories
with large numbers of extents resulting from excessive filesytem fragmentation,
as well as extent list corruption.  Unfortunately no test case at this point.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 fs/xfs/xfs_dir2_readdir.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: xfs/fs/xfs/xfs_dir2_readdir.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_readdir.c	2013-12-06 17:20:27.695331596 +0100
+++ xfs/fs/xfs/xfs_dir2_readdir.c	2013-12-06 19:38:08.375162074 +0100
@@ -674,6 +674,7 @@ xfs_readdir(
 {
 	int		rval;		/* return value */
 	int		v;		/* type-checking value */
+	uint		lock_mode;
 
 	trace_xfs_readdir(dp);
 
@@ -683,6 +684,7 @@ xfs_readdir(
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
 	XFS_STATS_INC(xs_dir_getdents);
 
+	lock_mode = xfs_ilock_data_map_shared(dp);
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_getdents(dp, ctx);
 	else if ((rval = xfs_dir2_isblock(NULL, dp, &v)))
@@ -691,5 +693,7 @@ xfs_readdir(
 		rval = xfs_dir2_block_getdents(dp, ctx);
 	else
 		rval = xfs_dir2_leaf_getdents(dp, ctx, bufsize);
+	xfs_iunlock(dp, lock_mode);
+
 	return rval;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
