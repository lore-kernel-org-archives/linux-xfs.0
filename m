Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931E13B71A5
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112174; cv=none; b=pIb0AuKtSkDlMlkFSvPn3fQGn0hNfBHHl3TPBUac1ZyfcwrBZfKkvqzkoKYrxkaK9r466/m0/4GPegafOZ+neGH//QlmsU7/BVwo1s06P5wdtGBfTDfhAxHv3oLs+LY1QdTArbyb3+qgkQnnh9iUDHpLQ4ibXHhwBCwnuWFMw9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112174; c=relaxed/simple;
	bh=yMrg/1mhuAsGDJrITIi1LEqhbmTNDd57YLkcgyjq22c=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=h6yq3Wx91Rwvp61/MlJnC9ypwxaqc4w0E+x03NlUpXdNJnmTtfWm/fMwlZ1MVrYSTJvZUAKbtbs9FGSOKpSev1U3hNHN4YrhHd2V0hXs8MkT39FPBlKcXlP4FiyB2RWVvNs/R0yE+TvaTbm9ThLn+Omr/XBsJGwC4QU1kYTJ/3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=TYyilc7P; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="TYyilc7P"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04R4NHYz6lr
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112167; bh=eqEWhMBPAsNxNLXmfuzuhkVoJb/xd1qr6s6nadoNvJI=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=TYyilc7PzAwTpilw8F4eWz5q9eGfLeY6SbwGI7BrqFW1WemCC+vT1Hgt5BJKGFBqG
	 BmH/+tUM5udFN1V5Po647EeB+dSNUv9qP4ax6O2m23IGEvoyOx1fHuueEOjjLI9rpp
	 5umtkIDliFq3bBJJRTQ9wAkxY42Iz8590AVjYl9PHt4kMXFhgJiMJt926RL4nIj23w
	 OgsiUrTtkSVNoNWNzPlHbjRbJehLvQIE7sPAw337VcgNbzWLvZsaDmlSp1dwk6cmHD
	 x/oNc9gl1hS7N5zt4o4ol0fV1BdnH7kTUSw8nSYrT68eBsuyPMA0kgqMvGtj3j8b88
	 sFjSYd7Pv9Kzw==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04Q0mpqz9KQbD
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:26 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:26 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <2bc415d28f12b661f5286c282cba597a33b9b0e8.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Thu, 20 Aug 2026 17:26:22 -0700
Subject: [PATCH 2/9] libxfs: don't corrupt a delwri list when a buffer is
 queued twice
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfs_buf_delwri_queue() unconditionally adds the buffer to the list:

	xfs_buf_hold(bp);
	list_add_tail(&bp->b_list, buffer_list);

list_add_tail() on a node that is already linked does not move the node,
it relinks it: the entries between its old position and the tail are
spliced out of the list and are never submitted.  Queueing A, B and C
and then queueing A again leaves a list containing just A; B and C are
silently dropped and their contents are never written.  Each redundant
queue also leaks a reference.

The kernel avoids this with the _XBF_DELWRI_Q flag.  There is no such
flag in userspace, but list membership is an accurate substitute here
because both xfs_buf_delwri_submit() and xfs_buf_delwri_cancel() remove
entries with list_del_init(), so a buffer that is not on a list always
has an empty b_list.

That is only true once b_list is actually initialised.  Buffers are
allocated with kmem_cache_zalloc() and __initbuf() initialises b_li_list
but not b_list, leaving b_list.next NULL, for which list_empty() is
false.  Initialise b_list alongside b_li_list so the new test means what
it says.  This also makes the existing

	ASSERT(list_empty(&bp->b_list));

in xfs_buf_delwri_queue_here() true for a freshly allocated buffer; it
would have fired on every such buffer had assertions been enabled
(libxfs/Makefile builds with -DNDEBUG unconditionally).

No caller in the tree queues a buffer twice today, so there is no
user-visible change: xfs_repair -n output and post-repair superblock
counters are unchanged across an 8-image corpus and mkfs.xfs superblock
geometry is identical.  Log recovery, which queues a buffer once per log
item that touches it, does rely on this.
---
 libxfs/libxfs_io.h | 12 ++++++++++++
 libxfs/rdwr.c      |  1 +
 2 files changed, 13 insertions(+)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 5562e292..e27922d5 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -264,6 +264,18 @@ int libxfs_buf_read_uncached(struct xfs_buftarg *targ, xfs_daddr_t daddr,
 static inline bool
 xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
 {
+	/*
+	 * If the buffer is already on a delwri list, leave it where it is.
+	 * list_add_tail() on an already-linked node relinks it at the tail
+	 * and splices every entry between its old position and the tail out
+	 * of the list, silently dropping those buffers from the submission.
+	 * The kernel guards this with _XBF_DELWRI_Q; here list membership is
+	 * an accurate predicate because both xfs_buf_delwri_submit() and
+	 * xfs_buf_delwri_cancel() remove entries with list_del_init().
+	 */
+	if (!list_empty(&bp->b_list))
+		return false;
+
 	xfs_buf_hold(bp);
 	list_add_tail(&bp->b_list, buffer_list);
 	return true;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 6c57bede..7ec6e774 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -261,6 +261,7 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 	bp->b_recur = 0;
 	bp->b_ops = NULL;
 	INIT_LIST_HEAD(&bp->b_li_list);
+	INIT_LIST_HEAD(&bp->b_list);
 
 	if (!bp->b_maps)
 		bp->b_maps = &bp->__b_map;
-- 
2.47.3

