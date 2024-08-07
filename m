Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102457A715;
	Wed,  7 Aug 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723041322; cv=none; b=Jjkrw+rCXiSwRGmPy/zL/EOivYOohT6dV1VwebEnTv9zF+g18/jU7iM5msSvbVVHDrynZ136XQndCMY5g4zwpXBcJyK84IHy0GSWP1n8Mz2tA86e5R95Pr05oEot1Ffw4pHGKAm1fQvUWX3/xLTWjFz6/two8SAibuGZYiEFPeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723041322; c=relaxed/simple;
	bh=FHJ6/xag9qvXxicDepVYIh6Aztt1te/ArJKTM93RIP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceVrRgwMym2lGlvI+Aqkir2jf/WFLLU7LXkfDwcqO4eAzm/A3d/zafHchLCZs21jG0Cgi0P7DSWUNcmm4TwFG2/KI7EVJ/XLZb2TNp6dMbIVypmHKE/njBPqgefrabd7oo6AQxr+RF973nuF8papX+oE2gEiZmKvAi4pVlyHtIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sUoiO4Zj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sUoiO4Zj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vb3Kfi3oTdqYo9QIBdZXhg9mMAE5ky+XFpkyvdybB1U=; b=sUoiO4ZjR8bee8LcFLnwXctRMe
	RN7je30rAWaOuvGuhg/pY6XMKeeOs59G5GhMcjBARTjCTjyMiD68KXIFECEHSQSEHnzsqWDkAbbLR
	kMsO/G81OBMnLS/H1FJ1iO1kqUn7Ncda4SyK3XpwxJt9C61sAgwpFOH6tG1HevvT8WaaxBmdHvDQz
	Urg/Ej/XGch3JKmcPlPlMUhgmUAqzi5CfrjOoeLXIrKgMkxY9ExEcy1nC1j24jrlWMQFwU+X+PXbX
	1hpcME1OsjujLGqsBN291sgIH2unR8EBUro6QmaAfZ2Gta0Si3oG1acOST3qFAeWPrnEEbyUwTmQu
	Mpb6Erhg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbhl2-00000005M0c-1UTD;
	Wed, 07 Aug 2024 14:35:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs/516: use _scratch_mkfs_xfs
Date: Wed,  7 Aug 2024 07:35:10 -0700
Message-ID: <20240807143519.2900711-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240807143519.2900711-1-hch@lst.de>
References: <20240807143519.2900711-1-hch@lst.de>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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

