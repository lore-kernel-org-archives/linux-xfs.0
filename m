Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:39976 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967646AbdIZDy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 23:54:56 -0400
Date: Tue, 26 Sep 2017 13:51:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: shared/298 lockdep splat?
Message-ID: <20170926035149.GO10955@dastard>
References: <20170920211042.GH7112@magnolia>
 <20170920222256.GR18948@dastard>
 <20170921084714.GI5994@X58A-UD3R>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921084714.GI5994@X58A-UD3R>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, kernel-team@lge.com

On Thu, Sep 21, 2017 at 05:47:14PM +0900, Byungchul Park wrote:
> On Thu, Sep 21, 2017 at 08:22:56AM +1000, Dave Chinner wrote:
> > Peter, this is the sort of false positive I mentioned were likely to
> > occur without some serious work to annotate the IO stack to prevent
> > them.  We can nest multiple layers of IO completions and locking in
> > the IO stack via things like loop and RAID devices.  They can be
> > nested to arbitrary depths, too (e.g. loop on fs on loop on fs on
> > dm-raid on n * (loop on fs) on bdev) so this new completion lockdep
> > checking is going to be a source of false positives until there is
> > an effective (and simple!) way of providing context based completion
> > annotations to avoid them...
> 
> Hello,
> 
> It looks caused by that &ret.event in submit_bio_wait() is initialized
> with the same class for all layers. I mean that completion variables in
> different layers should be initialized with different classes, as you do
> for typical locks in xfs.

Except that submit_bio_wait() is generic block layer functionality
and can be used by anyone. Whatever solution you decide on, it has
to be generic. And keep in mind that any code that submits a bio
themselves and waits on a completion event from the bio is going to
have to do their own annotations, which makes this a real PITA.

> I am not sure if I understand how xfs works correctly. Right? If yes,
> how can we distinguish between independent 'bio's in submit_bio_wait()?
> You or I can make it work with the answer. No?

Has nothing to do with XFS - it has no clue where it sits in the
block device stack and has no business screwing with bio internals
and stack layering to handle issues with stacked block devices....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
