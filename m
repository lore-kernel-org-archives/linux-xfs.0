Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57651 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751537AbdCFTCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 14:02:10 -0500
Message-ID: <1488826813.9307.21.camel@fb.com>
Subject: Re: [PATCH] xfs: clear XBF_ASYNC if we attach an iodone callback
From: Josef Bacik <jbacik@fb.com>
Date: Mon, 6 Mar 2017 14:00:13 -0500
In-Reply-To: <20170304135849.GA27205@bfoster.bfoster>
References: <1488552404-21379-1-git-send-email-jbacik@fb.com>
         <20170303204902.GF21245@bfoster.bfoster> <1488576856.9307.13.camel@fb.com>
         <20170303222001.GA24497@bfoster.bfoster>
         <A14C7E7E-2807-48E6-A5C1-ABD09A7B69D3@fb.com>
         <20170304135849.GA27205@bfoster.bfoster>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Kernel Team <Kernel-team@fb.com>, Carlos Maiolino <cmaiolino@redhat.com>

On Sat, 2017-03-04 at 08:58 -0500, Brian Foster wrote:
> cc Carlos
> 
> On Sat, Mar 04, 2017 at 01:26:50AM +0000, Josef Bacik wrote:
> > 
> > 
> > > 
> > > On Mar 3, 2017, at 5:20 PM, Brian Foster <bfoster@redhat.com>
> > > wrote:
> > > 
> > > > 
> > > > On Fri, Mar 03, 2017 at 04:34:16PM -0500, Josef Bacik wrote:
> > > > > 
> > > > > On Fri, 2017-03-03 at 15:49 -0500, Brian Foster wrote:
> > > > > > 
> > > > > > On Fri, Mar 03, 2017 at 09:46:44AM -0500, Josef Bacik
> > > > > > wrote:
> > > > > > 
> > > > > > While testing nbd disconnects I kept hitting the following
> > > > > > hang
> > > > > > 
> > > > > > Call Trace:
> > > > > >  schedule+0x35/0x80
> > > > > >  xfs_ail_push_all_sync+0xa3/0xe0
> > > > > >  ? prepare_to_wait_event+0x100/0x100
> > > > > >  xfs_unmountfs+0x57/0x190
> > > > > >  xfs_fs_put_super+0x32/0x90
> > > > > >  generic_shutdown_super+0x6f/0xf0
> > > > > >  kill_block_super+0x27/0x70
> > > > > >  deactivate_locked_super+0x3e/0x70
> > > > > >  deactivate_super+0x46/0x60
> > > > > >  cleanup_mnt+0x3f/0x80
> > > > > >  __cleanup_mnt+0x12/0x20
> > > > > >  task_work_run+0x86/0xb0
> > > > > >  exit_to_usermode_loop+0x6d/0x96
> > > > > >  do_syscall_64+0x8b/0xa0
> > > > > >  entry_SYSCALL64_slow_path+0x25/0x25
> > > > > > 
> > > > > > After some digging around I found that there was a log item
> > > > > > on the
> > > > > > ail
> > > > > > with a callback of xfs_iflush_done.  A printk confirmed
> > > > > > that at the
> > > > > > call
> > > > > > to xfs_buf_attach_iodone in xfs_iflush_int had XBF_ASYNC
> > > > > > already
> > > > > > set,
> > > > > > which means on error we do not call xfs_buf_do_callbacks,
> > > > > > which
> > > > > > leaves
> > > > > > the log item on the ail list which causes us to hang on
> > > > > > unmount.  I
> > > > > > assume the block has XBF_ASYNC set because we did a
> > > > > > readahead on
> > > > > > it, so
> > > > > > it doesn't really need to have XBF_ASYNC set at this point
> > > > > > as we do
> > > > > > actually care about what happens to the buffer once IO is
> > > > > > complete.
> > > > > > With this patch my hang no longer happens.
> > > > > > 
> > > > > > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > > > > > ---
> > > > > >  fs/xfs/xfs_buf_item.c | 5 +++++
> > > > > >  1 file changed, 5 insertions(+)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > > > > > index 2975cb2..24fcb67 100644
> > > > > > --- a/fs/xfs/xfs_buf_item.c
> > > > > > +++ b/fs/xfs/xfs_buf_item.c
> > > > > > @@ -1016,6 +1016,11 @@ xfs_buf_attach_iodone(
> > > > > >  
> > > > > >      ASSERT(bp->b_iodone == NULL ||
> > > > > >             bp->b_iodone == xfs_buf_iodone_callbacks);
> > > > > > +    /*
> > > > > > +     * Somebody now cares about the fate of this buffer,
> > > > > > clear
> > > > > > XBF_ASYNC so
> > > > > > +     * that the iodone callback actually gets called.
> > > > > > +     */
> > > > > > +    bp->b_flags &= ~XBF_ASYNC;
> > > > > XBF_ASYNC generally describes the type of I/O being submitted
> > > > > for a
> > > > > particular buffer (blocking or non), so it being set or not
> > > > > is kind
> > > > > of
> > > > > outside the scope of xfs_iflush(). It really depends on how
> > > > > the
> > > > > caller
> > > > > ultimately wants to write the buffer. For example, if we get
> > > > > here via
> > > > > xfsaild_push()->xfs_inode_item_push(), the latter will do
> > > > > xfs_buf_delwri_queue() and the former will eventually call
> > > > > xfs_buf_delwri_submit_nowait(), which submits async I/O and
> > > > > so will
> > > > > re-add XBF_ASYNC.
> > > > > 
> > > > > It is interesting if this prevents your problem. I can't
> > > > > quite make
> > > > > out
> > > > > why that would be. The other xfs_iflush() caller is reclaim,
> > > > > which
> > > > > calls
> > > > > xfs_bwrite() which itself clears XBF_ASYNC before submission.
> > > > > 
> > > > > What I'm guessing you're referring to above wrt to not
> > > > > calling
> > > > > xfs_buf_do_callbacks() is the async check in
> > > > > xfs_buf_iodone_callback_error(), which is only relevant on
> > > > > I/O error.
> > > > > If
> > > > > the buffer I/O succeeds, we should always invoke the iodone
> > > > > callbacks
> > > > > regardless of async state. Do you observe otherwise or does
> > > > > this I/O
> > > > > indeed fail?
> > > > > 
> > > > > Anyways, if we change the buffer flags simply to control the
> > > > > behavior
> > > > > of
> > > > > iodone_callback_error(), we've basically decided to treat an
> > > > > otherwise
> > > > > async I/O as sync with the assumption that the submitter is
> > > > > going to
> > > > > handle the I/O error. As mentioned above, we don't really
> > > > > have that
> > > > > information here so that is kind of a dangerous assumption.
> > > > > At the
> > > > > very
> > > > > least, it bypasses all of the configurable error handling
> > > > > infrastructure
> > > > > that is specifically in place for async submitted buffers.
> > > > > 
> > > > > I'm wondering if you're hitting the flush locked inode retry
> > > > > problem
> > > > > that Carlos has been working on. The problem is basically
> > > > > that if the
> > > > > I/O fails on a buffer that backs a flush locked inode, we
> > > > > never retry
> > > > > the buffer and xfsaild basically spins on pushing the inode.
> > > > > What
> > > > > happens if you enable xfs tracepoints while the fs is hung?
> > > > Sorry for some reason my reply to linux-xfs got eaten.  It made
> > > > it to
> > > > Darrick but vger is being weird (sometimes it fails to get an
> > > > email,
> > > > sometimes it works fine).
> > > > 
> > > > So yes my patch doesn't actually work, I just didn't notice
> > > > that the
> > > > problem had happened until after I sent the page.
> > > > 
> > > > I'm doing this on a 4.6 kernel, I haven't actually tried it on
> > > > a
> > > > upstream kernel but my original assumption was it was still
> > > > available
> > > > to hit on an upstream kernel.  Basically on 4.6 we _always_
> > > > resubmit
> > > > the IO once if it fails, and then just drop the buffer if we've
> > > > re-
> > > > submitted once.  We never do the xfs_buf_do_callbacks() call,
> > > > which
> > > > seems wrong since as you say basically everything will set
> > > > XBF_ASYNC.
> > > > 
> > > The XBF_WRITE_FAIL resubmission is an internal retry thing
> > > intended to
> > > deal with transient errors. Assuming the internal retry fails, we
> > > do
> > > release the buffer but note that the higher level item is still
> > > tracked
> > > on the AIL (which basically just tracks that the inode is in the
> > > physical log and we're waiting on the metadata writeback to
> > > complete to
> > > free up space in the log).
> > > 
> > > IOWs, while the I/O path doesn't retry and releases the buffer,
> > > the
> > > intent is that the next xfsaild_push() cycle will retry the I/O
> > > (this is
> > > the part that is actually broken for flush locked inodes).
> > Yeah this sounds like what is happening, as I'll see xfs errors
> > every N seconds while its hanging, so it's retrying the IO, it's
> > just not failing out gracefully. What would be the course of action
> > here?  I can apply things and run them here pretty quickly.
> > 
> If it is actually the flush lock issue, Carlos was working on a
> proper
> fix for that. I'm not sure where that stands currently, however..
> Carlos?
> 
> If there isn't anything available to test quite yet, there was also a
> poc patch[1] more to verify what the problem was. I believe that one
> is
> at least safe, but still probably not production worthy as it may
> have
> performance ramifications. It should at least tell you whether that
> is
> the problem or something else is going on here.
> 
> Oh, commit e6b3bb789 ("xfs: add "fail at unmount" error handling
> configuration") may also be interesting here if the fs doesn't
> shutdown
> on unmount. That one looks like it came after v4.6 as well.

Ok I looked at that patch and the email that Dave sent in response,
which sounds like what I'm hitting.  Looking at the 4.6 code we simply
drop the xfs_buf if our IO retry fails and assume that the upper layer
will take care of things if it cares.  Meanwhile the thing writing out
the AIL doesn't actually know if things went wrong
unless xfs_iflush_done() is run.

In the upstream code you guys do this

        if (!(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) 
             bp->b_last_error != bp->b_error) {                    
                bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
                bp->b_last_error = bp->b_error;                  
                if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
                    !bp->b_first_retry_time)
                        bp->b_first_retry_time = jiffies;
                                                               
                xfs_buf_ioerror(bp, 0);                        
                xfs_buf_submit(bp);                                  
                return true;
        }

so you retry once, and the second time through we will return false if
we are unmounting, which means that xfs_buf_do_callbacks gets called.

Now you say that xfs_buf_do_callbacks() being called when we errored
out is dangerous, but I don't understand why.  We have this code

        if (need_ail) {
                struct xfs_log_item *log_items[need_ail];
                int i = 0;
                spin_lock(&ailp->xa_lock);
                for (blip = lip; blip; blip = blip->li_bio_list) {
                        iip = INODE_ITEM(blip);
                        if (iip->ili_logged &&
                            blip->li_lsn == iip->ili_flush_lsn) {
                                log_items[i++] = blip;
                        }
                        ASSERT(i <= need_ail);
                }
                /* xfs_trans_ail_delete_bulk() drops the AIL lock. */
                xfs_trans_ail_delete_bulk(ailp, log_items, i,
                                          SHUTDOWN_CORRUPT_INCORE);
        }

and need_ail is set if we didn't actually end up on disk properly.  So
we delete the thing and mark the fs as fucked.  Am I mis-reading what
is going on here?  This is what I did to our 4.6 tree (in testing
still, not actually pushed to production)

        if (bp->b_flags & XBF_ASYNC) {
                ASSERT(bp->b_iodone != NULL);

                trace_xfs_buf_item_iodone_async(bp, _RET_IP_);

                xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag
*/

                if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
                        bp->b_flags |= XBF_WRITE | XBF_ASYNC |
                                       XBF_DONE | XBF_WRITE_FAIL;
                        xfs_buf_submit(bp);
                } else {
+                       xfs_buf_do_callbacks(bp);
+                       bp->b_fspriv = NULL;
+                       bp->b_iodone = NULL;
                        xfs_buf_relse(bp);
                }

                return;
        }

I've marked the things that I changed with '+'.  So we do the retry,
and on the second go around we do the callbacks which trips the logic
in xfs_iflush_done() to clean up the AIL and complain loudly.  I'm not
seeing the danger here, in fact it seems like the appropriate thing to
do as xfs_iflush_done() appears to do the correct thing if we call it
when something failed.  Thanks,

Josef
