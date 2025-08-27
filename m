Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9203F2727EA;
	Wed, 27 Aug 2025 18:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756317888; cv=none; b=MIaVI3vLTyP40ECAgMcZkit23i7CcFGJ3X7QgqVmCWaVgzb/P1r1MnhRgnAKMzPhDIen8Nz8ZJWsOejdXwr0WSMaxWQWNr0a1bhOvw7HZJMVHV6Z/vWICPMws8xAt/JynB0S5pMosko1BNgw71FKIAenZ8oM+k1v4lP54oAFWOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756317888; c=relaxed/simple;
	bh=6WlgShXTPlpTvd/GztbCg8VM5Dsy7drHlTuT71fnv6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phPTSgiX6R7bsjP5o+4EyjKBXis0xDb7ce96lxXumDEKc1M+YINzyNvwoPTeE5f9Es19D9iPiLwD3XmH7T/bxFRGaLqCfQhOI7pTyPnCBZvYnAfMrUczrWCGARBgbXa1DYFpDsBSkgHe0R8zhquaRRhj0YiG7MEoGXjev7D4+lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fd5Ie8SX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fd5Ie8SX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13651C4CEEB;
	Wed, 27 Aug 2025 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756317888;
	bh=6WlgShXTPlpTvd/GztbCg8VM5Dsy7drHlTuT71fnv6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fd5Ie8SX+ZykJ7iiT8jV+yWZJgioFZzGrUyZpE1Ecr0oLEBWIuv8rR/voHypzCpka
	 pxMT91zP/3U9Dc5XvBBmzgFFjKF70Nzb4+vjzW4Oe+Y2fuQvD29c//r+MICUs8zqf4
	 BFYEk+g5LHBsjG4Oz0HxN4a4cWelbDhatFHWHCdEbpKX8yydBcRWiwmqriSYzlkaO5
	 JIwD6TpMqtpdJmCM9IOifcBiFqg9Ljh8ihyz01ak003UhXqfjPNtLdPN7Y/CHHTP76
	 izKsRSG/WVummBw+XMSSp6t70Y0C4yUaWMPQ0MmcQxlKtdWoJw5Sd9RYCLSGzZw/x/
	 pIRQKktwgy7nQ==
Date: Wed, 27 Aug 2025 11:04:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] common: fix _require_xfs_io_command pwrite -A for
 various blocksizes
Message-ID: <20250827180447.GA8092@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381958029.3020742.354788781592227856.stgit@frogsfrogsfrogs>
 <20250801185315.2d2mfehoqybtiizb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801185315.2d2mfehoqybtiizb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Aug 02, 2025 at 02:53:15AM +0800, Zorro Lang wrote:
> On Tue, Jul 29, 2025 at 01:10:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In this predicate, we should test an atomic write of the minimum
> > supported size, not just 4k.  This fixes a problem where none of the
> > atomic write tests actually run on a 32k-fsblock xfs because you can't
> > do a sub-fsblock atomic write.
> > 
> > Cc: <fstests@vger.kernel.org> # v2025.04.13
> > Fixes: d90ee3b6496346 ("generic: add a test for atomic writes")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/rc |   14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 96578d152dafb9..177e7748f4bb89 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3027,16 +3027,24 @@ _require_xfs_io_command()
> >  	"pwrite")
> >  		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
> >  		local pwrite_opts=" "
> > +		local write_size="4k"
> >  		if [ "$param" == "-N" ]; then
> >  			opts+=" -d"
> > -			pwrite_opts+="-V 1 -b 4k"
> > +			pwrite_opts+="-V 1 -b $write_size"
> >  		fi
> >  		if [ "$param" == "-A" ]; then
> >  			opts+=" -d"
> > -			pwrite_opts+="-V 1 -b 4k"
> > +			# try to write the minimum supported atomic write size
> > +			write_size="$($XFS_IO_PROG -f -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile 2>/dev/null | \
> > +				grep atomic_write_unit_min | \
> > +				grep -o '[0-9]\+')"
> > +			if [ -z "$write_size" ] || [ "$write_size" = "0" ]; then
> > +				write_size="0 --not-supported"
>                                               ^^^^^^^^^^^^^^^
> 
> What is this "--not-supported" for? If write_size="0 --not-supported", will we get...
> 
> 
> > +			fi
> > +			pwrite_opts+="-V 1 -b $write_size"
> >  		fi
> >  		testio=`$XFS_IO_PROG -f $opts -c \
> > -		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> > +		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`
> 
> "pwrite -V 1 -b  0 --not-supported 0 0 --not-supported" at here?

Yes, this is correct.  "--not-supported" is not a valid flag to the
pwrite subcommand.  I'm injecting it here intentionally when we don't
detect any atomic write capability so that the _require checks will
behave as if xfs_io doesn't support the -A flag, and _notrun the test.

--D

> Thanks,
> Zorro
> 
> >  		param_checked="$pwrite_opts $param"
> >  		;;
> >  	"scrub"|"repair")
> > 
> 
> 
