Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F60495CB;
	Thu, 18 Apr 2024 07:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713426055; cv=none; b=Mv8TwW8Eo7Sli6pvS5KZuy6i5dVhEg79wljwk7CSFVZ1uT/Zcdd20S1KmURYMvfZYjK3ZoEXgHFN2P63s+J5KjuCPc/3pWu6N9LYcE8tYY1AQNyL0nlKb0Q0ARtV7STBMG/w3fB6fq7+Gx+8K2iudJFLc05eMWi9cW7iX29Th/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713426055; c=relaxed/simple;
	bh=TGN0DrSoZl4ripjEu+74ZmK0aG9PdreQZuvcUjmjGDo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZUvaR9s1pTClwZa3PSRNDtbZJHi7b+GIqj9rl5e7NibMO5LI1p20Xn5e+/xuYFglMCbNv2sLZocSn+8UwNd3mcB+KsmYqwjntv3LQOZSJI2HHpCYZcZVvOLHOI4lIbh1nxT4ppVVC+9cPiA6nRq8O9jtTkZUkW/Vd/26i6kcrhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V2D3n46N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V2D3n46N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=geOoiK/oqKnqOm807Tvmg/i8RfhT7Jye7XVuyWVilGE=; b=V2D3n46NQfoXtd/yLQAIPQ+w1b
	Zwtmz1ymZ2kk7IcwsrON3OjQKlbohcQWo/E+aeiRa2mOW0+N5T+3oLdJj3RYVa6buplhQP7w0pDoe
	LOxni5j/AByOtuiGWX9ApDdQfa+7VqKeNE+IYQ5XZb9lD21cU1F69qBOMkz22NTx9DgHlu2+/WUk8
	fczNer/S57fmKPLynnYDByEKSiXzvw4c1ZwVP39VeBihVDBBtU79Bq7DmyS3XjhWnOBCnDA0mctzs
	pdMVCsR7csbJ4/ULRSx6PGQyazVL8+CPNZ1oCFKW3o2M0Orb9/BqqQtW04X18M2zWloODcRYaS7j8
	fptFYqaQ==;
Received: from 3.95.143.157.bbcs.as8758.net ([157.143.95.3] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxMO4-00000001Iiv-3UXH;
	Thu, 18 Apr 2024 07:40:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 1/5] xfs/045: don't force v4 file systems
Date: Thu, 18 Apr 2024 09:40:42 +0200
Message-Id: <20240418074046.2326450-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240418074046.2326450-1-hch@lst.de>
References: <20240418074046.2326450-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_db can change UUIDs on v5 filesystems now, so we don't need the
-mcrc=0 in this test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/045 | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tests/xfs/045 b/tests/xfs/045
index d8cc9ac29..a596635ec 100755
--- a/tests/xfs/045
+++ b/tests/xfs/045
@@ -26,10 +26,8 @@ _require_scratch_nocheck
 echo "*** get uuid"
 uuid=`_get_existing_uuid`
 
-# We can only change the UUID on a v4 filesystem. Revist this when/if UUIDs
-# canbe changed on v5 filesystems.
 echo "*** mkfs"
-if ! _scratch_mkfs_xfs -m crc=0 >$tmp.out 2>&1
+if ! _scratch_mkfs_xfs >$tmp.out 2>&1
 then
     cat $tmp.out
     echo "!!! failed to mkfs on $SCRATCH_DEV"
-- 
2.39.2

