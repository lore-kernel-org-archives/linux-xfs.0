Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBED61B9B2A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 12:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761852; cv=none; b=R9HE8i6swo8i9+JS6e+lhPYdhtQ6A7wGMHXi7dbrTwtKNLWSHdoxt5PFXzf3Ttb0JQFQaSu0jSYIOtd5Z68F12aU1dJT1Vc9fDpnsfjLPvmB+30wG5ydUeJZt19dNlH8xYqt3vaDNnaHMEg0cR6SzIww7wZm77j/Vto37PqX6gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761852; c=relaxed/simple;
	bh=gH30t19bfaHFYhI07d2sLFkZ6c8hpOf8iLzRXBNttew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ua+kBj/U/W0+5ae2pupdGkFn98LK09zQGLmbHXeewByl+zK6ltN1D6kEmiU0YCRAVmd/xn9f3FjbJ7rLfqCXo1VOKZeBz9pAr87bpzF4Qhtr76bIdxV4lUNMWDYTMX8g68bKS4mhyh8/8Dm/lrZIF+xsX4cdk7D4R0rOtMi2qcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xr7/apLa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xr7/apLa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cVAi4ZgMMfTh27IOI9S3B4v+kbzfigsf5mLlb4Y1mFQ=; b=Xr7/apLaUMO4l4Vmawj4NMZaiT
	vkbNsWJ0AmEOcEPyvKaz5WMOjWbURXWkPNV7QksLBh0XMt9vhNiPIeKAUmYLS6mkOZgjL3ZPPkGVU
	vd2L+ge763p4LyxiJhK2NPWM8ygh2rHBwz7wM9TiA5R+C4UteoccHc4J5Fpflvd7FhBP0SQ7hcK4k
	uY1NzWsgXftZ6eC5Y74b7s2uBCqZqt0Xlhoe9WLM0dWSY1ugKky95TTRwatXEaGuPz2toJ4LBLwkg
	iQdHcRyxJSCIBR44P7yIVmh6NWEEXuUUuMkRvYeOV5LAFIVcBvQ8deJtxJQqgPcFDl+ZoSNkPNyre
	7wMNxvRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sivLV-0000000BEyf-3pxJ;
	Tue, 27 Aug 2024 12:30:49 +0000
Date: Tue, 27 Aug 2024 05:30:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Long Li <leo.lilong@huawei.com>,
	djwong@kernel.org, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <Zs3G-ZrwPsOjuInE@infradead.org>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
 <ZslU0yvCX9pbJq8C@infradead.org>
 <Zs2jpYJHBtYqSMmD@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs2jpYJHBtYqSMmD@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 27, 2024 at 08:00:05PM +1000, Dave Chinner wrote:
> Hence the only cases where the item might have been already removed
> from the AIL by the ->iop_push() are those where the push itself
> removes the item from the AIL. This only occurs in shutdown
> situations, so it's not the common case.
> 
> In which case, returning XFS_ITEM_FREED to tell the push code that
> it was freed and should not reference it at all is fine. We don't
> really even need tracing for this case because if the items can't be
> removed from the AIL, they will leave some other AIL trace when
> pushe (i.e.  they will be stuck locked, pinned or flushing and those
> will leave traces...)

So XFS_ITEM_FREED is definitively a better name, but it still feels
a bit fragile that any of these shutdown paths need special handling
inside ->iop_push.

