Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752369AbdDCJT2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 05:19:28 -0400
Date: Mon, 3 Apr 2017 11:19:13 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: clear XBF_ASYNC if we attach an iodone callback
Message-ID: <20170403091913.pmwc3taxypfgiqyw@eorzea.usersys.redhat.com>
References: <1488552404-21379-1-git-send-email-jbacik@fb.com>
 <20170303204902.GF21245@bfoster.bfoster>
 <1488576856.9307.13.camel@fb.com>
 <20170303222001.GA24497@bfoster.bfoster>
 <A14C7E7E-2807-48E6-A5C1-ABD09A7B69D3@fb.com>
 <20170304135849.GA27205@bfoster.bfoster>
 <1488826813.9307.21.camel@fb.com>
 <20170307012204.GP17542@dastard>
 <1488902165.9307.26.camel@fb.com>
 <20170307161246.GB8144@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170307161246.GB8144@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bfoster@redhat.com
Cc: Josef Bacik <jbacik@fb.com>, Dave Chinner <david@fromorbit.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Kernel Team <Kernel-team@fb.com>

Hi,

I really apologize for my late reply, March was a busy month and this thread got
lost on my mailbox.

I'll try to come back to this fix as soon as possible,

> > > > 
> > > >                 return;
> > > >         }
> > > It's likely you'll end up with silent on disk corruption if you do
> > > that because it's just tossing the error state away.
> > 
> > I think I'm getting a handle on this, but I wonder if we don't have
> > this problem currently?  We get an error on a buffer, we retry it and
> > it fails again.  If we don't have XFS_ERR_RETRY_FOREVER set then we
> > error out and do the normal callbacks as if nothing ever happened, and
> > we get the silent corruption without shutting down the file system.
> >  How is the code as it stands without XFS_ERR_RETRY_FOREVER safe?
> >  Thanks,
> > 
> 
> We shouldn't get into a situation where we run the callbacks when the
> I/O has failed and the fs isn't shut down. IOWs, we do run the callbacks
> only when the I/O succeeds, or it fails and the fs is shutdown as a
> result (never when the I/O fails but we haven't shut down, which is the
> problematic case the patch above introduces).
> 
> That tunable error handling logic (XFS_ERR_RETRY_FOREVER) basically
> determines when an I/O error is considered permanent, which means
> retries are futile and we have no choice but to shutdown the fs. E.g.,
> if an error is deemed permanent, we jump to permanent_error:
> 
>         /*
>          * Permanent error - we need to trigger a shutdown if we haven't already
>          * to indicate that inconsistency will result from this action.
>          */
> permanent_error:
>         xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> out_stale:
>         xfs_buf_stale(bp);
>         bp->b_flags |= XBF_DONE;
>         trace_xfs_buf_error_relse(bp, _RET_IP_);
>         return false;
> }
> 
> ... which shuts down the filesystem before we go any farther.
> 
> Brian
> 
> > Josef

Josef, did you have any success in avoiding this lockup problem with the
fail/retry mechanism mentioned? Or do you keep seeing it?


-- 
Carlos
