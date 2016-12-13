Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:58358 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752801AbcLMA4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 19:56:21 -0500
Date: Tue, 13 Dec 2016 11:56:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Message-ID: <20161213005614.GZ4326@dastard>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
 <20161212015959.GT4326@dastard>
 <CAOQ4uxhiOb9SBgDaqjY5gQ+Z99BRWCFtc=vyGiB4PmXyDYQQZA@mail.gmail.com>
 <20161212074430.GX4326@dastard>
 <CAOQ4uxg=2X27tKod1EcwGCUYArMKPjOhW2toWnLM3w2ju79HTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg=2X27tKod1EcwGCUYArMKPjOhW2toWnLM3w2ju79HTg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Dec 12, 2016 at 10:10:57AM +0200, Amir Goldstein wrote:
> On Mon, Dec 12, 2016 at 9:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Dec 12, 2016 at 07:06:37AM +0200, Amir Goldstein wrote:
> ...
> >
> > IOWs, the /earliest/ anything like this could be done is 4.11, but
> > I'd be really hesitant to rush anything like this into 4.11 because
> > of all the stuff we already have in the pipeline.  And given that
> > we're currently looking at around the 4.12 release timeframe for
> > moving to full support for reflink, what does all this extra
> > "refcount-but-not-reflink" format shenanigans buy us? At best it's
> > going to be useful for a 3-6 month window, with very very limited
> > relevance or use to the rest of the XFS userbase?
> >
> 
> If I truly believed that 4.12 is a realistic target, I wouldn't have bothered
> at all. But to get there we need to have a sufficiently large beta group
> of bleeding edge testers, don't you think?

We've never had to worry about this in the past. We've got plenty of
people already running reflink enabled filesystems (my production
systems included) and experimenting with it. People from the
gluster, ceph, container storage infrastructure, etc areas have
already been testing and evaluating the reflink functionality in
XFS, even before it was merged. They've been asking for this
functionality for /years/ for doing things like VM image snapshots,
so we've got no shortage of people testing and using it already.

Keep in mind that there's been years of work behind reflink to get
where we are now, so there's been lots of things going on behind the
scenes that you simply don't know about. We've had a "sufficiently
large beta group" for months before the feature was merged....

> In fact, I am hoping that overlayfs "clone up" is merged to 4.10, creating
> a big incentive to CoreOS users to start experimenting with docker
> with overlayfs over XFS reflink, so there may be hope for that beta group.

What we don't want is /production users/ to be guinea pigs for a new
on-disk functionality. That's just asking for trouble, especially if
we find a bug in the on-disk format.  We've done just fine in the
past with a small group of very knowledgable users testing new
functionality, so I see no reason to treat reflink differently and
thereby exposing a wide swath of unsuspecting users to excessive
risk unnecessarily.

.....

> FYI, and unrelated, in coming up docker 1.13 release I implemented
> support for container disk usage quota with overlayfs storage driver
> over xfs using project quotas.

Great to hear! It's only taken ~4 years since I first suggested this
container fs space management model for it to be implemented.... :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
