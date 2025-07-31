Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8B82253A5
	for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753977583; cv=none; b=Ox60SfnnbZJbz0kreX4I/W1lbwGE8prFNq89Pl4PolDqoxlrRWPN7gl6wAAVIs5Hbj5pDtTUge+S9+gg5VcEm1R+4YYE4YMuDJkx4oOiE3fqV8V9vpg2xEUJTGbqMbnLCcE4C2W5nxVa7DL0gnOVm6elOPlRKFvkxwtfqDy29Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753977583; c=relaxed/simple;
	bh=mtqycEu+oFnG09+8KeMbVrTRpOMCAO+k/vk1qHcifnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFnZG0qNR597gUTruq0nhYnHoYVeyK+5On+s67fe/GqHlkDgKmoXIm07VEORw8yJd68/zbWMWfL4BsZyzY2py7kDJa7vK9zZVuL0KVRUoudpSx+g1LgrCrHdEOyzQ8GScyLQgew65sk1nQ0Q/Nu4K7VgW/wO22o3lSRw8nyZFGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlrQqQqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlrQqQqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48567C4CEEF;
	Thu, 31 Jul 2025 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753977583;
	bh=mtqycEu+oFnG09+8KeMbVrTRpOMCAO+k/vk1qHcifnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QlrQqQqgQo7ewGoafnY+V19BiEG63CVG8WFCMZDc/bjBcp2sj3rj2K60Zc30XcQqD
	 ezLwwcP5aJ1K0hRKr4KPFyd+ul7k6Sk3e1G/X7VG6pzqbTXUyTuUbbKf7HLry6Gsst
	 sYHRF5KGtSkCcPNKlPuO/Yy59fXEvU4aC1WkhQ53iS0pJGgYf5VFlef0tbaVWambVV
	 gyS1d1PmjAfQjfuo8HXgZyWQbQvIaEQ5oZon7SeztOJw3ztHbemRNsJpwmq6uMVdEr
	 o36FWh0/lwoaLuji3+0FMO2d87fA0ppDqJ3O2eXtIA+KweZTI/f3WZt+gSRdJ0kThF
	 qtp7MYsKGWqxg==
Date: Thu, 31 Jul 2025 08:59:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix frozen file system assert in xfs_trans_alloc
Message-ID: <20250731155941.GT2672049@frogsfrogsfrogs>
References: <20250731141941.859866-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731141941.859866-1-hch@lst.de>

On Thu, Jul 31, 2025 at 07:19:41AM -0700, Christoph Hellwig wrote:
> Commit 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from
> xfs_trans_alloc") move the place of the assert for a frozen file system
> after the sb_start_intwrite call that ensures it doesn't run on frozen
> file systems, and thus allows to incorrect trigger it.
> 
> Fix that by moving it back to where it belongs.
> 
> Fixes: 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc")
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 4917b7d390a3..9010dd682591 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -253,8 +253,8 @@ xfs_trans_alloc(
>  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
>  	 */
>  retry:
> -	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
>  	tp = __xfs_trans_alloc(mp, flags);
> +	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);

Empty transactions can run during a freeze, so please put back the
original warning and comment:

	/*
	 * Zero-reservation ("empty") transactions can't modify anything, so
	 * they're allowed to run while we're frozen.
	 */
	WARN_ON(resp->tr_logres > 0 &&
		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);

--D

>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
>  	if (error == -ENOSPC && want_retry) {
>  		xfs_trans_cancel(tp);
> -- 
> 2.47.2
> 
> 
