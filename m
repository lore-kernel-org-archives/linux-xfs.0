Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A6D179A7
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 05:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720762111; cv=none; b=LkBdBljdGEaANGbCbebk0SyeuZoMlEIwk7yb2x1gNwOG4Bi2XkrOzlYGiQR7L8hy/WZ/CVt1fxlI2y8kbxSZCBMRojH1d1Yey1RDsw692+nFVuwWYh26By2LVxG7gxnR8hSgY60zcmzF1Fc9mLkI6YotrnceT4FrZKvh8ZoDB30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720762111; c=relaxed/simple;
	bh=f7IkjvBe5g8G5DqI/LjtTUmf+hBQ23y7q9jeLxhGA3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qT/nh4AEQS6XxzKtSRfMVSJVrh/ILtkIWP85org9B7lq+oRbKz0usc6opIXrqt6P+JnO1C6/dG5DHTXPW/UtnEockGfCTRemp5PVNreZdkfxpb0UmNkIJKUuAXcLrbDVSxZWE0PHA4mLTnJbiRwc02Nt19BW5hYBslCHQGSpV10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3M9XR8dn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3M9XR8dn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lcVJOyJcrsFfDPhNMIBlcsFd4tua5ECA8f5c1xSeSG0=; b=3M9XR8dnyBgDbCdw9PD7UJySJZ
	jLa2GYUvj2CGwEzqgI9B9YQX6tGddTIlHNUyryCHupDQmXyJZcmeR380DyR6QxbdmgwGiC8EXQ0Jq
	0jDbB+ZDck4hsToWa9RNo0bR3M3sMyolKRvkwjeJU9wK7XKznjr86MEWJdy+uFWoC5u/4qd2ZZ/JI
	VpVEGWyOYi1q30uFLOBVTSabvYJHFdK2YmSwGzy7pxj/8SZsyWXJNJkEu6uCiteZNK/eKBZz2b9OU
	iBgUWZep3yDP2gFj/TWumQ4Ot+AxdtREEkOzQg0eAI9PhaJANQrsx1/5Nv19cUjVEOOhSpJ+aEWWU
	x/CI6D/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sS8pZ-0000000GWZq-23Nt;
	Fri, 12 Jul 2024 05:28:29 +0000
Date: Thu, 11 Jul 2024 22:28:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: honor init_xattrs in xfs_init_new_inode for !attr
 && attr2 fs
Message-ID: <ZpC-_Rv4nPa2Bw3z@infradead.org>
References: <20240618232112.GF103034@frogsfrogsfrogs>
 <20240619010622.GI103034@frogsfrogsfrogs>
 <ZoIF7dEBkd4YPlSh@dread.disaster.area>
 <20240701233749.GF612460@frogsfrogsfrogs>
 <ZpB5fS822UrP6JIs@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZpB5fS822UrP6JIs@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 12, 2024 at 10:31:57AM +1000, Dave Chinner wrote:
> Suggesting that someone else should do the work to tidy up the loose
> on-disk format ends in the kernel and userspace in preference to a
> one line hack that works around the problem goes against all the
> agreements we've had for bringing experimental code up to production
> quality. This isn't how to engineer high quality, robust long lived
> code...

I don't think it is entirely unreasonable.  The code works totally
fine by not forcing attr for parent as Darrick pointed out.  It's
also kinda suboptimal and stupid as you pointed out.  So if you care
about it, just sending a patch would be a lot nicer than ranting.

