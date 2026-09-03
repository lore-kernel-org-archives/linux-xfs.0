Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314A8493656
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435669; cv=none; b=qwC+11mtZO3flBbr3xAjwjHIKoY3N8Ygv0C31P+NoIm2Ig4lra76gqrKPU6RiTSgLgTIB6l8Lr5o98Vu/BL2Je8urL7wdPbKzXRj65c4WMVznAaywvBGKIhkXuOrJiKGHRt5y6/tFqCsEYEWp+F4TfmTn9470rQNng9xTFVf1ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435669; c=relaxed/simple;
	bh=RbFTJSYmw9MYQClSQlXVonVwh2xy4Kp3NMW8NO6bALw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+s9r3oLH1iG9xisExk88NV8wDxNaSKLxFRZRO2O4zCZ+fhwx4EbJADTTcxEjtkshQ4YSJHBNbVKoREvkyJYijKrfcW8Ny+OU6uwTpuf7+6opCzRxVC6LIcioT90eO38p3YyOqNQMWV2AlGdiNc5Zsqn4+xqRYFwuuNVX5rz+hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifzi7etp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifzi7etp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CDF1F00A3F;
	Thu,  3 Sep 2026 11:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435659;
	bh=0kfddkv6Ejz8MemMORgGYiYBuhYvrja+7CAV8ccB0bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifzi7etpma/9pq6hzeH+wUhui286oRvrO72P5W33MVEvixB4BRdR/nmuFufP8GP39
	 BKE6P254uAeKWWddN6ie+jzIEFnK9uWn0PXMJ68ugGNp9cLD571Nt/h3WGLy+re4PT
	 m0qpZIZ/ZhF/z2FLWQp/uyTTY3CMyCX+vSuI0hWsq1LK98Yc98NoxzCt+R7RhRAQ0p
	 yI3sohP0x6Zq+boYCt2u/3BOx6vdAdorIEx7+EXp16sWLO8w81UJ93eYAszBHpk864
	 V6uctt0VuzCI3uvII1HHHcf4gB4zrf72LzQ/j1ru16VeEzF0eHCRjwgQVqi5+kwv6i
	 +XIEQB87A1fJw==
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
Subject: [PATCH v2 04/23] xfs: add a XFS_INODE_TO_AGNO helper
Date: Thu,  3 Sep 2026 13:39:46 +0200
Message-ID: <20260903114022.570210-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/iunlink.c            | 4 ++--
 libxfs/inode.c          | 2 +-
 libxfs/xfs_dir2.c       | 4 ++--
 libxfs/xfs_format.h     | 2 ++
 libxfs/xfs_ialloc.c     | 2 +-
 libxfs/xfs_inode_util.c | 2 +-
 repair/pptr.c           | 2 +-
 7 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/db/iunlink.c b/db/iunlink.c
index c73f818242b9..20946c967f54 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -22,7 +22,7 @@ count_rtblocks(
 	if (error) {
 		dbprintf(
 _("could not read AG %u agino %u extents, err=%d\n"),
-				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+				XFS_INODE_TO_AGNO(ip),
 				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
 				error);
 		return 0;
@@ -247,7 +247,7 @@ create_unlinked(
 
 	dbprintf(_("Created unlinked inode %llu in agno %u\n"),
 			(unsigned long long)ip->i_ino,
-			XFS_INO_TO_AGNO(mp, ip->i_ino));
+			XFS_INODE_TO_AGNO(ip));
 	libxfs_irele(ip);
 	return error;
 out_rele:
diff --git a/libxfs/inode.c b/libxfs/inode.c
index dc7e227e8ee9..83741b971171 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -159,7 +159,7 @@ libxfs_iget(
 	ip->i_prev_unlinked = NULLAGINO;
 	spin_lock_init(&VFS_I(ip)->i_lock);
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
 	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, 0);
 	xfs_perag_put(pag);
 
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
diff --git a/repair/pptr.c b/repair/pptr.c
index 6a9e072b360d..dc1ea2288eac 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -1050,7 +1050,7 @@ crosscheck_file_parent_ptrs(
 	struct ag_pptr		*ag_pptr, *prev_ag_pptr = NULL;
 	struct file_pptr	*file_pptr;
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agnumber_t		agno = XFS_INODE_TO_AGNO(ip);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	int			error;
 
-- 
2.55.0

