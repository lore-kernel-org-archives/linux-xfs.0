Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129E720AF89
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739368492; cv=none; b=ojf/vp/uTZHjhYY/JrsAfENLx67Jk9io9f1CPNJJ/OaJWQqWeSiEUz61yw/Hg1ZI0QTbOamYBL+950hbWqdXIBfZKJCXqUHsYI/CYFf8BmY1d04BHoSV0SK27kvEgnWZ4LZVaCDnJgnudXAbUFqKswwAHGJ1HxZTmMSJ0FSaccU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739368492; c=relaxed/simple;
	bh=Vmx1Kk4OKgB/Ozoj1haMKWpNBn3jR853iZs7E+SMPfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCPd9dVBwJQ0o1Aw0qGhv6zOWoW8Kk1hQdm/oM9ErAQLcVcackqOA+16ecsoaO6pLdoKgvrFuGh+BUK4ZUl/uexrZ5atVITcFj4hqi5DB8WVVJHmLIBKinAu83UbhOyu99CJZkGXjgiaL2k0LkdaiUdrvvLDR6nEj9spmUgQX14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a6g4190c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a6g4190c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739368489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cRTp8m7zC8drGEiQGwREcwDlswmw24kXWZgO/9+SJOA=;
	b=a6g4190cV1B5Z9JVe9dY+I5g4XVAJ3OI0YgYslhaT49D93QNNmCpY+CerPeopiST2A5k0p
	VPHviEOsmlNLPU7gL+FBMo4C4I8RwhLsL5g7+ToS5e6Qpdv5TsJU8uIV+n+8ThOK33w1ka
	OLQ75VHpgp1x/I7xywAPnSmjE/NxLfY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-343-nchPFNPaNWSIyww4TMQodg-1; Wed,
 12 Feb 2025 08:54:48 -0500
X-MC-Unique: nchPFNPaNWSIyww4TMQodg-1
X-Mimecast-MFC-AGG-ID: nchPFNPaNWSIyww4TMQodg_1739368487
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55254180034A;
	Wed, 12 Feb 2025 13:54:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 637CA30001AB;
	Wed, 12 Feb 2025 13:54:46 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 01/10] iomap: advance the iter directly on buffered read
Date: Wed, 12 Feb 2025 08:57:03 -0500
Message-ID: <20250212135712.506987-2-bfoster@redhat.com>
In-Reply-To: <20250212135712.506987-1-bfoster@redhat.com>
References: <20250212135712.506987-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

iomap buffered read advances the iter via iter.processed. To
continue separating iter advance from return status, update
iomap_readpage_iter() to advance the iter instead of returning the
number of bytes processed. In turn, drop the offset parameter and
sample the updated iter->pos at the start of the function. Update
the callers to loop based on remaining length in the current
iteration instead of number of bytes processed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 44 +++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ec227b45f3aa..44a366736289 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -366,12 +366,12 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
 		pos >= i_size_read(iter->inode);
 }
 
-static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx, loff_t offset)
+static loff_t iomap_readpage_iter(struct iomap_iter *iter,
+		struct iomap_readpage_ctx *ctx)
 {
 	const struct iomap *iomap = &iter->iomap;
-	loff_t pos = iter->pos + offset;
-	loff_t length = iomap_length(iter) - offset;
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
 	struct folio *folio = ctx->cur_folio;
 	struct iomap_folio_state *ifs;
 	loff_t orig_pos = pos;
@@ -438,25 +438,22 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 	 * we can skip trailing ones as they will be handled in the next
 	 * iteration.
 	 */
-	return pos - orig_pos + plen;
+	length = pos - orig_pos + plen;
+	return iomap_iter_advance(iter, &length);
 }
 
-static loff_t iomap_read_folio_iter(const struct iomap_iter *iter,
+static loff_t iomap_read_folio_iter(struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx)
 {
-	struct folio *folio = ctx->cur_folio;
-	size_t offset = offset_in_folio(folio, iter->pos);
-	loff_t length = min_t(loff_t, folio_size(folio) - offset,
-			      iomap_length(iter));
-	loff_t done, ret;
-
-	for (done = 0; done < length; done += ret) {
-		ret = iomap_readpage_iter(iter, ctx, done);
-		if (ret <= 0)
+	loff_t ret;
+
+	while (iomap_length(iter)) {
+		ret = iomap_readpage_iter(iter, ctx);
+		if (ret)
 			return ret;
 	}
 
-	return done;
+	return 0;
 }
 
 int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
@@ -493,15 +490,14 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_read_folio);
 
-static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
+static loff_t iomap_readahead_iter(struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx)
 {
-	loff_t length = iomap_length(iter);
-	loff_t done, ret;
+	loff_t ret;
 
-	for (done = 0; done < length; done += ret) {
+	while (iomap_length(iter) > 0) {
 		if (ctx->cur_folio &&
-		    offset_in_folio(ctx->cur_folio, iter->pos + done) == 0) {
+		    offset_in_folio(ctx->cur_folio, iter->pos) == 0) {
 			if (!ctx->cur_folio_in_bio)
 				folio_unlock(ctx->cur_folio);
 			ctx->cur_folio = NULL;
@@ -510,12 +506,12 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
 			ctx->cur_folio = readahead_folio(ctx->rac);
 			ctx->cur_folio_in_bio = false;
 		}
-		ret = iomap_readpage_iter(iter, ctx, done);
-		if (ret <= 0)
+		ret = iomap_readpage_iter(iter, ctx);
+		if (ret)
 			return ret;
 	}
 
-	return done;
+	return 0;
 }
 
 /**
-- 
2.48.1

