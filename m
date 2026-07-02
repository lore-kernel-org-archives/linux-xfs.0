Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C69306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022593; cv=none; b=grmNLm6OubNkYkW/TE9m5A8PMWHRqV7+6quQ8gopI7fNz+rd+2rPPgen65BOf2/xn3p9wWtzl0CC8iJhums7f1bJ/9sRJsWwZ1oyuUqylBhk8ad3WaBX1Na6FusOcN4tTIXSL8O3k7GjBhwu0C0lupajYJk42MFEBz710mZdqFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022593; c=relaxed/simple;
	bh=KMj0nFKoFJHZCQydCkYuOhMLNFisbJiA0ws7PIfYJ+U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nl+9nH4AAIZmfPfJw+XLpC0i7yyHIt+XibM9I9Mea+M80IBbMkDG/FyUlKTy/Ty7JEzi/kJXUB2r20oxo/noa0yrWx+kgIVE6mXf7Qxotab7n26qr8AdW8AqaUB2ce33+9qqxs1oKK237TAXJqMgEEki9lLa+JMLoBLgOkux1xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoQOnetE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoQOnetE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9FDE41F000E9;
	Thu,  2 Jul 2026 20:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022592;
	bh=GYIcYlloZ3diiU/uv/3zoI2C1p/L2O6BWc5ea9PTMbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NoQOnetE4SXgnKRyVu2d7ad1GZIX86eDZi0uCIVAcAoX9MM4qHh1kdtWpfZMwvqsg
	 VgQC8hM/WrxRs3mUC+IqJsvTa53IoA4jrfm7HhllxWofLST8tcXGx9FSpgWpbzpOpq
	 PfyoSOlet8eFWkLXenYkN6jGNjaGzmvgg26vu+UXYQvz4kvwfgBadyutut6anIifFi
	 aNbn2G7f3eLXuulS1JxEoXkJkV1qf3I6HuAEGCDc+dLWJqSf5DS4py3cUlPgLkVNtL
	 4xYJo0GbCrp2HhGCm97HIr/4c0MSp2WmfhVA15wiryBwcGvjmOxCv7iyYmfIos0fAl
	 en+pERsqsxU/A==
Date: Thu, 02 Jul 2026 13:03:12 -0700
Subject: [PATCH 11/18] xfs: remove im_len field in struct xfs_imap
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226509.845537.18146846944832920640.stgit@frogsfrogsfrogs>
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

Source kernel commit: 33451947c4f0f91df74af2db4384143446a1157a

im_len is always set to the same value for a given file system,
which makes it redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_inode_buf.h |    1 -
 libxfs/xfs_ialloc.c    |   10 +++++-----
 libxfs/xfs_inode_buf.c |    3 ++-
 3 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 8d43d2641c7328..54870796da419a 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -15,7 +15,6 @@ struct xfs_dinode;
  */
 struct xfs_imap {
 	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
-	unsigned short	im_len;		/* length in BBs of inode chunk */
 	unsigned short	im_boffset;	/* inode offset in block in bytes */
 };
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 8c42c045924db8..f313acbe559ad7 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2547,7 +2547,6 @@ xfs_imap(
 		XFS_INO_TO_OFFSET(mp, ino);
 out:
 	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
-	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 
 	/*
@@ -2556,12 +2555,13 @@ xfs_imap(
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
index 2fc9462e95d67e..84800fb3b37b7a 100644
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

