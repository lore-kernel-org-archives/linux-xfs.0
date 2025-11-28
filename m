Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D18424DCF6
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311874; cv=none; b=M6OJ5omQ6pqazcnQL4qXwb2RzNzYwiK5k0aCEt3ddOhOS3Sce8WBDFjZ6Vf3PfEos3/uKt+lmRjfZQyS/wWHx10sydczaRBlwqLEbbPcvkLS83IGaV+83weDZxY1Y/e7t/OyQkqfNUK8niymhROjhEfzpWoy8yp6zpEMaFPYjCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311874; c=relaxed/simple;
	bh=ksN0dOCLI2Oe5/jEBJEZqXS53jGN0ne/KdSJ4N5EITY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb3h3LsWw1Sf59LpMzOQd1zA3ukGJgUknLV8aN0E6OIYFf+L8meHgjKeDAy52xlITVzG5UmjXXsFj/1daSd6Ht3pGJbiqj5510zUqTnoD9ojAri5+XsCbS5EAd8ZRUZZQZeRGPdc7YlV8yH64KoCD2FlwB7Lwcgmr7S61/sYMlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E902fCIc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E902fCIc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YOVQTIlMsyrIVmCcuvPV4L68giTbhq9TSIrT1KTE1ns=; b=E902fCIc8dKYomz0w/Z547Cj3r
	JOz/OkuvLRFhdnWdSN6IL40Yf/OYFbBX9WwXPe3OKoPlVQOKep1WljeIjYSwMRHyBVY+BikU0qz+X
	4U8OUZqlZHQMtO0+cQW/+71QU6crGK+d2QjxfSZqy8ytASUfCa70ZbpJnlj0kfpUBQxqFoFP5c4S+
	PuYjSe1u0GDujDspAqPTIKxrQDHPs/V7BRaJw9SFDqR9U1c7dJtPEB2x8nOETgFO8C7wI+HKDCfCF
	EjZK8sxMbtAEfiZ9MxGoCay6rITXUG2Hq/oA/qXrpXxCSJxTgQ/EjLTzThmT1BDgTcVWRnbSAc7Ot
	tG5PdRBA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs76-000000003GA-2Awk;
	Fri, 28 Nov 2025 06:37:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] repair: enhance process_dinode_metafile
Date: Fri, 28 Nov 2025 07:37:02 +0100
Message-ID: <20251128063719.1495736-5-hch@lst.de>
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

Explicitly list the destiny of each metafile inode type, and warn about
unexpected types instead of just silently zapping them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index f77c8e86c6f1..695ce0410395 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2963,7 +2963,8 @@ process_dinode_metafile(
 	xfs_agnumber_t		agno,
 	xfs_agino_t		agino,
 	xfs_ino_t		lino,
-	enum xr_ino_type	type)
+	enum xr_ino_type	type,
+	bool			*zap_metadata)
 {
 	struct ino_tree_node	*irec = find_inode_rec(mp, agno, agino);
 	int			off = get_inode_offset(mp, lino, irec);
@@ -2971,16 +2972,6 @@ process_dinode_metafile(
 	set_inode_is_meta(irec, off);
 
 	switch (type) {
-	case XR_INO_RTBITMAP:
-	case XR_INO_RTSUM:
-		/*
-		 * RT bitmap and summary files are always recreated when
-		 * rtgroups are enabled.  For older filesystems, they exist at
-		 * fixed locations and cannot be zapped.
-		 */
-		if (xfs_has_rtgroups(mp))
-			return true;
-		return false;
 	case XR_INO_UQUOTA:
 	case XR_INO_GQUOTA:
 	case XR_INO_PQUOTA:
@@ -2989,7 +2980,25 @@ process_dinode_metafile(
 		 * preserve quota inodes and their contents for later.
 		 */
 		return false;
+	case XR_INO_DIR:
+	case XR_INO_RTBITMAP:
+	case XR_INO_RTSUM:
+	case XR_INO_RTRMAP:
+	case XR_INO_RTREFC:
+		/*
+		 * These are always recreated.  Note that for pre-metadir file
+		 * systems, the RT bitmap and summary inodes need to be
+		 * preserved, but we'll never end up here for them.
+		 */
+		*zap_metadata = true;
+		return false;
 	default:
+		do_warn(_("unexpected %s inode %" PRIu64 " with metadata flag"),
+				xr_ino_type_name[type], lino);
+		if (!no_modify)
+			do_warn(_(" will zap\n"));
+		else
+			do_warn(_(" would zap\n"));
 		return true;
 	}
 }
@@ -3610,8 +3619,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	if (dino->di_version >= 3 &&
 	    (dino->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))) {
 		is_meta = true;
-		if (process_dinode_metafile(mp, agno, ino, lino, type))
-			zap_metadata = true;
+		if (process_dinode_metafile(mp, agno, ino, lino, type,
+				&zap_metadata))
+			goto bad_out;
 	}
 
 	/*
-- 
2.47.3

