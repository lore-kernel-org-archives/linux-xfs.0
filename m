Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58C8265CB6
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039495; cv=none; b=lH2Ry4u7OUna7Cx1eL8KqUseWV3TKlUMqyTjAnVd6TI/qu49qf78vfKU56FVBqMNWQ0eGXg36Fkmi1eoBYqxMQS/0y7L0ZlnxtzMp0LtUrnhcApXUK05AsdJ+cg3jHr66cNDWulnlK66xtt2dUz/4JJq/mJcG9J3WYa6vCgQYo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039495; c=relaxed/simple;
	bh=Vn5+OagXl701xCm1pEnhNpWs5mZx4RseLqwWF+6/1hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gmtHl9ncp28RshrnAoYjRU0aPanLNQPWBQqZdvAaLkhYC3ZWo47d/LIV4MeChkfg/sn90QObfZNrf0iBzlj2nOhSH6+wQDuLVFEKNOByfiYwaEevxrse5Z1Wo1MO1eisTU8EchBvv9/SBP0ZpHLMbDoB3dNG+ibztHO4fMnGdxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bB3V4YTl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bB3V4YTl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746039492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=711zis8ZB/4bSfxJtWMZ4GXsx6bJLQxYwR9+fVBxfbQ=;
	b=bB3V4YTlbRXOoBeCa4I4ef3C2ow8M/wRHPW3bs6BcH3BI4NpI0X5TfW5izhZpiwwKgTLSQ
	LV+iSRdWqhen8W2O0TazR3dDFS4X/vn8iL0f3GXl/dSSGAM9HSE1/e3K5EHG1cdZKKKPRJ
	kZbEuSkBpd9u+YYwm/8M5w97K/+43RQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-180-3sqv93t6NjKk8ECi0EQELA-1; Wed,
 30 Apr 2025 14:58:02 -0400
X-MC-Unique: 3sqv93t6NjKk8ECi0EQELA-1
X-Mimecast-MFC-AGG-ID: 3sqv93t6NjKk8ECi0EQELA_1746039481
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FA9019560B6;
	Wed, 30 Apr 2025 18:58:01 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 010EB19560B1;
	Wed, 30 Apr 2025 18:58:00 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] iomap: drop unnecessary pos param from iomap_write_[begin|end]
Date: Wed, 30 Apr 2025 15:01:08 -0400
Message-ID: <20250430190112.690800-3-bfoster@redhat.com>
In-Reply-To: <20250430190112.690800-1-bfoster@redhat.com>
References: <20250430190112.690800-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

iomap_write_begin() and iomap_write_end() both take the iter and
iter->pos as parameters. Drop the unnecessary pos parameter and
sample iter->pos within each function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
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

