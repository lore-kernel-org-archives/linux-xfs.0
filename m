Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A582E7F7E
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:33:56 -0500 (CDT)
Date: Thu, 8 Aug 2013 16:33:56 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 7/14] xfsprogs: fix issues with commit 75c8b4343abb
Message-ID: <20130808213356.GU3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808210600.GN3111@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

These are various issues found in 75c8b4343abb during review.
* clean up a few extra tabs
* xfs_buf_map->xfs_buf_ops in libxfs_readbuf and libxfs_readbuf_map args
* don't call the write verifier twice
* put the multithreaded scan_ags back

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 include/libxfs.h |    2 +-
 libxfs/rdwr.c    |   20 ++------------------
 repair/scan.c    |    3 +--
 3 files changed, 4 insertions(+), 21 deletions(-)

Index: b/include/libxfs.h
===================================================================
--- a/include/libxfs.h	2013-08-06 16:36:31.000000000 -0500
+++ b/include/libxfs.h	2013-08-06 16:48:59.990857870 -0500
@@ -528,7 +528,7 @@ typedef struct xfs_inode {
 	xfs_mount_t		*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
-	struct xfs_buftarg			i_dev;		/* dev for this inode */
+	struct xfs_buftarg	i_dev;		/* dev for this inode */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
 	xfs_ifork_t		i_df;		/* data fork */
 	xfs_trans_t		*i_transp;	/* ptr to owning transaction */
Index: b/libxfs/rdwr.c
===================================================================
--- a/libxfs/rdwr.c	2013-08-06 14:39:38.580817239 -0500
+++ b/libxfs/rdwr.c	2013-08-06 16:49:54.300837139 -0500
@@ -201,9 +201,9 @@ libxfs_log_header(
 #undef libxfs_putbuf
 
 xfs_buf_t	*libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
-				const struct xfs_buf_map *);
+				const struct xfs_buf_ops *);
 xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
-				int, int, const struct xfs_buf_map *);
+				int, int, const struct xfs_buf_ops *);
 int		libxfs_writebuf(xfs_buf_t *, int);
 xfs_buf_t	*libxfs_getbuf(struct xfs_buftarg *, xfs_daddr_t, int);
 xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *, int);
@@ -834,22 +834,6 @@ libxfs_writebufr(xfs_buf_t *bp)
 		}
 	}
 
-	/*
-	 * clear any pre-existing error status on the buffer. This can occur if
-	 * the buffer is corrupt on disk and the repair process doesn't clear
-	 * the error before fixing and writing it back.
-	 */
-	bp->b_error = 0;
-	if (bp->b_ops) {
-		bp->b_ops->verify_write(bp);
-		if (bp->b_error) {
-			fprintf(stderr,
-	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
-				__func__, (long long)bp->b_bn, bp->b_bcount);
-			return bp->b_error;
-		}
-	}
-
 	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
 		error = __write_buf(fd, bp->b_addr, bp->b_bcount,
 				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
Index: b/repair/scan.c
===================================================================
--- a/repair/scan.c	2013-08-06 15:21:22.000000000 -0500
+++ b/repair/scan.c	2013-08-06 16:49:00.040877652 -0500
@@ -1369,8 +1369,7 @@ scan_ags(
 	}
 	memset(agcnts, 0, mp->m_sb.sb_agcount * sizeof(*agcnts));
 
-	create_work_queue(&wq, mp, 1);
-	//create_work_queue(&wq, mp, scan_threads);
+	create_work_queue(&wq, mp, scan_threads);
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, scan_ag, i, &agcnts[i]);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
