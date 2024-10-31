Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652991CEADC;
	Thu, 31 Oct 2024 22:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412502; cv=none; b=BYNlsCQOzoKmxBEh+lmvU33DYA+fcDrHF++PIlIGPBb4jm7fzz9oLg95im55bGQMqVrWtRYiVw8slRA+VVcaEQExGpIrVrFBzTRv6gaUsiDJszPDTBK/xUU4maFt+CIGqeZs+m0BThN1YIJgOk1SjEZuzBiMMKV6Lo4mTk4LgvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412502; c=relaxed/simple;
	bh=u4mu4zmcQCC6mL/SWEM5nSIM8G1AP3l65jkKZ+P1OGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zm4f3PzDvAXJrGJaZmmrzjNhOPtoCYpd6GAWOUKGzmK56gceOZbuU2QZ+jHO+5Ix20lbpfmtiGjLjjkSsrHT3F05URuVV2v82rq3aaS1d/trHILfxxgkglcub5cKDrG6Q4yBEsAyn9/Q+j9KgJP8ojRa2Gq/Yo1B8R3UnG38VMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZuSajgvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZuSajgvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1860C4CEC3;
	Thu, 31 Oct 2024 22:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730412501;
	bh=u4mu4zmcQCC6mL/SWEM5nSIM8G1AP3l65jkKZ+P1OGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZuSajgviPE7kJ512Ymza+oIqrCYKXASSBJ4iBdAus+er/X/V6183tTuYOGUM6YsDU
	 BoWnTgI9+vBc9nDDqC8/2wpMbbHzy3mEA3czDrvNyaSclGn0ogQ7SjffAy2PNj0qAv
	 Vf2xjFHbznY2GOQAZTet8M3/gR2bDJmn2tt1/5NPVfZR74gLWmxttW72AEZ4zdfB6Y
	 W6JEqQwTBCsuFcD7Qdm9zZNRkzzybJqVaPvNZ3QWVPVWDrarorzGkY7ULZcFPGCgtJ
	 IPt55p4mvaJoPvUv2pPkX1DvVZb37pRbbLdDLM/s+rNPdXZJBRROA2cgFOVm/XAAZE
	 O4zs73jVBrH1A==
Date: Thu, 31 Oct 2024 15:08:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <20241031220821.GA2386201@frogsfrogsfrogs>
References: <20241031193552.1171855-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031193552.1171855-1-zlang@kernel.org>

On Fri, Nov 01, 2024 at 03:35:52AM +0800, Zorro Lang wrote:
> The xfs/157 doesn't need to do a "sized" mkfs, the image file is
> 500MiB, don't need to do _scratch_mkfs_sized with a 500MiB fssize
> argument, a general _scratch_mkfs is good enough.
> 
> Besides that, if we do:
> 
>   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> 
> the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs fails
> with incompatible $MKFS_OPTIONS options, likes this:
> 
>   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
>   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> 
> But if we do:
> 
>   _scratch_mkfs -L oldlabel
> 
> the _scratch_mkfs trys to keep the "-L oldlabel", when mkfs fails
> with incompatible $MKFS_OPTIONS options, likes this:
> 
>   ** mkfs failed with extra mkfs options added to "-m rmapbt=1" by test 157 **
>   ** attempting to mkfs using only test 157 options: -L oldlabel **
> 
> that's actually what we need.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> This test started to fail since 2f7e1b8a6f09 ("xfs/157,xfs/547,xfs/548: switch to
> using _scratch_mkfs_sized") was merged.
> 
>   FSTYP         -- xfs (non-debug)
>   PLATFORM      -- Linux/x86_64
>   MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/sda3
>   MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch
> 
>   xfs/157 7s ... - output mismatch (see /root/git/xfstests/results//xfs/157.out.bad)
>       --- tests/xfs/157.out       2024-11-01 01:05:03.664543576 +0800
>       +++ /root/git/xfstests/results//xfs/157.out.bad     2024-11-01 02:56:47.994007900 +0800
>       @@ -6,10 +6,10 @@
>        label = "oldlabel"
>        label = "newlabel"
>        S3: Check that setting with rtdev works
>       -label = "oldlabel"
>       +label = ""
>        label = "newlabel"
>        S4: Check that setting with rtdev + logdev works
>       ...
>       (Run 'diff -u /root/git/xfstests/tests/xfs/157.out /root/git/xfstests/results//xfs/157.out.bad'  to see the entire diff)
>   Ran: xfs/157
>   Failures: xfs/157
>   Failed 1 of 1 tests
> 
> Before that change, the _scratch_mkfs can drop "rmapbt=1" option from $MKFS_OPTIONS,
> only keep the "-L label" option. That's why this test never failed before.
> 
> Now it fails on xfs, if MKFS_OPTIONS contains "-m rmapbt=1", the reason as I
> explained above.
> 
> Thanks,
> Zorro
> 
>  tests/xfs/157 | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index 9b5badbae..459c6de7c 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -66,8 +66,7 @@ scenario() {
>  }
>  
>  check_label() {
> -	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> -		>> $seqres.full
> +	_scratch_mkfs -L oldlabel >> $seqres.full 2>&1

Hans Holmberg discovered that this mkfs fails if the SCRATCH_RTDEV is
very large and SCRATCH_DEV is set to the 500M fake_datafile because the
rtbitmap is larger than the datadev.

I wonder if there's a way to pass the -L argument through in the
"attempting to mkfs using only" case?

--D

>  	_scratch_xfs_db -c label
>  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
>  	_scratch_xfs_db -c label
> -- 
> 2.45.2
> 
> 
