Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8B814D43D
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 16:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730133931; cv=none; b=bZjWaTMC5zw11VCuIN6mwKo0SFXVcfj7g+wq8G0/woorcrTrADO1w0Io+dFU/vex+xR/Qokdi09DeL8Z8GWyG9MuN3qt5onfivVGjbwpVOE+SoVzj/mtStoKVBmceV1Xiv8R5V+AgnhGynyO8hJUmpl7h6IBAch7Y7ce3Fsm73g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730133931; c=relaxed/simple;
	bh=7yDJ0kNjFPeQs/sblfT5F0mgM8CnWJpcl56CrpMW558=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FuqPYy9ynGDH0QFo1KCod6hcEyWQKEN1Rvejpc9eziUtMp14FNk/uwVXuG5fR64yuM7SsHhnUfMcwdc6Q6NctweJjECiphGhnEZXQvm7UP4gmcuGLOBNOaq/gNvW5OmNTdzfDeu9BgiDPaaV+BKAqBqY3upbrLl/pGcXq+eLCKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufO+B0+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufO+B0+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E07CC4CEC3;
	Mon, 28 Oct 2024 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730133930;
	bh=7yDJ0kNjFPeQs/sblfT5F0mgM8CnWJpcl56CrpMW558=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ufO+B0+P0UOyQmVnhBaR0bX/YytE9W3kqS41HTWWSLB61brZhWdQZvEgzxyZec4pO
	 EzTwvmVhICI8ipBOhaDBeLJKjH4TfG+Gj+LcqIssWNNWOeuxfJQLe6J6+5gXpnMSna
	 xnrN6C4M4vQbCKPMBHpZycjiwEpr2CGnKTJZ8+bMRUt0pmGWhXY5UYRu9jKYUTcdz0
	 b2VYecQlUjpu0W3HcNaL7VJJ+nbDHYgFYC7tJnxH9qq6330lyv24OCyzGwvcVjR801
	 3kRsIe8ssilot88+oJL3olcVFaNke4gFjpiaeb9JBvNJ05QtJo076Mp9eFV8iC+aY3
	 iIb6/uvrm3YDg==
Date: Mon, 28 Oct 2024 09:45:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_scrub_all: wait for services to start activating
Message-ID: <20241028164529.GQ2386201@frogsfrogsfrogs>
References: <172983774811.3041899.4175728441279480358.stgit@frogsfrogsfrogs>
 <172983774826.3041899.15350842942789677656.stgit@frogsfrogsfrogs>
 <Zx9O53A6mhr2sF4b@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zx9O53A6mhr2sF4b@infradead.org>

On Mon, Oct 28, 2024 at 01:44:23AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 24, 2024 at 11:38:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It seems that the function call to start a systemd unit completes
> > asynchronously from any change in that unit's active state.  On a
> > lightly loaded system, a Start() call followed by an ActiveState()
> > call actually sees the change in state from inactive to activating.
> > 
> > Unfortunately, on a heavily loaded system, the state change may take a
> > few seconds.  If this is the case, the wait() call can see that the unit
> > state is "inactive", decide that the service already finished, and exit
> > early, when in reality it hasn't even gotten to 'activating'.
> > 
> > Fix this by adding a second method that watches either for the inactive
> > -> activating state transition or for the last exit from inactivation
> > timestamp to change before waiting for the unit to reach inactive state.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> 
> What is this supposed to mean? 

It means that if anyone is supporting xfsprogs 6.10, this patch applies
to it.

> The patch itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
