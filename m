Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405A2346AD6;
	Tue, 30 Jun 2026 11:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782820129; cv=none; b=TKeOAWxb+OR5qXrXoi3Tza3z481toU2qwRScnXoWCjKZC8UitQWNYBKim12q9FXsi4uiemwmGlq30xDirwoD2GoIRtOOU8S6ej0tI2j3tOU15/Fa6/qSuR3C9JXjGipNrxOGv/aFx1rWWXHgw8dpehnMLlWQ0OFCU8jxHGfJNac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782820129; c=relaxed/simple;
	bh=sw/xZYZ7Ir7A52GOlocplivHztuhGIYD/SJF9Wzg360=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7vOPx1VXbKb8g37JQfhnwnPOWrHOC2413EIxBlSzkNxYO/0NRMziG81+ZyP+030LNhrbeCF7gR3B/FQjvXCKREUCLQFDtS47V6aVXp9vOQPE6+WVZqGJYVy2REK6XJP/NZgvDBvLgN/eb29y64fGnAHJ4hVvy6CaAkWvs3DMRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=itceAvM5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="itceAvM5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3pRI0I/sedCyfhTiQbpEge2gLbMRG4ocIB2FDj+0Hg0=; b=itceAvM5VG5GscShzJI3l+ke+H
	/+Q4+ic+ZFnzPSc07R6c6laIlwbr5bQ7tRpj/57hdL22lQ3llaa6UbGLYFp2/AO4FSevVK6ulzXrw
	zl0xvzpVOWUuEgilhxanrYUR0z3sm763PuSdXsJJM1bB/qwp/lIKwDWme5AGpovDWRAPmZvExGsXE
	Ha3OpamVRs1bj8NMdK492425y369J+E0iko3x/H8AqkLxw2EOsgLF4D4OsDmBCeInlyXK/Rbgmcjg
	NNQ9IohuRjQowF7CAdLeOY0O7v1ubzg79IWxgQuZh5tlUQ9snG+JOXcs6gzmK2fC6oKKDulRtwH//
	2doOIZrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weWxH-0000000GstI-2Khv;
	Tue, 30 Jun 2026 11:48:43 +0000
Date: Tue, 30 Jun 2026 04:48:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com,
	pankaj.raghav@linux.dev
Subject: Re: [PATCH v5 4/4] iomap: add simple dio path for small direct I/O
Message-ID: <akOtG5_gNb8btWCx@infradead.org>
References: <20260629120124.25223-1-changfengnan@bytedance.com>
 <20260629120124.25223-5-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629120124.25223-5-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 29, 2026 at 08:01:24PM +0800, Fengnan Chang wrote:
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>

I don't think these two headers are actually used by the new code.

> +struct iomap_dio_simple {
> +	struct kiocb		*iocb;
> +	size_t			size;
> +	unsigned int		dio_flags;
> +	struct work_struct	work;
> +	/*
> +	 * Align @bio to a cacheline boundary so that, combined with the
> +	 * front_pad passed to bioset_init(), the bio sits at the start of
> +	 * a cacheline in memory returned by the (HWCACHE-aligned) bio
> +	 * slab.  This keeps the hot fields block layer touches on submit
> +	 * and completion (bi_iter, bi_status, ...) within a single line.
> +	 */
> +	struct bio	bio ____cacheline_aligned_in_smp;

Add an extra tab here so it aligns with the fields above the comment?

> +	int error = blk_status_to_errno(bio->bi_status);
> +	ssize_t ret = error;
> +
> +	if (likely(!ret)) {
> +		ret = sr->size;
> +		iocb->ki_pos += ret;
> +	} else if (should_report_dio_fserror(ret)) {
> +		fserror_report_io(inode, FSERR_DIRECTIO_READ, iocb->ki_pos,
> +				  sr->size, ret, GFP_NOFS);
> +	}
> +
> +	iomap_dio_bio_release_pages(bio, sr->dio_flags, ret < 0);
> +	inode_dio_end(inode);
> +	trace_iomap_dio_complete(iocb, error, ret);

I think some of this could be micro-optimized a bit more and
cleaned up at the same time:

	ssize_t ret;

	if (unlikely(bio->bi_status) {
		ret = blk_status_to_errno(bio->bi_status);
		if (should_report_dio_fserror(ret)) {
			fserror_report_io(inode, FSERR_DIRECTIO_READ,
					iocb->ki_pos, sr->size, ret,
					GFP_NOFS);
		}
	} else {
		ret = sr->size;
		iocb->ki_pos += ret;
	}

	iomap_dio_bio_release_pages(bio, sr->dio_flags, ret < 0);
	inode_dio_end(inode);
	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret);

	return ret;

> +
> +static void iomap_dio_simple_complete_work(struct work_struct *work)
> +{
> +	struct iomap_dio_simple *sr =
> +			container_of(work, struct iomap_dio_simple, work);

A single tab indent is enough here. (and used in the next function)

> +	struct bio *bio;
> +	bool wait_for_completion = is_sync_kiocb(iocb);
> +	ssize_t ret;

Nitpick: keep variables initialized at declaration time above those
that are not initalized.

> +	/*
> +	 * Fast path for small, block-aligned direct I/Os that map to a
> +	 * single contiguous on-disk extent.
> +	 *
> +	 * @dops must be NULL: a non-NULL @dops means the caller wants its
> +	 * ->end_io / ->submit_io hooks invoked, and in particular wants its
> +	 * bios to be allocated from the filesystem-private @dops->bio_set
> +	 * (whose front_pad sizes a filesystem-private wrapper around the
> +	 * bio).  The fast path instead allocates from the shared
> +	 * iomap_dio_simple_pool, whose front_pad matches
> +	 * struct iomap_dio_simple; the two wrappers are not
> +	 * interchangeable, so we must fall back to __iomap_dio_rw() in
> +	 * that case.
> +	 *
> +	 * @done_before must be zero: a non-zero caller-accumulated residual
> +	 * cannot be carried through a single-bio inline completion.
> +	 *
> +	 * -ENOTBLK is the private sentinel returned by iomap_dio_simple()
> +	 * when it decides the request does not fit the fast path.
> +	 * In that case we proceed to the generic __iomap_dio_rw() slow
> +	 * path.  Any other errno is a real result and is propagated as-is,
> +	 * in particular -EAGAIN for IOCB_NOWAIT must reach the caller.

I think this documentation belongs above iomap_dio_simple, not
here.  And maye it should also mention that iomap_dio_simple_supported
enforces these limitations.  Mostly anyway, and maybe the other two
checks should go into that as well for completeness?

