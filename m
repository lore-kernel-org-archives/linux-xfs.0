Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0827432C328
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 21:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764882667; cv=none; b=uD5/mzuWHqjq/D/ffl0t3sL5DzO+0/67MFK2RgK7NWU9PnL3qxpylCguK3N71HpSthFU94XF6X6zcgS/1Jn6sx14Hpc48UXwcUz1iuU/t/KG5MZdyflEdgxjcrEHQuq1rqaPfllbvKkatpgV+79uK4x+S7XCGIhvb2sKNQott6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764882667; c=relaxed/simple;
	bh=0HG352rxpPnYJzeBURgw/NbCYU/HafNhRs569CM+dzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyX/VkyElopRtBLU1a8bSiQotBqyUijx1MPXJ/7qy5P2DKKt194f6+V8zQD3uGQ7l0PYRfjK1sripaSNPY4dR0HddyKcGEOTiU/oiDdSgxh3Sv0YitgQoaK6sohIJikM5FWl1WyXtakN+HKvaMObblQqhKXRS8Zcbd3ymkMI0Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeUQWAln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeUQWAln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BDEC113D0;
	Thu,  4 Dec 2025 21:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764882666;
	bh=0HG352rxpPnYJzeBURgw/NbCYU/HafNhRs569CM+dzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eeUQWAlnbTQHDnV39H8TbZdRwfKFpTTK9ryfHn7OejbVaXvj4A/H+svo6RtAuZl77
	 LgG0Z+q2uTNmGQB0tnDTWAxo2T7J7jGRzerGt/5wzC2yt2bZO5xu973mHbswL9lCm7
	 AUXozkmBU1WtfWH2qGWuLWNuPqJ+B3HwfJDHUEjJuhJnhz7diredlaF3qmPFQjSmzA
	 sGG/lowvwl05U6MaCh5dZlmeIszJKkWf/4ibTc/niGX9YzHmXLEpzIZ20X7ltMnmy5
	 ZplNKnAFO+nwZnKMQwbmHC8Le49l405qrpDWE1x7mPohobRgnmao1aoKlSSQyVE9+v
	 kMvRTX5BSmp4Q==
Date: Thu, 4 Dec 2025 13:11:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: pass correct structure to FS_IOC_FSSETXATTR
Message-ID: <20251204211105.GL89472@frogsfrogsfrogs>
References: <aS_XwUDcaQsNl6Iu@infradead.org>
 <20251204192827.2371839-1-arekm@maven.pl>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251204192827.2371839-1-arekm@maven.pl>

On Thu, Dec 04, 2025 at 08:28:27PM +0100, Arkadiusz Miśkiewicz wrote:
> Commit 56af42ac ("libfrog: add wrappers for file_getattr/file_setattr syscalls")
> introduced the xfrog_file_setattr() framework, which was then wired up for
> xfs_quota in 961e42e0.
> 
> However, the wrong structure is passed to FS_IOC_FSSETXATTR, which breaks the
> xfs_quota "project" subcommand:
> 
>     # LC_ALL=C /usr/sbin/xfs_quota -x -c 'project -s -p /home/xxx 389701' /home
>     Setting up project 389701 (path /home/xxx)...
>     xfs_quota: cannot set project on /home/xxx: Invalid argument
>     Processed 1 (/etc/projects and cmdline) paths for project 389701 with recursion depth infinite (-1).
> 
> strace:
>     ioctl(5, FS_IOC_FSSETXATTR,
>           {fsx_xflags=FS_XFLAG_PROJINHERIT|FS_XFLAG_HASATTR,
>            fsx_extsize=0, fsx_projid=0, fsx_cowextsize=389701}) = -1 EINVAL (Invalid argument)
> 
> Fix the call to pass the correct structure so that the project ID is set
> properly.
> 
> Fixes: 56af42ac ("libfrog: add wrappers for file_getattr/file_setattr syscalls")
> Signed-off-by: Arkadiusz Miśkiewicz <arekm@maven.pl>

That's correct, thanks for the fix patch.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

I'm kinda surprised gcc didn't warn about the set-but-unused variable.
Maybe the call to file_attr_to_fsxattr confused it or something.

> ---
>  libfrog/file_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> Note: the tests need to be updated, as they didn’t catch this problem.

Yep. :/

--D

> diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
> index c2cbcb4e..6801c545 100644
> --- a/libfrog/file_attr.c
> +++ b/libfrog/file_attr.c
> @@ -114,7 +114,7 @@ xfrog_file_setattr(
>  
>  	file_attr_to_fsxattr(fa, &fsxa);
>  
> -	error = ioctl(fd, FS_IOC_FSSETXATTR, fa);
> +	error = ioctl(fd, FS_IOC_FSSETXATTR, &fsxa);
>  	close(fd);
>  
>  	return error;
> -- 
> 2.52.0
> 
> 
