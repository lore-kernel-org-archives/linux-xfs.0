Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2867 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751505AbdGRXMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 19:12:06 -0400
Date: Wed, 19 Jul 2017 09:12:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: fix buffer check for primary sb in userspace
 libxfs
Message-ID: <20170718231202.GP17762@dastard>
References: <20170718141337.46255-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170718141337.46255-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2017 at 10:13:37AM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This patch is actually targeted at userspace. The previous change in commit
> f3d7ebde ("xfs: fix superblock inprogress check") to use ->b_maps technically
> breaks the logic in userspace in a similar way to the original problem because
> userspace has no concept of uncached buffers.  ->b_maps is NULL in userspace
> unless the buffer is truly discontiguous.
> 
> This would normally result in a segfault but this appears to be hidden
> by gcc optimization as -O2 is enabled by default and the
> check_inprogress param to xfs_mount_validate_sb() is unused in
> userspace. Therefore, the segfault is only reproducible when
> optimization is disabled (which is a useful configuration for
> debugging).
> 
> There are obviously different ways to fix this. I'm floating this (untested)
> rfc as a kernel patch (do we ever sync libxfs from xfsprogs -> kernel?) with
> the objective of keeping the libxfs code the same between the kernel and
> userspace. We could alternatively create a custom helper/macro with the
> appropriate check in each place. Thoughts?

Wouldn't it be better to simply fix the userspace buffer
initialisation to always have a valid bp->b_maps, just like the
kernel does? (See xfs_buf_get_maps() in the kernel code).  That way
we don't have a landmine lurking in all the shared libxfs code we
bring from the kernel that may interact with uncached buffers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
