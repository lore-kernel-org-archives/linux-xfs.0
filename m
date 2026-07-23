Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF7C4746C8;
	Thu, 23 Jul 2026 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818293; cv=none; b=BtPBGmBjUmyBM5Wz6l6cDqUQ4vBwGvqho7FfFJ6lb21ytz6I3tICPOy7IdsfalfmAXVZ4hWIKgTuPVa60QsiOWR52A1ZZQWkQx5r0HzALKqrMf2d7bJH6x5c7eMCXAjReUUIsYKPi+LmdOXQT/CCZtbYsZr+FPhUk2isva+4qFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818293; c=relaxed/simple;
	bh=MjmWJ0QjtW1Y4DBviXbOTtKzR6nHURod4C8Kx5kbteY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOErweydMm3IhLTDTi9gwMNJd97Tpd2DSPr9OtUoYa+q+7CqitUS8JsLyQ4aNhRQXBiZP9bM6MhFQURaKhgFlKPejr7X6NPBOrMcBfih537nY7+VinknDojQHEK+l4aiR8SbFWp2rTOQiAs0H/Z+w3uXmpAfDxyLjUl5nwXZbfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fRMPNqTc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fRMPNqTc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dAz7+YzyZp3t5S9uo8fsnEwb3k2IwceHyMo2E6BucZk=; b=fRMPNqTcRIsOhryGTe6VIid9qK
	rbHN+rwYextSFjzIJ6vVP7ysRS0h6N3CytfazFHMi2qUdSfIeMxVmOJGFdBZ9kXDsMF5uI7qu8YBx
	XHpQUgrRM4vnf+ErgcGh5J3Od8qvQ5/6msFIrOSGUZ1odCmKcpYZO5Oj1uQoBtltmfGCnl0H4LTFv
	NMckSDJmb7NgxlKMmCAMzDuoAvlqXw7fLVXQQti6+CCpKp9nMeOUkMshXE4vf4xyD/PAsu+SPzq+u
	wJ8ElWft1mPiEp5vq/6iix5yktzPU1XEU4MCI4ak0E9TJwMiTiDiPn0XVX/Ps2SwWX/oPQtjq9e4o
	cuAF0qcg==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulk-0000000EXNR-1pR3;
	Thu, 23 Jul 2026 14:51:29 +0000
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
Subject: [PATCH 18/22] xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
Date: Thu, 23 Jul 2026 16:49:43 +0200
Message-ID: <20260723145000.116419-19-hch@lst.de>
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

Stop using the xfs per-inode work struct for completing read bios, as
unlike writes we don't want to serialize reads on a single inode as
there is no exclusive resource contention for them.

Factor the code for kicking off a read that needs and ioend and the
task context completion into a single helper so that it is split off
the xfs_end_bio machinery, which is not only used for writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 10 ++++------
 fs/xfs/xfs_file.c  |  9 +--------
 fs/xfs/xfs_ioend.c | 32 +++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioend.h |  2 ++
 4 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 49d21d905cc3..76918bd15ca8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -580,12 +580,10 @@ xfs_bio_submit_read(
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
index c0c3a11e7ff2..d31a1dddcdc3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,7 +37,6 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
-#include <linux/bio-integrity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -236,14 +235,8 @@ xfs_dio_read_bounce_submit_io(
 	struct bio		*bio,
 	loff_t			file_offset)
 {
-	struct iomap_ioend	*ioend;
-
-	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
+	xfs_ioend_submit_read(iter->inode, bio, file_offset,
 			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
-	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
-		fs_bio_integrity_alloc(bio);
-	bio->bi_end_io = xfs_end_bio;
-	submit_bio(bio);
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
2.53.0

