Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3DC3A962D
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063918; cv=none; b=DvinbC3TaOU0z08vZ6oz+e0DlNqXwW1mj2Ivsj1jtqdbisEsKwyay4aWm1B1PlHhM69fhkpMszTSiCyP4QR7OSyB7ANaskXXfX2Uk+dqls3bsA0gOkt22B+TvCEpWZbo0tpj5rydvgAjBKUCEQeZ8cWEFuJMLr5pasqF7ymyNjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063918; c=relaxed/simple;
	bh=rEz9psfeAEkongil3SmU0G+3w3SklvX3viJRAx+U7Ys=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s2M+cO82xFew2cRlcoGLu7XdUPfr4v2hS8d+3uC1NEnf44/Ms8kkZVjawYHdTU4aBl66ZwjF3pkua8Ln5HlFkyIQ/mWiEpBCrrpCJaMXnNvXwQnvFGUhZHdaNUT1g2G6gP4U5PKFS4WTipkzM2FXBR6rJBLV80Gmi+QR+oq4wj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BlBM9QoL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BlBM9QoL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773063916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNLGmDAQIHSiMk1Pn92+Z9ygkS8ciDlfVR2AGbktuQQ=;
	b=BlBM9QoLcK2MDyqnKtoKhNhZMC0cji9AhoHdnr6F+neS2aBEL59CgO2WB7qi21oBp1NGk6
	jVWECVfWj0O8thWY4nma7BdnyuaiI156fzaBQnuRk+6WCHQwo5/9L5BkeKNOEwbDLmjSWp
	dQUdG8facIcp7zOLSDCZ7LNte58CqB4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-262-rZY9xdcWPOyYgzJJwKd9VA-1; Mon,
 09 Mar 2026 09:45:12 -0400
X-MC-Unique: rZY9xdcWPOyYgzJJwKd9VA-1
X-Mimecast-MFC-AGG-ID: rZY9xdcWPOyYgzJJwKd9VA_1773063912
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D954C195605A;
	Mon,  9 Mar 2026 13:45:11 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.89.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5D7101800361;
	Mon,  9 Mar 2026 13:45:11 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 5/8] xfs: look up cow fork extent earlier for buffered iomap_begin
Date: Mon,  9 Mar 2026 09:45:03 -0400
Message-ID: <20260309134506.167663-6-bfoster@redhat.com>
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

To further isolate the need for flushing for zero range, we need to
know whether a hole in the data fork is fronted by blocks in the COW
fork or not. COW fork lookup currently occurs further down in the
function, after the zero range case is handled.

As a preparation step, lift the COW fork extent lookup to earlier in
the function, at the same time as the data fork lookup. Only the
lookup logic is lifted. The COW fork branch/reporting logic remains
as is to avoid any observable behavior change from an iomap
reporting perspective.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 966fb9d8b9df..0f44d9aef25b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1830,14 +1830,29 @@ xfs_buffered_write_iomap_begin(
 		goto out_unlock;
 
 	/*
-	 * Search the data fork first to look up our source mapping.  We
-	 * always need the data fork map, as we have to return it to the
-	 * iomap code so that the higher level write code can read data in to
-	 * perform read-modify-write cycles for unaligned writes.
+	 * Search the data fork first to look up our source mapping. We always
+	 * need the data fork map, as we have to return it to the iomap code so
+	 * that the higher level write code can read data in to perform
+	 * read-modify-write cycles for unaligned writes.
+	 *
+	 * Then search the COW fork extent list even if we did not find a data
+	 * fork extent. This serves two purposes: first this implements the
+	 * speculative preallocation using cowextsize, so that we also unshare
+	 * block adjacent to shared blocks instead of just the shared blocks
+	 * themselves. Second the lookup in the extent list is generally faster
+	 * than going out to the shared extent tree.
 	 */
 	eof = !xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap);
 	if (eof)
 		imap.br_startoff = end_fsb; /* fake hole until the end */
+	if (xfs_is_cow_inode(ip)) {
+		if (!ip->i_cowfp) {
+			ASSERT(!xfs_is_reflink_inode(ip));
+			xfs_ifork_init_cow(ip);
+		}
+		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
+				&ccur, &cmap);
+	}
 
 	/* We never need to allocate blocks for unsharing a hole. */
 	if ((flags & IOMAP_UNSHARE) && imap.br_startoff > offset_fsb) {
@@ -1904,24 +1919,13 @@ xfs_buffered_write_iomap_begin(
 	}
 
 	/*
-	 * Search the COW fork extent list even if we did not find a data fork
-	 * extent.  This serves two purposes: first this implements the
-	 * speculative preallocation using cowextsize, so that we also unshare
-	 * block adjacent to shared blocks instead of just the shared blocks
-	 * themselves.  Second the lookup in the extent list is generally faster
-	 * than going out to the shared extent tree.
+	 * Now that we've handled any operation specific special cases, at this
+	 * point we can report a COW mapping if found.
 	 */
-	if (xfs_is_cow_inode(ip)) {
-		if (!ip->i_cowfp) {
-			ASSERT(!xfs_is_reflink_inode(ip));
-			xfs_ifork_init_cow(ip);
-		}
-		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
-				&ccur, &cmap);
-		if (!cow_eof && cmap.br_startoff <= offset_fsb) {
-			trace_xfs_reflink_cow_found(ip, &cmap);
-			goto found_cow;
-		}
+	if (xfs_is_cow_inode(ip) &&
+	    !cow_eof && cmap.br_startoff <= offset_fsb) {
+		trace_xfs_reflink_cow_found(ip, &cmap);
+		goto found_cow;
 	}
 
 	if (imap.br_startoff <= offset_fsb) {
-- 
2.52.0

