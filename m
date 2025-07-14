Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DD8238179
	for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 20:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752525472; cv=none; b=jszg/4Fmf2idponuuEPjYNjHaV1VktswpB9YXeB9hpijmcaEYEEW/8OCXApf5WHfYSqtLsiLKkbJm96DksLFOHFQ58jQzXPQSMjQ0TMZ7kOHyNGN5r1Z2pZYDTAAcjuO/DoS7lUuXA7Y0z6YgZYzqc625Yh+rBdHYuaB6XxCoxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752525472; c=relaxed/simple;
	bh=o6lxpyRDhsKyt1kSzcpl+YFoFNmOOt4Bd/BQbj/e+Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hf+oJTsDqnzh/xiYho8R4EQLsM90Z0lcaZY5/hxeGgNTEhghE6WHYi8iZmMIoZ1wd6kZpIMOMHCJ2z++Nrt3UbnQbYl/crYHqfmOywKKSYxkfdOYrHRVsEmzzdg3AWEUw2mqEbeXiYDrKgJ0sUgnJWtkrbiuIW5W78BKnmNaJJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LcCgOqkK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LcCgOqkK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752525469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XLdZRvcQL8LOEfVl5rHLuZ7anpsrEIqyRbvnEXKnMtw=;
	b=LcCgOqkKs1POvGUZEayehjRfHG9PAoenKsNHqq4kRjXHUwUHP/C1KngV0HM+8mSYhlW3tp
	8/Cz71UtXo4eLhzrco8KRG/idcaac9x/XZxVT0FvJiwI5XVsrS/lfzI6U01WPdtTjKtG6S
	DS49Ae4YlVxc460HHCVj6z/TDkXKpbU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-j6dcRWlsONyj34yYaO-DtA-1; Mon,
 14 Jul 2025 16:37:45 -0400
X-MC-Unique: j6dcRWlsONyj34yYaO-DtA-1
X-Mimecast-MFC-AGG-ID: j6dcRWlsONyj34yYaO-DtA_1752525464
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EDBD180120C;
	Mon, 14 Jul 2025 20:37:44 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.43])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2333C19560A3;
	Mon, 14 Jul 2025 20:37:41 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v3 1/7] filemap: add helper to look up dirty folios in a range
Date: Mon, 14 Jul 2025 16:41:16 -0400
Message-ID: <20250714204122.349582-2-bfoster@redhat.com>
In-Reply-To: <20250714204122.349582-1-bfoster@redhat.com>
References: <20250714204122.349582-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Add a new filemap_get_folios_dirty() helper to look up existing dirty
folios in a range and add them to a folio_batch. This is to support
optimization of certain iomap operations that only care about dirty
folios in a target range. For example, zero range only zeroes the subset
of dirty pages over unwritten mappings, seek hole/data may use similar
logic in the future, etc.

Note that the helper is intended for use under internal fs locks.
Therefore it trylocks folios in order to filter out clean folios.
This loosely follows the logic from filemap_range_has_writeback().

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 58 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e63fbfbd5b0f..fb83ddf26621 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -941,6 +941,8 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch);
+unsigned filemap_get_folios_dirty(struct address_space *mapping,
+		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 
 /*
  * Returns locked page at given index in given cache, creating it if needed.
diff --git a/mm/filemap.c b/mm/filemap.c
index bada249b9fb7..2171b7f689b0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2334,6 +2334,64 @@ unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 }
 EXPORT_SYMBOL(filemap_get_folios_tag);
 
+/**
+ * filemap_get_folios_dirty - Get a batch of dirty folios
+ * @mapping:	The address_space to search
+ * @start:	The starting folio index
+ * @end:	The final folio index (inclusive)
+ * @fbatch:	The batch to fill
+ *
+ * filemap_get_folios_dirty() works exactly like filemap_get_folios(), except
+ * the returned folios are presumed to be dirty or undergoing writeback. Dirty
+ * state is presumed because we don't block on folio lock nor want to miss
+ * folios. Callers that need to can recheck state upon locking the folio.
+ *
+ * This may not return all dirty folios if the batch gets filled up.
+ *
+ * Return: The number of folios found.
+ * Also update @start to be positioned for traversal of the next folio.
+ */
+unsigned filemap_get_folios_dirty(struct address_space *mapping, pgoff_t *start,
+			pgoff_t end, struct folio_batch *fbatch)
+{
+	XA_STATE(xas, &mapping->i_pages, *start);
+	struct folio *folio;
+
+	rcu_read_lock();
+	while ((folio = find_get_entry(&xas, end, XA_PRESENT)) != NULL) {
+		if (xa_is_value(folio))
+			continue;
+		if (folio_trylock(folio)) {
+			bool clean = !folio_test_dirty(folio) &&
+				     !folio_test_writeback(folio);
+			folio_unlock(folio);
+			if (clean) {
+				folio_put(folio);
+				continue;
+			}
+		}
+		if (!folio_batch_add(fbatch, folio)) {
+			unsigned long nr = folio_nr_pages(folio);
+			*start = folio->index + nr;
+			goto out;
+		}
+	}
+	/*
+	 * We come here when there is no folio beyond @end. We take care to not
+	 * overflow the index @start as it confuses some of the callers. This
+	 * breaks the iteration when there is a folio at index -1 but that is
+	 * already broke anyway.
+	 */
+	if (end == (pgoff_t)-1)
+		*start = (pgoff_t)-1;
+	else
+		*start = end + 1;
+out:
+	rcu_read_unlock();
+
+	return folio_batch_count(fbatch);
+}
+
 /*
  * CD/DVDs are error prone. When a medium error occurs, the driver may fail
  * a _large_ part of the i/o request. Imagine the worst scenario:
-- 
2.50.0

