Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4E62C21E6
	for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 16:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763139355; cv=none; b=YX/JxPRXLs8gA7LJpWwpMjpQCp9f17sPCYD2AnpfbOOQHzdEf5h25Ib3yP+qJ80yAnXKLt1nK0rTaCLzbAn7KgD3oGS9JmDjUr1Xr1ayPc/Zp1+Kp6nPQk4VARcBKgE1LnpEy1k7ad5V2wIsdCcACqZAEVwYXJaG48pGCXgZUv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763139355; c=relaxed/simple;
	bh=MAlA3Nl4/Ipg4dC1JDfxJiKHsENSOte2hamPzaQmm/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3XAb96tny5ItSwlhV+ZWHeozqjqtGkibtZf0dsXstjUCKCsHVqdqu+Fe371S5tBZaEQ0tBxw1C5uWPLeVFyR7XEQLrhaEDnizMrwVq38Yi2XNq9HDfeXekq0S9z3p8WNVZDpOysHJw0G+tFYFs2EJ3VAnFgARb+7LcEhSrGg1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4/QKL1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4/QKL1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17243C116D0;
	Fri, 14 Nov 2025 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763139355;
	bh=MAlA3Nl4/Ipg4dC1JDfxJiKHsENSOte2hamPzaQmm/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X4/QKL1OCj4TSqy4ARgWhO+hVLcL5WfHZ+WEzY/f3CVHOn2MiXktdzMcQeRCvMMxK
	 YbdNwCrrmzIKRLQjza2C6XVw9zVRBKjVxUeMMV0eX4jr1aelOcupG0eDOu8/z8PTQV
	 84EO3j3AS0AMOPa3VW3Hns4oLt25sgYWRf91bStrsDNU6vfOIukzOTU2fQsY2rktVP
	 sPtuERfm9mx7QQKl820noxO1CvTHcixyf1lHXYeWDQNwdWhybBb4uWCMtd3YlYWuv6
	 ilJE81MUYffYMgyLbq/5JYFSYxko6i4oGz3vY7l4tVGTWlQCUQviyREOYuZiTqnoLJ
	 hGllRxPSyEHEw==
Date: Fri, 14 Nov 2025 08:55:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: regularize iclog space accounting in
 xlog_write_partial
Message-ID: <20251114165554.GG196370@frogsfrogsfrogs>
References: <20251112121458.915383-1-hch@lst.de>
 <20251112121458.915383-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112121458.915383-7-hch@lst.de>

On Wed, Nov 12, 2025 at 01:14:22PM +0100, Christoph Hellwig wrote:
> When xlog_write_partial splits a log region over multiple iclogs, it
> has to include the continuation ophder in the length requested for the
> new iclog.  Currently is simply adds that to the request, which makes
> the accounting of the used space below look slightly different from the
> other users of iclog space that decrement it.
> 
> To prepare for more code sharing, add the ophdr size to the len variable
> that tracks the number of bytes still are left in this xlog_write
> operation before the calling xlog_write_get_more_iclog_space, and then
> decrement it later when consuming that space.
> 
> This changes the value of len when xlog_write_get_more_iclog_space
> returns an error, but as nothing looks at len in that case the
> difference doesn't matter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ok, glad I took the time to ask questions for v2;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 93e99d1cc037..539b22dff2d1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2048,10 +2048,10 @@ xlog_write_partial(
>  			 * consumes hasn't been accounted to the lv we are
>  			 * writing.
>  			 */
> +			*len += sizeof(struct xlog_op_header);
>  			error = xlog_write_get_more_iclog_space(ticket,
> -					&iclog, log_offset,
> -					*len + sizeof(struct xlog_op_header),
> -					record_cnt, data_cnt);
> +					&iclog, log_offset, *len, record_cnt,
> +					data_cnt);
>  			if (error)
>  				return error;
>  
> @@ -2064,6 +2064,7 @@ xlog_write_partial(
>  			ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  			*log_offset += sizeof(struct xlog_op_header);
>  			*data_cnt += sizeof(struct xlog_op_header);
> +			*len -= sizeof(struct xlog_op_header);
>  
>  			/*
>  			 * If rlen fits in the iclog, then end the region
> -- 
> 2.47.3
> 
> 
