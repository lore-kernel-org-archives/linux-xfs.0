Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66DE45A2B8;
	Fri, 14 Aug 2026 09:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699591; cv=none; b=G5t+rPxWioEI4+ztE2I+Y34j9hRTk35PEEEUh3F5fAGVVOtZuWmEzY1ubUbXz2gKS5JS+FSHfw5qeePIUjbOtKPr63qFfgXUTnvKA7XayrKjr2bnxzWCs3CDYDAlb5HofBkNsyOAo7adopovJJ+k1ZtW5BGnzwSXdrOH2I+vT9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699591; c=relaxed/simple;
	bh=CbusMpvebec3tBYu+NURQT8ZFljJI2s3y3jfCcEsWxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7b9FLNj+VWYv7zg8Pg1jkgV/xC1bmEni92OBBsSVe8WhTch9dbF8ufivI6ry9xa+9zywBrxhFbcHcqT/2ufHUnNm/jMt47PUoEDnb+F8WWqN6d1InfSggn0vnFYFQ1b6B7NfS7j1LkRpIK9lWP9cM/rmHefjv0EsWde9uXjF/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+dMfBa0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+dMfBa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3938F1F000E9;
	Fri, 14 Aug 2026 09:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699587;
	bh=q2SKTE3mDAWpbaUp39eqm6e7KDQqD/IN66nudQau/oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+dMfBa0cyPdpFlv+0yqDbuU6SEvrn5eV7+4ThldVZG5r2IdybxdF/7vfINE9ISpP
	 a/iSEGgmYcW3HJFxUFV7y7tTqTJaQW0XlaMmd/GdY1yhwjdrwvjOTUGs1G7z/zVknf
	 j4e2PwiMAlzIZzOyTo34G+MzTvdCa0uE4CQfq4NTxMoHZ8Wj+pU8Xxz2D6AzobSEW9
	 GewTkZpEL/0ua9CAy7hElj6XYY42VVzWnOpPDPnzV2jrJLy/yvh2E8OTz8BVdeDHwL
	 XrGsu6umvUWNGh8qIb8NLyZAMeSw/ncDUPXkHTPnAXCACPKZtumXxJ+RLEdIOeqkOw
	 mvhGBE9doSFZA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 11/25] xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
Date: Fri, 14 Aug 2026 11:24:28 +0200
Message-ID: <20260814092448.1818082-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Stop using the xfs per-inode work struct for completing read bios, as
unlike writes we don't want to serialize reads on a single inode as
there is no exclusive resource contention for them.

Factor the code for kicking off a read that needs and ioend and the
task context completion into a single helper so that it is split off
the xfs_end_bio machinery, which is not only used for writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c  | 10 ++++------
 fs/xfs/xfs_file.c  |  6 ++----
 fs/xfs/xfs_ioend.c | 32 +++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioend.h |  2 ++
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a39dcd8c9a1c..d2484c4a6151 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -578,12 +578,10 @@ xfs_bio_submit_read(
 	const struct iomap_iter		*iter,
 	struct iomap_read_folio_ctx	*ctx)
 {
-	struct bio			*bio = ctx->read_ctx;
-
-	/* defer read completions to the ioend workqueue */
-	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
-		iomap_ioend_flags(&iter->iomap));
-	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
+	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
+			ctx->read_ctx_file_offset,
+			iomap_ioend_flags(&iter->iomap));
+	ctx->read_ctx = NULL;
 }
 
 static const struct iomap_read_ops xfs_iomap_read_ops = {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6d989bd1696b..b3e1263516dd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -235,10 +235,8 @@ xfs_dio_read_bounce_submit_io(
 	struct bio		*bio,
 	loff_t			file_offset)
 {
-	iomap_init_ioend(iter->inode, bio, file_offset,
-		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
-	bio->bi_end_io = xfs_end_bio;
-	submit_bio(bio);
+	xfs_ioend_submit_read(iter->inode, bio, file_offset,
+			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
 }
 
 static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 40695d18dac0..37a3ae8066e9 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -16,6 +16,32 @@
 #include "xfs_reflink.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_ioend.h"
+#include <linux/bio-integrity.h>
+
+static void
+xfs_end_io_read(
+	struct bio		*bio)
+{
+	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
+	int			error = blk_status_to_errno(bio->bi_status);
+
+	iomap_finish_ioends(ioend, error);
+}
+
+void
+xfs_ioend_submit_read(
+	struct inode		*inode,
+	struct bio		*bio,
+	loff_t			file_offset,
+	u16			ioend_flags)
+{
+	iomap_init_ioend(inode, bio, file_offset, ioend_flags);
+	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
+		fs_bio_integrity_alloc(bio);
+	bio->bi_end_io = xfs_end_io_read;
+	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+	submit_bio(bio);
+}
 
 static void
 xfs_ioend_put_open_zones(
@@ -148,11 +174,7 @@ xfs_end_io(
 			io_list))) {
 		list_del_init(&ioend->io_list);
 		iomap_ioend_try_merge(ioend, &tmp);
-		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
-			iomap_finish_ioends(ioend,
-				blk_status_to_errno(ioend->io_bio.bi_status));
-		else
-			xfs_end_ioend_write(ioend);
+		xfs_end_ioend_write(ioend);
 		cond_resched();
 	}
 }
diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
index 525865767fca..7c2a1ea3e6ed 100644
--- a/fs/xfs/xfs_ioend.h
+++ b/fs/xfs/xfs_ioend.h
@@ -12,5 +12,7 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 }
 
 void xfs_end_bio(struct bio *bio);
+void xfs_ioend_submit_read(struct inode *inode, struct bio *bio,
+		loff_t file_offset, u16 ioend_flags);
 
 #endif /* __XFS_IOEND_H */
-- 
2.54.0

