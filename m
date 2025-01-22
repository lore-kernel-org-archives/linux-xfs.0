Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827DB18FDAB
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 19:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737574478; cv=none; b=ZvOVoIaT7gbVXteo953YbPEW+MuC8eNM4Av9GZbHfobn2S8FETcq1ZJjn0GVQ+EaH3Hq0n5t0YOmq7sVJD0ZAk5V1WlMNtDj9S8ozJ8EOlGdPS1cSa7IyZhaRYSHosVNi+8JE2Rynwa6i1geaS532OE+SQgnW6xZN7R21ZQcIYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737574478; c=relaxed/simple;
	bh=qMVAxFS7W+pNWpnqjzQun6zBt3rNSyjmFnm7lxOhcGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVbSgGhMpBTzns8jyRR1Vnwe97JAwHNMceiYy0lhEnBwj8bwNmCZF/XyiTVDUvqcUchZMVvCB+lM2H+x466EXtJfnJiogiLD+Bfq74g9qJD/BGHsws3fv7wOtH8QHJNWMvsg+vv1WpojOOpa8WBrAGdTTyUFCfWQnPs0tT8J6Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+6TS6Er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+6TS6Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C099CC4CED2;
	Wed, 22 Jan 2025 19:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737574477;
	bh=qMVAxFS7W+pNWpnqjzQun6zBt3rNSyjmFnm7lxOhcGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b+6TS6Erf1dQLOESwmDAB7viBdJFKphiSiyoB88woOWX37yOmSFlI+lmMqkcmP4Dx
	 jN9GNM9hMjHO6TxzfZT9Q4pH5XMzFccUj6mmxEX/yrga2ZNmoXhOyG4deTPSmpkU9N
	 H6lpBYbGSSXW3MAYie1yG1YLpStXQh0EFm3P4Ikzcksq/tGpkjE61nWTJ3K3C97HbT
	 9jVFWc/JDq6xbObn21aufppBjx2DQMFDgueluAh4ONsp49vZ45plnS5lMJRMEiP4mH
	 kP0D+23wm3kbuVxYdjAhzcdgYJzwbEHBCxcwFepZ6vJztPl6HAw3CoRmCMTSMajO8o
	 6GFWH3AhoYK0Q==
Date: Wed, 22 Jan 2025 11:34:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is
 readonly
Message-ID: <20250122193437.GY3557553@frogsfrogsfrogs>
References: <20250122020025.GL1611770@frogsfrogsfrogs>
 <20250122060230.GA30481@lst.de>
 <20250122071829.GW3557553@frogsfrogsfrogs>
 <20250122072247.GA32211@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122072247.GA32211@lst.de>

On Wed, Jan 22, 2025 at 08:22:47AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 21, 2025 at 11:18:29PM -0800, Darrick J. Wong wrote:
> > Eh, it's mostly to shut up systems where even /var/lib is readonly.
> 
> What are those systems?  They must still provide some place writable
> for semi-persistant data, so we should look for that?

The particular place that I noticed this was on my fstests fleet, where
the root filesystem is an ro nfs4 export.  I forgot to configure an
overlayfs for /var/lib/xfsprogs, so when I upgraded it to xfsprogs 6.12
and left the VMs running on a Sunday morning, they tried to start
xfs_scrub_all and failed.  Then the monitoring systems emailed me about
that, and I got 150 emails. :(

This /should/ be a pretty uncommon situation since (AFAICT) most
readonly-root systems set up a writable (and possibly volatile)
/var/lib, but I thought I should just turn off the timer if it's going
to fail anyway.

> > IIRC systemd's volatile mode isn't quite that silly, but it'd be nice
> > to avoid xfs_scrub_all repeatedly failing every time the timer fires.
> > 
> > OTOH maybe a better solution is just to run scrub in media scan mode if
> > the media scan stamp file can't be opened for writing?
> 
> Or not run it at all?  Either way I'd like to understand what causes
> this.

<nod>

--D
