Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D17821517F;
	Tue,  4 Feb 2025 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738676833; cv=none; b=hSzHv1DiKtPRgNzrEBiSSrkIlCaHgUExDcYpyWCh8S30A/E5RzGE1jylJHsPIFdW0L0iQzV/8+c9OFVF0FJvLel2faGVec/Eej0XzggaOzURSgHZTxq6JwFUuIJX9RVgSkdELtIhyxAWDU6B7pm0da0F5TQQFQc/XaGoTD3HB04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738676833; c=relaxed/simple;
	bh=6Naro2S2YtYNyi9jSZQxTHKviwXfveZD6BhjN6kleS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LPXvG1FDUOrrAdDbFVYO1aTLyIzPcy47zgcRrEl3hvRiGvYulmMqM1liH/K8Tf6uPaNsNDw7l8c+AzaRaWd4o2ktCltgHx5AXMzIwXpAxPr5/hG7Xpi0D+kQsBtYos2y7RkRg7AODJHNqmLM7z1ytBnKjOS5PFo+vj9JEqkgkKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VW0iAcOe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VW0iAcOe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=BJ9+BszIOx09MEga1tesbN83E+W6kAf+GSIza1SIthQ=; b=VW0iAcOeKmjlryZbA4n930tkdy
	SsL6Pbc+5XBG+0U8xJvQlmt0iPjwYBYapAG0a6KQNluOHyBSW9Vxv3HzrrYd8FTlMNhjnSWHz1BeK
	9X2LVxU1kCO2jfWh0a2CSHzhIiMSDVnteJqZAryX3C6+/HmPgYOyTOe613laVlGb7uCmrmZC07RvH
	itfLRUBKwSIKRFnldZ7AYeTZRkwyHH4kRY3NbC08gqVhIKehz5oDhaHnaz+N1/5J3XftoQA3FHnP2
	BPInOP/gCR5sUzF9+F3ng03Wd381xq1MRm/dWsaXBvk4ydv547iiee+mQoTq8fZS2hVffgCbRff6R
	k+Y/3Grg==;
Received: from 2a02-8389-2341-5b80-c653-ac45-db09-df54.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:c653:ac45:db09:df54] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfJGg-00000000ZcK-12ey;
	Tue, 04 Feb 2025 13:47:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org,
	djwong@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs/614: query correct direct I/O alignment
Date: Tue,  4 Feb 2025 14:46:54 +0100
Message-ID: <20250204134707.2018526-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When creating XFS file systems on files, mkfs will query the file system
for the minimum alignment, which can be larger than that of the
underlying device.  Do the same to link the right output file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/614 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/614 b/tests/xfs/614
index 0f8952e50b9a..06cc2384f38c 100755
--- a/tests/xfs/614
+++ b/tests/xfs/614
@@ -26,7 +26,7 @@ _require_loop
 $MKFS_XFS_PROG 2>&1 | grep -q concurrency || \
 	_notrun "mkfs does not support concurrency options"
 
-test_dev_lbasize=$(blockdev --getss $TEST_DEV)
+test_dev_lbasize=$($here/src/min_dio_alignment $TEST_DIR $TEST_DEV)
 seqfull=$0
 _link_out_file "lba${test_dev_lbasize}"
 
-- 
2.45.2

