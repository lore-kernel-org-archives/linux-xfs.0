Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9804D1AAE17
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 13:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498963; cv=none; b=swjOg8Ong7SblmHNyLa46Xxl7+6AMK0nT0vd6Pya9ZnG/YTu8QeXDWAAoT7byIg1XroCEyxBIbiSbvvEN/IrRgEuAvPjVVcknS+En7BxnfrJulIkrE3/vMrLNXkKdzlFej3iaGoW3P9khHoO4mq+Yozi1PJa8ZoqgcwJWwARn7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498963; c=relaxed/simple;
	bh=kcXsA5D2l6jq1dNJXhJGlHhKOe+Grlq1+qB7Sse2dPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SryExnetP8lpjdKVSxiTFU6BGH7coYxwPNFMkxig18K8DIaPZgHT8gTf4D+MgbEejpaoMVMiavZusWqfy/XicJOxB6DqDuLl+S1hAlVw1P+dDtmlXXk7gHQTUNZ87fcAMo7BhslMVNU+rfXhGCrsdo9QxgCqGyYLJ7c2F/yHPLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bm+9pj4w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bm+9pj4w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+uBUs752o9ejjaxLycOGdkkyFonqI7ieDhyDaEpM9qA=;
	b=bm+9pj4wSzI3cG+BS8pyBk3FYW0Tm4sg9Ppi352Zxi96uMN2hoXTtJhqt5U4kqMH5nKC+/
	KrQunjv7fB4i0BXxGf3HwpUAZS28V847c8ms1wSpr08WathJUH9awKUQEKstnZ0iiwpwXE
	UY3RYn5CxwLezki49a2xJIaokPIKfzY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-4PEntGNLOpijA2AKBOui0A-1; Fri,
 03 Oct 2025 09:42:38 -0400
X-MC-Unique: 4PEntGNLOpijA2AKBOui0A-1
X-Mimecast-MFC-AGG-ID: 4PEntGNLOpijA2AKBOui0A_1759498956
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16EAC1800378;
	Fri,  3 Oct 2025 13:42:36 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D5FC19560B1;
	Fri,  3 Oct 2025 13:42:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 2/7] iomap: remove pos+len BUG_ON() to after folio lookup
Date: Fri,  3 Oct 2025 09:46:36 -0400
Message-ID: <20251003134642.604736-3-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The bug checks at the top of iomap_write_begin() assume the pos/len
reflect exactly the next range to process. This may no longer be the
case once the get folio path is able to process a folio batch from
the filesystem. On top of that, len is already trimmed to within the
iomap/srcmap by iomap_length(), so these checks aren't terribly
useful. Remove the unnecessary BUG_ON() checks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8b847a1e27f1..211644774bb8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -815,15 +815,12 @@ static int iomap_write_begin(struct iomap_iter *iter,
 		size_t *poffset, u64 *plen)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
-	loff_t pos = iter->pos;
+	loff_t pos;
 	u64 len = min_t(u64, SIZE_MAX, iomap_length(iter));
 	struct folio *folio;
 	int status = 0;
 
 	len = min_not_zero(len, *plen);
-	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
-	if (srcmap != &iter->iomap)
-		BUG_ON(pos + len > srcmap->offset + srcmap->length);
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
-- 
2.51.0

