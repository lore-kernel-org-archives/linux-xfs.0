Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29DAA7FA5
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:23:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E79BC8F804C
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:23:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HajJoHzpxWQssrkr for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:23:36 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiDE-00017a-Ly
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiDE-000676-6r
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 27/27] xfs: fix issues that cause userspace warnings
Date: Wed, 12 Jun 2013 20:22:47 +1000
Message-Id: <1371032567-21772-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-1-git-send-email-david@fromorbit.com>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_attr_remote.c |    8 ++++----
 fs/xfs/xfs_bmap.c        |    3 ---
 fs/xfs/xfs_da_btree.c    |    6 +++---
 fs/xfs/xfs_dir2_node.c   |    2 ++
 fs/xfs/xfs_ialloc.c      |    2 +-
 fs/xfs/xfs_rtalloc.c     |    4 ++--
 6 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index fed6d78..b8ab302 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -238,7 +238,7 @@ xfs_attr_rmtval_copyout(
 	xfs_ino_t	ino,
 	int		*offset,
 	int		*valuelen,
-	char		**dst)
+	__uint8_t	**dst)
 {
 	char		*src = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
@@ -285,7 +285,7 @@ xfs_attr_rmtval_copyin(
 	xfs_ino_t	ino,
 	int		*offset,
 	int		*valuelen,
-	char		**src)
+	__uint8_t	**src)
 {
 	char		*dst = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
@@ -338,7 +338,7 @@ xfs_attr_rmtval_get(
 	struct xfs_mount	*mp = args->dp->i_mount;
 	struct xfs_buf		*bp;
 	xfs_dablk_t		lblkno = args->rmtblkno;
-	char			*dst = args->value;
+	__uint8_t		*dst = args->value;
 	int			valuelen = args->valuelen;
 	int			nmap;
 	int			error;
@@ -402,7 +402,7 @@ xfs_attr_rmtval_set(
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
 	xfs_fileoff_t		lfileoff = 0;
-	char			*src = args->value;
+	__uint8_t		*src = args->value;
 	int			blkcnt;
 	int			valuelen;
 	int			nmap;
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index fa90247..f2df130 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4647,12 +4647,9 @@ __xfs_bmapi_allocate(
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
index 0b8b2a1..a7319b1 100644
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
index 7b448f5..9359209 100644
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
index 319d9e4..9831eff 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1342,7 +1342,7 @@ xfs_imap(
 	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
 	int		error;	/* error code */
 	int		offset;	/* index of inode in its buffer */
-	int		offset_agbno;	/* blks from chunk start to inode */
+	xfs_agino_t	offset_agbno;	/* blks from chunk start to inode */
 
 	ASSERT(ino != NULLFSINO);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 98dc670..c9a9a42 100644
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
