Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98319270ECB
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039496; cv=none; b=gsDOwDo+qMxKRljULrdUXjIegZixcaQZdxvfsXPGY7W0Go2S4kbt1067tdBjMTV18mVxQwyzxKTVXcUysiRR62ir1jXMcw3bEc91q/Q9A90C9T672pfZygjHnpKENJ0a+lwSw+tR0qWKl3tPQ2Wr14oJU4Azea4vX4JWWkWQw0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039496; c=relaxed/simple;
	bh=bJd292s5/g5hp+C4RBdxp5m7A33nWP2SCU7S7EQHO+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ra+SV+Zzu2brD8tPr1kpr886Il7MZjfLqKdF2ZtyM0/hbNXfGUL/Kggan3PSDxyQ4XKBFpDVi3K/qIEgjmjmPhdisRLZKH+Ejl6/QtTCuFgIZQ68oVPA4dfgLTuoVwdyZvQwTNAGH9rXM2s4X8t4VN9oL3a5kKTqL9biBud9Om8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=agi4Z13x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="agi4Z13x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746039492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrVR8JIWJ5LRarSTIYkzvKB8TaKcv+bkSk0KzdHQSwM=;
	b=agi4Z13xujOXHtwd5yq3qvppUsTlDOGPrhKFRXJ2c7h/3CErDucKC1xDoQPhWgfRXHGxva
	v7OEcYFGAWBJh+SBW+waCYZOUhMTjffZWDNFxNogvhZ+qK6L0fZbTjZ7ksWzzEv3hd9rfA
	aWuw0+hJ0Yz27MrW9dXmx03Hn9yjh9Q=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-164-Vis7mLnDNo-N1OcZbi9oUQ-1; Wed,
 30 Apr 2025 14:58:05 -0400
X-MC-Unique: Vis7mLnDNo-N1OcZbi9oUQ-1
X-Mimecast-MFC-AGG-ID: Vis7mLnDNo-N1OcZbi9oUQ_1746039484
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDD7C1801A1A;
	Wed, 30 Apr 2025 18:58:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E6A319560B0;
	Wed, 30 Apr 2025 18:58:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] iomap: push non-large folio check into get folio path
Date: Wed, 30 Apr 2025 15:01:11 -0400
Message-ID: <20250430190112.690800-6-bfoster@redhat.com>
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

The len param to __iomap_get_folio() is primarily a folio allocation
hint. iomap_write_begin() already trims its local len variable based
on the provided folio, so move the large folio support check closer
to folio lookup.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 5ed3332e69dd..d3b30ebad9ea 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -746,6 +746,9 @@ static struct folio *__iomap_get_folio(struct iomap_iter *iter, size_t len)
 	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
 	loff_t pos = iter->pos;
 
+	if (!mapping_large_folio_support(iter->inode->i_mapping))
+		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
+
 	if (folio_ops && folio_ops->get_folio)
 		return folio_ops->get_folio(iter, pos, len);
 	else
@@ -806,9 +809,6 @@ static int iomap_write_begin(struct iomap_iter *iter, size_t len,
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
-	if (!mapping_large_folio_support(iter->inode->i_mapping))
-		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
-
 	folio = __iomap_get_folio(iter, len);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-- 
2.49.0

