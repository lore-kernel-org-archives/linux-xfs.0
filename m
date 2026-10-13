Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2FE496D2D
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871797; cv=none; b=C5n5qmbDouOUfPO+jFhkOSt8aGfKy6WCgYnYr/A3jMz5QRD6sL+uokPCSQU4UNVbq1HkL30QxcR4Bc524Qqq62jyHgGuEV2+vDN8GDk17etPpvYAuHgT30+3QNU8Oxfrx6Te7X//Fpa1/rl4yDRgeoH5YuS47oixb2y43O+orb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871797; c=relaxed/simple;
	bh=+Vrf3aKMxpKrBvxoQu50xZiZ3HZz52m98wXszmfxSXw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brXBwGkkS3vjaOdTBLLOCh3hKI6idBad8yHHxVF52Ue1+8ghsZWw/UsKxAJ0jJFzz8ZSqzgfidOfIP/ibsIqWMzHkT218l3m3fAEGfddsQ1rwJrNBF71Vy1TL8ojSQtNIzuUVFNPDD/AlVLcWlP4tcJGps/XAclIXRHBiQOA6w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIPHKlNN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIPHKlNN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 794521F000FF;
	Tue, 13 Oct 2026 06:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871794;
	bh=7UezMTunf1/w2AMuIZzdLbFMgeH7tdIKrd03ompaAwg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kIPHKlNNH4mILSAHMm69l9KEXruqjyFll0SVc2pQcTJZtN4v6VivcEubdaAy5isZ4
	 F08LRTTOBivQR62YlY4DgWzThdYRLdrtPe5K4l7mU8HUW4KGRbX97s24NCu6LwAKWB
	 oJEvh4IZWd8JmI5dmoxwiineb4ysifuiU7F7BwOHCr5+uPXVamDO1+OEiLejbX1u3s
	 jEicXvThEXbOrwytVJ20n2LNuN1psJJLTK2i8gKno46s6pOw9uErf23CEoVvtkGOVH
	 7tPkJZixbHpquVbY0m13QYFq5ov15p1mewxrF97s2GO7vUU724wVRg5GEPmyGlP/Tu
	 JzdU52oe96z3w==
Date: Mon, 12 Oct 2026 23:09:54 -0700
Subject: [PATCH 06/12] xfs: refactor directory data block walking loops in
 scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179186107971.1898896.10119597165990670416.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist the inner loop code of the directory data block walking code in
the directory scrub and repair code to separate functions in preparation
for strengthening the validation in a subsequent patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir.c        |   56 ++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/dir_repair.c |   73 +++++++++++++++++++++++++++++++++------------
 2 files changed, 102 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index a63eebf39fd496..8de593c5382d11 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -315,6 +315,45 @@ xchk_dir_actor(
 	return error;
 }
 
+/*
+ * Deal with an unused directory entry.  Returns a positive number of bytes to
+ * advance in the directory block, zero to stop processing, or -1 if corruption
+ * was found.
+ */
+static int
+xchk_dir_check_unused(
+	struct xchk_da_btree		*ds,
+	struct xfs_buf			*bp,
+	unsigned int			iter_off,
+	unsigned int			end)
+{
+	struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
+
+	return be16_to_cpu(dup->length);
+}
+
+/*
+ * Check a directory entry.  Returns a positive number of bytes to advance
+ * in the directory block, zero to stop processing, or -1 if corruption was
+ * found.
+ */
+static int
+xchk_dir_check_entry(
+	struct xchk_da_btree		*ds,
+	struct xfs_buf			*bp,
+	unsigned int			iter_off,
+	unsigned int			end,
+	struct xfs_dir2_data_entry	*dent)
+{
+	struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
+	struct xfs_mount		*mp = ds->state->mp;
+
+	if (dep == dent)
+		return 0;
+
+	return xfs_dir2_data_entsize(mp, dep->namelen);
+}
+
 /* Scrub a directory btree record. */
 STATIC int
 xchk_dir_rec(
@@ -391,21 +430,24 @@ xchk_dir_rec(
 		goto out_relse;
 	}
 	for (;;) {
-		struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
+		int				advance;
 
 		if (iter_off >= end) {
 			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 			goto out_relse;
 		}
 
-		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			iter_off += be16_to_cpu(dup->length);
-			continue;
-		}
-		if (dep == dent)
+		if (dup->freetag == cpu_to_be16(XFS_DIR2_DATA_FREE_TAG))
+			advance = xchk_dir_check_unused(ds, bp, iter_off, end);
+		else
+			advance = xchk_dir_check_entry(ds, bp, iter_off, end,
+					dent);
+		if (advance < 0)
+			goto out_relse;
+		if (!advance)
 			break;
-		iter_off += xfs_dir2_data_entsize(mp, dep->namelen);
+		iter_off += advance;
 	}
 
 	/* Retrieve the entry, sanity check it, and compare hashes. */
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index bb3f2f462bde56..1169a2ad26876f 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -462,6 +462,52 @@ xrep_dir_salvage_data_entry(
 	return xrep_dir_salvage_entry(rd, dep->name, dep->namelen, ino);
 }
 
+/*
+ * Deal with an unused directory entry.  Returns a positive number of bytes to
+ * advance in the directory block, or zero to stop processing.
+ */
+static int
+xrep_dir_recover_unused(
+	struct xfs_buf			*bp,
+	unsigned int			offset,
+	unsigned int			end)
+{
+	struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+
+	return be16_to_cpu(dup->length);
+}
+
+/*
+ * Salvage a directory entry.  Returns a positive number of bytes to advance
+ * in the directory block, zero to stop processing, or a negative errno.
+ */
+static int
+xrep_dir_recover_entry(
+	struct xrep_dir			*rd,
+	struct xfs_buf			*bp,
+	unsigned int			offset,
+	unsigned int			end)
+{
+	struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+	unsigned int			advance;
+	int				error;
+
+	/* Don't walk off the end of the block. */
+	advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+	if (!advance)
+		return 0;
+	if (offset + advance > end)
+		return 0;
+
+	/* Ok, let's save this entry. */
+	error = xrep_dir_salvage_data_entry(rd, dep);
+	if (error < 0)
+		return error;
+
+	return advance;
+}
+
+
 /* Try to recover block/data format directory entries. */
 STATIC int
 xrep_dir_recover_data(
@@ -483,33 +529,20 @@ xrep_dir_recover_data(
 
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
-		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
-		unsigned int			advance;
+		int				advance;
 
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
-		/* Skip unused entries. */
-		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			if (!dup->length)
-				break;
-			offset += be16_to_cpu(dup->length);
-			continue;
-		}
-
-		/* Don't walk off the end of the block. */
-		advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (dup->freetag == cpu_to_be16(XFS_DIR2_DATA_FREE_TAG))
+			advance = xrep_dir_recover_unused(bp, offset, end);
+		else
+			advance = xrep_dir_recover_entry(rd, bp, offset, end);
+		if (advance < 0)
+			return advance;
 		if (!advance)
 			break;
 		offset += advance;
-		if (offset > end)
-			break;
-
-		/* Ok, let's save this entry. */
-		error = xrep_dir_salvage_data_entry(rd, dep);
-		if (error)
-			return error;
-
 	}
 
 	return 0;

