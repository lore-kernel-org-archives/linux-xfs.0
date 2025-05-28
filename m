Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3021FF3B;
	Wed, 28 May 2025 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748471878; cv=none; b=YdHXo/lfQzBWIqHgu18icER928U5hB3OjveXSaiSvWcl21F7954eaJGRHV8Ga6HPTB40LaGbzY2tMumT+/YVqj53ffg769sBF3GyZCApj1b8PFVzhZMfJUYXF/PNU8B22q2WoySA7TUkmMYD2pRlV5iXTlifoueHu9DjNl5oCDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748471878; c=relaxed/simple;
	bh=tlWGNGMACjN71Mm/Gf7tdbmvAOAcAUYFWn9DtpbT6gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=en/QAawMT7q2IUZHcoZpsJ3RT0kc7RCBTI3rxjmBxHYJ14i+UWMbphaDan7xkUaRLxbYie/9mRuyBH8GFislLUkYQf9rldZuT19aZFYDsvuNZ+9x20bVqFfTeMa/LNpactiM515o2MD9AhCsUy5SYxUoxW4Ef7ywL2SYcJIy0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsmYQoTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsmYQoTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76D9C4CEE3;
	Wed, 28 May 2025 22:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748471877;
	bh=tlWGNGMACjN71Mm/Gf7tdbmvAOAcAUYFWn9DtpbT6gA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LsmYQoTYJrE8Rnxa55J7Yl+FxcuVBO2djRnlhmHdSNT+H8spryHaSfNqZCn3bIYsj
	 sfSRt7l9Ss52zwCHgrT9rUNCb1/zEXSaVUi5Io3cQyHbekPlRExqINYiwYRmdADiKS
	 /+Q/orEclSmHoHfR5NJcroSNLB07wZ0n1uerkiir0RlxiUZdarXKo+qSa4Qlf8kRn4
	 4qiAyGccUTOdIpwj3wzDYsrfU1PedeyoZSASPZfzg7GBsa36DF0Gq4TDhX4JkqG9Cg
	 UiehUGQQ4Kl3g5tep8FjmXnskWqvrBV0YxoJnc7taz7qCRUqra8dwXRFRRV6WeP0nL
	 VfHta9664WfVw==
Date: Wed, 28 May 2025 15:37:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs/432: fix metadump loop device blocksize problems
Message-ID: <20250528223757.GD8303@frogsfrogsfrogs>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719464.1398726.8513251082673880762.stgit@frogsfrogsfrogs>
 <aC54_ucTlwh189MG@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC54_ucTlwh189MG@dread.disaster.area>

On Thu, May 22, 2025 at 11:08:14AM +1000, Dave Chinner wrote:
> On Wed, May 21, 2025 at 03:41:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure the lba size of the loop devices created for the metadump
> > tests actually match that of the real SCRATCH_ devices or else the tests
> > will fail.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/metadump |   12 ++++++++++--
> >  common/rc       |    7 +++++++
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/common/metadump b/common/metadump
> > index 61ba3cbb91647c..4ae03c605563fc 100644
> > --- a/common/metadump
> > +++ b/common/metadump
> > @@ -76,6 +76,7 @@ _xfs_verify_metadump_v1()
> >  
> >  	# Create loopdev for data device so we can mount the fs
> >  	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
> > +	_force_loop_device_blocksize $METADUMP_DATA_LOOP_DEV $SCRATCH_DEV
> 
> That doesn't look right. You're passing the scratch device as a
> block size parameter. 
> 
> >  
> >  	# Mount fs, run an extra test, fsck, and unmount
> >  	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV _scratch_mount
> > @@ -123,12 +124,19 @@ _xfs_verify_metadump_v2()
> >  
> >  	# Create loopdev for data device so we can mount the fs
> >  	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
> > +	_force_loop_device_blocksize $METADUMP_DATA_LOOP_DEV $SCRATCH_DEV
> >  
> >  	# Create loopdev for log device if we recovered anything
> > -	test -s "$log_img" && METADUMP_LOG_LOOP_DEV=$(_create_loop_device $log_img)
> > +	if [ -s "$log_img" ]; then
> > +		METADUMP_LOG_LOOP_DEV=$(_create_loop_device $log_img)
> > +		_force_loop_device_blocksize $METADUMP_LOG_LOOP_DEV $SCRATCH_LOGDEV
> > +	fi
> >  
> >  	# Create loopdev for rt device if we recovered anything
> > -	test -s "$rt_img" && METADUMP_RT_LOOP_DEV=$(_create_loop_device $rt_img)
> > +	if [ -s "$rt_img" ]; then
> > +		METADUMP_RT_LOOP_DEV=$(_create_loop_device $rt_img)
> > +		_force_loop_device_blocksize $METADUMP_RT_LOOP_DEV $SCRATCH_RTDEV
> > +	fi
> >  
> >  	# Mount fs, run an extra test, fsck, and unmount
> >  	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV SCRATCH_RTDEV=$METADUMP_RT_LOOP_DEV _scratch_mount
> > diff --git a/common/rc b/common/rc
> > index 4e3917a298e072..9e27f7a4afba44 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4527,6 +4527,8 @@ _create_loop_device()
> >  }
> >  
> >  # Configure the loop device however needed to support the given block size.
> > +# The first argument is the loop device; the second is either an integer block
> > +# size, or a different block device whose blocksize we want to match.
> >  _force_loop_device_blocksize()
> >  {
> >  	local loopdev="$1"
> > @@ -4539,6 +4541,11 @@ _force_loop_device_blocksize()
> >  		return 1
> >  	fi
> >  
> > +	# second argument is really a bdev; copy its lba size
> > +	if [ -b "$blksize" ]; then
> > +		blksize="$(blockdev --getss "${blksize}")"
> > +	fi
> 
> Oh, you're overloading the second parameter with different types -
> that's pretty nasty.  It would be much cleaner to write a wrapper
> function that extracts the block size from the device before calling
> _force_loop_device_blocksize()....

Or my preferred solution: a special purpose wrapper with a different
name that takes only a bdev path and has a comment that says it requires
a bdev path.

--D

> 
> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
