Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52636 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeG3Rp5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 13:45:57 -0400
Date: Mon, 30 Jul 2018 09:09:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH, RFC] xfs: completely disable toggling DAX flag via ioctl
 on reg files
Message-ID: <20180730160956.GW30972@magnolia>
References: <405e182f-0c24-81fe-9d04-1031a8bbac17@redhat.com>
 <20180726120854.GA16980@bfoster>
 <892f27ac-f985-bf8f-1cc9-bc0a996136f7@sandeen.net>
 <20180726231754.GB2234@dastard>
 <e1caad41-40c2-3ff2-3ed4-46cf603fc4d2@sandeen.net>
 <20180727185125.GG22227@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180727185125.GG22227@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>

On Fri, Jul 27, 2018 at 02:51:25PM -0400, Brian Foster wrote:
> On Thu, Jul 26, 2018 at 06:20:01PM -0700, Eric Sandeen wrote:
> > On 7/26/18 4:17 PM, Dave Chinner wrote:
> > 
> > ...
> > 
> > > As it is, I don't think we can remove this now - people are using
> > > the on-disk flags already, and the inherit flag from the directory
> > > has none of the problems of changing S_DAX dynamically.
> > 
> > Which is why I left the inheritance part ...
> > 
> > > Hence just
> > > disabling it is the wrong thing to do because it removes the ability
> > > for people to manage the flags that are already on disk....
> > 
> > Well, it's EXPERIMENTAL... o_O
> > 
> > But yeah, this does remove the ability to turn off the flag, at least
> > w/o making a file copy or some other gross thing.
> > 
> 
> You could retain the ability to change the flag on existing files when
> -odax is used, right? IIUC, that means the runtime change is essentially
> a no-op and so the state change problem doesn't exist.
> 
> That's obviously tedious, but is there any other truly predictable way
> to toggle the behavior change other than a mount cycle anyways?
> 
> > > I'd much prefer we fix the page fault synchronisation problem than
> > > break stuff that /isn't actually broken/. Yes, it's current
> > > behaviour is suboptimal, but that is only supposed to be /temporary/
> > > until the aops callout problem is fixed.

I thought Jan Kara proposed checking the S_DAX state in the DAX/non-DAX
code paths and bailing out with some sort of -EAGAIN type status (or
whatever the vm_fault_t equivalent of that is) if it's inconsistent,
though the same discussion also proposed restricting DAX flag changes to
directories and files with zero size, zero i_blocks, and zero
i_delayed_blks.

> > 
> 
> I agree, but it sounds like nobody has a solution for that (let alone a
> patch). :/
> 
> > Well, it's super confusing and from the user POV more or less
> > nondeterministic, at this point.  That borders on broken/unusable IMHO.
> > "Change the flag and some time later, not really within your control, the
> > behavior will change."
> > 
> 
> Perhaps broken is strong if whatever crash problem existed was worked
> around by Christoph's change. I agree that this is certainly not usable.

He didn't work around it so much as disabled the in-core state changes
that were supposed to accompany the on-disk state changes.

> You can literally create a new/empty file, set the DAX flag, start
> writing data and see the exact opposite behavior from what is expected.
> I'm not sure suboptimal really describes that either. ;P
> 
> I guess the more important question is does anything beyond this inode
> flag switching problem hold DAX+XFS in experimental status?

In order of increasing complexity (as perceived by me):

Lack of reflink support, maintainer's continuing unease about how all
this interacts with the memory manager / "we can't quite fix this right
now", unresolved debate over what role inode flags have vs. kernel
autoconfiguration...

> The purpose of this rfc is to essentially probe whether we can lift
> some portion of dax out of experimental status, right? If there are
> other concerns that would prevent that, then perhaps this is moot
> until that changes.

I thought the point of the RFC was to turn off the parts of the
interface that have imprecisely defined outcomes until a later time when
we can deliver a precisely defined outcome.

--D

> Brian
> 
> > It's been broken for a year.  TBH I'm not sure I personally have
> > the knowledge/skill (and I almost certainly don't have the time)
> > to fix it.  Just trying to make the best of a sticky situation.
> > This seemed better to me, modulo the inability to remove the
> > flag.  :/  And I figured more permissive flag manipulation could
> > be added back later if it ever does get fixed.
> > 
> > Thanks,
> > -Eric
> >  
> > > Cheers,
> > > 
> > > Dave.
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
