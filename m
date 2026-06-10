Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549EF349CCF;
	Wed, 10 Jun 2026 05:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068062; cv=none; b=nHEBzZ0Hz3zN5SeixvzI0nO2oBruasc1p5keAA1bZGSIWLg356AJwWYGWkI0aTayDv0lpGQbrcKV8tTTEiw2itWP5RYXOTYQqEiWUb8BSotlhHdDY5kSGYJYljzOAFiaFGheWcFjXl+fyaRKFFbbt816i9jqTHM0R/wQyaCIsuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068062; c=relaxed/simple;
	bh=cNPVQn2OgGoFhfAuY++UbAD/Bdyrtuunx8YG+TNh9gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6/N/YVKNdnE4iDNog7DeSj8JWMstqOqH3DwfrRp85AYCmz8ahvOetB2LCef0ZSz+l63BjwHf3NiHoct67vCquXIFboSUv8FbhNPZDEfWIZYRUGlCZnGZeZ5KMwouLW15uSkxSdNu/aPQDxO2MS6whVUQ1ztQakmk0fAW5FLUWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q2IzERXs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q2IzERXs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QsD1nrQGxwECGADxFT4VtFhWnUq6d9NJMsZUI0rJPZI=; b=q2IzERXspgStpY/UAmRw8bBJgS
	QF2yQoITzphGE+T8DfBRZgNrdkuYSVzQHp1zIsOvfx9D41tuffjxH6bIwuZdbtrWk4tx4yytb7zu+
	nF07Ll2IeYeAY/jmeL1JE4ZwefEbItnWL2epVl+C49eoiSr2uOsIJWGY9F6+BMnCUxHF/dIeTybX+
	9kR4zf0nLVHtoeHuSKAHgNjbZ2N0s42mcK7tdYiFCrZStedl4XKNZg6FjnwRKtTmCbxI0Af2YJ4KK
	DuRhstUnWuuiIPaOHA5MNWVLZSvKdAh2qffcmTQtzBO7nniQfmfjCjHwZ2A0i6mxXZFyC9Gz5gNLs
	jUEG7Otg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXBAC-00000006o7o-3G2l;
	Wed, 10 Jun 2026 05:07:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/3] xfs: add newly added RTGs to the free pool in growfs
Date: Wed, 10 Jun 2026 07:07:20 +0200
Message-ID: <20260610050731.1906760-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260610050731.1906760-1-hch@lst.de>
References: <20260610050731.1906760-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When growing a zoned RT section, the newly added RTGs also need to be
tagged as free in the radix tree and add to the nr_free_zones counters.
Call xfs_add_free_zone to do that, otherwise using up the newly added
space will wait for free zones forever.

Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
Cc: <stable@vger.kernel.org> # v6.15
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 153f3c378f9f..debbcefdf07f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -933,6 +933,14 @@ xfs_growfs_rt_zoned(
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_rtrefcountbt_compute_maxlevels(mp);
+
+	/*
+	 * Finally add the newly added zone to the freelist and add the space
+	 * to the available counter.  The order is important here: only add
+	 * the available space after the zones, as available space guarantees
+	 * that zones to back it are available.
+	 */
+	xfs_zone_mark_free(rtg);
 	xfs_zoned_add_available(mp, freed_rtx);
 out_free:
 	kfree(nmp);
-- 
2.53.0

