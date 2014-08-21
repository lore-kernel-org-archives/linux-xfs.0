Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42E0F7F5E
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 00:09:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6D9CAC002
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 22:09:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7Q1i7Xm9J5vm5rwr for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 22:09:38 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: don't log inode unless extent shift makes extent
	modifications
Date: Thu, 21 Aug 2014 15:09:13 +1000
Message-Id: <1408597754-13526-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1408597754-13526-1-git-send-email-david@fromorbit.com>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
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
Cc: clm@fb.com

From: Brian Foster <bfoster@redhat.com>

The file collapse mechanism uses xfs_bmap_shift_extents() to collapse
all subsequent extents down into the specified, previously punched out,
region. This function performs some validation, such as whether a
sufficient hole exists in the target region of the collapse, then shifts
the remaining exents downward.

The exit path of the function currently logs the inode unconditionally.
While we must log the inode (and abort) if an error occurs and the
transaction is dirty, the initial validation paths can generate errors
before the transaction has been dirtied. This creates an unnecessary
filesystem shutdown scenario, as the caller will cancel a transaction
that has been marked dirty.

Modify xfs_bmap_shift_extents() to OR the logflags bits as modifications
are made to the inode bmap. Only log the inode in the exit path if
logflags has been set. This ensures we only have to cancel a dirty
transaction if modifications have been made and prevents an unnecessary
filesystem shutdown otherwise.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3a6a700..e5c2518 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5422,7 +5422,7 @@ xfs_bmap_shift_extents(
 	struct xfs_bmap_free	*flist,
 	int			num_exts)
 {
-	struct xfs_btree_cur		*cur;
+	struct xfs_btree_cur		*cur = NULL;
 	struct xfs_bmbt_rec_host	*gotp;
 	struct xfs_bmbt_irec            got;
 	struct xfs_bmbt_irec		left;
@@ -5433,7 +5433,7 @@ xfs_bmap_shift_extents(
 	int				error = 0;
 	int				i;
 	int				whichfork = XFS_DATA_FORK;
-	int				logflags;
+	int				logflags = 0;
 	xfs_filblks_t			blockcount = 0;
 	int				total_extents;
 
@@ -5476,16 +5476,11 @@ xfs_bmap_shift_extents(
 		}
 	}
 
-	/* We are going to change core inode */
-	logflags = XFS_ILOG_CORE;
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
 		cur->bc_private.b.flist = flist;
 		cur->bc_private.b.flags = 0;
-	} else {
-		cur = NULL;
-		logflags |= XFS_ILOG_DEXT;
 	}
 
 	/*
@@ -5543,11 +5538,14 @@ xfs_bmap_shift_extents(
 			blockcount = left.br_blockcount +
 				got.br_blockcount;
 			xfs_iext_remove(ip, *current_ext, 1, 0);
+			logflags |= XFS_ILOG_CORE;
 			if (cur) {
 				error = xfs_btree_delete(cur, &i);
 				if (error)
 					goto del_cursor;
 				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+			} else {
+				logflags |= XFS_ILOG_DEXT;
 			}
 			XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
@@ -5573,6 +5571,7 @@ xfs_bmap_shift_extents(
 			got.br_startoff = startoff;
 		}
 
+		logflags |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_update(cur, got.br_startoff,
 						got.br_startblock,
@@ -5580,6 +5579,8 @@ xfs_bmap_shift_extents(
 						got.br_state);
 			if (error)
 				goto del_cursor;
+		} else {
+			logflags |= XFS_ILOG_DEXT;
 		}
 
 		(*current_ext)++;
@@ -5595,6 +5596,7 @@ del_cursor:
 		xfs_btree_del_cursor(cur,
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 
-	xfs_trans_log_inode(tp, ip, logflags);
+	if (logflags)
+		xfs_trans_log_inode(tp, ip, logflags);
 	return error;
 }
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
