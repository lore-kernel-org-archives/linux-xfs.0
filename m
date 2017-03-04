Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdCDN6v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 4 Mar 2017 08:58:51 -0500
Date: Sat, 4 Mar 2017 08:58:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: clear XBF_ASYNC if we attach an iodone callback
Message-ID: <20170304135849.GA27205@bfoster.bfoster>
References: <1488552404-21379-1-git-send-email-jbacik@fb.com>
 <20170303204902.GF21245@bfoster.bfoster>
 <1488576856.9307.13.camel@fb.com>
 <20170303222001.GA24497@bfoster.bfoster>
 <A14C7E7E-2807-48E6-A5C1-ABD09A7B69D3@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A14C7E7E-2807-48E6-A5C1-ABD09A7B69D3@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Kernel Team <Kernel-team@fb.com>, Carlos Maiolino <cmaiolino@redhat.com>

cc Carlos

On Sat, Mar 04, 2017 at 01:26:50AM +0000, Josef Bacik wrote:
> 
> > On Mar 3, 2017, at 5:20 PM, Brian Foster <bfoster@redhat.com> wrote:
> > 
> >> On Fri, Mar 03, 2017 at 04:34:16PM -0500, Josef Bacik wrote:
> >>> On Fri, 2017-03-03 at 15:49 -0500, Brian Foster wrote:
> >>>> On Fri, Mar 03, 2017 at 09:46:44AM -0500, Josef Bacik wrote:
> >>>> 
> >>>> While testing nbd disconnects I kept hitting the following hang
> >>>> 
> >>>> Call Trace:
> >>>>  schedule+0x35/0x80
> >>>>  xfs_ail_push_all_sync+0xa3/0xe0
> >>>>  ? prepare_to_wait_event+0x100/0x100
> >>>>  xfs_unmountfs+0x57/0x190
> >>>>  xfs_fs_put_super+0x32/0x90
> >>>>  generic_shutdown_super+0x6f/0xf0
> >>>>  kill_block_super+0x27/0x70
> >>>>  deactivate_locked_super+0x3e/0x70
> >>>>  deactivate_super+0x46/0x60
> >>>>  cleanup_mnt+0x3f/0x80
> >>>>  __cleanup_mnt+0x12/0x20
> >>>>  task_work_run+0x86/0xb0
> >>>>  exit_to_usermode_loop+0x6d/0x96
> >>>>  do_syscall_64+0x8b/0xa0
> >>>>  entry_SYSCALL64_slow_path+0x25/0x25
> >>>> 
> >>>> After some digging around I found that there was a log item on the
> >>>> ail
> >>>> with a callback of xfs_iflush_done.  A printk confirmed that at the
> >>>> call
> >>>> to xfs_buf_attach_iodone in xfs_iflush_int had XBF_ASYNC already
> >>>> set,
> >>>> which means on error we do not call xfs_buf_do_callbacks, which
> >>>> leaves
> >>>> the log item on the ail list which causes us to hang on unmount.  I
> >>>> assume the block has XBF_ASYNC set because we did a readahead on
> >>>> it, so
> >>>> it doesn't really need to have XBF_ASYNC set at this point as we do
> >>>> actually care about what happens to the buffer once IO is complete.
> >>>> With this patch my hang no longer happens.
> >>>> 
> >>>> Signed-off-by: Josef Bacik <jbacik@fb.com>
> >>>> ---
> >>>>  fs/xfs/xfs_buf_item.c | 5 +++++
> >>>>  1 file changed, 5 insertions(+)
> >>>> 
> >>>> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> >>>> index 2975cb2..24fcb67 100644
> >>>> --- a/fs/xfs/xfs_buf_item.c
> >>>> +++ b/fs/xfs/xfs_buf_item.c
> >>>> @@ -1016,6 +1016,11 @@ xfs_buf_attach_iodone(
> >>>>  
> >>>>      ASSERT(bp->b_iodone == NULL ||
> >>>>             bp->b_iodone == xfs_buf_iodone_callbacks);
> >>>> +    /*
> >>>> +     * Somebody now cares about the fate of this buffer, clear
> >>>> XBF_ASYNC so
> >>>> +     * that the iodone callback actually gets called.
> >>>> +     */
> >>>> +    bp->b_flags &= ~XBF_ASYNC;
> >>> XBF_ASYNC generally describes the type of I/O being submitted for a
> >>> particular buffer (blocking or non), so it being set or not is kind
> >>> of
> >>> outside the scope of xfs_iflush(). It really depends on how the
> >>> caller
> >>> ultimately wants to write the buffer. For example, if we get here via
> >>> xfsaild_push()->xfs_inode_item_push(), the latter will do
> >>> xfs_buf_delwri_queue() and the former will eventually call
> >>> xfs_buf_delwri_submit_nowait(), which submits async I/O and so will
> >>> re-add XBF_ASYNC.
> >>> 
> >>> It is interesting if this prevents your problem. I can't quite make
> >>> out
> >>> why that would be. The other xfs_iflush() caller is reclaim, which
> >>> calls
> >>> xfs_bwrite() which itself clears XBF_ASYNC before submission.
> >>> 
> >>> What I'm guessing you're referring to above wrt to not calling
> >>> xfs_buf_do_callbacks() is the async check in
> >>> xfs_buf_iodone_callback_error(), which is only relevant on I/O error.
> >>> If
> >>> the buffer I/O succeeds, we should always invoke the iodone callbacks
> >>> regardless of async state. Do you observe otherwise or does this I/O
> >>> indeed fail?
> >>> 
> >>> Anyways, if we change the buffer flags simply to control the behavior
> >>> of
> >>> iodone_callback_error(), we've basically decided to treat an
> >>> otherwise
> >>> async I/O as sync with the assumption that the submitter is going to
> >>> handle the I/O error. As mentioned above, we don't really have that
> >>> information here so that is kind of a dangerous assumption. At the
> >>> very
> >>> least, it bypasses all of the configurable error handling
> >>> infrastructure
> >>> that is specifically in place for async submitted buffers.
> >>> 
> >>> I'm wondering if you're hitting the flush locked inode retry problem
> >>> that Carlos has been working on. The problem is basically that if the
> >>> I/O fails on a buffer that backs a flush locked inode, we never retry
> >>> the buffer and xfsaild basically spins on pushing the inode. What
> >>> happens if you enable xfs tracepoints while the fs is hung?
> >> 
> >> Sorry for some reason my reply to linux-xfs got eaten.  It made it to
> >> Darrick but vger is being weird (sometimes it fails to get an email,
> >> sometimes it works fine).
> >> 
> >> So yes my patch doesn't actually work, I just didn't notice that the
> >> problem had happened until after I sent the page.
> >> 
> >> I'm doing this on a 4.6 kernel, I haven't actually tried it on a
> >> upstream kernel but my original assumption was it was still available
> >> to hit on an upstream kernel.  Basically on 4.6 we _always_ resubmit
> >> the IO once if it fails, and then just drop the buffer if we've re-
> >> submitted once.  We never do the xfs_buf_do_callbacks() call, which
> >> seems wrong since as you say basically everything will set XBF_ASYNC.
> >> 
> > 
> > The XBF_WRITE_FAIL resubmission is an internal retry thing intended to
> > deal with transient errors. Assuming the internal retry fails, we do
> > release the buffer but note that the higher level item is still tracked
> > on the AIL (which basically just tracks that the inode is in the
> > physical log and we're waiting on the metadata writeback to complete to
> > free up space in the log).
> > 
> > IOWs, while the I/O path doesn't retry and releases the buffer, the
> > intent is that the next xfsaild_push() cycle will retry the I/O (this is
> > the part that is actually broken for flush locked inodes).
> 
> Yeah this sounds like what is happening, as I'll see xfs errors every N seconds while its hanging, so it's retrying the IO, it's just not failing out gracefully. What would be the course of action here?  I can apply things and run them here pretty quickly.
> 

If it is actually the flush lock issue, Carlos was working on a proper
fix for that. I'm not sure where that stands currently, however..
Carlos?

If there isn't anything available to test quite yet, there was also a
poc patch[1] more to verify what the problem was. I believe that one is
at least safe, but still probably not production worthy as it may have
performance ramifications. It should at least tell you whether that is
the problem or something else is going on here.

Oh, commit e6b3bb789 ("xfs: add "fail at unmount" error handling
configuration") may also be interesting here if the fs doesn't shutdown
on unmount. That one looks like it came after v4.6 as well.

Brian

[1] http://www.spinics.net/lists/linux-xfs/msg01018.html

> > 
> >> What I've done to fix it for 4.6 was in the second case where we just
> >> drop the buffer was to go ahead and do the xfs_buf_do_callbacks() call
> >> and then clear the fspriv and iodone callback on the buffer, and that
> >> actually made the problem go away.  Looking at the upstream code if
> >> it's a permanent IO error we still do the callbacks, so I think the
> >> problem I've hit has already been fixed upstream.  I'll verify next
> >> week just to be sure, since I can usually hit the problem in less than
> >> 5 minutes of my reproducer.  Thanks,
> >> 
> > 
> > Ok, just be aware that while that might allow your hung unmount case to
> > progress, what you're doing in the general/runtime case is treating a
> > buffer that fails the I/O twice as successfully completed. E.g., see
> > that xfs_iflush_done() invokes xfs_trans_ail_delete_bulk() which removes
> > the inode item from the AIL as if it were written back to its final
> > location on disk.
> > 
> > It might not be straightforward to reproduce because in practice I/O
> > errors won't occur, may mean the device is broken and the fs is going to
> > shutdown anyways, or some other dirty inode backed by the same buffer
> > might flush it, but otherwise this sounds like a path to corruption. For
> > example, suppose we modify an inode, commit the transaction etc. such
> > that the inode makes it to the log. At this point, the buffer is now
> > available for writeback. Say we attempt the buffer writeback and it
> > fails both initially and for the internal retry. IIUC, the change you've
> > made will basically release the inode from the AIL at this point as if
> > it succeeded, but clearly the updated inode has not made it to disk. If
> > the device otherwise goes back to normal and no more I/O errors occur,
> > we've basically just thrown away the change to the inode and corrupted
> > the fs.
> 
> Well thankfully this is when the device goes completely away so I'm not worried about that, but yeah that's not an excellent general solution.  Though it looked like it was tripping the shutdown code in the iflush code, but this isn't my area.  Thanks,
> 
> Josef--
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
