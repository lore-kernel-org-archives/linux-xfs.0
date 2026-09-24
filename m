Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7661D4B716B;
	Thu, 24 Sep 2026 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275760; cv=none; b=HTLkBNANyfzJ0NNaJFtfh17f41skiQzKfTnQ5Ov6A7xg7JXD2gqgP9fsXj3SmH6xaxCwAItUAIwufsiVsaQqUrj4vUI3UCMQz/DDFn2uFq9ljzrGeOWy/EKgbfzhYFpmg3WWiPTdM9//IrD0iyAofZpJUNkDgLTLJShEqSqDhzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275760; c=relaxed/simple;
	bh=wWFMz0BI2jj7rQ0InITpgf4wAXLKCNiZef8BRCaO6Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FVmCfZritl0eHyR7Cs8gTmiGoWa4waHtgoWFTsvWnMTvh4epxqOCvydQ4iZfsT+/SO+hMkc8tkoEzhLlNrdvwKiyISdZEC8D+lRaV8MmtRL9zPpm5TDIqQmT4QDZI4tqkIvizXF8/iADqoVKbS4ZzMGRLDSXAwsqNbhafJbuOJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJRK6keN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJRK6keN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AFD7F1F000FF;
	Thu, 24 Sep 2026 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790275750;
	bh=r3K6A4rh3gkfpjLLzhEDske3Q1zq3Souvc7M5qJn/Lw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mJRK6keNHyEKuBbLKoIIjxXXraoTVay7nUL1hEGMSXdRJHl860Y47+x3ogs41gsy+
	 dorGcFagt5dyp6lJHLe13tDRiueQRsFeOxS3KMEAVH04E7yFyJwng2DeQ+wysB+7j9
	 a81lgGHNMVpm47XONOjhs8dE+20uicUz33KGoS6bOE90nlUXlvy7x2JdBy7tyX15xJ
	 hD9VW3cItvCJRqspLxKfKOvp0zVJl7A2Aplwy+xE+wSSr+pRKVvh4YtHy0j7bQ28c+
	 B0L8zHZdOwjDNxo9Wmov031RhLz2KPKtM91Khn5ehHmHyfaHwlYjd4XbUSbBVgX9J2
	 z3vMDJp/9JWbQ==
Date: Thu, 24 Sep 2026 11:49:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <20260924184910.GI2705364@frogsfrogsfrogs>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-2-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091203.198225-2-parri.andrea@gmail.com>

On Thu, Sep 24, 2026 at 11:11:51AM +0200, Andrea Parri wrote:
> iomap_add_to_ioend() submits the pending ioend through
> ->writeback_submit() before allocating a new one for the current range.
> When the submission fails the helper completes the ioend with an error,
> but iomap_add_to_ioend() returns the error without clearing
> wpc->wb_ctx.  iomap_writepages() then submits whatever wpc->wb_ctx
> points to, so the already completed ioend is submitted a second time.
> 
> For XFS the second bio_endio() lands in xfs_end_bio(), which
> list_add_tail()s the already linked ioend into ip->i_ioend_list.  This
> corrupts the list and leaves a use-after-free/double-free window against
> the ioend completion worker.  Reproduced with a fault-injected
> ->writeback_submit() failure on a reflinked XFS file with several
> CoW writeback ranges in flight: the unfixed kernel hits repeated
> "list_add double add" warnings from __list_add_valid_or_report(),
> the fixed kernel fails writeback cleanly.
> 
> Clear wpc->wb_ctx when ->writeback_submit() fails.  The old
> iomap_submit_ioend() cleared the context unconditionally; that clear was
> lost when submission moved to iomap_ioend_writeback_submit().  The final
> ->writeback_submit() call in iomap_writepages() needs no equivalent fix:
> it is the last thing the function does before returning, and every
> caller allocates its iomap_writepage_ctx on the stack for a single call,
> so wpc->wb_ctx is never read again afterwards.
> 
> Fixes: f4fa7981fa26 ("iomap: hide ioends from the generic writeback code")
> Cc: <stable@vger.kernel.org> # v6.17
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
>  fs/iomap/ioend.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 7bbbb417f9152..32ae292a84cbe 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -246,8 +246,16 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  new_ioend:
>  		if (ioend) {
>  			error = wpc->ops->writeback_submit(wpc, 0);
> -			if (error)
> +			if (error) {
> +				/*
> +				 * ->writeback_submit() completed the ioend
> +				 * with an error, so drop the stale context;
> +				 * iomap_writepages() would otherwise submit
> +				 * it a second time.
> +				 */
> +				wpc->wb_ctx = NULL;

I looked around the codebase and saw that iomap_writepages also calls
->writeback_submit.  Does that need to null out wb_ctx?

My guess is that none of the callers do anything with wpc after
iomap_writepages returns so it's not harming anyone, but we should drop
the stale context too, right?

--D

>  				return error;
> +			}
>  		}
>  		wpc->wb_ctx = ioend = iomap_alloc_ioend(wpc, pos, ioend_flags);
>  	}
> -- 
> 2.53.0
> 
> 
