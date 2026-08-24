Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCFB283FDC
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571970; cv=none; b=VnIGNKo5cVhPvBs2PcTvtlUFX1mQbMQxNB4pOwo6n/zZzwPITL2aqY1HH1bGOIiIUyd9Ok/j9P+xM5COqpdheIp80rqO6vRXQz9UNyNwMT3/aGcgPPbe+eEzDL3GIaNk64PK0jXDQrFgMl779HL6X26Sv/+5y9r2hCTD3znSLAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571970; c=relaxed/simple;
	bh=QcZhTwxiauWXXEMDd7MKASzj2VWdPGEYnXHjn5pEp7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw0mTC2KpaPZCczq39gvbhf5lBmAjS7+PH02vuSpRoKx8wukvOfdM31z6Pxz8FIr0ZEf9n9yowCoSxk13LwdKLDt6qnjHZuJInMg1s70MVOcHj9kDJ/RWvleFgM7aBvGJbyysTJ8ETyxRtkiRoZKIMdbVvwM6VyOyT+2jIPlS6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfYzzhTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfYzzhTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8C01F00A3A;
	Mon, 24 Aug 2026 11:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571967;
	bh=0ViqZnRSQKf/RbpZEcmON3lBce567v/p4rB7mT1FO8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfYzzhTm/g9xvCMBDpveDl3Pnhg89liTtHFWJ/PYTC/2KSas8lcXo2R8q7qrHzebu
	 +G8WP4GDCpLLpSFYvdSfaluYUzmn4XSlfHrBz4d+reaL6hvUvNJ/szKcSliYq/qNT5
	 bVfcS6JJVGg1RZWSYP2TBIVcPO/cg8N0WDdeKdpCcJK2HWwahQSiiLL4P4Syg57PUF
	 zf/4U/B+7OFFVIqOB2nKkgFWi9C+q4N2C388ogXfyVARKDASXYd+ekX7+qOusYURfI
	 IoC1Atgo19Pl01gjsiyIQswKPa7hSOEExD/gE/dvP70W0EOfhpm4LykDhMXoNRlbee
	 YlQpFEsBczv4g==
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
Subject: [PATCH 05/21] xfs: add a XFS_INO_TO_FSB helper
Date: Mon, 24 Aug 2026 12:40:03 +0200
Message-ID: <20260824104022.420566-6-aalbersh@kernel.org>
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

Source kernel commit: f8b7c9a8b0a9e43b054981d134b426d9464264f6

Add a shortcut for the common XFS_INO_TO_FSB(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c   | 8 +++-----
 libxfs/xfs_btree.c  | 6 ++----
 libxfs/xfs_format.h | 2 ++
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 96975f88497a..d211d31697a2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -675,8 +675,7 @@ xfs_bmap_extents_to_btree(
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
-	error = xfs_alloc_vextent_start_ag(&args,
-				XFS_INO_TO_FSB(mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		goto out_root_realloc;
 
@@ -822,8 +821,7 @@ xfs_bmap_local_to_extents(
 	 */
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	error = xfs_alloc_vextent_start_ag(&args,
-			XFS_INO_TO_FSB(args.mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		goto done;
 
@@ -3584,7 +3582,7 @@ xfs_bmap_btalloc_best_length(
 	xfs_extlen_t		blen = 0;
 	int			error;
 
-	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
+	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
 	if (!xfs_bmap_adjacent(ap))
 		ap->eof = false;
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4ab0d8d3789b..0069fba162a8 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -3240,8 +3240,7 @@ xfs_btree_new_iroot(
 	if (level > 0)
 		aptr = *xfs_btree_ptr_addr(cur, 1, block);
 	else
-		aptr.l = cpu_to_be64(XFS_INO_TO_FSB(cur->bc_mp,
-				cur->bc_ino.ip->i_ino));
+		aptr.l = cpu_to_be64(XFS_INODE_TO_FSB(cur->bc_ino.ip));
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
 	error = xfs_btree_alloc_block(cur, &aptr, &nptr, stat);
@@ -5606,8 +5605,7 @@ xfs_btree_alloc_metafile_block(
 	ASSERT(xfs_is_metadir_inode(ip));
 
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	error = xfs_alloc_vextent_start_ag(&args,
-			XFS_INO_TO_FSB(cur->bc_mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK) {
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f812c6782492..9886af0507e3 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1289,6 +1289,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 	((int)(i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
 #define	XFS_INO_TO_FSB(mp,i)		\
 	XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))
+#define	XFS_INODE_TO_FSB(ip)		\
+	XFS_INO_TO_FSB((ip)->i_mount, (ip)->i_ino)
 #define	XFS_AGINO_TO_INO(mp,a,i)	\
 	(((xfs_ino_t)(a) << XFS_INO_AGINO_BITS(mp)) | (i))
 #define	XFS_AGINO_TO_AGBNO(mp,i)	((i) >> XFS_INO_OFFSET_BITS(mp))
-- 
2.55.0

