Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 19E5E7CBF
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 14:15:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FA54AC001
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:15:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZXrXAPGw2Nn1FdLz for
	<xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:15:22 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8JJFMdO021125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:15:22 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8JJFL8g009193
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:15:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 4/4] xfs: clean up xfs_inactive() error handling,
	kill VN_INACTIVE_[NO]CACHE
Date: Thu, 19 Sep 2013 15:15:21 -0400
Message-Id: <1379618121-35105-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
References: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
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

The xfs_inactive() return value is meaningless. Turn xfs_inactive()
into a void function and clean up the error handling appropriately.
Kill the VN_INACTIVE_[NO]CACHE directives as they are not relevant
to Linux.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 28 +++++++++++-----------------
 fs/xfs/xfs_inode.h |  2 +-
 fs/xfs/xfs_vnode.h |  8 --------
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dde182e..6b08fd2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1790,7 +1790,7 @@ xfs_inactive_ifree(
  * now be truncated.  Also, we clear all of the read-ahead state
  * kept for the inode here since the file is now closed.
  */
-int
+void
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
@@ -1805,16 +1805,14 @@ xfs_inactive(
 	if (ip->i_d.di_mode == 0 || is_bad_inode(VFS_I(ip))) {
 		ASSERT(ip->i_df.if_real_bytes == 0);
 		ASSERT(ip->i_df.if_broot_bytes == 0);
-		return VN_INACTIVE_CACHE;
+		return;
 	}
 
 	mp = ip->i_mount;
 
-	error = 0;
-
 	/* If this is a read-only mount, don't do this (would generate I/O) */
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		goto out;
+		return;
 
 	if (ip->i_d.di_nlink != 0) {
 		/*
@@ -1822,12 +1820,10 @@ xfs_inactive(
 		 * cache. Post-eof blocks must be freed, lest we end up with
 		 * broken free space accounting.
 		 */
-		if (xfs_can_free_eofblocks(ip, true)) {
-			error = xfs_free_eofblocks(mp, ip, false);
-			if (error)
-				return VN_INACTIVE_CACHE;
-		}
-		goto out;
+		if (xfs_can_free_eofblocks(ip, true))
+			xfs_free_eofblocks(mp, ip, false);
+
+		return;
 	}
 
 	if (S_ISREG(ip->i_d.di_mode) &&
@@ -1837,14 +1833,14 @@ xfs_inactive(
 
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
-		return VN_INACTIVE_CACHE;
+		return;
 
 	if (S_ISLNK(ip->i_d.di_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)
 		error = xfs_inactive_truncate(ip);
 	if (error)
-		goto out;
+		return;
 
 	/*
 	 * If there are attributes associated with the file then blow them away
@@ -1857,7 +1853,7 @@ xfs_inactive(
 
 		error = xfs_attr_inactive(ip);
 		if (error)
-			goto out;
+			return;
 	}
 
 	if (ip->i_afp)
@@ -1870,14 +1866,12 @@ xfs_inactive(
 	 */
 	error = xfs_inactive_ifree(ip);
 	if (error)
-		goto out;
+		return;
 
 	/*
 	 * Release the dquots held by inode, if any.
 	 */
 	xfs_qm_dqdetach(ip);
-out:
-	return VN_INACTIVE_CACHE;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4a91358..cce62ce 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -316,7 +316,7 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
 
 
 int		xfs_release(struct xfs_inode *ip);
-int		xfs_inactive(struct xfs_inode *ip);
+void		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
diff --git a/fs/xfs/xfs_vnode.h b/fs/xfs/xfs_vnode.h
index db14d0c..3e8e797 100644
--- a/fs/xfs/xfs_vnode.h
+++ b/fs/xfs/xfs_vnode.h
@@ -25,14 +25,6 @@ struct xfs_inode;
 struct attrlist_cursor_kern;
 
 /*
- * Return values for xfs_inactive.  A return value of
- * VN_INACTIVE_NOCACHE implies that the file system behavior
- * has disassociated its state and bhv_desc_t from the vnode.
- */
-#define	VN_INACTIVE_CACHE	0
-#define	VN_INACTIVE_NOCACHE	1
-
-/*
  * Flags for read/write calls - same values as IRIX
  */
 #define IO_ISDIRECT	0x00004		/* bypass page cache */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
