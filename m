Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E96542BC30
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187473; cv=none; b=lQotprugzHMG+Id8nPbA1qCnchYcxxjN8U0JDxadSRciVuxmk1bHachG1HxKI8rR7ICVcZ6XpELi+eWp/qN5eu5BZaadBAsJoTE85bF2/3odP0mUYMqt8m7lCy5sh0rE6AG7vgI8IMpTvd7rrujfu70RT+i6srxmBYuW65oIACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187473; c=relaxed/simple;
	bh=b16NGij7B9AuUipvRYNnIl444U9xuE3md8sbF/Yhw0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqXa46ihEo55shTt04uoBndINpkE8N+S9bFfz0TW15MVYW6Pvx7jFllJs/vB9gjZXp2C1U620Nnbi7zWTG/bRaKajJsaJ1fSF4jahklVWtWmH51lGqMroXICgqbV12Grn8XFBpsRtnKh9ZTi5VyeGUXzab+8IpN0eUfCyYCHdsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cl6ARfDR; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cl6ARfDR"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38511175ad3so2193550a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187471; x=1785792271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=roR2fDZvSVNY5ER4KawZnLxIPb4sfP+jbTdlrjx/uqE=;
        b=Cl6ARfDRNy+Jp5LWYFDqtyDy3RhUDG9YfqPUHC37+09DyhIz5snDugWf9oqK8Qd3ij
         i8of+2OptPoOq7YvybU0ZiyMRFqB68RHy+puSEUnPC2DKFfdkg90sRuvKnsgU44few/v
         ryiLZHKEKgvR16Wqs4zfzkTqgp24/EjHkXotk2zP2v5ZhqBgCJQ2cASb1/3vZxa1+mTq
         7HyGNebOqyJYbsaRwmoEmEUld9i4IwWwAZxYYzGyhWbAIgvDM608v31NnjYIi8bjeVbL
         xTb8Dx51Ad2UTpBmxTfe+rDfwCMbbsZ/aBMquqNDa9w2uXrpnyg4/6sUcRxM9kExDv2t
         xzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187471; x=1785792271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=roR2fDZvSVNY5ER4KawZnLxIPb4sfP+jbTdlrjx/uqE=;
        b=MweQUcc1Mfbw4b6R1zGYolQb11LsIDaMFJSn8H4/GgRVjiM9ql6NpTzrHjEEnBe0GD
         +bizUKrXcdcuJhKaAB4V2ri+nIjQJdqFBuCuldrnDIHe09Gh94yVRlPJkqqxZBmRqDay
         brGjwSzg3tjEx1ron8PLcJsGXePqbcSEKqE/UW4wgkKY7GlaZ9icPqHCExJs8rjNHrIL
         evS6yLFcAfpGdaY2yMLXvGcX6UG2p1otj4i/+c4hJ+rUNeysURe0fb0Ir8DmNMcj++hb
         b6V/EzteXfHxdF68ZHxNzFncV2nrOJ4q7ImcWnUE4bZRxM0ZRLBEbjpncGDtOpD2ZB5j
         WIbw==
X-Forwarded-Encrypted: i=1; AHgh+Ro56CRwelE66kx4wSNyccSnzepkCBhu/8YzJVuquO+bYmTgVD3lkUXKVDkpoi27hKEybbUSlcX6nFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZbeVVZnOonHk6+exd28D4jTY4j5AZ2fuXXdISRoiBBEwjCp4J
	PPQbVvUKoBk95W7N8PpRKXm009/NbrQnJurlJJk0EfeE2nttTq5XsUyw
X-Gm-Gg: AR+sD12R+TSkHIHd/limDssSLMEy15gQ3W30iaGnuMNVfuCIklWvnPgMtpRh2NghVRk
	I6ZLLjAmZ7PulnSynmDcDk4/a2qGDtYV7RVIj5ozTc2EilYeuxV3ESK1RyqZo4nV7xPlnaKPc2j
	TLiP9mZDPMzbQzxTZMc2XLDSOBiJzI6vchBwwcwWFQalAnU130rUmdbq9olUJcp993DUCKlyF35
	MZoGtePGcZY7yUNYDnmP6UmFef6m9+5aIRddCbrDB1aD5HKBYwExWpt6uENck+HYz0Eea4sRYpJ
	W5nfbYu6WpQmpjKkD/lsdy4g7dg4XANKdhJeZnXA68D2BrtOzCqtmDsi4p1iGrqOaHeRrBKLysz
	JJsYJCAButdZQXyiIGd3SVcJK4MuQvJyGaiGlBhscsIhbgvxN4DeNK+xG1fxBpsSchUHQ5sIeX7
	u0Jxy8iiqL5g2ldvP1ONAz7jxOh4eG6oqDTgiDX/XXDA7mylVP2Ha5yA==
X-Received: by 2002:a17:90b:1e0d:b0:38e:e0b:320d with SMTP id 98e67ed59e1d1-38f64d03d14mr755174a91.41.1785187470776;
        Mon, 27 Jul 2026 14:24:30 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59b451sm41625715ad.13.2026.07.27.14.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:30 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 02/21] iomap: decouple simple direct I/O reads from iomap_dio_rw
Date: Mon, 27 Jul 2026 14:17:39 -0700
Message-ID: <20260727211758.1116539-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

The pending iomap_iter_next conversion creates performance issues for the
new simple direct I/O read fast path, because it assumes a model where
the iterator must be advanced at the end, which the direct I/O read fast
path tries to avoid.

Side step this by splitting the simple path from iomap_dio_rw, and
require the file systems to call into it explicitly, and pass only a
->begin callback.  This allows to drop various checks for incompatible
features while creating a requirement for the file system to only call
the simple path for cases that it can handle.

As a side-benefit we can now inline the initial part of the simple
direct I/O read fast path and let the compiler convert the indirect call
to ->begin into a direct call.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/ext4.h        |   3 +
 fs/ext4/file.c        |   4 +-
 fs/ext4/inode.c       |   2 +-
 fs/iomap/direct-io.c  | 208 ++++++++++--------------------------------
 fs/xfs/xfs_file.c     |  14 +--
 fs/xfs/xfs_iomap.c    |   2 +-
 fs/xfs/xfs_iomap.h    |   4 +
 include/linux/iomap.h |  66 ++++++++++++++
 8 files changed, 136 insertions(+), 167 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..e134c0193e2b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4007,6 +4007,9 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 
+int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+		unsigned flags, struct iomap *iomap, struct iomap *srcmap);
+
 static inline int ext4_buffer_uptodate(struct buffer_head *bh)
 {
 	/*
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index eb1a323962b1..f20d92255546 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -91,7 +91,9 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return generic_file_read_iter(iocb, to);
 	}
 
-	ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
+	ret = iomap_dio_read_simple(iocb, to, ext4_iomap_begin);
+	if (ret == -ENOTBLK)
+		ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
 	inode_unlock_shared(inode);
 
 	file_accessed(iocb->ki_filp);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..b48c54f3312b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3771,7 +3771,7 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
 }
 
 
-static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned flags, struct iomap *iomap, struct iomap *srcmap)
 {
 	int ret;
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ca790239e5eb..36c976cf0848 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -894,6 +894,21 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(__iomap_dio_rw);
 
+ssize_t
+iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
+		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
+		unsigned int dio_flags, void *private, size_t done_before)
+{
+	struct iomap_dio *dio;
+
+	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, private,
+			     done_before);
+	if (IS_ERR_OR_NULL(dio))
+		return PTR_ERR_OR_ZERO(dio);
+	return iomap_dio_complete(dio);
+}
+EXPORT_SYMBOL_GPL(iomap_dio_rw);
+
 struct iomap_dio_simple {
 	struct kiocb		*iocb;
 	size_t			size;
@@ -968,211 +983,88 @@ static void iomap_dio_simple_end_io(struct bio *bio)
 	iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
 }
 
-static inline bool
-iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
-			   const struct iomap_dio_ops *dops,
-			   unsigned int dio_flags, size_t done_before)
-{
-	struct inode *inode = file_inode(iocb->ki_filp);
-	size_t count = iov_iter_count(iter);
-
-	if (dops || done_before)
-		return false;
-	if (iov_iter_rw(iter) != READ)
-		return false;
-	if (!count)
-		return false;
-	/*
-	 * Simple dio is an optimization for small IO. Filter out large IO
-	 * early as it's the most common case to fail for typical direct IO
-	 * workloads.
-	 */
-	if (count > inode->i_sb->s_blocksize)
-		return false;
-	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
-			 IOMAP_DIO_BOUNCE))
-		return false;
-	if (iocb->ki_pos + count > i_size_read(inode))
-		return false;
-	if (IS_ENCRYPTED(inode))
-		return false;
-
-	return true;
-}
-
-/*
- * Fast path for small, block-aligned direct I/Os that map to a single
- * contiguous on-disk extent.
- *
- * iomap_dio_simple_supported() enforces the cheap up-front constraints before
- * entering this path.
- *
- * @dops must be NULL: a non-NULL @dops means the caller wants its
- * ->end_io / ->submit_io hooks invoked, and in particular wants its bios to be
- * allocated from the filesystem-private @dops->bio_set (whose front_pad sizes a
- * filesystem-private wrapper around the bio).  The fast path instead allocates
- * from the shared iomap_dio_simple_pool, whose front_pad matches struct
- * iomap_dio_simple; the two wrappers are not interchangeable, so we must fall
- * back to __iomap_dio_rw() in that case.
- *
- * @done_before must be zero: a non-zero caller-accumulated residual cannot be
- * carried through a single-bio inline completion.
- *
- * @iter must describe a non-empty READ no larger than the inode block size:
- * writes, zero-length I/O, and larger requests need the generic iomap direct
- * I/O path.
- *
- * @dio_flags must not request IOMAP_DIO_FORCE_WAIT, IOMAP_DIO_PARTIAL, or
- * IOMAP_DIO_BOUNCE: this path does not support forced waiting, partial direct
- * I/O, or bouncing.  The range must also stay within i_size and encrypted
- * inodes must use the generic iomap direct I/O path.
- *
- * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when it
- * decides the request does not fit the fast path.  In that case we proceed to
- * the generic __iomap_dio_rw() slow path.  Any other errno is a real result and
- * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach the
- * caller.
- */
-static ssize_t
-iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
-		 const struct iomap_ops *ops, void *private,
-		 unsigned int dio_flags)
+ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
+		struct iomap_iter *iomi)
 {
-	struct inode *inode = file_inode(iocb->ki_filp);
-	size_t count = iov_iter_count(iter);
-	bool wait_for_completion = is_sync_kiocb(iocb);
-	struct iomap_iter iomi = {
-		.inode		= inode,
-		.pos		= iocb->ki_pos,
-		.len		= count,
-		.flags		= IOMAP_DIRECT,
-		.private	= private,
-	};
 	struct iomap_dio_simple *sr;
 	unsigned int alignment;
 	struct bio *bio;
 	ssize_t ret;
 
-	if (iocb->ki_flags & IOCB_NOWAIT)
-		iomi.flags |= IOMAP_NOWAIT;
-
-	ret = kiocb_write_and_wait(iocb, count);
-	if (ret)
-		return ret;
-
-	inode_dio_begin(inode);
-
-	ret = ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
-			       &iomi.iomap, &iomi.srcmap);
-	if (ret) {
-		inode_dio_end(inode);
-		return ret;
-	}
-
-	if (iomi.iomap.type != IOMAP_MAPPED ||
-	    iomi.iomap.offset + iomi.iomap.length < iomi.pos + count ||
-	    (iomi.iomap.flags & IOMAP_F_INTEGRITY)) {
+	if (iomi->iomap.type != IOMAP_MAPPED ||
+	    iomi->iomap.offset + iomi->iomap.length < iomi->pos + iomi->len ||
+	    (iomi->iomap.flags & IOMAP_F_INTEGRITY)) {
 		ret = -ENOTBLK;
-		goto out_iomap_end;
+		goto out_dio_end;
 	}
 
-	alignment = iomap_dio_alignment(inode, iomi.iomap.bdev, dio_flags);
-	if ((iomi.pos | count) & (alignment - 1)) {
+	alignment = iomap_dio_alignment(iomi->inode, iomi->iomap.bdev, 0);
+	if ((iomi->pos | iomi->len) & (alignment - 1)) {
 		ret = -EINVAL;
-		goto out_iomap_end;
+		goto out_dio_end;
 	}
 
-	if (!wait_for_completion && unlikely(!inode->i_sb->s_dio_done_wq)) {
-		ret = sb_init_dio_done_wq(inode->i_sb);
+	if (unlikely(!iomi->inode->i_sb->s_dio_done_wq &&
+			!is_sync_kiocb(iocb))) {
+		ret = sb_init_dio_done_wq(iomi->inode->i_sb);
 		if (ret < 0)
-			goto out_iomap_end;
+			goto out_dio_end;
 	}
 
-	trace_iomap_dio_rw_begin(iocb, iter, dio_flags, 0);
-
-	if (user_backed_iter(iter))
-		dio_flags |= IOMAP_DIO_USER_BACKED;
+	trace_iomap_dio_rw_begin(iocb, iter, 0, 0);
 
-	bio = bio_alloc_bioset(iomi.iomap.bdev,
+	bio = bio_alloc_bioset(iomi->iomap.bdev,
 			       bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
 			       REQ_OP_READ, GFP_KERNEL, &iomap_dio_simple_pool);
 	sr = container_of(bio, struct iomap_dio_simple, bio);
 	sr->iocb = iocb;
-	sr->dio_flags = dio_flags;
+	sr->dio_flags = 0;
 
-	bio->bi_iter.bi_sector = iomap_sector(&iomi.iomap, iomi.pos);
+	bio->bi_iter.bi_sector = iomap_sector(&iomi->iomap, iomi->pos);
 	bio->bi_ioprio = iocb->ki_ioprio;
 
 	ret = bio_iov_iter_get_pages(bio, iter, alignment - 1);
 	if (unlikely(ret))
 		goto out_bio_put;
 
-	if (bio->bi_iter.bi_size != count) {
+	if (bio->bi_iter.bi_size != iomi->len) {
 		iov_iter_revert(iter, bio->bi_iter.bi_size);
 		ret = -ENOTBLK;
 		goto out_bio_release_pages;
 	}
 
 	sr->size = bio->bi_iter.bi_size;
-
-	if (dio_flags & IOMAP_DIO_USER_BACKED)
+	if (user_backed_iter(iter)) {
 		bio_set_pages_dirty(bio);
+		sr->dio_flags |= IOMAP_DIO_USER_BACKED;
+	}
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio->bi_opf |= REQ_NOWAIT;
-	if ((iocb->ki_flags & IOCB_HIPRI) && !wait_for_completion) {
-		bio->bi_opf |= REQ_POLLED;
-		WRITE_ONCE(iocb->private, bio);
-	}
 
-	if (ops->iomap_end)
-		ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
-			       &iomi.iomap);
-
-	if (!wait_for_completion) {
-		bio->bi_end_io = iomap_dio_simple_end_io;
-		submit_bio(bio);
-		trace_iomap_dio_rw_queued(inode, iomi.pos, count);
-		return -EIOCBQUEUED;
+	if (is_sync_kiocb(iocb)) {
+		submit_bio_wait(bio);
+		return iomap_dio_simple_complete(sr);
 	}
 
-	submit_bio_wait(bio);
-	return iomap_dio_simple_complete(sr);
+	if ((iocb->ki_flags & IOCB_HIPRI)) {
+		bio->bi_opf |= REQ_POLLED;
+		WRITE_ONCE(iocb->private, bio);
+	}
+	bio->bi_end_io = iomap_dio_simple_end_io;
+	submit_bio(bio);
+	trace_iomap_dio_rw_queued(iomi->inode, iocb->ki_pos, iomi->len);
+	return -EIOCBQUEUED;
 
 out_bio_release_pages:
 	bio_release_pages(bio, false);
 out_bio_put:
 	bio_put(bio);
-out_iomap_end:
-	if (ops->iomap_end)
-		ops->iomap_end(inode, iomi.pos, count, 0, iomi.flags,
-			       &iomi.iomap);
-	inode_dio_end(inode);
+out_dio_end:
+	inode_dio_end(iomi->inode);
 	return ret;
 }
-
-ssize_t
-iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
-		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags, void *private, size_t done_before)
-{
-	struct iomap_dio *dio;
-	ssize_t ret;
-
-	if (iomap_dio_simple_supported(iocb, iter, dops, dio_flags,
-				       done_before)) {
-		ret = iomap_dio_simple(iocb, iter, ops, private, dio_flags);
-		if (ret != -ENOTBLK)
-			return ret;
-	}
-
-	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, private,
-			     done_before);
-	if (IS_ERR_OR_NULL(dio))
-		return PTR_ERR_OR_ZERO(dio);
-	return iomap_dio_complete(dio);
-}
-EXPORT_SYMBOL_GPL(iomap_dio_rw);
+EXPORT_SYMBOL_GPL(__iomap_dio_read_simple);
 
 static int __init iomap_dio_init(void)
 {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..b733225d2864 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -251,8 +251,6 @@ xfs_file_dio_read(
 	struct iov_iter		*to)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
-	unsigned int		dio_flags = 0;
-	const struct iomap_dio_ops *dio_ops = NULL;
 	ssize_t			ret;
 
 	trace_xfs_file_direct_read(iocb, to);
@@ -266,11 +264,15 @@ xfs_file_dio_read(
 	if (ret)
 		return ret;
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
-		dio_ops = &xfs_dio_read_bounce_ops;
-		dio_flags |= IOMAP_DIO_BOUNCE;
+		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
+				&xfs_dio_read_bounce_ops, IOMAP_DIO_BOUNCE,
+				NULL, 0);
+	} else {
+		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin);
+		if (ret == -ENOTBLK)
+			ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
+					0, NULL, 0);
 	}
-	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, dio_ops, dio_flags,
-			NULL, 0);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 225c3de88d03..0536e2aeddcc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -2173,7 +2173,7 @@ const struct iomap_ops xfs_buffered_write_iomap_ops = {
 	.iomap_end		= xfs_buffered_write_iomap_end,
 };
 
-static int
+int
 xfs_read_iomap_begin(
 	struct inode		*inode,
 	loff_t			offset,
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ebcce7d49446..cffcec532ea6 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -49,6 +49,10 @@ xfs_aligned_fsb_count(
 	return count_fsb;
 }
 
+int xfs_read_iomap_begin(struct inode *inode, loff_t offset,
+		loff_t length, unsigned flags, struct iomap *iomap,
+		struct iomap *srcmap);
+
 extern const struct iomap_ops xfs_buffered_write_iomap_ops;
 extern const struct iomap_ops xfs_direct_write_iomap_ops;
 extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 36490c08d6e9..80832edc7ec2 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -10,6 +10,7 @@
 #include <linux/mm_types.h>
 #include <linux/blkdev.h>
 #include <linux/folio_batch.h>
+#include <linux/pagemap.h>
 
 struct address_space;
 struct fiemap_extent_info;
@@ -675,6 +676,71 @@ struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 ssize_t iomap_dio_complete(struct iomap_dio *dio);
 void iomap_dio_bio_end_io(struct bio *bio);
 
+/*
+ * Fast path for small, block-aligned direct I/Os that map to a single
+ * contiguous on-disk extent.
+ *
+ * @iter must describe a non-empty READ no larger than the inode block size:
+ * writes, zero-length I/O, and larger requests need the generic iomap direct
+ * I/O path.
+ *
+ * Does not support iomap_dio_ops, dio_flags, done_before or private data.
+ * The range must also stay within i_size and encrypted inodes must use the
+ * generic iomap direct I/O path.
+ *
+ * -ENOTBLK indicates the generic path must be used by the caller instead.
+ * Any other errno is a real result and is propagated as-is, in particular
+ * -EAGAIN for IOCB_NOWAIT must reach the caller.
+ *
+ * The caller can only provide an iomap begin handler, and the iterator
+ * is never advanced.
+ */
+ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
+		struct iomap_iter *iomi);
+static __always_inline ssize_t iomap_dio_read_simple(struct kiocb *iocb,
+		struct iov_iter *iter, iomap_iter_begin_fn begin)
+{
+	struct iomap_iter iomi = {
+		.inode		= file_inode(iocb->ki_filp),
+		.pos		= iocb->ki_pos,
+		.len		= iov_iter_count(iter),
+		.flags		= IOMAP_DIRECT,
+	};
+	ssize_t ret;
+
+	if (!iomi.len)
+		return 0;
+
+	/*
+	 * Simple dio is an optimization for small IO. Filter out large IO
+	 * early as it's the most common case to fail for typical direct IO
+	 * workloads.
+	 */
+	if (iomi.len > iomi.inode->i_sb->s_blocksize)
+		return -ENOTBLK;
+	if (iocb->ki_pos + iomi.len > i_size_read(iomi.inode))
+		return -ENOTBLK;
+	if (IS_ENCRYPTED(iomi.inode))
+		return -ENOTBLK;
+
+	ret = kiocb_write_and_wait(iocb, iomi.len);
+	if (ret)
+		return ret;
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		iomi.flags |= IOMAP_NOWAIT;
+
+	inode_dio_begin(iomi.inode);
+	ret = begin(iomi.inode, iomi.pos, iomi.len, iomi.flags, &iomi.iomap,
+			&iomi.srcmap);
+	if (ret) {
+		inode_dio_end(iomi.inode);
+		return ret;
+	}
+
+	return __iomap_dio_read_simple(iocb, iter, &iomi);
+}
+
 #ifdef CONFIG_SWAP
 struct file;
 struct swap_info_struct;
-- 
2.52.0

