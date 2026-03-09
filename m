Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E303C1977
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063915; cv=none; b=Y1+PZ7WNygju4SMfsS5yagcf5/hX5VPafD46eMb0qTzclib1dD8OKNp0tQ60Ev6RCMN0LpTyi7ePMkuY8J7j2daruvoTprq1BNqozEk+KWDvtxYzXLXQ+Toj/wKlSVRECwQ1BSHZwMT45I6YXMyQA0knrUN+i0ikesIkRsVnLIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063915; c=relaxed/simple;
	bh=/EVcC+DRH9x072XELSOFT+oprtKn3auPvCTFcr+S+Y8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TvDTp5LJXdYd2qVaPxC4zBloyheXbkF65IyOGdih4WhlDWpUdugH3hT9WIixjPKhZ6wyokKrqD/W7Pv80fJH0ssr/FpS2DRVv8UGj7XmiHbPaia+kkgbgRY15D2EMREIDOZXjW85qgZKbRBKCqUwHkptRMn2Yhc5sn6091bqi+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzopX30X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzopX30X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773063913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uxZWJgni4OV+MDNm9+Oha51+OTI4WnlF1Kzm1F34qBw=;
	b=gzopX30X0Mk/tys0ekVLzSTpDCYwNo01dhyGZ5hMMN+n0srwcgG6On4yT9cWhCUNsuTyou
	CqGytr0jiTr6ab9EmeHrhOsX6p0v9F7cBnxAbwCe4/BEhVK2+XgE6cOLh1BzLlalMCT/8H
	HZ1EPdpKsCTALZNpTOcxDmSjSk5FnVc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-38-V1qMdLXmN4uakwx7pmjXTg-1; Mon,
 09 Mar 2026 09:45:10 -0400
X-MC-Unique: V1qMdLXmN4uakwx7pmjXTg-1
X-Mimecast-MFC-AGG-ID: V1qMdLXmN4uakwx7pmjXTg_1773063909
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD9DB19560A3;
	Mon,  9 Mar 2026 13:45:08 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.89.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5CA6E180035F;
	Mon,  9 Mar 2026 13:45:08 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/8] xfs: fix iomap hole map reporting for zoned zero range
Date: Mon,  9 Mar 2026 09:44:59 -0400
Message-ID: <20260309134506.167663-2-bfoster@redhat.com>
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

The hole mapping logic for zero range in zoned mode is not quite
correct. It currently reports a hole whenever one exists in the data
fork. If the first write to a sparse range has completed and not yet
written back, the blocks exist in the COW fork as delalloc until
writeback completes, at which point they are allocated and mapped
into the data fork. If a zero range occurs on a range that has not
yet populated the data fork, we will incorrectly report it as a
hole.

Note that this currently functions correctly because we are bailed
out by the pagecache flush in iomap_zero_range(). If a hole or
unwritten mapping is reported with dirty pagecache, it assumes there
is pending data, flushes to induce any pending block
allocations/remaps, and retries the lookup. We want to remove this
hack from iomap, however, so update iomap_begin() to only report a
hole for zeroing when one exists in both forks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index be86d43044df..8c3469d2c73e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1651,14 +1651,6 @@ xfs_zoned_buffered_write_iomap_begin(
 				&smap))
 			smap.br_startoff = end_fsb; /* fake hole until EOF */
 		if (smap.br_startoff > offset_fsb) {
-			/*
-			 * We never need to allocate blocks for zeroing a hole.
-			 */
-			if (flags & IOMAP_ZERO) {
-				xfs_hole_to_iomap(ip, iomap, offset_fsb,
-						smap.br_startoff);
-				goto out_unlock;
-			}
 			end_fsb = min(end_fsb, smap.br_startoff);
 		} else {
 			end_fsb = min(end_fsb,
@@ -1690,6 +1682,16 @@ xfs_zoned_buffered_write_iomap_begin(
 	count_fsb = min3(end_fsb - offset_fsb, XFS_MAX_BMBT_EXTLEN,
 			 XFS_B_TO_FSB(mp, 1024 * PAGE_SIZE));
 
+	/*
+	 * When zeroing, don't allocate blocks for holes as they are already
+	 * zeroes, but we need to ensure that no extents exist in both the data
+	 * and COW fork to ensure this really is a hole.
+	 */
+	if ((flags & IOMAP_ZERO) && srcmap->type == IOMAP_HOLE) {
+		xfs_hole_to_iomap(ip, iomap, offset_fsb, end_fsb);
+		goto out_unlock;
+	}
+
 	/*
 	 * The block reservation is supposed to cover all blocks that the
 	 * operation could possible write, but there is a nasty corner case
-- 
2.52.0

