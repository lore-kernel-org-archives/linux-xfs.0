Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53271193419
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 05:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733377445; cv=none; b=l2lCntRHLX691yu45oQQLGrUzFqbpeRQ67VF7veXdvrVvHkulXxNKMdSlrg338rknDwJa1SGpAkm7OnZNbxSzfBaIl5opZeaTtZnoG9bLkHmDIFJhDjQWPoUJ4GOnWLXKQ8vOHQnfESAzYusZcDNpNNbELCZyJ2UHuduDOppqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733377445; c=relaxed/simple;
	bh=cGMIDEru98DjR6dVO4WHYegq3hMxBteXRcD1R43SOlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+eJrbL7ntZ3rI7QQxt2J5JuR05ourEUgtZhQuZw554oDjuioDUr2DlJgG5lwTysET+aeQWcgm7GCXOJA7Kxdljc0aDKH50syOJiiidPyTzUF7767XKFCZuqhF8pxH0ufC2+SU6Ci4c7baxYqvPCoPWVizOr6O3rjPnY15DFSjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AE0/Z6s9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AE0/Z6s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF68C4CEDC;
	Thu,  5 Dec 2024 05:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733377444;
	bh=cGMIDEru98DjR6dVO4WHYegq3hMxBteXRcD1R43SOlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AE0/Z6s9Sl3JVArRqgiJqHsyYNFWpdDaLVIKPcYU13FwgYFT6otR/RZgSI6+CVDgb
	 kIPTOwyiIMSKbo87EQsMblFR+uWC5RHe8cKY8cCyZggG6G/0JAj9bG+odw52Nxec6k
	 1YxsmfWzlOGNykQPX/w401YuIcLveY08SjOT4Wj5zRGhk6LHEGe0T6b4rfLE3iPGFt
	 mwxH0ckKqEJqXb47oHYLGLXT/oTjS0tC50w+eD3CXcXa0283rBhIsrdEdOzQiPykth
	 iybgLU4V5KyyAuOrWzyG9Nf1FV/xbSm0+W849O26J7EqyN4EKOBfdOLK7PTuWc12cR
	 PJac5oADiQMhA==
Date: Wed, 4 Dec 2024 21:44:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jan Palus <jpalus@fastmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs v6.12.0 released
Message-ID: <20241205054404.GA7837@frogsfrogsfrogs>
References: <vjjbmzy7uhdxhfejfctdjb4wf5o42wy7qpnbsjucixxwgreb4v@j5ey2vj2fo4o>
 <z34jlvpz5wfeejc4ub2ynfcozbhdvzp3ug2eynuepfkqlhlna5@fpuhaexfm24h>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z34jlvpz5wfeejc4ub2ynfcozbhdvzp3ug2eynuepfkqlhlna5@fpuhaexfm24h>

On Wed, Dec 04, 2024 at 10:50:49PM +0100, Jan Palus wrote:
> On 03.12.2024 11:10, Andrey Albershteyn wrote:
> > Hi folks,
> > 
> > The xfsprogs repository at:
> > 
> > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > 
> > has just been updated.
> > 
> > Patches often get missed, so if your outstanding patches are properly reviewed
> > on the list and not included in this update, please let me know.
> > 
> > The for-next branch has also been updated to match the state of master.
> > 
> > The new head of the master branch is commit:
> > 
> > 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
> > 
> > New commits:
> > 
> > Andrey Albershteyn (1):
> >       [90d6da68ee54] xfsprogs: Release v6.12.0
> ...
> >       [bc37fe78843f] man: document file range commit ioctls
> 
> Note there is a small issue in this release -- ioctl_xfs_commit_range.2
> man page is never installed due to how INSTALL_MAN works:
> 
> - for man pages that source other page, like ioctl_xfs_start_commit.2,
>   it is copied as is with same filename
> 
> - for mans with .SH NAME section, like ioctl_xfs_commit_range.2, it will
>   use first symbol that follows this section both for source and
>   destination filename, which in case of ioctl_xfs_commit_range.2 is
>   ioctl_xfs_start_commit
> 
> Effectively ioctl_xfs_start_commit.2 is copied twice and is broken since
> it points to non-existent man page. Swapping symbols in .SH NAME section
> is one workaround:
> 
> @@ -22,8 +22,8 @@
>  .\" %%%LICENSE_END
>  .TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
>  .SH NAME
> -ioctl_xfs_start_commit \- prepare to exchange the contents of two files
>  ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
> +ioctl_xfs_start_commit \- prepare to exchange the contents of two files

I had not realized that install_man does that. :(

If you turn this into a formal patch I can RVB it and we can merge it
upstream.

--D

>  .SH SYNOPSIS
>  .br
>  .B #include <sys/ioctl.h>
> 
