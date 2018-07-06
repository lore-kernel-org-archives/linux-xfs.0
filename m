Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:44953 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753451AbeGFBIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 21:08:55 -0400
Date: Fri, 6 Jul 2018 11:08:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/21] xfs: repair the rmapbt
Message-ID: <20180706010841.GS2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986827881.3155.10096839660329617215.stgit@magnolia>
 <20180703053200.GH2234@dastard>
 <20180703235901.GY32415@magnolia>
 <20180704232115.GP2234@dastard>
 <20180705034858.GH32415@magnolia>
 <20180705070324.GQ2234@dastard>
 <20180706004637.GI32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180706004637.GI32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 05, 2018 at 05:47:48PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 05, 2018 at 05:03:24PM +1000, Dave Chinner wrote:
> > IOWs, ISTM that the online scrub/repair algorithms break down in the
> > face of rmap corruption and it is correctable only by building a
> > global cross-reference which we can then reconcile and use to
> > rebuild all the per-AG metadata btrees in the filesystem. Trying to
> > do it online via scanning of unverifiable structures risks making
> > the problem worse and there is a good possibility that we can't
> > repair the inconsistencies in a single pass.
> 
> Yeah.  I've pondered whether or not the primary repairers ought to
> require at least a quick rmap scan before they touch anything, but up
> till now I've preferred to keep that knowledge in xfs_scrub.

I think that's fine - scrub is most likely going to be the trigger
to run online repair, anyway.

> > So at this point, I'd prefer that we stop, discuss and work out a
> > solution to the rmap rebuild problem rather than merge a rmap
> > rebuild algorithm prematurely. This doesn't need to hold up any of
> > the other online repair functionality - none of that is dependent on
> > this particular piece of the puzzle being implemented.
> 
> I didn't think it would hold up the others repairers.  I always knew
> that the rmapbt repair was going to be a tough project. :)
> 
> So, seeing as you're about to head off on vacation, let's set a rough
> time to discuss the rmap rebuild problem in detail once you're back.
> Does that sound good?

Yes. Gives us some thinking time, too :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
