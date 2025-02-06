Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573C122FF37
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881826; cv=none; b=NwClSXsgoiLs0KJVsJQ5n8qMzfh4CnbdALNVpz4U2fuvQ9O/8PmyA2EKlw0jJFoKuUXT+9VXFnhx47f7V+jN6mlh5a8Yy6Sd2fU9tLNvgaVcIZ+kOA08kp2CTmM1L8upFjSpCvVHC3wybZQrxW0jbfbFtsv1HnGBJQkBm62QsTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881826; c=relaxed/simple;
	bh=SQIWPkrwCANkDFDaQWBcWma7xjwRh/Kw2bERaIsjjg4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TvjfMba9UsGuordj7XKfFss0QJcGbOY445ypbmyFGw3jtR27qgj7pQbbFz1Xm60FRhswgAThqn/e/SesDsVTVmldnYlkJjeQWdgSULwAr4rmGu0vY5UiaBpXRKPCKtA3oDSRxq00ygdquIhVsdm8JB13bovNZHsEJSWZfdhIuX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oIirmdam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIirmdam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47A2C4CEDD;
	Thu,  6 Feb 2025 22:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881824;
	bh=SQIWPkrwCANkDFDaQWBcWma7xjwRh/Kw2bERaIsjjg4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oIirmdamxuKAgk2BqFxez7Xn5qjIuJaUlXFN84boOirc2ZqC1YZIohUvgObemEoAG
	 7SwJW96kJNJMOBdXV2fArwBfb3s9N7Pdjop7BC6VlT1/aNoe8iMcGuSyan3GDoLQHT
	 eA+Cycj/56QPpNuA4kfzZbGHYZTM/RcAEPactlHRGkU4b7fqbwzBPEVHtjTZCbR4wV
	 07CIjRvXqp0nwaRLmOVPzgsHjn21sUxTlABPRzNN41gMojtV2s5PgOjZCLCuqHfIWc
	 hajGYnTCsNXukhYAPloySSTHOPM8d2Z+nq56mTtE8wz7rEQYOX00M/sQtA+yd39J4F
	 0CXspyWeqGSZg==
Date: Thu, 06 Feb 2025 14:43:44 -0800
Subject: [PATCH 33/56] xfs: realtime refcount btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087297.2739176.4006485865028652889.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 2003c6a8754e307970c101a20baf8fb67d0588f2

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrefcountbt to add the record and a second
split in the regular refcountbt to record the rtrefcountbt split.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_trans_resv.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index cdfac7a12906c2..4034c52790de8b 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -89,6 +89,14 @@ xfs_refcountbt_block_count(
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
@@ -256,10 +264,13 @@ xfs_rtalloc_block_count(
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
@@ -267,12 +278,20 @@ xfs_calc_refcountbt_reservation(
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

