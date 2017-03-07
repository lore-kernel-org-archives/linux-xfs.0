Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50081 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755621AbdCGP4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 10:56:39 -0500
Message-ID: <1488902165.9307.26.camel@fb.com>
Subject: Re: [PATCH] xfs: clear XBF_ASYNC if we attach an iodone callback
From: Josef Bacik <jbacik@fb.com>
Date: Tue, 7 Mar 2017 10:56:05 -0500
In-Reply-To: <20170307012204.GP17542@dastard>
References: <1488552404-21379-1-git-send-email-jbacik@fb.com>
         <20170303204902.GF21245@bfoster.bfoster> <1488576856.9307.13.camel@fb.com>
         <20170303222001.GA24497@bfoster.bfoster>
         <A14C7E7E-2807-48E6-A5C1-ABD09A7B69D3@fb.com>
         <20170304135849.GA27205@bfoster.bfoster> <1488826813.9307.21.camel@fb.com>
         <20170307012204.GP17542@dastard>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Kernel Team <Kernel-team@fb.com>, Carlos Maiolino <cmaiolino@redhat.com>

On Tue, 2017-03-07 at 12:22 +1100, Dave Chinner wrote:
> On Mon, Mar 06, 2017 at 02:00:13PM -0500, Josef Bacik wrote:
> > 
> > so you retry once, and the second time through we will return false
> > if
> > we are unmounting, which means that xfs_buf_do_callbacks gets
> > called.
> > 
> > Now you say that xfs_buf_do_callbacks() being called when we
> > errored
> > out is dangerous, but I don't understand why.  We have this code
> > 
> >         if (need_ail) {
> >                 struct xfs_log_item *log_items[need_ail];
> >                 int i = 0;
> >                 spin_lock(&ailp->xa_lock);
> >                 for (blip = lip; blip; blip = blip->li_bio_list) {
> >                         iip = INODE_ITEM(blip);
> >                         if (iip->ili_logged &&
> >                             blip->li_lsn == iip->ili_flush_lsn) {
> >                                 log_items[i++] = blip;
> >                         }
> >                         ASSERT(i <= need_ail);
> >                 }
> >                 /* xfs_trans_ail_delete_bulk() drops the AIL lock.
> > */
> >                 xfs_trans_ail_delete_bulk(ailp, log_items, i,
> >                                           SHUTDOWN_CORRUPT_INCORE);
> >         }
> [ Your cut-n-paste is horribly mangled in something non-ascii. ]
> 
> > 
> > and need_ail is set if we didn't actually end up on disk properly.
> >  So
> > we delete the thing and mark the fs as fucked.  Am I mis-reading
> > what
> > is going on here?
> Yes. That won't shut down the filesystem on an inode write error. It
> will simply remove the inode from the AIL, the error will do dropped
> on the floor, and the filesystem will not be shut down even though
> it's now in a corrupt state. xfs_trans_ail_delete_bulk() only shuts
> down the filesytem if it doesn't find the item being removed form
> the AIL in the AIL.
> 
> As I keep telling people, what needs to happen is this:
> 
> 	1. buffer write error occurs
> 	2. retries exhausted, mark buffer as errored, run callbacks
> 	3. xfs_iflush_done() (and other iodone callbacks) need to
> 	   look at the buffer error state to determine what to do.
> 	4. if the buffer is errored and recovery is not possible,
> 	   the callback needs to shut down the filesytem.
> 	5. the callback then needs to call flush abort function for
> 	   item (e.g. xfs_iflush_abort()) rather than the normal
> 	   IO completion processing path.
> 
> > 
> >  This is what I did to our 4.6 tree (in testing
> > still, not actually pushed to production)
> > 
> >         if (bp->b_flags & XBF_ASYNC) {
> >                 ASSERT(bp->b_iodone != NULL);
> > 
> >                 trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> > 
> >                 xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the
> > flag
> > */
> > 
> >                 if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
> >                         bp->b_flags |= XBF_WRITE | XBF_ASYNC
> >                                        XBF_DONE | XBF_WRITE_FAIL;
> >                         xfs_buf_submit(bp);
> >                 } else {
> > +                       xfs_buf_do_callbacks(bp);
> > +                       bp->b_fspriv = NULL;
> > +                       bp->b_iodone = NULL;
> >                         xfs_buf_relse(bp);
> >                 }
> > 
> >                 return;
> >         }
> It's likely you'll end up with silent on disk corruption if you do
> that because it's just tossing the error state away.

I think I'm getting a handle on this, but I wonder if we don't have
this problem currently?  We get an error on a buffer, we retry it and
it fails again.  If we don't have XFS_ERR_RETRY_FOREVER set then we
error out and do the normal callbacks as if nothing ever happened, and
we get the silent corruption without shutting down the file system.
 How is the code as it stands without XFS_ERR_RETRY_FOREVER safe?
 Thanks,

Josef
