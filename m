Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FBA3C1F
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 05:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736745288; cv=none; b=j8MkEs7LU4Hy8tvGWrgGcVBt2jqNfSxGSlch+ARAqLC0Ua+Yucbq53edoO1n1GeBKqMKVkPzTggXdt6iI8nkFkcbqVlju+SeSLmQvjqfe2Qcdwby2xrlAe/k1UdEm0c+7IesvlloYC4PIheF9J+hPJ5JwnTbhbTwD2OmA6Y2HS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736745288; c=relaxed/simple;
	bh=8krdDQ7WCJ42whxHX4aRlPM4i4Yx1ydYwnY2WaIWABg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sx34aNAmxQBV66ECFhpPhqJ902v/Jaksj56mwmxW+drsNEce1BCPpLD1nHJfgrYzs0YLK/ADrBCkmFcwZbAq+ps3+1rzVfClr1sPKFJlQ1VP4V8kxXg3fjV6eXhBXvtydkGNYTHneyUPp/6foVH91BUIZQKy6/CNZUP9gv98ulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6751968BFE; Mon, 13 Jan 2025 06:14:35 +0100 (CET)
Date: Mon, 13 Jan 2025 06:14:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: fix buffer refcount races
Message-ID: <20250113051435.GA23103@lst.de>
References: <20250113042542.2051287-1-hch@lst.de> <20250113050846.GU1387004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113050846.GU1387004@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jan 12, 2025 at 09:08:46PM -0800, Darrick J. Wong wrote:
> > This might actually be able to trigger the first one, but otherwise
> > just means we're doing a pass through insert which will find it.
> > For pure lookups using xfs_buf_incore it could cause us to miss buffer
> > invalidation.  The fix for that is bigger and has bigger implications
> > because it not requires all b_hold increments to be done under d_lock.
> 
> Just to be clear, should this sentence say
> "...because it *now* requires"?

Yes.

> > This causes more contention, but as releasing the buffer always takes
> > the lock it can't be too horrible.  I also have a only minimally
> > tested series to switch it over to a lockref here:
> > 
> >     http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-buffer-locking
> 
> Will take a look; some of those patches look familiar. ;)

Well, the first batch after these fixes are the buffer cleanups I
reposted last week that you've mostly but not entirely reviewed.  The
reminder only really depends on them for changed context.

