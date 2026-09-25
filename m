Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8997D4052C4
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313242; cv=none; b=AbYU2Tj7QmpNdv7Mh1W82Bbki2xzpLMN5Am7AMZPjEYvKES3qlBjSuQnHWU1YDvGhTfEjv0LSQLVBHxitCCFTMCgzpy4JnW3l8oxPayqms6JQPILB7KZbIMikmMoDI51YQBTiGu0zok4jTBh3VOYcOvks0TuGBqCtVJqM9q+5I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313242; c=relaxed/simple;
	bh=6ww4NEp5aJQrA80/fMz9IfCp3lviP7Dt5Ik4pO5k6RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1QsH+bbins8gMfVz1py7SjBniBJZuycu27CZwSoWDj3aLH5GTlKuWwc8hyozW89XyWk3h94hYfICjtCp6jH0iYEyGt5RdZXkyjhuXtS8f85r7DKA2SxHyfsINkadOkcyadAnKQPAJc5PkSzjhqi6BDSL24STTyMFDQHVKxrbAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FWvcYkgr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FWvcYkgr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+t5jraK4h9qXWzfNVKUQ+XHmO10ipydQ9UzgYhGwr6w=; b=FWvcYkgrmuDObmAP2XPTO8610p
	zpEiF3imoD871MAg9nF0C4hYGO/PCaJFdtmMZqjTnhqCtcHwMBCcygqEsRsa19x0l6GxCrUzVKHD5
	/VXQbCgmXXWS/LrLVxnTPj2gDBkm581F3SRAzqGvhND8OtesBTG4394wvHpqT2kzw84rXC4r9vu+o
	5//h90L+CNrqkjVwqjI0B8ffMJ7Yje2FBp4P7GYFUbSjkV1dqp3RLrJekhiqRK2ndZA2fpMIyln5e
	oYCYLUUVt5up81sfmSt8czpiSkvii/24bi3VoN7FqbmvD9/jWBA3835DL6DbIApM6TOeINLxoBq00
	fHmZFNEg==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yFw-0000000Cgc9-3gn2;
	Fri, 25 Sep 2026 05:13:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] libxfs: don't clear ->dev in libxfs_device_close
Date: Fri, 25 Sep 2026 07:12:52 +0200
Message-ID: <20260925051336.2997014-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

struct libxfs_init can't be reused for multiple mounts, so there is no
point in clearing it.  And clearing it defeats the duplicate device
check in libxfs_close_devices, which would lead to flushing a closed
device if this wasn't current masked by another bug.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 85e0b3402bb2..842a2e1e09a9 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -182,7 +182,6 @@ libxfs_device_close(
 	close(dev->fd);
 
 	dev->fd = -1;
-	dev->dev = 0;
 }
 
 /*
-- 
2.53.0

