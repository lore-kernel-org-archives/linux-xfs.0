Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16CF87F61
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:51:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8ABB0AC001
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:51:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9KPq9Kb3FC8UETQs for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:51:01 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YH-5B
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00062I-4G
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 23/50] xfs: fix issues that cause
	userspace warnings
Date: Mon, 12 Aug 2013 20:49:44 +1000
Message-Id: <1376304611-22994-24-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

Some of the code shared with userspace causes compilation warnings
from things turned off in the kernel code, such as differences in
variable signedness. Fix those issues.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_attr_remote.c | 8 ++++----
 fs/xfs/xfs_bmap.c        | 3 ---
 fs/xfs/xfs_da_btree.c    | 6 +++---
 fs/xfs/xfs_dir2_node.c   | 2 ++
 fs/xfs/xfs_ialloc.c      | 2 +-
 fs/xfs/xfs_rtalloc.c     | 4 ++--
 6 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index b42926a..712a502 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -239,7 +239,7 @@ xfs_attr_rmtval_copyout(
 	xfs_ino_t	ino,
 	int		*offset,
 	int		*valuelen,
-	char		**dst)
+	__uint8_t	**dst)
 {
 	char		*src = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
@@ -286,7 +286,7 @@ xfs_attr_rmtval_copyin(
 	xfs_ino_t	ino,
 	int		*offset,
 	int		*valuelen,
-	char		**src)
+	__uint8_t	**src)
 {
 	char		*dst = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
@@ -339,7 +339,7 @@ xfs_attr_rmtval_get(
 	struct xfs_mount	*mp = args->dp->i_mount;
 	struct xfs_buf		*bp;
 	xfs_dablk_t		lblkno = args->rmtblkno;
-	char			*dst = args->value;
+	__uint8_t		*dst = args->value;
 	int			valuelen = args->valuelen;
 	int			nmap;
 	int			error;
@@ -403,7 +403,7 @@ xfs_attr_rmtval_set(
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
 	xfs_fileoff_t		lfileoff = 0;
-	char			*src = args->value;
+	__uint8_t		*src = args->value;
 	int			blkcnt;
 	int			valuelen;
 	int			nmap;
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 1f09faf..a9331a6 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4258,12 +4258,9 @@ __xfs_bmapi_allocate(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
-	int			rt;
 
 	ASSERT(bma->length > 0);
 
-	rt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(bma->ip);
-
 	/*
 	 * For the wasdelay case, we could also just allocate the stuff asked
 	 * for in this bmap call but that wouldn't be as good.
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 8bbd7ef..d4e59a4 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -399,7 +399,7 @@ xfs_da3_split(
 	struct xfs_da_intnode	*node;
 	struct xfs_buf		*bp;
 	int			max;
-	int			action;
+	int			action = 0;
 	int			error;
 	int			i;
 
@@ -2454,9 +2454,9 @@ static int
 xfs_buf_map_from_irec(
 	struct xfs_mount	*mp,
 	struct xfs_buf_map	**mapp,
-	unsigned int		*nmaps,
+	int			*nmaps,
 	struct xfs_bmbt_irec	*irecs,
-	unsigned int		nirecs)
+	int			nirecs)
 {
 	struct xfs_buf_map	*map;
 	int			i;
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index b4bd9b6..18e287d 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -313,11 +313,13 @@ xfs_dir2_free_log_header(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp)
 {
+#ifdef DEBUG
 	xfs_dir2_free_t		*free;		/* freespace structure */
 
 	free = bp->b_addr;
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
+#endif
 	xfs_trans_log_buf(tp, bp, 0, xfs_dir3_free_hdr_size(tp->t_mountp) - 1);
 }
 
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index bd4e2a7..266024b 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1342,7 +1342,7 @@ xfs_imap(
 	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
 	int		error;	/* error code */
 	int		offset;	/* index of inode in its buffer */
-	int		offset_agbno;	/* blks from chunk start to inode */
+	xfs_agblock_t	offset_agbno;	/* blks from chunk start to inode */
 
 	ASSERT(ino != NULLFSINO);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 084caa8..7a445e6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -736,8 +736,8 @@ xfs_rtallocate_range(
 {
 	xfs_rtblock_t	end;		/* end of the allocated extent */
 	int		error;		/* error value */
-	xfs_rtblock_t	postblock;	/* first block allocated > end */
-	xfs_rtblock_t	preblock;	/* first block allocated < start */
+	xfs_rtblock_t	postblock = 0;	/* first block allocated > end */
+	xfs_rtblock_t	preblock = 0;	/* first block allocated < start */
 
 	end = start + len - 1;
 	/*
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
