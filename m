Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C95358379
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 02:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782354293; cv=none; b=iIM/CzqaS78A9duh8tG1YTgHsun/fOTgxDlmMKYVJSoe17haUDdV6RtefW7Lh3079xv+EhKClef/b6EW/a/XjMPqodmjkf/Ebw2Nt7VnVx0UKheITPLN7smzCZ9KH2R6yFQcbN/ck2IbVA6TLMPla0ktKt0alzAlJaTu222w1oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782354293; c=relaxed/simple;
	bh=YN9iVpUcM/JZJozaZQLMWltb6cNG4E7B7QuYYCQ1iuU=;
	h=Content-Type:In-Reply-To:Date:Mime-Version:To:From:Message-Id:
	 References:Cc:Subject; b=ux6mXFKzf6Gmqef1P2GgIGjTuXFaNFAS+etvwYcUOJrTlqiqqhNNPpiiLGPz2QWXiAN2xoPxbISjty7t8UDnd2LNtPhh4HuiKZRcG8wwmqUu3Nh1zPfD1bXYTuTRtlhLvw1gpP7Ceo/DdPjHiVYjtU4Y0e4p+m3U35vTPzKYio0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=CUoXXSvL; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="CUoXXSvL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782354282; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=7OytZyb9otFtfIGullITk4Ck3jXIU6Jsyait6h8rTgA=;
 b=CUoXXSvLKZz0HBiJZT20gX0m+gkofl308A5m0BQMAtAOAYlcCDi6u4pj+q9kNH2bVE+jqQ
 ZXy/nfZYkyknbMv+G25YVTSxT8u+/DXfUatHjwPss4CaROgzZcTvRfAYlMApGwdLfIBVv5
 HTKcgIsDVRKXJzxuNJtSn+XjD2jFagTAqQmdYsvmG0lYZkHRny7qs3tUD7sY7F1Cc2L50J
 k0LY5r4sSd9mITHCYWKUqgLumfv0ZUqXGMj3PkELvMbfPEBBJ5hNUiEbaIqAqym0GkWuwJ
 haBEfsD8w3aZnhHs8GA5nny6+4jqCizhdkKPzSYceH++xFyEe7IRhvIjQJ5xtQ==
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <ajv5pqNureiK80Eu@infradead.org>
Date: Thu, 25 Jun 2026 10:24:25 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a3c9168+9d4b16+vger.kernel.org+changfengnan@bytedance.com>
To: "Christoph Hellwig" <hch@infradead.org>
From: "Fengnan" <changfengnan@bytedance.com>
Message-Id: <6f9bd250-1808-4396-9f6b-4987a7ac7ee0@bytedance.com>
X-Original-From: Fengnan <changfengnan@bytedance.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
References: <20260608073134.95964-1-changfengnan@bytedance.com> <ajv5pqNureiK80Eu@infradead.org>
Cc: <brauner@kernel.org>, <djwong@kernel.org>, <ojaswin@linux.ibm.com>, 
	<dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>
Subject: Re: [PATCH v4] iomap: add simple read path for small direct I/O

=E5=9C=A8 2026/6/24 23:37, Christoph Hellwig =E5=86=99=E9=81=93:
> Sorry for the delay in getting back to this, I'm a bit overloaded at
> the moment.
>
>> -static inline bool should_report_dio_fserror(const struct iomap_dio *di=
o)
>> +static inline bool should_report_dio_fserror(int error)
> Can you split all the refactoring into prep patches?
off course

>
>> +/*
>> + * In the async simple read path, we need to prevent bio_endio() from
>> + * triggering iocb->ki_complete() before the submitter has returned
>> + * -EIOCBQUEUED. Otherwise, the caller might free the iocb concurrently=
.
>> + *
>> + * We use a three-state rendezvous to synchronize the submitter and end=
_io:
>> + *
>> + * IOMAP_DIO_SIMPLE_SUBMITTING: Initial state set before submitting the=
 bio.
>> + *
>> + * IOMAP_DIO_SIMPLE_QUEUED: The submitter has safely queued the IO and =
will
>> + * return -EIOCBQUEUED. If end_io sees this state, it takes over and ca=
lls
>> + * ki_complete().
>> + *
>> + * IOMAP_DIO_SIMPLE_DONE: end_io fired before the submitter finished th=
e
>> + * submit path. end_io sets this state and does nothing else. The submi=
tter
>> + * will see this state and handle the completion synchronously (bypassi=
ng
>> + * ki_complete() and returning the actual result).
>> + */
> I don't think we actually need any of this.  For the sync case we
> can just use submit_bio_wait, and for async just always complete
> from the end_io handler.  This will simplify the implementation a lot,
> and also avoid the atomic.

I was wrong before, in simple read path, we won't use sr after submit bio.
>
>> +static void iomap_dio_simple_read_async_done(struct iomap_dio_simple_re=
ad *sr)
> Btw, I'd drop the _read in the name.  Most of this would work as-is
> for trivial overwrites if we figure out when to use them.
ok, let's rename to iomap_dio_simple_xxx

>
>> +	if (dio_flags & IOMAP_DIO_BOUNCE)
>> +		nr_pages =3D bio_iov_bounce_nr_vecs(iter, REQ_OP_READ);
>> +	else
>> +		nr_pages =3D bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS);
> Bounce buffering requires dops, so all this can be dropped.
Get .
>
>> +	ret =3D ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
>> +			       &iomi.iomap, &iomi.srcmap);
>> +	if (ret) {
>> +		inode_dio_end(inode);
>> +		return ret;
>> +	}
>> +
>> +	if (iomi.iomap.type !=3D IOMAP_MAPPED ||
>> +	    iomi.iomap.offset > iomi.pos ||
> I don't think offset > pos can happen

>
>> +	    iomi.iomap.offset + iomi.iomap.length < iomi.pos + count ||
>> +	    (iomi.iomap.flags & IOMAP_F_INTEGRITY)) {
>> +		ret =3D -ENOTBLK;
>> +		goto out_iomap_end;
>> +	}
> Given that we already have a fallback here, I'm not sure why this is
> limited to a single file system block.  Anything that:
>
>    a) fits into the iomap
>    b) fits into a single bio
>
> can be easily supported.  The first condition is a trivial, and for
> the second we could just check if iter->nr_segs is larger than
> BIO_MAX_VECS.
The reason I only added a simple path for 4K reads is that, in current
NVMe, 4K random reads suffer from a significant bottleneck, whereas
8K reads and 4K writes do not.
Considering that if an 8K or larger block size does not fit within a single
BIO, two iomap_begin/iomap_end calls would be required, resulting in
additional overhead.
Of course, even without considering this scenario, there would still be
some benefit, it=E2=80=99s just not as significant.
How do you approach this issue?

>
>> +	if (user_backed_iter(iter))
>> +		dio_flags |=3D IOMAP_DIO_USER_BACKED;
>> +	bio->bi_iter.bi_sector =3D iomap_sector(&iomi.iomap, iomi.pos);
>> +	bio->bi_ioprio =3D iocb->ki_ioprio;
>> +	bio->bi_private =3D sr;
>> +	bio->bi_end_io =3D iomap_dio_simple_read_end_io;
>> +
>> +	if ((dio_flags & IOMAP_DIO_USER_BACKED) &&
>> +	    !(dio_flags & IOMAP_DIO_BOUNCE))
>> +		bio_set_pages_dirty(bio);
>> +
>> +	if (iocb->ki_flags & IOCB_NOWAIT)
>> +		bio->bi_opf |=3D REQ_NOWAIT;
>> +	if ((iocb->ki_flags & IOCB_HIPRI) && !wait_for_completion) {
>> +		bio->bi_opf |=3D REQ_POLLED;
>> +		bio_set_polled(bio, iocb);
>> +		WRITE_ONCE(iocb->private, bio);
>> +	}
> Can you check if sone more of this can be factored into a shared
> helper?
I'll try.

>
> Below is a completely untested patch implementing my suggestion
> for the completion simplification.  It compiles, but that's about
> the guarantees I can give for it:
I'll apply and do some test.

>
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 3cb179752612..c785512e5339 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -909,11 +909,7 @@ struct iomap_dio_simple_read {
>   	struct kiocb		*iocb;
>   	size_t			size;
>   	unsigned int		dio_flags;
> -	atomic_t		state;
> -	union {
> -		struct task_struct	*waiter;
> -		struct work_struct	work;
> -	};
> +	struct work_struct	work;
>   	/*
>   	 * Align @bio to a cacheline boundary so that, combined with the
>   	 * front_pad passed to bioset_init(), the bio sits at the start of
> @@ -926,35 +922,12 @@ struct iomap_dio_simple_read {
>  =20
>   static struct bio_set iomap_dio_simple_read_pool;
>  =20
> -/*
> - * In the async simple read path, we need to prevent bio_endio() from
> - * triggering iocb->ki_complete() before the submitter has returned
> - * -EIOCBQUEUED. Otherwise, the caller might free the iocb concurrently.
> - *
> - * We use a three-state rendezvous to synchronize the submitter and end_=
io:
> - *
> - * IOMAP_DIO_SIMPLE_SUBMITTING: Initial state set before submitting the =
bio.
> - *
> - * IOMAP_DIO_SIMPLE_QUEUED: The submitter has safely queued the IO and w=
ill
> - * return -EIOCBQUEUED. If end_io sees this state, it takes over and cal=
ls
> - * ki_complete().
> - *
> - * IOMAP_DIO_SIMPLE_DONE: end_io fired before the submitter finished the
> - * submit path. end_io sets this state and does nothing else. The submit=
ter
> - * will see this state and handle the completion synchronously (bypassin=
g
> - * ki_complete() and returning the actual result).
> - */
> -enum {
> -	IOMAP_DIO_SIMPLE_SUBMITTING =3D 0,
> -	IOMAP_DIO_SIMPLE_QUEUED,
> -	IOMAP_DIO_SIMPLE_DONE,
> -};
> -
> -static ssize_t iomap_dio_simple_read_finish(struct kiocb *iocb,
> -		struct bio *bio, ssize_t ret)
> +static ssize_t iomap_dio_simple_read_complete(struct iomap_dio_simple_re=
ad *sr)
>   {
> +	struct bio *bio =3D &sr->bio;
> +	struct kiocb *iocb =3D sr->iocb;
>   	struct inode *inode =3D file_inode(iocb->ki_filp);
> -	struct iomap_dio_simple_read *sr =3D bio->bi_private;
> +	ssize_t ret =3D blk_status_to_errno(bio->bi_status);
>  =20
>   	if (likely(!ret)) {
>   		ret =3D sr->size;
> @@ -965,21 +938,6 @@ static ssize_t iomap_dio_simple_read_finish(struct k=
iocb *iocb,
>   	}
>  =20
>   	iomap_dio_bio_release_pages(bio, sr->dio_flags, ret < 0);
> -
> -	return ret;
> -}
> -
> -static ssize_t iomap_dio_simple_read_complete(struct kiocb *iocb,
> -		struct bio *bio)
> -{
> -	struct inode *inode =3D file_inode(iocb->ki_filp);
> -	ssize_t ret;
> -
> -	WRITE_ONCE(iocb->private, NULL);
> -
> -	ret =3D iomap_dio_simple_read_finish(iocb, bio,
> -			blk_status_to_errno(bio->bi_status));
> -
>   	inode_dio_end(inode);
>   	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret > 0 ? ret : 0);
>   	return ret;
> @@ -988,45 +946,26 @@ static ssize_t iomap_dio_simple_read_complete(struc=
t kiocb *iocb,
>   static void iomap_dio_simple_read_complete_work(struct work_struct *wor=
k)
>   {
>   	struct iomap_dio_simple_read *sr =3D
> -		container_of(work, struct iomap_dio_simple_read, work);
> -	struct kiocb *iocb =3D sr->iocb;
> -	ssize_t ret;
> +			container_of(work, struct iomap_dio_simple_read, work);
>  =20
> -	ret =3D iomap_dio_simple_read_complete(iocb, &sr->bio);
> -	iocb->ki_complete(iocb, ret);
> +	WRITE_ONCE(sr->iocb->private, NULL);
> +	sr->iocb->ki_complete(sr->iocb, iomap_dio_simple_read_complete(sr));
>   }
>  =20
> -static void iomap_dio_simple_read_async_done(struct iomap_dio_simple_rea=
d *sr)
> +static void iomap_dio_simple_read_end_io(struct bio *bio)
>   {
> -	struct kiocb *iocb =3D sr->iocb;
> +	struct iomap_dio_simple_read *sr =3D
> +		container_of(bio, struct iomap_dio_simple_read, bio);
>  =20
>   	if (unlikely(sr->bio.bi_status)) {
> -		struct inode *inode =3D file_inode(iocb->ki_filp);
> +		struct inode *inode =3D file_inode(sr->iocb->ki_filp);
>  =20
>   		INIT_WORK(&sr->work, iomap_dio_simple_read_complete_work);
>   		queue_work(inode->i_sb->s_dio_done_wq, &sr->work);
>   		return;
>   	}
>  =20
> -	iomap_dio_simple_read_complete_work(&sr->work);
> -}
> -
> -static void iomap_dio_simple_read_end_io(struct bio *bio)
> -{
> -	struct iomap_dio_simple_read *sr =3D bio->bi_private;
> -
> -	if (sr->waiter) {
> -		struct task_struct *waiter =3D sr->waiter;
> -
> -		WRITE_ONCE(sr->waiter, NULL);
> -		blk_wake_io_task(waiter);
> -		return;
> -	}
> -
> -	if (likely(atomic_read(&sr->state) =3D=3D IOMAP_DIO_SIMPLE_QUEUED) ||
> -	    atomic_cmpxchg(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING,
> -			   IOMAP_DIO_SIMPLE_DONE) =3D=3D IOMAP_DIO_SIMPLE_QUEUED)
> -		iomap_dio_simple_read_async_done(sr);
> +	sr->iocb->ki_complete(sr->iocb, iomap_dio_simple_read_complete(sr));
>   }
>  =20
>   static inline bool iomap_dio_simple_read_supported(struct kiocb *iocb,
> @@ -1046,11 +985,13 @@ static inline bool iomap_dio_simple_read_supported=
(struct kiocb *iocb,
>   	 */
>   	if (count > inode->i_sb->s_blocksize)
>   		return false;
> -	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL))
> +	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
> +			 IOMAP_DIO_BOUNCE))
>   		return false;
>   	if (iocb->ki_pos + count > i_size_read(inode))
>   		return false;
>  =20
> +	// XXX: reject fscrypt
>   	return true;
>   }
>  =20
> @@ -1060,7 +1001,6 @@ static ssize_t iomap_dio_simple_read(struct kiocb *=
iocb,
>   {
>   	struct inode *inode =3D file_inode(iocb->ki_filp);
>   	size_t count =3D iov_iter_count(iter);
> -	int nr_pages;
>   	struct iomap_dio_simple_read *sr;
>   	unsigned int alignment;
>   	struct iomap_iter iomi =3D {
> @@ -1074,11 +1014,6 @@ static ssize_t iomap_dio_simple_read(struct kiocb =
*iocb,
>   	bool wait_for_completion =3D is_sync_kiocb(iocb);
>   	ssize_t ret;
>  =20
> -	if (dio_flags & IOMAP_DIO_BOUNCE)
> -		nr_pages =3D bio_iov_bounce_nr_vecs(iter, REQ_OP_READ);
> -	else
> -		nr_pages =3D bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS);
> -
>   	if (iocb->ki_flags & IOCB_NOWAIT)
>   		iomi.flags |=3D IOMAP_NOWAIT;
>  =20
> @@ -1120,24 +1055,18 @@ static ssize_t iomap_dio_simple_read(struct kiocb=
 *iocb,
>   	if (user_backed_iter(iter))
>   		dio_flags |=3D IOMAP_DIO_USER_BACKED;
>  =20
> -	bio =3D bio_alloc_bioset(iomi.iomap.bdev, nr_pages,
> -			       REQ_OP_READ | REQ_SYNC | REQ_IDLE,
> -			       GFP_KERNEL, &iomap_dio_simple_read_pool);
> +	bio =3D bio_alloc_bioset(iomi.iomap.bdev,
> +			bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
> +			REQ_OP_READ | REQ_SYNC | REQ_IDLE,
> +			GFP_KERNEL, &iomap_dio_simple_read_pool);
>   	sr =3D container_of(bio, struct iomap_dio_simple_read, bio);
> -
> -	fscrypt_set_bio_crypt_ctx(bio, inode, iomi.pos, GFP_KERNEL);
>   	sr->iocb =3D iocb;
>   	sr->dio_flags =3D dio_flags;
>  =20
>   	bio->bi_iter.bi_sector =3D iomap_sector(&iomi.iomap, iomi.pos);
>   	bio->bi_ioprio =3D iocb->ki_ioprio;
> -	bio->bi_private =3D sr;
> -	bio->bi_end_io =3D iomap_dio_simple_read_end_io;
>  =20
> -	if (dio_flags & IOMAP_DIO_BOUNCE)
> -		ret =3D bio_iov_iter_bounce(bio, iter, count);
> -	else
> -		ret =3D bio_iov_iter_get_pages(bio, iter, alignment - 1);
> +	ret =3D bio_iov_iter_get_pages(bio, iter, alignment - 1);
>   	if (unlikely(ret))
>   		goto out_bio_put;
>  =20
> @@ -1161,49 +1090,22 @@ static ssize_t iomap_dio_simple_read(struct kiocb=
 *iocb,
>   		WRITE_ONCE(iocb->private, bio);
>   	}
>  =20
> -	if (wait_for_completion) {
> -		sr->waiter =3D current;
> -		blk_crypto_submit_bio(bio);
> -	} else {
> -		atomic_set(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING);
> -		sr->waiter =3D NULL;
> -		blk_crypto_submit_bio(bio);
> -		ret =3D -EIOCBQUEUED;
> -	}
> -
>   	if (ops->iomap_end)
>   		ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
>   			       &iomi.iomap);
>  =20
> -	if (wait_for_completion) {
> -		for (;;) {
> -			set_current_state(TASK_UNINTERRUPTIBLE);
> -			if (!READ_ONCE(sr->waiter))
> -				break;
> -			blk_io_schedule();
> -		}
> -		__set_current_state(TASK_RUNNING);
> -
> -		ret =3D iomap_dio_simple_read_finish(iocb, bio,
> -				blk_status_to_errno(bio->bi_status));
> -		inode_dio_end(inode);
> -		trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0,
> -					 ret > 0 ? ret : 0);
> -	} else if (atomic_cmpxchg(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING,
> -				  IOMAP_DIO_SIMPLE_QUEUED) =3D=3D
> -		   IOMAP_DIO_SIMPLE_DONE) {
> -		ret =3D iomap_dio_simple_read_complete(iocb, bio);
> -	} else {
> +	if (!wait_for_completion) {
> +		bio->bi_end_io =3D iomap_dio_simple_read_end_io;
> +		submit_bio(bio);
>   		trace_iomap_dio_rw_queued(inode, iomi.pos, count);
> +		return -EIOCBQUEUED;
>   	}
>  =20
> -	return ret;
> +	submit_bio_wait(bio);
> +	return iomap_dio_simple_read_complete(sr);
>  =20
>   out_bio_release_pages:
> -	if (dio_flags & IOMAP_DIO_BOUNCE)
> -		bio_iov_iter_unbounce(bio, true, false);
> -	else
> -		bio_release_pages(bio, false);
> +	bio_release_pages(bio, false);
>   out_bio_put:
>   	bio_put(bio);
>   out_iomap_end:
