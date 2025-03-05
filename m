Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F1E24C065
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183535; cv=none; b=ZAey2re4KJDTUPI9YBoBEKFDhobvTU3IAoUP/nRWM5AagUY0sCFfCreNk21e+X5rzI584JbDdv0HDTy3inp3q6NX4c7RFugqBeT9u07rGJUxG6chn7PsmQDtqkE1y2+MRQO35oRiAG82PPKqKxUVDYsACPDaRlKuteWGvKgm9zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183535; c=relaxed/simple;
	bh=jH8xYyWdrS/f+mes1+Lz2MYeJcplOu8H5nErCYr8Fcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oshMY4siuhaRLTIislcxXpiq7m9XE+FKfP4wvmVfw6RgJbGdd2yDlA7yiPX82VWhoDqfMWPKVe3BabAhghRkafPIzFPMXCMO3uF49qydHKmzxIiytRi0TQQPS0PVcjUo1JSEPCbfGFaTVAm2CYZoe3gwSK1k9dXKCH7AJEPXviQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TyLh/AJx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TyLh/AJx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+as5Rra19jF7aKj2oyUncN1Vc+WhmMOc1AfmzuTg+6A=; b=TyLh/AJxBbeNGJbtu01HtDpq69
	O1xWcQqdbeNLoKXcYATpacB7Ujyhi6Vr11czim7HcBBhKbEyvcLghL9CYXKrATkKaTJ+Cao8Z7ADx
	vKGeu4sbg52rMbKEzbKCdtZqCOIONyflrRXdJjyslao9Ryka4yZvMmJak7FjjsFM16wkgYYZVr/kD
	GOykS/JmKdn3CwGbdfWyAV1XKg4CX19dgVxTiZugAwXvbJ0c/cLWnmzYYi+mzjrvBp/Fn7sLN2eg2
	LGD6D4lWjNr5aZKLHFvq8iMlWt3YPfi5jAw/U9HMnqrYdTHaNUHCup2ERYGOUY3wC1v2izMoj1pyT
	XtZ2HUlA==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNN-00000008HoY-1SkJ;
	Wed, 05 Mar 2025 14:05:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/12] xfs: add a fast path to xfs_buf_zero when b_addr is set
Date: Wed,  5 Mar 2025 07:05:19 -0700
Message-ID: <20250305140532.158563-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250305140532.158563-1-hch@lst.de>
References: <20250305140532.158563-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No need to walk the page list if bp->b_addr is valid.  That also means
b_offset doesn't need to be taken into account in the unmapped loop as
b_offset is only set for kmem backed buffers which are always mapped.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5d560e9073f4..ba0bdff3ad57 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1633,13 +1633,18 @@ xfs_buf_zero(
 {
 	size_t			bend;
 
+	if (bp->b_addr) {
+		memset(bp->b_addr + boff, 0, bsize);
+		return;
+	}
+
 	bend = boff + bsize;
 	while (boff < bend) {
 		struct page	*page;
 		int		page_index, page_offset, csize;
 
-		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
-		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
+		page_index = boff >> PAGE_SHIFT;
+		page_offset = boff & ~PAGE_MASK;
 		page = bp->b_pages[page_index];
 		csize = min_t(size_t, PAGE_SIZE - page_offset,
 				      BBTOB(bp->b_length) - boff);
-- 
2.45.2

