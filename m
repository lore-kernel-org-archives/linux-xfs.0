Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD152F50A2
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669842; cv=none; b=M8KURUgFdfzAaJUj8chuWLoIFiFmZ+EZO7YvQds3ZZA0+HXlwOZYAsQTnlgnZSAuScLf2ccS2t7ZyX0I797ejlEREs+BGNtCuk08DX29cpElef6XYJWz2meb1O2y4d9F0OJhNtM18uViiy/ZH2ssMnktrtWxiiXCpGVwEUuTg+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669842; c=relaxed/simple;
	bh=zSjS6bE7IvcXaa2zM+ZBVjBRki9091BWv/kHMujLKm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcAJ4skYIKctcz6f1HIeYry2Y9Nv8Yv72iMiUr0nImcgaFMzitsr4Hhrw104p0OuT3mIGncrShzM4HthMJ73446BaR2MwffXb2mewJ3uxegdBi3IFQZ9K9utt93KOzYt1jOEsGoWN72K231z0FrinzUCIEkcJSfx/vCJoR4i9IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XdqFUaxj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XdqFUaxj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tYU8bWWgCKduLsPRVhoH40LGGRK/QVvpQuWp8h0FJrQ=; b=XdqFUaxjo16GWy+RVuLrqIwtas
	MVBxIBtzJvRBAI/fxsDG4H6e1K0bNqR3ArgkJfKDaQwzTCXpVNAfFi4hGAIYytjtC1P9m5FdT5u1f
	Am90gmFBNNDQigO+xxRZbzu2VOtP5Fmg+PReSXCetTHhpXjR5M8zL8xF9Rtp3Jx1LEs1rGP+xOW7M
	MT3z1S6129VpcQy8uBZ4G/85b/rnfSQChK5WPMkTLXXycsyFbYg/QqLCfbUCDHIwUGZN4ljLD4MLg
	J3q90xdlZT7utNBpKPU2gDZ2Ap3cj6QWEJTZoJvynLWifotdKuyNWKjVjF8MoMphrGzvOGVXGMagY
	kUgZ2FsA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1UN-00000007gsd-3tXe;
	Wed, 16 Jul 2025 12:44:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/8] xfs: use xfs_trans_reserve_more in xfs_trans_reserve_more_inode
Date: Wed, 16 Jul 2025 14:43:11 +0200
Message-ID: <20250716124352.2146673-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716124352.2146673-1-hch@lst.de>
References: <20250716124352.2146673-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Instead of duplicating the empty transacaction reservation
definition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b4a07af513ba..8b15bfe68774 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1163,14 +1163,13 @@ xfs_trans_reserve_more_inode(
 	unsigned int		rblocks,
 	bool			force_quota)
 {
-	struct xfs_trans_res	resv = { };
 	struct xfs_mount	*mp = ip->i_mount;
 	unsigned int		rtx = xfs_extlen_to_rtxlen(mp, rblocks);
 	int			error;
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_trans_reserve(tp, &resv, dblocks, rtx);
+	error = xfs_trans_reserve_more(tp, dblocks, rtx);
 	if (error)
 		return error;
 
-- 
2.47.2

