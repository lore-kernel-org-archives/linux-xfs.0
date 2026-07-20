Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7493D1CAE;
	Mon, 20 Jul 2026 09:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538141; cv=none; b=iEt3ZB2LdSrrH0fdebwsN7Etv9fyqBWtkonps5YVg9stOHFlr4jBsuoOV9iLhnp9vS+aMImLN6bJklAGgr291F/k5YRe5Zq3nVVXBl3gzTVLpO3c1YZqpR2oh2sdpVTHJVZiU0Leab/fo61U/uX3ndbzG8jUopwGNWg47v2fZgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538141; c=relaxed/simple;
	bh=p3TTFKiLrc9hRkHyrXLvc5ghe3ELIPGNb9LCfcbYI4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZ82cOwOmtNiPoWPYeVd+YSAnaiFmiIXmYLACUseo652P933BINctJsOkdCv4Ku6EhfJq0WwkYn5JpwhOUuPztjSdwZxGeYRHBsTle9KiiAlfUk153tr+pr6JNFFRuHq4tex8daKhohndPVSxWNZJlZ14AsBrYD56tLM8mN5jxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Awt9POZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Awt9POZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1E51F000E9;
	Mon, 20 Jul 2026 09:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538139;
	bh=BeOA7FgJu6xP3+IRrnBdxgFMUgaylCdb8yYjKYASvPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Awt9POZmbK3nnvHqT0uJDO28VA7bXue6vuWHZHtpBnNOIxHhcwLX3JmfDJtlBnIOz
	 vOyNu7/goNK6FwqsA+xZgCbjUsCgHzv8qKcCHlWnzIAvRAI7FBXFk+/vbV9lTuQs90
	 sKwk3w+EpNbeQlUWBeEIFtI0S8hf7ISUPTMXeuWgvMKDLZQdWVPqVgvAEPSgyXXNob
	 bw8wacVg8sZRPdIgp8RxemyH11r4N0Vsptl8P4E3RP4zt5TQDgM0qXz747dqrtN6bM
	 t20kfT+ouWfgjx32A/KpQv/mxDJid7eCbIRvtraisqTGfAIkxTDjYkb7zsMbXKMQsk
	 0ZnfEyEpuX8Gg==
Date: Mon, 20 Jul 2026 11:02:15 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Filip Blagojevic <filip.blagojevic@wdc.com>, 
	Matthew Wilcox <willy@infradead.org>, Damien Le Moal <dlemoal@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
Message-ID: <al3j0GaQaeYj0Ih8@nidhogg.toxiclabs.cc>
References: <20260623142109.1838702-1-hch@lst.de>
 <20260623142109.1838702-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623142109.1838702-2-hch@lst.de>

On Tue, Jun 23, 2026 at 04:21:06PM +0200, Christoph Hellwig wrote:
> When using XFS with a main device on an SSD that stores metadata and a RT
> device to store data on a HDD, we fail to take the I/O sizes for the RT
> device into accounting, leading to up to 5% slower read performance when
> using an SSD for metadata vs storing data and metadata on the HDD.
> 
> Fix this up by taking the RT settings into account.  Note that this
> updates the BDI owned by the main device, and leaves those settings in
> place even when the file system is unmounted.  This is a bit unexpected
> but not different from manual tuning through sysfs (although that is only
> possible for the ra_pages value).

Sorry a 'very late reply', but...
On a second thought, wouldn't be wise to cache the original value in
memory and restore it during unmount/filesystem shutdown?

I could send a patch to complement this one if you guys agree, otherwise
just ignore me.

> 
> Reported-by: Filip Blagojevic <filip.blagojevic@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e6781f86d867..88edd3822872 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -546,6 +546,29 @@ xfs_open_devices(
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
> +	sb_bdi->ra_pages = max(sb_bdi->ra_pages, rt_bdi->ra_pages);
> +	sb_bdi->io_pages = max(sb_bdi->io_pages, rt_bdi->io_pages);
> +}
> +
>  /*
>   * Setup xfs_mount buffer target pointers based on superblock
>   */
> @@ -583,6 +606,7 @@ xfs_setup_devices(
>  				mp->m_sb.sb_sectsize, mp->m_sb.sb_rblocks);
>  		if (error)
>  			return error;
> +		xfs_update_bdi_rahead(mp);
>  	}
>  
>  	return 0;
> -- 
> 2.53.0
> 
