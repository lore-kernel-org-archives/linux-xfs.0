Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC98370AEC
	for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779199838; cv=none; b=bSUNnQp+OtWeUyvPoQGuTrEGdIP7qh8G2RRshiPyTvt6TQYIma+2yIRwH1y0XdP9oCDaWIuA4gHNwF599keCCl4FYsbDBnjUiYf5vA8WqmktOJs5nAU+1pv0LHapCdtBUF0xyzJ4MYw8H2mhdvlycV9qP6HTFuW4vjzAJ5M6db0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779199838; c=relaxed/simple;
	bh=9qTvmfguMjcejW3iW2gLcg+J1kuVdWcpzToJBzL2oEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gt/zuLyu2wQzcXS47UIpqv5APorOWAEqf6EFqDolOyLAd8LFZI8hMxXBS2gKbtcQZlvVw2ABcwu6k6HN28KrxLXNogghSvcCn0pQ3ipiHdkHI7Z5ih4jCVkDx2vtJXm9alj9Afh1SFEvLzZl0Vv29Kq7wS6P3xOjnTs53gYMaqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIKBjovN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIKBjovN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47F0C2BCB3;
	Tue, 19 May 2026 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779199838;
	bh=9qTvmfguMjcejW3iW2gLcg+J1kuVdWcpzToJBzL2oEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIKBjovNJDi1WqcBsqUS09amC3Iaw2/5GTf2um0ryIgopa2tQnzSt35rY79yqGny1
	 eqCnw9VRwNkjvpFOdXSo3BVGpEHD5Vp8kW/Y+IfyE5KL6Kx+POJfmkLinap9UA9Cud
	 i3E1LTqLarAGqecbSpAJh87E5XFQTsn6ZiySNRbyGiBIAKKPMJxIfd1Dj8TDAuIAXa
	 bFjIehLPtg+Ogs6CbgO+CljQ7PvNqbL57iK7MLa9TgXvLflqfgmqdzuMN9vAIEjFJc
	 MmqVI209/tdWvu2RGJKba03rKcEfNhPhpBqDqwrc0F8jzFNc87E1XkNEWw70fmn4xz
	 AuRd2eJP5d5nw==
Date: Tue, 19 May 2026 07:10:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, sandeen@sandeen.net,
	aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] mkfs: allow specification of default options via
 configuration file
Message-ID: <20260519141037.GG9555@frogsfrogsfrogs>
References: <20260514150653.GW9555@frogsfrogsfrogs>
 <agwisMUPPeYa5qDM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agwisMUPPeYa5qDM@infradead.org>

On Tue, May 19, 2026 at 01:43:28AM -0700, Christoph Hellwig wrote:
> On Thu, May 14, 2026 at 08:06:53AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Ted asked for the ability to set default mkfs options, but to retain the
> > ability respecify options via a separate configuration file or cli
> > options.  This would be useful for running fstests with the default
> > featureset of (say) Linux 5.15 LTS, while still allowing individual
> > testcases to provide their own overrides.  It's certainly less messy
> > than what Ted does today, which is a bash script that copies the desired
> > config file and changes things.
> 
> Looks reasonable, do you have a test for it as well?

Somewhere, yeah :)

> > +static inline int
> > +getopt_mkfs(
> 
> I don't think there's much of a point in the inline here.
> 
> > +	int			argc,
> > +	char *const		argv[],
> > +	const struct option	*longopts,
> > +	int			*longindex)
> > +{
> > +	return getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
> > +			longopts, longindex);
> > +}
> 
> Why does this hardcode the short options, but requires the caller to
> pass in the long options (which are the same for both callers)?

long_options is a local variable which contains a pointer into cli,
which is another local variable in main().

I could have made a fugly macro with implicit variable access, but that
was yuck.

> > +	while ((c = getopt_mkfs(argc, argv, long_options, &option_index)) != EOF) {
> 
> Killing the long_opts would also avoid the overly long line here and in
> the other call site.

I could just shorten it to "lopts" or something.

> > +		if (c == 'c') {
> > +			parse_subopts(c, optarg, defcfg_subopt_tab, &cli);
> > +		}
> 
> Spurious braces.

Will fix.

--D
