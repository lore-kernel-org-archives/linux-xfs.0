Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFC32F5E;
	Tue, 23 Jul 2024 00:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721692848; cv=none; b=K2kWBaMwGh2EJeXFla/CAkNZFAKJbQrhNsFRFxHbSqnrhh0q9y4on9huaoF98ebMstOw91EILGdqet+xl48g950VZg8KuTIwQRn7KWnS4OvRB+RFmfCnpBB3KcrBlbeqYInWS+rq4BaIvFITiVBdh8v+6Qe+pZ8aSzE2WRLvQG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721692848; c=relaxed/simple;
	bh=CgPjykVemZ/5skHMKNcua/H1ONOlYFTk99alXXnFkMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8UvI4wPSL5FiCedwq0U6RisnbSKAyAUwamLaZLHisWYvvXvwFYFzT70LsnQJ+SRpDW233XRNoLrCjhh7jXgyOdcMcwvT+QyXcWyXi1Q5TBofr55AoU//em0EBMD2hz+7LkfyNACuyHULmuv+X+5KoWvn6vcaKX5cX5163Ay+AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1GMvS9tO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1GMvS9tO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nUUOIzjvV4cpdMPwuKFToo02eWAKgxtg3olcW5f500M=; b=1GMvS9tO7jxIqyH2Y3Hn9v9C5J
	fgZ95eu5alfrm7kkSdUzABPgDAJhLMvEXQ/fR2lwSe6aUzoedXK5/VQYhfmmt3HmL3uw3SB/E7/iE
	UW3gYznxfcCedpm3iezOO0ITiv2r4ZYSFrvLK/P++V6WF14wmr6UHUZoP2OgKoo92GJZHU/WX8GI6
	asJ+jQdlhMbifp+iBU8EW8NwtFO4NmjMgpth1ntq94XOofIlxKlOYs5KEPrCQcR6MVQ1sXDzB0bSk
	GQHMPqQpdvjEK7IYhimU8T1In/ji8Acx/NKpXrtfEGW3Ims0FWaqEH469e++Rte3vBNkG/Ll0IOrM
	cJx/8n4Q==;
Received: from [64.141.80.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sW2xR-0000000Aumy-3l8x;
	Tue, 23 Jul 2024 00:00:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs/516: use _scratch_mkfs_xfs
Date: Mon, 22 Jul 2024 17:00:35 -0700
Message-ID: <20240723000042.240981-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240723000042.240981-1-hch@lst.de>
References: <20240723000042.240981-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use _scratch_mkfs_xfs instead of _scratch_mkfs to get _notrun handling
for unsupported option combinations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/516 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/516 b/tests/xfs/516
index e52779cf3..882ba48e8 100755
--- a/tests/xfs/516
+++ b/tests/xfs/516
@@ -72,7 +72,7 @@ __test_mount_opts()
 test_sunit_opts()
 {
 	echo "Format with 4k stripe unit; 1x stripe width" >> $seqres.full
-	_scratch_mkfs -b size=4k -d sunit=8,swidth=8 >> $seqres.full 2>&1
+	_scratch_mkfs_xfs -b size=4k -d sunit=8,swidth=8 >> $seqres.full 2>&1
 
 	__test_mount_opts "$@"
 }
@@ -82,7 +82,7 @@ test_su_opts()
 	local mounted=0
 
 	echo "Format with 256k stripe unit; 4x stripe width" >> $seqres.full
-	_scratch_mkfs -b size=1k -d su=256k,sw=4 >> $seqres.full 2>&1
+	_scratch_mkfs_xfs -b size=1k -d su=256k,sw=4 >> $seqres.full 2>&1
 
 	__test_mount_opts "$@"
 }
@@ -92,7 +92,7 @@ test_repair_detection()
 	local mounted=0
 
 	echo "Format with 256k stripe unit; 4x stripe width" >> $seqres.full
-	_scratch_mkfs -b size=1k -d su=256k,sw=4 >> $seqres.full 2>&1
+	_scratch_mkfs_xfs -b size=1k -d su=256k,sw=4 >> $seqres.full 2>&1
 
 	# Try to mount the fs with our test options.
 	_try_scratch_mount >> $seqres.full 2>&1 && mounted=1
-- 
2.43.0

