Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83851357D07;
	Wed,  2 Sep 2026 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788359549; cv=none; b=kfpN7vC8ESHD4Wz6qCUYGjgR1jNKPJTRe2TFB+1vu3dbfGn2naq08epFAw1e8F4xfpNdtFo8h5Bov8BIdgRg5UgS5GMe4ZOXGSUErsxHNvossxr8SoSj/kHTCfHMiiwjWdT69N1X0cRs1gg4Ysl+CV6Q+Wb1sPtT0p0sbr2e0AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788359549; c=relaxed/simple;
	bh=TMnlBVhLESW2ZT0OwdtTHwpYohURMcdJs8ocvokYsec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izmqzW3rhXwQN6HanzeduzifApx80eST6eC904esj7pyKXA7fubYgkK1hfafM0M5IPydCDe1ANOhhG5qg6d0qsdYMUmwLPAoZIqrbx0wyJse9FvLYmTOEybXRmsLsFVCDE+h0nfl4hD3iQYY6cq3eVvC9+6/P7OGKOBnfJ1cJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x94EtOSW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x94EtOSW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EJThRJxcb5ZyZDKnZjsJGD0FqhAXwnBk13tyzhihRaI=; b=x94EtOSWAUSX3HLBg0leRaCPlV
	GdYrOK9kldOMx2U6iAsjteD+CbZaKRJp5J38nHE5xU0/SqKFUSsFYLDFQOlP7I0A0chlc9KuqPS5c
	jjN4mw05LVyc/LlTQiQC5tG1k3jencqnNrEpbeTwa/xa9pb/YlqkX82VbiN4MjUodzkgBRoVVxmru
	ik7g4VQncUo038xq54h/Q/Qvz3dBxcmauqJNZ7Mrw1egTjB7CvK0WX7JWhtoTyMmt4Q+pC14wNH5c
	3XJPuldMR+kc7yQgXSgzHemS2PpNr5Ao+S6wUGd4PbSvUYZVw6q/qKt0vQesbYfS6EnKkcA9Sydns
	Dgpvhcpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1m0i-0000000ExMs-2Re1;
	Wed, 02 Sep 2026 14:32:20 +0000
Date: Wed, 2 Sep 2026 07:32:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] xfs: remove dead kswapd flag inheritance from btree
 split worker
Message-ID: <apgzdKWBDn4rpIO5@infradead.org>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Sep 02, 2026 at 09:16:50PM +0800, Kefeng Wang wrote:
> Commit 1f6d64829db7 ("xfs: block allocation work needs to be kswapd
> aware") added PF_MEMALLOC | PF_KSWAPD inheritance to
> xfs_btree_split_worker() so that block allocation offloaded from
> kswapd to a workqueue thread could access emergency memory reserves
> and avoid reclaim throttling.
> 
> pageout() no longer calls ->writepage() for filesystem folios -- it
> returns PAGE_ACTIVATE for non-shmem, non-anon pages.  kswapd therefore
> never enters XFS writeback and cannot reach btree split.  The only
> path that offloads btree splits is unwritten extent conversion at IO
> completion (xfs_end_io -> xfs_iomap_write_unwritten), which runs in
> a workqueue context where current_is_kswapd() is always false.
> 
> Let's remove the dead kswapd flag and related codes.

Nice!

Reviewed-by: Christoph Hellwig <hch@lst.de>
