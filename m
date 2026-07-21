Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBB9417D60;
	Tue, 21 Jul 2026 09:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625867; cv=none; b=d3xu85dqunzs0Z3BaQJ6tVvuROkY1lgY+RQ5aAHeSPG5CWI0GDxYOxmctjLwYr5NfIMEzX9sE9gfKt7ieMLb7cLgDpS0/ZJjtMwMwc94BoiJddwMS05HsYANRqucGMEIoMBGTOzmYz7eY2QhruV1bB3LUV+9utAJK43HDNaRBaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625867; c=relaxed/simple;
	bh=2b0H/SGoXtF9YCgBQjaIyMyPOhEfnL+OtxO87gvaIMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKEKtL0voNeEifzS1heFncOWojVrey1dgpXsq1jI3VqoxW8RZMLvblWbDb0NzQ7RyU0c8MA6JMEcgjP5dGh1Xzu+PwRTA9pkekalNfPxJxnyMs2m6/AeKj84phvfl+c/eKOkMUiHrgSENdAKoRSCo0fbRI5s1hAfuRvjLY4prh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVYTO0m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVYTO0m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A9C1F00A3A;
	Tue, 21 Jul 2026 09:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784625865;
	bh=zY6Y0aLB0L0Vk4o7IqtXJYa35OXiWT0vTcoWjxI9bM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KVYTO0m0BADbE1IT6XioIP3fzqmbHVA07ULx9g6c2BPVZJnkGXi5HFKXfxNVOtovF
	 CycPzzJGg5UlKIqc+OXEE6gD1RXjgOcRP79IRl73s4UC2dQ8DP4oi/zgfzE2bKjP+e
	 kog75LcxRss9gyZMc4Xu24ayPcFcdNicsqeK8+OndmKNgThllqj/aY0OBmB/STwqrG
	 v0+x3TwTRgMerZQHswbXDXCoQ8+2hF9htL1nAJ4t3XTjE/WkTBj3KuzGyZUQUqr5tF
	 w0fv+XoiOhPkB3TZlnlIB7VIhCVAD2Q4BzvytQfwgc/DHJfd7eH8wYqWdI4/Rqqo7e
	 sSS2+IKhc+CKw==
Date: Tue, 21 Jul 2026 11:24:21 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Filip Blagojevic <filip.blagojevic@wdc.com>, 
	Matthew Wilcox <willy@infradead.org>, Damien Le Moal <dlemoal@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
Message-ID: <al86vKpjWnVLgkaV@nidhogg.toxiclabs.cc>
References: <20260720140849.2269776-1-hch@lst.de>
 <20260720140849.2269776-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720140849.2269776-2-hch@lst.de>

On Mon, Jul 20, 2026 at 04:08:47PM +0200, Christoph Hellwig wrote:
> When using XFS with a main device on an SSD that stores metadata and a RT
> device to store data on a HDD, we fail to take the I/O sizes for the RT
> device into accounting, leading to up to 5% slower read performance when
> using an SSD for metadata vs storing data and metadata on the HDD.
> 
> Fix this up by taking the RT settings into account at mount an restoring
> the old settings at unmount time, unless the BDI settings have changed
> from those set by XFS.
> 
> Reported-by: Filip Blagojevic <filip.blagojevic@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/xfs_mount.h |  7 ++++++
>  fs/xfs/xfs_super.c | 53 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 66a02d1b9ad7..216a38a354e7 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -349,6 +349,13 @@ typedef struct xfs_mount {
>  
>  	/* Index of uuid record in the uuid xarray. */
>  	unsigned int		m_uuid_table_index;
> +
> +	/*
> +	 * Old io_pages/ra_pages valued in the main bdev BDI, and our initial
> +	 * calculated values.
> +	 */
> +	unsigned long		m_old_io_pages, m_initial_io_pages;
> +	unsigned long		m_old_ra_pages, m_initial_ra_pages;
>  } xfs_mount_t;
>  
>  #define M_IGEO(mp)		(&(mp)->m_ino_geo)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8531d526fc44..63c4bcbe6c2b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -548,6 +548,52 @@ xfs_open_devices(
>  	return error;
>  }
>  
> +/*
> + * When using a RT device some or all data I/O is using the RT device, but
> + * the BDI is inherited from the main data device.  When the underlying block
> + * device for the RT device has larger I/O sizes, the BDI settings might be
> + * incorrect, which is especially bad if the main device is a SSD and the
> + * RT device is a HDD, as the io_opt fixup in blk_apply_bdi_limits is missing
> + * for this case.
> + *
> + * Update the BDI values to the max of the data and RT device to cover our
> + * bases.
> + */
> +static void
> +xfs_update_bdi_rahead(
> +	struct xfs_mount	*mp)
> +{
> +	struct backing_dev_info	*rt_bdi =
> +		mp->m_rtdev_targp->bt_bdev->bd_disk->bdi;
> +	struct backing_dev_info	*sb_bdi = mp->m_super->s_bdi;
> +
> +	mp->m_old_io_pages = sb_bdi->io_pages;
> +	mp->m_old_ra_pages = sb_bdi->ra_pages;
> +
> +	sb_bdi->io_pages = mp->m_initial_io_pages =
> +		max(sb_bdi->io_pages, rt_bdi->io_pages);
> +	sb_bdi->ra_pages = mp->m_initial_ra_pages =
> +		max(sb_bdi->ra_pages, rt_bdi->ra_pages);
> +}
> +
> +static void
> +xfs_restore_bdi_rahead(
> +	struct xfs_mount	*mp)
> +{
> +	struct backing_dev_info	*sb_bdi = mp->m_super->s_bdi;
> +
> +	if (sb_bdi->io_pages == mp->m_initial_io_pages)
> +		sb_bdi->io_pages = mp->m_old_io_pages;
> +	else
> +		xfs_info(mp, "io_pages changed from %lu to %lu, not restoring.",
> +				mp->m_initial_io_pages, sb_bdi->io_pages);
> +	if (sb_bdi->ra_pages == mp->m_initial_ra_pages)
> +		sb_bdi->ra_pages = mp->m_old_ra_pages;
> +	else
> +		xfs_info(mp, "ra_pages changed from %lu to %lu, not restoring.",
> +				mp->m_initial_ra_pages, sb_bdi->ra_pages);
> +}
> +
>  /*
>   * Setup xfs_mount buffer target pointers based on superblock
>   */
> @@ -585,6 +631,7 @@ xfs_setup_devices(
>  				mp->m_sb.sb_sectsize, mp->m_sb.sb_rblocks);
>  		if (error)
>  			return error;
> +		xfs_update_bdi_rahead(mp);
>  	}
>  
>  	return 0;
> @@ -2283,8 +2330,12 @@ static void
>  xfs_kill_sb(
>  	struct super_block		*sb)
>  {
> +	struct xfs_mount		*mp = XFS_M(sb);
> +
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
> +		xfs_restore_bdi_rahead(mp);
>  	kill_block_super(sb);
> -	xfs_mount_free(XFS_M(sb));
> +	xfs_mount_free(mp);
>  }
>  
>  static struct file_system_type xfs_fs_type = {
> -- 
> 2.53.0
> 
> 
