Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9CD257FDA
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D7C7AC005
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XIyHmxqr5F6An38b for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:07 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQE-0001CM-5e
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:58 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006o5-V3
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/22] libxfs: fix compile warnings
Date: Wed, 12 Jun 2013 20:36:34 +1000
Message-Id: <1371033394-26006-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1371033394-26006-1-git-send-email-david@fromorbit.com>
References: <1371033394-26006-1-git-send-email-david@fromorbit.com>
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
 copy/xfs_copy.c          |   12 ++++++++++--
 db/bmroot.c              |    6 +++---
 libxfs/xfs.h             |    8 +++++++-
 libxfs/xfs_attr_remote.c |    8 ++++----
 libxfs/xfs_bmap.c        |    3 ---
 libxfs/xfs_da_btree.c    |    6 +++---
 libxfs/xfs_dir2_node.c   |    2 ++
 libxfs/xfs_ialloc.c      |    2 +-
 libxfs/xfs_rtalloc.c     |    4 ++--
 repair/attr_repair.c     |    2 ++
 repair/incore_ino.c      |    2 ++
 repair/scan.c            |    1 +
 12 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 39517da..bb37279 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -434,6 +434,10 @@ read_ag_header(int fd, xfs_agnumber_t agno, wbuf *buf, ag_header_t *ag,
 	off = XFS_AG_DADDR(mp, agno, XFS_SB_DADDR);
 	buf->position = (xfs_off_t) off * (xfs_off_t) BBSIZE;
 	length = buf->length = first_agbno * blocksize;
+	if (length == 0) {
+		do_log(_("ag header buffer invalid!\n"));
+		exit(1);
+	}
 
 	/* handle alignment stuff */
 
@@ -449,7 +453,6 @@ read_ag_header(int fd, xfs_agnumber_t agno, wbuf *buf, ag_header_t *ag,
 	if (buf->length % buf->min_io_size != 0)
 		buf->length = roundup(buf->length, buf->min_io_size);
 
-	ASSERT(length != 0);
 	read_wbuf(fd, buf, mp);
 	ASSERT(buf->length >= length);
 
@@ -936,7 +939,12 @@ main(int argc, char **argv)
 		for (;;) {
 			/* none of this touches the w_buf buffer */
 
-			ASSERT(current_level < btree_levels);
+			if (current_level >= btree_levels) {
+				do_log(
+			_("Error: current level %d >= btree levels %d\n"),
+					current_level, btree_levels);
+				exit(1);
+			}
 
 			current_level++;
 
diff --git a/db/bmroot.c b/db/bmroot.c
index 3e18917..12b129e 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -91,13 +91,13 @@ bmroota_key_offset(
 	int			idx)
 {
 	xfs_bmdr_block_t	*block;
-	/* REFERENCED */
-	xfs_dinode_t		*dip;
+#ifdef DEBUG
+	xfs_dinode_t		*dip = obj;
+#endif
 	xfs_bmdr_key_t		*kp;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
 	block = (xfs_bmdr_block_t *)((char *)obj + byteize(startoff));
 	ASSERT(XFS_DFORK_Q(dip) && (char *)block == XFS_DFORK_APTR(dip));
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 8391dc8..acf5895 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -191,7 +191,9 @@ roundup_pow_of_two(uint v)
 /* avoid gcc warning */
 #define xfs_incore(bt,blkno,len,lockit)	({		\
 	typeof(blkno) __foo = (blkno);			\
+	typeof(len) __bar = (len);			\
 	(blkno) = __foo;				\
+	(len) = __bar; /* no set-but-unused warning */	\
 	NULL;						\
 })
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
@@ -265,7 +267,11 @@ roundup_pow_of_two(uint v)
 #define	xfs_trans_agblocks_delta(tp, d)
 #define	xfs_trans_agflist_delta(tp, d)
 #define	xfs_trans_agbtree_delta(tp, d)
-#define xfs_trans_buf_set_type(tp, bp, t)
+#define xfs_trans_buf_set_type(tp, bp, t)	({	\
+	int __t = (t);					\
+	__t = __t; /* no set-but-unused warning */	\
+})
+
 #define xfs_trans_buf_copy_type(dbp, sbp)
 
 #define xfs_buf_readahead(a,b,c,ops)		((void) 0)	/* no readahead */
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 0b2ca8c..59bb12d 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -214,7 +214,7 @@ xfs_attr_rmtval_copyout(
 	xfs_ino_t	ino,
 	int		*offset,
 	int		*valuelen,
-	char		**dst)
+	__uint8_t	**dst)
 {
 	char		*src = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
@@ -261,7 +261,7 @@ xfs_attr_rmtval_copyin(
 	xfs_ino_t	ino,
 	int		*offset,
 	int		*valuelen,
-	char		**src)
+	__uint8_t	**src)
 {
 	char		*dst = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
@@ -314,7 +314,7 @@ xfs_attr_rmtval_get(
 	struct xfs_mount	*mp = args->dp->i_mount;
 	struct xfs_buf		*bp;
 	xfs_dablk_t		lblkno = args->rmtblkno;
-	char			*dst = args->value;
+	__uint8_t		*dst = args->value;
 	int			valuelen = args->valuelen;
 	int			nmap;
 	int			error;
@@ -378,7 +378,7 @@ xfs_attr_rmtval_set(
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
 	xfs_fileoff_t		lfileoff = 0;
-	char			*src = args->value;
+	__uint8_t		*src = args->value;
 	int			blkcnt;
 	int			valuelen;
 	int			nmap;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1c0939b..ce72b87 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4426,12 +4426,9 @@ xfs_bmapi_allocate(
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
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index d7798af..b7b6705 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -376,7 +376,7 @@ xfs_da3_split(
 	struct xfs_da_intnode	*node;
 	struct xfs_buf		*bp;
 	int			max;
-	int			action;
+	int			action = 0;
 	int			error;
 	int			i;
 
@@ -2431,9 +2431,9 @@ static int
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
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 222f08c..d2bd249 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -295,11 +295,13 @@ xfs_dir2_free_log_header(
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
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index bbdaf3f..ce32dfa 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1320,7 +1320,7 @@ xfs_imap(
 	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
 	int		error;	/* error code */
 	int		offset;	/* index of inode in its buffer */
-	int		offset_agbno;	/* blks from chunk start to inode */
+	xfs_agino_t	offset_agbno;	/* blks from chunk start to inode */
 
 	ASSERT(ino != NULLFSINO);
 
diff --git a/libxfs/xfs_rtalloc.c b/libxfs/xfs_rtalloc.c
index 1de85fd..9797db7 100644
--- a/libxfs/xfs_rtalloc.c
+++ b/libxfs/xfs_rtalloc.c
@@ -431,8 +431,8 @@ xfs_rtfree_range(
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
 	int		error;		/* error value */
-	xfs_rtblock_t	postblock;	/* first block freed > end */
-	xfs_rtblock_t	preblock;	/* first block freed < start */
+	xfs_rtblock_t	postblock = 0;	/* first block freed > end */
+	xfs_rtblock_t	preblock = 0;	/* first block freed < start */
 
 	end = start + len - 1;
 	/*
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index d42b85f..ba85fd9 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1631,9 +1631,11 @@ process_attributes(
 {
 	int		err;
 	__u8		aformat = dip->di_aformat;
+#ifdef DEBUG
 	xfs_attr_shortform_t *asf;
 
 	asf = (xfs_attr_shortform_t *) XFS_DFORK_APTR(dip);
+#endif
 
 	if (aformat == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(be16_to_cpu(asf->hdr.totsize) <=
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 2a40727..158cf3a 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -167,6 +167,7 @@ __uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
 	default:
 		ASSERT(0);
 	}
+	return 0;
 }
 
 void set_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset,
@@ -207,6 +208,7 @@ __uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
 	default:
 		ASSERT(0);
 	}
+	return 0;
 }
 
 /*
diff --git a/repair/scan.c b/repair/scan.c
index d58d55a..e76ce47 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -520,6 +520,7 @@ scan_allocbt(
 		name = "cnt";
 		break;
 	default:
+		name = "(unknown)";
 		assert(0);
 		break;
 	}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
