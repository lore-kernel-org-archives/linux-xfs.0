Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4EA1F4C8B
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 13:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498966; cv=none; b=PALXu5sViCi2xL41B2aHJnGp33g4lNgNmEwxYtcDnWpJiH8TpRszYpSP+aivJBX45RysUMxRrFjuRVMHwH2o9vSaIVpOxKnHYZeLqvmbvS3T4J7hkrTbggUkgwnjIqbYscI8Jnc7uNzYl7FlJ7znDaF+OGiKuDGpBjSZ0Dx+ZOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498966; c=relaxed/simple;
	bh=UF8QDKcBj8JnkX14TEtuRUIdtMCLQ2j7WWNpgXkjmNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNY2nSpbsad503D6uXXS+C7IXSWMIzXf7JNNP61NJTTaeXmMLB0IXieIJQIqn4G3ZtESjvCVrXj2ugnkG2DpqiilmI7tS4x1akCDtncxyRngovlcTNWKFvTGyxVztkYD129XlZBq5ZF7wsTsgIS0vsdk7fybbRdnikn/k8lWblg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MRAKb1w1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MRAKb1w1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zDrKAA2ZD/x3/1/bEfyvAedG8tOXZaxk1l6cH5OtHxo=;
	b=MRAKb1w1zmK8Enhwo5sOHsKk/2olID8QXnZoxoVArKeJi62ycmE5xFbmbtnFxMdKi8ITK+
	N3zOIYENXXljF6U76jWRulYuKVVDz3R+ThCK1L8yI7+geMrxp1EeGcZ5dFaf6nrhWc5ap7
	MHjF7xEzromB/svYyD1OZGYA5YY7X/Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-vaP1Z3sdN3-svEXP8nVo4g-1; Fri,
 03 Oct 2025 09:42:42 -0400
X-MC-Unique: vaP1Z3sdN3-svEXP8nVo4g-1
X-Mimecast-MFC-AGG-ID: vaP1Z3sdN3-svEXP8nVo4g_1759498961
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C2EC1956053;
	Fri,  3 Oct 2025 13:42:41 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C116419560B1;
	Fri,  3 Oct 2025 13:42:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 5/7] xfs: fill dirty folios on zero range of unwritten mappings
Date: Fri,  3 Oct 2025 09:46:39 -0400
Message-ID: <20251003134642.604736-6-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Use the iomap folio batch mechanism to select folios to zero on zero
range of unwritten mappings. Trim the resulting mapping if the batch
is filled (unlikely for current use cases) to distinguish between a
range to skip and one that requires another iteration due to a full
batch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6a05e04ad5ba..535bf3b8705d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1702,6 +1702,8 @@ xfs_buffered_write_iomap_begin(
 	struct iomap		*iomap,
 	struct iomap		*srcmap)
 {
+	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
+						     iomap);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -1773,6 +1775,7 @@ xfs_buffered_write_iomap_begin(
 	 */
 	if (flags & IOMAP_ZERO) {
 		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
+		u64 end;
 
 		if (isnullstartblock(imap.br_startblock) &&
 		    offset_fsb >= eof_fsb)
@@ -1780,6 +1783,26 @@ xfs_buffered_write_iomap_begin(
 		if (offset_fsb < eof_fsb && end_fsb > eof_fsb)
 			end_fsb = eof_fsb;
 
+		/*
+		 * Look up dirty folios for unwritten mappings within EOF.
+		 * Providing this bypasses the flush iomap uses to trigger
+		 * extent conversion when unwritten mappings have dirty
+		 * pagecache in need of zeroing.
+		 *
+		 * Trim the mapping to the end pos of the lookup, which in turn
+		 * was trimmed to the end of the batch if it became full before
+		 * the end of the mapping.
+		 */
+		if (imap.br_state == XFS_EXT_UNWRITTEN &&
+		    offset_fsb < eof_fsb) {
+			loff_t len = min(count,
+					 XFS_FSB_TO_B(mp, imap.br_blockcount));
+
+			end = iomap_fill_dirty_folios(iter, offset, len);
+			end_fsb = min_t(xfs_fileoff_t, end_fsb,
+					XFS_B_TO_FSB(mp, end));
+		}
+
 		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 	}
 
-- 
2.51.0

