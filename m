Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0573821A425
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413134; cv=none; b=mHn5JMEnshxPFbMOFyZVNqS9x43BVPZiGhN1K04OiJVdtQkXPJdSwZMBgtK7ViScF2500vJPHF+hNPyEfU9lA67a3ZRo3pW7m24MwJKW21GzIw4aPyFzF9HEsQ+iOAYjyooUusmKH7GrbedBar6Fb2xp0RdEKPVdk4qaL9StjoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413134; c=relaxed/simple;
	bh=sF3nb5OQzVs7mw4/uH9shak7agGDwlDpDZBD/f21Epw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZrF+V8u5kCHLIKwYdTeaLVHA3mnfsf15i9pBjBhrJ0ZZlLyKWw7p0cLFA4ibdIIIcjhgiM+aybGwbSxZzCrazA6VTj8q2XZjWgqfAS2tElSgbfya1o3NHhGtmkgN4svw6rGwwbc8sFeL8sRi5fyD6qIpfzLvMkSizl8qdKkqyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHRlOjyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHRlOjyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82323C4CED1;
	Thu,  5 Dec 2024 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733413133;
	bh=sF3nb5OQzVs7mw4/uH9shak7agGDwlDpDZBD/f21Epw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BHRlOjyVLH1+CPEHwUjse5SrJwIVAypfpbd3WAKueV7vNKe/jI7FeyhXXo9iwKEq6
	 g6XrHMDh+ad/rOpBBMFGVUZzX8QfvmJOm5jYYYr23y/g88n5ybY9uW+vM7b1DxYTEZ
	 tMAM0lLgzoFMKU6gMoL7Lf1HJDvc051zkbqUO3I//hUt649LcGHJdQ/LNr09eY4yWu
	 KJ62t9JkAFvNpb6xY6eanWc4G2R/Na49XbpSFOZfb4xT87JuvcuuCgUYKroXuqj/nZ
	 4btKZKbLterfO4717+ujikzV4yOjEbp9zuG+Jrzeq7+qSfC1AoxQrVY14BYbL+dGPg
	 0jF+y1XrLHRzA==
Date: Thu, 5 Dec 2024 07:38:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jan Palus <jpalus@fastmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs v6.12.0 released
Message-ID: <20241205153852.GL7837@frogsfrogsfrogs>
References: <vjjbmzy7uhdxhfejfctdjb4wf5o42wy7qpnbsjucixxwgreb4v@j5ey2vj2fo4o>
 <z34jlvpz5wfeejc4ub2ynfcozbhdvzp3ug2eynuepfkqlhlna5@fpuhaexfm24h>
 <20241205054404.GA7837@frogsfrogsfrogs>
 <4ssfj3ye4724v66ravsmi7aajesbbj2k5pbordrejzmosecekg@kwzif7uhh4ip>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ssfj3ye4724v66ravsmi7aajesbbj2k5pbordrejzmosecekg@kwzif7uhh4ip>

On Thu, Dec 05, 2024 at 11:09:39AM +0100, Jan Palus wrote:
> On 04.12.2024 21:44, Darrick J. Wong wrote:
> > On Wed, Dec 04, 2024 at 10:50:49PM +0100, Jan Palus wrote:
> > > On 03.12.2024 11:10, Andrey Albershteyn wrote:
> > > > Hi folks,
> > > > 
> > > > The xfsprogs repository at:
> > > > 
> > > > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > > > 
> > > > has just been updated.
> > > > 
> > > > Patches often get missed, so if your outstanding patches are properly reviewed
> > > > on the list and not included in this update, please let me know.
> > > > 
> > > > The for-next branch has also been updated to match the state of master.
> > > > 
> > > > The new head of the master branch is commit:
> > > > 
> > > > 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
> > > > 
> > > > New commits:
> > > > 
> > > > Andrey Albershteyn (1):
> > > >       [90d6da68ee54] xfsprogs: Release v6.12.0
> > > ...
> > > >       [bc37fe78843f] man: document file range commit ioctls
> > > 
> > > Note there is a small issue in this release -- ioctl_xfs_commit_range.2
> > > man page is never installed due to how INSTALL_MAN works:
> > > 
> > > - for man pages that source other page, like ioctl_xfs_start_commit.2,
> > >   it is copied as is with same filename
> > > 
> > > - for mans with .SH NAME section, like ioctl_xfs_commit_range.2, it will
> > >   use first symbol that follows this section both for source and
> > >   destination filename, which in case of ioctl_xfs_commit_range.2 is
> > >   ioctl_xfs_start_commit
> > > 
> > > Effectively ioctl_xfs_start_commit.2 is copied twice and is broken since
> > > it points to non-existent man page. Swapping symbols in .SH NAME section
> > > is one workaround:
> > > 
> > > @@ -22,8 +22,8 @@
> > >  .\" %%%LICENSE_END
> > >  .TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
> > >  .SH NAME
> > > -ioctl_xfs_start_commit \- prepare to exchange the contents of two files
> > >  ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
> > > +ioctl_xfs_start_commit \- prepare to exchange the contents of two files
> > 
> > I had not realized that install_man does that. :(
> > 
> > If you turn this into a formal patch I can RVB it and we can merge it
> > upstream.
> 
> Sent.
> 
> Although I was also contemplating swapping content of
> ioctl_xfs_start_commit.2 and ioctl_xfs_commit_range.2 so
> ioctl_xfs_start_commit.2 contains actual content and
> ioctl_xfs_commit_range.2 includes ioctl_xfs_start_commit.2. It would allow
> to maintain logical order of ioctls however I believe emphasis is on
> ioctl_xfs_commit_range and perhaps its preferred to keep main content in
> ioctl_xfs_commit_range.2

Yeah, all of the publicity materials (ha!) mention commit range, so
that's most likely what people will try to look up.

--D

> > 
> > --D
> > 
> > >  .SH SYNOPSIS
> > >  .br
> > >  .B #include <sys/ioctl.h>
> > > 
> 
