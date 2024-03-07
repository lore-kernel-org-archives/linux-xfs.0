Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C613C12DD99;
	Thu,  7 Mar 2024 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824327; cv=none; b=KtziJoK0vy416xJmSTfwGjQg3PkRNR5oQWXMwaDs4fOHZYE1mjlJ4p4fbGVenRKSKhP0AZwLNDSqF4yTSPiwpxNinF+ZzmLgql0p4LwwN0QzTh/Y1wY1H08TMcSG8uAXC5Pwh1ZEuufSxJZO5LddHU3pm9nrBibg4kUAlXIT+RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824327; c=relaxed/simple;
	bh=as6eEroskOLEchsef29Ei/N8XvJhpIrN4Y1Oes1eamc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=si3WMqw2VRkZp1emp75ytUF/eI8qxkWPBBXX8m/dVdj6zWZy9tbAy7zI390HCQh3M89ooXfyGT2Ph4AhJ7bNinTnJd7Lx5jW8nHjrMJN9/F5Azl30tI21qfJkC/D+EpVzEpqHyFDDB+gzkOqiHCMDZTLnvLAh4/vnZAAQcVAeSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0dzOYaCs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0dzOYaCs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TW6U45LMqo70ibxXeynwYboB+abUkfYEFYwo0rLd1po=; b=0dzOYaCskszw2282+GkGRnddaV
	R3iNZrOZx2tgWUSgvUXnlAh5Kla6p89sA8t0EUgGh8ssrrxZdjjGU01y3g6lb5TfUJxSkPWuJhcGH
	KMHJBtXt6OK/7E3zPcH+KcXbNxTPtAnawVlTm+7jmQN5pQqniMepZJjJxszTP1ZEMXKlSuinZ9J3K
	kRcj1tFO2A++RyeHp3SnTuQZZ5nOe1LKovpEtUxw6k9WEaJLzjLw69Rr0z62T1vCqd5m6jDG4FXl7
	bFfZ5T4zVNUHY9WcA6O5CXJSYwQd8Na1BDqHIvQ2ZOZXs2veCJrYiPbm1TelngEck5r+WGO8sRxUG
	selgdBqQ==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPg-00000005D9H-2yQH;
	Thu, 07 Mar 2024 15:12:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/10] f2fs: switch to using blk_next_discard_bio directly
Date: Thu,  7 Mar 2024 08:11:52 -0700
Message-Id: <20240307151157.466013-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240307151157.466013-1-hch@lst.de>
References: <20240307151157.466013-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This fixes fatal signals getting into the way and corrupting the bio
chain and removes the need to handle synchronous errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/f2fs/segment.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index e1065ba7020761..c131e138d74f94 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1305,10 +1305,12 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
 			err = -EIO;
 		} else {
-			err = __blkdev_issue_discard(bdev,
-					SECTOR_FROM_BLOCK(start),
-					SECTOR_FROM_BLOCK(len),
-					GFP_NOFS, &bio);
+			sector_t sector = SECTOR_FROM_BLOCK(start);
+			sector_t nr_sects = SECTOR_FROM_BLOCK(len);
+
+			while (blk_next_discard_bio(bdev, &bio, &sector,
+					&nr_sects, GFP_NOFS))
+				;
 		}
 		if (err) {
 			spin_lock_irqsave(&dc->lock, flags);
-- 
2.39.2

