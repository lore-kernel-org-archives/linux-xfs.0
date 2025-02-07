Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C57963D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905412; cv=none; b=LAc1fHLUwbCZG7bxdfTl1M3NpzRoi/+dwn7gEP9TWVLRwYTxpMkHtBNeahaPLWfm291iQzzFUVHtvslcIQmfbS6HTBGuCEGDRR4xVwNWb1rXMU7023xeQJ3gheaObhPS61+oblYz26ZbKs/hih1guG7W6aisP/2u/eni9/BI88s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905412; c=relaxed/simple;
	bh=aQBKttSqNmd6FNPlj3cEGkoIsGUQkvBlDSUP58QHR68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLfPGeL5IDmt7PAAKUxl5t22ljlxRX0byOqxMzsZmu3zuWkWphp4UBcOaM3KAum3faZQ60QHtcKx1rImIEO0+eqWoNYyHcls1NZZPbYOUMb25cLXjI6YDK5IYazFiJnf63H9cPgK49NJpys5FtiUg+iEkem8wFCNV+i3moQxuzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=km/R0WxG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="km/R0WxG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d19+Gjt+N/4bnfuDfbgPAwpqfMbh97Kfva0WjApRc74=; b=km/R0WxGARcHN5xSiNKw4ZevuU
	S1JGp+JnMzr8qjkTonh1lm1Q97/iNfrGNtf7FxRY+rBg/nXfEJkGSUWBLVa0+utnELkyDCwFcCoIf
	hD0+q45AV5KQOVlVlSdyin4YLHeGYQOGh2hxKtJyxV/pFn9MVdQlIy3DEjOV08GeVC2p6Hi3Qgp13
	WhzR2VbYBI/9xZzMvwuYjZgAW1s8+8ct1ZtojZyEowLnvgWyN5aK0wEY04OPSDMZQtkIqsI5eNYEI
	HiD1n1RTbT3xoAnPsncNqvZRAerf7+Ilb0AoQY0zbe4iwxr84TUmTmNuDzz6khq4BIirG78csMgj9
	y+ZBv8mg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGjS-00000008M2y-3zNZ;
	Fri, 07 Feb 2025 05:16:50 +0000
Date: Thu, 6 Feb 2025 21:16:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/27] xfs_db: display the realtime rmap btree contents
Message-ID: <Z6WXQn_Zi6moPpks@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088203.2741033.164927994313593176.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088203.2741033.164927994313593176.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:51:33PM -0800, Darrick J. Wong wrote:
> +static int
> +rtrmaproot_rec_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_rtrmap_root	*block;
> +#ifdef DEBUG
> +	struct xfs_dinode	*dip = obj;
> +#endif
> +
> +	ASSERT(bitoffs(startoff) == 0);
> +	ASSERT(obj == iocur_top->data);
> +	block = (struct xfs_rtrmap_root *)((char *)obj + byteize(startoff));
> +	ASSERT((char *)block == XFS_DFORK_DPTR(dip));

Hmm, wouldn't this be cleaner by turning the logic around:

	struct xfs_dinode	*dip = obj;
	struct xfs_rtrmap_root	*block = XFS_DFORK_DPTR(dip);

	...

	ASSERT(block == obj + byteize(startoff));

Same for the other uses of this pattern.

Otherwise looks good (as good as xfs_db can look like anyway..)

Reviewed-by: Christoph Hellwig <hch@lst.de>
