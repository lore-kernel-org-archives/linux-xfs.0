Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4086B51EDF2;
	Mon, 21 Sep 2026 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790029798; cv=none; b=Bl/XKNdUf1pOjMxxlRiYK44Z+0nmF2GYSyCRJM/WD9SZYlb/ZdlRrPZHw2mswE+uUK8p4kwSWhSVTsNNRlJ9E3qzhvyN3AjIGGP40aRtQO+df5vxRwskRnE7ROICM/vxEmQBphsMiChGERp85yiCAhhnQA8hUSdySlIuBnqbvNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790029798; c=relaxed/simple;
	bh=sikBXLJqrajH4ARJP2eBg1MY614d9GTDi9k0/acvbCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boj7pHVkIGZMu+JPPawZfYOOpIIhc6mjCZnK9CsLqxxXstjy78gKwBO8zwXsDQyAFvli5y/qChILl7AjaYYLK3yrn8YfD1axLwuBAOAFfsnYq8U7ouOqsLdOLgl9anyAQUL5xNXsZG+L/QUq6Jd3WPoNIZOiuUuy1JiKStht0xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I60jD1+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I60jD1+7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 314241F000FF;
	Mon, 21 Sep 2026 22:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790029794;
	bh=bgL3iJjMR1yuBTVdRdC4x6uFfEX57QK0NKdzj3j7tlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I60jD1+7Ttgmd70eoW6kmvHBwCoxb/xNjfW4Bsrxlwu3HfrcqenNgDZPDuEN9DGOF
	 Y/l6ARxiaanajGVC2p+WLHxRytWFOA4/SzslmLipeYdXl5CZawOSZXhPAdTgfocJ04
	 HQ/QfOleXAtW/KSibE7ET0y3kZTmeFIgcaOadItH0gaedJM+9aRDm/+RR+MhQ1aH7t
	 YrjDo1aA5SGXuSDjZooGl72rTc1HaGiJYQmjc12oU1XPAlih1ZJzy3l54huHvFCIte
	 NwWh5EShOvFg2270kl4vZSZGAtdJ2zyEOTXFMBNIo/F1fxXuj0Tlb3+DOzHS1vnzyr
	 wO8BR5g7/D69g==
Date: Mon, 21 Sep 2026 15:29:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <20260921222953.GM6283@frogsfrogsfrogs>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-2-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921083133.2960-2-parri.andrea@gmail.com>

On Mon, Sep 21, 2026 at 10:31:31AM +0200, Andrea Parri wrote:
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
> the ioend completion worker.
> 
> Clear wpc->wb_ctx when ->writeback_submit() fails.  The old
> iomap_submit_ioend() cleared the context unconditionally; that clear was
> lost when submission moved to iomap_ioend_writeback_submit().
> 
> Fixes: f4fa7981fa26c ("iomap: hide ioends from the generic writeback code")
> Cc: stable@vger.kernel.org

Cc: <stable@vger.kernel.org> # v6.17

> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
>  fs/iomap/ioend.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 7bbbb417f9152..bb8575768d888 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -246,8 +246,16 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  new_ioend:
>  		if (ioend) {
>  			error = wpc->ops->writeback_submit(wpc, 0);
> -			if (error)
> +			if (error) {
> +				/*
> +				 * ->writeback_submit() completed the ioend with
> +				 * an error, so drop the stale context.
> +				 * iomap_writepages() would otherwise submit it a
> +				 * second time.
> +				 */
> +				wpc->wb_ctx = NULL;

Do you need to do the same thing for the ->writeback_submit call in
iomap_writepages?

--D

>  				return error;
> +			}
>  		}
>  		wpc->wb_ctx = ioend = iomap_alloc_ioend(wpc, pos, ioend_flags);
>  	}
> -- 
> 2.53.0
> 
