Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27540 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934108AbdHYWSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:18:47 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMIkoY022958
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMIkco019104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:46 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7PMIkdw023581
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:46 GMT
Subject: [PATCH 17/19] xfs: online repair of inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:18:45 -0700
Message-ID: <150369952489.9957.11143012191482946963.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Try to reinitialize corrupt inodes, or clear the reflink flag
if it's not needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/inode.c  |  188 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    1 
 fs/xfs/scrub/scrub.c  |    1 
 3 files changed, 190 insertions(+)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 44201ab..2316c76 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -40,10 +40,13 @@
 #include "xfs_rmap.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_dir2.h"
+#include "xfs_quota_defs.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /* Set us up with an inode. */
 int
@@ -437,3 +440,188 @@ xfs_scrub_inode(
 		xfs_trans_brelse(sc->tp, bp);
 	return error;
 }
+
+/* Repair an inode's fields. */
+int
+xfs_repair_inode(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_imap			imap;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp;
+	struct xfs_dinode		*dip;
+	struct xfs_inode		*ip;
+	xfs_ino_t			ino;
+	xfs_filblks_t			count;
+	xfs_filblks_t			acount;
+	uint64_t			flags2;
+	xfs_extnum_t			nextents;
+	uint16_t			flags;
+	uint16_t			mode;
+	bool				invalidate_quota = false;
+	int				error = 0;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	if (sc->ip && xfs_scrub_preen_only(sc->sm))
+		goto preen_only;
+
+	/* Are we fixing this thing manually? */
+	if (!sc->ip) {
+		/* Map & read inode. */
+		ino = sc->sm->sm_ino;
+		error = xfs_imap(mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
+		if (error)
+			goto out;
+
+		error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+				imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp,
+				NULL);
+		if (error)
+			goto out;
+
+		/* Fix everything the verifier will complain about. */
+		bp->b_ops = &xfs_inode_buf_ops;
+		dip = xfs_buf_offset(bp, imap.im_boffset);
+		mode = be16_to_cpu(dip->di_mode);
+		if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
+			mode = S_IFREG;
+		dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+		if (!xfs_dinode_good_version(mp, dip->di_version))
+			dip->di_version = 3;
+		dip->di_ino = cpu_to_be64(ino);
+		uuid_copy(&dip->di_uuid, &mp->m_sb.sb_meta_uuid);
+		flags = be16_to_cpu(dip->di_flags);
+		flags2 = be64_to_cpu(dip->di_flags2);
+		if (xfs_sb_version_hasreflink(&mp->m_sb) && S_ISREG(mode))
+			flags2 |= XFS_DIFLAG2_REFLINK;
+		else
+			flags2 &= ~(XFS_DIFLAG2_REFLINK |
+				    XFS_DIFLAG2_COWEXTSIZE);
+		if (flags & XFS_DIFLAG_REALTIME)
+			flags2 &= ~XFS_DIFLAG2_REFLINK;
+		if (flags2 & XFS_DIFLAG2_REFLINK)
+			flags2 &= ~XFS_DIFLAG2_DAX;
+		dip->di_flags = cpu_to_be16(flags);
+		dip->di_flags2 = cpu_to_be64(flags2);
+		dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
+		if (be64_to_cpu(dip->di_size) & (1ULL << 63))
+			dip->di_size = cpu_to_be64((1ULL << 63) - 1);
+
+		/* Write out the inode... */
+		xfs_dinode_calc_crc(mp, dip);
+		xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);
+		xfs_trans_log_buf(sc->tp, bp, imap.im_boffset,
+				imap.im_boffset + mp->m_sb.sb_inodesize - 1);
+		error = xfs_trans_roll(&sc->tp, NULL);
+		if (error)
+			goto out;
+
+		/* ...and reload it? */
+		error = xfs_iget(mp, sc->tp, ino,
+				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE,
+				0, &sc->ip);
+		if (error)
+			goto out;
+		sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL |
+				  XFS_ILOCK_EXCL;
+		xfs_ilock(sc->ip, sc->ilock_flags);
+	}
+
+	ip = sc->ip;
+	xfs_trans_ijoin(sc->tp, ip, 0);
+
+	/* di_size */
+	if (!S_ISDIR(VFS_I(ip)->i_mode) && !S_ISREG(VFS_I(ip)->i_mode) &&
+	    !S_ISLNK(VFS_I(ip)->i_mode)) {
+		i_size_write(VFS_I(ip), 0);
+		ip->i_d.di_size = 0;
+	}
+
+	/* di_flags */
+	flags = ip->i_d.di_flags;
+	if ((flags & XFS_DIFLAG_IMMUTABLE) && (flags & XFS_DIFLAG_APPEND))
+		flags &= ~XFS_DIFLAG_APPEND;
+
+	if ((flags & XFS_DIFLAG_FILESTREAM) && (flags & XFS_DIFLAG_REALTIME))
+		flags &= ~XFS_DIFLAG_FILESTREAM;
+	ip->i_d.di_flags = flags;
+
+	/* di_nblocks/di_nextents/di_anextents */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (error)
+		goto out;
+	ip->i_d.di_nextents = nextents;
+
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &acount);
+	if (error)
+		goto out;
+	ip->i_d.di_anextents = nextents;
+
+	ip->i_d.di_nblocks = count + acount;
+	if (ip->i_d.di_anextents != 0 && ip->i_d.di_forkoff == 0)
+		ip->i_d.di_anextents = 0;
+
+	/* Do we have prealloc blocks? */
+	if (S_ISREG(VFS_I(ip)->i_mode) && !(flags & XFS_DIFLAG_PREALLOC) &&
+	    (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS ||
+	     ip->i_d.di_format == XFS_DINODE_FMT_BTREE)) {
+		struct xfs_bmbt_irec		got;
+		struct xfs_ifork		*ifp;
+		xfs_fileoff_t			lblk;
+		xfs_extnum_t			idx;
+		bool				found;
+
+		lblk = XFS_B_TO_FSB(mp, i_size_read(VFS_I(sc->ip)));
+		ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+		while (found) {
+			if (got.br_startoff >= lblk &&
+			    got.br_state == XFS_EXT_NORM) {
+				ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+				break;
+			}
+			lblk = got.br_startoff + got.br_blockcount;
+			found = xfs_iext_get_extent(ifp, ++idx, &got);
+		}
+	}
+
+	/* Invalid uid/gid? */
+	if (ip->i_d.di_uid == cpu_to_be32(-1U)) {
+		ip->i_d.di_uid = 0;
+		VFS_I(ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_UQUOTA_ON(mp))
+			invalidate_quota = true;
+	}
+	if (ip->i_d.di_gid == cpu_to_be32(-1U)) {
+		ip->i_d.di_gid = 0;
+		VFS_I(ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_GQUOTA_ON(mp))
+			invalidate_quota = true;
+	}
+
+	/* Commit inode core changes. */
+	xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_roll(&sc->tp, ip);
+	if (error)
+		goto out;
+
+	/* We changed uid/gid, force a quotacheck. */
+	if (invalidate_quota) {
+		mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
+		spin_lock(&mp->m_sb_lock);
+		mp->m_sb.sb_qflags = mp->m_qflags & XFS_MOUNT_QUOTA_ALL;
+		spin_unlock(&mp->m_sb_lock);
+		xfs_log_sb(sc->tp);
+	}
+
+preen_only:
+	if (xfs_is_reflink_inode(sc->ip))
+		return xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 303afa9..62d0002 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -81,5 +81,6 @@ int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
 int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
+int xfs_repair_inode(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 2e2ed4a..47394a3 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -277,6 +277,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ /* inode record */
 		.setup	= xfs_scrub_setup_inode,
 		.scrub	= xfs_scrub_inode,
+		.repair	= xfs_repair_inode,
 	},
 	{ /* inode data fork */
 		.setup	= xfs_scrub_setup_inode_bmap_data,

