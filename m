Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3130414B96B
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 22:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726526304; cv=none; b=ECOPROiB4i61an2z5Vk0wUPXAmbhT94rgsnkIGJC7oPgegk4F5NXo+24vTJ8B+qemyeUApR8zYnvSS9m2Ser4iMXvgWPl5JeQeWdm8JKR45o9d61ChoeOHcaJ+GEymwsEmy2htC7omIgfpSSccda/kOCXOtdIzfCQTWX7CvO7/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726526304; c=relaxed/simple;
	bh=+Y4y1gAgw9Rhe8FXkSd8aFfD7KRHc/HPewMirulVgz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gF5P4E3Y1aeXzYmMgqSc92wRyyMxl6osgryC5a/bTqAEP9POxZGFCD2cBviqOancyrCMsalwMNzBsHc7s9fAssWcQjkXAy/ojoKS6165u9Ly8tbU0QMLIS3GX0tZP7eGRoVnvWZOv9jOQ5uczflYkQr0wji1sxK/lKA4RMLsabI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anpBp6pO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anpBp6pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BECC4CEC4;
	Mon, 16 Sep 2024 22:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726526303;
	bh=+Y4y1gAgw9Rhe8FXkSd8aFfD7KRHc/HPewMirulVgz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=anpBp6pOg4jl/6BN9CF8VP6QsEYrt+q/z6xTn10wg3YaeSPOxDnQi2qAfDeRpx7+U
	 HixKOalhx/NHfWvX2FlorwHSgKBwa0VwOB1wg7i9UfjN6Y7w+yumGAKn3Knz+TjoGY
	 guOllS24qYNR/aPJN2wbe1D0JSAaJI5Op/sMM6B42hzYM92OxfqyfCVEj4fzowWsgO
	 DZPcnkxfDTQcLIClx50l3zs1XUM+rLYiP6JjnfgNBcQ4BJFWn9va3o36oka/dwdkH7
	 oGQ1S6KpZ0TyGmi6o8lVaqIUjME2GOuPHSOVBGBzcKGNijfh4FgeB9gpTFHJ2b93We
	 7tDZWf4a+OeHg==
Date: Mon, 16 Sep 2024 15:38:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] debian: Debian and Ubuntu archive changes
Message-ID: <20240916223823.GE182194@frogsfrogsfrogs>
References: <20240912072059.913-1-bage@debian.org>
 <slyvt2rz27lnawl6k22ozv2mevul6zrv3j5pzmobrxao5ilsmh@qz4l27bmlqd7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slyvt2rz27lnawl6k22ozv2mevul6zrv3j5pzmobrxao5ilsmh@qz4l27bmlqd7>

On Fri, Sep 13, 2024 at 07:42:22AM +0200, Carlos Maiolino wrote:
> On Thu, Sep 12, 2024 at 09:20:47AM GMT, Bastian Germann wrote:
> > Hi,
> > 
> > I am forwarding all the changes that are in the Debian and Ubuntu
> > archives with a major structural change in the debian/rules file,
> > which gets the package to a more modern dh-based build flavor.
> > 
> > Bastian Germann (6):
> >   debian: Update debhelper-compat level
> >   debian: Update public release key
> >   debian: Prevent recreating the orig tarball
> >   debian: Add Build-Depends: systemd-dev
> >   debian: Modernize build script

Yeah!

> >   debian: Correct the day-of-week on 2024-09-04
> > 
> >  debian/changelog                |   2 +-
> >  debian/compat                   |   2 +-
> >  debian/control                  |   2 +-
> >  debian/rules                    |  81 ++++++++----------------
> >  debian/upstream/signing-key.asc | 106 ++++++++++++++------------------
> >  5 files changed, 75 insertions(+), 118 deletions(-)
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Those changes look fine for me, but I'll wait Darrick's review too as he's more
> familiar with Debian than I am.

Looks fine to me too, modulo the thing that I noticed.  I don't think
debian stable builds should hold up merging this series.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Carlos
> 
> > 
> > -- 
> > 2.45.2
> > 
> > 
> 
