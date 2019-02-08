Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfBHQy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 11:54:29 -0500
Date: Fri, 8 Feb 2019 08:54:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 9/9] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190208165414.GO7991@magnolia>
References: <154947207759.22369.11575570374120223292.stgit@magnolia>
 <154947213625.22369.7330296004413590907.stgit@magnolia>
 <20190207143114.GB2880@bfoster>
 <20190208080016.GB5523@infradead.org>
 <20190208120623.GA21317@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208120623.GA21317@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Feb 08, 2019 at 07:06:24AM -0500, Brian Foster wrote:
> On Fri, Feb 08, 2019 at 12:00:16AM -0800, Christoph Hellwig wrote:
> > > > +	if (XFS_TEST_ERROR(false, pag->pag_mount, XFS_ERRTAG_IUNLINK_FALLBACK))
> > > > +		return 0;
> > > > +
> > > > +	iu = kmem_zalloc(sizeof(*iu), KM_SLEEP | KM_NOFS);
> > > > +	iu->iu_agino = prev_agino;
> > > > +	iu->iu_next_unlinked = this_agino;
> > > > +
> > > > +	error = rhashtable_insert_fast(&pag->pagi_unlinked_hash,
> > > > +			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> > > > +	if (error == 0 || error == -EEXIST)
> > > > +		return error;
> > > > +	return 0;
> > > 
> > > The return val looks funny at a glance: return -EEXIST or otherwise
> > > return 0 for success and all other errors (also the error == 0 looks
> > > superfluous). I see the comment above describes what this does, but it
> > > doesn't explain why. I'd move the comment to above the if check and
> > > explain why it's there (i.e., "Absorb all runtime errors besides -EEXIST
> > > because fallback blah blah. We care about -EEXIST because ...").
> > > 
> > > Also I assume we need to free the iu object on insert failure,
> > > regardless of whether we ultimately return the error.
> > 
> > But is this really the right thing to do?  Everything but ENOMEM
> > would be a bug in the rhashtable implementation, or the XFS use,
> > wouldn't it?
> > 
> 
> I think anything beyond -ENOMEM would imply a bug somewhere, yes.

AFAICT the only other error we can receive from rhashtable is -E2BIG.
That only happens if we somehow end up with more than 2^31 inodes (or
leave a logic bomb for ourselves by setting max_size, I guess...)

> > So why not drop the return value entirely and do a:
> > 
> > 	error = rhashtable_insert_fast(&pag->pagi_unlinked_hash,
> > 			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> > 	ASSERT(error == 0 || error == -ENOMEM);

But if someone hits -EEXIST on a non-debug filesystem we'll never know
that our code was actually buggy, whereas returning it shuts down the
filesystem and we'll start getting letters.

> It's not clear to me whether you're suggesting we return 0, error or
> nothing at all here. The assert otherwise seems fine to me as I don't
> think we'd ever expect anything outside of success or -ENOMEM.

As I mentioned above, we could theoretically receive -E2BIG due to a
programming bug, or at some point the rhashtable code could start
returning new errors it hasn't before, or we could be misreading the
code too. :)

> That said, I don't see any reason to ever leak an iu if we know it
> didn't make it into the table.

Agreed.

> I could probably go either way on whether we wanted to allow the
> filesystem to continue or not on unexpected insert errors. The
> original comment was just that we probably shouldn't explode on
> "expected" errors like -ENOSPC.

Since we /do/ have a fallback to handle cache misses, I think it's fine
to ignore hashtable insertion failures, though I'll put in a ASSERT if
we see any error other than ENOMEM.

> 
> > > > +	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
> > > > +			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> > > > +	if (error)
> > > > +		return error;
> > > 
> > > What's interesting about remove failure is that if we otherwise found an
> > > iu for this inode, removing the inode from the unlinked list leaves a
> > > stale/incorrect iu around in the in-core table. So it's one thing for
> > > the in-core table to be a valid subset of the on-disk structures, but
> > > another thing entirely to have incoherence between the two. It might be
> > > worth pointing out that it's critical to return an error here so we
> > > don't actually remove the inode (whereas the re-add below is less
> > > strict).
> > 
> > Again, remove failure here sounds like a programming bug - so ASSERT
> > and or forced shutdown here.
> 
> Remove failure already unconditionally returns the error (which in the
> inactive path translates to a shutdown). My feedback above was just a
> suggestion to explain why in a comment because the error handling is
> intentionally different between table insert/remove/lookup.

I assume you're ok with the comment that got added in the followup patch
I sent to this thread?

--D

> Brian
