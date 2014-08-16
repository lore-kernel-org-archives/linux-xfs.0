Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB2617F3F
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 23:55:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D45A28F8039
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 21:55:33 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id kNa2gUWul0xlYUHI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 21:55:32 -0700 (PDT)
Date: Fri, 15 Aug 2014 21:55:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20140816045531.GA7876@infradead.org>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-9-git-send-email-david@fromorbit.com>
	<20140815131020.GB27856@infradead.org>
	<20140815233743.GX26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815233743.GX26465@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Aug 16, 2014 at 09:37:43AM +1000, Dave Chinner wrote:
> xfs_zero_remaining_bytes is uses an uncached buffer, so we're not
> using the buffer cache at all for the blocks being zeroed. That is
> why it does the flag twiddling dance it does. However, consolidation
> all the different block zeroing functions we have is an exercise for
> a different day....

Well, we're using buffers.  Anyway, below is what I think it should
look like when using buffers.   Although I wonder how either the old
or new variant pass the verifier check in _xfs_buf_ioapply for v5
filesystems given that we don't pass any ops in.

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2f1e30d..c495dce 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1122,14 +1122,6 @@ xfs_zero_remaining_bytes(
 	if (endoff > XFS_ISIZE(ip))
 		endoff = XFS_ISIZE(ip);
 
-	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
-					mp->m_rtdev_targp : mp->m_ddev_targp,
-				  BTOBB(mp->m_sb.sb_blocksize), 0);
-	if (!bp)
-		return -ENOMEM;
-
-	xfs_buf_unlock(bp);
-
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
 		uint lock_mode;
 
@@ -1152,42 +1144,26 @@ xfs_zero_remaining_bytes(
 		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
 		if (imap.br_state == XFS_EXT_UNWRITTEN)
 			continue;
-		XFS_BUF_UNDONE(bp);
-		XFS_BUF_UNWRITE(bp);
-		XFS_BUF_READ(bp);
-		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
 
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			error = -EIO;
-			break;
-		}
-		xfs_buf_iorequest(bp);
-		error = xfs_buf_iowait(bp);
-		if (error) {
-			xfs_buf_ioerror_alert(bp,
-					"xfs_zero_remaining_bytes(read)");
-			break;
+		bp = xfs_buf_read_uncached(XFS_IS_REALTIME_INODE(ip) ?
+				mp->m_rtdev_targp : mp->m_ddev_targp,
+				xfs_fsb_to_db(ip, imap.br_startblock),
+				BTOBB(mp->m_sb.sb_blocksize),
+				0, NULL);
+		if (!bp)
+			return -ENOMEM;
+		if (bp->b_error) {
+			error = bp->b_error;
+			xfs_buf_relse(bp);
+			return error;
 		}
+
 		memset(bp->b_addr +
 			(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
 		      0, lastoffset - offset + 1);
-		XFS_BUF_UNDONE(bp);
-		XFS_BUF_UNREAD(bp);
-		XFS_BUF_WRITE(bp);
 
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			error = -EIO;
-			break;
-		}
-		xfs_buf_iorequest(bp);
-		error = xfs_buf_iowait(bp);
-		if (error) {
-			xfs_buf_ioerror_alert(bp,
-					"xfs_zero_remaining_bytes(write)");
-			break;
-		}
+		xfs_bwrite(bp);
 	}
-	xfs_buf_free(bp);
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
