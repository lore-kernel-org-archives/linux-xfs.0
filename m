Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BB734B669;
	Tue,  4 Aug 2026 12:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847475; cv=none; b=Uppbp3XFwU+0N84R+wuFlSQ/bBCvmJZDR0GwghGTAzJtNzMvNtdwJR7WK5cJJcK+QmCJzJTUti+b/br4Jp/xJAXljPfUljlAQHLBirg1+N867xOJJcZ9kPphvNbWnnbFN8djRI6SjA0QnWA0BIxwBe9SGz1qM8jtEAVdB8e+Qc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847475; c=relaxed/simple;
	bh=A/Y2A7jceVvUSyGZq9J4Wg4Frp0rYlrD99DKK86qstg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0SiWSahskVbl1PDtrO+RVn+ZNUxrO4g1BGm0ZMat4P3j4ioAWhW5O+qgKOhrey4O1kGsnG5Sd13LjAqkkHULSg/sSfPXXWeA0IrFF/6dX0L23uq3ON+Ibu6dn+blisKjuIhLj74s0FCeZggFrU8Yj5ort/xDbMbdWKpmkklo6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u76nuvLS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u76nuvLS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hnFOIp+6jvboBDxPvHjWBgbUGmcdALyTf4EzwQnS42Q=; b=u76nuvLSFL00hs2y7vahxLq+FP
	7pYA0MhibCbeg1Cn2bJgdUr8rruqbyUsrVcEZRJhmsWZI4UY5+lUq3xFj+seeb+QtsIQ/3wD/6hIR
	tvOQoAJluxehwgQQdPyI6zbN4HXNlWVX+rBWlbgrYljn+U45Tqu8RTRaxlJDF6ZC02jV2R/YgkKVo
	AKzoUIt6UTSIS4hdqakmEUqXJJQvey8PTKqBWgXc5MLE+rmtk/ISeopYtLG06PmRfpu4i9p7v/Ryv
	Fl5MC0sp4IQWNA6BiF+Q/gReEicVn8OS7F+sglRMLp1S3j4IPoTB9hF74oSuGdspG2Yyor4hHrtoE
	SPupSgrQ==;
Received: from [93.123.20.94] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEVU-00000001qUG-2aWV;
	Tue, 04 Aug 2026 12:44:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] iomap: don't free integrity payload that doesn't exist
Date: Tue,  4 Aug 2026 05:43:57 -0700
Message-ID: <20260804124404.737145-2-hch@lst.de>
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

fs_bio_integrity_alloc might not allocate a bio integrity payload if PI
verification is disabled on the block device.  Check for that case before
calling fs_bio_integrity_free in iomap_bio_read_folio_range_sync to
avoid a NULL pointer dereferences.

Make the branch cover the PI verification as well - while
fs_bio_integrity_verify works without an integrity payload, it requires
one to actually do useful work.

Fixes: 0b10a370529c ("iomap: support T10 protection information")
Cc: <stable@vger.kernel.org> # v7.1
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index dc8ac7e370a5..30ef78a66b4f 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -179,7 +179,7 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 	if (srcmap->flags & IOMAP_F_INTEGRITY)
 		fs_bio_integrity_alloc(&bio);
 	error = submit_bio_wait(&bio);
-	if (srcmap->flags & IOMAP_F_INTEGRITY) {
+	if (bio_integrity(&bio)) {
 		if (!error)
 			error = fs_bio_integrity_verify(&bio, sector, len);
 		fs_bio_integrity_free(&bio);
-- 
2.53.0

