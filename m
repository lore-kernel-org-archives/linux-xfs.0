Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530A2345CCD;
	Fri, 24 Jul 2026 05:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784869825; cv=none; b=uf7usU8EhDdHJyMwBNI1J0XzGrpn7YqjZs5WloJ132BgdKvKS0cu7QeVT/pvkqgrsSoUJ19Agma93ly8VMmUJ33Ww2YVbJV+if8cxEFPve9amXCa1gWO4Kp/QbfBYNinj7Uja9ekQGm1E0pGPY5Ofrn0sFVbkc4wrHQj5o/9iyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784869825; c=relaxed/simple;
	bh=VmZkEaj2XCcWJRRWm0HVeheKpWJGUWw9RYOIa+XrMVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONLvyDrIU9MxvcFlaZM6JBXNxhl6qxt840tQiNpoTC8YiYFRokjJ/cyzt1OVbX0UzbsJpSGm49kb+5t+OC+KdS1uHGtGny4bO1b3yhAbqOo71eZ/OZFEh99PjeA9v2mfT0MYR7VAYoCDpJVv+uT5TnU7EMFcwKbyq/3u7sBcDh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S9Or5Uqx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S9Or5Uqx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cE0D6K57Y9/NjH36eSx6hJk/9geEDDEqSIhjpxq77zI=; b=S9Or5Uqx44fbGrT4aHVP0LFhZ3
	9i/lTM5NiiieukOISbnXrBAvxBq9m00aN1L+U5aHVJKz3YNii66R3+ZtWqRJBHSEELCnFDLKYFvPQ
	5O5plcCbGMgBAPZrT+Hrt2OzeD9LcMcvKtHkaOTdRjOqOhSMw3CuARZIrkTeuea4Svx0QsgoQjRLD
	OEJfBr6/h1eBcjPGcVXyHFuKpEq0eajk/4X0TMMAjBrLYZIme+6uxcdklLvdzab1rXppI3XRg4CZv
	UP4PFf/vc7jiHcKHIYoTbsMaXrlr3+vu+4zo08QOnmE4I0LnQmxKx+6S3uV//w83iO/w+bSCNh6VU
	Uc3/1hVA==;
Received: from [2001:4bb8:2d1:bd34:bc05:3da8:f7ec:c468] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wn8Av-0000000FUMn-0pVM;
	Fri, 24 Jul 2026 05:10:21 +0000
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
Subject: [PATCH 3/4] block: handle nogenerate/noverify properly in fs-integrity
Date: Fri, 24 Jul 2026 07:09:43 +0200
Message-ID: <20260724051001.202741-4-hch@lst.de>
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

Check the BIP_CHECK flags before generating or verifying PI information,
otherwise this can be incorrectly called for non-PI metadata and
cause generation of incorrect metadata and crashed in the verification
handler.

The new behavior matches that of the block layer auto-generated
metadata.

Fixes: 0bde8a12b554 ("block: add fs_bio_integrity helpers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity-fs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 9c5fe5fa8f0d..692403dfa047 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -46,7 +46,8 @@ void fs_bio_integrity_free(struct bio *bio)
 
 void fs_bio_integrity_generate(struct bio *bio)
 {
-	if (fs_bio_integrity_alloc(bio))
+	if (fs_bio_integrity_alloc(bio) &&
+	    (bio_integrity(bio)->bip_flags & BIP_CHECK_FLAGS))
 		bio_integrity_generate(bio);
 }
 EXPORT_SYMBOL_GPL(fs_bio_integrity_generate);
@@ -60,6 +61,9 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 		.bi_size	= size,
 	};
 
+	if (!bip || !(bip->bip_flags & BIP_CHECK_FLAGS))
+		return 0;
+
 	/*
 	 * Reinitialize bip->bip_iter.
 	 *
-- 
2.53.0

