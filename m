Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E03374D1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893562; cv=none; b=R52IOTAi0dQjOQewLFJ7iOv+c2x/Pk5LMXQmStXDj9fyI5DYeCI44tDivvSEbiwfbLhpQiZPjCMKvi1J4fZcjq92QUTrkVvrb1qkw99qm6nOYyi+YxvFdy87PgBESSPbUI2sFIp4ws5C//Oy6jOd6RcqeTUH7YExWX0G5jUWJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893562; c=relaxed/simple;
	bh=P0/wIcj+MSqHCdEXxjqqQoMSD5AyXjztSai7FVmGuUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=goVAL4FJFmvyIYR1V9rCn5e0pVuzlzaS+un6SegURGyzPKYmZRKRig89RMbmiGsQlizm1oAlTtyvnkYS7+poFCS4Lys9QfH64jmRXTR1n+h0Go3c1E+9UXm06xPSvqCZpP1MakU9TEdKjBE6wUu7IC6/+AhRt37K7t9rK2RtMg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oAkkihUU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oAkkihUU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w7mWYy/2fEC7UKVqiladV1NRHruh4Zbp2ecN91wfamQ=; b=oAkkihUUaCY4JGqtG/t+lWOKCM
	AonaFCrLPLDYbGNuYpccKtyTcBlYWCT4y2yAdPPAlBEWkWsg8lj79Q9aZhBoXl1AS4ut3WTMtyzMw
	N8+JphOwK3/vC6D20eYiV7bWCRjkfdpjlGToOzggJ4wEp+RAnzKdSSZeXdbqsVZbk5AZ2xywT+sI9
	mO0KtTGe1LOCHu+DxBqsjwBwVnTxXv9mMf6Z9Vvs2Y81lPYzZa6zf8uP3XW5SikwdEamiO49YCBGp
	y2V0Fcdk1ielbhRG6TCOLvvEmy5cNRB3LZq2qmGR4XS/2eCvUopipHoutRG4jpSfO081eQ2fRW3u4
	dyKluGgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GC0-00000004Dgn-35eN;
	Mon, 14 Oct 2024 08:12:40 +0000
Date: Mon, 14 Oct 2024 01:12:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/36] xfs: port the perag discard code to handle generic
 groups
Message-ID: <ZwzSeG0MA9ejlqSR@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644830.4178701.10909954990936352067.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644830.4178701.10909954990936352067.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 06:10:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Port xfs_discard_extents and its tracepoints to handle generic groups
> instead of just perags.  This is needed to enable busy extent tracking
> for rtgroups.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_discard.c |   35 ++++++++++++++++++++++++++---------
>  fs/xfs/xfs_trace.h   |   19 +++++++++++--------
>  2 files changed, 37 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index bcc904e749b276..2200b119e55b6b 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -101,6 +101,24 @@ xfs_discard_endio(
>  	bio_put(bio);
>  }
>  
> +static inline struct block_device *
> +xfs_group_bdev(
> +	const struct xfs_group	*xg)
> +{
> +	struct xfs_mount	*mp = xg->xg_mount;
> +
> +	switch (xg->xg_type) {
> +	case XG_TYPE_AG:
> +		return mp->m_ddev_targp->bt_bdev;
> +	case XG_TYPE_RTG:
> +		return mp->m_rtdev_targp->bt_bdev;
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +	return NULL;
> +}

I wonder if this should be in xfs_group.h as there is nothing
discard-specific about it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
