Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 42AB529DF9
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F7178F8037
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XoSQArF6MNX26UMm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:58 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 8225E2C76F8
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJvl2004543
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 10/18] xfs_repair: don't clear the log by default
Date: Fri,  2 Oct 2015 14:19:47 -0400
Message-Id: <1443809995-20395-11-git-send-email-bfoster@redhat.com>
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

xfs_repair currently clears the log regardless of whether it is
corrupted, clean or contains data. This is traditionally harmless but
now causes log recovery problems on v5 filesystems. v5 filesystems
expect a clean log to always have an LSN out ahead of the maximum last
modification LSN stamped on any bit of metadata throughout the fs. If
this is not the case, repair must reformat the log with a larger cycle
number after fs processing is complete.

Given that unconditional log clearing actually introduces a filesystem
inconsistency on v5 superblocks (that repair must subsequently recover
from) and provides no tangible benefit for v4 filesystems that otherwise
have a clean and covered log, it is more appropriate behavior to not
clear the log by default.

Update xfs_repair to always and only clear the log when the -L parameter
is specified. Retain the existing logic to require -L or otherwise exit
if the log appears to contain data. Adopt similar behavior if the log
appears to be corrupted.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase2.c | 60 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/repair/phase2.c b/repair/phase2.c
index 72132ce..fe7ed2b 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -36,11 +36,13 @@ int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
 }
 
 static void
-zero_log(xfs_mount_t *mp)
+zero_log(
+	struct xfs_mount	*mp)
 {
-	int error;
-	xfs_daddr_t head_blk, tail_blk;
-	struct xlog	*log = mp->m_log;
+	int			error;
+	xfs_daddr_t		head_blk;
+	xfs_daddr_t		tail_blk;
+	struct xlog		*log = mp->m_log;
 
 	memset(log, 0, sizeof(struct xlog));
 	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
@@ -65,10 +67,22 @@ zero_log(xfs_mount_t *mp)
 	}
 	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
 
-	if ((error = xlog_find_tail(log, &head_blk, &tail_blk))) {
-		do_warn(_("zero_log: cannot find log head/tail "
-			  "(xlog_find_tail=%d), zeroing it anyway\n"),
+	/*
+	 * Find the log head and tail and alert the user to the situation if the
+	 * log appears corrupted or contains data. In either case, we do not
+	 * proceed past this point unless the user explicitly requests to zap
+	 * the log.
+	 */
+	error = xlog_find_tail(log, &head_blk, &tail_blk);
+	if (error) {
+		do_warn(
+		_("zero_log: cannot find log head/tail (xlog_find_tail=%d)\n"),
 			error);
+		if (!no_modify && !zap_log)
+			do_error(_(
+"ERROR: The log head and/or tail cannot be discovered. Attempt to mount the\n"
+"filesystem to replay the log or use the -L option to destroy the log and\n"
+"attempt a repair.\n"));
 	} else {
 		if (verbose) {
 			do_warn(
@@ -93,19 +107,25 @@ zero_log(xfs_mount_t *mp)
 		}
 	}
 
-	if (no_modify)
-		return;
-
-	libxfs_log_clear(log->l_dev, XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-		(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
-		&mp->m_sb.sb_uuid,
-		xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
-		mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE);
-
-	/* update the log data structure with new state */
-	error = xlog_find_tail(log, &head_blk, &tail_blk);
-	if (error || head_blk != tail_blk)
-		do_error(_("failed to clear log"));
+	/*
+	 * Only clear the log when explicitly requested. Doing so is unnecessary
+	 * unless something is wrong. Further, this resets the current LSN of
+	 * the filesystem and creates more work for repair of v5 superblock
+	 * filesystems.
+	 */
+	if (!no_modify && zap_log) {
+		libxfs_log_clear(log->l_dev,
+			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
+			&mp->m_sb.sb_uuid,
+			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
+			mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE);
+
+		/* update the log data structure with new state */
+		error = xlog_find_tail(log, &head_blk, &tail_blk);
+		if (error || head_blk != tail_blk)
+			do_error(_("failed to clear log"));
+	}
 }
 
 /*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
