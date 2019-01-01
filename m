Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56970 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfAACXp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:23:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012NihA173680
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:44 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxedxave-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:23:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012NghK014675
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:43 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012Ngeh008895
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:42 GMT
Subject: [PATCH 12/13] xfs: disable the agi rotor for metadata inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:23:41 -0800
Message-ID: <154630942114.21716.1893263236839727703.stgit@magnolia>
In-Reply-To: <154630934595.21716.17416691804044507782.stgit@magnolia>
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ideally, we'd put all the metadata inodes in one place if we could, so
that the metadata all stay reasonably close together instead of
spreading out over the disk.  Furthermore, if the log is internal we'd
probably prefer to keep the metadata near the log.  Therefore, disable
AGI rotoring for metadata inode allocations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c     |   48 ++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_ialloc.h     |   10 ++++----
 fs/xfs/libxfs/xfs_inode_util.c |    3 +--
 3 files changed, 37 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f32be0c85f93..9f926fbb37f8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -937,20 +937,21 @@ xfs_ialloc_next_ag(
  */
 STATIC xfs_agnumber_t
 xfs_ialloc_ag_select(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_ino_t	parent,		/* parent directory inode number */
-	umode_t		mode)		/* bits set to indicate file type */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*pip,
+	umode_t			mode)
 {
-	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
-	xfs_agnumber_t	agno;		/* current ag number */
-	int		flags;		/* alloc buffer locking flags */
-	xfs_extlen_t	ineed;		/* blocks needed for inode allocation */
-	xfs_extlen_t	longest = 0;	/* longest extent available */
-	xfs_mount_t	*mp;		/* mount point structure */
-	int		needspace;	/* file mode implies space allocated */
-	xfs_perag_t	*pag;		/* per allocation group data */
-	xfs_agnumber_t	pagno;		/* parent (starting) ag number */
-	int		error;
+	struct xfs_mount	*mp;
+	struct xfs_perag	*pag;
+	xfs_ino_t		parent = pip ? pip->i_ino : 0;
+	xfs_agnumber_t		agcount;
+	xfs_agnumber_t		agno;
+	xfs_agnumber_t		pagno;
+	xfs_extlen_t		ineed;
+	xfs_extlen_t		longest = 0;	/* longest extent available */
+	int			needspace;	/* file mode implies space allocated */
+	int			flags;
+	int			error;
 
 	/*
 	 * Files of these types need at least one block if length > 0
@@ -959,9 +960,21 @@ xfs_ialloc_ag_select(
 	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
 	mp = tp->t_mountp;
 	agcount = mp->m_maxagi;
-	if (S_ISDIR(mode))
+	if (pip && xfs_is_metadata_inode(pip)) {
+		/*
+		 * Try to squash all the metadata inodes into the parent's
+		 * AG, or the one with the log if the log is internal, or
+		 * AG 0 if all else fails.
+		 */
+		if (xfs_verify_ino(mp, parent))
+			pagno = XFS_INO_TO_AGNO(mp, parent);
+		else if (mp->m_sb.sb_logstart != 0)
+			pagno = XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
+		else
+			pagno = 0;
+	} else if (S_ISDIR(mode)) {
 		pagno = xfs_ialloc_next_ag(mp);
-	else {
+	} else {
 		pagno = XFS_INO_TO_AGNO(mp, parent);
 		if (pagno >= agcount)
 			pagno = 0;
@@ -1693,13 +1706,14 @@ xfs_dialloc_ag(
 int
 xfs_dialloc(
 	struct xfs_trans	*tp,
-	xfs_ino_t		parent,
+	struct xfs_inode	*pip,
 	umode_t			mode,
 	struct xfs_buf		**IO_agbp,
 	xfs_ino_t		*inop)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*agbp;
+	xfs_ino_t		parent = pip ? pip->i_ino : 0;
 	xfs_agnumber_t		agno;
 	int			error;
 	int			ialloced;
@@ -1723,7 +1737,7 @@ xfs_dialloc(
 	 * We do not have an agbp, so select an initial allocation
 	 * group for inode allocation.
 	 */
-	start_agno = xfs_ialloc_ag_select(tp, parent, mode);
+	start_agno = xfs_ialloc_ag_select(tp, pip, mode);
 	if (start_agno == NULLAGNUMBER) {
 		*inop = NULLFSINO;
 		return 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index b74fa2addd51..23a03168c240 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -66,11 +66,11 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
  */
 int					/* error */
 xfs_dialloc(
-	struct xfs_trans *tp,		/* transaction pointer */
-	xfs_ino_t	parent,		/* parent inode (directory) */
-	umode_t		mode,		/* mode bits for new inode */
-	struct xfs_buf	**agbp,		/* buf for a.g. inode header */
-	xfs_ino_t	*inop);		/* inode number allocated */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	struct xfs_inode	*pip,	/* parent inode (directory) */
+	umode_t			mode,	/* mode bits for new inode */
+	struct xfs_buf		**agbp,	/* buf for a.g. inode header */
+	xfs_ino_t		*inop);	/* inode number allocated */
 
 /*
  * Free disk inode.  Carefully avoids touching the incore inode, all
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 815efd73efa7..7d29b995f2dc 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -380,8 +380,7 @@ xfs_ialloc(
 	 * Call the space management code to pick
 	 * the on-disk inode to be allocated.
 	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
-			    ialloc_context, &ino);
+	error = xfs_dialloc(tp, pip, args->mode, ialloc_context, &ino);
 	if (error)
 		return error;
 	if (*ialloc_context || ino == NULLFSINO) {
