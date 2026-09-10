Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B581B25228D;
	Thu, 10 Sep 2026 05:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789018303; cv=none; b=g78hp6QskUHk+RvQZi71V8CsiRU/YlIZDzQm4rNg9qfy2KXi5x25jEYxpY1EXLqyMiFYMsF/HrX9faqt3SE9N0qUyumDeAzqN3XwfRZN+j524BLWcO3ItwWd6OMb1jJ2VkULBVahRoX8Gp+phYBSBSO/yRD6dcVGqH18r1+i11I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789018303; c=relaxed/simple;
	bh=jm0FXUlzhEk51BDrFANyga7WNeOqnXpBC/OhDj06vlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyiYhu/3ntmMbBWdrnGFnBl2bPxmpZ4gCHchF5zihPw/Xnte+mIhVePp/yK9JEBKx0GBnEYojiAcHWNlqoChr2yIi9Ys3q4Zr0BwQoNT7dH4Eev4O22gsGbIXaxZfHPNqT8aaj7eJG6wK61uFMBGWNLtzBuJyxuqzhRygN+tz1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2WzCrOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2WzCrOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F392D1F000FF;
	Thu, 10 Sep 2026 05:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789018302;
	bh=LQ2gkzf9X0BU5XOiFqcl3ujZ5dmTu8PMNVA8Ebpo/38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o2WzCrOERsfT5JdVtUKNdEH9A3O8B21y13xV2y93pZdHJCTQ5WTs+zcJ4LuMVBw4g
	 VBSg4PQDQpF7fvI2x26V6phM8paASidDXTZeUPZNrXUa+bAoE/yeWwgA9IphTDrwwl
	 sf16p9S9wvJ13Rd54GRGYwD/9+Gu4OnUtz2sg8VXKfxzINURbBIMc5Lj9M6dPwG5ZR
	 r/p60myrmfS3nDskqMZFK0H3Ii0STtbqHK2ooLBVb/rw0inlOeS/qkCFFQLgAADkxK
	 q10IxhMcTR2bk5an7RzlNvbeaSeV6ebBeIR/6xiER2E6WOlyav5qoAAQvQm2IdwWv/
	 0KFx34LXVVOmg==
Date: Thu, 10 Sep 2026 07:31:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, dgc@kernel.org, floss@jetm.me, 
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix under-reservation of blocks when repairing
 sf directories
Message-ID: <aqJANTuQQMEIqcmO@andromeda.toxiclabs.cc>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs>
 <20260910050031.GB26687@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910050031.GB26687@lst.de>

On Thu, Sep 10, 2026 at 07:00:31AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 08, 2026 at 11:04:35PM -0700, Darrick J. Wong wrote:
> > +static inline unsigned int
> > +xrep_tempexch_estimate_sf_resblks(
> > +	struct xfs_scrub	*sc,
> > +	int			whichfork)
> > +{
> > +	if (whichfork == XFS_ATTR_FORK)
> > +		return sc->mp->m_attr_geo->fsbcount;
> > +	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
> > +		return sc->mp->m_dir_geo->fsbcount;
> > +	return 1;
> 
> geo->fsbcount for attrs is a always 1 and a lot of code relies on that,
> so this feels a bit overcomplicated and misleading (but still correct).
> 
> What about the more usual:
> 
> 	if (S_ISDIR(VFS_I(sc->ip)->i_mode) && whichfork == XFS_DATA_FORK)
> 		return sc->mp->m_dir_geo->fsbcount;
> 	return 1;

Either are fine to me so feel free to add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> ?
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
