Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B721A6816;
	Mon, 12 Oct 2026 06:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784843; cv=none; b=rbMWXdA6oWEIZzmghTi4nc5eS645jL9hXsZnVBLt6/BYS4noc9ThPX7iyqPeK8eq+7fPobUzEevvHQVxKS+fTzmDaU/zib2rVmIY6lbpvdS21d7vkqlCAT8tB7oakgEuQebIz3lWiwbZjPl3kfFz+o10PE+KSP0uTD5R9ZhSTm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784843; c=relaxed/simple;
	bh=zZCXLmxRA+nWJh6SknxcJQPqO7WEGLn2e49EoY0laRA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qkxwoFcSrIAfQDjcBOkJsVAd45M8WZxe5H/XOnTKW3vZ5glYQxclaejESaAxIvIGOLs0hy04WFHHtwCmmKyUIgjl1zVlOnVw9rdlHoT2JKQRDmRr9f+DW+FpwyQbtqEvOjWsk7XFRkiONqbqeDwIBizMcuu0dqOsu+uPm2zhJKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsKHJIMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsKHJIMb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 809351F0089B;
	Mon, 12 Oct 2026 06:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784841;
	bh=FjV42XVslAxUKBqxnr8m02U2zaSqvfUx9Z3kov60FtU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=AsKHJIMbAXFjgLn382OIZR6ojUYKA9scfVv+LhYHajY2k0jG/kh8jRakqylwiu1Mf
	 gHIEEEyG/3FNMzBSPSvf46Dk+pomOpKqx9eF/JWuGvYZA+3dfCDFDDC5q7Qyth8k3b
	 ic4ad4qnjsyRCNUWM8ASOBwGcvSm2+P1pGW/5cC8QAdX4zyP4VIViqamoBhens+AuM
	 p6CfsZgQoC+sd71FmVXcV0ewjE5eIi2oLANJL7FjVo+fwk2cPMAEvVi7lResszTksj
	 iNBRZ/ePgA8qhw4l0N9wJxKLtnv/mkj06mP+tiLUKxeASWCiWlOZlPyFkljwvycLid
	 WYzL8vssZ7lEA==
Date: Sun, 11 Oct 2026 23:00:41 -0700
Subject: [PATCH 07/12] xfs: improve dirent bounds checking in scrub and repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065946.1058822.5630800433093455691.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that we don't do enough bounds checking of the directory
entries in directory blocks when we're looking for errors or trying to
salvage entries.  Let's improve that with more detailed checks.

Cc: <stable@vger.kernel.org> # v4.16
Fixes: ce92d29ddf9908 ("xfs: directory scrubber must walk through data block to offset")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dir.c        |   67 ++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/scrub/dir_repair.c |   28 ++++++++++++++++++-
 2 files changed, 84 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 8de593c5382d11..5fb19e98fca4e5 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -325,11 +325,24 @@ xchk_dir_check_unused(
 	struct xchk_da_btree		*ds,
 	struct xfs_buf			*bp,
 	unsigned int			iter_off,
-	unsigned int			end)
+	unsigned int			end,
+	xfs_dablk_t			rec_bno)
 {
 	struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
+	int				advance;
 
-	return be16_to_cpu(dup->length);
+	if (iter_off + sizeof(*dup) > end) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		return -1;
+	}
+
+	advance = xfs_dir2_data_unusedsize(be16_to_cpu(dup->length));
+	if (!advance) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		return -1;
+	}
+
+	return advance;
 }
 
 /*
@@ -343,15 +356,30 @@ xchk_dir_check_entry(
 	struct xfs_buf			*bp,
 	unsigned int			iter_off,
 	unsigned int			end,
-	struct xfs_dir2_data_entry	*dent)
+	struct xfs_dir2_data_entry	*dent,
+	xfs_dablk_t			rec_bno)
 {
 	struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
 	struct xfs_mount		*mp = ds->state->mp;
+	int				advance;
+
+	/* must have namelen */
+	advance = offsetof(typeof(*dep), name);
+	if (iter_off + advance >= end) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		return -1;
+	}
+
+	advance = xfs_dir2_data_entsize(mp, dep->namelen);
+	if (!advance) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		return -1;
+	}
 
 	if (dep == dent)
 		return 0;
 
-	return xfs_dir2_data_entsize(mp, dep->namelen);
+	return advance;
 }
 
 /* Scrub a directory btree record. */
@@ -379,6 +407,7 @@ xchk_dir_rec(
 	xfs_dahash_t			hash;
 	struct xfs_dir3_icleaf_hdr	hdr;
 	unsigned int			tag;
+	bool				foundit = false;
 	int				error;
 
 	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
@@ -423,33 +452,44 @@ xchk_dir_rec(
 	dent = bp->b_addr + off;
 
 	/* Make sure we got a real directory entry. */
-	iter_off = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
 	if (!end) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
-	for (;;) {
+	iter_off = geo->data_entry_offset;
+	while (iter_off < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
 		int				advance;
 
-		if (iter_off >= end) {
+		/* must have freetag */
+		advance = offsetof(typeof(*dup), length);
+		if (iter_off + advance >= end) {
 			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 			goto out_relse;
 		}
 
 		if (dup->freetag == cpu_to_be16(XFS_DIR2_DATA_FREE_TAG))
-			advance = xchk_dir_check_unused(ds, bp, iter_off, end);
+			advance = xchk_dir_check_unused(ds, bp, iter_off, end,
+					rec_bno);
 		else
 			advance = xchk_dir_check_entry(ds, bp, iter_off, end,
-					dent);
+					dent, rec_bno);
 		if (advance < 0)
 			goto out_relse;
-		if (!advance)
+		if (!advance) {
+			foundit = true;
 			break;
+		}
 		iter_off += advance;
 	}
 
+	/* Hash tree must point to the exact dirent */
+	if (!foundit) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+
 	/* Retrieve the entry, sanity check it, and compare hashes. */
 	ino = be64_to_cpu(dent->inumber);
 	hash = be32_to_cpu(ent->hashval);
@@ -461,6 +501,13 @@ xchk_dir_rec(
 		goto out_relse;
 	}
 
+	/* Name must not overflow end of block */
+	if ((char *)dent->name + dent->namelen >
+	    (char *)bp->b_addr + BBTOB(bp->b_length)) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+
 	/* Does the directory hash match? */
 	dname.name = dent->name;
 	dname.len = dent->namelen;
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 1169a2ad26876f..9d853de63aea60 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -474,7 +474,10 @@ xrep_dir_recover_unused(
 {
 	struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 
-	return be16_to_cpu(dup->length);
+	if (offset + sizeof(*dup) > end)
+		return 0;
+
+	return xfs_dir2_data_unusedsize(be16_to_cpu(dup->length));
 }
 
 /*
@@ -492,6 +495,11 @@ xrep_dir_recover_entry(
 	unsigned int			advance;
 	int				error;
 
+	/* must have namelen */
+	advance = offsetof(typeof(*dep), name);
+	if (offset + advance >= end)
+		return 0;
+
 	/* Don't walk off the end of the block. */
 	advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
 	if (!advance)
@@ -534,6 +542,11 @@ xrep_dir_recover_data(
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
+		/* must have freetag */
+		advance = offsetof(typeof(*dup), length);
+		if (offset + advance >= end)
+			break;
+
 		if (dup->freetag == cpu_to_be16(XFS_DIR2_DATA_FREE_TAG))
 			advance = xrep_dir_recover_unused(bp, offset, end);
 		else
@@ -565,6 +578,19 @@ xrep_dir_recover_sf(
 	hdr = ifp->if_data;
 	end = (unsigned char *)ifp->if_data + ifp->if_bytes;
 
+	/* sf header must be big enough for count/i8count */
+	if (!hdr || ifp->if_bytes < 2)
+		return 0;
+
+	/* and large enough for the parent inumber */
+	if (hdr->i8count) {
+		if (ifp->if_bytes < offsetof(struct xfs_dir2_sf_hdr, parent[8]))
+			return 0;
+	} else {
+		if (ifp->if_bytes < offsetof(struct xfs_dir2_sf_hdr, parent[4]))
+			return 0;
+	}
+
 	ino = xfs_dir2_sf_get_parent_ino(hdr);
 	trace_xrep_dir_salvaged_parent(rd->sc->ip, ino);
 

