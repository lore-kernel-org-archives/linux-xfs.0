Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4gqWvj2S"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C87E182
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 23:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+p9OwlN10r17NwS4BYbtWRDyhHNrd76yOUzgHsvHtwE=; b=4gqWvj2SnJltwKQ/a/gg0Q67Nv
	lYt4Jhd7VopdzfL011jRWfghQ61a1eaUioilSQyOMmxPDjB2qoDx2aeqrJH4dRfYcBLaJYQo8gU3w
	Lx4oJfrM+EjbTV+otdvINnHsPqSW73RG0G/vilD/jo9FDr2KR8iwDieDptXUfeXa+8FUv2z0eAa5L
	xB9MxqsZRgQ41ZSbv4M6Uzysv/Jihtgse/9CI7MpKc3oT2iHIJGrFF5lXI6zoDqyH5va/ZcdzQtAa
	mhJgOyKTWOV9/b3Hne4nKT8YN8oJy4ojY5ht66IgOYGtMWyVEwfBQ4drBrahcyxqxkR7V906f0ZtS
	LMDves/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7sHs-004LS7-2z;
	Tue, 28 Nov 2023 07:13:40 +0000
Date: Mon, 27 Nov 2023 23:13:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <ZWWTJGq1ldOm6inW@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926593.2770816.5504104328549141972.stgit@frogsfrogsfrogs>
 <ZWGK6Ig752wdBvwF@infradead.org>
 <20231128015041.GO2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128015041.GO2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> > If my understanding above is correct this just papers over the bug
> > that a buffer that is marked stale and can be reused for something
> > else is left on a delwri list.
> 
> I'm not sure it's a bug for *most* code that encounters it.  Regular
> transactions don't directly use the delwri lists, so it will never see
> that at all. If the buffer gets rewritten and logged, then it'll just
> end up on the AIL's delwri buffer list again.

Where "regular transactions" means data I/O, yes.  All normal metadata
I/O eventually ends up on a delwri list.  And we want it on that delwri
list after actually updating the contents.

> Every time I revisit this patch I wonder if DELWRI_Q is misnamed -- does
> it mean "b_list is active"?  Or does it merely mean "another thread will
> write this buffer via b_list if nobody gets there first"?  I think it's
> the second, since it's easy enough to list_empty().

I think it is misnamed and not clearly defined, and we should probably
fix that.  Note that least the current list_empty() usage isn't quite
correct either without a lock held by the delwri list owner.  We at
least need a list_empty_careful for a racey but still save check.

Thinking out loud I wonder if we can just kill XBF_DELWRI_Q entirely.
Except for various asserts we mostly use it in reverse polarity, that is
to cancel delwri writeout for stale buffers.  How about just skipping
XBF_STALE buffers on the delwri list directly and not bother with
DELWRI_Q?  With that we can then support multiple delwri lists that
don't get into each others way using say an allocating xarray instead
of the invase list and avoid this whole mess.

Let me try to prototype this..

> It's only repair that requires this new behavior that all new buffers
> have to be written through the delwri list, and only because it actually
> /can/ cancel the transaction by finishing the autoreap EFIs.

Right now yes.  But I think the delwri behavior is a land mine, and
this just happens to be the first user to trigger it.  Edit: while
looking through the DELWRI_Q usage I noticed xfs_qm_flush_one, which
seems to deal with what is at least a somewhat related issue based
on the comments there.

> Way back when I first discovered this, my first impulse was to make
> xfs_buf_stale wait for DELWRI_Q to clear.  That IIRC didn't work because
> a transaction could hold an inode that the AIL will need to lock.  I
> think xfs_buf_find_lock would have the same problem.

Yes, that makes sense.  Would be great to document such details in the
commit message..

