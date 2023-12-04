Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Du+nCDnL"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE3BF2
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dS4e0t8q3339cSf4kWx8K9stNICyeWMET3CGw4z8JSo=; b=Du+nCDnLdudhQIGaxQOyRHTLP0
	h/JJzrrM6VzsAGfzgi3qo9/hmAAf/MnNNG9462FUJogRj4RcFghUDShIoT92SJ89FrwMZxWv8Rsr7
	E4zaXyBLLCuKeXDPoYe5i540Ev7Onq+KKgmLaiFvfQM1lq94nPWqewdiJkD69cuvtPZsMpM12wtgU
	rxBf8FLIxdnyEO+qg+xpBGa9iZfQRZJBPV6M3nndKo2N8ENB3f57YaMt83MI2389d0gw8h+0IiDp8
	yrERaxNL9sVleRnc+VMnJ/J0wPiMkig0rpUfdkpkLE7QLo1nwOjHACsg3BElVl7LsrTXLN1Qs1KCe
	x9EoETaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA0uW-0030Rx-2M;
	Mon, 04 Dec 2023 04:50:24 +0000
Date: Sun, 3 Dec 2023 20:50:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, leo.lilong@huawei.com,
	chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: use xfs_defer_pending objects to recover intent
 items
Message-ID: <ZW1akF6YCrstcoEi@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120320014.13206.3481074226973016591.stgit@frogsfrogsfrogs>
 <ZWg/eyy9RUz2nliq@infradead.org>
 <20231130171455.GI361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130171455.GI361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 09:14:55AM -0800, Darrick J. Wong wrote:
> > > +	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> > > +			GFP_NOFS | __GFP_NOFAIL);
> > > +	dfp->dfp_type = dfp_type;
> > > +	dfp->dfp_intent = lip;
> > > +	INIT_LIST_HEAD(&dfp->dfp_work);
> > > +	INIT_LIST_HEAD(&dfp->dfp_list);
> > > +	return dfp;
> > > +}
> > 
> > Initializing dfp_list here is a bit pointless as the caller instantly
> > adds it to log->l_dfops.
> 
> I'd rather pass the list_head into xfs_defer_start_recovery so that it
> can create a fully initialized dfp and add it to the tracker.

Sounds good to me.

