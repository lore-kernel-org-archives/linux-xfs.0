Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BBC238D2D
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596254; cv=none; b=E2zn3LEZ0Szl3BhfdyD04lEaukpv30594irNgNZSz6e47J3Dm7907+tXNHBefIseBjpN4qFDnMOBU2XE8+5bMF110eAWnvMp7y99ag8kPAhFbFALW2po5ljo6ODu97wuPcVRpOtzk/aJ4T++w4o0cWxeXo1ESHgb/9ZeQvu3IuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596254; c=relaxed/simple;
	bh=PGWouvOc+gNSjvkA/eobUYaxS0puzpHDHCbA9qqc37M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFw6OyVuDdX+vSYTUvjEHWDjI+ZIICDewRMbJodpvxmygmoAVdY0RTkYpn976FCdxU2FjvXDnq9TqVAPJ2j60DGr2gbVgJz7XlfZzuu+A3QJVttA7KD3huaIviAs9KNBca9bKcIFaw5xGWJm3Rx+O1za/2KMWDPe1qrtTrLGYIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bhU6T5Wm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bhU6T5Wm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X0r8qJOozTQt+ER+SF3X9ToR28Keovm1zv4WwyV2nho=; b=bhU6T5WmbSa3eV21UkyIqfRFb4
	CYNNHD9J+i6sH1V75bmxnXrzNj6t4/00sgRM3L/YiNwIIGyTG9Bs2NbFmVXa2XhVf8IpV2OEKnirc
	AGWoq94lGkS/OVwbWfh8rPU8MhDdmE7YVy/gi5nmwt9OamaB+V0dH0ixZpMcUq5jI3oZ38sXhRAQF
	rM4P+2I9LkhKN8zS2pXeqpH3t4jGZSOyKjgLDOtTHpBSHUdpcIAwRycgJ86k0X/4Izmyd6f35LJnQ
	GUvpb6oiO71w9yJcVvAHhBrY82/8iTsx8UBNQMdWANl4dxJR9eAYHf1zHGcaqlXXFnF8z+49jgVzz
	t4oXQcaQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb7-000000053vl-0TH1;
	Wed, 26 Feb 2025 18:57:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 29/44] xfs: hide reserved RT blocks from statfs
Date: Wed, 26 Feb 2025 10:57:01 -0800
Message-ID: <20250226185723.518867-30-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

File systems with a zoned RT device have a large number of reserved
blocks that are required for garbage collection, and which can't be
filled with user data.  Exclude them from the available blocks reported
through stat(v)fs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 39b2bad67fcd..b6426f5c8b51 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -869,7 +869,8 @@ xfs_statfs_rt(
 {
 	st->f_bfree = xfs_rtbxlen_to_blen(mp,
 			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
-	st->f_blocks = mp->m_sb.sb_rblocks;
+	st->f_blocks = mp->m_sb.sb_rblocks - xfs_rtbxlen_to_blen(mp,
+			mp->m_free[XC_FREE_RTEXTENTS].res_total);
 }
 
 static void
-- 
2.45.2

