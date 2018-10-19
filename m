Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10151 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbeJSJ2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Oct 2018 05:28:11 -0400
Date: Fri, 19 Oct 2018 12:24:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181019012423.GK6311@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <5516031c-6c4f-072f-e9f9-9f0ecee9927d@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5516031c-6c4f-072f-e9f9-9f0ecee9927d@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 18, 2018 at 06:44:54PM +0300, Avi Kivity wrote:
> 
> On 18/10/2018 14.00, Avi Kivity wrote:
> >
> >
> >This can happen, and indeed I see our default hint is 1MB, so our
> >small files use a 1MB hint. Looks like we should remove that 1MB
> >hint since it's reducing allocation flexibility for XFS without a
> >good return.
> 
> 
> I convinced myself that this is the root cause, it fits perfectly
> with your explanation. I still think that XFS should allocate
> *something* rather than ENOSPC, but I can also understand someone
> wanting a guarantee.

Yup, it's a classic catch 22.

> >On the other hand, I worry that because we bypass the page cache,
> >XFS doesn't get to see the entire file at one time and so it will
> >get fragmented.
> 
> 
> That's what happens. I write 1000 4k writes to 400 files, in
> parallel, AIO+DIO. I got 400 perfectly-fragmented files, each had
> 1000 extents.

Yup, you wrote them all in the one directory, didn't you? :)

> So I'll remove the default hint for small files, and replace it with
> larger buffer sizes so we batch more and don't get 8k-sized extents
> (which is our default buffer size).

Or you could just mount with the "noalign" mount option to turn off
stripe alignment. After all, you don't need stripe alignment for a
single spindle....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
