Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E141DDEE
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjYw5Pnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8083C433C8;
	Thu,  4 Jan 2024 07:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704351677;
	bh=RqBhKWkFis19hqqQmUIi8WVLIMhvoMfnNJPLpNlMPlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjYw5PnpG4O4E8HKV0wMCADjEuC8FrX/hoUOYV3kmHpX2IKXh3WZ8grf3XETlzGjm
	 Fi/OHpBNV1wI7IYWmXHTf0Yb3IycxDKUbXtT2NX+H0M4gUAQjNnPj3OehXuZF6eVEG
	 rLhnvObOcq5uTvM8HcRc4MdQlv9a0lgFAjBjUBp2Rx4R4cpyrMEhK7unyP5YCILLgx
	 UPnoPkwQslZll5z6wgbzUivDbtL86k58YKn+bT4vbKIoVVv54n80WXoyy2S/CowXBd
	 Xe5hv1+U5N8YLYFpH954/LLXn+xGo2BU6AjZ0uYRGRTviELu3DeFmVCeyzrDT+L06H
	 ErvIo/WtbiDDw==
Date: Wed, 3 Jan 2024 23:01:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/15] xfs: don't allow highmem pages in xfile mappings
Message-ID: <20240104070117.GX361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-10-hch@lst.de>
 <20240104000324.GC361584@frogsfrogsfrogs>
 <20240104062428.GC29215@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104062428.GC29215@lst.de>

On Thu, Jan 04, 2024 at 07:24:28AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 04:03:24PM -0800, Darrick J. Wong wrote:
> > > +	/*
> > > +	 * We don't want to bother with kmapping data during repair, so don't
> > > +	 * allow highmem pages to back this mapping.
> > > +	 */
> > > +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> > 
> > Gonna be fun to see what happens on 32-bit. ;)
> 
> 32-bit with highmem, yes.  I suspect we should just not allow online
> repair and scrub on that.  I've in fact been tempted to see who would
> scream if we'd disallow XFS on 32-bit entirel, as that would simplify
> a lot of things.

You and Dave both. :)

I guess we could propose deprecating it like V4 and see if people come
out of the woodwork.

--D
