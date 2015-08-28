Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44D027F51
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 13:06:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 124E98F8040
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 11:06:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CVYOcy5bgiKFphKh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2015 11:06:50 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id D39B28EB50
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 18:06:49 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-103.bos.redhat.com [10.18.41.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7SI6nKV006118
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 14:06:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 8/9] xfs_repair: format the log with forward cycle number on
	v5 supers
Date: Fri, 28 Aug 2015 14:06:46 -0400
Message-Id: <1440785207-17543-9-git-send-email-bfoster@redhat.com>
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

v5 filesystems use the current LSN and the last modified LSN stored
within fs metadata to provide correct log recovery ordering. xfs_repair
historically clears the log in phase 2. This resets to the current LSN
of the filesystem to the initial cycle, as if the fs was just created.

This is problematic because the filesystem LSN is now behind many
pre-existing metadata structures on-disk until either the current
filesystem LSN catches up or those particular data structures are
modified and written out. If a filesystem crash occurs in the meantime,
log recovery can incorrectly skip log items and cause filesystem
corruption.

Update xfs_repair to check the maximum metadata LSN value against the
current log state once the filesystem has been processed. If the maximum
LSN exceeds the current LSN with respect to the log, reformat the log
with a cycle number that exceeds that of the maximum LSN.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/xfs_repair.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 0e80124..8285d9d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -531,6 +531,63 @@ _("sb realtime summary inode %" PRIu64 " %sinconsistent with calculated value %u
 
 }
 
+/*
+ * v5 superblock metadata track the LSN of last modification and thus require
+ * that the current LSN is always moving forward. The current LSN is reset if
+ * the log has been cleared, which puts the log behind parts of the filesystem
+ * on-disk and can disrupt log recovery.
+ *
+ * We have tracked the maximum LSN of every piece of metadata that has been read
+ * in via the read verifiers. Compare the max LSN with the log and if the log is
+ * behind, bump the cycle number and reformat the log.
+ */
+static void
+format_log_max_lsn(
+	struct xfs_mount	*mp)
+{
+	struct xlog		*log = mp->m_log;
+	int			max_cycle;
+	int			max_block;
+	int			new_cycle;
+	xfs_daddr_t		logstart;
+	xfs_daddr_t		logblocks;
+	int			logversion;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	/*
+	 * If the log is ahead of the highest metadata LSN we've seen, we're
+	 * safe and there's nothing to do.
+	 */
+	max_cycle = CYCLE_LSN(libxfs_max_lsn);
+	max_block = BLOCK_LSN(libxfs_max_lsn);
+	if (max_cycle < log->l_curr_cycle ||
+	    (max_cycle == log->l_curr_cycle && max_block < log->l_curr_block))
+		return;
+
+	/*
+	 * Going to the next cycle should be sufficient but we bump by a few
+	 * counts to help cover any metadata LSNs we could have missed.
+	 */
+	new_cycle = max_cycle + 3;
+	logstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
+	logblocks = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	logversion = xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1;
+
+	do_warn(_("Maximum metadata LSN (%d:%d) is ahead of log (%d:%d).\n"),
+		max_cycle, max_block, log->l_curr_cycle, log->l_curr_block);
+
+	if (no_modify) {
+		do_warn(_("Would format log to cycle %d.\n"), new_cycle);
+		return;
+	}
+
+	do_warn(_("Format log to cycle %d.\n"), new_cycle);
+	libxfs_log_clear(log->l_dev, logstart, logblocks, &mp->m_sb.sb_uuid,
+			 logversion, mp->m_sb.sb_logsunit, XLOG_FMT, new_cycle);
+}
+
 int
 main(int argc, char **argv)
 {
@@ -896,6 +953,12 @@ _("Warning:  project quota information would be cleared.\n"
 		stop_progress_rpt();
 
 	if (no_modify)  {
+		/*
+		 * Warn if the current LSN is problematic and the log requires a
+		 * reformat.
+		 */
+		format_log_max_lsn(mp);
+
 		do_log(
 	_("No modify flag set, skipping filesystem flush and exiting.\n"));
 		if (verbose)
@@ -931,11 +994,14 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	libxfs_writebuf(sbp, 0);
 
 	/*
-	 * Done, flush all cached buffers and inodes.
+	 * Done. Flush all cached buffers and inodes first to ensure all
+	 * verifiers are run (where we discover the max metadata LSN), reformat
+	 * the log if necessary and unmount.
 	 */
 	libxfs_bcache_flush();
-
+	format_log_max_lsn(mp);
 	libxfs_umount(mp);
+
 	if (x.rtdev)
 		libxfs_device_close(x.rtdev);
 	if (x.logdev && x.logdev != x.ddev)
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
