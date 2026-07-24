Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A07830BF70;
	Fri, 24 Jul 2026 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899223; cv=none; b=DsvZf5RWFV94uY1Gn3HFIIrDFRLV2YY19THXtm1fuXzZJXpJkj/hw9kk8oztLhvF+kLw+iF3918Bsl5nthKGMn/3eqEal5x2HmsmLAOtHLJRrmbRDLoAkHLuDY65z2DXYtnlrVS5hUghMYZZlQjAK5Oj97gS5Fmt9xRSHE3WpBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899223; c=relaxed/simple;
	bh=jth4+VlWF4GWBoZJED2mP7GCE8j1W+je7s+hud4yCwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ui/GPZTCbr8F8o+p3QcPfCpcvUzlBMPlUiutmgpniRB7NOTFrkAZvRgVtvdMRSowkqzNqakxLVMiqXiUapy2P/+B7LJNu4VxIhdq+SoFjeXVuanp+QY6HyHowizjx4XGa75fJMPpahvV5IUVN2OtSaRvOok8mmI+qEoEsIc4/WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CDF6E68D09; Fri, 24 Jul 2026 15:20:18 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:20:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 17/23] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <20260724132018.GF27878@lst.de>
References: <20260721184346.416657-1-aalbersh@kernel.org> <20260721184346.416657-18-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-18-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 21, 2026 at 08:40:54PM +0200, Andrey Albershteyn wrote:
> +	while (offset_fsb < end_fsb) {
> +		nimaps = 1;
> +
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
> +		if (error)
> +			return error;
> +
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		error = xfs_bmapi_read(ip, offset_fsb,
> +				end_fsb - offset_fsb, &imap, &nimaps,
> +				0);
> +		if (error)
> +			goto out_cancel;
> +
> +		if (nimaps == 0)
> +			goto out_cancel;
> +
> +		if (imap.br_state == XFS_EXT_UNWRITTEN) {

Do we also need to cancel COW fork extents here?  Should this
share code xfs_free_eofblocks by adding an end argument to that?

