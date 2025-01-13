Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47CE1CDFA9
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 04:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742784; cv=none; b=HXHb3eu5syL+sv6pQTvKuaGMtnl4oBBrkANIZQNJaO3AeuM0AxbA5RLYMvfsK4zI0e1M6PNsKwF6vRmVgLFKLXVcIM+Lg8OM0TMKlHTvam+JEr+CkZQD6ougSGth5QWYx0LGv0e/ePz7O6zUvoXjugdCcOJsdN4J4QxjtAEXSbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742784; c=relaxed/simple;
	bh=vu976xgV6JuKi0Y3vOgJfsjVvou2Xr/Mh4xfrkoAg88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ss/oNKHtqHY59AzXBLYvykaGiMgPFDa3jWFVz9lDZR76yzUPrNE4y1qqm5HkO+9MAYo7C/cxjMzme7QgwfjK5JjeGHgxBK0nh5eDWl+XuIduj6RvsEtB7Z7cbMAj/VQStqGNdiibBdF/kUktrGFRUxCMtCbR5dcUr5uLQZRBHiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rh6INk+g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rh6INk+g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/hOOWRiPj/w2bqkdCSWZne7z9N48/9yhHlZWMS9uBbg=; b=rh6INk+gLN0ZwC9Q+TERU+N2pZ
	zaKaHGCEc2yPzMIeyd0rwj3ERWWBqXkzJgadEzixJUHszq4tfV+JVxxmZwfU+YOTM4DgJAXL0i1Bv
	Smh7471izL/Bko6Ko/Gv6c2Gn7MAE6xhbjhQM4wn2wm2wDwb5CBsPwDq7ev5GOfWcf4vMIllN+2NJ
	FSS9GTH2CRoZtWGVkrYhCm+AMvFkwzY/ZxSNn/Hahz2S1Czmnj/hTRhNgxhNmaiLVn25jAVGe0Kzs
	MY2dISdAYru9lC/sVRSe4ZArLx9GfLEUA0eOe37Fy9x/sp4C/irI/cA5tno7m9LDWnaOy2OEwFnkf
	ST5aducg==;
Received: from 2a02-8389-2341-5b80-421b-ad95-8448-da51.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:421b:ad95:8448:da51] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXC8L-00000003zW4-3dVN;
	Mon, 13 Jan 2025 04:33:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: don't take m_sb_lock in xfs_fs_statfs
Date: Mon, 13 Jan 2025 05:32:58 +0100
Message-ID: <20250113043259.2054322-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The only non-constant value read under m_sb_lock in xfs_fs_statfs is
sb_dblocks, and it could become stale right after dropping the lock
anyway.  Remove the thus pointless lock section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7c3f996cd39e..20cc00b992a6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -850,11 +850,13 @@ xfs_fs_statfs(
 	ifree = percpu_counter_sum(&mp->m_ifree);
 	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 
-	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
+	/*
+	 * sb_dblocks can change during growfs, but nothing cares about reporting
+	 * the old or new value during growfs.
+	 */
 	statp->f_blocks = sbp->sb_dblocks - lsize;
-	spin_unlock(&mp->m_sb_lock);
 
 	/* make sure statp->f_bfree does not underflow */
 	statp->f_bfree = max_t(int64_t, 0,
-- 
2.45.2

