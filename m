Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1A2154448;
	Thu, 22 Aug 2024 20:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724359978; cv=none; b=nr0Cwyf6JKkPTLnWDGdYu9OT8jwOJ9GEPiJC60FKjqYJXMaMqB4qXZOClNhfQbobIU5682hlbWdjpXHDzU2WaXqjLRuCpSYCxZZ9iKPFSP4cqE0ewSfvM2iUtsV50e0MehJRA+ycHZm1syNcUAR+iXYzdqsjO6aAgegou8t4Bjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724359978; c=relaxed/simple;
	bh=12LDcvl633ZFuLHlZNXoeCuCBYGueFl5SeVhmqMMLoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLVKEq2qbSv7/vGA+BO38JHxX9kNFU5VV58LpLN0bg5gjPEUVfHmjJoSGVcEur+o3QI9xABFOwwdrJz/F3cWRG7SJJI+CnYlol+97az0KAzw6agdO3Is2ZwdWAEhjzbiuGi/q/qCqCOyWmooUz8yl3rZvdTBSndYBfuDH469kZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnntFPlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnntFPlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159DCC32782;
	Thu, 22 Aug 2024 20:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724359978;
	bh=12LDcvl633ZFuLHlZNXoeCuCBYGueFl5SeVhmqMMLoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lnntFPlWOBtRHrknICPLrfAaGi1HFwCi7vtYBv6AU2d2nRVuBXRTI7nfa5k20JHNl
	 9R7gkSFliKqHannoKXpBfA1KEeadXxEwvhjjUA0Lw6c3BdvH1BYYoZFpS+G7u+YDdY
	 eFNLAqzJuMw1B2cL5N7wF657NoYmxODvQaLn8lAqlZn8akbqqMibxjhPnQ7bSs3TOT
	 S6zX55i/McmvrEiVewNQTP1USVFYx+btkU1CrWFQELClugg7q7ERCK8A7Ha64O13P9
	 LYCDQ7Y7aYk0F2Hlq0aPfPbcwvqur0wJlEJFa2smKPywun6pgv95Mw4slMT/H/9OJH
	 h+wPr9UsWZf1g==
Date: Thu, 22 Aug 2024 13:52:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH 2/3] fsx: support eof page pollution for eof zeroing test
 coverage
Message-ID: <20240822205257.GW865349@frogsfrogsfrogs>
References: <20240822144422.188462-1-bfoster@redhat.com>
 <20240822144422.188462-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822144422.188462-3-bfoster@redhat.com>

On Thu, Aug 22, 2024 at 10:44:21AM -0400, Brian Foster wrote:
> File ranges that are newly exposed via size changing operations are
> expected to return zeroes until written to. This behavior tends to
> be difficult to regression test as failures can be racy and
> transient. fsx is probably the best tool for this type of test
> coverage, but uncovering issues can require running for a
> significantly longer period of time than is typically invoked
> through fstests tests. As a result, these types of regressions tend
> to go unnoticed for an unfortunate amount of time.
> 
> To facilitate uncovering these problems more quickly, implement an
> eof pollution mode in fsx that opportunistically injects post-eof
> data prior to operations that change file size. Since data injection
> occurs immediately before the size changing operation, it can be
> used to detect problems in partial eof page/block zeroing associated
> with each relevant operation.
> 
> The implementation takes advantage of the fact that mapped writes
> can place data beyond eof so long as the page starts within eof. The
> main reason for the isolated per-operation approach (vs. something
> like allowing mapped writes to write beyond eof, for example) is to
> accommodate the fact that writeback zeroes post-eof data on the eof
> page. The current approach is therefore not necessarily guaranteed
> to detect all problems, but provides more generic and broad test
> coverage than the alternative of testing explicit command sequences
> and doesn't require significant changes to how fsx works. If this
> proves useful long term, further enhancements can be considered that
> might facilitate the presence of post-eof data across operations.
> 
> Enable the feature with the -e command line option. It is disabled
> by default because zeroing behavior is inconsistent across
> filesystems. This can also be revisited in the future if zeroing
> behavior is refined for the major filesystems that rely on fstests
> for regression testing.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  ltp/fsx.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 72 insertions(+), 2 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 1389c51d..20b8cd9f 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -178,6 +178,7 @@ int	dedupe_range_calls = 1;		/* -B flag disables */
>  int	copy_range_calls = 1;		/* -E flag disables */
>  int	exchange_range_calls = 1;	/* -0 flag disables */
>  int	integrity = 0;			/* -i flag */
> +int	pollute_eof = 0;		/* -e flag */
>  int	fsxgoodfd = 0;
>  int	o_direct;			/* -Z */
>  int	aio = 0;
> @@ -983,6 +984,58 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
>  	}
>  }
>  
> +/*
> + * Pollute the EOF page with data beyond EOF prior to size change operations.
> + * This provides additional test coverage for partial EOF block/page zeroing.
> + * If the upcoming operation does not correctly zero, incorrect file data will
> + * be detected.
> + */
> +void
> +pollute_eofpage(unsigned int maxoff)
> +{
> +	unsigned offset = file_size;
> +	unsigned pg_offset;
> +	unsigned write_size;
> +	char    *p;
> +
> +	if (!pollute_eof)
> +		return;
> +
> +	/* write up to specified max or the end of the eof page */
> +	pg_offset = offset & mmap_mask;
> +	write_size = MIN(PAGE_SIZE - pg_offset, maxoff - offset);
> +
> +	if (!pg_offset)
> +		return;
> +
> +	if (!quiet &&
> +	    ((progressinterval && testcalls % progressinterval == 0) ||
> +	    (debug &&
> +	     (monitorstart == -1 ||
> +	     (offset + write_size > monitorstart &&
> +	      (monitorend == -1 || offset <= monitorend)))))) {
> +		prt("%lld pollute_eof\t0x%x thru\t0x%x\t(0x%x bytes)\n",
> +			testcalls, offset, offset + write_size - 1, write_size);
> +	}
> +
> +	if ((p = (char *)mmap(0, PAGE_SIZE, PROT_READ | PROT_WRITE,
> +			      MAP_FILE | MAP_SHARED, fd,
> +			      (off_t)(offset - pg_offset))) == (char *)-1) {

Nit:

if (mmap(...) == MAP_FAILED)?

Otherwise I like the concept here. :)

--D

> +		prterr("pollute_eofpage: mmap");
> +		return;
> +	}
> +
> +	/*
> +	 * Write to a range just past EOF of the test file. Do not update the
> +	 * good buffer because the upcoming operation is expected to zero this
> +	 * range of the file.
> +	 */
> +	gendata(original_buf, p, pg_offset, write_size);
> +
> +	if (munmap(p, PAGE_SIZE) != 0)
> +		prterr("pollute_eofpage: munmap");
> +}
> +
>  /*
>   * Helper to update the tracked file size. If the offset begins beyond current
>   * EOF, zero the range from EOF to offset in the good buffer.
> @@ -990,8 +1043,10 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
>  void
>  update_file_size(unsigned offset, unsigned size)
>  {
> -	if (offset > file_size)
> +	if (offset > file_size) {
> +		pollute_eofpage(offset + size);
>  		memset(good_buf + file_size, '\0', offset - file_size);
> +	}
>  	file_size = offset + size;
>  }
>  
> @@ -1143,6 +1198,9 @@ dotruncate(unsigned size)
>  
>  	log4(OP_TRUNCATE, 0, size, FL_NONE);
>  
> +	/* pollute the current EOF before a truncate down */
> +	if (size < file_size)
> +		pollute_eofpage(maxfilelen);
>  	update_file_size(size, 0);
>  
>  	if (testcalls <= simulatedopcount)
> @@ -1305,6 +1363,9 @@ do_collapse_range(unsigned offset, unsigned length)
>  
>  	log4(OP_COLLAPSE_RANGE, offset, length, FL_NONE);
>  
> +	/* pollute current eof before collapse truncates down */
> +	pollute_eofpage(maxfilelen);
> +
>  	if (testcalls <= simulatedopcount)
>  		return;
>  
> @@ -1356,6 +1417,9 @@ do_insert_range(unsigned offset, unsigned length)
>  
>  	log4(OP_INSERT_RANGE, offset, length, FL_NONE);
>  
> +	/* pollute current eof before insert truncates up */
> +	pollute_eofpage(maxfilelen);
> +
>  	if (testcalls <= simulatedopcount)
>  		return;
>  
> @@ -2385,6 +2449,7 @@ usage(void)
>  	-b opnum: beginning operation number (default 1)\n\
>  	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
>  	-d: debug output for all operations\n\
> +	-e: pollute post-eof on size changes (default 0)\n\
>  	-f: flush and invalidate cache after I/O\n\
>  	-g X: write character X instead of random generated data\n\
>  	-i logdev: do integrity testing, logdev is the dm log writes device\n\
> @@ -2783,7 +2848,7 @@ main(int argc, char **argv)
>  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>  
>  	while ((ch = getopt_long(argc, argv,
> -				 "0b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
> +				 "0b:c:de:fg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
>  				 longopts, NULL)) != EOF)
>  		switch (ch) {
>  		case 'b':
> @@ -2805,6 +2870,11 @@ main(int argc, char **argv)
>  		case 'd':
>  			debug = 1;
>  			break;
> +		case 'e':
> +			pollute_eof = getnum(optarg, &endp);
> +			if (pollute_eof < 0 || pollute_eof > 1)
> +				usage();
> +			break;
>  		case 'f':
>  			flush = 1;
>  			break;
> -- 
> 2.45.0
> 
> 
