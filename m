Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:65009 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751065AbdGTEiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 00:38:21 -0400
Date: Thu, 20 Jul 2017 14:38:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Collecting aged XFS profiles
Message-ID: <20170720043806.GU17762@dastard>
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
 <20170717234814.GK17762@dastard>
 <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
 <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net>
 <CAAxjCEzZ2Q0wL=nhGVHVtK3M5Ws3MQdrUNKm3jJKO+1y-wxTkw@mail.gmail.com>
 <20170720030252.GT17762@dastard>
 <93399fda-5d20-5ec9-14f1-5496814fed79@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93399fda-5d20-5ec9-14f1-5496814fed79@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

On Wed, Jul 19, 2017 at 10:55:23PM -0500, Eric Sandeen wrote:
> 
> 
> On 07/19/2017 10:02 PM, Dave Chinner wrote:
> > On Wed, Jul 19, 2017 at 11:08:41PM +0200, Stefan Ring wrote:
> >> On Wed, Jul 19, 2017 at 5:20 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >>> On 07/19/2017 02:59 AM, Stefan Ring wrote:
> >>>> I have created a metadump that is 1GB in size, xz-compressed. However,
> >>>> by running strings on it I find that there are many identifiable
> >>>> remains inside, and I cannot legally pass this on.
> >>>
> >>> newer metadump should correct that problem, and is a read-only tool,
> >>> so should be (tm) perfectly safe (tm).  You could run it out of a built
> >>> git repo, via the xfs_db commands.
> >>>
> >>>> The question is: can I import this metadata image in a VM and recreate
> >>>> the metadata image from there, using modern xfsprogs? Will this
> >>>> preserve most of the relevant information?
> >>>
> >>> yes, that would work too. (mdrestore followed by or piped through metadump)
> >>> If you find significant strings in that result please let me know :)
> >>
> >> There is still quite a lot of stuff that should not be there (pasted
> >> selectively while scrolling over it via less):
> > 
> > [snip]
> > 
> > This stuff could all be in the journal. This is why I said "metadump
> > will first need to be modified to avoid dumping the journal".
> > Shouldn't be too hard - we already avoid dumping the journal when it
> > is external....
> 
> We already (in effect) avoid dumping it when it's clean:
> 
>         dirty = xlog_is_dirty(mp, &log, &x, 0);
> 
>         switch (dirty) {
>         case 0:
>                 /* clear out a clean log */
>                 if (show_progress)
>                         print_progress("Zeroing clean log");
> 		...
> 		libxfs_log_clear( ...
> 
> and if it /wasn't/ clean, he'd have gotten the warning:
> 
> _("Warning: log recovery of an obfuscated metadata image can leak "
> "unobfuscated metadata and/or cause image corruption.  If possible, "
> "please mount the filesystem to clean the log, or disable obfuscation."));

Oh, that's in the for-next branch, not the master branch. No wonder
I couldn't find this at first. :/

FWIW, people building from the git tree are probably using the
master branch (v4.11.0), not the for-next branch. I used to stage
all the -rcX releases in the master branch, which was why I was
confused by this at first. Never mind, I'll update my scripts that
haven't been pulling the xfsprogs for-next branch from kernel.org...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
