Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315FE1D619E
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157380; cv=none; b=OoqQNPGoW2y/kJhDW71ujdSF77wwXgZ90mbATxW3kE1agGHaAVipFcjKBEPe9SBZl3EfqGeisrHNBfZ9i4yrKLrsVX4OJrelS3WkAVuZmoh67Jur9bwZu+akfgjFUefsmCU6dOb5IcqCRuLl5xSg5UH/CJb7P4XOEJE43N00SkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157380; c=relaxed/simple;
	bh=g3LZ2nIUmjjDxk7BB4on3sLforYBouXid4zHyXIr0mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkiV5/UMu0YXuXDPKnGRw25upluIhJGkyta/Z3IujFk1Pw7jUxCQwXdLNfRQJiM6iWlU8UNX9JQ2ZWRauo82V2g9dst3qH9X8DnytgTL/f4sk2C+6syAwG4xJpKEDY6wwgbHwx2wn8ryLpOAsVfDeYt7R5G6ixIODKBuHnt/KKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UXH9j2pw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UXH9j2pw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PX1VncT4RmAtddDaB9jL14vC4dC3UJinYNv4hMCmyDs=; b=UXH9j2pwOLV2KQPQFMftzhTDBS
	JwofxSTn5DFF//4Bm/VrbYD9NXk6bk1O0wjsPDwyYMOS3flYQcFj9U6lN++1fUfbSw/Egaw7w9IBp
	jmaGaTJ/9c9bo9TtOfJUTSB5yarZWFRFl8icPP8WCrqUm0D3Jgn2YhCgDfiMXTjWgEclfiSuFsMq6
	nuZwWluRHzc3mkXngAbnvCs1bHDX9dip1A3KzebYTOi1p0JhxJnRhiz/hdgNYg3QMo6WSYKQaLZIV
	x5su7ZscOp5SGSEnh0rF10Pu6pVXZleFx25HKWXRiJ9D1RRES/BJGUFtrOaWIumK4XibtnEZyaLeu
	qR3QAsqA==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqL-00000000lC5-1POS;
	Mon, 06 Jan 2025 09:56:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/15] xfs: fix a double completion for buffers on in-memory targets
Date: Mon,  6 Jan 2025 10:54:38 +0100
Message-ID: <20250106095613.847700-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__xfs_buf_submit calls xfs_buf_ioend when b_io_remaining hits zero.  For
in-memory buftargs b_io_remaining is never incremented from it's initial
value of 1, so this always happens.  Thus the extra call to xfs_buf_ioend
in _xfs_buf_ioapply causes a double completion.  Fortunately
__xfs_buf_submit is only used for synchronous reads on in-memory buftargs
due to the peculiarities of how they work, so this is mostly harmless and
just causes a little extra work to be done.

Fixes: 5076a6040ca1 ("xfs: support in-memory buffer cache targets")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aa63b8efd782..787caf0c3254 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1656,10 +1656,8 @@ _xfs_buf_ioapply(
 	op |= REQ_META;
 
 	/* in-memory targets are directly mapped, no IO required. */
-	if (xfs_buftarg_is_mem(bp->b_target)) {
-		xfs_buf_ioend(bp);
+	if (xfs_buftarg_is_mem(bp->b_target))
 		return;
-	}
 
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
-- 
2.45.2

