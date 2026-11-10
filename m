Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329197;
	b=SYTXJlE5XIXtlfvCu0Yc/eXHAW4nR4lVI4vq/97VI15vYF3L9N8i0hAkcLEd1f14qJNl
	 7J6yvp/ZrpatZItWcpkGD4p/RA0RwsWEIIcVwf1/fulOkurDV2Aol1AmMT4/lQhqsL/un
	 pUBZmCPxKHw/enAHuKKpXycRgwglylh1SBmsyo2+BgTQnCVizA6sZXSJSGSw58bsIvaxx
	 4mBGeR8dwPr0BagkkAbRIp5nztz6RTPu23RkA99cNDJjY27quGp34Z2PoGethE/zctaeD
	 xtpZaBtGDDLf7AtTjthJnmeX43D3BX0afoPCrlh11bm0FLuiYTkv1vJ8kI7uwU+b+YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RkZTLW/CNSkiTnxbfbpGEWkEgUVDTZldEX2agu3X0pI=;
	b=KoHZDyZ1OeHUQDQvmQD44HI082GdezCigT5V7464FymlBhCE1aTWvCsRzg/SZnfgwrtb
	 KXWIxw+whiCmrpJ0+6TiKU08Qil7v5tVTGoRx7ildVZaesF6gQ89K7zLEV63IFUMGcMlT
	 JizryiRSLymSehUPWBkdukmvv8l7j5eV2jcexCpGbgDyhsuRmXy6jD0eJHuGTdTkOzAEU
	 s7PGL5l4oQ+2mee5RDMaDiAp4GhXzd7zu/EO8NfyzdQ+JAhn1rgdK/58DY3d50snKPC0y
	 DVdUAS0/vMmkqoiyz3tn6CPPtwB/Y1cH5Srgy3i2PPgu7A2c+aIOsrjtaqWKfqKtmUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lVs9Mmxk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B311B606A31C;
	Tue, 10 Nov 2026 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lVs9Mmxk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910431F008A2;
	Tue, 10 Nov 2026 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329196;
	bh=RkZTLW/CNSkiTnxbfbpGEWkEgUVDTZldEX2agu3X0pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVs9MmxkzykroIpe/PMxQmYOycYWyF0e50LIT4l6BiJwDAg2TpmyAbOiy3/8KlFt3
	 WXCZCcuw5sZs/LKicgWiwmmZEr/PIBtVg3qlMcC932ihRw559jB2kfFIMkeQxNadC3
	 OmsICsV1/KPaZ9+rwrofAoD6r6X3ATNSFoTUX3d1dXVjuyJcW0Kd3v1xQdsxYrCjwQ
	 JPaRiMO8cNMYg7ijTlVTS6PjtXqRh87Y4xVJ/hyoQYXbw6I+nbxfkeydYkUN3lisr9
	 C0OFyoxgyi8LbUfHvVyMQ8Sxvm53B3RbleH/rFQshgpoxuDaH5GI2xi8D7prf87nWW
	 8/A1f0Ol2I4eg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 2/3] xfs: Use folio_next_pos()
Date: Tue, 10 Nov 2026 11:46:32 -0500
Message-ID: <20261110164625.2532323-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110164625.2532323-1-sashal@kernel.org>
References: <20261107050829-failed-6.18-329750292e9d@kernel.org>
 <20261110164625.2532323-1-sashal@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit ac0a11113de3f0007283d20f5a38615ea4c6e9fd ]

This is one instruction more efficient than open-coding folio_pos() +
folio_size().  It's the equivalent of (x + y) << z rather than
x << z + y << z.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20251024170822.1427218-10-willy@infradead.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 329750292e9d ("xfarray: don't crash when sorting if array element crosses a folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/xfarray.c | 2 +-
 fs/xfs/xfs_aops.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index ccf7cfb63bbc8..78880b76b15d0 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -833,7 +833,7 @@ xfarray_sort_scan(
 		si->first_folio_idx = xfarray_idx(si->array,
 				folio_pos(si->folio) + si->array->obj_size - 1);
 
-		next_pos = folio_pos(si->folio) + folio_size(si->folio);
+		next_pos = folio_next_pos(si->folio);
 		si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
 		if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
 			si->last_folio_idx--;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9845a5fcf8575..4c9afca35fefa 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -271,7 +271,7 @@ xfs_discard_folio(
 	 * folio itself and not the start offset that is passed in.
 	 */
 	xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, pos,
-				folio_pos(folio) + folio_size(folio), NULL);
+				folio_next_pos(folio), NULL);
 }
 
 /*
-- 
2.53.0

