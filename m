Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:52802 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754420AbdKNXHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 18:07:34 -0500
Date: Wed, 15 Nov 2017 10:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Message-ID: <20171114230730.GD4094@dastard>
References: <20171113103139.GA18936@yu-chen.sh.intel.com>
 <20171114201915.GI729@wotan.suse.de>
 <20171114212538.GC4094@dastard>
 <6271997.pCNICGrn9T@aspire.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6271997.pCNICGrn9T@aspire.rjw.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Yu Chen <yu.c.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jkosina@suse.cz>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org, Thorsten Leemhuis <linux@leemhuis.info>, oleg.b.antonyan@gmail.com, Oliver Neukum <oneukum@suse.com>

On Tue, Nov 14, 2017 at 11:01:57PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 14, 2017 10:25:38 PM CET Dave Chinner wrote:
> > On Tue, Nov 14, 2017 at 09:19:15PM +0100, Luis R. Rodriguez wrote:
> > > This is another way to say suspend has been busted on XFS for a very long time,
> > > but I would not blame XFS -- this is a kernel issue to get proper filesystem
> > > suspend working right, and the way we currently deal with kthreads is just
> > > a sloppy goo mess which has created this situation.
> > 
> > Yes, and I've been telling people that suspend on journalling
> > filesystems has been broken for a long time (i.e since I first
> > realised the scope of the problem back in 2005). However, only XFS
> > triggers those conditions regularly because it is the most
> > asynchronous of the "freezable" journalling filesytems and has the
> > most reliance on co-ordination of kernel threads and workqueues to
> > function correctly.
> > 
> > IOWs, suspend of filesystems has been broken forever, and we've been
> > slapping bandaids on it in XFS forever. Now we've got to a
> > catch-22 situation that bandaids can't fix. We need structural
> > fixes, like I said we needed to do more than 10 years ago.
> 
> Right.
> 
> Yet, apparently, nobody has had the time to make those changes for all
> that time.

No, that's not the case. The problem was that the suspend developers
were in complete denial about the short-comings of using "sync" to
quiesce filesystems.  It wasn't until Plumbers a year ago that it
was reluctantly admitted that maybe there was a problem and that
filesystem freeze should be used instead.

Until the admission that "sync" was inadequate was made, there was
no point in even proposing a solution; the response up until that
point in time was a "we don't see a problem here" denial. We had to
wait for you guys to come to that conclusion yourselves because you
simply wouldn't listen to what the filesystem developers were
repeatedly telling you....

> So what do you think should be done, specifically?

Luis posted an initial version of those "use fs freeze" changes
recently, so Work with Luis to get those changes into the kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
