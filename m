Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A85F1EF0B9
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jan 2025 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738256869; cv=none; b=hzbhEapQA7DuWCE17MtK80Xf2EP5XhkP+4SlSYqwLw5tmdIo55Y3Kt3ztk3ogb6zI25bVd/BGF3xLeUZTQtLt5hx8DoEcRcCqi4fkzhUv7kgZbxwPmy1uFBEL3LUBldY9Ba7CF6E29Vr/pQcljG3Atym+tYkKNwXIQ8tZEL4Gdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738256869; c=relaxed/simple;
	bh=lbE0ncRQAHCxmz6OZ0krfnko+/rOEkIe83zcnTw04fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZHdPoSs8AlIv2fTai59/o5qGKf6PBBL3X7mU6gIOFcYQseVoWl1H9qa+Z+ovajC46KNndhzryP63sa24pEljpxvVvylSj/MRC++HnoU6YfM6PWOoMUcnKdGPzVaxc8nHCl+jnotOfAoM/N67VAUjKenTQOjGv5MySd3PDO5sdvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=elX+P935; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="elX+P935"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738256866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/3n+3CqF5bkcm5ag7qCI2+ZZ+H1Wf/QP/jrJXyaQmg=;
	b=elX+P935iGBWSUI/CBrfFBlbh+HOa3ueNanGYOdyD3oH1RKM1hJ8x+RW16gMnXHpuwunFK
	MQx+bgb+xqIcDifT+J+e/FJhlweQU91oA3TaPn9yH/Jjb8WkH0YOjIM8XDAdrTo8DgBpGs
	tzzlQA3cUqHhyB2lJK7TABvmIuUD6VE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-OtVSqm6xNZqQvDaE2oSYbQ-1; Thu,
 30 Jan 2025 12:07:44 -0500
X-MC-Unique: OtVSqm6xNZqQvDaE2oSYbQ-1
X-Mimecast-MFC-AGG-ID: OtVSqm6xNZqQvDaE2oSYbQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7A221955DC6;
	Thu, 30 Jan 2025 17:07:42 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.113])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1ABE930001BE;
	Thu, 30 Jan 2025 17:07:41 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 6/7] iomap: advance the iter directly on unshare range
Date: Thu, 30 Jan 2025 12:09:47 -0500
Message-ID: <20250130170949.916098-7-bfoster@redhat.com>
In-Reply-To: <20250130170949.916098-1-bfoster@redhat.com>
References: <20250130170949.916098-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Modify unshare range to advance the iter directly. Replace the local
pos and length calculations with direct advances and loop based on
iter state instead.

Signed-off-by: Brian Foster <bfoster@redhat.com>
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
2.47.1

