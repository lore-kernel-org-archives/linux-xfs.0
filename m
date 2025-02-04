Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA8E21CA15
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 13:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675718; cv=none; b=UscdNLvK07aX2hBIFvjZyhrjZfg8w4EpK2TUu3RXwuuQWnKYQXf+x7e0w6a+972syJxEm8MXMeshS7TfQUrMqZ1S1MWrdx4EqYhj6hVMXXWBLgGzV7SKEVGPvkiklrkr2LCdKOPTrxa+Kmzm+8AIv6+B9FiazZL6Jfq5KuCPjug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675718; c=relaxed/simple;
	bh=Kdz/56mDCbmYD0YG89VTqRwBDxd/kcACpINoojLnKdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=inQth66TkXGh5X1buhlnhRvdhoqoB4bKtJCoWK7Q65zWQk5HqJW0DNMSa9QtlDYj65snVXD1tMhAw+kY4c7w3AdcOqM93uDS0uv5ZV5Mdi+e58VpDWPg6mRzZMEjrFryhlydxbivVBmDnaWM2L6BaA71gLS04Ee+y7seRTEks+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fzQJ+ehH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fzQJ+ehH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738675715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WMVMy45A1WyesgW+SjJGtcOKsPdojtcP73swmOalVws=;
	b=fzQJ+ehHPhIX43BzaFbZMG+qQA25IfjxiQF2kHY80/CIovO1BKUaUkl2CfUA3TQz5Y/Fv2
	KLLMITbY7MEiDJK6IO4kRSI8Xx+ybX1eymnxLwGH2X2hObyU9aURAPfuETmr3+j5XQQ683
	9BXjh9Jvn2gGnBxyD+yG4MSph4NV6Og=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-bZcji3FzOmWt6hzSVZ4vmQ-1; Tue,
 04 Feb 2025 08:28:31 -0500
X-MC-Unique: bZcji3FzOmWt6hzSVZ4vmQ-1
X-Mimecast-MFC-AGG-ID: bZcji3FzOmWt6hzSVZ4vmQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E8FE19560AF;
	Tue,  4 Feb 2025 13:28:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7EB719560AD;
	Tue,  4 Feb 2025 13:28:28 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 09/10] iomap: advance the iter directly on unshare range
Date: Tue,  4 Feb 2025 08:30:43 -0500
Message-ID: <20250204133044.80551-10-bfoster@redhat.com>
In-Reply-To: <20250204133044.80551-1-bfoster@redhat.com>
References: <20250204133044.80551-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Modify unshare range to advance the iter directly. Replace the local
pos and length calculations with direct advances and loop based on
iter state instead.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 678c189faa58..f953bf66beb1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1267,20 +1267,19 @@ EXPORT_SYMBOL_GPL(iomap_write_delalloc_release);
 static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
-	loff_t pos = iter->pos;
-	loff_t length = iomap_length(iter);
-	loff_t written = 0;
+	u64 bytes = iomap_length(iter);
+	int status;
 
 	if (!iomap_want_unshare_iter(iter))
-		return length;
+		return iomap_iter_advance(iter, &bytes);
 
 	do {
 		struct folio *folio;
-		int status;
 		size_t offset;
-		size_t bytes = min_t(u64, SIZE_MAX, length);
+		loff_t pos = iter->pos;
 		bool ret;
 
+		bytes = min_t(u64, SIZE_MAX, bytes);
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (unlikely(status))
 			return status;
@@ -1298,14 +1297,14 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 
 		cond_resched();
 
-		pos += bytes;
-		written += bytes;
-		length -= bytes;
-
 		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
-	} while (length > 0);
 
-	return written;
+		status = iomap_iter_advance(iter, &bytes);
+		if (status)
+			break;
+	} while (bytes > 0);
+
+	return status;
 }
 
 int
-- 
2.48.1

