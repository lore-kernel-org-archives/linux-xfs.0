Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F0A3F074A
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571961; cv=none; b=RA9hSjiU/nVbijawBhTJEuVjaG5JJnTjU26ls0cv/FXh4+/mOPDsszjBVO6SgMQwRPOdT7dz1+LNU0DoM/4G+SSBFnIYCHx2OCfxpJoLXj+vhcRUlDaPI9gaNxAbcGk/9iVKeSEIWQfnLHxlBYAuwXGp+SGkArxKwmeUvhpiuAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571961; c=relaxed/simple;
	bh=fjiBLVHBU061IF8OK4Gemc6k5I/w+nuLxWl5NdctvLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iru1eIdvqJJqeihCyEJn9saFed+TUxtuPawBVRADYbb+/RYQg2Vkj7q/h1waem44nZqmqlty6aqe+H0YcoLbgTf6qWhnD0TyWgSGNpLAvhWOTkB5GXzrfHLpCMuqEEXGeKbVqy+0Jipw5YEJgQIuoX+7Bfwe0ANDcwcxn1h3ti0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erJ4oqg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erJ4oqg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5A71F00A3D;
	Mon, 24 Aug 2026 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571959;
	bh=M+4gO9cT78LOinDGBgQGravDOZPcaNFANp8Z7l1NmFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erJ4oqg2POhDB0zalEzleLk4uOIH48SLbiShKLB9FhNrLPbN0MDiE2VJ6eiEM2db3
	 OPZZHZ2z8OqbpfPzfCkn067HEgg//Lnawo80rfvD4D20Ql5ATeO9/SZvewh1DBPsF1
	 AV6R0+73cxDSTrJSDmzcygNBCB6YQYFVtXqzgJt0cv54zh0iplwzVxIMs3lizk6f96
	 Hybn1UMQqUUJvZH0wN/RTKItcdJ8eTFE3Kgedpo1PCXI4RzjFJ0fTPa6ftnhITG4TL
	 wzDOapK/HuZ1wusMcYD0DT75aD877YvJa7Q8mc1fopo2wXayK1xKm2WHqKgsmL6v4B
	 8rc4VWa3N/VfQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH 03/21] xfs: add a XFS_INODE_TO_AGNO helper
Date: Mon, 24 Aug 2026 12:40:01 +0200
Message-ID: <20260824104022.420566-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: a22166add624818a6c43b807d37f99483ba268a6

Add a shortcut for the common XFS_INO_TO_AGNO(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dir2.c       | 4 ++--
 libxfs/xfs_format.h     | 2 ++
 libxfs/xfs_ialloc.c     | 2 +-
 libxfs/xfs_inode_util.c | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 1a13fec25e15..562d617254b2 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -918,7 +918,7 @@ xfs_dir_add_child(
 	if (VFS_I(ip)->i_nlink == 0) {
 		struct xfs_perag	*pag;
 
-		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 		error = xfs_iunlink_remove(tp, pag, ip);
 		xfs_perag_put(pag);
 		if (error)
@@ -1245,7 +1245,7 @@ xfs_dir_rename_children(
 
 		ASSERT(VFS_I(du_wip->ip)->i_nlink == 0);
 
-		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, du_wip->ip->i_ino));
+		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(du_wip->ip));
 		error = xfs_iunlink_remove(tp, pag, du_wip->ip);
 		xfs_perag_put(pag);
 		if (error)
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 779dac59b1f3..36a00c174f1e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1276,6 +1276,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 	XFS_INO_AGNO_BITS(mp) + XFS_INO_AGINO_BITS(mp)
 #define	XFS_INO_TO_AGNO(mp,i)		\
 	((xfs_agnumber_t)((i) >> XFS_INO_AGINO_BITS(mp)))
+#define	XFS_INODE_TO_AGNO(ip)		\
+	XFS_INO_TO_AGNO((ip)->i_mount, (ip)->i_ino)
 #define	XFS_INO_TO_AGINO(mp,i)		\
 	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
 #define	XFS_INO_TO_AGBNO(mp,i)		\
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 31c818f9870f..abfba2bfabaf 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1865,7 +1865,7 @@ xfs_dialloc_pick_ag(
 	if (S_ISDIR(mode))
 		return (atomic_inc_return(&mp->m_agirotor) - 1) % mp->m_maxagi;
 
-	start_agno = XFS_INO_TO_AGNO(mp, dp->i_ino);
+	start_agno = XFS_INODE_TO_AGNO(dp);
 	if (start_agno >= mp->m_maxagi)
 		start_agno = 0;
 
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index fd8441bf9b83..8e439dc2f4fa 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -528,7 +528,7 @@ xfs_iunlink(
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	trace_xfs_iunlink(ip);
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
 	error = xfs_read_agi(pag, tp, 0, &agibp);
-- 
2.55.0

