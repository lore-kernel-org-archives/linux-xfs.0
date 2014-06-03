Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D66507F62
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:18:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B69B630404E
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:18:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id bVUlBrDacXCXg68i (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 02:18:14 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s539ICKc027891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:13 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539ICmW014118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:12 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539IChm014113 for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:12 GMT
Message-ID: <538D92D0.4060806@oracle.com>
Date: Tue, 03 Jun 2014 17:18:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 03/10] xfs: consolidate xfs_inumbers
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Consolidate xfs_inumbers() to make the formatter function return correct
error and make the source code looks a bit neat.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ioctl32.c |  4 +--
 fs/xfs/xfs_itable.c  | 71 ++++++++++++++++++++++++----------------------------
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 944d5ba..8080a2e 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -102,7 +102,7 @@ xfs_compat_growfs_rt_copyin(
 STATIC int
 xfs_inumbers_fmt_compat(
 	void			__user *ubuffer,
-	const xfs_inogrp_t	*buffer,
+	const struct xfs_inogrp	*buffer,
 	long			count,
 	long			*written)
 {
@@ -113,7 +113,7 @@ xfs_inumbers_fmt_compat(
 		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
 		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
 		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
-			return -XFS_ERROR(EFAULT);
+			return XFS_ERROR(EFAULT);
 	}
 	*written = count * sizeof(*p32);
 	return 0;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 4d62e63..dd68696 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -512,12 +512,12 @@ xfs_bulkstat(
 int
 xfs_inumbers_fmt(
 	void			__user *ubuffer, /* buffer to write to */
-	const xfs_inogrp_t	*buffer,	/* buffer to read from */
+	const struct xfs_inogrp	*buffer,	/* buffer to read from */
 	long			count,		/* # of elements to read */
 	long			*written)	/* # of bytes written */
 {
 	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
-		return -EFAULT;
+		return XFS_ERROR(EFAULT);
 	*written = count * sizeof(*buffer);
 	return 0;
 }
@@ -527,37 +527,33 @@ xfs_inumbers_fmt(
  */
 int					/* error status */
 xfs_inumbers(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	*lastino,	/* last inode returned */
-	int		*count,		/* size of buffer/count returned */
-	void		__user *ubuffer,/* buffer with inode descriptions */
-	inumbers_fmt_pf	formatter)
+	struct xfs_mount	*mp,/* mount point for filesystem */
+	xfs_ino_t		*lastino,/* last inode returned */
+	int			*count,/* size of buffer/count returned */
+	void			__user *ubuffer,/* buffer with inode descriptions */
+	inumbers_fmt_pf		formatter)
 {
-	xfs_buf_t	*agbp;
-	xfs_agino_t	agino;
-	xfs_agnumber_t	agno;
-	int		bcount;
-	xfs_inogrp_t	*buffer;
-	int		bufidx;
-	xfs_btree_cur_t	*cur;
-	int		error;
-	xfs_inobt_rec_incore_t r;
-	int		i;
-	xfs_ino_t	ino;
-	int		left;
-	int		tmp;
-
-	ino = (xfs_ino_t)*lastino;
-	agno = XFS_INO_TO_AGNO(mp, ino);
-	agino = XFS_INO_TO_AGINO(mp, ino);
-	left = *count;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, *lastino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, *lastino);
+	struct xfs_btree_cur	*cur = NULL;
+	xfs_buf_t		*agbp = NULL;
+	struct xfs_inogrp	*buffer;
+	int			bcount;
+	int			left = *count;
+	int			bufidx = 0;
+	int			error = 0;
+
 	*count = 0;
+	if (agno >= mp->m_sb.sb_agcount ||
+	    *lastino != XFS_AGINO_TO_INO(mp, agno, agino))
+		return error;
+
 	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
 	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
-	error = bufidx = 0;
-	cur = NULL;
-	agbp = NULL;
 	while (left > 0 && agno < mp->m_sb.sb_agcount) {
+		struct xfs_inobt_rec_incore	r;
+		int				stat;
+
 		if (agbp == NULL) {
 			error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
 			if (error) {
@@ -574,7 +570,7 @@ xfs_inumbers(
 			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
 						    XFS_BTNUM_INO);
 			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
-						 &tmp);
+						 &stat);
 			if (error) {
 				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 				cur = NULL;
@@ -589,8 +585,8 @@ xfs_inumbers(
 				continue;
 			}
 		}
-		error = xfs_inobt_get_rec(cur, &r, &i);
-		if (error || i == 0) {
+		error = xfs_inobt_get_rec(cur, &r, &stat);
+		if (error || stat == 0) {
 			xfs_buf_relse(agbp);
 			agbp = NULL;
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
@@ -609,16 +605,15 @@ xfs_inumbers(
 		left--;
 		if (bufidx == bcount) {
 			long written;
-			if (formatter(ubuffer, buffer, bufidx, &written)) {
-				error = XFS_ERROR(EFAULT);
+			error = formatter(ubuffer, buffer, bufidx, &written);
+			if (error)
 				break;
-			}
 			ubuffer += written;
 			*count += bufidx;
 			bufidx = 0;
 		}
 		if (left) {
-			error = xfs_btree_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &stat);
 			if (error) {
 				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 				cur = NULL;
@@ -636,9 +631,9 @@ xfs_inumbers(
 	if (!error) {
 		if (bufidx) {
 			long written;
-			if (formatter(ubuffer, buffer, bufidx, &written))
-				error = XFS_ERROR(EFAULT);
-			else
+
+			error = formatter(ubuffer, buffer, bufidx, &written);
+			if (!error)
 				*count += bufidx;
 		}
 		*lastino = XFS_AGINO_TO_INO(mp, agno, agino);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
