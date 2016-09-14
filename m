Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:27905 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754743AbcINWJy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 18:09:54 -0400
Date: Thu, 15 Sep 2016 08:09:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] xfs: Document error handlers behavior
Message-ID: <20160914220951.GP30497@dastard>
References: <1473757385-81633-1-git-send-email-cmaiolino@redhat.com>
 <20160914012334.GK30497@dastard>
 <20160914100219.5743534ofe6oktbb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160914100219.5743534ofe6oktbb@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 14, 2016 at 12:02:19PM +0200, Carlos Maiolino wrote:
> On Wed, Sep 14, 2016 at 11:23:34AM +1000, Dave Chinner wrote:
> > Ok, I had to update this for the change in retry timeout values from
> > Eric, so I went and fixed all the other things I thought needed
> > fixing, too. New patch below....
> > 
> 
> Hi, thanks, this looks good to me, with one exception described below.
> 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> > xfs: Document error handlers behavior
> > 
> > From: Carlos Maiolino <cmaiolino@redhat.com>
> > 
> > + -error handlers:
> > +	Defines the behavior for a specific error.
> > +
> > +The filesystem behavior during an error can be set via sysfs files, Each
> > +error handler works independently, the first condition met by and error handler
> > +for a specific class will cause the error to be propagated rather than reset and
> > +retried.
> > +
> > +The action taken by the filesystem when the error is propagated is context
> > +dependent - it may cause a shut down in the case of an unrecoverable error,
> > +it may be reported back to userspace, or it may even be ignored because
> > +there's nothing useful we can with the error or anyone we can report it to (e.g.
> 
> "there's nothing useful we can do with the error"
> 
> > +during unmount).
> 
> Also, I apologize if I misunderstand it, but being ignored doesn't look a proper
> description here, it sounds to me something like 'we ignore the error and tell
> nobody about it", in unmount example, we shut down the filesystem if any error
> happens, for me it doesn't sound like ignoring an error, but I might be
> interpreting it in the wrong way.

I think you're making the assumption that the only way we handle
errors once retries are exhausted is to trigger a filesystem shutdown.
That assumption was repeated throughout the documentation.

While that may be true for /metadata write IO errors/, it is not
true for the generic error handling case. e.g. if we extend it to
memory allocation contexts, we may end up returning ENOMEM to
userspace. Or, in certain contexts, we might be able to fall back to
doing a single operation at a time using the stack for storage, in
which case there is no reason at all to report the allocation
failure to anyone.

The infrastructure is generic, as is the documentation, and so it
shouldn't assume anything about what is going to happen once the
retries are exhausted and the error is propagated upwards. What
happens with that error after it is returned is a subsystem and
context dependent behaviour, not something that is defined by the
error retry configuration infrastructure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
