Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97FE155CB3;
	Mon, 24 Feb 2025 19:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424332; cv=none; b=RaYZZ+9dSB+G3o5kMGuy1ayjm/jdSy0+ztgw6D50rVqhcuCrn3gm+tBMHJQaU35WbWQ/GoJpKDYxwlpCoQgNjkYfHB3NNsyiOJrJ21FTuUtIDyxTZAsQYf4rzUOPQYLozW288IrvnMcpGzQFOf1WsMPeRZWv5zQFScNMb3lERWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424332; c=relaxed/simple;
	bh=vXBsqbufAWtmBoM7Qh1pntSR7FtTvFbZYNSh+wYzzv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hox9hgUAEcWd6VIY5mZxu5bn4iJ4Dtsc7tgQB6PwYLORGFK9Z1pMH3ECGE4HKhrIDrXLwZGZnXkoWntdGDsxoCyXqeG03ZbAeVIzkDLJ/4iJyPk2b4MrEUCHymFxv18nzDlF7mTncWv9swufhoB+qRw8SMTGkurVFX/ea87fgDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TvmgjDln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TvmgjDln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A31C4CEEF;
	Mon, 24 Feb 2025 19:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740424330;
	bh=vXBsqbufAWtmBoM7Qh1pntSR7FtTvFbZYNSh+wYzzv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TvmgjDlnxWsPu6PSnGEV2bpAwWTTTq6AVXIoJHV6iPbaFCclbAf70dZoCPm4vSXlj
	 AoA7yFbzTjuZ5tkJzdtvQCGETB/8vF4B9iT/uyPpgMwheIglp5KtQqLWUQKgdp5evx
	 NI9rrPtWeh8DzVaFd5MtsmYyc/hr8bN6pgjAQ0/RmQY1c5IklS0mD0k0XE66duewSg
	 UCOynPjmpRooGigm6YPbpPgAUg6CzvfHTyDlPtVVWdDmlJFk7i8jYMPDD+CdiG16n7
	 MhyQL1POu6Mrbl40Gj5c11vPlyYclVd7/z4nJt8bOmStAYGaVYEgvFTm5wWaR/e7nB
	 UMZUqZPAiDtaw==
Date: Mon, 24 Feb 2025 11:12:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 3/8][next] xfs: Avoid -Wflex-array-member-not-at-end
 warnings
Message-ID: <20250224191209.GZ21808@frogsfrogsfrogs>
References: <cover.1739957534.git.gustavoars@kernel.org>
 <e1b8405de7073547ed6252a314fb467680b4c7e8.1739957534.git.gustavoars@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1b8405de7073547ed6252a314fb467680b4c7e8.1739957534.git.gustavoars@kernel.org>

On Mon, Feb 24, 2025 at 08:27:44PM +1030, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Change the type of the middle struct members currently causing trouble
> from `struct bio` to `struct bio_hdr`.
> 
> We also use `container_of()` whenever we need to retrieve a pointer to
> the flexible structure `struct bio`, through which we can access the
> flexible-array member in it, if necessary.
> 
> With these changes fix 27 of the following warnings:
> 
> fs/xfs/xfs_log_priv.h:208:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  fs/xfs/xfs_log.c      | 15 +++++++++------
>  fs/xfs/xfs_log_priv.h |  2 +-
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f8851ff835de..7e8b71f64a46 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1245,7 +1245,7 @@ xlog_ioend_work(
>  	}
>  
>  	xlog_state_done_syncing(iclog);
> -	bio_uninit(&iclog->ic_bio);
> +	bio_uninit(container_of(&iclog->ic_bio, struct bio, __hdr));
>  
>  	/*
>  	 * Drop the lock to signal that we are done. Nothing references the
> @@ -1663,7 +1663,8 @@ xlog_write_iclog(
>  	 * writeback throttle from throttling log writes behind background
>  	 * metadata writeback and causing priority inversions.
>  	 */
> -	bio_init(&iclog->ic_bio, log->l_targ->bt_bdev, iclog->ic_bvec,
> +	bio_init(container_of(&iclog->ic_bio, struct bio, __hdr),
> +		 log->l_targ->bt_bdev, iclog->ic_bvec,
>  		 howmany(count, PAGE_SIZE),
>  		 REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE);
>  	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
> @@ -1692,7 +1693,8 @@ xlog_write_iclog(
>  
>  	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>  
> -	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
> +	if (xlog_map_iclog_data(container_of(&iclog->ic_bio, struct bio, __hdr),
> +				iclog->ic_data, count))
>  		goto shutdown;
>  
>  	if (is_vmalloc_addr(iclog->ic_data))
> @@ -1705,16 +1707,17 @@ xlog_write_iclog(
>  	if (bno + BTOBB(count) > log->l_logBBsize) {
>  		struct bio *split;
>  
> -		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
> +		split = bio_split(container_of(&iclog->ic_bio, struct bio, __hdr),
> +				  log->l_logBBsize - bno,
>  				  GFP_NOIO, &fs_bio_set);
> -		bio_chain(split, &iclog->ic_bio);
> +		bio_chain(split, container_of(&iclog->ic_bio, struct bio, __hdr));
>  		submit_bio(split);
>  
>  		/* restart at logical offset zero for the remainder */
>  		iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart;
>  	}
>  
> -	submit_bio(&iclog->ic_bio);
> +	submit_bio(container_of(&iclog->ic_bio, struct bio, __hdr));
>  	return;
>  shutdown:
>  	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index f3d78869e5e5..32abc48aef24 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -205,7 +205,7 @@ typedef struct xlog_in_core {
>  #endif
>  	struct semaphore	ic_sema;
>  	struct work_struct	ic_end_io_work;
> -	struct bio		ic_bio;
> +	struct bio_hdr		ic_bio;

What struct is this?

$ git grep 'struct bio_hdr' include/
$

(Please always send the core code change patches to the xfs list.)

--D

>  	struct bio_vec		ic_bvec[];
>  } xlog_in_core_t;
>  
> -- 
> 2.43.0
> 
> 
