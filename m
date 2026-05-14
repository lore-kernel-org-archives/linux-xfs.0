Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A988030E0EC
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778776155; cv=none; b=ldYEZ7erHbniTIKjAnMwVvpflAWuGwUKggMFq35lSfM4g254ZPqz+gawCBMeHjq7vkcUsPw+yRQCfwxbpMKRMDWmfOZymb2NfyHZY2U8qEmIb99mNP1RkQXfLTUhlrLJndOQInsfTQRgf33nGB3ZPMSlt91WE+bKNqHu0DVMptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778776155; c=relaxed/simple;
	bh=qCs+3FzGfmphd70CbAnTdWt+ISTrCCdzUz0XBLmY3qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JjHL0H/R1T8xi0MzBQWKz5bQWVjIDwqfGr3b/KqAL27EWJ918iojGQnSxBj8FtKPvYbfj13cbc1QaOqBrOFxiHGy6kUwULzaT7fNERi7ccruMvEBxbSu7Ku0lHakk4ft0SlxpGvWQh/owXrcysa7XHm0RZQ9Z5KTz28z0ShC8u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ee7oY5r1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ee7oY5r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404D4C2BCB7;
	Thu, 14 May 2026 16:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778776155;
	bh=qCs+3FzGfmphd70CbAnTdWt+ISTrCCdzUz0XBLmY3qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ee7oY5r1+DqFAi/RiqCdhOV9iYoxziEZbTvVJtrt+t6JzcnQNHsESLsOZxtYTXHgG
	 WdtEsNHcYkl0Zjn6doXz1YnATfCNsX6xSBkDhSnLE7BtCyr4EuOHF2o8SnoNul+E4N
	 EZQdYpMKqDJjzhltyugatEMgCf9cwgNXE5qJ3PCxHCily66mMZFK3ZLV4jof+7FSuq
	 RdSY9ElQxcz5zuwOf79GTvPWY8wU6uruw6n/koS4TzeuTY2M/hnSRecEdOps4oF6Rr
	 mI5lp8oDb3GdPkqSE7jIothqPKvMPuGA1iUMmfknZSCm1KEtSzID98sFagOS6it/bc
	 BL9+Qkn4lSRCg==
Date: Thu, 14 May 2026 09:29:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cem@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
	aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] xfsprogs: mkfs.xfs add default configuration
 file.
Message-ID: <20260514162914.GY9555@frogsfrogsfrogs>
References: <20260514143716.893814-2-lukas@herbolt.com>
 <20260514143716.893814-3-lukas@herbolt.com>
 <agXnLdc5kzfyOI3P@nidhogg.toxiclabs.cc>
 <fddc8573-8461-475f-9826-ee465c48c969@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fddc8573-8461-475f-9826-ee465c48c969@sandeen.net>

On Thu, May 14, 2026 at 11:05:14AM -0500, Eric Sandeen wrote:
> On 5/14/26 10:21 AM, Carlos Maiolino wrote:
> > On Thu, May 14, 2026 at 04:37:17PM +0200, Lukas Herbolt wrote:
> >> Various users may prefer different default values. Having a default config
> >> file will allow them to utilize it without the need specifying configuration
> >> file on command line.
> >>
> > The idea seems reasonable, to have a default file to load if it's found.
> > I just particularly don't like the idea of shipping/installing a 'default'
> > config file.
> > I think we could ship an "example" one, but leave to distributions to decide
> > what to do. If they would install a default config or not. And maintain
> > the default config file.
> > LTS configs are easy to maintain because we know no new features will be
> > ported to LTS. Providing a default config file from the mainline risks
> > getting a lot of user complains if we in the future decide to change the
> > 'defaults' of the default config file.
> 
> Thanks for starting this discussion Lukas.
> 
> I'm sure others will have Deeper Thoughts but I more or less agree with
> Carlos here - a default config file to be loaded /if it exists/ but maybe
> not existing by default - because we already have defaults hardcoded into
> the binary itself - might be a more maintainable path for upstream.
> Otherwise I see new tests appearing which are like "make sure the dfault
> config we ship matches the defaults built into the binary itself" which
> seems like unneeded complexity.
> 
> (i.e. the os-specific config files could be renamed or symlinked to
> that special default config file path, for example?)
> 
> I could maybe see generating an example defaults config file which matches
> the built-in defaults at build time? Not sure if that would be useful
> or helpful (or complex).

I think that would be a lot easier than us trying to keep the default
config file in sync with xfs_mkfs.c by hand.

--D

> 
> Thanks,
> -Eric
> 
