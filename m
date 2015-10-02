Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B83FA7F5A
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0821304032
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gQM0T7jMuwMRnIFX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:58 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id AADCDC0B64B9
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJveN023994
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 13/18] db/metadump: bump lsn when log is cleared on v5
	supers
Date: Fri,  2 Oct 2015 14:19:50 -0400
Message-Id: <1443809995-20395-14-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
References: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
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

xfs_metadump handles the log in different ways depending on the mode of
operation. If the log is dirty or obfuscation and stale data zeroing are
disabled, the log is copied as is. In all other scenarios, the log is
explicitly zeroed. This is incorrect for version 5 superblocks where the
current LSN is always expected to be ahead of all fs metadata.

Update metadump to use libxfs_log_clear() to format the log with an
elevated LSN rather than zero the log and reset the current the LSN.
Metadump does not use buffers for the dump target, instead using a
cursor implementation to access the log via a single memory buffer.
Therefore, update libxfs_log_clear() to receive an optional (but
exclusive to the buftarg parameter) memory buffer pointer for the log.
If the pointer is provided, the log format is written out to this
buffer. Otherwise, fall back to the original behavior and access the log
through buftarg buffers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/metadump.c       | 16 +++++++++++--
 db/sb.c             |  2 +-
 include/libxfs.h    |  4 ++--
 libxfs/rdwr.c       | 68 +++++++++++++++++++++++++++++++++++++++--------------
 mkfs/xfs_mkfs.c     |  2 +-
 repair/phase2.c     |  2 +-
 repair/xfs_repair.c |  5 ++--
 7 files changed, 72 insertions(+), 27 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 129670e..56b733e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2514,6 +2514,10 @@ copy_log(void)
 {
 	struct xlog	log;
 	int		dirty;
+	xfs_daddr_t	logstart;
+	int		logblocks;
+	int		logversion;
+	int		cycle = XLOG_INIT_CYCLE;
 
 	if (show_progress)
 		print_progress("Copying log");
@@ -2538,8 +2542,16 @@ copy_log(void)
 		/* clear out a clean log */
 		if (show_progress)
 			print_progress("Zeroing clean log");
-		memset(iocur_top->data, 0,
-			mp->m_sb.sb_logblocks * mp->m_sb.sb_blocksize);
+
+		logstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
+		logblocks = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+		logversion = xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1;
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			cycle = log.l_curr_cycle + 1;
+
+		libxfs_log_clear(NULL, iocur_top->data, logstart, logblocks,
+				 &mp->m_sb.sb_uuid, logversion,
+				 mp->m_sb.sb_logsunit, XLOG_FMT, cycle);
 		break;
 	case 1:
 		/* keep the dirty log */
diff --git a/db/sb.c b/db/sb.c
index 30c622d..17d446c 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -283,7 +283,7 @@ sb_logzero(uuid_t *uuidp)
 
 	dbprintf(_("Clearing log and setting UUID\n"));
 
-	error =  libxfs_log_clear(mp->m_logdev_targp,
+	error =  libxfs_log_clear(mp->m_logdev_targp, NULL,
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			uuidp,
diff --git a/include/libxfs.h b/include/libxfs.h
index 6c87934..f733c36 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -153,8 +153,8 @@ typedef char	*(libxfs_get_block_t)(char *, int, void *);
  * Helpers to clear the log to a particular log cycle.
  */
 #define XLOG_INIT_CYCLE	1
-extern int	libxfs_log_clear(struct xfs_buftarg *, xfs_daddr_t, uint,
-				 uuid_t *, int, int, int, int);
+extern int	libxfs_log_clear(struct xfs_buftarg *, char *, xfs_daddr_t,
+				 uint, uuid_t *, int, int, int, int);
 extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 				  xfs_lsn_t, libxfs_get_block_t *, void *);
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 93f6eb7..ee41a1e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -133,38 +133,54 @@ static void unmount_record(void *p)
 	memcpy((char *)p + sizeof(xlog_op_header_t), &magic, sizeof(magic));
 }
 
-static char *next(char *ptr, int offset, void *private)
+static char *next(
+	char		*ptr,
+	int		offset,
+	void		*private)
 {
-	xfs_buf_t	*buf = (xfs_buf_t *)private;
+	struct xfs_buf	*buf = (struct xfs_buf *)private;
 
-	if (XFS_BUF_COUNT(buf) < (int)(ptr - XFS_BUF_PTR(buf)) + offset)
+	if (buf &&
+	    (XFS_BUF_COUNT(buf) < (int)(ptr - XFS_BUF_PTR(buf)) + offset))
 		abort();
+
 	return ptr + offset;
 }
 
+/*
+ * Format the log. The caller provides either a buftarg which is used to access
+ * the log via buffers or a direct pointer to a buffer that encapsulates the
+ * entire log.
+ */
 int
 libxfs_log_clear(
 	struct xfs_buftarg	*btp,
+	char			*dptr,
 	xfs_daddr_t		start,
-	uint			length,
+	uint			length,		/* basic blocks */
 	uuid_t			*fs_uuid,
 	int			version,
-	int			sunit,
+	int			sunit,		/* bytes */
 	int			fmt,
 	int			cycle)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp = NULL;
 	int			len;
 	xfs_lsn_t		lsn;
 	xfs_lsn_t		tail_lsn;
 	xfs_daddr_t		blk;
 	xfs_daddr_t		end_blk;
+	char			*ptr;
 
-	if (!btp->dev || !fs_uuid)
+	if (((btp && dptr) || (!btp && !dptr)) ||
+	    (btp && !btp->dev) || !fs_uuid)
 		return -EINVAL;
 
 	/* first zero the log */
-	libxfs_device_zero(btp, start, length);
+	if (btp)
+		libxfs_device_zero(btp, start, length);
+	else
+		memset(dptr, 0, BBTOB(length));
 
 	/*
 	 * Initialize the log record length and LSNs. XLOG_INIT_CYCLE is a
@@ -182,11 +198,17 @@ libxfs_log_clear(
 		tail_lsn = xlog_assign_lsn(cycle - 1, length - len);
 
 	/* write out the first log record */
-	bp = libxfs_getbufr(btp, start, len);
-	libxfs_log_header(XFS_BUF_PTR(bp), fs_uuid, version, sunit, fmt,
-			  lsn, tail_lsn, next, bp);
-	bp->b_flags |= LIBXFS_B_DIRTY;
-	libxfs_putbufr(bp);
+	ptr = dptr;
+	if (btp) {
+		bp = libxfs_getbufr(btp, start, len);
+		ptr = XFS_BUF_PTR(bp);
+	}
+	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
+			  next, bp);
+	if (bp) {
+		bp->b_flags |= LIBXFS_B_DIRTY;
+		libxfs_putbufr(bp);
+	}
 
 	/*
 	 * There's nothing else to do if this is a log reset. The kernel detects
@@ -207,6 +229,8 @@ libxfs_log_clear(
 	 */
 	cycle--;
 	blk = start + len;
+	if (dptr)
+		dptr += BBTOB(len);
 	end_blk = start + length;
 
 	len = min(end_blk - blk, BTOBB(BDSTRAT_SIZE));
@@ -214,18 +238,26 @@ libxfs_log_clear(
 		lsn = xlog_assign_lsn(cycle, blk - start);
 		tail_lsn = xlog_assign_lsn(cycle, blk - start - len);
 
-		bp = libxfs_getbufr(btp, blk, len);
+		ptr = dptr;
+		if (btp) {
+			bp = libxfs_getbufr(btp, blk, len);
+			ptr = XFS_BUF_PTR(bp);
+		}
 		/*
 		 * Note: pass the full buffer length as the sunit to initialize
 		 * the entire buffer.
 		 */
-		libxfs_log_header(XFS_BUF_PTR(bp), fs_uuid, version, BBTOB(len),
-				  fmt, lsn, tail_lsn, next, bp);
-		bp->b_flags |= LIBXFS_B_DIRTY;
-		libxfs_putbufr(bp);
+		libxfs_log_header(ptr, fs_uuid, version, BBTOB(len), fmt, lsn,
+				  tail_lsn, next, bp);
+		if (bp) {
+			bp->b_flags |= LIBXFS_B_DIRTY;
+			libxfs_putbufr(bp);
+		}
 
 		len = min(end_blk - blk, BTOBB(BDSTRAT_SIZE));
 		blk += len;
+		if (dptr)
+			dptr += BBTOB(len);
 	}
 
 	return 0;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 238d400..5f939b5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2667,7 +2667,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	/*
 	 * Zero the log....
 	 */
-	libxfs_log_clear(mp->m_logdev_targp,
+	libxfs_log_clear(mp->m_logdev_targp, NULL,
 		XFS_FSB_TO_DADDR(mp, logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
 		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT, XLOG_INIT_CYCLE);
diff --git a/repair/phase2.c b/repair/phase2.c
index f9d0e22..cb24711 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -114,7 +114,7 @@ zero_log(
 	 * filesystems.
 	 */
 	if (!no_modify && zap_log) {
-		libxfs_log_clear(log->l_dev,
+		libxfs_log_clear(log->l_dev, NULL,
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			&mp->m_sb.sb_uuid,
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8285d9d..bed2ff5 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -584,8 +584,9 @@ format_log_max_lsn(
 	}
 
 	do_warn(_("Format log to cycle %d.\n"), new_cycle);
-	libxfs_log_clear(log->l_dev, logstart, logblocks, &mp->m_sb.sb_uuid,
-			 logversion, mp->m_sb.sb_logsunit, XLOG_FMT, new_cycle);
+	libxfs_log_clear(log->l_dev, NULL, logstart, logblocks,
+			 &mp->m_sb.sb_uuid, logversion, mp->m_sb.sb_logsunit,
+			 XLOG_FMT, new_cycle);
 }
 
 int
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
