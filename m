Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE6A3C10AF;
	Wed, 19 Aug 2026 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787129354; cv=none; b=MZGufOlkAOer8vYGfW+dHaRvHmsEx62nDltpaEcFIMIpEWsAwSpAo8tD3MOQRrBbrEUMMqSpk53USGhj2GjenKAFcRAv2ddfW1HuzF0OdBVe9dXXvlQRnj9A0ipNVJwtyukWY4oC8vnbs0bhcQmLNpdCSQaF4Ybj0f8RDcYfvHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787129354; c=relaxed/simple;
	bh=r70Foggs4XarD0ZG9S9hcXi5kUwkBQB8OhSnmH/R/ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tjpLdnfglwXoAdgpdZVu+eyxOc/L+VX6LHz+BII93A9SnS3b3HgInJl46937EFBVsH4i6E+9Cn0JO3yc2znMPTWzOzxkzB8aVOX0+1YVcNKCtpNWCiOPEKzTFQYvQwSoZL4kbAJBHcf2nKamb85nHcmRdKnrBQkDUrgiXrvYsVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hQ0c329Gdz8v27;
	Wed, 19 Aug 2026 10:49:07 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: "Darrick J . Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com,
	linux-xfs@vger.kernel.org,
	pankaj.raghav@linux.dev,
	ojaswin@linux.ibm.com,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] iomap: remove the unused ifs parameter from ifs_find_dirty_range
Date: Wed, 19 Aug 2026 10:48:58 +0200
Message-ID: <20260819084858.778285-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit fed9c62d28b7 ("iomap: use find_next_bit() for dirty bitmap scanning")
removed the use of ifs in ifs_find_dirty_range(). Remove the unused
parameter.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/iomap/buffered-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..e11f1327bd98 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -143,8 +143,8 @@ static unsigned ifs_next_clean_block(struct folio *folio,
 			blks + start_blk) - blks;
 }
 
-static unsigned ifs_find_dirty_range(struct folio *folio,
-		struct iomap_folio_state *ifs, u64 *range_start, u64 range_end)
+static unsigned ifs_find_dirty_range(struct folio *folio, u64 *range_start,
+		u64 range_end)
 {
 	struct inode *inode = folio->mapping->host;
 	unsigned start_blk =
@@ -176,7 +176,7 @@ static unsigned iomap_find_dirty_range(struct folio *folio, u64 *range_start,
 		return 0;
 
 	if (ifs)
-		return ifs_find_dirty_range(folio, ifs, range_start, range_end);
+		return ifs_find_dirty_range(folio, range_start, range_end);
 	return range_end - *range_start;
 }
 

base-commit: 352cda83346d4c35113b056486d2358da6343737
-- 
2.51.2

