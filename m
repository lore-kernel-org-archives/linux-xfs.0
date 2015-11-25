Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ACE2C7F5A
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 14:18:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C7A7AC007
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:18:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id scUCzDY2kf9dail1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:17:59 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 03D1FC0D2226
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 20:17:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-225.bos.redhat.com [10.18.41.225])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAPKHwRO015469
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 15:17:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] libxfs: conditionalize log format record size optimization
Date: Wed, 25 Nov 2015 15:17:56 -0500
Message-Id: <1448482677-44364-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
References: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
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

The libxfs log clear mechanism includes an optimization to use the
maximum log buffer size (256k) when the log is being fully written
(i.e., cycle != 1). This behavior is always enabled as no current
callers are concerned with the size of the records written to format the
log to a given cycle.

A log format command will be added to xfs_db to facilitate testing of
the userspace log format code (among other things). This command is not
performance oriented and prefers the ability to format the log with
varying record sizes.

Update libxfs_log_clear() to use a new parameter to enable or disable
the record size optimization. Note that the flag is a no-op when the
cycle == XLOG_INIT_CYCLE (e.g., mkfs).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 copy/xfs_copy.c     |  2 +-
 db/metadump.c       |  2 +-
 db/sb.c             |  2 +-
 include/libxfs.h    |  2 +-
 libxfs/rdwr.c       | 15 ++++++++++++---
 mkfs/xfs_mkfs.c     |  3 ++-
 repair/phase2.c     |  2 +-
 repair/xfs_repair.c |  2 +-
 8 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 1dc7c65..62edfc8 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1328,7 +1328,7 @@ format_log(
 	 */
 	libxfs_log_clear(NULL, buf->data, logstart, length, &buf->owner->uuid,
 			 xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
-			 mp->m_sb.sb_logsunit, XLOG_FMT, cycle);
+			 mp->m_sb.sb_logsunit, XLOG_FMT, cycle, true);
 	if (do_write(buf->owner, buf))
 		target[tcarg->id].state = INACTIVE;
 }
diff --git a/db/metadump.c b/db/metadump.c
index 8cdcb92..8455fdd 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2552,7 +2552,7 @@ copy_log(void)
 
 		libxfs_log_clear(NULL, iocur_top->data, logstart, logblocks,
 				 &mp->m_sb.sb_uuid, logversion,
-				 mp->m_sb.sb_logsunit, XLOG_FMT, cycle);
+				 mp->m_sb.sb_logsunit, XLOG_FMT, cycle, true);
 		break;
 	case 1:
 		/* keep the dirty log */
diff --git a/db/sb.c b/db/sb.c
index 17d446c..ee3927d 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -288,7 +288,7 @@ sb_logzero(uuid_t *uuidp)
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			uuidp,
 			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
-			mp->m_sb.sb_logsunit, XLOG_FMT, cycle);
+			mp->m_sb.sb_logsunit, XLOG_FMT, cycle, true);
 	if (error) {
 		dbprintf(_("ERROR: cannot clear the log\n"));
 		return 0;
diff --git a/include/libxfs.h b/include/libxfs.h
index 04c6f9c..bd51df0 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -154,7 +154,7 @@ typedef char	*(libxfs_get_block_t)(char *, int, void *);
  */
 #define XLOG_INIT_CYCLE	1
 extern int	libxfs_log_clear(struct xfs_buftarg *, char *, xfs_daddr_t,
-				 uint, uuid_t *, int, int, int, int);
+				 uint, uuid_t *, int, int, int, int, bool);
 extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 				  xfs_lsn_t, libxfs_get_block_t *, void *);
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 16904d0..7a04985 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -162,7 +162,8 @@ libxfs_log_clear(
 	int			version,
 	int			sunit,		/* bytes */
 	int			fmt,
-	int			cycle)
+	int			cycle,
+	bool			max)
 {
 	struct xfs_buf		*bp = NULL;
 	int			len;
@@ -218,6 +219,14 @@ libxfs_log_clear(
 		return 0;
 
 	/*
+	 * Bump the record size for a full log format if the caller allows it.
+	 * This is primarily for performance reasons and most callers don't care
+	 * about record size since the log is clean after we're done.
+	 */
+	if (max)
+		len = BTOBB(BDSTRAT_SIZE);
+
+	/*
 	 * Otherwise, fill everything beyond the initial record with records of
 	 * the previous cycle so the kernel head/tail detection works correctly.
 	 *
@@ -233,7 +242,7 @@ libxfs_log_clear(
 		dptr += BBTOB(len);
 	end_blk = start + length;
 
-	len = min(end_blk - blk, BTOBB(BDSTRAT_SIZE));
+	len = min(end_blk - blk, len);
 	while (blk < end_blk) {
 		lsn = xlog_assign_lsn(cycle, blk - start);
 		tail_lsn = xlog_assign_lsn(cycle, blk - start - len);
@@ -257,7 +266,7 @@ libxfs_log_clear(
 		blk += len;
 		if (dptr)
 			dptr += BBTOB(len);
-		len = min(end_blk - blk, BTOBB(BDSTRAT_SIZE));
+		len = min(end_blk - blk, len);
 	}
 
 	return 0;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7cba41a..546108d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2713,7 +2713,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	libxfs_log_clear(mp->m_logdev_targp, NULL,
 		XFS_FSB_TO_DADDR(mp, logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT, XLOG_INIT_CYCLE);
+		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT, XLOG_INIT_CYCLE,
+		false);
 
 	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
 	if (mp == NULL) {
diff --git a/repair/phase2.c b/repair/phase2.c
index cb24711..e21ffa6 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -119,7 +119,7 @@ zero_log(
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			&mp->m_sb.sb_uuid,
 			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
-			mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE);
+			mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE, true);
 
 		/* update the log data structure with new state */
 		error = xlog_find_tail(log, &head_blk, &tail_blk);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 1aeac5b..3eaced4 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -586,7 +586,7 @@ format_log_max_lsn(
 	do_warn(_("Format log to cycle %d.\n"), new_cycle);
 	libxfs_log_clear(log->l_dev, NULL, logstart, logblocks,
 			 &mp->m_sb.sb_uuid, logversion, mp->m_sb.sb_logsunit,
-			 XLOG_FMT, new_cycle);
+			 XLOG_FMT, new_cycle, true);
 }
 
 int
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
