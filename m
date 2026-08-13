Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64620485504
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786632992; cv=none; b=K4GI/0i9Y7ZBLJHoVrheKlmwY6i0eltptB8Nd1mkLLzUFbj8f9r9E0zKGDzIL2spBmG5LEQBRXqqYCaN/R40j3L8v1lHefzN0q+v7wQh0jPskgvx2kKfb+beaJMExyv5UXZ3mE2vY2lFtJhpeoAPVotQy876QT/zoJ4ZsAfd3XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786632992; c=relaxed/simple;
	bh=/vaQiwIX72kc7+HLI5wMIEkC+ddx2aC3jCXlgNqS0go=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aN7IefqRFoh11QY2QKSmV/SOB1Z2e6iub9vwzrdU6mF0Oj2Qr9UFl4zzZBj5YcJctVFWhEGNH+ZJoeQl07JqCw7dTg5nmV0khrvLQhKT5bNXtylj9jFWpnm0IXJERrfgL4Fo6J96TLgxs5zJHb/cmk+0cuOkg6fiHOxSHPI7xWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0kU0az2I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0kU0az2I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MaNkcNn5ArR9BoZ5CBw+wAx8Yzh5z8jxpNzcwBiDC/s=; b=0kU0az2ILga56HFuSfVvKq0shw
	KlPCvzUaKVI6x0rghkZRzvl2b+fPqQ/mYoBRnB5YgUXIUCwct4/bqI1yp3wtw61fVstMkA6YjjcwT
	dVitJvGGpTbmB7ov0pqRI4IWeMUQpTPejPNDmSOo0+VfUuP05J+4fn34U7hCqLk4ZdCa/kpSd7Tdg
	a99kHzYk6BQTvmHD12AuhDUcj28ko13vwpqrek04La5foOHpVXBM0U1ABCKBJCPZ1IiDDOoicUJ0O
	ZyzCJJtvfqDE1ttdojgGzpPaX+0SNyb1K3out35mf0DRNvJx6oYEGTHAZUjR2cVqdAEDXbl41BnXi
	DJVt7/+A==;
Received: from [2001:4bb8:2cb:3bb6:f72b:dcb5:48fd:91f6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuWqy-00000000sXC-1SxZ;
	Thu, 13 Aug 2026 14:56:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: hans.holmberg@wdc.com,
	dlemoal@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: restore bi_bdev in xfs_zone_gc_write_chunk
Date: Thu, 13 Aug 2026 16:56:12 +0200
Message-ID: <20260813145617.419537-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_zone_gc_write_chunk relies on bi_bdev to still be valid, which is not
true when XFS is used on top of a stacked block device.  This can lead to
misdirected GC writes, writing of plain text when using dm-crypt, or
miscalculated I/O limits in xfs_zone_gc_split_write.

Fix this by reassigning bi_bdev.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 7ab8f2218c6a..5cc5ad1e3483 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -869,6 +869,11 @@ xfs_zone_gc_write_chunk(
 	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 	list_move_tail(&chunk->entry, &data->writing);
 
+	/*
+	 * If we run on top of stacked block device, the read I/O might have
+	 * reset bi_bdev, restore it to the one we want.
+	 */
+	bio_set_dev(&chunk->bio, mp->m_rtdev_targp->bt_bdev);
 	bio_reuse(&chunk->bio, REQ_OP_WRITE);
 	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
 		xfs_zone_gc_submit_write(data, split_chunk);
-- 
2.53.0

