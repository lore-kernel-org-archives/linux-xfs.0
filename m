Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89C55C97
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 05:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qucd1cWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBB4C433C7;
	Tue, 19 Dec 2023 05:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702963623;
	bh=0Dln6JHcRdhBQaiA0TtncEyOlbFKKl9ErZFzTx/k0bA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qucd1cWIhrBhSHNm3PeT1hxpPk6CszUZMpQpH+QtnvHoVuiDJjIvowiBVN0gtdfml
	 xfhAG6PJcJYDpLTocj0Fa+nHEmiwU6UWSg62GWpFLL/NyzA04W75W/SlGRbhnjggS4
	 PUXLG7rrq/40Nlg2YgsPvCkm2hXjrTlm5MHOD7EDzoEm30Ad3778Ikp2kK5tqskt/M
	 KPvEN1NSkw+sez7gtUBuofJa4AwJIkzvnTvedsAcTmDqshb6q7vjgHxGCXksgXJ9TA
	 Ltc2AxIyp7rpuCOBushuJMjm8mb0FzPU81kK1/j5fZzC2AsQ3hh7IrAquMBy4rzNgl
	 RQxtupNLnqPaQ==
Date: Mon, 18 Dec 2023 21:27:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sam James <sam@gentoo.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] io: Adapt to >= 64-bit time_t
Message-ID: <20231219052702.GJ361584@frogsfrogsfrogs>
References: <20231215013657.1995699-1-sam@gentoo.org>
 <20231215013657.1995699-4-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215013657.1995699-4-sam@gentoo.org>

On Fri, Dec 15, 2023 at 01:36:43AM +0000, Sam James wrote:
> We now require (at least) 64-bit time_t, so we need to adjust some printf
> specifiers accordingly.
> 
> Unfortunately, we've stumbled upon a ridiculous C mmoment whereby there's

Plenty of those to go around...

> no neat format specifier (not even one of the inttypes ones) for time_t, so
> we cast to intmax_t and use %jd.
> 
> Signed-off-by: Sam James <sam@gentoo.org>
> ---
> v3: uintmax_t -> intmax_t as time_t is signed
> 
>  io/stat.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/io/stat.c b/io/stat.c
> index e8f68dc3..743a7586 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -66,11 +66,11 @@ dump_raw_stat(struct stat *st)
>  	printf("stat.ino = %llu\n", (unsigned long long)st->st_ino);
>  	printf("stat.size = %lld\n", (long long)st->st_size);
>  	printf("stat.blocks = %lld\n", (long long)st->st_blocks);
> -	printf("stat.atime.tv_sec = %ld\n", st->st_atim.tv_sec);
> +	printf("stat.atime.tv_sec = %jd\n", (intmax_t)st->st_atim.tv_sec);

I almost wonder if we want a similar
BUILD_BUG_ON(sizeof(time_t) < 8);
here or something?

Also I totally didn't realize that "intmax_t" is actually s64 on x86_64.
I saw "int" and assumed "still 32-bit".

But, I guess C99 says "...capable of representing any value of any basic
signed integer type supported by the implementation."

So it apparently works even for 32-bit compilers, at least according to
godbolt.org...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  	printf("stat.atime.tv_nsec = %ld\n", st->st_atim.tv_nsec);
> -	printf("stat.ctime.tv_sec = %ld\n", st->st_ctim.tv_sec);
> +	printf("stat.ctime.tv_sec = %jd\n", (intmax_t)st->st_ctim.tv_sec);
>  	printf("stat.ctime.tv_nsec = %ld\n", st->st_ctim.tv_nsec);
> -	printf("stat.mtime.tv_sec = %ld\n", st->st_mtim.tv_sec);
> +	printf("stat.mtime.tv_sec = %jd\n", (intmax_t)st->st_mtim.tv_sec);
>  	printf("stat.mtime.tv_nsec = %ld\n", st->st_mtim.tv_nsec);
>  	printf("stat.rdev_major = %u\n", major(st->st_rdev));
>  	printf("stat.rdev_minor = %u\n", minor(st->st_rdev));
> -- 
> 2.43.0
> 
> 
