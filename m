Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523F8768EA;
	Fri, 24 Jul 2026 05:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784869826; cv=none; b=s+1M8Jzn5WKou/EuC6fZnD/lgxvoyYdvGrnlYa7ys1p+1aX4fvuPJYRDuegsEy/jeChtWgn1bAL9PNFVuZ6lxCilwin6MvM8lKZvn/yWzLXOrhCbozfdf8avRAkQ+o+sfyTcOTj9ePWL03LDRrO2d7qzOhm2LfbKBZA3XhemA5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784869826; c=relaxed/simple;
	bh=33kgPLnlLpWZWIytrg7RrBcpWcajaZj9xf+D4kSjiT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKu0ygXJWz6ExsgZ7Zdnkce/X1tN8DF7E/ogKsZAsiaELSu8ifw54Nwkg2RAKd+9TI/VC4SJoJdsK1HWw0ikc0nGra+kgd8brHbNhmQOaRu2xoittva6o7Im9yYGwji1CYNfLH5JhfM9dRks1laxfUfYJvxuBmZeQM0pR7Ef0zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SsC6zCco; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SsC6zCco"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O4OsN0seD9T5iTqsBPH3/qpARDGsEj3WTvEDcEhFWqs=; b=SsC6zCcoS92H3xmINHYXZUhVaN
	IjYLdCEMun7H5EuFsbJui0up8WirmneWFHgRGHIaVRWHCibaClGnMcKGC7VIFeIFs9IPvI41U/jjN
	bHMuu7BIgL9UoMpVIu8lpyficjstwTQh0Sft9cIjGPLyP86ZxePZ/0EyZv5oDbm6iRhearYyTvICR
	BHjPZKcQnBWGSaaq8NmQu6L1PTRWGJLM6VZJKWZA3/WrUduQkIWdIQ8ovxtAwJmvPxQJ6V7LODc8K
	ioENbOTfc0eSMAy7evbH8s2GkB3wGgKlyYlNIq6yRTQMw0pIvdahHKKShCEFs1VXx9eMnA+XZNJpf
	6Sptwtbw==;
Received: from [2001:4bb8:2d1:bd34:bc05:3da8:f7ec:c468] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wn8Aq-0000000FUMg-2Sqm;
	Fri, 24 Jul 2026 05:10:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4] block: lift BIP_CHECK_FLAGS to include/linux/bio-integrity.h
Date: Fri, 24 Jul 2026 07:09:42 +0200
Message-ID: <20260724051001.202741-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724051001.202741-1-hch@lst.de>
References: <20260724051001.202741-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To allow for users outside of bio-integrity-auto.c.  Also add a little
comment explaining it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity-auto.c    | 2 --
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index 43ac9f338183..9456dcffd17a 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -44,8 +44,6 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 	bio_endio(bio);
 }
 
-#define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
-
 /**
  * __bio_integrity_endio - Integrity I/O completion function
  * @bio:	Protected bio
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index c3dda32fd803..0ea2a8bf7efb 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -17,6 +17,9 @@ enum bip_flags {
 	BIP_MEMPOOL		= 1 << 15, /* buffer backed by mempool */
 };
 
+/* flags that require generate/verify action. */
+#define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
+
 struct bio_integrity_payload {
 	struct bvec_iter	bip_iter;
 
-- 
2.53.0

