Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9435D8F58
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 02:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719975571; cv=none; b=XAWu/KHhHCYK3bR5d4q+EbaODDIms48+mYydiqJAB57RhDKjMY+3N90MFQPfwyf/mtjXByyiT+Cs6k9LZIb0AfMRNBDYeriG+71MV0VSLikbFyMAuCSaQJ82f0yzcGBUBnMLGqfrltjIG/X7lMXjpMq8cAmpf91Xv33K2E6pDL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719975571; c=relaxed/simple;
	bh=6XuIPdI64QS83gDfLFrICn7OMW/F/ktFlTzKGnhWV9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfJFzk3ky2Yj2s4xSxublcP+gZJv4UnOuojnXiNf0dXrj/7840OaX+v+vP9tVDVT5EM5xafAPXwnNdceSOQ4hPaRauomSLu3KnqU+qxLTD+51d29O3Rhp0v4fF/05O2nOX5jrgDrogFg5MpTrr6sCUCJwxvRJEmDSfrTML0Nm6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrhjpSI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrhjpSI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1546BC116B1;
	Wed,  3 Jul 2024 02:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719975570;
	bh=6XuIPdI64QS83gDfLFrICn7OMW/F/ktFlTzKGnhWV9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rrhjpSI5/rmnnvyMM3iIt07Nklc+QByj44U39M/FFgabzHOwrX8C+bmrlvTdfH0AI
	 J4dJbrw1PMTFAecGVbNXqudFdiLjAWZ963VehnKqs2dSpCORj/24SLPT3mWplU57v0
	 cknWlOTXcCh6VhaOhwhSqj7ua+xhKxXSDXq2aF2HHnINXydvc4cBD5UAPeg5i51IBO
	 e2Hsecrx1h0wb5CYCleqUZzWBxxceusynpZRAooCGwRA9vCf+Vh5EWyZYoEomGbUKW
	 VEn6e4QpGQZoOZcCx8fk9Mt6aaKGb8Aax4UMjkm+IzWcT84h/IP8wBoZsmQvyrwI6Y
	 NQsRhAUy5cnRg==
Date: Tue, 2 Jul 2024 19:59:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services
 by default
Message-ID: <20240703025929.GV612460@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
 <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
 <20240702054419.GC23415@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702054419.GC23415@lst.de>

On Tue, Jul 02, 2024 at 07:44:19AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 01, 2024 at 06:09:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we're finished building online fsck, enable the periodic
> > background scrub service by default.  This involves the postinst script
> > starting the resource management slice and the timer.
> > 
> > No other sub-services need to be enabled or unmasked explicitly.  They
> > also shouldn't be started or restarted because that might interrupt
> > background operation unnecessarily.
> 
> I'm still not sure we quite want to run this by default on all
> debian systems.  Are you ready to handle all the bug reports from
> people complaining about the I/O load?

CONFIG_XFS_ONLINE_SCRUB isn't turned on for the 6.9.7 kernel in sid, so
there shouldn't be any complaints until we ask the kernel team to enable
it.  I don't think we should ask Debian to do that until after they lift
the debian 13 freeze next year/summer/whenever.

--D
