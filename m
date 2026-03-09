Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B683C1995
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063917; cv=none; b=QQiM+oPnXPpAMHDW7JJmZ0blNok0tpuOgRIhj8T2Telw1PgGJx5SCryMTe3opMyLkAmIVo2vVIxTmd0zTMxLQPMG0ugGyKmCVXMOE1fPpdU+BJSQ2DbJTtWhsgD7swWKIBhLUYoaUIKEYjAz/HzwLUS/ephtpjRexcmx1LHtrTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063917; c=relaxed/simple;
	bh=ia5t6bkAC2hlw8BRoBOBjDmssVZXI35KjSwLRrSR+MU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGVhx4S+XYO0Mivbi46RX3voR4yIEgSZ0DxEisYAOeuFCCrL3tjjrJ147clX2uPAYwVS8dM2E4A1O5BCtk7fcxb1F0Dh0iMxMdgIWP403egK+SLknik/pr4ssvQ9b8sGW0bLF+itOMFJOCR5VnK1XyW2liR2FCw3LzYTyryYB7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e/PWJOvm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e/PWJOvm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773063915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UDi5ESx3ObW7CfD/QyaeaZusmZj7k1+ywq7qGZwBJ/o=;
	b=e/PWJOvmCj6Ttcfup4OpG07sLeiUzZyznMbSb9pYyiMNaShbBJVdT/yYLFRtFliTwNZ1LP
	J0FgSs/clm9KBJ8CmK08rO47Td3u+xeuy8gELJ7GL8m9xz5FD1N9vkLAh480zir+YzS8KE
	wxEg5ZtSUB3u74LIGFF+FHafwuDGiuQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-qwV08D3-MIiaMlbLFEB3rw-1; Mon,
 09 Mar 2026 09:45:14 -0400
X-MC-Unique: qwV08D3-MIiaMlbLFEB3rw-1
X-Mimecast-MFC-AGG-ID: qwV08D3-MIiaMlbLFEB3rw_1773063913
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DDCA1800611;
	Mon,  9 Mar 2026 13:45:13 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.89.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D104A180035F;
	Mon,  9 Mar 2026 13:45:12 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 7/8] xfs: replace zero range flush with folio batch
Date: Mon,  9 Mar 2026 09:45:05 -0400
Message-ID: <20260309134506.167663-8-bfoster@redhat.com>
In-Reply-To: <20260309134506.167663-1-bfoster@redhat.com>
References: <20260309134506.167663-1-bfoster@redhat.com>
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
index ce342b9ce2f0..df240931f07a 100644
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

