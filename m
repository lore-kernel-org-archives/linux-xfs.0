Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECE6211A3B
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 13:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737552750; cv=none; b=B3OO6Wvg7PmYUMupF6Hgus02hhscyExXRt19LVoAOwVkZmnA58pcOSQ+NKLR2m4Y4Zv/eHoSv76iAgrS5Tfj9WQwSUzpn7LFLs2ggUnLWc3UlCVO0cbwKb9qLpHNa/NLJ+FC9I2gGJxS8lNdATCpAT3fV3vXYKEmKWGjAkVs8Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737552750; c=relaxed/simple;
	bh=TOr5oWgkH7Q9YZBsYXY+h3c0MXVUiTU0kiQvMSdB7rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9ix8pNrXhKrYLwT1a9dJMd+70kJotisuJNTnDx1DHKADoHhJ0Y8BbSiiOVk0sImLmyo8u/uN40q0l7DHeYjrCWULAx534G+Qhn7CfOsveyzsFGJvZuNUWwIwgGX9CxCwRFtc7o8d+o612oCWS+Ae1C5sxs4VwsmhDjjNAptWdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eQktUS+X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQktUS+X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737552747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JEoq9O+sN6/C9lYpYN4gpK7SEnLTWIvXxcVRZYusifI=;
	b=eQktUS+XJUeDRZY/ce2g9FRapw4qXnS7stvrosEPP8C9Vom+FYmg5u7qY3VzyLKi+R8Vui
	TSaPVZAAUhmB0/GV42fn8GjdHTdHXg7mZHhjjQB8JzaBLqi6TWvfKmAf8t9jf34y0pDljx
	gcpL7e+pSrMfMK12qH70HCfqOZtUOkY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-M8mAoWQNNl2FFwpSe2brZw-1; Wed,
 22 Jan 2025 08:32:24 -0500
X-MC-Unique: M8mAoWQNNl2FFwpSe2brZw-1
X-Mimecast-MFC-AGG-ID: M8mAoWQNNl2FFwpSe2brZw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C7C119560B4;
	Wed, 22 Jan 2025 13:32:23 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.118])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE5F419560A7;
	Wed, 22 Jan 2025 13:32:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/7] iomap: refactor iter and advance continuation logic
Date: Wed, 22 Jan 2025 08:34:30 -0500
Message-ID: <20250122133434.535192-4-bfoster@redhat.com>
In-Reply-To: <20250122133434.535192-1-bfoster@redhat.com>
References: <20250122133434.535192-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In preparation for future changes and more generic use of
iomap_iter_advance(), lift the high level iter continuation logic
out of iomap_iter_advance() into the caller. Also add some comments
and rework iomap_iter() to jump straight to ->iomap_begin() on the
first iteration.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/iter.c       | 54 +++++++++++++++++++++++--------------------
 include/linux/iomap.h |  1 +
 2 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 731ea7267f27..260ec702ddd5 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -15,31 +15,19 @@ static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
 }
 
 /*
- * Advance to the next range we need to map.
- *
- * If the iomap is marked IOMAP_F_STALE, it means the existing map was not fully
- * processed - it was aborted because the extent the iomap spanned may have been
- * changed during the operation. In this case, the iteration behaviour is to
- * remap the unprocessed range of the iter, and that means we may need to remap
- * even when we've made no progress (i.e. count = 0). Hence the "finished
- * iterating" case needs to distinguish between (count = 0) meaning we are done
- * and (count = 0 && stale) meaning we need to remap the entire remaining range.
+ * Advance the current iterator position and return the length remaining for the
+ * current mapping.
  */
-static inline int iomap_iter_advance(struct iomap_iter *iter, s64 count)
+s64 iomap_iter_advance(struct iomap_iter *iter, s64 count)
 {
-	bool stale = iter->iomap.flags & IOMAP_F_STALE;
-	int ret = 1;
-
 	if (count < 0)
 		return count;
 	if (WARN_ON_ONCE(count > iomap_length(iter)))
 		return -EIO;
 	iter->pos += count;
 	iter->len -= count;
-	if (!iter->len || (!count && !stale))
-		ret = 0;
 
-	return ret;
+	return iomap_length(iter);
 }
 
 static inline void iomap_iter_done(struct iomap_iter *iter)
@@ -71,9 +59,15 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
  */
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 {
-	int ret;
+	s64 ret;
+	bool stale = iter->iomap.flags & IOMAP_F_STALE;
 
-	if (iter->iomap.length && ops->iomap_end) {
+	if (!iter->iomap.length) {
+		trace_iomap_iter(iter, ops, _RET_IP_);
+		goto begin;
+	}
+
+	if (ops->iomap_end) {
 		ret = ops->iomap_end(iter->inode, iter->pos, iomap_length(iter),
 				iter->processed > 0 ? iter->processed : 0,
 				iter->flags, &iter->iomap);
@@ -81,15 +75,25 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 			return ret;
 	}
 
-	/* advance and clear state from the previous iteration */
+	/*
+	 * Advance the iter and clear state from the previous iteration. The
+	 * remaining length of the previous iteration should be zero by this
+	 * point, so use iter->len to determine whether to continue onto the
+	 * next mapping. Explicitly terminate in the case where the current iter
+	 * has not advanced at all (i.e. no work was done for some reason)
+	 * unless the mapping has been marked stale and needs to be reprocessed.
+	 */
 	trace_iomap_iter(iter, ops, _RET_IP_);
-	if (iter->iomap.length) {
-		ret = iomap_iter_advance(iter, iter->processed);
-		iomap_iter_reset_iomap(iter);
-		if (ret <= 0)
-			return ret;
-	}
+	ret = iomap_iter_advance(iter, iter->processed);
+	if (!ret)
+		ret = iter->len;
+	if (ret > 0 && !iter->processed && !stale)
+		ret = 0;
+	iomap_iter_reset_iomap(iter);
+	if (ret <= 0)
+		return ret;
 
+begin:
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index b6f7d96156f2..88bde0259035 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -229,6 +229,7 @@ struct iomap_iter {
 };
 
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
+s64 iomap_iter_advance(struct iomap_iter *iter, s64 count);
 
 static inline u64 iomap_length_trim(const struct iomap_iter *iter, loff_t pos,
 		u64 len)
-- 
2.47.1

