Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC6277F77
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 13:49:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7DB5A8F8066
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 11:49:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DBjLlWT11hsGLBzD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 11:49:29 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s78InR9m007657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 8 Aug 2014 14:49:28 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s78InRCF014088
	for <xfs@oss.sgi.com>; Fri, 8 Aug 2014 14:49:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: don't log inode unless extent shift makes extent
	modifications
Date: Fri,  8 Aug 2014 14:49:25 -0400
Message-Id: <1407523766-62233-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
References: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
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
index de2d26d..86df952 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5424,7 +5424,7 @@ xfs_bmap_shift_extents(
 	struct xfs_bmap_free	*flist,
 	int			num_exts)
 {
-	struct xfs_btree_cur		*cur;
+	struct xfs_btree_cur		*cur = NULL;
 	struct xfs_bmbt_rec_host	*gotp;
 	struct xfs_bmbt_irec            got;
 	struct xfs_bmbt_irec		left;
@@ -5435,7 +5435,7 @@ xfs_bmap_shift_extents(
 	int				error = 0;
 	int				i;
 	int				whichfork = XFS_DATA_FORK;
-	int				logflags;
+	int				logflags = 0;
 	xfs_filblks_t			blockcount = 0;
 	int				total_extents;
 
@@ -5478,16 +5478,11 @@ xfs_bmap_shift_extents(
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
@@ -5545,11 +5540,14 @@ xfs_bmap_shift_extents(
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
@@ -5575,6 +5573,7 @@ xfs_bmap_shift_extents(
 			got.br_startoff = startoff;
 		}
 
+		logflags |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_update(cur, got.br_startoff,
 						got.br_startblock,
@@ -5582,6 +5581,8 @@ xfs_bmap_shift_extents(
 						got.br_state);
 			if (error)
 				goto del_cursor;
+		} else {
+			logflags |= XFS_ILOG_DEXT;
 		}
 
 		(*current_ext)++;
@@ -5597,6 +5598,7 @@ del_cursor:
 		xfs_btree_del_cursor(cur,
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 
-	xfs_trans_log_inode(tp, ip, logflags);
+	if (logflags)
+		xfs_trans_log_inode(tp, ip, logflags);
 	return error;
 }
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
