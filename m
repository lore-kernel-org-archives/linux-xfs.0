Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8776E7F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 08:41:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76161304039
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 06:41:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id msvLTKJxKjlp2xCS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 06:41:30 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t23EfTnK003027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 3 Mar 2015 09:41:29 -0500
Received: from hades.maiolino.org.com (ovpn-112-62.phx2.redhat.com
	[10.3.112.62])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t23EfQcg026615
	for <xfs@oss.sgi.com>; Tue, 3 Mar 2015 09:41:27 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] [RFC] Implement XFS_IOC_FSBULKSTAT_RANGE ioctl
Date: Tue,  3 Mar 2015 11:41:18 -0300
Message-Id: <1425393678-4550-1-git-send-email-cmaiolino@redhat.com>
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

This patch aims to implement a ranged bulkstat ioctl, which will make users able
to bulkstat inodes in a filesystem based on range instead on rely only in a
whole filesystem bulkstat.

This first implementation add a per AG bulkstat possibility, but it also adds
the necessary infrastructure to implement different kinds of ranged bulkstat,
like per block.

The patch is already working and I've been testing it for a while, so, I think
it's time to send this patch out and ask for comments on it.

The core of the implementation is very similar with what xfs_bulsktat() does by
now, which, instead bulkstat the whole filesystem, it start/stop on the
specified range.

As per Dave's suggesting, I added to  rgbulkreq structure (used to pass data
to/from userland), a padding, so we can use the same structure for another kind
of ranged bulkstats without the need to actually change the structure size.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h |  12 +++
 fs/xfs/xfs_ioctl.c     |  56 +++++++++++++
 fs/xfs/xfs_itable.c    | 210 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_itable.h    |  16 ++++
 4 files changed, 294 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 18dc721..88665aa 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -334,6 +334,17 @@ typedef struct xfs_fsop_bulkreq {
 	__s32		__user *ocount;	/* output count pointer		*/
 } xfs_fsop_bulkreq_t;
 
+typedef struct xfs_fsop_rgbulkreq {
+	__u64		__user *lastip; /* last inode # pointer		*/
+	__s32		icount;		/* count of entries in buffer	*/
+	void		__user *ubuffer;/* user buffer for inode desc.	*/
+	__s32		__user *ocount;	/* output count pointer		*/
+	__u64		start;		/* start point of rgbulkstat	*/
+	__u64		end;		/* end point of rgbulkstat	*/
+	__u32		flags;		/* multipurpose flag field	*/
+	__u32		pad[5];		/* reserved space		*/
+} xfs_fsop_rgbulkreq_t;
+
 
 /*
  * Structures returned from xfs_inumbers routine (XFS_IOC_FSINUMBERS).
@@ -556,6 +567,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_FSBULKSTAT_RANGE     _IOWR('X', 126, struct xfs_fsop_rgbulkreq)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f7afb86..34a4de5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -790,6 +790,59 @@ xfs_ioc_bulkstat(
 }
 
 STATIC int
+xfs_ioc_bulkstat_range(
+	xfs_mount_t		*mp,
+	unsigned int		cmd,
+	void			__user *arg)
+{
+
+	xfs_fsop_rgbulkreq_t	rgbulkreq;
+	int			count;	/* # of records returned */
+	xfs_ino_t		inlast; /* last inode number */
+	int			done;
+	int			error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	/* We do not support another ranged calls yet */
+	if (cmd != XFS_IOC_FSBULKSTAT_RANGE)
+		return -EINVAL;
+
+	if (copy_from_user(&rgbulkreq, arg, sizeof(xfs_fsop_rgbulkreq_t)))
+		return -EFAULT;
+
+	if (copy_from_user(&inlast, rgbulkreq.lastip, sizeof(__s64)))
+		return -EFAULT;
+
+	if ((count = rgbulkreq.icount) <= 0)
+		return -EINVAL;
+
+	if (rgbulkreq.ubuffer == NULL)
+		return -EINVAL;
+
+	error = xfs_bulkstat_range(mp, &inlast, &count, xfs_bulkstat_one,
+				   sizeof(xfs_bstat_t), rgbulkreq.ubuffer,
+				   rgbulkreq.start, rgbulkreq.end, &done);
+
+	if (error)
+		return error;
+
+	if (rgbulkreq.ocount != NULL) {
+		if (copy_to_user(rgbulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
+			return -EFAULT;
+
+		if (copy_to_user(rgbulkreq.ocount, &count, sizeof(count)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+STATIC int
 xfs_ioc_fsgeometry_v1(
 	xfs_mount_t		*mp,
 	void			__user *arg)
@@ -1555,6 +1608,9 @@ xfs_file_ioctl(
 	case XFS_IOC_FSINUMBERS:
 		return xfs_ioc_bulkstat(mp, cmd, arg);
 
+	case XFS_IOC_FSBULKSTAT_RANGE:
+		return xfs_ioc_bulkstat_range(mp, cmd, arg);
+
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry_v1(mp, arg);
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 82e3142..d6b27ee 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -530,6 +530,216 @@ del_cursor:
 	return error;
 }
 
+/*
+ * Return stat information in bulk (by-inode) for specified
+ * filesystem range.
+ */
+int
+xfs_bulkstat_range(
+	xfs_mount_t		*mp,	/* mount point for filesystem */
+	xfs_ino_t		*lastinop, /* last inode returned */
+	int			*ubcountp, /* size of buffer/count returned */
+	bulkstat_one_pf		formatter, /* func that'd fill a single buf */
+	size_t			statstruct_size, /* sizeof struct filling */
+	char			__user *ubuffer, /* buffer with inode stats */
+	__u64			start,	/* start bulkstat here */
+	__u64			end,	/* end bulkstat here */
+	int			*done) /* 1 if there are more stats to get */
+{
+	xfs_buf_t		*agbp;	/* agi header buffer */
+	xfs_agino_t		agino;	/* inode # in allocation group */
+	xfs_agnumber_t		agno;	/* allocation group number */
+	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
+	size_t			irbsize; /* size of irec buffer in bytes */
+	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
+	int			nirbuf;	/* size of irbuf */
+	int			ubcount; /* size of user's buffer */
+	struct xfs_bulkstat_agichunk ac;
+	int			error = 0;
+
+	/*
+	 * Get the last inode value, see if there is nothing to do.
+	 */
+	if (*lastinop != 0)
+		agno = XFS_INO_TO_AGNO(mp, *lastinop);
+	else
+		agno = start;
+
+	agino = XFS_INO_TO_AGINO(mp, *lastinop);
+
+	/*
+	 * If specified end is bigger than mp->m_sb.sb_agount, should we
+	 * gracefully interpret as if there is nothing to do, or trigger
+	 * an error?
+	 */
+	if (agno >= mp->m_sb.sb_agcount) {
+		*done = 1;
+		*ubcountp = 0;
+		return 0;
+	}
+
+	ubcount = *ubcountp;
+	ac.ac_ubuffer = &ubuffer;
+	ac.ac_ubleft = ubcount * statstruct_size; /* bytes */
+	ac.ac_ubelem = 0;
+
+	*ubcountp = 0;
+	*done = 0;
+
+	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
+	if (!irbuf)
+		return -ENOMEM;
+
+	nirbuf = irbsize / sizeof(*irbuf);
+
+	/*
+	 * Loop over the allocation groups, starting from the last inode
+	 * returned; - means start of the allocation group.
+	 */
+	while (agno <= end) {
+		struct xfs_inobt_rec_incore	*irbp = irbuf;
+		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
+		bool				end_of_ag = false;
+		int				icount = 0;
+		int				stat;
+
+		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
+		if (error)
+			break;
+
+		/*
+		 * Allocate and initialize a btree cursor for ialloc btree.
+		 */
+		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
+					    XFS_BTNUM_INO);
+
+		if (agino > 0) {
+			/*
+			 * In the middle of an allocation group, we need to get
+			 * the remainder of the chunk we are in.
+			 */
+			struct xfs_inobt_rec_incore	r;
+
+			error = xfs_bulkstat_grab_ichunk(cur, agino, &icount, &r);
+			if (error)
+				goto del_cursor;
+			if (icount) {
+				irbp->ir_startino = r.ir_startino;
+				irbp->ir_freecount = r.ir_freecount;
+				irbp->ir_free = r.ir_free;
+				irbp++;
+			}
+			/* Increment to the next record */
+			error = xfs_btree_increment(cur, 0, &stat);
+		} else {
+			/* Start of ag. Lookup the first inode chunk */
+			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
+		}
+		if (error || stat == 0) {
+			end_of_ag = true;
+			goto del_cursor;
+		}
+
+		/*
+		 * Loop through inode btree records in this ag,
+		 * until we run out of inodes or space in the buffer.
+		 */
+		while (irbp < irbufend && icount < ubcount) {
+			struct xfs_inobt_rec_incore	r;
+
+			error = xfs_inobt_get_rec(cur, &r, &stat);
+			if (error || stat == 0) {
+				end_of_ag = true;
+				goto del_cursor;
+			}
+
+			/*
+			 * If this chunk has any allocated inodes, save it.
+			 * Also start read-ahead now for this chunk.
+			 */
+			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
+				xfs_bulkstat_ichunk_ra(mp, agno, &r);
+				irbp->ir_startino = r.ir_startino;
+				irbp->ir_freecount = r.ir_freecount;
+				irbp->ir_free = r.ir_free;
+				irbp++;
+				icount += XFS_INODES_PER_CHUNK - r.ir_freecount;
+			}
+			error = xfs_btree_increment(cur, 0, &stat);
+			if (error || stat == 0) {
+				end_of_ag = true;
+				goto del_cursor;
+			}
+			cond_resched();
+		}
+
+	/*
+	 * Drop the btree buffers and the agi buffer as we can't hold any of the
+	 * locks these represent when calling iget. If there is a pending error,
+	 * then we are done.
+	 */
+del_cursor:
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		xfs_buf_relse(agbp);
+		if (error)
+			break;
+		/*
+		 * Now format all the good inodes into the user's buffer. The
+		 * call to xfs_bulkstat_ag_ichunk() sets up the agino pointer
+		 * for the next loop iteration.
+		 */
+		irbufend = irbp;
+		for (irbp = irbuf;
+		     irbp < irbufend && ac.ac_ubleft >= statstruct_size;
+		     irbp++) {
+			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp, formatter,
+						statstruct_size, &ac, &agino);
+			if (error)
+				break;
+
+			cond_resched();
+		}
+
+		/*
+		 * If we have run out of space or had a formatting error, we
+		 * are now done
+		 */
+		if (ac.ac_ubleft < statstruct_size || error)
+			break;
+
+		if (end_of_ag) {
+			agno++;
+			agino = 0;
+		}
+	}
+	/*
+	 * Done, we are either out of specified inode range or space to
+	 * put the data.
+	 */
+	kmem_free(irbuf);
+	*ubcountp = ac.ac_ubelem;
+
+	/*
+	 * We found some inodes, so clear the error status and return them.
+	 * The lastino pointer will point directly at the inode that triggered
+	 * any error that occurred, so on the next call the error will be
+	 * triggered again and propagated to userspace as there will be no
+	 * formatted inodes in the buffer.
+	 */
+	if (ac.ac_ubelem)
+		error = 0;
+
+	/*
+	 * If we ran out of specified range, lastino will point off the end of
+	 * the file range, so, the next call will return immediately.
+	 */
+	*lastinop = XFS_AGINO_TO_INO(mp, agno, agino);
+	if (agno >= end)
+		*done = 1;
+
+	return error;
+}
+
 int
 xfs_inumbers_fmt(
 	void			__user *ubuffer, /* buffer to write to */
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 6ea8b39..f8cf724 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -50,6 +50,22 @@ xfs_bulkstat(
 	char		__user *ubuffer,/* buffer with inode stats */
 	int		*done);		/* 1 if there are more stats to get */
 
+/*
+ * Return stat information in bulk (by-inode) for the ispecified
+ * filesystem range.
+ */
+int
+xfs_bulkstat_range(
+	xfs_mount_t	*mp,		/* mount point for filesystem */
+	xfs_ino_t	*lastinop,	/* last inode returned */
+	int		*ubcountp,	/* size of buffer/count returned */
+	bulkstat_one_pf	formatter,	/* func that'd fill a single buf */
+	size_t		statstruct_size,/* sizeof struct filling */
+	char		__user *ubuffer,/* buffer with inode stats */
+	__u64		start,		/* start bulkstat here */
+	__u64		end,		/* end bulkstat here */
+	int		*done);		/* 1 if there are more stats to get */
+
 typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
 	void			__user *ubuffer, /* buffer to write to */
 	int			ubsize,		 /* remaining user buffer sz */
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
