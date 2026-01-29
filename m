Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AF7337BBD
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769701839; cv=none; b=Yq5dyCCzIZC5s0P64ofeMAFhRsb82E5Sp2ha1mzxe1Kusr++1pyNRj/NmLBLsp4dnAxjcXIGm4LId4g8GRP0CSUe7mdoCyOiA7o1CyQlRpCkeocs6Aars6RIZ45LufyU/bjsjIGOLIN5Ard/gcsQArZtC46CzVTFe2HnhL0jpzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769701839; c=relaxed/simple;
	bh=h/SCMewyavfpnphR4mY6T2G24x4ckORWxA6knj2wQiE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=trxgr9YuGif5eEm1ZaApHe6eYf77bdE7a8WIJRqJyeut8fal/IFLP9gv8caFObNa58sNESN3YRpzDHNMODvwiM4GTKYsC8TxteNJukapBn8hPMgrOWKZ4CIyQdUI3Dz1begZkVutLO5qqPeJS9MHe3vzQXHyuttaMe5jMgfSsbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y4zNjCaz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y4zNjCaz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769701836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bypKnRu9ubTGihYr+Ex09h3pIKBDW0z1NfrUHjeZ8Fc=;
	b=Y4zNjCazBl+kiuvNjpwBF8ORRkhBgLeWfIjOhXe/v9YLUkrUW/Rz+SH19enfp2W0AjTASO
	TFePtUA9jsK5ZW+Xg5hjS412NrvgerXoDaQ6MQrwPq/UMLUSQaiEdW7sVE2JwJ3daJQ/DK
	3ppSq0dYvk8A2e3CxNLcgDAfEoD3Klg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-8oYdMvY8PFOI9xxQB6zvkA-1; Thu,
 29 Jan 2026 10:50:33 -0500
X-MC-Unique: 8oYdMvY8PFOI9xxQB6zvkA-1
X-Mimecast-MFC-AGG-ID: 8oYdMvY8PFOI9xxQB6zvkA_1769701831
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7985618005B3;
	Thu, 29 Jan 2026 15:50:31 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.81.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F1C551800840;
	Thu, 29 Jan 2026 15:50:30 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/5] xfs: look up cow fork extent earlier for buffered iomap_begin
Date: Thu, 29 Jan 2026 10:50:26 -0500
Message-ID: <20260129155028.141110-4-bfoster@redhat.com>
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
---
 fs/xfs/xfs_iomap.c | 46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 896d0dd07613..0edab7af4a10 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1809,14 +1809,29 @@ xfs_buffered_write_iomap_begin(
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
@@ -1883,24 +1898,13 @@ xfs_buffered_write_iomap_begin(
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

