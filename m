Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7517B391
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727830867; cv=none; b=JxFIZXhAOM8mxPSbe06iqClkcVnAttXIOou80DbyRli/amMLm4liVvAWSr9qzCBo2VN1PWh3xfhx0Rv0q3SktlyXc8R5LxdUzAOajUxlXmXdkKTEUurMEXYRAwFM7Ze3vMXezZXbhCEktnfwFO/mJu8CKosO9hhogNkZa34qj78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727830867; c=relaxed/simple;
	bh=t5XPurXdKpjZ222fkTUjxs9XQpihyHHQkExZXhmlF/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8HnZ/jDNsooFy+cgJbIJp17uu6BT/C4OVUVAYKCktf+arL+Xg7QZNboLRx6UdCIhiiafGAq3QAF40IYGZJHHfpIQv3zoxj5i4JpCl2G/FTCBD4+kO8ryKwyya4157kYHJ/HMw9wLHg4RgyXBLGgspdZvvP+vBHjmDb1PufaJns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkt6+1C6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkt6+1C6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED828C4CEC6;
	Wed,  2 Oct 2024 01:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727830867;
	bh=t5XPurXdKpjZ222fkTUjxs9XQpihyHHQkExZXhmlF/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nkt6+1C6Pb9QMwer1Vs3sRF5ktibxhFdXB5TwG24mNmttjraF3PqVXZWW++bCEoC0
	 cposKPpEn8u+Xdleprz83UTtfMPgf1N2mPn08aLqQwOjJMv+KUS5A+RDBHwj8swliL
	 XFEErwzYWyKMj68uAnhv7cfi6zf8hhnp9LJNijs2WXcH1kP4r8Dj055uhdSx0ulFLZ
	 6Q2vH924Tv+1n4SZyIXhhfoR//GJJ39H0wxdf5LmGjRughX1BKrzyMmDZtmsLldVqU
	 J2O5ZjZmfcDsKgpkyR1kleMEAqAsybUm7PuhwmbC9GK1cSG3R5/OAp+AtNK2AVKnIS
	 8YlZenaK1NQuQ==
Date: Tue, 1 Oct 2024 18:01:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs_io: add RWF_ATOMIC support to pwrite
Message-ID: <20241002010106.GX21853@frogsfrogsfrogs>
References: <20241001182849.7272-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001182849.7272-1-catherine.hoang@oracle.com>

On Tue, Oct 01, 2024 at 11:28:49AM -0700, Catherine Hoang wrote:
> Enable testing write behavior with the per-io RWF_ATOMIC flag.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Looks ok, though are there testcases for us to look at as well?
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  include/linux.h   | 5 +++++
>  io/pwrite.c       | 8 ++++++--
>  man/man8/xfs_io.8 | 8 +++++++-
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index a13072d2..e9eb7bfb 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -231,6 +231,11 @@ struct fsxattr {
>  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>  #endif
>  
> +/* Atomic Write */
> +#ifndef RWF_ATOMIC
> +#define RWF_ATOMIC	((__kernel_rwf_t)0x00000040)
> +#endif
> +
>  /*
>   * Reminder: anything added to this file will be compiled into downstream
>   * userspace projects!
> diff --git a/io/pwrite.c b/io/pwrite.c
> index a88cecc7..fab59be4 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -44,6 +44,7 @@ pwrite_help(void)
>  #ifdef HAVE_PWRITEV2
>  " -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
>  " -D   -- Perform the pwritev2() with RWF_DSYNC\n"
> +" -A   -- Perform the pwritev2() with RWF_ATOMIC\n"
>  #endif
>  "\n"));
>  }
> @@ -284,7 +285,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "Ab:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -324,6 +325,9 @@ pwrite_f(
>  		case 'D':
>  			pwritev2_flags |= RWF_DSYNC;
>  			break;
> +		case 'A':
> +			pwritev2_flags |= RWF_ATOMIC;
> +			break;
>  #endif
>  		case 's':
>  			skip = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -476,7 +480,7 @@ pwrite_init(void)
>  	pwrite_cmd.argmax = -1;
>  	pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	pwrite_cmd.args =
> -_("[-i infile [-qdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
> +_("[-i infile [-qAdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
>  	pwrite_cmd.oneline =
>  		_("writes a number of bytes at a specified offset");
>  	pwrite_cmd.help = pwrite_help;
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 303c6447..1e790139 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -244,7 +244,7 @@ See the
>  .B pread
>  command.
>  .TP
> -.BI "pwrite [ \-i " file " ] [ \-qdDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
> +.BI "pwrite [ \-i " file " ] [ \-qAdDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
>  Writes a range of bytes in a specified blocksize from the given
>  .IR offset .
>  The bytes written can be either a set pattern or read in from another
> @@ -281,6 +281,12 @@ Perform the
>  call with
>  .IR RWF_DSYNC .
>  .TP
> +.B \-A
> +Perform the
> +.BR pwritev2 (2)
> +call with
> +.IR RWF_ATOMIC .
> +.TP
>  .B \-O
>  perform pwrite once and return the (maybe partial) bytes written.
>  .TP
> -- 
> 2.34.1
> 
> 
