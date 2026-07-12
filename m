Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB5B25B092;
	Sun, 12 Jul 2026 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783873374; cv=none; b=TWOulielt+jRCzNGR4zQhETQbDBwcr99WGTBY0fjFgCt0UuNWT85fs9iop5jEeVBgjnO/R2Et1x6Z6YYxAh5aQpzOiy88c0kIl0LedYA8wqt6XLi7ZWPDwOtdIqMQJDbC5/S2I9Oc8ZV7Skf1K6OpsDhy9guXgMbK5tMehsIAO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783873374; c=relaxed/simple;
	bh=RSiIR1z2mpzASDxjHuQkD2I0bpgzQ/FS832oGCKKcCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hJFWw6j4gexTRPwT4do9Qm/I6zZ4X0Lg+li9+vmx40ydV84gbDmkYa2Vr/3y4tbJkBqIJQwTooZ1pR7won5NwhwP41rySZv/c7WV+QWQvFRVxNWZ40s7bYbmiSXY30yFQ3K/I2aU4YJI6Mi+TvUiJLyXSfMnQo92nSt82OsOHmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPujuT0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPujuT0L"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E1C781F000E9;
	Sun, 12 Jul 2026 16:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783873373;
	bh=FZTvFXX2MudrX92TEaij+xL5i/6YlKbl9UJuuydy7zg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LPujuT0LV11yb+bgnE6+BzngTwJ0EpEgrQcNoUiCS+wbhMBFQGaQOQxsgk40seesV
	 x55VVByjtTTmY0gGIHWMY1VqzuWZfr+/y/ImdS7uS/GGAhNcmsLhGH6nE0LLd2RJSb
	 M+SjBuuoJuID4BOMCWh/5YrBow0KjrwbfXyx63hla1THhXE9Q37yQMs2dIKgUMaEGk
	 +TF68L7/9VTwFxNSqNer4TNpXe5/wh9nLlw+wCUBjiHtOpzNFNqREIKBMcY3lHQ8r/
	 BFJeIstxrQ/+bskIRyPnUdGOgVIyevE0XfSQhtJJmin+LyGVoUtq8tZqM858RoCm3w
	 VZsGmHj6rutHA==
Date: Sun, 12 Jul 2026 09:22:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Guanghui Yang <3497809730@qq.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: propagate errors from xfs_rtginode_load
Message-ID: <20260712162252.GA7233@frogsfrogsfrogs>
References: <tencent_542687AA9C474951C4132E84DAED17622105@qq.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_542687AA9C474951C4132E84DAED17622105@qq.com>

On Sun, Jul 12, 2026 at 03:42:56AM +0000, Guanghui Yang wrote:
> xfs_rtginode_ensure() treats every xfs_rtginode_load() error other than
> -ENOENT as success.  This can leave the realtime group inode unset after an
> I/O, allocation, or corruption error.  Growfs then continues as though the
> inode had been loaded.
> 
> Only -ENOENT means that the inode needs to be created.  Return all other
> errors to the growfs caller.
> 
> Fixes: ae897e0bed0f ("xfs: support creating per-RTG files in growfs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

Yeah, that's correct
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 7a3f97686989..84efe5a8fb11 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -737,7 +737,7 @@ xfs_rtginode_ensure(
>  	xfs_trans_cancel(tp);
>  
>  	if (error != -ENOENT)
> -		return 0;
> +		return error;
>  	return xfs_rtginode_create(rtg, type, true);
>  }
>  
> -- 
> 2.34.1
> 
