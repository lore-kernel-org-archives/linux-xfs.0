Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682592376EC
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596249; cv=none; b=VDg322tVCnyWiJB/P9zOorB99kWvEasRhcAuG+rY+VYBm1rmD686Wuo5hcDT/v9V09dsbwmQMlLXzuD7FHabnr8AxW5jtHUyzWGXX+N6mfTMpUvyrMtX92u29w9FhT0WqF46iqF7TrXz6uPAbQjdZrj90byVXhDnqqy5VM+Qfw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596249; c=relaxed/simple;
	bh=H7NJOZASmaHp/yFweRqvJktvqMAvAwewCHx4hXQk/Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Atq1ig/X73U0+mqTYHhmDJ/OOH4VGY/oJlaMw1a8NVIIOcrVI3wqPtbxLrNjV5hKnn0DRK/EHiWVjG6o2k5ABCcW6ym9dvhzIaAuaUGH4vNdgklF8l3Qajacjlj25l+pioiWW4k9az+KYob9Q9WDhepfcGafCcR0y8Z5b7NLxN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DMbmsjPY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DMbmsjPY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cb365wOMtx88hhbd0L0O7xwRDA03zOJ6O/Y5qrSwiBs=; b=DMbmsjPYmF0XzY68lw4oCNXiLr
	GBKgpKfKXG6SQtnW3wbbZMe2g8ezog2gtiOCFnOgi0ksBNyLAfAlK3jgXIvCJMom/Zrpm3jnzrkOy
	+xFQav8q446TSjzKlGCjpr3Z4ic1KlktDgSdLUrSelFUgEDtf38Mh7VtCUksCPJ+H2f8iCfPPUVvg
	zTgS2JKqhukFDcCxrxpNSmS6LiG8lE5yuaEM5ORsloLSVcNVEGScdNuE21o60NfG14EjgazFWGIBo
	fs6WPMuSJLT9H3VZKXRDksyn9HkXDtVfIpe85NO+LP1A5wTK9MGb0/kiqwyMiwIVj1bqVd7zn5h3I
	7p8MFzFQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb1-000000053sL-0CDa;
	Wed, 26 Feb 2025 18:57:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/44] xfs: add a rtg_blocks helper
Date: Wed, 26 Feb 2025 10:56:41 -0800
Message-ID: <20250226185723.518867-10-hch@lst.de>
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

