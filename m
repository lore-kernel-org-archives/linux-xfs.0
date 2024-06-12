Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0473454BE7
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 18:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718216925; cv=none; b=nggucecMHktbi+b1RtbHaxpIXytEPfxjX4nhT6cck8Jo3Tpl+qdk0qeeS8OsrJeiaek7SjSQ2cRBdRYBNBh+Y3zSw3tV5izZ5GHySJIbmlQaC8ujEf6mEQUNIyUxLKrtBJZKoPKLjbKPiARjwMY6mMyR4Q7DQXxmv9Yy1FB4wGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718216925; c=relaxed/simple;
	bh=A52rMLl6LH2H9FF/NtJ6jhWqh5mp6F/8iJxCWEXqFz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdbpZO2ks6QnheDs/8qjRcjPPM8rrSVyBHf2l4FnuwRvGj2ryyBish50hnHgNuzofBWX4OjWaz2pC9QI6F6Fjyi86UzvLmwgDtO+Fh173HFbjF0eUZDDxNzklZk+ZhghuVErefwDRAT/LxdGXuYE3y97egsLZ1+kdKAvpNAOuzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHCcN7U+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHCcN7U+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA86C32786;
	Wed, 12 Jun 2024 18:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718216924;
	bh=A52rMLl6LH2H9FF/NtJ6jhWqh5mp6F/8iJxCWEXqFz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UHCcN7U+RZ6R0HFiT79PDrwTItMQDAtRhguee4jqL5iFNSQmyd+pAy2m8xPMtZ1tG
	 HMpAK10tq10sXh8/71ikBv3uk5BWwnGbg9qWkhdjsKutXDvLcSmYf14oLnAs3PPXqD
	 LTBTYECGS7EVjmg1RxdzoPa/gLnvkRH1RQOj7jvdTfZJ8m0hYtGCxQPliapCw90OM1
	 Re8SldFvHNtlbSAChCwbf5tCPf2Y4SCTLTzKzpp6amZIa6VDq6bx3XRmrL6Ou2li3r
	 0WLH06YAlcJAuNyqSQmVRPwXtAGzbpSZ0LdxAhVdrJBW7Oae6ERyuA6cjYgIcRuXud
	 N/Qk6X73v4tTA==
Date: Wed, 12 Jun 2024 11:28:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH V3] xfsprogs: remove platform_zero_range wrapper
Message-ID: <20240612182844.GF2764752@frogsfrogsfrogs>
References: <be7f0845-5d5f-4af5-9ca9-3e4370b47d97@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be7f0845-5d5f-4af5-9ca9-3e4370b47d97@sandeen.net>

On Fri, Jun 07, 2024 at 10:24:52AM -0500, Eric Sandeen wrote:
> Now that the HAVE_FALLOCATE guard around including
> <linux/falloc.h> in linux/xfs.h has been removed via
> 15fb447f ("configure: don't check for fallocate"),
> bad things can happen because we reference fallocate in
> <xfs/linux.h> without defining _GNU_SOURCE:
> 
> $ cat test.c
> #include <xfs/linux.h>
> 
> int main(void)
> {
> 	return 0;
> }
> 
> $ gcc -o test test.c
> In file included from test.c:1:
> /usr/include/xfs/linux.h: In function ‘platform_zero_range’:
> /usr/include/xfs/linux.h:186:15: error: implicit declaration of function ‘fallocate’ [-Wimplicit-function-declaration]
>   186 |         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
>       |               ^~~~~~~~~
> 
> i.e. xfs/linux.h includes fcntl.h without _GNU_SOURCE, so we
> don't get an fallocate prototype.
> 
> Rather than playing games with header files, just remove the
> platform_zero_range() wrapper - we have only one platform, and
> only one caller after all - and simply call fallocate directly
> if we have the FALLOC_FL_ZERO_RANGE flag defined.
> 
> (LTP also runs into this sort of problem at configure time ...)
> 
> Darrick points out that this changes a public header, but
> platform_zero_range() has only been exposed by default
> (without the oddball / internal xfsprogs guard) for a couple
> of xfsprogs releases, so it's quite unlikely that anyone is
> using this oddball fallocate wrapper.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Ok I'm convinced
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> V2: remove error variable, add to commit msg
> V3: Drop FALLOC_FL_ZERO_RANGE #ifdef per hch's suggestion and
>     add his RVB from V2, with changes.
> 
> NOTE: compile tested only
> 
> diff --git a/include/linux.h b/include/linux.h
> index 95a0deee..a13072d2 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -174,24 +174,6 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
>  	endmntent(cursor->mtabp);
>  }
>  
> -#if defined(FALLOC_FL_ZERO_RANGE)
> -static inline int
> -platform_zero_range(
> -	int		fd,
> -	xfs_off_t	start,
> -	size_t		len)
> -{
> -	int ret;
> -
> -	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
> -	if (!ret)
> -		return 0;
> -	return -errno;
> -}
> -#else
> -#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
> -#endif
> -
>  /*
>   * Use SIGKILL to simulate an immediate program crash, without a chance to run
>   * atexit handlers.
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 153007d5..b54505b5 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -73,7 +73,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  
>  	/* try to use special zeroing methods, fall back to writes if needed */
>  	len_bytes = LIBXFS_BBTOOFF64(len);
> -	error = platform_zero_range(fd, start_offset, len_bytes);
> +	error = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
>  	if (!error) {
>  		xfs_buftarg_trip_write(btp);
>  		return 0;
> 
> 
