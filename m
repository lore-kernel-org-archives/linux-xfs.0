Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EC23EA947
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 22:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787005551; cv=none; b=hfbm4GTmUG0ZxjGq4VGQNDDIRGMY6uHzSFrs7iZDlTrMG047zLmBp65lqrRstv9p2EyvpuoH029e9OmjnLxfWyCV3R9onudhZHhopytyWYBSxlddXepp2yvaQjiRs1F1Lrix9abGQaXYhCBvwEmcZw2k7kHwQtbpAm1/Wq9/hCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787005551; c=relaxed/simple;
	bh=kKnUWMwws4bXuIC6yt3dxQHqhvFq0NWB14pokZg0RvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGidjDTdUaTr5ghFnSH8YYIJdv7m70rhUPmK7n5Y/epBbp9ZPccRHGJpnajfgbVPjZD1ycrMkMWEpch0aTCXb3YClm9liG2I5LFGlB/jPlb6sfwF09AJLtukuTZtcYjJALuXIXxRIjPp+iDr/tjg2eSsMiZbpAOip33+uDqKN2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5AxBqoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5AxBqoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441C81F0156B;
	Mon, 17 Aug 2026 22:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787005545;
	bh=BSUrYbaDvY1ccrS9Dv+41evcKNky79JXCjBOGhvyoqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d5AxBqoi1WXKwctoNVO7l8sHVWqwb7jSbE418Ox6xFk7zPGENU8sacah5yg/2l6s+
	 KaTAYnUPcatadcpmbf9c/vC13qtGiDX/VrcnasAkUwiyOftOWdaDa1mk64SssEXrNR
	 hIvhlZ8eth5zowWIS8ye6ScaydwhYLcQlcA0uVALCl6c7YTpUV8QhYy1Xw3X94IHaH
	 8hRRFxBYzII6YJebeLu7fIhkd+c0ziiNAnkkJKCjU1u+pIjZbFZo7Oyseteqj8jpE5
	 PUGbyusthE/5+uDYhExMmwnnSaTD1YoupDPS7OVyzKWOO4WyzxkMm/WRhfci2UH35k
	 CMKGbnBkOIZqA==
Date: Tue, 18 Aug 2026 08:25:37 +1000
From: Dave Chinner <dgc@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH v2 1/3] xfs: set minleft correctly for sparse chunk
 errortag allocation
Message-ID: <aoOKYRBTK7ocCBrY@dread>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814132239.271492-2-bfoster@redhat.com>

On Fri, Aug 14, 2026 at 09:22:37AM -0400, Brian Foster wrote:
> The errortag instrumentation for forced sparse chunk allocation
> jumps straight to the allocation path without setting args.minleft.
> minleft is unconditionally set to ->inobt_maxlevels for the normal
> allocation path. Lift the assignment to the initial args setup so
> it covers all possible paths.
> 
> Assisted-by: LLM
> Fixes: 1cdadee11f8d ("xfs: randomly do sparse inode allocations in DEBUG mode")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index ffcdd1f691fd..633b2d6e42c5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -733,6 +733,10 @@ xfs_ialloc_ag_alloc(
>  							igeo->maxicount)
>  		return -ENOSPC;
>  	args.minlen = args.maxlen = igeo->ialloc_blks;
> +
> +	/* Allow space for the inode btree to split. */
> +	args.minleft = igeo->inobt_maxlevels;

As an extra question: is that reservation even correct? We can split
both the inobt and the finobt on insert, and this only reserves
space for a inobt split....

Secondly, why always reserve space for a max level split? The amount
we need is depedent on the current level of the btree, and for all
other btree types our reservations are based on the current level.
i.e. we know the math needed to make this dependent on current btree
levels, and we know that we are inserting into multiple btrees of
different heights here, so maybe we should fix this reservation
whilst we are here, too?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
