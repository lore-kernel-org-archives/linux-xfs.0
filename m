Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 134E029E1C
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 23:08:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93A7EAC006
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 21:08:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mf8mgEwMpCgesq8F for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 21:08:18 -0700 (PDT)
Date: Tue, 20 Aug 2013 14:08:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
	deferred cmtime update
Message-ID: <20130820040814.GH6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
	<ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
	<20130820023615.GE6023@dastard>
	<CALCETrV-Toj-NGpmWnmoUbCwrMUXOSbjQdYsSVuTiH+2dEgPTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrV-Toj-NGpmWnmoUbCwrMUXOSbjQdYsSVuTiH+2dEgPTQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>

On Mon, Aug 19, 2013 at 08:28:20PM -0700, Andy Lutomirski wrote:
> On Mon, Aug 19, 2013 at 7:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Aug 16, 2013 at 04:22:10PM -0700, Andy Lutomirski wrote:
> >> Filesystems that defer cmtime updates should update cmtime when any
> >> of these events happen after a write via a mapping:
> >>
> >>  - The mapping is written back to disk.  This happens from all kinds
> >>    of places, all of which eventually call ->writepages.
> >>
> >>  - munmap is called or the mapping is removed when the process exits
> >>
> >>  - msync(MS_ASYNC) is called.  Linux currently does nothing for
> >>    msync(MS_ASYNC), but POSIX says that cmtime should be updated some
> >>    time between an mmaped write and the subsequent msync call.
> >>    MS_SYNC calls ->writepages, but MS_ASYNC needs special handling.
> >>
> >> Filesystmes that defer cmtime updates should flush them on munmap or
> >> exit.  Finding out that this happened through vm_ops is messy, so
> >> add a new address space op for this.
> >>
> >> It's not strictly necessary to call ->flush_cmtime after ->writepages,
> >> but it simplifies the fs code.  As an optional optimization,
> >> filesystems can call mapping_test_clear_cmtime themselves in
> >> ->writepages (as long as they're careful to scan all the pages first
> >> -- the cmtime bit may not be set when ->writepages is entered).
> >
> > .flush_cmtime is effectively a duplicate method.  We already have
> > .update_time to notify filesystems that they need to update the
> > timestamp in the inode transactionally.
> 
> .update_time is used for the atime update as well, and it relies on
> the core code to update the in-memory timestamp first.

No, it doesn't. The caller of .update_time provides the timestamp to
that gets written into the relevant fields of the inode.

i.e. this code:

	now = current_fs_time(inode->i_sb);
	if (inode->i_op->update_time)
		return inode->i_op->update_time(inode, &now, S_CTIME|S_MTIME);

will update *only* the ctime and mtime of the inode to have a value
of @now. That's precisely what you want to do, yes?

Indeed, your .flush_cmtime function effectively does:

	flags = prepare_cmtime(inode, &now)
		{ *now = current_fs_time()
		  flags = S_CTIME|S_MTIME;
		}
	update_time(inode, now, flags);
		{
			inode->i_op->update_time(inode, now, flags)
			or
			mark_inode_dirty_sync()
		}

IOWs, you're adding a filesystem specific method to update a
timestamp that wraps around a generic method for updating a
timestamp. i.e.  .flush_cmtime is not necessary - you could just
call inode_update_time_writable() from generic_writepages() and it
would simply just work for all filesystems....

> I used that
> approach in v2, but it was (correctly, I think) pointed out that this
> was a layering violation and that core code shouldn't be mucking with
> the timestamps directly during writeback.

If calling a generic method to update the timestamp is a layering
violation, then why is replacing that with a filesystem specific
method of updating a timestamp not a layering violation?

> > Indeed:
> >
> >> +     /*
> >> +      * Userspace expects certain system calls to update cmtime if
> >> +      * a file has been recently written using a shared vma.  In
> >> +      * cases where cmtime may need to be updated but writepages is
> >> +      * not called, this is called instead.  (Implementations
> >> +      * should call mapping_test_clear_cmtime.)
> >> +      */
> >> +     void (*flush_cmtime)(struct address_space *);
> >
> > You say it can be implemented in the ->writepage(s) method, and all
> > filesystems provide ->writepage(s) in some form. Therefore I would
> > have thought it be best to simply require filesystems to check that
> > mapping flag during those methods and update the inode directly when
> > that is set?
> 
> The problem with only doing it in ->writepages is that calling
> writepages from munmap and exit would probably hurt performance for no
> particular gain.  So I need some kind of callback to say "update the
> time, but don't write data."  The AS_CMTIME bit will still be set when
> the ptes are removed.

What's the point of updating the timestamp at unmap when it's going
to be changed again when the writeback occurs?

> I could require ->writepages *and* ->flush_cmtime to handle the time
> update, but that would complicate non-transactional filesystems.
> Those filesystems should just flush cmtime at the end of writepages.

do_writepages() is the wrong place to do such updates - we can get
writeback directly through .writepage, so the time updates need to
be in .writepage. That first .writepage call will clear the bit on
the mapping, so it's only done on the first call to .writepage on
the given mapping.

And some filesystems provide a .writepages method that doesn't call
.writepage, so those filesystems will need to do the timestamp
update in those methods.

> > Indeed, the way you've set up the infrastructure, we'll have to
> > rewrite the cmtime update code to enable writepages to update this
> > within some other transaction. Perhaps you should just implement it
> > that way first?
> 
> This is already possible although not IMO necessary for correctness.
> All that ext4 would need to do is to add something like:
> 
> if (mapping_test_clear_cmtime(mapping)) {
>   update times within current transaction
> }

Where does it get the timestamps from? i.e. the update could call
prepare_update_cmtime() to do this, yes? And so having a wrapper
that does

	if (mapping_test_clear_cmtime(mapping))
		return prepare_update_cmtime(inode);
	return 0;

would work just fine for them, yes?

> somewhere inside the transaction in writepages.  There would probably
> be room for some kind of generic helper to do everything in
> inode_update_time_writable except for the actual mark_inode_dirty
> part, but this still seems nasty from a locking perspective, and I'd
> rather leave that optimization to an ext4 developer who wants to do
> it.

filesystems that implement .update_time don't need to mark the
struct inode dirty on timestamp updates. Similarly, filesystems that
use a writepages transaction to do the update don't either....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
