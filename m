Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC3F729E19
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3BDA304064
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bptbWC4ByG8yBZhQ for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:32 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDA-0007dc-Lw
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003w8-Kk
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 55/55] xfsprogs: cleanup miscellaneous merge faults
Date: Thu,  5 Sep 2013 08:05:59 +1000
Message-Id: <1378332359-14737-56-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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

From: Ben Myers <bpm@sgi.com>

* clean up a few extra tabs
* xfs_buf_map->xfs_buf_ops in libxfs_readbuf and libxfs_readbuf_map args
* don't call the write verifier twice
* put the multithreaded scan_ags back

Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h |  2 +-
 libxfs/rdwr.c    | 20 ++------------------
 repair/scan.c    |  3 +--
 3 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 533d336..ffd83bf 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -589,7 +589,7 @@ typedef struct xfs_inode {
 	xfs_mount_t		*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
-	struct xfs_buftarg			i_dev;		/* dev for this inode */
+	struct xfs_buftarg	i_dev;		/* dev for this inode */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
 	xfs_ifork_t		i_df;		/* data fork */
 	xfs_trans_t		*i_transp;	/* ptr to owning transaction */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 92a90f1..13dbd23 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -198,9 +198,9 @@ libxfs_log_header(
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
@@ -831,22 +831,6 @@ libxfs_writebufr(xfs_buf_t *bp)
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
diff --git a/repair/scan.c b/repair/scan.c
index 4f8bbef..49ed194 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1370,8 +1370,7 @@ scan_ags(
 	}
 	memset(agcnts, 0, mp->m_sb.sb_agcount * sizeof(*agcnts));
 
-	create_work_queue(&wq, mp, 1);
-	//create_work_queue(&wq, mp, scan_threads);
+	create_work_queue(&wq, mp, scan_threads);
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, scan_ag, i, &agcnts[i]);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
