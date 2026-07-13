Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1236654F
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 06:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783925896; cv=none; b=Q4fr+ll/CalpHTB31YVftE/jwZUSCquTA2BF0G0Wd5q1jp3kwKahlGOMi5SpWlVYa4pm1+DIjqCtDP3IlWobXbL3/a9wbB34cM+H0XEcngRzsKJCSVhaO38syka1HGqge0PNf0VvsVdruX1BBS7ft45WYutG4Lc9MvpZFG/v9AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783925896; c=relaxed/simple;
	bh=nGZ06Ng51VRT/zJXfpr6r70Q6sF+LR1ZVafT+sckPv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlG9V1TdbqDkDSuM0KpMbVQj4tS2jblmOzAUyZP2LXBsEU8XSOgFtVWPnD+izsmFFBh8JZSZvOZcKoKAuaWGC+PJL78ddZnTNm5zxyRgHuB8EpJUEvr2X+wSkGFNZuKSISERVP848+tOX0qC3U5DUnlTv6/7LlAxAlTXo5idZYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1652068B05; Mon, 13 Jul 2026 08:58:02 +0200 (CEST)
Date: Mon, 13 Jul 2026 08:58:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH 3/3] xfs: create rtgroup metadir inodes using
 xfs_metadir_create_file
Message-ID: <20260713065801.GJ29416@lst.de>
References: <20260712093317.782831-1-johannes.thumshirn@wdc.com> <20260712093317.782831-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712093317.782831-4-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 12, 2026 at 11:33:17AM +0200, Johannes Thumshirn wrote:
> Now that we have xfs_metadir_create_file() use it in
> xfs_rtginode_create().
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/xfs/libxfs/xfs_rtgroup.c | 58 +++++++++++++++++--------------------
>  1 file changed, 26 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index caecc1e1f723..b6844b9af390 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -547,6 +547,25 @@ xfs_rtginode_irele(
>  	*ipp = NULL;
>  }
>  
> +struct xfs_rtginode_create {
> +	struct xfs_rtgroup		*rtg;
> +	enum xfs_rtg_inodes		type;
> +	bool				init;
> +};
> +
> +static int
> +xfs_rtginode_init(
> +	struct xfs_metadir_update	*upd,
> +	void				*priv)
> +{
> +	struct xfs_rtginode_create	*rc = priv;
> +	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[rc->type];
> +
> +	xfs_rtginode_lockdep_setup(upd->ip, rtg_rgno(rc->rtg), rc->type);
> +	upd->ip->i_projid = rtg_rgno(rc->rtg);
> +	return ops->create(rc->rtg, upd->ip, upd->tp, rc->init);
> +}

The double indirection is a bit annoying, but given that this is not
a performance pass not a major issue.  I can't really hink of a good
way to get rid of it either.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Please add another patch at the end to mark xfs_metadir_start_create,
xfs_metadir_create and xfs_metadir_cancel static.
