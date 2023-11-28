Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mrot9lew"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B184CD49
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 07:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jbYDBB5Wdt18VBWj03+mTqGyWVjuYBX/6nrcHnQ6Gso=; b=Mrot9lewQGEJ5iFOza7oXEOC5j
	pcs43idsTeIfZDOYOdlmBzZyLZgQZcukVWt0sUJZAw+LwbVF+6af87Di5+JvTFYhe6umbfyrqfy0I
	dJzgYh6nTJvVIhp96uUNAiKcglmaR8MtOGiGsD10zOyZj9vmo6pOM2w0A4zAwC6QtEBlKYHNc4iBC
	ai3x6WZb/gi2JIuOwQnarB7fDZlNVtcZLvPBjNWK/o+J8BZpj0kr21C/KipjC45t3cgwUy1BB94wk
	sEV59KlfwQdtiizSSVMCS8wUUoM453oZobUSZ+auiufcMmoYkKoO1pD4KNVqWw1JKcsmbkKmIxlrV
	FGdhKogg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7zqw-005eYC-1s;
	Tue, 28 Nov 2023 15:18:22 +0000
Date: Tue, 28 Nov 2023 07:18:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <ZWYEvqZHj4KX4wqj@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926593.2770816.5504104328549141972.stgit@frogsfrogsfrogs>
 <ZWGK6Ig752wdBvwF@infradead.org>
 <20231128015041.GO2766956@frogsfrogsfrogs>
 <ZWWTJGq1ldOm6inW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWWTJGq1ldOm6inW@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 27, 2023 at 11:13:40PM -0800, Christoph Hellwig wrote:
> > Every time I revisit this patch I wonder if DELWRI_Q is misnamed -- does
> > it mean "b_list is active"?  Or does it merely mean "another thread will
> > write this buffer via b_list if nobody gets there first"?  I think it's
> > the second, since it's easy enough to list_empty().
> 
> I think it is misnamed and not clearly defined, and we should probably
> fix that.  Note that least the current list_empty() usage isn't quite
> correct either without a lock held by the delwri list owner.  We at
> least need a list_empty_careful for a racey but still save check.
> 
> Thinking out loud I wonder if we can just kill XBF_DELWRI_Q entirely.
> Except for various asserts we mostly use it in reverse polarity, that is
> to cancel delwri writeout for stale buffers.  How about just skipping
> XBF_STALE buffers on the delwri list directly and not bother with
> DELWRI_Q?  With that we can then support multiple delwri lists that
> don't get into each others way using say an allocating xarray instead
> of the invase list and avoid this whole mess.
> 
> Let me try to prototype this..

Ok, I spent half the day prototyping this and it passes basic sanity
checks:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/xfs-multiple-delwri-lists

My conclusions from that is:

 1) it works
 2) I think it is the right to do
 3) it needs a lot more work
 4) we can't block the online repair work on it

so I guess we'll need to go with the approach in this patch for now,
maybe with a better commit log, and I'll look into finishing this work
some time in the future.

