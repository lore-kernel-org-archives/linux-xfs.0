Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA202CCC1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609089; cv=none; b=lm5CT5k8S+ZpYYWKDj+8BREeRAPGj6OlkMkIdxhmyyo6V8YinJH9B7guJb7ZXlx/5F89M1lrHZNSo+GBhcWQe1+7RDC0NFK0u1UDOW7iDYSyUW4zpnDHzlQq2EUyDGQjKErobjf5uhASRFITCYvIgT9z8/iiKOOlh3i9Ui1PofM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609089; c=relaxed/simple;
	bh=Vc9OGJl4Er4n8f1CfJxz8iq8ov2b7rgER5RCC96QoTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLV4ODyjGQjH7Lvkv1T7aKgRdBQpjfdX3auazzqUAT7p8bxNNL7M+rZusop/OWOgvT2YVvFsiMfURR262ORseH0cXOfGIgcgdjt78IZnhTEo/PiO5VLtzLvT0ZcPY7QU0c3nOl2C0hXAQ1WvUv7ATcJASwEEtOhBsIB/NVehySA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AzCf6DIs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AzCf6DIs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WOmNBJg8LLNJx3XAsmhwCHXwD45+nk7w0WacNK7ZKZc=; b=AzCf6DIszwZTeQ+JQhItMRVmcj
	TJG83+eZsEaT8Uua5WZtkz12nzypEp0NtBaOBouiCBdrE4HB7h7Yb5RiVD7UbYuT4/Y1V5iWKwQEP
	DS0vsMLY+NjJUIGylosJyOfYqtW/I4cjfZnj6oprGLxRA9nkY6/ezQF6B3JZe/07vRGdkHmLx5SOP
	sqEhHp8u3gulpXgWPsizlqkYHIjkg34JmtWf/p7F6TrTQQ8DwprwxhujoJ4g0KTHKNVgBwCbXUY+1
	RM2eHUXEtpVBykc3bVtiHKLupYku6s+giLsfbG1baXLGNUZ53CnyFwpr1BFNXIQDD9KgvKqG5gqH5
	nad5WNOA==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWF-00000000iP1-3TFM;
	Mon, 14 Apr 2025 05:38:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 34/43] xfs_mkfs: reflink conflicts with zoned file systems for now
Date: Mon, 14 Apr 2025 07:36:17 +0200
Message-ID: <20250414053629.360672-35-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Don't allow reflink on zoned file system until garbage collections learns
how to deal with shared extents and doesn't blindly unshare them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e6adb345551e..9d84dc9cb426 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2966,6 +2966,14 @@ _("rt extent size not supported on realtime devices with zoned mode\n"));
 			}
 			cli->rtextsize = 0;
 		}
+		if (cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices with zoned mode specified\n"));
+				usage();
+			}
+			cli->sb_feat.reflink = false;
+		}
 
 		/*
 		 * Set the rtinherit by default for zoned file systems as they
-- 
2.47.2

