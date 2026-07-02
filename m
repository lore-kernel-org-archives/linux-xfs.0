Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33B834C9A6
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022487; cv=none; b=B/O8jxr+1yQeu97njzkmCfKEEj839QC9WO3UIFqD69qUzeBfZKAk40SXLKVxkBY/6iL9OKXzymSa5tbh8eTfgYPw2UzF6qAMiJ4xdhHSipQs/JtAVsZYc8ZYc2mS45RrjKRlwWaeJKgcnjZxxUs//AG6YeaH/lSn7xothxD9IOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022487; c=relaxed/simple;
	bh=2ePO+NKL4oq8+ZpTsETsH9ZNsTgi4MHU3V178WRcnsc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPt8i0jAzld3JZUx1d3X1L4kG6KHucPFNMW/Q2ziG8qN3jXZXL84rGdHzvf6FE5S5lOoiKYkiUsQ6ADFzE5tmVImKLnZgyJ7iijTI32LnS+0MDeqEz0R0ojyTP/jyNYstKXSRywegbn+f46ArhpZCq5e5SPh30wXtv2+J+MI6TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I//Cmjq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I//Cmjq7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 002511F000E9;
	Thu,  2 Jul 2026 20:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022484;
	bh=2s45o6GhpMgQ/Pqbqdt+s0+kiWaJQ+vLXQepdg7c0VE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=I//Cmjq7gsDgaGN9QhtIZoVVCPB5Dlz53qAnmMl3ccv261Tp/bfapSMiR12WxPEvw
	 hUYL/HrSknLQ5A/++lB1b4Vm9hKvChEwcvlQZgeT25bMB3cTjOXiCHSqf/7/AO6gCo
	 I+m3tWO1X5oijwcfdH5QTZlwM3ebYZZImDGkFtG0xWt7b5gpVY9IKiCNniEBUtElfp
	 3IkD34GVKtl4dwMabuIn2KoUSM+THXy8xXSDw78PV56fvK3eA2EooA7U/meXoqPV81
	 kZ2czGV8dXdPEVc0pGmya2madt6IN1SUmLryAJpX+TDo0IMb/ni52q5FYnhWnesngh
	 tduwTmcwUhoCg==
Date: Thu, 02 Jul 2026 13:01:23 -0700
Subject: [PATCH 04/18] xfs: add a XFS_INODE_TO_AGNO helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226377.845537.16062711503952166037.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: a22166add624818a6c43b807d37f99483ba268a6

Add a shortcut for the common XFS_INO_TO_AGNO(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h     |    2 ++
 db/iunlink.c            |    4 ++--
 libxfs/inode.c          |    2 +-
 libxfs/xfs_dir2.c       |    4 ++--
 libxfs/xfs_ialloc.c     |    2 +-
 libxfs/xfs_inode_util.c |    2 +-
 repair/pptr.c           |    2 +-
 7 files changed, 10 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 779dac59b1f3ba..36a00c174f1ea1 100644
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
diff --git a/db/iunlink.c b/db/iunlink.c
index c73f818242b983..20946c967f548a 100644
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
index dc7e227e8ee92f..83741b97117106 100644
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
index 1a13fec25e15b3..562d617254b2e3 100644
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
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 31c818f9870f8d..abfba2bfabafb7 100644
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
index fd8441bf9b83dd..8e439dc2f4faff 100644
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
index 6a9e072b360d7d..dc1ea2288eacc0 100644
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
 

