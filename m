Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F5C2B9BC;
	Wed, 12 Feb 2025 06:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739340305; cv=none; b=U1o2guHwf5CEiCImXOQMCpN+9lXIDBUCkYRC/gJevQ5Jj4ssR0mRz71u9EMxaHq6mZxGKhKsZasKjeOQX4pttMWu/9i9cufx/sqABQJu/HSoa9z/UWbOUaRREPD4K8R05u2mEL95dAygkztMl1/JLNVHN5k9TqxSJH1JqKDMCwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739340305; c=relaxed/simple;
	bh=EHfnL5vkjFJjCl3XxyPBLpH8esKQgRDpXj5T/1JRjiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uuExYiT92GRqdj/dLcDdhPKbFkYQqUElJ2pRsr6ESdybwTUSZvtXzj3HOJoCN7p2dlJzxNZZHCDXYdRuk012kzu3C4aBPnS5fB+aMCI5rlK3NyzorpHtJ494Bv7fqaZPCCQeCrRzzuFbiPD3eL6NWSyo2C6yTllfHD+z0C31yqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdlmBaJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdlmBaJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C936C4CEDF;
	Wed, 12 Feb 2025 06:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739340305;
	bh=EHfnL5vkjFJjCl3XxyPBLpH8esKQgRDpXj5T/1JRjiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BdlmBaJSbcC8jfcCyQll34Bef6TAMlgwNgoMEB9da7Rb0Y+pjUuHybEeVqQ/pK98O
	 pSZ1z17OkGjctou1AIBQK2IhPeUlY/lYLbJ/lxgDMd6uzO/tfGYDxhvtzLoMBICMpI
	 4JEKppxG4NjTFLAIpwPQZS8ytLVYnhFn5Do+nkMH5W2jSNlrXAwoY0sb4L0eXE3bhi
	 EZhzIEtAdUgqFASd/atWbXXC0sE1XkGf+B3gG//Tu2SMGtFEqtFEerAizxRJwC03uA
	 HJAFEYoUIzrobkmBl4AZFV5OE+TtzAurBXVNjGGl0i0QcocjZMlGva9f4tiJ8b32b7
	 DO4sf6Pwl3SVw==
Date: Tue, 11 Feb 2025 22:05:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/34] fuzzy: kill subprocesses with SIGPIPE, not SIGINT
Message-ID: <20250212060504.GI21808@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094538.1758477.11313063681546904819.stgit@frogsfrogsfrogs>
 <Z6wnfuqEr6TEkbi7@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6wnfuqEr6TEkbi7@dread.disaster.area>

On Wed, Feb 12, 2025 at 03:45:50PM +1100, Dave Chinner wrote:
> On Tue, Feb 11, 2025 at 07:33:48PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The next patch in this series fixes various issues with the recently
> > added fstests process isolation scheme by running each new process in a
> > separate process group session.  Unfortunately, the processes in the
> > session are created with SIGINT ignored by default because they are not
> > attached to the controlling terminal.  Therefore, switch the kill signal
> > to SIGPIPE because that is usually fatal and not masked by default.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/fuzzy |   13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> I thought I reviewed this, must have missed it.
> 
> > diff --git a/common/fuzzy b/common/fuzzy
> > index 0a2d91542b561e..e9df956e721949 100644
> > --- a/common/fuzzy
> > +++ b/common/fuzzy
> > @@ -891,7 +891,7 @@ __stress_xfs_scrub_loop() {
> >  	local runningfile="$2"
> >  	local scrub_startat="$3"
> >  	shift; shift; shift
> > -	local sigint_ret="$(( $(kill -l SIGINT) + 128 ))"
> > +	local signal_ret="$(( $(kill -l SIGPIPE) + 128 ))"
> >  	local scrublog="$tmp.scrub"
> >  
> >  	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
> > @@ -902,7 +902,7 @@ __stress_xfs_scrub_loop() {
> >  		_scratch_scrub "$@" &> $scrublog
> >  		res=$?
> >  		if [ "$res" -eq "$sigint_ret" ]; then
> 
> s/sigint_ret/signal_ret/

Heh, whoops.  Will fix.

> Otherwise looks fine, so with that fixed:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
