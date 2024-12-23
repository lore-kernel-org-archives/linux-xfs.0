Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8BF1D6199
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989953; cv=none; b=a+3jZYZfhHvvEQyqBSpEow5kxFwgoBHLiUCGAH4e/Y9M2FqEGJe6ToGtH+RpRyyHfvxpW/LWnqxZCeRyuSjVSBrZwbNZKs60I4OnXMr1DpzfFgB+IwGb06ZKiNiPg33Vr5XoZAB2K6Y5TyM2iHkv1umsNREKhY/TpvnryO64Rl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989953; c=relaxed/simple;
	bh=z+xOQtHRaBKCz7eXykLXEBF2Z/cXBJ40jKoFh5/mUPE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6mfgRrmN5WosPC72BSfaE0qXx6Oj0dtq/s4Pd6h4GUcMTozZ3O8rkyLl2QDe699tCNkp08/k1W4BD2fEpt0ipER2TMxLifYEabyUVXDAHaU4XDqXjsufAwveufHDsOg7ApjsF8FsOIEMPE4GxcRjSHowkKVJUL6OaIs0tfSvRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uS7/odw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uS7/odw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1112AC4CED3;
	Mon, 23 Dec 2024 21:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989953;
	bh=z+xOQtHRaBKCz7eXykLXEBF2Z/cXBJ40jKoFh5/mUPE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uS7/odw415e0Md7jugfa4I83XS68X/A5V1HQ+kFE/gvLS/lf3w+nL87HeOSMXTqUY
	 +6c8ivaO2G4QmwEgMS3zM2hqLS2WuMe2+jnWeB/65rJzq6erizeB1FNK3mUdhAZFf0
	 x/+NzrlQJSnYGEzXBlTGDsk+oLBqk+L9n1jS8YZo35odmDuIpFLtaZKe0xtbzWwjt0
	 rzYyqXEfCp/TK4AzunrtKDKiKKjHzzVh4QeOGmbiT7GGko4hZN/LEDsEYW7q+J3Uai
	 0RUj6GkFbKZq0cgc9rZOwiJzVT5XS6vLm+cJ8dKDAYTVOaU0SKDwjLAEnsXl3aNdGB
	 4YJ3jEYteIWMQ==
Date: Mon, 23 Dec 2024 13:39:12 -0800
Subject: [PATCH 08/36] xfs: add a xfs_agino_to_ino helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940069.2293042.16876229849757397847.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 6abd82ab6ea48430c13caebaad436ca6b5f2c34d

Add a helpers to convert an agino to an ino based on a pag structure.

This provides a simpler conversion and better type safety compared to the
existing code that passes the mount structure and the agno separately.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.h     |    8 ++++++++
 libxfs/xfs_ialloc.c |   24 +++++++++++-------------
 2 files changed, 19 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index c0a30141ddc330..e0f567d90debee 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -346,4 +346,12 @@ xfs_agbno_to_daddr(
 	return XFS_AGB_TO_DADDR(pag->pag_mount, pag->pag_agno, agbno);
 }
 
+static inline xfs_ino_t
+xfs_agino_to_ino(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino)
+{
+	return XFS_AGINO_TO_INO(pag->pag_mount, pag->pag_agno, agino);
+}
+
 #endif /* __LIBXFS_AG_H */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 6694ee2370411a..01b2e2d8c27c22 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -909,8 +909,7 @@ xfs_ialloc_ag_alloc(
 		if (error == -EFSCORRUPTED) {
 			xfs_alert(args.mp,
 	"invalid sparse inode record: ino 0x%llx holemask 0x%x count %u",
-				  XFS_AGINO_TO_INO(args.mp, pag->pag_agno,
-						   rec.ir_startino),
+				  xfs_agino_to_ino(pag, rec.ir_startino),
 				  rec.ir_holemask, rec.ir_count);
 			xfs_force_shutdown(args.mp, SHUTDOWN_CORRUPT_INCORE);
 		}
@@ -1329,7 +1328,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
-	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
+	ino = xfs_agino_to_ino(pag, rec.ir_startino + offset);
 
 	if (xfs_ag_has_sickness(pag, XFS_SICK_AG_INODES)) {
 		error = xfs_dialloc_check_ino(pag, tp, ino);
@@ -1610,7 +1609,7 @@ xfs_dialloc_ag(
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
-	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
+	ino = xfs_agino_to_ino(pag, rec.ir_startino + offset);
 
 	if (xfs_ag_has_sickness(pag, XFS_SICK_AG_INODES)) {
 		error = xfs_dialloc_check_ino(pag, tp, ino);
@@ -2117,8 +2116,7 @@ xfs_difree_inobt(
 	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		xic->deleted = true;
-		xic->first_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
-				rec.ir_startino);
+		xic->first_ino = xfs_agino_to_ino(pag, rec.ir_startino);
 		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
 
 		/*
@@ -2317,10 +2315,10 @@ xfs_difree(
 		return -EINVAL;
 	}
 	agino = XFS_INO_TO_AGINO(mp, inode);
-	if (inode != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino))  {
-		xfs_warn(mp, "%s: inode != XFS_AGINO_TO_INO() (%llu != %llu).",
+	if (inode != xfs_agino_to_ino(pag, agino))  {
+		xfs_warn(mp, "%s: inode != xfs_agino_to_ino() (%llu != %llu).",
 			__func__, (unsigned long long)inode,
-			(unsigned long long)XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
+			(unsigned long long)xfs_agino_to_ino(pag, agino));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2451,7 +2449,7 @@ xfs_imap(
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 	if (agbno >= mp->m_sb.sb_agblocks ||
-	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
+	    ino != xfs_agino_to_ino(pag, agino)) {
 		error = -EINVAL;
 #ifdef DEBUG
 		/*
@@ -2466,11 +2464,11 @@ xfs_imap(
 				__func__, (unsigned long long)agbno,
 				(unsigned long)mp->m_sb.sb_agblocks);
 		}
-		if (ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
+		if (ino != xfs_agino_to_ino(pag, agino)) {
 			xfs_alert(mp,
-		"%s: ino (0x%llx) != XFS_AGINO_TO_INO() (0x%llx)",
+		"%s: ino (0x%llx) != xfs_agino_to_ino() (0x%llx)",
 				__func__, ino,
-				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
+				xfs_agino_to_ino(pag, agino));
 		}
 		xfs_stack_trace();
 #endif /* DEBUG */

