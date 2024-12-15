Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513E2154BEA
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734288168; cv=none; b=ZcrKbv1oH4i96NRxwxmPKWkWkSNkpnXlw2HfFhptm6nn1E88L2/pEobsxZ2K1OsLtPkqgd/ncvXjKsqKULINGWxLM7GNmvVNAmdiKNxZWQh/JU+1Q+2sWHqnL4L6EHOMzaE3PDH/iX62D94rBcR/+P905a9pO2uv2x/hyfiWBrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734288168; c=relaxed/simple;
	bh=/X9DqBzH/Vh9nkjFOAdRijeNaW6etnFHPuzvTrKcwWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCh3o6+630c4uAl4uluD3/UzqhsYLEo0L0S9N2ubCDoNuCPhrbPxJOa0qYl1jMDIqUaAR1iArWLng4ZcYLtzHb85bjcphuZAFRWwsNwOnloNY00W7tqJdGnzJIkTVpAJOWo64w/lGto5IiloB5ma2G/UZW33mhuacSxtJg8nh3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnwVucvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnwVucvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B830CC4CECE;
	Sun, 15 Dec 2024 18:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734288167;
	bh=/X9DqBzH/Vh9nkjFOAdRijeNaW6etnFHPuzvTrKcwWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JnwVucvF5mlKHkMntUy/JWCcQece0Ciu4oxQFxqwbH4QWHlsCnhxpoCcdLSxlIMR2
	 rnrXf3EF/z/LnV1yzh5OoOYq6YCws1y9YBryqIJOXaNmiTIe6gPW8OeMEIlfjVAAHO
	 SxJHqlyB+nkeO6eHSw8F0qb6GLLvRCRX9v9kmxmqjIhsKqS/54YH79TUOtI6bH4QrM
	 nrpaCQUrKtYk1h/vthvtWqnjKlEDAoU+doU92r45PWTAx8+yBk3IGxgiNoGDZA9226
	 y4Do92+HbZhdFZrb9HUawQr6TlAFwHTNUYv8tiWRTg4bdFgZc7sb2m9/TuyBgv9RV/
	 y+QudmI5cqJLw==
Date: Sun, 15 Dec 2024 10:42:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <hans@owltronix.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/43] xfs: preserve RT reservations across remounts
Message-ID: <20241215184247.GD6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-11-hch@lst.de>
 <20241212213833.GV6678@frogsfrogsfrogs>
 <CANr-nt0QY-8Dwh2Vj_US4ZYBXB1Y1jF=Ms3G0ALM2wS=MopAbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANr-nt0QY-8Dwh2Vj_US4ZYBXB1Y1jF=Ms3G0ALM2wS=MopAbA@mail.gmail.com>

On Fri, Dec 13, 2024 at 10:15:25AM +0100, Hans Holmberg wrote:
> On Thu, Dec 12, 2024 at 10:38 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Wed, Dec 11, 2024 at 09:54:35AM +0100, Christoph Hellwig wrote:
> > > From: Hans Holmberg <hans.holmberg@wdc.com>
> > >
> > > Introduce a reservation setting for rt devices so that zoned GC
> > > reservations are preserved over remount ro/rw cycles.
> > >
> > > Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_mount.c | 22 +++++++++++++++-------
> > >  fs/xfs/xfs_mount.h |  3 ++-
> > >  fs/xfs/xfs_super.c |  2 +-
> > >  3 files changed, 18 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index 4174035b2ac9..db910ecc1ed4 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -465,10 +465,15 @@ xfs_mount_reset_sbqflags(
> > >  }
> > >
> > >  uint64_t
> > > -xfs_default_resblks(xfs_mount_t *mp)
> > > +xfs_default_resblks(
> > > +     struct xfs_mount        *mp,
> > > +     enum xfs_free_counter   ctr)
> > >  {
> > >       uint64_t resblks;
> > >
> > > +     if (ctr == XC_FREE_RTEXTENTS)
> > > +             return 0;
> > > +
> > >       /*
> > >        * We default to 5% or 8192 fsbs of space reserved, whichever is
> > >        * smaller.  This is intended to cover concurrent allocation
> > > @@ -683,6 +688,7 @@ xfs_mountfs(
> > >       uint                    quotamount = 0;
> > >       uint                    quotaflags = 0;
> > >       int                     error = 0;
> > > +     int                     i;
> > >
> > >       xfs_sb_mount_common(mp, sbp);
> > >
> > > @@ -1051,18 +1057,20 @@ xfs_mountfs(
> > >        * privileged transactions. This is needed so that transaction
> > >        * space required for critical operations can dip into this pool
> > >        * when at ENOSPC. This is needed for operations like create with
> > > -      * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
> > > -      * are not allowed to use this reserved space.
> > > +      * attr, unwritten extent conversion at ENOSPC, garbage collection
> > > +      * etc. Data allocations are not allowed to use this reserved space.
> > >        *
> > >        * This may drive us straight to ENOSPC on mount, but that implies
> > >        * we were already there on the last unmount. Warn if this occurs.
> > >        */
> > >       if (!xfs_is_readonly(mp)) {
> > > -             error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS,
> > > -                             xfs_default_resblks(mp));
> > > -             if (error)
> > > -                     xfs_warn(mp,
> > > +             for (i = 0; i < XC_FREE_NR; i++) {
> > > +                     error = xfs_reserve_blocks(mp, i,
> > > +                                     xfs_default_resblks(mp, i));
> > > +                     if (error)
> > > +                             xfs_warn(mp,
> > >       "Unable to allocate reserve blocks. Continuing without reserve pool.");
> >
> > Should we be able to log *which* reserve block pool is out?
> 
> Yep, that should be useful I think. We could do something like this:

Yeah, that looks good to me.

--D

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 20d564b3b564..6ef69d025f9a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -674,6 +674,10 @@ xfs_rtbtree_compute_maxlevels(
>         mp->m_rtbtree_maxlevels = levels;
>  }
> 
> +static const char * const xfs_free_pool_name[XC_FREE_NR] = {
> +               "free blocks", "free rt extents", "available rt extents"
> +};
> +
>  /*
>   * This function does the following on an initial mount of a file system:
>   *     - reads the superblock from disk and init the mount struct
> @@ -1081,7 +1085,8 @@ xfs_mountfs(
>                                         xfs_default_resblks(mp, i));
>                         if (error)
>                                 xfs_warn(mp,
> -       "Unable to allocate reserve blocks. Continuing without reserve pool.");
> +"Unable to allocate reserve blocks. Continuing without reserve pool for %s.",
> +                               xfs_free_pool_name[i]);
>                 }
> 
>                 /* Reserve AG blocks for future btree expansion. */
> 
