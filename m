Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755225AbcIOJSy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Sep 2016 05:18:54 -0400
Date: Thu, 15 Sep 2016 05:18:51 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V4] xfs: Document error handlers behavior
Message-ID: <20160915091851.GA24318@redhat.com>
References: <1473757385-81633-1-git-send-email-cmaiolino@redhat.com>
 <20160914012334.GK30497@dastard>
 <20160914100219.5743534ofe6oktbb@redhat.com>
 <20160914220951.GP30497@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160914220951.GP30497@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

> > Also, I apologize if I misunderstand it, but being ignored doesn't look a proper
> > description here, it sounds to me something like 'we ignore the error and tell
> > nobody about it", in unmount example, we shut down the filesystem if any error
> > happens, for me it doesn't sound like ignoring an error, but I might be
> > interpreting it in the wrong way.
> 
> I think you're making the assumption that the only way we handle
> errors once retries are exhausted is to trigger a filesystem shutdown.
> That assumption was repeated throughout the documentation.
> 
> While that may be true for /metadata write IO errors/, it is not
> true for the generic error handling case. e.g. if we extend it to
> memory allocation contexts, we may end up returning ENOMEM to
> userspace. Or, in certain contexts, we might be able to fall back to
> doing a single operation at a time using the stack for storage, in
> which case there is no reason at all to report the allocation
> failure to anyone.
> 
> The infrastructure is generic, as is the documentation, and so it
> shouldn't assume anything about what is going to happen once the
> retries are exhausted and the error is propagated upwards. What
> happens with that error after it is returned is a subsystem and
> context dependent behaviour, not something that is defined by the
> error retry configuration infrastructure....
> 
> Cheers,

Thanks for the very detailed explanation Dave
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos
