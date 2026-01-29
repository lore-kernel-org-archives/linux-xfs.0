Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952E2313E39
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769701840; cv=none; b=uu9JVgZqlTMtfXF1dl3dNao5mwX6iecLsuTM7Rq5eYW7bm61PGAWKLzWse1CQAqKmQkkXOWy0Bb3l3jxDVVrj5yk6sRyBeorU/EbLNj6PjHlOZ+Haiwcd0iL84DOcCU7u4bijnV1CLnlteHhZOvV4Cfk0HecX4LIeAQ74F53cw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769701840; c=relaxed/simple;
	bh=QiN6vhMYpKrmixvFZfsVjr03wit10DMQcKrz+pqH7Zg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GZqO3Aq+sVCUWMxOST/0GFe+KHJVjk4MgB8ppUpT/SxZxhOS/KbBgM0detMyv+7hy0jZPJTmxJjBuwGk/qjjM61aHmnY2L3IB55ilhnzPYRmjo9KFZ604/NS8+fCVLJT5XX9QRYVYoqyqfvIE0DpB+0oLj1KupDhqQ1OTRxd1no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YeUrBWYM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YeUrBWYM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769701837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ETxct+U0k1JHYnUxUYfwnBNddLgISExOM0VStlFt+sk=;
	b=YeUrBWYM+mgL/2DT8yk/Jdpmzu/ASVi7ynyH2dmbSuBwUngLDm9SDl5TbYK8fDdAI+m64F
	dafrdB131FOMok+Dj3ERXoBj4Iy4b65Y8pLsUAn6u0yuFKeMqbWH7ZmVeUau4HdX1CTvoK
	Yqk07GsRY7k4dOqEaTOjdFfYQoAplQA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-yXc_ZFm0MKWitx72yWpE2w-1; Thu,
 29 Jan 2026 10:50:33 -0500
X-MC-Unique: yXc_ZFm0MKWitx72yWpE2w-1
X-Mimecast-MFC-AGG-ID: yXc_ZFm0MKWitx72yWpE2w_1769701833
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5B061956046;
	Thu, 29 Jan 2026 15:50:32 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.81.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A4681800840;
	Thu, 29 Jan 2026 15:50:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 5/5] xfs: replace zero range flush with folio batch
Date: Thu, 29 Jan 2026 10:50:28 -0500
Message-ID: <20260129155028.141110-6-bfoster@redhat.com>
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

Now that the zero range pagecache flush is purely isolated to
providing zeroing correctness in this case, we can remove it and
replace it with the folio batch mechanism that is used for handling
unwritten extents.

This is still slightly odd in that XFS reports a hole vs. a mapping
that reflects the COW fork extents, but that has always been the
case in this situation and so a separate issue. We drop the iomap
warning that assumes the folio batch is always associated with
unwritten mappings, but this is mainly a development assertion as
otherwise the core iomap fbatch code doesn't care much about the
mapping type if it's handed the set of folios to process.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c |  4 ----
 fs/xfs/xfs_iomap.c     | 16 ++++------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 807384d72311..68eb4bc056b6 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1611,10 +1611,6 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	while ((ret = iomap_iter(&iter, ops)) > 0) {
 		const struct iomap *srcmap = iomap_iter_srcmap(&iter);
 
-		if (WARN_ON_ONCE((iter.iomap.flags & IOMAP_F_FOLIO_BATCH) &&
-				 srcmap->type != IOMAP_UNWRITTEN))
-			return -EIO;
-
 		if (!(iter.iomap.flags & IOMAP_F_FOLIO_BATCH) &&
 		    (srcmap->type == IOMAP_HOLE ||
 		     srcmap->type == IOMAP_UNWRITTEN)) {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0e82b4ec8264..49ab4edf5ec3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1760,7 +1760,6 @@ xfs_buffered_write_iomap_begin(
 {
 	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
 						     iomap);
-	struct address_space	*mapping = inode->i_mapping;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -1792,7 +1791,6 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
-restart:
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -1868,16 +1866,10 @@ xfs_buffered_write_iomap_begin(
 		xfs_trim_extent(&imap, offset_fsb,
 			    cmap.br_startoff + cmap.br_blockcount - offset_fsb);
 		start = XFS_FSB_TO_B(mp, imap.br_startoff);
-		end = XFS_FSB_TO_B(mp,
-				   imap.br_startoff + imap.br_blockcount) - 1;
-		if (filemap_range_needs_writeback(mapping, start, end)) {
-			xfs_iunlock(ip, lockmode);
-			error = filemap_write_and_wait_range(mapping, start,
-							     end);
-			if (error)
-				return error;
-			goto restart;
-		}
+		end = XFS_FSB_TO_B(mp, imap.br_startoff + imap.br_blockcount);
+		iomap_fill_dirty_folios(iter, &start, end, &iomap_flags);
+		xfs_trim_extent(&imap, offset_fsb,
+				XFS_B_TO_FSB(mp, start) - offset_fsb);
 
 		goto found_imap;
 	}
-- 
2.52.0

