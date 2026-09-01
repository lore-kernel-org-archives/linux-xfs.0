Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CFB1DF980
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 08:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251278; cv=none; b=Z/NggOAzPXFBn/4OMhVXtJe72u6ljuc7Uv1Zxmd3ny/NPSxG2AFOHPQcq+RBBTbe2uTmfinSgjS8SDFkAPJLSJzGIrNh84S1ZMS27VOKYG9BLc8Jgntz7G2my+0+j1StzI3p4E9HjFSSM4qdtQenl1WEkXADpE4KJETgXeJnjME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251278; c=relaxed/simple;
	bh=DHipKYKODJw6RA1+ObmH6JOvyPgJon25vsiZF/UYL6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKCBFDKkJgGT6G+zlSBnnkEtyxoDHpYPuv+Yv3qK6Ejx6ShgyE4TjkFNuAWMIq/YbjOj/cmbUj+pn8XeI0MH+SyaE4r5CgseGEp7EpaAPQyyqQIaZ4KDa2CMhQjBzItk8MFnOyYVnRkGuqRrQTacLEvyfRxKEoPhiQnT3Ic1PG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CfyGC9Mx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfyGC9Mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA921F000E9;
	Tue,  1 Sep 2026 08:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788251276;
	bh=+h735eYwRAWwZyaNh0NXY97WBIyquCPnhelAzj3vYH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CfyGC9MxEmnMSLAwTK2sRIJct8Vsn5UpoxIx4Pfstqu9GZn3jfg+gQSpwvxAcXDI+
	 JuJBGuNdSkRrROhQjHi7228tECcZDKKmMkLMK7+dVmRiTeT1R5MZ459ZNYCsAMXzES
	 YJAcs36Wh7A4h2saqrOhO5d4aPJUyKmwp5zDuHbkLd72BcJa7mwcePzf3ngwpglXMS
	 dHw3C7KuCyfyg+Op1PG5+LeWHHsJopBHIDUeWNOfYQqesv04wFvFumXnI7UVr596g7
	 4PDacatA74ANjXpIXVnn5yNk75orbU0LjxFja1OjLNzD0a449kpulwoQl6aQ9RwtVE
	 2CHc2xzpbxYHQ==
Date: Tue, 1 Sep 2026 10:27:51 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org, 
	dlemoal@kernel.org, shinichiro.kawasaki@wdc.com, sashiko-bot@kernel.org
Subject: Re: [PATCH] xfs: prevent race in zoned space reservations
Message-ID: <apaMXvIq-1eKE7s_@andromeda.toxiclabs.cc>
References: <20260826123219.73978-1-hans.holmberg@wdc.com>
 <apUqKvNgd1Onghg2@andromeda.toxiclabs.cc>
 <b1cb1564-9ac0-4b34-8526-d5e2b455d757@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1cb1564-9ac0-4b34-8526-d5e2b455d757@wdc.com>

On Tue, Sep 01, 2026 at 09:07:21AM +0200, Hans Holmberg wrote:
> On 31/08/2026 09:19, Carlos Maiolino wrote:
> > On Wed, Aug 26, 2026 at 02:32:19PM +0200, Hans Holmberg wrote:
> >> xfs_zoned_add_available() checks whether the reservation list is empty
> >> before adding blocks to the available-space counter.  This check is not
> >> serialized against a task adding itself to the reservation list however.
> >>
> >> This allows the space provider to observe an empty list, after which a
> >> reserver can enqueue itself and retry the counter before the new space is
> >> added.  The provider then adds the space and returns without waking the
> >> now-eligible reserver, leaving it asleep until GC or another event
> >> provides a wakeup, potentially adding seconds to max write latency.
> >>
> >> Take the reservation lock before updating the counter and checking the
> >> list.  Use list_empty() because the list is now inspected under its lock.
> >>
> >> Taking a per-mount lock when handing back space is far from ideal, but
> >> benchmarking with null_blk showed no measurable performance regression.
> >>
> >> Fixes: 0bb2193056b5 ("xfs: add support for zoned space reservations")
> >> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >> Closes: https://sashiko.dev/#/patchset/20260609075655.1698743-1-hch@lst.de?part=2
> >> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> >> ---
> >>  fs/xfs/xfs_zone_space_resv.c | 8 ++++----
> >>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> >> index 5c6e6ef627e4..7aa3c74fb2e0 100644
> >> --- a/fs/xfs/xfs_zone_space_resv.c
> >> +++ b/fs/xfs/xfs_zone_space_resv.c
> >> @@ -85,13 +85,13 @@ xfs_zoned_add_available(
> >>  	struct xfs_zone_info		*zi = mp->m_zone_info;
> >>  	struct xfs_zone_reservation	*reservation;
> >>  
> >> -	if (list_empty_careful(&zi->zi_reclaim_reservations)) {
> >> -		xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
> >> +	spin_lock(&zi->zi_reservation_lock);
> >> +	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
> >> +	if (list_empty(&zi->zi_reclaim_reservations)) {
> >> +		spin_unlock(&zi->zi_reservation_lock);
> >>  		return;
> >>  	}
> >>  
> >> -	spin_lock(&zi->zi_reservation_lock);
> >> -	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
> >>  	count_fsb = xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE);
> >>  	list_for_each_entry(reservation, &zi->zi_reclaim_reservations, entry) {
> >>  		if (reservation->count_fsb > count_fsb)
> > 
> > Looks good to me:
> > 
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > 
> > FWIW, don't xfs_zoned_reserve_available() might have a similar problem
> > when decreasing the free counter? I'm not that much literate on zoned,
> > but a quick look seemed reserving space might hit a similar problem?!
> > 
> 
> It's a good question, in xfs_zoned_reserve_available, a writer could
> theoretically race and skip ahead of another writer that was lining up
> to wait for available space.
> 
> So while xfs_zoned_reserve_available is not guaranteed to be 100% fair,
> I think the alternative (adding the lock on the reserve path) is too costly. 

Oh, thanks for looking into it. I certainly didn't think about the costs
implied here!
