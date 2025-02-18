Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13D51DDC07
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866322; cv=none; b=b76jUDJdbUn08ZjsSCWRTq2u8Lm8zJJV+ZA8SBNEpxL4DbqjR0RYE7n+vBsJzuigi3mHchtmSLdwHDWvcsa0X4nJYi/UtoPNh14RenT0VnYehkkwmutLPbEm51RM5NcMXlSWjwqNgpLeiOLu2epjXXasVeZxecAAPs4SbhOLBcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866322; c=relaxed/simple;
	bh=XpWNeFOr3oPgNpopTqgpdaT8RbWXtGirfLLLuQaUdaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcdQk4NxgtXlUPGqet6L6KSUbQCrB7vLpfav1ZmwGifNRFravY1/u0yuTplbIROB+O2eNlXz+wz0pVSUJe16dJHyyASMO5cfSPCVEcG4Rw6UUm3KlGrapNLz859bkw9PvbXNBnsQO183VYSVMNOAc4bkT4g6j+63ADdkM/q94/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y/OboHox; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y/OboHox"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bsTf1VGVm0mLe2YgrbHV++yjgSJ4PttZlWGSrY/lZo0=; b=Y/OboHox3zrq/nYGNkYBQa3s29
	frxNFexuYqruT8pCHD++cMjeges+q8wodCgMnpetrelczn4c1kXvKx3AQ59o7netZ3U6eKKgSKEcJ
	RbG+MIjA19u6AhD8AAjYq/tUjnubnA34hiBi+bXqoM2gZbAHvsBbw/j8cQRnx5XvDKZdQP2xlI/0E
	WjgfTugJ61LHV3uPzeIhDYzOD970Td9w5fEvHrOyWhZp91KKly6cDpdyVDoK4gB6/dnFVw6oWqRMj
	lqJI5FDJY5TxXWK3KJhO+lBkS99Q+TP/bwn+j3NlkSK8BQWcuEMWMcTbrtOAy70bhFNdYJWEYl2O4
	1UVTdOpg==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIhz-00000007CGE-10mm;
	Tue, 18 Feb 2025 08:11:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/45] xfs: reflow xfs_dec_freecounter
Date: Tue, 18 Feb 2025 09:10:04 +0100
Message-ID: <20250218081153.3889537-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Let the successful allocation be the main path through the function
with exception handling in branches to make the code easier to
follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 477c5262cf91..0598e9db488c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1260,7 +1260,6 @@ xfs_dec_freecounter(
 	uint64_t		delta,
 	bool			rsvd)
 {
-	int64_t			lcounter;
 	uint64_t		set_aside = 0;
 	s32			batch;
 	bool			has_resv_pool;
@@ -1299,28 +1298,26 @@ xfs_dec_freecounter(
 		set_aside = xfs_fdblocks_unavailable(mp);
 	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
 	if (__percpu_counter_compare(counter, set_aside,
-				     XFS_FDBLOCKS_BATCH) >= 0) {
-		/* we had space! */
-		return 0;
-	}
-
-	/*
-	 * lock up the sb for dipping into reserves before releasing the space
-	 * that took us to ENOSPC.
-	 */
-	spin_lock(&mp->m_sb_lock);
-	percpu_counter_add(counter, delta);
-	if (!has_resv_pool || !rsvd)
-		goto fdblocks_enospc;
-
-	lcounter = (long long)mp->m_resblks_avail - delta;
-	if (lcounter >= 0) {
-		mp->m_resblks_avail = lcounter;
+			XFS_FDBLOCKS_BATCH) < 0) {
+		/*
+		 * Lock up the sb for dipping into reserves before releasing the
+		 * space that took us to ENOSPC.
+		 */
+		spin_lock(&mp->m_sb_lock);
+		percpu_counter_add(counter, delta);
+		if (!rsvd)
+			goto fdblocks_enospc;
+		if (delta > mp->m_resblks_avail) {
+			xfs_warn_once(mp,
+"Reserve blocks depleted! Consider increasing reserve pool size.");
+			goto fdblocks_enospc;
+		}
+		mp->m_resblks_avail -= delta;
 		spin_unlock(&mp->m_sb_lock);
-		return 0;
 	}
-	xfs_warn_once(mp,
-"Reserve blocks depleted! Consider increasing reserve pool size.");
+
+	/* we had space! */
+	return 0;
 
 fdblocks_enospc:
 	spin_unlock(&mp->m_sb_lock);
-- 
2.45.2

