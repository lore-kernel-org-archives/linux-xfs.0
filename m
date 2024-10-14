Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D814374D1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893042; cv=none; b=TChxliN35toaLesM6uee0vwuXjHf5KFyZ7YDtNxKYB5FPTWNMPczqds3T+ik/HN5YLy+Spl2XYHJoY5r4dA3EfTRoaA5nV8xr7uNv8Ig1XP11YMW2omzqYLuOMmfm0l4+l9fBBXkpdi+Sz4czmn5BePLJAK8qWw+GJGlau7EQxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893042; c=relaxed/simple;
	bh=R9haDeY51N3Lu1+hEtg9SO5IFILICG7SZSgl0paaqrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kEImgpKLCMf47hEzkGHXlG6UMbF7ulI2ljtF+L+Wo79sGVar8TLzMuRKRUrxYiEoWo8yAkWQomUbVNYERpmWbkDJSw9k9lor1fdz3J6494g3seezrFqC30Zm2YyvXMQEJfMGnJkhyjruZHfN1N+sbEl6XdJR90A7FTsPLCwPCto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nw58wsHZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nw58wsHZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AY3rsnHH9Y3PmhWmircwDwTclM2WERbbkPtE62o3W1c=; b=Nw58wsHZ7J2x5fZ0evmygdtGq3
	OD+mPv5EipWb6KjsQvmodvJvTgfmSRkkZcUfrZydae4vkdn3k0UwnVzSkK71ghBK1ILnb5jhPN9/6
	KKMK2cnebaS1wlaAcGYqdFrCKifrkXvKew2y+Ja1BvcP4gbtFfvM1dvAF8kXZKSl9vM7SHEb1gM/M
	ckbZ6Je8Mv81GnXGygYm/wl8pa+OcKN8KE11pJHWNVYgxEQc7BNIdzaIAxA+nFGY/lr/aHONQmyWm
	/vj1ucmQyyGvKFd7eO9SqDcTxd7mVjWOtD7OE4wFXaEksRRtieHR5k9T/KRWeReQTUzpPIyVpez3+
	wrWKEvwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0G3d-00000004C3T-0aW4;
	Mon, 14 Oct 2024 08:04:01 +0000
Date: Mon, 14 Oct 2024 01:04:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 15/36] xfs: store rtgroup information with a bmap intent
Message-ID: <ZwzQcYRPCPAchgjY@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644500.4178701.5897856828553646962.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644500.4178701.5897856828553646962.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The actual intent code looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

but while re-reviewing I noticed a minor thing in the tracing code:

> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->type = bi->bi_group->xg_type;
> +		__entry->agno = bi->bi_group->xg_index;
> +		switch (__entry->type) {
> +		case XG_TYPE_RTG:
> +			/*
> +			 * Use the 64-bit version of xfs_rtb_to_rgbno because
> +			 * legacy rt filesystems can have group block numbers
> +			 * that exceed the size of an xfs_rgblock_t.
> +			 */
> +			__entry->gbno = __xfs_rtb_to_rgbno(mp,
>  						bi->bi_bmap.br_startblock);
> +			break;
> +		case XG_TYPE_AG:
> +			__entry->gbno = XFS_FSB_TO_AGBNO(mp,
>  						bi->bi_bmap.br_startblock);
> +			break;
> +		default:
> +			/* should never happen */
> +			__entry->gbno = -1ULL;
> +			break;

Maybe just make this an

		if (type == XG_TYPE_RTG)
			__xfs_rtb_to_rgbno()
		else
			xfs_fsb_to_gbno()

?

>  		  __entry->l_len,
> 
> 
---end quoted text---
