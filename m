Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AA526E165;
	Fri, 24 Oct 2025 22:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761344209; cv=none; b=ZZJ1kA1DAZHlQk/LD0glMHBdKJHSas9pSZcDQi0McrYI0mCY5rvQUE1tcfkfoBVFmem5oLHCcKwSHe15bTuhGJT0PoTgzBfukuj6uFPJBZQgdtBmHbmfJ+1VAOeYTrpSx6Ggspvah4jCX/6BDoLbA/PKBnfAk/TdF77scHe3rt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761344209; c=relaxed/simple;
	bh=hO2iReHrVXKESwEc4bqJcL1IvEvQ10jm4vtllKXPEUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYPWp3wV8PQwUyXWnz8y7CJ9k3xEmgeS3N9G5fPiz8NmNCoHo2ieCoDvASgND7k9ix656YdZ/eHkyicruotDggfC3y/lOW0x3gmsyBnBnj6KlipF1v1BUXESuvzvKJdnwOffrlMhDrfOu+aa34VhJzmm+q7VmiJ4+4ci3c4m9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8nBUOEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8nBUOEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D2DC4CEF1;
	Fri, 24 Oct 2025 22:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761344208;
	bh=hO2iReHrVXKESwEc4bqJcL1IvEvQ10jm4vtllKXPEUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I8nBUOElcg/OwxaID+wyf37DLPXMMzoOcULDLM/eWsbURMoWHCCT4SaudfkUmKhsg
	 FD+aUuqOjUtUfHwcRi0iSjjTQCkHEoEq1e8O9rUpALOf+3HcJa08GgdGcXPG4WOB/O
	 i9lC6JQ0buyPXFFUrP+cUow0CT3JG1UByzzs69WYXFENCyo3oYu6sKHfZLFRmvjerc
	 eTuf94rcAk6962H4Vwj/JL6zlJORNqXM0+/tedcZYQu1OImPDV1InDVUMA6uIZF0tH
	 MclsR9Hc8bqwv30rfovh4vcuSARTTwvvtxs35d5kGFXOCUwdomXlcxy2qxX1fVIYPa
	 433p+iI+l4XYA==
Date: Fri, 24 Oct 2025 15:16:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] common: fix _require_xfs_io_command pwrite -A for
 various blocksizes
Message-ID: <20251024221647.GW6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618045.2391029.13403718073912452422.stgit@frogsfrogsfrogs>
 <4e8a9b373fdfeecd3e0de2a91ecdd75fbb94e18e.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e8a9b373fdfeecd3e0de2a91ecdd75fbb94e18e.camel@gmail.com>

On Fri, Oct 24, 2025 at 02:48:00PM +0530, Nirjhar Roy (IBM) wrote:
> On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
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
> > index 1b78cd0c358bb9..dcae5bc33b19ce 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3030,16 +3030,24 @@ _require_xfs_io_command()
> >  	"pwrite")
> >  		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
> >  		local pwrite_opts=" "
> > +		local write_size="4k"
> >  		if [ "$param" == "-N" ]; then
> >  			opts+=" -d"
> > -			pwrite_opts+="-V 1 -b 4k"
> > +			pwrite_opts+="-V 1 -b $write_size"
> Nit: We can still keep this to 4k (or any random size and not necessarily a size = fsblocksize),
> right?

Well, yes, the default will still be 4k on an old kernel that doesn't
support STATX_WRITE_ATOMIC.  For kernels that do support that flag,
write_size will now be whatever the filesystem claims is the minimum
write unit.

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
> > +			fi
> > +			pwrite_opts+="-V 1 -b $write_size"
> >  		fi
> >  		testio=`$XFS_IO_PROG -f $opts -c \
> > -		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> > +		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`
> This looks good to me:
> 
> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Thanks!

--D

> >  		param_checked="$pwrite_opts $param"
> >  		;;
> >  	"scrub"|"repair")
> > 
> 
> 
