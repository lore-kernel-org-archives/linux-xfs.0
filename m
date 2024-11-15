Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EE51D432F
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 14:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682687; cv=none; b=WuZRK5awy3NJ4uVWbg8ymIYBEfEN/jqfRBPQAWDiN0aw+UIY2j+qsY5RLjs7rtkfCO4jiM/+lveL0s1oO7V/bgSTYxTlHqoFaqPU/wcWO0HtOgvJE2+J925TkUnDKVLTRBTVzAGJ8p0E9WZhMZGqb8Qlm1Mq4Qeq10JdgFBeFHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682687; c=relaxed/simple;
	bh=c/7lFKN3Ag3N/BSh0Uxi5XXoHLfe/ZdKeNZ6i18Ve8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MSdM19UyAhOUC40qjNQn2kdLKMbm4/R1Rb3++QoWfIVMKvY3uJ8swCZ029Nk8s9e+SInJ67rfg+M9sSlcpupP6xLtXJ+XqlmJI+huhKy3MJxaYZMlXjiFL8C9ahPkicMzbaulsijIVSZjCUQsBHKH3gtbBbGae2E+bL1wwV1yX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFz5dfCl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFz5dfCl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731682683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9V3qi4Y0mu5WQhvZWL8ZcO5jzlkbQWD1NKBj6Ei5iLI=;
	b=IFz5dfCloy9B3XVSvzxz92l3c0x7mijOXwE3IxhUcenkKyEAGcHWZ7G+9EA+lvMcGSVoxm
	NDtFPC3b54XAhgEKUxdaOR0PDpURXL/DX/0tG3TRJgVJvZKoSK7d3hbNTgQK10eb6RWTUw
	4BdYirvFtfxqLfyg2NRT+khQhirckP0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-E7qv5hxbPMqAL05_xYXcZg-1; Fri,
 15 Nov 2024 09:58:00 -0500
X-MC-Unique: E7qv5hxbPMqAL05_xYXcZg-1
X-Mimecast-MFC-AGG-ID: E7qv5hxbPMqAL05_xYXcZg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22C5D19560B4;
	Fri, 15 Nov 2024 14:57:59 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DDCFE3003B71;
	Fri, 15 Nov 2024 14:57:57 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v2] iomap: warn on zero range of a post-eof folio
Date: Fri, 15 Nov 2024 09:59:31 -0500
Message-ID: <20241115145931.535207-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

iomap_zero_range() uses buffered writes for manual zeroing, no
longer updates i_size for such writes, but is still explicitly
called for post-eof ranges. The historical use case for this is
zeroing post-eof speculative preallocation on extending writes from
XFS. However, XFS also recently changed to convert all post-eof
delalloc mappings to unwritten in the iomap_begin() handler, which
means it now never expects manual zeroing of post-eof mappings. In
other words, all post-eof mappings should be reported as holes or
unwritten.

This is a subtle dependency that can be hard to detect if violated
because associated codepaths are likely to update i_size after folio
locks are dropped, but before writeback happens to occur. For
example, if XFS reverts back to some form of manual zeroing of
post-eof blocks on write extension, writeback of those zeroed folios
will now race with the presumed i_size update from the subsequent
buffered write.

Since iomap_zero_range() can't correctly zero post-eof mappings
beyond EOF without updating i_size, warn if this ever occurs. This
serves as minimal indication that if this use case is reintroduced
by a filesystem, iomap_zero_range() might need to reconsider i_size
updates for write extending use cases.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

v2:
- Dropped unnecessary local var.
v1: https://lore.kernel.org/linux-fsdevel/20241108124246.198489-5-bfoster@redhat.com/

 fs/iomap/buffered-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index af2f59817779..25fbb541032a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1369,6 +1369,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		if (iter->iomap.flags & IOMAP_F_STALE)
 			break;
 
+		/* warn about zeroing folios beyond eof that won't write back */
+		WARN_ON_ONCE(folio_pos(folio) > iter->inode->i_size);
 		offset = offset_in_folio(folio, pos);
 		if (bytes > folio_size(folio) - offset)
 			bytes = folio_size(folio) - offset;
-- 
2.47.0

