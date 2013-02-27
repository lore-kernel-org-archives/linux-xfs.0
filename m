Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A5DF7F6D
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 17:36:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 777088F804C
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 15:36:19 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5kEXsogWajgfvCB9 for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 15:36:15 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UAqXX-0002X7-Dq
	for xfs@oss.sgi.com; Thu, 28 Feb 2013 10:35:59 +1100
Date: Thu, 28 Feb 2013 10:35:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/16] xfs: add CRC checks to remote symlinks
Message-ID: <20130227233559.GG5551@dastard>
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
	<1361755901-12453-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361755901-12453-10-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Mon, Feb 25, 2013 at 12:31:34PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a header to the remote symlink block, containing location and
> owner information, as well as CRCs and LSN fields. This requires
> verifiers to be added to the remote symlink buffers for CRC enabled
> filesystems.
> 
> This also fixes a bug reading multiple block symlinks, where the second block
> overwrites the first block when copying out the link name.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile          |    5 +-
>  fs/xfs/xfs_bmap.c        |   21 +-
>  fs/xfs/xfs_buf_item.h    |    4 +-
>  fs/xfs/xfs_log_recover.c |    9 +
>  fs/xfs/xfs_vnodeops.c    |  480 +---------------------------------------------
>  5 files changed, 25 insertions(+), 494 deletions(-)

I just noticed this is missing two new files (insert grumble about
guilt forgetting added files when a patch is force applied because
of conflicts).

The correct version is below (diffstat += 770 lines)...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: add CRC checks to remote symlinks

From: Dave Chinner <dchinner@redhat.com>

Add a header to the remote symlink block, containing location and
owner information, as well as CRCs and LSN fields. This requires
verifiers to be added to the remote symlink buffers for CRC enabled
filesystems.

This also fixes a bug reading multiple block symlinks, where the second block
overwrites the first block when copying out the link name.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile          |    5 +-
 fs/xfs/xfs_bmap.c        |   21 +-
 fs/xfs/xfs_buf_item.h    |    4 +-
 fs/xfs/xfs_log_recover.c |    9 +
 fs/xfs/xfs_symlink.c     |  719 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_symlink.h     |   53 ++++
 fs/xfs/xfs_vnodeops.c    |  480 +------------------------------
 7 files changed, 797 insertions(+), 494 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d02201d..062f25c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -45,11 +45,11 @@ xfs-y				+= xfs_aops.o \
 				   xfs_itable.o \
 				   xfs_message.o \
 				   xfs_mru_cache.o \
-				   xfs_super.o \
-				   xfs_xattr.o \
 				   xfs_rename.o \
+				   xfs_super.o \
 				   xfs_utils.o \
 				   xfs_vnodeops.o \
+				   xfs_xattr.o \
 				   kmem.o \
 				   uuid.o
 
@@ -73,6 +73,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_inode.o \
 				   xfs_log_recover.o \
 				   xfs_mount.o \
+				   xfs_symlink.o \
 				   xfs_trans.o
 
 # low-level transaction/log code
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 0531cd3..0fcb7f4 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -47,6 +47,7 @@
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
+#include "xfs_symlink.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -1321,9 +1322,10 @@ xfs_bmap_add_attrfork_extents(
 }
 
 /*
- * Block initialisation functions for local to extent format conversion.
- * As these get more complex, they will be moved to the relevant files,
- * but for now they are too simple to worry about.
+ * Block initialisation function for local to extent format conversion.
+ *
+ * This shouldn't actually be called by anyone, so make sure debug kernels cause
+ * a noticable failure.
  */
 STATIC void
 xfs_bmap_local_to_extents_init_fn(
@@ -1332,23 +1334,12 @@ xfs_bmap_local_to_extents_init_fn(
 	struct xfs_inode	*ip,
 	struct xfs_ifork	*ifp)
 {
+	ASSERT(0);
 	bp->b_ops = &xfs_bmbt_buf_ops;
 	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLF_BTREE_BUF);
 }
 
-STATIC void
-xfs_symlink_local_to_remote(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
-	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
-{
-	/* remote symlink blocks are not verifiable until CRCs come along */
-	bp->b_ops = NULL;
-	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
-}
-
 /*
  * Called from xfs_bmap_add_attrfork to handle local format files. Each
  * different data fork content type needs a different callout to do the
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
index 4096998..e1e3dcf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -45,6 +45,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_symlink.h"
 
 STATIC int
 xlog_find_zeroed(
@@ -2006,6 +2007,14 @@ xlog_recover_do_reg_buffer(
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
new file mode 100644
index 0000000..33e8f13
--- /dev/null
+++ b/fs/xfs/xfs_symlink.c
@@ -0,0 +1,719 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2012-2013 Red Hat, Inc.
+ * All rights reserved.
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_mount.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_inode_item.h"
+#include "xfs_itable.h"
+#include "xfs_ialloc.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_error.h"
+#include "xfs_quota.h"
+#include "xfs_utils.h"
+#include "xfs_trans_space.h"
+#include "xfs_log_priv.h"
+#include "xfs_trace.h"
+#include "xfs_symlink.h"
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
+
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
+
+void
+xfs_symlink_local_to_remote(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp)
+{
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
+}
+
+/* ----- Kernel only functions below ----- */
+STATIC int
+xfs_readlink_bmap(
+	struct xfs_inode	*ip,
+	char			*link)
+{
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
+
+	fsblocks = xfs_symlink_blocks(mp, pathlen);
+	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
+	if (error)
+		goto out;
+
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
+		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
+
+		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
+				  &xfs_symlink_buf_ops);
+		if (!bp)
+			return XFS_ERROR(ENOMEM);
+		error = bp->b_error;
+		if (error) {
+			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_relse(bp);
+			goto out;
+		}
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
+		if (pathlen < byte_cnt)
+			byte_cnt = pathlen;
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
+		pathlen -= byte_cnt;
+		offset += byte_cnt;
+
+		xfs_buf_relse(bp);
+	}
+	ASSERT(pathlen == 0);
+
+	link[ip->i_d.di_size] = '\0';
+	error = 0;
+
+ out:
+	return error;
+}
+
+int
+xfs_readlink(
+	struct xfs_inode *ip,
+	char		*link)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	xfs_fsize_t	pathlen;
+	int		error = 0;
+
+	trace_xfs_readlink(ip);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+
+	pathlen = ip->i_d.di_size;
+	if (!pathlen)
+		goto out;
+
+	if (pathlen < 0 || pathlen > MAXPATHLEN) {
+		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
+			 __func__, (unsigned long long) ip->i_ino,
+			 (long long) pathlen);
+		ASSERT(0);
+		error = XFS_ERROR(EFSCORRUPTED);
+		goto out;
+	}
+
+
+	if (ip->i_df.if_flags & XFS_IFINLINE) {
+		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
+		link[pathlen] = '\0';
+	} else {
+		error = xfs_readlink_bmap(ip, link);
+	}
+
+ out:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
+}
+
+int
+xfs_symlink(
+	struct xfs_inode	*dp,
+	struct xfs_name		*link_name,
+	const char		*target_path,
+	umode_t			mode,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
+	struct xfs_inode	*ip = NULL;
+	int			error = 0;
+	int			pathlen;
+	struct xfs_bmap_free	free_list;
+	xfs_fsblock_t		first_block;
+	bool			unlock_dp_on_error = false;
+	uint			cancel_flags;
+	int			committed;
+	xfs_fileoff_t		first_fsb;
+	xfs_filblks_t		fs_blocks;
+	int			nmaps;
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	xfs_daddr_t		d;
+	const char		*cur_chunk;
+	int			byte_cnt;
+	int			n;
+	xfs_buf_t		*bp;
+	prid_t			prid;
+	struct xfs_dquot	*udqp, *gdqp;
+	uint			resblks;
+
+	*ipp = NULL;
+
+	trace_xfs_symlink(dp, link_name);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	/*
+	 * Check component lengths of the target path name.
+	 */
+	pathlen = strlen(target_path);
+	if (pathlen >= MAXPATHLEN)      /* total string too long */
+		return XFS_ERROR(ENAMETOOLONG);
+
+	udqp = gdqp = NULL;
+	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		prid = xfs_get_projid(dp);
+	else
+		prid = XFS_PROJID_DEFAULT;
+
+	/*
+	 * Make sure that we have allocated dquot(s) on disk.
+	 */
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
+			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
+	if (error)
+		goto std_return;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SYMLINK);
+	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
+	/*
+	 * The symlink will fit into the inode data fork?
+	 * There can't be any attributes so we get the whole variable part.
+	 */
+	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
+		fs_blocks = 0;
+	else
+		fs_blocks = XFS_B_TO_FSB(mp, pathlen);
+	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
+	error = xfs_trans_reserve(tp, resblks, XFS_SYMLINK_LOG_RES(mp), 0,
+			XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
+	if (error == ENOSPC && fs_blocks == 0) {
+		resblks = 0;
+		error = xfs_trans_reserve(tp, 0, XFS_SYMLINK_LOG_RES(mp), 0,
+				XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
+	}
+	if (error) {
+		cancel_flags = 0;
+		goto error_return;
+	}
+
+	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+	unlock_dp_on_error = true;
+
+	/*
+	 * Check whether the directory allows new symlinks or not.
+	 */
+	if (dp->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) {
+		error = XFS_ERROR(EPERM);
+		goto error_return;
+	}
+
+	/*
+	 * Reserve disk quota : blocks and inode.
+	 */
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
+	if (error)
+		goto error_return;
+
+	/*
+	 * Check for ability to enter directory entry, if no space reserved.
+	 */
+	error = xfs_dir_canenter(tp, dp, link_name, resblks);
+	if (error)
+		goto error_return;
+	/*
+	 * Initialize the bmap freelist prior to calling either
+	 * bmapi or the directory create code.
+	 */
+	xfs_bmap_init(&free_list, &first_block);
+
+	/*
+	 * Allocate an inode for the symlink.
+	 */
+	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
+			       prid, resblks > 0, &ip, NULL);
+	if (error) {
+		if (error == ENOSPC)
+			goto error_return;
+		goto error1;
+	}
+
+	/*
+	 * An error after we've joined dp to the transaction will result in the
+	 * transaction cancel unlocking dp so don't do it explicitly in the
+	 * error path.
+	 */
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	unlock_dp_on_error = false;
+
+	/*
+	 * Also attach the dquot(s) to it, if applicable.
+	 */
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
+
+	if (resblks)
+		resblks -= XFS_IALLOC_SPACE_RES(mp);
+	/*
+	 * If the symlink will fit into the inode, write it inline.
+	 */
+	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
+		xfs_idata_realloc(ip, pathlen, XFS_DATA_FORK);
+		memcpy(ip->i_df.if_u1.if_data, target_path, pathlen);
+		ip->i_d.di_size = pathlen;
+
+		/*
+		 * The inode was initially created in extent format.
+		 */
+		ip->i_df.if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
+		ip->i_df.if_flags |= XFS_IFINLINE;
+
+		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
+
+	} else {
+		int	offset;
+
+		first_fsb = 0;
+		nmaps = XFS_SYMLINK_MAPS;
+
+		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
+				  XFS_BMAPI_METADATA, &first_block, resblks,
+				  mval, &nmaps, &free_list);
+		if (error)
+			goto error2;
+
+		if (resblks)
+			resblks -= fs_blocks;
+		ip->i_d.di_size = pathlen;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+		cur_chunk = target_path;
+		offset = 0;
+		for (n = 0; n < nmaps; n++) {
+			char *buf;
+
+			d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
+			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
+			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+					       BTOBB(byte_cnt), 0);
+			if (!bp) {
+				error = ENOMEM;
+				goto error2;
+			}
+			bp->b_ops = &xfs_symlink_buf_ops;
+
+			byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
+			if (pathlen < byte_cnt) {
+				byte_cnt = pathlen;
+			}
+
+			buf = bp->b_addr;
+			buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset,
+						   byte_cnt, bp);
+
+			memcpy(buf, cur_chunk, byte_cnt);
+
+			cur_chunk += byte_cnt;
+			pathlen -= byte_cnt;
+			offset += byte_cnt;
+
+			xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
+							(char *)bp->b_addr);
+		}
+	}
+
+	/*
+	 * Create the directory entry for the symlink.
+	 */
+	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
+					&first_block, &free_list, resblks);
+	if (error)
+		goto error2;
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	/*
+	 * If this is a synchronous mount, make sure that the
+	 * symlink transaction goes to disk before returning to
+	 * the user.
+	 */
+	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
+		xfs_trans_set_sync(tp);
+	}
+
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error) {
+		goto error2;
+	}
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+
+	*ipp = ip;
+	return 0;
+
+ error2:
+	IRELE(ip);
+ error1:
+	xfs_bmap_cancel(&free_list);
+	cancel_flags |= XFS_TRANS_ABORT;
+ error_return:
+	xfs_trans_cancel(tp, cancel_flags);
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+
+	if (unlock_dp_on_error)
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ std_return:
+	return error;
+}
+
+/*
+ * Free a symlink that has blocks associated with it.
+ */
+int
+xfs_inactive_symlink_rmt(
+	xfs_inode_t	*ip,
+	xfs_trans_t	**tpp)
+{
+	xfs_buf_t	*bp;
+	int		committed;
+	int		done;
+	int		error;
+	xfs_fsblock_t	first_block;
+	xfs_bmap_free_t	free_list;
+	int		i;
+	xfs_mount_t	*mp;
+	xfs_bmbt_irec_t	mval[XFS_SYMLINK_MAPS];
+	int		nmaps;
+	xfs_trans_t	*ntp;
+	int		size;
+	xfs_trans_t	*tp;
+
+	tp = *tpp;
+	mp = ip->i_mount;
+	ASSERT(ip->i_d.di_size > XFS_IFORK_DSIZE(ip));
+	/*
+	 * We're freeing a symlink that has some
+	 * blocks allocated to it.  Free the
+	 * blocks here.  We know that we've got
+	 * either 1 or 2 extents and that we can
+	 * free them all in one bunmapi call.
+	 */
+	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
+
+	/*
+	 * Lock the inode, fix the size, and join it to the transaction.
+	 * Hold it so in the normal path, we still have it locked for
+	 * the second transaction.  In the error paths we need it
+	 * held so the cancel won't rele it, see below.
+	 */
+	size = (int)ip->i_d.di_size;
+	ip->i_d.di_size = 0;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	/*
+	 * Find the block(s) so we can inval and unmap them.
+	 */
+	done = 0;
+	xfs_bmap_init(&free_list, &first_block);
+	nmaps = ARRAY_SIZE(mval);
+	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
+				mval, &nmaps, 0);
+	if (error)
+		goto error0;
+	/*
+	 * Invalidate the block(s). No validation is done.
+	 */
+	for (i = 0; i < nmaps; i++) {
+		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
+			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
+		if (!bp) {
+			error = ENOMEM;
+			goto error1;
+		}
+		xfs_trans_binval(tp, bp);
+	}
+	/*
+	 * Unmap the dead block(s) to the free_list.
+	 */
+	if ((error = xfs_bunmapi(tp, ip, 0, size, XFS_BMAPI_METADATA, nmaps,
+			&first_block, &free_list, &done)))
+		goto error1;
+	ASSERT(done);
+	/*
+	 * Commit the first transaction.  This logs the EFI and the inode.
+	 */
+	if ((error = xfs_bmap_finish(&tp, &free_list, &committed)))
+		goto error1;
+	/*
+	 * The transaction must have been committed, since there were
+	 * actually extents freed by xfs_bunmapi.  See xfs_bmap_finish.
+	 * The new tp has the extent freeing and EFDs.
+	 */
+	ASSERT(committed);
+	/*
+	 * The first xact was committed, so add the inode to the new one.
+	 * Mark it dirty so it will be logged and moved forward in the log as
+	 * part of every commit.
+	 */
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	/*
+	 * Get a new, empty transaction to return to our caller.
+	 */
+	ntp = xfs_trans_dup(tp);
+	/*
+	 * Commit the transaction containing extent freeing and EFDs.
+	 * If we get an error on the commit here or on the reserve below,
+	 * we need to unlock the inode since the new transaction doesn't
+	 * have the inode attached.
+	 */
+	error = xfs_trans_commit(tp, 0);
+	tp = ntp;
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		goto error0;
+	}
+	/*
+	 * transaction commit worked ok so we can drop the extra ticket
+	 * reference that we gained in xfs_trans_dup()
+	 */
+	xfs_log_ticket_put(tp->t_ticket);
+
+	/*
+	 * Remove the memory for extent descriptions (just bookkeeping).
+	 */
+	if (ip->i_df.if_bytes)
+		xfs_idata_realloc(ip, -ip->i_df.if_bytes, XFS_DATA_FORK);
+	ASSERT(ip->i_df.if_bytes == 0);
+	/*
+	 * Put an itruncate log reservation in the new transaction
+	 * for our caller.
+	 */
+	if ((error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
+			XFS_TRANS_PERM_LOG_RES, XFS_ITRUNCATE_LOG_COUNT))) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		goto error0;
+	}
+
+	xfs_trans_ijoin(tp, ip, 0);
+	*tpp = tp;
+	return 0;
+
+ error1:
+	xfs_bmap_cancel(&free_list);
+ error0:
+	return error;
+}
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
new file mode 100644
index 0000000..be20ae1
--- /dev/null
+++ b/fs/xfs/xfs_symlink.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
+ */
+#ifndef __XFS_SYMLINK_H
+#define __XFS_SYMLINK_H 1
+
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
+/*
+ * The maximum pathlen is 1024 bytes. Since the minimum file system
+ * blocksize is 512 bytes, we can get a max of 3 extents back from
+ * bmapi when crc headers are taken into account.
+ */
+#define XFS_SYMLINK_MAPS 3
+
+#define XFS_SYMLINK_BUF_SPACE(mp, bufsize)	\
+	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
+			sizeof(struct xfs_dsymlink_hdr) : 0))
+
+int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
+
+void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
+				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+
+#ifdef __KERNEL__
+
+int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
+		const char *target_path, umode_t mode, struct xfs_inode **ipp);
+int xfs_readlink(struct xfs_inode *ip, char *link);
+int xfs_inactive_symlink_rmt(struct xfs_inode *ip, struct xfs_trans **tpp);
+
+#endif /* __KERNEL__ */
+#endif /* __XFS_SYMLINK_H */
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index aa0c066..1034440 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2012 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -48,103 +49,10 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_symlink.h"
+#include "xfs_cksum.h"
+#include "xfs_buf_item.h"
 
-/*
- * The maximum pathlen is 1024 bytes. Since the minimum file system
- * blocksize is 512 bytes, we can get a max of 2 extents back from
- * bmapi.
- */
-#define SYMLINK_MAPS 2
-
-STATIC int
-xfs_readlink_bmap(
-	xfs_inode_t	*ip,
-	char		*link)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	int		pathlen = ip->i_d.di_size;
-	int             nmaps = SYMLINK_MAPS;
-	xfs_bmbt_irec_t mval[SYMLINK_MAPS];
-	xfs_daddr_t	d;
-	int		byte_cnt;
-	int		n;
-	xfs_buf_t	*bp;
-	int		error = 0;
-
-	error = xfs_bmapi_read(ip, 0, XFS_B_TO_FSB(mp, pathlen), mval, &nmaps,
-			       0);
-	if (error)
-		goto out;
-
-	for (n = 0; n < nmaps; n++) {
-		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
-		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
-
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0, NULL);
-		if (!bp)
-			return XFS_ERROR(ENOMEM);
-		error = bp->b_error;
-		if (error) {
-			xfs_buf_ioerror_alert(bp, __func__);
-			xfs_buf_relse(bp);
-			goto out;
-		}
-		if (pathlen < byte_cnt)
-			byte_cnt = pathlen;
-		pathlen -= byte_cnt;
-
-		memcpy(link, bp->b_addr, byte_cnt);
-		xfs_buf_relse(bp);
-	}
-
-	link[ip->i_d.di_size] = '\0';
-	error = 0;
-
- out:
-	return error;
-}
-
-int
-xfs_readlink(
-	xfs_inode_t     *ip,
-	char		*link)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_fsize_t	pathlen;
-	int		error = 0;
-
-	trace_xfs_readlink(ip);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-
-	pathlen = ip->i_d.di_size;
-	if (!pathlen)
-		goto out;
-
-	if (pathlen < 0 || pathlen > MAXPATHLEN) {
-		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
-			 __func__, (unsigned long long) ip->i_ino,
-			 (long long) pathlen);
-		ASSERT(0);
-		error = XFS_ERROR(EFSCORRUPTED);
-		goto out;
-	}
-
-
-	if (ip->i_df.if_flags & XFS_IFINLINE) {
-		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
-		link[pathlen] = '\0';
-	} else {
-		error = xfs_readlink_bmap(ip, link);
-	}
-
- out:
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return error;
-}
 
 /*
  * This is called by xfs_inactive to free any blocks beyond eof
@@ -249,145 +157,6 @@ xfs_free_eofblocks(
 	return error;
 }
 
-/*
- * Free a symlink that has blocks associated with it.
- */
-STATIC int
-xfs_inactive_symlink_rmt(
-	xfs_inode_t	*ip,
-	xfs_trans_t	**tpp)
-{
-	xfs_buf_t	*bp;
-	int		committed;
-	int		done;
-	int		error;
-	xfs_fsblock_t	first_block;
-	xfs_bmap_free_t	free_list;
-	int		i;
-	xfs_mount_t	*mp;
-	xfs_bmbt_irec_t	mval[SYMLINK_MAPS];
-	int		nmaps;
-	xfs_trans_t	*ntp;
-	int		size;
-	xfs_trans_t	*tp;
-
-	tp = *tpp;
-	mp = ip->i_mount;
-	ASSERT(ip->i_d.di_size > XFS_IFORK_DSIZE(ip));
-	/*
-	 * We're freeing a symlink that has some
-	 * blocks allocated to it.  Free the
-	 * blocks here.  We know that we've got
-	 * either 1 or 2 extents and that we can
-	 * free them all in one bunmapi call.
-	 */
-	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
-
-	/*
-	 * Lock the inode, fix the size, and join it to the transaction.
-	 * Hold it so in the normal path, we still have it locked for
-	 * the second transaction.  In the error paths we need it
-	 * held so the cancel won't rele it, see below.
-	 */
-	size = (int)ip->i_d.di_size;
-	ip->i_d.di_size = 0;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	/*
-	 * Find the block(s) so we can inval and unmap them.
-	 */
-	done = 0;
-	xfs_bmap_init(&free_list, &first_block);
-	nmaps = ARRAY_SIZE(mval);
-	error = xfs_bmapi_read(ip, 0, XFS_B_TO_FSB(mp, size),
-				mval, &nmaps, 0);
-	if (error)
-		goto error0;
-	/*
-	 * Invalidate the block(s).
-	 */
-	for (i = 0; i < nmaps; i++) {
-		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
-			XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
-			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
-		if (!bp) {
-			error = ENOMEM;
-			goto error1;
-		}
-		xfs_trans_binval(tp, bp);
-	}
-	/*
-	 * Unmap the dead block(s) to the free_list.
-	 */
-	if ((error = xfs_bunmapi(tp, ip, 0, size, XFS_BMAPI_METADATA, nmaps,
-			&first_block, &free_list, &done)))
-		goto error1;
-	ASSERT(done);
-	/*
-	 * Commit the first transaction.  This logs the EFI and the inode.
-	 */
-	if ((error = xfs_bmap_finish(&tp, &free_list, &committed)))
-		goto error1;
-	/*
-	 * The transaction must have been committed, since there were
-	 * actually extents freed by xfs_bunmapi.  See xfs_bmap_finish.
-	 * The new tp has the extent freeing and EFDs.
-	 */
-	ASSERT(committed);
-	/*
-	 * The first xact was committed, so add the inode to the new one.
-	 * Mark it dirty so it will be logged and moved forward in the log as
-	 * part of every commit.
-	 */
-	xfs_trans_ijoin(tp, ip, 0);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	/*
-	 * Get a new, empty transaction to return to our caller.
-	 */
-	ntp = xfs_trans_dup(tp);
-	/*
-	 * Commit the transaction containing extent freeing and EFDs.
-	 * If we get an error on the commit here or on the reserve below,
-	 * we need to unlock the inode since the new transaction doesn't
-	 * have the inode attached.
-	 */
-	error = xfs_trans_commit(tp, 0);
-	tp = ntp;
-	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		goto error0;
-	}
-	/*
-	 * transaction commit worked ok so we can drop the extra ticket
-	 * reference that we gained in xfs_trans_dup()
-	 */
-	xfs_log_ticket_put(tp->t_ticket);
-
-	/*
-	 * Remove the memory for extent descriptions (just bookkeeping).
-	 */
-	if (ip->i_df.if_bytes)
-		xfs_idata_realloc(ip, -ip->i_df.if_bytes, XFS_DATA_FORK);
-	ASSERT(ip->i_df.if_bytes == 0);
-	/*
-	 * Put an itruncate log reservation in the new transaction
-	 * for our caller.
-	 */
-	if ((error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ITRUNCATE_LOG_COUNT))) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		goto error0;
-	}
-
-	xfs_trans_ijoin(tp, ip, 0);
-	*tpp = tp;
-	return 0;
-
- error1:
-	xfs_bmap_cancel(&free_list);
- error0:
-	return error;
-}
-
 int
 xfs_release(
 	xfs_inode_t	*ip)
@@ -1353,247 +1122,6 @@ xfs_link(
 }
 
 int
-xfs_symlink(
-	xfs_inode_t		*dp,
-	struct xfs_name		*link_name,
-	const char		*target_path,
-	umode_t			mode,
-	xfs_inode_t		**ipp)
-{
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t		*tp;
-	xfs_inode_t		*ip;
-	int			error;
-	int			pathlen;
-	xfs_bmap_free_t		free_list;
-	xfs_fsblock_t		first_block;
-	bool                    unlock_dp_on_error = false;
-	uint			cancel_flags;
-	int			committed;
-	xfs_fileoff_t		first_fsb;
-	xfs_filblks_t		fs_blocks;
-	int			nmaps;
-	xfs_bmbt_irec_t		mval[SYMLINK_MAPS];
-	xfs_daddr_t		d;
-	const char		*cur_chunk;
-	int			byte_cnt;
-	int			n;
-	xfs_buf_t		*bp;
-	prid_t			prid;
-	struct xfs_dquot	*udqp, *gdqp;
-	uint			resblks;
-
-	*ipp = NULL;
-	error = 0;
-	ip = NULL;
-	tp = NULL;
-
-	trace_xfs_symlink(dp, link_name);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	/*
-	 * Check component lengths of the target path name.
-	 */
-	pathlen = strlen(target_path);
-	if (pathlen >= MAXPATHLEN)      /* total string too long */
-		return XFS_ERROR(ENAMETOOLONG);
-
-	udqp = gdqp = NULL;
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		prid = xfs_get_projid(dp);
-	else
-		prid = XFS_PROJID_DEFAULT;
-
-	/*
-	 * Make sure that we have allocated dquot(s) on disk.
-	 */
-	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
-	if (error)
-		goto std_return;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SYMLINK);
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
-	/*
-	 * The symlink will fit into the inode data fork?
-	 * There can't be any attributes so we get the whole variable part.
-	 */
-	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
-		fs_blocks = 0;
-	else
-		fs_blocks = XFS_B_TO_FSB(mp, pathlen);
-	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
-	error = xfs_trans_reserve(tp, resblks, XFS_SYMLINK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
-	if (error == ENOSPC && fs_blocks == 0) {
-		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_SYMLINK_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
-	}
-	if (error) {
-		cancel_flags = 0;
-		goto error_return;
-	}
-
-	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
-	unlock_dp_on_error = true;
-
-	/*
-	 * Check whether the directory allows new symlinks or not.
-	 */
-	if (dp->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) {
-		error = XFS_ERROR(EPERM);
-		goto error_return;
-	}
-
-	/*
-	 * Reserve disk quota : blocks and inode.
-	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
-	if (error)
-		goto error_return;
-
-	/*
-	 * Check for ability to enter directory entry, if no space reserved.
-	 */
-	error = xfs_dir_canenter(tp, dp, link_name, resblks);
-	if (error)
-		goto error_return;
-	/*
-	 * Initialize the bmap freelist prior to calling either
-	 * bmapi or the directory create code.
-	 */
-	xfs_bmap_init(&free_list, &first_block);
-
-	/*
-	 * Allocate an inode for the symlink.
-	 */
-	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
-			       prid, resblks > 0, &ip, NULL);
-	if (error) {
-		if (error == ENOSPC)
-			goto error_return;
-		goto error1;
-	}
-
-	/*
-	 * An error after we've joined dp to the transaction will result in the
-	 * transaction cancel unlocking dp so don't do it explicitly in the
-	 * error path.
-	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
-
-	/*
-	 * Also attach the dquot(s) to it, if applicable.
-	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
-
-	if (resblks)
-		resblks -= XFS_IALLOC_SPACE_RES(mp);
-	/*
-	 * If the symlink will fit into the inode, write it inline.
-	 */
-	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
-		xfs_idata_realloc(ip, pathlen, XFS_DATA_FORK);
-		memcpy(ip->i_df.if_u1.if_data, target_path, pathlen);
-		ip->i_d.di_size = pathlen;
-
-		/*
-		 * The inode was initially created in extent format.
-		 */
-		ip->i_df.if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
-		ip->i_df.if_flags |= XFS_IFINLINE;
-
-		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
-
-	} else {
-		first_fsb = 0;
-		nmaps = SYMLINK_MAPS;
-
-		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
-				  XFS_BMAPI_METADATA, &first_block, resblks,
-				  mval, &nmaps, &free_list);
-		if (error)
-			goto error2;
-
-		if (resblks)
-			resblks -= fs_blocks;
-		ip->i_d.di_size = pathlen;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-		cur_chunk = target_path;
-		for (n = 0; n < nmaps; n++) {
-			d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
-			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
-			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					       BTOBB(byte_cnt), 0);
-			if (!bp) {
-				error = ENOMEM;
-				goto error2;
-			}
-			if (pathlen < byte_cnt) {
-				byte_cnt = pathlen;
-			}
-			pathlen -= byte_cnt;
-
-			memcpy(bp->b_addr, cur_chunk, byte_cnt);
-			cur_chunk += byte_cnt;
-
-			xfs_trans_log_buf(tp, bp, 0, byte_cnt - 1);
-		}
-	}
-
-	/*
-	 * Create the directory entry for the symlink.
-	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
-					&first_block, &free_list, resblks);
-	if (error)
-		goto error2;
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * symlink transaction goes to disk before returning to
-	 * the user.
-	 */
-	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
-		xfs_trans_set_sync(tp);
-	}
-
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
-	if (error) {
-		goto error2;
-	}
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-
-	*ipp = ip;
-	return 0;
-
- error2:
-	IRELE(ip);
- error1:
-	xfs_bmap_cancel(&free_list);
-	cancel_flags |= XFS_TRANS_ABORT;
- error_return:
-	xfs_trans_cancel(tp, cancel_flags);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-
-	if (unlock_dp_on_error)
-		xfs_iunlock(dp, XFS_ILOCK_EXCL);
- std_return:
-	return error;
-}
-
-int
 xfs_set_dmattrs(
 	xfs_inode_t     *ip,
 	u_int		evmask,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
