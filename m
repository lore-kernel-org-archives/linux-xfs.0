Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44261 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbeKHJak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 04:30:40 -0500
Received: by mail-qk1-f194.google.com with SMTP id n12so23624295qkh.11
        for <linux-xfs@vger.kernel.org>; Wed, 07 Nov 2018 15:57:55 -0800 (PST)
Date: Wed, 7 Nov 2018 18:57:53 -0500
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 2/2] xfs: take a ref on failed bufs in xfs_inode_item_push
Message-ID: <20181107235753.ogcp32ux5yggre7s@macbook-pro-91.dhcp.thefacebook.com>
References: <20181107201055.25883-1-josef@toxicpanda.com>
 <20181107201055.25883-3-josef@toxicpanda.com>
 <20181107233740.GZ19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107233740.GZ19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-xfs@vger.kernel.org

On Thu, Nov 08, 2018 at 10:37:40AM +1100, Dave Chinner wrote:
> On Wed, Nov 07, 2018 at 03:10:55PM -0500, Josef Bacik wrote:
> > If we failed to writeout a xfs_buf we'll grab a ref for it and put it on
> > li->li_buf.  Then when submitting the failed bufs we'll clear LI_FAILED
> > on the li, which clears the LI_FAILED flag, but also drops the ref on
> > the buf.  Since it isn't on a IO list at this point this could very well
> > be the last ref on the buf, which wreaks havoc when we go to add the buf
> > to the delwrite list.  Fix this by holding a ref on the buf before we
> > call xfs_buf_resubmit_failed_buffers in order to make sure the buf
> > doesn't disappear before we're able to clear the error and add it to the
> > delwri list.  This fixes the panics I was seeing with error injection.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/xfs/xfs_inode_item.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index fa1c4fe2ffbf..df49adf1989c 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -503,13 +503,16 @@ xfs_inode_item_push(
> >  	 * previously. Resubmit the buffer for IO.
> >  	 */
> >  	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
> > -		if (!xfs_buf_trylock(bp))
> > +		xfs_buf_hold(bp);
> > +		if (!xfs_buf_trylock(bp)) {
> > +			xfs_buf_rele(bp);
> >  			return XFS_ITEM_LOCKED;
> > +		}
> >  
> >  		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
> >  			rval = XFS_ITEM_FLUSHING;
> >  
> > -		xfs_buf_unlock(bp);
> > +		xfs_buf_relse(bp);
> >  		return rval;
> >  	}
> 
> This just doesn't smell right to me.
> 
> /me rummages around in the code
> 
> Ok, so I think the bug is in xfs_buf_resubmit_failed_buffers() in
> that it removes all the "failed" reference counts from the buffer
> before it adds the delwri reference count back to the buffer. Taking
> a high level reference count like above just papers over the
> transient reference counting error in
> xfs_buf_resubmit_failed_buffers().
> 
> It also fails to fix the other xfs_buf_resubmit_failed_buffers()
> caller, which has exactly the same problem (dquot writeback).
> 
> Perhaps something like the patch below?
>

The other question, is it possible for the buffer to be submitted in another
thread immediately after it is queued for IO?  Because then we have the same
problem, we could get to xfs_buf_unlock() and it would have been freed in the
other thread.  If that's not possible either then I'm still cool with your
patch.  Thanks,

Josef 
