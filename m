Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6j1MM067555 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:45:01 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Agpr6HQxsuSzqe7d (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:47:06 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6l5ZT004581
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:47:06 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6l4mC020820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:47:05 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6l4e8011665 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:47:04 -0600
Message-ID: <50A5E163.2080006@oracle.com>
Date: Fri, 16 Nov 2012 14:46:59 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 14/15] xfs: Add shrink data ioctl(2)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

So the real FS data section shrink function via ioctl(2) is here.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_fs.h    |    8 ++
 fs/xfs/xfs_fsops.c |  212 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fsops.h |    1 +
 fs/xfs/xfs_ioctl.c |   15 ++++
 4 files changed, 234 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index c459d52..3a85979 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -272,6 +272,13 @@ typedef struct xfs_growfs_rt {
 	__u32		extsize;	/* new realtime extent size, fsblocks */
 } xfs_growfs_rt_t;
 
+/*
+ * Structure for XFS_IOC_SHRINKFS_DATA.
+ */
+typedef struct xfs_shrinkfs_data {
+	__u64		newblocks;	/* new data subvol size, fsblocks */
+	__u32		imaxpct;	/* new inode space percentage limit */
+} xfs_shrinkfs_data_t;
 
 /*
  * Structures returned from ioctl XFS_IOC_FSBULKSTAT & XFS_IOC_FSBULKSTAT_SINGLE
@@ -489,6 +496,7 @@ typedef struct xfs_handle {
 #define XFS_IOC_SET_AGSTATE	     _IOW('X', 126, struct xfs_ioc_agstate)
 #define XFS_IOC_GET_AGSTATE	     _IOR('X', 127, struct xfs_ioc_agstate)
 #define XFS_IOC_SWAPINO		     _IOWR('X', 128, struct xfs_swapino)
+#define XFS_IOC_FSSHRINKFS_DATA	     _IOW('X', 129, struct xfs_shrinkfs_data)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 04a21d1..e5aa564 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -579,8 +579,6 @@ xfs_growfs_log_private(
  * point - exported through ioctls: XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG,
  * XFS_IOC_FSGROWFSRT
  */
-
-
 int
 xfs_growfs_data(
 	xfs_mount_t		*mp,
@@ -948,6 +946,216 @@ error0:
 	return error;
 }
 
+static int
+xfs_shrinkfs_process_ag(
+	xfs_mount_t		*mp,
+	xfs_trans_t		*tp,
+	xfs_agnumber_t		agno,
+	xfs_rfsblock_t		tsize,
+	xfs_extlen_t		*nfree)
+{
+	xfs_perag_t		*pag;
+	bool			empty;
+	int			error;
+
+	/*
+	 * The a.g. state must has already been set to offline
+	 * by xfs_shrinkfs(8).
+	 */
+	pag = xfs_perag_get(mp, agno);
+	if (!(pag->pag_state & XFS_AG_STATE_ALLOC_DENY)) {
+		xfs_perag_put(pag);
+		return XFS_ERROR(EINVAL);
+	}
+	xfs_perag_put(pag);
+
+	error = xfs_ag_is_empty(mp, agno, &empty);
+	if (error)
+		goto error0;
+
+	if (!empty)
+		error = xfs_truncate_ag(mp, agno, tsize, nfree);
+	else {
+		/*
+		 * The Primary AG must not be empty except at the
+		 * invitial phase(mkfs.xfs).  But we should not
+		 * remove it anyway.
+		 */
+		if (agno == 0) {
+			error = XFS_ERROR(EINVAL);
+			goto error0;
+		}
+		error = xfs_remove_empty_ag(mp, agno, nfree);
+	}
+
+error0:
+	if (error)
+		*nfree = 0;
+
+	return error;
+}
+
+static int
+xfs_shrinkfs_data_private(
+	xfs_mount_t		*mp,
+	xfs_shrinkfs_data_t	*in)
+{
+	xfs_agnumber_t		oagcount; /* old AG count */
+	xfs_agnumber_t		nagcount; /* new AG count */
+	xfs_agnumber_t		agno;
+	xfs_rfsblock_t		nb, nb_mod;
+	xfs_rfsblock_t		new;
+	xfs_rfsblock_t		tsize;
+	xfs_rfsblock_t		nfree;
+	xfs_trans_t		*tp;
+	int			pct;
+	int			dpct;
+	int			error;
+
+	new = nb = in->newblocks;
+	pct = in->imaxpct;
+
+	if (new > mp->m_sb.sb_dblocks)
+		return XFS_ERROR(EINVAL);
+	if (new == mp->m_sb.sb_dblocks)
+		return 0;
+	if (pct < 0 || pct > 100)
+		return XFS_ERROR(EINVAL);
+
+	tsize = mp->m_sb.sb_dblocks - new;
+
+	/*
+	 * If the filesystem has internal logs, cannot shrink beyond the
+	 * end block of the log area for now.
+	 */
+	if (mp->m_sb.sb_logstart > 0 &&
+	    new < mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks)
+		return XFS_ERROR(EINVAL);
+
+	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
+	nagcount = new + (nb_mod != 0);
+	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
+		nagcount--;
+		nb_mod = 0;
+		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
+	}
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SHRINKFS);
+	tp->t_flags |= XFS_TRANS_RESERVE;
+	error = xfs_trans_reserve(tp, XFS_SHRINKFS_SPACE_RES(mp),
+				  XFS_SHRINKDATA_LOG_RES(mp),
+				  0, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto out;
+	}
+
+	oagcount = mp->m_sb.sb_agcount;
+	nfree = 0;
+	for (agno = nagcount - 1; agno < oagcount; agno++) {
+		xfs_extlen_t		freed;
+
+		error = xfs_shrinkfs_process_ag(mp, tp, agno, tsize, &freed);
+		if (error)
+			goto out_trans_cancel;
+		nfree += freed;
+		tsize -= freed;
+	}
+
+	xfs_trans_agblocks_delta(tp, -nfree);
+
+	/*
+	 * Update superblock to reflect current agcount if possbile.
+	 */
+	if (nagcount < oagcount)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
+
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, -nfree);
+
+	/*
+	 * Update superblock to reflect current data blocks.
+	 */
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, -nfree);
+	dpct = pct - mp->m_sb.sb_imax_pct;
+	if (dpct)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
+	error = xfs_trans_commit(tp, 0);
+	if (error)
+		goto out;
+
+	/* FIXME: iterate perag to find out the maximum agi */
+	if (mp->m_maxagi > nagcount)
+		mp->m_maxagi = nagcount;
+	if (!mp->m_sb.sb_imax_pct)
+		mp->m_maxicount = 0;
+	else {
+		__uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
+		do_div(icount, 100);
+		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
+	}
+	xfs_set_low_space_thresholds(mp);
+
+	/*
+	 * Update secondary superblocks.
+	 */
+	for (agno = 1; agno < nagcount; agno++) {
+		xfs_buf_t	*bp = NULL;
+
+		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+				XFS_FSS_TO_BB(mp, 1), 0, &bp);
+		if (error) {
+			xfs_warn(mp,
+		"error %d reading secondary superblock for ag %d",
+				error, agno);
+			break;
+		}
+
+		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
+		/*
+		 * If we get an error writing out the alternate superblocks,
+		 * just issue a warning and continue.  The real work is
+		 * already done and committed.
+		 */
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error) {
+			xfs_warn(mp,
+		"write error %d updating secondary superblock for ag %d",
+				error, agno);
+			break; /* no point in continuing */
+		}
+	}
+
+out:
+	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	return error;
+}
+
+/*
+ * Interface of shrinking file system data section via ioctl(2).
+ */
+int
+xfs_shrinkfs_data(
+	xfs_mount_t		*mp,
+	xfs_shrinkfs_data_t	*in)
+{
+	int error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return XFS_ERROR(EPERM);
+
+	if (!mutex_trylock(&mp->m_shrinklock))
+		return XFS_ERROR(EWOULDBLOCK);
+	error = xfs_shrinkfs_data_private(mp, in);
+	mutex_unlock(&mp->m_shrinklock);
+
+	return error;
+}
+
 /*
  * exported through ioctl XFS_IOC_FSCOUNTS
  */
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 1b6a98b..40be112 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -26,5 +26,6 @@ extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
 extern int xfs_fs_log_dummy(struct xfs_mount *mp);
+extern int xfs_shrinkfs_data(xfs_mount_t *mp, xfs_shrinkfs_data_t *in);
 
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0e0c03f..41b2900 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1649,6 +1649,21 @@ xfs_file_ioctl(
 		return -error;
 	}
 
+	case XFS_IOC_FSSHRINKFS_DATA: {
+		xfs_shrinkfs_data_t	in;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
+
+		error = xfs_shrinkfs_data(mp, &in);
+		mnt_drop_write_file(filp);
+		return -error;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
