Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8584C6E;
	Fri, 25 Apr 2025 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745592867; cv=none; b=bt1zmWDFfUlUpCo/l0e7A9vNonW3AU9pbbW4VqHxUY1jwbdgq5jxLj+VvfCGHRMse7+crxOHrjMg9SaSY439cFn3qXV0yQQJt1lucAbllf5YP7LtA2vmzo+7Qget7yZzrWaKmu43J4+wJfxD5FOa4Sc6oDvAf7BkRiRPGzDZXb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745592867; c=relaxed/simple;
	bh=fsjtFMIR/hiClwpGcJKvd9UaGF67MFSWOjljj3tLchs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+0HbnklHN6QGFt6FxSr618lY5yBqRFqEi/yasw4G1Nszl7G2+ktVTS2PjrwmD2705PTpW7NrKLYeLnLw27eZTQSVn8XYYAI0z+4xNO2BoKi72puF6dPYxKgvPiaMtHsBJAyuLrbeDu0pmucHHAH66m0+6f5lbx0928iTVGgaVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlZWXdtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlZWXdtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADD0C4CEE4;
	Fri, 25 Apr 2025 14:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745592866;
	bh=fsjtFMIR/hiClwpGcJKvd9UaGF67MFSWOjljj3tLchs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mlZWXdtX9Kh+wZPRVeqyCme36yWI5Xbm1vyzOqltGE8XjumbacDir8FCssNtqrF0J
	 F1uabKh2Z+CI7CCYDskUTBoNiwOH1RBLfDbooG1aVRiLxYk1l7pKavEBsAKm5WT3p3
	 JnwBg/TRRBEix3ZKhE596GxmQG8fkF9w1rtCRzQ7Il/6nyA05dn+bAyRnTco9q4gEE
	 few4CBSY1alIUa81458S/uHyipHuUcXwqxhBXonb6dz5MRTegmARmHZ3ykegVr85zX
	 U5igBW1qntFGye9z0IlyZG1VmljezZJgRu4Ss5ykF/zhuSQcqS78D8sSi7FajbVbfE
	 iuVrZBMeAk9OA==
Date: Fri, 25 Apr 2025 07:54:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Message-ID: <20250425145426.GL25675@frogsfrogsfrogs>
References: <20250425085217.9189-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425085217.9189-1-hans.holmberg@wdc.com>

On Fri, Apr 25, 2025 at 08:52:53AM +0000, Hans Holmberg wrote:
> Allow read-only mounts on rtdevs and logdevs that are marked as
> read-only and make sure those mounts can't be remounted read-write.

If the log device is readonly, does that mean the filesystem gets
mounted norecovery too?  Your test might want to check that a dirty log
is not recovered even if the filesystem mounts.

--D

> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
> 
> I will post a couple of xfstests to add coverage for these cases.
> 
>  fs/xfs/xfs_super.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b2dd0c0bf509..d7ac1654bc80 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -380,10 +380,14 @@ xfs_blkdev_get(
>  	struct file		**bdev_filep)
>  {
>  	int			error = 0;
> +	blk_mode_t		mode;
>  
> -	*bdev_filep = bdev_file_open_by_path(name,
> -		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
> -		mp->m_super, &fs_holder_ops);
> +	mode = BLK_OPEN_READ | BLK_OPEN_RESTRICT_WRITES;
> +	if (!xfs_is_readonly(mp))
> +		mode |= BLK_OPEN_WRITE;
> +
> +	*bdev_filep = bdev_file_open_by_path(name, mode,
> +			mp->m_super, &fs_holder_ops);
>  	if (IS_ERR(*bdev_filep)) {
>  		error = PTR_ERR(*bdev_filep);
>  		*bdev_filep = NULL;
> @@ -1969,6 +1973,20 @@ xfs_remount_rw(
>  	struct xfs_sb		*sbp = &mp->m_sb;
>  	int error;
>  
> +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp &&
> +	    bdev_read_only(mp->m_logdev_targp->bt_bdev)) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited by read-only logdev");
> +		return -EACCES;
> +	}
> +
> +	if (mp->m_rtdev_targp &&
> +	    bdev_read_only(mp->m_rtdev_targp->bt_bdev)) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited by read-only rtdev");
> +		return -EACCES;
> +	}
> +
>  	if (xfs_has_norecovery(mp)) {
>  		xfs_warn(mp,
>  			"ro->rw transition prohibited on norecovery mount");
> -- 
> 2.34.1
> 
