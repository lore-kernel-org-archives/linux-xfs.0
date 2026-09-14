Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7968A4825A9;
	Mon, 14 Sep 2026 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397525; cv=none; b=PN4F2Qj50D1eBNoNfqwh3gAk6VcpaPC0H8UqX+skoFpsSmvXNW171oLlAM6ilBFmaVpBdz9KDLKNc/J6oKxEvW+3xq4f0utD3ZvzhsgSQQWU3qKP7uIKiUzPAuvv5Bis10ijjB/UKB/YhxQcvW+OYlMF0FXxj2JXaURa+9bxM4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397525; c=relaxed/simple;
	bh=fW5ujig+7HS1WpnUx0oz4BSjdjeK7UF1DKw2cXFP/Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q8X4sLSSp2VH+NSK/9WwrTFSHUiHhsuoF+o4j03TAANYp4eTtPbiurt9Wq7J5GvS7vjkHeNuZI9MVv89UAFaqm2cflK4RSApMTN+W+RRbOUe99wkWsGEzvxkJR6bvHSObZ2mfmHGj2EXfjRLQhLwaRmVAkjFt+NeCkKmdMofdZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lg/UIL+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lg/UIL+8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 131E41F000FF;
	Mon, 14 Sep 2026 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397524;
	bh=1VhtW9nWqnbkEzz/qQtjgJIb2gQUYqmYe0k1ImIAfGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lg/UIL+8VgOZMrlFbMMH5v7yUaXqExnY8OY2kyNonO5/QJ5WRKOB2Wqq9UBPjz/kT
	 Pdtyey5Db1Hr159D7JVjkhQbg/hbe09dOzeDwj6+p0D+t2oapZbV+DhhIygb4Bd4ON
	 gmVhtnmOg005vZ+dX4B4pcvjXN2TFzSpuP2r2y+mSWwwrMgR4T8Hhtb/4t/GIzK3mk
	 tl32hiPr8+yz7pf5NkeFwWvecSHPmqlE7LzJGx/AqMX1/RJV9EAsWhY99DEV5F8Por
	 GbqX35ck7y1XM34aEys0QrjkabZKc1xSnDnkSS2KdO1FvXT8SCCiX3b+sQFBMnK2h6
	 5pxWJE4leUDRg==
Date: Mon, 14 Sep 2026 07:52:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: cem@kernel.org, ljp1205831794@gmail.com, gaoyingjie@uniontech.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	13667453960@163.com
Subject: Re: [PATCH] xfs: remove duplicate INO1_WRITTEN check
Message-ID: <20260914145203.GM6265@frogsfrogsfrogs>
References: <20260914082111.195006-1-yijiangshan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914082111.195006-1-yijiangshan@kylinos.cn>

On Mon, Sep 14, 2026 at 04:21:11PM +0800, Jiangshan Yi wrote:
> Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
> issue with INO1_WRITTEN") duplicated commit b2d5a81dae38 ("xfs: fix
> exchange-range reflink flag clearing issue with INO1_WRITTEN"), so
> xmi_can_exchange_reflink_flags() ended up with two identical
> XFS_EXCHMAPS_INO1_WRITTEN checks.  The second one is dead code,
> since the first one already returned false.  Remove it.
> 
> Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>

Not sure why b2d5a81dae38 got committed twice, but yes this patch is
correct.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_exchmaps.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index 49eda8d0994d..3efed37cb98a 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -959,16 +959,6 @@ xmi_can_exchange_reflink_flags(
>  {
>  	struct xfs_mount		*mp = req->ip1->i_mount;
>  
> -	/*
> -	 * The INO1_WRITTEN optimization can skip exchanging hole and
> -	 * unwritten mappings, which means we cannot guarantee that all
> -	 * shared extents actually moved to the other file.  Clearing the
> -	 * reflink flag of an inode that still holds shared extents breaks
> -	 * the CoW write path, so refuse to exchange the flags in that case.
> -	 */
> -	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
> -		return false;
> -
>  	/*
>  	 * The INO1_WRITTEN optimization can skip exchanging hole and
>  	 * unwritten mappings, which means we cannot guarantee that all
> -- 
> 2.25.1
> 
> 
