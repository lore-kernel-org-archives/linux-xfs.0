Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E9F24DCF6
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311858; cv=none; b=knOcSfSgRlJPQvb84WxiU64RjyI1NFQk4H0EaKTaOXxDS+sXgI+fo9FU2UpWH0TFNbtnaga+Gn1dHBvK+w2AzapodbzR2ShbUTJQEJHDfOpbQuOeGnRzBYWnTBntOMRhtRslDt/OcMdPHrAVadQwQu3oRxJ63pqIrgWz0q0GSPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311858; c=relaxed/simple;
	bh=kETWQCVO9YhZ84Rc3BVmSZ19ad89XCC5KoEEnn3e5ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCc5hkQghMLZpY7oR3XkD7u0XN1AvC5o4mG+3eeXNcSfKqkRuS1i6LDo6yF/m+t/N2o9ZSx10LMIDyY/tdkkZagnHa+row2Hex8pCMVdiSFSb3yNGIYu8amFLclb49rQoYwVBQuNHs0fXRzMWyPot/ba/wLAG+z3eFNliVVfkF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YKdkiYfu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YKdkiYfu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SS0FOn9HzmTkAjL/NXyMC6MR6YGjJ6U1VN5PbtP7g88=; b=YKdkiYfutY3vpoZimhaTUjT0Vz
	16BvKhbVZEdnhSteXgjNDvkvpfsloQI2FEcNQL5BGR8RrFLR/zYtSKjsxO4RIHpitDLIT1SwN+Nny
	2Hw11HA6XjDp2kxPLm++vHcvsInCoeH+oVal0niW/ojBdGnctQy9fwYtQzkn6fp8ElWJP9lfJ29Bt
	OZb2oXRmPp0aRqLF3K491kUtDeoTi4lusHcAkGUnC11wfLnUmvkilht/OCb1e8n2bv6DPsZVpJcvy
	p93z+KGZMbsoj9N6KjQJlnrB26jUEgVLEX8OwFuktYDYyrP4sJG+ZQ9NBmzmjH/0bQsyRhj6euU8b
	+alvI+ig==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs6q-000000003Ek-2jYM;
	Fri, 28 Nov 2025 06:37:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Date: Fri, 28 Nov 2025 07:37:00 +0100
Message-ID: <20251128063719.1495736-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063719.1495736-1-hch@lst.de>
References: <20251128063719.1495736-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add an array with the canonical name for each inode type so that code
doesn't have to implement switch statements for that, and remove the now
trivial process_misc_ino_types and process_misc_ino_types_blocks
functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c | 157 +++++++++++++++---------------------------------
 1 file changed, 48 insertions(+), 109 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index b824dfc0a59f..fd40fdcce665 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -43,6 +43,25 @@ enum xr_ino_type {
 	XR_INO_RTREFC,		/* realtime refcount */
 };
 
+static const char *xr_ino_type_name[] = {
+	[XR_INO_UNKNOWN]	= "unknown",
+	[XR_INO_DIR]		= "directory",
+	[XR_INO_RTDATA]		= "realtime file",
+	[XR_INO_RTBITMAP]	= "realtime bitmap",
+	[XR_INO_RTSUM]		= "realtime summary",
+	[XR_INO_DATA]		= "regular file",
+	[XR_INO_SYMLINK]	= "symlink",
+	[XR_INO_CHRDEV]		= "character device",
+	[XR_INO_BLKDEV]		= "block device",
+	[XR_INO_SOCK]		= "socket",
+	[XR_INO_FIFO]		= "fifo",
+	[XR_INO_UQUOTA]		= "user quota",
+	[XR_INO_GQUOTA]		= "group quota",
+	[XR_INO_PQUOTA]		= "project quota",
+	[XR_INO_RTRMAP]		= "realtime rmap",
+	[XR_INO_RTREFC]		= "realtime refcount",
+};
+
 /*
  * gettext lookups for translations of strings use mutexes internally to
  * the library. Hence when we come through here doing parallel scans in
@@ -1946,106 +1965,6 @@ _("found illegal null character in symlink inode %" PRIu64 "\n"),
 	return(0);
 }
 
-/*
- * called to process the set of misc inode special inode types
- * that have no associated data storage (fifos, pipes, devices, etc.).
- */
-static int
-process_misc_ino_types(
-	xfs_mount_t		*mp,
-	struct xfs_dinode	*dino,
-	xfs_ino_t		lino,
-	enum xr_ino_type	type)
-{
-	/*
-	 * must also have a zero size
-	 */
-	if (be64_to_cpu(dino->di_size) != 0)  {
-		switch (type)  {
-		case XR_INO_CHRDEV:
-			do_warn(
-_("size of character device inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(int64_t)be64_to_cpu(dino->di_size));
-			break;
-		case XR_INO_BLKDEV:
-			do_warn(
-_("size of block device inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(int64_t)be64_to_cpu(dino->di_size));
-			break;
-		case XR_INO_SOCK:
-			do_warn(
-_("size of socket inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(int64_t)be64_to_cpu(dino->di_size));
-			break;
-		case XR_INO_FIFO:
-			do_warn(
-_("size of fifo inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(int64_t)be64_to_cpu(dino->di_size));
-			break;
-		case XR_INO_UQUOTA:
-		case XR_INO_GQUOTA:
-		case XR_INO_PQUOTA:
-			do_warn(
-_("size of quota inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(int64_t)be64_to_cpu(dino->di_size));
-			break;
-		default:
-			do_warn(_("Internal error - process_misc_ino_types, "
-				  "illegal type %d\n"), type);
-			abort();
-		}
-
-		return(1);
-	}
-
-	return(0);
-}
-
-static int
-process_misc_ino_types_blocks(
-	xfs_rfsblock_t		totblocks,
-	xfs_ino_t		lino,
-	enum xr_ino_type	type)
-{
-	/*
-	 * you can not enforce all misc types have zero data fork blocks
-	 * by checking dino->di_nblocks because atotblocks (attribute
-	 * blocks) are part of nblocks. We must check this later when atotblocks
-	 * has been calculated or by doing a simple check that anExtents == 0.
-	 * We must also guarantee that totblocks is 0. Thus nblocks checking
-	 * will be done later in process_dinode_int for misc types.
-	 */
-
-	if (totblocks != 0)  {
-		switch (type)  {
-		case XR_INO_CHRDEV:
-			do_warn(
-_("size of character device inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
-				lino, totblocks);
-			break;
-		case XR_INO_BLKDEV:
-			do_warn(
-_("size of block device inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
-				lino, totblocks);
-			break;
-		case XR_INO_SOCK:
-			do_warn(
-_("size of socket inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
-				lino, totblocks);
-			break;
-		case XR_INO_FIFO:
-			do_warn(
-_("size of fifo inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
-				lino, totblocks);
-			break;
-		default:
-			return(0);
-		}
-		return(1);
-	}
-	return (0);
-}
-
 static inline int
 dinode_fmt(
 	struct xfs_dinode *dino)
@@ -2261,16 +2180,20 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
 	case XR_INO_BLKDEV:
 	case XR_INO_SOCK:
 	case XR_INO_FIFO:
-		if (process_misc_ino_types(mp, dino, lino, type))
-			return 1;
-		break;
-
 	case XR_INO_UQUOTA:
 	case XR_INO_GQUOTA:
 	case XR_INO_PQUOTA:
-		/* Quota inodes have same restrictions as above types */
-		if (process_misc_ino_types(mp, dino, lino, type))
+		/*
+		 * Misc inode types that have no associated data storage (fifos,
+		 * pipes, devices, etc.) mad thus must also have a zero size.
+		 */
+		if (dino->di_size != 0)  {
+			do_warn(
+_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
+				xr_ino_type_name[type], lino,
+				(int64_t)be64_to_cpu(dino->di_size));
 			return 1;
+		}
 		break;
 
 	case XR_INO_RTDATA:
@@ -3704,10 +3627,26 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	dino = *dinop;
 
 	/*
-	 * enforce totblocks is 0 for misc types
+	 * Enforce totblocks is 0 for misc types.
+	 *
+	 * Note that di_nblocks includes attribute fork blocks, so we can only
+	 * do this here instead of when reading the inode.
 	 */
-	if (process_misc_ino_types_blocks(totblocks, lino, type))
-		goto clear_bad_out;
+	switch (type)  {
+	case XR_INO_CHRDEV:
+	case XR_INO_BLKDEV:
+	case XR_INO_SOCK:
+	case XR_INO_FIFO:
+		if (totblocks != 0)  {
+			do_warn(
+_("size of %s inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
+				xr_ino_type_name[type], lino, totblocks);
+			goto clear_bad_out;
+		}
+		break;
+	default:
+		break;
+	}
 
 	/*
 	 * correct space counters if required
-- 
2.47.3

