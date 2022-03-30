Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23671C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 15:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348414AbiC3Pxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 11:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344935AbiC3Pxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 11:53:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2F4DBC;
        Wed, 30 Mar 2022 08:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3CC361724;
        Wed, 30 Mar 2022 15:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20491C340EC;
        Wed, 30 Mar 2022 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648655521;
        bh=7FgCyRfpLM8OxrU4cKR0Z85J1SkUnxCQDLMcAADOuqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=azg7aSd3mQroQ/Slbmvk5psDK5DUlT+/8qhhXdNiZLCVVb/OtxtJWvR0VKFfqle5E
         sI36HwFRTJQ54Abvrer7eFyaAMkHJpSzFSeMjXZRKs2wEOeikIm44fOOZ/mias4DNu
         qmQWNAJ8erwlUjooBBLWi7wzF7i3u2qXDGCVu6aztkQLUuUUyvP1fYhdC59kj/e0q5
         Slr4XR1p5t44oXgWrHAMRdXFRGnWavPkp+vaB5TLDyG2IOnbVB+GkDHqKmie1NSogR
         2hM0O0hLgKDA2wlIqzdsEBCH1Sq88+pNbM+nJScu7OJ32koM1TENFGw6FbvvOELDSi
         Oh8y70UDI6w3Q==
Date:   Wed, 30 Mar 2022 08:52:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        liuyd.fnst@fujitsu.com
Subject: Re: [PATCH] fsx: remove XFS_IOC_ALLOCSP operation entirely
Message-ID: <20220330155200.GH27690@magnolia>
References: <20220330052506.650390-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330052506.650390-1-zlang@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 01:25:06PM +0800, Zorro Lang wrote:
> Due to XFS_IOC_ALLOCSP is nearly retired from linux xfs, and the
> ALLOCSP testing in fsx easily trigger errors. So compare with
> disable it by default, I'd like to remove it entirely. So this
> patch revert two patches:
> cd99a499 ("fsx: disable allocsp_calls if -F is specified")
> a32fb1bb ("fsx: add support for XFS_IOC_ALLOCSP")
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Hmm.  fsstress and iogen also use ALLOCSP/FREESP, so perhaps they should
also get cleaned out?  I guess the difference here is that fsx errors
out if the call fails, whereas the other two have some ability to try
alternate means. <shrug>

*oh* Now I realize why there was a complaint about this -- I added that
allocsp_calls variable to guard against the case where fsx is built with
old uapi headers but run on a new kernel, but nowhere do we actually
gate ALLOCSP usage with allocsp_calls.

Anyway, ALLOCSP was broken for decades and is now gone, so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Hi,
> 
> As we talked in:
> https://lore.kernel.org/fstests/20220330045718.wqrarqorslzaeks5@zlang-mailbox/T/#t
> 
> We have two choices:
> 1) Disable ALLOCSP from fsx by default, and give it another option to enable it
>    manually if someone need it.
> 2) Remove the ALLOCSP support from fsx entirely
> 
> As Darrick's suggestion, this patch choose the 2nd one. Please review and feel
> free to tell me if you have other suggestions.
> 
> Thanks,
> Zorro
> 
>  ltp/fsx.c | 111 +-----------------------------------------------------
>  1 file changed, 2 insertions(+), 109 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 3ee37fe8..12c2cc33 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -111,7 +111,6 @@ enum {
>  	OP_CLONE_RANGE,
>  	OP_DEDUPE_RANGE,
>  	OP_COPY_RANGE,
> -	OP_ALLOCSP,
>  	OP_MAX_FULL,
>  
>  	/* integrity operations */
> @@ -166,7 +165,6 @@ int	randomoplen = 1;		/* -O flag disables it */
>  int	seed = 1;			/* -S flag */
>  int     mapped_writes = 1;              /* -W flag disables */
>  int     fallocate_calls = 1;            /* -F flag disables */
> -int     allocsp_calls = 1;		/* -F flag disables */
>  int     keep_size_calls = 1;            /* -K flag disables */
>  int     punch_hole_calls = 1;           /* -H flag disables */
>  int     zero_range_calls = 1;           /* -z flag disables */
> @@ -270,7 +268,6 @@ static const char *op_names[] = {
>  	[OP_DEDUPE_RANGE] = "dedupe_range",
>  	[OP_COPY_RANGE] = "copy_range",
>  	[OP_FSYNC] = "fsync",
> -	[OP_ALLOCSP] = "allocsp",
>  };
>  
>  static const char *op_name(int operation)
> @@ -413,15 +410,6 @@ logdump(void)
>  			if (overlap)
>  				prt("\t******WWWW");
>  			break;
> -		case OP_ALLOCSP:
> -			down = lp->args[1] < lp->args[2];
> -			prt("ALLOCSP  %s\tfrom 0x%x to 0x%x",
> -			    down ? "DOWN" : "UP", lp->args[2], lp->args[1]);
> -			overlap = badoff >= lp->args[1 + !down] &&
> -				  badoff < lp->args[1 + !!down];
> -			if (overlap)
> -				prt("\t******NNNN");
> -			break;
>  		case OP_FALLOCATE:
>  			/* 0: offset 1: length 2: where alloced */
>  			prt("FALLOC   0x%x thru 0x%x\t(0x%x bytes) ",
> @@ -1707,51 +1695,6 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
>  }
>  #endif
>  
> -#ifdef XFS_IOC_ALLOCSP
> -/* allocsp is an old Irix ioctl that either truncates or does extending preallocaiton */
> -void
> -do_allocsp(unsigned new_size)
> -{
> -	struct xfs_flock64	fl;
> -
> -	if (new_size > biggest) {
> -		biggest = new_size;
> -		if (!quiet && testcalls > simulatedopcount)
> -			prt("allocsping to largest ever: 0x%x\n", new_size);
> -	}
> -
> -	log4(OP_ALLOCSP, 0, new_size, FL_NONE);
> -
> -	if (new_size > file_size)
> -		memset(good_buf + file_size, '\0', new_size - file_size);
> -	file_size = new_size;
> -
> -	if (testcalls <= simulatedopcount)
> -		return;
> -
> -	if ((progressinterval && testcalls % progressinterval == 0) ||
> -	    (debug && (monitorstart == -1 || monitorend == -1 ||
> -		      new_size <= monitorend)))
> -		prt("%lld allocsp\tat 0x%x\n", testcalls, new_size);
> -
> -	fl.l_whence = SEEK_SET;
> -	fl.l_start = new_size;
> -	fl.l_len = 0;
> -
> -	if (ioctl(fd, XFS_IOC_ALLOCSP, &fl) == -1) {
> -	        prt("allocsp: 0x%x\n", new_size);
> -		prterr("do_allocsp: allocsp");
> -		report_failure(161);
> -	}
> -}
> -#else
> -void
> -do_allocsp(unsigned new_isize)
> -{
> -	return;
> -}
> -#endif
> -
>  #ifdef HAVE_LINUX_FALLOC_H
>  /* fallocate is basically a no-op unless extending, then a lot like a truncate */
>  void
> @@ -2097,8 +2040,6 @@ test(void)
>  		if (fallocate_calls && size && keep_size_calls)
>  			keep_size = random() % 2;
>  		break;
> -	case OP_ALLOCSP:
> -		break;
>  	case OP_ZERO_RANGE:
>  		if (zero_range_calls && size && keep_size_calls)
>  			keep_size = random() % 2;
> @@ -2125,12 +2066,6 @@ have_op:
>  		if (!mapped_writes)
>  			op = OP_WRITE;
>  		break;
> -	case OP_ALLOCSP:
> -		if (!allocsp_calls) {
> -			log4(OP_FALLOCATE, 0, size, FL_SKIPPED);
> -			goto out;
> -		}
> -		break;
>  	case OP_FALLOCATE:
>  		if (!fallocate_calls) {
>  			log4(OP_FALLOCATE, offset, size, FL_SKIPPED);
> @@ -2206,10 +2141,6 @@ have_op:
>  		dotruncate(size);
>  		break;
>  
> -	case OP_ALLOCSP:
> -		do_allocsp(size);
> -		break;
> -
>  	case OP_FALLOCATE:
>  		TRIM_OFF_LEN(offset, size, maxfilelen);
>  		do_preallocate(offset, size, keep_size);
> @@ -2339,8 +2270,8 @@ usage(void)
>  "	-U: Use the IO_URING system calls, -U excludes -A\n"
>   #endif
>  "	-D startingop: debug output starting at specified operation\n"
> -#if defined(HAVE_LINUX_FALLOC_H) || defined(XFS_IOC_ALLOCSP)
> -"	-F: Do not use fallocate (preallocation) or XFS_IOC_ALLOCSP calls\n"
> +#ifdef HAVE_LINUX_FALLOC_H
> +"	-F: Do not use fallocate (preallocation) calls\n"
>  #endif
>  #ifdef FALLOC_FL_PUNCH_HOLE
>  "	-H: Do not use punch hole calls\n"
> @@ -2656,41 +2587,6 @@ __test_fallocate(int mode, const char *mode_str)
>  #endif
>  }
>  
> -int
> -test_allocsp()
> -{
> -#ifdef XFS_IOC_ALLOCSP
> -	struct xfs_flock64	fl;
> -	int			ret = 0;
> -
> -	if (lite)
> -		return 0;
> -
> -	fl.l_whence = SEEK_SET;
> -	fl.l_start = 1;
> -	fl.l_len = 0;
> -
> -	ret = ioctl(fd, XFS_IOC_ALLOCSP, &fl);
> -	if (ret == -1 && (errno == ENOTTY || errno == EOPNOTSUPP)) {
> -		if (!quiet)
> -			fprintf(stderr,
> -				"main: filesystem does not support "
> -				"XFS_IOC_ALLOCSP, disabling!\n");
> -		return 0;
> -	}
> -
> -	ret = ftruncate(fd, file_size);
> -	if (ret) {
> -		warn("main: ftruncate");
> -		exit(132);
> -	}
> -
> -	return 1;
> -#else
> -	return 0;
> -#endif
> -}
> -
>  static struct option longopts[] = {
>  	{"replay-ops", required_argument, 0, 256},
>  	{"record-ops", optional_argument, 0, 255},
> @@ -2835,7 +2731,6 @@ main(int argc, char **argv)
>  			break;
>  		case 'F':
>  			fallocate_calls = 0;
> -			allocsp_calls = 0;
>  			break;
>  		case 'K':
>  			keep_size_calls = 0;
> @@ -3077,8 +2972,6 @@ main(int argc, char **argv)
>  
>  	if (fallocate_calls)
>  		fallocate_calls = test_fallocate(0);
> -	if (allocsp_calls)
> -		allocsp_calls = test_allocsp(0);
>  	if (keep_size_calls)
>  		keep_size_calls = test_fallocate(FALLOC_FL_KEEP_SIZE);
>  	if (punch_hole_calls)
> -- 
> 2.31.1
> 
