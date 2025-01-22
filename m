Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B5D186A;
	Wed, 22 Jan 2025 03:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737516654; cv=none; b=WOhtTqHUDNBIFVRDDChJCPrSTn6d95gBqC9l9LyIJFn4VG+KznM/Gj4CCMlbslvSxLmiZkq2284bKKfM3Z2atbltPMT379OYBjWq4Ak+88efEdx19M3bVgieyJufHPeKklvLEeOW7i3WwijAuGs/uta+r3eWclwklChR6Pr6SkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737516654; c=relaxed/simple;
	bh=5I5CzDuDudong4Yc8kpLLWEBA0aB6rb0VNYBrct+hL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joXx3rutmKP7GkZzOrRRSkNTlMpLO4rL8yWbTH/zk6aj9N6eWGzTnxKo3j3MQUz/y3dGqCn/w/wRQF++Uj1eg/Ay17wip48i/QAyI2Y32FN6sKA5v1c3hs3NeV7xuiTWyrr/UmD2G53jmhi+MFmm9zlR6R+f/7XkLj3GrV9YzzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVT25+1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVT25+1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CA6C4CED6;
	Wed, 22 Jan 2025 03:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737516653;
	bh=5I5CzDuDudong4Yc8kpLLWEBA0aB6rb0VNYBrct+hL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iVT25+1AtaFDco4Az74Iuu/mJBVu8rZ8gXulABv6KtA8D8TQo0FSATdlMx3n7HqnY
	 RnfSJmSlHtOtDMx8TUIw6ZLtTzUHJMgcC2wcqbjaBVyBQYihwtoIO75I91GrVRCAHo
	 Pu3mRJj2X0DvwuUnQHdlrEzGbSBFEMpZcWsCN/VUMIgnuvxvuMxcekdtoisM4zkC/g
	 flNo4UU8OFiUHqlhRRnDhHdsCMVoXkvJfVvQav5nxaHp+tIuET21moaAfMvgtGfaOb
	 WKzrZBhVkoBQ7S1PDA+1eHsLWtisgmWCDrceIPCUkcc1JewUQU843uFdCKG+PyytD5
	 7oN8cXMi3lRpg==
Date: Tue, 21 Jan 2025 19:30:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/23] mkfs: don't hardcode log size
Message-ID: <20250122033053.GP1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974228.1927324.17714311358227511791.stgit@frogsfrogsfrogs>
 <Z48bYVRvWt-wPmUz@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48bYVRvWt-wPmUz@dread.disaster.area>

On Tue, Jan 21, 2025 at 02:58:25PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2025 at 03:27:46PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Commit 000813899afb46 hardcoded a log size of 256MB into xfs/501,
> > xfs/502, and generic/530.  This seems to be an attempt to reduce test
> > run times by increasing the log size so that more background threads can
> > run in parallel.  Unfortunately, this breaks a couple of my test
> > configurations:
> > 
> >  - External logs smaller than 256MB
> >  - Internal logs where the AG size is less than 256MB
> ....
> 
> > diff --git a/common/rc b/common/rc
> > index 9e34c301b0deb0..885669beeb5e26 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -689,6 +689,33 @@ _test_cycle_mount()
> >      _test_mount
> >  }
> >  
> > +# Are there mkfs options to try to improve concurrency?
> > +_scratch_mkfs_concurrency_options()
> > +{
> > +	local nr_cpus="$(( $1 * LOAD_FACTOR ))"
> 
> caller does not need to pass a number of CPUs. This function can
> simply do:
> 
> 	local nr_cpus=$(getconf _NPROCESSORS_CONF)
> 
> And that will set concurrency to be "optimal" for the number of CPUs
> in the machine the test is going to run on. That way tests don't
> need to hard code some number that is going to be too large for
> small systems and to small for large systems...

Sounds good to me.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
