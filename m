Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 17:22:28 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAD1MKsZ004014
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 17:22:21 -0800
Received: from remx.pixar.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCD741551FDC
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 17:22:19 -0800 (PST)
Received: from remx.pixar.com (remx.pixar.com [199.108.77.22]) by cuda.sgi.com with ESMTP id 0q24A9AtAPokxx27 for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 17:22:19 -0800 (PST)
Date: Wed, 12 Nov 2008 17:20:45 -0800
From: Lars Damerow <lars@pixar.com>
Subject: Re: last xfs_repair time?
Message-ID: <20081113012045.GL18990@pixar.com>
References: <20081112224109.GC18990@pixar.com> <491B6F4C.6030506@sgi.com> <491B7EB9.1050207@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491B7EB9.1050207@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

>From Eric Sandeen <sandeen@sandeen.net>, Wed, Nov 12, 2008 at 07:11:21PM -0600:
> Timothy Shimmin wrote:
> > Lars Damerow wrote:
> >> Hi folks,
> >>
> >> Is it possible to query XFS for the last time xfs_repair fixed a
> >> filesystem? I've been searching the man pages and haven't found anything
> >> useful.
> >>
> > Not that I know of.
> > Barry is the repair maintainer/expert though.
> > 
> > --Tim
> > 
> > 
> AFAIK it doesn't, but that'd be a neat feature - adding space for that,
> and maybe date of mkfs (or mkfs version) etc might be nice too.

Thanks for the responses! It's handy to have that information
available, especially when you're maintaining hundreds of workstations
whose power cables occasionally get yanked out by their users. :/

Here's what we can get from ext3:

    % sudo dumpe2fs -h /dev/sda1 | grep 2008
    dumpe2fs 1.40.8 (13-Mar-2008)
    Inodes per group:         2008
    Filesystem created:       Thu May 29 11:11:12 2008
    Last mount time:          Tue Sep 30 18:01:18 2008
    Last write time:          Tue Sep 30 18:01:18 2008
    Last checked:             Thu May 29 11:11:12 2008

cheers,
-lars

--
lars r. damerow :: button pusher :: pixar animation studios
<lars@pixar.com>
