Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED031DDEA
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 13:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307694; cv=none; b=YivLuJrfskI7Ww2JeTi4BNQPJl4w+aAwEVrcDWdzV1nqh4K7pPeRAW8fd9+NhhOrqTR/QfX+mLlHrk5+0yAOllLnX0mE5xb+IHRZT545p8x5taD6K57aqtjlqAkRrgzKB8pn1Bw6fxzjKFZRxsHY1D85NbQI2z7WE2ZPdl0ifV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307694; c=relaxed/simple;
	bh=R2slA10gNRg3+H0XvltJQefma7XhwHawvoEXRcRWd2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H5FK+S8SKbimDSllNwLkjuFpn48TCgxWiPmBr0lV2Ospov7hu1wpIt8ndL9DIwJMnLdpLiM5AwiXQLlrb/u6cBX1A9m/G1srA12WhyQn4e1exE7+s8aZxtVbHlA/CgCCTusu1woYxcqKWGdxiVJ5hFze2PlJT85B2Ao8LsqgkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=foSnqFR5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="foSnqFR5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721307691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+BiOiT3LndRWbM8oPe7FzMaXX4t+mACZ2hr5DvtRG4=;
	b=foSnqFR5ictCzXpDkXRzZWCnsYourmQ+lWA+hLf48XOkLlFdwOJ8t5RBn65xmZ6OhUZJdh
	R0HvzxDAbBIlidQKzEI5ltvA5fVndRD5woFRxr9FaUUCoFIoqONOjUOe2Z9tNOIkVsMA/c
	DwNQif/joj+L+5W3oKCJ2/Uvucf6sJs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-483-9k4PGyEfM4WkITIVpHz-4A-1; Thu,
 18 Jul 2024 09:01:29 -0400
X-MC-Unique: 9k4PGyEfM4WkITIVpHz-4A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BA011955D57;
	Thu, 18 Jul 2024 13:01:28 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 768BE19560B2;
	Thu, 18 Jul 2024 13:01:27 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] filemap: return pos of first dirty folio from range_has_writeback
Date: Thu, 18 Jul 2024 09:02:09 -0400
Message-ID: <20240718130212.23905-2-bfoster@redhat.com>
In-Reply-To: <20240718130212.23905-1-bfoster@redhat.com>
References: <20240718130212.23905-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The iomap layer has a use case that wants to locate the first dirty
or writeback folio in a particular range.
filemap_range_has_writeback() already implements this with the
exception that it only returns a boolean.

Since the _needs_writeback() wrapper is currently the only caller,
tweak has_writeback to take a pointer for the starting offset and
update it to the offset of the first dirty folio found.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 include/linux/pagemap.h | 4 ++--
 mm/filemap.c            | 8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a0a026d2d244..a15131a3fa12 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1217,7 +1217,7 @@ int __filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		pgoff_t index, gfp_t gfp, void **shadowp);
 
 bool filemap_range_has_writeback(struct address_space *mapping,
-				 loff_t start_byte, loff_t end_byte);
+				 loff_t *start_byte, loff_t end_byte);
 
 /**
  * filemap_range_needs_writeback - check if range potentially needs writeback
@@ -1242,7 +1242,7 @@ static inline bool filemap_range_needs_writeback(struct address_space *mapping,
 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
 	    !mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
 		return false;
-	return filemap_range_has_writeback(mapping, start_byte, end_byte);
+	return filemap_range_has_writeback(mapping, &start_byte, end_byte);
 }
 
 /**
diff --git a/mm/filemap.c b/mm/filemap.c
index 657bcd887fdb..be0a219e8d9e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -636,13 +636,13 @@ static bool mapping_needs_writeback(struct address_space *mapping)
 }
 
 bool filemap_range_has_writeback(struct address_space *mapping,
-				 loff_t start_byte, loff_t end_byte)
+				 loff_t *start_byte, loff_t end_byte)
 {
-	XA_STATE(xas, &mapping->i_pages, start_byte >> PAGE_SHIFT);
+	XA_STATE(xas, &mapping->i_pages, *start_byte >> PAGE_SHIFT);
 	pgoff_t max = end_byte >> PAGE_SHIFT;
 	struct folio *folio;
 
-	if (end_byte < start_byte)
+	if (end_byte < *start_byte)
 		return false;
 
 	rcu_read_lock();
@@ -655,6 +655,8 @@ bool filemap_range_has_writeback(struct address_space *mapping,
 				folio_test_writeback(folio))
 			break;
 	}
+	if (folio)
+		*start_byte = folio_pos(folio);
 	rcu_read_unlock();
 	return folio != NULL;
 }
-- 
2.45.0

