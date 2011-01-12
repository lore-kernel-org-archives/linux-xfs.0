Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0YG9U124028 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:34:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBA48FD432B
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:27 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	AUeN8a0MFwZjGTXc for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:27 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52533598-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:26 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohM-0000V1-Dn
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogu-0002GL-Uh
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/12] xfs: convert xfs_fs_cmn_err to new error logging API
Date: Wed, 12 Jan 2011 11:35:49 +1100
Message-Id: <1294792553-8378-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Continue to clean up the error logging code by converting all the
callers of xfs_fs_cmn_err() to the new API. once done, remove the
unused old API function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_dquot.c      |    4 ++--
 fs/xfs/quota/xfs_dquot_item.c |    5 ++---
 fs/xfs/quota/xfs_qm.c         |   13 ++++++-------
 fs/xfs/support/debug.c        |   20 --------------------
 fs/xfs/support/debug.h        |    2 --
 fs/xfs/xfs_bmap.c             |    2 +-
 fs/xfs/xfs_dfrag.c            |    4 ++--
 fs/xfs/xfs_dir2.c             |    2 +-
 fs/xfs/xfs_fsops.c            |    6 +++---
 fs/xfs/xfs_ialloc.c           |   39 +++++++++++++++++----------------------
 fs/xfs/xfs_inode.c            |   17 +++++++----------
 fs/xfs/xfs_mount.c            |   16 ++++++++--------
 fs/xfs/xfs_vnodeops.c         |    8 ++++----
 13 files changed, 53 insertions(+), 85 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 773adc8..e1ff7e5 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1393,8 +1393,8 @@ xfs_qm_dqpurge(
 		 */
 		error = xfs_qm_dqflush(dqp, SYNC_WAIT);
 		if (error)
-			xfs_fs_cmn_err(CE_WARN, mp,
-				"xfs_qm_dqpurge: dquot %p flush failed", dqp);
+			xfs_warn(mp, "%s: dquot %p flush failed",
+				__func__, dqp);
 		xfs_dqflock(dqp);
 	}
 	ASSERT(atomic_read(&dqp->q_pincount) == 0);
diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
index 2a1f3dc..9e0e2fa 100644
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -136,9 +136,8 @@ xfs_qm_dquot_logitem_push(
 	 */
 	error = xfs_qm_dqflush(dqp, 0);
 	if (error)
-		xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
-			"xfs_qm_dquot_logitem_push: push error %d on dqp %p",
-			error, dqp);
+		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
+			__func__, error, dqp);
 	xfs_dqunlock(dqp);
 }
 
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index d87c4a3..2488e2f 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -402,14 +402,13 @@ xfs_qm_mount_quotas(
 			 * off, but the on disk superblock doesn't know that !
 			 */
 			ASSERT(!(XFS_IS_QUOTA_RUNNING(mp)));
-			xfs_fs_cmn_err(CE_ALERT, mp,
-				"XFS mount_quotas: Superblock update failed!");
+			xfs_alert(mp, "%s: Superblock update failed!",
+				__func__);
 		}
 	}
 
 	if (error) {
-		xfs_fs_cmn_err(CE_WARN, mp,
-			"Failed to initialize disk quotas.");
+		xfs_warn(mp, "Failed to initialize disk quotas.");
 		return;
 	}
 
@@ -1264,7 +1263,7 @@ xfs_qm_qino_alloc(
 	xfs_mod_sb(tp, sbfields);
 
 	if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES))) {
-		xfs_fs_cmn_err(CE_ALERT, mp, "XFS qino_alloc failed!");
+		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 		return error;
 	}
 	return 0;
@@ -1941,8 +1940,8 @@ startagain:
 			 */
 			error = xfs_qm_dqflush(dqp, 0);
 			if (error) {
-				xfs_fs_cmn_err(CE_WARN, mp,
-			"xfs_qm_dqreclaim: dquot %p flush failed", dqp);
+				xfs_warn(mp, "%s: dquot %p flush failed",
+					__func__, dqp);
 			}
 			xfs_dqunlock(dqp); /* dqflush unlocks dqflock */
 			continue;
diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index b93b75d..98daab6 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -45,26 +45,6 @@ cmn_err(
 }
 
 void
-xfs_fs_cmn_err(
-	const char		*lvl,
-	struct xfs_mount	*mp,
-	const char		*fmt,
-	...)
-{
-	struct va_format	vaf;
-	va_list			args;
-
-	va_start(args, fmt);
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	printk("%sFilesystem %s: %pV", lvl, mp->m_fsname, &vaf);
-	va_end(args);
-
-	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
-}
-
-void
 assfail(char *expr, char *file, int line)
 {
 	printk("Assertion failed: %s, file: %s, line: %d\n", expr, file, line);
diff --git a/fs/xfs/support/debug.h b/fs/xfs/support/debug.h
index eaeaa17..4a082b9 100644
--- a/fs/xfs/support/debug.h
+++ b/fs/xfs/support/debug.h
@@ -31,8 +31,6 @@ struct xfs_mount;
 
 void cmn_err(const char *lvl, const char *fmt, ...)
 		__attribute__ ((format (printf, 2, 3)));
-void xfs_fs_cmn_err( const char *lvl, struct xfs_mount *mp,
-		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
 
 extern void assfail(char *expr, char *f, int l);
 
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 87919e1..922b793 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6114,7 +6114,7 @@ xfs_bmap_punch_delalloc_range(
 		if (error) {
 			/* something screwed, just bail */
 			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+				xfs_alert(ip->i_mount,
 			"Failed delalloc mapping lookup ino %lld fsb %lld.",
 						ip->i_ino, start_fsb);
 			}
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index e60490b..be62867 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -270,9 +270,9 @@ xfs_swap_extents(
 	/* check inode formats now that data is flushed */
 	error = xfs_swap_extents_check_format(ip, tip);
 	if (error) {
-		xfs_fs_cmn_err(CE_NOTE, mp,
+		xfs_notice(mp,
 		    "%s: inode 0x%llx format is incompatible for exchanging.",
-				__FILE__, ip->i_ino);
+				__func__, ip->i_ino);
 		goto out_unlock;
 	}
 
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index a1321bc..dba7a71 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -159,7 +159,7 @@ xfs_dir_ino_validate(
 		XFS_AGINO_TO_INO(mp, agno, agino) == ino;
 	if (unlikely(XFS_TEST_ERROR(!ino_ok, mp, XFS_ERRTAG_DIR_INO_VALIDATE,
 			XFS_RANDOM_DIR_INO_VALIDATE))) {
-		xfs_fs_cmn_err(CE_WARN, mp, "Invalid inode number 0x%Lx",
+		xfs_warn(mp, "Invalid inode number 0x%Lx",
 				(unsigned long long) ino);
 		XFS_ERROR_REPORT("xfs_dir_ino_validate", XFS_ERRLEVEL_LOW, mp);
 		return XFS_ERROR(EFSCORRUPTED);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cec89dd..f12507d 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -382,8 +382,8 @@ xfs_growfs_data_private(
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
 		if (error) {
-			xfs_fs_cmn_err(CE_WARN, mp,
-			"error %d reading secondary superblock for ag %d",
+			xfs_warn(mp,
+		"error %d reading secondary superblock for ag %d",
 				error, agno);
 			break;
 		}
@@ -396,7 +396,7 @@ xfs_growfs_data_private(
 		if (!(error = xfs_bwrite(mp, bp))) {
 			continue;
 		} else {
-			xfs_fs_cmn_err(CE_WARN, mp,
+			xfs_warn(mp,
 		"write error %d updating secondary superblock for ag %d",
 				error, agno);
 			break; /* no point in continuing */
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 0626a32..fc3a2cb 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1218,10 +1218,9 @@ xfs_imap_lookup(
 
 	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
 	if (error) {
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-				"xfs_ialloc_read_agi() returned "
-				"error %d, agno %d",
-				error, agno);
+		xfs_alert(mp,
+			"%s: xfs_ialloc_read_agi() returned error %d, agno %d",
+			__func__, error, agno);
 		return error;
 	}
 
@@ -1299,24 +1298,21 @@ xfs_imap(
 		if (flags & XFS_IGET_UNTRUSTED)
 			return XFS_ERROR(EINVAL);
 		if (agno >= mp->m_sb.sb_agcount) {
-			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_imap: agno (%d) >= "
-					"mp->m_sb.sb_agcount (%d)",
-					agno,  mp->m_sb.sb_agcount);
+			xfs_alert(mp,
+				"%s: agno (%d) >= mp->m_sb.sb_agcount (%d)",
+				__func__, agno, mp->m_sb.sb_agcount);
 		}
 		if (agbno >= mp->m_sb.sb_agblocks) {
-			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_imap: agbno (0x%llx) >= "
-					"mp->m_sb.sb_agblocks (0x%lx)",
-					(unsigned long long) agbno,
-					(unsigned long) mp->m_sb.sb_agblocks);
+			xfs_alert(mp,
+		"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
+				__func__, (unsigned long long)agbno,
+				(unsigned long)mp->m_sb.sb_agblocks);
 		}
 		if (ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
-			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_imap: ino (0x%llx) != "
-					"XFS_AGINO_TO_INO(mp, agno, agino) "
-					"(0x%llx)",
-					ino, XFS_AGINO_TO_INO(mp, agno, agino));
+			xfs_alert(mp,
+		"%s: ino (0x%llx) != XFS_AGINO_TO_INO() (0x%llx)",
+				__func__, ino,
+				XFS_AGINO_TO_INO(mp, agno, agino));
 		}
 		xfs_stack_trace();
 #endif /* DEBUG */
@@ -1388,10 +1384,9 @@ out_map:
 	 */
 	if ((imap->im_blkno + imap->im_len) >
 	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
-			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
-			(unsigned long long) imap->im_blkno,
+		xfs_alert(mp,
+	"%s: (im_blkno (0x%llx) + im_len (0x%llx)) > sb_dblocks (0x%llx)",
+			__func__, (unsigned long long) imap->im_blkno,
 			(unsigned long long) imap->im_len,
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
 		return XFS_ERROR(EINVAL);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 85c5410..60f2dd5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -110,8 +110,8 @@ xfs_inobp_check(
 		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
 					i * mp->m_sb.sb_inodesize);
 		if (!dip->di_next_unlinked)  {
-			xfs_fs_cmn_err(CE_ALERT, mp,
-				"Detected a bogus zero next_unlinked field in incore inode buffer 0x%p.  About to pop an ASSERT.",
+			xfs_alert(mp,
+	"Detected bogus zero next_unlinked field in incore inode buffer 0x%p.",
 				bp);
 			ASSERT(dip->di_next_unlinked);
 		}
@@ -806,11 +806,9 @@ xfs_iread(
 	 */
 	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC) {
 #ifdef DEBUG
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
-				"dip->di_magic (0x%x) != "
-				"XFS_DINODE_MAGIC (0x%x)",
-				be16_to_cpu(dip->di_magic),
-				XFS_DINODE_MAGIC);
+		xfs_alert(mp,
+			"%s: dip->di_magic (0x%x) != XFS_DINODE_MAGIC (0x%x)",
+			__func__, be16_to_cpu(dip->di_magic), XFS_DINODE_MAGIC);
 #endif /* DEBUG */
 		error = XFS_ERROR(EINVAL);
 		goto out_brelse;
@@ -828,9 +826,8 @@ xfs_iread(
 		error = xfs_iformat(ip, dip);
 		if (error)  {
 #ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
-					"xfs_iformat() returned error %d",
-					error);
+			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
+				__func__, error);
 #endif /* DEBUG */
 			goto out_brelse;
 		}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1b43ad3..e39b082 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -881,8 +881,9 @@ xfs_update_alignment(xfs_mount_t *mp)
 				if (mp->m_flags & XFS_MOUNT_RETERR) {
 					return XFS_ERROR(EINVAL);
 				}
-				xfs_fs_cmn_err(CE_WARN, mp,
-"stripe alignment turned off: sunit(%d)/swidth(%d) incompatible with agsize(%d)",
+				xfs_warn(mp,
+		"stripe alignment turned off: sunit(%d)/swidth(%d) "
+		"incompatible with agsize(%d)",
 					mp->m_dalign, mp->m_swidth,
 					sbp->sb_agblocks);
 
@@ -892,9 +893,9 @@ xfs_update_alignment(xfs_mount_t *mp)
 				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 			} else {
 				if (mp->m_flags & XFS_MOUNT_RETERR) {
-					xfs_fs_cmn_err(CE_WARN, mp,
-"stripe alignment turned off: sunit(%d) less than bsize(%d)",
-                                        	mp->m_dalign,
+					xfs_warn(mp,
+		"stripe alignment turned off: sunit(%d) less than bsize(%d)",
+						mp->m_dalign,
 						mp->m_blockmask +1);
 					return XFS_ERROR(EINVAL);
 				}
@@ -1100,7 +1101,7 @@ xfs_mount_reset_sbqflags(
 		return 0;
 
 #ifdef QUOTADEBUG
-	xfs_fs_cmn_err(CE_NOTE, mp, "Writing superblock quota changes");
+	xfs_notice(mp, "Writing superblock quota changes");
 #endif
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
@@ -1108,8 +1109,7 @@ xfs_mount_reset_sbqflags(
 				      XFS_DEFAULT_LOG_COUNT);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
-		xfs_fs_cmn_err(CE_ALERT, mp,
-			"xfs_mount_reset_sbqflags: Superblock update failed!");
+		xfs_alert(mp, "%s: Superblock update failed!", __func__);
 		return error;
 	}
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index d8e6f8c..d34533d 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1208,12 +1208,12 @@ xfs_inactive(
 		 */
 		error = xfs_bmap_finish(&tp,  &free_list, &committed);
 		if (error)
-			xfs_fs_cmn_err(CE_NOTE, mp, "xfs_inactive: "
-				"xfs_bmap_finish() returned error %d", error);
+			xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
+				__func__, error);
 		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 		if (error)
-			xfs_fs_cmn_err(CE_NOTE, mp, "xfs_inactive: "
-				"xfs_trans_commit() returned error %d", error);
+			xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
+				__func__, error);
 	}
 
 	/*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
