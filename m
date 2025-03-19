Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D237D2528E7
	for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 09:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742375512; cv=none; b=gNveNwnbScA2Zl4xvTWQvJGFot0MY63DTmsP0WU2oUc0rSFkHV22iMCGB/dnAsui0lH448GIBbUzylGPLcaDMSEdLjo71pD09Pvl85+UzxM1sV/u0JNtjMmKWpLUC9Tt0DGTeJCllr6/SHtd0ogBKfp/M3PrPuM02HkHOkD5Ayo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742375512; c=relaxed/simple;
	bh=ZsDBsBTdPC3Vc3+95kLCasXgWvgIUmltgKjuAXyM/Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xmo7lcT6hDHljE21uCaDjJIUwP2hWShdowyGeZRyq8k7HcamUfW5QUsZJ2O4R1H+2QF5MUvY6SfnoplUM2Sf9Af9SLFXAkqYYrdL5YgXddw1XHlB5shHOmkJE9vmrZBZHZU26U2eu3YTQY9YluTK2r5h+4yBUo/NGnmb2+iLsVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=aonJuYQG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="aonJuYQG"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22622ddcc35so15598845ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 02:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1742375510; x=1742980310; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lS4VbEEXUkPnZ8cL6kavr7ndmUE7F3pUXuDlK1TnAJM=;
        b=aonJuYQG/OvUIiuRE5j3XmqQmoF8deBVMboW1WYm+t7uQptUhSSXHCSkO54/RNcHYX
         O9F302rjGAQrMzddeSkuxCGaphbbBJrg6t3pt7PpxfTafTJkgulbkfnUopVxJC8NH47W
         bBaIaxrH+LMS0+NFO2KWBe43dG4DBGL/Eq+JJd/iHBZTMwyiKqNitT9CWYiBm8lDWIZl
         VchYSfdz7b88QSZLzyPmNtzElj0R3VpmhuN0COSZhZbUz4lMpz4+mNcS1xVrLLlfFtL8
         27Rqh2ncjelVCJus+xJ3Tv842DO37zghLqKip7w1RKoI7Dj6xHkNpj2oSXc25ryKOnVw
         zKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742375510; x=1742980310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lS4VbEEXUkPnZ8cL6kavr7ndmUE7F3pUXuDlK1TnAJM=;
        b=ECw/35VbHSbKOdnYk8iKkB4jURlKdXcc+TLfS4wbcWxsDCmn1RRSK2pZuHIwA3yck3
         NNB1OYbaGyz4X9t+Ga8rWUOSBLekb0rVEREhg87JyDwez5BuUeabBwZyqjmzR6UtSf72
         bkvL/TrfvhV3WINGmXGc08Q276fRIVJtfdEVkLnRt8Zjr7AfScGv5CmJk9dTrBtp8Xqx
         XZDofC4RAArMQ2Ys+8k0jyYSuqkR1i4MSz5KQLnQbJephZ86jWTDwjsnDBwwFuA2xrka
         5HLwPEUkP2YNiP+gos+FcVPy8iNTQe9uu2CHuf27hoQoRYls6qagJ7hOOQ5/rYZJb1cn
         4EmA==
X-Gm-Message-State: AOJu0YzVNyA6Sm0AEjMzpCajCvV+9fZOvmHQzVSo8X1IqliTOw9YXRPb
	+LyizVmX+6iMFroLZZEHDHMFkhwF+KkWIXpSrYxcAadL+N+n/3cNWiF4biOq9M3KvZSSVfvFnfn
	f
X-Gm-Gg: ASbGnctvd69hCMuB4Lh9d5SHfWaY+K/ysrzO5r/4edYeYtg7GYBQdl6Lz/s8T1ddcek
	tzFe+r9sLM8S7KMMU4Mjk1kOaiuAssQcW4jtukWHxmi51aGm5ndvqSRHJOEnWjOnLJifGhEzeR3
	hcmqUSXkOhIvg+lR9MsJgtTkZRuJ/1J1EtJrqtMyU3LlvU7oyz6YXbOn6qj8mv2eWC0KuHKFzFZ
	wYCK2PvsuRgHIb2EV5ED+kIN7ftAHP8wrjQpq0zxK3nkQpYErATn3FlAedMEEwKdk3hwiMf2Fet
	8Dm2axVh7yllzGtjAuq0M1m2JngkgOqH7stoQuTUeapDObk+SHfDSxCuIVm+GG2tNWKo4FUIg8f
	47w9R75lmMTmc52ccCyYaeQaaGJFzres=
X-Google-Smtp-Source: AGHT+IGgOQMICsR5qELC3RjLevLzNuOZoBjqz+3a6tv2r5jQnUMp/TK8I4WXHJyrhHVab5YKy8OF+w==
X-Received: by 2002:a17:902:d4cf:b0:224:a79:5fe9 with SMTP id d9443c01a7336-22649a34608mr31087295ad.30.1742375509976;
        Wed, 19 Mar 2025 02:11:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-36-239.pa.vic.optusnet.com.au. [49.186.36.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371167d7bcsm11055927b3a.87.2025.03.19.02.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 02:11:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tupSk-0000000F4vC-3yQg;
	Wed, 19 Mar 2025 20:11:46 +1100
Date: Wed, 19 Mar 2025 20:11:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>
Subject: Re: [RFC PATCH] xfs: add mount option for zone gc pressure
Message-ID: <Z9qKUt1iPsQTTKu-@dread.disaster.area>
References: <20250319081818.6406-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319081818.6406-1-hans.holmberg@wdc.com>

On Wed, Mar 19, 2025 at 08:19:19AM +0000, Hans Holmberg wrote:
> Presently we start garbage collection late - when we start running
> out of free zones to backfill max_open_zones. This is a reasonable
> default as it minimizes write amplification. The longer we wait,
> the more blocks are invalidated and reclaim cost less in terms
> of blocks to relocate.
> 
> Starting this late however introduces a risk of GC being outcompeted
> by user writes. If GC can't keep up, user writes will be forced to
> wait for free zones with high tail latencies as a result.
> 
> This is not a problem under normal circumstances, but if fragmentation
> is bad and user write pressure is high (multiple full-throttle
> writers) we will "bottom out" of free zones.
> 
> To mitigate this, introduce a gc_pressure mount option that lets the
> user specify a percentage of how much of the unused space that gc
> should keep available for writing. A high value will reclaim more of
> the space occupied by unused blocks, creating a larger buffer against
> write bursts.
> 
> This comes at a cost as write amplification is increased. To
> illustrate this using a sample workload, setting gc_pressure to 60%
> avoids high (500ms) max latencies while increasing write amplification
> by 15%.

It seems to me that this is runtime workload dependent, and so maybe
a tunable variable in /sys/fs/xfs/<dev>/.... might suit better?

That way it can be controlled by a userspace agent as the filesystem
fills and empties rather than being fixed at mount time and never
really being optimal for a changing workload...

> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
> 
> A patch for xfsprogs documenting the option will follow (if it makes
> it beyond RFC)

New mount options should also be documented in the kernel admin
guide here -> Documentation/admin-guide/xfs.rst.

....
> 
>  fs/xfs/xfs_mount.h      |  1 +
>  fs/xfs/xfs_super.c      | 14 +++++++++++++-
>  fs/xfs/xfs_zone_alloc.c |  5 +++++
>  fs/xfs/xfs_zone_gc.c    | 16 ++++++++++++++--
>  4 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 799b84220ebb..af595024de00 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -229,6 +229,7 @@ typedef struct xfs_mount {
>  	bool			m_finobt_nores; /* no per-AG finobt resv. */
>  	bool			m_update_sb;	/* sb needs update in mount */
>  	unsigned int		m_max_open_zones;
> +	unsigned int		m_gc_pressure;

This is not explicitly initialised somewhere. If the magic "mount
gets zeroed on allocation" value of zero it gets means this feature
is turned off, there needs to be a comment somewhere explaining why
it is turned completely off rather than having a default of, say,
5% like we have for low space allocation thresholds in various
other lowspace allocation and reclaim algorithms....

> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -162,18 +162,30 @@ struct xfs_zone_gc_data {
>  
>  /*
>   * We aim to keep enough zones free in stock to fully use the open zone limit
> - * for data placement purposes.
> + * for data placement purposes. Additionally, the gc_pressure mount option
> + * can be set to make sure a fraction of the unused/free blocks are available
> + * for writing.
>   */
>  bool
>  xfs_zoned_need_gc(
>  	struct xfs_mount	*mp)
>  {
> +	s64			available, free;
> +
>  	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
>  		return false;
> -	if (xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE) <
> +
> +	available = xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
> +
> +	if (available <
>  	    mp->m_groups[XG_TYPE_RTG].blocks *
>  	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
>  		return true;
> +
> +	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> +	if (available < div_s64(free * mp->m_gc_pressure, 100))

mult_frac(free, mp->m_gc_pressure, 100) to avoid overflow.

Also, this is really a free space threshold, not a dynamic
"pressure" measurement...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
