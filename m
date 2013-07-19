Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E868E7F6B
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A317C8F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tzpWoj7PmiKpHAhQ for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:37 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048a-2D
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001yi-1B
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/49] xfs: consolidate xfs_utils.c
Date: Fri, 19 Jul 2013 16:24:57 +1000
Message-Id: <1374215120-7271-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

There are a few small helper functions in xfs_util, all related to
xfs_inode modifications. Move them all to xfs_inode.c so all
xfs_inode operations are consiolidated in the one place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile          |   1 -
 fs/xfs/xfs_error.c       |   1 -
 fs/xfs/xfs_filestream.c  |   1 -
 fs/xfs/xfs_inode.c       | 279 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h       |   7 ++
 fs/xfs/xfs_ioctl.c       |   1 -
 fs/xfs/xfs_iomap.c       |   1 -
 fs/xfs/xfs_iops.c        |   1 -
 fs/xfs/xfs_log_recover.c |   1 -
 fs/xfs/xfs_mount.c       |   1 -
 fs/xfs/xfs_qm.c          |   1 -
 fs/xfs/xfs_qm_syscalls.c |   1 -
 fs/xfs/xfs_rtalloc.c     |   1 -
 fs/xfs/xfs_super.c       |   1 -
 fs/xfs/xfs_symlink.c     |   1 -
 fs/xfs/xfs_utils.c       | 316 -----------------------------------------------
 fs/xfs/xfs_utils.h       |  27 ----
 17 files changed, 285 insertions(+), 357 deletions(-)
 delete mode 100644 fs/xfs/xfs_utils.c
 delete mode 100644 fs/xfs/xfs_utils.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e5a0758..201c61d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -53,7 +53,6 @@ xfs-y				+= xfs_aops.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
 				   xfs_trans.o \
-				   xfs_utils.o \
 				   xfs_xattr.o \
 				   kmem.o \
 				   uuid.o
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 35d3f5b..1123d93f 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -26,7 +26,6 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_utils.h"
 #include "xfs_error.h"
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index d0e8890..ce78e65 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -28,7 +28,6 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
-#include "xfs_utils.h"
 #include "xfs_mru_cache.h"
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 29d41c4..9db5be7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -46,7 +46,6 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_error.h"
-#include "xfs_utils.h"
 #include "xfs_quota.h"
 #include "xfs_filestream.h"
 #include "xfs_cksum.h"
@@ -862,6 +861,284 @@ xfs_ialloc(
 	return 0;
 }
 
+/*
+ * Allocates a new inode from disk and return a pointer to the
+ * incore copy. This routine will internally commit the current
+ * transaction and allocate a new one if the Space Manager needed
+ * to do an allocation to replenish the inode free-list.
+ *
+ * This routine is designed to be called from xfs_create and
+ * xfs_create_dir.
+ *
+ */
+int
+xfs_dir_ialloc(
+	xfs_trans_t	**tpp,		/* input: current transaction;
+					   output: may be a new transaction. */
+	xfs_inode_t	*dp,		/* directory within whose allocate
+					   the inode. */
+	umode_t		mode,
+	xfs_nlink_t	nlink,
+	xfs_dev_t	rdev,
+	prid_t		prid,		/* project id */
+	int		okalloc,	/* ok to allocate new space */
+	xfs_inode_t	**ipp,		/* pointer to inode; it will be
+					   locked. */
+	int		*committed)
+
+{
+	xfs_trans_t	*tp;
+	xfs_trans_t	*ntp;
+	xfs_inode_t	*ip;
+	xfs_buf_t	*ialloc_context = NULL;
+	int		code;
+	uint		log_res;
+	uint		log_count;
+	void		*dqinfo;
+	uint		tflags;
+
+	tp = *tpp;
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	/*
+	 * xfs_ialloc will return a pointer to an incore inode if
+	 * the Space Manager has an available inode on the free
+	 * list. Otherwise, it will do an allocation and replenish
+	 * the freelist.  Since we can only do one allocation per
+	 * transaction without deadlocks, we will need to commit the
+	 * current transaction and start a new one.  We will then
+	 * need to call xfs_ialloc again to get the inode.
+	 *
+	 * If xfs_ialloc did an allocation to replenish the freelist,
+	 * it returns the bp containing the head of the freelist as
+	 * ialloc_context. We will hold a lock on it across the
+	 * transaction commit so that no other process can steal
+	 * the inode(s) that we've just allocated.
+	 */
+	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, okalloc,
+			  &ialloc_context, &ip);
+
+	/*
+	 * Return an error if we were unable to allocate a new inode.
+	 * This should only happen if we run out of space on disk or
+	 * encounter a disk error.
+	 */
+	if (code) {
+		*ipp = NULL;
+		return code;
+	}
+	if (!ialloc_context && !ip) {
+		*ipp = NULL;
+		return XFS_ERROR(ENOSPC);
+	}
+
+	/*
+	 * If the AGI buffer is non-NULL, then we were unable to get an
+	 * inode in one operation.  We need to commit the current
+	 * transaction and call xfs_ialloc() again.  It is guaranteed
+	 * to succeed the second time.
+	 */
+	if (ialloc_context) {
+		/*
+		 * Normally, xfs_trans_commit releases all the locks.
+		 * We call bhold to hang on to the ialloc_context across
+		 * the commit.  Holding this buffer prevents any other
+		 * processes from doing any allocations in this
+		 * allocation group.
+		 */
+		xfs_trans_bhold(tp, ialloc_context);
+		/*
+		 * Save the log reservation so we can use
+		 * them in the next transaction.
+		 */
+		log_res = xfs_trans_get_log_res(tp);
+		log_count = xfs_trans_get_log_count(tp);
+
+		/*
+		 * We want the quota changes to be associated with the next
+		 * transaction, NOT this one. So, detach the dqinfo from this
+		 * and attach it to the next transaction.
+		 */
+		dqinfo = NULL;
+		tflags = 0;
+		if (tp->t_dqinfo) {
+			dqinfo = (void *)tp->t_dqinfo;
+			tp->t_dqinfo = NULL;
+			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
+			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
+		}
+
+		ntp = xfs_trans_dup(tp);
+		code = xfs_trans_commit(tp, 0);
+		tp = ntp;
+		if (committed != NULL) {
+			*committed = 1;
+		}
+		/*
+		 * If we get an error during the commit processing,
+		 * release the buffer that is still held and return
+		 * to the caller.
+		 */
+		if (code) {
+			xfs_buf_relse(ialloc_context);
+			if (dqinfo) {
+				tp->t_dqinfo = dqinfo;
+				xfs_trans_free_dqinfo(tp);
+			}
+			*tpp = ntp;
+			*ipp = NULL;
+			return code;
+		}
+
+		/*
+		 * transaction commit worked ok so we can drop the extra ticket
+		 * reference that we gained in xfs_trans_dup()
+		 */
+		xfs_log_ticket_put(tp->t_ticket);
+		code = xfs_trans_reserve(tp, 0, log_res, 0,
+					 XFS_TRANS_PERM_LOG_RES, log_count);
+		/*
+		 * Re-attach the quota info that we detached from prev trx.
+		 */
+		if (dqinfo) {
+			tp->t_dqinfo = dqinfo;
+			tp->t_flags |= tflags;
+		}
+
+		if (code) {
+			xfs_buf_relse(ialloc_context);
+			*tpp = ntp;
+			*ipp = NULL;
+			return code;
+		}
+		xfs_trans_bjoin(tp, ialloc_context);
+
+		/*
+		 * Call ialloc again. Since we've locked out all
+		 * other allocations in this allocation group,
+		 * this call should always succeed.
+		 */
+		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
+				  okalloc, &ialloc_context, &ip);
+
+		/*
+		 * If we get an error at this point, return to the caller
+		 * so that the current transaction can be aborted.
+		 */
+		if (code) {
+			*tpp = tp;
+			*ipp = NULL;
+			return code;
+		}
+		ASSERT(!ialloc_context && ip);
+
+	} else {
+		if (committed != NULL)
+			*committed = 0;
+	}
+
+	*ipp = ip;
+	*tpp = tp;
+
+	return 0;
+}
+
+/*
+ * Decrement the link count on an inode & log the change.
+ * If this causes the link count to go to zero, initiate the
+ * logging activity required to truncate a file.
+ */
+int				/* error */
+xfs_droplink(
+	xfs_trans_t *tp,
+	xfs_inode_t *ip)
+{
+	int	error;
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	ASSERT (ip->i_d.di_nlink > 0);
+	ip->i_d.di_nlink--;
+	drop_nlink(VFS_I(ip));
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	error = 0;
+	if (ip->i_d.di_nlink == 0) {
+		/*
+		 * We're dropping the last link to this file.
+		 * Move the on-disk inode to the AGI unlinked list.
+		 * From xfs_inactive() we will pull the inode from
+		 * the list and free it.
+		 */
+		error = xfs_iunlink(tp, ip);
+	}
+	return error;
+}
+
+/*
+ * This gets called when the inode's version needs to be changed from 1 to 2.
+ * Currently this happens when the nlink field overflows the old 16-bit value
+ * or when chproj is called to change the project for the first time.
+ * As a side effect the superblock version will also get rev'd
+ * to contain the NLINK bit.
+ */
+void
+xfs_bump_ino_vers2(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*ip)
+{
+	xfs_mount_t	*mp;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(ip->i_d.di_version == 1);
+
+	ip->i_d.di_version = 2;
+	ip->i_d.di_onlink = 0;
+	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
+	mp = tp->t_mountp;
+	if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
+		spin_lock(&mp->m_sb_lock);
+		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
+			xfs_sb_version_addnlink(&mp->m_sb);
+			spin_unlock(&mp->m_sb_lock);
+			xfs_mod_sb(tp, XFS_SB_VERSIONNUM);
+		} else {
+			spin_unlock(&mp->m_sb_lock);
+		}
+	}
+	/* Caller must log the inode */
+}
+
+/*
+ * Increment the link count on an inode & log the change.
+ */
+int
+xfs_bumplink(
+	xfs_trans_t *tp,
+	xfs_inode_t *ip)
+{
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	ASSERT(ip->i_d.di_nlink > 0);
+	ip->i_d.di_nlink++;
+	inc_nlink(VFS_I(ip));
+	if ((ip->i_d.di_version == 1) &&
+	    (ip->i_d.di_nlink > XFS_MAXLINK_1)) {
+		/*
+		 * The inode has increased its number of links beyond
+		 * what can fit in an old format inode.  It now needs
+		 * to be converted to a version 2 inode with a 32 bit
+		 * link count.  If this is the first inode in the file
+		 * system to do this, then we need to bump the superblock
+		 * version number as well.
+		 */
+		xfs_bump_ino_vers2(tp, ip);
+	}
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 int
 xfs_create(
 	xfs_inode_t		*dp,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2a63470..4a91358 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -360,6 +360,13 @@ void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
 xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
 
+int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
+			       xfs_nlink_t, xfs_dev_t, prid_t, int,
+			       struct xfs_inode **, int *);
+int		xfs_droplink(struct xfs_trans *, struct xfs_inode *);
+int		xfs_bumplink(struct xfs_trans *, struct xfs_inode *);
+void		xfs_bump_ino_vers2(struct xfs_trans *, struct xfs_inode *);
+
 /* from xfs_file.c */
 int		xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 int		xfs_iozero(struct xfs_inode *, loff_t, size_t);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ce636bf..557c7b8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -35,7 +35,6 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_buf_item.h"
-#include "xfs_utils.h"
 #include "xfs_dfrag.h"
 #include "xfs_fsops.h"
 #include "xfs_discard.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index b04a60f..cf8f744 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -40,7 +40,6 @@
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
-#include "xfs_utils.h"
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e0cefd4..24be68d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -36,7 +36,6 @@
 #include "xfs_itable.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
-#include "xfs_utils.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fabcc84..0771fa3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -41,7 +41,6 @@
 #include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
-#include "xfs_utils.h"
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c0eafbe..7a02d66 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -42,7 +42,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
-#include "xfs_utils.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_cksum.h"
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e14d53a..6432ebb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -38,7 +38,6 @@
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
-#include "xfs_utils.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3521c8b..40b06b5 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -38,7 +38,6 @@
 #include "xfs_error.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
-#include "xfs_utils.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7a445e6..4822806 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -35,7 +35,6 @@
 #include "xfs_error.h"
 #include "xfs_inode_item.h"
 #include "xfs_trans_space.h"
-#include "xfs_utils.h"
 #include "xfs_trace.h"
 #include "xfs_buf.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 980ecab..1a4fc1c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -40,7 +40,6 @@
 #include "xfs_fsops.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
-#include "xfs_utils.h"
 #include "xfs_log_priv.h"
 #include "xfs_trans_priv.h"
 #include "xfs_filestream.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 1ce2756..e6facbf 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -38,7 +38,6 @@
 #include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
-#include "xfs_utils.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
deleted file mode 100644
index fde7d22..0000000
--- a/fs/xfs/xfs_utils.c
+++ /dev/null
@@ -1,316 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_format.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_da_btree.h"
-#include "xfs_dir2_format.h"
-#include "xfs_dir2.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_inode_item.h"
-#include "xfs_bmap.h"
-#include "xfs_error.h"
-#include "xfs_quota.h"
-#include "xfs_itable.h"
-#include "xfs_utils.h"
-
-
-/*
- * Allocates a new inode from disk and return a pointer to the
- * incore copy. This routine will internally commit the current
- * transaction and allocate a new one if the Space Manager needed
- * to do an allocation to replenish the inode free-list.
- *
- * This routine is designed to be called from xfs_create and
- * xfs_create_dir.
- *
- */
-int
-xfs_dir_ialloc(
-	xfs_trans_t	**tpp,		/* input: current transaction;
-					   output: may be a new transaction. */
-	xfs_inode_t	*dp,		/* directory within whose allocate
-					   the inode. */
-	umode_t		mode,
-	xfs_nlink_t	nlink,
-	xfs_dev_t	rdev,
-	prid_t		prid,		/* project id */
-	int		okalloc,	/* ok to allocate new space */
-	xfs_inode_t	**ipp,		/* pointer to inode; it will be
-					   locked. */
-	int		*committed)
-
-{
-	xfs_trans_t	*tp;
-	xfs_trans_t	*ntp;
-	xfs_inode_t	*ip;
-	xfs_buf_t	*ialloc_context = NULL;
-	int		code;
-	uint		log_res;
-	uint		log_count;
-	void		*dqinfo;
-	uint		tflags;
-
-	tp = *tpp;
-	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
-
-	/*
-	 * xfs_ialloc will return a pointer to an incore inode if
-	 * the Space Manager has an available inode on the free
-	 * list. Otherwise, it will do an allocation and replenish
-	 * the freelist.  Since we can only do one allocation per
-	 * transaction without deadlocks, we will need to commit the
-	 * current transaction and start a new one.  We will then
-	 * need to call xfs_ialloc again to get the inode.
-	 *
-	 * If xfs_ialloc did an allocation to replenish the freelist,
-	 * it returns the bp containing the head of the freelist as
-	 * ialloc_context. We will hold a lock on it across the
-	 * transaction commit so that no other process can steal
-	 * the inode(s) that we've just allocated.
-	 */
-	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, okalloc,
-			  &ialloc_context, &ip);
-
-	/*
-	 * Return an error if we were unable to allocate a new inode.
-	 * This should only happen if we run out of space on disk or
-	 * encounter a disk error.
-	 */
-	if (code) {
-		*ipp = NULL;
-		return code;
-	}
-	if (!ialloc_context && !ip) {
-		*ipp = NULL;
-		return XFS_ERROR(ENOSPC);
-	}
-
-	/*
-	 * If the AGI buffer is non-NULL, then we were unable to get an
-	 * inode in one operation.  We need to commit the current
-	 * transaction and call xfs_ialloc() again.  It is guaranteed
-	 * to succeed the second time.
-	 */
-	if (ialloc_context) {
-		/*
-		 * Normally, xfs_trans_commit releases all the locks.
-		 * We call bhold to hang on to the ialloc_context across
-		 * the commit.  Holding this buffer prevents any other
-		 * processes from doing any allocations in this
-		 * allocation group.
-		 */
-		xfs_trans_bhold(tp, ialloc_context);
-		/*
-		 * Save the log reservation so we can use
-		 * them in the next transaction.
-		 */
-		log_res = xfs_trans_get_log_res(tp);
-		log_count = xfs_trans_get_log_count(tp);
-
-		/*
-		 * We want the quota changes to be associated with the next
-		 * transaction, NOT this one. So, detach the dqinfo from this
-		 * and attach it to the next transaction.
-		 */
-		dqinfo = NULL;
-		tflags = 0;
-		if (tp->t_dqinfo) {
-			dqinfo = (void *)tp->t_dqinfo;
-			tp->t_dqinfo = NULL;
-			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
-			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
-		}
-
-		ntp = xfs_trans_dup(tp);
-		code = xfs_trans_commit(tp, 0);
-		tp = ntp;
-		if (committed != NULL) {
-			*committed = 1;
-		}
-		/*
-		 * If we get an error during the commit processing,
-		 * release the buffer that is still held and return
-		 * to the caller.
-		 */
-		if (code) {
-			xfs_buf_relse(ialloc_context);
-			if (dqinfo) {
-				tp->t_dqinfo = dqinfo;
-				xfs_trans_free_dqinfo(tp);
-			}
-			*tpp = ntp;
-			*ipp = NULL;
-			return code;
-		}
-
-		/*
-		 * transaction commit worked ok so we can drop the extra ticket
-		 * reference that we gained in xfs_trans_dup()
-		 */
-		xfs_log_ticket_put(tp->t_ticket);
-		code = xfs_trans_reserve(tp, 0, log_res, 0,
-					 XFS_TRANS_PERM_LOG_RES, log_count);
-		/*
-		 * Re-attach the quota info that we detached from prev trx.
-		 */
-		if (dqinfo) {
-			tp->t_dqinfo = dqinfo;
-			tp->t_flags |= tflags;
-		}
-
-		if (code) {
-			xfs_buf_relse(ialloc_context);
-			*tpp = ntp;
-			*ipp = NULL;
-			return code;
-		}
-		xfs_trans_bjoin(tp, ialloc_context);
-
-		/*
-		 * Call ialloc again. Since we've locked out all
-		 * other allocations in this allocation group,
-		 * this call should always succeed.
-		 */
-		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
-				  okalloc, &ialloc_context, &ip);
-
-		/*
-		 * If we get an error at this point, return to the caller
-		 * so that the current transaction can be aborted.
-		 */
-		if (code) {
-			*tpp = tp;
-			*ipp = NULL;
-			return code;
-		}
-		ASSERT(!ialloc_context && ip);
-
-	} else {
-		if (committed != NULL)
-			*committed = 0;
-	}
-
-	*ipp = ip;
-	*tpp = tp;
-
-	return 0;
-}
-
-/*
- * Decrement the link count on an inode & log the change.
- * If this causes the link count to go to zero, initiate the
- * logging activity required to truncate a file.
- */
-int				/* error */
-xfs_droplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
-{
-	int	error;
-
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	ASSERT (ip->i_d.di_nlink > 0);
-	ip->i_d.di_nlink--;
-	drop_nlink(VFS_I(ip));
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	error = 0;
-	if (ip->i_d.di_nlink == 0) {
-		/*
-		 * We're dropping the last link to this file.
-		 * Move the on-disk inode to the AGI unlinked list.
-		 * From xfs_inactive() we will pull the inode from
-		 * the list and free it.
-		 */
-		error = xfs_iunlink(tp, ip);
-	}
-	return error;
-}
-
-/*
- * This gets called when the inode's version needs to be changed from 1 to 2.
- * Currently this happens when the nlink field overflows the old 16-bit value
- * or when chproj is called to change the project for the first time.
- * As a side effect the superblock version will also get rev'd
- * to contain the NLINK bit.
- */
-void
-xfs_bump_ino_vers2(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(ip->i_d.di_version == 1);
-
-	ip->i_d.di_version = 2;
-	ip->i_d.di_onlink = 0;
-	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-	mp = tp->t_mountp;
-	if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
-		spin_lock(&mp->m_sb_lock);
-		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
-			xfs_sb_version_addnlink(&mp->m_sb);
-			spin_unlock(&mp->m_sb_lock);
-			xfs_mod_sb(tp, XFS_SB_VERSIONNUM);
-		} else {
-			spin_unlock(&mp->m_sb_lock);
-		}
-	}
-	/* Caller must log the inode */
-}
-
-/*
- * Increment the link count on an inode & log the change.
- */
-int
-xfs_bumplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
-{
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	ASSERT(ip->i_d.di_nlink > 0);
-	ip->i_d.di_nlink++;
-	inc_nlink(VFS_I(ip));
-	if ((ip->i_d.di_version == 1) &&
-	    (ip->i_d.di_nlink > XFS_MAXLINK_1)) {
-		/*
-		 * The inode has increased its number of links beyond
-		 * what can fit in an old format inode.  It now needs
-		 * to be converted to a version 2 inode with a 32 bit
-		 * link count.  If this is the first inode in the file
-		 * system to do this, then we need to bump the superblock
-		 * version number as well.
-		 */
-		xfs_bump_ino_vers2(tp, ip);
-	}
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return 0;
-}
diff --git a/fs/xfs/xfs_utils.h b/fs/xfs/xfs_utils.h
deleted file mode 100644
index 5eeab46..0000000
--- a/fs/xfs/xfs_utils.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_UTILS_H__
-#define __XFS_UTILS_H__
-
-extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, umode_t, xfs_nlink_t,
-				xfs_dev_t, prid_t, int, xfs_inode_t **, int *);
-extern int xfs_droplink(xfs_trans_t *, xfs_inode_t *);
-extern int xfs_bumplink(xfs_trans_t *, xfs_inode_t *);
-extern void xfs_bump_ino_vers2(xfs_trans_t *, xfs_inode_t *);
-
-#endif	/* __XFS_UTILS_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
