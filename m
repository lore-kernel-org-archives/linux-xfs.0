Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEFA1FDE01
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 07:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765177906; cv=none; b=EE8Y9Yx5qxeya6Ii7/+jbPauPbyYG99CrxeZR6QHX/GzrRj9mg1USYiu7h7DiIYDdiDCVNGwH+i6IHEtXzFngWMh4LQCYr5qsbF3MSRUB0WGUjRtBL2mkI/3XwlHB/HzPfh9RGVGSrKU+tHX25g+M+ZfDAeFY6EckqD3dvXxhMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765177906; c=relaxed/simple;
	bh=ymH6Wh0yLHVBQAjx0jq8KyFGxw8Z2HgJFGPEy4ypK8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eY+FdzTQ4ec85ydp1eXj3kDN1CyOj0NF+Dp14zRujD+h5ysCk4FAcaM/E0MvlQUrdwFQtMPyg9JQKn/imUgn/ty1N+1WUfXUrqhFepmdMEaLfH+11xgzuyUUIrqglkp6P8HhBTER+wXLWC7a5QGeCcicaqaLf7ULx2Dv1A7+TEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O6jNSnmE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O6jNSnmE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rdWz6oreIYugLuOIGvsYUAZy1M4rVJdTBDbOARDJCYA=; b=O6jNSnmEaNotCJiPOcxf2kqqNZ
	dEShSM3dEj81Ox9untmiBQzlva3dj3qFDrDE1YmPx2QCpxa3RCmDPTxIfLBLiwW3OKQHI841r260R
	DpCJiH2AY6/G9sVO/WikXc+XR9obDo0i4hQhIL+WE95xZvNv61/AI3aO79mL7DUEpanh5mrfvKhZi
	+WBP6Oixk82KRxnT+iA4+OtZaCIucfPlZraisWmHA7cKyH7wdW+ETjqRqxZj6McMS7MmVhn3g6VWK
	B8jvXz5tbQqfSq9/RoWASXtvdkMrSW2j8R9R91pmxTz9c2TDf/RAWgIuc1KTWfQaEffNPvEuLW9GC
	f4vqIJHw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vSVPM-0000000CjWd-2NeZ;
	Mon, 08 Dec 2025 07:11:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] repair: enhance process_dinode_metafile
Date: Mon,  8 Dec 2025 08:11:07 +0100
Message-ID: <20251208071128.3137486-5-hch@lst.de>
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

Explicitly list the destiny of each metafile inode type, and warn about
unexpected types instead of just silently zapping them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 61ccbbc25ca9..af4233eb7c38 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2965,7 +2965,8 @@ process_dinode_metafile(
 	xfs_agnumber_t		agno,
 	xfs_agino_t		agino,
 	xfs_ino_t		lino,
-	enum xr_ino_type	type)
+	enum xr_ino_type	type,
+	bool			*zap_metadata)
 {
 	struct ino_tree_node	*irec = find_inode_rec(mp, agno, agino);
 	int			off = get_inode_offset(mp, lino, irec);
@@ -2973,16 +2974,6 @@ process_dinode_metafile(
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
@@ -2991,7 +2982,25 @@ process_dinode_metafile(
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
@@ -3612,8 +3621,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
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

