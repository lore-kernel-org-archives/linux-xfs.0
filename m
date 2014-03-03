Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EE2429DF7
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 23:40:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5618AC003
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 21:40:07 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4UuOZBjzRbyzGFS4 for <xfs@oss.sgi.com>;
	Sun, 02 Mar 2014 21:40:05 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKLbY-0002b8-L7
	for xfs@oss.sgi.com; Mon, 03 Mar 2014 16:39:56 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKLbY-00085l-KD
	for xfs@oss.sgi.com; Mon, 03 Mar 2014 16:39:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: don't leak EFSBADCRC to userspace
Date: Mon,  3 Mar 2014 16:39:53 +1100
Message-Id: <1393825194-1719-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1393825194-1719-1-git-send-email-david@fromorbit.com>
References: <1393825194-1719-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

While the verifier reoutines may return EFSBADCRC when a buffer ahs
a bad CRC, we need to translate that to EFSCORRUPTED so that the
higher layers treat the error appropriately and so we return a
consistent error to userspace. This fixes a xfs/005 regression.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c     |  3 +++
 fs/xfs/xfs_symlink.c   |  4 ++++
 fs/xfs/xfs_trans_buf.c | 11 +++++++++++
 3 files changed, 18 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f96c056..993cb19 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -314,6 +314,9 @@ reread:
 		error = bp->b_error;
 		if (loud)
 			xfs_warn(mp, "SB validate failed with error %d.", error);
+		/* bad CRC means corrupted metadata */
+		if (error == EFSBADCRC)
+			error = EFSCORRUPTED;
 		goto release_buf;
 	}
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 14e58f2..5fda189 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -80,6 +80,10 @@ xfs_readlink_bmap(
 		if (error) {
 			xfs_buf_ioerror_alert(bp, __func__);
 			xfs_buf_relse(bp);
+
+			/* bad CRC means corrupted metadata */
+			if (error == EFSBADCRC)
+				error = EFSCORRUPTED;
 			goto out;
 		}
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 647b6f1..b8eef05 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -275,6 +275,10 @@ xfs_trans_read_buf_map(
 			XFS_BUF_UNDONE(bp);
 			xfs_buf_stale(bp);
 			xfs_buf_relse(bp);
+
+			/* bad CRC means corrupted metadata */
+			if (error == EFSBADCRC)
+				error = EFSCORRUPTED;
 			return error;
 		}
 #ifdef DEBUG
@@ -338,6 +342,9 @@ xfs_trans_read_buf_map(
 				if (tp->t_flags & XFS_TRANS_DIRTY)
 					xfs_force_shutdown(tp->t_mountp,
 							SHUTDOWN_META_IO_ERROR);
+				/* bad CRC means corrupted metadata */
+				if (error == EFSBADCRC)
+					error = EFSCORRUPTED;
 				return error;
 			}
 		}
@@ -375,6 +382,10 @@ xfs_trans_read_buf_map(
 		if (tp->t_flags & XFS_TRANS_DIRTY)
 			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
 		xfs_buf_relse(bp);
+
+		/* bad CRC means corrupted metadata */
+		if (error == EFSBADCRC)
+			error = EFSCORRUPTED;
 		return error;
 	}
 #ifdef DEBUG
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
