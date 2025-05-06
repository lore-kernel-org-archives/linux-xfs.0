Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F802820A7
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746538698; cv=none; b=Ztn7/pYpMA2pn8Pn5x+z0rP3T3Npn7RGfxUTyg8dK8eMv1Zt0ZdyCQKIg/tEYuqdmFXCcaDkdsv/h25YF8yC6a3YxgMKQjRfSlyz66WDufglnZTD3I1BsQGtwvC/Bnu+Mn4MeqLkbLsyS66GhNiNSsVdB0unOcKH+YwQasDJoro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746538698; c=relaxed/simple;
	bh=P+531+meD4QWrD/kCd0hFX59vhMWNjOlgXaP/pEBe2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IsSVmuXxowfZScYJvL+SGLMVwaDQJI7jAQN+q4GPL0JO3zvCY28n57Qk5rGaJDanvn4flKDub1pK5mrMa9duLV7NOA+WzwbOOERvHUyLlTdmOZTPbOyiTz9rXPlxYNE8FWZiIPZ8CCXl8VVqgHgqlhHyZZBzrhGJl6nGzDlGZfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XLFRXvvH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XLFRXvvH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746538695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qgoQ+zuLZcQMdiNfCLJHX106n26WzcrD/PSBV7Gv7GA=;
	b=XLFRXvvHbzRsR58V6Ofd07O2IYWoOvnNxN0ZCe/5/5T1flOlW+bqOGhu1KqmJUL7sS0+1G
	ODfHAILDe9r/wi356P52EAg1GCk+Q3sxytAKQ2ReMbcWtdnq9Jo7CtcLZySNsE6onmKV0P
	loAqk4EKPFORKB2W22ppxXzmx94ZD/k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518--VQL8O4WNLye7YMMvufRSQ-1; Tue,
 06 May 2025 09:38:10 -0400
X-MC-Unique: -VQL8O4WNLye7YMMvufRSQ-1
X-Mimecast-MFC-AGG-ID: -VQL8O4WNLye7YMMvufRSQ_1746538689
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 407FD1801A1B;
	Tue,  6 May 2025 13:38:09 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.112])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2B42F19560A3;
	Tue,  6 May 2025 13:38:08 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v2 2/6] iomap: drop unnecessary pos param from iomap_write_[begin|end]
Date: Tue,  6 May 2025 09:41:14 -0400
Message-ID: <20250506134118.911396-3-bfoster@redhat.com>
In-Reply-To: <20250506134118.911396-1-bfoster@redhat.com>
References: <20250506134118.911396-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

iomap_write_begin() and iomap_write_end() both take the iter and
iter->pos as parameters. Drop the unnecessary pos parameter and
sample iter->pos within each function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a41c8ffc4996..d1a50300a5dc 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -774,11 +774,12 @@ static int iomap_write_begin_inline(const struct iomap_iter *iter,
 	return iomap_read_inline_data(iter, folio);
 }
 
-static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
-		size_t len, struct folio **foliop)
+static int iomap_write_begin(struct iomap_iter *iter, size_t len,
+		struct folio **foliop)
 {
 	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
+	loff_t pos = iter->pos;
 	struct folio *folio;
 	int status = 0;
 
@@ -883,10 +884,11 @@ static void iomap_write_end_inline(const struct iomap_iter *iter,
  * Returns true if all copied bytes have been written to the pagecache,
  * otherwise return false.
  */
-static bool iomap_write_end(struct iomap_iter *iter, loff_t pos, size_t len,
-		size_t copied, struct folio *folio)
+static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
+		struct folio *folio)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
+	loff_t pos = iter->pos;
 
 	if (srcmap->type == IOMAP_INLINE) {
 		iomap_write_end_inline(iter, folio, pos, copied);
@@ -949,7 +951,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 			break;
 		}
 
-		status = iomap_write_begin(iter, iter->pos, bytes, &folio);
+		status = iomap_write_begin(iter, bytes, &folio);
 		if (unlikely(status)) {
 			iomap_write_failed(iter->inode, iter->pos, bytes);
 			break;
@@ -966,7 +968,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 			flush_dcache_folio(folio);
 
 		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
-		written = iomap_write_end(iter, pos, bytes, copied, folio) ?
+		written = iomap_write_end(iter, bytes, copied, folio) ?
 			  copied : 0;
 
 		/*
@@ -1281,7 +1283,7 @@ static int iomap_unshare_iter(struct iomap_iter *iter)
 		bool ret;
 
 		bytes = min_t(u64, SIZE_MAX, bytes);
-		status = iomap_write_begin(iter, iter->pos, bytes, &folio);
+		status = iomap_write_begin(iter, bytes, &folio);
 		if (unlikely(status))
 			return status;
 		if (iomap->flags & IOMAP_F_STALE)
@@ -1292,7 +1294,7 @@ static int iomap_unshare_iter(struct iomap_iter *iter)
 		if (bytes > folio_size(folio) - offset)
 			bytes = folio_size(folio) - offset;
 
-		ret = iomap_write_end(iter, pos, bytes, bytes, folio);
+		ret = iomap_write_end(iter, bytes, bytes, folio);
 		__iomap_put_folio(iter, pos, bytes, folio);
 		if (WARN_ON_ONCE(!ret))
 			return -EIO;
@@ -1357,7 +1359,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		bool ret;
 
 		bytes = min_t(u64, SIZE_MAX, bytes);
-		status = iomap_write_begin(iter, iter->pos, bytes, &folio);
+		status = iomap_write_begin(iter, bytes, &folio);
 		if (status)
 			return status;
 		if (iter->iomap.flags & IOMAP_F_STALE)
@@ -1373,7 +1375,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		folio_zero_range(folio, offset, bytes);
 		folio_mark_accessed(folio);
 
-		ret = iomap_write_end(iter, pos, bytes, bytes, folio);
+		ret = iomap_write_end(iter, bytes, bytes, folio);
 		__iomap_put_folio(iter, pos, bytes, folio);
 		if (WARN_ON_ONCE(!ret))
 			return -EIO;
-- 
2.49.0

