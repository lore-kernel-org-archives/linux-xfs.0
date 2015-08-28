Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 272867F3F
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 13:06:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E18538F8035
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 11:06:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TZIIbAxHRdPiUt8u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2015 11:06:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id C8F3C8CF6E
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 18:06:49 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-103.bos.redhat.com [10.18.41.103])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7SI6nHX027619
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 14:06:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5/9] libxfs: add ability to clear log to arbitrary log cycle
Date: Fri, 28 Aug 2015 14:06:43 -0400
Message-Id: <1440785207-17543-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1440785207-17543-1-git-send-email-bfoster@redhat.com>
References: <1440785207-17543-1-git-send-email-bfoster@redhat.com>
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

The libxfs_log_clear() helper currently zeroes the log and writes a
single log record such that the kernel code detects the log has been
zeroed and mounts successfully. This is not sufficient for v5
filesystems, which must have the log cleared to an LSN that is
guaranteed to be ahead of any LSN that has been previously stamped into
on-disk metadata.

Update libxfs_log_clear() to support the ability to format the log to an
arbitrary cycle number. First, the log is physically zeroed. A log
record is written to the first block of the log with the desired lsn and
refers to the tail_lsn as the last record of the previous cycle. The
rest of the log is filled with log records of the previous cycle. This
causes the kernel to set the current LSN to start of the desired cycle
number at mount time.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/rdwr.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 6 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9cd7f3d..8b6ded2 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -155,26 +155,81 @@ libxfs_log_clear(
 	xfs_buf_t		*bp;
 	int			len;
 	xfs_lsn_t		lsn;
+	xfs_lsn_t		tail_lsn;
+	xfs_daddr_t		blk;
+	xfs_daddr_t		end_blk;
 
 	if (!btp->dev || !fs_uuid)
 		return -EINVAL;
 
-	if (cycle != XLOG_INIT_CYCLE)
+	if (cycle < XLOG_INIT_CYCLE)
 		return -EINVAL;
 
-	lsn = xlog_assign_lsn(cycle, 0);
-
 	/* first zero the log */
 	libxfs_device_zero(btp, start, length);
 
-	/* then write a log record header */
+	/*
+	 * Initialize the log record length and LSNs. XLOG_INIT_CYCLE is a
+	 * special reset case where we only write a single record where the lsn
+	 * and tail_lsn match. Otherwise, the record lsn starts at block 0 of
+	 * the specified cycle and points tail_lsn at the last record of the
+	 * previous cycle.
+	 */
 	len = ((version == 2) && sunit) ? BTOBB(sunit) : 2;
 	len = MAX(len, 2);
+	lsn = xlog_assign_lsn(cycle, 0);
+	if (cycle == XLOG_INIT_CYCLE)
+		tail_lsn = lsn;
+	else
+		tail_lsn = xlog_assign_lsn(cycle - 1, length - len);
+
+	/* write out the first log record */
 	bp = libxfs_getbufr(btp, start, len);
-	libxfs_log_header(XFS_BUF_PTR(bp), fs_uuid, version, sunit, fmt, lsn,
-			  lsn, next, bp);
+	libxfs_log_header(XFS_BUF_PTR(bp), fs_uuid, version, sunit, fmt,
+			  lsn, tail_lsn, next, bp);
 	bp->b_flags |= LIBXFS_B_DIRTY;
 	libxfs_putbufr(bp);
+
+	/*
+	 * There's nothing else to do if this is a log reset. The kernel detects
+	 * the rest of the log is zeroed and starts at cycle 1.
+	 */
+	if (cycle == XLOG_INIT_CYCLE)
+		return 0;
+
+	/*
+	 * Otherwise, fill everything beyond the initial record with records of
+	 * the previous cycle so the kernel head/tail detection works correctly.
+	 *
+	 * We don't particularly care about the record size or content here.
+	 * It's only important that the headers are in place such that the
+	 * kernel finds 1.) a clean log and 2.) the correct current cycle value.
+	 * Therefore, bump up the record size to the max to use larger I/Os and
+	 * improve performance.
+	 */
+	cycle--;
+	blk = start + len;
+	end_blk = start + length;
+
+	len = min(end_blk - blk, BTOBB(BDSTRAT_SIZE));
+	while (blk < end_blk) {
+		lsn = xlog_assign_lsn(cycle, blk - start);
+		tail_lsn = xlog_assign_lsn(cycle, blk - start - len);
+
+		bp = libxfs_getbufr(btp, blk, len);
+		/*
+		 * Note: pass the full buffer length as the sunit to initialize
+		 * the entire buffer.
+		 */
+		libxfs_log_header(XFS_BUF_PTR(bp), fs_uuid, version, BBTOB(len),
+				  fmt, lsn, tail_lsn, next, bp);
+		bp->b_flags |= LIBXFS_B_DIRTY;
+		libxfs_putbufr(bp);
+
+		len = min(end_blk - blk, BTOBB(BDSTRAT_SIZE));
+		blk += len;
+	}
+
 	return 0;
 }
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
