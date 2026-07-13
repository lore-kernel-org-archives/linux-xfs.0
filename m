Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8A2342CBA
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 06:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783925731; cv=none; b=doGPhSsvFGE8CHtT0nLEy9lpXv1YywhIvOXbzU30NZ9yuDzcyxgsH60lPE+QvZ+Mpa8+JpdiA3mU3e55hgb/ozag0cCmS0DxakCie/pwaVCQBRH4X+0yZyPXryv5tJVpQg2nshjFZeEoBtevvYAj/oEeN8i9flIlYWviQCLMNh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783925731; c=relaxed/simple;
	bh=dlk/1RWpBsXuTWwvOxu+K3vRL8rM3ZRYjSbSh2qrT+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjaty2cr79eLNjescx6mgjn8ADaCeGbJINZicmcxOyR4aL3FgQA6yS5KfJ2wzPPOiawH0Kiq0sa0x1WDACOcZO5ill+xjE9leuRsDAyUEV3Y48ObTLOXu376YWG2oZhKD+K9sxnnUQlykOfhAkSk9bvAWSrSV6bccAhCP2zvYrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 55D1068B05; Mon, 13 Jul 2026 08:55:26 +0200 (CEST)
Date: Mon, 13 Jul 2026 08:55:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/3] xfs: create quota metadir inodes using
 xfs_metadir_create_file
Message-ID: <20260713065525.GI29416@lst.de>
References: <20260712093317.782831-1-johannes.thumshirn@wdc.com> <20260712093317.782831-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712093317.782831-3-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 12, 2026 at 11:33:16AM +0200, Johannes Thumshirn wrote:
> +static int
> +xfs_dqinode_init(
> +	struct xfs_metadir_update	*upd,
> +	void				*priv)
> +{
> +	xfs_trans_log_inode(upd->tp, upd->ip, XFS_ILOG_CORE);
> +	return 0;
> +}

I wonder if we should just unconditionally re-log the inode in the
caller.  File creation already logs the inode core anyway, so this
really is a no-op.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
