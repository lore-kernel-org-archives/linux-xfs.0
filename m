Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:34501 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932931AbeFUTtk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 15:49:40 -0400
Date: Fri, 22 Jun 2018 05:49:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
Message-ID: <20180621194936.GS19934@dastard>
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
 <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-xfs@vger.kernel.org

On Thu, Jun 21, 2018 at 02:26:45PM -0500, Eric Sandeen wrote:
> On 6/21/18 2:15 PM, Jeff Mahoney wrote:
> > On 6/20/18 11:57 PM, Dave Chinner wrote:
> >> On Wed, Jun 20, 2018 at 10:55:20PM -0400, jeffm@suse.com wrote:
> >>> From: Jeff Mahoney <jeffm@suse.com>
> >>>
> >>> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
> >>> AG alignment code into a separate function.  It got rid of
> >>> redundant checks for dswidth != 0 but did too good a job since now
> >>> it doesn't check at all.
> >>
> >> Of course they got removed - we've already validated the CLI input
> >> and guaranteed that cfg->dswidth can only be zero iff cfg->dsunit is
> >> zero in calc_stripe_factors().
> >>
> >> i.e. We do input validation of CLI paramters before anything else so
> >> that later users (like align_ag_geometry()) can assume the
> >> parameters they are using are valid. In this case, the assumption is
> >> that either both dsunit and dswidth are zero or that both are
> >> non-zero and dswidth an integer multple of dsunit.
> > 
> > It's not coming from the CLI parameters.  It's coming from the topology.
> >  The blkid topology stuff is returning 8k for minimal i/o and 0 for
> > optimal.  Without a CLI config, we have dunit=0 in calc_stripe_factors,
> > which takes it from the device.  We set cfg->dsunit=16 and
> > cfg->dswidth=0, and then head down to align_ag_geometry.
> > 
> > The topology on this system looks like:
> > 
> > ft = {dsunit = 16, dswidth = 0, rtswidth = 0, lsectorsize = 512,
> > 
> > psectorsize = 512}
> > That matches with a few of the dm targets I see reported on this system.

Exactly what kind of dm device does that - we've never had anyone
report this before? Also, if it's a dm device, shouldn't it
also be fixed to output a sane set of IO characteristics in /sys?

> > Since minimal io size isn't sector size, we don't clear it.  Talking
> > with Eric, we should probably just extent that check in
> > blkid_get_topology to cover that case since it's not like we can just
> > reject what blkid gives us.
> > 
> >>> When we hit the check to see if agsize
> >>> is a multiple of stripe width: (cfg->agsize % cfg->dswidth), we crash
> >>> on a divide by zero.
> >>
> >> What CLI config did you use to hit this? I'd like to reproduce it so
> >> I can see where calc_stripe_factors() is going wrong....
> > 
> > It was just "mkfs.xfs <path-to-mpath-device>"
> 
> yeah, so in blkid_get_topology we have:
> 
>         /*
>          * If the reported values are the same as the physical sector size
>          * do not bother to report anything.  It will only cause warnings
>          * if people specify larger stripe units or widths manually.
>          */
>         if (*sunit == *psectorsize || *swidth == *psectorsize) {
>                 *sunit = 0;
>                 *swidth = 0;
>         }
> 
> as a sanity check.  We should probably extend that (or add a similar test)
> which sets both to zero if either is zero, for the same reason as the CLI
> validation does it.  Comments should explain why....
> 
>         /*
>          * Ensure that if either sunit or stripe width is zero, the other
>          * is as well.  Having only one set is not valid stripe geometry.
>          */
>         if (*sunit == 0 || *swidth == 0) {
>                 *sunit = 0;
>                 *swidth = 0;
>         }

Yup, we need to validate that input properly before using it. Silly
me - I should have known better that to assume external code would
give back sane results.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
