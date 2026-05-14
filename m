Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF2F3CF977
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 22:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778797675; cv=none; b=BvDEqWYDwha8XRg42XKuVFiPihMMB3lqubHnTJTz6GrSW0eK+x9xI+ffaDpyHfp7iuLGYHCLjKHP0tVQ9K155byzqSeeZptMRG5Wtgw4Xb0OAgBQieyIVNakz4cNniZTcybMiWOL8H/pry8eM/V/7EiVbdvkfBEzaKB+c+sOuUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778797675; c=relaxed/simple;
	bh=wLF03T4iUzm0GtiXXhCCQMCFko+wLEuj9oM+qLzvTI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3qM6u1KV+kaDSuCu6CDfS0QSYXWjL9OnrCsUMQZX+DiVpm4m4bzTLtsZ7hFMso+a0y+CY2o5uOP8UusyiCINY9esQQXZnhJNECrKqTtkYV+eCrDYsIhewfXh62bjv40WAP0P3Al9oN9rt7oOEUw5hdrL/Mf02fDHE68E47YIqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Be3I8BKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Be3I8BKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887C3C2BCB3;
	Thu, 14 May 2026 22:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778797674;
	bh=wLF03T4iUzm0GtiXXhCCQMCFko+wLEuj9oM+qLzvTI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Be3I8BKwf6iwF3rWIrTYUN6fqPb+bogQ2045TzBu6zWKva1528vP6Qc2vVmy3NBsE
	 8Xcq9nmbmc3l2v6zdaVKwvBruLh+LnT8f0Gg5j5d/1ojzUf/LdtyodqetF4hX6RVFX
	 QHqeyJvH970Wb23FJcdkdfruQj8q6RU9cTeyHupBOGpdMCcPoCrgVhgC1HXvVvmtNV
	 MIVas7UjbnwyjJpYxMIgeZBcxd8BvWevuRZ0Zgb1wtgmz/RshYuaY5gw7jHJzTF4Xx
	 IURMbZgv3Nme63PKrxgZnOZ1dd9NpcqPMTLh0mjIALEE9gnbL6Mev/xAQ6yVl4JlFJ
	 Kqy++SiCsSh1A==
Date: Fri, 15 May 2026 08:27:43 +1000
From: Dave Chinner <dgc@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cem@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
	djwong@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] xfsprogs: mkfs.xfs add default configuration
 file.
Message-ID: <agZMX7Bzyjdq80pN@dread>
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

Yes, the upstream package should not install a defaults file - the
package might be built alongside the system package install using an
install prefix, and we don't want to be overriding any config the
user/distro has already installed.

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

Not really useful, IMO, because changing default behaviour is a
relatively rare event.

Indeed, we already have LTS kernel mkfs conf files that adjust "cli"
parameters to match the mkfs defaults at the time the LTS kernel was
released. These get installed into /usr/share/xfsprogs/mkfs for
users that want to use them via 'mkfs.xfs -c ..../lts_6.12.conf
...'.

Hence I don't think we even need to care about maintaining conf
files for the current defaults or even per-package-release files
because what most people care about is maintaining a feature set
that is compatible with the distro kernel(s) they are running...

Hence if we are going to ship default config files that users can
install manually into /etc/xfs/mkfs/default.conf, then the package
install directory for those example config files would also be
/usr/share/xfsprogs/mkfs, right?

If that is the case, how does the user now tell the difference
between a CLI conf file and a template default conf file that
should be installed into /etc/xfsprogs/mkfs/.... to change the
default behaviour to match lts_6.12.conf?

I guess what I'm asking is that the conf file we install into /etc
to set the defaults needs to have exactly the same contents as the
conf file the user would specify on the command line to get that
specific config to be used.

If this is already the case with this new proposal, then we don't
need to ship any new example config files, just hook up an xfs_admin
command to set a specific conf file as the mkfs default. i.e. to set
the default behaviour to 6.12 compatible:

# xfs_admin -d /usr/share/xfsprogs/mkfs/lts_6.12.conf

And to reset mkfs behaviour back to built in defaults:

# xfs_admin -d clear

Distros can then patch their package source to add their own
defaults files for their own releases - we could even ask distros to
push them upstream so that users can still use bleeding edge
xfsprogs on older distros when needed....

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
