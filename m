Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8EC285CAE;
	Fri, 13 Mar 2026 23:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773445981; cv=none; b=YbLzyG1Hqc9k6mf2s1/g5MulHKbziUnLZ1wcmR3meLsNieu87iPXiN/4LkrnghmrRNLFjEfKsHIloHFhgacTcOEXcY1XJykE/j8pHqSKGt6magKKVqS2APFflIQHyK4xGvlcszLCCpvXeIWmoCF5JlwqYqpM771xNOuBTEZQTbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773445981; c=relaxed/simple;
	bh=5r5j5oLDbMFyq7DrYWhRWxFhJiFPpNWAap2QKg7KDhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXeq5YYZ39FxAiCJq4gV7KsJb+aZNZG+Kan4mxzSrkI/w6x8Je6OqtHNsfMGmzpol4VNLB/FDBtb6hRt4/SEUMvK7OOswKSKIDLF9jPv5MFpUoDgutxr8TIkxa5hhqFmYEL4lshPzMGoGUXoKl1ieZZOqbVJAyHKEU+/cRCLcD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUxeMhqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUxeMhqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62260C19421;
	Fri, 13 Mar 2026 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773445980;
	bh=5r5j5oLDbMFyq7DrYWhRWxFhJiFPpNWAap2QKg7KDhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CUxeMhqCD1bvPi8eMx70VUDJiTsoNxt4QobZZtz33U2AY99VVCyocFUOLcqUKPhqt
	 36XtbhAC1/aJ5/hswzi2ExgxSnGIzvtggBYNsn8dZdywI5QIRG5F5vXpj8A2wuSaWL
	 hkL1Niqo/so9kxkWHR8Xs2uGOv0yp2I6ovHZooNeVxdrYFRE2WRkEWwlywS5kZ3ic2
	 +IOlK6Xw0IIw5hMBGkMz9y6vWq86/9RKgoPSqNFcesjwKgnD3zDOiFi2tM0ArBUi+4
	 KblOHyK7R+d0jVuW9ehAzMiy2ga9a/XdizZ/H5E3BC3F8BNalcCxmiCk0RO6fsuf2o
	 3PXseipOO1MSw==
Date: Fri, 13 Mar 2026 16:52:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, lukas@herbolt.com,
	dgc@kernel.org, pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] ltp: add support for FALLOC_FL_WRITE_ZEROES to fsx and
 fsstress
Message-ID: <20260313235259.GH6023@frogsfrogsfrogs>
References: <20260312195308.738189-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312195308.738189-1-p.raghav@samsung.com>

On Thu, Mar 12, 2026 at 08:53:08PM +0100, Pankaj Raghav wrote:
> Add FALLOC_FL_WRITE_ZEROES support to both fsx and fsstress.
> FALLOC_FL_WRITE_ZEROES flag was added in the kernel as a part of Zhang
> Yi's series [1].
> 
> FALLOC_FL_KEEP_SIZE is not supported when FALLOC_FL_WRITE_ZEROES is
> used.
> 
> [1] https://lore.kernel.org/linux-fsdevel/20250619111806.3546162-1-yi.zhang@huaweicloud.com/
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Looks like a clone of the ZERO_RANGE code so I think this is ready for
wider testing...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  ltp/fsstress.c | 15 ++++++++-
>  ltp/fsx.c      | 85 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  src/global.h   |  8 +++++
>  3 files changed, 105 insertions(+), 3 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 9d0ed32f..fe340aea 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -124,6 +124,7 @@ typedef enum {
>  	OP_MWRITE,
>  	OP_PUNCH,
>  	OP_ZERO,
> +	OP_WRITE_ZEROES,
>  	OP_COLLAPSE,
>  	OP_INSERT,
>  	OP_READ,
> @@ -257,6 +258,7 @@ void	mread_f(opnum_t, long);
>  void	mwrite_f(opnum_t, long);
>  void	punch_f(opnum_t, long);
>  void	zero_f(opnum_t, long);
> +void	write_zeroes_f(opnum_t, long);
>  void	collapse_f(opnum_t, long);
>  void	insert_f(opnum_t, long);
>  void	unshare_f(opnum_t, long);
> @@ -326,6 +328,7 @@ struct opdesc	ops[OP_LAST]	= {
>  	[OP_MWRITE]	   = {"mwrite",	       mwrite_f,	2, 1 },
>  	[OP_PUNCH]	   = {"punch",	       punch_f,		1, 1 },
>  	[OP_ZERO]	   = {"zero",	       zero_f,		1, 1 },
> +	[OP_WRITE_ZEROES]  = {"write_zeroes",  write_zeroes_f,	1, 1 },
>  	[OP_COLLAPSE]	   = {"collapse",      collapse_f,	1, 1 },
>  	[OP_INSERT]	   = {"insert",	       insert_f,	1, 1 },
>  	[OP_READ]	   = {"read",	       read_f,		1, 0 },
> @@ -3827,6 +3830,7 @@ struct print_flags falloc_flags [] = {
>  	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
>  	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
>  	{ FALLOC_FL_UNSHARE_RANGE, "UNSHARE_RANGE"},
> +	{ FALLOC_FL_WRITE_ZEROES, "WRITE_ZEROES"},
>  	{ -1, NULL}
>  };
>  
> @@ -3886,7 +3890,8 @@ do_fallocate(opnum_t opno, long r, int mode)
>  		off = roundup_64(off, stb.st_blksize);
>  		len = roundup_64(len, stb.st_blksize);
>  	}
> -	mode |= FALLOC_FL_KEEP_SIZE & random();
> +	if (!(mode & FALLOC_FL_WRITE_ZEROES))
> +		mode |= FALLOC_FL_KEEP_SIZE & random();
>  	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
>  	if (v)
>  		printf("%d/%lld: fallocate(%s) %s%s [%lld,%lld] %d\n",
> @@ -4513,6 +4518,14 @@ zero_f(opnum_t opno, long r)
>  #endif
>  }
>  
> +void
> +write_zeroes_f(opnum_t opno, long r)
> +{
> +#ifdef HAVE_LINUX_FALLOC_H
> +	do_fallocate(opno, r, FALLOC_FL_WRITE_ZEROES);
> +#endif
> +}
> +
>  void
>  collapse_f(opnum_t opno, long r)
>  {
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 32b9d599..63cdd58e 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -125,6 +125,7 @@ enum {
>  	OP_FALLOCATE,
>  	OP_PUNCH_HOLE,
>  	OP_ZERO_RANGE,
> +	OP_WRITE_ZEROES,
>  	OP_COLLAPSE_RANGE,
>  	OP_INSERT_RANGE,
>  	OP_CLONE_RANGE,
> @@ -189,6 +190,7 @@ int     keep_size_calls = 1;            /* -K flag disables */
>  int     unshare_range_calls = 1;        /* -u flag disables */
>  int     punch_hole_calls = 1;           /* -H flag disables */
>  int     zero_range_calls = 1;           /* -z flag disables */
> +int     write_zeroes_calls = 1;         /* -Y flag disables */
>  int	collapse_range_calls = 1;	/* -C flag disables */
>  int	insert_range_calls = 1;		/* -I flag disables */
>  int	mapped_reads = 1;		/* -R flag disables it */
> @@ -306,6 +308,7 @@ static const char *op_names[] = {
>  	[OP_FALLOCATE] = "fallocate",
>  	[OP_PUNCH_HOLE] = "punch_hole",
>  	[OP_ZERO_RANGE] = "zero_range",
> +	[OP_WRITE_ZEROES] = "write_zeroes",
>  	[OP_COLLAPSE_RANGE] = "collapse_range",
>  	[OP_INSERT_RANGE] = "insert_range",
>  	[OP_CLONE_RANGE] = "clone_range",
> @@ -486,6 +489,13 @@ logdump(void)
>  			if (overlap)
>  				prt("\t******ZZZZ");
>  			break;
> +		case OP_WRITE_ZEROES:
> +			prt("WZERO    0x%x thru 0x%x\t(0x%x bytes)",
> +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> +			    lp->args[1]);
> +			if (overlap)
> +				prt("\t******ZZZZ");
> +			break;
>  		case OP_COLLAPSE_RANGE:
>  			prt("COLLAPSE 0x%x thru 0x%x\t(0x%x bytes)",
>  			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> @@ -1413,6 +1423,59 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
>  }
>  #endif
>  
> +#ifdef FALLOC_FL_WRITE_ZEROES
> +void
> +do_write_zeroes(unsigned offset, unsigned length)
> +{
> +	unsigned end_offset;
> +	int mode = FALLOC_FL_WRITE_ZEROES;
> +
> +	if (length == 0) {
> +		if (!quiet && testcalls > simulatedopcount)
> +			prt("skipping zero length write zeroes\n");
> +		log4(OP_WRITE_ZEROES, offset, length, FL_SKIPPED);
> +		return;
> +	}
> +
> +	end_offset = offset + length;
> +
> +	if (end_offset > biggest) {
> +		biggest = end_offset;
> +		if (!quiet && testcalls > simulatedopcount)
> +			prt("write_zeroes to largest ever: 0x%x\n", end_offset);
> +	}
> +
> +	log4(OP_WRITE_ZEROES, offset, length, FL_NONE);
> +
> +	if (end_offset > file_size)
> +		update_file_size(offset, length);
> +
> +	if (testcalls <= simulatedopcount)
> +		return;
> +
> +	if ((progressinterval && testcalls % progressinterval == 0) ||
> +	    (debug && (monitorstart == -1 || monitorend == -1 ||
> +		      end_offset <= monitorend))) {
> +		prt("%lld wzero\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
> +			offset, offset+length, length);
> +	}
> +	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
> +		prt("write zeroes: 0x%x to 0x%x\n", offset, offset + length);
> +		prterr("do_write_zeroes: fallocate");
> +		report_failure(161);
> +	}
> +
> +	memset(good_buf + offset, '\0', length);
> +}
> +
> +#else
> +void
> +do_write_zeroes(unsigned offset, unsigned length)
> +{
> +	return;
> +}
> +#endif
> +
>  #ifdef FALLOC_FL_COLLAPSE_RANGE
>  void
>  do_collapse_range(unsigned offset, unsigned length)
> @@ -2409,6 +2472,12 @@ have_op:
>  			goto out;
>  		}
>  		break;
> +	case OP_WRITE_ZEROES:
> +		if (!write_zeroes_calls) {
> +			log4(OP_WRITE_ZEROES, offset, size, FL_SKIPPED);
> +			goto out;
> +		}
> +		break;
>  	case OP_COLLAPSE_RANGE:
>  		if (!collapse_range_calls) {
>  			log4(OP_COLLAPSE_RANGE, offset, size, FL_SKIPPED);
> @@ -2512,6 +2581,10 @@ have_op:
>  		TRIM_OFF_LEN(offset, size, maxfilelen);
>  		do_zero_range(offset, size, keep_size);
>  		break;
> +	case OP_WRITE_ZEROES:
> +		TRIM_OFF_LEN(offset, size, maxfilelen);
> +		do_write_zeroes(offset, size);
> +		break;
>  	case OP_COLLAPSE_RANGE:
>  		TRIM_OFF_LEN(offset, size, file_size - 1);
>  		offset = rounddown_64(offset, block_size);
> @@ -2611,7 +2684,7 @@ void
>  usage(void)
>  {
>  	fprintf(stdout, "usage: %s",
> -		"fsx [-adfhknqxyzBEFHIJKLORWXZ0]\n\
> +		"fsx [-adfhknqxyzBEFHIJKLORWXZ0Y]\n\
>  	   [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid]\n\
>  	   [-l flen] [-m start:end] [-o oplen] [-p progressinterval]\n\
>  	   [-r readbdy] [-s style] [-t truncbdy] [-w writebdy]\n\
> @@ -2663,6 +2736,9 @@ usage(void)
>  #ifdef FALLOC_FL_ZERO_RANGE
>  "	-z: Do not use zero range calls\n"
>  #endif
> +#ifdef FALLOC_FL_WRITE_ZEROES
> +"	-Y: Do not use write zeroes calls\n"
> +#endif
>  #ifdef FALLOC_FL_COLLAPSE_RANGE
>  "	-C: Do not use collapse range calls\n"
>  #endif
> @@ -3160,7 +3236,7 @@ main(int argc, char **argv)
>  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>  
>  	while ((ch = getopt_long(argc, argv,
> -				 "0ab:c:de:fg:hi:j:kl:m:no:p:qr:s:t:uw:xyABD:EFJKHzCILN:TOP:RS:UWXZ",
> +				 "0ab:c:de:fg:hi:j:kl:m:no:p:qr:s:t:uw:xyABD:EFJKHzCILN:TOP:RS:UWXZY",
>  				 longopts, NULL)) != EOF)
>  		switch (ch) {
>  		case 'a':
> @@ -3307,6 +3383,9 @@ main(int argc, char **argv)
>  		case 'z':
>  			zero_range_calls = 0;
>  			break;
> +		case 'Y':
> +			write_zeroes_calls = 0;
> +			break;
>  		case 'C':
>  			collapse_range_calls = 0;
>  			break;
> @@ -3568,6 +3647,8 @@ main(int argc, char **argv)
>  		punch_hole_calls = test_fallocate(FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE);
>  	if (zero_range_calls)
>  		zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
> +	if (write_zeroes_calls)
> +		write_zeroes_calls = test_fallocate(FALLOC_FL_WRITE_ZEROES);
>  	if (collapse_range_calls)
>  		collapse_range_calls = test_fallocate(FALLOC_FL_COLLAPSE_RANGE);
>  	if (insert_range_calls)
> diff --git a/src/global.h b/src/global.h
> index fbc0a0b5..e07b3703 100644
> --- a/src/global.h
> +++ b/src/global.h
> @@ -179,6 +179,14 @@
>  #define FALLOC_FL_INSERT_RANGE		0x20
>  #endif
>  
> +#ifndef FALLOC_FL_UNSHARE_RANGE
> +#define FALLOC_FL_UNSHARE_RANGE		0x40
> +#endif
> +
> +#ifndef FALLOC_FL_WRITE_ZEROES
> +#define FALLOC_FL_WRITE_ZEROES		0x80
> +#endif
> +
>  #endif /* HAVE_LINUX_FALLOC_H */
>  
>  #ifdef HAVE_SYS_MMAN_H
> 
> base-commit: 3ded3e13c008326d197d11ac975049ed1f8ec922
> -- 
> 2.51.2
> 
> 
