Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EAA24DCF6
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311866; cv=none; b=c+F9ESrk5FXhgTnxsSSHvNPaeBYREnj7rX6uHXv4617gVkEVRhOJxo/HUlFqV5KD5kHRtgx7VF7X+FyPeQH8oMPESHBhPZaHrr6Cwd+II7iWyuHgv3ybbI5U+YrZYiCnMLyXQlRn6pCNlRTjwp6Hqo0p/e5KG5/sjVX+AosOXbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311866; c=relaxed/simple;
	bh=q9BRBSwkCCQX5xVlMAwTo0uMWfz1QJ/CFUUA+hzg80A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bdu5+numzBACaNDQPP/Vdei+jzWbgr5lgkqGLX2uUNd54dLdFN2YgbV6Zp3tMwY6p8M/aEPTpRangV94quNN85H47eOMpeib2lmXV0GYjN5HsVAFttuQzJ0nbb3GZsq9ctSGr66YHkZyVaoLLMmvKXh6hwUroKCtzHz5yWwC104=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yYpQnsxe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yYpQnsxe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xRvH7yJyZPOyKI2sFaVOJJljeFLDF6V1NPbkLtZ7gi0=; b=yYpQnsxeuBBIY8I8aqR9fvieWw
	6dDkgnOy/9Hbw0QHS+B2I6Qw7bYVFgVoo5OQs2nM8Tfs5c7B668g9CVRzGBaYLOqEBYRszmARnENZ
	wOYEYKTvts9wZuIgPKfb7NQbqAqtn3AYoHwWPgl45SzudPR7iUsJeDYvoBZ5zUPFfUK4O+6tOz6Ey
	hFCJNQ5Lz0si4UtX3w9T0PjLprfrrgYhUGPvz5iQvMPinUILaSqddaWCOA9holeWvrJQ1mgd73SyL
	Ly59hk2oLFSJdZlgp/CTCKn382oLncISOyYCJ8mTnscrKJXN6duudyrMzZ5UeCnEZP3vIfxKuzJ/t
	K0ItHKqg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs6y-000000003FF-3LKb;
	Fri, 28 Nov 2025 06:37:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] repair: factor out a process_dinode_metafile helper
Date: Fri, 28 Nov 2025 07:37:01 +0100
Message-ID: <20251128063719.1495736-4-hch@lst.de>
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

Split the metafile logic from process_dinode_int into a separate
helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c | 87 ++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 40 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index fd40fdcce665..f77c8e86c6f1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2948,6 +2948,52 @@ _("Bad CoW extent size hint %u on inode %" PRIu64 ", "),
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
@@ -3563,48 +3609,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
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

