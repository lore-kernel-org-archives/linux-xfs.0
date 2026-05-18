Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31263246F4;
	Mon, 18 May 2026 06:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779086899; cv=none; b=XMattViULaifyQ7e/1EOan+Z2A3s02dKKWyqQIuZMiLtKMI3ePrLVIxQJE1qDUb40zOO+uJm6unIFGwUodhcr/WYBnN3iZrFvhQHBgFPUFEiDYsq4etSuGivaFMj19xg54VyyZYzW66MI+A/T1TzMTE69u/zQlC4gpYJdXH4yp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779086899; c=relaxed/simple;
	bh=kqZg1RRtDe2nEefgCSyIfrLurXbbJ6IaMqIK6ptMdl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1OePbRqV/vyw0oVX1nkIS2/aqME/5PgmRFFn+kjv5f4496ESyhWiIBqrXyB5wFL9A+o8wqZt6ZO4QkOD1/yXTAyodsEgJ3qsBBw+pfeXybj2B4WWPyVVMgrc1iidoKI2QEOx1nCToLVBLVYkgHe9ah589amheUmpm+3iW8S3FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q2RkAlOA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q2RkAlOA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=6QlzVHg/VJtWXf7fgwcVOARPx/LzCTC/cqL++r1Bxj8=; b=q2RkAlOADHQeGt9L5UyoaQwDJv
	ZQx/5j3Ebjw42T3EHsqG3owxB9wcEbB6IeR46UrKNkyNjZsJ1ZPyFfRO99Pq7rdIzRjIjhqY/AgwG
	2RHy4eLnSxmxfBP9PCyupAOmUgtVUy3QUiQtC/yw7TfXbpnHSGpOOZPBhw1I725qA/78wDtJfQ+2a
	BDLG4hAxsYX6LGB0fomexQDlVkaQxBk+84Xm98/78ClzG3v52AxBwd7LxXEu4md71daVbRlAAol2n
	WCbwu+jFGYMvJT3GJfVulk+JhK4cHftGW81kWWZoQaC3ARwxhPgGhxEnqlhKyuyAo74oYYnHtAcie
	0CQTAqvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrlq-0000000ETRO-04oH;
	Mon, 18 May 2026 06:48:10 +0000
Date: Sun, 17 May 2026 23:48:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <agq2KRd8RkP1TAf5@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 14, 2026 at 05:51:14PM -0400, Tal Zussman wrote:
> Some bio completion handlers need to run from preemptible task context,
> but bio_endio() may be called from IRQ context (e.g., buffer_head
> writeback). Callers need a way to ensure their callback eventually runs
> from a sleepable context. Add infrastructure for that, in two forms:
> 
>   1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
>      in advance that its callback needs task context (e.g., dropbehind
>      writeback). bio_endio() sees the flag and offloads completion to a
>      worker automatically.
> 
>   2. bio_complete_in_task(), a helper that completion callbacks can
>      invoke from within bi_end_io() when the deferral decision is
>      dynamic (e.g., fserror reporting).

Note that method 2 is unused as of this series.  I do plan to add users
ASAP, and at one or two could even land through the block layer in this
merge window.

> Both share a per-CPU batch list drained by a delayed work item on a
> WQ_PERCPU workqueue. Producers push the bio onto the local CPU's batch
> and schedule the work item, which then dispatches each bio's bi_end_io()
> from task context. The delayed work item uses a 1-jiffie delay to allow
> batches of completions to accumulate before processing.

But this 1-jiffie delay also means we unconditionally increase
completion latency, which feels like a bad idea.  Do you have any
measurements that show where it does benefit?  Note that queing work
already often has very measurable latency on it's own.  This also
directly contradics the erofs experience that even went to a RT
thread to reduce the latency.

> Both methods are gated on bio_in_atomic(), which returns true in any
> context where a sleeping bi_end_io() is unsafe, including
> non-preemptible task context. This logic is copied from commit
> c99fab6e80b7 ("erofs: fix atomic context detection when
> !CONFIG_DEBUG_LOCK_ALLOC").

Let's not copy it, but have a prep patch that moves the erofs logic
into the block layer under the new bio_in_atomic name.

> +		while ((bio = bio_list_pop(&list)))
> +			bio->bi_end_io(bio);
> +
> +		if (need_resched()) {
> +			bool is_empty;
> +
> +			local_lock_irq(&bio_complete_batch.lock);
> +			is_empty = bio_list_empty(&batch->list);
> +			local_unlock_irq(&bio_complete_batch.lock);
> +			if (!is_empty)
> +				mod_delayed_work_on(batch->cpu,
> +						    bio_complete_wq,
> +						    &batch->work, 0);
> +			break;
> +		}
> +	}

Ån all mainstream architetures we now default to lazy preempt, which
should remove the need for need_resched() calls.  Do you have evidence
that we actually need this handling on recent kernels?

Otherwise this looks good to me.
