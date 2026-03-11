Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC33A3DEAEF;
	Wed, 11 Mar 2026 12:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773230717; cv=none; b=Nh5lsIDKQcAV8MHjleVMjxm3J3UFdjP3ON1cpeKcZ48rJ7k0TADq0S3U+oUo09O1gs/sDIdMYhnaN547GPZLy/sY4cG5P3xBiae9WQkqPv8pEPfsiv8k473OAL2v0haa68bl1LK4xIyfXZTTTsJb5x+3jJ15vbkJmPB6KzMNC0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773230717; c=relaxed/simple;
	bh=Du89kre53kIBxs4+gE7Cn9HL5HvtlWDkKKKH87VYLdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXFwaa7XYM174oGmKK5vHSz0UTSIn+cNONwO0hTaSCi0B7TvSgtSTN7EgfObkQTLdjZ6AW89hpthp6UrulXEhLiNYFkjnE7Cau8H4StscF6vlHC5ntTI76Xb76xATK8k6gZSDHqzII9DD/c1zE/uKQpFEepgQpSotd2JHU8x1Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCGMXRBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCGMXRBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD15C2BC9E;
	Wed, 11 Mar 2026 12:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773230717;
	bh=Du89kre53kIBxs4+gE7Cn9HL5HvtlWDkKKKH87VYLdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kCGMXRBNqdUaSvmkFvnZn0GNxpYUZiaZ7GbxYvK4uIHmIVh+PMOn22QoXv1QapDhx
	 lMdvZXt3ceJfcx5TgA7oZgNPdcbpHbBaa1wRBn+8FoOeg2h7SrVUcc76walF65zBvC
	 Bnsr3pqLP9Rmj7PQpcpRJTBFtZLrDRuHKUVhfAMNNIPLIHZNwrXMbUkaDI092f0iKz
	 IVHXvFT7B6lYWsDEupLfYqOkGQPl4hwnWKXrmCw/aXytA1ObWVEvwgjdwJ5ybFHMqF
	 9SB7WLSDulDCIftTO1DuaF44caLA08j2+b3yuEgTTmCy50MeiKVDOjNUXbwxaUKtsq
	 6+jTvyJ9qJcIA==
Date: Wed, 11 Mar 2026 23:05:05 +1100
From: Dave Chinner <dgc@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
	Luis Chamberlain <mcgrof@kernel.org>, tytso@mit.edu,
	p.raghav@samsung.com, andres@anarazel.de,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] iomap: Support buffered RWF_WRITETHROUGH via async dio
 backend
Message-ID: <abFacQlKfQj3aQZk@dread>
References: <cover.1773076216.git.ojaswin@linux.ibm.com>
 <c84ddc3f864f840d646b6aa19fd9b3e83e079c0b.1773076216.git.ojaswin@linux.ibm.com>
 <aa--rBKQG7ck5nuM@dread>
 <abFFcSTmUaAzbmOB@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abFFcSTmUaAzbmOB@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>

On Wed, Mar 11, 2026 at 04:05:29PM +0530, Ojaswin Mujoo wrote:
> On Tue, Mar 10, 2026 at 05:48:12PM +1100, Dave Chinner wrote:
> > On Mon, Mar 09, 2026 at 11:04:31PM +0530, Ojaswin Mujoo wrote:
> > This is not what I envisiaged write-through using DIO to look like.
> > This is a DIO per folio, rather than a DIO per write() syscall. We
> > want the latter to be the common case, not the former, especially
> > when it comes to RWF_ATOMIC support.
> > 
> > i.e. I was expecting something more like having a wt context
> > allocated up front with an appropriately sized bvec appended to it
> > (i.e. single allocation for the common case). Then in
> > iomap_write_end(), we'd mark the folio as under writeback and add it
> > to the bvec. Then we iterate through the IO range adding folio after
> > folio to the bvec.
> > 
> > When the bvec is full or we reach the end of the IO, we then push
> > that bvec down to the DIO code. Ideally we'd also push the iomap we
> > already hold down as well, so that the DIO code does not need to
> > look it up again (unless the mapping is stale). The DIO completion
> > callback then runs a completion callback that iterates the folios
> > attached ot the bvec and runs buffered writeback compeltion on them.
> > It can then decrements the wt-ctx IO-in-flight counter.
> > 
> > If there is more user data to submit, we keep going around (with a
> > new bvec if we need it) adding folios and submitting them to the dio
> > code until there is no more data to copy in and submit.
> > 
> > The writethrough context then drops it's own "in-flight" reference
> > and waits for the in-flight counter to go to zero.
> 
> Hi Dave,
> 
> Thanks for the review. IIUC you are suggesting a per iomap submission of
> dio rather than a per folio,

Yes, this is the original architectural premise of iomap: we map the
extent first, then iterate over folios, then submit a single bio for
the extent...

> and for each iomap we submit we can
> maintain a per writethrough counter which helps us perform any sort of
> endio cleanup work. I can give this design a try in v2.

Yes, this is exactly how iomap DIO completion tracking works for
IO that requires multiple bios to be submitted. i.e. completion
processing only runs once all IOs -and submission- have completed.

> > > index c24d94349ca5..f4d8ff08a83a 100644
> > > --- a/fs/iomap/direct-io.c
> > > +++ b/fs/iomap/direct-io.c
> > > @@ -713,7 +713,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> > >  	dio->i_size = i_size_read(inode);
> > >  	dio->dops = dops;
> > >  	dio->error = 0;
> > > -	dio->flags = dio_flags & (IOMAP_DIO_FSBLOCK_ALIGNED | IOMAP_DIO_BOUNCE);
> > > +	dio->flags = dio_flags & (IOMAP_DIO_FSBLOCK_ALIGNED | IOMAP_DIO_BOUNCE |
> > > +				  IOMAP_DIO_BUF_WRITETHROUGH);
> > >  	dio->done_before = done_before;
> > >  
> > >  	dio->submit.iter = iter;
> > > @@ -747,8 +748,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> > >  		if (iocb->ki_flags & IOCB_ATOMIC)
> > >  			iomi.flags |= IOMAP_ATOMIC;
> > >  
> > > -		/* for data sync or sync, we need sync completion processing */
> > > -		if (iocb_is_dsync(iocb)) {
> > > +		/*
> > > +		 * for data sync or sync, we need sync completion processing.
> > > +		 * for buffered writethrough, sync is handled in buffered IO
> > > +		 * path so not needed here
> > > +		 */
> > > +		if (iocb_is_dsync(iocb) &&
> > > +		    !(dio->flags & IOMAP_DIO_BUF_WRITETHROUGH)) {
> > >  			dio->flags |= IOMAP_DIO_NEED_SYNC;
> > 
> > Ah, that looks wrong. We want writethrough to be able to use FUA
> > optimisations for RWF_DSYNC. This prevents the DIO write for wt from
> > setting IOMAP_DIO_WRITE_THROUGH which is needed to trigger FUA
> > writes for RWF_DSYNC ops.
> > 
> > i.e. we need DIO to handle the write completions directly to allow
> > conditional calling of generic_write_sync() based on whether FUA
> > writes were used or not.
> 
> Yes right, for now we just let xfs_file_buffered_write() ->
> generic_write_sync() to handle the sync because first we wanted to have
> some discussion on how to correctly implement optimized
> O_DSYNC/RWF_DSYNC. 

Ah, I had assumed that discussion was largely unnecessary because it
was obvious to me how to implement writethrough behaviour. i.e.  all
we need to do is replicate the iomap DIO internal
submission/completion model for wt around the outside of the async
DIO write submission loop, and we are largely done.

> Some open questions that I have right now:
> 
> 1. For non-aio non FUA writethrough, where is the right place to do the
>    sync?

At the end of final wt ctx IO completion, just like we do for DIO.

>    We can't simply rely on iomap_dio_complete() to do the sync
>    since we still hold writeback bit and that causes a deadlock.

Right, you do it at wt ctx IO completion after all the folios in the
range have been marked clean. At that point, all that remains is for
the device cache to be flushed and the metadata sync operations to
be performed.

i.e. This is exactly the same integrity requirement as non-FUA
RWF_DSYNC DIO.

>    Even if
>    we solve that, we need to have a way to propogate any fsync errors
>    back to user so endio might not be the right place anyways?

It's the same model as DIO. If we have async submission and the IO
is not complete, we return -EIOCBQUEUED. Otherwise we gather the
error from the completed wt ctx and return that.

> 2. For non-aio writethrough, if we do want to do the sync via
>    xfs_file_buffered_write() -> generic_write_sync(),

We don't want to do that. This crappy "caller submits and waits for
IO" model is the primary reasons we can't do async buffered
RWF_DSYNC.

The sync operation needs to be run at completion processing. If we
are not doing AIO, then the submitter waits for all submitted IOs to
complete, then runs completion processing itself. IO errors are
collected directly and returned to the submitter.

If we are doing AIO, the the submitter drops it's IO reference, and
then the final IO completion that runs will execute the sync
operation, and the result is returned to the AIO completion ring
via the iocb->ki_complete() callback.

This is exactly the same model as the iomap DIO code - it's lifted
up a layer to the buffered WT layer and wrapped around multiple
async DIO submissions...

>    `we need a way to
>    propogate IOMAP_DIO_WRITE_THROUGH to the higher level so that we can
>    skip the sync.

The sync disappears completely from the higher layers - to take
advantage of FUA optimisations, the sync operations need to be
handled by the WT code. i.e. Buffered DSYNC or OSYNC writes are
-always- write-through operations after this infrastructure is put
in place, they are never run by high level code like
xfs_file_buffered_write().

Indeed, do you see generic_write_sync() calls in the XFS DIO write
paths?

> Also, a naive question, usually DSYNC means that by the time the
> syscall returns we'd either know data has reached the medium or we will
> get an error.  Even in aio context I think we respect this semantic
> currently.

For a write() style syscall, yes. For AIO/io_uring, no.

io_submit() only returns an error if there is something wrong
with the aio ctx or iocbs being submitted. It does not report
completion status of the iocbs that are submitted. You need to call
io_getevents() to obtain the completion status of individual iocbs
that have been submitted via io_submit().

Think about it: if you submit 16 IO in on io_submit() call and
one fails, how do you know find out which IO failed?

> However, with our idea of making the DSYNC buffered aio also
> truly async, via writethrough, won't we be violating this guarantee?

No, the error will be returned to the AIO completion ring, same as
it is now.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
