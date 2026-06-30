Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DCE2D2397;
	Tue, 30 Jun 2026 06:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782800241; cv=none; b=coWkouaPJlWMMuR0REafnu8hcAeETBr771SH2mRaWEq3UU1D2BxRDXhzBwuTJrdLfqh5J1xMr+2SPg6LXS65SyVJSYzs6EFD/Vs6pgAKhB9xNZDjbqU75Fy3bZRhTDdHgXgma4rXRdb0kbapotAoebYM5LhpbdzKfcD7XJMez9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782800241; c=relaxed/simple;
	bh=kIXGjxfNKN5+oqWFgsDzhwJX6Jk7wJXKkIGssxnYa1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueqUFa+Mo7PGubq/iYMPBCH+SiD3Hb/+M0SUQMFUxZ4yGDaVm75LGyfEOnY2FXLYRqWIa0Jh7qo6m1kuXnENWWVHwV5bq3ycWR8l2ECzZ5kb1SiBKr1L87+o6U+QTSxtjtqPqShUI6j0eUI6pMfO7L4HcmevMHqOmUSQSdywYg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BZadDrDN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BZadDrDN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OpD5BoHGpN5+c5sunrjRG6A/khOVjHowQ6wCVHeCJQU=; b=BZadDrDNtXqrMmkVBsOlbDa953
	MUOckoPHhH0czqNQJhDf98xS4yzMkWcTdMiDyq/9I3ICvFK6EJm41DnMW0eVLBAZZ2uwyLeLIOEhl
	Jrdu4GGGjA3z0cGzwjs4AF2doZMNFYRr7yd8FGsNkfGAvcQ8yRfV3MpieH21SVEgMoqB5p5cFwsBl
	3gu+YWORhOWhNBvs5Z79okyyjuR1QNvoJhV8pf57Dcd7J6amJWCQ32tcxLhfsqdjrCk9O+UWF0Q3b
	DPZtWf8CGTiU+HP/iVCw1DjRVE2a0twbWHSjKu7yvMIh4ddqGYsyW34G5pDnoJ+g8B2GeLSHDp9IV
	5dDPlIig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weRmZ-0000000FuGI-1jEe;
	Tue, 30 Jun 2026 06:17:19 +0000
Date: Mon, 29 Jun 2026 23:17:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com,
	pankaj.raghav@linux.dev
Subject: Re: [PATCH v5 2/4] iomap: factor out iomap_dio_bio_release_pages
 helper
Message-ID: <akNfb8f_EI4vP5Kd@infradead.org>
References: <20260629120124.25223-1-changfengnan@bytedance.com>
 <20260629120124.25223-3-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629120124.25223-3-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 29, 2026 at 08:01:22PM +0800, Fengnan Chang wrote:
> Extract bio page-release logic from __iomap_dio_bio_end_io() into a
> helper taking (bio, dio_flags, error) so the upcoming simple direct I/O
> path can reuse it without a struct iomap_dio.

The first two branches can't happen for the simple code, so is this
really a useful abstraction?  I think just open coding the
bio_check_pages_dirty / bio_release_pages might end up simpler.

