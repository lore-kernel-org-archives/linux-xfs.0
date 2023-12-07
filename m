Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C7F1841
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="duiUUKnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD67C433C7;
	Thu,  7 Dec 2023 02:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916965;
	bh=Lvz3NUjamXX912IDrmdGNpP8H8BSlBRQs2PAiYcdFeQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=duiUUKnWVmbhrRgDFRQ5hB6AkXLKdChmx/955lnpBPu+q15OvzRnsCBfI1Oklocvf
	 8JikjwlapV+BwD2Kg6OoXZqoAaUZQE53/rVoik4oOz/r7uQFtL6gOtVvNKzKeaFWqy
	 VUb/LlDFhYQkInROdHcDaHYpltheYtrCeB5MZU9AP6mckm8mcOPwfVic7/NTUnUyY2
	 ak6+S7IJKAAQgL9VmhpHtybUzdWJVBCcHhvYw5dIIPca0SJ/li7vIwmFmxnVnu4FyK
	 hbHduTrSJJi5hEfBK4xFHxWJ4u0+Vfj8T+vXNNFKpOHEQe7R4PwHKRUrSU1KXWdyRC
	 LtdD20mYBbXSg==
Date: Wed, 06 Dec 2023 18:42:44 -0800
Subject: [PATCH 4/9] xfs: repair inode records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191666171.1182270.14955183758137681010.stgit@frogsfrogsfrogs>
In-Reply-To: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
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

If an inode is so badly damaged that it cannot be loaded into the cache,
fix the ondisk metadata and try again.  If there /is/ a cached inode,
fix any problems and apply any optimizations that can be solved incore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_format.h  |    2 
 fs/xfs/scrub/inode.c        |    8 
 fs/xfs/scrub/inode_repair.c |  809 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c       |   42 ++
 fs/xfs/scrub/repair.h       |   20 +
 fs/xfs/scrub/scrub.c        |    2 
 fs/xfs/scrub/trace.h        |  129 +++++++
 8 files changed, 1009 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7e1df6fdaaad2..561ab59b9422c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -184,6 +184,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
 				   ialloc_repair.o \
+				   inode_repair.o \
 				   newbt.o \
 				   reap.o \
 				   refcount_repair.o \
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9a88aba1589f8..f16974126ff92 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1008,7 +1008,7 @@ enum xfs_dinode_fmt {
  * Return pointers to the data or attribute forks.
  */
 #define XFS_DFORK_DPTR(dip) \
-	((char *)dip + xfs_dinode_size(dip->di_version))
+	((void *)dip + xfs_dinode_size(dip->di_version))
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6c40f3e020eae..6e2fe2d6250b3 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -25,6 +25,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /* Prepare the attached inode for scrubbing. */
 static inline int
@@ -185,8 +186,11 @@ xchk_setup_inode(
 	 * saying the inode is allocated and the icache being unable to load
 	 * the inode until we can flag the corruption in xchk_inode.  The
 	 * scrub function has to note the corruption, since we're not really
-	 * supposed to do that from the setup function.
+	 * supposed to do that from the setup function.  Save the mapping to
+	 * make repairs to the ondisk inode buffer.
 	 */
+	if (xchk_could_repair(sc))
+		xrep_setup_inode(sc, &imap);
 	return 0;
 
 out_cancel:
@@ -556,7 +560,7 @@ xchk_dinode(
 	}
 
 	/* di_forkoff */
-	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
+	if (XFS_DFORK_BOFF(dip) >= mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
 	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
new file mode 100644
index 0000000000000..491f3def7964b
--- /dev/null
+++ b/fs/xfs/scrub/inode_repair.c
@@ -0,0 +1,809 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
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
+#include "xfs_icache.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_ialloc.h"
+#include "xfs_da_format.h"
+#include "xfs_reflink.h"
+#include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_quota_defs.h"
+#include "xfs_quota.h"
+#include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Inode Record Repair
+ * ===================
+ *
+ * Roughly speaking, inode problems can be classified based on whether or not
+ * they trip the dinode verifiers.  If those trip, then we won't be able to
+ * xfs_iget ourselves the inode.
+ *
+ * Therefore, the xrep_dinode_* functions fix anything that will cause the
+ * inode buffer verifier or the dinode verifier.  The xrep_inode_* functions
+ * fix things on live incore inodes.  The inode repair functions make decisions
+ * with security and usability implications when reviving a file:
+ *
+ * - Files with zero di_mode or a garbage di_mode are converted to regular file
+ *   that only root can read.  This file may not actually contain user data,
+ *   if the file was not previously a regular file.  Setuid and setgid bits
+ *   are cleared.
+ *
+ * - Zero-size directories can be truncated to look empty.  It is necessary to
+ *   run the bmapbtd and directory repair functions to fully rebuild the
+ *   directory.
+ *
+ * - Zero-size symbolic link targets can be truncated to '.'.  It is necessary
+ *   to run the bmapbtd and symlink repair functions to salvage the symlink.
+ *
+ * - Invalid extent size hints will be removed.
+ *
+ * - Quotacheck will be scheduled if we repaired an inode that was so badly
+ *   damaged that the ondisk inode had to be rebuilt.
+ *
+ * - Invalid user, group, or project IDs (aka -1U) will be reset to zero.
+ *   Setuid and setgid bits are cleared.
+ */
+
+/*
+ * All the information we need to repair the ondisk inode if we can't iget the
+ * incore inode.  We don't allocate this buffer unless we're going to perform
+ * a repair to the ondisk inode cluster buffer.
+ */
+struct xrep_inode {
+	/* Inode mapping that we saved from the initial lookup attempt. */
+	struct xfs_imap		imap;
+
+	struct xfs_scrub	*sc;
+};
+
+/*
+ * Setup function for inode repair.  @imap contains the ondisk inode mapping
+ * information so that we can correct the ondisk inode cluster buffer if
+ * necessary to make iget work.
+ */
+int
+xrep_setup_inode(
+	struct xfs_scrub	*sc,
+	const struct xfs_imap	*imap)
+{
+	struct xrep_inode	*ri;
+
+	sc->buf = kzalloc(sizeof(struct xrep_inode), XCHK_GFP_FLAGS);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	ri = sc->buf;
+	memcpy(&ri->imap, imap, sizeof(struct xfs_imap));
+	ri->sc = sc;
+	return 0;
+}
+
+/*
+ * Make sure this ondisk inode can pass the inode buffer verifier.  This is
+ * not the same as the dinode verifier.
+ */
+STATIC void
+xrep_dinode_buf_core(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp,
+	unsigned int		ioffset)
+{
+	struct xfs_dinode	*dip = xfs_buf_offset(bp, ioffset);
+	struct xfs_trans	*tp = sc->tp;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_agino_t		agino;
+	bool			crc_ok = false;
+	bool			magic_ok = false;
+	bool			unlinked_ok = false;
+
+	agino = be32_to_cpu(dip->di_next_unlinked);
+
+	if (xfs_verify_agino_or_null(bp->b_pag, agino))
+		unlinked_ok = true;
+
+	if (dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
+	    xfs_dinode_good_version(mp, dip->di_version))
+		magic_ok = true;
+
+	if (xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+			XFS_DINODE_CRC_OFF))
+		crc_ok = true;
+
+	if (magic_ok && unlinked_ok && crc_ok)
+		return;
+
+	if (!magic_ok) {
+		dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+		dip->di_version = 3;
+	}
+	if (!unlinked_ok)
+		dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+	xfs_dinode_calc_crc(mp, dip);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
+	xfs_trans_log_buf(tp, bp, ioffset,
+				  ioffset + sizeof(struct xfs_dinode) - 1);
+}
+
+/* Make sure this inode cluster buffer can pass the inode buffer verifier. */
+STATIC void
+xrep_dinode_buf(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = sc->mp;
+	int			i;
+	int			ni;
+
+	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
+	for (i = 0; i < ni; i++)
+		xrep_dinode_buf_core(sc, bp, i << mp->m_sb.sb_inodelog);
+}
+
+/* Reinitialize things that never change in an inode. */
+STATIC void
+xrep_dinode_header(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	trace_xrep_dinode_header(sc, dip);
+
+	dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+	if (!xfs_dinode_good_version(sc->mp, dip->di_version))
+		dip->di_version = 3;
+	dip->di_ino = cpu_to_be64(sc->sm->sm_ino);
+	uuid_copy(&dip->di_uuid, &sc->mp->m_sb.sb_meta_uuid);
+	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
+}
+
+/* Turn di_mode into /something/ recognizable. */
+STATIC void
+xrep_dinode_mode(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	uint16_t		mode = be16_to_cpu(dip->di_mode);
+
+	trace_xrep_dinode_mode(sc, dip);
+
+	if (mode == 0 || xfs_mode_to_ftype(mode) != XFS_DIR3_FT_UNKNOWN)
+		return;
+
+	/* bad mode, so we set it to a file that only root can read */
+	mode = S_IFREG;
+	dip->di_mode = cpu_to_be16(mode);
+	dip->di_uid = 0;
+	dip->di_gid = 0;
+}
+
+/* Fix any conflicting flags that the verifiers complain about. */
+STATIC void
+xrep_dinode_flags(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	uint64_t		flags2 = be64_to_cpu(dip->di_flags2);
+	uint16_t		flags = be16_to_cpu(dip->di_flags);
+	uint16_t		mode = be16_to_cpu(dip->di_mode);
+
+	trace_xrep_dinode_flags(sc, dip);
+
+	/*
+	 * For regular files on a reflink filesystem, set the REFLINK flag to
+	 * protect shared extents.  A later stage will actually check those
+	 * extents and clear the flag if possible.
+	 */
+	if (xfs_has_reflink(mp) && S_ISREG(mode))
+		flags2 |= XFS_DIFLAG2_REFLINK;
+	else
+		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
+	if (flags & XFS_DIFLAG_REALTIME)
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
+	if (!xfs_has_bigtime(mp))
+		flags2 &= ~XFS_DIFLAG2_BIGTIME;
+	if (!xfs_has_large_extent_counts(mp))
+		flags2 &= ~XFS_DIFLAG2_NREXT64;
+	if (flags2 & XFS_DIFLAG2_NREXT64)
+		dip->di_nrext64_pad = 0;
+	else if (dip->di_version >= 3)
+		dip->di_v3_pad = 0;
+	dip->di_flags = cpu_to_be16(flags);
+	dip->di_flags2 = cpu_to_be64(flags2);
+}
+
+/*
+ * Blow out symlink; now it points nowhere.  We don't have to worry about
+ * incore state because this inode is failing the verifiers.
+ */
+STATIC void
+xrep_dinode_zap_symlink(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	char			*p;
+
+	trace_xrep_dinode_zap_symlink(sc, dip);
+
+	dip->di_format = XFS_DINODE_FMT_LOCAL;
+	dip->di_size = cpu_to_be64(1);
+	p = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	*p = '?';
+}
+
+/*
+ * Blow out dir, make the parent point to the root.  In the future repair will
+ * reconstruct this directory for us.  Note that there's no in-core directory
+ * inode because the sf verifier tripped, so we don't have to worry about the
+ * dentry cache.
+ */
+STATIC void
+xrep_dinode_zap_dir(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_dir2_sf_hdr	*sfp;
+	int			i8count;
+
+	trace_xrep_dinode_zap_dir(sc, dip);
+
+	dip->di_format = XFS_DINODE_FMT_LOCAL;
+	i8count = mp->m_sb.sb_rootino > XFS_DIR2_MAX_SHORT_INUM;
+	sfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	sfp->count = 0;
+	sfp->i8count = i8count;
+	xfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
+	dip->di_size = cpu_to_be64(xfs_dir2_sf_hdr_size(i8count));
+}
+
+/* Make sure we don't have a garbage file size. */
+STATIC void
+xrep_dinode_size(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	uint64_t		size = be64_to_cpu(dip->di_size);
+	uint16_t		mode = be16_to_cpu(dip->di_mode);
+
+	trace_xrep_dinode_size(sc, dip);
+
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		/* di_size can't be nonzero for special files */
+		dip->di_size = 0;
+		break;
+	case S_IFREG:
+		/* Regular files can't be larger than 2^63-1 bytes. */
+		dip->di_size = cpu_to_be64(size & ~(1ULL << 63));
+		break;
+	case S_IFLNK:
+		/*
+		 * Truncate ridiculously oversized symlinks.  If the size is
+		 * zero, reset it to point to the current directory.  Both of
+		 * these conditions trigger dinode verifier errors, so there
+		 * is no in-core state to reset.
+		 */
+		if (size > XFS_SYMLINK_MAXLEN)
+			dip->di_size = cpu_to_be64(XFS_SYMLINK_MAXLEN);
+		else if (size == 0)
+			xrep_dinode_zap_symlink(sc, dip);
+		break;
+	case S_IFDIR:
+		/*
+		 * Directories can't have a size larger than 32G.  If the size
+		 * is zero, reset it to an empty directory.  Both of these
+		 * conditions trigger dinode verifier errors, so there is no
+		 * in-core state to reset.
+		 */
+		if (size > XFS_DIR2_SPACE_SIZE)
+			dip->di_size = cpu_to_be64(XFS_DIR2_SPACE_SIZE);
+		else if (size == 0)
+			xrep_dinode_zap_dir(sc, dip);
+		break;
+	}
+}
+
+/* Fix extent size hints. */
+STATIC void
+xrep_dinode_extsize_hints(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	uint64_t		flags2 = be64_to_cpu(dip->di_flags2);
+	uint16_t		flags = be16_to_cpu(dip->di_flags);
+	uint16_t		mode = be16_to_cpu(dip->di_mode);
+
+	xfs_failaddr_t		fa;
+
+	trace_xrep_dinode_extsize_hints(sc, dip);
+
+	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
+			mode, flags);
+	if (fa) {
+		dip->di_extsize = 0;
+		dip->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
+					      XFS_DIFLAG_EXTSZINHERIT);
+	}
+
+	if (dip->di_version < 3)
+		return;
+
+	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
+			mode, flags, flags2);
+	if (fa) {
+		dip->di_cowextsize = 0;
+		dip->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
+	}
+}
+
+/* Inode didn't pass dinode verifiers, so fix the raw buffer and retry iget. */
+STATIC int
+xrep_dinode_core(
+	struct xrep_inode	*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_buf		*bp;
+	struct xfs_dinode	*dip;
+	xfs_ino_t		ino = sc->sm->sm_ino;
+	int			error;
+	int			iget_error;
+
+	/* Read the inode cluster buffer. */
+	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
+			ri->imap.im_blkno, ri->imap.im_len, XBF_UNMAPPED, &bp,
+			NULL);
+	if (error)
+		return error;
+
+	/* Make sure we can pass the inode buffer verifier. */
+	xrep_dinode_buf(sc, bp);
+	bp->b_ops = &xfs_inode_buf_ops;
+
+	/* Fix everything the verifier will complain about. */
+	dip = xfs_buf_offset(bp, ri->imap.im_boffset);
+	xrep_dinode_header(sc, dip);
+	xrep_dinode_mode(sc, dip);
+	xrep_dinode_flags(sc, dip);
+	xrep_dinode_size(sc, dip);
+	xrep_dinode_extsize_hints(sc, dip);
+
+	/* Write out the inode. */
+	trace_xrep_dinode_fixed(sc, dip);
+	xfs_dinode_calc_crc(sc->mp, dip);
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);
+	xfs_trans_log_buf(sc->tp, bp, ri->imap.im_boffset,
+			ri->imap.im_boffset + sc->mp->m_sb.sb_inodesize - 1);
+
+	/*
+	 * In theory, we've fixed the ondisk inode record enough that we should
+	 * be able to load the inode into the cache.  Try to iget that inode
+	 * now while we hold the AGI and the inode cluster buffer and take the
+	 * IOLOCK so that we can continue with repairs without anyone else
+	 * accessing the inode.  If iget fails, we still need to commit the
+	 * changes.
+	 */
+	iget_error = xchk_iget(sc, ino, &sc->ip);
+	if (!iget_error)
+		xchk_ilock(sc, XFS_IOLOCK_EXCL);
+
+	/*
+	 * Commit the inode cluster buffer updates and drop the AGI buffer that
+	 * we've been holding since scrub setup.  From here on out, repairs
+	 * deal only with the cached inode.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	if (iget_error)
+		return iget_error;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	error = xrep_ino_dqattach(sc);
+	if (error)
+		return error;
+
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/* Fix everything xfs_dinode_verify cares about. */
+STATIC int
+xrep_dinode_problems(
+	struct xrep_inode	*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	int			error;
+
+	error = xrep_dinode_core(ri);
+	if (error)
+		return error;
+
+	/* We had to fix a totally busted inode, schedule quotacheck. */
+	if (XFS_IS_UQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+	if (XFS_IS_GQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+	if (XFS_IS_PQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+
+	return 0;
+}
+
+/*
+ * Fix problems that the verifiers don't care about.  In general these are
+ * errors that don't cause problems elsewhere in the kernel that we can easily
+ * detect, so we don't check them all that rigorously.
+ */
+
+/* Make sure block and extent counts are ok. */
+STATIC int
+xrep_inode_blockcounts(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp;
+	xfs_filblks_t		count;
+	xfs_filblks_t		acount;
+	xfs_extnum_t		nextents;
+	int			error;
+
+	trace_xrep_inode_blockcounts(sc);
+
+	/* Set data fork counters from the data fork mappings. */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (error)
+		return error;
+	if (xfs_is_reflink_inode(sc->ip)) {
+		/*
+		 * data fork blockcount can exceed physical storage if a user
+		 * reflinks the same block over and over again.
+		 */
+		;
+	} else if (XFS_IS_REALTIME_INODE(sc->ip)) {
+		if (count >= sc->mp->m_sb.sb_rblocks)
+			return -EFSCORRUPTED;
+	} else {
+		if (count >= sc->mp->m_sb.sb_dblocks)
+			return -EFSCORRUPTED;
+	}
+	error = xrep_ino_ensure_extent_count(sc, XFS_DATA_FORK, nextents);
+	if (error)
+		return error;
+	sc->ip->i_df.if_nextents = nextents;
+
+	/* Set attr fork counters from the attr fork mappings. */
+	ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
+	if (ifp) {
+		error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+				&nextents, &acount);
+		if (error)
+			return error;
+		if (count >= sc->mp->m_sb.sb_dblocks)
+			return -EFSCORRUPTED;
+		error = xrep_ino_ensure_extent_count(sc, XFS_ATTR_FORK,
+				nextents);
+		if (error)
+			return error;
+		ifp->if_nextents = nextents;
+	} else {
+		acount = 0;
+	}
+
+	sc->ip->i_nblocks = count + acount;
+	return 0;
+}
+
+/* Check for invalid uid/gid/prid. */
+STATIC void
+xrep_inode_ids(
+	struct xfs_scrub	*sc)
+{
+	bool			dirty = false;
+
+	trace_xrep_inode_ids(sc);
+
+	if (!uid_valid(VFS_I(sc->ip)->i_uid)) {
+		i_uid_write(VFS_I(sc->ip), 0);
+		dirty = true;
+		if (XFS_IS_UQUOTA_ON(sc->mp))
+			xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+	}
+
+	if (!gid_valid(VFS_I(sc->ip)->i_gid)) {
+		i_gid_write(VFS_I(sc->ip), 0);
+		dirty = true;
+		if (XFS_IS_GQUOTA_ON(sc->mp))
+			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+	}
+
+	if (sc->ip->i_projid == -1U) {
+		sc->ip->i_projid = 0;
+		dirty = true;
+		if (XFS_IS_PQUOTA_ON(sc->mp))
+			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+	}
+
+	/* strip setuid/setgid if we touched any of the ids */
+	if (dirty)
+		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
+}
+
+static inline void
+xrep_clamp_timestamp(
+	struct xfs_inode	*ip,
+	struct timespec64	*ts)
+{
+	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC);
+	*ts = timestamp_truncate(*ts, VFS_I(ip));
+}
+
+/* Nanosecond counters can't have more than 1 billion. */
+STATIC void
+xrep_inode_timestamps(
+	struct xfs_inode	*ip)
+{
+	struct timespec64	tstamp;
+	struct inode		*inode = VFS_I(ip);
+
+	tstamp = inode_get_atime(inode);
+	xrep_clamp_timestamp(ip, &tstamp);
+	inode_set_atime_to_ts(inode, tstamp);
+
+	tstamp = inode_get_mtime(inode);
+	xrep_clamp_timestamp(ip, &tstamp);
+	inode_set_mtime_to_ts(inode, tstamp);
+
+	tstamp = inode_get_ctime(inode);
+	xrep_clamp_timestamp(ip, &tstamp);
+	inode_set_ctime_to_ts(inode, tstamp);
+
+	xrep_clamp_timestamp(ip, &ip->i_crtime);
+}
+
+/* Fix inode flags that don't make sense together. */
+STATIC void
+xrep_inode_flags(
+	struct xfs_scrub	*sc)
+{
+	uint16_t		mode;
+
+	trace_xrep_inode_flags(sc);
+
+	mode = VFS_I(sc->ip)->i_mode;
+
+	/* Clear junk flags */
+	if (sc->ip->i_diflags & ~XFS_DIFLAG_ANY)
+		sc->ip->i_diflags &= ~XFS_DIFLAG_ANY;
+
+	/* NEWRTBM only applies to realtime bitmaps */
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_rbmino)
+		sc->ip->i_diflags |= XFS_DIFLAG_NEWRTBM;
+	else
+		sc->ip->i_diflags &= ~XFS_DIFLAG_NEWRTBM;
+
+	/* These only make sense for directories. */
+	if (!S_ISDIR(mode))
+		sc->ip->i_diflags &= ~(XFS_DIFLAG_RTINHERIT |
+					  XFS_DIFLAG_EXTSZINHERIT |
+					  XFS_DIFLAG_PROJINHERIT |
+					  XFS_DIFLAG_NOSYMLINKS);
+
+	/* These only make sense for files. */
+	if (!S_ISREG(mode))
+		sc->ip->i_diflags &= ~(XFS_DIFLAG_REALTIME |
+					  XFS_DIFLAG_EXTSIZE);
+
+	/* These only make sense for non-rt files. */
+	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_diflags &= ~XFS_DIFLAG_FILESTREAM;
+
+	/* Immutable and append only?  Drop the append. */
+	if ((sc->ip->i_diflags & XFS_DIFLAG_IMMUTABLE) &&
+	    (sc->ip->i_diflags & XFS_DIFLAG_APPEND))
+		sc->ip->i_diflags &= ~XFS_DIFLAG_APPEND;
+
+	/* Clear junk flags. */
+	if (sc->ip->i_diflags2 & ~XFS_DIFLAG2_ANY)
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_ANY;
+
+	/* No reflink flag unless we support it and it's a file. */
+	if (!xfs_has_reflink(sc->mp) || !S_ISREG(mode))
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	/* DAX only applies to files and dirs. */
+	if (!(S_ISREG(mode) || S_ISDIR(mode)))
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
+
+	/* No reflink files on the realtime device. */
+	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+}
+
+/*
+ * Fix size problems with block/node format directories.  If we fail to find
+ * the extent list, just bail out and let the bmapbtd repair functions clean
+ * up that mess.
+ */
+STATIC void
+xrep_inode_blockdir_size(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		off;
+	int			error;
+
+	trace_xrep_inode_blockdir_size(sc);
+
+	error = xfs_iread_extents(sc->tp, sc->ip, XFS_DATA_FORK);
+	if (error)
+		return;
+
+	/* Find the last block before 32G; this is the dir size. */
+	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+	off = XFS_B_TO_FSB(sc->mp, XFS_DIR2_SPACE_SIZE);
+	if (!xfs_iext_lookup_extent_before(sc->ip, ifp, &off, &icur, &got)) {
+		/* zero-extents directory? */
+		return;
+	}
+
+	off = got.br_startoff + got.br_blockcount;
+	sc->ip->i_disk_size = min_t(loff_t, XFS_DIR2_SPACE_SIZE,
+			XFS_FSB_TO_B(sc->mp, off));
+}
+
+/* Fix size problems with short format directories. */
+STATIC void
+xrep_inode_sfdir_size(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp;
+
+	trace_xrep_inode_sfdir_size(sc);
+
+	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+	sc->ip->i_disk_size = ifp->if_bytes;
+}
+
+/*
+ * Fix any irregularities in a directory inode's size now that we can iterate
+ * extent maps and access other regular inode data.
+ */
+STATIC void
+xrep_inode_dir_size(
+	struct xfs_scrub	*sc)
+{
+	trace_xrep_inode_dir_size(sc);
+
+	switch (sc->ip->i_df.if_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		xrep_inode_blockdir_size(sc);
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		xrep_inode_sfdir_size(sc);
+		break;
+	}
+}
+
+/* Fix extent size hint problems. */
+STATIC void
+xrep_inode_extsize(
+	struct xfs_scrub	*sc)
+{
+	/* Fix misaligned extent size hints on a directory. */
+	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (sc->ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
+	    xfs_extlen_to_rtxmod(sc->mp, sc->ip->i_extsize) > 0) {
+		sc->ip->i_extsize = 0;
+		sc->ip->i_diflags &= ~XFS_DIFLAG_EXTSZINHERIT;
+	}
+}
+
+/* Fix any irregularities in an inode that the verifiers don't catch. */
+STATIC int
+xrep_inode_problems(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xrep_inode_blockcounts(sc);
+	if (error)
+		return error;
+	xrep_inode_timestamps(sc->ip);
+	xrep_inode_flags(sc);
+	xrep_inode_ids(sc);
+	/*
+	 * We can now do a better job fixing the size of a directory now that
+	 * we can scan the data fork extents than we could in xrep_dinode_size.
+	 */
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
+		xrep_inode_dir_size(sc);
+	xrep_inode_extsize(sc);
+
+	trace_xrep_inode_fixed(sc);
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return xrep_roll_trans(sc);
+}
+
+/* Repair an inode's fields. */
+int
+xrep_inode(
+	struct xfs_scrub	*sc)
+{
+	int			error = 0;
+
+	/*
+	 * No inode?  That means we failed the _iget verifiers.  Repair all
+	 * the things that the inode verifiers care about, then retry _iget.
+	 */
+	if (!sc->ip) {
+		struct xrep_inode	*ri = sc->buf;
+
+		ASSERT(ri != NULL);
+
+		error = xrep_dinode_problems(ri);
+		if (error)
+			return error;
+
+		/* By this point we had better have a working incore inode. */
+		if (!sc->ip)
+			return -EFSCORRUPTED;
+	}
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* If we found corruption of any kind, try to fix it. */
+	if ((sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT) ||
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)) {
+		error = xrep_inode_problems(sc);
+		if (error)
+			return error;
+	}
+
+	/* See if we can clear the reflink flag. */
+	if (xfs_is_reflink_inode(sc->ip)) {
+		error = xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+		if (error)
+			return error;
+	}
+
+	return xrep_defer_finish(sc);
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 021f6ec72e873..25392dea326d7 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -176,6 +176,16 @@ xrep_roll_ag_trans(
 	return 0;
 }
 
+/* Roll the scrub transaction, holding the primary metadata locked. */
+int
+xrep_roll_trans(
+	struct xfs_scrub	*sc)
+{
+	if (!sc->ip)
+		return xrep_roll_ag_trans(sc);
+	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+}
+
 /* Finish all deferred work attached to the repair transaction. */
 int
 xrep_defer_finish(
@@ -740,6 +750,38 @@ xrep_ino_dqattach(
 }
 #endif /* CONFIG_XFS_QUOTA */
 
+/*
+ * Ensure that the inode being repaired is ready to handle a certain number of
+ * extents, or return EFSCORRUPTED.  Caller must hold the ILOCK of the inode
+ * being repaired and have joined it to the scrub transaction.
+ */
+int
+xrep_ino_ensure_extent_count(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	xfs_extnum_t		nextents)
+{
+	xfs_extnum_t		max_extents;
+	bool			inode_has_nrext64;
+
+	inode_has_nrext64 = xfs_inode_has_large_extent_counts(sc->ip);
+	max_extents = xfs_iext_max_nextents(inode_has_nrext64, whichfork);
+	if (nextents <= max_extents)
+		return 0;
+	if (inode_has_nrext64)
+		return -EFSCORRUPTED;
+	if (!xfs_has_large_extent_counts(sc->mp))
+		return -EFSCORRUPTED;
+
+	max_extents = xfs_iext_max_nextents(true, whichfork);
+	if (nextents > max_extents)
+		return -EFSCORRUPTED;
+
+	sc->ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 /*
  * Initialize all the btree cursors for an AG repair except for the btree that
  * we're rebuilding.
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 93814acc678a8..a513b84f5330a 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -30,11 +30,22 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 int xrep_attempt(struct xfs_scrub *sc, struct xchk_stats_run *run);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
+int xrep_roll_trans(struct xfs_scrub *sc);
 int xrep_defer_finish(struct xfs_scrub *sc);
 bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
 		enum xfs_ag_resv_type type);
 xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub *sc);
 
+static inline int
+xrep_trans_commit(
+	struct xfs_scrub	*sc)
+{
+	int error = xfs_trans_commit(sc->tp);
+
+	sc->tp = NULL;
+	return error;
+}
+
 struct xbitmap;
 struct xagb_bitmap;
 
@@ -66,11 +77,16 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
 # define xrep_ino_dqattach(sc)			(0)
 #endif /* CONFIG_XFS_QUOTA */
 
+int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
+		xfs_extnum_t nextents);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
 
+struct xfs_imap;
+int xrep_setup_inode(struct xfs_scrub *sc, const struct xfs_imap *imap);
+
 void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 
 /* Metadata revalidators */
@@ -88,6 +104,7 @@ int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
 int xrep_refcountbt(struct xfs_scrub *sc);
+int xrep_inode(struct xfs_scrub *sc);
 
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
@@ -133,6 +150,8 @@ xrep_setup_nothing(
 }
 #define xrep_setup_ag_allocbt		xrep_setup_nothing
 
+#define xrep_setup_inode(sc, imap)	((void)0)
+
 #define xrep_revalidate_allocbt		(NULL)
 #define xrep_revalidate_iallocbt	(NULL)
 
@@ -144,6 +163,7 @@ xrep_setup_nothing(
 #define xrep_allocbt			xrep_notsupported
 #define xrep_iallocbt			xrep_notsupported
 #define xrep_refcountbt			xrep_notsupported
+#define xrep_inode			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6ff4dc57095fc..7e903a0fde6cd 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -282,7 +282,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode,
 		.scrub	= xchk_inode,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_inode,
 	},
 	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3f7af44309515..6041c716242aa 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1393,6 +1393,135 @@ DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_file_blocks);
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_free_blocks);
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_claim_block);
 
+DECLARE_EVENT_CLASS(xrep_dinode_class,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_dinode *dip),
+	TP_ARGS(sc, dip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(uint16_t, mode)
+		__field(uint8_t, version)
+		__field(uint8_t, format)
+		__field(uint32_t, uid)
+		__field(uint32_t, gid)
+		__field(uint64_t, size)
+		__field(uint64_t, nblocks)
+		__field(uint32_t, extsize)
+		__field(uint32_t, nextents)
+		__field(uint16_t, anextents)
+		__field(uint8_t, forkoff)
+		__field(uint8_t, aformat)
+		__field(uint16_t, flags)
+		__field(uint32_t, gen)
+		__field(uint64_t, flags2)
+		__field(uint32_t, cowextsize)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->sm->sm_ino;
+		__entry->mode = be16_to_cpu(dip->di_mode);
+		__entry->version = dip->di_version;
+		__entry->format = dip->di_format;
+		__entry->uid = be32_to_cpu(dip->di_uid);
+		__entry->gid = be32_to_cpu(dip->di_gid);
+		__entry->size = be64_to_cpu(dip->di_size);
+		__entry->nblocks = be64_to_cpu(dip->di_nblocks);
+		__entry->extsize = be32_to_cpu(dip->di_extsize);
+		__entry->nextents = be32_to_cpu(dip->di_nextents);
+		__entry->anextents = be16_to_cpu(dip->di_anextents);
+		__entry->forkoff = dip->di_forkoff;
+		__entry->aformat = dip->di_aformat;
+		__entry->flags = be16_to_cpu(dip->di_flags);
+		__entry->gen = be32_to_cpu(dip->di_gen);
+		__entry->flags2 = be64_to_cpu(dip->di_flags2);
+		__entry->cowextsize = be32_to_cpu(dip->di_cowextsize);
+	),
+	TP_printk("dev %d:%d ino 0x%llx mode 0x%x version %u format %u uid %u gid %u disize 0x%llx nblocks 0x%llx extsize %u nextents %u anextents %u forkoff 0x%x aformat %u flags 0x%x gen 0x%x flags2 0x%llx cowextsize %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->mode,
+		  __entry->version,
+		  __entry->format,
+		  __entry->uid,
+		  __entry->gid,
+		  __entry->size,
+		  __entry->nblocks,
+		  __entry->extsize,
+		  __entry->nextents,
+		  __entry->anextents,
+		  __entry->forkoff,
+		  __entry->aformat,
+		  __entry->flags,
+		  __entry->gen,
+		  __entry->flags2,
+		  __entry->cowextsize)
+)
+
+#define DEFINE_REPAIR_DINODE_EVENT(name) \
+DEFINE_EVENT(xrep_dinode_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_dinode *dip), \
+	TP_ARGS(sc, dip))
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_header);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_mode);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_flags);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_size);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_extsize_hints);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_symlink);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_dir);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_fixed);
+
+DECLARE_EVENT_CLASS(xrep_inode_class,
+	TP_PROTO(struct xfs_scrub *sc),
+	TP_ARGS(sc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_rfsblock_t, nblocks)
+		__field(uint16_t, flags)
+		__field(uint64_t, flags2)
+		__field(uint32_t, nextents)
+		__field(uint8_t, format)
+		__field(uint32_t, anextents)
+		__field(uint8_t, aformat)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->sm->sm_ino;
+		__entry->size = sc->ip->i_disk_size;
+		__entry->nblocks = sc->ip->i_nblocks;
+		__entry->flags = sc->ip->i_diflags;
+		__entry->flags2 = sc->ip->i_diflags2;
+		__entry->nextents = sc->ip->i_df.if_nextents;
+		__entry->format = sc->ip->i_df.if_format;
+		__entry->anextents = sc->ip->i_af.if_nextents;
+		__entry->aformat = sc->ip->i_af.if_format;
+	),
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx nblocks 0x%llx flags 0x%x flags2 0x%llx nextents %u format %u anextents %u aformat %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->nblocks,
+		  __entry->flags,
+		  __entry->flags2,
+		  __entry->nextents,
+		  __entry->format,
+		  __entry->anextents,
+		  __entry->aformat)
+)
+
+#define DEFINE_REPAIR_INODE_EVENT(name) \
+DEFINE_EVENT(xrep_inode_class, name, \
+	TP_PROTO(struct xfs_scrub *sc), \
+	TP_ARGS(sc))
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_blockcounts);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_ids);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_flags);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_blockdir_size);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_sfdir_size);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_dir_size);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_fixed);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

