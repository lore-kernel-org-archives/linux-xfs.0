Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0041D7F5A
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:55:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83CC4AC00E
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uGR5FxIZsCClkhAQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:45 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id A61FDA8A
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:55:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BIti7r027204
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:55:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 07/12] xfs_repair: track log state throughout all recovery
	phases
Date: Fri, 11 Sep 2015 14:55:37 -0400
Message-Id: <1441997742-37160-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
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

xfs_repair examines and clears the log in phase 2. Phase 2 acquires the
log state in local data structures that are lost upon phase exit. v5
filesystems require that the log is formatted with a higher cycle number
after the fs is repaired. This requires assessment of the log state to
determine whether a reformat is necessary.

Rather than duplicate the log processing code, update phase 2 to
populate a globally available log data structure. Add a log pointer to
xfs_mount, as exists in kernel space, that repair uses to store a
reference to the log that is available to various phases. Note that this
patch simply plumbs through the global log data structure and does not
change behavior in any way.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 include/xfs_mount.h |  6 ++++++
 repair/phase2.c     | 34 +++++++++++++++++++---------------
 repair/xfs_repair.c |  8 +++++++-
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index ed897a2..5ec6866 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -98,6 +98,12 @@ typedef struct xfs_mount {
 		int	qi_dqperchunk;
 	}			*m_quotainfo;
 
+	/*
+	 * xlog is defined in libxlog and thus is not intialized by libxfs. This
+	 * allows an application to initialize and store a reference to the log
+	 * if warranted.
+	 */
+	struct xlog		*m_log;
 } xfs_mount_t;
 
 /*
diff --git a/repair/phase2.c b/repair/phase2.c
index 0673a0c..11504e3 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -39,33 +39,33 @@ static void
 zero_log(xfs_mount_t *mp)
 {
 	int error;
-	struct xlog	log;
 	xfs_daddr_t head_blk, tail_blk;
+	struct xlog	*log = mp->m_log;
 
-	memset(&log, 0, sizeof(log));
+	memset(log, 0, sizeof(struct xlog));
 	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 	x.lbsize = BBSIZE;
 	if (xfs_sb_version_hassector(&mp->m_sb))
 		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 
-	log.l_dev = mp->m_logdev_targp;
-	log.l_logBBsize = x.logBBsize;
-	log.l_logBBstart = x.logBBstart;
-	log.l_sectBBsize  = BTOBB(x.lbsize);
-	log.l_mp = mp;
+	log->l_dev = mp->m_logdev_targp;
+	log->l_logBBsize = x.logBBsize;
+	log->l_logBBstart = x.logBBstart;
+	log->l_sectBBsize  = BTOBB(x.lbsize);
+	log->l_mp = mp;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
-		log.l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
-		ASSERT(log.l_sectbb_log <= mp->m_sectbb_log);
+		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
+		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
 		/* for larger sector sizes, must have v2 or external log */
-		ASSERT(log.l_sectbb_log == 0 ||
-			log.l_logBBstart == 0 ||
+		ASSERT(log->l_sectbb_log == 0 ||
+			log->l_logBBstart == 0 ||
 			xfs_sb_version_haslogv2(&mp->m_sb));
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
-	log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
+	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
 
-	if ((error = xlog_find_tail(&log, &head_blk, &tail_blk))) {
+	if ((error = xlog_find_tail(log, &head_blk, &tail_blk))) {
 		do_warn(_("zero_log: cannot find log head/tail "
 			  "(xlog_find_tail=%d), zeroing it anyway\n"),
 			error);
@@ -93,12 +93,16 @@ zero_log(xfs_mount_t *mp)
 		}
 	}
 
-	libxfs_log_clear(log.l_dev,
-		XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+	libxfs_log_clear(log->l_dev, XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 		&mp->m_sb.sb_uuid,
 		xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
 		mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE);
+
+	/* update the log data structure with new state */
+	error = xlog_find_tail(log, &head_blk, &tail_blk);
+	if (error || head_blk != tail_blk)
+		do_error(_("failed to clear log"));
 }
 
 /*
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 85a012b..0e80124 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -539,6 +539,7 @@ main(int argc, char **argv)
 	xfs_dsb_t	*dsb;
 	xfs_buf_t	*sbp;
 	xfs_mount_t	xfs_m;
+	struct xlog	log = {0};
 	char		*msgbuf;
 	struct xfs_sb	psb;
 	int		rval;
@@ -620,7 +621,11 @@ main(int argc, char **argv)
 		}
 	}
 
-	/* prepare the mount structure */
+	/*
+	 * Prepare the mount structure. Point the log reference to our local
+	 * copy so it's available to the various phases. The log bits are
+	 * initialized in phase 2.
+	 */
 	memset(&xfs_m, 0, sizeof(xfs_mount_t));
 	mp = libxfs_mount(&xfs_m, &psb, x.ddev, x.logdev, x.rtdev, 0);
 
@@ -630,6 +635,7 @@ main(int argc, char **argv)
 			progname);
 		exit(1);
 	}
+	mp->m_log = &log;
 
 	/*
 	 * set XFS-independent status vars from the mount/sb structure
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
