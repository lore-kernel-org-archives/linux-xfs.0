Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B953E0C7C
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 16:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773246322; cv=none; b=VNdP2nO62oV4KUqcTBHOg7P3031fEc2N5aYcfWWUrZpI6uafMTxYAbIPJHyHAr7xXJzmleJbaEQqgQppIBIzsFW0NQPJrF3D0XQMzFuFVFv2SBuayM5QmGICs678nW155JOHVC/zXiAmuGnZWZ0k7HnR48TeO4Wa5IUrAoOhxFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773246322; c=relaxed/simple;
	bh=0cbq4NRIOBeZph6y+yhgLsb8T9JMy/YXXbI1V97X4nM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7ZBAAtFidtMLpSBAqTjZ47zSGU90hZdAdP+qwciXav9MhOIDsnLPrB2xmigGWu79CH3sUVOW2EaamEvwVn4Nr0YJOP9i1K+7HOUsHofn2YE4cvbGGq+ehOVV5RqiGKT8vugLsn4vR/TKQqaKTVX5RoKlD9LkQ22WXCe/IKJsRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LxHrO6l+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LxHrO6l+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773246313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=89PRDtArtZ82NJ4aEvNiQ7vUPm7wGdVP6Z2kLdVkYZk=;
	b=LxHrO6l+27vv/dNGX3W1juWzbYoUyaRLVp5eNR1vcWBD7wal9+2JZLgCvIU2haoUtXVWOH
	4klM8nwmg0sFQqM3X7+crOVJj9cAU7iOE/ocnU0UnicZZL6klv6xNGJApJws9tb9nads1W
	UN0X9yGIvbToRO89Ot7VPTFpHl337UM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-hQ6EnAYvNWSlE4ClrxwctA-1; Wed,
 11 Mar 2026 12:25:09 -0400
X-MC-Unique: hQ6EnAYvNWSlE4ClrxwctA-1
X-Mimecast-MFC-AGG-ID: hQ6EnAYvNWSlE4ClrxwctA_1773246308
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D01621800372;
	Wed, 11 Mar 2026 16:25:08 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.89.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 532C01800351;
	Wed, 11 Mar 2026 16:25:08 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 7/8] xfs: replace zero range flush with folio batch
Date: Wed, 11 Mar 2026 12:25:01 -0400
Message-ID: <20260311162502.192375-8-bfoster@redhat.com>
In-Reply-To: <20260311162502.192375-1-bfoster@redhat.com>
References: <20260311162502.192375-1-bfoster@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c |  4 ----
 fs/xfs/xfs_iomap.c     | 20 ++++++--------------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0999aca6e5cc..4422a6d477d7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1633,10 +1633,6 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
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
index 6229a0bf793b..51a55510d4a5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1781,7 +1781,6 @@ xfs_buffered_write_iomap_begin(
 {
 	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
 						     iomap);
-	struct address_space	*mapping = inode->i_mapping;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -1813,7 +1812,6 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
-restart:
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -1866,8 +1864,8 @@ xfs_buffered_write_iomap_begin(
 
 	/*
 	 * We may need to zero over a hole in the data fork if it's fronted by
-	 * COW blocks and dirty pagecache. To make sure zeroing occurs, force
-	 * writeback to remap pending blocks and restart the lookup.
+	 * COW blocks and dirty pagecache. Scan such file ranges for dirty
+	 * cache and fill the iomap batch with folios that need zeroing.
 	 */
 	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
 		loff_t	start, end;
@@ -1889,16 +1887,10 @@ xfs_buffered_write_iomap_begin(
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

