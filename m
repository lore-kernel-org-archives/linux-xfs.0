Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:51264 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbeJUWtU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Oct 2018 18:49:20 -0400
Date: Mon, 22 Oct 2018 01:34:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181021143443.GP6311@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <5516031c-6c4f-072f-e9f9-9f0ecee9927d@scylladb.com>
 <20181019012423.GK6311@dastard>
 <0fcfc274-fbb1-5a3e-6335-6993d616df97@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fcfc274-fbb1-5a3e-6335-6993d616df97@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 21, 2018 at 12:00:16PM +0300, Avi Kivity wrote:
> 
> On 19/10/2018 04.24, Dave Chinner wrote:
> >On Thu, Oct 18, 2018 at 06:44:54PM +0300, Avi Kivity wrote:
> >>On 18/10/2018 14.00, Avi Kivity wrote:
> >>>
> >>>This can happen, and indeed I see our default hint is 1MB, so our
> >>>small files use a 1MB hint. Looks like we should remove that 1MB
> >>>hint since it's reducing allocation flexibility for XFS without a
> >>>good return.
> >>
> >>I convinced myself that this is the root cause, it fits perfectly
> >>with your explanation. I still think that XFS should allocate
> >>*something* rather than ENOSPC, but I can also understand someone
> >>wanting a guarantee.
> >Yup, it's a classic catch 22.
> >
> >>>On the other hand, I worry that because we bypass the page cache,
> >>>XFS doesn't get to see the entire file at one time and so it will
> >>>get fragmented.
> >>
> >>That's what happens. I write 1000 4k writes to 400 files, in
> >>parallel, AIO+DIO. I got 400 perfectly-fragmented files, each had
> >>1000 extents.
> >Yup, you wrote them all in the one directory, didn't you? :)
> 
> 
> Yes :(
> 
> But if I have more concurrently-written files than AGs, I'd get the
> same behavior with multiple directories, no?

Up to a point. At which point, I'd say you're doing it wrong and
tell you to use extent size hints or buffered IO so the filesystem
can turn the small random writes in nicely formed large IOs via
delayed allocation. :)

Remember the first rule of storage: Garbage In, Garbage Out.

With direct IO, it's the responsibility of the application to give
the fileystem and storage layers well formed IOs. If the app doesn't
play nice, there's nothing the filesystem or storage layers can do
to make it better....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
