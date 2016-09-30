Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932515AbcI3OyP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 10:54:15 -0400
Date: Fri, 30 Sep 2016 10:54:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] [RFC] Release buffer locks in case of IO error
Message-ID: <20160930145413.GB27528@bfoster.bfoster>
References: <1475154199-28880-1-git-send-email-cmaiolino@redhat.com>
 <20160930000147.GH27872@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930000147.GH27872@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Sep 30, 2016 at 10:01:47AM +1000, Dave Chinner wrote:
> On Thu, Sep 29, 2016 at 03:03:19PM +0200, Carlos Maiolino wrote:
> > I have been working in a bug still regarding xfs fail_at_unmount configuration,
> > where, even though the configuration is enable, an unmount attempt will still
> > hang if the AIL buf items are locked as a result of a previous failed attempt to
> > flush these items.
> > 
> > Currently, if there is a failure while trying to flush inode buffers to disk,
> > these items are kept in AIL with FLUSHING status and with the locks held, making
> > them unable to be retried. Either during unmount, where they will be retried and
> > 'failed', or if using a thin provisioned device, the pool is actually extended, to
> > accomodate these not-yet-flushed items, instead of retrying to flush such items,
> > xfs is unable to retry them, once they are already locked.
> 
> [....]
> 

So this was originally written simply as a hack/experiment to test a
theory about what could be going wrong here, based on Carlos'
investigation so far into the issue. It wasn't really intended to be
posted as a proposed fix, so I'm going to skip over the details...

...
> 
> Ok, I'm pretty sure that this just addresses a symptom of the
> underlying problem, not solve the root cause. e.g. dquot flushing
> has exactly the same problem.
> 

Agree.

> The underlying problem is that when the buffer was failed, the
> callbacks attached to the buffer were not run. Hence the inodes
> locked and attached to the buffer were not aborted and unlocked
> when the buffer IO was failed. That's the underlying problem that
> needs fixing - this cannot be solved sanely by trying to guess why
> an inode is flush locked when walking the AIL....
> 

Are you making the assumption that the filesystem is already shutdown in
this scenario? I assume so, otherwise I'm not sure simply running the
callbacks (that remove items from the AIL) is really appropriate.

My _unconfirmed suspicion_ is that the core problem is that any log
items that are flush locked upon AIL push remain flush locked in the
event of I/O error (independent of fs shutdown, which is not guaranteed
after a metadata I/O error). E.g., consider the case of a transient
error or error configuration that expects more than one retry cycle
through xfsaild. IOW, the current AIL error retry mechanism doesn't work
for flush locked items.

(FWIW, another experiment I was thinking about was an optional
error-specific log item callback that would be specified and invoked in
the event of any metadata I/O error to release things like flush locks
and prepare for another retry, but I think that is complicated by the
fact that the in-core struct has already been flushed to the buffer.)

But stepping back from all that, this is just a theory based on Carlos'
investigation so far and could easily be wrong. I haven't debugged the
issue and so I'm not totally confident I actually understand the root
cause. As such, I'm not sure it's worth getting further into the weeds
until we have a root cause analysis.

Carlos,

Unless you completely disagree and are confident you have a handle on
the problem (in which case you can just ignore me and send a new patch
:), I'd suggest that what we probably need here is a detailed writeup of
the root cause. E.g., a step by step progression of what happens to the
log item in relation to the I/O errors and shutdown (if one actually
occurs), preferably backed by tracepoint data. Just my .02.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
