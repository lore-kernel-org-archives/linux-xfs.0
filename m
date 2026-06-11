Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9C83BE144
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 09:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781170646; cv=none; b=GOoBtB/3MKy9RuhbOj73/5fL7duofpPzcuC2uZceLYXo+atO3s70TfM1kRb89trpbOzUmkdUYRXq02lLlP6wkNG+3GhK8SjSWYuN7T/rgWRd7oiqgZImJ5cxXdoIKDhJHE9TvXM8T1r9N6WeP73jkY79PeoN2eUmjJ2ZzCcAjFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781170646; c=relaxed/simple;
	bh=tH7WGG5PJoYEKjsOUYn41zNOkcxmQEP9Rp8HQcrXjEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8I3XJh8H/IENZVJN6Z8gPCfY+LUTBcC74Tn3psjL0RNtc5eAQ/K12nluYMfba/73/0vvYnDtnX6SnPzKuSH3Z1zc9E0iQ2vl5WWWwulfdn3UfSmDAf39DJ+aQ77CfhvVhHz2eukT8niYndtOrBluvMAgOPlFoI8TTlbLPhLy/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NmsqS6o+; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NmsqS6o+"
Date: Thu, 11 Jun 2026 09:36:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781170632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PP9RH5eglWRADP2z+IgM/rYFF4ySyQJxH6xHTsVvGDs=;
	b=NmsqS6o+ysm74oruF52zgGiVoxDtkrZE+Yp4k+UAn9om6XZVnLGwm0tqKRiHYOc7mzur2r
	bmpNmtGR9eNnHqxnGVrGYVGD2OeIlOFGPWaEEQWmpktHFWGp7CoZN+n/45DujeRTdURvtz
	jxX55Yh44ohoI5Ol/H06JJoPLk1HiqE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org, 
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lidiangang@bytedance.com, p.raghav@samsung.com
Subject: Re: [PATCH v4] iomap: add simple read path for small direct I/O
Message-ID: <mmbe4kdeqg6zlblhysi27qno22dtkaahv7bzslaqopsg4k3qs7@nofv525nnl6c>
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
X-Migadu-Flow: FLOW_OUT

> +static ssize_t iomap_dio_simple_read_complete(struct kiocb *iocb,
> +		struct bio *bio)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	ssize_t ret;
> +
> +	WRITE_ONCE(iocb->private, NULL);
> +
> +	ret = iomap_dio_simple_read_finish(iocb, bio,
> +			blk_status_to_errno(bio->bi_status));
> +
> +	inode_dio_end(inode);
> +	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret > 0 ? ret : 0);

Shouldn't the second parameter here be
blk_status_to_errno(bio->bi_status)?

I think that will be more meaningful for tracing here.
trace_iomap_dio_complete(iocb, blk_status_to_errno(bio->bi_status), ret);

<snip>
> +	return ret;
> +}
> +
> +	sr->iocb = iocb;
> +	sr->dio_flags = dio_flags;
> +
> +	bio->bi_iter.bi_sector = iomap_sector(&iomi.iomap, iomi.pos);
> +	bio->bi_ioprio = iocb->ki_ioprio;
> +	bio->bi_private = sr;
> +	bio->bi_end_io = iomap_dio_simple_read_end_io;
> +
> +	if (dio_flags & IOMAP_DIO_BOUNCE)
> +		ret = bio_iov_iter_bounce(bio, iter, count);
> +	else
> +		ret = bio_iov_iter_get_pages(bio, iter, alignment - 1);
> +	if (unlikely(ret))
> +		goto out_bio_put;
> +
> +	if (bio->bi_iter.bi_size != count) {
> +		iov_iter_revert(iter, bio->bi_iter.bi_size);
> +		ret = -ENOTBLK;
> +		goto out_bio_release_pages;
> +	}
> +
> +	sr->size = bio->bi_iter.bi_size;
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

This results in build failure as the following patch removed this call:
https://lore.kernel.org/linux-block/20260518062917.506483-1-hch@lst.de/

I think this call can just be removed as you are setting REQ_POLLED
anyway.

> +		WRITE_ONCE(iocb->private, bio);
> +	}
> +
> +	if (wait_for_completion) {
> +		sr->waiter = current;
> +		blk_crypto_submit_bio(bio);
> +	} else {
> +		atomic_set(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING);
> +		sr->waiter = NULL;
> +		blk_crypto_submit_bio(bio);
> +		ret = -EIOCBQUEUED;
> +	}
> +
--
Pankaj
