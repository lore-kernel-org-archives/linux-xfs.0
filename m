Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25FB4779E
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 04:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720670598; cv=none; b=aPYqgkbVW9coRgCG547FpyOvVpCdAZNHX+z1D6xPfivwfmYdsWu0v7jF76LZb4v6UWwG/DEFBGBxJD00MN8auzBDCUzJVLO+ll7d0Q4/X67E0C0jEssZmzpoqQ1qeDM9YTG712mVDuBg0uGeMKzJ5nzfjrg/TTOQRIGTykoqf2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720670598; c=relaxed/simple;
	bh=H87xu+RuOVLFd6y7CqpQSIhZj4Mv9nCwJs0uz3vLf50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGciBcqxgl9HkryGT9biSQj7J+5aFsTiCyCXlZ6Y8Lvdjesvl+XHYzPi/GRx2WftQQPjQYBoKpQWnWJfyr5HY9FtxDyoJHrITGSDjAKOnWfASCE3nKm+o4hVlvFP22HtfzDqAg9haT3hUsfb6zWtXQr9mRfB08kYLWOHwrqsARo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I5FFypDW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I5FFypDW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LL1MQt2nc2qlIJt136MWYbqaSZe4VTRW5TX826+q/r8=; b=I5FFypDWRIiwsetfrXsA/SOvTI
	Mp5dRd50xFyDsFxR+CLqCldcwVTweN+NiYWtj1I/Wjx/zAdnv8hUPC9yBheSvSEMv89iglvCiZfaN
	YmJGrTgcFkdjs65IxIeASSy0YitKXRNpypUt2yItNongnaaAoESzwRUnhbmu1zsbFBkrAcnWn0Tqu
	3xY1e3+WQNgUL1l7DMBMKNWzpLaC88qtoMcHeckDwhLdn3hfzJzk+voE6nF40RlOVTtNQoEUGQ6zP
	fnnBfou3vjgBNUc+Thfb4NODJ1f4JE6Vcm7HGTPY+hblZTXZiY3vDUdu8Snbr1jnkX5VnNtwEZjwL
	3pDYxF7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sRl1Y-0000000CdZB-03aq;
	Thu, 11 Jul 2024 04:03:16 +0000
Date: Wed, 10 Jul 2024 21:03:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update XFS_IOC_DIOINFO memory alignment value
Message-ID: <Zo9Zg762urtBzY1w@infradead.org>
References: <20240711003637.2979807-1-david@fromorbit.com>
 <20240711025206.GG612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711025206.GG612460@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 10, 2024 at 07:52:06PM -0700, Darrick J. Wong wrote:
> > -		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
> > +		da.d_mem = bdev_dma_alignment(target->bt_bdev);
> 
> bdev_dma_alignment returns a mask, so I think you want to add one here?

Yes.

> Though at this point, perhaps DIOINFO should query the STATX_DIOALIGN
> information so xfs doesn't have to maintain this anymore?
> 
> (Or just make a helper that statx and DIOINFO can both call?)

Lift DIOINFO to the VFS and back it using the statx data?

