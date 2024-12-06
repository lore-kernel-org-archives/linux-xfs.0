Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF98819ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527941; cv=none; b=uq26Vl3UljuwGK0lfano+5Q3/eA67MT3P5AjGoHFUst98UR2DV7KIGFkDhfyJhRLdnH2cnd3jAD4ZEXmRvvSkl591BhMYDDi8/2T78BhRxxL3csDhW8O7NAC4+iYsMdWQlYoQy2h0c00tl7HWMPw+IYmn1qqLHkcSaBABHZB/0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527941; c=relaxed/simple;
	bh=mJxq8u5Ig474T4JleUh06uBvfu1HTb+fZ8MAslQ8Ucw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BeHdohbmmvRFFE7XfLBxZJhzdqW2WqbKv7x7XCnwiiF/ppne/jTtncyr5WyaCpt1L4CQaP+d0AG4hg0bQGljQD58MAqRH+Yp2G8VNuGTUl+egZzdRkv3fNaIsny/WaD3dezZ/6+aeX/itzY5qGiKC8E3TbrxnjXyHuo4ihVcCSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqR4M6SC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqR4M6SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CACC4CED1;
	Fri,  6 Dec 2024 23:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527941;
	bh=mJxq8u5Ig474T4JleUh06uBvfu1HTb+fZ8MAslQ8Ucw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cqR4M6SCEAnFfuc4M8NIqV3PGcWLyWNp7KPs9lFZugQEemm7P3mdI8434xY0OtvAO
	 Bz4sSEYp6yTACaGx9/xsKXII4wzFnxbMJUtXwsnGVOW0QvStNEQ/u0g5xXlv5/UvKc
	 V+g71bT3QwPUphFMGtT7RJoqqCFSwhbeZKrCPNKNYlzwmZaXTZ92ehzN9iW3r3VzzI
	 afX1R9khkwC06PVmgXYm3IUzyIMgri7qhXxggJ0BoMeUbGOYa5jp3dL0572i1zZgQL
	 881n+dXM42Mfj50UobpCAOAcJ7plDrqnzKVeOvNlav7sCFJY6rq9JSp1Oe0y2ajNdr
	 iVNonf2X1ICmg==
Date: Fri, 06 Dec 2024 15:32:21 -0800
Subject: [PATCH 08/36] xfs: add a xfs_agino_to_ino helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747005.121772.6563246433541426499.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
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

