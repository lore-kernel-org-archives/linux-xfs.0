Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB47Quti001600 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 01:26:56 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 6A93D304081
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 23:26:54 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id SAA21605 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 18:26:52 +1100
Message-ID: <49378654.2050707@sgi.com>
Date: Thu, 04 Dec 2008 18:27:16 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Remove XFS_BUF_SHUT() and friends
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Code does nothing so remove it.

--- a/fs/xfs/linux-2.6/xfs_buf.h	2008-12-04 14:24:12.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_buf.h	2008-12-04 14:24:22.000000000 +1100
@@ -311,10 +311,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
  #define XFS_BUF_UNORDERED(bp)	((bp)->b_flags &= ~XBF_ORDERED)
  #define XFS_BUF_ISORDERED(bp)	((bp)->b_flags & XBF_ORDERED)

-#define XFS_BUF_SHUT(bp)	do { } while (0)
-#define XFS_BUF_UNSHUT(bp)	do { } while (0)
-#define XFS_BUF_ISSHUT(bp)	(0)
-
  #define XFS_BUF_HOLD(bp)	xfs_buf_hold(bp)
  #define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
  #define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
--- a/fs/xfs/xfs_buf_item.c	2008-12-04 14:24:12.000000000 +1100
+++ b/fs/xfs/xfs_buf_item.c	2008-12-04 14:13:32.000000000 +1100
@@ -998,21 +1000,7 @@ xfs_buf_iodone_callbacks(
  			xfs_buf_do_callbacks(bp, lip);
  			XFS_BUF_SET_FSPRIVATE(bp, NULL);
  			XFS_BUF_CLR_IODONE_FUNC(bp);
-
-			/*
-			 * XFS_SHUT flag gets set when we go thru the
-			 * entire buffer cache and deliberately start
-			 * throwing away delayed write buffers.
-			 * Since there's no biowait done on those,
-			 * we should just brelse them.
-			 */
-			if (XFS_BUF_ISSHUT(bp)) {
-			    XFS_BUF_UNSHUT(bp);
-				xfs_buf_relse(bp);
-			} else {
-				xfs_biodone(bp);
-			}
-
+			xfs_biodone(bp);
  			return;
  		}

--- a/fs/xfs/xfs_inode.c	2008-12-04 14:24:12.000000000 +1100
+++ b/fs/xfs/xfs_inode.c	2008-12-04 14:21:54.000000000 +1100
@@ -3089,7 +3089,6 @@ cluster_corrupt_out:
  			XFS_BUF_CLR_BDSTRAT_FUNC(bp);
  			XFS_BUF_UNDONE(bp);
  			XFS_BUF_STALE(bp);
-			XFS_BUF_SHUT(bp);
  			XFS_BUF_ERROR(bp,EIO);
  			xfs_biodone(bp);
  		} else {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
