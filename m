Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889DC40F75A
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435692; cv=none; b=AOysy9tUj4aBkEIczhL4IkMuWev3uxIkbcE8UqOiDkg1E+EAraXI73oNYG9azC1BsCYHYXnsGYeyZSjBN40QDwtnLKn2N1//HBlLZxzqulFRks4uqD6OVrKO8387w+5TICyfuKq3y9eOyvWBDWsEUmxE7L+SuSCSMDYROsuSJDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435692; c=relaxed/simple;
	bh=zlSAlVP7TqI8+SARUQX2Fege67IBVIez/MRhzTfaVJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjfrCbEoClHPW+y7/lUp3w7abHyajDKFhlSsWxDGSrO9gcCp8Rpbq0o1DHCwzWIXz/dVA7lsOwchejws5d2npLfqN3xxigQb9dxyUEn0MoFdyeu5CuYYxTFQJT45WKJkBHjW2YcGoRfEfDqDLralIoOxG1F/05zWBC818hrN+m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkSIuj7J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkSIuj7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE4C1F00A3A;
	Thu,  3 Sep 2026 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435683;
	bh=kJWhVFArwM7pSEgIspW+QlSIdBNyoxpvyJfwEkQEHjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkSIuj7JwC+pLr6EpzJ6BfKSGie+ogn+b6d7jyxU44EypY0m1Jz1jFXyk0MFpmM9b
	 ph1SNIu1eJJxxwt/8P6+UlrLtwWsWhQlDcE7FKvuD52c9kFanqWPKR6O0qVD6BhCKE
	 hiPx/StODkVbeoAO2L0S4tK0N+S01jVVjFZ4xbuiQEP+NUYcYZMvEvci1NIwA9Dj6P
	 q53M5CtAkbqKD3qAjcqkqIo+AIajwC0BM51UFMX6ROhgJeC1pj9Z6R9feYvpJvS4kt
	 kUawJOCqtaJpbXKdVaUSKM4axtcwXGpQwdFp7Cq9qVQmBBrnI1PNLVO0uP7Q91Gpfr
	 Wb7XhE25Xak5g==
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
Subject: [PATCH v2 11/23] xfs: remove im_len field in struct xfs_imap
Date: Thu,  3 Sep 2026 13:39:53 +0200
Message-ID: <20260903114022.570210-12-aalbersh@kernel.org>
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

Source kernel commit: 33451947c4f0f91df74af2db4384143446a1157a

im_len is always set to the same value for a given file system,
which makes it redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

