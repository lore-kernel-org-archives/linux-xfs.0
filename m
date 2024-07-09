Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A20414E2FD
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 22:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720565587; cv=none; b=Ga9z9zttuLC7fucYC3mTbUcxfIpSfpMwJJd0lnzuP6L0m427WnHj+7UAYIwC0qizq/YTkIixzII/QfoZ6zzVXhUyyfRedhcMlXdXsUSwBcxqbjpzMwsoIeG0y9XAkcjqcEtClKYaA5PPYE3smq8L5CASxROaTMe/CaaMhRoIFls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720565587; c=relaxed/simple;
	bh=+pgmv/9SiBoXaDPGeY3ltFIvvEJoAHiQQGrAo7AtB5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4yByXaFae4cOh6jJENVy3tbJyPTX71pkHLBezpMQfn7gXwQoz4HaQ9dBHaP2S9VlpQT66/5omLB62LghoVRwuLHpC15aRvmHqY/xgRmDIYwRnle6TmqnJhOVr4KmVvl7JQqd/zTbtXppFnrlCdtWFnzErfdsJnJi/wPOHqDpAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntKAK3mc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntKAK3mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9500AC3277B;
	Tue,  9 Jul 2024 22:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720565586;
	bh=+pgmv/9SiBoXaDPGeY3ltFIvvEJoAHiQQGrAo7AtB5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ntKAK3mcy23CTcdCpCutXCc6lF8jjE6zJP/qAY4WNIGNjRO5oea5Jfm2eXUHluKFk
	 HB3sU0pwOKGzbCAt96Mrn006T4gzfss8Vx8HwxfcfcmRxyWVZub2EFbVPpD+yNsg3n
	 5o4ujeVomsC2xek7GgIC6qTEBceYmaRLepkv63MPIuVBnWW4FH/LnjxUL1av2vZoZf
	 RN1wpsMV01+EysROlGj47P8BpnMVTSDmneHGtIGOwnblEXwuKFjYzSxE+hVzr+Fm1f
	 //WzaIxU3ngTx4TSCjo/NITocDw4aHZhJlMrCNizqf6ZZSc6Y7Wtg3DaoqUH/Dfsjk
	 Y+pTRK8n4cYMg==
Date: Tue, 9 Jul 2024 15:53:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services
 by default
Message-ID: <20240709225306.GE612460@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
 <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
 <20240702054419.GC23415@lst.de>
 <20240703025929.GV612460@frogsfrogsfrogs>
 <20240703043123.GD24160@lst.de>
 <20240703050154.GB612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703050154.GB612460@frogsfrogsfrogs>

On Tue, Jul 02, 2024 at 10:01:54PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 03, 2024 at 06:31:24AM +0200, Christoph Hellwig wrote:
> > On Tue, Jul 02, 2024 at 07:59:29PM -0700, Darrick J. Wong wrote:
> > > CONFIG_XFS_ONLINE_SCRUB isn't turned on for the 6.9.7 kernel in sid, so
> > > there shouldn't be any complaints until we ask the kernel team to enable
> > > it.  I don't think we should ask Debian to do that until after they lift
> > > the debian 13 freeze next year/summer/whenever.
> > 
> > I'm not entirely sure if we should ever do this by default.  The right
> > fit to me would be on of those questions asked during apt-get upgrade
> > to enable/disable things.  But don't ask me how those are implemented
> > or even called.
> 
> Some debconf magicks that I don't understand. :(

A week's worth of digging later:

Actually, no debconf magic -- Debian policy is to enable any service
shipped in a package, by default:

https://www.debian.org/doc/debian-policy/ch-opersys.html#starting-system-services

"Debian packages that provide system services should arrange for those
services to be automatically started and stopped by the init system or
service manager."

It's up to the sysadmin to disable this behavior, either by installing
their own systemd preset file:

https://manpages.debian.org/bookworm/systemd/systemd.preset.5.en.html

that shuts off the services they don't want (or more likely enables only
the ones they do want).  Other people have proposed rc.d hacks:

https://packages.debian.org/bookworm/policy-rcd-declarative-deny-all

which prevent the postinst scripts from actually triggering the service.

> A more declarative-happy way would be to make a subpackage that turns on
> the background service, so the people that want it on by default can add
> "Depends: xfsprogs-background-scrub" to their ... uh ... ansible?
> puppet?  orchestration system.

Though I guess we /could/ decide to ship only the
xfs_scrub_all.{service,timer} files in a totally separate package.  But
that will make packaging more difficult because now we have to have
per-package .install files so that debconf knows where to put the files,
and then we have to split the package scripts too.

On Fedora it's apparently the other way 'round where one has to turn on
services manually.

--D
