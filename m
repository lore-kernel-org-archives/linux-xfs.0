Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61932 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751094AbeBHVLr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Feb 2018 16:11:47 -0500
Date: Fri, 9 Feb 2018 08:11:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS over device mapper dm-thin device
Message-ID: <20180208211144.GD20266@dastard>
References: <147a1764-1988-4efd-4f02-e942a1001b4e@redhat.com>
 <20180202223541.i27bfjij7itt3q5r@destitution>
 <9c3ec8ff-3595-c889-3abe-7f069292be0d@sandeen.net>
 <20180205223604.wgacfnsrsaqrwz7n@destitution>
 <7ed418fa-fa47-1e67-5de8-87d5ba74fbbc@sandeen.net>
 <20180206061100.yqbc55besdmttkzd@destitution>
 <89d31e43-a0f7-95f1-080d-1f3bf3d81add@sandeen.net>
 <20180208055340.GH5433@magnolia>
 <20180208082526.GC20266@dastard>
 <744222fe-7774-5086-20b7-48b8326cad99@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744222fe-7774-5086-20b7-48b8326cad99@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Todd Gill <tgill@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Feb 08, 2018 at 08:31:21AM -0600, Eric Sandeen wrote:
> 
> 
> On 2/8/18 2:25 AM, Dave Chinner wrote:
> > On Wed, Feb 07, 2018 at 09:53:40PM -0800, Darrick J. Wong wrote:
> >> On Wed, Feb 07, 2018 at 08:35:12PM -0600, Eric Sandeen wrote:
> >>>
> >>>
> >>> On 2/6/18 12:11 AM, Dave Chinner wrote:
> >>>> On Mon, Feb 05, 2018 at 04:37:22PM -0600, Eric Sandeen wrote:
> >>>>>
> >>>>>
> >>>>> On 2/5/18 4:36 PM, Dave Chinner wrote:
> >>>>>>> In retrospect I think we (I) should have left the "metadata" uuid as
> >>>>>>> the one to match the log, not the user-facing one.
> >>>>>> I suspect we can just change the log recovery code to accept either
> >>>>>> sb_uuid or sb_metauuid if the metauuid feature bit is set and
> >>>>>> change xfs_db to not rewrite the log when metauuid is used....
> >>>>>>
> >>>>>> Cheers,
> >>>>>
> >>>>> That was my first thought, but then newer userspace UUID changes
> >>>>> won't be mountable on older kernels.   I don't think we can just
> >>>>> change it w/o some thought re: compatibility...
> >>>>
> >>>> So maybe we should use a log incompat bit and provide an alternative
> >>>> command for the old way of changing the UUID in the log?
> >>>
> >>> Sure, if we're happy burning an incompat bit for this, sounds good.
> >>
> >> Or a log incompat bit?
> > 
> > That's what I suggested :P
> 
> And that's what I /meant/, sorry for the lack of specificity ;)

So we are all happy to burn a log incompat bit for this? 

/me wonders how many one liners we can string this out into :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
