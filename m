Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0YIhi124058 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:34:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60BD01D2641E
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	PuQcMrFtoHpqumnN for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:28 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52263213-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:26 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohM-0000V3-I5
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogv-0002GT-49
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/12] xfs: Convert remaining cmn_err() callers to new API
Date: Wed, 12 Jan 2011 11:35:52 +1100
Message-Id: <1294792553-8378-12-git-send-email-david@fromorbit.com>
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

Once converted, kill the remainder of the cmn_err() interface.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_dquot.c       |   34 ++++++++++++----------
 fs/xfs/quota/xfs_qm.c          |   27 ++++++++----------
 fs/xfs/quota/xfs_qm_bhv.c      |    3 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   58 ++++++++++++++++++++------------------
 fs/xfs/quota/xfs_trans_dquot.c |    5 ++-
 fs/xfs/support/debug.c         |   26 -----------------
 fs/xfs/support/debug.h         |   12 --------
 fs/xfs/xfs_bmap.c              |    6 ++--
 fs/xfs/xfs_buf_item.c          |   15 +++++----
 fs/xfs/xfs_da_btree.c          |    9 ++---
 fs/xfs/xfs_dir2_node.c         |   25 ++++++----------
 fs/xfs/xfs_error.c             |   16 ++++------
 fs/xfs/xfs_ialloc.c            |   43 +++++++++++-----------------
 fs/xfs/xfs_inode.c             |   30 ++++++++-----------
 fs/xfs/xfs_mount.c             |   60 ++++++++++++++++------------------------
 fs/xfs/xfs_rtalloc.c           |    8 ++--
 fs/xfs/xfs_rtalloc.h           |    2 +-
 fs/xfs/xfs_rw.c                |   17 +++++------
 fs/xfs/xfs_trans_buf.c         |    6 ++--
 fs/xfs/xfs_vnodeops.c          |    5 +--
 20 files changed, 169 insertions(+), 238 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index e1ff7e5..7e24164 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -828,7 +828,7 @@ xfs_qm_dqget(
 	if (xfs_do_dqerror) {
 		if ((xfs_dqerror_target == mp->m_ddev_targp) &&
 		    (xfs_dqreq_num++ % xfs_dqerror_mod) == 0) {
-			cmn_err(CE_DEBUG, "Returning error in dqget");
+			xfs_debug(mp, "Returning error in dqget");
 			return (EIO);
 		}
 	}
@@ -1427,36 +1427,38 @@ xfs_qm_dqpurge(
 void
 xfs_qm_dqprint(xfs_dquot_t *dqp)
 {
-	cmn_err(CE_DEBUG, "-----------KERNEL DQUOT----------------");
-	cmn_err(CE_DEBUG, "---- dquotID =  %d",
+	struct xfs_mount	*mp = dqp->q_mount;
+
+	xfs_debug(mp, "-----------KERNEL DQUOT----------------");
+	xfs_debug(mp, "---- dquotID =  %d",
 		(int)be32_to_cpu(dqp->q_core.d_id));
-	cmn_err(CE_DEBUG, "---- type    =  %s", DQFLAGTO_TYPESTR(dqp));
-	cmn_err(CE_DEBUG, "---- fs      =  0x%p", dqp->q_mount);
-	cmn_err(CE_DEBUG, "---- blkno   =  0x%x", (int) dqp->q_blkno);
-	cmn_err(CE_DEBUG, "---- boffset =  0x%x", (int) dqp->q_bufoffset);
-	cmn_err(CE_DEBUG, "---- blkhlimit =  %Lu (0x%x)",
+	xfs_debug(mp, "---- type    =  %s", DQFLAGTO_TYPESTR(dqp));
+	xfs_debug(mp, "---- fs      =  0x%p", dqp->q_mount);
+	xfs_debug(mp, "---- blkno   =  0x%x", (int) dqp->q_blkno);
+	xfs_debug(mp, "---- boffset =  0x%x", (int) dqp->q_bufoffset);
+	xfs_debug(mp, "---- blkhlimit =  %Lu (0x%x)",
 		be64_to_cpu(dqp->q_core.d_blk_hardlimit),
 		(int)be64_to_cpu(dqp->q_core.d_blk_hardlimit));
-	cmn_err(CE_DEBUG, "---- blkslimit =  %Lu (0x%x)",
+	xfs_debug(mp, "---- blkslimit =  %Lu (0x%x)",
 		be64_to_cpu(dqp->q_core.d_blk_softlimit),
 		(int)be64_to_cpu(dqp->q_core.d_blk_softlimit));
-	cmn_err(CE_DEBUG, "---- inohlimit =  %Lu (0x%x)",
+	xfs_debug(mp, "---- inohlimit =  %Lu (0x%x)",
 		be64_to_cpu(dqp->q_core.d_ino_hardlimit),
 		(int)be64_to_cpu(dqp->q_core.d_ino_hardlimit));
-	cmn_err(CE_DEBUG, "---- inoslimit =  %Lu (0x%x)",
+	xfs_debug(mp, "---- inoslimit =  %Lu (0x%x)",
 		be64_to_cpu(dqp->q_core.d_ino_softlimit),
 		(int)be64_to_cpu(dqp->q_core.d_ino_softlimit));
-	cmn_err(CE_DEBUG, "---- bcount  =  %Lu (0x%x)",
+	xfs_debug(mp, "---- bcount  =  %Lu (0x%x)",
 		be64_to_cpu(dqp->q_core.d_bcount),
 		(int)be64_to_cpu(dqp->q_core.d_bcount));
-	cmn_err(CE_DEBUG, "---- icount  =  %Lu (0x%x)",
+	xfs_debug(mp, "---- icount  =  %Lu (0x%x)",
 		be64_to_cpu(dqp->q_core.d_icount),
 		(int)be64_to_cpu(dqp->q_core.d_icount));
-	cmn_err(CE_DEBUG, "---- btimer  =  %d",
+	xfs_debug(mp, "---- btimer  =  %d",
 		(int)be32_to_cpu(dqp->q_core.d_btimer));
-	cmn_err(CE_DEBUG, "---- itimer  =  %d",
+	xfs_debug(mp, "---- itimer  =  %d",
 		(int)be32_to_cpu(dqp->q_core.d_itimer));
-	cmn_err(CE_DEBUG, "---------------------------");
+	xfs_debug(mp, "---------------------------");
 }
 #endif
 
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 2488e2f..3dede6a 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -80,7 +80,7 @@ xfs_qm_dquot_list_print(
 	int		i = 0;
 
 	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist_lock, qi_mplist) {
-		cmn_err(CE_DEBUG, "   %d. \"%d (%s)\"   "
+		xfs_debug(mp, "   %d. \"%d (%s)\"   "
 				  "bcnt = %lld, icnt = %lld, refs = %d",
 			i++, be32_to_cpu(dqp->q_core.d_id),
 			DQFLAGTO_TYPESTR(dqp),
@@ -205,7 +205,7 @@ xfs_qm_destroy(
 	list_for_each_entry_safe(dqp, n, &xqm->qm_dqfrlist, q_freelist) {
 		xfs_dqlock(dqp);
 #ifdef QUOTADEBUG
-		cmn_err(CE_DEBUG, "FREELIST destroy 0x%p", dqp);
+		xfs_debug(dqp->q_mount, "FREELIST destroy 0x%p", dqp);
 #endif
 		list_del_init(&dqp->q_freelist);
 		xfs_Gqm->qm_dqfrlist_cnt--;
@@ -341,9 +341,7 @@ xfs_qm_mount_quotas(
 	 * quotas immediately.
 	 */
 	if (mp->m_sb.sb_rextents) {
-		cmn_err(CE_NOTE,
-			"Cannot turn on quotas for realtime filesystem %s",
-			mp->m_fsname);
+		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
 		mp->m_qflags = 0;
 		goto write_changes;
 	}
@@ -1675,7 +1673,7 @@ xfs_qm_quotacheck(
 	 */
 	ASSERT(list_empty(&mp->m_quotainfo->qi_dqlist));
 
-	cmn_err(CE_NOTE, "XFS quotacheck %s: Please wait.", mp->m_fsname);
+	xfs_notice(mp, "Quotacheck needed: Please wait.");
 
 	/*
 	 * First we go thru all the dquots on disk, USR and GRP/PRJ, and reset
@@ -1753,9 +1751,9 @@ xfs_qm_quotacheck(
 
  error_return:
 	if (error) {
-		cmn_err(CE_WARN, "XFS quotacheck %s: Unsuccessful (Error %d): "
-			"Disabling quotas.",
-			mp->m_fsname, error);
+		xfs_warn(mp,
+	"Quotacheck: Unsuccessful (Error %d): Disabling quotas.",
+			error);
 		/*
 		 * We must turn off quotas.
 		 */
@@ -1763,12 +1761,11 @@ xfs_qm_quotacheck(
 		ASSERT(xfs_Gqm != NULL);
 		xfs_qm_destroy_quotainfo(mp);
 		if (xfs_mount_reset_sbqflags(mp)) {
-			cmn_err(CE_WARN, "XFS quotacheck %s: "
-				"Failed to reset quota flags.", mp->m_fsname);
+			xfs_warn(mp,
+				"Quotacheck: Failed to reset quota flags.");
 		}
-	} else {
-		cmn_err(CE_NOTE, "XFS quotacheck %s: Done.", mp->m_fsname);
-	}
+	} else
+		xfs_notice(mp, "Quotacheck: Done.");
 	return (error);
 }
 
@@ -2118,7 +2115,7 @@ xfs_qm_write_sb_changes(
 	int		error;
 
 #ifdef QUOTADEBUG
-	cmn_err(CE_NOTE, "Writing superblock quota changes :%s", mp->m_fsname);
+	xfs_notice(mp, "Writing superblock quota changes");
 #endif
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
 	if ((error = xfs_trans_reserve(tp, 0,
diff --git a/fs/xfs/quota/xfs_qm_bhv.c b/fs/xfs/quota/xfs_qm_bhv.c
index 45b5cb1..774d7ec 100644
--- a/fs/xfs/quota/xfs_qm_bhv.c
+++ b/fs/xfs/quota/xfs_qm_bhv.c
@@ -119,8 +119,7 @@ xfs_qm_newmount(
 	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
 	    (!gquotaondisk &&  XFS_IS_OQUOTA_ON(mp)))  &&
 	    xfs_dev_is_read_only(mp, "changing quota state")) {
-		cmn_err(CE_WARN,
-			"XFS: please mount with%s%s%s%s.",
+		xfs_warn(mp, "please mount with%s%s%s%s.",
 			(!quotaondisk ? "out quota" : ""),
 			(uquotaondisk ? " usrquota" : ""),
 			(pquotaondisk ? " prjquota" : ""),
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 603ab86..c82f067 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -936,10 +936,11 @@ struct mutex  qcheck_lock;
 #define DQTEST_LIST_PRINT(l, NXT, title) \
 { \
 	  xfs_dqtest_t	*dqp; int i = 0;\
-	  cmn_err(CE_DEBUG, "%s (#%d)", title, (int) (l)->qh_nelems); \
+	  xfs_debug(NULL, "%s (#%d)", title, (int) (l)->qh_nelems); \
 	  for (dqp = (xfs_dqtest_t *)(l)->qh_next; dqp != NULL; \
 	       dqp = (xfs_dqtest_t *)dqp->NXT) { \
-		cmn_err(CE_DEBUG, "  %d. \"%d (%s)\"  bcnt = %d, icnt = %d", \
+		xfs_debug(dqp->q_mount,		\
+			"  %d. \"%d (%s)\"  bcnt = %d, icnt = %d", \
 			 ++i, dqp->d_id, DQFLAGTO_TYPESTR(dqp),	     \
 			 dqp->d_bcount, dqp->d_icount); } \
 }
@@ -963,16 +964,17 @@ xfs_qm_hashinsert(xfs_dqhash_t *h, xfs_dqtest_t *dqp)
 }
 STATIC void
 xfs_qm_dqtest_print(
-	xfs_dqtest_t	*d)
+	struct xfs_mount	*mp,
+	struct dqtest		*d)
 {
-	cmn_err(CE_DEBUG, "-----------DQTEST DQUOT----------------");
-	cmn_err(CE_DEBUG, "---- dquot ID = %d", d->d_id);
-	cmn_err(CE_DEBUG, "---- fs       = 0x%p", d->q_mount);
-	cmn_err(CE_DEBUG, "---- bcount   = %Lu (0x%x)",
+	xfs_debug(mp, "-----------DQTEST DQUOT----------------");
+	xfs_debug(mp, "---- dquot ID = %d", d->d_id);
+	xfs_debug(mp, "---- fs       = 0x%p", d->q_mount);
+	xfs_debug(mp, "---- bcount   = %Lu (0x%x)",
 		d->d_bcount, (int)d->d_bcount);
-	cmn_err(CE_DEBUG, "---- icount   = %Lu (0x%x)",
+	xfs_debug(mp, "---- icount   = %Lu (0x%x)",
 		d->d_icount, (int)d->d_icount);
-	cmn_err(CE_DEBUG, "---------------------------");
+	xfs_debug(mp, "---------------------------");
 }
 
 STATIC void
@@ -986,12 +988,14 @@ xfs_qm_dqtest_failed(
 {
 	qmtest_nfails++;
 	if (error)
-		cmn_err(CE_DEBUG, "quotacheck failed id=%d, err=%d\nreason: %s",
-		       d->d_id, error, reason);
+		xfs_debug(dqp->q_mount,
+			"quotacheck failed id=%d, err=%d\nreason: %s",
+			d->d_id, error, reason);
 	else
-		cmn_err(CE_DEBUG, "quotacheck failed id=%d (%s) [%d != %d]",
-		       d->d_id, reason, (int)a, (int)b);
-	xfs_qm_dqtest_print(d);
+		xfs_debug(dqp->q_mount,
+			"quotacheck failed id=%d (%s) [%d != %d]",
+			d->d_id, reason, (int)a, (int)b);
+	xfs_qm_dqtest_print(dqp->q_mount, d);
 	if (dqp)
 		xfs_qm_dqprint(dqp);
 }
@@ -1018,9 +1022,9 @@ xfs_dqtest_cmp2(
 	    be64_to_cpu(dqp->q_core.d_bcount) >=
 	    be64_to_cpu(dqp->q_core.d_blk_softlimit)) {
 		if (!dqp->q_core.d_btimer && dqp->q_core.d_id) {
-			cmn_err(CE_DEBUG,
-				"%d [%s] [0x%p] BLK TIMER NOT STARTED",
-				d->d_id, DQFLAGTO_TYPESTR(d), d->q_mount);
+			xfs_debug(dqp->q_mount,
+				"%d [%s] BLK TIMER NOT STARTED",
+				d->d_id, DQFLAGTO_TYPESTR(d));
 			err++;
 		}
 	}
@@ -1028,16 +1032,16 @@ xfs_dqtest_cmp2(
 	    be64_to_cpu(dqp->q_core.d_icount) >=
 	    be64_to_cpu(dqp->q_core.d_ino_softlimit)) {
 		if (!dqp->q_core.d_itimer && dqp->q_core.d_id) {
-			cmn_err(CE_DEBUG,
-				"%d [%s] [0x%p] INO TIMER NOT STARTED",
-				d->d_id, DQFLAGTO_TYPESTR(d), d->q_mount);
+			xfs_debug(dqp->q_mount,
+				"%d [%s] INO TIMER NOT STARTED",
+				d->d_id, DQFLAGTO_TYPESTR(d));
 			err++;
 		}
 	}
 #ifdef QUOTADEBUG
 	if (!err) {
-		cmn_err(CE_DEBUG, "%d [%s] [0x%p] qchecked",
-			d->d_id, DQFLAGTO_TYPESTR(d), d->q_mount);
+		xfs_debug(dqp->q_mount, "%d [%s] qchecked",
+			d->d_id, DQFLAGTO_TYPESTR(d));
 	}
 #endif
 	return (err);
@@ -1220,12 +1224,12 @@ xfs_qm_internalqcheck(
 				 xfs_qm_internalqcheck_adjust,
 				 0, NULL, &done);
 		if (error) {
-			cmn_err(CE_DEBUG, "Bulkstat returned error 0x%x", error);
+			xfs_debug(mp, "Bulkstat returned error 0x%x", error);
 			break;
 		}
 	} while (!done);
 
-	cmn_err(CE_DEBUG, "Checking results against system dquots");
+	xfs_debug(mp, "Checking results against system dquots");
 	for (i = 0; i < qmtest_hashmask; i++) {
 		xfs_dqtest_t	*d, *n;
 		xfs_dqhash_t	*h;
@@ -1243,10 +1247,10 @@ xfs_qm_internalqcheck(
 	}
 
 	if (qmtest_nfails) {
-		cmn_err(CE_DEBUG, "******** quotacheck failed  ********");
-		cmn_err(CE_DEBUG, "failures = %d", qmtest_nfails);
+		xfs_debug(mp, "******** quotacheck failed  ********");
+		xfs_debug(mp, "failures = %d", qmtest_nfails);
 	} else {
-		cmn_err(CE_DEBUG, "******** quotacheck successful! ********");
+		xfs_debug(mp, "******** quotacheck successful! ********");
 	}
 	kmem_free(qmtest_udqtab);
 	kmem_free(qmtest_gdqtab);
diff --git a/fs/xfs/quota/xfs_trans_dquot.c b/fs/xfs/quota/xfs_trans_dquot.c
index 7de91d1..2a36487 100644
--- a/fs/xfs/quota/xfs_trans_dquot.c
+++ b/fs/xfs/quota/xfs_trans_dquot.c
@@ -643,8 +643,9 @@ xfs_trans_dqresv(
 	     (XFS_IS_OQUOTA_ENFORCED(dqp->q_mount) &&
 	      (XFS_QM_ISPDQ(dqp) || XFS_QM_ISGDQ(dqp))))) {
 #ifdef QUOTADEBUG
-		cmn_err(CE_DEBUG, "BLK Res: nblks=%ld + resbcount=%Ld"
-			  " > hardlimit=%Ld?", nblks, *resbcountp, hardlimit);
+		xfs_debug(mp,
+			"BLK Res: nblks=%ld + resbcount=%Ld > hardlimit=%Ld?",
+			nblks, *resbcountp, hardlimit);
 #endif
 		if (nblks > 0) {
 			/*
diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index 98daab6..c9020ae 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -18,32 +18,6 @@
 #include <xfs.h>
 #include "debug.h"
 
-/* xfs_mount.h drags a lot of crap in, sorry.. */
-#include "xfs_sb.h"
-#include "xfs_inum.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_error.h"
-
-void
-cmn_err(
-	const char	*lvl,
-	const char	*fmt,
-	...)
-{
-	struct va_format vaf;
-	va_list		args;
-
-	va_start(args, fmt);
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	printk("%s%pV", lvl, &vaf);
-	va_end(args);
-
-	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
-}
-
 void
 assfail(char *expr, char *file, int line)
 {
diff --git a/fs/xfs/support/debug.h b/fs/xfs/support/debug.h
index 4a082b9..db36be4 100644
--- a/fs/xfs/support/debug.h
+++ b/fs/xfs/support/debug.h
@@ -20,18 +20,6 @@
 
 #include <stdarg.h>
 
-struct xfs_mount;
-
-#define CE_DEBUG        KERN_DEBUG
-#define CE_CONT         KERN_INFO
-#define CE_NOTE         KERN_NOTICE
-#define CE_WARN         KERN_WARNING
-#define CE_ALERT        KERN_ALERT
-#define CE_PANIC        KERN_EMERG
-
-void cmn_err(const char *lvl, const char *fmt, ...)
-		__attribute__ ((format (printf, 2, 3)));
-
 extern void assfail(char *expr, char *f, int l);
 
 #define ASSERT_ALWAYS(expr)	\
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 922b793..e6d23a2 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5742,7 +5742,7 @@ xfs_check_block(
 			else
 				thispa = XFS_BMBT_PTR_ADDR(mp, block, j, dmxr);
 			if (*thispa == *pp) {
-				cmn_err(CE_WARN, "%s: thispa(%d) == pp(%d) %Ld",
+				xfs_warn(mp, "%s: thispa(%d) == pp(%d) %Ld",
 					__func__, j, i,
 					(unsigned long long)be64_to_cpu(*thispa));
 				panic("%s: ptrs are equal in node\n",
@@ -5907,11 +5907,11 @@ xfs_bmap_check_leaf_extents(
 	return;
 
 error0:
-	cmn_err(CE_WARN, "%s: at error0", __func__);
+	xfs_warn(mp, "%s: at error0", __func__);
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	cmn_err(CE_WARN, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
 		__func__, i);
 	panic("%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	return;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 98c6f73..169a380 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -130,10 +130,12 @@ xfs_buf_item_log_check(
 	orig = bip->bli_orig;
 	buffer = XFS_BUF_PTR(bp);
 	for (x = 0; x < XFS_BUF_COUNT(bp); x++) {
-		if (orig[x] != buffer[x] && !btst(bip->bli_logged, x))
-			cmn_err(CE_PANIC,
-	"xfs_buf_item_log_check bip %x buffer %x orig %x index %d",
-				bip, bp, orig, x);
+		if (orig[x] != buffer[x] && !btst(bip->bli_logged, x)) {
+			xfs_emerg(bp->b_mount,
+				"%s: bip %x buffer %x orig %x index %d",
+				__func__, bip, bp, orig, x);
+			ASSERT(0);
+		}
 	}
 }
 #else
@@ -981,10 +983,9 @@ xfs_buf_iodone_callbacks(
 	if (XFS_BUF_TARGET(bp) != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
-		cmn_err(CE_ALERT, "Device %s, XFS metadata write error"
-				" block 0x%llx in %s",
+		xfs_alert(mp, "Device %s: metadata write error block 0x%llx",
 			XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
-		      (__uint64_t)XFS_BUF_ADDR(bp), mp->m_fsname);
+		      (__uint64_t)XFS_BUF_ADDR(bp));
 	}
 	lasttarg = XFS_BUF_TARGET(bp);
 
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 1c00bed..6102ac6 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1995,13 +1995,12 @@ xfs_da_do_buf(
 		error = mappedbno == -2 ? 0 : XFS_ERROR(EFSCORRUPTED);
 		if (unlikely(error == EFSCORRUPTED)) {
 			if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
-				cmn_err(CE_ALERT, "xfs_da_do_buf: bno %lld\n",
-					(long long)bno);
-				cmn_err(CE_ALERT, "dir: inode %lld\n",
+				xfs_alert(mp, "%s: bno %lld dir: inode %lld",
+					__func__, (long long)bno,
 					(long long)dp->i_ino);
 				for (i = 0; i < nmap; i++) {
-					cmn_err(CE_ALERT,
-						"[%02d] br_startoff %lld br_startblock %lld br_blockcount %lld br_state %d\n",
+					xfs_alert(mp,
+"[%02d] br_startoff %lld br_startblock %lld br_blockcount %lld br_state %d",
 						i,
 						(long long)mapp[i].br_startoff,
 						(long long)mapp[i].br_startblock,
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index f9a0864..a0aab7d 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -899,10 +899,9 @@ xfs_dir2_leafn_rebalance(
 	if(blk2->index < 0) {
 		state->inleaf = 1;
 		blk2->index = 0;
-		cmn_err(CE_ALERT,
-			"xfs_dir2_leafn_rebalance: picked the wrong leaf? reverting original leaf: "
-			"blk1->index %d\n",
-			blk1->index);
+		xfs_alert(args->dp->i_mount,
+	"%s: picked the wrong leaf? reverting original leaf: blk1->index %d\n",
+			__func__, blk1->index);
 	}
 }
 
@@ -1641,26 +1640,22 @@ xfs_dir2_node_addname_int(
 			}
 
 			if (unlikely(xfs_dir2_db_to_fdb(mp, dbno) != fbno)) {
-				cmn_err(CE_ALERT,
-					"xfs_dir2_node_addname_int: dir ino "
-					"%llu needed freesp block %lld for\n"
-					"  data block %lld, got %lld\n"
-					"  ifbno %llu lastfbno %d\n",
-					(unsigned long long)dp->i_ino,
+				xfs_alert(mp,
+			"%s: dir ino " "%llu needed freesp block %lld for\n"
+			"  data block %lld, got %lld ifbno %llu lastfbno %d",
+					__func__, (unsigned long long)dp->i_ino,
 					(long long)xfs_dir2_db_to_fdb(mp, dbno),
 					(long long)dbno, (long long)fbno,
 					(unsigned long long)ifbno, lastfbno);
 				if (fblk) {
-					cmn_err(CE_ALERT,
-						" fblk 0x%p blkno %llu "
-						"index %d magic 0x%x\n",
+					xfs_alert(mp,
+				" fblk 0x%p blkno %llu index %d magic 0x%x",
 						fblk,
 						(unsigned long long)fblk->blkno,
 						fblk->index,
 						fblk->magic);
 				} else {
-					cmn_err(CE_ALERT,
-						" ... fblk is NULL\n");
+					xfs_alert(mp, " ... fblk is NULL");
 				}
 				XFS_ERROR_REPORT("xfs_dir2_node_addname_int",
 						 XFS_ERRLEVEL_LOW, mp);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 0302890..39f0633 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -48,7 +48,7 @@ xfs_error_trap(int e)
 			break;
 		if (e != xfs_etrap[i])
 			continue;
-		cmn_err(CE_NOTE, "xfs_error_trap: error %d", e);
+		xfs_notice(NULL, "%s: error %d", __func__, e);
 		BUG();
 		break;
 	}
@@ -74,7 +74,7 @@ xfs_error_test(int error_tag, int *fsidp, char *expression,
 
 	for (i = 0; i < XFS_NUM_INJECT_ERROR; i++)  {
 		if (xfs_etest[i] == error_tag && xfs_etest_fsid[i] == fsid) {
-			cmn_err(CE_WARN,
+			xfs_warn(NULL,
 	"Injecting error (%s) at file %s, line %d, on filesystem \"%s\"",
 				expression, file, line, xfs_etest_fsname[i]);
 			return 1;
@@ -95,14 +95,14 @@ xfs_errortag_add(int error_tag, xfs_mount_t *mp)
 
 	for (i = 0; i < XFS_NUM_INJECT_ERROR; i++)  {
 		if (xfs_etest_fsid[i] == fsid && xfs_etest[i] == error_tag) {
-			cmn_err(CE_WARN, "XFS error tag #%d on", error_tag);
+			xfs_warn(mp, "error tag #%d on", error_tag);
 			return 0;
 		}
 	}
 
 	for (i = 0; i < XFS_NUM_INJECT_ERROR; i++)  {
 		if (xfs_etest[i] == 0) {
-			cmn_err(CE_WARN, "Turned on XFS error tag #%d",
+			xfs_warn(mp, "Turned on XFS error tag #%d",
 				error_tag);
 			xfs_etest[i] = error_tag;
 			xfs_etest_fsid[i] = fsid;
@@ -114,7 +114,7 @@ xfs_errortag_add(int error_tag, xfs_mount_t *mp)
 		}
 	}
 
-	cmn_err(CE_WARN, "error tag overflow, too many turned on");
+	xfs_warn(mp, "error tag overflow, too many turned on");
 
 	return 1;
 }
@@ -133,7 +133,7 @@ xfs_errortag_clearall(xfs_mount_t *mp, int loud)
 		if ((fsid == 0LL || xfs_etest_fsid[i] == fsid) &&
 		     xfs_etest[i] != 0) {
 			cleared = 1;
-			cmn_err(CE_WARN, "Clearing XFS error tag #%d",
+			xfs_warn(mp, "Clearing XFS error tag #%d",
 				xfs_etest[i]);
 			xfs_etest[i] = 0;
 			xfs_etest_fsid[i] = 0LL;
@@ -144,9 +144,7 @@ xfs_errortag_clearall(xfs_mount_t *mp, int loud)
 	}
 
 	if (loud || cleared)
-		cmn_err(CE_WARN,
-			"Cleared all XFS error tags for filesystem \"%s\"",
-			mp->m_fsname);
+		xfs_warn(mp, "Cleared all XFS error tags for filesystem");
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index fc3a2cb..84ebeec 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1055,28 +1055,23 @@ xfs_difree(
 	 */
 	agno = XFS_INO_TO_AGNO(mp, inode);
 	if (agno >= mp->m_sb.sb_agcount)  {
-		cmn_err(CE_WARN,
-			"xfs_difree: agno >= mp->m_sb.sb_agcount (%d >= %d) on %s.  Returning EINVAL.",
-			agno, mp->m_sb.sb_agcount, mp->m_fsname);
+		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
+			__func__, agno, mp->m_sb.sb_agcount);
 		ASSERT(0);
 		return XFS_ERROR(EINVAL);
 	}
 	agino = XFS_INO_TO_AGINO(mp, inode);
 	if (inode != XFS_AGINO_TO_INO(mp, agno, agino))  {
-		cmn_err(CE_WARN,
-			"xfs_difree: inode != XFS_AGINO_TO_INO() "
-			"(%llu != %llu) on %s.  Returning EINVAL.",
-			(unsigned long long)inode,
-			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino),
-			mp->m_fsname);
+		xfs_warn(mp, "%s: inode != XFS_AGINO_TO_INO() (%llu != %llu).",
+			__func__, (unsigned long long)inode,
+			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino));
 		ASSERT(0);
 		return XFS_ERROR(EINVAL);
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 	if (agbno >= mp->m_sb.sb_agblocks)  {
-		cmn_err(CE_WARN,
-			"xfs_difree: agbno >= mp->m_sb.sb_agblocks (%d >= %d) on %s.  Returning EINVAL.",
-			agbno, mp->m_sb.sb_agblocks, mp->m_fsname);
+		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
+			__func__, agbno, mp->m_sb.sb_agblocks);
 		ASSERT(0);
 		return XFS_ERROR(EINVAL);
 	}
@@ -1085,9 +1080,8 @@ xfs_difree(
 	 */
 	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
 	if (error) {
-		cmn_err(CE_WARN,
-			"xfs_difree: xfs_ialloc_read_agi() returned an error %d on %s.  Returning error.",
-			error, mp->m_fsname);
+		xfs_warn(mp, "%s: xfs_ialloc_read_agi() returned error %d.",
+			__func__, error);
 		return error;
 	}
 	agi = XFS_BUF_TO_AGI(agbp);
@@ -1106,17 +1100,15 @@ xfs_difree(
 	 * Look for the entry describing this inode.
 	 */
 	if ((error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i))) {
-		cmn_err(CE_WARN,
-			"xfs_difree: xfs_inobt_lookup returned()  an error %d on %s.  Returning error.",
-			error, mp->m_fsname);
+		xfs_warn(mp, "%s: xfs_inobt_lookup() returned error %d.",
+			__func__, error);
 		goto error0;
 	}
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error) {
-		cmn_err(CE_WARN,
-			"xfs_difree: xfs_inobt_get_rec()  returned an error %d on %s.  Returning error.",
-			error, mp->m_fsname);
+		xfs_warn(mp, "%s: xfs_inobt_get_rec() returned error %d.",
+			__func__, error);
 		goto error0;
 	}
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
@@ -1157,8 +1149,8 @@ xfs_difree(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
 		if ((error = xfs_btree_delete(cur, &i))) {
-			cmn_err(CE_WARN, "xfs_difree: xfs_btree_delete returned an error %d on %s.\n",
-				error, mp->m_fsname);
+			xfs_warn(mp, "%s: xfs_btree_delete returned error %d.",
+				__func__, error);
 			goto error0;
 		}
 
@@ -1170,9 +1162,8 @@ xfs_difree(
 
 		error = xfs_inobt_update(cur, &rec);
 		if (error) {
-			cmn_err(CE_WARN,
-	"xfs_difree: xfs_inobt_update returned an error %d on %s.",
-				error, mp->m_fsname);
+			xfs_warn(mp, "%s: xfs_inobt_update returned error %d.",
+				__func__, error);
 			goto error0;
 		}
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 60f2dd5..6b3424b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -142,10 +142,9 @@ xfs_imap_to_bp(
 				   (int)imap->im_len, buf_flags, &bp);
 	if (error) {
 		if (error != EAGAIN) {
-			cmn_err(CE_WARN,
-				"xfs_imap_to_bp: xfs_trans_read_buf()returned "
-				"an error %d on %s.  Returning error.",
-				error, mp->m_fsname);
+			xfs_warn(mp,
+				"%s: xfs_trans_read_buf() returned error %d.",
+				__func__, error);
 		} else {
 			ASSERT(buf_flags & XBF_TRYLOCK);
 		}
@@ -180,12 +179,11 @@ xfs_imap_to_bp(
 			XFS_CORRUPTION_ERROR("xfs_imap_to_bp",
 						XFS_ERRLEVEL_HIGH, mp, dip);
 #ifdef DEBUG
-			cmn_err(CE_PANIC,
-					"Device %s - bad inode magic/vsn "
-					"daddr %lld #%d (magic=%x)",
-				XFS_BUFTARG_NAME(mp->m_ddev_targp),
+			xfs_emerg(mp,
+				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
 				(unsigned long long)imap->im_blkno, i,
 				be16_to_cpu(dip->di_magic));
+			ASSERT(0);
 #endif
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EFSCORRUPTED);
@@ -1810,9 +1808,8 @@ xfs_iunlink_remove(
 		 */
 		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XBF_LOCK);
 		if (error) {
-			cmn_err(CE_WARN,
-				"xfs_iunlink_remove: xfs_itobp()  returned an error %d on %s.  Returning error.",
-				error, mp->m_fsname);
+			xfs_warn(mp, "%s: xfs_itobp() returned error %d.",
+				__func__, error);
 			return error;
 		}
 		next_agino = be32_to_cpu(dip->di_next_unlinked);
@@ -1857,9 +1854,9 @@ xfs_iunlink_remove(
 			error = xfs_inotobp(mp, tp, next_ino, &last_dip,
 					    &last_ibp, &last_offset, 0);
 			if (error) {
-				cmn_err(CE_WARN,
-			"xfs_iunlink_remove: xfs_inotobp()  returned an error %d on %s.  Returning error.",
-					error, mp->m_fsname);
+				xfs_warn(mp,
+					"%s: xfs_inotobp() returned error %d.",
+					__func__, error);
 				return error;
 			}
 			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
@@ -1872,9 +1869,8 @@ xfs_iunlink_remove(
 		 */
 		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XBF_LOCK);
 		if (error) {
-			cmn_err(CE_WARN,
-				"xfs_iunlink_remove: xfs_itobp()  returned an error %d on %s.  Returning error.",
-				error, mp->m_fsname);
+			xfs_warn(mp, "%s: xfs_itobp(2) returned error %d.",
+				__func__, error);
 			return error;
 		}
 		next_agino = be32_to_cpu(dip->di_next_unlinked);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e39b082..bb3f9a7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -133,9 +133,7 @@ xfs_uuid_mount(
 		return 0;
 
 	if (uuid_is_nil(uuid)) {
-		cmn_err(CE_WARN,
-			"XFS: Filesystem %s has nil UUID - can't mount",
-			mp->m_fsname);
+		xfs_warn(mp, "Filesystem has nil UUID - can't mount");
 		return XFS_ERROR(EINVAL);
 	}
 
@@ -163,8 +161,7 @@ xfs_uuid_mount(
 
  out_duplicate:
 	mutex_unlock(&xfs_uuid_table_mutex);
-	cmn_err(CE_WARN, "XFS: Filesystem %s has duplicate UUID - can't mount",
-			 mp->m_fsname);
+	xfs_warn(mp, "Filesystem has duplicate UUID - can't mount");
 	return XFS_ERROR(EINVAL);
 }
 
@@ -867,8 +864,7 @@ xfs_update_alignment(xfs_mount_t *mp)
 		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
 		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
 			if (mp->m_flags & XFS_MOUNT_RETERR) {
-				cmn_err(CE_WARN,
-					"XFS: alignment check 1 failed");
+				xfs_warn(mp, "alignment check 1 failed");
 				return XFS_ERROR(EINVAL);
 			}
 			mp->m_dalign = mp->m_swidth = 0;
@@ -1041,14 +1037,14 @@ xfs_check_sizes(xfs_mount_t *mp)
 
 	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
-		cmn_err(CE_WARN, "XFS: filesystem size mismatch detected");
+		xfs_warn(mp, "filesystem size mismatch detected");
 		return XFS_ERROR(EFBIG);
 	}
 	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
 					d - XFS_FSS_TO_BB(mp, 1),
 					BBTOB(XFS_FSS_TO_BB(mp, 1)), 0);
 	if (!bp) {
-		cmn_err(CE_WARN, "XFS: last sector read failed");
+		xfs_warn(mp, "last sector read failed");
 		return EIO;
 	}
 	xfs_buf_relse(bp);
@@ -1056,14 +1052,14 @@ xfs_check_sizes(xfs_mount_t *mp)
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
-			cmn_err(CE_WARN, "XFS: log size mismatch detected");
+			xfs_warn(mp, "log size mismatch detected");
 			return XFS_ERROR(EFBIG);
 		}
 		bp = xfs_buf_read_uncached(mp, mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
 					XFS_FSB_TO_B(mp, 1), 0);
 		if (!bp) {
-			cmn_err(CE_WARN, "XFS: log device read failed");
+			xfs_warn(mp, "log device read failed");
 			return EIO;
 		}
 		xfs_buf_relse(bp);
@@ -1175,8 +1171,7 @@ xfs_mountfs(
 	 * transaction subsystem is online.
 	 */
 	if (xfs_sb_has_mismatched_features2(sbp)) {
-		cmn_err(CE_WARN,
-			"XFS: correcting sb_features alignment problem");
+		xfs_warn(mp, "correcting sb_features alignment problem");
 		sbp->sb_features2 |= sbp->sb_bad_features2;
 		sbp->sb_bad_features2 = sbp->sb_features2;
 		mp->m_update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
@@ -1255,7 +1250,7 @@ xfs_mountfs(
 	 */
 	error = xfs_rtmount_init(mp);
 	if (error) {
-		cmn_err(CE_WARN, "XFS: RT mount failed");
+		xfs_warn(mp, "RT mount failed");
 		goto out_remove_uuid;
 	}
 
@@ -1286,12 +1281,12 @@ xfs_mountfs(
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
 	if (error) {
-		cmn_err(CE_WARN, "XFS: Failed per-ag init: %d", error);
+		xfs_warn(mp, "Failed per-ag init: %d", error);
 		goto out_remove_uuid;
 	}
 
 	if (!sbp->sb_logblocks) {
-		cmn_err(CE_WARN, "XFS: no log defined");
+		xfs_warn(mp, "no log defined");
 		XFS_ERROR_REPORT("xfs_mountfs", XFS_ERRLEVEL_LOW, mp);
 		error = XFS_ERROR(EFSCORRUPTED);
 		goto out_free_perag;
@@ -1304,7 +1299,7 @@ xfs_mountfs(
 			      XFS_FSB_TO_DADDR(mp, sbp->sb_logstart),
 			      XFS_FSB_TO_BB(mp, sbp->sb_logblocks));
 	if (error) {
-		cmn_err(CE_WARN, "XFS: log mount failed");
+		xfs_warn(mp, "log mount failed");
 		goto out_free_perag;
 	}
 
@@ -1341,16 +1336,14 @@ xfs_mountfs(
 	 */
 	error = xfs_iget(mp, NULL, sbp->sb_rootino, 0, XFS_ILOCK_EXCL, &rip);
 	if (error) {
-		cmn_err(CE_WARN, "XFS: failed to read root inode");
+		xfs_warn(mp, "failed to read root inode");
 		goto out_log_dealloc;
 	}
 
 	ASSERT(rip != NULL);
 
 	if (unlikely((rip->i_d.di_mode & S_IFMT) != S_IFDIR)) {
-		cmn_err(CE_WARN, "XFS: corrupted root inode");
-		cmn_err(CE_WARN, "Device %s - root %llu is not a directory",
-			XFS_BUFTARG_NAME(mp->m_ddev_targp),
+		xfs_warn(mp, "corrupted root inode %llu: not a directory",
 			(unsigned long long)rip->i_ino);
 		xfs_iunlock(rip, XFS_ILOCK_EXCL);
 		XFS_ERROR_REPORT("xfs_mountfs_int(2)", XFS_ERRLEVEL_LOW,
@@ -1370,7 +1363,7 @@ xfs_mountfs(
 		/*
 		 * Free up the root inode.
 		 */
-		cmn_err(CE_WARN, "XFS: failed to read RT inodes");
+		xfs_warn(mp, "failed to read RT inodes");
 		goto out_rele_rip;
 	}
 
@@ -1382,7 +1375,7 @@ xfs_mountfs(
 	if (mp->m_update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		error = xfs_mount_log_sb(mp, mp->m_update_flags);
 		if (error) {
-			cmn_err(CE_WARN, "XFS: failed to write sb changes");
+			xfs_warn(mp, "failed to write sb changes");
 			goto out_rtunmount;
 		}
 	}
@@ -1403,10 +1396,7 @@ xfs_mountfs(
 		 * quotachecked license.
 		 */
 		if (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_ACCT) {
-			cmn_err(CE_NOTE,
-				"XFS: resetting qflags for filesystem %s",
-				mp->m_fsname);
-
+			xfs_notice(mp, "resetting quota flags");
 			error = xfs_mount_reset_sbqflags(mp);
 			if (error)
 				return error;
@@ -1420,7 +1410,7 @@ xfs_mountfs(
 	 */
 	error = xfs_log_mount_finish(mp);
 	if (error) {
-		cmn_err(CE_WARN, "XFS: log mount finish failed");
+		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;
 	}
 
@@ -1449,8 +1439,8 @@ xfs_mountfs(
 		resblks = xfs_default_resblks(mp);
 		error = xfs_reserve_blocks(mp, &resblks, NULL);
 		if (error)
-			cmn_err(CE_WARN, "XFS: Unable to allocate reserve "
-				"blocks. Continuing without a reserve pool.");
+			xfs_warn(mp,
+	"Unable to allocate reserve blocks. Continuing without reserve pool.");
 	}
 
 	return 0;
@@ -1539,12 +1529,12 @@ xfs_unmountfs(
 	resblks = 0;
 	error = xfs_reserve_blocks(mp, &resblks, NULL);
 	if (error)
-		cmn_err(CE_WARN, "XFS: Unable to free reserved block pool. "
+		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
 
 	error = xfs_log_sbcount(mp, 1);
 	if (error)
-		cmn_err(CE_WARN, "XFS: Unable to update superblock counters. "
+		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
 	xfs_unmountfs_writesb(mp);
 	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
@@ -2027,10 +2017,8 @@ xfs_dev_is_read_only(
 	if (xfs_readonly_buftarg(mp->m_ddev_targp) ||
 	    xfs_readonly_buftarg(mp->m_logdev_targp) ||
 	    (mp->m_rtdev_targp && xfs_readonly_buftarg(mp->m_rtdev_targp))) {
-		cmn_err(CE_NOTE,
-			"XFS: %s required on read-only device.", message);
-		cmn_err(CE_NOTE,
-			"XFS: write access unavailable, cannot proceed.");
+		xfs_notice(mp, "%s required on read-only device.", message);
+		xfs_notice(mp, "write access unavailable, cannot proceed.");
 		return EROFS;
 	}
 	return 0;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 12a1913..7cf9bbb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2222,8 +2222,8 @@ xfs_rtmount_init(
 	if (sbp->sb_rblocks == 0)
 		return 0;
 	if (mp->m_rtdev_targp == NULL) {
-		cmn_err(CE_WARN,
-	"XFS: This filesystem has a realtime volume, use rtdev=device option");
+		xfs_warn(mp,
+	"Filesystem has a realtime volume, use rtdev=device option");
 		return XFS_ERROR(ENODEV);
 	}
 	mp->m_rsumlevels = sbp->sb_rextslog + 1;
@@ -2237,7 +2237,7 @@ xfs_rtmount_init(
 	 */
 	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_rblocks) {
-		cmn_err(CE_WARN, "XFS: realtime mount -- %llu != %llu",
+		xfs_warn(mp, "realtime mount -- %llu != %llu",
 			(unsigned long long) XFS_BB_TO_FSB(mp, d),
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return XFS_ERROR(EFBIG);
@@ -2246,7 +2246,7 @@ xfs_rtmount_init(
 					d - XFS_FSB_TO_BB(mp, 1),
 					XFS_FSB_TO_B(mp, 1), 0);
 	if (!bp) {
-		cmn_err(CE_WARN, "XFS: realtime device size check failed");
+		xfs_warn(mp, "realtime device size check failed");
 		return EIO;
 	}
 	xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index ff614c2..09e1f4f 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -154,7 +154,7 @@ xfs_rtmount_init(
 	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 
-	cmn_err(CE_WARN, "XFS: Not built with CONFIG_XFS_RT");
+	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
 	return ENOSYS;
 }
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index c3ef00d..e587401 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -49,9 +49,9 @@ xfs_do_force_shutdown(
 	logerror = flags & SHUTDOWN_LOG_IO_ERROR;
 
 	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
-		cmn_err(CE_NOTE, "xfs_force_shutdown(%s,0x%x) called from "
-				 "line %d of file %s.  Return address = 0x%p",
-			mp->m_fsname, flags, lnnum, fname, __return_address);
+		xfs_notice(mp,
+	"%s(0x%x) called from line %d of file %s.  Return address = 0x%p",
+			__func__, flags, lnnum, fname, __return_address);
 	}
 	/*
 	 * No need to duplicate efforts.
@@ -86,8 +86,8 @@ xfs_do_force_shutdown(
 		}
 	}
 	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
-		cmn_err(CE_ALERT, "Please umount the filesystem, "
-				  "and rectify the problem(s)");
+		xfs_alert(mp,
+	"Please umount the filesystem and rectify the problem(s)");
 	}
 }
 
@@ -101,10 +101,9 @@ xfs_ioerror_alert(
 	xfs_buf_t		*bp,
 	xfs_daddr_t		blkno)
 {
-	cmn_err(CE_ALERT,
- "I/O error in filesystem (\"%s\") meta-data dev %s block 0x%llx"
- "       (\"%s\") error %d buf count %zd",
-		(!mp || !mp->m_fsname) ? "(fs name not set)" : mp->m_fsname,
+	xfs_alert(mp,
+		 "I/O error occurred: meta-data dev %s block 0x%llx"
+		 "       (\"%s\") error %d buf count %zd",
 		XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
 		(__uint64_t)blkno, func,
 		XFS_BUF_GETERROR(bp), XFS_BUF_COUNT(bp));
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index c47918c..3bea661 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -305,7 +305,7 @@ xfs_trans_read_buf(
 			if (xfs_error_target == target) {
 				if (((xfs_req_num++) % xfs_error_mod) == 0) {
 					xfs_buf_relse(bp);
-					cmn_err(CE_DEBUG, "Returning error!\n");
+					xfs_debug(mp, "Returning error!");
 					return XFS_ERROR(EIO);
 				}
 			}
@@ -403,7 +403,7 @@ xfs_trans_read_buf(
 				xfs_force_shutdown(tp->t_mountp,
 						   SHUTDOWN_META_IO_ERROR);
 				xfs_buf_relse(bp);
-				cmn_err(CE_DEBUG, "Returning trans error!\n");
+				xfs_debug(mp, "Returning trans error!");
 				return XFS_ERROR(EIO);
 			}
 		}
@@ -427,7 +427,7 @@ shutdown_abort:
 	 */
 #if defined(DEBUG)
 	if (XFS_BUF_ISSTALE(bp) && XFS_BUF_ISDELAYWRITE(bp))
-		cmn_err(CE_NOTE, "about to pop assert, bp == 0x%p", bp);
+		xfs_notice(mp, "about to pop assert, bp == 0x%p", bp);
 #endif
 	ASSERT((XFS_BUF_BFLAGS(bp) & (XBF_STALE|XBF_DELWRI)) !=
 				     (XBF_STALE|XBF_DELWRI));
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index d34533d..6848b2f 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1189,9 +1189,8 @@ xfs_inactive(
 		 * inode might be lost for a long time or forever.
 		 */
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
-			cmn_err(CE_NOTE,
-		"xfs_inactive:	xfs_ifree() returned an error = %d on %s",
-				error, mp->m_fsname);
+			xfs_notice(mp, "%s: xfs_ifree returned error %d",
+				__func__, error);
 			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 		}
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
