Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloudserver094114.home.net.pl ([79.96.170.134]:62470 "EHLO
        cloudserver094114.home.net.pl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756526AbdKNXk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 18:40:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Date: Wed, 15 Nov 2017 00:40:43 +0100
Message-ID: <1642052.KjDFtI7czP@aspire.rjw.lan>
In-Reply-To: <20171114230730.GD4094@dastard>
References: <20171113103139.GA18936@yu-chen.sh.intel.com> <6271997.pCNICGrn9T@aspire.rjw.lan> <20171114230730.GD4094@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jiri Kosina <jkosina@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Yu Chen <yu.c.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org, Thorsten Leemhuis <linux@leemhuis.info>, oleg.b.antonyan@gmail.com, Oliver Neukum <oneukum@suse.com>

On Wednesday, November 15, 2017 12:07:30 AM CET Dave Chinner wrote:
> On Tue, Nov 14, 2017 at 11:01:57PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 14, 2017 10:25:38 PM CET Dave Chinner wrote:
> > > On Tue, Nov 14, 2017 at 09:19:15PM +0100, Luis R. Rodriguez wrote:
> > > > This is another way to say suspend has been busted on XFS for a very long time,
> > > > but I would not blame XFS -- this is a kernel issue to get proper filesystem
> > > > suspend working right, and the way we currently deal with kthreads is just
> > > > a sloppy goo mess which has created this situation.
> > > 
> > > Yes, and I've been telling people that suspend on journalling
> > > filesystems has been broken for a long time (i.e since I first
> > > realised the scope of the problem back in 2005). However, only XFS
> > > triggers those conditions regularly because it is the most
> > > asynchronous of the "freezable" journalling filesytems and has the
> > > most reliance on co-ordination of kernel threads and workqueues to
> > > function correctly.
> > > 
> > > IOWs, suspend of filesystems has been broken forever, and we've been
> > > slapping bandaids on it in XFS forever. Now we've got to a
> > > catch-22 situation that bandaids can't fix. We need structural
> > > fixes, like I said we needed to do more than 10 years ago.
> > 
> > Right.
> > 
> > Yet, apparently, nobody has had the time to make those changes for all
> > that time.
> 
> No, that's not the case. The problem was that the suspend developers
> were in complete denial about the short-comings of using "sync" to
> quiesce filesystems.  It wasn't until Plumbers a year ago that it
> was reluctantly admitted that maybe there was a problem and that
> filesystem freeze should be used instead.

Excuse me, but that's not correct.

Fortunately, the old stuff is still there:

https://lists.celinuxforum.org/pipermail/linux-pm/2011-August/032513.html

and you are on the thread.  That was in 2011 and it failed, unfortunately.

I needed help at that time and didn't have the time to figure it all out
myself, but you know what, nobody from the fs side helped me then.

Next time Jiri tried to revive this, in 2015 AFAICS:

https://marc.info/?l=linux-kernel&m=144621283608619&w=2

and again, it didn't get too far.

> Until the admission that "sync" was inadequate was made, there was
> no point in even proposing a solution; the response up until that
> point in time was a "we don't see a problem here" denial. We had to
> wait for you guys to come to that conclusion yourselves because you
> simply wouldn't listen to what the filesystem developers were
> repeatedly telling you....

Can we stop here and be constructive going forward, please?

> > So what do you think should be done, specifically?
> 
> Luis posted an initial version of those "use fs freeze" changes
> recently, so Work with Luis to get those changes into the kernel.

This isn't the first version as per the above and sorry, but without
help from fs people this is going to end the same way as before and
I sort of doubt that "working with Luis" alone is going to be sufficient.

We need the fs people to actually help us, pretty much like back in 2011.

Thanks,
Rafael

