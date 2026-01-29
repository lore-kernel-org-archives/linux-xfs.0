Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8033148B7
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 15:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769701834; cv=none; b=IigS60wUq52KOZuU1fqbXpXH3pxMwfRmphUSTc8EvxQczfWxvyEpadyF4jyKM3ASOqhVCFF/adBLdTeEjOAL/6C7WyiDdgyRg4A9ESAn/P4pKsKxq8+gRB1K5sc9oOMqthAIht3u/PhmjcU3lIO27g4R0xfQSf4DJ0sxnT6rx7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769701834; c=relaxed/simple;
	bh=eVvW314NMz6q7aUpTB5n9mSdcYYCeGxh5SHdVuXkdBM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h900/bcfzYj7nsYZ+mROKq3M5gmrIAGZxeCjCFEoXlnGiTGc16PJ8iTJFI0OrjvGMFLrllXPfixlHxrjbyknJ3A3SNcmE7zD7TcXpmaAOsmc40LCm3IrRGEjJkVPrIIw8SoSk0qZtrTSS2PVepAT5p74asPHt0/qepA72Sk3Cog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IqkkSnSC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IqkkSnSC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769701832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=InLw1uWk9OoqU9MQKvV2se6+GLu90UsaDut5igx0LBM=;
	b=IqkkSnSCiTy8GRXLoVWB7HI4aj+UOTiogJTooa+t2b6OTnx/+iOK7t++iJSZpC9gs8rynt
	zTNh26NASrmUKdwTS8u82CUQjBon2OQUf7DNEoftmUXVxvMDClIROI19VnOj1NkqKmvs65
	8eWvKnMEIn0vHOfiBtuuGhrk9X/uGxY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-FYr3FdUXOy67ptaH21aNWg-1; Thu,
 29 Jan 2026 10:50:31 -0500
X-MC-Unique: FYr3FdUXOy67ptaH21aNWg-1
X-Mimecast-MFC-AGG-ID: FYr3FdUXOy67ptaH21aNWg_1769701830
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3E211956052;
	Thu, 29 Jan 2026 15:50:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.81.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 76F091800109;
	Thu, 29 Jan 2026 15:50:29 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush into xfs
Date: Thu, 29 Jan 2026 10:50:24 -0500
Message-ID: <20260129155028.141110-2-bfoster@redhat.com>
In-Reply-To: <20260129155028.141110-1-bfoster@redhat.com>
References: <20260129155028.141110-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

iomap zero range has a wart in that it also flushes dirty pagecache
over hole mappings (rather than only unwritten mappings). This was
included to accommodate a quirk in XFS where COW fork preallocation
can exist over a hole in the data fork, and the associated range is
reported as a hole. This is because the range actually is a hole,
but XFS also has an optimization where if COW fork blocks exist for
a range being written to, those blocks are used regardless of
whether the data fork blocks are shared or not. For zeroing, COW
fork blocks over a data fork hole are only relevant if the range is
dirty in pagecache, otherwise the range is already considered
zeroed.

The easiest way to deal with this corner case is to flush the
pagecache to trigger COW remapping into the data fork, and then
operate on the updated on-disk state. The problem is that ext4
cannot accommodate a flush from this context due to being a
transaction deadlock vector.

Outside of the hole quirk, ext4 can avoid the flush for zero range
by using the recently introduced folio batch lookup mechanism for
unwritten mappings. Therefore, take the next logical step and lift
the hole handling logic into the XFS iomap_begin handler. iomap will
still flush on unwritten mappings without a folio batch, and XFS
will flush and retry mapping lookups in the case where it would
otherwise report a hole with dirty pagecache during a zero range.

Note that this is intended to be a fairly straightforward lift and
otherwise not change behavior. Now that the flush exists within XFS,
follow on patches can further optimize it.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c |  2 +-
 fs/xfs/xfs_iomap.c     | 25 ++++++++++++++++++++++---
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6beb876658c0..807384d72311 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1620,7 +1620,7 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		     srcmap->type == IOMAP_UNWRITTEN)) {
 			s64 status;
 
-			if (range_dirty) {
+			if (range_dirty && srcmap->type == IOMAP_UNWRITTEN) {
 				range_dirty = false;
 				status = iomap_zero_iter_flush_and_stale(&iter);
 			} else {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 37a1b33e9045..896d0dd07613 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1790,6 +1790,7 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
+restart:
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -1817,9 +1818,27 @@ xfs_buffered_write_iomap_begin(
 	if (eof)
 		imap.br_startoff = end_fsb; /* fake hole until the end */
 
-	/* We never need to allocate blocks for zeroing or unsharing a hole. */
-	if ((flags & (IOMAP_UNSHARE | IOMAP_ZERO)) &&
-	    imap.br_startoff > offset_fsb) {
+	/* We never need to allocate blocks for unsharing a hole. */
+	if ((flags & IOMAP_UNSHARE) && imap.br_startoff > offset_fsb) {
+		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
+		goto out_unlock;
+	}
+
+	/*
+	 * We may need to zero over a hole in the data fork if it's fronted by
+	 * COW blocks and dirty pagecache. To make sure zeroing occurs, force
+	 * writeback to remap pending blocks and restart the lookup.
+	 */
+	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
+		if (filemap_range_needs_writeback(inode->i_mapping, offset,
+						  offset + count - 1)) {
+			xfs_iunlock(ip, lockmode);
+			error = filemap_write_and_wait_range(inode->i_mapping,
+						offset, offset + count - 1);
+			if (error)
+				return error;
+			goto restart;
+		}
 		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
 		goto out_unlock;
 	}
-- 
2.52.0

