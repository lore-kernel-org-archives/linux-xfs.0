Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EC13AA1AE
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063920; cv=none; b=NSu2KLT3myKdW+/W++9ksy5TW6Wca+KtTeuGOYrXWmtk8CKiJbM9Ll1YCQ7nCHn8IVRoOoAE40o/I5BtEvaKhqWixOvjeOOwJPLb9apcyv5b5cg8DA9qSZraDhKPUdmnZYU3eGnkBdH79fkwp32eDqcCG1hAMXkYagZjCABGZQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063920; c=relaxed/simple;
	bh=aTUUxz2YgVUwOiQqZ7tIlp6NO1cqBn8ZKI/Fd8HBqqU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pt2C5w4OYbRa31jL9L0mkM11L9LyrnKm/Rn/96BOMhK2lhVTUKw8NRzcexoysvZiZHvDhPH6udWTrZe+TiNoorZuVdVrj6qTMaqxy6gIW9EPbPutRBT3BF1L11v3DAhFEYrHJnD45jdXpNb0aSEytwjfoT2uUmUwBtitxzuXAp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HO4vhPy+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HO4vhPy+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773063918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0JMW1hNhJ1/0zYpQuiyMnmCroeibaC2slxlZYv8D1xc=;
	b=HO4vhPy+Ns5K+b+BHGC+U3g0J9PDWLvbZ7IEmtRYecXEJrXmCF2F9jNZR1Xeo+O77YYW8q
	eVLaaYHrRsFfvDiRIB4zJehim8+Sh56B1MA1uYeqJR9KkFmF6BkhtnYgWbZaQZ+QUROKXH
	/RN4dSTzzEXng8lOXXK8PIEfC7o0gKU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-kDIDWbZXNS2oI5LvZMdt2g-1; Mon,
 09 Mar 2026 09:45:14 -0400
X-MC-Unique: kDIDWbZXNS2oI5LvZMdt2g-1
X-Mimecast-MFC-AGG-ID: kDIDWbZXNS2oI5LvZMdt2g_1773063914
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C28418005B2;
	Mon,  9 Mar 2026 13:45:14 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.89.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93B1B1800361;
	Mon,  9 Mar 2026 13:45:13 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 8/8] xfs: report cow mappings with dirty pagecache for iomap zero range
Date: Mon,  9 Mar 2026 09:45:06 -0400
Message-ID: <20260309134506.167663-9-bfoster@redhat.com>
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

XFS has long supported the case where it is possible to have dirty
data in pagecache backed by COW fork blocks and a hole in the data
fork. This occurs for two reasons. On reflink enabled files, COW
fork blocks are allocated with preallocation to help avoid
fragmention. Second, if a mapping lookup for a write finds blocks in
the COW fork, it consumes those blocks unconditionally. This might
mean that COW fork blocks are backed by non-shared blocks or even a
hole in the data fork, both of which are perfectly fine.

This leaves an odd corner case for zero range, however, because it
needs to distinguish between ranges that are sparse and thus do not
require zeroing and those that are not. A range backed by COW fork
blocks and a data fork hole might either be a legitimate hole in the
file or a range with pending buffered writes that will be written
back (which will remap COW fork blocks into the data fork).

This "COW fork blocks over data fork hole" situation has
historically been reported as a hole to iomap, which then has grown
a flush hack as a workaround to ensure zeroing occurs correctly. Now
that this has been lifted into the filesystem and replaced by the
dirty folio lookup mechanism, we can do better and use the pagecache
state to decide how to report the mapping. If a COW fork range
exists with dirty folios in cache, then report a typical shared
mapping. If the range is clean in cache, then we can consider the
COW blocks preallocation and call it a hole.

This doesn't fundamentally change behavior, but makes mapping
reporting more accurate. Note that this does require splitting
across the EOF boundary (similar to normal zero range) to ensure we
don't spuriously perform post-eof zeroing. iomap will warn about
zeroing beyond EOF because folios beyond i_size may not be written
back.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index df240931f07a..3bef5ea610bb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1786,6 +1786,7 @@ xfs_buffered_write_iomap_begin(
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
 	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
+	xfs_fileoff_t		eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
 	struct xfs_bmbt_irec	imap, cmap;
 	struct xfs_iext_cursor	icur, ccur;
 	xfs_fsblock_t		prealloc_blocks = 0;
@@ -1868,7 +1869,8 @@ xfs_buffered_write_iomap_begin(
 	 * cache and fill the iomap batch with folios that need zeroing.
 	 */
 	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
-		loff_t	start, end;
+		loff_t		start, end;
+		unsigned int	fbatch_count;
 
 		imap.br_blockcount = imap.br_startoff - offset_fsb;
 		imap.br_startoff = offset_fsb;
@@ -1883,15 +1885,32 @@ xfs_buffered_write_iomap_begin(
 			goto found_imap;
 		}
 
+		/* no zeroing beyond eof, so split at the boundary */
+		if (offset_fsb >= eof_fsb)
+			goto found_imap;
+		if (offset_fsb < eof_fsb && end_fsb > eof_fsb)
+			xfs_trim_extent(&imap, offset_fsb, eof_fsb - offset_fsb);
+
 		/* COW fork blocks overlap the hole */
 		xfs_trim_extent(&imap, offset_fsb,
 			    cmap.br_startoff + cmap.br_blockcount - offset_fsb);
 		start = XFS_FSB_TO_B(mp, imap.br_startoff);
 		end = XFS_FSB_TO_B(mp, imap.br_startoff + imap.br_blockcount);
-		iomap_fill_dirty_folios(iter, &start, end, &iomap_flags);
+		fbatch_count = iomap_fill_dirty_folios(iter, &start, end,
+						       &iomap_flags);
 		xfs_trim_extent(&imap, offset_fsb,
 				XFS_B_TO_FSB(mp, start) - offset_fsb);
 
+		/*
+		 * Report the COW mapping if we have folios to zero. Otherwise
+		 * ignore the COW blocks as preallocation and report a hole.
+		 */
+		if (fbatch_count) {
+			xfs_trim_extent(&cmap, imap.br_startoff,
+					imap.br_blockcount);
+			imap.br_startoff = end_fsb;	/* fake hole */
+			goto found_cow;
+		}
 		goto found_imap;
 	}
 
@@ -1901,8 +1920,6 @@ xfs_buffered_write_iomap_begin(
 	 * unwritten extent.
 	 */
 	if (flags & IOMAP_ZERO) {
-		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
-
 		if (isnullstartblock(imap.br_startblock) &&
 		    offset_fsb >= eof_fsb)
 			goto convert_delay;
-- 
2.52.0

