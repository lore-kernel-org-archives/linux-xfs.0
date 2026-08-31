Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561E71F16B
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 07:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788160780; cv=none; b=LxRfIBgPb08XQRT0U8GAFWrlcC46Lr/kCive94FtWrZDu1QpIUJe9xSPjHGqp2UDqUP29dvoufrxGPykMHAK9T3+Yf2YSLwsalmu/8gJC9Z6s3iqTCu4hQ17TCZ4uxdsQ5SnTcnbDYcSzmikreawZX77TN+IrEe8gsyu9myxIjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788160780; c=relaxed/simple;
	bh=HOEr6muehD357AbkHRxfhSbmSXuJiWMeHJ870ePPwfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qM/u0QJmQ3yFLzGVYMrToHqx9rXcEhLz6yMzvB0No8c6eonvnSxy6Hiv1ZctXjFo4Dk+aRnlsYjjmprNlfYTspJouITS67+XAEXvV8bSTRRsO7ucfTuikByUhR6Kb6IwBtUP4s38Nksms3Dc8xDR9bj/klt9qZ8GO3GH6t2UyG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSSoXil8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSSoXil8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3904A1F000E9;
	Mon, 31 Aug 2026 07:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788160779;
	bh=ZDPuazZGFzglgUbyOqPijxi9dH3geIfmt4uuXXHDnEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jSSoXil82B6Ncnv+dd8gxnSDuURI9MUpIkjr+BaeP2QFOMAC2QeIjTa678Q6em+1E
	 46hbCpv5tS8v3MsCQxc0RQ9SpSLeHH0AmFUWcuFKOPkdhM6/ALHEG3JJV+s+qr0UdI
	 BnbApGLN6NPQ8AAT+4LnZQMOdRX0tvXhDhMDD37Ew9JkWLawqTs4QjKmmpvI1KABS4
	 e58YSySBmLP++ByPVxYY4+mn9GVBmGtOevQXJ9E8mKiRWoQJ4yMFPIvGwWV0izb26l
	 yn+vkJ0R4nuc6foT3t/1AqIlS2RotG1puhUzYE0GLqR1SDWhNudelMrcjBT72qaRnA
	 Pue8sJ8Kxovuw==
Date: Mon, 31 Aug 2026 09:19:34 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org, 
	dlemoal@kernel.org, shinichiro.kawasaki@wdc.com, sashiko-bot@kernel.org
Subject: Re: [PATCH] xfs: prevent race in zoned space reservations
Message-ID: <apUqKvNgd1Onghg2@andromeda.toxiclabs.cc>
References: <20260826123219.73978-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826123219.73978-1-hans.holmberg@wdc.com>

On Wed, Aug 26, 2026 at 02:32:19PM +0200, Hans Holmberg wrote:
> xfs_zoned_add_available() checks whether the reservation list is empty
> before adding blocks to the available-space counter.  This check is not
> serialized against a task adding itself to the reservation list however.
> 
> This allows the space provider to observe an empty list, after which a
> reserver can enqueue itself and retry the counter before the new space is
> added.  The provider then adds the space and returns without waking the
> now-eligible reserver, leaving it asleep until GC or another event
> provides a wakeup, potentially adding seconds to max write latency.
> 
> Take the reservation lock before updating the counter and checking the
> list.  Use list_empty() because the list is now inspected under its lock.
> 
> Taking a per-mount lock when handing back space is far from ideal, but
> benchmarking with null_blk showed no measurable performance regression.
> 
> Fixes: 0bb2193056b5 ("xfs: add support for zoned space reservations")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260609075655.1698743-1-hch@lst.de?part=2
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
>  fs/xfs/xfs_zone_space_resv.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> index 5c6e6ef627e4..7aa3c74fb2e0 100644
> --- a/fs/xfs/xfs_zone_space_resv.c
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -85,13 +85,13 @@ xfs_zoned_add_available(
>  	struct xfs_zone_info		*zi = mp->m_zone_info;
>  	struct xfs_zone_reservation	*reservation;
>  
> -	if (list_empty_careful(&zi->zi_reclaim_reservations)) {
> -		xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
> +	spin_lock(&zi->zi_reservation_lock);
> +	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
> +	if (list_empty(&zi->zi_reclaim_reservations)) {
> +		spin_unlock(&zi->zi_reservation_lock);
>  		return;
>  	}
>  
> -	spin_lock(&zi->zi_reservation_lock);
> -	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
>  	count_fsb = xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE);
>  	list_for_each_entry(reservation, &zi->zi_reclaim_reservations, entry) {
>  		if (reservation->count_fsb > count_fsb)

Looks good to me:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

FWIW, don't xfs_zoned_reserve_available() might have a similar problem
when decreasing the free counter? I'm not that much literate on zoned,
but a quick look seemed reserving space might hit a similar problem?!

Cheers.

> -- 
> 2.43.0
> 
