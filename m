Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E703AF9F0
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001172; cv=none; b=Q2Q2u3KOlkzb6TDpaPlSTN9S7Jf+g9h2OP0hVpFNKv4WFWL8Z1SuRzjJPvUMtS3F2GJU/TqJLkE0OqVABOwUHfGGjGjB0875M+AqjzqxyRTFI/lPp0Dhy/AwRiSrh5EixZ/jxwrqY6QLwH1Gh98IY+C+7yDRjyfupynyvX9kwh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001172; c=relaxed/simple;
	bh=Dk5EqcLOU7gDaxLmc+E9n9aQ1UL6Lsjsp2cbH5TVaJA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jG9DGuRMfnCLq78MfRJQHMNs1BabDi+7hAoqQX0VcIFa+vtcc5UU7uZfdqMU5NllNC8xkZWUDLOoBpAhCa6u+ubRp+xz6eNMsJcjJ0BFH++oAO4mLf2595JVNTRxhWI93/khFuHR3OHSY1OjkuLA9YWbujy5pGwbp03/sMHW6Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjPHk0Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjPHk0Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1FBC433F1;
	Tue, 27 Feb 2024 02:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001171;
	bh=Dk5EqcLOU7gDaxLmc+E9n9aQ1UL6Lsjsp2cbH5TVaJA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hjPHk0TdrVV0l7tG00gKEg73/7RcyDAFaETb+wLj76Qb4Ygut56Dm8+NRsoFSR+2M
	 BFX53u+4xrh03ivL6ITgS8xLLyLhG8CJ9XwUT/q6NZKsGVjRgkgS9+ksTIoxhLZMG9
	 uNh2Ku2x0yARGTOZIcsEDx3k3Wo3BeaQZ1RrMCZSphu2CyaNp5Aj4s4wAJg54P9dgS
	 xhOj4l7MJmmMAmLEP6G1vJANIbMDSp3mK1Xu08ebPUtCGhr6F5/B2akzhh/rhnkpwT
	 8Fz/aZDrvkx0e4z7UYZOAxwkdWncasL9+UgTzU1Jo6P537jnTVBOUf6CCUQOYyxt7l
	 9tkfPszAJnvAQ==
Date: Mon, 26 Feb 2024 18:32:51 -0800
Subject: [PATCH 1/1] xfs: online repair of symbolic links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
In-Reply-To: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
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

If a symbolic link target looks bad, try to sift through the rubble to
find as much of the target buffer that we can, and stage a new target
(short or remote format as needed) in a temporary file and use the
atomic extent swapping mechanism to commit the results.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_bmap.c           |   11 -
 fs/xfs/libxfs/xfs_bmap.h           |    6 
 fs/xfs/libxfs/xfs_symlink_remote.c |    9 -
 fs/xfs/libxfs/xfs_symlink_remote.h |   22 +-
 fs/xfs/scrub/repair.h              |    8 +
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   13 +
 fs/xfs/scrub/symlink_repair.c      |  491 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.c            |    5 
 fs/xfs/scrub/trace.h               |   46 +++
 11 files changed, 599 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 464febc2f7cd2..4fef74547ed77 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -214,6 +214,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   refcount_repair.o \
 				   repair.o \
 				   rmap_repair.o \
+				   symlink_repair.o \
 				   tempfile.o \
 				   xfblob.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a1b27ac7a4505..e9e8b7338f220 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -779,7 +779,7 @@ xfs_bmap_local_to_extents_empty(
 }
 
 
-STATIC int				/* error */
+int					/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*ip,		/* incore inode pointer */
@@ -789,7 +789,8 @@ xfs_bmap_local_to_extents(
 	void		(*init_fn)(struct xfs_trans *tp,
 				   struct xfs_buf *bp,
 				   struct xfs_inode *ip,
-				   struct xfs_ifork *ifp))
+				   struct xfs_ifork *ifp, void *priv),
+	void		*priv)
 {
 	int		error = 0;
 	int		flags;		/* logging flags returned */
@@ -850,7 +851,7 @@ xfs_bmap_local_to_extents(
 	 * log here. Note that init_fn must also set the buffer log item type
 	 * correctly.
 	 */
-	init_fn(tp, bp, ip, ifp);
+	init_fn(tp, bp, ip, ifp, priv);
 
 	/* account for the change in fork size */
 	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
@@ -982,8 +983,8 @@ xfs_bmap_add_attrfork_local(
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		return xfs_bmap_local_to_extents(tp, ip, 1, flags,
-						 XFS_DATA_FORK,
-						 xfs_symlink_local_to_remote);
+				XFS_DATA_FORK, xfs_symlink_local_to_remote,
+				NULL);
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b8bdbf1560e65..32fb2a455c294 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -179,6 +179,12 @@ unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
+int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_extlen_t total, int *logflagsp, int whichfork,
+		void (*init_fn)(struct xfs_trans *tp, struct xfs_buf *bp,
+				struct xfs_inode *ip, struct xfs_ifork *ifp,
+				void *priv),
+		void *priv);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index df1db72a3b7f3..e04f3a4b27e4d 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -169,7 +169,8 @@ xfs_symlink_local_to_remote(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
+	struct xfs_ifork	*ifp,
+	void			*priv)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	char			*buf;
@@ -307,9 +308,10 @@ xfs_symlink_remote_read(
 
 /* Write the symlink target into the inode. */
 int
-xfs_symlink_write_target(
+__xfs_symlink_write_target(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	xfs_ino_t		owner,
 	const char		*target_path,
 	int			pathlen,
 	xfs_fsblock_t		fs_blocks,
@@ -364,8 +366,7 @@ xfs_symlink_write_target(
 		byte_cnt = min(byte_cnt, pathlen);
 
 		buf = bp->b_addr;
-		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset, byte_cnt,
-				bp);
+		buf += xfs_symlink_hdr_set(mp, owner, offset, byte_cnt, bp);
 
 		memcpy(buf, cur_chunk, byte_cnt);
 
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
index ac3dac8f617ed..e409d68013360 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -16,12 +16,26 @@ int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+				 struct xfs_inode *ip, struct xfs_ifork *ifp,
+				 void *priv);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
-int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
-		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
-		uint resblks);
+int __xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_ino_t owner, const char *target_path, int pathlen,
+		xfs_fsblock_t fs_blocks, uint resblks);
+
+static inline int
+xfs_symlink_write_target(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const char		*target_path,
+	int			pathlen,
+	xfs_fsblock_t		fs_blocks,
+	uint			resblks)
+{
+	return __xfs_symlink_write_target(tp, ip, ip->i_ino, target_path,
+			pathlen, fs_blocks, resblks);
+}
 int xfs_symlink_remote_truncate(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 7e6aba7fe5586..622eb486a16fb 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -94,6 +94,7 @@ int xrep_setup_xattr(struct xfs_scrub *sc);
 int xrep_setup_directory(struct xfs_scrub *sc);
 int xrep_setup_parent(struct xfs_scrub *sc);
 int xrep_setup_nlinks(struct xfs_scrub *sc);
+int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *resblks);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -130,6 +131,7 @@ int xrep_fscounters(struct xfs_scrub *sc);
 int xrep_xattr(struct xfs_scrub *sc);
 int xrep_directory(struct xfs_scrub *sc);
 int xrep_parent(struct xfs_scrub *sc);
+int xrep_symlink(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -206,6 +208,11 @@ xrep_setup_nothing(
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
+static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
+{
+	return 0;
+}
+
 #define xrep_revalidate_allocbt		(NULL)
 #define xrep_revalidate_iallocbt	(NULL)
 
@@ -231,6 +238,7 @@ xrep_setup_nothing(
 #define xrep_xattr			xrep_notsupported
 #define xrep_directory			xrep_notsupported
 #define xrep_parent			xrep_notsupported
+#define xrep_symlink			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6417628ce26be..301d5b753fdd5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -339,7 +339,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_symlink,
 		.scrub	= xchk_symlink,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_symlink,
 	},
 	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index d77d8a9598f63..c848bcc07cd5b 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -10,6 +10,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_symlink.h"
 #include "xfs_health.h"
@@ -17,18 +18,28 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/health.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub a symbolic link. */
 int
 xchk_setup_symlink(
 	struct xfs_scrub	*sc)
 {
+	unsigned int		resblks = 0;
+	int			error;
+
 	/* Allocate the buffer without the inode lock held. */
 	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
 
-	return xchk_setup_inode_contents(sc, 0);
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_symlink(sc, &resblks);
+		if (error)
+			return error;
+	}
+
+	return xchk_setup_inode_contents(sc, resblks);
 }
 
 /* Symbolic links. */
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
new file mode 100644
index 0000000000000..63f610d8b6fd5
--- /dev/null
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -0,0 +1,491 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_symlink.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_symlink_remote.h"
+#include "xfs_exchmaps.h"
+#include "xfs_exchrange.h"
+#include "xfs_health.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempexch.h"
+#include "scrub/reap.h"
+
+/*
+ * Symbolic Link Repair
+ * ====================
+ *
+ * We repair symbolic links by reading whatever target data we can find, up to
+ * the first NULL byte.  Zero length symlinks are turned into links to the
+ * current directory.  The new target is written into a private hidden
+ * temporary file, and then a file contents exchange commits the new symlink
+ * target to the file being repaired.
+ */
+
+/* Set us up to repair the rtsummary file. */
+int
+xrep_setup_symlink(
+	struct xfs_scrub	*sc,
+	unsigned int		*resblks)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	blocks;
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFLNK);
+	if (error)
+		return error;
+
+	/*
+	 * If we're doing a repair, we reserve enough blocks to write out a
+	 * completely new symlink file, plus twice as many blocks as we would
+	 * need if we can only allocate one block per data fork mapping.  This
+	 * should cover the preallocation of the temporary file and exchanging
+	 * the extent mappings.
+	 *
+	 * We cannot use xfs_exchmaps_estimate because we have not yet
+	 * constructed the replacement rtsummary and therefore do not know how
+	 * many extents it will use.  By the time we do, we will have a dirty
+	 * transaction (which we cannot drop because we cannot drop the
+	 * rtsummary ILOCK) and cannot ask for more reservation.
+	 */
+	blocks = xfs_symlink_blocks(sc->mp, XFS_SYMLINK_MAXLEN);
+	blocks += xfs_bmbt_calc_size(mp, blocks) * 2;
+	if (blocks > UINT_MAX)
+		return -EOPNOTSUPP;
+
+	*resblks += blocks;
+	return 0;
+}
+
+/*
+ * Try to salvage the pathname from remote blocks.  Returns the number of bytes
+ * salvaged or a negative errno.
+ */
+STATIC int
+xrep_symlink_salvage_remote(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_inode	*ip = sc->ip;
+	struct xfs_buf		*bp;
+	char			*target_buf = sc->buf;
+	xfs_failaddr_t		fa;
+	xfs_filblks_t		fsblocks;
+	xfs_daddr_t		d;
+	loff_t			len;
+	loff_t			offset = 0;
+	unsigned int		byte_cnt;
+	bool			magic_ok;
+	bool			hdr_ok;
+	int			n;
+	int			nmaps = XFS_SYMLINK_MAPS;
+	int			error;
+
+	/* We'll only read until the buffer is full. */
+	len = min_t(loff_t, ip->i_disk_size, XFS_SYMLINK_MAXLEN);
+	fsblocks = xfs_symlink_blocks(sc->mp, len);
+	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
+	if (error)
+		return error;
+
+	for (n = 0; n < nmaps; n++) {
+		struct xfs_dsymlink_hdr	*dsl;
+
+		d = XFS_FSB_TO_DADDR(sc->mp, mval[n].br_startblock);
+
+		/* Read the rmt block.  We'll run the verifiers manually. */
+		error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
+				d, XFS_FSB_TO_BB(sc->mp, mval[n].br_blockcount),
+				0, &bp, NULL);
+		if (error)
+			return error;
+		bp->b_ops = &xfs_symlink_buf_ops;
+
+		/* How many bytes do we expect to get out of this buffer? */
+		byte_cnt = XFS_FSB_TO_B(sc->mp, mval[n].br_blockcount);
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(sc->mp, byte_cnt);
+		byte_cnt = min_t(unsigned int, byte_cnt, len);
+
+		/*
+		 * See if the verifiers accept this block.  We're willing to
+		 * salvage if the if the offset/byte/ino are ok and either the
+		 * verifier passed or the magic is ok.  Anything else and we
+		 * stop dead in our tracks.
+		 */
+		fa = bp->b_ops->verify_struct(bp);
+		dsl = bp->b_addr;
+		magic_ok = dsl->sl_magic == cpu_to_be32(XFS_SYMLINK_MAGIC);
+		hdr_ok = xfs_symlink_hdr_ok(ip->i_ino, offset, byte_cnt, bp);
+		if (!hdr_ok || (fa != NULL && !magic_ok))
+			break;
+
+		memcpy(target_buf + offset, dsl + 1, byte_cnt);
+
+		len -= byte_cnt;
+		offset += byte_cnt;
+	}
+	return offset;
+}
+
+/*
+ * Try to salvage an inline symlink's contents.  Returns the number of bytes
+ * salvaged or a negative errno.
+ */
+STATIC int
+xrep_symlink_salvage_inline(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_inode	*ip = sc->ip;
+	char			*target_buf = sc->buf;
+	char			*old_target;
+	struct xfs_ifork	*ifp;
+	unsigned int		nr;
+
+	ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	if (!ifp->if_data)
+		return 0;
+
+	/*
+	 * If inode repair zapped the link target, pretend that we didn't find
+	 * any bytes at all so that we can replace the (now totally lost) link
+	 * target with a warning message.
+	 */
+	old_target = ifp->if_data;
+	if (xfs_inode_has_sickness(sc->ip, XFS_SICK_INO_SYMLINK_ZAPPED) &&
+	    sc->ip->i_disk_size == 1 && old_target[0] == '?')
+		return 0;
+
+	nr = min(XFS_SYMLINK_MAXLEN, xfs_inode_data_fork_size(ip));
+	strncpy(target_buf, ifp->if_data, nr);
+	return nr;
+}
+
+#define DUMMY_TARGET \
+	"The target of this symbolic link could not be recovered at all and " \
+	"has been replaced with this explanatory message.  To avoid " \
+	"accidentally pointing to an existing file path, this message is " \
+	"longer than the maximum supported file name length.  That is an " \
+	"acceptable length for a symlink target on XFS but will produce " \
+	"File Name Too Long errors if resolved."
+
+/* Salvage whatever we can of the target. */
+STATIC int
+xrep_symlink_salvage(
+	struct xfs_scrub	*sc)
+{
+	char			*target_buf = sc->buf;
+	int			ret;
+
+	BUILD_BUG_ON(sizeof(DUMMY_TARGET) - 1 <= NAME_MAX);
+
+	/* Find whatever we can of the link target. */
+	if (sc->ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		ret = xrep_symlink_salvage_inline(sc);
+	else
+		ret = xrep_symlink_salvage_remote(sc);
+	if (ret < 0)
+		return ret;
+	target_buf[ret] = 0;
+
+	/*
+	 * Change an empty target into a dummy target and clear the symlink
+	 * target zapped flag.
+	 */
+	if (target_buf[0] == 0) {
+		sc->sick_mask |= XFS_SICK_INO_SYMLINK_ZAPPED;
+		sprintf(target_buf, DUMMY_TARGET);
+	}
+
+	trace_xrep_symlink_salvage_target(sc->ip, target_buf,
+					  strlen(target_buf));
+	return 0;
+}
+
+STATIC void
+xrep_symlink_local_to_remote(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp,
+	void			*priv)
+{
+	struct xfs_scrub	*sc = priv;
+	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
+
+	xfs_symlink_local_to_remote(tp, bp, ip, ifp, NULL);
+
+	if (!xfs_has_crc(sc->mp))
+		return;
+
+	dsl->sl_owner = cpu_to_be64(sc->ip->i_ino);
+	xfs_trans_log_buf(tp, bp, 0,
+			  sizeof(struct xfs_dsymlink_hdr) + ifp->if_bytes - 1);
+}
+
+/*
+ * Prepare both links' data forks for an exchange.  Promote the tempfile from
+ * local format to extents format, and if the file being repaired has a short
+ * format data fork, turn it into an empty extent list.
+ */
+STATIC int
+xrep_symlink_swap_prep(
+	struct xfs_scrub	*sc,
+	bool			temp_local,
+	bool			ip_local)
+{
+	int			error;
+
+	/*
+	 * If the temp link is in shortform format, convert that to a remote
+	 * target so that we can use the atomic mapping exchange.
+	 */
+	if (temp_local) {
+		int		logflags = XFS_ILOG_CORE;
+
+		error = xfs_bmap_local_to_extents(sc->tp, sc->tempip, 1,
+				&logflags, XFS_DATA_FORK,
+				xrep_symlink_local_to_remote,
+				sc);
+		if (error)
+			return error;
+
+		xfs_trans_log_inode(sc->tp, sc->ip, 0);
+
+		error = xfs_defer_finish(&sc->tp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If the file being repaired had a shortform data fork, convert that
+	 * to an empty extent list in preparation for the atomic mapping
+	 * exchange.
+	 */
+	if (ip_local) {
+		struct xfs_ifork	*ifp;
+
+		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+		xfs_idestroy_fork(ifp);
+		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
+		ifp->if_nextents = 0;
+		ifp->if_bytes = 0;
+		ifp->if_data = NULL;
+		ifp->if_height = 0;
+
+		xfs_trans_log_inode(sc->tp, sc->ip,
+				XFS_ILOG_CORE | XFS_ILOG_DDATA);
+	}
+
+	return 0;
+}
+
+/* Exchange the temporary symlink's data fork with the one being repaired. */
+STATIC int
+xrep_symlink_swap(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_tempexch	*tx = sc->buf;
+	bool			ip_local, temp_local;
+	int			error;
+
+	ip_local = sc->ip->i_df.if_format == XFS_DINODE_FMT_LOCAL;
+	temp_local = sc->tempip->i_df.if_format == XFS_DINODE_FMT_LOCAL;
+
+	/*
+	 * If the both links have a local format data fork and the rebuilt
+	 * remote data would fit in the repaired file's data fork, copy the
+	 * contents from the tempfile and declare ourselves done.
+	 */
+	if (ip_local && temp_local &&
+	    sc->tempip->i_disk_size <= xfs_inode_data_fork_size(sc->ip)) {
+		xrep_tempfile_copyout_local(sc, XFS_DATA_FORK);
+		return 0;
+	}
+
+	/* Otherwise, make sure both data forks are in block-mapping mode. */
+	error = xrep_symlink_swap_prep(sc, temp_local, ip_local);
+	if (error)
+		return error;
+
+	return xrep_tempexch_contents(sc, tx);
+}
+
+/*
+ * Free all the remote blocks and reset the data fork.  The caller must join
+ * the inode to the transaction.  This function returns with the inode joined
+ * to a clean scrub transaction.
+ */
+STATIC int
+xrep_symlink_reset_fork(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->tempip, XFS_DATA_FORK);
+	int			error;
+
+	/* Unmap all the remote target buffers. */
+	if (xfs_ifork_has_extents(ifp)) {
+		error = xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	trace_xrep_symlink_reset_fork(sc->tempip);
+
+	/* Reset the temp symlink target to dummy content. */
+	xfs_idestroy_fork(ifp);
+	return xfs_symlink_write_target(sc->tp, sc->tempip, "?", 1, 0, 0);
+}
+
+/*
+ * Reinitialize a link target.  Caller must ensure the inode is joined to
+ * the transaction.
+ */
+STATIC int
+xrep_symlink_rebuild(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_tempexch	*tx;
+	char			*target_buf = sc->buf;
+	xfs_fsblock_t		fs_blocks;
+	unsigned int		target_len;
+	unsigned int		resblks;
+	int			error;
+
+	/* How many blocks do we need? */
+	target_len = strlen(target_buf);
+	ASSERT(target_len != 0);
+	if (target_len == 0 || target_len > XFS_SYMLINK_MAXLEN)
+		return -EFSCORRUPTED;
+
+	trace_xrep_symlink_rebuild(sc->ip);
+
+	/*
+	 * In preparation to write the new symlink target to the temporary
+	 * file, drop the ILOCK of the file being repaired (it shouldn't be
+	 * joined) and take the ILOCK of the temporary file.
+	 *
+	 * The VFS does not take the IOLOCK while reading a symlink (and new
+	 * symlinks are hidden with INEW until they've been written) so it's
+	 * possible that a readlink() could see the old corrupted contents
+	 * while we're doing this.
+	 */
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	xrep_tempfile_ilock(sc);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	/*
+	 * Reserve resources to reinitialize the target.  We're allowed to
+	 * exceed file quota to repair inconsistent metadata, though this is
+	 * unlikely.
+	 */
+	fs_blocks = xfs_symlink_blocks(sc->mp, target_len);
+	resblks = XFS_SYMLINK_SPACE_RES(sc->mp, target_len, fs_blocks);
+	error = xfs_trans_reserve_quota_nblks(sc->tp, sc->tempip, resblks, 0,
+			true);
+	if (error)
+		return error;
+
+	/* Erase the dummy target set up by the tempfile initialization. */
+	xfs_idestroy_fork(&sc->tempip->i_df);
+	sc->tempip->i_df.if_bytes = 0;
+	sc->tempip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+
+	/* Write the salvaged target to the temporary link. */
+	error = __xfs_symlink_write_target(sc->tp, sc->tempip, sc->ip->i_ino,
+			target_buf, target_len, fs_blocks, resblks);
+	if (error)
+		return error;
+
+	/*
+	 * Commit the repair transaction so that we can use the atomic mapping
+	 * exchange functions to compute the correct block reservations and
+	 * re-lock the inodes.
+	 */
+	target_buf = NULL;
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	xrep_tempfile_iunlock(sc);
+
+	/*
+	 * We're done with the temporary buffer, so we can reuse it for the
+	 * tempfile contents exchange information.
+	 */
+	tx = sc->buf;
+	error = xrep_tempexch_trans_alloc(sc, XFS_DATA_FORK, tx);
+	if (error)
+		return error;
+
+	/*
+	 * Exchange the temp link's data fork with the file being repaired.
+	 * This recreates the transaction and takes the ILOCKs of the file
+	 * being repaired and the temporary file.
+	 */
+	error = xrep_symlink_swap(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Release the old symlink blocks and reset the data fork of the temp
+	 * link to an empty shortform link.  This is the last repair action we
+	 * perform on the symlink, so we don't need to clean the transaction.
+	 */
+	return xrep_symlink_reset_fork(sc);
+}
+
+/* Repair a symbolic link. */
+int
+xrep_symlink(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	/* The rmapbt is required to reap the old data fork. */
+	if (!xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
+
+	error = xrep_symlink_salvage(sc);
+	if (error)
+		return error;
+
+	/* Now reset the target. */
+	error = xrep_symlink_rebuild(sc);
+	if (error)
+		return error;
+
+	return xrep_trans_commit(sc);
+}
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index dd031e6542aca..8046eb46f4a56 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -21,6 +21,7 @@
 #include "xfs_exchrange.h"
 #include "xfs_exchmaps.h"
 #include "xfs_defer.h"
+#include "xfs_symlink_remote.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -109,6 +110,10 @@ xrep_tempfile_create(
 		error = xfs_dir_init(tp, sc->tempip, dp);
 		if (error)
 			goto out_trans_cancel;
+	} else if (S_ISLNK(VFS_I(sc->tempip)->i_mode)) {
+		error = xfs_symlink_write_target(tp, sc->tempip, ".", 1, 0, 0);
+		if (error)
+			goto out_trans_cancel;
 	}
 
 	/*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 7915648012c66..4e9c9922a4140 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2705,6 +2705,52 @@ DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_alias);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_dentry);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_invalidate_child);
 
+TRACE_EVENT(xrep_symlink_salvage_target,
+	TP_PROTO(struct xfs_inode *ip, char *target, unsigned int targetlen),
+	TP_ARGS(ip, target, targetlen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, targetlen)
+		__dynamic_array(char, target, targetlen + 1)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->targetlen = targetlen;
+		memcpy(__get_str(target), target, targetlen);
+		__get_str(target)[targetlen] = 0;
+	),
+	TP_printk("dev %d:%d ip 0x%llx target '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->targetlen,
+		  __get_str(target))
+);
+
+DECLARE_EVENT_CLASS(xrep_symlink_class,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+	),
+	TP_printk("dev %d:%d ip 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino)
+);
+
+#define DEFINE_XREP_SYMLINK_EVENT(name) \
+DEFINE_EVENT(xrep_symlink_class, name, \
+	TP_PROTO(struct xfs_inode *ip), \
+	TP_ARGS(ip))
+DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_rebuild);
+DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_reset_fork);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

