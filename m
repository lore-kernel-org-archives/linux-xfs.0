Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0621A0BF1
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636845; cv=none; b=lqwJUYN08jKVt3I/SD39roUm2gapCEusXg0duXFlmpZO0OWBdUH02c+s3/i/0U6EJVkpT34XDiJNNxU8ICn2SUSGns5d256/hDFicH0W+O2qSJI7dJYJ07NLDMLzz7vzKKvpb/E7/8bOcJC1Mn8YQScuvidWChw4AKbkcXqMAts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636845; c=relaxed/simple;
	bh=zGRCtcQCM5dlQdrk01yBhVtilUTnGumzI/f8YFuFJlI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnPV1TwjKvYFHSQDlOZAlldfp2pL2ZDldqtp7qxtYO94Ypsql+EALRpm2GCZJm5irumGNM62Nb4tULbFlojYTnbIBj+qGSpJCkAMBWtDK4so9w+NLKSHwlnJq8fJ9fpxyDfsy/u/+BFx6ep7Zy90f074ULtzRb8WHYCMdF3fZKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rmicF6Qb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rmicF6Qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27912C4CECE;
	Thu, 19 Dec 2024 19:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636845;
	bh=zGRCtcQCM5dlQdrk01yBhVtilUTnGumzI/f8YFuFJlI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rmicF6QbK6A3P2zmBm9EqVO+iGow1FEfe088W3mZ2lbKQ5VlDPbNHyo8h2IqaBSgh
	 H+//UEJoxW/Q7QpZWjM8Mm9xRSM3zAp1wNl003+k4JNnIZXPlyzSNafqKkgTzW78Ym
	 IIhMCyiT9uqEFztSEX50Ii5wh96D66GvJE5O0X+alzwtRWqae3RTECRGtIHcBRFh/l
	 VdQ2Jy3xRRwffKJnZ+YTdiAUsK0fZmCZ0T5kFehzeruqo16TsRyMVlffz0ROTkZo7u
	 LiQeCgZZKOflE2MxvZJX1BDqKWGf0CDCUiGV5WWHuxPAuKX1TWJc+MziGcQNEGniVt
	 hqfKRlzuilkqw==
Date: Thu, 19 Dec 2024 11:34:04 -0800
Subject: [PATCH 04/43] xfs: realtime refcount btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581046.1572761.4038146946641618516.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

