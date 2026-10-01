Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1757C52F28B;
	Thu,  1 Oct 2026 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866684; cv=none; b=tTSTlVuskWoYueqhJk97hNYCaFAx3SjNovx2hm/vgSqAt2LnTeFv/ZcCnGMEHBYiuoYppXzvBVj9nF8OtkGMHKwxlEOWGAy9n+y+SJw/zMI4UGuE2l82/YQQQbHOUIbxBn57c61HnkHK4g0yMb/shBQkaPZY1yYF59BLXvgGLe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866684; c=relaxed/simple;
	bh=M0vJMAtMJZIPmd2mczy100KwS7AH7bGm91qOTTWvEkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7PLin4lnB/rzMtJt0HN0WIYICZoCFZY1j3M+ZLlhUJebLyvgW0ZsxUFwLGKJmdqCHiK78tdTnRACKIgqKon9LxdOnHpPYfq+jevfOgwziUMDkEyXbhE9iQPvkBnEzK5p1DNLxcW1mXvhOC8QYi1KQB6VKz4sb+7QMy8LZ9WpjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGFtypkQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGFtypkQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A8A471F000FF;
	Thu,  1 Oct 2026 14:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790866682;
	bh=ndgT8nr149XSVa3VKzfNr0MJ0BBBwGQ+1f/Ic6y+cnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BGFtypkQyyLznAyr7gTcntpXBG4Pi6A2yLW/acMlz6tnj9o0ezISILmoE+pcLQxQ9
	 4sfOn4Hvgam+dq7qRhwGxl6EnDAKiK181Cl8lfEpz99l35S7ocL4xkKhNhd78AW8+E
	 VUvPzv9puzYbGi7kL2JstEsAqRqtZN/OpxgnE0oDxdfYz7WY+0xDJ0vcLBjll7AB3h
	 hyMdOCPGS5Oxw8LceeTJ6QPyPqVziewL1oaKx5ZMOdV1Mn7LKXNjKvMfsrI8lEkhFT
	 5YAPt3A5MikB25Q/peN8xq4HDisSfuZ3acAinT83yLH3KMBKnHwfCiVDP6lOohpe+k
	 3vn1Iyve6fo9Q==
Date: Thu, 1 Oct 2026 07:58:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Message-ID: <20261001145802.GX2705364@frogsfrogsfrogs>
References: <20261001145153.308087-1-siddh.raman.pant@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001145153.308087-1-siddh.raman.pant@oracle.com>

On Thu, Oct 01, 2026 at 08:21:53PM +0530, Siddh Raman Pant wrote:
> Probably an (harmless) error in copy-paste.
> 
> Fixes: db6a2274162d ("xfs: catch stale AGF/AGF metadata")
> Cc: stable@vger.kernel.org

Cc: <stable@vger.kernel.org> # v6.16
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
> ---
> Put in stables <= 6.12 after the backport series lands.
> 
>  fs/xfs/libxfs/xfs_alloc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index f762dcce8d13..0ffa82400007 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3461,7 +3461,6 @@ xfs_alloc_read_agf(
>  	if (!xfs_is_shutdown(pag_mount(pag))) {
>  		bool	ok = true;
>  
> -		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
>  		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
>  		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
>  		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
> -- 
> 2.53.0
> 
> 
