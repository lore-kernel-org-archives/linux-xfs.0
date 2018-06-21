Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13541 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932753AbeFUWTO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 18:19:14 -0400
Date: Fri, 22 Jun 2018 08:19:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Mounting xfs filesystem takes long time
Message-ID: <20180621221911.GT19934@dastard>
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
 <20180619161819.GD21698@magnolia>
 <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
 <20180621191535.GI7508@wotan.suse.de>
 <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
 <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>, xfs list <linux-xfs@vger.kernel.org>

On Thu, Jun 21, 2018 at 03:50:11PM -0600, Chris Murphy wrote:
> On Thu, Jun 21, 2018 at 1:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> >
> > On 6/21/18 2:15 PM, Luis R. Rodriguez wrote:
> >> On Tue, Jun 19, 2018 at 02:21:15PM -0500, Eric Sandeen wrote:
> >>> On 6/19/18 11:18 AM, Darrick J. Wong wrote:
> >>>> On Tue, Jun 19, 2018 at 02:27:29PM +0200, swadmin - levigo.de wrote:
> >>>>> Hi @all
> >>>>> I have a problem with mounting a large XFS filesystem which takes about
> >>>>> 8-10 minutes.
> >>>>>
> >>>>>
> >>>>>
> >>>>> :~# df -h /graylog_data
> >>>>> Filesystem                       Size  Used Avail Use% Mounted on
> >>>>> /dev/mapper/vgdata-graylog_data   11T  5.0T  5.1T  50% /graylog_data
> >>>>>
> >>>>> ----
> >>>>>
> >>>>> :~# xfs_info /dev/mapper/vgdata-graylog_data
> >>>>> meta-data=/dev/mapper/vgdata-graylog_data isize=512    agcount=40805,
> >>>>> agsize=65792 blks
> >>>>
> >>>> 41,000 AGs is a lot of metadata to load.  Did someone growfs a 1G fs
> >>>> into a 11T fs?
> >>>
> >>> <answer: yes, they did>
> >>>
> >>> Let me state that a little more clearly: this is a badly mis-administered
> >>> filesystem; 40805 x 256MB AGs is nearly unusable, as you've seen.
> >>>
> >>> If at all possible I would start over with a rationally-created filesystem
> >>> and migrate the data.
> >>
> >> Considering *a lot* of folks may typically follow the above "trap", wouldn't it
> >> be wise for userspace to complain or warn when the user may want to do
> >> something stupid like this? Otherwise I cannot see how we could possibly
> >> conceive that this is badly administered filesystem.
> >
> > Fair point, though I'm not sure where such a warning would go.  growfs?
> > I'm not a big fan of the "you asked for something unusual, continue [y/N]?"
> > type prompts.
> >
> > To people who know how xfs is laid out it's "obvious" but it's not fair to
> > assume every admin knows this, you're right.  So calling it mis-administered
> > was a bit harsh.
> >
> 
> The extreme case is interesting to me, but even more interesting are
> the intermediate cases. Is it straightforward to establish a hard and
> fast threshold? i.e. do not growfs more than 1000% from original size?
> Do not growfs more than X times?

Rule of thumb we've stated every time it's been asked in the past
10-15 years is "try not to grow by more than 10x the original size".

Too many allocation groups for a given storage size is bad in many
ways:

	- on spinning rust, more than 2 AGs per spindle decreases
	  general performance
	- small AGs don't hold large contiguous free spaces, leading
	  to increased file and freespace fragmentation (both almost
	  always end up being bad)
	- CPU efficiency of AG serach loops (e.g. finding free
	  space) goes way down, especially as the filesystem fills
	  up

The mkfs ratios are about as optimal as we can get for the
information we have about the storage - growing by
10x (i.e.  increaseing the number of AGs by 10x) puts us at the
outside edge of the acceptible filesystem performance and longevity
charcteristics. Growing by 100x puts us way outside the window,
and examples like this where we are taking about growing by 10000x
is just way beyond anything the static AG layout architecture was
ever intended to support....

Yes, the filesystem will still work, but unexpected delays and
non-deterministic behaviour will occur when algorithms have to
iterate all the AGs for some reason....

> Or is it a linear relationship between performance loss and each
> additional growfs?

The number of growfs operations is irrelevant - it is the
the AGs:capacity ratio that matters here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
