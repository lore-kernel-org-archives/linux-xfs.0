Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C785B1B7F4
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824327; cv=none; b=N40Z/KitAwRZGVmfLo7kGggBpHdWRgTjGQC4ARlhEGHdJoh3e9W13QuVej9cTeFuTMJzZY2SliP0u2yh430okRiv6yY6knNCZij6keojLgXzmmXcRdP986s1sXfEkMvrDhwlCFs1GnrfEk5Tm/gku89Qt3PQcVoQryNuIuPzmNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824327; c=relaxed/simple;
	bh=DKbmVL0+2WcORdoBnr/bPVAP7SA8SmbLWBhhITrJAYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyoJE2RnJn4gAZ4MVE+pvukKm5rBbsAZx7utviNElRv2ru5pLC3rOHLYxm8rUBGyYGI6J5V8LvcZeSfwrA1w0o7uIv5F1+IvcibioE/Tu4Ph6zT3LPJ969b1viBd1Zf5oIUp9Fu2X+L0sqnRXAIqNJGbd//WvVV6R6cV9MKE1S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oXPUPvhI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oXPUPvhI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0wz0pd+XTksdD2WU2NRAKVysbTapQV/+tfGeaasIQgE=; b=oXPUPvhI9UjqaqaCKeMHbAh9zm
	xT95593ZD1sXeK/TrHngoYFqqlOmzyHxdyRU91gnQBd096OmhZePus1HlU/4xYKSNy4QqavOWrx7o
	lLq2ILwHPtLxca8kkhTjVkw3ZpMJMO1zym7LUntW1Sd6pF43Kj8r4ZYOqmeTPlEE0uWEwRP/o6FdO
	+mOLYRj/ypMoc0bGGEPZKan7s2v+mqBD51OaBL9fqKnMu5B+cO0i+AE/5inUDfzbUTxxZ+jbArrk4
	N72funffzVaUK3+zVSzpdfSYsMlUHkhqMZUllJXEZOZROii6L9ADUSZHcDnbxqlAhEjv/sQyG7a+u
	DaB8oHlw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvdd-00000005Q6I-0rsj;
	Thu, 06 Feb 2025 06:45:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/43] xfs: refine the unaligned check for always COW inodes in xfs_file_dio_write
Date: Thu,  6 Feb 2025 07:44:21 +0100
Message-ID: <20250206064511.2323878-6-hch@lst.de>
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

For always COW inodes we also must check the alignment of each individual
iovec segment, as they could end up with different I/Os due to the way
bio_iov_iter_get_pages works, and we'd then overwrite an already written
block.  The existing always_cow sysctl based code doesn't catch this
because nothing enforces that blocks aren't rewritten, but for zoned XFS
on sequential write required zones this is a hard error.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 785f6bbf1406..d88a771d4c23 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -721,7 +721,16 @@ xfs_file_dio_write(
 	/* direct I/O must be aligned to device logical sector size */
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
 		return -EINVAL;
-	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
+
+	/*
+	 * For always COW inodes we also must check the alignment of each
+	 * individual iovec segment, as they could end up with different
+	 * I/Os due to the way bio_iov_iter_get_pages works, and we'd
+	 * then overwrite an already written block.
+	 */
+	if (((iocb->ki_pos | count) & ip->i_mount->m_blockmask) ||
+	    (xfs_is_always_cow_inode(ip) &&
+	     (iov_iter_alignment(from) & ip->i_mount->m_blockmask)))
 		return xfs_file_dio_write_unaligned(ip, iocb, from);
 	return xfs_file_dio_write_aligned(ip, iocb, from);
 }
-- 
2.45.2

