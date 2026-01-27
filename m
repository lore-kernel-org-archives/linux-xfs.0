Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0A7361DCE
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526646; cv=none; b=YUkv+DhDtPr7aHWXOYU8BZpXewtGoG0VPNBaGfTwQAFLQwQoIdWsqd6ITGlS4jjd7Au6Cxqp3/IA/xWO3x4Z1Bqm2m2CZbsuRPLpFkjA7Ye6cqvMZAiO4014FG5RtekZgAlqnGJo2gm6Jw9kp6wpkNrbjN50iMY6npoA99aAXd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526646; c=relaxed/simple;
	bh=6OmF8yD+N/uacuZIa+0mRT6SSejQYnUFkC2hiRcYk8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPyt9jKlURvwYYeZccB768Ki0RUwNpbj7E5oG2PFdUTKF2m4/Uy/07e29ob1caAG/zqzqit4sVXnQWfkt1Rgtevy6nlnUsjlo6mXfwXctdHEjtgwELblV+ekkTbc4zx1N5nUOjvg+YontAxlSjXIxnV/+qm3p5wrRSjPRl5ivIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gJCUv4LG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gJCUv4LG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5E6WQqqvmcxu5gyniodyajdDl1YQROIbNchHQ2tp+64=; b=gJCUv4LGxp64sZs7AuL+b3EGSJ
	3MDbI9hK8rVn+4K3BnyNd1zNRwBe3F7Og9ddVB2iO3YiBVDUVMlbCF7OhMXtA/tJdwmaAhYSZ3ugM
	KPIvOIUa5ibFG5W9Vz+PJQSOqHLmLMgZpq/4GW9ISqxCA1sDVHZACJaAdiMM/+Fn5Fpd7ySHvRCT2
	lskJDRggsQQ46JcWbxeI0PDOxeZOrQ7ZKg1YXIpvIghn8/nEbfaYZKLld3UD5fAINGvK5kFGdwyN4
	o90ZfG41a+Ci0Vap2+uPDUBgq6zEWUNbQMmRJ0kAcY/QdHMEcquoigBVddJK358p/kZlCUY42Ub37
	NdW8ujiw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkkiJ-0000000EVYE-2iKK;
	Tue, 27 Jan 2026 15:10:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chris Mason <clm@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: remove xfs_zone_gc_space_available
Date: Tue, 27 Jan 2026 16:10:21 +0100
Message-ID: <20260127151026.299341-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127151026.299341-1-hch@lst.de>
References: <20260127151026.299341-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_zone_gc_space_available only has one caller left, so fold it into
that.  Reorder the checks so that the cheaper scratch_available check
is done first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 8c08e5519bff..7bdc5043cc1a 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -578,19 +578,6 @@ xfs_zone_gc_ensure_target(
 	return oz;
 }
 
-static bool
-xfs_zone_gc_space_available(
-	struct xfs_zone_gc_data	*data)
-{
-	struct xfs_open_zone	*oz;
-
-	oz = xfs_zone_gc_ensure_target(data->mp);
-	if (!oz)
-		return false;
-	return oz->oz_allocated < rtg_blocks(oz->oz_rtg) &&
-		data->scratch_available;
-}
-
 static void
 xfs_zone_gc_end_io(
 	struct bio		*bio)
@@ -989,9 +976,15 @@ static bool
 xfs_zone_gc_should_start_new_work(
 	struct xfs_zone_gc_data	*data)
 {
+	struct xfs_open_zone	*oz;
+
 	if (xfs_is_shutdown(data->mp))
 		return false;
-	if (!xfs_zone_gc_space_available(data))
+	if (!data->scratch_available)
+		return false;
+
+	oz = xfs_zone_gc_ensure_target(data->mp);
+	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
 		return false;
 
 	if (!data->iter.victim_rtg) {
-- 
2.47.3

