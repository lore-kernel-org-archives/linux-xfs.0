Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ycxb1oAb"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44EF170B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=90OTXwXkcFAQGnvp7Y+d5ysa+8peyggU/CYt7Uqyems=; b=ycxb1oAboOAXGozxWRo8T6RVWz
	E9YTNmlOuVUtcS5m7Ttmdf+LrrJOVl7V6HytSvHtq8rx5iPiyy2uuISXYa5pVA8OcEpI2aEAuGxCe
	iHOAt9Qva+FpOZ3M8rsJID7Hoy968o4/kqqGcENzv1DSwJ4eCFHyYNPxVMvhsjHBgHWUa7wGRwe5Z
	z5vsbRkZeWPcTX0++IsiM1wWmauelTx899k/AK7Dk9UrUOCkagbiEJKO9IbVCq2vpOEnmCBVzRWtN
	C550Z6Sr8E9DlqpmfKcsZ2jgQBnykvVWTTp9hoUtIZ9KmDQ8GTz/Qmvio5DUW41WBxPGYXH7L4mRL
	8rEX3GPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lXk-008dAW-1m;
	Sat, 25 Nov 2023 05:49:28 +0000
Date: Fri, 24 Nov 2023 21:49:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <ZWGK6Ig752wdBvwF@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926593.2770816.5504104328549141972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926593.2770816.5504104328549141972.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The code makes me feel we're fixing the wrong thing, but I have to
admin I don't fully understand it. Let me go step by step.

> While stress-testing online repair of btrees, I noticed periodic
> assertion failures from the buffer cache about buffer readers
> encountering buffers with DELWRI_Q set, even though the btree bulk load
> had already committed and the buffer itself wasn't on any delwri list.

What assert do these buffer reader hit?  The two I can spot that are in
the read path in the broader sense are:

  1) in xfs_buf_find_lock for stale buffers.
  2) in __xfs_buf_submit just before I/O submission

> I traced this to a misunderstanding of how the delwri lists work,
> particularly with regards to the AIL's buffer list.  If a buffer is
> logged and committed, the buffer can end up on that AIL buffer list.  If
> btree repairs are run twice in rapid succession, it's possible that the
> first repair will invalidate the buffer and free it before the next time
> the AIL wakes up.  This clears DELWRI_Q from the buffer state.

Where "this clears" is xfs_buf_stale called from xfs_btree_free_block
via xfs_trans_binval?

> If the second repair allocates the same block, it will then recycle the
> buffer to start writing the new btree block.

If my above theory is correct: how do we end up reusing a stale buffer?
If not, what am I misunderstanding above?

> Meanwhile, if the AIL
> wakes up and walks the buffer list, it will ignore the buffer because it
> can't lock it, and go back to sleep.

And I think this is where the trouble starts - we have a buffer that
is left on some delwri list, but with the _XBF_DELWRI_Q flag cleared,
it is stale and we then reuse it.  I don't think we just need to kick
it off the delwri list just for btree staging, but in general.

> 
> When the second repair calls delwri_queue to put the buffer on the
> list of buffers to write before committing the new btree, it will set
> DELWRI_Q again, but since the buffer hasn't been removed from the AIL's
> buffer list, it won't add it to the bulkload buffer's list.
>
> This is incorrect, because the bulkload caller relies on delwri_submit
> to ensure that all the buffers have been sent to disk /before/
> committing the new btree root pointer.  This ordering requirement is
> required for data consistency.
>
> Worse, the AIL won't clear DELWRI_Q from the buffer when it does finally
> drop it, so the next thread to walk through the btree will trip over a
> debug assertion on that flag.

Where do it finally drop it?

> To fix this, create a new function that waits for the buffer to be
> removed from any other delwri lists before adding the buffer to the
> caller's delwri list.  By waiting for the buffer to clear both the
> delwri list and any potential delwri wait list, we can be sure that
> repair will initiate writes of all buffers and report all write errors
> back to userspace instead of committing the new structure.

If my understanding above is correct this just papers over the bug
that a buffer that is marked stale and can be reused for something
else is left on a delwri list.  I've entirely thought about all the
consequence, but here is what I'd try:

 - if xfs_buf_find_lock finds a stale buffer with _XBF_DELWRI_Q
   call your new wait code instead of asserting (probably only
   for the !trylock case)
 - make sure we don't leak DELWRI_Q 

