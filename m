Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:49126 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751033AbcK1EBw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2016 23:01:52 -0500
Date: Mon, 28 Nov 2016 15:01:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] clean up speculative preallocation tracking and
 tagging
Message-ID: <20161128040106.GY28177@dastard>
References: <1479819662-64416-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479819662-64416-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 22, 2016 at 08:00:59AM -0500, Brian Foster wrote:
> Hi all,
> 
> These are a few patches that resulted from the following discussion with
> regard to how to tag reflink inodes correctly for COW fork
> preallocation:
> 
>   http://www.spinics.net/lists/linux-xfs/msg02155.html
> 
> The problem with the current code is that xfs_reflink_reserve_cow()
> doesn't consider preallocation due to start offset alignment. The
> problem with the first pass patch above is that the same function
> doesn't distinguish between extent preallocation and extent merge.
> 
> The solution in this series pushes down the incorporation of
> preallocation to the bmapi call, where it already has the additional
> context to identify whether an extent allocation was widened due to
> cowextszhint alignment. The callers are still responsible for defining
> how much to preallocate, to throttle, retry if necessary, etc.
> 
> Note that this series is based on top of Christoph's recent extent
> lookup cleanup patches. This survives xfstests for me on a reflink=1 fs.
> Thoughts, reviews, flames appreciated.

All in all looks like a nice little cleanup. Tests out just fine
here, too, so consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
