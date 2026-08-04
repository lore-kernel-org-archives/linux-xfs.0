Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365603C1977;
	Tue,  4 Aug 2026 12:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847483; cv=none; b=CdLp2a64um6GrOVUJUH7gR2mAZO0g9H8uCN3qHONjwvVNniE8XSiIpqaPesmRHrvt7+KILYEEpxueCbaIrfzc8zcREk7kV/M2HP1Jai8jclzbyE0DbprPWBAJX7KOe6UpPR8EB6QsvBoVxXgYT7vVa0Ae0TL1AiZRRKOaCgKxRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847483; c=relaxed/simple;
	bh=t8/0/wmEQZr2c2cAjz/418DhbZ4RJzFYFTIA287RK2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZaDSwfSAFBJhCjlqVGK8lFgK5y6Vg+Mb76zngVPDl43iiBdDBRgCHVYMAGvlxOvrh1hNrQr/84Jttc6dZ/tM21GBqV2stORfGb1DChbbOBOaK7veP7oBIgoMDJJx3OxgCi7MWa7/glTLU3uWSXgTkcXW6chKwn+N9tZ4RcnCXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QLeKBRvd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QLeKBRvd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GExJ64QZe3NvrWdp+LaaimPdCn+8rnLHmfAV+g6wxSk=; b=QLeKBRvdFqlkrmoFwYVGy+1u78
	QPIIhG8Ag+yyxmo2Di4b8djlKKgS7nrbzLbtWUmy5uuJxqpT2TyPbkE6ZR32Kaqj3DxrKIYIub5rH
	X3tx4BfnNUmcOwPvvTj1KsotKb6qWcgZfUn8GscCztpZAs0yWofpwvpZ//Lmk2qBp9/tlHsaeXJAE
	H5I2I5NW3dqKp0co9zvAEEt4YvYSAtCvFzRftIX02+sOgQFxMJGAeQ2defqfyYSfbiz/2L/x4IvM7
	0xMuOU5gG92Yd+TdpzVzQQVDz7MXbQiaLcXcQf4JRFtvIdD2V5sZnwhwnO213hzuZPXZtw/9mHslm
	SncluAfA==;
Received: from [93.123.20.94] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEVc-00000001qXU-2e8t;
	Tue, 04 Aug 2026 12:44:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] iomap: iomap_bio_read_folio_range_sync is missing a call to bio_uninit
Date: Tue,  4 Aug 2026 05:43:58 -0700
Message-ID: <20260804124404.737145-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260804124404.737145-1-hch@lst.de>
References: <20260804124404.737145-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Which could leak blkg references.

Fixes: c03cea42149d ("iomap: add initial support for writes without buffer heads")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 30ef78a66b4f..48100c614431 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -184,5 +184,6 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 			error = fs_bio_integrity_verify(&bio, sector, len);
 		fs_bio_integrity_free(&bio);
 	}
+	bio_uninit(&bio);
 	return error;
 }
-- 
2.53.0

