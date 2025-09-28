Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E5B1DC9B5
	for <linux-xfs@vger.kernel.org>; Sun, 28 Sep 2025 06:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759039869; cv=none; b=RKh6x42edDb+SOlzCq8DnwwlaylT+z34s1iR0GnVXHdpyAz3ZUaYMZK0d3QOJAvVJ3FUCEnr3tgiw1yMp0kFiYWMmj3VkMMo/xGCmzh/tR3b+zyXxgqRYvyx4u94MVlLg6vSudznXLBqBkj9+/rnF4okZsvkY27zeawO/0Jjt7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759039869; c=relaxed/simple;
	bh=gOT3aAKxndgT3neLUNz6SIjPff4oVrmnQck36ke8iPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjCCojNlF0K3mFXWiK4iJuMe3jpoQpi/Atqrm4DauefrvubvCG3G/Pwcgf2Ahk5Z8dXbaGYZ6rgLS2ntKa/+q+j4H3vYewHKyndcx1JDOT5MuEGrd4YzIa/4vG4Q1X45DT5ysWOpQiWdZ8j4Cdul+wvv3sdtbo0j4fLzQs+BEnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s70SEgQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s70SEgQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512C9C4CEF0;
	Sun, 28 Sep 2025 06:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759039869;
	bh=gOT3aAKxndgT3neLUNz6SIjPff4oVrmnQck36ke8iPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s70SEgQCz/OiVG0Vjxg+M8f9Qq7Lt/JbpKhlVjZqvYtLNBKvuAQQI2nNhM298oSpf
	 XL9f1x1HbmnQJDESRTq4PFZEfkz62+jN7zlNSmEevXOhzo9wo/yHwLQbP4AE7rSjMD
	 PNqnK4RwkFBYyA51pdQtdYhxy+Fl5Z4r4QZlSyo0h3ETH3vuGGWM5b/kBCHHmx8WDP
	 iAR7KFjzd+7IYso2h6SgaZLcqyI1XEDjKIRXBP30ewapVN4EEiXhGhiZMkNOnMvj9z
	 npNa8TEX/q9cFMW0jzlIqig7Oeasi/fF+kJN5hCeXYqny8KjH8yjLMSoTSkQsc9bqX
	 TiuzXrzUSqMPw==
Date: Sun, 28 Sep 2025 08:11:05 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "hubert ." <hubjin657@outlook.com>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Message-ID: <bwfvyxyntorkrcg3fyjey7mbjqgrt4xx772xgkkdj64xifkbbo@ny54t3meeloo>
References: <kZ0Ndjz5Uh9rHFbs-iYYoEFNVWoxMtkvK-3nrx6mrlxpglTxelNWuY_lqxKmfrItAPWl4M4ng-BzenCqcFiOaA==@protonmail.internalid>
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>
 <7qd0IjCTUj1UpKLm2g6sPrhFI8HEoYrqIQ23o_ANTShTu58S7x7bgoMYTvXfR_fpqPdB85XxZoz16xrnllDcvA==@protonmail.internalid>
 <aNZfRuIVgIOiP6Qp@dread.disaster.area>
 <ip6g2acleif3cyslm65uzdxd47dgzfum57xxgpmk73r4223poy@shhld7q7ls7i>
 <k2WmSRFVtx7nB1UFDzxjDchWiWXHpB7iqgQdpjse19hi7nXOWfn6A5nKlf9stmEopKn16IAsArviy0SpjDfJ8Q==@protonmail.internalid>
 <aNhx0SD3zOasGhpp@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNhx0SD3zOasGhpp@dread.disaster.area>

On Sun, Sep 28, 2025 at 09:22:57AM +1000, Dave Chinner wrote:
> On Fri, Sep 26, 2025 at 03:45:17PM +0200, Carlos Maiolino wrote:
> > On Fri, Sep 26, 2025 at 07:39:18PM +1000, Dave Chinner wrote:
> > > So there must be a bounds checking bug in process_exinode():
> > >
> > > static int
> > > process_exinode(
> > >         struct xfs_dinode       *dip,
> > >         int                     whichfork)
> > > {
> > >         xfs_extnum_t            max_nex = xfs_iext_max_nextents(
> > >                         xfs_dinode_has_large_extent_counts(dip), whichfork);
> > >         xfs_extnum_t            nex = xfs_dfork_nextents(dip, whichfork);
> > >         int                     used = nex * sizeof(struct xfs_bmbt_rec);
> > >
> > >         if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> > >                 if (metadump.show_warnings)
> > >                         print_warning("bad number of extents %llu in inode %lld",
> > >                                 (unsigned long long)nex,
> > >                                 (long long)metadump.cur_ino);
> > >                 return 1;
> > >         }
> > >
> > > Can you spot it?
> > >
> > > Hint: ((2^28 + 1) * 2^4) - 1 as an int is?
> >
> > Perhaps the patch below will suffice?
> >
> > diff --git a/db/metadump.c b/db/metadump.c
> > index 34f2d61700fe..1dd38ab84ade 100644
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -2395,7 +2395,7 @@ process_btinode(
> >
> >  static int
> >  process_exinode(
> > -	struct xfs_dinode 	*dip,
> > +	struct xfs_dinode	*dip,
> >  	int			whichfork)
> >  {
> >  	xfs_extnum_t		max_nex = xfs_iext_max_nextents(
> > @@ -2403,7 +2403,13 @@ process_exinode(
> >  	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
> >  	int			used = nex * sizeof(struct xfs_bmbt_rec);
> >
> > -	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> > +	/*
> > +	 * We need to check for overflow of used counter.
> > +	 * If the inode extent count is corrupted, we risk having a
> > +	 * big enough number of extents to overflow it.
> > +	 */
> > +	if (used < nex || nex > max_nex ||
> > +	    used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> >  		if (metadump.show_warnings)
> >  			print_warning("bad number of extents %llu in inode %lld",
> >  				(unsigned long long)nex,
> >
> 
> That fixes this specific problem, but now it will reject valid
> inodes with valid but large extent counts.
> 
> What type does XFS_SB_FEAT_INCOMPAT_NREXT64 require for extent
> count calculations?  i.e. what's the size of xfs_extnum_t?

I thought about extending it to 64bit, but honestly thought it was not
necessary here as I thought the number of extents in an inode before it
was converted to btree format wouldn't exceed a 32-bit counter. That's a
trivial change for the patch, but still I think the overflow check
should still be there as even for a 64bit counter we could have enough
garbage to overflow it. Does it make sense to you?

-Carlos

> 
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
