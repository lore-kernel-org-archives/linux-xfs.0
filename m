Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0514D37C4;
	Mon, 28 Sep 2026 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790603741; cv=none; b=XPITpZ+ge7mIQqzzocaE+VZore9tOk35gZhtZ8UeWsOYS2xclJW2W4fdC+Y02YFe1nJG6kksMXiGeMU7cwxEmdwSyPgSE8uxHc5vmoioYxp/w7NJjXIrylWTY4VY7yu1GeEaKCrEQvmuqwmVDHUP4TGMzLLYfW+RIKw4YvP83WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790603741; c=relaxed/simple;
	bh=fwFJzBURfmcrsNGHaZD6gRZTu4XO0mvAEW+his6TZso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0tan+uq/wzwqK1Kp9pFoVDxUoWaDkKchPkFXSRSpgZUFoYQveZKtixuzyB3B7G9uZx2eC3s++4Wk4wQgj7IVY188hTi/Q8LfQzP0AeAE9Es4DVzhDM5U+jgYaNgSLfBh+6TsLjzXrtlEgq7ir46dHe9y+cg+b8HvnnMnAKNdWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S030UGys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S030UGys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97A91F000FF;
	Mon, 28 Sep 2026 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790603739;
	bh=9kN1HsHr/CzvxpqA9DLj1E6OGajT1EkYC1y2wlqle/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S030UGysVsWcJlHMM3SqhKi69SsekzpHbPSWQEPxrkaQGawFJDmHIzinqbRbPAyQp
	 8H+2kZebXsTssj7OauMJDnGN0xFOAmiD4IHJwr08gFNTOp6gPKITBMe6xkoH5z0dEW
	 Tk3s8USY3h3InHxpjzxVNWTnOuuoRoCeppiKJ4JCEuVGsG2HN0cSzSNG0hYsbCPh/q
	 YKrCdbUEtsFaKRizBeBob42NXbwRTdRJZNKnXyXyxDk/D6U38RRn/O0WGnrcpRzXh7
	 XGCP/c4LPTWM/Gf8yelk02P4yfjfVlZZdc5gmLedSp3lG7K/ZESc29gvnRQfs2BV7Y
	 aTEgDlsZktRFA==
Date: Mon, 28 Sep 2026 21:55:34 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/{349,350,351}: fix scsi_debug parameter quoting
 issues
Message-ID: <arpxqgQRdO-PGhXe@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
References: <20260924060315.GF6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924060315.GF6253@frogsfrogsfrogs>

On Wed, Sep 23, 2026 at 11:03:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit a90ba59dca447d reworked the argument handling code inside
> _get_scsi_debug_dev to put all the remaining arguments (after we extract
> the first four arguments) inside an array that gets passed to modprobe:
> 
> 	opts+=("$@")
> 
> This code takes every command line argument and copies them into the
> array verbatim.  Contrast this to what it did before (excerpted):
> 
> 	opts="...dev_size_mb=$size $@"
> 	echo "scsi_debug options $opts" >> $seqres.full
> 	modprobe scsi_debug $opts
> 
> The old code put all the arguments into a string, then passed the string
> unquoted to modprobe, which means that any spaces in the parameters
> given to _get_scsi_debug_dev become argument separators in the modprobe
> call.  Put more simply, passing "foo=1 bar=1" to _get_scsi_debug_dev
> results in "foo=1" "bar=1" being passed to modprobe.
> 
> Now we no longer do that, which causes these three tests to fail with:
> 
> 	scsi_debug: `1 lbpws10=1' invalid for parameter `lbpws'
> 
> because we're effectively passing lbpws="1 lbpws10=1" to scsi_debug.
> Fix this by removing the quoting from the three tests.
> 
> Cc: <fstests@vger.kernel.org> # v2026.09.22
> Fixes: a90ba59dca447d ("common/scsi_debug: don't slow down I/O")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Thanks for finding and fixing it.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/generic/349 |    2 +-
>  tests/generic/350 |    2 +-
>  tests/generic/351 |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/generic/349 b/tests/generic/349
> index 72fbda412ea41c..0d019d4ab46170 100755
> --- a/tests/generic/349
> +++ b/tests/generic/349
> @@ -20,7 +20,7 @@ _require_scsi_debug
>  _require_xfs_io_command "fzero"
>  
>  echo "Create and format"
> -dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=1 lbpws10=1")
> +dev=$(_get_scsi_debug_dev 512 512 0 4 lbpws=1 lbpws10=1)
>  _pwrite_byte 0x62 0 4m $dev >> $seqres.full
>  
>  echo "Zero range"
> diff --git a/tests/generic/350 b/tests/generic/350
> index 6079a8d5032303..7dcdda03a613ff 100755
> --- a/tests/generic/350
> +++ b/tests/generic/350
> @@ -20,7 +20,7 @@ _require_scsi_debug
>  _require_xfs_io_command "fpunch"
>  
>  echo "Create and format"
> -dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=1 lbpws10=1")
> +dev=$(_get_scsi_debug_dev 512 512 0 4 lbpws=1 lbpws10=1)
>  _pwrite_byte 0x62 0 4m $dev >> $seqres.full
>  
>  echo "Zero punch"
> diff --git a/tests/generic/351 b/tests/generic/351
> index e73b70e4d7957e..374ea1afe46d76 100755
> --- a/tests/generic/351
> +++ b/tests/generic/351
> @@ -27,7 +27,7 @@ _require_xfs_io_command "fzero"
>  _require_xfs_io_command "fpunch"
>  
>  echo "Create and format"
> -dev=$(_get_scsi_debug_dev 4096 4096 0 4 "lbpws=1 lbpws10=1")
> +dev=$(_get_scsi_debug_dev 4096 4096 0 4 lbpws=1 lbpws10=1)
>  _pwrite_byte 0x62 0 4m $dev >> $seqres.full
>  $XFS_IO_PROG -c "fsync" $dev
>  
> @@ -70,7 +70,7 @@ echo "Destroy device"
>  _put_scsi_debug_dev
>  
>  echo "Create w/o unmap or writesame and format"
> -dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=0 lbpws10=0 lbpu=0 write_same_length=0 unmap_max_blocks=0")
> +dev=$(_get_scsi_debug_dev 512 512 0 4 lbpws=0 lbpws10=0 lbpu=0 write_same_length=0 unmap_max_blocks=0)
>  _pwrite_byte 0x62 0 4m $dev >> $seqres.full
>  $XFS_IO_PROG -c "fsync" $dev
>  
