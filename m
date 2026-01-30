Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF06183CC3
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750444; cv=none; b=lWuPlsBUxkUZWlw/yMs1vCabUOoIeZqCB8QYyXXMuO6zUmcFLqkY3eMRgvrdaH6SVjns5Aa6t+z+U+Af+O/x1zyUWA/5jj9vxwLy0FuauyaJb/ChKa7sEp/DkwT5Ci0v2asRKJ/CHhymxfBimfnl5X1cDgzCmMS8Spw5BVkq6Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750444; c=relaxed/simple;
	bh=xnht0mFjwzY5cb4hTxL3FdqcHEXRozC3+Qsi0i5n3HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WR/KMehVAsnnn7Ltw40DpROxJuDXvGZx6nOl/kwBbv8y/7xfxMUibE5kcUKfeEpYtoKcMPiuckV8OOultPEHNkAKL9qhSg39v7GRadcanz3spjcK4mEFQ4eKY4R1Ac4G+Hi2IONEngKP9p+2eWziodrJug2aL4I9Zw9JkO9UqKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0p1IXLxn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0p1IXLxn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7Xx7LkTa2sB7b1SVqdC7Sk4vGUaVBVAbJ20VPVv8JOM=; b=0p1IXLxnVb40iBYNCu6/UWNt/6
	I4+4qySWaPTQjUrJ/DOutiiG8HF6Vn/vWMp8WxVwnE/VvKdUSsS0N/QOGzfQeu6a+wR0LMBJfHZth
	i1qyzGhZETD8GzexzZ39tQc01zhD4VWUHY/uuldMitXHoRNSYbWwp8x2yUWtXtLkKfjfeeIt1X4JV
	0By8fxDEWSIQLiriNpSqcudLrhRL/Ben3iURSYbbH2+8L9wBU/59U7N0LWBt/x8TUU5z5RI6L894Q
	EaDD/biNrJq5B5QnjwfO6WG0eJKvNa5mffD9XgwFyrpEicx2ZK+MnlFWVLb2K/PFps2tlaFOGcYCz
	v7rccW4Q==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgvy-000000013If-0bsy;
	Fri, 30 Jan 2026 05:20:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 07/11] xfs: don't mark all discard issued by zoned GC as sync
Date: Fri, 30 Jan 2026 06:19:22 +0100
Message-ID: <20260130052012.171568-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Discard are not usually sync when issued from zoned garbage collection,
so drop the REQ_SYNC flag.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 7bdc5043cc1a..60964c926f9f 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -905,7 +905,8 @@ xfs_zone_gc_prepare_reset(
 	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
 		if (!bdev_max_discard_sectors(bio->bi_bdev))
 			return false;
-		bio->bi_opf = REQ_OP_DISCARD | REQ_SYNC;
+		bio->bi_opf &= ~REQ_OP_ZONE_RESET;
+		bio->bi_opf |= REQ_OP_DISCARD;
 		bio->bi_iter.bi_size =
 			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
 	}
-- 
2.47.3

