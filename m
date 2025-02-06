Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920BC1FDA85
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824345; cv=none; b=RQ37Ys2GD/LDjaIxlNOIMwrYKWWz8WYWvO57lx2gNeQ8zh29maV6W62qEgRoTGsDztZ9JsY+owwxzCXe+KI/YJW7TBv0hlDcvigSLIdXHS71RhJqqVIUqaCYq3sXQsyjLr46kTtWzKBG9desaTYqEtPfgQfiZ5UUf2s6w7rmHYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824345; c=relaxed/simple;
	bh=vmNRTURLdGNZaUDTjqV4CNADXFNv//lzqE3SNgcbdEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoEmZJmXA4E+t5x4iiaNwzZBHqBKRKQSmi5/QZK4yKWRoLt7JvGZ0Ry/IML2JcZTReHIEx72WMpDrVRC/ysScaYPefvdcMhc44HgpNLD9fEnIM4GC0GuWydwezLjSQZmQlmOIp6/4pPYfUTr74MQKFMcHB65T/vsqnUBe/srBW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0APnpIKe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0APnpIKe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7nIoXU1fzrsyO4pEfINcVHOwXoSsuhwlWkikBrbF0dE=; b=0APnpIKe6l4/DXiaVFyvpBS21A
	7pBLW+9SemUnCgKXdwNj5L0rjC3Sosp+/437clbkRG2Ee7l2ZwS4Aab8+5LRQBdXYqzKyfAFPiggo
	q56jEDc47Q1Q7GC7JWkMIcIGTHHTF4CTN9OS//twGvlVFIZpkc4xZYedU8o/NjOgTjd4qh9nxxd22
	YEKkFodP/CHQSXG5WUo4Vd7X9dVOgdBDldr9cOKTg+dvEy4jm6FlF1+OM9ZV4prGa7QyeNgW60lBP
	ERwHUR8kUHKx1FBkuqKBawy42bX6VKcUWc/K3McVorRUQK7ESiT9f+iY2lQ/GFYEYcRLlbaEHvIr0
	8l432uTQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvdv-00000005QFq-2zeB;
	Thu, 06 Feb 2025 06:45:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/43] xfs: reduce metafile reservations
Date: Thu,  6 Feb 2025 07:44:27 +0100
Message-ID: <20250206064511.2323878-12-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no point in reserving more space than actually available
on the data device for the worst case scenario that is unlikely to
happen.  Reserve at most 1/4th of the data device blocks, which is
still a heuristic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_metafile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index 88f011750add..225923e463c4 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -260,6 +260,7 @@ xfs_metafile_resv_init(
 	struct xfs_rtgroup	*rtg = NULL;
 	xfs_filblks_t		used = 0, target = 0;
 	xfs_filblks_t		hidden_space;
+	xfs_rfsblock_t		dblocks_avail = mp->m_sb.sb_dblocks / 4;
 	int			error = 0;
 
 	if (!xfs_has_metadir(mp))
@@ -297,6 +298,8 @@ xfs_metafile_resv_init(
 	 */
 	if (used > target)
 		target = used;
+	else if (target > dblocks_avail)
+		target = dblocks_avail;
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);
-- 
2.45.2

