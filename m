Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489D23FFAA4;
	Mon, 29 Jun 2026 12:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735492; cv=none; b=UXWAdRUj17k6Ymadb7PnyNXCqV1Z64xTwMC9B0rXNwWCHio/Wtvp77gANxOmtrgRP9Tg+HcfUW0tk1ZwfCNacCQP3g+eSkDetnOhg+YmjLmjoq9qIKoXWk3M1PGfUCeT4hedqI36aKrkJz9ZKARLYD1xTd9bPXZl/fjA38Y+fhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735492; c=relaxed/simple;
	bh=DY0KztDnB2Siug5JWS9iLn4tjldnDvo5HXhr4nTHIXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8DjLZNHBdDlFMeAullnlJPlpi1Jm/PBsniKsYY7QK6txzp42H8VFJnY4QyQywBU/ohvSqMy9yELsbkTvog4ExV2W7rn2NBIx38GuEjP1Q+UmUJR6KQHwzKCbTvDqvJG6dcyGbJ9eR95Gk/nHmOEfvqM0gersy9axydwNtawzDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b61Gv/gZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b61Gv/gZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h42S6vF9jz0jHC3GNT/SpM3g946pL/rq1oM/rG26wEc=; b=b61Gv/gZCJM16zv6Ydc9uKDS5t
	38JmFOyxa/9pITmkkkNJtNSqL3/ajXTzjIqAmb4BFqeBRfE5mCtV7QXjUGxvb/jHlbDIcWfaPN2Iq
	KQ+p6ENl6KXr9NEtnhvNWD3UeULlhLXG7dJGoaxAA/i52Z26BkN912Ez4XzizX1iHYLqOx4YM/Yfu
	uRQenjp8oMoTaMut683Bk8Ib5SddchLvYTFX77r1H+BskLsLwOiwfM2LwlNVerg/b/S52y3NuGEo6
	HuWhMLmC8JRZvWZnSiOuBcS/5SgoK3Y4eYY70yZTAWsINuLtWGbH/tNjjilzjBrKtaGH3D/usUK7D
	g91ZEw1Q==;
Received: from clnet-b08-202.ikbnet.co.at ([83.175.123.202] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weAwB-0000000EX0O-0zYW;
	Mon, 29 Jun 2026 12:18:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] fuse: call fuse_send_readpages explicitly from fuse_readahead
Date: Mon, 29 Jun 2026 14:17:39 +0200
Message-ID: <20260629121750.3392300-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260629121750.3392300-1-hch@lst.de>
References: <20260629121750.3392300-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Joanne Koong <joannelkoong@gmail.com>

Move the call to fuse_send_readpages from the iomap ->submit_read method
to the fuse readahead implementation.

fuse_read_folio() does not need to call fuse_send_readpages() because it
always does reads synchronously (the iomap->submit_read method for this
was a no-op since data->ia is always NULL for fuse_read_folio()).

This prepares for an iomap fix that will call ->submit_read after each
iomap.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fuse/file.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e052a0d44dee..ceada75310b8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -981,19 +981,8 @@ static int fuse_iomap_read_folio_range_async(const struct iomap_iter *iter,
 	return ret;
 }
 
-static void fuse_iomap_submit_read(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
-{
-	struct fuse_fill_read_data *data = ctx->read_ctx;
-
-	if (data->ia)
-		fuse_send_readpages(data->ia, data->file, data->nr_bytes,
-				    data->fc->async_read);
-}
-
 static const struct iomap_read_ops fuse_iomap_read_ops = {
 	.read_folio_range = fuse_iomap_read_folio_range_async,
-	.submit_read = fuse_iomap_submit_read,
 };
 
 static int fuse_read_folio(struct file *file, struct folio *folio)
@@ -1116,6 +1105,9 @@ static void fuse_readahead(struct readahead_control *rac)
 		return;
 
 	iomap_readahead(&fuse_iomap_ops, &ctx, NULL);
+	if (data.ia)
+		fuse_send_readpages(data.ia, data.file, data.nr_bytes,
+				    fc->async_read);
 }
 
 static ssize_t fuse_cache_read_iter(struct kiocb *iocb, struct iov_iter *to)
-- 
2.53.0

