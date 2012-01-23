Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHWfru122914 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:32:41 -0600
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id PrwqDBua7pMJYtUl for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:32:40 -0800 (PST)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 23 Jan 2012 10:32:39 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 6CCBE1FF0049
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:31:44 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0NHVd4D135092 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:31:41 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q0NHVcZ8008134
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:31:38 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 23 Jan 2012 11:31:37 -0600
Message-Id: <20120123173137.31546.33777.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC PATCH 3/4] Change xfs_sb_from_disk() interface to take a mount
	pointer
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Change xfs_sb_from_disk() interface to take a mount pointer
instead of a superblock pointer.

This is to print mount point specific error messages in future
fixes.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_log_recover.c |    2 +-
 fs/xfs/xfs_mount.c       |    6 ++++--
 fs/xfs/xfs_mount.h       |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 19f69e2..c082e44 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -395,7 +395,7 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
 extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
 					xfs_agnumber_t *);
-extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
+extern void	xfs_sb_from_disk(struct xfs_mount *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 541a508..b38eb84 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3695,7 +3695,7 @@ xlog_do_recover(
 
 	/* Convert superblock from on-disk format */
 	sbp = &log->l_mp->m_sb;
-	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_from_disk(log->l_mp, XFS_BUF_TO_SBP(bp));
 	ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
 	ASSERT(xfs_sb_good_version(sbp));
 	xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d06afbc..25e9908 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -553,9 +553,11 @@ out_unwind:
 
 void
 xfs_sb_from_disk(
-	xfs_sb_t	*to,
+	struct xfs_mount	*mp,
 	xfs_dsb_t	*from)
 {
+	struct xfs_sb *to = &mp->m_sb;
+
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
 	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
 	to->sb_dblocks = be64_to_cpu(from->sb_dblocks);
@@ -693,7 +695,7 @@ reread:
 	 * Initialize the mount structure from the superblock.
 	 * But first do some basic consistency checking.
 	 */
-	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
+	xfs_sb_from_disk(mp, XFS_BUF_TO_SBP(bp));
 	error = xfs_mount_validate_sb(mp, &(mp->m_sb), flags);
 	if (error) {
 		if (loud)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
