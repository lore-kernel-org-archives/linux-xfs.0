Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29B463D;
	Sun, 20 Apr 2025 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745172479; cv=none; b=YcQn5mKKg6LnnOWOndT3YMBs16JU8i3o4U1j7oJ9eRRk9jDQuK9gDnF5PB16dSEd0ZRS+pxEh4o+J5BrJ1piBiNmGmLmZ6v7B0T0TTDcfwf22iuoBOfnKbAJvU9jcBNo6huKvNuQvtVFmXn70zUwZbvrL2Cg0GLYDdSAABUXijI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745172479; c=relaxed/simple;
	bh=E/WMo/2meT4Q6nRVgRgIsz+Ztko21pEAwIer8dQvQgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEUb4xLDqqbHDV/RQ+FTz/X5MVKwc3KCLUh8Q7x7P+A2ogEugwXYwntVs3X6Z//6k6hvheKYrEgqfz5/BV+m2C7FCJkXwrlOuFCzAepQB5RhZQfeFP4deWVQeYPj6VHOOLmwxlw+lgTnfw3kdVrD2HqQ60D+IlN3a1c4zQv6fQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f30Ns+W+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f30Ns+W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD64C4CEE2;
	Sun, 20 Apr 2025 18:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745172478;
	bh=E/WMo/2meT4Q6nRVgRgIsz+Ztko21pEAwIer8dQvQgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f30Ns+W+ZGQv65U8FCDVFwB/nZkPUOBTkLOqKl7ZD1BxPhtdMid/UClFSpQ0zuavT
	 Fe1joPVUkJLGWAkZLJSPHfpkObtSTkrMVHkozfVVUh5IfJozzwHZQWq/AsRGoScto5
	 2XgKEQcOk3SCvvi3aWpPXi/kg608z57ELxXMruOsdiUC0+mCnmR3NM74swVbJ4PgQx
	 8x9sXGHXRLEo2ssQXXgzrZpgVyySHvgSujKJhv7GkFTArvZ1u+FW3eaQwGLT8O+AjO
	 C/RKnfh9TKbraQ+nyduzdO5CzdwqTFGcYZFfbmiKyo88S4wE2zGVdIWW7ALrVOfgnb
	 ijCYIVr+bTdww==
Date: Sun, 20 Apr 2025 20:07:51 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, 
	Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Message-ID: <wpblwpuv6fbfqndbxi7y352axtykhevyqpg67d4q2eepogon7j@2hjqvzrzzknb>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
 <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid>
 <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
 <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
 <CGBuRmwlHYtQLQhMGGNldfbkiOB6TFkyzyKlWXmQIED91j9O6JH1391_9nwxfIiZibfKL2vK6r25kNZcS4RdAQ==@protonmail.internalid>
 <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>

On Sun, Apr 20, 2025 at 10:42:56AM -0700, Guenter Roeck wrote:
> On 4/20/25 03:53, Carlos Maiolino wrote:
> > On Sun, Apr 20, 2025 at 02:47:02AM -0700, Guenter Roeck wrote:
> >> On Tue, Mar 25, 2025 at 09:10:49AM +0000, Hans Holmberg wrote:
> >>> Presently we start garbage collection late - when we start running
> >>> out of free zones to backfill max_open_zones. This is a reasonable
> >>> default as it minimizes write amplification. The longer we wait,
> >>> the more blocks are invalidated and reclaim cost less in terms
> >>> of blocks to relocate.
> >>>
> >>> Starting this late however introduces a risk of GC being outcompeted
> >>> by user writes. If GC can't keep up, user writes will be forced to
> >>> wait for free zones with high tail latencies as a result.
> >>>
> >>> This is not a problem under normal circumstances, but if fragmentation
> >>> is bad and user write pressure is high (multiple full-throttle
> >>> writers) we will "bottom out" of free zones.
> >>>
> >>> To mitigate this, introduce a zonegc_low_space tunable that lets the
> >>> user specify a percentage of how much of the unused space that GC
> >>> should keep available for writing. A high value will reclaim more of
> >>> the space occupied by unused blocks, creating a larger buffer against
> >>> write bursts.
> >>>
> >>> This comes at a cost as write amplification is increased. To
> >>> illustrate this using a sample workload, setting zonegc_low_space to
> >>> 60% avoids high (500ms) max latencies while increasing write
> >>> amplification by 15%.
> >>>
> >> ...
> >>>   bool
> >>>   xfs_zoned_need_gc(
> >>>   	struct xfs_mount	*mp)
> >>>   {
> >>> +	s64			available, free;
> >>> +
> >> ...
> >>> +
> >>> +	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> >>> +	if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
> >>> +		return true;
> >>> +
> >>
> >> With some 32-bit builds (parisc, openrisc so far):
> >>
> >> Error log:
> >> ERROR: modpost: "__divdi3" [fs/xfs/xfs.ko] undefined!
> >> ERROR: modpost: "__umoddi3" [fs/xfs/xfs.ko] undefined!
> >> ERROR: modpost: "__moddi3" [fs/xfs/xfs.ko] undefined!
> >> ERROR: modpost: "__udivdi3" [fs/xfs/xfs.ko] undefined!
> >>
> >
> > I opened a discussion about this:
> >
> > https://lore.kernel.org/lkml/20250419115157.567249-1-cem@kernel.org/
> 
> A possible local solution is below. Note the variable type change from s64 to u64.
> 
> Guenter
> ---
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 8c541ca71872..6dde2a680e75 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -170,7 +170,7 @@ bool
>   xfs_zoned_need_gc(
>          struct xfs_mount        *mp)
>   {
> -       s64                     available, free;
> +       u64                     available, free, rem;
> 
>          if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
>                  return false;
> @@ -183,7 +183,12 @@ xfs_zoned_need_gc(
>                  return true;
> 
>          free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> -       if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
> +
> +       rem = do_div(free, 100);
> +       free = free * mp->m_zonegc_low_space +
> +               div_u64(rem * mp->m_zonegc_low_space, 100);
> +
> +       if (available < free)
>                  return true;

You're essentially open coding mult_frac(), if we can get mult_frac() to work
on 64-bit too (or add a 64-bit version), that seems a better generic solution.


> 
>          return false;
> 
> 
