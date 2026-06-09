Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807F042B750
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781016972; cv=none; b=WUZli2FUP6VFnqQREIKoE3hICKTLbXg4/hLirrc1O6F5Qh5j0i/Oo0M0xLN9+7gX7SBt2LMe6eEHDWXHtXHnTrV6d3laAmjeN92fW+WAPfktpvnTxOlQsONK0/11sCAV0UmjSG+NWWflLzPZ3uGJtgFykHEqDPyIDbzTvDETXe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781016972; c=relaxed/simple;
	bh=ZHUJV51gB56M+6+pA3D/xveLvpv9Kn/iW4BRtnQlo2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iytpe6gHeOe+S67Lkdn6pJsbcQykug7+KPfbgyrB9NK6yTFdRC5o/ywNe4sM6ZMPKrPcfGlU4so2w02/xpxGfhnHugvb04LsP3B9xXhU49OfiHmzJDHVHt3mo6uZu1FRuTTrrfNlMH7xX7WM5mb1Lxrq6vBrrES6Co1021VoguM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOxff0I6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOxff0I6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1FBE21F00893;
	Tue,  9 Jun 2026 14:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781016967;
	bh=tVFWlYM8W/pF6gEQ9qle2mWVw3uXDlyiPfiEerUQyLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XOxff0I6PUow0QhfBAfSOAe8jKxS/Y8a9BlPmpiRylCkswcQH1Us00oIEmyFCRezL
	 KFwu2ovH1wf54ioFLi4MstWj/bI8PxK4dOsUMgGvVu06G4MG2E0BzrZrYQJ1FndAoU
	 boNzALXrUxNMi86pRUqFGuAflzYk1NfmOVdGvApGRvqhaLrfUyaudtVPnBkJESVzLu
	 CbjKiW5KRp+aUMWHuchje3zBD+J9has+lIuVQTXnMljfD16yMeVQYQvBpqOfaYhUGl
	 NRjJpq4MxMdTU55yEeDBwpwznKG/S5lr+cupQuCcxTJ4Gmf4KjnixoQRnZ1vX9UwiR
	 d2zZgnU8nH71Q==
Date: Tue, 9 Jun 2026 07:56:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: factor out a xfs_add_free_zone helper
Message-ID: <20260609145606.GB6078@frogsfrogsfrogs>
References: <20260609075655.1698743-1-hch@lst.de>
 <20260609075655.1698743-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609075655.1698743-2-hch@lst.de>

On Tue, Jun 09, 2026 at 09:56:41AM +0200, Christoph Hellwig wrote:
> Add a helper for adding a zone to the free pool in preparation of adding
> another caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I might've called this xfs_zone_mark_free but I don't care passionately
about the name.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_alloc.c | 11 +++++++++--
>  fs/xfs/xfs_zone_alloc.h |  1 +
>  fs/xfs/xfs_zone_gc.c    |  4 +---
>  3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 5e297b75a85f..0a7c4863eefb 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -944,6 +944,14 @@ xfs_zone_rgbno_is_valid(
>  			rtg_rgno(rtg), XFS_RTG_FREE);
>  }
>  
> +void
> +xfs_add_free_zone(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
> +	atomic_inc(&rtg_mount(rtg)->m_zone_info->zi_nr_free_zones);
> +}
> +
>  static void
>  xfs_free_open_zones(
>  	struct xfs_zone_info	*zi)
> @@ -1082,8 +1090,7 @@ xfs_init_zone(
>  
>  	if (write_pointer == 0) {
>  		/* zone is empty */
> -		atomic_inc(&zi->zi_nr_free_zones);
> -		xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
> +		xfs_add_free_zone(rtg);
>  		iz->available += rtg_blocks(rtg);
>  	} else if (write_pointer < rtg_blocks(rtg)) {
>  		/* zone is open */
> diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
> index 8b2ef98c81ef..cc16cc328763 100644
> --- a/fs/xfs/xfs_zone_alloc.h
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -42,6 +42,7 @@ void xfs_zoned_wake_all(struct xfs_mount *mp);
>  bool xfs_zone_rgbno_is_valid(struct xfs_rtgroup *rtg, xfs_rgnumber_t rgbno);
>  void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
>  
> +void xfs_add_free_zone(struct xfs_rtgroup *rtg);
>  uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
>  		enum xfs_free_counter ctr);
>  void xfs_zoned_show_stats(struct seq_file *m, struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index f03211e4354a..670e05d2dadd 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -924,9 +924,7 @@ xfs_zone_gc_finish_reset(
>  		goto out;
>  	}
>  
> -	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
> -	atomic_inc(&zi->zi_nr_free_zones);
> -
> +	xfs_add_free_zone(rtg);
>  	xfs_zoned_add_available(mp, rtg_blocks(rtg));
>  
>  	wake_up_all(&zi->zi_zone_wait);
> -- 
> 2.53.0
> 
> 
