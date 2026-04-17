Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A7C3815E6;
	Fri, 17 Apr 2026 07:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412291; cv=none; b=AtM1NiD6i3i7ZfXNorSiu7oy2/9mzCR/n29Gf94cOhGFSz5uHHFjTSqDGLUobqu66JiExsnHD8DvDZUYagflG9x4PvEyYOOipQ/Wv3Kk7AL1oG/BQkSft/mxRe9/zUY4FD3edE57zqdLAfhX8SXtoen/UHT8k7ia/WfZOr1MgTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412291; c=relaxed/simple;
	bh=+yNf/Fg00yvhmx5hpyRNbZQbe8W/SBfILSFYHiTpr4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQiInbL0vE35PW/ow/ej9ffNvtWUnNodc2FoowrfbD9gXO4ekNdwMjoUO6aMFSN6qAYVwNKipww1EnqtvS7WfNWuVGNikKFma4cqugImWpfBidbOILG0maa7UMLWx1Ww5+Xp729jaZU1zNWN477qwtIJyP0NmrejGhD/ZrH1fNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=09rISPL8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="09rISPL8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ufQc+KuGEWII8IYRTn6hCMin1L5dlDfSCylJ26r2oHk=; b=09rISPL8TPcY3L6WvEF2R7nAaB
	vNY8OZk0pE6/mXbSS5trqbPR55p4H7gCsW1C2CiG/yi8+KTHXQkrtZm/8dcpt//dKkb/TKO8noOVC
	2ZaKf9+eWFujq+1bIzRbpYiacKv4SHapablNkdXOXjQQ6UFcGRkD1kIyJytmUr5YWeVqwafHHe6hK
	tFUgX/s/BjKcWeOlHsMI7W+HXOdYgJeKfsQnYBqx8EOkvWCpeTVdon65NnXRuOMAbL52qqNeAKPwz
	mAY9nkHn3hGK9zCwRZ6HmQIQb5dJ8yCo3wkM0e2ZtVmvwFygB4olbPOfqS+/jal2CLMumTrXhnzhS
	A/2hOaFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDdz0-00000003ct5-1unN;
	Fri, 17 Apr 2026 07:51:22 +0000
Date: Fri, 17 Apr 2026 00:51:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix memory leak for data allocated by
 xfs_zone_gc_data_alloc()
Message-ID: <aeHmevGYolL2Pgvt@infradead.org>
References: <20260417021628.2608734-3-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417021628.2608734-3-wilfred.opensource@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 17, 2026 at 12:16:30PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> In xfs_zone_gc_mount(), on error, a struct xfs_zone_gc_data allocated
> with xfs_zone_gc_data_alloc() is freed with kfree(), however, this
> doesn't free the underlying folios or the rmap_irecs.
> 
> Use xfs_zone_gc_data_free() to correctly free this memory.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

