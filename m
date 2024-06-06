Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F28E13BAEB
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687741; cv=none; b=od9uTZbyselaqaiT5MGO51ruey5FU2j3O19EC/cuZbzgEGsOYJiefxbN55j2xbFa91Z09qPQoog7q8nEAkv0CSsxhk5PYeQ5lEqsj0QCUdZbzAXaeo0PW62swlZusB5VHcORTHg/0QL0dB8aA3v85TvnBQqgbKcDntQJgfXXJfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687741; c=relaxed/simple;
	bh=lKCdWfvt1rAmiGe0cUuZLKW+1kci9Mmj1fCaBCVBjNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c58rLOpcGxUzwF0BXReoO6RlTfa5otKiyiZftZ9OdQ9EA9bbUTG2hBnJBsY6rqQBJ9czaVGiqUaALMhd5GU4Lkw8IRjjKOkVgV+30i9GtABZWlfoeBsdDK9OXKcNgHxxEGAktIXl5v/W5bAnGBxBUJxYtkGsE6XKUOsVhhV3W0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rSDVamB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rSDVamB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B12CC2BD10;
	Thu,  6 Jun 2024 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717687740;
	bh=lKCdWfvt1rAmiGe0cUuZLKW+1kci9Mmj1fCaBCVBjNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rSDVamB58q/Zo99Q3msgykBTZPdIfXS971hEXfRG20cmI8Q9N7GSrR3CPVVX4aSqR
	 DAb7rtC9s9au9z7Dk6otE1nVwaDAVfshWMQ+Nu8GeVRC45yD1p0lKVc19Ahuct8uee
	 v16wntcOVxw6GGzaiSrfW6urpKDjpyReSJEKeaNHPxaIOSl3rp3pND48jZquHnaoTE
	 dOcEq4smj9YxYYwAOAkoDAZJ9jGZzYllGdAMAs0L/S/dPcx4Sv01UNRnJDdxyHBDgr
	 K3gC2I2ArY6HstFWZZRIZwgrxkbUoakHE6ApzLkt00GGqgCxMvN1P4+REoAuEUi61S
	 PxB9uvOXnCezw==
Date: Thu, 6 Jun 2024 08:28:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Zorro Lang <zlang@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfsprogs: remove platform_zero_range wrapper
Message-ID: <20240606152859.GL52987@frogsfrogsfrogs>
References: <a216140e-1c8a-4d04-ba46-670646498622@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a216140e-1c8a-4d04-ba46-670646498622@redhat.com>

On Wed, Jun 05, 2024 at 10:38:20PM -0500, Eric Sandeen wrote:
> Now that the guard around including <linux/falloc.h> in
> linux/xfs.h has been removed via
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
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
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

Technically speaking, this is an abi change in the xfs library headers
so you can't just yank this without a deprecation period.  That said,
debian codesearch doesn't show any users ... so if there's nothing in
RHEL/Fedora then perhaps it's ok to do that?

Fedora magazine pointed me at "sourcegraph" so I tried:
https://sourcegraph.com/search?q=context:global+repo:%5Esrc.fedoraproject.org/+platform_zero_range&patternType=regexp&sm=0

It shows no callers, but it doesn't show the definition either.

> -
>  /*
>   * Use SIGKILL to simulate an immediate program crash, without a chance to run
>   * atexit handlers.
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 153007d5..e5b6b5de 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -67,17 +67,19 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  	ssize_t		zsize, bytes;
>  	size_t		len_bytes;
>  	char		*z;
> -	int		error;
> +	int		error = 0;

Is this declaration going to cause build warnings about unused variables
if built on a system that doesn't have FALLOC_FL_ZERO_RANGE?

(Maybe we don't care?)

--D

>  
>  	start_offset = LIBXFS_BBTOOFF64(start);
>  
>  	/* try to use special zeroing methods, fall back to writes if needed */
>  	len_bytes = LIBXFS_BBTOOFF64(len);
> -	error = platform_zero_range(fd, start_offset, len_bytes);
> +#if defined(FALLOC_FL_ZERO_RANGE)
> +	error = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
>  	if (!error) {
>  		xfs_buftarg_trip_write(btp);
>  		return 0;
>  	}
> +#endif
>  
>  	zsize = min(BDSTRAT_SIZE, BBTOB(len));
>  	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
> 
> 
