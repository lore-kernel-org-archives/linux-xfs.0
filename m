Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BA42ED853
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 10:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165138; cv=none; b=XJmdKLOY75I0QvK1ZXvA4xJ3ZSmcsxctxVyRrrC7gwNH9j/ayZ7bFY/gjdRWe6CVRE+y3e5TnUjNCDvEwwZaAkJ3VKspGr5xbSIuBMe3kjcbFKPly8/s6BTVLrjb2EX0QYWQ3h1Ej/aieDV0bU6DZuaXdGvoFA4E8EIOqvJZvlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165138; c=relaxed/simple;
	bh=jWL9qh7zUmJ537R0bKsCk5qyW/Fj2/wnrO7wMOiayLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/pZf+I4SCrrUeYX70/ugNO4LTnjxj2KLZfDXydpRM/xadrH5mWn0uWqj4VGOwo+haDAfiGjGIJuOhKZk8KqTk28SWQ0w7xeIzxInZBrCGwyJ3vImoTcZGlKV5237aR6AlgIedDZkmbVnRldw5B5S7uOja5nqKVnpN2A/jiJUd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UE2vpn6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UE2vpn6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F33FC4CEE7;
	Mon,  3 Nov 2025 10:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762165137;
	bh=jWL9qh7zUmJ537R0bKsCk5qyW/Fj2/wnrO7wMOiayLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UE2vpn6afltYM9svlhNEO+I9iVwD722ODR9/5SHUn5iCoQ8uMVoPaUdS5/lIfSblC
	 FVIaBKNzV12C+4Jo5O0qnVHDnAoOXIoRZKGVrVImchHt8kTDLncfLFLSvkGreq4HAn
	 OjEF0xVccxABjvLzJa1O80R1Hy/fSMVN1R2SgxdEfwoiz/ll+WV86txJl4/1uX1CyZ
	 oi8INTWwmu+JX5Iir4ogMwOeuLjkLQ9Yozxhc1N/9uh0/3Oc5HpOQkiRr9LovD1Jc4
	 9jJ7kK04oaObZZ2o1vWPhjpIWpNxwXtQlYHoYHPXotA6tp7HpG6V+FOUlceoB4k4M7
	 bY/XWu3wuE2+Q==
Date: Mon, 3 Nov 2025 11:18:52 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "hubert ." <hubjin657@outlook.com>
Cc: Dave Chinner <david@fromorbit.com>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Message-ID: <udxfjn4ybistaf6whay6kw3a7urqk6j4ftmxgrpyxsvr5fhu5m@mk3pdxjdxakd>
References: <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>
 <7qd0IjCTUj1UpKLm2g6sPrhFI8HEoYrqIQ23o_ANTShTu58S7x7bgoMYTvXfR_fpqPdB85XxZoz16xrnllDcvA==@protonmail.internalid>
 <aNZfRuIVgIOiP6Qp@dread.disaster.area>
 <ip6g2acleif3cyslm65uzdxd47dgzfum57xxgpmk73r4223poy@shhld7q7ls7i>
 <k2WmSRFVtx7nB1UFDzxjDchWiWXHpB7iqgQdpjse19hi7nXOWfn6A5nKlf9stmEopKn16IAsArviy0SpjDfJ8Q==@protonmail.internalid>
 <aNhx0SD3zOasGhpp@dread.disaster.area>
 <bwfvyxyntorkrcg3fyjey7mbjqgrt4xx772xgkkdj64xifkbbo@ny54t3meeloo>
 <aNuhP-zyhfy34AT9@dread.disaster.area>
 <rja0fHh6sTLaEoz364LuhyL1gwkr6t20Ks81zzwb2Xex4UlaPgMQhcJ60W8yV2qegppIJIrFgliAZixRufVi6A==@protonmail.internalid>
 <IA0PR05MB997593D825A2E104BF85DB5AFAC7A@IA0PR05MB9975.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA0PR05MB997593D825A2E104BF85DB5AFAC7A@IA0PR05MB9975.namprd05.prod.outlook.com>

On Mon, Nov 03, 2025 at 09:23:08AM +0000, hubert . wrote:
> >>>> On Fri, Sep 26, 2025 at 07:39:18PM +1000, Dave Chinner wrote:
> >>>>> So there must be a bounds checking bug in process_exinode():
> >>>>>
> >>>>> static int
> >>>>> process_exinode(
> >>>>>         struct xfs_dinode       *dip,
> >>>>>         int                     whichfork)
> >>>>> {
> >>>>>         xfs_extnum_t            max_nex = xfs_iext_max_nextents(
> >>>>>                         xfs_dinode_has_large_extent_counts(dip), whichfork);
> >>>>>         xfs_extnum_t            nex = xfs_dfork_nextents(dip, whichfork);
> >>>>>         int                     used = nex * sizeof(struct xfs_bmbt_rec);
> >>>>>
> >>>>>         if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> >>>>>                 if (metadump.show_warnings)
> >>>>>                         print_warning("bad number of extents %llu in inode %lld",
> >>>>>                                 (unsigned long long)nex,
> >>>>>                                 (long long)metadump.cur_ino);
> >>>>>                 return 1;
> >>>>>         }
> >>>>>
> >>>>> Can you spot it?
> >>>>>
> >>>>> Hint: ((2^28 + 1) * 2^4) - 1 as an int is?
> >>>>
> >>>> Perhaps the patch below will suffice?
> >>>>
> >>>> diff --git a/db/metadump.c b/db/metadump.c
> >>>> index 34f2d61700fe..1dd38ab84ade 100644
> >>>> --- a/db/metadump.c
> >>>> +++ b/db/metadump.c
> >>>> @@ -2395,7 +2395,7 @@ process_btinode(
> >>>>
> >>>>  static int
> >>>>  process_exinode(
> >>>> - struct xfs_dinode       *dip,
> >>>> + struct xfs_dinode       *dip,
> >>>>   int                     whichfork)
> >>>>  {
> >>>>   xfs_extnum_t            max_nex = xfs_iext_max_nextents(
> >>>> @@ -2403,7 +2403,13 @@ process_exinode(
> >>>>   xfs_extnum_t            nex = xfs_dfork_nextents(dip, whichfork);
> >>>>   int                     used = nex * sizeof(struct xfs_bmbt_rec);
> >>>>
> >>>> - if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> >>>> + /*
> >>>> +  * We need to check for overflow of used counter.
> >>>> +  * If the inode extent count is corrupted, we risk having a
> >>>> +  * big enough number of extents to overflow it.
> >>>> +  */
> >>>> + if (used < nex || nex > max_nex ||
> >>>> +     used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> >>>>           if (metadump.show_warnings)
> >>>>                   print_warning("bad number of extents %llu in inode %lld",
> >>>>                           (unsigned long long)nex,
> >>>>
> >>>
> >>> That fixes this specific problem, but now it will reject valid
> >>> inodes with valid but large extent counts.
> >>>
> >>> What type does XFS_SB_FEAT_INCOMPAT_NREXT64 require for extent
> >>> count calculations?  i.e. what's the size of xfs_extnum_t?
> >>
> >> I thought about extending it to 64bit, but honestly thought it was not
> >> necessary here as I thought the number of extents in an inode before it
> >> was converted to btree format wouldn't exceed a 32-bit counter.
> >
> > The filesystem is corrupt so the normal rules of sanity don't apply.
> > The extent count could be anything, and we can't assume that it fits
> > in a 32 bit value, nor that any unchecked calculation based on the
> > value fits in 32 bits.
> >
> > Mixing integer types like this always leads to bugs. It's bad
> > practice because everyone who looks at the code has to think about
> > type conversion rules (which no-one ever remembers or gets right) to
> > determine if the code is correct or not. Nobody catches stuff
> > like this during review and the compiler is no help, either.
> >
> >> That's a
> >> trivial change for the patch, but still I think the overflow check
> >> should still be there as even for a 64bit counter we could have enough
> >> garbage to overflow it. Does it make sense to you?
> >
> > Yes, we need to check for overflow, but IMO, the best way to do
> > these checks is to use the same type (and hence unsigned 64 bit
> > math) throughout. This requires much less metnal gymnastics to
> > determine that it is obviously correct:
> >
> > ....
> >         xfs_extnum_t            used = nex * sizeof(struct xfs_bmbt_rec);
> >
> >         // number of extents clearly bad
> >         if (nex > max_nex)
> >                 goto warn;
> >
> >         // catch extent array size overflow
> >         if (used < nex)
> >                 goto warn;
> >
> >         // extent array should fit in the inode fork
> >         if (used > XFS_DFORK_SIZE(dip, mp, whichfork))
> >                 goto warn;
> 
> Dear Carlos, dear Dave,
> 
> Sorry for the late reply and thank you so much for looking into this.
> Not sure if there is something else you would change here, but the patch
> Carlos proposed worked for me and the metadump completed with no
> issues.
> Things got really busy since my last message, but I still wanted to
> belatedly thank you both for your time and expert help.

I'll wriet a formal patch for this soon. Just couldn't get to it yet on
my TODO.

Cheers.

> 
> Best,
> Hub
> >
> >
> > -Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
