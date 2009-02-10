Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUHCe073497 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB888105D6C
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hBPTTbcc0smT5gXu for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:41 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEj-0005pO-Hv
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:41 +0000
Message-Id: <20090210202941.455393000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/13] xfs: add version 3 inode format with CRCs
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-inode-crc
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add a new inode version with a larger core.  The primary objective is
to allow for a crc of the inode, and location information (uuid and ino)
to verify it was written in the right place.  We also extend it by
a creation time (for Samba) and a changecount (for NFSv4) and some
additional padding.  These additional fields are not implemented yet,
but already layed out in the structure.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2009-02-10 19:45:50.921943721 +0100
+++ xfs/fs/xfs/xfs_inode.h	2009-02-10 19:45:59.186069347 +0100
@@ -152,6 +152,11 @@ typedef struct xfs_icdinode {
 	__uint32_t	di_gen;		/* generation number */
 } xfs_icdinode_t;
 
+static inline uint xfs_icdinode_size(struct xfs_icdinode *dicp)
+{
+	return sizeof(struct xfs_icdinode);
+}
+
 /*
  * Flags for xfs_ichgtime().
  */
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2009-02-10 19:16:18.696943663 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2009-02-10 19:45:59.190098211 +0100
@@ -281,7 +281,7 @@ xfs_inode_item_format(
 	xfs_mark_inode_dirty_sync(ip);
 
 	vecp->i_addr = (xfs_caddr_t)&ip->i_d;
-	vecp->i_len  = sizeof(struct xfs_icdinode);
+	vecp->i_len  = xfs_icdinode_size(&ip->i_d);
 	XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_ICORE);
 	vecp++;
 	nvecs++;
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-10 19:45:54.105069313 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-10 19:46:08.354069897 +0100
@@ -2325,6 +2325,7 @@ xlog_recover_do_inode_trans(
 	int			attr_index;
 	uint			fields;
 	xfs_icdinode_t		*dicp;
+	uint			isize;
 	int			need_free = 0;
 
 	if (pass == XLOG_RECOVER_PASS1) {
@@ -2459,7 +2460,9 @@ xlog_recover_do_inode_trans(
 		error = EFSCORRUPTED;
 		goto error;
 	}
-	if (unlikely(item->ri_buf[1].i_len > sizeof(struct xfs_icdinode))) {
+
+	isize = xfs_icdinode_size(dicp);
+	if (unlikely(item->ri_buf[1].i_len > isize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_do_inode_trans(7)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
 		xfs_buf_relse(bp);
@@ -2471,13 +2474,13 @@ xlog_recover_do_inode_trans(
 	}
 
 	/* The core is in in-core format */
-	xfs_dinode_to_disk(dip, (xfs_icdinode_t *)item->ri_buf[1].i_addr);
+	xfs_dinode_to_disk(dip, dicp);
 
 	/* the rest is in on-disk format */
-	if (item->ri_buf[1].i_len > sizeof(struct xfs_icdinode)) {
-		memcpy((xfs_caddr_t) dip + sizeof(struct xfs_icdinode),
-			item->ri_buf[1].i_addr + sizeof(struct xfs_icdinode),
-			item->ri_buf[1].i_len  - sizeof(struct xfs_icdinode));
+	if (item->ri_buf[1].i_len > isize) {
+		memcpy((xfs_caddr_t) dip + isize,
+			item->ri_buf[1].i_addr + isize,
+			item->ri_buf[1].i_len  - isize);
 	}
 
 	fields = in_f->ilf_fields;
@@ -2561,6 +2564,15 @@ xlog_recover_do_inode_trans(
 	}
 
 write_inode_buffer:
+	/* re-generate the checksum. */
+	if (dip->di_version == 3) {
+		__uint32_t	crc;
+
+		crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
+				      offsetof(struct xfs_dinode, di_crc));
+		dip->di_crc = xfs_end_cksum(crc);
+	}
+
 	if (ITEM_TYPE(item) == XFS_LI_INODE) {
 		ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
 		bp->b_mount = mp;
Index: xfs/fs/xfs/xfs_dinode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dinode.h	2009-02-10 19:45:51.939069576 +0100
+++ xfs/fs/xfs/xfs_dinode.h	2009-02-10 19:45:59.195068745 +0100
@@ -19,7 +19,7 @@
 #define	__XFS_DINODE_H__
 
 #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
-#define XFS_DINODE_GOOD_VERSION(v)	(((v) == 1 || (v) == 2))
+#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
 
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
@@ -69,11 +69,32 @@ typedef struct xfs_dinode {
 
 	/* di_next_unlinked is the only non-core field in the old dinode */
 	__be32		di_next_unlinked;/* agi unlinked list ptr */
-} __attribute__((packed)) xfs_dinode_t;
+
+	/* start of the extended dinode, writable fields */
+	__be32		di_crc;		/* CRC of the inode */
+	__be64		di_changecount;	/* number of attribute changes */
+	__u8		di_pad2[16];	/* more padding for future expansion */
+
+	/* fields only written to during inode creation */
+	xfs_timestamp_t	di_crtime;	/* time created */
+	__be64		di_ino;		/* inode number */
+	uuid_t		di_uuid;	/* UUID of the filesystem */
+} xfs_dinode_t;
 
 #define DI_MAX_FLUSH 0xffff
 
 /*
+ * Size of the core inode on disk.  Version 1 and 2 inodes have
+ * the same size, but version 3 has grown a few additional fields.
+ */
+static inline uint xfs_dinode_size(int version)
+{
+	if (version == 3)
+		return sizeof(struct xfs_dinode);
+	return offsetof(struct xfs_dinode, di_crc);
+}
+
+/*
  * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
  * Since the pathconf interface is signed, we use 2^31 - 1 instead.
  * The old inode format had a 16 bit link count, so its maximum is USHRT_MAX.
@@ -104,7 +125,7 @@ typedef enum xfs_dinode_fmt {
  * Inode size for given fs.
  */
 #define XFS_LITINO(version, mp) \
-	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
+	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
 
 #define XFS_BROOT_SIZE_ADJ(ip) \
 	(XFS_BMBT_BLOCK_LEN((ip)->i_mount) - sizeof(xfs_bmdr_block_t))
@@ -132,7 +153,7 @@ typedef enum xfs_dinode_fmt {
  * Return pointers to the data or attribute forks.
  */
 #define XFS_DFORK_DPTR(dip) \
-	((char *)(dip) + sizeof(struct xfs_dinode))
+	((char *)dip + xfs_dinode_size(dip->di_version))
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-02-10 19:45:53.408069901 +0100
+++ xfs/fs/xfs/xfs_ialloc.c	2009-02-10 19:46:08.351069375 +0100
@@ -163,6 +163,7 @@ xfs_ialloc_ag_alloc(
 	xfs_buf_t	*agbp,		/* alloc group buffer */
 	int		*alloc)
 {
+	xfs_mount_t	*mp = tp->t_mountp;
 	xfs_agi_t	*agi;		/* allocation group header */
 	xfs_alloc_arg_t	args;		/* allocation argument structure */
 	int		blks_per_cluster;  /* fs blocks per inode cluster */
@@ -191,11 +192,10 @@ xfs_ialloc_ag_alloc(
 	 * Locking will ensure that we don't have two callers in here
 	 * at one time.
 	 */
-	newlen = XFS_IALLOC_INODES(args.mp);
-	if (args.mp->m_maxicount &&
-	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
+	newlen = XFS_IALLOC_INODES(mp);
+	if (mp->m_maxicount && mp->m_sb.sb_icount + newlen > mp->m_maxicount)
 		return XFS_ERROR(ENOSPC);
-	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(args.mp);
+	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(mp);
 	/*
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
@@ -203,12 +203,13 @@ xfs_ialloc_ag_alloc(
  	 */
 	agi = XFS_BUF_TO_AGI(agbp);
 	newino = be32_to_cpu(agi->agi_newino);
-	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
-			XFS_IALLOC_BLOCKS(args.mp);
+	agno = be32_to_cpu(agi->agi_seqno);
+
+	args.agbno = XFS_AGINO_TO_AGBNO(mp, newino) + XFS_IALLOC_BLOCKS(mp);
+
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(mp, agno, args.agbno);
 		args.type = XFS_ALLOCTYPE_THIS_BNO;
 		args.mod = args.total = args.wasdel = args.isfl =
 			args.userdata = args.minalignslop = 0;
@@ -231,7 +232,7 @@ xfs_ialloc_ag_alloc(
 		args.minalignslop = xfs_ialloc_cluster_alignment(&args) - 1;
 
 		/* Allow space for the inode btree to split. */
-		args.minleft = args.mp->m_in_maxlevels - 1;
+		args.minleft = mp->m_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	} else
@@ -247,9 +248,9 @@ xfs_ialloc_ag_alloc(
 		 * pieces, so don't need alignment anyway.
 		 */
 		isaligned = 0;
-		if (args.mp->m_sinoalign) {
-			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
-			args.alignment = args.mp->m_dalign;
+		if (mp->m_sinoalign) {
+			ASSERT(!(mp->m_flags & XFS_MOUNT_NOALIGN));
+			args.alignment = mp->m_dalign;
 			isaligned = 1;
 		} else
 			args.alignment = xfs_ialloc_cluster_alignment(&args);
@@ -259,8 +260,7 @@ xfs_ialloc_ag_alloc(
 		 * For now, just allocate blocks up front.
 		 */
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(mp, agno, args.agbno);
 		/*
 		 * Allocate a fixed-size extent of inodes.
 		 */
@@ -271,7 +271,7 @@ xfs_ialloc_ag_alloc(
 		/*
 		 * Allow space for the inode btree to split.
 		 */
-		args.minleft = args.mp->m_in_maxlevels - 1;
+		args.minleft = mp->m_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
@@ -283,8 +283,7 @@ xfs_ialloc_ag_alloc(
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(mp, agno, args.agbno);
 		args.alignment = xfs_ialloc_cluster_alignment(&args);
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
@@ -298,21 +297,21 @@ xfs_ialloc_ag_alloc(
 	/*
 	 * Convert the results.
 	 */
-	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
+	newino = XFS_OFFBNO_TO_AGINO(mp, args.agbno, 0);
 	/*
 	 * Loop over the new block(s), filling in the inodes.
 	 * For small block sizes, manipulate the inodes in buffers
 	 * which are multiples of the blocks size.
 	 */
-	if (args.mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(args.mp)) {
+	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
 		blks_per_cluster = 1;
 		nbufs = (int)args.len;
-		ninodes = args.mp->m_sb.sb_inopblock;
+		ninodes = mp->m_sb.sb_inopblock;
 	} else {
-		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(args.mp) /
-				   args.mp->m_sb.sb_blocksize;
+		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
+				   mp->m_sb.sb_blocksize;
 		nbufs = (int)args.len / blks_per_cluster;
-		ninodes = blks_per_cluster * args.mp->m_sb.sb_inopblock;
+		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
 	}
 	/*
 	 * Figure out what version number to use in the inodes we create.
@@ -321,7 +320,9 @@ xfs_ialloc_ag_alloc(
 	 * use the old version so that old kernels will continue to be
 	 * able to use the file system.
 	 */
-	if (xfs_sb_version_hasnlink(&args.mp->m_sb))
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		version = 3;
+	else if (xfs_sb_version_hasnlink(&mp->m_sb))
 		version = 2;
 	else
 		version = 1;
@@ -335,13 +336,15 @@ xfs_ialloc_ag_alloc(
 	 */
 	gen = random32();
 	for (j = 0; j < nbufs; j++) {
+		xfs_agblock_t agbno;
+
 		/*
 		 * Get the block.
 		 */
-		d = XFS_AGB_TO_DADDR(args.mp, be32_to_cpu(agi->agi_seqno),
-				     args.agbno + (j * blks_per_cluster));
-		fbuf = xfs_trans_get_buf(tp, args.mp->m_ddev_targp, d,
-					 args.mp->m_bsize * blks_per_cluster,
+		agbno = args.agbno + (j * blks_per_cluster);
+		d = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+					 mp->m_bsize * blks_per_cluster,
 					 XFS_BUF_LOCK);
 		ASSERT(fbuf);
 		ASSERT(!XFS_BUF_GETERROR(fbuf));
@@ -353,31 +356,44 @@ xfs_ialloc_ag_alloc(
 		 *      log a whole cluster of inodes instead of all the indivdual
 		 *      transactions causing a lot of log traffic.
 		 */
-		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
+		xfs_biozero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
-			int	ioffset = i << args.mp->m_sb.sb_inodelog;
-			uint	isize = sizeof(struct xfs_dinode);
+			int	ioffset = i << mp->m_sb.sb_inodelog;
+			uint	isize = xfs_dinode_size(version);
 
-			free = xfs_make_iptr(args.mp, fbuf, i);
+			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 			free->di_version = version;
 			free->di_gen = cpu_to_be32(gen);
 			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
+
+			if (version == 3) {
+				__uint32_t	crc;
+
+				free->di_ino = cpu_to_be64(
+					XFS_AGINO_TO_INO(mp, agno,
+						XFS_OFFBNO_TO_AGINO(mp, agbno, i)));
+				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
+
+				crc = xfs_start_cksum((char *)free,
+					mp->m_sb.sb_inodesize,
+					offsetof(struct xfs_dinode, di_crc));
+				free->di_crc = xfs_end_cksum(crc);
+			}
 			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
 		}
 		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
-	agno = be32_to_cpu(agi->agi_seqno);
-	down_read(&args.mp->m_peraglock);
-	args.mp->m_perag[agno].pagi_freecount += newlen;
-	up_read(&args.mp->m_peraglock);
+	down_read(&mp->m_peraglock);
+	mp->m_perag[agno].pagi_freecount += newlen;
+	up_read(&mp->m_peraglock);
 	agi->agi_newino = cpu_to_be32(newino);
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */
-	cur = xfs_inobt_init_cursor(args.mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
 	for (thisino = newino;
 	     thisino < newino + newlen;
 	     thisino += XFS_INODES_PER_CHUNK) {
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2009-02-10 19:46:02.110944088 +0100
+++ xfs/fs/xfs/xfs_inode.c	2009-02-10 19:46:08.309069135 +0100
@@ -52,6 +52,7 @@
 #include "xfs_acl.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
+#include "xfs_cksum.h"
 
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
@@ -827,6 +828,23 @@ xfs_iread(
 	 * Otherwise, just get the truly permanent information.
 	 */
 	if (dip->di_mode) {
+		/* validate the checksum. */
+		if (dip->di_version == 3) {
+			if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+					      offsetof(struct xfs_dinode, di_crc)) ||
+		    	    !uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid) ||
+			    be64_to_cpu(dip->di_ino) != ip->i_ino) {
+				xfs_fs_cmn_err(CE_ALERT, mp,
+	"xfs_iread: checksum validation failed for inode %lld", ip->i_ino);
+
+				XFS_CORRUPTION_ERROR("xfs_iread crc",
+						     XFS_ERRLEVEL_LOW,
+						     mp, dip);
+				error = XFS_ERROR(EFSCORRUPTED);
+				goto out_brelse;
+			}
+		}
+
 		xfs_dinode_from_disk(&ip->i_d, dip);
 		error = xfs_iformat(ip, dip);
 		if (error)  {
@@ -3171,6 +3189,15 @@ xfs_iflush_int(
 		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK, bp);
 	xfs_inobp_check(mp, bp);
 
+	/* generate the checksum. */
+	if (dip->di_version == 3) {
+		__uint32_t	crc;
+
+		crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
+				      offsetof(struct xfs_dinode, di_crc));
+		dip->di_crc = xfs_end_cksum(crc);
+	}
+
 	/*
 	 * We've recorded everything logged in the inode, so we'd
 	 * like to clear the ilf_fields bits so we don't log and

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
