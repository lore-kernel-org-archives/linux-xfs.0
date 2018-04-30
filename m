Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36564 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753582AbeD3PpN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 11:45:13 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CF5994C1515
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 10:44:01 -0500 (CDT)
Subject: [PATCH 3/5] xfs: move xfs_scrub_checkpoint_log to xfs_log_checkpoint
 for general use
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c57f7f1e-f5f5-56f3-b85c-4c8f6edfba0c@sandeen.net>
Date: Mon, 30 Apr 2018 10:45:13 -0500
MIME-Version: 1.0
In-Reply-To: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The upcoming online label patch will require forcing the superblock
change from the log to the actual on-disk superblock, so move this log
checkpoint function out for general use.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/scrub/common.c | 16 +---------------
 fs/xfs/scrub/common.h |  1 -
 fs/xfs/xfs_log.c      | 14 ++++++++++++++
 fs/xfs/xfs_log.h      |  1 +
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8ed91d5..6044399 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -594,7 +594,7 @@ struct xfs_scrub_rmap_ownedby_info {
 	 * document why they need to do so.
 	 */
 	if (force_log) {
-		error = xfs_scrub_checkpoint_log(mp);
+		error = xfs_log_checkpoint(mp);
 		if (error)
 			return error;
 	}
@@ -606,20 +606,6 @@ struct xfs_scrub_rmap_ownedby_info {
 	return xfs_scrub_ag_init(sc, sc->sm->sm_agno, &sc->sa);
 }
 
-/* Push everything out of the log onto disk. */
-int
-xfs_scrub_checkpoint_log(
-	struct xfs_mount	*mp)
-{
-	int			error;
-
-	error = xfs_log_force(mp, XFS_LOG_SYNC);
-	if (error)
-		return error;
-	xfs_ail_push_all_sync(mp->m_ail);
-	return 0;
-}
-
 /*
  * Given an inode and the scrub control structure, grab either the
  * inode referenced in the control structure or the inode passed in.
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index deaf604..a88ae07 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -83,7 +83,6 @@ void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset);
 
 void xfs_scrub_set_incomplete(struct xfs_scrub_context *sc);
-int xfs_scrub_checkpoint_log(struct xfs_mount *mp);
 
 /* Are we set up for a cross-referencing check? */
 bool xfs_scrub_should_check_xref(struct xfs_scrub_context *sc, int *error,
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2fcd9ed..326fbe8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -4095,3 +4095,17 @@ struct xlog_ticket *
 
 	return valid;
 }
+
+/* Push everything out of the log onto disk. */
+int
+xfs_log_checkpoint(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		return error;
+	xfs_ail_push_all_sync(mp->m_ail);
+	return 0;
+}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index fa8ad31..df2d5d2 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -165,5 +165,6 @@ void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 void	xfs_log_work_queue(struct xfs_mount *mp);
 void	xfs_log_quiesce(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
+int	xfs_log_checkpoint(struct xfs_mount *mp);
 
 #endif	/* __XFS_LOG_H__ */
-- 
1.8.3.1

