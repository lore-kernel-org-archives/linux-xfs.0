Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33064 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfFLGs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:48:29 -0400
Subject: [PATCH 06/14] xfs: convert bulkstat to new iwalk infrastructure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:48:09 -0700
Message-ID: <156032208948.3774243.13794437416373501819.stgit@magnolia>
In-Reply-To: <156032205136.3774243.15725828509940520561.stgit@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new ibulk structure incore to help us deal with bulk inode stat
state tracking and then convert the bulkstat code to use the new iwalk
iterator.  This disentangles inode walking from bulk stat control for
simpler code and enables us to isolate the formatter functions to the
ioctl handling code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   |   70 ++++++--
 fs/xfs/xfs_ioctl.h   |    5 +
 fs/xfs/xfs_ioctl32.c |   93 ++++++-----
 fs/xfs/xfs_itable.c  |  431 ++++++++++++++++----------------------------------
 fs/xfs/xfs_itable.h  |   79 ++++-----
 5 files changed, 272 insertions(+), 406 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5ffbdcff3dba..60595e61f2a6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -14,6 +14,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
+#include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_attr.h"
@@ -721,16 +722,29 @@ xfs_ioc_space(
 	return error;
 }
 
+/* Return 0 on success or positive error */
+int
+xfs_bulkstat_one_fmt(
+	struct xfs_ibulk	*breq,
+	const struct xfs_bstat	*bstat)
+{
+	if (copy_to_user(breq->ubuffer, bstat, sizeof(*bstat)))
+		return -EFAULT;
+	return xfs_ibulk_advance(breq, sizeof(struct xfs_bstat));
+}
+
 STATIC int
 xfs_ioc_bulkstat(
 	xfs_mount_t		*mp,
 	unsigned int		cmd,
 	void			__user *arg)
 {
-	xfs_fsop_bulkreq_t	bulkreq;
-	int			count;	/* # of records returned */
-	xfs_ino_t		inlast;	/* last inode number */
-	int			done;
+	struct xfs_fsop_bulkreq	bulkreq;
+	struct xfs_ibulk	breq = {
+		.mp		= mp,
+		.ocount		= 0,
+	};
+	xfs_ino_t		lastino;
 	int			error;
 
 	/* done = 1 if there are more stats to get and if bulkstat */
@@ -745,35 +759,57 @@ xfs_ioc_bulkstat(
 	if (copy_from_user(&bulkreq, arg, sizeof(xfs_fsop_bulkreq_t)))
 		return -EFAULT;
 
-	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
+	if (copy_from_user(&lastino, bulkreq.lastip, sizeof(__s64)))
 		return -EFAULT;
 
-	if ((count = bulkreq.icount) <= 0)
+	if (bulkreq.icount <= 0)
 		return -EINVAL;
 
 	if (bulkreq.ubuffer == NULL)
 		return -EINVAL;
 
-	if (cmd == XFS_IOC_FSINUMBERS)
-		error = xfs_inumbers(mp, &inlast, &count,
+	breq.ubuffer = bulkreq.ubuffer;
+	breq.icount = bulkreq.icount;
+
+	/*
+	 * FSBULKSTAT_SINGLE expects that *lastip contains the inode number
+	 * that we want to stat.  However, FSINUMBERS and FSBULKSTAT expect
+	 * that *lastip contains either zero or the number of the last inode to
+	 * be examined by the previous call and return results starting with
+	 * the next inode after that.  The new bulk request back end functions
+	 * take the inode to start with, so we have to compute the startino
+	 * parameter from lastino to maintain correct function.  lastino == 0
+	 * is a special case because it has traditionally meant "first inode
+	 * in filesystem".
+	 */
+	if (cmd == XFS_IOC_FSINUMBERS) {
+		int	count = breq.icount;
+
+		breq.startino = lastino;
+		error = xfs_inumbers(mp, &breq.startino, &count,
 					bulkreq.ubuffer, xfs_inumbers_fmt);
-	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
-		error = xfs_bulkstat_one(mp, inlast, bulkreq.ubuffer,
-					sizeof(xfs_bstat_t), NULL, &done);
-	else	/* XFS_IOC_FSBULKSTAT */
-		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
-				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
-				     &done);
+		breq.ocount = count;
+		lastino = breq.startino;
+	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
+		breq.startino = lastino;
+		breq.icount = 1;
+		error = xfs_bulkstat_one(&breq, xfs_bulkstat_one_fmt);
+		lastino = breq.startino;
+	} else {	/* XFS_IOC_FSBULKSTAT */
+		breq.startino = lastino ? lastino + 1 : 0;
+		error = xfs_bulkstat(&breq, xfs_bulkstat_one_fmt);
+		lastino = breq.startino - 1;
+	}
 
 	if (error)
 		return error;
 
 	if (bulkreq.lastip != NULL &&
-	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
+	    copy_to_user(bulkreq.lastip, &lastino, sizeof(xfs_ino_t)))
 		return -EFAULT;
 
 	if (bulkreq.ocount != NULL &&
-	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+	    copy_to_user(bulkreq.ocount, &breq.ocount, sizeof(__s32)))
 		return -EFAULT;
 
 	return 0;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 4b17f67c888a..f32c8aadfeba 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -77,4 +77,9 @@ xfs_set_dmattrs(
 	uint			evmask,
 	uint16_t		state);
 
+struct xfs_ibulk;
+struct xfs_bstat;
+
+int xfs_bulkstat_one_fmt(struct xfs_ibulk *breq, const struct xfs_bstat *bstat);
+
 #endif
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 814ffe6fbab7..5d1c143bac18 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -11,11 +11,13 @@
 #include <linux/fsmap.h>
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_fsops.h"
@@ -172,15 +174,10 @@ xfs_bstime_store_compat(
 /* Return 0 on success or positive error (to xfs_bulkstat()) */
 STATIC int
 xfs_bulkstat_one_fmt_compat(
-	void			__user *ubuffer,
-	int			ubsize,
-	int			*ubused,
-	const xfs_bstat_t	*buffer)
+	struct xfs_ibulk	*breq,
+	const struct xfs_bstat	*buffer)
 {
-	compat_xfs_bstat_t	__user *p32 = ubuffer;
-
-	if (ubsize < sizeof(*p32))
-		return -ENOMEM;
+	struct compat_xfs_bstat	__user *p32 = breq->ubuffer;
 
 	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
 	    put_user(buffer->bs_mode,	  &p32->bs_mode)	||
@@ -205,23 +202,8 @@ xfs_bulkstat_one_fmt_compat(
 	    put_user(buffer->bs_dmstate,  &p32->bs_dmstate)	||
 	    put_user(buffer->bs_aextents, &p32->bs_aextents))
 		return -EFAULT;
-	if (ubused)
-		*ubused = sizeof(*p32);
-	return 0;
-}
 
-STATIC int
-xfs_bulkstat_one_compat(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	void		__user *buffer,	/* buffer to place output in */
-	int		ubsize,		/* size of buffer */
-	int		*ubused,	/* bytes used by me */
-	int		*stat)		/* BULKSTAT_RV_... */
-{
-	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
-				    xfs_bulkstat_one_fmt_compat,
-				    ubused, stat);
+	return xfs_ibulk_advance(breq, sizeof(struct compat_xfs_bstat));
 }
 
 /* copied from xfs_ioctl.c */
@@ -232,10 +214,12 @@ xfs_compat_ioc_bulkstat(
 	compat_xfs_fsop_bulkreq_t __user *p32)
 {
 	u32			addr;
-	xfs_fsop_bulkreq_t	bulkreq;
-	int			count;	/* # of records returned */
-	xfs_ino_t		inlast;	/* last inode number */
-	int			done;
+	struct xfs_fsop_bulkreq	bulkreq;
+	struct xfs_ibulk	breq = {
+		.mp		= mp,
+		.ocount		= 0,
+	};
+	xfs_ino_t		lastino;
 	int			error;
 
 	/*
@@ -245,8 +229,7 @@ xfs_compat_ioc_bulkstat(
 	 * functions and structure size are the correct ones to use ...
 	 */
 	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
-	bulkstat_one_pf	bs_one_func = xfs_bulkstat_one_compat;
-	size_t bs_one_size = sizeof(struct compat_xfs_bstat);
+	bulkstat_one_fmt_pf	bs_one_func = xfs_bulkstat_one_fmt_compat;
 
 #ifdef CONFIG_X86_X32
 	if (in_x32_syscall()) {
@@ -259,8 +242,7 @@ xfs_compat_ioc_bulkstat(
 		 * x32 userspace expects.
 		 */
 		inumbers_func = xfs_inumbers_fmt;
-		bs_one_func = xfs_bulkstat_one;
-		bs_one_size = sizeof(struct xfs_bstat);
+		bs_one_func = xfs_bulkstat_one_fmt;
 	}
 #endif
 
@@ -284,38 +266,59 @@ xfs_compat_ioc_bulkstat(
 		return -EFAULT;
 	bulkreq.ocount = compat_ptr(addr);
 
-	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
+	if (copy_from_user(&lastino, bulkreq.lastip, sizeof(__s64)))
 		return -EFAULT;
+	breq.startino = lastino + 1;
 
-	if ((count = bulkreq.icount) <= 0)
+	if (bulkreq.icount <= 0)
 		return -EINVAL;
 
 	if (bulkreq.ubuffer == NULL)
 		return -EINVAL;
 
+	breq.ubuffer = bulkreq.ubuffer;
+	breq.icount = bulkreq.icount;
+
+	/*
+	 * FSBULKSTAT_SINGLE expects that *lastip contains the inode number
+	 * that we want to stat.  However, FSINUMBERS and FSBULKSTAT expect
+	 * that *lastip contains either zero or the number of the last inode to
+	 * be examined by the previous call and return results starting with
+	 * the next inode after that.  The new bulk request back end functions
+	 * take the inode to start with, so we have to compute the startino
+	 * parameter from lastino to maintain correct function.  lastino == 0
+	 * is a special case because it has traditionally meant "first inode
+	 * in filesystem".
+	 */
 	if (cmd == XFS_IOC_FSINUMBERS_32) {
-		error = xfs_inumbers(mp, &inlast, &count,
+		int	count = breq.icount;
+
+		breq.startino = lastino;
+		error = xfs_inumbers(mp, &breq.startino, &count,
 				bulkreq.ubuffer, inumbers_func);
+		breq.ocount = count;
+		lastino = breq.startino;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
-		int res;
-
-		error = bs_one_func(mp, inlast, bulkreq.ubuffer,
-				bs_one_size, NULL, &res);
+		breq.startino = lastino;
+		breq.icount = 1;
+		error = xfs_bulkstat_one(&breq, bs_one_func);
+		lastino = breq.startino;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
-		error = xfs_bulkstat(mp, &inlast, &count,
-			bs_one_func, bs_one_size,
-			bulkreq.ubuffer, &done);
-	} else
+		breq.startino = lastino ? lastino + 1 : 0;
+		error = xfs_bulkstat(&breq, bs_one_func);
+		lastino = breq.startino - 1;
+	} else {
 		error = -EINVAL;
+	}
 	if (error)
 		return error;
 
 	if (bulkreq.lastip != NULL &&
-	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
+	    copy_to_user(bulkreq.lastip, &lastino, sizeof(xfs_ino_t)))
 		return -EFAULT;
 
 	if (bulkreq.ocount != NULL &&
-	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+	    copy_to_user(bulkreq.ocount, &breq.ocount, sizeof(__s32)))
 		return -EFAULT;
 
 	return 0;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 3ca1c454afe6..58e411e11d6c 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -14,47 +14,68 @@
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
-#include "xfs_iwalk.h"
 
 /*
- * Return stat information for one inode.
- * Return 0 if ok, else errno.
+ * Bulk Stat
+ * =========
+ *
+ * Use the inode walking functions to fill out struct xfs_bstat for every
+ * allocated inode, then pass the stat information to some externally provided
+ * iteration function.
  */
-int
+
+struct xfs_bstat_chunk {
+	bulkstat_one_fmt_pf	formatter;
+	struct xfs_ibulk	*breq;
+	struct xfs_bstat	*buf;
+};
+
+/*
+ * Fill out the bulkstat info for a single inode and report it somewhere.
+ *
+ * bc->breq->lastino is effectively the inode cursor as we walk through the
+ * filesystem.  Therefore, we update it any time we need to move the cursor
+ * forward, regardless of whether or not we're sending any bstat information
+ * back to userspace.  If the inode is internal metadata or, has been freed
+ * out from under us, we just simply keep going.
+ *
+ * However, if any other type of error happens we want to stop right where we
+ * are so that userspace will call back with exact number of the bad inode and
+ * we can send back an error code.
+ *
+ * Note that if the formatter tells us there's no space left in the buffer we
+ * move the cursor forward and abort the walk.
+ */
+STATIC int
 xfs_bulkstat_one_int(
-	struct xfs_mount	*mp,		/* mount point for filesystem */
-	xfs_ino_t		ino,		/* inode to get data for */
-	void __user		*buffer,	/* buffer to place output in */
-	int			ubsize,		/* size of buffer */
-	bulkstat_one_fmt_pf	formatter,	/* formatter, copy to user */
-	int			*ubused,	/* bytes used by me */
-	int			*stat)		/* BULKSTAT_RV_... */
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	void			*data)
 {
+	struct xfs_bstat_chunk	*bc = data;
 	struct xfs_icdinode	*dic;		/* dinode core info pointer */
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
-	struct xfs_bstat	*buf;		/* return buffer */
-	int			error = 0;	/* error value */
+	struct xfs_bstat	*buf = bc->buf;
+	int			error = -EINVAL;
 
-	*stat = BULKSTAT_RV_NOTHING;
+	if (xfs_internal_inum(mp, ino))
+		goto out_advance;
 
-	if (!buffer || xfs_internal_inum(mp, ino))
-		return -EINVAL;
-
-	buf = kmem_zalloc(sizeof(*buf), KM_SLEEP | KM_MAYFAIL);
-	if (!buf)
-		return -ENOMEM;
-
-	error = xfs_iget(mp, NULL, ino,
+	error = xfs_iget(mp, tp, ino,
 			 (XFS_IGET_DONTCACHE | XFS_IGET_UNTRUSTED),
 			 XFS_ILOCK_SHARED, &ip);
+	if (error == -ENOENT || error == -EINVAL)
+		goto out_advance;
 	if (error)
-		goto out_free;
+		goto out;
 
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
@@ -119,43 +140,56 @@ xfs_bulkstat_one_int(
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	xfs_irele(ip);
 
-	error = formatter(buffer, ubsize, ubused, buf);
-	if (!error)
-		*stat = BULKSTAT_RV_DIDONE;
+	error = bc->formatter(bc->breq, buf);
+	if (error == XFS_IBULK_BUFFER_FULL) {
+		error = XFS_IWALK_ABORT;
+		goto out_advance;
+	}
+	if (error)
+		goto out;
 
- out_free:
-	kmem_free(buf);
+out_advance:
+	/*
+	 * Advance the cursor to the inode that comes after the one we just
+	 * looked at.  We want the caller to move along if the bulkstat
+	 * information was copied successfully; if we tried to grab the inode
+	 * but it's no longer allocated; or if it's internal metadata.
+	 */
+	bc->breq->startino = ino + 1;
+out:
 	return error;
 }
 
-/* Return 0 on success or positive error */
-STATIC int
-xfs_bulkstat_one_fmt(
-	void			__user *ubuffer,
-	int			ubsize,
-	int			*ubused,
-	const xfs_bstat_t	*buffer)
-{
-	if (ubsize < sizeof(*buffer))
-		return -ENOMEM;
-	if (copy_to_user(ubuffer, buffer, sizeof(*buffer)))
-		return -EFAULT;
-	if (ubused)
-		*ubused = sizeof(*buffer);
-	return 0;
-}
-
+/* Bulkstat a single inode. */
 int
 xfs_bulkstat_one(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	void		__user *buffer,	/* buffer to place output in */
-	int		ubsize,		/* size of buffer */
-	int		*ubused,	/* bytes used by me */
-	int		*stat)		/* BULKSTAT_RV_... */
+	struct xfs_ibulk	*breq,
+	bulkstat_one_fmt_pf	formatter)
 {
-	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
-				    xfs_bulkstat_one_fmt, ubused, stat);
+	struct xfs_bstat_chunk	bc = {
+		.formatter	= formatter,
+		.breq		= breq,
+	};
+	int			error;
+
+	ASSERT(breq->icount == 1);
+
+	bc.buf = kmem_zalloc(sizeof(struct xfs_bstat), KM_SLEEP | KM_MAYFAIL);
+	if (!bc.buf)
+		return -ENOMEM;
+
+	error = xfs_bulkstat_one_int(breq->mp, NULL, breq->startino, &bc);
+
+	kmem_free(bc.buf);
+
+	/*
+	 * If we reported one inode to userspace then we abort because we hit
+	 * the end of the buffer.  Don't leak that back to userspace.
+	 */
+	if (error == XFS_IWALK_ABORT)
+		error = 0;
+
+	return error;
 }
 
 /*
@@ -251,256 +285,69 @@ xfs_bulkstat_grab_ichunk(
 
 #define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
 
-struct xfs_bulkstat_agichunk {
-	char		__user **ac_ubuffer;/* pointer into user's buffer */
-	int		ac_ubleft;	/* bytes left in user's buffer */
-	int		ac_ubelem;	/* spaces used in user's buffer */
-};
-
-/*
- * Process inodes in chunk with a pointer to a formatter function
- * that will iget the inode and fill in the appropriate structure.
- */
 static int
-xfs_bulkstat_ag_ichunk(
-	struct xfs_mount		*mp,
-	xfs_agnumber_t			agno,
-	struct xfs_inobt_rec_incore	*irbp,
-	bulkstat_one_pf			formatter,
-	size_t				statstruct_size,
-	struct xfs_bulkstat_agichunk	*acp,
-	xfs_agino_t			*last_agino)
+xfs_bulkstat_iwalk(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	void			*data)
 {
-	char				__user **ubufp = acp->ac_ubuffer;
-	int				chunkidx;
-	int				error = 0;
-	xfs_agino_t			agino = irbp->ir_startino;
-
-	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
-	     chunkidx++, agino++) {
-		int		fmterror;
-		int		ubused;
-
-		/* inode won't fit in buffer, we are done */
-		if (acp->ac_ubleft < statstruct_size)
-			break;
-
-		/* Skip if this inode is free */
-		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free)
-			continue;
-
-		/* Get the inode and fill in a single buffer */
-		ubused = statstruct_size;
-		error = formatter(mp, XFS_AGINO_TO_INO(mp, agno, agino),
-				  *ubufp, acp->ac_ubleft, &ubused, &fmterror);
-
-		if (fmterror == BULKSTAT_RV_GIVEUP ||
-		    (error && error != -ENOENT && error != -EINVAL)) {
-			acp->ac_ubleft = 0;
-			ASSERT(error);
-			break;
-		}
-
-		/* be careful not to leak error if at end of chunk */
-		if (fmterror == BULKSTAT_RV_NOTHING || error) {
-			error = 0;
-			continue;
-		}
-
-		*ubufp += ubused;
-		acp->ac_ubleft -= ubused;
-		acp->ac_ubelem++;
-	}
-
-	/*
-	 * Post-update *last_agino. At this point, agino will always point one
-	 * inode past the last inode we processed successfully. Hence we
-	 * substract that inode when setting the *last_agino cursor so that we
-	 * return the correct cookie to userspace. On the next bulkstat call,
-	 * the inode under the lastino cookie will be skipped as we have already
-	 * processed it here.
-	 */
-	*last_agino = agino - 1;
+	int			error;
 
+	error = xfs_bulkstat_one_int(mp, tp, ino, data);
+	/* bulkstat just skips over missing inodes */
+	if (error == -ENOENT || error == -EINVAL)
+		return 0;
 	return error;
 }
 
 /*
- * Return stat information in bulk (by-inode) for the filesystem.
+ * Check the incoming lastino parameter.
+ *
+ * We allow any inode value that could map to physical space inside the
+ * filesystem because if there are no inodes there, bulkstat moves on to the
+ * next chunk.  In other words, the magic agino value of zero takes us to the
+ * first chunk in the AG, and an agino value past the end of the AG takes us to
+ * the first chunk in the next AG.
+ *
+ * Therefore we can end early if the requested inode is beyond the end of the
+ * filesystem or doesn't map properly.
  */
-int					/* error status */
-xfs_bulkstat(
-	xfs_mount_t		*mp,	/* mount point for filesystem */
-	xfs_ino_t		*lastinop, /* last inode returned */
-	int			*ubcountp, /* size of buffer/count returned */
-	bulkstat_one_pf		formatter, /* func that'd fill a single buf */
-	size_t			statstruct_size, /* sizeof struct filling */
-	char			__user *ubuffer, /* buffer with inode stats */
-	int			*done)	/* 1 if there are more stats to get */
+static inline bool
+xfs_bulkstat_already_done(
+	struct xfs_mount	*mp,
+	xfs_ino_t		startino)
 {
-	xfs_buf_t		*agbp;	/* agi header buffer */
-	xfs_agino_t		agino;	/* inode # in allocation group */
-	xfs_agnumber_t		agno;	/* allocation group number */
-	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
-	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
-	int			nirbuf;	/* size of irbuf */
-	int			ubcount; /* size of user's buffer */
-	struct xfs_bulkstat_agichunk ac;
-	int			error = 0;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, startino);
 
-	/*
-	 * Get the last inode value, see if there's nothing to do.
-	 */
-	agno = XFS_INO_TO_AGNO(mp, *lastinop);
-	agino = XFS_INO_TO_AGINO(mp, *lastinop);
-	if (agno >= mp->m_sb.sb_agcount ||
-	    *lastinop != XFS_AGINO_TO_INO(mp, agno, agino)) {
-		*done = 1;
-		*ubcountp = 0;
-		return 0;
-	}
+	return agno >= mp->m_sb.sb_agcount ||
+	       startino != XFS_AGINO_TO_INO(mp, agno, agino);
+}
 
-	ubcount = *ubcountp; /* statstruct's */
-	ac.ac_ubuffer = &ubuffer;
-	ac.ac_ubleft = ubcount * statstruct_size; /* bytes */;
-	ac.ac_ubelem = 0;
+/* Return stat information in bulk (by-inode) for the filesystem. */
+int
+xfs_bulkstat(
+	struct xfs_ibulk	*breq,
+	bulkstat_one_fmt_pf	formatter)
+{
+	struct xfs_bstat_chunk	bc = {
+		.formatter	= formatter,
+		.breq		= breq,
+	};
+	int			error;
 
-	*ubcountp = 0;
-	*done = 0;
+	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
+		return 0;
 
-	irbuf = kmem_zalloc_large(PAGE_SIZE * 4, KM_SLEEP);
-	if (!irbuf)
+	bc.buf = kmem_zalloc(sizeof(struct xfs_bstat), KM_SLEEP | KM_MAYFAIL);
+	if (!bc.buf)
 		return -ENOMEM;
-	nirbuf = (PAGE_SIZE * 4) / sizeof(*irbuf);
 
-	/*
-	 * Loop over the allocation groups, starting from the last
-	 * inode returned; 0 means start of the allocation group.
-	 */
-	while (agno < mp->m_sb.sb_agcount) {
-		struct xfs_inobt_rec_incore	*irbp = irbuf;
-		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
-		bool				end_of_ag = false;
-		int				icount = 0;
-		int				stat;
+	error = xfs_iwalk(breq->mp, NULL, breq->startino, xfs_bulkstat_iwalk,
+			breq->icount, &bc);
 
-		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
-		if (error)
-			break;
-		/*
-		 * Allocate and initialize a btree cursor for ialloc btree.
-		 */
-		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
-					    XFS_BTNUM_INO);
-		if (agino > 0) {
-			/*
-			 * In the middle of an allocation group, we need to get
-			 * the remainder of the chunk we're in.
-			 */
-			struct xfs_inobt_rec_incore	r;
-
-			error = xfs_bulkstat_grab_ichunk(cur, agino, &icount, &r);
-			if (error)
-				goto del_cursor;
-			if (icount) {
-				irbp->ir_startino = r.ir_startino;
-				irbp->ir_holemask = r.ir_holemask;
-				irbp->ir_count = r.ir_count;
-				irbp->ir_freecount = r.ir_freecount;
-				irbp->ir_free = r.ir_free;
-				irbp++;
-			}
-			/* Increment to the next record */
-			error = xfs_btree_increment(cur, 0, &stat);
-		} else {
-			/* Start of ag.  Lookup the first inode chunk */
-			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
-		}
-		if (error || stat == 0) {
-			end_of_ag = true;
-			goto del_cursor;
-		}
-
-		/*
-		 * Loop through inode btree records in this ag,
-		 * until we run out of inodes or space in the buffer.
-		 */
-		while (irbp < irbufend && icount < ubcount) {
-			struct xfs_inobt_rec_incore	r;
-
-			error = xfs_inobt_get_rec(cur, &r, &stat);
-			if (error || stat == 0) {
-				end_of_ag = true;
-				goto del_cursor;
-			}
-
-			/*
-			 * If this chunk has any allocated inodes, save it.
-			 * Also start read-ahead now for this chunk.
-			 */
-			if (r.ir_freecount < r.ir_count) {
-				xfs_bulkstat_ichunk_ra(mp, agno, &r);
-				irbp->ir_startino = r.ir_startino;
-				irbp->ir_holemask = r.ir_holemask;
-				irbp->ir_count = r.ir_count;
-				irbp->ir_freecount = r.ir_freecount;
-				irbp->ir_free = r.ir_free;
-				irbp++;
-				icount += r.ir_count - r.ir_freecount;
-			}
-			error = xfs_btree_increment(cur, 0, &stat);
-			if (error || stat == 0) {
-				end_of_ag = true;
-				goto del_cursor;
-			}
-			cond_resched();
-		}
-
-		/*
-		 * Drop the btree buffers and the agi buffer as we can't hold any
-		 * of the locks these represent when calling iget. If there is a
-		 * pending error, then we are done.
-		 */
-del_cursor:
-		xfs_btree_del_cursor(cur, error);
-		xfs_buf_relse(agbp);
-		if (error)
-			break;
-		/*
-		 * Now format all the good inodes into the user's buffer. The
-		 * call to xfs_bulkstat_ag_ichunk() sets up the agino pointer
-		 * for the next loop iteration.
-		 */
-		irbufend = irbp;
-		for (irbp = irbuf;
-		     irbp < irbufend && ac.ac_ubleft >= statstruct_size;
-		     irbp++) {
-			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
-					formatter, statstruct_size, &ac,
-					&agino);
-			if (error)
-				break;
-
-			cond_resched();
-		}
-
-		/*
-		 * If we've run out of space or had a formatting error, we
-		 * are now done
-		 */
-		if (ac.ac_ubleft < statstruct_size || error)
-			break;
-
-		if (end_of_ag) {
-			agno++;
-			agino = 0;
-		}
-	}
-	/*
-	 * Done, we're either out of filesystem or space to put the data.
-	 */
-	kmem_free(irbuf);
-	*ubcountp = ac.ac_ubelem;
+	kmem_free(bc.buf);
 
 	/*
 	 * We found some inodes, so clear the error status and return them.
@@ -509,17 +356,9 @@ xfs_bulkstat(
 	 * triggered again and propagated to userspace as there will be no
 	 * formatted inodes in the buffer.
 	 */
-	if (ac.ac_ubelem)
+	if (breq->ocount > 0)
 		error = 0;
 
-	/*
-	 * If we ran out of filesystem, lastino will point off the end of
-	 * the filesystem so the next call will return immediately.
-	 */
-	*lastinop = XFS_AGINO_TO_INO(mp, agno, agino);
-	if (agno >= mp->m_sb.sb_agcount)
-		*done = 1;
-
 	return error;
 }
 
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 369e3f159d4e..7c5f1df360e6 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -5,63 +5,46 @@
 #ifndef __XFS_ITABLE_H__
 #define	__XFS_ITABLE_H__
 
-/*
- * xfs_bulkstat() is used to fill in xfs_bstat structures as well as dm_stat
- * structures (by the dmi library). This is a pointer to a formatter function
- * that will iget the inode and fill in the appropriate structure.
- * see xfs_bulkstat_one() and xfs_dm_bulkstat_one() in dmapi_xfs.c
- */
-typedef int (*bulkstat_one_pf)(struct xfs_mount	*mp,
-			       xfs_ino_t	ino,
-			       void		__user *buffer,
-			       int		ubsize,
-			       int		*ubused,
-			       int		*stat);
+/* In-memory representation of a userspace request for batch inode data. */
+struct xfs_ibulk {
+	struct xfs_mount	*mp;
+	void __user		*ubuffer; /* user output buffer */
+	xfs_ino_t		startino; /* start with this inode */
+	unsigned int		icount;   /* number of elements in ubuffer */
+	unsigned int		ocount;   /* number of records returned */
+};
+
+/* Return value that means we want to abort the walk. */
+#define XFS_IBULK_ABORT		(XFS_IWALK_ABORT)
+
+/* Return value that means the formatting buffer is now full. */
+#define XFS_IBULK_BUFFER_FULL	(XFS_IBULK_ABORT + 1)
 
 /*
- * Values for stat return value.
+ * Advance the user buffer pointer by one record of the given size.  If the
+ * buffer is now full, return the appropriate error code.
  */
-#define BULKSTAT_RV_NOTHING	0
-#define BULKSTAT_RV_DIDONE	1
-#define BULKSTAT_RV_GIVEUP	2
+static inline int
+xfs_ibulk_advance(
+	struct xfs_ibulk	*breq,
+	size_t			bytes)
+{
+	char __user		*b = breq->ubuffer;
+
+	breq->ubuffer = b + bytes;
+	breq->ocount++;
+	return breq->ocount == breq->icount ? XFS_IBULK_BUFFER_FULL : 0;
+}
 
 /*
  * Return stat information in bulk (by-inode) for the filesystem.
  */
-int					/* error status */
-xfs_bulkstat(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	*lastino,	/* last inode returned */
-	int		*count,		/* size of buffer/count returned */
-	bulkstat_one_pf formatter,	/* func that'd fill a single buf */
-	size_t		statstruct_size,/* sizeof struct that we're filling */
-	char		__user *ubuffer,/* buffer with inode stats */
-	int		*done);		/* 1 if there are more stats to get */
 
-typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
-	void			__user *ubuffer, /* buffer to write to */
-	int			ubsize,		 /* remaining user buffer sz */
-	int			*ubused,	 /* bytes used by formatter */
-	const xfs_bstat_t	*buffer);        /* buffer to read from */
+typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
+		const struct xfs_bstat *bstat);
 
-int
-xfs_bulkstat_one_int(
-	xfs_mount_t		*mp,
-	xfs_ino_t		ino,
-	void			__user *buffer,
-	int			ubsize,
-	bulkstat_one_fmt_pf	formatter,
-	int			*ubused,
-	int			*stat);
-
-int
-xfs_bulkstat_one(
-	xfs_mount_t		*mp,
-	xfs_ino_t		ino,
-	void			__user *buffer,
-	int			ubsize,
-	int			*ubused,
-	int			*stat);
+int xfs_bulkstat_one(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
+int xfs_bulkstat(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
 
 typedef int (*inumbers_fmt_pf)(
 	void			__user *ubuffer, /* buffer to write to */
