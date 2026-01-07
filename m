Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3AB13AD26
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 06:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766333; cv=none; b=BLNvFl2/RRC3IYaeUrn6+d4obUKWG3qOTwG/KtGbdCqfaqxkX11AWLRL5LmFpTMgM8Kk65ZxdiG38ZV+V+6SjokO+Z5XGQI317L+aJqrbpYkmUvT2OkXuIhoJ9GErvXfsyGU9klVn88ewQzDnDP0u1F5EpzJIThu9rdASpjVZ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766333; c=relaxed/simple;
	bh=usKOjZp4yv0Ukc0w1z+sLkkM48isacHOv4PvcfK+17Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmd4FzQnZXXh02JFMS6pilAam/419q/sC5J3Yh/1YTPoxNH/QcPjUPqPKcpDpyS3FYTTK6JazwGenQwE8WzHFloljdujsI5Foi5JnyKonX8n7E4CO1kwEhlzDvD4KX/4wO55WAcD/ve9j1fIYZEnCpScTSgqniIMmzCvg/hpZIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MpEW/Y2c; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MpEW/Y2c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xLJT44Vr9EHdHEm4/9k1Elk4VkXFWoYO8uvqK7ZRxek=; b=MpEW/Y2cE66fPwtpCXWnycjuM7
	/7adrrySXM+d8S+cKoXKN0xpAPSt/NyfluDeiRwNBBOyBoMuQOBGCk+ZLWR0mb1Aqp/3d7UQ6Zs9H
	itnmU9oPTL1HLy2DQtc3tmGR5Cu6romREgy6zm5jnp6v/TFJVqyQ+tuQrdgFLsCQ7+1rHHvN2Z1N9
	K4pxJpWTjw5gteEKUSEH8sMtcwNTWBkquUSEejbFQBwlNi7P9IK2Fn/IioyHxEAtFrI1ltIbzXk7w
	rn7nW7xBg8XURlbK42ES9B2Izi+Wpi6/nTbFYysBRJE82G3KoO2jAhIn3f7gHIzfvoeK6o8L78SXh
	5Zr0Arig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdMm9-0000000ECcX-2b34;
	Wed, 07 Jan 2026 06:12:09 +0000
Date: Tue, 6 Jan 2026 22:12:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_mdrestore: fix restoration on filesystems with 4k
 sectors
Message-ID: <aV35OUeSf-g99rbY@infradead.org>
References: <20260106184827.GI191501@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106184827.GI191501@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 06, 2026 at 10:48:27AM -0800, Darrick J. Wong wrote:
> +	/*
> +	 * The first block must be the primary super, which is at the start of
> +	 * the data device, which is device 0.
> +	 */
> +	if (xme.xme_addr != 0)
> +		fatal("Invalid superblock disk address 0x%llx\n",
> +				be64_to_cpu(xme.xme_addr));
>  
>  	len = BBTOB(be32_to_cpu(xme.xme_len));
>  
> +	/* The primary superblock is always a single filesystem sector. */
> +	if (len < BBTOB(1) || len > 1U << XFS_MAX_SECTORSIZE_LOG)

I'd use XFS_MAX_SECTORSIZE here instead of open coding the shift.

Otherwise looks good.

