Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8741E528
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2024 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721148390; cv=none; b=PYoWrvrxIy0re6nEeIr4IKDYyLaIRlAubpxyH0BGmENJXIb0w9ul0cssy919kL9mFSSKw+atNQAK8g1zW6DwxxO5wB28ObDPjTAia7LYPj48Om99su8rdLX4RvbHKsqR4bBHHfpSTTgkG32edfaT7GzHA8KOYXBg+DnjchdukrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721148390; c=relaxed/simple;
	bh=6h7teWWfOcKzrmQkfMb9tIlRfaOy+fwdXXP4fgdumqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PhA8vb6yZj+9y2K4rKrLJcxKhunNwVZ03PjiLbdqviTgmODd3VDsl+bAU/cDTF3xrYcGb/LYTwBeRaOUe5pXzeeBfcWGQGE/753DXV6C1303z3NU3gt++DKfba2qQ2JtMjrbFI0Hz6RXWFc/t1zH5zCno+TWqdZ1SF/KEhW+tWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYiMAvew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYiMAvew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C04C116B1;
	Tue, 16 Jul 2024 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721148389;
	bh=6h7teWWfOcKzrmQkfMb9tIlRfaOy+fwdXXP4fgdumqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gYiMAvewDLUmQzzSUDefS2cc5vNkrB344f/0zBMz8MWQThnH+eJ9gGhYyxKL/efoh
	 18YMTyAD8Neup6em/WxIvfUS+RbgIqsr4WmkaQRup1jCHpsh1hyOesfcsm+8R9Ws0M
	 1dIBjBndvontYIzY+gZWZtHCU0vFBhu9XkWrA8chjuudU4933inB0HSFrtqcJRE8eA
	 bH3XWJwKarBgbJ5R9Z2wdaVnc0mleiRbrJiDD3eSfT8eGLHh7yrrTuCxMNcaKf1huq
	 Yudi/XZjL2yy+f9wQmLTvS0hQ9pcTNbu+BWymY3DXwCoXlt3PMnv+dZpUrXVOo7dsl
	 RZ8yfGHh+ncMQ==
Date: Tue, 16 Jul 2024 09:46:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services
 by default
Message-ID: <20240716164629.GB612460@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
 <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
 <20240702054419.GC23415@lst.de>
 <20240703025929.GV612460@frogsfrogsfrogs>
 <20240703043123.GD24160@lst.de>
 <20240703050154.GB612460@frogsfrogsfrogs>
 <20240709225306.GE612460@frogsfrogsfrogs>
 <20240710061838.GA25875@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710061838.GA25875@lst.de>

On Wed, Jul 10, 2024 at 08:18:38AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 09, 2024 at 03:53:06PM -0700, Darrick J. Wong wrote:
> > Though I guess we /could/ decide to ship only the
> > xfs_scrub_all.{service,timer} files in a totally separate package.  But
> > that will make packaging more difficult because now we have to have
> > per-package .install files so that debconf knows where to put the files,
> > and then we have to split the package scripts too.
> > 
> > On Fedora it's apparently the other way 'round where one has to turn on
> > services manually.
> 
> Heh.  I'm still worried about scrub just being automatically run without
> the user asking for it.
> 
> How about something different:  add a new autoscrub mount option, which
> the kernel simply ignores, but which the scrub daemon uses to figure out
> if it should scrub a file system?

Hm, xfs could do that, but that would clutter up the mount options.
Or perhaps the systemd service could look for $mountpoint/.autoheal or
something.

It might be easier still to split the packages, let me send an RFC of
what that looks like.

--D
