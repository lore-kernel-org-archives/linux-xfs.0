Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:24363 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753250AbdHDXRs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2017 19:17:48 -0400
Date: Sat, 5 Aug 2017 09:17:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Stop searching for free slots in an inode chunk when
 there are none
Message-ID: <20170804231744.GE21024@dastard>
References: <20170803151915.7861-1-cmaiolino@redhat.com>
 <20170803223538.GB21024@dastard>
 <1977631726.66215858.1501836926842.JavaMail.zimbra@redhat.com>
 <42743373.66226189.1501839361497.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42743373.66226189.1501839361497.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Eduardo Maiolino <cmaiolin@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 04, 2017 at 05:36:01AM -0400, Carlos Eduardo Maiolino wrote:
> One more thing.
> 
> 
> 
> ----- Original Message -----
> > From: "Carlos Eduardo Maiolino" <cmaiolin@redhat.com>
> > To: "Dave Chinner" <david@fromorbit.com>
> > Cc: linux-xfs@vger.kernel.org
> > Sent: Friday, August 4, 2017 10:55:26 AM
> > Subject: Re: [PATCH] Stop searching for free slots in an inode chunk when there are none
> > 
> > Hi Dave.
> > 
> > 
> > > > Add a way to stop the loop when a free slot is not found in the btree,
> > > > making the function to fall into the whole AG scan which will then, be
> > > > able to detect the corruption and shut the filesystem down.
> > > 
> > > That doesn't sound quite right. The initial scan and the restart
> > > loop are both limited to scanning search_distance records - we never
> > > search the entire tree except when it's really small (i..e less than
> > > 10-20 records (640-1280 inodes) depending on balance). If the
> > > pagino record to end of btree distance in both directions is shorter
> > > than the search distance for a given loop (i.e. less than 10 records
> > > from pagino to end-of-btree) then that is the only time a corrupted
> > > agi->freecount can cause this problem.
> > > 
> > 
> > I agree with you, but still, we are feasible to have this corruption
> > happening,
> > and I've seen reports of users hitting it.
> > 
> > 
> > > IOWs, on production systems where there's more than a few hundred
> > > inodes (i.e. the vast majority of installations) a corrupted
> > > agi->freecount won't lead to a endless loop because search_distance
> > > will terminate the retry loop and we'll allocate a new inode.
> > > 
> > > To tell the truth, I'd much rather we just use the search distance
> > > to prevent endless looping than add a second method of limiting
> > > the search loop. i.e. don't reset search_distance when we restart
> > > the search loop at pagino.  That means even for small trees (<
> > > search_distance * 2 records) we'll retry when we get to the end of
> > > tree, but we'll still break out of the loop and allocate new inodes
> > > as soon as we hit the search distance limit.
> > > 
> > 
> 
> Here, you are assuming we enter into the 
> 
> while (!doneleft || !doneright) { }
> 
> on every interaction, so it will be able to decrease the searchdistance or you
> mean by moving the --searchdistance somewhere else?
> 
> In very small trees we don't even enter the while loop (both doneleft and doneright are 1),
> so searchdistance isn't decremented at all, resetting it or not will not make any difference
> in this case.

Seems like a minor issue - the first search step left+right is
outside the while loop, and we don't account for that. So change
where the search distance check to take that into account:

	while (--searchdistance > 0 && (!doneleft || !doneright)) {
		.....
	}

	if (searchdistance <= 0) {
		/* save current chunk indexes */
		....
		goto newino;
	}

	/* restart at pagino */
	.....
	goto restart_pagno;


-Dave.
-- 
Dave Chinner
david@fromorbit.com
