Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD964F1ED
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513543; cv=none; b=htZlrYch1fD0mdhr9QPbyAD1Ih9jGG7s1xEocAekhYeII+XT4on36I2y7jUT4WvjxCBll/1VGjXt6moAgNr9ySMC+iXuFk2iXpC1vzyRBMMRBJwBdJU01NLEGS3E4a5nshYdWQTyLVAd+FiX8DudbXMcuvTr8HliNUm1nCvdcUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513543; c=relaxed/simple;
	bh=pPwZWmIkIVqkqOPgkpo2tE6b5yZf6aNGMXEVAiP7XmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uMRC5WFnslYs3ywtzLLzloKlOiZjVE3c8P1A1Zbf+zmKQfj8vdGQxzUEn+zOKFWqmOIyIjQiRRdsMEh3FSP4qdyrDy8wx/+3pvbIcT/SkcJkWFwvzHhGP6jel2aHLC0K5tGwdn2a1okSdyarGfP9DGUhS/AV46uzzdjCtHQV1tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TEbfqstd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TEbfqstd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W+lZpVvfs5HaWhTjKKXVokDAK6pXHLSJ8r1rpuekodw=; b=TEbfqstdF6+CkFOi6RxvrIIHB3
	rgeesKraUqtghD8ZKfDNOQgU9i/JwJeL6wdHnlzlSPFpLH9e5XmalFEQU9/MRjogH1YTfZFpS3nGV
	+Uj+yyTnTjOt9OuyXFnmAXO5KVANt296qo1DTfBtWj3AQTh46lC8VPpL3cAgw3xKC3y/HGqqkVm2Y
	uVYLWWKHRf6V7ehww6D+yct8RTP/BmUzXOeOsf+CIBvk0GhloHhgbOhp0UOqLxWVZe+/axSAxFxm2
	7w2h87hPGUJrZo3o1s95BoXTvnouIIdqy2whzVJoBOlA3rLa0HQ+cstkEb1LUOe4w2ZkJirOxkU9q
	Fq6BhUhg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM7w-0000000BcZU-30Om;
	Mon, 29 Jan 2024 07:32:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/27] include: remove the filldir_t typedef
Date: Mon, 29 Jan 2024 08:31:49 +0100
Message-Id: <20240129073215.108519-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Neither struct filldir, nor filldir_t is used anywhere in xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 64e7efdbf..02b0e08b5 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -25,8 +25,6 @@
 #include <libgen.h>
 #include <urcu.h>
 
-typedef struct filldir		filldir_t;
-
 /* long and pointer must be either 32 bit or 64 bit */
 #undef SIZEOF_LONG
 #undef SIZEOF_CHAR_P
-- 
2.39.2

