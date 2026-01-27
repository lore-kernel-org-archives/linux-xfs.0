Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39688355058
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769530022; cv=none; b=ZY5rF29ZTlqdTt2vKUh72WFwgIDXAN1/8ADaHfro1fBEVzbY50pK6+NqNiK4fEN5q7yAFfdIl2z9X4CKqhWXMYAZ61fyyhoXEfJmQIGnQope19xNCPXcZg3ss71nj1jU6oj68eAIkYjP3JX8+CR6FyPOFHF5m8lCA2+Tzyh+ekI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769530022; c=relaxed/simple;
	bh=9DEZye2Kxhn21hh4ZxCXu22Z/gmWDnL1cUp5lZS1JsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0nJRLwdqeToyJzMYuk0rob+ccf/9k8iMQWQK5/MiXGO8BClAMVyrRYgFpjPg6OcTzliHcE4KpvNHOaOJaCn/r+7tNxvRi24a+HWd7HdDyOml1lg2Qlr+uSdZJefdnhu3CX5I2SpCUTohIK7M30VbkTqI7rWfyi1zdRM/A3RIq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D5LJfxXz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D5LJfxXz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=P+zykL4TY7McLpTWGesZ6AaS2wY1Meh/KCbqK3DozUE=; b=D5LJfxXzaToeSwxjXIRaLrjNWQ
	h2oeWm9dNJ0iMMza2l8YWMm0MPE/1e9r+ugehe4L8dH9cEhRmDBVeeW22gF6TliQ0cBO8SAFGHWwb
	Xud3yjwKGBeOVpXZwNrIqvIO/i5chAhWjlPWhk8RUrMuBrV2eS4Ljya5IsjaXG2C5JRwHxtJM3cwy
	9eGUGkl+yAclzyfUU2i1oTZLOzPsJAA3os3KqxaKshkwEtzmGI8817zwF3Stv3W9uAeAoyF7R1sJo
	pY7qidONRvK6dG23DvkmHxSlUtCUdblzsznjkbN91VAr84t4aNUQMw4mFEKhgZhRlvBDg+xFBTNa7
	PXL7S6vQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklam-0000000Ebmq-0Z1z;
	Tue, 27 Jan 2026 16:07:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/10] xfs: don't mark all discard issued by zoned GC as sync
Date: Tue, 27 Jan 2026 17:05:47 +0100
Message-ID: <20260127160619.330250-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
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

