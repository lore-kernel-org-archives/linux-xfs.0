Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26440125D6
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052278; cv=none; b=QV9X9XZJFysknPoOE4V8A97UuRggnXkNyPJy6CzJ0dyGVVjH9lUm71bHfQ9ocuy5veTA4zx0yokjgLKLtNxR+NRqneCYOKm2jQhRv1rZGqJ/QF9waVdRp2tKMnp7jXYb+1MGlsbOXvDnWd0+ZFZVZu2B3/L+tUQlEALSnPYef2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052278; c=relaxed/simple;
	bh=jDNB8Zr1GhUZO5Rwu1P2D9BWFtP8ItaGSJLdq3tZ6ZQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kKcl9BI5cu+fpJuhhx6qBhA1/NDC01GxpLz0QUhS8qei76+Bz0oTDrfegQM2Cg+o4rTzan3KvRp5F/enMb0nVDG5H9wfIpFmNltcudDiz7dg6A9W54PS1Ho7udMYPxFN9DXxqehHMmfGUawmvfxiqS8YWOoNmncKEakPUzjbB0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAPIJRdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAPIJRdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FE8C4CECE;
	Fri, 13 Dec 2024 01:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052278;
	bh=jDNB8Zr1GhUZO5Rwu1P2D9BWFtP8ItaGSJLdq3tZ6ZQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FAPIJRdWMjGRFXjz82XyG2omW04eDK2Gp8ctHDr6ZFCAtJ3hp0g51nvCJmVN3MQ5V
	 AlfosXPSoNsOc8/6hoNJAOiImLK3rwDVpvIQT0HxmuDxWk14zfJ2S/e/3PPBL5HwuT
	 a2ajKKFyKICyNX9zQ97e5RqC+l9yQHRbP2LPB49/DaLXJgBo9XNeTX49Mfb9pw0G2d
	 7xr5f5+oSp7z90vV6FdBc8v+zjQ8gP/Abcfh4yglZKhdKk/ZxCmXUkfLQSjGKUW5H7
	 JlKiGQoiBKlkwDp4momRP/OPlh3whTgayZ31UOEHS+qvhr7dKrhHOqM6fjPhLy+Xtg
	 l3ounln9OLG5w==
Date: Thu, 12 Dec 2024 17:11:17 -0800
Subject: [PATCH 04/43] xfs: realtime refcount btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124636.1182620.10803993698212980927.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrefcountbt to add the record and a second
split in the regular refcountbt to record the rtrefcountbt split.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f3392eb2d7f41f..13d00c7166e178 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -92,6 +92,14 @@ xfs_refcountbt_block_count(
 	return num_ops * (2 * mp->m_refc_maxlevels - 1);
 }
 
+static unsigned int
+xfs_rtrefcountbt_block_count(
+	struct xfs_mount	*mp,
+	unsigned int		num_ops)
+{
+	return num_ops * (2 * mp->m_rtrefc_maxlevels - 1);
+}
+
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
@@ -259,10 +267,13 @@ xfs_rtalloc_block_count(
  * Compute the log reservation required to handle the refcount update
  * transaction.  Refcount updates are always done via deferred log items.
  *
- * This is calculated as:
+ * This is calculated as the max of:
  * Data device refcount updates (t1):
  *    the agfs of the ags containing the blocks: nr_ops * sector size
  *    the refcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
+ * Realtime refcount updates (t2);
+ *    the rt refcount inode
+ *    the rtrefcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
  */
 static unsigned int
 xfs_calc_refcountbt_reservation(
@@ -270,12 +281,20 @@ xfs_calc_refcountbt_reservation(
 	unsigned int		nr_ops)
 {
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+	unsigned int		t1, t2 = 0;
 
 	if (!xfs_has_reflink(mp))
 		return 0;
 
-	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
-	       xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+	t1 = xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+
+	if (xfs_has_realtime(mp))
+		t2 = xfs_calc_inode_res(mp, 1) +
+		     xfs_calc_buf_res(xfs_rtrefcountbt_block_count(mp, nr_ops),
+				     blksz);
+
+	return max(t1, t2);
 }
 
 /*

