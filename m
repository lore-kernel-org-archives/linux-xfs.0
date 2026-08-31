Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF553B0AD4;
	Mon, 31 Aug 2026 06:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158478; cv=none; b=l0+n8Otpvw22CZS8QyVxHeDZFwJ3rWB1NLohe+kB2xQgJFeKFMXRayJo9q95ehKEWiEl/ZJDmGN9nvxMglLJ4FUM/vO32LUAyaMrqVY8LB4g+zFEv2EXleSaO1/6XOwR6yzuWqQq5sIW/mr7JmNA5CDPrzD2iP4c/i5QqFdze8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158478; c=relaxed/simple;
	bh=Zg9136amq6hLA7lM9OYG8n4cESxMN9uJJVDHNpjT1iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZv8qlJLQC9M5G4wVMYNRysN8FdjEPFPXf3CvZAayz/mUyMIM0dHkyttSaZ3fY7AF0SLpNPKCUFybhoaJMLN9QWOavY/D7aLmmx2R8T5qPOPjILTm3eIWeB5kIlDvDf4jIa9spRS4K1vn7J3UJoanzhFcfPr3kLKFzxmCOdSqC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O2SEM1WE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O2SEM1WE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CthRkDs6AH4GKuCmo+7U/fNRBUJiJp5NKODmWMdxWYE=; b=O2SEM1WE22JedbsnoD5tKMIvzn
	YOJOYL828J5Zqb/u2FTGTg9uT9FSDsv6vPIvtiDh6YuOAYK0VviXZR8SyrIY36YhYJYbodm71hQ+L
	3W/UtAYDqSF8CwPS+lYueH+AxiuUWPMRzuyiosZVhgG2Mmn8tMkDQ0CKLtJkGpX5X/4BTB8PuVT3S
	K9cXAFBRKAjhyJvrgIMRm93lvzQrYqHqAKOd5kir6TGL1LIzoDavh7LPv2ms0MjLmCD9+cGPGc+jB
	7SVaHHWdUcWwfKlKo+SQ1alUee5VdmW8W+wL13Nirw6t0lplp6OaLdizvxOALA9dTdVt2PtZDv8ES
	VtSW6YGA==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vhj-00000008cxF-1ir0;
	Mon, 31 Aug 2026 06:41:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 09/17] xfs: move PI generation into xfs_submit_zoned_bio
Date: Mon, 31 Aug 2026 09:39:57 +0300
Message-ID: <20260831064010.2574896-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064010.2574896-1-hch@lst.de>
References: <20260831064010.2574896-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Keep the code in one place, and do so only after splitting to
keep the allocation size down in case of a split.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c       | 4 +---
 fs/xfs/xfs_file.c       | 2 --
 fs/xfs/xfs_zone_alloc.c | 3 +++
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4e862406eee9..d2cdb7cffa6b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -23,7 +23,6 @@
 #include "xfs_ioend.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
-#include <linux/bio-integrity.h>
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -498,8 +497,7 @@ xfs_zoned_writeback_submit(
 		bio_endio(&ioend->io_bio);
 		return error;
 	}
-	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
-		fs_bio_integrity_generate(&ioend->io_bio);
+
 	xfs_zone_alloc_and_submit(ioend, &XFS_ZWPC(wpc)->open_zone);
 	return 0;
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index acbfd55f56a3..0e029db2e85b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -739,8 +739,6 @@ xfs_dio_zoned_submit_io(
 	bio->bi_end_io = xfs_end_bio;
 	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
 			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
-	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
-		fs_bio_integrity_generate(bio);
 	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
 }
 
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bdbb60cc5d5b..e427be806f97 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_zones.h"
 #include "xfs_trace.h"
 #include "xfs_mru_cache.h"
+#include <linux/bio-integrity.h>
 
 static void
 xfs_open_zone_free_rcu(
@@ -890,6 +891,8 @@ xfs_submit_zoned_bio(
 		xfs_mark_rtg_boundary(ioend);
 	}
 
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
+		fs_bio_integrity_generate(&ioend->io_bio);
 	submit_bio(&ioend->io_bio);
 }
 
-- 
2.53.0

