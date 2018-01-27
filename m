Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:22956 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752078AbeA0L1l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 06:27:41 -0500
Date: Sat, 27 Jan 2018 22:28:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Message-ID: <20180127112833.g624srgy4qdhk6yd@destitution>
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
 <CAOQ4uxiCN1yXFOs--pQhEczk8SyXX+-gk5QKF_2YO-VvvZ0sVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiCN1yXFOs--pQhEczk8SyXX+-gk5QKF_2YO-VvvZ0sVw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Jan 27, 2018 at 10:34:25AM +0200, Amir Goldstein wrote:
> On Thu, Jan 25, 2018 at 7:51 AM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > The video from my talk at LCA 2018 yesterday about the XFS subvolume and
> > snapshot support I'm working on has been uploaded and can be found
> > here:
> >
> > https://www.youtube.com/watch?v=wG8FUvSGROw
> >
> > I don't have the code in a reviewable form yet - there's still quite
> > a bit of work before I get to that point, but this is a good
> > introduction to how all the pieces will fit together....
> >
> 
> Very cool!
> 
> Got any paper napkin design photo to share?

No. I have some arch docs I wrote after the initial Poc on loopback
devices and a bunch of bash, sed, awk and xfs_io hacks....

> What are the big unknowns at this point?

None - all of the concepts needed for snapshot/clone/repl are now
proven and have a working implementation. Matthew Wilcox has a
pretty good handle on what is needed for page cache sharing, and
encryption is just a matter of implementing the generic
interfaces....

> Is the data part challenging because of no buffer cache for data?

Not at all. I just didn't have time to implement the remapping hooks
into the IO path before I gave the talk.

> I suppose all subvolumes use the host fs journal?

No. A subvolume is a "fully functioning filesystem" and so - by
definition - they each have their own internal journal. The journal
IO remapping and COW functionality all works as seen in that demo...

> Not gonna share this master plan with fsdevel?

There's nothing really to talk about outside of XFS until I split
the device space management API out from the XFS code. And that's
far from my highest priority right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
