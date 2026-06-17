Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A537F271A71
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 11:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781696579; cv=none; b=CXrcfA1Od1D/CpwokHth5j0RmUjQKdiRfLQvrNCtzbhZeRQ0iJhHitGf+RQm7M/wjMx8nH8ZujlsM46chCgud7ukLHiool07+qgGvkijR7RJDWbekxbG4BYe6YAQRcuLE0cbjiAuvewU/cPYtvl66RKYbTPQ242jrqXIJUr/k5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781696579; c=relaxed/simple;
	bh=IGwM/eBfzi3jxrzplcOShTe+PJAIsBp8WpPaiCkQvGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EsFyVAxRFmqZk0dimm9JHgsdRof02g/uwV5//4wsTnsrbdhhbv4QcnWIkT+hEt9lCDJEJyGHwFw+2JVJ+wuKK1k0errh7q0COc8URt0kGNDfVVgZ7pbRoIMPEUUh3gcQRHWjqs8HwXWfqhLdf36xwaB72VM/BOOFCYgqcl4WoXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XVfxMRke; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XVfxMRke"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781696576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VN9WNHTA1ZjmNHefd5fG67Hik0Y72dU4DcgNv+nHzjM=;
	b=XVfxMRkesP7bgZIyqYTfyeSMdhcQV+3naDfdtXRJ7c1OFjRvUxOozHQ2NZCoqKZHP3qiO1
	ha3pP2Cp27e6U5si8QOv0w8YtFCZQCOOrjVoKSwfJrUPhEoPHVnMo1ELUZb0VFufvHG/d+
	l0tw9tEJP1m2FSBUuHuY2EkeM01XDj8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-ImLf3wXcMfuynWNEtOIWKg-1; Wed,
 17 Jun 2026 07:42:55 -0400
X-MC-Unique: ImLf3wXcMfuynWNEtOIWKg-1
X-Mimecast-MFC-AGG-ID: ImLf3wXcMfuynWNEtOIWKg_1781696574
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63CE219540DE;
	Wed, 17 Jun 2026 11:42:54 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.89.36])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9CC71955BC2;
	Wed, 17 Jun 2026 11:42:53 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] iomap: always return status from iomap_write_iter
Date: Wed, 17 Jun 2026 07:42:53 -0400
Message-ID: <20260617114253.635751-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

iomap_write_iter() returns either an error code or 0 if partial
progress has been made. The error sanitization was required in the
past because the return value was used by iomap_iter() to determine
how much progress was made, and thus what to pass to ->iomap_end()
and how much to advance the iter.

Now that iter handlers advance the iter incrementally and progress
is separate from return status, this is no longer needed.
iomap_iter() infers partial progress directly from the iter state
and similarly, iomap_file_buffered_write() uses iter.pos to
determine whether to return a short write or an error code.

This also eliminates a minor quirk in the write iteration where if
an error interrupts a partial write, we'd have to loop back into
iomap_write_iter() once more and run into the error a second time
before iomap terminates the operation and returns the error. With
the error code returned directly and separate from write progress,
we can complete the operation and return from iomap_iter()
immediately.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8d4806dc46d4..fb1f60130cd0 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1156,7 +1156,6 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		const struct iomap_write_ops *write_ops)
 {
-	ssize_t total_written = 0;
 	int status = 0;
 	struct address_space *mapping = iter->inode->i_mapping;
 	size_t chunk = mapping_max_folio_size(mapping);
@@ -1252,12 +1251,11 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 				goto retry;
 			}
 		} else {
-			total_written += written;
 			iomap_iter_advance(iter, written);
 		}
 	} while (iov_iter_count(i) && iomap_length(iter));
 
-	return total_written ? 0 : status;
+	return status;
 }
 
 ssize_t
-- 
2.54.0

