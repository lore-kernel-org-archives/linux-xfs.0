Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62C121CA1C
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 13:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675716; cv=none; b=CTI4E5ESxjPYDDkTetet8LoOWSITXPqdo275flUQTp0HPMkvZStCzdAhOJY31+gmR2tkRgbLPeJyD7xArDq+54TXdOX2rvy8B6y5taNo/I4kmVxMpU3+4UsoSxd6ZQ/KFFsN1olee8RSYjQ4DIaYSysORxdP+gzX27CMF6ByEEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675716; c=relaxed/simple;
	bh=QCgaqBiygpjXgYUk72ByAGxBLyfCE2huLirr2/Us2f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hmjNiNe42zPe7tf1brd9Iom93P+fLBd40D02OcUKlv3jXz/7pd9Ohwyd6Uv//dgPAqx8V80lM9SH7sq9CcltK3qczIiXyFHwyjskLsKBgYHz0a2LjB4YZ8xLREGkjPBwR4+/idIcxQ9k/OfrlX2svbEJwGVcC3FGfHpthq8t/5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ag6a1mTK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ag6a1mTK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738675713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hv3T+Ttj1lbOrRdX3pI+fAyVtMbGsZP6fn6j2R7l7U0=;
	b=ag6a1mTKWf3dRatRtSa10YaNZu5PWn4YNs4+hB/ki/lbi6LpC1vW11WG8qBXtTGsRSUtnw
	ncrMgiucMkdy1COqdR12sGfepW1HVaHpbRdQBMumsyVBs0VxcMnlbNbxKqZb9qTxY/7NA/
	eP/uIdaGShU0/RhynsAhpr+0VWLdj8M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-Rva7Ik5AOz6Uf6YXjZuKAQ-1; Tue,
 04 Feb 2025 08:28:28 -0500
X-MC-Unique: Rva7Ik5AOz6Uf6YXjZuKAQ-1
X-Mimecast-MFC-AGG-ID: Rva7Ik5AOz6Uf6YXjZuKAQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B41E1800370;
	Tue,  4 Feb 2025 13:28:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0047019560BF;
	Tue,  4 Feb 2025 13:28:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 07/10] iomap: support incremental iomap_iter advances
Date: Tue,  4 Feb 2025 08:30:41 -0500
Message-ID: <20250204133044.80551-8-bfoster@redhat.com>
In-Reply-To: <20250204133044.80551-1-bfoster@redhat.com>
References: <20250204133044.80551-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

The current iomap_iter iteration model reads the mapping from the
filesystem, processes the subrange of the operation associated with
the current mapping, and returns the number of bytes processed back
to the iteration code. The latter advances the position and
remaining length of the iter in preparation for the next iteration.

At the _iter() handler level, this tends to produce a processing
loop where the local code pulls the current position and remaining
length out of the iter, iterates it locally based on file offset,
and then breaks out when the associated range has been fully
processed.

This works well enough for current handlers, but upcoming
enhancements require a bit more flexibility in certain situations.
Enhancements for zero range will lead to a situation where the
processing loop is no longer a pure ascending offset walk, but
rather dictated by pagecache state and folio lookup. Since folio
lookup and write preparation occur at different levels, it is more
difficult to manage position and length outside of the iter.

To provide more flexibility to certain iomap operations, introduce
support for incremental iomap_iter advances from within the
operation itself. This allows more granular advances for operations
that might not use the typical file offset based walk.

Note that the semantics for operations that use incremental advances
is slightly different than traditional operations. Operations that
advance the iter directly are expected to return success or failure
(i.e. 0 or negative error code) in iter.processed rather than the
number of bytes processed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/iter.c       | 32 +++++++++++++++++++++++++-------
 include/linux/iomap.h |  3 +++
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index cdba24dbbfd7..9273ef36d5ae 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -35,6 +35,8 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 	WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos);
 	WARN_ON_ONCE(iter->iomap.flags & IOMAP_F_STALE);
 
+	iter->iter_start_pos = iter->pos;
+
 	trace_iomap_iter_dstmap(iter->inode, &iter->iomap);
 	if (iter->srcmap.type != IOMAP_HOLE)
 		trace_iomap_iter_srcmap(iter->inode, &iter->srcmap);
@@ -58,6 +60,8 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 {
 	bool stale = iter->iomap.flags & IOMAP_F_STALE;
+	ssize_t advanced = iter->processed > 0 ? iter->processed : 0;
+	u64 olen = iter->len;
 	s64 processed;
 	int ret;
 
@@ -66,11 +70,22 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	if (!iter->iomap.length)
 		goto begin;
 
+	/*
+	 * If iter.processed is zero, the op may still have advanced the iter
+	 * itself. Calculate the advanced and original length bytes based on how
+	 * far pos has advanced for ->iomap_end().
+	 */
+	if (!advanced) {
+		advanced = iter->pos - iter->iter_start_pos;
+		olen += advanced;
+	}
+
 	if (ops->iomap_end) {
-		ret = ops->iomap_end(iter->inode, iter->pos, iomap_length(iter),
-				iter->processed > 0 ? iter->processed : 0,
-				iter->flags, &iter->iomap);
-		if (ret < 0 && !iter->processed)
+		ret = ops->iomap_end(iter->inode, iter->iter_start_pos,
+				iomap_length_trim(iter, iter->iter_start_pos,
+						  olen),
+				advanced, iter->flags, &iter->iomap);
+		if (ret < 0 && !advanced)
 			return ret;
 	}
 
@@ -81,8 +96,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	}
 
 	/*
-	 * Advance the iter and clear state from the previous iteration. Use
-	 * iter->len to determine whether to continue onto the next mapping.
+	 * Advance the iter and clear state from the previous iteration. This
+	 * passes iter->processed because that reflects the bytes processed but
+	 * not yet advanced by the iter handler.
+	 *
+	 * Use iter->len to determine whether to continue onto the next mapping.
 	 * Explicitly terminate in the case where the current iter has not
 	 * advanced at all (i.e. no work was done for some reason) unless the
 	 * mapping has been marked stale and needs to be reprocessed.
@@ -90,7 +108,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	ret = iomap_iter_advance(iter, &processed);
 	if (!ret && iter->len > 0)
 		ret = 1;
-	if (ret > 0 && !iter->processed && !stale)
+	if (ret > 0 && !advanced && !stale)
 		ret = 0;
 	iomap_iter_reset_iomap(iter);
 	if (ret <= 0)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f304c602e5fe..0135a7f8dd83 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -211,6 +211,8 @@ struct iomap_ops {
  *	calls to iomap_iter().  Treat as read-only in the body.
  * @len: The remaining length of the file segment we're operating on.
  *	It is updated at the same time as @pos.
+ * @iter_start_pos: The original start pos for the current iomap. Used for
+ *	incremental iter advance.
  * @processed: The number of bytes processed by the body in the most recent
  *	iteration, or a negative errno. 0 causes the iteration to stop.
  * @flags: Zero or more of the iomap_begin flags above.
@@ -221,6 +223,7 @@ struct iomap_iter {
 	struct inode *inode;
 	loff_t pos;
 	u64 len;
+	loff_t iter_start_pos;
 	s64 processed;
 	unsigned flags;
 	struct iomap iomap;
-- 
2.48.1

