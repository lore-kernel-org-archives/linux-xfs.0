Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77CF57FB6
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 00:11:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6740E304081
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 22:11:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	smkFklHxa50DH29z for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 22:11:52 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UNFzC-0000LS-Bw
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:50 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UNFz7-0005BO-7N
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/22] xfs: add CRC checks to remote symlinks
Date: Wed,  3 Apr 2013 16:11:19 +1100
Message-Id: <1364965892-19623-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1364965892-19623-1-git-send-email-david@fromorbit.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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

Add a header to the remote symlink block, containing location and
owner information, as well as CRCs and LSN fields. This requires
verifiers to be added to the remote symlink buffers for CRC enabled
filesystems.

This also fixes a bug reading multiple block symlinks, where the second block
overwrites the first block when copying out the link name.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.h    |    4 +-
 fs/xfs/xfs_log_recover.c |    9 ++
 fs/xfs/xfs_symlink.c     |  279 +++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_symlink.h     |   34 +++++-
 4 files changed, 283 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index abae8c8..09cab4e 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,6 +49,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 #define XFS_BLF_AGFL_BUF	(1<<7)
 #define XFS_BLF_AGI_BUF		(1<<8)
 #define XFS_BLF_DINO_BUF	(1<<9)
+#define XFS_BLF_SYMLINK_BUF	(1<<10)
 
 #define XFS_BLF_TYPE_MASK	\
 		(XFS_BLF_UDQUOT_BUF | \
@@ -58,7 +59,8 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 		 XFS_BLF_AGF_BUF | \
 		 XFS_BLF_AGFL_BUF | \
 		 XFS_BLF_AGI_BUF | \
-		 XFS_BLF_DINO_BUF)
+		 XFS_BLF_DINO_BUF | \
+		 XFS_BLF_SYMLINK_BUF)
 
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2878782..d1292fd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -45,6 +45,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_symlink.h"
 
 STATIC int
 xlog_find_zeroed(
@@ -2002,6 +2003,14 @@ xlog_recover_do_reg_buffer(
 		}
 		bp->b_ops = &xfs_inode_buf_ops;
 		break;
+	case XFS_BLF_SYMLINK_BUF:
+		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_SYMLINK_MAGIC)) {
+			xfs_warn(mp, "Bad symlink block magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_symlink_buf_ops;
+		break;
 	default:
 		break;
 	}
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 7512c96..5f234389 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -43,6 +43,152 @@
 #include "xfs_log_priv.h"
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
+#include "xfs_cksum.h"
+#include "xfs_buf_item.h"
+
+
+/*
+ * Each contiguous block has a header, so it is not just a simple pathlen
+ * to FSB conversion.
+ */
+int
+xfs_symlink_blocks(
+	struct xfs_mount *mp,
+	int		pathlen)
+{
+	int		fsblocks = 0;
+	int		len = pathlen;
+
+	do {
+		fsblocks++;
+		len -= XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+	} while (len > 0);
+
+	ASSERT(fsblocks <= XFS_SYMLINK_MAPS);
+	return fsblocks;
+}
+
+static int
+xfs_symlink_hdr_set(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	uint32_t		offset,
+	uint32_t		size,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return 0;
+
+	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
+	dsl->sl_offset = cpu_to_be32(offset);
+	dsl->sl_bytes = cpu_to_be32(size);
+	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_uuid);
+	dsl->sl_owner = cpu_to_be64(ino);
+	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
+	bp->b_ops = &xfs_symlink_buf_ops;
+
+	return sizeof(struct xfs_dsymlink_hdr);
+}
+
+/*
+ * Checking of the symlink header is split into two parts. the verifier does
+ * CRC, location and bounds checking, the unpacking function checks the path
+ * parameters and owner.
+ */
+bool
+xfs_symlink_hdr_ok(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	uint32_t		offset,
+	uint32_t		size,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dsymlink_hdr *dsl = bp->b_addr;
+
+	if (offset != be32_to_cpu(dsl->sl_offset))
+		return false;
+	if (size != be32_to_cpu(dsl->sl_bytes))
+		return false;
+	if (ino != be64_to_cpu(dsl->sl_owner))
+		return false;
+
+	/* ok */
+	return true;
+}
+
+static bool
+xfs_symlink_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return false;
+	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
+		return false;
+	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_uuid))
+		return false;
+	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
+		return false;
+	if (be32_to_cpu(dsl->sl_offset) +
+				be32_to_cpu(dsl->sl_bytes) >= MAXPATHLEN)
+		return false;
+	if (dsl->sl_owner == 0)
+		return false;
+
+	return true;
+}
+
+static void
+xfs_symlink_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+
+	/* no verification of non-crc buffers */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+				  offsetof(struct xfs_dsymlink_hdr, sl_crc)) ||
+	    !xfs_symlink_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+}
+
+static void
+xfs_symlink_write_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+
+	/* no verification of non-crc buffers */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (!xfs_symlink_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (bip) {
+		struct xfs_dsymlink_hdr *dsl = bp->b_addr;
+		dsl->sl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+	}
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 offsetof(struct xfs_dsymlink_hdr, sl_crc));
+}
+
+const struct xfs_buf_ops xfs_symlink_buf_ops = {
+	.verify_read = xfs_symlink_read_verify,
+	.verify_write = xfs_symlink_write_verify,
+};
 
 void
 xfs_symlink_local_to_remote(
@@ -51,38 +197,60 @@ xfs_symlink_local_to_remote(
 	struct xfs_inode	*ip,
 	struct xfs_ifork	*ifp)
 {
-	/* remote symlink blocks are not verifiable until CRCs come along */
-	bp->b_ops = NULL;
-	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+	struct xfs_mount	*mp = ip->i_mount;
+	char			*buf;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		bp->b_ops = NULL;
+		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+		return;
+	}
+
+	/*
+	 * As this symlink fits in an inode literal area, it must also fit in
+	 * the smallest buffer the filesystem supports.
+	 */
+	ASSERT(BBTOB(bp->b_length) >=
+			ifp->if_bytes + sizeof(struct xfs_dsymlink_hdr));
+
+	bp->b_ops = &xfs_symlink_buf_ops;
+
+	buf = bp->b_addr;
+	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
+	memcpy(buf, ifp->if_u1.if_data, ifp->if_bytes);
 }
 
 /* ----- Kernel only functions below ----- */
-
 STATIC int
 xfs_readlink_bmap(
-	xfs_inode_t	*ip,
-	char		*link)
+	struct xfs_inode	*ip,
+	char			*link)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	int		pathlen = ip->i_d.di_size;
-	int             nmaps = XFS_SYMLINK_MAPS;
-	xfs_bmbt_irec_t mval[XFS_SYMLINK_MAPS];
-	xfs_daddr_t	d;
-	int		byte_cnt;
-	int		n;
-	xfs_buf_t	*bp;
-	int		error = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_buf		*bp;
+	xfs_daddr_t		d;
+	char			*cur_chunk;
+	int			pathlen = ip->i_d.di_size;
+	int			nmaps = XFS_SYMLINK_MAPS;
+	int			byte_cnt;
+	int			n;
+	int			error = 0;
+	int			fsblocks = 0;
+	int			offset;
 
-	error = xfs_bmapi_read(ip, 0, XFS_B_TO_FSB(mp, pathlen), mval, &nmaps,
-			       0);
+	fsblocks = xfs_symlink_blocks(mp, pathlen);
+	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
 	if (error)
 		goto out;
 
+	offset = 0;
 	for (n = 0; n < nmaps; n++) {
 		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0, NULL);
+		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
+				  &xfs_symlink_buf_ops);
 		if (!bp)
 			return XFS_ERROR(ENOMEM);
 		error = bp->b_error;
@@ -91,13 +259,34 @@ xfs_readlink_bmap(
 			xfs_buf_relse(bp);
 			goto out;
 		}
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
 		if (pathlen < byte_cnt)
 			byte_cnt = pathlen;
+
+		cur_chunk = bp->b_addr;
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			if (!xfs_symlink_hdr_ok(mp, ip->i_ino, offset,
+							byte_cnt, bp)) {
+				error = EFSCORRUPTED;
+				xfs_alert(mp,
+"symlink header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
+					offset, byte_cnt, ip->i_ino);
+				xfs_buf_relse(bp);
+				goto out;
+
+			}
+
+			cur_chunk += sizeof(struct xfs_dsymlink_hdr);
+		}
+
+		memcpy(link + offset, bp->b_addr, byte_cnt);
+
 		pathlen -= byte_cnt;
+		offset += byte_cnt;
 
-		memcpy(link, bp->b_addr, byte_cnt);
 		xfs_buf_relse(bp);
 	}
+	ASSERT(pathlen == 0);
 
 	link[ip->i_d.di_size] = '\0';
 	error = 0;
@@ -108,10 +297,10 @@ xfs_readlink_bmap(
 
 int
 xfs_readlink(
-	xfs_inode_t     *ip,
+	struct xfs_inode *ip,
 	char		*link)
 {
-	xfs_mount_t	*mp = ip->i_mount;
+	struct xfs_mount *mp = ip->i_mount;
 	xfs_fsize_t	pathlen;
 	int		error = 0;
 
@@ -150,26 +339,26 @@ xfs_readlink(
 
 int
 xfs_symlink(
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*link_name,
 	const char		*target_path,
 	umode_t			mode,
-	xfs_inode_t		**ipp)
+	struct xfs_inode	**ipp)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t		*tp;
-	xfs_inode_t		*ip;
-	int			error;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
+	struct xfs_inode	*ip = NULL;
+	int			error = 0;
 	int			pathlen;
-	xfs_bmap_free_t		free_list;
+	struct xfs_bmap_free	free_list;
 	xfs_fsblock_t		first_block;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	uint			cancel_flags;
 	int			committed;
 	xfs_fileoff_t		first_fsb;
 	xfs_filblks_t		fs_blocks;
 	int			nmaps;
-	xfs_bmbt_irec_t		mval[XFS_SYMLINK_MAPS];
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
 	xfs_daddr_t		d;
 	const char		*cur_chunk;
 	int			byte_cnt;
@@ -180,9 +369,6 @@ xfs_symlink(
 	uint			resblks;
 
 	*ipp = NULL;
-	error = 0;
-	ip = NULL;
-	tp = NULL;
 
 	trace_xfs_symlink(dp, link_name);
 
@@ -307,6 +493,8 @@ xfs_symlink(
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
 
 	} else {
+		int	offset;
+
 		first_fsb = 0;
 		nmaps = XFS_SYMLINK_MAPS;
 
@@ -322,7 +510,10 @@ xfs_symlink(
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 		cur_chunk = target_path;
+		offset = 0;
 		for (n = 0; n < nmaps; n++) {
+			char *buf;
+
 			d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
@@ -331,15 +522,25 @@ xfs_symlink(
 				error = ENOMEM;
 				goto error2;
 			}
+			bp->b_ops = &xfs_symlink_buf_ops;
+
+			byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
 			if (pathlen < byte_cnt) {
 				byte_cnt = pathlen;
 			}
-			pathlen -= byte_cnt;
 
-			memcpy(bp->b_addr, cur_chunk, byte_cnt);
+			buf = bp->b_addr;
+			buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset,
+						   byte_cnt, bp);
+
+			memcpy(buf, cur_chunk, byte_cnt);
+
 			cur_chunk += byte_cnt;
+			pathlen -= byte_cnt;
+			offset += byte_cnt;
 
-			xfs_trans_log_buf(tp, bp, 0, byte_cnt - 1);
+			xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
+							(char *)bp->b_addr);
 		}
 	}
 
@@ -392,7 +593,7 @@ xfs_symlink(
 /*
  * Free a symlink that has blocks associated with it.
  */
-STATIC int
+int
 xfs_inactive_symlink_rmt(
 	xfs_inode_t	*ip,
 	xfs_trans_t	**tpp)
@@ -438,12 +639,12 @@ xfs_inactive_symlink_rmt(
 	done = 0;
 	xfs_bmap_init(&free_list, &first_block);
 	nmaps = ARRAY_SIZE(mval);
-	error = xfs_bmapi_read(ip, 0, XFS_B_TO_FSB(mp, size),
+	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
 				mval, &nmaps, 0);
 	if (error)
 		goto error0;
 	/*
-	 * Invalidate the block(s).
+	 * Invalidate the block(s). No validation is done.
 	 */
 	for (i = 0; i < nmaps; i++) {
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index 07bdabc..b39398d 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -17,16 +17,44 @@
 #ifndef __XFS_SYMLINK_H
 #define __XFS_SYMLINK_H 1
 
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_inode;
+struct xfs_buf;
+struct xfs_ifork;
+struct xfs_name;
+
+#define XFS_SYMLINK_MAGIC	0x58534c4d	/* XSLM */
+
+struct xfs_dsymlink_hdr {
+	__be32	sl_magic;
+	__be32	sl_offset;
+	__be32	sl_bytes;
+	__be32	sl_crc;
+	uuid_t	sl_uuid;
+	__be64	sl_owner;
+	__be64	sl_blkno;
+	__be64	sl_lsn;
+};
+
 /*
  * The maximum pathlen is 1024 bytes. Since the minimum file system
- * blocksize is 512 bytes, we can get a max of 2 extents back from
- * bmapi.
+ * blocksize is 512 bytes, we can get a max of 3 extents back from
+ * bmapi when crc headers are taken into account.
  */
-#define XFS_SYMLINK_MAPS 2
+#define XFS_SYMLINK_MAPS 3
+
+#define XFS_SYMLINK_BUF_SPACE(mp, bufsize)	\
+	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
+			sizeof(struct xfs_dsymlink_hdr) : 0))
+
+int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
 
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+
 #ifdef __KERNEL__
 
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
