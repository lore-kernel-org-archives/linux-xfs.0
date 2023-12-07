Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8EE36C
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VecE+Tma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1941C433C8;
	Thu,  7 Dec 2023 02:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916855;
	bh=1nbo5xCmVDQiR51nkF9GvI4wlSSGPEaU2kzdjqxEKpE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VecE+Tma8mT/JQONKNXTz1T8RImt1gFwSi4a7pExtrCni5Qk62S1O10WIYqhvR0jH
	 m1vCulDTvYqjtv42EaWqp2CwnoiA/+uakOmyYqewEHEYJ1wV7dAufSff69f/PgEjCR
	 Mdbxq9GQKUzBTJ5fJm61mtjUIBlKEMlNMZ+BTMSrsSZbyyX9BfHm9RUtdMSFWUppNX
	 CuXuvuqK0kjVh9r5URd4Wa1Me+KIjwPqckosXdIfe1EJ8nc1Vlv03QgfxH/5xQJJXd
	 pb2eASQZtPzmNoQxf23HBeUN6d6OFei6qZZd2+C1d9uAMZlHxOATnlBB77um1Ty/PP
	 2Q7HMTkypsE7A==
Date: Wed, 06 Dec 2023 18:40:55 -0800
Subject: [PATCH 4/7] xfs: remove trivial bnobt/inobt scrub helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191665680.1181880.14296800294050969079.stgit@frogsfrogsfrogs>
In-Reply-To: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Christoph Hellwig complained about awkward code in the next two repair
patches such as:

	sc->sm->sm_type = XFS_SCRUB_TYPE_BNOBT;
	error = xchk_bnobt(sc);

This is a little silly, so let's export the xchk_{,i}allocbt functions
to the dispatch table in scrub.c directly and get rid of the helpers.
Originally I had planned each btree gets its own separate entry point,
but since repair doesn't work that way, it no longer makes sense to
complicate the call chain that way.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/alloc.c  |   34 +++++++++++++++-------------------
 fs/xfs/scrub/ialloc.c |   37 ++++++++++++++++++-------------------
 fs/xfs/scrub/scrub.c  |    8 ++++----
 fs/xfs/scrub/scrub.h  |    6 ++----
 4 files changed, 39 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 279af72b1671d..eb8ec47fc129c 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -138,33 +138,29 @@ xchk_allocbt_rec(
 	return 0;
 }
 
-/* Scrub the freespace btrees for some AG. */
-STATIC int
+/* Scrub one of the freespace btrees for some AG. */
+int
 xchk_allocbt(
-	struct xfs_scrub	*sc,
-	xfs_btnum_t		which)
+	struct xfs_scrub	*sc)
 {
 	struct xchk_alloc	ca = { };
 	struct xfs_btree_cur	*cur;
 
-	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
+	switch (sc->sm->sm_type) {
+	case XFS_SCRUB_TYPE_BNOBT:
+		cur = sc->sa.bno_cur;
+		break;
+	case XFS_SCRUB_TYPE_CNTBT:
+		cur = sc->sa.cnt_cur;
+		break;
+	default:
+		ASSERT(0);
+		return -EIO;
+	}
+
 	return xchk_btree(sc, cur, xchk_allocbt_rec, &XFS_RMAP_OINFO_AG, &ca);
 }
 
-int
-xchk_bnobt(
-	struct xfs_scrub	*sc)
-{
-	return xchk_allocbt(sc, XFS_BTNUM_BNO);
-}
-
-int
-xchk_cntbt(
-	struct xfs_scrub	*sc)
-{
-	return xchk_allocbt(sc, XFS_BTNUM_CNT);
-}
-
 /* xref check that the extent is not free */
 void
 xchk_xref_is_used_space(
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index fb7bbf47ae5d6..83d9a29ce91e8 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -708,11 +708,10 @@ xchk_iallocbt_xref_rmap_inodes(
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
 
-/* Scrub the inode btrees for some AG. */
-STATIC int
+/* Scrub one of the inode btrees for some AG. */
+int
 xchk_iallocbt(
-	struct xfs_scrub	*sc,
-	xfs_btnum_t		which)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_btree_cur	*cur;
 	struct xchk_iallocbt	iabt = {
@@ -720,9 +719,23 @@ xchk_iallocbt(
 		.next_startino	= NULLAGINO,
 		.next_cluster_ino = NULLAGINO,
 	};
+	xfs_btnum_t		which;
 	int			error;
 
-	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
+	switch (sc->sm->sm_type) {
+	case XFS_SCRUB_TYPE_INOBT:
+		cur = sc->sa.ino_cur;
+		which = XFS_BTNUM_INO;
+		break;
+	case XFS_SCRUB_TYPE_FINOBT:
+		cur = sc->sa.fino_cur;
+		which = XFS_BTNUM_FINO;
+		break;
+	default:
+		ASSERT(0);
+		return -EIO;
+	}
+
 	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &XFS_RMAP_OINFO_INOBT,
 			&iabt);
 	if (error)
@@ -743,20 +756,6 @@ xchk_iallocbt(
 	return error;
 }
 
-int
-xchk_inobt(
-	struct xfs_scrub	*sc)
-{
-	return xchk_iallocbt(sc, XFS_BTNUM_INO);
-}
-
-int
-xchk_finobt(
-	struct xfs_scrub	*sc)
-{
-	return xchk_iallocbt(sc, XFS_BTNUM_FINO);
-}
-
 /* See if an inode btree has (or doesn't have) an inode chunk record. */
 static inline void
 xchk_xref_inode_check(
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4849efcaa33ae..31fabae588beb 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -238,25 +238,25 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
-		.scrub	= xchk_bnobt,
+		.scrub	= xchk_allocbt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
-		.scrub	= xchk_cntbt,
+		.scrub	= xchk_allocbt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
-		.scrub	= xchk_inobt,
+		.scrub	= xchk_iallocbt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
-		.scrub	= xchk_finobt,
+		.scrub	= xchk_iallocbt,
 		.has	= xfs_has_finobt,
 		.repair	= xrep_notsupported,
 	},
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1ef9c6b4842a1..a6a1bea4d62b2 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -129,10 +129,8 @@ int xchk_superblock(struct xfs_scrub *sc);
 int xchk_agf(struct xfs_scrub *sc);
 int xchk_agfl(struct xfs_scrub *sc);
 int xchk_agi(struct xfs_scrub *sc);
-int xchk_bnobt(struct xfs_scrub *sc);
-int xchk_cntbt(struct xfs_scrub *sc);
-int xchk_inobt(struct xfs_scrub *sc);
-int xchk_finobt(struct xfs_scrub *sc);
+int xchk_allocbt(struct xfs_scrub *sc);
+int xchk_iallocbt(struct xfs_scrub *sc);
 int xchk_rmapbt(struct xfs_scrub *sc);
 int xchk_refcountbt(struct xfs_scrub *sc);
 int xchk_inode(struct xfs_scrub *sc);

