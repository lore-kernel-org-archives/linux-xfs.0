Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96653537C7;
	Mon, 31 Aug 2026 07:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159602; cv=none; b=QEuifso5ad/RZcocd2yMZebjIhELBKd2zn7smptzzsjReaqgsjT1n5cRLdPq0pX443MhzMT5QauMRw2rj/fKQdns+BbA0RLWSs9ItoATg6fH5pAKG7O0vK26kCHgVWKW4idh7qKLtsR3cUt3gz64Hv4KLE7px4uFo5tZITwcG8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159602; c=relaxed/simple;
	bh=2YS/HTgDqNf4YjISD649FFeNKRA0/LvVImmhune6eOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3UQWnLUFCaQla2L7rgo3jdf/U6rNAivqCtlOnioYux325tlDVYI5N0fxnOy0CVyV1jmYfnHsC+cv1ocXiRipwU4cnpIGPsHMTA3ZmhgISSx2Nii6f8qfP5XBSC3frMlzBxB4a1T05NFDaDRrnB9yCI8nL38iqv7/KGTLiAQyA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKknt6hX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKknt6hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B140B1F000E9;
	Mon, 31 Aug 2026 06:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788159600;
	bh=3/gFv+rblRquZMcsz7oEg/t5t/Ykn6e7Ikbtdkyikcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jKknt6hXVgZVwkCs8gv7F2Aa+Z/K2LvMdsroteRI0eSUIHwqSTuGoR101idWf2yrs
	 6AF3mDVu4ZQi6qQnYuCMnAZD6vuPLjugn5AhpKRJP3dWv+RGiv37M96WozFGF2b/p+
	 miGArQWka2xQ9FqTXtn1bMyIJ8ojlm1P0NHR6S/31xXViRuxPnPbANV0DEr0k9IML3
	 e6lPMVP7uUcjVQPDMmSXi2XBFs4XC8NVR5Ue0z6G19jsjB6iinsIyTpgaXApDGeH6Q
	 vZXixOAbqv650YTAeHCMMloi62T+j14Tb/unveakrE751XC2pZQzAW471Gt0yRc1ma
	 EzQE3/SvEa/VA==
Date: Mon, 31 Aug 2026 08:59:56 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix media verification ioctl for internal rt volumes
Message-ID: <apUmXKFPrBJJQnd6@andromeda.toxiclabs.cc>
References: <20260821035806.GJ6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821035806.GJ6072@frogsfrogsfrogs>

On Thu, Aug 20, 2026 at 08:58:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A media scan of a filesystem containing an internal rt volume produced
> an error in xfs_scrub phase 6 complaining about a truncated realtime
> device.  The rt device wasn't truncated, but the media scan code thought
> we were trying to start a scan past the end of m_rtdev_targp.  That in
> turn is an alias for m_ddev_targp, but in xfs_configure_buftarg we set
> nr_sectors to the size of the data section.  We don't account for an
> internal realtime section, so the kernel doesn't scan any part of it.
> Oops.
> 
> Reproducer:
> 
>  # mkfs.xfs -f /dev/sda -r zoned=1 -d rtinherit=1
>  # mount /dev/sda /mnt
>  # dd if=/dev/zero of=/mnt/a bs=1024k count=100
>  # sync
>  # xfs_info /mnt
>  meta-data=/dev/sda               isize=512    agcount=4, agsize=32768 blks
>           =                       sectsz=512   attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=1, rmapbt=1
>           =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>           =                       exchange=1   metadir=1
>  data     =                       bsize=4096   blocks=131072, imaxpct=25
>           =                       sunit=0      swidth=0 blks
>  naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
>  log      =internal log           bsize=4096   blocks=16384, version=2
>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>  realtime =internal               extsz=4096   blocks=1114112, rtextents=1114112
>           =                       rgcount=17   rgsize=65536 extents
>           =                       zoned=1      start=131072 reserved=53248
> 
> IOWS: 512M data volume, 3.1G internal rt section.  Now let's try some
> media verification:
> 
>  # xfs_io -c 'verifymedia -d' -c 'verifymedia -r' /mnt
>  verified 536870912/536870912 bytes at offset 0
>  512 MiB, 1 ops; 0.0496 sec (10.067 GiB/sec and 20.1345 ops/sec)
>  verified 536870912/536870912 bytes at offset 0
>  512 MiB, 1 ops; 0.0409 sec (12.222 GiB/sec and 24.4439 ops/sec)
> 
> Notice how xfs_io says we only verified 512M of the rt volume?  If you
> run btrace in the background you'll see that we read the first 512M of
> the volume (aka the data section) twice and never read anything from the
> rt section.
> 
> An earlier fix tried messing with the buftarg geometry, but I've decided
> on a more targetted fix for the media verification code.  All we have to
> do is calculate the starting and ending daddr for the device that we're
> verifying, and clamp the user's input values to that range.  This leads
> to some bogosity in the output reporting:
> 
>  # xfs_io -c 'verifymedia -d' -c 'verifymedia -r' /mnt/t
>  verified 536870912/536870912 bytes at offset 0
>  512 MiB, 1 ops; 0.0606 sec (8.248 GiB/sec and 16.4968 ops/sec)
>  verified 5100273664/5100273664 bytes at offset 0
>  4.750 GiB, 1 ops; 0.3329 sec (14.267 GiB/sec and 3.0035 ops/sec)
> 
> Because we don't have a way to report that we didn't really do anything
> at all for that first 512M of address space of the rt "device".  But at
> least we're no longer ignoring real media.
> 
> (Note that the fsmap/bmap/fiemap calls all report physical addresses for
> the internal rt volume as offsets from the start of the data device, and
> the media verifier call consumes the same.  We baked that into the
> user-visible behavior in 6.15, so we're stuck with that sparse hole at
> the beginning.)
> 
> Cc: <stable@vger.kernel.org> # v6.15
> Fixes: bdc03eb5f98f6f ("xfs: allow internal RT devices for zoned mode")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_verify_media.c |   24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
> index 5ead3976d51151..b75c81f8fcc037 100644
> --- a/fs/xfs/xfs_verify_media.c
> +++ b/fs/xfs/xfs_verify_media.c
> @@ -268,6 +268,8 @@ xfs_verify_media(
>  	struct xfs_buftarg	*btp = NULL;
>  	struct bio		*bio;
>  	struct folio		*folio;
> +	xfs_daddr_t		dev_start = 0;
> +	xfs_daddr_t		dev_end = 0;
>  	xfs_daddr_t		daddr;
>  	uint64_t		bbcount;
>  	int			error = 0;
> @@ -277,24 +279,33 @@ xfs_verify_media(
>  	switch (me->me_dev) {
>  	case XFS_DEV_DATA:
>  		btp = mp->m_ddev_targp;
> +		dev_end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
>  		break;
>  	case XFS_DEV_LOG:
> -		if (mp->m_logdev_targp != mp->m_ddev_targp)
> +		if (mp->m_logdev_targp != mp->m_ddev_targp) {
>  			btp = mp->m_logdev_targp;
> +			dev_end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> +		}
>  		break;
>  	case XFS_DEV_RT:
>  		btp = mp->m_rtdev_targp;
> +		dev_start = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
> +		dev_end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart +
> +					    mp->m_sb.sb_rblocks);
>  		break;
>  	}
>  	if (!btp)
>  		return -ENODEV;
>  
>  	/*
> -	 * If the caller told us to verify beyond the end of the disk, tell the
> -	 * user exactly where that was.
> +	 * If the caller told us to verify before the start or beyond the end
> +	 * of the disk volume, tell the user exactly where the volume starts
> +	 * and ends.
>  	 */
> -	if (me->me_end_daddr > btp->bt_nr_sectors)
> -		me->me_end_daddr = btp->bt_nr_sectors;
> +	if (me->me_end_daddr > dev_end)
> +		me->me_end_daddr = dev_end;
> +	if (me->me_start_daddr < dev_start)
> +		me->me_start_daddr = dev_start;
>  
>  	/* start and end have to be aligned to the lba size */
>  	if (!IS_ALIGNED(BBTOB(me->me_start_daddr | me->me_end_daddr),
> @@ -323,8 +334,7 @@ xfs_verify_media(
>  	 *    verifying.
>  	 */
>  	daddr = me->me_start_daddr;
> -	bbcount = min_t(sector_t, me->me_end_daddr, btp->bt_nr_sectors) -
> -			  me->me_start_daddr;
> +	bbcount = me->me_end_daddr - me->me_start_daddr;
>  
>  	folio = xfs_verify_alloc_folio(xfs_verify_iosize(me, btp, bbcount));
>  	if (!folio)
> 
