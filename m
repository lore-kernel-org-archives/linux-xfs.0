Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6934336A374
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 08:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956000; cv=none; b=pxuLGFJQ1CRkxE8LxGzGfh3FbfvnZiawO3l5ZN6ExawMKSPnwHtb42S2pjC1Pe3LH9JaodyoWYVM3mEHvucc3+Y3dfUx0efHaEV8oVpkMWOwdHMp59JV9ZIwVZcOHFK2W67lU0cJRRHaW/SSmicy4GNXyP0fby76pphJyadr68c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956000; c=relaxed/simple;
	bh=2+w2QlUcCj6ojzR/+4++P+YCncgOgkQUlY92Eqvrw6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skK+3jwYVaNZPn221XKiN7Xr/itGuhEN1cUj8Gu7lv5+RU/vIG1H0RTpSOh33u+6apl8A9mAiuznqDdLOq4NjR+JjmNDRzJOqNfi9dCjswVS6g0aQcVRseLEXhwVbknoO8zgqpxhVohmUvK7W2Zp4LEWp7GyQXVb+JtckGksIOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mj+HJLqS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mj+HJLqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70C21F000E9;
	Thu, 28 May 2026 08:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779955999;
	bh=44rukWKqvtLTMAIYCJvvX208tPhCKOa8LC7jpBweww0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mj+HJLqSLSAJns4d86Jh61BOMzWKGr7tV6gnaEJM8hBbGFyDQlAfM2MGO3+Fv6WKS
	 gHamLgD8NKmPY5t4vLVkX2Wis82gUDk8MkkvOv8Uz+uD8QsE+eIzSluQroUOVjqJVf
	 qB1bXN4BQD5VutVIyuDXT/7qe3vvchW5LNvTRLjqezqVf5VgIglGirwQpkoSv7BkvL
	 bFksh1w2b6R4+vJP5HyzKZcFqPldrCpnodD2BhGu8CedVlpiveKXAdfQLnP+T0heYA
	 /S34fJB+PRtF9SyXPRKfXxrMj3YgvqXbApGZVVJ2EjE3wMtUsA6zw6D3+jCjKz5FdD
	 E8jShCzX6lwnw==
Date: Thu, 28 May 2026 10:13:14 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: drop the RTG reference later in
 xfs_ioc_rtgroup_geometry
Message-ID: <ahf5FEmC-zUGKJ8E@nidhogg.toxiclabs.cc>
References: <20260527123941.2319377-1-hch@lst.de>
 <20260527123941.2319377-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527123941.2319377-2-hch@lst.de>

On Wed, May 27, 2026 at 02:39:28PM +0200, Christoph Hellwig wrote:
> Keep the rtgroup reference until after reporting the write pointer, as
> that uses it.  Right now this is not a major issue as we don't support
> shrinking file systems in a way that makes RTGs go away, but let's stick
> to the proper reference counting to prepare for that.
> 
> Fixes: c6ce65cb17aa ("xfs: add write pointer to xfs_rtgroup_geometry")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_ioctl.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 46e234863644..737afcb5652a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -433,9 +433,8 @@ xfs_ioc_rtgroup_geometry(
>  		return -EINVAL;
>  
>  	error = xfs_rtgroup_get_geometry(rtg, &rgeo);
> -	xfs_rtgroup_put(rtg);
>  	if (error)
> -		return error;
> +		goto out_put_rtg;
>  
>  	if (xfs_has_zoned(mp)) {
>  		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> @@ -453,8 +452,10 @@ xfs_ioc_rtgroup_geometry(
>  	}
>  
>  	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
> -		return -EFAULT;
> -	return 0;
> +		error = -EFAULT;
> +out_put_rtg:
> +	xfs_rtgroup_put(rtg);
> +	return error;
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
