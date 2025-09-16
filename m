Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749BB31D731
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758030757; cv=none; b=jj5OHWIKlAQOAmZJ/V7hVF+hu7MIOk/VoVWo0ZWqwS6Yc5bKWVFam2k+vYD30PcoI4zQG0NQtFw6s7ZegRBCIClnLgfu1vIGkaWTgDEoJZfaqnlkdmzgaOh/jgTFEUlpaDLfyvrH287gGHQGk/EiA9fzOYkNLF09vWwI/HsS4Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758030757; c=relaxed/simple;
	bh=mXa1ae3S48kCHLt9IjEMEdZfxnWt2IKncmPYrkAnfL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htw67grNWUhPHFw5BpjVWMXjB1nOAWqpNHDH0MhRfz5yiQc0+299Ub7yKTfs2epkdKZa2nqFbVGCDlwuSINoT7Kn8Zj4iRnY7necwZSl5v8KJClKmvdMysC9dhuBN9XOLYj9aoKhGM4TiEiRFmNziG0TWJ+nLdhPdnKycUo3Ut0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZEVly9E2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZEVly9E2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JQP5BTsATzgxmeImquEtvNKiKchpssqkG9QPkfUp6bQ=; b=ZEVly9E2Gj516N8zjfHIsS00h9
	SWjbIc2N7ZgBUTWn252sXQGCtDnvS6dNJS3Egl/ZOiUYq32HzYbiXhtmCxHu3Sb5T+UjMwltf8Gt+
	i8JZ9Ifs/D3e5EfydwdxBLY4bnD/pLbcW7TpgK0IQJLjeKHKq9Og1daYndVy8xiFZjH7Tt8qyIdP3
	h2jho2YQgxAIQmHRUEVMaIN6UZ99IEKsuq5ZSbmNk3PG8c6TOKxDcQcwtZBuvH59I813gz28M6fN0
	hc7dRouM4sIM6Flhy4mHxwBZJbJRPlHoipExjEoynkg9a+r8k0FjEjLM5qRdvXBT/codbRGph4DUV
	Q/dLW+Bw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyW6m-00000007zfF-0QRx;
	Tue, 16 Sep 2025 13:52:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/2] xfs: use bt_nr_blocks in xfs_dax_translate_range
Date: Tue, 16 Sep 2025 06:52:32 -0700
Message-ID: <20250916135235.218084-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250916135235.218084-1-hch@lst.de>
References: <20250916135235.218084-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Only ranges inside the file system can be translated, and the file system
can be smaller than the containing device.

Fixes: f4ed93037966 ("xfs: don't shut down the filesystem for media failures beyond end of log")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_notify_failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index fbeddcac4792..3726caa38375 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -165,7 +165,7 @@ xfs_dax_translate_range(
 	uint64_t		*bblen)
 {
 	u64			dev_start = btp->bt_dax_part_off;
-	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
+	u64			dev_len = BBTOB(btp->bt_nr_blocks);
 	u64			dev_end = dev_start + dev_len - 1;
 
 	/* Notify failure on the whole device. */
-- 
2.47.2

