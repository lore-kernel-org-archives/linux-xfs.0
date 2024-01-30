Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD5633981
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591166; cv=none; b=htCSkXhU40rI9xEt4/l1Ug3X5EtoNd6AmuZ6Ef0oxA0eIPMJ8l1N24osCf75lhAusH54F8U2xw2IzVC+o5mqic7bL747m8Nrj4SEiD8cpH3JDAOOMxdqBJVXrgUPayPVOjC++PXIYdm1TWCkBMrQ7IebTsSLTD8LPEGSCZurJAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591166; c=relaxed/simple;
	bh=h/ryL/80tJODee9vJmzF3FuXRToznWR3sfMAYj1Km6c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MGwYv4FA8rTQ4GJLzpAmrrgfvafm6Nh7FLYy6z6na9pE2HLFJefv3v2r3BA3NF9JJtmAGOE7zkZ0AKqi2I0gZEKoqvott6aLbyyQesKYLcm/S5HPWmxk3cqzdLM7RrOQ5ZE8tXxmJsJoOEJc/WFmIztWwhbQNRIcnAJzlaF+PPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=er0xIEsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="er0xIEsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370C7C433C7;
	Tue, 30 Jan 2024 05:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591166;
	bh=h/ryL/80tJODee9vJmzF3FuXRToznWR3sfMAYj1Km6c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=er0xIEsEikeBDGVzYviyTZCQYkkq+intCeojJ3l1qWIcujC4iBLZ4ctgyh6kHbGbL
	 DZSkWc1w6Pj2+hdySb/Lh+iDFA8ucMkNGfcYMa6LsmWDQlWI2l1uvrlQyCoJx8L3BJ
	 JLZWOxG4qmX5coEwfiE2QBhFDLDH3JJNIf1xekuqanjc7wYzV5N0oLPIoHm8Q70VVB
	 kS6akq0LQ60M622FCxIBHm9xRw/mskTMTtNme52AOe7+TXXq/YfxMwsgaSicbSKjPI
	 oo7bzh9gw9txR+n2kvSApxnenZyrghuCQY9nBCOoXRRn0ssDFtMmg/JBuBTEexPdGz
	 Zr6RFS5NPuvWA==
Date: Mon, 29 Jan 2024 21:06:05 -0800
Subject: [PATCH 4/4] xfs: repair file modes by scanning for a dirent pointing
 to us
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062365.3353217.14491290266847299966.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
References: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
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

Repair might encounter an inode with a totally garbage i_mode.  To fix
this problem, we have to figure out if the file was a regular file, a
directory, or a special file.  One way to figure this out is to check if
there are any directories with entries pointing down to the busted file.

This patch recovers the file mode by scanning every directory entry on
the filesystem to see if there are any that point to the busted file.
If the ftype of all such dirents are consistent, the mode is recovered
from the ftype.  If no dirents are found, the file becomes a regular
file.  In all cases, ACLs are canceled and the file is made accessible
only by root.

A previous patch attempted to guess the mode by reading the beginning of
the file data.  This was rejected by Christoph on the grounds that we
cannot trust user-controlled data blocks.  Users do not have direct
control over the ondisk contents of directory entries, so this method
should be much safer.

If all the dirents have the same ftype, then we can translate that back
into an S_IFMT flag and fix the file.  If not, reset the mode to
S_IFREG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |  236 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/iscan.c        |   29 +++++
 fs/xfs/scrub/iscan.h        |    3 +
 fs/xfs/scrub/trace.c        |    1 
 fs/xfs/scrub/trace.h        |   49 +++++++++
 5 files changed, 312 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 0ca62d59f84ad..7e859c412a5b2 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -43,6 +43,8 @@
 #include "scrub/btree.h"
 #include "scrub/trace.h"
 #include "scrub/repair.h"
+#include "scrub/iscan.h"
+#include "scrub/readdir.h"
 
 /*
  * Inode Record Repair
@@ -126,6 +128,10 @@ struct xrep_inode {
 
 	/* Must we remove all access from this file? */
 	bool			zap_acls;
+
+	/* Inode scanner to see if we can find the ftype from dirents */
+	struct xchk_iscan	ftype_iscan;
+	uint8_t			alleged_ftype;
 };
 
 /*
@@ -227,26 +233,233 @@ xrep_dinode_header(
 	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
 }
 
-/* Turn di_mode into /something/ recognizable. */
-STATIC void
+/*
+ * If this directory entry points to the scrub target inode, then the directory
+ * we're scanning is the parent of the scrub target inode.
+ */
+STATIC int
+xrep_dinode_findmode_dirent(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*dp,
+	xfs_dir2_dataptr_t		dapos,
+	const struct xfs_name		*name,
+	xfs_ino_t			ino,
+	void				*priv)
+{
+	struct xrep_inode		*ri = priv;
+	int				error = 0;
+
+	if (xchk_should_terminate(ri->sc, &error))
+		return error;
+
+	if (ino != sc->sm->sm_ino)
+		return 0;
+
+	/* Ignore garbage directory entry names. */
+	if (name->len == 0 || !xfs_dir2_namecheck(name->name, name->len))
+		return -EFSCORRUPTED;
+
+	/* Don't pick up dot or dotdot entries; we only want child dirents. */
+	if (xfs_dir2_samename(name, &xfs_name_dotdot) ||
+	    xfs_dir2_samename(name, &xfs_name_dot))
+		return 0;
+
+	/*
+	 * Uhoh, more than one parent for this inode and they don't agree on
+	 * the file type?
+	 */
+	if (ri->alleged_ftype != XFS_DIR3_FT_UNKNOWN &&
+	    ri->alleged_ftype != name->type) {
+		trace_xrep_dinode_findmode_dirent_inval(ri->sc, dp, name->type,
+				ri->alleged_ftype);
+		return -EFSCORRUPTED;
+	}
+
+	/* We found a potential parent; remember the ftype. */
+	trace_xrep_dinode_findmode_dirent(ri->sc, dp, name->type);
+	ri->alleged_ftype = name->type;
+	return 0;
+}
+
+/*
+ * If this is a directory, walk the dirents looking for any that point to the
+ * scrub target inode.
+ */
+STATIC int
+xrep_dinode_findmode_walk_directory(
+	struct xrep_inode	*ri,
+	struct xfs_inode	*dp)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	/*
+	 * Scan the directory to see if there it contains an entry pointing to
+	 * the directory that we are repairing.
+	 */
+	lock_mode = xfs_ilock_data_map_shared(dp);
+
+	/*
+	 * If this directory is known to be sick, we cannot scan it reliably
+	 * and must abort.
+	 */
+	if (xfs_inode_has_sickness(dp, XFS_SICK_INO_CORE |
+				       XFS_SICK_INO_BMBTD |
+				       XFS_SICK_INO_DIR)) {
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
+
+	/*
+	 * We cannot complete our parent pointer scan if a directory looks as
+	 * though it has been zapped by the inode record repair code.
+	 */
+	if (xchk_dir_looks_zapped(dp)) {
+		error = -EBUSY;
+		goto out_unlock;
+	}
+
+	error = xchk_dir_walk(sc, dp, xrep_dinode_findmode_dirent, ri);
+	if (error)
+		goto out_unlock;
+
+out_unlock:
+	xfs_iunlock(dp, lock_mode);
+	return error;
+}
+
+/*
+ * Try to find the mode of the inode being repaired by looking for directories
+ * that point down to this file.
+ */
+STATIC int
+xrep_dinode_find_mode(
+	struct xrep_inode	*ri,
+	uint16_t		*mode)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_inode	*dp;
+	int			error;
+
+	/* No ftype means we have no other metadata to consult. */
+	if (!xfs_has_ftype(sc->mp)) {
+		*mode = S_IFREG;
+		return 0;
+	}
+
+	/*
+	 * Scan all directories for parents that might point down to this
+	 * inode.  Skip the inode being repaired during the scan since it
+	 * cannot be its own parent.  Note that we still hold the AGI locked
+	 * so there's a real possibility that _iscan_iter can return EBUSY.
+	 */
+	xchk_iscan_start(sc, 5000, 100, &ri->ftype_iscan);
+	ri->ftype_iscan.skip_ino = sc->sm->sm_ino;
+	ri->alleged_ftype = XFS_DIR3_FT_UNKNOWN;
+	while ((error = xchk_iscan_iter(&ri->ftype_iscan, &dp)) == 1) {
+		if (S_ISDIR(VFS_I(dp)->i_mode))
+			error = xrep_dinode_findmode_walk_directory(ri, dp);
+		xchk_iscan_mark_visited(&ri->ftype_iscan, dp);
+		xchk_irele(sc, dp);
+		if (error < 0)
+			break;
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	xchk_iscan_iter_finish(&ri->ftype_iscan);
+	xchk_iscan_teardown(&ri->ftype_iscan);
+
+	if (error == -EBUSY) {
+		if (ri->alleged_ftype != XFS_DIR3_FT_UNKNOWN) {
+			/*
+			 * If we got an EBUSY after finding at least one
+			 * dirent, that means the scan found an inode on the
+			 * inactivation list and could not open it.  Accept the
+			 * alleged ftype and install a new mode below.
+			 */
+			error = 0;
+		} else if (!(sc->flags & XCHK_TRY_HARDER)) {
+			/*
+			 * Otherwise, retry the operation one time to see if
+			 * the reason for the delay is an inode from the same
+			 * cluster buffer waiting on the inactivation list.
+			 */
+			error = -EDEADLOCK;
+		}
+	}
+	if (error)
+		return error;
+
+	/*
+	 * Convert the discovered ftype into the file mode.  If all else fails,
+	 * return S_IFREG.
+	 */
+	switch (ri->alleged_ftype) {
+	case XFS_DIR3_FT_DIR:
+		*mode = S_IFDIR;
+		break;
+	case XFS_DIR3_FT_WHT:
+	case XFS_DIR3_FT_CHRDEV:
+		*mode = S_IFCHR;
+		break;
+	case XFS_DIR3_FT_BLKDEV:
+		*mode = S_IFBLK;
+		break;
+	case XFS_DIR3_FT_FIFO:
+		*mode = S_IFIFO;
+		break;
+	case XFS_DIR3_FT_SOCK:
+		*mode = S_IFSOCK;
+		break;
+	case XFS_DIR3_FT_SYMLINK:
+		*mode = S_IFLNK;
+		break;
+	default:
+		*mode = S_IFREG;
+		break;
+	}
+	return 0;
+}
+
+/* Turn di_mode into /something/ recognizable.  Returns true if we succeed. */
+STATIC int
 xrep_dinode_mode(
 	struct xrep_inode	*ri,
 	struct xfs_dinode	*dip)
 {
 	struct xfs_scrub	*sc = ri->sc;
 	uint16_t		mode = be16_to_cpu(dip->di_mode);
+	int			error;
 
 	trace_xrep_dinode_mode(sc, dip);
 
 	if (mode == 0 || xfs_mode_to_ftype(mode) != XFS_DIR3_FT_UNKNOWN)
-		return;
+		return 0;
+
+	/* Try to fix the mode.  If we cannot, then leave everything alone. */
+	error = xrep_dinode_find_mode(ri, &mode);
+	switch (error) {
+	case -EINTR:
+	case -EBUSY:
+	case -EDEADLOCK:
+		/* temporary failure or fatal signal */
+		return error;
+	case 0:
+		/* found mode */
+		break;
+	default:
+		/* some other error, assume S_IFREG */
+		mode = S_IFREG;
+		break;
+	}
 
 	/* bad mode, so we set it to a file that only root can read */
-	mode = S_IFREG;
 	dip->di_mode = cpu_to_be16(mode);
 	dip->di_uid = 0;
 	dip->di_gid = 0;
 	ri->zap_acls = true;
+	return 0;
 }
 
 /* Fix any conflicting flags that the verifiers complain about. */
@@ -1107,12 +1320,15 @@ xrep_dinode_core(
 	/* Fix everything the verifier will complain about. */
 	dip = xfs_buf_offset(bp, ri->imap.im_boffset);
 	xrep_dinode_header(sc, dip);
-	xrep_dinode_mode(ri, dip);
+	iget_error = xrep_dinode_mode(ri, dip);
+	if (iget_error)
+		goto write;
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(ri, dip);
 	xrep_dinode_extsize_hints(sc, dip);
 	xrep_dinode_zap_forks(ri, dip);
 
+write:
 	/* Write out the inode. */
 	trace_xrep_dinode_fixed(sc, dip);
 	xfs_dinode_calc_crc(sc->mp, dip);
@@ -1128,7 +1344,8 @@ xrep_dinode_core(
 	 * accessing the inode.  If iget fails, we still need to commit the
 	 * changes.
 	 */
-	iget_error = xchk_iget(sc, ino, &sc->ip);
+	if (!iget_error)
+		iget_error = xchk_iget(sc, ino, &sc->ip);
 	if (!iget_error)
 		xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
@@ -1496,6 +1713,13 @@ xrep_inode(
 		ASSERT(ri != NULL);
 
 		error = xrep_dinode_problems(ri);
+		if (error == -EBUSY) {
+			/*
+			 * Directory scan to recover inode mode encountered a
+			 * busy inode, so we did not continue repairing things.
+			 */
+			return 0;
+		}
 		if (error)
 			return error;
 
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index 327f7fb83958a..17af89b519b3f 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -51,6 +51,32 @@
  * scanner's observations must be updated.
  */
 
+/*
+ * If the inobt record @rec covers @iscan->skip_ino, mark the inode free so
+ * that the scan ignores that inode.
+ */
+STATIC void
+xchk_iscan_mask_skipino(
+	struct xchk_iscan	*iscan,
+	struct xfs_perag	*pag,
+	struct xfs_inobt_rec_incore	*rec,
+	xfs_agino_t		lastrecino)
+{
+	struct xfs_scrub	*sc = iscan->sc;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_agnumber_t		skip_agno = XFS_INO_TO_AGNO(mp, iscan->skip_ino);
+	xfs_agnumber_t		skip_agino = XFS_INO_TO_AGINO(mp, iscan->skip_ino);
+
+	if (pag->pag_agno != skip_agno)
+		return;
+	if (skip_agino < rec->ir_startino)
+		return;
+	if (skip_agino > lastrecino)
+		return;
+
+	rec->ir_free |= xfs_inobt_maskn(skip_agino - rec->ir_startino, 1);
+}
+
 /*
  * Set *cursor to the next allocated inode after whatever it's set to now.
  * If there are no more inodes in this AG, cursor is set to NULLAGINO.
@@ -127,6 +153,9 @@ xchk_iscan_find_next(
 		if (rec.ir_startino + XFS_INODES_PER_CHUNK <= agino)
 			continue;
 
+		if (iscan->skip_ino)
+			xchk_iscan_mask_skipino(iscan, pag, &rec, lastino);
+
 		/*
 		 * If the incoming lookup put us in the middle of an inobt
 		 * record, mark it and the previous inodes "free" so that the
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
index 365d54e35cd94..71f657552dfac 100644
--- a/fs/xfs/scrub/iscan.h
+++ b/fs/xfs/scrub/iscan.h
@@ -22,6 +22,9 @@ struct xchk_iscan {
 	/* This is the inode that will be examined next. */
 	xfs_ino_t		cursor_ino;
 
+	/* If nonzero and non-NULL, skip this inode when scanning. */
+	xfs_ino_t		skip_ino;
+
 	/*
 	 * This is the last inode that we've successfully scanned, either
 	 * because the caller scanned it, or we moved the cursor past an empty
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 4542eeebab6f1..5ed75cc33b928 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -16,6 +16,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_quota.h"
 #include "xfs_quota_defs.h"
+#include "xfs_da_format.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 829c90da59c7c..9aba60c61880a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1817,6 +1817,55 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		  __entry->attr_extents)
 );
 
+TRACE_EVENT(xrep_dinode_findmode_dirent,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *dp,
+		 unsigned int ftype),
+	TP_ARGS(sc, dp, ftype),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, ftype)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->sm->sm_ino;
+		__entry->parent_ino = dp->i_ino;
+		__entry->ftype = ftype;
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx ftype '%s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parent_ino,
+		  __print_symbolic(__entry->ftype, XFS_DIR3_FTYPE_STR))
+);
+
+TRACE_EVENT(xrep_dinode_findmode_dirent_inval,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *dp,
+		 unsigned int ftype, unsigned int found_ftype),
+	TP_ARGS(sc, dp, ftype, found_ftype),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, ftype)
+		__field(unsigned int, found_ftype)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->sm->sm_ino;
+		__entry->parent_ino = dp->i_ino;
+		__entry->ftype = ftype;
+		__entry->found_ftype = found_ftype;
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx ftype '%s' found_ftype '%s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parent_ino,
+		  __print_symbolic(__entry->ftype, XFS_DIR3_FTYPE_STR),
+		  __print_symbolic(__entry->found_ftype, XFS_DIR3_FTYPE_STR))
+);
+
 TRACE_EVENT(xrep_cow_mark_file_range,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsblock_t startblock,
 		 xfs_fileoff_t startoff, xfs_filblks_t blockcount),

