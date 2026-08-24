Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19627AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571988; cv=none; b=Kq9Y3nMvaaALg5S+NY0NccLnRUKxKFyQT/QPFk+5YhsMichv+dwSAOC/+3MnWr2RVnSlOdDHv8F1LkgfvA4nUx2LxJ2egJbxRSchq13QBdrdo8uTxfwtjibEOfy6cNpYPz6Bv1rHgdEEKxxrIzanoApftUB2f5m3UnphaKjnveM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571988; c=relaxed/simple;
	bh=+Pu4A5GIAbz5GOJupPQvk6lCs+LPtld93z1N+0zNqhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fD0vuB6AQ7hCQ9Ddo4vRYoA5iR2NV6gwKuQFyo+sM6GyyT461WpARfuEl0OkU5qSo9r/owjFXA5m0x/ghbpEzTJdZqtn1rn+Z9a5F7AkL7Mv/Sjwne62vVyf4M4dvLZYzbbyooqQgG8TS+zfCzJy74jmUH2r6ap/chgljbGAES8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUpXYx2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUpXYx2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420A31F00A3D;
	Mon, 24 Aug 2026 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571986;
	bh=FLBdIXbyMJMn0VH3TAaZJDvrnrU2VP4rxlyQQoGrxOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUpXYx2xPdH1t/SewIvLBpVXvOWeccfBGyuarfcKv8fO0HCtVVSpylUkqRfivCiE2
	 Ij/5F1gJ7Ia/tqVcwefon3coVQebVEaQ/TWLeUvIHgL/7KSXHhxg7N0M8FmMcHV27N
	 cY9V9jfmuQomGaOQXSzCYojBSMYchP3+KtYeF5FKDmXBQeYtpJya0Jonns/PxEFl4H
	 wFVqlDxqdRQ1v52q67QcK4Qvf72BKn7ECa4HBYgEgeOmu4FYwPec7Zaut+v5WhKMCW
	 HfjGMbq9lDwGlo9vWIJ8gCw85jbMXgvLtIG5lT6K/MmHQ1hIJ9q8/XCPPBwUKD5fGU
	 JByX566+ffnmQ==
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
Subject: [PATCH 10/21] xfs: remove im_len field in struct xfs_imap
Date: Mon, 24 Aug 2026 12:40:08 +0200
Message-ID: <20260824104022.420566-11-aalbersh@kernel.org>
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

Source kernel commit: 33451947c4f0f91df74af2db4384143446a1157a

im_len is always set to the same value for a given file system,
which makes it redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ialloc.c    | 10 +++++-----
 libxfs/xfs_inode_buf.c |  3 ++-
 libxfs/xfs_inode_buf.h |  1 -
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 8c42c045924d..f313acbe559a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2547,7 +2547,6 @@ out_map:
 		XFS_INO_TO_OFFSET(mp, ino);
 out:
 	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
-	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 
 	/*
@@ -2556,12 +2555,13 @@ out:
 	 * read_buf and panicing when we get an error from the
 	 * driver.
 	 */
-	if ((imap->im_blkno + imap->im_len) >
+	if (imap->im_blkno +
+	    XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster) >
 	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
 		xfs_alert(mp,
-	"%s: (im_blkno (0x%llx) + im_len (0x%llx)) > sb_dblocks (0x%llx)",
-			__func__, (unsigned long long) imap->im_blkno,
-			(unsigned long long) imap->im_len,
+	"%s: (im_blkno (0x%llx) + len (0x%x)) > sb_dblocks (0x%llx)",
+			__func__, imap->im_blkno,
+			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
 		return -EINVAL;
 	}
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 2fc9462e95d6..84800fb3b37b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -134,7 +134,8 @@ xfs_imap_to_bp(
 	int			error;
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-			imap->im_len, 0, bpp, &xfs_inode_buf_ops);
+			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
+			0, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
 				XFS_SICK_AG_INODES);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 8d43d2641c73..54870796da41 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -15,7 +15,6 @@ struct xfs_dinode;
  */
 struct xfs_imap {
 	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
-	unsigned short	im_len;		/* length in BBs of inode chunk */
 	unsigned short	im_boffset;	/* inode offset in block in bytes */
 };
 
-- 
2.55.0

