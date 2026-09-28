Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A1B42901C;
	Mon, 28 Sep 2026 06:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576182; cv=none; b=JDSNUq21tZzsaYW84D9r/RV280nr3nNdqlBr3XVOQ/VB4rsKL1T1Toyuvo+ucyqAVAFF4HP5Ky1GblJj7Nk5S0caXc3qV7uZg1MsfHItjuIxcChbVupnCajN/eelfbmqP7ttP2Ojur1jo9qG7mEs5F+JKKMrN0m2sztd1lrzfs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576182; c=relaxed/simple;
	bh=jl8vxmNh3cpt6dx2j0ZjP00o+2desTuJ1pfGqemcsCk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eU0YjegjbKpVP00yec3uJ64yVyBna531jlnE/2POqma92XEClhQDd81HBuZU6C/ryZkJm31n/ZNDjsNS6p0mbdu9KtYm+TJpm4d84cFjqnLQnZqgBpy1j7CRz8TvCGjfvtIFO03G8BsHQWab1MmxZ14hAlQfxyiLH4EFM7hIK+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kq9S9bHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kq9S9bHm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F39061F000FF;
	Mon, 28 Sep 2026 06:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576181;
	bh=fJTIUFeRmFrHx0NKIYtGC9QtsXbGCFeg1we6W4LG7vY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Kq9S9bHmCPGnFdfjstpezbukZGMLkw/5ntd/E1Sagh7w6Rto7gSy6duEq6zGQMKdi
	 X0IgmCXQiI1tBfxzMinKXf9Z9X9FkQBAXnOk1IlSNWfn88u+81gtSicS1lAT/3xZkJ
	 tXkJIo1cpFILKTvpLDHDdiJsGikvAU4/4sp3wkmv0z4a4yJPj26LKJMmJ51Ot5HIyg
	 3q4xQcZQ60qCGtfnvoT7qAGdUfoOVjMgXiZYBGnRtClrzoFA4KxXcB2osRdbS42aYY
	 TDsH+FyUZwPgbOBpea69NoaWBVBbvpo1UtH30FGbk0FX+xHy04NYNQCVYhR69S1aOv
	 EZpmhaz9kbfmw==
Date: Sun, 27 Sep 2026 23:16:20 -0700
Subject: [PATCH 02/12] xfs: improve dirent bounds checking in scrub and repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612639.479634.13348969749056583205.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/dir.c        |   56 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/dir_repair.c |   30 +++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index a63eebf39fd496..dd21570378b281 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -340,6 +340,7 @@ xchk_dir_rec(
 	xfs_dahash_t			hash;
 	struct xfs_dir3_icleaf_hdr	hdr;
 	unsigned int			tag;
+	bool				foundit = false;
 	int				error;
 
 	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
@@ -390,22 +391,60 @@ xchk_dir_rec(
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
-	for (;;) {
+	while (iter_off < end) {
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
+		unsigned int			advance;
 
-		if (iter_off >= end) {
+		/* must have freetag */
+		if (iter_off + offsetof(struct xfs_dir2_data_unused, length) >= end) {
 			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 			goto out_relse;
 		}
 
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			iter_off += be16_to_cpu(dup->length);
+			if (iter_off + sizeof(*dup) > end) {
+				xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK,
+						rec_bno);
+				goto out_relse;
+			}
+			advance = xfs_dir2_data_unusedsize(
+					be16_to_cpu(dup->length));
+			if (!advance) {
+				xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK,
+						rec_bno);
+				goto out_relse;
+			}
+
+			iter_off += advance;
 			continue;
 		}
-		if (dep == dent)
+
+		/* must have namelen */
+		if (iter_off + offsetof(struct xfs_dir2_data_entry, name) >= end) {
+			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+			goto out_relse;
+		}
+
+		advance = xfs_dir2_data_entsize(mp, dep->namelen);
+		if (!advance) {
+			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK,
+					rec_bno);
+			goto out_relse;
+		}
+
+		if (dep == dent) {
+			foundit = true;
 			break;
-		iter_off += xfs_dir2_data_entsize(mp, dep->namelen);
+		}
+
+		iter_off += advance;
+	}
+
+	/* Hash tree must point to the exact dirent */
+	if (!foundit) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
 	}
 
 	/* Retrieve the entry, sanity check it, and compare hashes. */
@@ -419,6 +458,13 @@ xchk_dir_rec(
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
index 0164335cb5c1be..b625cc71266b74 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -489,14 +489,27 @@ xrep_dir_recover_data(
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
+		/* must have freetag */
+		if (offset + offsetof(struct xfs_dir2_data_unused, length) >= end)
+			break;
+
 		/* Skip unused entries. */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			if (!dup->length)
+
+			if (offset + sizeof(*dup) > end)
 				break;
-			offset += be16_to_cpu(dup->length);
+			advance = xfs_dir2_data_unusedsize(
+					be16_to_cpu(dup->length));
+			if (!advance)
+				break;
+			offset += advance;
 			continue;
 		}
 
+		/* must have namelen */
+		if (offset + offsetof(struct xfs_dir2_data_entry, name) >= end)
+			break;
+
 		/* Don't walk off the end of the block. */
 		advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
 		if (!advance)
@@ -532,6 +545,19 @@ xrep_dir_recover_sf(
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
 

