Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE7830F819
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 05:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765346115; cv=none; b=ORMYsARzQOSg23sTkHGgwZ0YaUD2MH6JeTtyqP8NZnPvDVNqbkSgxB3TuaHCSggA10f6tHXmbtcg8SZWjpHo5JOUmiwJep4l1HhXwegxEg+FsUxcOURKl2e5WYI4ibqmW5xGlqkWMaxyX9ct+71gJWmuGhNstiI5lD1jdUI1iuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765346115; c=relaxed/simple;
	bh=8KOFsjjlnMI18GlOboM+7dPxBvcRizI74vh3Pm5lyCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVczGPpZ/ZSmzJU5sKpMxaUjCS+KN7XUtTCR8rJQLJur1d8rN8uJveoPoerWrxkjJ4l8sO81ZDATPet1wQP+hzoHsCSv+Ogs3MIisELPhMIe1GdsxVKclI5KUAaRtiOhOG/gAUBPRJf0RwJGZb5QQ9mrNbYm9c42Qm83QW+Cey4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uJzTHjZ+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uJzTHjZ+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O9BECtxoZ9V4vUD+c07yeSEryZbV+d/J2B0kqob+xjs=; b=uJzTHjZ+D00SE0JkkB+StUufHZ
	8y08JwtuzVfUOzSV2rdcTrY8vWTemMmw2nzNuTjOuLUC8P7WvZlrgJs4hghneL/R80d0dNDGq3Jpz
	2Ve+6DHThP3z21pL58jJOjGADhN97+ngjJm9Z7vjjFUDW/+5gXfPeF/D/NWyqQicGM9acU57doOMN
	3FmyY8Jsuh/gO1Tlwc1klY635napphahM/NoQ3lh99ZM5eWWvgcZ9j645+g/tgGfubUsdv57hW/Ys
	Q63GIP5GPKVgrDwkoZilIXw670/RCX8x8fyBqJWtYupeGEVrwO1h62JTY4KEtgBawbbmeycClTO9F
	t+QyND5Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTDAO-0000000F9PY-3GKp;
	Wed, 10 Dec 2025 05:55:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] repair: enhance process_dinode_metafile
Date: Wed, 10 Dec 2025 06:54:41 +0100
Message-ID: <20251210055455.3479288-5-hch@lst.de>
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

Explicitly list the destiny of each metafile inode type, and warn about
unexpected types instead of just silently zapping them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 2e8728594ead..48939f8bd159 100644
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

