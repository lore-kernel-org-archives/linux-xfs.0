Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C31297F4E
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:25:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A6BC8F804B
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:25:50 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:09 -0700
Message-Id: <1363213395-10988-8-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 08/14] xfs: Use kprojids when allocating inodes.
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
To: linux-fsdevel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>

From: "Eric W. Biederman" <ebiederm@xmission.com>

In xfs_create and xfs_symlink compute the desired kprojid and pass it
down into xfs_ialloc.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_inode.c    |    5 +++--
 fs/xfs/xfs_inode.h    |    2 +-
 fs/xfs/xfs_qm.c       |    4 +++-
 fs/xfs/xfs_utils.c    |    2 +-
 fs/xfs/xfs_utils.h    |    2 +-
 fs/xfs/xfs_vnodeops.c |    8 ++++----
 6 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8d77e49..bed6947 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1226,7 +1226,7 @@ xfs_ialloc(
 	umode_t		mode,
 	xfs_nlink_t	nlink,
 	xfs_dev_t	rdev,
-	prid_t		prid,
+	kprojid_t	prid,
 	int		okalloc,
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
@@ -1290,7 +1290,8 @@ xfs_ialloc(
 	/*
 	 * Project ids won't be stored on disk if we are using a version 1 inode.
 	 */
-	if ((prid != 0) && (ip->i_d.di_version == 1))
+	if (!projid_eq(prid, make_kprojid(&init_user_ns, 0)) &&
+	    (ip->i_d.di_version == 1))
 		xfs_bump_ino_vers2(tp, ip);
 
 	if (pip && XFS_INHERIT_GID(pip)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 095bcbb..efe279e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -516,7 +516,7 @@ int		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
 void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
-			   xfs_nlink_t, xfs_dev_t, prid_t, int,
+			   xfs_nlink_t, xfs_dev_t, kprojid_t, int,
 			   struct xfs_buf **, xfs_inode_t **);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3324dd3..861e4e8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -777,7 +777,9 @@ xfs_qm_qino_alloc(
 		return error;
 	}
 
-	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &committed);
+	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
+			       make_kprojid(&init_user_ns, 0),
+			       1, ip, &committed);
 	if (error) {
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 				 XFS_TRANS_ABORT);
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 0025c78..f0a9f1d 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -54,7 +54,7 @@ xfs_dir_ialloc(
 	umode_t		mode,
 	xfs_nlink_t	nlink,
 	xfs_dev_t	rdev,
-	prid_t		prid,		/* project id */
+	kprojid_t	prid,		/* project id */
 	int		okalloc,	/* ok to allocate new space */
 	xfs_inode_t	**ipp,		/* pointer to inode; it will be
 					   locked. */
diff --git a/fs/xfs/xfs_utils.h b/fs/xfs/xfs_utils.h
index 5eeab46..7757f7c 100644
--- a/fs/xfs/xfs_utils.h
+++ b/fs/xfs/xfs_utils.h
@@ -19,7 +19,7 @@
 #define __XFS_UTILS_H__
 
 extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, umode_t, xfs_nlink_t,
-				xfs_dev_t, prid_t, int, xfs_inode_t **, int *);
+				xfs_dev_t, kprojid_t, int, xfs_inode_t **, int *);
 extern int xfs_droplink(xfs_trans_t *, xfs_inode_t *);
 extern int xfs_bumplink(xfs_trans_t *, xfs_inode_t *);
 extern void xfs_bump_ino_vers2(xfs_trans_t *, xfs_inode_t *);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index dab0ab3..863b979 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -728,7 +728,7 @@ xfs_create(
 	bool                    unlock_dp_on_error = false;
 	uint			cancel_flags;
 	int			committed;
-	prid_t			prid;
+	kprojid_t		prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	uint			resblks;
@@ -743,7 +743,7 @@ xfs_create(
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
 	else
-		prid = XFS_PROJID_DEFAULT;
+		prid = make_kprojid(&init_user_ns, XFS_PROJID_DEFAULT);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
@@ -1379,7 +1379,7 @@ xfs_symlink(
 	int			byte_cnt;
 	int			n;
 	xfs_buf_t		*bp;
-	prid_t			prid;
+	kprojid_t		prid;
 	struct xfs_dquot	*udqp, *gdqp;
 	uint			resblks;
 
@@ -1404,7 +1404,7 @@ xfs_symlink(
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
 	else
-		prid = XFS_PROJID_DEFAULT;
+		prid = make_kprojid(&init_user_ns, XFS_PROJID_DEFAULT);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
