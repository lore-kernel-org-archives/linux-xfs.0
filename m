Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B912E2641FB
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 18:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039487; cv=none; b=TmJtLjS1M64OYTH6+Ot582lC7tc/skHYziGHSbGYNLEhWmFkrScLxKqo55fKSiVOa1mlfYTf1Gv8MBEcw9Rp6ZFLGTXaS5kkWhf+8yHY3kQokoFDN5Gtu3apQlJU9Rq/Frr3cjrUfGp0nozmGvknb4/T40xYdgqnnwaf/LWYuoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039487; c=relaxed/simple;
	bh=zRLCEvvjv9vup53c4cK8xs21IWEVFMC0hL+JofSxVeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HLpyE9k6RNnYxexjz4fjqw4CsYzvWgwJcnWRmoVpNLZyRc/xOnPbzweL/WenHgGbi64IKRGJcij+DWn94wjn/M467SuKHszkL3IX1IRzfffYZpkwZdEDoBqqcUQZwHEnKgjgP0rcfCkEhXOHO9+n0u4odrkwBAptBXTfJO509Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5z0dqaU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5z0dqaU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746039484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mftKe7707T/GtWSLagWhYlnulUJle86ihYZ8NU5oWfc=;
	b=Q5z0dqaU3+jK0Vt+XdLrQr2liJfqcVJoWCvl0TCqJxFPDLASenecpIU/npULAMGzk0cHc1
	owfQQbF7669xEWy5+eFhGgihH+p8mjFY7PBnQxs+MfE0lRhjtKukht6jWqICClpL6Utr6a
	ZdFQVsMI+6O/5IqykRo3APBQllUZG20=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-r-w3luzHMMm8jI5Yqzftog-1; Wed,
 30 Apr 2025 14:58:01 -0400
X-MC-Unique: r-w3luzHMMm8jI5Yqzftog-1
X-Mimecast-MFC-AGG-ID: r-w3luzHMMm8jI5Yqzftog_1746039481
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCE3A1956088;
	Wed, 30 Apr 2025 18:58:00 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 290B219560A3;
	Wed, 30 Apr 2025 18:58:00 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] iomap: resample iter->pos after iomap_write_begin() calls
Date: Wed, 30 Apr 2025 15:01:07 -0400
Message-ID: <20250430190112.690800-2-bfoster@redhat.com>
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

In preparation for removing the pos parameter, push the local pos
assignment down after calls to iomap_write_begin().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 5b08bd417b28..a41c8ffc4996 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -920,11 +920,11 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		size_t bytes;		/* Bytes to write to folio */
 		size_t copied;		/* Bytes copied from user */
 		u64 written;		/* Bytes have been written */
-		loff_t pos = iter->pos;
+		loff_t pos;
 
 		bytes = iov_iter_count(i);
 retry:
-		offset = pos & (chunk - 1);
+		offset = iter->pos & (chunk - 1);
 		bytes = min(chunk - offset, bytes);
 		status = balance_dirty_pages_ratelimited_flags(mapping,
 							       bdp_flags);
@@ -949,13 +949,14 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 			break;
 		}
 
-		status = iomap_write_begin(iter, pos, bytes, &folio);
+		status = iomap_write_begin(iter, iter->pos, bytes, &folio);
 		if (unlikely(status)) {
-			iomap_write_failed(iter->inode, pos, bytes);
+			iomap_write_failed(iter->inode, iter->pos, bytes);
 			break;
 		}
 		if (iter->iomap.flags & IOMAP_F_STALE)
 			break;
+		pos = iter->pos;
 
 		offset = offset_in_folio(folio, pos);
 		if (bytes > folio_size(folio) - offset)
@@ -1276,15 +1277,16 @@ static int iomap_unshare_iter(struct iomap_iter *iter)
 	do {
 		struct folio *folio;
 		size_t offset;
-		loff_t pos = iter->pos;
+		loff_t pos;
 		bool ret;
 
 		bytes = min_t(u64, SIZE_MAX, bytes);
-		status = iomap_write_begin(iter, pos, bytes, &folio);
+		status = iomap_write_begin(iter, iter->pos, bytes, &folio);
 		if (unlikely(status))
 			return status;
 		if (iomap->flags & IOMAP_F_STALE)
 			break;
+		pos = iter->pos;
 
 		offset = offset_in_folio(folio, pos);
 		if (bytes > folio_size(folio) - offset)
@@ -1351,15 +1353,16 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 	do {
 		struct folio *folio;
 		size_t offset;
-		loff_t pos = iter->pos;
+		loff_t pos;
 		bool ret;
 
 		bytes = min_t(u64, SIZE_MAX, bytes);
-		status = iomap_write_begin(iter, pos, bytes, &folio);
+		status = iomap_write_begin(iter, iter->pos, bytes, &folio);
 		if (status)
 			return status;
 		if (iter->iomap.flags & IOMAP_F_STALE)
 			break;
+		pos = iter->pos;
 
 		/* warn about zeroing folios beyond eof that won't write back */
 		WARN_ON_ONCE(folio_pos(folio) > iter->inode->i_size);
-- 
2.49.0

