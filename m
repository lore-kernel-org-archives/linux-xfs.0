Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E5D42AA5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481420; cv=none; b=ZberLzBgCKKcsDY9F75Vpf9Qnl+2PigHey5zuTBJ2dSesgtmDIaU7uaD9AxLDTah3r71Sx8e6Q5BDbjvWxsDduSwfJGw//xC6pxZPpFpIAN0ldswiq7H8iww6+2zvJXs/c0mOtkc6KQAFeDO6ts0gle6OlD13hfP0q1/4LaEdQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481420; c=relaxed/simple;
	bh=zfnKd/wIYI+TDuvG5INONhBPxdsN72cEzE6YcfivMrg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uOg9L0HZMrHtjScf307Zk+NidJ62oo4OffwdtG1Z9wiHXf1JG653wI29mKIab6fFo4caGeTLTUwsgfjrbFxXH3Sk1dMQejsLJaSBpgb/25NJ0ZO3JbGLGeXVi+BX9mR+ZXcknw+7AjjNI0/eUjlQNKvcn/YblS+lCYXeNuEr7gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A8S1fHau; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A8S1fHau"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UJJuEFFCz1rtkUn3hOHRKDOGptVCuwe26tDtiG6DPV8=; b=A8S1fHaur3HXA9gf/2AMUO1I/Y
	RiMjEfY/3VSgflC1z2vWH5L5AL7hGAzs80qFyG0xO4Gjt8HcOWGZjQIc0oyAv28LzLBWsI2I2YG3k
	aP7sEVR8s1BFGLxVFzf+R+zdfI4q+E8ogTlPN8Zla8pCtCF15gG4nrEPRHYyrbN6InfFNaFDnUGh4
	Qk2qFk0AqDJA3LkcmxxDWWQk/sLoaOvbd4NlWjmD34IUU0qIuRhr+MPl94gMDV/xz3lzmjdueonvl
	Xac0KSJUg3TRjjgtXkysWhGa5js2HafCoiXp5F3nZAU05zHarRyt5vB5mslaCiD9X1j7qjOdkrR3v
	/p/4VaYQ==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mw5-00000006Nqh-2NCv;
	Tue, 30 Apr 2024 12:50:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/16] xfs: make the hard case in xfs_dir2_sf_addname less hard
Date: Tue, 30 Apr 2024 14:49:26 +0200
Message-Id: <20240430124926.1775355-17-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430124926.1775355-1-hch@lst.de>
References: <20240430124926.1775355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_dir2_sf_addname tries and easy addition first where the new entry
is added to an end and a new higher offset is allocated to it.  If an
arbitrary limit on the offset is trigger it goes down the "hard" path
and instead looks for a hole in the offset space, which then also
implies inserting the new entry in the middle as the entries are sorted
by the d_offset offset.

The code to add an entry the hard way is way to complicated and
inefficient as it duplicates the linear search of the directory to
find the entry, full frees the old inode fork data and reallocates
it just to copy data into it from a temporary buffer.  Rewrite all
this to use the offset from the initial scan, do the usual idata
realloc and then just move the entries past the insertion point out
of the way in place using memmove.  This also happens to allow sharing
the code entirely with the easy case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 319 ++++++++++--------------------------
 1 file changed, 89 insertions(+), 230 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 0598465357cc3a..4ba93835dd847f 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -16,18 +16,6 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 
-/*
- * Prototypes for internal functions.
- */
-static void xfs_dir2_sf_addname_easy(xfs_da_args_t *args,
-				     xfs_dir2_sf_entry_t *sfep,
-				     xfs_dir2_data_aoff_t offset,
-				     int new_isize);
-static void xfs_dir2_sf_addname_hard(xfs_da_args_t *args, int objchange,
-				     int new_isize);
-static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
-				    xfs_dir2_sf_entry_t **sfepp,
-				    xfs_dir2_data_aoff_t *offsetp);
 #ifdef DEBUG
 static void xfs_dir2_sf_check(xfs_da_args_t *args);
 #else
@@ -361,6 +349,61 @@ xfs_dir2_try_block_to_sf(
 	return error;
 }
 
+static xfs_dir2_data_aoff_t
+xfs_dir2_sf_addname_pick_offset(
+	struct xfs_da_args	*args,
+	unsigned int		*byteoffp)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
+	xfs_dir2_data_aoff_t	offset = args->geo->data_first_offset;
+	struct xfs_dir2_sf_entry *sfep = xfs_dir2_sf_firstentry(sfp);
+	unsigned int		data_size =
+		xfs_dir2_data_entsize(mp, args->namelen);
+	unsigned int		data_overhead =
+		xfs_dir2_block_overhead(sfp->count + 1);
+	xfs_dir2_data_aoff_t	hole_offset = 0;
+	unsigned int		byteoff = 0;
+	unsigned int		i;
+
+	/*
+	 * Scan the directory to find the last offset and find a suitable
+	 * hole that we can use if needed.
+	 */
+	for (i = 0; i < sfp->count; i++) {
+		if (!hole_offset &&
+		    offset + data_size <= xfs_dir2_sf_get_offset(sfep)) {
+			hole_offset = offset;
+			byteoff = (void *)sfep - dp->i_df.if_data;
+		}
+		offset = xfs_dir2_sf_get_offset(sfep) +
+			xfs_dir2_data_entsize(mp, sfep->namelen);
+		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
+	}
+
+	/*
+	 * If just appending the entry would make the offset too large, use the
+	 * first hole that fits it if there is one or else give up and convert
+	 * to block format.
+	 *
+	 * Note that "too large" here is a completely arbitrary limit.  The
+	 * offset is logical concept not related to the physical byteoff and
+	 * there is no fundamental underlying limit to it.  But it has been
+	 * encoded in asserts and verifiers for a long time so we have to
+	 * respect it.
+	 */
+	if (offset + data_size + data_overhead > args->geo->blksize) {
+		if (!hole_offset)
+			return 0;
+		*byteoffp = byteoff;
+		return hole_offset;
+	}
+
+	*byteoffp = dp->i_disk_size;
+	return offset;
+}
+
 static void
 xfs_dir2_sf_addname_common(
 	struct xfs_da_args	*args,
@@ -384,23 +427,29 @@ xfs_dir2_sf_addname_common(
 
 /*
  * Add a name to a shortform directory.
- * There are two algorithms, "easy" and "hard" which we decide on
- * before changing anything.
- * Convert to block form if necessary, if the new entry won't fit.
+ *
+ * Shortform directories are always tighty packed, and we simply allocate
+ * a new higher offset and add the entry at the end.
+ *
+ * While we could search for a hole in the offset space there really isn't
+ * much of a a point in doing so and complicating the algorithm.
+ *
+ * Convert to block form if the new entry won't fit.
  */
-int						/* error */
+int
 xfs_dir2_sf_addname(
-	xfs_da_args_t		*args)		/* operation arguments */
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
-	int			error;		/* error return value */
-	int			incr_isize;	/* total change in size */
-	int			new_isize;	/* size after adding name */
-	int			objchange;	/* changing to 8-byte inodes */
-	xfs_dir2_data_aoff_t	offset = 0;	/* offset for new entry */
-	int			pick;		/* which algorithm to use */
-	xfs_dir2_sf_entry_t	*sfep = NULL;	/* shortform entry */
+	struct xfs_dir2_sf_entry *sfep;
+	xfs_dir2_data_aoff_t	offset;
+	unsigned int		entsize;
+	unsigned int		new_isize;
+	unsigned int		byteoff;
+	bool			objchange = false;
+	int			error;
 
 	trace_xfs_dir2_sf_addname(args);
 
@@ -408,11 +457,12 @@ xfs_dir2_sf_addname(
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
+
 	/*
-	 * Compute entry (and change in) size.
+	 * Compute entry size and new inode size.
 	 */
-	incr_isize = xfs_dir2_sf_entsize(dp->i_mount, sfp, args->namelen);
-	objchange = 0;
+	entsize = xfs_dir2_sf_entsize(mp, sfp, args->namelen);
+	new_isize = dp->i_disk_size + entsize;
 
 	/*
 	 * Do we have to change to 8 byte inodes?
@@ -421,19 +471,17 @@ xfs_dir2_sf_addname(
 		/*
 		 * Yes, adjust the inode size.  old count + (parent + new)
 		 */
-		incr_isize += (sfp->count + 2) * XFS_INO64_DIFF;
-		objchange = 1;
+		new_isize += (sfp->count + 2) * XFS_INO64_DIFF;
+		objchange = true;
 	}
 
-	new_isize = (int)dp->i_disk_size + incr_isize;
-
 	/*
 	 * Too large to fit into the inode fork or too large offset?
 	 */
 	if (new_isize > xfs_inode_data_fork_size(dp))
 		goto convert;
-	pick = xfs_dir2_sf_addname_pick(args, objchange, &sfep, &offset);
-	if (pick == 0)
+	offset = xfs_dir2_sf_addname_pick_offset(args, &byteoff);
+	if (!offset)
 		goto convert;
 
 	/*
@@ -451,20 +499,17 @@ xfs_dir2_sf_addname(
 		return 0;
 	}
 
+	sfp = xfs_idata_realloc(dp, entsize, XFS_DATA_FORK);
+	sfep = dp->i_df.if_data + byteoff;
+
 	/*
-	 * Do it the easy way - just add it at the end.
-	 */
-	if (pick == 1)
-		xfs_dir2_sf_addname_easy(args, sfep, offset, new_isize);
-	/*
-	 * Do it the hard way - look for a place to insert the new entry.
-	 * Convert to 8 byte inode numbers first if necessary.
+	 * If we're inserting in the middle, move the tail out of the way first.
 	 */
-	else {
-		ASSERT(pick == 2);
-		xfs_dir2_sf_addname_hard(args, objchange, new_isize);
+	if (byteoff < dp->i_disk_size) {
+		memmove(sfep, (void *)sfep + entsize,
+			dp->i_disk_size - byteoff);
 	}
-
+	xfs_dir2_sf_addname_common(args, sfep, offset, objchange);
 	dp->i_disk_size = new_isize;
 	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
@@ -482,192 +527,6 @@ xfs_dir2_sf_addname(
 	return xfs_dir2_block_addname(args);
 }
 
-/*
- * Add the new entry the "easy" way.
- * This is copying the old directory and adding the new entry at the end.
- * Since it's sorted by "offset" we need room after the last offset
- * that's already there, and then room to convert to a block directory.
- * This is already checked by the pick routine.
- */
-static void
-xfs_dir2_sf_addname_easy(
-	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dir2_sf_entry_t	*sfep,		/* pointer to new entry */
-	xfs_dir2_data_aoff_t	offset,		/* offset to use for new ent */
-	int			new_isize)	/* new directory size */
-{
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
-	int			byteoff = (int)((char *)sfep - (char *)sfp);
-
-	/*
-	 * Grow the in-inode space.
-	 */
-	sfp = xfs_idata_realloc(dp, xfs_dir2_sf_entsize(mp, sfp, args->namelen),
-			  XFS_DATA_FORK);
-	/*
-	 * Need to set up again due to realloc of the inode data.
-	 */
-	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
-	xfs_dir2_sf_addname_common(args, sfep, offset, false);
-}
-
-/*
- * Add the new entry the "hard" way.
- * The caller has already converted to 8 byte inode numbers if necessary,
- * in which case we need to leave the i8count at 1.
- * Find a hole that the new entry will fit into, and copy
- * the first part of the entries, the new entry, and the last part of
- * the entries.
- */
-/* ARGSUSED */
-static void
-xfs_dir2_sf_addname_hard(
-	xfs_da_args_t		*args,		/* operation arguments */
-	int			objchange,	/* changing inode number size */
-	int			new_isize)	/* new directory size */
-{
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_mount	*mp = dp->i_mount;
-	int			add_datasize;	/* data size need for new ent */
-	char			*buf;		/* buffer for old */
-	int			eof;		/* reached end of old dir */
-	int			nbytes;		/* temp for byte copies */
-	xfs_dir2_data_aoff_t	new_offset;	/* next offset value */
-	xfs_dir2_data_aoff_t	offset;		/* current offset value */
-	int			old_isize;	/* previous size */
-	xfs_dir2_sf_entry_t	*oldsfep;	/* entry in original dir */
-	xfs_dir2_sf_hdr_t	*oldsfp;	/* original shortform dir */
-	xfs_dir2_sf_entry_t	*sfep;		/* entry in new dir */
-	xfs_dir2_sf_hdr_t	*sfp;		/* new shortform dir */
-
-	/*
-	 * Copy the old directory to the stack buffer.
-	 */
-	old_isize = (int)dp->i_disk_size;
-	buf = kmalloc(old_isize, GFP_KERNEL | __GFP_NOFAIL);
-	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
-	memcpy(oldsfp, dp->i_df.if_data, old_isize);
-	/*
-	 * Loop over the old directory finding the place we're going
-	 * to insert the new entry.
-	 * If it's going to end up at the end then oldsfep will point there.
-	 */
-	for (offset = args->geo->data_first_offset,
-	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
-	      add_datasize = xfs_dir2_data_entsize(mp, args->namelen),
-	      eof = (char *)oldsfep == &buf[old_isize];
-	     !eof;
-	     offset = new_offset + xfs_dir2_data_entsize(mp, oldsfep->namelen),
-	      oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep),
-	      eof = (char *)oldsfep == &buf[old_isize]) {
-		new_offset = xfs_dir2_sf_get_offset(oldsfep);
-		if (offset + add_datasize <= new_offset)
-			break;
-	}
-	/*
-	 * Get rid of the old directory, then allocate space for
-	 * the new one.  We do this so xfs_idata_realloc won't copy
-	 * the data.
-	 */
-	xfs_idata_realloc(dp, -old_isize, XFS_DATA_FORK);
-	sfp = xfs_idata_realloc(dp, new_isize, XFS_DATA_FORK);
-
-	/*
-	 * Copy the first part of the directory, including the header.
-	 */
-	nbytes = (int)((char *)oldsfep - (char *)oldsfp);
-	memcpy(sfp, oldsfp, nbytes);
-	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + nbytes);
-
-	/*
-	 * Fill in the new entry, and update the header counts.
-	 */
-	xfs_dir2_sf_addname_common(args, sfep, offset, objchange);
-
-	/*
-	 * If there's more left to copy, do that.
-	 */
-	if (!eof) {
-		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
-		memcpy(sfep, oldsfep, old_isize - nbytes);
-	}
-	kfree(buf);
-}
-
-/*
- * Decide if the new entry will fit at all.
- * If it will fit, pick between adding the new entry to the end (easy)
- * or somewhere else (hard).
- * Return 0 (won't fit), 1 (easy), 2 (hard).
- */
-/*ARGSUSED*/
-static int					/* pick result */
-xfs_dir2_sf_addname_pick(
-	xfs_da_args_t		*args,		/* operation arguments */
-	int			objchange,	/* inode # size changes */
-	xfs_dir2_sf_entry_t	**sfepp,	/* out(1): new entry ptr */
-	xfs_dir2_data_aoff_t	*offsetp)	/* out(1): new offset */
-{
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_mount	*mp = dp->i_mount;
-	int			holefit;	/* found hole it will fit in */
-	int			i;		/* entry number */
-	xfs_dir2_data_aoff_t	offset;		/* data block offset */
-	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
-	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
-	int			size;		/* entry's data size */
-	int			used;		/* data bytes used */
-
-	size = xfs_dir2_data_entsize(mp, args->namelen);
-	offset = args->geo->data_first_offset;
-	sfep = xfs_dir2_sf_firstentry(sfp);
-	holefit = 0;
-	/*
-	 * Loop over sf entries.
-	 * Keep track of data offset and whether we've seen a place
-	 * to insert the new entry.
-	 */
-	for (i = 0; i < sfp->count; i++) {
-		if (!holefit)
-			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
-		if (holefit)
-			*offsetp = offset;
-		offset = xfs_dir2_sf_get_offset(sfep) +
-			 xfs_dir2_data_entsize(mp, sfep->namelen);
-		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
-	}
-	/*
-	 * Calculate data bytes used excluding the new entry, if this
-	 * was a data block (block form directory).
-	 */
-	used = offset + xfs_dir2_block_overhead(sfp->count + 1);
-	/*
-	 * If it won't fit in a block form then we can't insert it,
-	 * we'll go back, convert to block, then try the insert and convert
-	 * to leaf.
-	 */
-	if (used + (holefit ? 0 : size) > args->geo->blksize)
-		return 0;
-	/*
-	 * If changing the inode number size, do it the hard way.
-	 */
-	if (objchange)
-		return 2;
-	/*
-	 * If it won't fit at the end then do it the hard way (use the hole).
-	 */
-	if (used + size > args->geo->blksize)
-		return 2;
-	/*
-	 * Do it the easy way.
-	 */
-	*sfepp = sfep;
-	*offsetp = offset;
-	return 1;
-}
-
 #ifdef DEBUG
 /*
  * Check consistency of shortform directory, assert if bad.
-- 
2.39.2

