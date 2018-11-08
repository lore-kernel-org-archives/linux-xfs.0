Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42481 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbeKHLRC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 06:17:02 -0500
Received: by mail-yb1-f196.google.com with SMTP id o204-v6so7690725yba.9
        for <linux-xfs@vger.kernel.org>; Wed, 07 Nov 2018 17:43:59 -0800 (PST)
Date: Wed, 7 Nov 2018 20:43:57 -0500
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 2/2] xfs: take a ref on failed bufs in xfs_inode_item_push
Message-ID: <20181108014356.np5q2wg4ohzagofe@MacBook-Pro-91.local>
References: <20181107235753.ogcp32ux5yggre7s@macbook-pro-91.dhcp.thefacebook.com>
 <20181107234302.lfr7toyoxzuh2z2s@macbook-pro-91.dhcp.thefacebook.com>
 <20181108004817.GB19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108004817.GB19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-xfs@vger.kernel.org

On Thu, Nov 08, 2018 at 11:48:17AM +1100, Dave Chinner wrote:
> [compendium reply]
> 
> On Wed, Nov 07, 2018 at 06:43:03PM -0500, Josef Bacik wrote:
> > On Thu, Nov 08, 2018 at 10:37:40AM +1100, Dave Chinner wrote:
> > > On Wed, Nov 07, 2018 at 03:10:55PM -0500, Josef Bacik wrote:
> > > > If we failed to writeout a xfs_buf we'll grab a ref for it and put it on
> > > > li->li_buf.  Then when submitting the failed bufs we'll clear LI_FAILED
> > > > on the li, which clears the LI_FAILED flag, but also drops the ref on
> > > > the buf.  Since it isn't on a IO list at this point this could very well
> > > > be the last ref on the buf, which wreaks havoc when we go to add the buf
> > > > to the delwrite list.  Fix this by holding a ref on the buf before we
> > > > call xfs_buf_resubmit_failed_buffers in order to make sure the buf
> > > > doesn't disappear before we're able to clear the error and add it to the
> > > > delwri list.  This fixes the panics I was seeing with error injection.
> ....
> > > Perhaps something like the patch below?
> > > 
> > 
> > I thought about this, but I was worried that clearing the XFS_LI_FAILED may race
> > with submitting the IO and having it fail again, so we end up clearing it when
> > we need it set to resubmit again.  But you are the expert here, if that isn't
> > possible then I'm happy with this patch.  Thanks,
> 
> The buffer cannot be submitted while we are clearing the failed
> flags because a) the caller holds the buffer locked and so owns it
> completely, and b) the caller owns the buffer_list that the buffer
> is queued to and so controls when the list of buffers is submitted
> for IO.
> 
> IOWs, there is no possibility of racing with clearing the
> XFS_LI_FAILED flags because we own everything in that context.
> 
> > The other question, is it possible for the buffer to be submitted in another
> > thread immediately after it is queued for IO?
> 
> See a) above - you have to hold the buffer lock to submit it for IO.
> Hence holding the buffer lock over queueing means nothing can submit
> it for IO at the same time. And you have to hold the buffer lock to
> submit it to the delwri list:
> 
> 
> bool
> xfs_buf_delwri_queue(
>         struct xfs_buf          *bp,
>         struct list_head        *list)
> {
> >>>>>   ASSERT(xfs_buf_islocked(bp));
>         ASSERT(!(bp->b_flags & XBF_READ));
>

Ah yeah duh, thanks,

Josef 
