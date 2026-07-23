Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099C443CE79;
	Thu, 23 Jul 2026 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818211; cv=none; b=qLKJd6CBxadCsQTGaawQEDYoj9to7m2R+UCZmWyvt/h3AHJxVoQbsbci9PbQ597HqakEXqblnJEPrubd0FuDK2TVhZNohKSN9kFovfrFiIf25f30SkCjTswgc4OjSexjxeV2zhefXHXB7M5vbdJi2jDjNV2r6XB9AQzOhvQyomM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818211; c=relaxed/simple;
	bh=2gmP+/qg8nGgTZnLknBflwul1dW+M/dskZ7+btSwEvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Log4Q5uvXxOnI67/AmryrqxyE7ZhmKJOQB4NLsVOqA/04pjaGnFjQhxwd1SORsW2nBHzYqI/8JEcQlb5e2igvYwQVJgGJxVAOx/EToMTCjJd+0sR9spkpLmSdgZkaQpmaY53IUOocfvHf7DZ/4g4SSNOPJ4WdYsjUi441+2smZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mRCLaq+g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mRCLaq+g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Nba2dXeUaHj4e867Cz3s4X4aIQyI4p71a9tL7S5UAek=; b=mRCLaq+gyPYaYH5hag4EjvPkDI
	FOTmdh8cE2saHb2pw59sHnUF4dRPfdzGxnmsK7UU1h1PGNr0gqG06sVU4saY5wyiO9z58+U0G+BqR
	e0dkG8QHgZMg4MsQ8SYXkG87EDadL5yeF5/06oEH+DOqGq29bjejyEZUdHQpha+6h+BXyAIzNgMgS
	gQMFc9Mm9Vin8tLwsjS2okXLbH51m1GQubazXu0R3I9AlKZCYurBGSZrDXNGVjkgZ5MOt9FdlBjrl
	JhQaXBt4qLgWE4tWoC2YpR4dF+lph2uTZLkV/yL8oPN4uVa9NVeSU4ZdI05XonbtfnUj4KVZ8TZU2
	hwlpf0NQ==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmukS-0000000EXGN-2KPn;
	Thu, 23 Jul 2026 14:50:08 +0000
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
Subject: [PATCH 01/22] iomap: add a separate bio_set for iomap_split_ioend
Date: Thu, 23 Jul 2026 16:49:26 +0200
Message-ID: <20260723145000.116419-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

iomap_split_ioend can split bios that already come from
iomap_ioend_bioset and thus deadlock when the bioset is exhausted.

Add a separate bio_set to avoid this deadlock.

Fixes: 5fcbd555d483 ("iomap: split bios to zone append limits in the submission handlers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/ioend.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 0565328764c1..2ec755a89228 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -13,6 +13,7 @@
 
 struct bio_set iomap_ioend_bioset;
 EXPORT_SYMBOL_GPL(iomap_ioend_bioset);
+static struct bio_set iomap_ioend_split_bioset;
 
 struct iomap_ioend *iomap_init_ioend(struct inode *inode,
 		struct bio *bio, loff_t file_offset, u16 ioend_flags)
@@ -486,7 +487,8 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
 	sector_offset = ALIGN_DOWN(sector_offset << SECTOR_SHIFT,
 			i_blocksize(ioend->io_inode)) >> SECTOR_SHIFT;
 
-	split = bio_split(bio, sector_offset, GFP_NOFS, &iomap_ioend_bioset);
+	split = bio_split(bio, sector_offset, GFP_NOFS,
+			&iomap_ioend_split_bioset);
 	if (IS_ERR(split))
 		return ERR_CAST(split);
 	split->bi_private = bio->bi_private;
@@ -509,8 +511,23 @@ EXPORT_SYMBOL_GPL(iomap_split_ioend);
 
 static int __init iomap_ioend_init(void)
 {
-	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
+	const unsigned int nr_mempool_entries = 4 * (PAGE_SIZE / SECTOR_SIZE);
+	int error;
+
+	error = bioset_init(&iomap_ioend_bioset, nr_mempool_entries,
 			   offsetof(struct iomap_ioend, io_bio),
 			   BIOSET_NEED_BVECS);
+	if (error)
+		return error;
+	error = bioset_init(&iomap_ioend_split_bioset, nr_mempool_entries,
+			   offsetof(struct iomap_ioend, io_bio),
+			   BIOSET_NEED_BVECS);
+	if (error)
+		goto out_exit_ioend_bioset;
+	return 0;
+
+out_exit_ioend_bioset:
+	bioset_exit(&iomap_ioend_bioset);
+	return error;
 }
 fs_initcall(iomap_ioend_init);
-- 
2.53.0

