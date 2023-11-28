Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB8A1C2E
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SjIYce3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA69C433C9;
	Tue, 28 Nov 2023 01:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701136241;
	bh=Hc/a3jko4XbIm+DOh9Lbw+mIcbyFSfDsoGxvVOnlo9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SjIYce3rR6tGkVGSjZyt2fhjmd9G9gfcD1422ZZa540Dx1f2tD/JTBKmFN1RT4RYh
	 WKTujubtAvY6/XU+owKqkxMJtREojhlPWM42A+SsjdktXstTDjWK+jeKSl/PWwC7Tm
	 A2DddeCuKlY2amiREbfz6C7FxkoH/H3xw+r1fOpK3aI28T9LW9eb8ocGBKKHSLWCfl
	 9F4NHeXDTD5W2sUs9GhrWVwNLiBz3d6P7RcgllbxnIo/X+QDa21VYK4J8pJzLQB6Hk
	 JZlr+wi3JYrPjjs24dwJjN0tRhU/DYQHjQ3X5i7Rg9gKVpEOSI8+Dj9DDyB9MDaY1a
	 mVBJUyCC+B5fw==
Date: Mon, 27 Nov 2023 17:50:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <20231128015041.GO2766956@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926593.2770816.5504104328549141972.stgit@frogsfrogsfrogs>
 <ZWGK6Ig752wdBvwF@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWGK6Ig752wdBvwF@infradead.org>

On Fri, Nov 24, 2023 at 09:49:28PM -0800, Christoph Hellwig wrote:
> The code makes me feel we're fixing the wrong thing, but I have to
> admin I don't fully understand it. Let me go step by step.
> 
> > While stress-testing online repair of btrees, I noticed periodic
> > assertion failures from the buffer cache about buffer readers
> > encountering buffers with DELWRI_Q set, even though the btree bulk load
> > had already committed and the buffer itself wasn't on any delwri list.
> 
> What assert do these buffer reader hit?  The two I can spot that are in
> the read path in the broader sense are:
> 
>   1) in xfs_buf_find_lock for stale buffers.
>   2) in __xfs_buf_submit just before I/O submission

The second assert:

AIL:	Repair0:	Repair1:

pin buffer X
delwri_queue:
set DELWRI_Q
add to delwri list

	stale buf X:
	clear DELWRI_Q
	does not clear b_list
	free space X
	commit

delwri_submit	# oops

Though there's more to this.

> > I traced this to a misunderstanding of how the delwri lists work,
> > particularly with regards to the AIL's buffer list.  If a buffer is
> > logged and committed, the buffer can end up on that AIL buffer list.  If
> > btree repairs are run twice in rapid succession, it's possible that the
> > first repair will invalidate the buffer and free it before the next time
> > the AIL wakes up.  This clears DELWRI_Q from the buffer state.
> 
> Where "this clears" is xfs_buf_stale called from xfs_btree_free_block
> via xfs_trans_binval?

Yes.  I'll rework the last sentence to read: "Marking the buffer stale
clears DELWRI_Q from the buffer state without removing the buffer from
its delwri list."

> > If the second repair allocates the same block, it will then recycle the
> > buffer to start writing the new btree block.
> 
> If my above theory is correct: how do we end up reusing a stale buffer?
> If not, what am I misunderstanding above?

If we free a metadata buffer, we'll mark it stale, update the bnobt, and
add an entry to the extent busy list.  If a later repair finds:

1. The same free space in the bnobt;
2. The free space exactly coincides with one extent busy list entry;
3. The entry isn't in the middle of discarding the block;

Then the allocator will remove the extent busy list entry and let us
have the space.  At that point we could have a stale buffer that's also
on one of the AIL's lists:

AIL:	Repair0:	Repair1:

pin buffer X
delwri_queue:
set DELWRI_Q
add to delwri list

	stale buf X:
	clear DELWRI_Q
	does not clear b_list
	free space X
	commit

			find free space X
			get buffer
			rewrite buffer
			delwri_queue:
			set DELWRI_Q
			already on a list, do not add
			commit

			BAD: committed tree root before all blocks written

delwri_submit	# too late now

I could demonstrate this by injecting dmerror while delwri(ting) the new
btree blocks, and observing that some of the EIOs would not trigger the
rollback but instead would trip IO errors in the AIL.

> > wakes up and walks the buffer list, it will ignore the buffer because it
> > can't lock it, and go back to sleep.
> 
> And I think this is where the trouble starts - we have a buffer that
> is left on some delwri list, but with the _XBF_DELWRI_Q flag cleared,
> it is stale and we then reuse it.  I don't think we just need to kick
> it off the delwri list just for btree staging, but in general.

...but how to do that?  We don't know whose delwri list the buffer's on,
let alone how to lock the list so that we can remove the buffer from
that list.

(Oh, you have some suggestions below.)

> > When the second repair calls delwri_queue to put the buffer on the
> > list of buffers to write before committing the new btree, it will set
> > DELWRI_Q again, but since the buffer hasn't been removed from the AIL's
> > buffer list, it won't add it to the bulkload buffer's list.
> >
> > This is incorrect, because the bulkload caller relies on delwri_submit
> > to ensure that all the buffers have been sent to disk /before/
> > committing the new btree root pointer.  This ordering requirement is
> > required for data consistency.
> >
> > Worse, the AIL won't clear DELWRI_Q from the buffer when it does finally
> > drop it, so the next thread to walk through the btree will trip over a
> > debug assertion on that flag.
> 
> Where do it finally drop it?

TBH, it's been so long that I can't remember anymore. :(

> > To fix this, create a new function that waits for the buffer to be
> > removed from any other delwri lists before adding the buffer to the
> > caller's delwri list.  By waiting for the buffer to clear both the
> > delwri list and any potential delwri wait list, we can be sure that
> > repair will initiate writes of all buffers and report all write errors
> > back to userspace instead of committing the new structure.
> 
> If my understanding above is correct this just papers over the bug
> that a buffer that is marked stale and can be reused for something
> else is left on a delwri list.

I'm not sure it's a bug for *most* code that encounters it.  Regular
transactions don't directly use the delwri lists, so it will never see
that at all.  If the buffer gets rewritten and logged, then it'll just
end up on the AIL's delwri buffer list again.

The other delwri_submit users don't seem to care if the buffer gets
written directly by delwri_submit or by the AIL.  In the first case, the
caller will get the EIO and force a shutdown; in the second case, the
AIL will shut down the log.

Weirdly, xfs_bwrite clears DELWRI_Q but doesn't necessary shut down the
fs if the write fails.

Every time I revisit this patch I wonder if DELWRI_Q is misnamed -- does
it mean "b_list is active"?  Or does it merely mean "another thread will
write this buffer via b_list if nobody gets there first"?  I think it's
the second, since it's easy enough to list_empty().

It's only repair that requires this new behavior that all new buffers
have to be written through the delwri list, and only because it actually
/can/ cancel the transaction by finishing the autoreap EFIs.

> I've entirely thought about all the
> consequence, but here is what I'd try:
> 
>  - if xfs_buf_find_lock finds a stale buffer with _XBF_DELWRI_Q
>    call your new wait code instead of asserting (probably only
>    for the !trylock case)
>  - make sure we don't leak DELWRI_Q 

Way back when I first discovered this, my first impulse was to make
xfs_buf_stale wait for DELWRI_Q to clear.  That IIRC didn't work because
a transaction could hold an inode that the AIL will need to lock.  I
think xfs_buf_find_lock would have the same problem.

Seeing as repair is the only user with the requirement that it alone can
issue writes for the delwri list buffers, that's why I went with what's
in this patch.

Thank you for persevering so far! :D

--D
