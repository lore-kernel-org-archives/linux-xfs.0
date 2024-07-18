Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182B71DDEA
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 13:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307696; cv=none; b=TRlSeW6J4ChNeVvFVD1tIe3FryC9nlYz4wHeQngwVG3jwmXe117uyqjUt3X7xwAkab20rPPjI2Be1vh7PN4ID2BAeM+i6rSrbOWW0STN2byV8aB1CDMxZoMMq0dF0E99+m5Ic5FJB1FnUmPMg+fSND3Wfzq8vD8SYYbz/pKuFMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307696; c=relaxed/simple;
	bh=tN33hKIpRs5sWw9AsupKYf+uzWW0a95CugBsXTfqRqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KeuAXwLKCRDRrBO+VRhFxqywE/vGGNkfwM7PdT7+2Wy5x312cmDIc23op+ewYkWLv1WvZJXjDjs0hDsl5wEJqVDn1e6Mk/UglvWxG77z6eILEjauvgwChgy4aw69sK0kX1U0usdyE4A4Vud9DBEwsKEagkcPHhhnaT480KGXPmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aTSWmEuv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTSWmEuv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721307693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ma4I3Wz0WluGWqW9yq9eTuWH2xOM0InZUvlarO3itoQ=;
	b=aTSWmEuvJJoIV3yE1eNl9C/8Prwa874LNyMdYMeUQgo8Mr+vGtUlgIbF3jfTHybGYZgpsC
	2M12hfFO3zlzjpnzak2ko4OGkVPga1horx9r73erz8DDyktodq7y2NYcgBnKsBUFFH/WvA
	6WQ28usIVI+/39iwOosniUXR0hyL4+4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-b6B1lnHEPlmv1tDiQhi6rA-1; Thu,
 18 Jul 2024 09:01:30 -0400
X-MC-Unique: b6B1lnHEPlmv1tDiQhi6rA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A25B11956088;
	Thu, 18 Jul 2024 13:01:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 98CB61956046;
	Thu, 18 Jul 2024 13:01:28 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] iomap: refactor an iomap_revalidate() helper
Date: Thu, 18 Jul 2024 09:02:10 -0400
Message-ID: <20240718130212.23905-3-bfoster@redhat.com>
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

The buffered write path revalidates the mapping on each folio lock
cycle. If the mapping has changed since the last lookup, the mapping
is marked stale and the operation must break back out into the
lookup path to update the mapping.

The zero range path will need to do something similar for correct
handling of dirty folios over unwritten ranges. Factor out the
validation callback into a new helper that marks the mapping stale
on failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d46558990279..a9425170df72 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -756,6 +756,22 @@ static void __iomap_put_folio(struct iomap_iter *iter, loff_t pos, size_t ret,
 	}
 }
 
+/*
+ * Check whether the current mapping of the iter is still valid. If not, mark
+ * the mapping stale.
+ */
+static inline bool iomap_revalidate(struct iomap_iter *iter)
+{
+	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
+	bool iomap_valid = true;
+
+	if (folio_ops && folio_ops->iomap_valid)
+		iomap_valid = folio_ops->iomap_valid(iter->inode, &iter->iomap);
+	if (!iomap_valid)
+		iter->iomap.flags |= IOMAP_F_STALE;
+	return iomap_valid;
+}
+
 static int iomap_write_begin_inline(const struct iomap_iter *iter,
 		struct folio *folio)
 {
@@ -768,7 +784,6 @@ static int iomap_write_begin_inline(const struct iomap_iter *iter,
 static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 		size_t len, struct folio **foliop)
 {
-	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	struct folio *folio;
 	int status = 0;
@@ -797,15 +812,8 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 	 * could do the wrong thing here (zero a page range incorrectly or fail
 	 * to zero) and corrupt data.
 	 */
-	if (folio_ops && folio_ops->iomap_valid) {
-		bool iomap_valid = folio_ops->iomap_valid(iter->inode,
-							 &iter->iomap);
-		if (!iomap_valid) {
-			iter->iomap.flags |= IOMAP_F_STALE;
-			status = 0;
-			goto out_unlock;
-		}
-	}
+	if (!iomap_revalidate(iter))
+		goto out_unlock;
 
 	if (pos + len > folio_pos(folio) + folio_size(folio))
 		len = folio_pos(folio) + folio_size(folio) - pos;
-- 
2.45.0

