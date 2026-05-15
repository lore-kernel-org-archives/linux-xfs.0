Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F0D481224
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853082; cv=none; b=UJxMHUeawzj6302F6+ixnw/gi0K70FhF4waMrsFe9E9ic08o3kM1cGUYJ6PgQhNNe8X4v057OgnKiOIbAGA+lPLT0cjNjmgemlG4HWs3AJ8iVX2zhsooLwkCp3fAXZqTQgDUfEbwuLAyYSj676jPJRW1qTwID2734yJYV/dVQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853082; c=relaxed/simple;
	bh=vf1743kEWU2MeFfGqKINmNGNTzbF0u0gJqUuWUmdvqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2x/XiG2FyD+1m631q+KaZOwgc4PThwEuMJ/8HhTiCd3LA+98iJsAKQ3NPEm0GEXWb35RRivPs0JwTArsBDNo9ZZuvFRtKrUCStdEzqZpmxacqrPKEB8k4J4zv2BiXUce3bFhfqpWcSq6ZkVc+fFNdB+8UT1wMqKux8vDEIJ+M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=11jCO8Z3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="11jCO8Z3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ek5dWcHtc+vcq/SLymz1uca6dvLukNC6JZC5QlJAlIo=; b=11jCO8Z32bIY3RfHBXqcTbp4ck
	DMi64KnRhbmi7P/D3ug0PBwYxqUDxJxlTnIQEZB2XKeRwTAPrg/Nvtq8VCrAC5JXX6Pts7i1MS0XB
	namWebUlwKbwKjTnUp/z9fen0VPM64EyffI/ed9vY22l2NriXJ6XXUXb3syEOTK7lZnARtUjcLLSy
	Zo56ymUAn0fLX3MQ7Cg1Nf1yhtTd6E5yl3wNl87sM54oy0NDXQAvUdPqh5jZOVz3QtVWcedED0EGf
	SWs8JrLgC4aoX35hqo3S3MiDC/6eh2KMahqy6nGAkWHiTNxyaN5n6ivmKGD6O/ktbtgIsclVMPq0E
	3tHI8NCQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNswY-00000008UVq-2iWj;
	Fri, 15 May 2026 13:51:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: add a XFS_INODE_TO_AGNO helper
Date: Fri, 15 May 2026 15:50:22 +0200
Message-ID: <20260515135103.4042407-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515135103.4042407-1-hch@lst.de>
References: <20260515135103.4042407-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a shortcut for the common XFS_INO_TO_AGNO(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.c       |  4 ++--
 fs/xfs/libxfs/xfs_format.h     |  2 ++
 fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
 fs/xfs/libxfs/xfs_inode_util.c |  2 +-
 fs/xfs/scrub/agheader_repair.c |  8 +++-----
 fs/xfs/scrub/dir_repair.c      |  2 +-
 fs/xfs/scrub/inode_repair.c    |  3 +--
 fs/xfs/scrub/nlinks_repair.c   |  2 +-
 fs/xfs/scrub/parent_repair.c   |  2 +-
 fs/xfs/scrub/trace.h           |  8 ++++----
 fs/xfs/xfs_icache.c            | 14 ++++++--------
 fs/xfs/xfs_inode.c             |  9 ++++-----
 fs/xfs/xfs_trace.h             |  9 ++++-----
 13 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 495620cc001f..9f96528ea407 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -919,7 +919,7 @@ xfs_dir_add_child(
 	if (VFS_I(ip)->i_nlink == 0) {
 		struct xfs_perag	*pag;
 
-		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 		error = xfs_iunlink_remove(tp, pag, ip);
 		xfs_perag_put(pag);
 		if (error)
@@ -1246,7 +1246,7 @@ xfs_dir_rename_children(
 
 		ASSERT(VFS_I(du_wip->ip)->i_nlink == 0);
 
-		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, du_wip->ip->i_ino));
+		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(du_wip->ip));
 		error = xfs_iunlink_remove(tp, pag, du_wip->ip);
 		xfs_perag_put(pag);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 779dac59b1f3..36a00c174f1e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1276,6 +1276,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 	XFS_INO_AGNO_BITS(mp) + XFS_INO_AGINO_BITS(mp)
 #define	XFS_INO_TO_AGNO(mp,i)		\
 	((xfs_agnumber_t)((i) >> XFS_INO_AGINO_BITS(mp)))
+#define	XFS_INODE_TO_AGNO(ip)		\
+	XFS_INO_TO_AGNO((ip)->i_mount, (ip)->i_ino)
 #define	XFS_INO_TO_AGINO(mp,i)		\
 	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
 #define	XFS_INO_TO_AGBNO(mp,i)		\
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index dcef06ec0a02..77201a1eb3c4 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1870,7 +1870,7 @@ xfs_dialloc_pick_ag(
 	if (S_ISDIR(mode))
 		return (atomic_inc_return(&mp->m_agirotor) - 1) % mp->m_maxagi;
 
-	start_agno = XFS_INO_TO_AGNO(mp, dp->i_ino);
+	start_agno = XFS_INODE_TO_AGNO(dp);
 	if (start_agno >= mp->m_maxagi)
 		start_agno = 0;
 
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 551fa51befb6..b478d16c0e20 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -529,7 +529,7 @@ xfs_iunlink(
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	trace_xfs_iunlink(ip);
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
 	error = xfs_read_agi(pag, tp, 0, &agibp);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index ae9ed5f280d0..c8d54ce6e363 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1116,9 +1116,7 @@ xrep_iunlink_igrab(
 	struct xfs_perag	*pag,
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = pag_mount(pag);
-
-	if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
+	if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
 		return false;
 
 	if (!xfs_inode_on_unlinked_list(ip))
@@ -1142,7 +1140,7 @@ xrep_iunlink_visit(
 	unsigned int		bucket;
 	int			error;
 
-	ASSERT(XFS_INO_TO_AGNO(mp, ip->i_ino) == pag_agno(ragi->sc->sa.pag));
+	ASSERT(XFS_INODE_TO_AGNO(ip) == pag_agno(ragi->sc->sa.pag));
 	ASSERT(xfs_inode_on_unlinked_list(ip));
 
 	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
@@ -1213,7 +1211,7 @@ xrep_iunlink_mark_incore(
 			 * us to see this inode, so another lookup from the
 			 * same index will not find it again.
 			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
+			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
 				continue;
 			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 23b80c54aa60..373172e52287 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1576,7 +1576,7 @@ xrep_dir_set_nlink(
 	 * count.  If the directory has no parent, it will be moved to the
 	 * orphanage.
 	 */
-	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, dp->i_ino));
+	pag = xfs_perag_get(sc->mp, XFS_INODE_TO_AGNO(dp));
 	if (!pag) {
 		ASSERT(0);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 9738b9ce3f2d..8a2bf263ca3b 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -2011,8 +2011,7 @@ xrep_inode_unlinked(
 		struct xfs_perag	*pag;
 		int			error;
 
-		pag = xfs_perag_get(sc->mp,
-				XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
+		pag = xfs_perag_get(sc->mp, XFS_INODE_TO_AGNO(sc->ip));
 		error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
 		xfs_perag_put(pag);
 		if (error)
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 9049215c6eae..3767dba9f515 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -75,7 +75,7 @@ xrep_nlinks_iunlink_remove(
 	struct xfs_perag	*pag;
 	int			error;
 
-	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
+	pag = xfs_perag_get(sc->mp, XFS_INODE_TO_AGNO(sc->ip));
 	error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
 	xfs_perag_put(pag);
 	return error;
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 2ce0cefad362..a5dc7dc65f98 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1451,7 +1451,7 @@ xrep_parent_set_nondir_nlink(
 		 * The file is on the unlinked list but we found parents.
 		 * Remove the file from the unlinked list.
 		 */
-		pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, ip->i_ino));
+		pag = xfs_perag_get(sc->mp, XFS_INODE_TO_AGNO(ip));
 		if (!pag) {
 			ASSERT(0);
 			return -EFSCORRUPTED;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 286c5f5e0544..6c684e9433db 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3473,7 +3473,7 @@ TRACE_EVENT(xrep_iunlink_reload_next,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agno = XFS_INODE_TO_AGNO(ip);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 		__entry->old_prev_agino = ip->i_prev_unlinked;
 		__entry->prev_agino = prev_agino;
@@ -3503,7 +3503,7 @@ TRACE_EVENT(xrep_iunlink_reload_ondisk,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agno = XFS_INODE_TO_AGNO(ip);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 		__entry->nlink = VFS_I(ip)->i_nlink;
 		__entry->next_agino = ip->i_next_unlinked;
@@ -3590,7 +3590,7 @@ TRACE_EVENT(xrep_iunlink_relink_next,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agno = XFS_INODE_TO_AGNO(ip);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 		__entry->next_agino = ip->i_next_unlinked;
 		__entry->new_next_agino = next_agino;
@@ -3616,7 +3616,7 @@ TRACE_EVENT(xrep_iunlink_relink_prev,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agno = XFS_INODE_TO_AGNO(ip);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 		__entry->prev_agino = ip->i_prev_unlinked;
 		__entry->new_prev_agino = prev_agino;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2040a9292ee6..73f06bb13075 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -427,8 +427,7 @@ xfs_iget_check_free_state(
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
 				ip->i_ino, VFS_I(ip)->i_mode);
-			xfs_agno_mark_sick(ip->i_mount,
-					XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+			xfs_agno_mark_sick(ip->i_mount, XFS_INODE_TO_AGNO(ip),
 					XFS_SICK_AG_INOBT);
 			return -EFSCORRUPTED;
 		}
@@ -437,8 +436,7 @@ xfs_iget_check_free_state(
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx has blocks allocated!",
 				ip->i_ino);
-			xfs_agno_mark_sick(ip->i_mount,
-					XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+			xfs_agno_mark_sick(ip->i_mount, XFS_INODE_TO_AGNO(ip),
 					XFS_SICK_AG_INOBT);
 			return -EFSCORRUPTED;
 		}
@@ -1287,7 +1285,7 @@ xfs_blockgc_set_iflag(
 	ip->i_flags |= iflag;
 	spin_unlock(&ip->i_flags_lock);
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 	spin_lock(&pag->pag_ici_lock);
 
 	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
@@ -1324,7 +1322,7 @@ xfs_blockgc_clear_iflag(
 	if (!clear_tag)
 		return;
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 	spin_lock(&pag->pag_ici_lock);
 
 	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
@@ -1802,7 +1800,7 @@ xfs_icwalk_ag(
 			 * us to see this inode, so another lookup from the
 			 * same index will not find it again.
 			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
+			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
 				continue;
 			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
@@ -1916,7 +1914,7 @@ xfs_inodegc_set_reclaimable(
 		ASSERT(0);
 	}
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index beaa26ec62da..8a25cefaa17f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1363,7 +1363,7 @@ xfs_inactive_health(
 	if (sick & XFS_SICK_INO_FORGET)
 		return;
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 	if (!pag) {
 		/* There had better still be a perag structure! */
 		ASSERT(0);
@@ -1802,7 +1802,7 @@ xfs_ifree(
 	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
 	ASSERT(ip->i_nblocks == 0);
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 
 	error = xfs_inode_uninit(tp, pag, ip, &xic);
 	if (error)
@@ -2311,8 +2311,7 @@ xfs_rename(
 			struct xfs_perag	*pag;
 			struct xfs_buf		*bp;
 
-			pag = xfs_perag_get(mp,
-					XFS_INO_TO_AGNO(mp, inodes[i]->i_ino));
+			pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(inodes[i]));
 			error = xfs_read_agi(pag, tp, 0, &bp);
 			xfs_perag_put(pag);
 			if (error)
@@ -2859,7 +2858,7 @@ xfs_inode_reload_unlinked_bucket(
 	struct xfs_buf		*agibp;
 	struct xfs_agi		*agi;
 	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agnumber_t		agno = XFS_INODE_TO_AGNO(ip);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		prev_agino, next_agino;
 	unsigned int		bucket;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1c098cfc5c00..cd8b85dac7a8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4529,7 +4529,7 @@ TRACE_EVENT(xfs_iunlink_reload_next,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agno = XFS_INODE_TO_AGNO(ip);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 		__entry->prev_agino = ip->i_prev_unlinked;
 		__entry->next_agino = ip->i_next_unlinked;
@@ -4552,7 +4552,7 @@ TRACE_EVENT(xfs_inode_reload_unlinked_bucket,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agno = XFS_INODE_TO_AGNO(ip);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 	),
 	TP_printk("dev %d:%d agno 0x%x agino 0x%x bucket %u",
@@ -4572,7 +4572,7 @@ DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agno = XFS_INODE_TO_AGNO(ip);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 	),
 	TP_printk("dev %d:%d agno 0x%x agino 0x%x",
@@ -4769,8 +4769,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
 		__assign_str(name);
-		__entry->agno = XFS_INO_TO_AGNO(cur->bc_mp,
-					cur->bc_ino.ip->i_ino);
+		__entry->agno = XFS_INODE_TO_AGNO(cur->bc_ino.ip);
 		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
 					cur->bc_ino.ip->i_ino);
 		__entry->levels = cur->bc_ino.ifake->if_levels;
-- 
2.53.0

