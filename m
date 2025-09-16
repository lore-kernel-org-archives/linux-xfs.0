Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8C53218A7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758033737; cv=none; b=F3JajOEu5Oyxvfod1hZ0rNJkivCBn23o7O+tz45rmQzMXqGICEntyLKyiztGNUhd94AlBdkinE2vc89yjtArE8IEfI5vwqDsmc5D0Qf1Tl+dkPZNyr7NII6CezLn2kQXfQhquaC6TqrNDKwDSd6E7EADTpT2QxiL9AUDO9Dfg2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758033737; c=relaxed/simple;
	bh=l7RBO1SWZVwfHUmhLInwXkziDuuCt/lYwoJsfI9yN44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzV1KYpx/rQ+csYxwbWrDUS+3wRSQneRAdGrBW3onct+4QW4uuqiBWYPqrMfN2pYP74Tsdvi24UGaT6oEo0eAC1rwMoLxMmjlQZg6L61yEVbBKBB2B5egpw2EjaL0A7Sfrt4pojS8j3LG//SHgiUbxaGwNAAYPRGQQscDJBhovI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sII8rrmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sII8rrmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D43C4CEEB;
	Tue, 16 Sep 2025 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758033736;
	bh=l7RBO1SWZVwfHUmhLInwXkziDuuCt/lYwoJsfI9yN44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sII8rrmx771BmLRY/qEEq+JBADI+zLCMaF9cvkBYJH+EghGioPiwUPIJKp45mOogg
	 u669+KSCaHwmgHeBNb/ep1ux4LXIJdIphwfPMEQMCohk1cDD31ClsWsiRH5zC89ZTD
	 G6vkMMY+wsqv5wHT80APKdpr7FK5GEfDUVu1inpQjZ7GqBPR9NBf42Z7ZWb6MBTtsN
	 KnSAqY0Cl/B2Fng6psfwctPuy7LGfy9sa0Ja8MOwnwlu0Kv6CYS6otB1WVy3X2BkLL
	 XdsSWVxZY653YOdcR7vUIOJROp3OSnRT1QvZGDMdqpnr1V3UDSpv9kH2t/4kewZliq
	 Vw/kWaHFu9g6g==
Date: Tue, 16 Sep 2025 07:42:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: move the XLOG_REG_ constants out of xfs_log_format.h
Message-ID: <20250916144216.GC8096@frogsfrogsfrogs>
References: <20250915132413.159877-1-hch@lst.de>
 <20250915182732.GR8096@frogsfrogsfrogs>
 <20250915204835.GA5650@lst.de>
 <20250916140109.GA919@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916140109.GA919@lst.de>

On Tue, Sep 16, 2025 at 04:01:09PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 15, 2025 at 10:48:35PM +0200, Christoph Hellwig wrote:
> > On Mon, Sep 15, 2025 at 11:27:32AM -0700, Darrick J. Wong wrote:
> > > On Mon, Sep 15, 2025 at 06:24:13AM -0700, Christoph Hellwig wrote:
> > > > These are purely in-memory values and not used at all in xfsprogs.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Looks ok, but why not move struct xfs_log_iovec as well?  It's also not
> > > part of the ondisk log format.
> > 
> > I have a separate series that includes the move, but I might as well
> > send that now.
> 
> I just looked into that: with my log formatting clean series,
> xfs_log_iovec can and should move to xfs_log_priv.h, while right now
> we could only move it to xfs_log.h.  So I'd rather not move it twice
> and wait a bit.

Ok.

--D
