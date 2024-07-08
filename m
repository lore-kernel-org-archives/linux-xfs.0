Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9917D14F110
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 12:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720440186; cv=none; b=U2tWHEb5SKRp4Yi2Lku90gX71TGPBvsVWr0w8v38JADJWRM8AkB3v6tYuRmmVnwqcdntOjhXtX3jP+C1WXlq8NBHbgVBOMelXODPsiq7uZDr1oLG608S1OSHlq6FhcrYntSwujOXgwSFtqZAS7INUsDMKjEIhgXcNYohmqh2w/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720440186; c=relaxed/simple;
	bh=6/O2/oN4s8GxLYcK2Z2lU6uejGCRYxyPPWVqaYjwUVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XCT3/OOW8tG4ILgsYHsRysEAuDaWo1xYJpyJia2FyId+7w/7ibqhSH5btGAZiX3EYvCSXgqeclZ7iqt/eSqSiTxhtTVIHZZAFIRaI3JH4sbA6xn902ol4TJgSiH8LetRKH4zLttmiuN5IBxxa68QzS0c2zk2Sq/bMKPmo8MoVX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PgSEj71i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PgSEj71i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Nmv7ty21OaLGwC9/uF6UWQC/T39fAf0DdnqKwq7To2c=; b=PgSEj71ihPT4ciQSGf+l/3HOqD
	jz8QLpTZ5LbnPMb57lcD0HNYD8iV0Oq5cCD7OSUuFjljgpMGPQExBpGj4BMbqCEqbGDhnQ8GozZGa
	rrxu2f+Oiny4OGefz+ZLCbhn1oREI+IyJzqBZYQyAd4u0DI/0S2d1gFW9jBF6onLHJTg9bXMko7XI
	WngrrfyZ6BGgPeAlbbw0Ek3YluwLzLysrjofWUwhVT5CHqnVDBgMmea70rx4fhj3wkqBOrH7pc/AD
	r9IoxPrwk1JBCZTPUInzfsJUFxzRTmlUlbTQG+eYQqQIzPmtuCnvDbc6IheXBiHPauPrWqf8v0DgH
	7lal3+Kw==;
Received: from 2a02-8389-2341-5b80-32a7-96d3-2226-ffd3.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:32a7:96d3:2226:ffd3] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sQn5D-00000003geU-36VH;
	Mon, 08 Jul 2024 12:03:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix rtalloc rotoring when delalloc is in use
Date: Mon,  8 Jul 2024 14:02:57 +0200
Message-ID: <20240708120257.2760160-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

If we're trying to allocate real space for a delalloc reservation at
offset 0, we should use the rotor to spread files across the rt volume.

Switch the rtalloc to use the XFS_ALLOC_INITIAL_USER_DATA flag that
is set for any write at startoff to make it match the behavior for
the main data device.

Based on a patch from Darrick J. Wong.

Fixes: 6a94b1acda7e ("xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1)")
Repored-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5a7ddfed1bb855..0c3e96c621a672 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -12,6 +12,7 @@
 #include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap_util.h"
@@ -1382,7 +1383,7 @@ xfs_bmap_rtalloc(
 		start = 0;
 	} else if (xfs_bmap_adjacent(ap)) {
 		start = xfs_rtb_to_rtx(mp, ap->blkno);
-	} else if (ap->eof && ap->offset == 0) {
+	} else if (ap->datatype & XFS_ALLOC_INITIAL_USER_DATA) {
 		/*
 		 * If it's an allocation to an empty file at offset 0, pick an
 		 * extent that will space things out in the rt area.
-- 
2.43.0

