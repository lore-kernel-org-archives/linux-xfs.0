Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D422F1FDE;
	Wed, 24 Jun 2026 15:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782315442; cv=none; b=PxcZuHkgtdHp69sjZ54YpCFumLfp9wcpNorMMze5H9RrEdFWes+Kbza9gr0vVKYHaCPYayPkQMjD09DmKuJxIj5C06TMtLsXQbfVRrnT9j3y1ZKBKTCEb2Fgs48RKpqJ6AUwMk5LXoS7ojkUUpE40DbIj4CSa21HvPW/6BgUEhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782315442; c=relaxed/simple;
	bh=cFugtTwxxaEoi2fJ2FJORcZobWI5qVxzdoA1OTGvYTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFJGwi1T6hFXGELEMxFmfDvxilLG/fxvP/+OgkaSMhBgTggkG7KX9VarnkqgyJ1rNy63DX+GZNfYvsGGrxygNRCCKnFQkf6gxtNNJPemElBSgn51Ej6zjLRWm1t5G8W4i4m+2ULsAP5QTZl/a5StEe8rAkfWvibC7nhBJl2D5+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3G4e5+I3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3G4e5+I3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rf//pWD/IJO6Nea1GlpoLIi2frum3iYrUvWorumtOFk=; b=3G4e5+I3Hb58Y1LJQl20ZZSozn
	q5wUwUzVjI+XxHkNJiuN6oW/psabfJ6BNXn5Osmx7gk95dpIBcCjt9lN5NixkE6FaQ5o2De7+cxfE
	afPvby33pMseDx4s17Jc9Qj1ISw2ASSHvPmkig8gZa9PkTxgB6wjhPPQLExAAbS9xOT0av0S9/jzW
	eWP17ilQOl3Iwno8L3Qfwj/ThMNmZhC1k6E/np7FEDggcPV8uTR1xzD6KG3F5yR/OjQBys6pE3khC
	6fzhVRFZCxYkDD9FaqxdjKbfBTUfRRqBVNvRRbxShjI2jW+jn4AejWIfegJGnGDc/+4I+pXmyKncs
	gzd4b3rQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcPf4-0000000811u-0yv1;
	Wed, 24 Jun 2026 15:37:10 +0000
Date: Wed, 24 Jun 2026 08:37:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com
Subject: Re: [PATCH v4] iomap: add simple read path for small direct I/O
Message-ID: <ajv5pqNureiK80Eu@infradead.org>
References: <20260608073134.95964-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608073134.95964-1-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Sorry for the delay in getting back to this, I'm a bit overloaded at
the moment.

> -static inline bool should_report_dio_fserror(const struct iomap_dio *dio)
> +static inline bool should_report_dio_fserror(int error)

Can you split all the refactoring into prep patches?

> +/*
> + * In the async simple read path, we need to prevent bio_endio() from
> + * triggering iocb->ki_complete() before the submitter has returned
> + * -EIOCBQUEUED. Otherwise, the caller might free the iocb concurrently.
> + *
> + * We use a three-state rendezvous to synchronize the submitter and end_io:
> + *
> + * IOMAP_DIO_SIMPLE_SUBMITTING: Initial state set before submitting the bio.
> + *
> + * IOMAP_DIO_SIMPLE_QUEUED: The submitter has safely queued the IO and will
> + * return -EIOCBQUEUED. If end_io sees this state, it takes over and calls
> + * ki_complete().
> + *
> + * IOMAP_DIO_SIMPLE_DONE: end_io fired before the submitter finished the
> + * submit path. end_io sets this state and does nothing else. The submitter
> + * will see this state and handle the completion synchronously (bypassing
> + * ki_complete() and returning the actual result).
> + */

I don't think we actually need any of this.  For the sync case we
can just use submit_bio_wait, and for async just always complete
from the end_io handler.  This will simplify the implementation a lot,
and also avoid the atomic.

> +static void iomap_dio_simple_read_async_done(struct iomap_dio_simple_read *sr)

Btw, I'd drop the _read in the name.  Most of this would work as-is
for trivial overwrites if we figure out when to use them.

> +	if (dio_flags & IOMAP_DIO_BOUNCE)
> +		nr_pages = bio_iov_bounce_nr_vecs(iter, REQ_OP_READ);
> +	else
> +		nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS);

Bounce buffering requires dops, so all this can be dropped.

> +	ret = ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
> +			       &iomi.iomap, &iomi.srcmap);
> +	if (ret) {
> +		inode_dio_end(inode);
> +		return ret;
> +	}
> +
> +	if (iomi.iomap.type != IOMAP_MAPPED ||
> +	    iomi.iomap.offset > iomi.pos ||

I don't think offset > pos can happen

> +	    iomi.iomap.offset + iomi.iomap.length < iomi.pos + count ||
> +	    (iomi.iomap.flags & IOMAP_F_INTEGRITY)) {
> +		ret = -ENOTBLK;
> +		goto out_iomap_end;
> +	}

Given that we already have a fallback here, I'm not sure why this is
limited to a single file system block.  Anything that:

  a) fits into the iomap
  b) fits into a single bio

can be easily supported.  The first condition is a trivial, and for
the second we could just check if iter->nr_segs is larger than
BIO_MAX_VECS.

> +	if (user_backed_iter(iter))
> +		dio_flags |= IOMAP_DIO_USER_BACKED;

> +	bio->bi_iter.bi_sector = iomap_sector(&iomi.iomap, iomi.pos);
> +	bio->bi_ioprio = iocb->ki_ioprio;
> +	bio->bi_private = sr;
> +	bio->bi_end_io = iomap_dio_simple_read_end_io;
> +
> +	if ((dio_flags & IOMAP_DIO_USER_BACKED) &&
> +	    !(dio_flags & IOMAP_DIO_BOUNCE))
> +		bio_set_pages_dirty(bio);
> +
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		bio->bi_opf |= REQ_NOWAIT;
> +	if ((iocb->ki_flags & IOCB_HIPRI) && !wait_for_completion) {
> +		bio->bi_opf |= REQ_POLLED;
> +		bio_set_polled(bio, iocb);
> +		WRITE_ONCE(iocb->private, bio);
> +	}

Can you check if sone more of this can be factored into a shared
helper?

Below is a completely untested patch implementing my suggestion
for the completion simplification.  It compiles, but that's about
the guarantees I can give for it:

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 3cb179752612..c785512e5339 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -909,11 +909,7 @@ struct iomap_dio_simple_read {
 	struct kiocb		*iocb;
 	size_t			size;
 	unsigned int		dio_flags;
-	atomic_t		state;
-	union {
-		struct task_struct	*waiter;
-		struct work_struct	work;
-	};
+	struct work_struct	work;
 	/*
 	 * Align @bio to a cacheline boundary so that, combined with the
 	 * front_pad passed to bioset_init(), the bio sits at the start of
@@ -926,35 +922,12 @@ struct iomap_dio_simple_read {
 
 static struct bio_set iomap_dio_simple_read_pool;
 
-/*
- * In the async simple read path, we need to prevent bio_endio() from
- * triggering iocb->ki_complete() before the submitter has returned
- * -EIOCBQUEUED. Otherwise, the caller might free the iocb concurrently.
- *
- * We use a three-state rendezvous to synchronize the submitter and end_io:
- *
- * IOMAP_DIO_SIMPLE_SUBMITTING: Initial state set before submitting the bio.
- *
- * IOMAP_DIO_SIMPLE_QUEUED: The submitter has safely queued the IO and will
- * return -EIOCBQUEUED. If end_io sees this state, it takes over and calls
- * ki_complete().
- *
- * IOMAP_DIO_SIMPLE_DONE: end_io fired before the submitter finished the
- * submit path. end_io sets this state and does nothing else. The submitter
- * will see this state and handle the completion synchronously (bypassing
- * ki_complete() and returning the actual result).
- */
-enum {
-	IOMAP_DIO_SIMPLE_SUBMITTING = 0,
-	IOMAP_DIO_SIMPLE_QUEUED,
-	IOMAP_DIO_SIMPLE_DONE,
-};
-
-static ssize_t iomap_dio_simple_read_finish(struct kiocb *iocb,
-		struct bio *bio, ssize_t ret)
+static ssize_t iomap_dio_simple_read_complete(struct iomap_dio_simple_read *sr)
 {
+	struct bio *bio = &sr->bio;
+	struct kiocb *iocb = sr->iocb;
 	struct inode *inode = file_inode(iocb->ki_filp);
-	struct iomap_dio_simple_read *sr = bio->bi_private;
+	ssize_t ret = blk_status_to_errno(bio->bi_status);
 
 	if (likely(!ret)) {
 		ret = sr->size;
@@ -965,21 +938,6 @@ static ssize_t iomap_dio_simple_read_finish(struct kiocb *iocb,
 	}
 
 	iomap_dio_bio_release_pages(bio, sr->dio_flags, ret < 0);
-
-	return ret;
-}
-
-static ssize_t iomap_dio_simple_read_complete(struct kiocb *iocb,
-		struct bio *bio)
-{
-	struct inode *inode = file_inode(iocb->ki_filp);
-	ssize_t ret;
-
-	WRITE_ONCE(iocb->private, NULL);
-
-	ret = iomap_dio_simple_read_finish(iocb, bio,
-			blk_status_to_errno(bio->bi_status));
-
 	inode_dio_end(inode);
 	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret > 0 ? ret : 0);
 	return ret;
@@ -988,45 +946,26 @@ static ssize_t iomap_dio_simple_read_complete(struct kiocb *iocb,
 static void iomap_dio_simple_read_complete_work(struct work_struct *work)
 {
 	struct iomap_dio_simple_read *sr =
-		container_of(work, struct iomap_dio_simple_read, work);
-	struct kiocb *iocb = sr->iocb;
-	ssize_t ret;
+			container_of(work, struct iomap_dio_simple_read, work);
 
-	ret = iomap_dio_simple_read_complete(iocb, &sr->bio);
-	iocb->ki_complete(iocb, ret);
+	WRITE_ONCE(sr->iocb->private, NULL);
+	sr->iocb->ki_complete(sr->iocb, iomap_dio_simple_read_complete(sr));
 }
 
-static void iomap_dio_simple_read_async_done(struct iomap_dio_simple_read *sr)
+static void iomap_dio_simple_read_end_io(struct bio *bio)
 {
-	struct kiocb *iocb = sr->iocb;
+	struct iomap_dio_simple_read *sr =
+		container_of(bio, struct iomap_dio_simple_read, bio);
 
 	if (unlikely(sr->bio.bi_status)) {
-		struct inode *inode = file_inode(iocb->ki_filp);
+		struct inode *inode = file_inode(sr->iocb->ki_filp);
 
 		INIT_WORK(&sr->work, iomap_dio_simple_read_complete_work);
 		queue_work(inode->i_sb->s_dio_done_wq, &sr->work);
 		return;
 	}
 
-	iomap_dio_simple_read_complete_work(&sr->work);
-}
-
-static void iomap_dio_simple_read_end_io(struct bio *bio)
-{
-	struct iomap_dio_simple_read *sr = bio->bi_private;
-
-	if (sr->waiter) {
-		struct task_struct *waiter = sr->waiter;
-
-		WRITE_ONCE(sr->waiter, NULL);
-		blk_wake_io_task(waiter);
-		return;
-	}
-
-	if (likely(atomic_read(&sr->state) == IOMAP_DIO_SIMPLE_QUEUED) ||
-	    atomic_cmpxchg(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING,
-			   IOMAP_DIO_SIMPLE_DONE) == IOMAP_DIO_SIMPLE_QUEUED)
-		iomap_dio_simple_read_async_done(sr);
+	sr->iocb->ki_complete(sr->iocb, iomap_dio_simple_read_complete(sr));
 }
 
 static inline bool iomap_dio_simple_read_supported(struct kiocb *iocb,
@@ -1046,11 +985,13 @@ static inline bool iomap_dio_simple_read_supported(struct kiocb *iocb,
 	 */
 	if (count > inode->i_sb->s_blocksize)
 		return false;
-	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL))
+	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
+			 IOMAP_DIO_BOUNCE))
 		return false;
 	if (iocb->ki_pos + count > i_size_read(inode))
 		return false;
 
+	// XXX: reject fscrypt
 	return true;
 }
 
@@ -1060,7 +1001,6 @@ static ssize_t iomap_dio_simple_read(struct kiocb *iocb,
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	size_t count = iov_iter_count(iter);
-	int nr_pages;
 	struct iomap_dio_simple_read *sr;
 	unsigned int alignment;
 	struct iomap_iter iomi = {
@@ -1074,11 +1014,6 @@ static ssize_t iomap_dio_simple_read(struct kiocb *iocb,
 	bool wait_for_completion = is_sync_kiocb(iocb);
 	ssize_t ret;
 
-	if (dio_flags & IOMAP_DIO_BOUNCE)
-		nr_pages = bio_iov_bounce_nr_vecs(iter, REQ_OP_READ);
-	else
-		nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS);
-
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iomi.flags |= IOMAP_NOWAIT;
 
@@ -1120,24 +1055,18 @@ static ssize_t iomap_dio_simple_read(struct kiocb *iocb,
 	if (user_backed_iter(iter))
 		dio_flags |= IOMAP_DIO_USER_BACKED;
 
-	bio = bio_alloc_bioset(iomi.iomap.bdev, nr_pages,
-			       REQ_OP_READ | REQ_SYNC | REQ_IDLE,
-			       GFP_KERNEL, &iomap_dio_simple_read_pool);
+	bio = bio_alloc_bioset(iomi.iomap.bdev,
+			bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
+			REQ_OP_READ | REQ_SYNC | REQ_IDLE,
+			GFP_KERNEL, &iomap_dio_simple_read_pool);
 	sr = container_of(bio, struct iomap_dio_simple_read, bio);
-
-	fscrypt_set_bio_crypt_ctx(bio, inode, iomi.pos, GFP_KERNEL);
 	sr->iocb = iocb;
 	sr->dio_flags = dio_flags;
 
 	bio->bi_iter.bi_sector = iomap_sector(&iomi.iomap, iomi.pos);
 	bio->bi_ioprio = iocb->ki_ioprio;
-	bio->bi_private = sr;
-	bio->bi_end_io = iomap_dio_simple_read_end_io;
 
-	if (dio_flags & IOMAP_DIO_BOUNCE)
-		ret = bio_iov_iter_bounce(bio, iter, count);
-	else
-		ret = bio_iov_iter_get_pages(bio, iter, alignment - 1);
+	ret = bio_iov_iter_get_pages(bio, iter, alignment - 1);
 	if (unlikely(ret))
 		goto out_bio_put;
 
@@ -1161,49 +1090,22 @@ static ssize_t iomap_dio_simple_read(struct kiocb *iocb,
 		WRITE_ONCE(iocb->private, bio);
 	}
 
-	if (wait_for_completion) {
-		sr->waiter = current;
-		blk_crypto_submit_bio(bio);
-	} else {
-		atomic_set(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING);
-		sr->waiter = NULL;
-		blk_crypto_submit_bio(bio);
-		ret = -EIOCBQUEUED;
-	}
-
 	if (ops->iomap_end)
 		ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
 			       &iomi.iomap);
 
-	if (wait_for_completion) {
-		for (;;) {
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			if (!READ_ONCE(sr->waiter))
-				break;
-			blk_io_schedule();
-		}
-		__set_current_state(TASK_RUNNING);
-
-		ret = iomap_dio_simple_read_finish(iocb, bio,
-				blk_status_to_errno(bio->bi_status));
-		inode_dio_end(inode);
-		trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0,
-					 ret > 0 ? ret : 0);
-	} else if (atomic_cmpxchg(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING,
-				  IOMAP_DIO_SIMPLE_QUEUED) ==
-		   IOMAP_DIO_SIMPLE_DONE) {
-		ret = iomap_dio_simple_read_complete(iocb, bio);
-	} else {
+	if (!wait_for_completion) {
+		bio->bi_end_io = iomap_dio_simple_read_end_io;
+		submit_bio(bio);
 		trace_iomap_dio_rw_queued(inode, iomi.pos, count);
+		return -EIOCBQUEUED;
 	}
 
-	return ret;
+	submit_bio_wait(bio);
+	return iomap_dio_simple_read_complete(sr);
 
 out_bio_release_pages:
-	if (dio_flags & IOMAP_DIO_BOUNCE)
-		bio_iov_iter_unbounce(bio, true, false);
-	else
-		bio_release_pages(bio, false);
+	bio_release_pages(bio, false);
 out_bio_put:
 	bio_put(bio);
 out_iomap_end:
