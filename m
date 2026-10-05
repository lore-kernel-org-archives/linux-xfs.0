Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A85248867
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205027; cv=none; b=V9kcwKBvd1OGGEg4nOwop6vhZZen/kPSh4WfTRfbvdVPZDcdfj7jNaC1aOJwY2cPDGHDiVJFgttEwXW2riy2pHMvwE6ReaPne4dniZWoTnHA7UNrGi5E6yNW3KPqWeYEQCPU0d0jnZFEM8MdY0cxZjWbf4GMqADQbS7mYpsZqaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205027; c=relaxed/simple;
	bh=vscSLBokJaNties1NgqnAl2xRc1k8o2c+27MOdCtSdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Egg9PpERweas/TnEHp0D/MtOusKNZJlBbEiG5Ke/oK5MV45XcrM59Dw78V1jm2C5MP0r4VI/DGQV6wYBR8FNcDHlWCP5TTXTi9Jo788wJzI9DpywKohuUlAvt+VB8rIqRtnGPDniqOy4O+rssColSeH0MlIj+1Ix62kBsZJaFjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mMW9CApI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mMW9CApI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8VwDLtJgxgouOMjyYm1FfwRW8YMOBUpnooT7EjuAnso=; b=mMW9CApIXfYUHFevBy5OYu+lRe
	be1fhFcEsbbNmMncaxWpfJCMcIKzXkLjndnQAE2cgonmf1g6d4xOJOi6C92hulrBaQ+BJYWL8C+t5
	bIUCYj39vbFOdH64/wbw8BWLtIIIORbjYfYag+OYjQOXiBexRMJ7RXl8qsmuWbgHbzJp6V4n2sgV9
	AzilVzIIuIT8NvuMW5oavnDkKyZnNp2c7vQNfcsIKdzeGVZTRAfZVMCNswc3QLGvnmfget5ABFINB
	t6U2Tu7M9pIU/Ae2kl5iAwy53HTpLRINGfbPrBxAWkaUZ1trt6EUdN20zGNYSqOqM6QDeZI1i7LGK
	YM7l0onw==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFc-0000000GR7K-3sBk;
	Mon, 05 Oct 2026 12:57:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/13] libxfs: remove libxfs_trans_alloc_rollable
Date: Mon,  5 Oct 2026 14:56:18 +0200
Message-ID: <20261005125637.1340355-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005125637.1340355-1-hch@lst.de>
References: <20261005125637.1340355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no real value in this userland-only wrapper.  Remove it and
open code the calls, and switch to clearly better fitting transaction
reservations where applicable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/stubs/xfs_trans.h |  2 --
 libxfs/trans.c           | 15 ---------------
 mkfs/proto.c             |  8 +++++---
 mkfs/xfs_mkfs.c          |  3 ++-
 repair/phase5.c          |  3 ++-
 repair/phase6.c          |  3 ++-
 repair/rmap.c            |  5 +++--
 7 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
index 1117aad80c2f..9e8737f09d8e 100644
--- a/libxfs/stubs/xfs_trans.h
+++ b/libxfs/stubs/xfs_trans.h
@@ -88,8 +88,6 @@ int	libxfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
 int	libxfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
 			struct xfs_inode *ip, unsigned int *dblocks,
 			struct xfs_trans **tpp, int *nospace_error);
-int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
-				    struct xfs_trans **tpp);
 struct xfs_trans *libxfs_trans_alloc_empty(struct xfs_mount *mp);
 int	libxfs_trans_commit(struct xfs_trans *);
 void	libxfs_trans_cancel(struct xfs_trans *);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index aa303288a81c..f36c54b9c806 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -306,21 +306,6 @@ libxfs_trans_alloc_empty(
 	return __libxfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
 }
 
-/*
- * Allocate a transaction that can be rolled.  Since userspace doesn't have
- * a need for log reservations, we really only tr_itruncate to get the
- * permanent log reservation flag to avoid blowing asserts.
- */
-int
-libxfs_trans_alloc_rollable(
-	struct xfs_mount	*mp,
-	unsigned int		blocks,
-	struct xfs_trans	**tpp)
-{
-	return libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
-			0, 0, tpp);
-}
-
 void
 libxfs_trans_cancel(
 	struct xfs_trans	*tp)
diff --git a/mkfs/proto.c b/mkfs/proto.c
index bdd0fadda517..f17ed3b88112 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -161,7 +161,8 @@ getres(
 	uint		r;
 
 	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
-		i = -libxfs_trans_alloc_rollable(mp, r, &tp);
+		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, r, 0, 0,
+			&tp);
 		if (i == 0)
 			return tp;
 	}
@@ -251,7 +252,7 @@ rsvfile(
 	/*
 	 * update the inode timestamp, mode, and prealloc flag bits
 	 */
-	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
 	if (error)
 		fail(_("allocating transaction for a file"), error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -1037,7 +1038,8 @@ create_sb_metadata_file(
 	xfs_ino_t		ino;
 	int			error;
 
-	error = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create,
+			MKFS_BLOCKRES_INODE, 0, 0, &tp);
 	if (error)
 		res_failed(error);
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index aa87951db0d0..eb863827d19c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -5706,7 +5706,8 @@ initialise_ag_freespace(
 	struct xfs_trans	*tp;
 	int			c;
 
-	c = -libxfs_trans_alloc_rollable(mp, worst_freelist, &tp);
+	c = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, worst_freelist,
+			0, 0, &tp);
 	if (c)
 		res_failed(c);
 
diff --git a/repair/phase5.c b/repair/phase5.c
index e44c26885717..4c67d049702b 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -610,7 +610,8 @@ inject_lost_extent(
 	xfs_agblock_t		agbno;
 	int			error;
 
-	error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 16, 0, 0,
+			&tp);
 	if (error)
 		return error;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index f3951a3d0709..f6f985a92541 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -507,7 +507,8 @@ mk_rtino(
 		libxfs_rtginode_metafile_type(type);
 	int			error;
 
-	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 10, 0, 0,
+			&tp);
 	if (error)
 		res_failed(error);
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 55c2b0928c52..9f824f848edc 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -714,7 +714,8 @@ rmap_commit_agbtree_mappings(
 		struct xfs_owner_info	oinfo = {};
 		struct xfs_perag	*pag;
 
-		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
+		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 16, 0,
+				0, &tp);
 		if (error)
 			goto err_slab;
 
@@ -1952,7 +1953,7 @@ fix_freelist(
 	args.agno = agno;
 	args.alignment = 1;
 	args.pag = libxfs_perag_get(mp, agno);
-	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error)
 		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
 				agno, error);
-- 
2.53.0

