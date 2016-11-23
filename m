Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6625 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755798AbcKWE0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 23:26:36 -0500
Date: Wed, 23 Nov 2016 15:26:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161123042632.GQ31101@dastard>
References: <cover.1479427384.git.osandov@fb.com>
 <20161123020210.GW21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161123020210.GW21290@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com

On Tue, Nov 22, 2016 at 09:02:10PM -0500, Zygo Blaxell wrote:
> On Thu, Nov 17, 2016 at 04:07:48PM -0800, Omar Sandoval wrote:
> > 3. Both XFS and Btrfs cap each dedupe operation to 16MB, but the
> >    implicit EOF gets around this in the existing XFS implementation. I
> >    copied this for the Btrfs implementation.
> 
> Somewhat tangential to this patch, but on the dedup topic:  Can we raise
> or drop that 16MB limit?
> 
> The maximum btrfs extent length is 128MB.  Currently the btrfs dedup
> behavior for a 128MB extent is to generate 8x16MB shared extent references
> with different extent offsets to a single 128MB physical extent.
> These references no longer look like the original 128MB extent to a
> userspace dedup tool.  That raises the difficulty level substantially
> for a userspace dedup tool when it tries to figure out which extents to
> keep and which to discard or rewrite.

That, IMO, is a btrfs design/implementation problem, not a problem
with the API. Applications are always going to end up doing things
that aren't perfectly aligned to extent boundaries or sizes
regardless of the size limit that is placed on the dedupe ranges.

> XFS may not have this problem--I haven't checked.

It doesn't - it tracks shared blocks exactly and merges adjacent
extent records whenever possible.

> Even if we want to keep the 16MB limit, there's also no way to query the
> kernel from userspace to find out what the limit is, other than by trial
> and error.  It's not even in a header file, userspace just has to *know*.

So add a define to the API to make it visible to applications and
document it in the man page.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
