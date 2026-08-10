Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738072594BD
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376283; cv=none; b=C8ybu6M7rBN5tyYBorvgOYBQ8/3xBFaljHFmSwYcxs/G/HsRRQ+g4Ok4w+DTP1VwJELB7hSDZpJb9Nr4g1vGvGWUCwvCPhbwyLHCyUj0CX1G4kYKIt/Msuw2B/OTnOyUKTdriSBfnTtqFvk+iOFm/aaOzNQEaHZUyP5U1izPK9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376283; c=relaxed/simple;
	bh=ffsb2HfhU0CXvpY3T2kJlcMJNLeHddcvCfHTtY1izDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etDkMuLqUepp3Eu2Z9QN1hyZVkoLbCam0b7gUXTakoelbUe386GkOa/xCFaZ6UeVCWBIluwFh2CCvfxkqNZIqUOeNxW1OZwMqrYtuVQ6LEcLjBD7xfQzGVuESpckklfio5V8P5lUQO8kxX0V+Fyy+bf6DPwmEgD/6KJbqWypOcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dm1v5vGD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dm1v5vGD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Gpn4fAjKSjxL+VOWOWzOFXPBEw6z7yG77eGHqZRMu14=; b=dm1v5vGDzcthihvwX187Ai3MDu
	pQ+wrYX+rdFFNzfcar33jtNrA3mm6BOGc9NLr0DH+Dkbzp/270L7xz+xpi9QWdrj1V/3BKA7jt09f
	bNISYdnElPEEiE8VV5sIUe+kL7RWkftx0cHdFEr/R914D17jlMSDcsBnVA34ciqqqwBijoyOXsKIi
	vMYKqYLwp7FwcIMz9poc0CdpTV/cYOjEQzXOZnVSmosUfxWomh8tujq9Rrw5GvA9hx4YQGPuR60Qx
	3bbvhOAB0vngVcyuBlLpemzE25FvUsZiHy3sdklh1CltwfJrz2BJN/DvyeWaGH/e0mWCrZ1TP//Uw
	ihI73V1g==;
Received: from [12.156.71.108] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtS4f-0000000CHon-0NeJ;
	Mon, 10 Aug 2026 15:38:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: fix zoned write iomap flags assignments
Date: Mon, 10 Aug 2026 08:37:44 -0700
Message-ID: <20260810153759.466417-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260810153759.466417-1-hch@lst.de>
References: <20260810153759.466417-1-hch@lst.de>
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
Signed-off-by: Christoph Hellwig <hch@lst.de>
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

