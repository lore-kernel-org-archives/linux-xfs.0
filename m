Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDC812F581;
	Thu,  7 Mar 2024 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824330; cv=none; b=oTM6i3hiullvir+v+Mg61JiyWYgps/zfT690yVfthGjPS21SgtYSjrlDXDKcvBOoNpFDqUK7k5fPlsiMLq09Bjmzne9e5VyWHxdMgw+nz4NYPhG+IbrwKEuS2GzAG2p2lHoKdyRGfPaxTNU9X7p2hIvm99etDloe+wIbym48UMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824330; c=relaxed/simple;
	bh=zPxsh836NPBiiy/7oPJ0S6jtnAX71dRpgwl/YopkPIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OlkSucygGNHFvJUqxBuvxf1QwapgWMbuhCV32LoUpKGQkVW5YV/bz15ubGmaR4mxcyVcLs0kpu2zVg4ii54XDhHi652VTftWPF7ir4W4/zFxbq3LwekZi2boX1rk+yOYeG9aNbuiMeokwA7m29HUjAn4uA9/mA5E0/iG8RjhdwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BbGn5YzV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BbGn5YzV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0jRMO28hlSvt3zadSNwOLNWqxW82YvXZ34Ykj2ec+Tw=; b=BbGn5YzVLKVWXIPLrCzlp84cUp
	I+06bpKxaQ/thKBDB3ZKn2igdrSYtfRQlztBnuURBcZuxxCTk4dFBLwd0hsWseSnN4WhpRQ8NByy1
	Peg9UNEEPT8b0iCpxjhIdmTba55vx+MQplwgRUDLK8DIt/lFfNG0iUUgAkOqNUgZIU/K57YK9tOEZ
	+cOOYTbPgT5EJlhyuAFfXxXGpD9nfYe4x5wRs0eX384chykvV3lyH0NHkOrbuEE+7fhLZQDiWTdW7
	RJbuEB6FYhstyaUqHpv9fw0tXBQOyEslSgzfteIpu/S4iRjZ9xVzoQAOm4lqj8Gx+4zXz1c6fkAi9
	K3Ikbz7A==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPj-00000005DAn-1aQv;
	Thu, 07 Mar 2024 15:12:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/10] md: switch to using blk_next_discard_bio directly
Date: Thu,  7 Mar 2024 08:11:55 -0700
Message-Id: <20240307151157.466013-9-hch@lst.de>
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
 drivers/md/md.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7d7b982e369c11..5803a298dd40f9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8722,8 +8722,10 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 {
 	struct bio *discard_bio = NULL;
 
-	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO,
-			&discard_bio) || !discard_bio)
+	while (blk_next_discard_bio(rdev->bdev, &discard_bio, &start, &size,
+			GFP_NOIO))
+		;
+	if (!discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
-- 
2.39.2

