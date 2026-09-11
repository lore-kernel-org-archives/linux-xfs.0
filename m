Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A547934CFD0
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789137969; cv=none; b=XtxdwLiOCouw1E2ePdMzaH5C2Ilocr9ZEMwQ5D22qFuF7tOcl94eTZouNXshu3860vvCOQ/QYOxmvKDUPMEGD1Pwo5tovN1gMXOiiqvawWCHfHv5dio0xjhnF67hOJpDiiAvPtzJxeQBGu9pLKzgddUwZ9na0r60rMjg3K6IwRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789137969; c=relaxed/simple;
	bh=xK6XCvTEtB9SnypMXnsWaQWB5km7YkOw2iz+l+NtE58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnVFywIOByc07g1/WQySkGjrxt4FBDMS0atmpq2Q1dxPfxkHL0rAgHJgD7TuCsJPHO0+x3y4zflw9akycu/WDJm1LaxKD1edAeLK/zEOKdktAEWmT9UxsFXJ12coRr3+ZyfLPt2uvGjGHIapkmH/SL/aUSVObhze4J4fX7/5HkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x2ojuloH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x2ojuloH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rTY4ro+ZoZuGx0TdKbpr0mI5pE3xqXrjSthmyfiCbA8=; b=x2ojuloHhy6p9LIPinUyUH8/nV
	7arZD3BCvcm1y1Ac/jqWPaKlbioB5xUfOlHe4Q0TzfWSm91bodae97P1PSTCU9kwDs9Szh91Tehge
	ClrHq+G+nNoSkPmh7lbGengJr2Bg91Np3azx4964o+8bnJcF5JfAHCjVJbMrOANS84H0JY06MYO9V
	GZ1arYHLkQ7k0DUkcaVldxkKf9YZ9RPyxgkrR/tXMAgWbGH9YsCPDoSYmNwIphAgPLGSrR1W4ZmLr
	kfJZdRGLZEtf+glVVaxOdQj7wHwm9lqrmldIxGAkHO/fdFJK6FfLsCeo+MLnRdCRocvrBuiNBnXIT
	3lgvAGtQ==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x52Vw-0000000Gx2U-3Vrd;
	Fri, 11 Sep 2026 14:46:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] libxfs: don't set mp->m_rtdev_targp when no RT devices is provided
Date: Fri, 11 Sep 2026 16:45:42 +0200
Message-ID: <20260911144559.1959740-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260911144559.1959740-1-hch@lst.de>
References: <20260911144559.1959740-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The user-space only parts of commit 9840f7e09e2f ("xfs: allow internal
RT devices for zoned mode") accidentally set m_rtdev_targp to
m_ddev_targp when not name is set for the RT device, and thus disable
the check for a non-NULL m_rtdev_targp in rtmount_init.

This lead to tools working without specifying a RT device when they
should abort.  For example this can lead to repair trying to read
and rewrite the rtsb when called without -rc, which will then fail
in weird ways.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 5d8b4a153e28..2a46ddf086ed 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -573,7 +573,7 @@ libxfs_buftarg_init(
 	else
 		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
 				lfail);
-	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
+	if (xi->rt.dev == xi->data.dev)
 		mp->m_rtdev_targp = mp->m_ddev_targp;
 	else
 		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
-- 
2.53.0

