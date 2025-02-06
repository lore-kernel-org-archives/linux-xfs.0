Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D1A158525
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824320; cv=none; b=g3PFY2KvDBPLmvi6KWezB2oFrxgbBqU77sqpPceuCOGf91D0ljleeW9kbSgNbKuT0boqzQKHssn44AnEF429CO5ytCHhZ59XPkiWgCpot0V6MzJh6AsPCd/GkKjffgfa5Wk/QqLxwtA3nSLF9Ikewv+lEiHsWMpvEXbNVso/vpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824320; c=relaxed/simple;
	bh=H7NJOZASmaHp/yFweRqvJktvqMAvAwewCHx4hXQk/Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ao+KAckYAMJoOiXgYwzTyFc+YCuy22OJSWZ054knUmSEMJws1oBqusInfe0YmegGki3YNcKxlHuMKklKLePCs8mJnqq1hy8z/mYxu74yezNXAQCtqzR+0LTRHy4zdceIdf5P1u6QTYbjvIlx2U6j0C3eBzx8cDhClEATlN9zD+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zE+fZnz1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zE+fZnz1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cb365wOMtx88hhbd0L0O7xwRDA03zOJ6O/Y5qrSwiBs=; b=zE+fZnz1RxLYDysXWuTK5QwC7d
	hfW+0UEJTWlZEdQD7yBAFXsM03KJhVnpKLwGdMJ2gIMYdwvxIIVewbS9NBxbtYC33GSuAv7o8Elcj
	d5UW+53w8M1CGx3yHepBJlxW5qZHefMsRaqlyf+HS+lWscnzukR+/QUZuwX2y0Iet3x49WmrI7kQX
	98U/Mg1KTjuM6A7GD2WrxkSPuCSPzKaq+opjSCUoA2epQnK8nuuFuzr4yUNLJyh6vIDWbbJ0vfV+P
	yMiLAvXDlTnq2NF47ROc8Yg/a+oQj8PHhBAt9DWDlkHo13Rg+cjGHQ8d8xm75hAHA29CU35WvVzQR
	ZyK1fVpA==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvdW-00000005Q4H-0zM1;
	Thu, 06 Feb 2025 06:45:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/43] xfs: add a rtg_blocks helper
Date: Thu,  6 Feb 2025 07:44:18 +0100
Message-ID: <20250206064511.2323878-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Shortcut dereferencing the xg_block_count field in the generic group
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c | 2 +-
 fs/xfs/libxfs/xfs_rtgroup.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index d84d32f1b48f..97aad8967149 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -270,7 +270,7 @@ xfs_rtgroup_get_geometry(
 	/* Fill out form. */
 	memset(rgeo, 0, sizeof(*rgeo));
 	rgeo->rg_number = rtg_rgno(rtg);
-	rgeo->rg_length = rtg_group(rtg)->xg_block_count;
+	rgeo->rg_length = rtg_blocks(rtg);
 	xfs_rtgroup_geom_health(rtg, rgeo);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 03f39d4e43fc..9c7e03f913cb 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -66,6 +66,11 @@ static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_group.xg_gno;
 }
 
+static inline xfs_rgblock_t rtg_blocks(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_group.xg_block_count;
+}
+
 static inline struct xfs_inode *rtg_bitmap(const struct xfs_rtgroup *rtg)
 {
 	return rtg->rtg_inodes[XFS_RTGI_BITMAP];
-- 
2.45.2

