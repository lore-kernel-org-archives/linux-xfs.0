Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5368B1FDE01
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 07:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765177903; cv=none; b=YKxuqLCa9vDq/Wq2H23A5Ah/XY+YQUvesRuLuvTBpfF5GsvmwX8dQmNruueWKqLo18g8zHB2PS+sm/Qdr8G3pQWXEwxo57jHW4CQCqhEit0e622TC2iVo3rkB3csU8ClJ633GtNZJzZI63KNyucWKE8/dvD00S5t89O/Dxei48Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765177903; c=relaxed/simple;
	bh=dCtmlcj7/l4ueAraSQWTdWiZLpClY3rumtS5hg1FQ/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sd54tXdVTRZaTI3TStmvg1CGm1I/YHifTaNhcWqKEW3M7xGjmtkHh3288ceov5clxqi0pMeETJuyIBnrv3aURhtfHP92TkRZtQntU0DEbv0XueE8KANOTKtev6Gx7PHem2NjI+ikUd2UKnEOJy4ijH0qcbyBS4kmcIbDuFjLJBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dF82sZVx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dF82sZVx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k/eKgSTvxp2ZG0J8A7YtWrcgjnNfBW7FB9zUUvmwZGQ=; b=dF82sZVxccq/Z75yiwO0o9zHIN
	cBkWf2w1iJI7WZqDG2RAa0THUCwIhvvHsF9mQbh56CalpHyWxArCz2e93VxM7IHYnvm2s/a3cDKV0
	Iju2Hh096QT0rl0vzzO5AxkQxGB0Nuc956cXqBCiqSlewsKLvhunw4s+D/XZefZ7aOq0xDQKb+Yxd
	pH7vUuo3wd8P+wnFMnVPmL+FOlAFgEbUpe2CxOpsTrvx+qCO2Uk/yByA2Ec+czOIQP5v1ivFl2yNj
	pEUciLV5lmj6uQweH3REogHlR8TLXxB84sWrulhUgUsvCAW9D8y6ZHk07+z6CPL/1QH0YLgrjhnoG
	4c+tBrGA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vSVPJ-0000000CjWU-2Hbg;
	Mon, 08 Dec 2025 07:11:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] repair: factor out a process_dinode_metafile helper
Date: Mon,  8 Dec 2025 08:11:06 +0100
Message-ID: <20251208071128.3137486-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208071128.3137486-1-hch@lst.de>
References: <20251208071128.3137486-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split the metafile logic from process_dinode_int into a separate
helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c | 87 ++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 40 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index bf2739a6eae5..61ccbbc25ca9 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2950,6 +2950,52 @@ _("Bad CoW extent size hint %u on inode %" PRIu64 ", "),
 	}
 }
 
+/*
+ * We always rebuild the metadata directory tree during phase 6, so we mark all
+ * directory blocks and other metadata files whose contents we don't want to
+ * save to be zapped.
+ *
+ * Currently, there are no metadata files that use xattrs, so we always drop the
+ * xattr blocks of metadata files.  Parent pointers will be rebuilt during
+ * phase 6.
+ */
+static bool
+process_dinode_metafile(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	xfs_ino_t		lino,
+	enum xr_ino_type	type)
+{
+	struct ino_tree_node	*irec = find_inode_rec(mp, agno, agino);
+	int			off = get_inode_offset(mp, lino, irec);
+
+	set_inode_is_meta(irec, off);
+
+	switch (type) {
+	case XR_INO_RTBITMAP:
+	case XR_INO_RTSUM:
+		/*
+		 * RT bitmap and summary files are always recreated when
+		 * rtgroups are enabled.  For older filesystems, they exist at
+		 * fixed locations and cannot be zapped.
+		 */
+		if (xfs_has_rtgroups(mp))
+			return true;
+		return false;
+	case XR_INO_UQUOTA:
+	case XR_INO_GQUOTA:
+	case XR_INO_PQUOTA:
+		/*
+		 * Quota checking and repair doesn't happen until phase7, so
+		 * preserve quota inodes and their contents for later.
+		 */
+		return false;
+	default:
+		return true;
+	}
+}
+
 /*
  * returns 0 if the inode is ok, 1 if the inode is corrupt
  * check_dups can be set to 1 *only* when called by the
@@ -3565,48 +3611,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	/* Does this inode think it was metadata? */
 	if (dino->di_version >= 3 &&
 	    (dino->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))) {
-		struct ino_tree_node	*irec;
-		int			off;
-
-		irec = find_inode_rec(mp, agno, ino);
-		off = get_inode_offset(mp, lino, irec);
-		set_inode_is_meta(irec, off);
 		is_meta = true;
-
-		/*
-		 * We always rebuild the metadata directory tree during phase
-		 * 6, so we use this flag to get all the directory blocks
-		 * marked as free, and any other metadata files whose contents
-		 * we don't want to save.
-		 *
-		 * Currently, there are no metadata files that use xattrs, so
-		 * we always drop the xattr blocks of metadata files.  Parent
-		 * pointers will be rebuilt during phase 6.
-		 */
-		switch (type) {
-		case XR_INO_RTBITMAP:
-		case XR_INO_RTSUM:
-			/*
-			 * rt bitmap and summary files are always recreated
-			 * when rtgroups are enabled.  For older filesystems,
-			 * they exist at fixed locations and cannot be zapped.
-			 */
-			if (xfs_has_rtgroups(mp))
-				zap_metadata = true;
-			break;
-		case XR_INO_UQUOTA:
-		case XR_INO_GQUOTA:
-		case XR_INO_PQUOTA:
-			/*
-			 * Quota checking and repair doesn't happen until
-			 * phase7, so preserve quota inodes and their contents
-			 * for later.
-			 */
-			break;
-		default:
+		if (process_dinode_metafile(mp, agno, ino, lino, type))
 			zap_metadata = true;
-			break;
-		}
 	}
 
 	/*
-- 
2.47.3

