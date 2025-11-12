Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B673246FE
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949737; cv=none; b=SGuk5UdxEwsd+sW/QIEiXlY7x4MdZ+RCFsIp9BUYoMB4utrCaYDfCB6haoon5+Gy4hsie2yt2j1pGD+rrSmJ8Zym0Ukj/BYvi8wVIDWfkFngeTNSrgmlJ51CALVvhZsgXqdRZT9s3Z9YX288y/9i9fJAXshh23VAZROl4HmyY0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949737; c=relaxed/simple;
	bh=WLSh8FGHJIlpDl8tKuIxFik51dYncbYxTyy91l7dywc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMRQUIVV2kX0r3B3auDzZcNjrQ2rgQ+KAGiHPKrk9IOPmLu+MWKV+qwN+pH3V4zEGCdJ5QFQe1hi+A0ypoiARyQ1Pal2ODkKG7HEBinVeTJpbFZvYIimsZMO8r60tZPvh4Nxb+DtNFuvIFPaZeq/y5vPuZR6mM56j1a0E51wVfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NkpDF/6x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NkpDF/6x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cQ87MnIwSHoyeLjufRMyzDIz4gw3ZnXUpRS3OWsyOTE=; b=NkpDF/6xArzSq7S6oRp5Ldoh6/
	RtRW5jQWuVHvzze1oSxsDa2SqAbUFPLK0ctXGpZzvA51Rm61aH891GwiBSYdF2+kb55Boagn4SWac
	iHYhVSC+a1M1PkhNmT6h6lkPPXNpGowJrFjBjibV19rsQi147UnDDBWUlNL8gKKt6WwPSMrPMr5fW
	m3Zb+yN8Z/1vSTl/JEghkmGuNLIuTGKYQrrcPypwzXmRbNjvIeZe0qNLI8HIlXEibL9O6f5SA8Cam
	V6el8EFJBeqpPFyGkFz0ohSyNWkl8brYBTyovRd41sZXTNkvVohZH9wVS3HJwXrvF+qf1A1m+6Jh1
	HzqNa5hQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9l8-00000008lEY-2NXn;
	Wed, 12 Nov 2025 12:15:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 09/10] xfs: improve the iclog space assert in xlog_write_iovec
Date: Wed, 12 Nov 2025 13:14:25 +0100
Message-ID: <20251112121458.915383-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112121458.915383-1-hch@lst.de>
References: <20251112121458.915383-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We need enough space for the length we copy into the iclog, not just
some space, so tighten up the check a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7c751665bc44..8b8fdef6414d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1889,7 +1889,7 @@ xlog_write_iovec(
 	void			*buf,
 	uint32_t		buf_len)
 {
-	ASSERT(xlog_write_space_left(data) > 0);
+	ASSERT(xlog_write_space_left(data) >= buf_len);
 	ASSERT(data->log_offset % sizeof(int32_t) == 0);
 	ASSERT(buf_len % sizeof(int32_t) == 0);
 
-- 
2.47.3

