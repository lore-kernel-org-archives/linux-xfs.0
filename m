Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC930F819
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 05:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765346106; cv=none; b=DsumK1qV/oGk8eY2RRtVPtgFvU5EqrmTckA8aT51ANaJ3HADdlV4hzk5pu8q3KJZxM5q9tGlOk33UDdQg/7RsvOAlw/AnaJ7uofmmqV0OyRP1ZPBpa+408pPZ+3BwrieEs2V9bx/AFKJIvpM+vgZaBg7jcFfsiXW/N05Vup21hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765346106; c=relaxed/simple;
	bh=7XtW30negYf1H471CVufG1JxmaokuKjO0EGCadyLdw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9EKA70lhCPtFS0yv7svBlWrlOLX8fs9D4R7FzfN0Xbw3Grlms6hCO94ESc7Twoz8OV3jwLnyfdeyTizVEgZVEyPw2aZMXk92TWYbCr3rujRhfy3eyjgLT/MzB3MqgXZ6o5htKdVQ9bnjef4tkad9f6nmEmr/p1m6fi3VB03t2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jXv/UThg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jXv/UThg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5jUAz/2ktOfI0gjsNFe1xXt/Z1tDqKfPRifBbftvvEQ=; b=jXv/UThgg/dCkoys/PImkg+pz7
	b3ODjkmhJ98VapzxS8J35Qh1Q/wFkUHUHSHMXu0nk6zgU0BCRKXabP7yj2biI3PAFhDUNpP3m1bmS
	AESJQK2/Jq3D7fKFb7nmo9asXRj82PuyJk47BJGWMlZe45NuuORJSOk2sqpvLzmTsIPnXxru36BfM
	0YH3NKeH+BZYy3mhPGHQGEzy5Y07t404SwJQbTSTWaY529wxvwvx/Uon4oF6zz71D5m2jQPBzMaA1
	FuoLnmxsuA3lQk7z9C9ogw/O7CpV3NsiLUMe7GUup5yv8DN5wro/AH9uUaibQPBXN7yUOF0Elzbr7
	8lg2LpyQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTDAG-0000000F9Ol-0jwl;
	Wed, 10 Dec 2025 05:55:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Date: Wed, 10 Dec 2025 06:54:39 +0100
Message-ID: <20251210055455.3479288-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210055455.3479288-1-hch@lst.de>
References: <20251210055455.3479288-1-hch@lst.de>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c | 159 +++++++++++++++---------------------------------
 1 file changed, 50 insertions(+), 109 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index b824dfc0a59f..7f987c38d2e4 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -41,8 +41,29 @@ enum xr_ino_type {
 	XR_INO_PQUOTA,		/* project quota inode */
 	XR_INO_RTRMAP,		/* realtime rmap */
 	XR_INO_RTREFC,		/* realtime refcount */
+	XR_INO_MAX
 };
 
+static const char *xr_ino_type_name[] = {
+	[XR_INO_UNKNOWN]	= N_("unknown"),
+	[XR_INO_DIR]		= N_("directory"),
+	[XR_INO_RTDATA]		= N_("realtime file"),
+	[XR_INO_RTBITMAP]	= N_("realtime bitmap"),
+	[XR_INO_RTSUM]		= N_("realtime summary"),
+	[XR_INO_DATA]		= N_("regular file"),
+	[XR_INO_SYMLINK]	= N_("symlink"),
+	[XR_INO_CHRDEV]		= N_("character device"),
+	[XR_INO_BLKDEV]		= N_("block device"),
+	[XR_INO_SOCK]		= N_("socket"),
+	[XR_INO_FIFO]		= N_("fifo"),
+	[XR_INO_UQUOTA]		= N_("user quota"),
+	[XR_INO_GQUOTA]		= N_("group quota"),
+	[XR_INO_PQUOTA]		= N_("project quota"),
+	[XR_INO_RTRMAP]		= N_("realtime rmap"),
+	[XR_INO_RTREFC]		= N_("realtime refcount"),
+};
+static_assert(ARRAY_SIZE(xr_ino_type_name) == XR_INO_MAX);
+
 /*
  * gettext lookups for translations of strings use mutexes internally to
  * the library. Hence when we come through here doing parallel scans in
@@ -1946,106 +1967,6 @@ _("found illegal null character in symlink inode %" PRIu64 "\n"),
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
@@ -2261,16 +2182,20 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
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
+		 * pipes, devices, etc.) and thus must also have a zero size.
+		 */
+		if (dino->di_size != 0)  {
+			do_warn(
+_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
+				_(xr_ino_type_name[type]), lino,
+				(int64_t)be64_to_cpu(dino->di_size));
 			return 1;
+		}
 		break;
 
 	case XR_INO_RTDATA:
@@ -3704,10 +3629,26 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
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
+				_(xr_ino_type_name[type]), lino, totblocks);
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

