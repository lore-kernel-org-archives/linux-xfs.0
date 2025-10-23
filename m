Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9318D296BB9
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761232639; cv=none; b=JiZGbSwz6cNwmzQzGmj69tVYaZgjmkemLVHJF4U6eA7PSAIGA7ekpWCHG3o+WTCizQWK7cl+e7MedwPjAdPzkDdZbR2FI9U5PkYVrhOkwmB/0VawG9icga1nIiFMx2m1Ja6peXYjwvoe3ZMXkAZRNvUA4SHXnSO79jUBFiXYZtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761232639; c=relaxed/simple;
	bh=R9XS9xZ14dh0y7FZded9npEkEOo0+DlOzal0OKYP/kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWxVnQqYo8fLOXO/p8X/yKIY0gq3UFmxipd9EFoSYH65ZD7nHQNw4zhMwIGLkbk2GCfyro/LZ7uEqwztLjIEb1xLo6lUlrn1a3pZYyW+dYKWk5jvhtreOtG2+aX08iWBZfsenVoEXLnzX6q5RfkaCmK/r2Flqw2vU+ndlrWdAzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qAV0K2hi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qAV0K2hi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QxEWMa0kzUE26cccXu796c6icgVOBzhSz86mEUeuP9k=; b=qAV0K2hivJUAxt5johQYWJTK4o
	N+gzlgwaeTd/PiymbRpgS02IPFBlJWvuTQZacJbYjCP4skEQdZCoeClOb6s5ncKeUvZq4E8ZwMEwG
	7oBnUjGn4kgSd6ROGZ1mVG7TQydIiOkrY19ss7ewwdqMvnFXQ7vyE+f3Iq0ZrkAYCy308ItKksjaF
	48HVxPGDlnPJvGjyYH06TZ+oJjwAxiFp+wLkYPKh2/3zZzLV+f1N1D/szudSupwzNrl9pY9Dtmq/z
	KAg4QwwmaWHP7bRKv6/Lsj3BVjVYrbgwuqN83ZmjBSD0p9E+Vw5ytkh7q6ZgRpHaocn98AVDyT8Kj
	cNe6J96A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBx41-00000006jVp-3loa;
	Thu, 23 Oct 2025 15:17:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/2] xfs: document another racy GC case in xfs_zoned_map_extent
Date: Thu, 23 Oct 2025 17:17:03 +0200
Message-ID: <20251023151706.136479-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023151706.136479-1-hch@lst.de>
References: <20251023151706.136479-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Besides blocks being invalidated, there is another case when the original
mapping could have changed between querying the rmap for GC and calling
xfs_zoned_map_extent.  Document it there as it took us quite some time
to figure out what is going on while developing the multiple-GC
protection fix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 27276519a4a7..336c9f184a75 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -246,6 +246,14 @@ xfs_zoned_map_extent(
 	 * If a data write raced with this GC write, keep the existing data in
 	 * the data fork, mark our newly written GC extent as reclaimable, then
 	 * move on to the next extent.
+	 *
+	 * Note that this can also happen when racing with operations that do
+	 * not actually invalidate the data, but just move it to a different
+	 * inode (XFS_IOC_EXCHANGE_RANGE), or to a different offset inside the
+	 * inode (FALLOC_FL_COLLAPSE_RANGE / FALLOC_FL_INSERT_RANGE).  If the
+	 * data was just moved around, GC fails to free the zone, but the zone
+	 * becomes a GC candidate again as soon as all previous GC I/O has
+	 * finished and these blocks will be moved out eventually.
 	 */
 	if (old_startblock != NULLFSBLOCK &&
 	    old_startblock != data.br_startblock)
-- 
2.47.3

