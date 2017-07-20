Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40007 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935827AbdGTW6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 18:58:01 -0400
Date: Fri, 21 Jul 2017 08:57:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: init ->b_maps on contig buffers for uncached
 compatibility
Message-ID: <20170720225758.GX17762@dastard>
References: <20170720150612.37494-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720150612.37494-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 11:06:12AM -0400, Brian Foster wrote:
> There is a bit of an inconsistency in how ->b_maps is used for
> contiguous buffers between kernel libxfs and xfsprogs due to the
> independent buffer implementations. In the kernel, ->b_maps[0] is
> always intialized to a valid range and in xfsprogs, ->b_maps is only
> allocated for discontiguous buffers.
> 
> This can lead to confusion when dealing with uncached kernel buffers
> in common libxfs code because xfsprogs has no concept of uncached
> buffers. Kernel uncached buffers have ->b_bn == XFS_BUF_DADDR_NULL
> and ->b_maps[0] points to the physical block address. Block address
> checks in common code for kernel uncached buffers, such as in
> xfs_sb_verify(), therefore would need to check both places for an
> address or risk broken logic or userspace segfaults.
> 
> This problem currently manifests as an xfs_repair segfault due to a
> NULL ->b_maps access in xfs_sb_verify(). Note that this problem is
> only reproducible on builds with (-O2) optimization disabled, as the
> affected parameter is currently unused and thus optimization
> eliminates the problematic access.
> 
> To fix this problem and eliminate the incompatibility, update the
> userspace xfs_buf with an internal ->__b_map field and point
> ->b_maps to it for contiguous buffers, similar to the kernel buffer
> implementation. Set valid values in ->b_maps0] for contiguous

->b_maps[0]

> buffers so common code will continue to work regardless of whether a
> buffer is uncached in the kernel.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks right but I haven't compiled/tested it so:

Acked-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
