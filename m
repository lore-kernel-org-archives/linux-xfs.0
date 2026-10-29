Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793270134;
	b=BsFhjiz9MUEdZn5t4Q1aEeejrnTP7FTAVponVTc21B+m0ZzavAqu8heLABlUaYESLM1J
	 bA1tQyvQo6GNgr7Vth6bUS+KnGOKeUnEU2Egen1Mse1QuHn3rkXZJRoxCHU8O1wk+gWda
	 2D2shRXl7E/pW4e3yd6jXgdAeWlYbUL+cgCAZBZXrnOjjcsWwLUuVAZ+gONWyndXh3HwT
	 0DU80AFrnnEjaVA3yz2QKwJPJQE14xIg/KjQtxM3fgxYawyVyOANkRLsc3XbajmuviVYp
	 LtrO/3VFk2G/D3bjSX+1j0m83gbWRJZq7A7GElcUWJB69CRr88ewye36pLEoJULyIdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793270134;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=b3Kti2LlxnfIoBZn8WoK17y+yZXQJx8Soi6jDabDiEM=;
	b=f8PO4ecxupiSK9QrtoNEtObo6hkv39p29V3ZLyK9O4mIzvJlrQ4h5i67DK1CZs7pWd78
	 /x0zcoSaOwiy4AHFRt7ZQA3TyPI882QMOlWtv/aGoAJNGf/HiR18D2g+MAFER43xFbyan
	 k/Muu91BSr/8+Fcv8Nua9GuhYB8xLepE8dH4p4GEd+jLGAtuH9NBDdYHXQViYVlHzp88J
	 3hL8s1fxkE2f6tVEYnsQLdLJUyKaJ8GX1yGPH5Kkli/QGZNnFipyigMYCXNL5E22CvEIz
	 ZqyC+y9tu7CXIATugIYwRG/0yZgc1OexmUxLG8og8Z0zKLZXukweFif+9OtiyuXtDzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y5SUBSBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74891606A322;
	Thu, 29 Oct 2026 10:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y5SUBSBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2E31F031E1;
	Thu, 29 Oct 2026 10:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270134;
	bh=b3Kti2LlxnfIoBZn8WoK17y+yZXQJx8Soi6jDabDiEM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y5SUBSBjOT6snwksRsGSuj7hD4IpS3CHy64VEKvK1mqv1BZsM6+768MFdpcaShyLn
	 q7fktDYc+CEwBu5rbZWjT7KXkgVuMEOCUfVf502gTV0oMwlXwMP62useyWmuyilzfA
	 o/1Jalmt4wrywbIF0HgghFtdRy4wLhGy8trqu3uL2zmsvfDe7PYayjAgu2QbdwjTTA
	 47fTTed2Ty/O49m9xTIIbQaZ2yQyNJEc8+mBveFFHLUOMjAJAIdez0CmXZ0H9Y6Y9J
	 9Dr5cqqd8rvlBzHLhy0rYC8L2mvFUXP4tkPAqtOMcKZsoUp6/cRyX7y3oR78arLhi0
	 mBwExOzMA9hGw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 11:34:49 +0100
Subject: [PATCH 2/2] iomap: keep large chunks from defeating the bio cap
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-iomap-ai-fixes-v1-2-7eda63bc1b13@kernel.org>
References: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org>
In-Reply-To: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <clm@meta.com>, 
 Josef Bacik <josef@toxicpanda.com>, Matthew Wilcox <willy@infradead.org>, 
 Zhang Yi <yi.zhang@huaweicloud.com>, Joanne Koong <joannelkoong@gmail.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3193; i=brauner@kernel.org;
 h=from:subject:message-id; bh=1VbTvRVd2LJOzWvVDZo9+eo0SqVgtLUN2sxxcnpOCr8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9Vsx6ZZtn6xY284oCC8PUH6vW3Ur9P3/Ki+I070U51
 3+Ky0Uc6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiItwvDH36WnVenLZHoWhPh
 9C976Qp+VTf+HebfBXrMb++PW56+9hojw//mhPpn2xUtlUWdTFRTToo33lN6IW+6OSW5Xn2SzYK
 rfAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

From: Josef Bacik <josef@toxicpanda.com>

For integrity I/O a bio must not grow beyond max_integrity_io_size()
because the integrity buffer is a single allocation of at most 2 MiB.
Writeback and buffered reads check that before adding to a bio:

        bio->bi_iter.bi_size > iomap_max_bio_size(iomap) - len

The subtraction is done in size_t and wraps if len alone is above the
limit. The check then never fires and the bio grows until it runs out
of bio_vecs.

That's easy to hit. The limit is also capped by the maximum segment size
which is 64 KiB for SCSI hosts that don't set it, such as lpfc and
qla2xxx, and XFS uses folios of up to 2 MiB. Writeback of a preallocated
300 MiB file then builds a single bio that needs 4.7 MiB of PI with 512
byte sectors and 8 byte tuples. That's more than kmalloc() can do, so
bio_integrity_alloc_buf() falls back to a 2 MiB mempool element and
generating the PI writes 2.7 MiB past its end.

Check the length on its own first. A chunk above the limit still gets a
bio of its own which is never larger than a folio.

Fixes: 0b10a370529c ("iomap: support T10 protection information")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/iomap/bio.c      | 2 +-
 fs/iomap/internal.h | 9 +++++++++
 fs/iomap/ioend.c    | 3 +--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 153b779949e9..256564ebe238 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -109,7 +109,7 @@ int iomap_bio_read_folio_range(const struct iomap_iter *iter,
 
 	if (!bio ||
 	    bio_end_sector(bio) != iomap_sector(&iter->iomap, iter->pos) ||
-	    bio->bi_iter.bi_size > iomap_max_bio_size(&iter->iomap) - plen ||
+	    !iomap_bio_has_room(&iter->iomap, bio, plen) ||
 	    !bio_add_folio(bio, folio, plen, offset_in_folio(folio, iter->pos)))
 		iomap_read_alloc_bio(iter, ctx, plen);
 	return 0;
diff --git a/fs/iomap/internal.h b/fs/iomap/internal.h
index 74e898b196dc..e69b3ac02cc2 100644
--- a/fs/iomap/internal.h
+++ b/fs/iomap/internal.h
@@ -17,6 +17,15 @@ static inline size_t iomap_max_bio_size(const struct iomap *iomap)
 	return BIO_MAX_SIZE;
 }
 
+/* Can @len more bytes go into @bio? */
+static inline bool iomap_bio_has_room(const struct iomap *iomap,
+		const struct bio *bio, size_t len)
+{
+	size_t max_size = iomap_max_bio_size(iomap);
+
+	return len <= max_size && bio->bi_iter.bi_size <= max_size - len;
+}
+
 u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend);
 u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend);
 
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 92b89fbf95b9..4da248ff99f8 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -133,8 +133,7 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
 {
 	struct iomap_ioend *ioend = wpc->wb_ctx;
 
-	if (ioend->io_bio.bi_iter.bi_size >
-	    iomap_max_bio_size(&wpc->iomap) - map_len)
+	if (!iomap_bio_has_room(&wpc->iomap, &ioend->io_bio, map_len))
 		return false;
 	if (ioend_flags & IOMAP_IOEND_BOUNDARY)
 		return false;

-- 
2.53.0

