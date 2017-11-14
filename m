Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloudserver094114.home.net.pl ([79.96.170.134]:56939 "EHLO
        cloudserver094114.home.net.pl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753921AbdKNWCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 17:02:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Date: Tue, 14 Nov 2017 23:01:57 +0100
Message-ID: <6271997.pCNICGrn9T@aspire.rjw.lan>
In-Reply-To: <20171114212538.GC4094@dastard>
References: <20171113103139.GA18936@yu-chen.sh.intel.com> <20171114201915.GI729@wotan.suse.de> <20171114212538.GC4094@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Yu Chen <yu.c.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jkosina@suse.cz>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org, Thorsten Leemhuis <linux@leemhuis.info>, oleg.b.antonyan@gmail.com, Oliver Neukum <oneukum@suse.com>

On Tuesday, November 14, 2017 10:25:38 PM CET Dave Chinner wrote:
> On Tue, Nov 14, 2017 at 09:19:15PM +0100, Luis R. Rodriguez wrote:
> > This is another way to say suspend has been busted on XFS for a very long time,
> > but I would not blame XFS -- this is a kernel issue to get proper filesystem
> > suspend working right, and the way we currently deal with kthreads is just
> > a sloppy goo mess which has created this situation.
> 
> Yes, and I've been telling people that suspend on journalling
> filesystems has been broken for a long time (i.e since I first
> realised the scope of the problem back in 2005). However, only XFS
> triggers those conditions regularly because it is the most
> asynchronous of the "freezable" journalling filesytems and has the
> most reliance on co-ordination of kernel threads and workqueues to
> function correctly.
> 
> IOWs, suspend of filesystems has been broken forever, and we've been
> slapping bandaids on it in XFS forever. Now we've got to a
> catch-22 situation that bandaids can't fix. We need structural
> fixes, like I said we needed to do more than 10 years ago.

Right.

Yet, apparently, nobody has had the time to make those changes for all
that time.

So what do you think should be done, specifically?

Thanks,
Rafael

