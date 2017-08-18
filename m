Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50396 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdHRPhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2017 11:37:48 -0400
Date: Fri, 18 Aug 2017 08:37:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170818153734.GI4796@magnolia>
References: <20170810175548.GX24087@magnolia>
 <20170810183233.GG3777@bfoster.bfoster>
 <20170811022204.GQ21024@dastard>
 <20170811142741.GA18609@bfoster.bfoster>
 <20170812001637.GW21024@dastard>
 <20170812140433.GA31523@bfoster.bfoster>
 <20170814002809.GA21024@dastard>
 <20170817203826.GB62570@bfoster.bfoster>
 <20170817223121.GG4796@magnolia>
 <20170818113934.GA1069@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170818113934.GA1069@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Fri, Aug 18, 2017 at 07:39:34AM -0400, Brian Foster wrote:
> On Thu, Aug 17, 2017 at 03:31:21PM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 17, 2017 at 04:38:26PM -0400, Brian Foster wrote:
> > > On Mon, Aug 14, 2017 at 10:28:09AM +1000, Dave Chinner wrote:
> > > > On Sat, Aug 12, 2017 at 10:04:34AM -0400, Brian Foster wrote:
> > > > > On Sat, Aug 12, 2017 at 10:16:37AM +1000, Dave Chinner wrote:
> > > > > > On Fri, Aug 11, 2017 at 10:27:43AM -0400, Brian Foster wrote:
> > > > > > > On Fri, Aug 11, 2017 at 12:22:04PM +1000, Dave Chinner wrote:
> > > > > > Using XFS_BLI_ORDERED allows us to log the buffer without recording
> > > > > > a new dirty range on the buffer. IOWs, it retains whatever dirty range
> > > > > > it already had, and so after joining, marking it ordered and then
> > > > > > logging the buffer, we have a XFS_BLI_DIRTY | XFS_BLI_ORDERED buffer
> > > > > > in the transaction.
> > > > > > 
> > > > > > The question is this: what happens when a XFS_BLI_ORDERED buffer
> > > > > > with a pre-existing dirty region is formatted for the CIL? We
> > > > > > haven't done that before, so I'm betting that we don't relog the
> > > > > > dirty region like we should be doing....
> > > > > > 
> > > > > > ... and we don't relog the existing dirty range because the
> > > > > > ordered flag takes precedence.
> > > > > > 
> > > > > 
> > > > > Right.. so it seems that the current implementation for ordered buffers
> > > > > assumes a buffer is only ever used in one mode or the other.
> > > > > Additionally, the AIL assumes that any reinserted item has been fully
> > > > > relogged and so it moves the LSN forward unconditionally. Current
> > > > > ordered buffer processing violates this constraint for an already logged
> > > > > buffer.
> > > > 
> > > > Right, but it's not been a concern until now because we've only ever
> > > > used ordered buffers on newly allocated buffers that haven't been
> > > > previously logged.
> > > > 
> > > 
> > > Shortly after starting to test the latest refactoring with some asserts
> > > that enforce "strict" buffer ordering, I (sure enough ;)) ran into an
> > > instance of the above.
> > > 
> > > The issue is with the bmbt owner change operation that is part of the
> > > swap extent sequence. The owner change code ends up setting a buffer
> > > ordered that is currently dirty due to an unrelated previous
> > > transaction. The potential side effects of this are basically what we've
> > > already laid out above. Note that this is only relevant on
> > > crc=1,rmapbt=0 filesystems.
> > > 
> > > I'm currently testing out something that uses the rmapbt based swap
> > > implementation for all filesystems. IIUC, that algorithm doesn't
> > > actually require rmapbt support, it is just unfortunately named as such
> > > because we only use it on rmapbt filesystems. I suspect that is because
> > > rmapbt management requires the unmap/remapping of space to keep the tree
> > > consistent (and I suspect this is limited to rmapbt fs' for performance
> > > reasons, Darrick?) vs. it being something that actually depends on the
> > 
> > The rmapbt extent swapping function requires rmapbt because it writes
> > rmap and (more importantly) bmap intent items to the log.  An older
> > kernel cannot be allowed to recover such log items, which the rocompat
> > feature check in xfs_mount_validate_sb prevents.
> > 
> 
> Hmm, that's not what I've observed. I've tested recovery of both the
> rmapbt algorithm (with and without rmapbt actually enabled) as well as

But did you try recovery of the rmapbt algorithm on a pre-4.8 kernel?
That's what I meant by 'older kernel cannot be allowed...'.

IOWs, it's ok for log recovery on a 4.9+ kernel to process bmap intent
items on a non-rmap/non-reflink fs.

> the bmbt owner change algorithm. bmbt owner change recovery is actually
> currently broken due to the inode owner check in
> xfs_btree_lookup_get_block(), but I've been waiting to determine how we
> end up resolving this higher level issue before digging any further into
> that (I suspect it just needs to be bypassed during recovery). I hadn't
> hit any issues with the former cases.
>
> Looking at the code, I see the high level algorithm basically queues
> bmap unmap/map deferred ops across the file address space. That
> eventually resolves to __xfs_bunmapi()/xfs_bmapi_remap() calls that
> migrate the mappings. __xfs_bunmapi() clearly has to work in general for
> !rmapbt filesystems. AFAICT, all the XFS_BMAPI_REMAP flag does here is
> prevent us from actually freeing the blocks.
> 
> Moving along, we next end up in xfs_bmapi_remap() to map said blocks
> back into the other file... where I also don't see anything feature
> specific in the implementation. It uses xfs_bmap_add_extent_hole_real(),
> which calls xfs_rmap_map_extent(), which calls
> xfs_rmap_update_is_needed(), which checks xfs_sb_version_hasrmapbt().
> 
> Looking back at the unmap side, it looks like we have the same pattern
> down in xfs_bmap_del_extent() -> xfs_rmap_unmap_extent() -> ...
> 
> So AFAICT we have feature checks in the appropriate places. Am I missing
> something else?

Nope.

--D

> > I've never tried to see what happens when log recovery hits an item with
> > an unknown magic number -- I think we just bail out with EIO and leave
> > the log for someone else to recover?  In theory you could use the
> > rmap swapextents function all the time, but anyone trying to recover
> > after a crash with an old kernel will faceplant hard.  We could also
> > implement a new log-incompat flag if !rmapbt and someone tries to log a
> > bmap item... though iirc log_incompat doesn't exist for v4 filesystems,
> > so that still doesn't help us.
> > 
> > Conceptually, at least, the rmap swapext function should be capable of
> > swapping /any/ two inodes, not just the particular set of circumstances
> > required by xfs_swap_extents.
> > 
> 
> Indeed, thanks. If there is some dependency here it seems like it
> shouldn't be too difficult to break.
> 
> > > rmapbt.
> > > 
> > > FWIW, I've so far at least considered some of the following alternatives
> > > to try and preserve the existing bmbt owner change algorithm before
> > > moving on to testing the rmapbt approach:
> > > 
> > > 1.) Don't use ordered buffers for the bmbt owner change. My
> > > understanding is that this is a non-starter as we'd need to log every
> > > buffer in the tree in a single transaction.
> > 
> > Yep.
> > 
> > > 2.) Update the extent swap operation to push the log and AIL based on
> > > the most recent LSN of any buffer in the bmbt before the bmbt owner
> > > change takes place. I've experimented with this enough to hack together
> > > an xfs_ail_push_sync() prototype and also observe that using the
> > > ili_item.li_lsn of the inode is not sufficient.
> > > 
> > > IOW, this basically requires a second bmbt walk per-inode to discover
> > > the max lsn of all bmbt blocks. That may or may not be a performance
> > > issue since we have to walk the bmbt anyways. Otherwise I think this is
> > > a viable option from a correctness perspective.
> > > 
> > > A simplified variant of this (that just crossed my mind while writing
> > > this up) may be to do an in-core check for dirty bmbt buffers on an
> > > inode and just do an xfs_ail_push_all_sync() if any are found.
> > 
> > I imagine you have to keep the inodes locked throughout all this to
> > prevent something else from wandering in and re-logging the bmbt block?
> > 
> 
> Yeah, or retry or fail with -EAGAIN or something if we hit the
> problematic state, and/or see if there's something we can do to
> effectively quiesce the bmbt while under iolock. I hadn't really got
> that far tbh because this didn't seem like a great first option.
> 
> Brian
> 
> > > 3.) Synchronous write the affected buffers at xfs_trans_ordered_buf()
> > > time. This is a bit ugly because it requires to xfs_trans_brelse() the
> > > buf from the current transaction, _bwrite() it and then _bjoin() it back
> > > to the transaction all within xfs_trans_ordered_buf(). The advantage
> > > over #2 is that this only occurs for buffers with logged segments in the
> > > bli. It also effectively implements a form of generic support for
> > > ordering previously logged buffers.
> > > 
> > > 4.) Implement the ordered buffer relogging logic discussed below: detect
> > > ordered buffers with previously logged segments and relog them at
> > > ->iop_format() time. I suppose I could alleviate my aforementioned
> > > concerns with an assert that verifies an ordered buffer isn't already
> > > dirtied by the _current_ transaction (i.e., to catch the case of the
> > > "screwed up optimization" I was concerned about).
> > > 
> > > That aside, I think there is another problem here that we missed
> > > previously: transactions that use ordered buffers don't reserve log
> > > space for them, but relogged items require log reservation. If I follow
> > > the code correctly, a relogged item that is presently in the CIL may not
> > > use reservation in a subsequent tx. If the item resides in the AIL at
> > > relog commit time, however, the relogging transaction must have
> > > reservation for the item (the physical log space for the item is freed
> > > and the space used for the relog is accounted out of the reservation).
> > > 
> > > So I think the only way we can support the ability to relog previously
> > > dirty buffers that have been marked ordered is to require log
> > > reservation for them as for normal physically logged buffers, which kind
> > > of defeats the purpose.
> > > 
> > > 5.) A deferred op variant of the bmbt owner change algorithm. I haven't
> > > fully thought this one through yet so it may not be viable, but the
> > > general idea is to use deferred ops to conditionally physically log
> > > previously dirty buffers where required. For example, use a transaction
> > > with log reservation for one full buffer, log a new bmbt owner change
> > > intent and start running through the bmbt scan attempting to order
> > > buffers. Update xfs_trans_ordered_buf() to explicitly fail on buffers
> > > with dirty segments. When said failure occurs during the bmbt scan,
> > > physically log the buffer and terminate the scan with -EAGAIN. The
> > > deferred infra rolls the tx, relogs the intent and has to restart the
> > > bmbt scan over again. This repeats until we've processed the entire
> > > tree.
> > > 
> > > I had a couple more thoughts that are similarly not yet thought out and
> > > thus not worth rambling about. Thoughts on any of the above? On using
> > > the rmapbt algorithm? Other ideas?
> > > 
> > > Brian
> > > 
> > > > > > Ok, the ordered buffer checks in xfs_buf_item_size() and
> > > > > > xfs_buf_item_format() need to also check for dirty regions. If dirty
> > > > > > regions exist, then we treat it like a normal buffer rather than an
> > > > > > ordered buffer. We can factor the dirty region check out of
> > > > > > xfs_buf_item_unlock() for this...
> > > > > > 
> > > > > > Actually, check the case in xfs_buf_item_size() and remove the
> > > > > > ordered flag if there are dirty regions. Then xfs_buf_item_format()
> > > > > > will do the right thing without needing a duplicate check...
> > > > > > 
> > > > > 
> > > > > I think that would work, assuming we actually check the
> > > > > xfs_buf_log_format for dirty-ness rather than just the log item. As it
> > > > > is, note that ordered buffers are still "logged" in the transaction
> > > > > because otherwise the transaction infrastructure will assume it made no
> > > > > change to the buf and toss the log item at commit time (we also need to
> > > > > set up I/O completion on the buf and whatnot).
> > > > 
> > > > *nod*
> > > > 
> > > > > What concerns me about this approach is that I think we introduce the
> > > > > possibility for subtle bugs. Existing ordered buffer code does this:
> > > > > 
> > > > >         xfs_trans_ordered_buf(tp, fbuf);
> > > > >         xfs_trans_log_buf(tp, fbuf, 0,
> > > > >                           BBTOB(fbuf->b_length) - 1);
> > > > > 
> > > > > ... which should continue to work fine. Allowing ordered buffers to
> > > > > physically log means that something like this:
> > > > > 
> > > > >         xfs_trans_log_buf(tp, fbuf, 0,
> > > > >                           BBTOB(fbuf->b_length) - 1);
> > > > >         xfs_trans_ordered_buf(tp, fbuf);
> > > > > 
> > > > > ... is now a bug that is only apparent after scrutiny of xfs_trans_*()
> > > > > and logging internals. Granted, the above already is incorrect, but it
> > > > > technically still works as expected. I don't see the need to turn that
> > > > > into a real problem by actually logging the buffer when we might not
> > > > > expect to.
> > > > 
> > > > Well, it's not a "things go bad" bug. It's a "we screwed up an
> > > > optimisation" bug, because logging the buffer contents unnecessarily
> > > > only increases the required log bandwidth. It shouldn't affect
> > > > replay because the buffer is still correctly ordered in the log.
> > > > Hence both the transient and end states of the buffer during replay
> > > > will still be the same...
> > > > 
> > > > > So while I agree that this could probably be made to work and I think it
> > > > > is ideal to doing any kind of logged range tracking in the deferred ops
> > > > > code, it still seems more tricky than it needs to be. To relog a held
> > > > > buffer in a new transaction, why not just mark the lidp dirty in the new
> > > > > transaction so it inherits all existing dirty segments? AFAICT, all we
> > > > > really need to do is:
> > > > > 
> > > > >         tp->t_flags |= XFS_TRANS_DIRTY;
> > > > >         lidp->lid_flags |= XFS_LID_DIRTY;
> > > > > 
> > > > > ... on the new transaction and everything should just work as designed
> > > > > (for a buffer that has been previously logged, held, rolled and
> > > > > rejoined).
> > > > 
> > > > We would also need to set:
> > > > 
> > > > 	bip->bli_flags |= XFS_BLI_DIRTY | XFS_BLI_LOGGED;
> > > > 
> > > > which means we should....
> > > > 
> > > > > To elaborate a bit, I think we could refactor xfs_trans_log_buf() into a
> > > > > new xfs_trans_dirty_buf() helper that covers all of the relevant bits
> > > > > not related to actually dirtying the bli. xfs_trans_log_buf() would call
> > > > > xfs_trans_dirty_buf() and thus would not change functionally.
> > > > > xfs_trans_ordered_buf() could now call xfs_trans_dirty_buf() and thus
> > > > > the existing ordered buf users would no longer need to log a range of
> > > > > the buffer (which doesn't make much sense anyways).
> > > > 
> > > > ... do this. :)
> > > > 
> > > > > Finally, the
> > > > > deferred infrastructure could join/dirty/hold the buffer to the new
> > > > > transaction after each roll without needing to track and relog specific
> > > > > regions of the buffer. Thoughts?
> > > > 
> > > > Yup, that's exactly what I was thinking should be possible by using
> > > > ordered buffers.... :)
> > > > 
> > > > And Christoph's rework of the transaction roll and deferred inode
> > > > handling that he just posted should make adding buffer handling
> > > > quite a bit neater and cleaner.
> > > > 
> > > > > Unless I'm missing something as to why this is busted, I'll take a
> > > > > closer look at the code and float an rfc next week since otherwise it
> > > > > sounds like this is something we could actually fix up in the ordered
> > > > > buffer code today.
> > > > 
> > > > Cool.
> > > > 
> > > > > > Nothing in XFS is ever simple, is it? :P
> > > > > 
> > > > > There used to be a level of satisfaction at feeling I understood some
> > > > > new corner of XFS. Nowadays I know that just means I'm not yet aware of
> > > > > whatever dragons remain in that corner (is that paranoia? not if it's
> > > > > true!). :P
> > > > 
> > > > Ah, the true signs of expertise: developing a knowledge base and
> > > > insight deep enough to understand that there is always another
> > > > hidden dragon poised to bite your head off. :)
> > > > 
> > > > Cheers,
> > > > 
> > > > Dave.
> > > > -- 
> > > > Dave Chinner
> > > > david@fromorbit.com
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
