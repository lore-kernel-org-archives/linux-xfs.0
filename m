Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E941B2D738F;
	Tue, 11 Aug 2026 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786467011; cv=none; b=SJ/VKLlSVVXfYX7dJJz8GhBzgQ/rhwBH0s4Znf3esQF9kLN9/zq73lYByhWnKlxOhaFmI4xxbCz4wWAU7mo/jZiHiXJ+vc/njs46/lFJAmPVwsZFFJ70VokEWxK6Llr0eeBOQh5L7/dBaaDcFn/naJMpJVoCl98ZZzyQW3E+exQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786467011; c=relaxed/simple;
	bh=OSGr3QXDOxI8opGvLES4VAmO/cRJ8O6OsyVof7xDYTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRl7Y/NuIhNkJXRhgNteY1ZDF1B6hfVkxrEHs5dEdB3YavL5EwXHOWdzq+ksINzmxay4EoKLa6Lr7iolk7JC8VCMG+8uz7VKO3VjRGeBS0cfRVPAV6Ze1EOXkxxwKiBK4tskTWfyuddwLy66L0CQ69djyLA9+kdIXGj/TSxB5i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nq2m/BEc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nq2m/BEc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=i4Cz4x+BNnIlXmsgUUKiJHKMjDGz09xlZV/tytqUOaY=; b=Nq2m/BEcSiJ4TM/e9f/H49dRLZ
	6ajEVXdxZftjhFJt+iRrP7N8SbhSgVwxl7R08OKCwVP7v8ck7YunUX25TBhZiGjrM7o2sk5av/ISL
	GsjrLV9pxewKwvb9/ptcQHBuorjlg2hiv67wD7UH7lCz7bBNEKKGxj1QluxEbLEZTa6nbbB9IQMrj
	WxTIqZH1FyjDNMzGsF7Dsf2AAqYiIP1mJjg/e6/DwjY+Rl8cx6A/7XEm9/pP1STyQ0lDTOxjIFyQ3
	9C9+0cbXtF+7ZkYwI36pIGCo+KM6VfcAMVV7NLtRBLmb3A/z0bN01UJzsyshgMGGsIcC7DoPJW5L1
	bFZPnsnA==;
Received: from [129.253.192.68] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtpfz-0000000EYNT-23CN;
	Tue, 11 Aug 2026 16:50:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 3/5] xfs: fix zoned write iomap flags assignments
Date: Tue, 11 Aug 2026 10:48:39 -0600
Message-ID: <20260811164912.124416-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260811164912.124416-1-hch@lst.de>
References: <20260811164912.124416-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Don't overwrite IOMAP_F_DIRTY with IOMAP_F_ANON_WRITE, but ensure both
flags are set instead.

Note that in practice this is harmless as all zoned writes force a metadata
transaction anyway, but incorrectly assigned flags are still a landmine
that will cause problems at some point.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Cc: <stable@vger.kernel.org> # v6.15
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c  | 3 +--
 fs/xfs/xfs_iomap.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c80f05507373..9506cd8d15e6 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -634,11 +634,10 @@ xfs_zoned_map_blocks(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	wpc->iomap.type = IOMAP_MAPPED;
-	wpc->iomap.flags = IOMAP_F_DIRTY;
 	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
 	wpc->iomap.offset = offset;
 	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
-	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
+	wpc->iomap.flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 
 	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
 	return 0;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 225c3de88d03..9fa9aa33745f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1081,11 +1081,10 @@ xfs_zoned_direct_write_iomap_begin(
 	}
 
 	iomap->type = IOMAP_MAPPED;
-	iomap->flags = IOMAP_F_DIRTY;
 	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
 	iomap->offset = offset;
 	iomap->length = length;
-	iomap->flags = IOMAP_F_ANON_WRITE;
+	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 	return 0;
 }
 
-- 
2.53.0

