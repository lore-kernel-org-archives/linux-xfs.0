Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004F33DB80
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqJMF+aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9D8C433C7;
	Fri, 24 Nov 2023 23:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869974;
	bh=MbBh3kY1V4Kl0Z2yYej7WL9VvjqiYu/jxgQ58v4epPM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FqJMF+aM3856CuwRcWQ1RaP8EiiqZyDZosF938WgRn8u6HitT8X4f78wx8WRntNSo
	 nR4BBZyEs5CNCbe0szliyG7IBdlc1sh+Og+XZxklF0yXlisj4bH/i3ayH74a492iFm
	 YAYt9XU4jnFtxyniNn4yzZXf0hb+nk8uMCf6jHJOjmAFjKWY41RaC8q1Qrf4GXRlpF
	 oJiYvFL8LLvBlPjMdtl8VKLaV6ggH/pPgH5GVF4hTgZi7U+s7P8WiXv2fZtbQN5pQO
	 dvx/w30w1qtNAMZkDRkw7DM4yiUrqUnSNubZnvHlBxxgJr6r8R9kPjTBea4i0I9pZI
	 QJ/if/Guu86Vg==
Date: Fri, 24 Nov 2023 15:52:54 -0800
Subject: [PATCH 7/7] xfs: repair obviously broken inode modes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927551.2771142.12581005882564921107.stgit@frogsfrogsfrogs>
In-Reply-To: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Building off the rmap scanner that we added in the previous patch, we
can now find block 0 and try to use the information contained inside of
it to guess the mode of an inode if it's totally improper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |  181 +++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h        |   11 ++-
 2 files changed, 179 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a73205702ffa5..96114ed889707 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -56,10 +56,13 @@
  * fix things on live incore inodes.  The inode repair functions make decisions
  * with security and usability implications when reviving a file:
  *
- * - Files with zero di_mode or a garbage di_mode are converted to regular file
- *   that only root can read.  This file may not actually contain user data,
- *   if the file was not previously a regular file.  Setuid and setgid bits
- *   are cleared.
+ * - Files with zero di_mode or a garbage di_mode are converted to a file
+ *   that only root can read.  If the immediate data fork area or block 0 of
+ *   the data fork look like a directory, the file type will be set to a
+ *   directory.  If the immediate data fork area has no nulls, it will be
+ *   turned into a symbolic link.  Otherwise, it is turned into a regular file.
+ *   This file may not actually contain user data, if the file was not
+ *   previously a regular file.  Setuid and setgid bits are cleared.
  *
  * - Zero-size directories can be truncated to look empty.  It is necessary to
  *   run the bmapbtd and directory repair functions to fully rebuild the
@@ -107,6 +110,9 @@ struct xrep_inode {
 	/* Blocks in use by the attr fork. */
 	xfs_rfsblock_t		attr_blocks;
 
+	/* Physical block containing data block 0. */
+	xfs_fsblock_t		block0;
+
 	/* Number of data device extents for the data fork. */
 	xfs_extnum_t		data_extents;
 
@@ -146,6 +152,7 @@ xrep_setup_inode(
 	ri = sc->buf;
 	memcpy(&ri->imap, imap, sizeof(struct xfs_imap));
 	ri->sc = sc;
+	ri->block0 = NULLFSBLOCK;
 	return 0;
 }
 
@@ -221,12 +228,159 @@ xrep_dinode_header(
 	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
 }
 
+/* Parse enough of the directory block header to guess if this is a dir. */
+static inline bool
+xrep_dinode_is_dir(
+	xfs_ino_t			ino,
+	xfs_daddr_t			daddr,
+	struct xfs_buf			*bp)
+{
+	struct xfs_dir3_blk_hdr		*hdr3 = bp->b_addr;
+	struct xfs_dir2_data_free	*bf;
+	struct xfs_mount		*mp = bp->b_mount;
+	xfs_lsn_t			lsn = be64_to_cpu(hdr3->lsn);
+
+	/* Does the dir3 header match the filesystem? */
+	if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC) &&
+	    hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
+		return false;
+
+	if (be64_to_cpu(hdr3->owner) != ino)
+		return false;
+
+	if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
+		return false;
+
+	if (be64_to_cpu(hdr3->blkno) != daddr)
+		return false;
+
+	/* Directory blocks are always logged and must have a valid LSN. */
+	if (lsn == NULLCOMMITLSN)
+		return false;
+	if (!xlog_valid_lsn(mp->m_log, lsn))
+		return false;
+
+	/*
+	 * bestfree information lives immediately after the end of the header,
+	 * so we won't run off the end of the buffer.
+	 */
+	bf = xfs_dir2_data_bestfree_p(mp, bp->b_addr);
+	if (!bf[0].length && bf[0].offset)
+		return false;
+	if (!bf[1].length && bf[1].offset)
+		return false;
+	if (!bf[2].length && bf[2].offset)
+		return false;
+
+	if (be16_to_cpu(bf[0].length) < be16_to_cpu(bf[1].length))
+		return false;
+	if (be16_to_cpu(bf[1].length) < be16_to_cpu(bf[2].length))
+		return false;
+
+	return true;
+}
+
+/* Guess the mode of this file from the contents. */
+STATIC uint16_t
+xrep_dinode_guess_mode(
+	struct xrep_inode	*ri,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_buf		*bp;
+	struct xfs_mount	*mp = ri->sc->mp;
+	xfs_daddr_t		daddr;
+	uint64_t		fsize = be64_to_cpu(dip->di_size);
+	unsigned int		dfork_sz = XFS_DFORK_DSIZE(dip, mp);
+	uint16_t		mode = S_IFREG;
+	int			error;
+
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_LOCAL:
+		/*
+		 * If the data fork is local format, the size of the data area
+		 * is reasonable and is big enough to contain the entire file,
+		 * we can guess the file type from the local data.
+		 *
+		 * If there are no nulls, guess this is a symbolic link.
+		 * Otherwise, this is probably a shortform directory.
+		 */
+		if (dfork_sz <= XFS_LITINO(mp) && dfork_sz >= fsize) {
+			if (!memchr(XFS_DFORK_DPTR(dip), 0, fsize))
+				return S_IFLNK;
+			return S_IFDIR;
+		}
+
+		/* By default, we guess regular file. */
+		return S_IFREG;
+	case XFS_DINODE_FMT_DEV:
+		/*
+		 * If the data fork is dev format, the size of the data area is
+		 * reasonable and large enough to store a dev_t, and the file
+		 * size is zero, this could be a blockdev, a chardev, a fifo,
+		 * or a socket.  There is no solid way to distinguish between
+		 * those choices, so we guess blockdev if the device number is
+		 * nonzero and chardev if it's zero (aka whiteout).
+		 */
+		if (dfork_sz <= XFS_LITINO(mp) &&
+		    dfork_sz >= sizeof(__be32) && fsize == 0) {
+			xfs_dev_t	dev = xfs_dinode_get_rdev(dip);
+
+			return dev != 0 ? S_IFBLK : S_IFCHR;
+		}
+
+		/* By default, we guess regular file. */
+		return S_IFREG;
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		/* There are data blocks to examine below. */
+		break;
+	default:
+		/* Everything else is considered a regular file. */
+		return S_IFREG;
+	}
+
+	/* There are no zero-length directories. */
+	if (fsize == 0)
+		return S_IFREG;
+
+	/*
+	 * If we didn't find a written mapping for file block zero, we'll guess
+	 * that it's a sparse regular file.
+	 */
+	if (ri->block0 == NULLFSBLOCK)
+		return S_IFREG;
+
+	/* Directories can't have rt extents. */
+	if (ri->rt_extents > 0)
+		return S_IFREG;
+
+	/*
+	 * Read the first block of the file.  Since we have no idea what kind
+	 * of file geometry (e.g. dirblock size) we might be reading into, use
+	 * an uncached buffer so that we don't pollute the buffer cache.  We
+	 * can't do uncached mapped buffers, so the best we can do is guess
+	 * from the directory header.
+	 */
+	daddr = XFS_FSB_TO_DADDR(mp, ri->block0);
+	error = xfs_buf_read_uncached(mp->m_ddev_targp, daddr,
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
+		return S_IFREG;
+
+	if (xrep_dinode_is_dir(ri->sc->sm->sm_ino, daddr, bp))
+		mode = S_IFDIR;
+
+	xfs_buf_relse(bp);
+	return mode;
+}
+
 /* Turn di_mode into /something/ recognizable. */
 STATIC void
 xrep_dinode_mode(
-	struct xfs_scrub	*sc,
+	struct xrep_inode	*ri,
 	struct xfs_dinode	*dip)
 {
+	struct xfs_scrub	*sc = ri->sc;
 	uint16_t		mode;
 
 	trace_xrep_dinode_mode(sc, dip);
@@ -236,7 +390,7 @@ xrep_dinode_mode(
 		return;
 
 	/* bad mode, so we set it to a file that only root can read */
-	mode = S_IFREG;
+	mode = xrep_dinode_guess_mode(ri, dip);
 	dip->di_mode = cpu_to_be16(mode);
 	dip->di_uid = 0;
 	dip->di_gid = 0;
@@ -443,9 +597,17 @@ xrep_dinode_walk_rmap(
 	}
 
 	ri->data_blocks += rec->rm_blockcount;
-	if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+	if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK)) {
 		ri->data_extents++;
 
+		if (rec->rm_offset == 0 &&
+		    !(rec->rm_flags & XFS_RMAP_UNWRITTEN)) {
+			if (ri->block0 != NULLFSBLOCK)
+				return -EFSCORRUPTED;
+			ri->block0 = rec->rm_startblock;
+		}
+	}
+
 	return 0;
 }
 
@@ -496,7 +658,8 @@ xrep_dinode_count_rmaps(
 
 	trace_xrep_dinode_count_rmaps(ri->sc,
 			ri->data_blocks, ri->rt_blocks, ri->attr_blocks,
-			ri->data_extents, ri->rt_extents, ri->attr_extents);
+			ri->data_extents, ri->rt_extents, ri->attr_extents,
+			ri->block0);
 	return 0;
 }
 
@@ -1090,7 +1253,7 @@ xrep_dinode_core(
 	/* Fix everything the verifier will complain about. */
 	dip = xfs_buf_offset(bp, ri->imap.im_boffset);
 	xrep_dinode_header(sc, dip);
-	xrep_dinode_mode(sc, dip);
+	xrep_dinode_mode(ri, dip);
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(sc, dip);
 	xrep_dinode_extsize_hints(sc, dip);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 75f0d57088b29..6cd5d04c0410c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1530,9 +1530,9 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 	TP_PROTO(struct xfs_scrub *sc, xfs_rfsblock_t data_blocks,
 		xfs_rfsblock_t rt_blocks, xfs_rfsblock_t attr_blocks,
 		xfs_extnum_t data_extents, xfs_extnum_t rt_extents,
-		xfs_aextnum_t attr_extents),
+		xfs_aextnum_t attr_extents, xfs_fsblock_t block0),
 	TP_ARGS(sc, data_blocks, rt_blocks, attr_blocks, data_extents,
-		rt_extents, attr_extents),
+		rt_extents, attr_extents, block0),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -1542,6 +1542,7 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		__field(xfs_extnum_t, data_extents)
 		__field(xfs_extnum_t, rt_extents)
 		__field(xfs_aextnum_t, attr_extents)
+		__field(xfs_fsblock_t, block0)
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
@@ -1552,8 +1553,9 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		__entry->data_extents = data_extents;
 		__entry->rt_extents = rt_extents;
 		__entry->attr_extents = attr_extents;
+		__entry->block0 = block0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx dblocks 0x%llx rtblocks 0x%llx ablocks 0x%llx dextents %llu rtextents %llu aextents %u",
+	TP_printk("dev %d:%d ino 0x%llx dblocks 0x%llx rtblocks 0x%llx ablocks 0x%llx dextents %llu rtextents %llu aextents %u startblock0 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->data_blocks,
@@ -1561,7 +1563,8 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		  __entry->attr_blocks,
 		  __entry->data_extents,
 		  __entry->rt_extents,
-		  __entry->attr_extents)
+		  __entry->attr_extents,
+		  __entry->block0)
 );
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */

