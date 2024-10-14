Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B8D156C5F
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894494; cv=none; b=IziHLxeNmK9OV23+XJf2RVA6fZ6tVN/600oUQ9FxSlW0hPZEy3b4p6SKrjG3QEMAzrnzDFHFFcJ3raDSKO/e69BiXP/CHUanKND6fMV21YffjH+ac7s8E0Z81eCcWr0vQFbYWxdjbIJnnQoU8B/BYF+0YlirvHrx1Ip53NIpJvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894494; c=relaxed/simple;
	bh=ojyYaCUEOrfF4uL+M9TclD/iKFpHUao/6BWV83tvT6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKZ4UTYboP66UHAvamVXchd31rrQciaAeHRPck/HEtPGBL6lW+7L9fPKOeP1ovqYT21bcnB405c4E7Ek4lF3VNGpx+GQVpiHG7flMOVjiCkE1FyklT/1zeNrVtK/O2cZy8qYn4HkjKxN9x2IxQFi24OLz/DPihZeg6xa0TzfZCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=inJN19LA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="inJN19LA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SdqY2QK50j7btiL037+78xAsRcu0+jyxd1open6rPyE=; b=inJN19LAh+Op877JZh9HTq7B6E
	DRjenqWGf2r3OoGYK5T5A+CVi/tP81ouIG7Y4nmbZSFmi+m9lGSY6US9yGTGaERoFgkaDcRPzEbnd
	iw3RvgfaeLt/fZd7bJvkb119tzonxj4jjp2mF06DLYxYeEn0c8ZSM/RFU2xcgGA4l43hhF47Ym4WP
	y6NUeTjZDoWJwKVm8L9ewVNf3fVUOKbmdcj6pm3dqxmXhDF7CPikFLziOQXoPsFvuP79HCe9U4dSs
	7Ioqi/HDZ9l6vtwzLAfF5unCXLYLmCj4b3oWjoWQnIpQR4fOAzEuLn9UwLAKMY7TUYJBmIAvF++lt
	rsHlFhhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GR3-00000004Hbs-00Y1;
	Mon, 14 Oct 2024 08:28:13 +0000
Date: Mon, 14 Oct 2024 01:28:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: create quota preallocation watermarks for
 realtime quota
Message-ID: <ZwzWHI_Lo-lKsMMp@infradead.org>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
 <172860645745.4180109.11610582297211837331.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860645745.4180109.11610582297211837331.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 06:13:07PM -0700, Darrick J. Wong wrote:
> +	pre->q_prealloc_hi_wmark = res->hardlimit;
> +	pre->q_prealloc_lo_wmark = res->softlimit;
> +	if (!pre->q_prealloc_lo_wmark) {
> +		pre->q_prealloc_lo_wmark = pre->q_prealloc_hi_wmark;
> +		do_div(pre->q_prealloc_lo_wmark, 100);
> +		pre->q_prealloc_lo_wmark *= 95;
> +	}
> +
> +	space = pre->q_prealloc_hi_wmark;
> +
> +	do_div(space, 100);

Maybe use div_u64 instead of the fugly do_div helper?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
