Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37282 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932131AbeCBVtw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 16:49:52 -0500
Date: Sat, 3 Mar 2018 08:49:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: add RWF_DSYNC support to pwrite
Message-ID: <20180302214950.GQ30854@dastard>
References: <20180301013633.28364-1-david@fromorbit.com>
 <fa38bfa3-2d30-be52-5bde-80b34aee3587@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa38bfa3-2d30-be52-5bde-80b34aee3587@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 01, 2018 at 09:45:43PM -0600, Eric Sandeen wrote:
> On 2/28/18 7:36 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Enable testing write behaviour with the per-io RWF_DSYNC flag.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  io/pwrite.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io/pwrite.c b/io/pwrite.c
> > index a89edfd0496f..58867b764635 100644
> > --- a/io/pwrite.c
> > +++ b/io/pwrite.c
> > @@ -56,6 +56,7 @@ pwrite_help(void)
> >  #endif
> >  #ifdef HAVE_PWRITEV2
> >  " -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
> > +" -D   -- Perform the pwritev2() with RWF_DSYNC\n"
> 
> Needs an xfs_io manpage update and a pwrite_cmd.args
> (short help) update, please.

Sure, forgot about that.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
