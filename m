Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A072114
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734129839; cv=none; b=WYCdlsebnQmF+CLlqhAMF1Yo4/F4BgA2PEbqgphjaySCG302oiKjMr++s5E3SuV+UNY1EuuoyW5vB9FsmUW14lD7UEupzPdH7txwwl7T4A9aemLOROQawdfTiS/eeKRzII5KJ8uOHxCKG8bMhQIc7A0YlHdd70JHhyGTHDEBrz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734129839; c=relaxed/simple;
	bh=FMJQZ47yNx6HzHgO4njXBsT/bMh2bH/a/AXukxa3Ssg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMGU7zZw/SBn7pGnFQudnT5jBUCgiwyv4qhKm5AuksYLBkGHeGsAQyJkGO86flF0uiRU19N1p6QXWJcNYwAl3BHP8TjCiB3K2hKb626Y69ydGT0II7V6JyN8bHvag5xPKQ5bBAIK1v0qWNCXcvow/S2xD0Oi7Wqr3Bvlft8cnTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jkj/49iW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jkj/49iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4C5C4CED0;
	Fri, 13 Dec 2024 22:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734129839;
	bh=FMJQZ47yNx6HzHgO4njXBsT/bMh2bH/a/AXukxa3Ssg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jkj/49iWWmEawPjBN+efsMCqo8GOqpHdYNftsre41BF0LltqnL9Fbl5uD5lEsfSow
	 oVuZs78iGgmU896vIicAa55PTCjzBqv9Br/afNyvIi7LGnVQ/WP+kP8hLzzBL9wI5+
	 5zUlmCZc+NvmYd/jVSfxaizVeGwQY90ZFfzoqBQ9rlB7eF7Ad3isEE6yVko09OGOFw
	 E5jtyRM38YaoLH5MevB5Kt1qD5EsDD0yyRZT0y4HFoIBACpoYVWErGtqKLL2rs6WYz
	 mYWbYhrzjZLjDr8j0Yp3oFu1gVDro4bAH1llPZEa1P/zjGLXXyGjvVVzR7GcjKSeF4
	 nDFpq1fWrCTMA==
Date: Fri, 13 Dec 2024 14:43:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/43] xfs: hide reserved RT blocks from statfs
Message-ID: <20241213224358.GT6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-31-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-31-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:55AM +0100, Christoph Hellwig wrote:
> File systems with a zoned RT device have a large number of reserved
> blocks that are required for garbage collection, and which can't be
> filled with user data.  Exclude them from the available blocks reported
> through stat(v)fs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b289b2ba78b1..59998aac7ed7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -865,7 +865,8 @@ xfs_statfs_rt(
>  		xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
>  
>  	st->f_bfree = xfs_rtbxlen_to_blen(mp, max(0LL, freertx));
> -	st->f_blocks = mp->m_sb.sb_rblocks;
> +	st->f_blocks = mp->m_sb.sb_rblocks -
> +		xfs_rtbxlen_to_blen(mp, mp->m_resblks[XC_FREE_RTEXTENTS].total);

I wonder, is mp->m_resblks[XC_FREE_RTEXTENTS].total considered
"unavailable"?  Should that be added to xfs_freecounter_unavailable?

--D

>  }
>  
>  static void
> -- 
> 2.45.2
> 
> 
