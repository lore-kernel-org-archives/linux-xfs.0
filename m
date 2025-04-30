Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7003326B96B
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039492; cv=none; b=P7nBou/4nuA0kMMxbNwQbG91U8ZFj2iwe9NFwJMta8GneHjxp6Br0w0Fv0MWXXANSDTNo3xVfsUuLq7lXqkyiSAlaMRm1iMdlRuhz5hYISd23mljhpuUhdHv+lrQZxD4DAO62KyPSLku8QefTqtRuYBEd8b0M03Gm6EYB5lyv+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039492; c=relaxed/simple;
	bh=CdzBseX/nhIO+r6EXHUjZkLAUAYUROQz71hC+z8sx/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s1T0KW1NejiMl6LdXX2y/QQw1hCMRiQd6Ax6Yfg01YofeEHPqSFOLYsLIU2dowVO3BaBO2kKHsTKx2yBVrNaCUAkNn8hGXrEn5AYjS2ncOrj9x0bLYtEOVTgEbTCPP3NOD+Cscb94r8ZbY3waYBUEBkyiNIIcdvIPX0SS6BmkGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TLXTPyad; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TLXTPyad"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746039488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FR48CFNRkcFcLoQC1+FepN+rqBdcBJJcHJrCBC6tinI=;
	b=TLXTPyadwVtxufH2PqfgmTo/OjN6Y/NO5JcNGPcqP18twGtTiQkv3fM5A8tmNoJJqpivEa
	qrWUSII8cbVgvqEDMHS2sAGSA93jF80oG2oAyk4RxZBnnLOr+kNzCF4fiP6e8xX1u/KGf1
	7sOKdNAPhTW081RGhs9I1768IZTAdc4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-2HlkonNzMUuGNOKFwfQqsA-1; Wed,
 30 Apr 2025 14:58:03 -0400
X-MC-Unique: 2HlkonNzMUuGNOKFwfQqsA-1
X-Mimecast-MFC-AGG-ID: 2HlkonNzMUuGNOKFwfQqsA_1746039482
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4344E19560BC;
	Wed, 30 Apr 2025 18:58:02 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B87C919560B1;
	Wed, 30 Apr 2025 18:58:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] iomap: drop pos param from __iomap_[get|put]_folio()
Date: Wed, 30 Apr 2025 15:01:09 -0400
Message-ID: <20250430190112.690800-4-bfoster@redhat.com>
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

Both helpers take the iter and pos as parameters. All callers
effectively pass iter->pos, so drop the unnecessary pos parameter.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d1a50300a5dc..5c08b2916bc7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -741,10 +741,10 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 	return 0;
 }
 
-static struct folio *__iomap_get_folio(struct iomap_iter *iter, loff_t pos,
-		size_t len)
+static struct folio *__iomap_get_folio(struct iomap_iter *iter, size_t len)
 {
 	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
+	loff_t pos = iter->pos;
 
 	if (folio_ops && folio_ops->get_folio)
 		return folio_ops->get_folio(iter, pos, len);
@@ -752,10 +752,11 @@ static struct folio *__iomap_get_folio(struct iomap_iter *iter, loff_t pos,
 		return iomap_get_folio(iter, pos, len);
 }
 
-static void __iomap_put_folio(struct iomap_iter *iter, loff_t pos, size_t ret,
+static void __iomap_put_folio(struct iomap_iter *iter, size_t ret,
 		struct folio *folio)
 {
 	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
+	loff_t pos = iter->pos;
 
 	if (folio_ops && folio_ops->put_folio) {
 		folio_ops->put_folio(iter->inode, pos, ret, folio);
@@ -793,7 +794,7 @@ static int iomap_write_begin(struct iomap_iter *iter, size_t len,
 	if (!mapping_large_folio_support(iter->inode->i_mapping))
 		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
 
-	folio = __iomap_get_folio(iter, pos, len);
+	folio = __iomap_get_folio(iter, len);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
@@ -834,7 +835,7 @@ static int iomap_write_begin(struct iomap_iter *iter, size_t len,
 	return 0;
 
 out_unlock:
-	__iomap_put_folio(iter, pos, 0, folio);
+	__iomap_put_folio(iter, 0, folio);
 
 	return status;
 }
@@ -983,7 +984,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 			i_size_write(iter->inode, pos + written);
 			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 		}
-		__iomap_put_folio(iter, pos, written, folio);
+		__iomap_put_folio(iter, written, folio);
 
 		if (old_size < pos)
 			pagecache_isize_extended(iter->inode, old_size, pos);
@@ -1295,7 +1296,7 @@ static int iomap_unshare_iter(struct iomap_iter *iter)
 			bytes = folio_size(folio) - offset;
 
 		ret = iomap_write_end(iter, bytes, bytes, folio);
-		__iomap_put_folio(iter, pos, bytes, folio);
+		__iomap_put_folio(iter, bytes, folio);
 		if (WARN_ON_ONCE(!ret))
 			return -EIO;
 
@@ -1376,7 +1377,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		folio_mark_accessed(folio);
 
 		ret = iomap_write_end(iter, bytes, bytes, folio);
-		__iomap_put_folio(iter, pos, bytes, folio);
+		__iomap_put_folio(iter, bytes, folio);
 		if (WARN_ON_ONCE(!ret))
 			return -EIO;
 
-- 
2.49.0

