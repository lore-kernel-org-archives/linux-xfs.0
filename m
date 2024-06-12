Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EC325762
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 20:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718222867; cv=none; b=pGBmpCgnQu3vn60ToqZo2NmgtdhKKv5bvb9EibsWz5zZ5M247gUq+PWuell3YFSuq8yJqMKawL0KajWUryheVmNnDaPkIv35jecpm79Bu71HpiRJyW3lhIIALYO3mjzvVY9cQ9yTCsB6uM2kvTZw/Jf7D4rqQ8sgVBeo+t8u4Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718222867; c=relaxed/simple;
	bh=GnGGjozdy8746y4esD15Bp50niJsFijWx8LoTXhb7O0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyN+l6Vay/FbJWzIK6C8GlpDkJdJ/hjSYtCHAi3HoxV9ZLF34tyG1Ouzq1skrw3vyhaZXGqFhY+I9meB5sH+nRnYqjLVuSDAz9S0zR3igymaWAYFQ81Dnz6+wyD6+7KlpXlQZ/+ss2a3l3B7yxBY+4vO7CU07gGy3WdGmmy85CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZ8NSuTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZ8NSuTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9E5C116B1;
	Wed, 12 Jun 2024 20:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718222866;
	bh=GnGGjozdy8746y4esD15Bp50niJsFijWx8LoTXhb7O0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZ8NSuTSQFsXeZObqlPYBNCiQIi15QtBGMA3hgT4rMwIiQ5yiLVrAPQe5z/ppDwmu
	 ezFfAEZ61IhuGGGAxQ08WxRMr/gr0rlQA7oiReXD+kCraDBzh+eV8bUQ8Z1QJibyZh
	 K2jlVyHasAEYaOxkfikki+d3D3TLqW5IqZt88Wd7Fpas6CTr7Wi5eRzLmuAXzb9G8y
	 OB4hN6ATHEwV1AgUgA7+c1jFdDi+RssfAUjqrYijf3rd3M1A8tnGNUL97FPCxp6eb4
	 IH5+R9jQ+VtAXoe0/kdFIOq4TVd3zLxNg7Grqe4PoxW4YjGxDdyI47rdlsePN/w9I1
	 xLk1sN2IF4NGA==
Date: Wed, 12 Jun 2024 13:07:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chris Hofstaedtler <zeha@debian.org>
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] Install files into UsrMerged layout
Message-ID: <20240612200745.GH2764752@frogsfrogsfrogs>
References: <20240612173551.6510-1-bage@debian.org>
 <20240612173551.6510-2-bage@debian.org>
 <20240612180843.GE2764752@frogsfrogsfrogs>
 <yoidu77dijghmk6tgpioz3diswsj53f6m5qjqd5quyruox7oop@o7gb7o6nl6ij>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yoidu77dijghmk6tgpioz3diswsj53f6m5qjqd5quyruox7oop@o7gb7o6nl6ij>

On Wed, Jun 12, 2024 at 08:58:55PM +0200, Chris Hofstaedtler wrote:
> * Darrick J. Wong <djwong@kernel.org> [240612 20:08]:
> > On Wed, Jun 12, 2024 at 07:35:05PM +0200, Bastian Germann wrote:
> > > From: Chris Hofstaedtler <zeha@debian.org>
> > > 
> > > Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
> > > Signed-off-by: Bastian Germann <bage@debian.org>
> > > ---
> > >  configure.ac                | 19 ++-----------------
> > >  debian/local/initramfs.hook |  2 +-
> > >  2 files changed, 3 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/configure.ac b/configure.ac
> > > index da30fc5c..a532d90d 100644
> > > --- a/configure.ac
> > > +++ b/configure.ac
> > > @@ -113,23 +113,8 @@ esac
> > >  #
> > >  test -n "$multiarch" && enable_lib64=no
> > >  
> > > -#
> > > -# Some important tools should be installed into the root partitions.
> > > -#
> > > -# Check whether exec_prefix=/usr: and install them to /sbin in that
> > > -# case.  If the user chooses a different prefix assume they just want
> > > -# a local install for testing and not a system install.
> > > -#
> > > -case $exec_prefix:$prefix in
> > > -NONE:NONE | NONE:/usr | /usr:*)
> > > -  root_sbindir='/sbin'
> > > -  root_libdir="/${base_libdir}"
> > > -  ;;
> > > -*)
> > > -  root_sbindir="${sbindir}"
> > > -  root_libdir="${libdir}"
> > > -  ;;
> > > -esac
> > > +root_sbindir="${sbindir}"
> > > +root_libdir="${libdir}"
> > 
> > Should we get rid of $root_sbindir, $root_libdir, PKG_ROOT_LIB_DIR, and
> > PKG_ROOT_SBIN_DIR while we're at it?
> 
> Will do.
> 
> > That will break anyone who hasn't
> > done the /usr merge yet, but how many distros still want
> > /sbin/xfs_repair?  opensuse and the rhel variants seem to have moved
> > that to /usr/sbin/ years ago.
> 
> I think nobody supports split-/usr nowadays?

Oh I bet there are *some* people still running separate / and /usr
without an initramfs or a livecd who still need to be able to mount / so
they can repair /usr.  Buuuut.  As none of the major distros
(suse/rhel/debian/anything with systemd) support separate /usr anymore,
it's probably no great loss.

--D

> Chris
> 
> 
