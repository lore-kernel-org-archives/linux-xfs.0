Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254642045BC;
	Mon, 21 Apr 2025 08:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745222909; cv=none; b=nNhPZT9NHXSB96qyvqge1ShN8sEc+ERgV1pLaQkmP92H/L2tw4ATLOqTj+eW88PjLsXIjgFpJ+dm3HCBd0rjDoIx4ZsofB4tgKhHievY/0FTbba5PqeQc980cKfM+p1ieB6vqvmAbmPX0krRcYKHdIiJKnEx0H8/KapaB2lxU7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745222909; c=relaxed/simple;
	bh=4DMIXsvlkcFiKcMKbt2X37fDBwCoIRPIuWxgqzHdT7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBO88CWUJzIIp2XBVdXMOkUhOsqOhq7GNzRntJ1uuQb7pgUjyIg0V3/Vx6X89pNoq0bTeqJCEB7SlABHyfeIUgYjJcXRMaGDPHARndqCH9cBqx+YbTNDckYtaRQTI5JfjKjBZ3TV24Zd29wMU/2WC9P4wQQhLy1RPY6kr6lIouE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exqOReHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exqOReHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA398C4CEE4;
	Mon, 21 Apr 2025 08:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745222908;
	bh=4DMIXsvlkcFiKcMKbt2X37fDBwCoIRPIuWxgqzHdT7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=exqOReHInSpoPsM0krYiQDfkf87nEzI3Ubi2EKXdbDbcKjPDidTwNClfQtxMX6wPA
	 ozn89DrO2Pu2KzThMh7YhMCWwRRuawNmVpqYwej3jydKXgucnpIk5FaikP/W/3vqEh
	 D23fF//NPYgntejFFb3Mw8muCe7bZnkAzRwSGvhpxnOx5R5f6p7NZrQsZx0H9+oa3U
	 GAVRls1uwcA0VyO+HOTpIi2nOh5yXr9958urq2/4MhkDMcDqyoxtVqBnC/qgv+cgQL
	 HbNm+I1Vr3BtYvrkf5DLqVqMKtF4UNYsUUo3KCLHpZgsinbuqIJxrdrDZvm9NHexVF
	 MVlrwOQzaIl7Q==
Date: Mon, 21 Apr 2025 10:08:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, 
	Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Message-ID: <bntghvwinsfah4xq2r5yqmpemgs6hqyilascl4zwnh2vm6og2c@fcaypngp64cy>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
 <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid>
 <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
 <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
 <CGBuRmwlHYtQLQhMGGNldfbkiOB6TFkyzyKlWXmQIED91j9O6JH1391_9nwxfIiZibfKL2vK6r25kNZcS4RdAQ==@protonmail.internalid>
 <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
 <wpblwpuv6fbfqndbxi7y352axtykhevyqpg67d4q2eepogon7j@2hjqvzrzzknb>
 <xBFJpCq9dta4mWmTXkeMDXcKHjntFRocNE0lt4n2lvFMolQNJlHo_nJNryWiMldMafQbsfSRm_52Ox04U2_W_A==@protonmail.internalid>
 <67c0a5f9-3349-4910-85f9-a017b6499dd3@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67c0a5f9-3349-4910-85f9-a017b6499dd3@roeck-us.net>

On Sun, Apr 20, 2025 at 12:13:34PM -0700, Guenter Roeck wrote:
> On 4/20/25 11:07, Carlos Maiolino wrote:
> ...
> >>
> >> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> >> index 8c541ca71872..6dde2a680e75 100644
> >> --- a/fs/xfs/xfs_zone_gc.c
> >> +++ b/fs/xfs/xfs_zone_gc.c
> >> @@ -170,7 +170,7 @@ bool
> >>    xfs_zoned_need_gc(
> >>           struct xfs_mount        *mp)
> >>    {
> >> -       s64                     available, free;
> >> +       u64                     available, free, rem;
> >>
> >>           if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
> >>                   return false;
> >> @@ -183,7 +183,12 @@ xfs_zoned_need_gc(
> >>                   return true;
> >>
> >>           free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> >> -       if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
> >> +
> >> +       rem = do_div(free, 100);
> >> +       free = free * mp->m_zonegc_low_space +
> >> +               div_u64(rem * mp->m_zonegc_low_space, 100);
> >> +
> >> +       if (available < free)
> >>                   return true;
> >
> > You're essentially open coding mult_frac(), if we can get mult_frac() to work
> > on 64-bit too (or add a 64-bit version), that seems a better generic solution.
> >
> 
> Yes, I know. Problem is that getting more than one maintainer involved tends to make
> it exponentially more difficult to get anything accepted. With that in mind, I prefer
> open coded solutions like the one I suggested above. A generic solution is then still
> possible, but it is disconnected from solving the immediate problem.
> 

I think this is fair for the moment, unless Hans/Christoph have a better idea?!

> Guenter
> 
